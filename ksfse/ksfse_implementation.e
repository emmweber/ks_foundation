/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : ksfse_implementation.e
 *
 * Authors  : Stefan Skare, Enrico Avventi, Henric Rydén, Ola Norbeck
 * Date     : 2019-Feb-15
 * Version  : 2.2
 *******************************************************************************************************
 * This code is shared under a specific licence agreement available on GE's collaboration portal, which
 * regulates the use of this software and states specifically that neither Karolinska University nor GE
 * Healthcare can be hold liable for anything related to the use of this software. Please consult this
 * legal document for details on collaborate.mr.gehealthcare.com. As with any other EPIC psd software,
 * compiled by an EPIC licenced user, it is to be used for research purposes only.
 *
 * The Neuro MR physics group at Karolinska University hospital encourages further modifications of, and
 * additions to, the provided PSDs and PSD modules. It is our hope that the KSFoundation library and
 * can provide a common base on top of which research users can share PSDs and PSD modules with each
 * other by e.g. adding branches or forks to the KSFoundation repository:
 * https://gitlab.com/neuromr_karolinska/psd_ksfoundation
 *******************************************************************************************************/

/**
********************************************************************************************************
* @file ksfse_implementation.e
* @brief This file contains the implementation details for the *ksfse* psd
********************************************************************************************************/




@global

#define KSFSE_MINHNOVER 6
#define KSFSE_MIN_SSI_TIME 200
#define KSFSE_MAXTHICKFACT 3.0

enum {KSFSE_RECOVERY_OFF, KSFSE_RECOVERY_T1WOPT, KSFSE_RECOVERY_FAST};

#ifndef GEREQUIRED_E
#error GERequired.e must be inlined before ksfse_implementation.e
#endif

/** @brief #### `typedef struct` holding all all gradients and waveforms for the ksfse sequence
*/
typedef struct KSFSE_SEQUENCE {
  KS_SEQ_CONTROL seqctrl; /**< Control object keeping track of the sequence and its components */
  KS_READTRAP read; /**< Readout trapezoid including data acquisition window */
  KS_TRAP readdephaser; /**< Static dephaser for readout trapezoid */
  KS_PHASER phaseenc; /**< Phase encoding (YGRAD). 2D & 3D */
  KS_PHASER zphaseenc; /**< 3D: Second phase encoding (ZGRAD) */
  KS_TRAP spoiler; /**< Gradient spoiler after FSE train */
  KS_SELRF selrfexc; /**< Excitation RF pulse with slice select and rephasing gradient */
  KS_SELRF selrfref1st; /**< First refocusing RF pulse */
  KS_SELRF selrfref2nd; /**< Second refocusing RF pulse */
  KS_SELRF selrfref; /* 3rd-Nth refocusing RF pulse */
  KS_SELRF selrfrecover; /**< Optional Fast Recovery/T1-optimization refocusing RF pulse */
  KS_SELRF selrfrecoverref; /**< Optional Fast Recovery/T1-optimization tip-up/down (to Mz) RF pulse */
  KS_PHASEENCODING_PLAN phaseenc_plan; /**<  Phase encoding plan, for 2D and 3D use */
} KSFSE_SEQUENCE;
#define KSFSE_INIT_SEQUENCE {KS_INIT_SEQ_CONTROL, KS_INIT_READTRAP, KS_INIT_TRAP, KS_INIT_PHASER, KS_INIT_PHASER, KS_INIT_TRAP, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_PHASEENCODING_PLAN};



@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/*****************************************************************************************************
* RF Excitation
*****************************************************************************************************/
float ksfse_excthickness = 0;
float ksfse_gscalerfexc = 0.9; /* default gradient scaling for slice thickness */
float ksfse_flipexc = 90.0 with {0.0, 180.0, 90.0, VIS, "Excitation flip angle [deg]",};
float ksfse_spoilerarea = 2000.0 with {0.0, 20000.0, 5000.0, VIS, "ksfse spoiler gradient area",};
float rf_stretch_rfexc = 1.0 with {0.01, 100.0, 1.0, VIS, "Stretch RF excitation pulse if > 1.0",};
int ksfse_inflowsuppression = 0 with {0, 1, 0, VIS, "In-flow Suppression [0:OFF, 1:ON]",};
float ksfse_inflowsuppression_mm = 0.0 with {0.0, 100.0, 0.0, VIS, "In-flow suppression [mm]",};
int ksfse_vfa = 1.0 with {0.0, 1.0, 1.0, VIS, "Variable flip angles [0:OFF, 1:ON]",};

/*****************************************************************************************************
* RF Refocusing
*****************************************************************************************************/
float ksfse_crusherscale = 0.5 with {0.0, 20.0, 0.5, VIS, "scaling of crusher gradient area",};
float ksfse_gscalerfref = 0.9; /* default gradient scaling for slice thickness */
int ksfse_slicecheck = 0 with {0.0, 1.0, 0.0, VIS, "move readout to z axis for slice thickness test",};
float rf_stretch_rfref = 1.0 with {0.01, 100.0, 1.0, VIS, "Stretch RF refocusing pulses if > 1.0",};
float rf_stretch_all = 1.0 with {0.01, 100.0, 1.0, VIS, "Stretch all RF pulses if > 1.0",};

/*****************************************************************************************************
* Post-ETL forced recovery: T1-w Optimization / T2 fast recover
*****************************************************************************************************/
int ksfse_recovery = KSFSE_RECOVERY_OFF with {KSFSE_RECOVERY_OFF, KSFSE_RECOVERY_FAST, KSFSE_RECOVERY_OFF, VIS, "Recovery. 0:off 1:T1wopt 2:T2fast", };
float rf_stretch_rfrecovery = 1.0 with {0.01, 100.0, 1.0, VIS, "Stretch RF recovery pulses if > 1.0",};

/*****************************************************************************************************
* Readout(s)
*****************************************************************************************************/
int ksfse_kxnover_min = KSFSE_MINHNOVER with {KSFSE_MINHNOVER, 512, KSFSE_MINHNOVER, VIS, "Min mum kx overscans for minTE",};
int ksfse_kxnover = 32 with {KSFSE_MINHNOVER, 512, 32, VIS, "Num kx overscans for minTE",};
int ksfse_rampsampling = 0 with {0, 1, 0, VIS, "Rampsampling [0:OFF 1:ON]",};
int ksfse_extragap = 0 with {0, 100ms, 0, VIS, "extra gap between readout [us]",};
int ksfse_etlte = 1 with {0, 1, 1, VIS, "ETL controls TE",};
int ksfse_xcrusherarea = 100.0 with {0.0, 100.0, 0.0, VIS, "x crusher area for readout",};
int ksfse_esp = 0 with {0, 1000000, 0, VIS, "View-only: Echo spacing in [us]",};

/*****************************************************************************************************
* Phase encoding
*****************************************************************************************************/
int ksfse_noph = 0 with {0, 1, 0, VIS, "Turn OFF phase encoding [0:Disabled 1:Enabled]",};
int ksfse_minacslines  = 12 with {0, 512, 12, VIS, "Minimum ACS lines for ARC",};
int ksfse_minzacslines = 12 with {0, 512, 12, VIS, "Minimum z ACS lines for ARC",};

/*****************************************************************************************************
* Sequence general
*****************************************************************************************************/
int ksfse_pos_start = KS_RFSSP_PRETIME with {0, , KS_RFSSP_PRETIME, VIS, "us from start until the first waveform begins",};
int ksfse_ssi_time = KSFSE_MIN_SSI_TIME with {50, , KSFSE_MIN_SSI_TIME, VIS, "time from eos to ssi in intern trig",};
int ksfse_dda = 2 with {0, 200, 2, VIS, "Number of dummy scans for steady state",};
int ksfse_debug = 1 with {0, 100, 1, VIS, "Write out e.g. plot files (unless scan on HW)",};
int ksfse_imsize = KS_IMSIZE_MIN256 with {KS_IMSIZE_NATIVE, KS_IMSIZE_MIN256, KS_IMSIZE_MIN256, VIS, "img. upsamp. [0:native 1:pow2 2:min256]"};
int ksfse_abort_on_kserror = FALSE with {0, 1, 0, VIS, "Hard program abort on ks_error [0:OFF 1:ON]",};
int ksfse_mintr = 0 with {0, 20s, 0, VIS, "Min TR (ms) [0: Disabled]",};
int ksfse_maxtr = 0 with {0, 40s, 0, VIS, "Max TR (ms) [0: Disabled]",};

/*****************************************************************************************************
* Temporary CVs for testing
*****************************************************************************************************/


@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/* the KSFSE Sequence object */
KSFSE_SEQUENCE ksfse = KSFSE_INIT_SEQUENCE;


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: Host functions
 *
 *******************************************************************************************************
 *******************************************************************************************************/

abstract("FSE [KSFoundation]");
psdname("ksfse");

/* function prototypes */
void ksfse_eval_TEmenu(int esp, int maxte, int etl, double optechono);
STATUS ksfse_calc_echo(double *bestecho, double *optecho, KS_PHASER *pe, int TE, int etl, int esp);
STATUS ksfse_pg(int);
int ksfse_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, int shot, int exc);
int ksfse_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args);
int ksfse_scan_sliceloop(int slperpass, int passindx, int shot, int exc);
int ksfse_scan_sliceloop_nargs(int slperpass, int nargs, void **args);
float ksfse_scan_acqloop(int); /* float since scan clock will be 0:00 if scan time > 38 mins otherwise */
float ksfse_scan_scanloop();
STATUS ksfse_scan_seqstate(SCAN_INFO slice_info, int shot);

#include "epic_iopt_util.h"
#include <psdiopt.h>



/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: CVINIT
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/*******************************************************************************************************
  MultiPhase imaging option button:
  N.B: There are two types of multi-phase modes that are mutually exlusive, mapping to one and same UI
       button option (MultiPhase):
  Mode 1 (PSD_IOPT_MPH): opmph = 1 & opfphases > 1. Use opfphases-for-loop in scan for multiple volumes
  Mode 2 (PSD_IOPT_DYNPL): opdynaplan = 1 & opfphases = 1. The HOST is running the PSD multiple times
         and no modifications or for-loop in the PSD

  PSD_IOPT_DYNPL mode is used for this PSD (ksfse)
********************************************************************************************************/
int sequence_iopts[] = {
  PSD_IOPT_ARC, /* oparc */
  PSD_IOPT_ASSET, /* opasset (SENSE) */
  PSD_IOPT_EDR, /* opptsize */
  PSD_IOPT_DYNPL, /* opdynaplan */
  PSD_IOPT_TLRD_RF, /* optlrdrf */
  PSD_IOPT_MILDNOTE, /* opsilent */
  PSD_IOPT_ZIP_512, /* opzip512 */
#if EPIC_RELEASE >= 26
  PSD_IOPT_FR, /* opfr */
  PSD_IOPT_T1FLAIR, /* opt1flair */
  PSD_IOPT_T2FLAIR, /* opt2flair */
  PSD_IOPT_IR_PREP, /* opirprep */
#endif
#ifdef UNDEF
  PSD_IOPT_SEQUENTIAL, /* opirmode */
  PSD_IOPT_ZIP_1024, /* opzip1024 */
  PSD_IOPT_SLZIP_X2, /* opzip2 */
  PSD_IOPT_MPH, /* opmph */
  PSD_IOPT_NAV, /* opnav */
  PSD_IOPT_FLOW_COMP, /* opfcomp */
#endif
};




/**
 *******************************************************************************************************
 @brief #### Initial handling of imaging options buttons and top-level CVs at the PSD type-in pages
 @return void
********************************************************************************************************/
void ksfse_init_imagingoptions(void) {
  int numopts = sizeof(sequence_iopts) / sizeof(int);

  psd_init_iopt_activity();
  activate_iopt_list(numopts, sequence_iopts);
  enable_iopt_list(numopts, sequence_iopts);

  /* Imaging option control functions (using PSD_IOPT_ZIP_512 as example):
    - Make an option unchecked and not selectable: disable_ioption(PSD_IOPT_ZIP_512)
    - Make an option checked and not selectable:   set_required_disabled_option(PSD_IOPT_ZIP_512)
    - Remove the imaging option:                   deactivate_ioption(PSD_IOPT_ZIP_512)
  */

  cvmax(opimode, PSD_3DM);

  /* Button accept control */
  cvmax(opepi, PSD_OFF); /* don't allow EPI selection */
  cvmax(opfast, PSD_ON);
  cvmax(opssfse, PSD_ON);
  cvmax(opflair, OPFLAIR_INTERLEAVED);
  cvmax(optlrdrf, PSD_ON);
  cvmax(opfr, PSD_ON);

  if (KS_3D_SELECTED) {
    pidefexcitemode = NON_SELECTIVE;
    piexcitemodenub = 1 + 2 /* + 4 FOCUS */;
    cvmax(opexcitemode, NON_SELECTIVE);

    /* For now, 3D is not compatible with: */
#if EPIC_RELEASE >= 26
    deactivate_ioption(PSD_IOPT_T1FLAIR);
    deactivate_ioption(PSD_IOPT_T2FLAIR);
#endif
    deactivate_ioption(PSD_IOPT_IR_PREP);
    deactivate_ioption(PSD_IOPT_TLRD_RF);
  }

#ifdef SIM
  oppseq = PSD_SE;
  setexist(oppseq, PSD_ON);
  opfast = PSD_ON;
  setexist(opfast, PSD_ON);
  opirmode = PSD_OFF; /* default interleaved slices */
  setexist(opirmode, PSD_ON);
#endif

} /* ksfse_init_imagingoptions() */




/**
 *******************************************************************************************************
 @brief #### Initial setup of user interface (UI) with default values for menus and fields
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_init_UI(void) {

  /* IR always in interleaved mode */
  if (oppseq == PSD_IR) {
    cvoverride(opirmode, PSD_OFF, PSD_FIX_ON, PSD_EXIST_ON);
  }

  acq_type = TYPSPIN; /* loadrheader.e rheaderinit: sets eeff = 1 */

  /* rBW */
  cvmin(oprbw, 2);
  cvmax(oprbw, 250.0);
  pircbnub  = 31; /* number of variable bandwidth */
  if (opssfse == PSD_ON) {
    pidefrbw = 62.50 * (cffield / 30000.0);
  } else {
    pidefrbw = 41.67 * (cffield / 30000.0);
  }
  pircbval2 = 31.25 * (cffield / 30000.0);
  pircbval3 = 41.67 * (cffield / 30000.0);
  pircbval4 = 50.00 * (cffield / 30000.0);
  pircbval5 = 62.50 * (cffield / 30000.0);
  pircbval6 = 83.33 * (cffield / 30000.0);
  cvdef(oprbw, pidefrbw);
  oprbw = _oprbw.defval;
  pircb2nub = 0; /* no second bandwidth option */

  /* NEX */
  pinexnub = 63;
  if (opssfse == PSD_ON) {
    cvdef(opnex, 0.6);
    cvmin(opnex, 0.55);
    cvmax(opnex, 100);
    pinexval2 = 0.55;
    pinexval3 = 0.575;
    pinexval4 = 0.60;
    pinexval5 = 0.625;
    pinexval6 = 0.65;
  } else {
    cvdef(opnex, 1);
    cvmin(opnex, 0.55);
    cvmax(opnex, 100);
    pinexval2 = 0.65;
    pinexval3 = 0.75;
    pinexval4 = 0.85;
    pinexval5 = 1;
    pinexval6 = 2;
  }
  opnex = _opnex.defval;

  /* FOV */
  opfov = 240;
  pifovnub = 4; /* show the first three + type-in */
  pifovval2 = 180;
  pifovval3 = 220;
  pifovval4 = 240;
  pifovval5 = 260;
  pifovval6 = 280;

  /* phase FOV fraction */
  opphasefov = 1;
  piphasfovnub2 = 63;
  piphasfovval2 = 1.0;
  piphasfovval3 = 0.9;
  piphasfovval4 = 0.8;
  piphasfovval5 = 0.7;
  piphasfovval6 = 0.6;

  /* freq (x) resolution */
  cvmin(opxres, 16);
  cvdef(opxres, 64);
  opxres = _opxres.defval;
  pixresnub = 63;
  pixresval2 = 192;
  pixresval3 = 224;
  pixresval4 = 256;
  pixresval5 = 320;
  pixresval6 = 384;

  /* phase (y) resolution */
  cvmin(opyres, 16);
  piyresnub = 63;
  if (opssfse == PSD_ON) {
    piyresval2 = 64;
    piyresval3 = 128;
    piyresval4 = 160;
    piyresval5 = 192;
    piyresval6 = 256;
    cvdef(opyres, 16); /* init low for SSFSE to avoid too long sequence length before proper values have been chosen */
  } else {
    piyresval2 = 192;
    piyresval3 = 224;
    piyresval4 = 256;
    piyresval5 = 320;
    piyresval6 = 384;
    cvdef(opyres, 128);
  }
  opyres = _opyres.defval;

  /* Num echoes */
  piechnub = 0;
  cvdef(opnecho, 1);
  cvmax(opnecho, 1);

  /* ETL */
  avminetl = 1;
  avmaxetl = 256;
  if (opssfse == PSD_ON) {

    if (ksfse.phaseenc.numlinestoacq > 0)
      cvdef(opetl, ksfse.phaseenc.numlinestoacq);
    else
      cvdef(opetl, _opyres.defval);
    opetl = _opetl.defval;
    pietlnub = 0;

  } else {

    if (!KS_3D_SELECTED) {
      /* 2D */

       if (opflair == FALSE) {
        if (optr < 1s) {
          /* T1-w */
          cvdef(opetl, 1);
          opetl = _opetl.defval;
          pietlnub = 63;
          pietlval2 = 1;
          pietlval3 = 2;
          pietlval4 = 3;
          pietlval5 = 4;
          pietlval6 = 8;
        } else {
          /* T2-w */
          cvdef(opetl, 16);
          opetl = _opetl.defval;
          pietlnub = 63;
          pietlval2 = 8;
          pietlval3 = 12;
          pietlval4 = 16;
          pietlval5 = 20;
          pietlval6 = 24;
        }
      } else if (opflair == OPFLAIR_GROUP) { /* T2-FLAIR */
        cvdef(opetl, 24);
        opetl = _opetl.defval;
        pietlnub = 63;
        pietlval2 = 20;
        pietlval3 = 24;
        pietlval4 = 28;
        pietlval5 = 32;
        pietlval6 = 36;
      } else if (opflair == OPFLAIR_INTERLEAVED) { /* T1-FLAIR */
        cvdef(opetl, 8);
        opetl = _opetl.defval;
        pietlnub = 63;
        pietlval2 = 4;
        pietlval3 = 5;
        pietlval4 = 6;
        pietlval5 = 7;
        pietlval6 = 8;
      }

    } else {

      /* 3D */
      cvdef(opetl, 32);
      opetl = _opetl.defval;
      pietlnub = 63;
      pietlval2 = 32;
      pietlval3 = 48;
      pietlval4 = 64;
      pietlval5 = 96;
      pietlval6 = 128;
  }

  } /* non-ssfse ETL menu */


  /* TE */
  pitetype = PSD_LABEL_TE_EFF; /* alt. PSD_LABEL_TE_EFF */
  if (! existcv(opte)) {
    avmaxte = 2s;
    avminte = 0;
    cvmin(opte, avminte);
    cvmax(opte, avmaxte);
    cvdef(opte, 100ms);
    opte = _opte.defval;
    ksfse_eval_TEmenu(10ms /* fake esp */, 200ms /* fake maxte */, opetl, opetl / 2.0);
  }

  /* TE2 */
  pite2nub = 0;

  /* TR */
  cvdef(optr, 5s);
  optr = _optr.defval;
  /*
   If you want values (pitrval) in the dropdown menu, change to pitrnub = 6;. 
   Remember that you can control the minimum and maximum TR-range 
   from the advanced tab using opuser18 & 19. 
  */
  pitrnub = 2;
  pitrval2 = PSD_MINIMUMTR;
  pitrval3 = 500ms;
  pitrval4 = 3000ms;
  pitrval5 = 4000ms;
  pitrval6 = 5000ms;

  /* FA of refocusing pulse */
  cvmax(opflip, 360);
  cvdef(opflip, 125); /* set it low to avoid init errors on sequence selection */
  opflip = _opflip.defval;
#if EPIC_RELEASE >= 24
  pifamode = PSD_FLIP_ANGLE_MODE_REFOCUS;
  pifanub = 5;
  pifaval2 = 110;
  pifaval3 = 125;
  pifaval4 = 140;
  pifaval5 = 160;
#else
  pifanub = 0;
#endif

  /* slice thickness */
  pistnub = 5;
  if (KS_3D_SELECTED) {
    cvdef(opslthick, 1);
    pistval2 = 0.8;
    pistval3 = 0.9;
    pistval4 = 1;
    pistval5 = 1.5;
    pistval5 = 2;
  } else {
    cvdef(opslthick, 4);
    pistval2 = 2;
    pistval3 = 3;
    pistval4 = 4;
    pistval5 = 5;
    pistval6 = 10;
  }
  opslthick = _opslthick.defval;

  /* slice spacing */
  cvdef(opslspace, 0);
  opslspace = _opslspace.defval;
  piisil = PSD_ON;
  if (KS_3D_SELECTED) {
    /* change these to do overlaps */
    piisnub = 0;
    piisval2 = 0;
  } else {
    piisnub = 5;
    piisval2 = 0;
    piisval3 = 0.5;
    piisval4 = 1;
    piisval5 = 2;
    piisval6 = 3;
  }

  /* default # of slices */
  cvdef(opslquant, 30);

  /* 3D slice settings */
  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */
    pimultislab = 0; /* 0: forces only single slab, 1: allow multi-slab (won't work with non-selective refocusing pulses) */
    pilocnub = 4;
    pilocval2 = 28;
    pilocval3 = 60;
    pilocval4 = 124;
    pilocval5 = 252;
    /* opslquant = #slices in slab. opvquant = #slabs */
    cvdef(opslquant, 32);
  }

  opslquant = _opslquant.defval;

  /* Multi phase (i.e. multi volumes) (only active if PSD_IOPT_MPH, not PSD_IOPT_DYNPL) */
  if (opmph) {
    pimphscrn = 1;   /* display Multi-Phase Parameter screen */
    pifphasenub = 6;
    pifphaseval2 = 1;
    pifphaseval3 = 2;
    pifphaseval4 = 5;
    pifphaseval5 = 10;
    pifphaseval6 = 15;
    pisldelnub = 0;
    piacqnub = 0;
    setexist(opacqo, 1);
    pihrepnub = 0;  /* no XRR gating */
  } else {
    cvoverride(opfphases, 1, PSD_FIX_ON, PSD_EXIST_ON);
  }

  /* opuser0: show GIT revision (GITSHA) using REV variable from the Imakefile */
  char userstr[100];
#ifdef REV
  sprintf(userstr, "    %s PSD version: %s", _ksfse_flipexc.descr, REV);
#else
  sprintf(userstr, "%s", _ksfse_flipexc.descr);
#endif
  cvmod(opuser0, _ksfse_flipexc.minval, _ksfse_flipexc.maxval, _ksfse_flipexc.defval, userstr, 0, " ");
  opuser0 = _opuser0.defval;
  piuset |= use0;

  /* opuser1: TE based on ETL. */
  cvmod(opuser1, _ksfse_etlte.minval, _ksfse_etlte.maxval, _ksfse_etlte.defval, _ksfse_etlte.descr, 0, " ");
  opuser1 = _ksfse_etlte.defval;
  ksfse_etlte = _ksfse_etlte.defval;

  if (opssfse) {
    piuset &= ~use1; /* don't show for SSFSE */
  } else {
    piuset |= use1; /* show since not SSFSE */
  }

  cvmod(opuser2, _ksfse_inflowsuppression.minval, _ksfse_inflowsuppression.maxval, _ksfse_inflowsuppression.defval, _ksfse_inflowsuppression.descr, 0, " ");
  piuset |= use2;
  opuser2 = _ksfse_inflowsuppression.defval;


  if (opfr == FALSE && (oppseq != PSD_IR /* 3 */ && opirprep == FALSE && opflair == FALSE) && opssfse == FALSE && exist(opetl) > 1) {
    /* if FSE-XL has been selected, allow T1-w optimization */
    cvmod(opuser3, 0, 1, 0, "T1-w Optimization [0:OFF 1:ON]", 0, " ");
    opuser3 = _opuser3.defval;
    piuset |= use3;
  } else {
    opuser3 = 0;
    piuset &= ~use3;
  }


  /* In-range TR support (but without using GE's opinrangetr, since we don't know
     how to read the AutoTR field values on the Advanced tab. Instead, for now, add two opusers
     for the range. If any of these are = 0, it is disabled */
  cvmod(opuser4, _ksfse_mintr.minval/1000, _ksfse_mintr.maxval/1000, _ksfse_mintr.defval/1000, _ksfse_mintr.descr, 0, " "); /* minTR in [ms] */
  opuser4 = _opuser4.defval;
  piuset |= use4;
  cvmod(opuser5, _ksfse_maxtr.minval/1000, _ksfse_maxtr.maxval/1000, _ksfse_maxtr.defval/1000, _ksfse_maxtr.descr, 0, " "); /* maxTR in [ms] */
  opuser5 = _opuser5.defval;
  if (opflair == OPFLAIR_GROUP) {
    piuset &= ~use5; /* Don't show maxTR limit for T2FLAIR */
  } else {
    piuset |= use5;
  }

  if (opflair != OPFLAIR_GROUP) {
    _rf_stretch_all.defval = 1.5; /* Wider default (except for T2FLAIR which is less SAR heavy) to shorten the scan time (less SAR penalty) */
  } else {
    _rf_stretch_all.defval = 1.0;
  }
  cvmod(opuser6, 1.0, _rf_stretch_all.maxval,  _rf_stretch_all.defval, _rf_stretch_all.descr, 0, " ");
  opuser6 = _rf_stretch_all.defval;
  piuset |= use6;

  /*
     Reserved opusers:
     -----------------
     ksfse_eval_inversion(): opuser26-29
     GE reserves: opuser36-48 (epic.h)
   */

  if (oparc) {
    /* Acceleration menu as decimal numbers (max accel = 4) */
    GEReq_init_accelUI(KS_ACCELMENU_FRACT, 4);
  } else {
    /* Acceleration menu as integers (max accel = 4)
       Covers the non-accelerated and ASSET cases */
    GEReq_init_accelUI(KS_ACCELMENU_INT, 4);
  }


  return SUCCESS;

} /* ksfse_init_UI() */





/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: CVEVAL
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Gets the current UI and checks for valid inputs
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_UI() {

  if (ksfse_init_UI() == FAILURE)
    return FAILURE;



  /*** Copy UserCVs to human readable CVs ***/
  ksfse_flipexc = opuser0;

  ksfse_etlte = (int) opuser1;
  if (ksfse_etlte != PSD_OFF && ksfse_etlte != PSD_ON) {
    return ks_error("'ETL controls TE' flag must be either [0:OFF, 1:ON]"); /* User error */
  }

  if (existcv(opetl)) {
    /* if ETL has been selected, adjust TR menu to either T1-w or T2-w mode */
    if (exist(opetl) < 6) {
      pitrval3 = 450ms;
      pitrval4 = 500ms;
      pitrval5 = 550ms;
      pitrval6 = 600ms;
    } else {
      pitrval3 = 2500ms;
      pitrval4 = 3000ms;
      pitrval5 = 4000ms;
      pitrval6 = 5000ms;
    }
  }

  /* Inflow suppression (only if spacing or multiple acqs) */
  if (existcv(opslquant) && (opslspace > 0.0 || avmaxacqs > 1)) {
    ksfse_inflowsuppression = opuser2;
  } else {
    cvoverride(ksfse_inflowsuppression, 0, PSD_FIX_OFF, PSD_EXIST_ON);
  }
  if (ksfse_inflowsuppression > 0) {
    cvdesc(opuser2, "In-flow suppression 0:OFF [1:ON]"); /* Highlight ON */
  } else {
    cvdesc(opuser2, "In-flow suppression [0:OFF] 1:ON"); /* Highlight OFF */
  }

  /* Fast recovery / T1w optimization */
  if (opuser3 > 0) {
    ksfse_recovery = KSFSE_RECOVERY_T1WOPT;
  } else if (opfr) {
    ksfse_recovery = KSFSE_RECOVERY_FAST;
  } else {
    ksfse_recovery = 0;
  }

  /* Min/Max TR */
  {
    char tmpstr[100];
  (ksfse_mintr) = RUP_GRD((int) opuser4 * 1000); /* in [us] */
  (ksfse_maxtr) = RUP_GRD((int) opuser5 * 1000); /* in [us] */

  if (opflair == OPFLAIR_GROUP) {
    /* T2FLAIR */
    (ksinv_mintr_t2flair) = (ksfse_mintr > 0) ? ksfse_mintr : _ksinv_mintr_t2flair.defval;
    if (ksfse_mintr > 0)
      sprintf(tmpstr, "Min TR (ms) [0: Auto]");
    else
      sprintf(tmpstr, "Min TR (ms) [0: Auto (%d)]", _ksinv_mintr_t2flair.defval/1000);
    cvdesc(opuser4, tmpstr);
  } else if (opflair == OPFLAIR_INTERLEAVED) {
    /* T1FLAIR */
    (ksinv_mintr_t1flair) = (ksfse_mintr > 0) ? ksfse_mintr : _ksinv_mintr_t1flair.defval;
    (ksinv_maxtr_t1flair) = (ksfse_maxtr > 0) ? ksfse_maxtr : _ksinv_maxtr_t1flair.defval;

    if (ksfse_mintr > 0)
      sprintf(tmpstr, "Min TR (ms) [0: Auto]");
    else
      sprintf(tmpstr, "Min TR (ms) [0: Auto (%d)]", _ksinv_mintr_t1flair.defval/1000);
    cvdesc(opuser4, tmpstr);

    if (ksfse_maxtr > 0)
      sprintf(tmpstr, "Max TR (ms) [0: Auto]");
    else
      sprintf(tmpstr, "Max TR (ms) [0: Auto (%d)]", _ksinv_maxtr_t1flair.defval/1000);
    cvdesc(opuser5, tmpstr);

  } else {
    cvdesc(opuser4, _ksfse_mintr.descr);
    cvdesc(opuser5, _ksfse_maxtr.descr);
  }
}

  /* overall RF pulse stretching */
  rf_stretch_all = opuser6;


  /* Reserved opusers:
     -----------------
     ksfse_eval_inversion(): opuser26-29
     GE reserves: opuser36-48 (epic.h)
   */

  return SUCCESS;

} /* ksfse_eval_UI() */





/**
 *******************************************************************************************************
 @brief #### Sets up the TE menu based on echo spacing, max TE, ETL and the optimal echo index

 `optechono` is the echo index in range [0, ETL-1] that is in the center of the FSE train. If the TE
 corresponding to this index is chosen, optimal image quality is achieved with minimal FSE ghosting.

 For ETLs > 6, this value is given first in the TE menu, meaning that if the user chooses the first
 field in the TE menu this will have the same effect as setting "ETL controls TE", and the remaining
 TE fields in the menu are the ones straddling the optimal TE.

 For ETLs in range [2,6], MinFull is the first, followed by the optimal TE.

 For ETL = 1, which corresponds to a conventional Spin-Echo, the user can choose only between MinTE
 (partial kx Fourier) and MinFullTE. Manual type-in is not allowed for ETL = 1.

 @return void
********************************************************************************************************/
void ksfse_eval_TEmenu(int esp, int maxte, int etl, double optechono) {
  int allow_typein = 1;

  if (etl > 6) {
    pite1val2 = optechono * esp; /* best TE for image quality (minimal T2-blurring, ghosting) */
    pite1val3 = (optechono - 2) * esp;
    pite1val4 = (optechono - 1) * esp;
    pite1val5 = (optechono + 1) * esp;
    pite1val6 = (optechono + 2) * esp;
  } else if (etl > 1) {
    pite1val2 = PSD_MINFULLTE;
    pite1val3 = (optechono - 2) * esp;
    pite1val4 = (optechono - 1) * esp;
    pite1val5 = optechono * esp;
    pite1val6 = (optechono + 1) * esp;
  } else { /* etl = 1 */
    allow_typein = 0;
    pite1val2 = PSD_MINIMUMTE;
    pite1val3 = PSD_MINFULLTE;
    pite1val4 = 0;
    pite1val5 = 0;
    pite1val6 = 0;
  }

  if (etl > 1) {
    pite1nub = allow_typein + 2 +
               4  * (pite1val3 >= esp && pite1val3 <= maxte) +
               8  * (pite1val4 >= esp && pite1val4 <= maxte) +
               16 * (pite1val5 >= esp && pite1val5 <= maxte) +
               32 * (pite1val6 >= esp && pite1val6 <= maxte);
  } else {
    pite1nub = 6; /* only MinTE & MinFull */
  }

} /* ksfse_eval_TEmenu() */




/**
 *******************************************************************************************************
 @brief #### Calculates echo spacing for the sequence

 @param[out] min90_180   Pointer to the time between moment start of the excitation pulse to the center
                         of the refocusing pulse in [us]
 @param[out] min180_echo Pointer to the time between center of the refocusing pulse to the center of the
                         first echo in [us]
 @param[in] slicecheck  0: Normal mode 1: Slice check mode, where the readout is moved to the slice axis
 @param[in] seq         Pointer to KSFSE_SEQUENCE
 @retval echospacing Echo Spacing in [us]
********************************************************************************************************/
int ksfse_eval_esp(int *min90_180, int *min180_echo, int slicecheck, KSFSE_SEQUENCE *seq) {
  int echospacing;

  /*** minimum time needed between RF exc center to RF ref center ***/
  /* latter portion of RF pulse incl ramptime of slice sel grad */
  *min90_180 = seq->selrfexc.rf.iso2end;
  if (slicecheck) {
    /* need separate time for read dephaser */
    *min90_180 += seq->selrfexc.grad.ramptime + seq->readdephaser.duration + seq->selrfexc.postgrad.duration +
                  seq->selrfref1st.pregrad.duration + seq->selrfref1st.grad.ramptime;
  } else {
    /* max of seq->readdephaser and time from end of rfexc grad plateau to beginning of plateau for rfrefocus */
    *min90_180 += IMax(2,
                       seq->readdephaser.duration /* X */,
                       seq->selrfexc.grad.ramptime + seq->selrfexc.postgrad.duration + seq->selrfref1st.pregrad.duration + seq->selrfref1st.grad.ramptime /* Z */);
  }
  *min90_180 += seq->selrfref1st.rf.start2iso; /* slice selection time until RF center */

  /*** minimum time needed between RF ref center and echo center ***/
  *min180_echo = IMax(3, seq->selrfref1st.rf.iso2end, seq->selrfref2nd.rf.iso2end, seq->selrfref.rf.iso2end);
  if (slicecheck) {
    *min180_echo += IMax(4,
                        seq->phaseenc.grad.duration - seq->read.acqdelay + seq->read.time2center /* Y */,
                        seq->selrfref1st.grad.ramptime                + seq->selrfref1st.postgrad.duration + seq->zphaseenc.grad.duration + seq->read.time2center /* Z 1st echo */,
                        (opetl > 1) * (seq->selrfref2nd.grad.ramptime + seq->selrfref2nd.postgrad.duration + seq->zphaseenc.grad.duration + seq->read.time2center) /* Z 2nd echo */,
                        (opetl > 2) * (seq->selrfref.grad.ramptime    + seq->selrfref.postgrad.duration    + seq->zphaseenc.grad.duration + seq->read.time2center) /* Z 3-Nth echo */);
  } else {
    *min180_echo += IMax(5,
                        seq->read.acqdelay /* X */,
                        seq->phaseenc.grad.duration /* Y */,
                        seq->selrfref1st.grad.ramptime                + seq->selrfref1st.postgrad.duration + seq->zphaseenc.grad.duration /* Z 1st echo */,
                        (opetl > 1) * (seq->selrfref2nd.grad.ramptime + seq->selrfref2nd.postgrad.duration + seq->zphaseenc.grad.duration) /* Z 2nd echo */,
                        (opetl > 2) * (seq->selrfref.grad.ramptime    + seq->selrfref.postgrad.duration    + seq->zphaseenc.grad.duration) /* Z 3-Nth echo */);
    *min180_echo += seq->read.time2center - seq->read.acqdelay; /* time from start of acquisition to k-space center */
  }

  echospacing = IMax(2, *min90_180, *min180_echo) * 2;
  echospacing = RUP_FACTOR(echospacing, 16);

  return echospacing;
}




/**
 *******************************************************************************************************
 @brief #### Calculates the optimal number of k-space points for partial kx Fourier that does not increase TE

 This function plays by the following rules:
     1. CV ksfse_kxnover_min is the lowest number of samples allowed
     2. ksfse.read.res/2 is the highest number of samples allowed
     3. Increase `kxnover` until an increase in TE results, while staying within above limits

 @param[in] seq Pointer to the KSFSE_SEQUENCE struct holding all sequence objects
 @retval kxnover Optimal number of k-space points beyond half k-space for partial kx Fourier scans.
********************************************************************************************************/
int ksfse_eval_optimalkxnover(KSFSE_SEQUENCE *seq) {

  int min90_180 = 0; /* [us] */
  int min180_echo = 0; /* [us] */
  int kxnover = 0; /* samples */

  ksfse_eval_esp(&min90_180, &min180_echo, ksfse_slicecheck, seq);

  if (seq->read.nover) {
    /* we are currently using partial Fourier, adjust kxnover to balance the time before and after
    the refocusing pulse */
    kxnover = seq->read.nover + ((min90_180 - min180_echo) / ks_calc_bw2tsp(seq->read.acq.rbw));
  } else {
    /* we are currently using full Fourier (read.nover = 0) */
    if (min90_180 > min180_echo) {
      /* more time needed before the 180 anyway, no need to do partial Fourier */
      kxnover = seq->read.res / 2;
    } else {
      kxnover = seq->read.res / 2 - ((min180_echo - min90_180) / ks_calc_bw2tsp(seq->read.acq.rbw));
    }
  }

  /* keep in range */
  if (kxnover < ksfse_kxnover_min) {
    kxnover = ksfse_kxnover_min;
  } else if (kxnover > seq->read.res / 2) {
    kxnover = seq->read.res / 2;
  }

  kxnover = RUP_GRD(kxnover);

  return kxnover;

} /* ksfse_eval_optimalkxnover() */



float ksfse_eval_rfstretchfactor(float patientweight, float flipangle, int tailoredrf_flag) {
  float rfstretchfactor = 1.0;
  float flipangle_factor = 1.0;
  float patientweight_factor = FMax(2, 1.0, patientweight * 0.0055 + 0.6); /* 1.0 at around 75 kg, never less than 0 */

  if (tailoredrf_flag) {
    /* Empirical 2D plane as a function of patient weight and flip angle (for RF pulse set ref_fse1601/2/n)
       Important to not let it below ~0.6 when flipangle or patient weight is too small */
    flipangle_factor = FMax(2, 0.6, 0.0035 * flipangle + 0.15);
    rfstretchfactor = flipangle_factor * patientweight_factor;
  } else {
    /* Empirical 2D plane as a function of patient weight and flip angle (for RF pulse set ref_se1b4)
    Important to not let it below ~0.6 when flipangle or patient weight is too small */
    flipangle_factor = FMax(2, 0.6, 0.0080 * flipangle - 0.10);
    rfstretchfactor = flipangle_factor * patientweight_factor;
  }

  if (rfstretchfactor < 0.6)
    rfstretchfactor = 0.6; /* extra level of safety */

  return rfstretchfactor;
}



/**
 *******************************************************************************************************
 @brief #### Sets up the RF objects for the ksfse sequence (2D)

 This function attempts to mimick the RF scaling and flip angle varation performed in the product
 fsemaster.e psd, with and without the tailored RF (optlrdrf) option. It is called from
 ksfse_eval_setupobjects() to set up the RF pulses to keep ksfse_eval_setupobjects() from growing too
 much in size.

 @param[in] seq Pointer to the KSFSE_SEQUENCE struct holding all sequence objects
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_setuprfpulses_2D(KSFSE_SEQUENCE *seq) {
  STATUS status;

  /* Clear potential gradient waveforms in the KS_SELRF objects before we choose our RF pulses */
  ks_init_wave(&seq->selrfexc.gradwave);
  ks_init_wave(&seq->selrfref1st.gradwave);
  ks_init_wave(&seq->selrfref2nd.gradwave);
  ks_init_wave(&seq->selrfref.gradwave);

  /*******************************************************************************************************
   *  RF Selections. Flip angle and slice thickness tweaks
   *******************************************************************************************************/

  ksfse_excthickness = opslthick;

  if (optlrdrf == TRUE || opetl > 2) {
    seq->selrfexc.rf = exc_fse90;      /* Excitation */
    seq->selrfref1st.rf = ref_fse1601; /* 1st Refocusing */
    seq->selrfref2nd.rf = ref_fse1602; /* 2nd Refocusing */
    seq->selrfref.rf = ref_fse160n;    /* 3->ETL Refocusing */
    ksfse_gscalerfexc = 0.8;
    ksfse_gscalerfref = (ksfse_inflowsuppression) ? 0.9 : 0.8;
  } else {
    seq->selrfexc.rf = exc_fl901mc;
    seq->selrfref1st.rf = ref_se1b4;
    seq->selrfref2nd.rf = ref_se1b4;
    seq->selrfref.rf = ref_se1b4;
    ksfse_gscalerfexc = 0.9;
    ksfse_gscalerfref = (ksfse_inflowsuppression) ? 1.0 : 0.9;
  }

  /* Stretch factors for RF refocusing pulses */
  rf_stretch_rfref = ksfse_eval_rfstretchfactor(opweight, opflip, optlrdrf);
  rf_stretch_rfexc = rf_stretch_rfref;

#if EPIC_RELEASE >= 26
  if (opsarmode == 0) { /* normal mode */
    rf_stretch_all *= 1.6;
  } else if (opsarmode == 3) { /* low SAR mode */
    rf_stretch_all *= 3;
  }
#endif

  /* Set flip angles */
  if (optlrdrf == TRUE && opetl > 2) {
    seq->selrfref1st.rf.flip = opflip + 0.6032 * (180.0 - opflip);
    seq->selrfref2nd.rf.flip = opflip + 0.1032 * (180.0 - opflip);
    seq->selrfref.rf.flip = opflip;
  } else {
    seq->selrfref1st.rf.flip = opflip;
    seq->selrfref2nd.rf.flip = opflip;
    seq->selrfref.rf.flip = opflip;
  }


  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  seq->selrfexc.slthick = ksfse_excthickness / ksfse_gscalerfexc;

  /* Optional widening of the excitation pulse when we have slice gap or
     interleaved (opileave) slice mode where odd slices are completed and reconstructed
     before playing out the even slices */
  if (ksfse_inflowsuppression) {
    if (ksfse_inflowsuppression_mm <= 0) {
      /* ksfse_inflowsuppression_mm = 0 => auto thickness */
      int intleavefact = IMax(2, 1, avmaxacqs);
      float newthick = intleavefact * (ksfse_excthickness + opslspace);
      newthick = FMax(2, seq->selrfexc.slthick, newthick); /* to handle case where newthick is smaller */
      /* up to the case where newthick is three times the slice thickness */
      seq->selrfexc.slthick = (newthick <= KSFSE_MAXTHICKFACT * ksfse_excthickness) ? newthick : KSFSE_MAXTHICKFACT * ksfse_excthickness;
    } else {
      /* ksfse_inflowsuppression_mm > 0: the user wants to specify how many mm extra the excitation
      thickness should be */
      seq->selrfexc.slthick += ksfse_inflowsuppression_mm / ksfse_gscalerfexc;
    }
  }

  seq->selrfexc.rf.flip = ksfse_flipexc; /* value from opuser0 */

  status = ks_eval_stretch_rf(&seq->selrfexc.rf, rf_stretch_all * rf_stretch_rfexc);
  if (status != SUCCESS) return status;

  status = ks_eval_selrf(&seq->selrfexc, "rfexc");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  RF Refocusing (1st echo)
  *******************************************************************************************************/
  seq->selrfref1st.slthick = ksfse_excthickness / ksfse_gscalerfref;

  status = ks_eval_stretch_rf(&seq->selrfref1st.rf, rf_stretch_all * rf_stretch_rfref);
  if (status != SUCCESS) return status;

  /* when quietness factor is used, find the crusherscale that minimizes the echo spacing (esp) */
  if (ks_qfact > 1) {
    int dummy1, dummy2;
    float c;
    float optc = 2.0;
    int optesp = 1s;
    int my_esp = KS_NOTSET;
    for (c = 0.0; c < 2.0; c += 0.01) {
      seq->selrfref1st.crusherscale = c;
      status = ks_eval_selrf(&seq->selrfref1st, "rfref1st");
      seq->selrfexc.postgrad.duration = 0; /* disable the rephaser of the excitation */
      seq->selrfref1st.pregrad.area += seq->selrfexc.postgrad.area; /* note: postgrad.area is negative ! */
      status = ks_eval_trap(&seq->selrfref1st.pregrad, seq->selrfref1st.pregrad.description);
      my_esp = ksfse_eval_esp(&dummy1, &dummy2, FALSE, seq);
      if (my_esp < optesp) {
        optesp = my_esp;
        optc = c;
      }
    }
    ksfse_crusherscale = optc;
  }

  seq->selrfref1st.crusherscale = ksfse_crusherscale;
  status = ks_eval_selrf(&seq->selrfref1st, "rfref1st");
  if (status != SUCCESS) return status;

  seq->selrfexc.postgrad.duration = 0; /* disable the rephaser of the excitation */
  seq->selrfref1st.pregrad.area += seq->selrfexc.postgrad.area; /* note: postgrad.area is negative ! */
  status = ks_eval_trap(&seq->selrfref1st.pregrad, seq->selrfref1st.pregrad.description);
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  RF Refocusing (2nd echo)
   *******************************************************************************************************/
  seq->selrfref2nd.slthick = ksfse_excthickness / ksfse_gscalerfref;
  seq->selrfref2nd.crusherscale = ksfse_crusherscale;

  status = ks_eval_stretch_rf(&seq->selrfref2nd.rf, rf_stretch_all * rf_stretch_rfref);
  if (status != SUCCESS) return status;

  status = ks_eval_selrf(&seq->selrfref2nd, "rfref2nd");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  RF Refocusing (3rd-Nth echo)
   *******************************************************************************************************/
  seq->selrfref.slthick = ksfse_excthickness / ksfse_gscalerfref;
  seq->selrfref.crusherscale = ksfse_crusherscale;

  status = ks_eval_stretch_rf(&seq->selrfref.rf, rf_stretch_all * rf_stretch_rfref);
  if (status != SUCCESS) return status;

  status = ks_eval_selrf(&seq->selrfref, "rfref");
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* ksfse_eval_setuprfpulses_2D() */





/**
 *******************************************************************************************************
 @brief #### Sets up the RF objects for the ksfse sequence (3D)

 This function attempts to mimick the RF scaling and flip angle varation performed in the product
 fsemaster.e psd, with and without the tailored RF (optlrdrf) option. It is called from
 ksfse_eval_setupobjects() to set up the RF pulses to keep ksfse_eval_setupobjects() from growing too
 much in size.

 @param[in] seq Pointer to the KSFSE_SEQUENCE struct holding all sequence objects
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_setuprfpulses_3D(KSFSE_SEQUENCE *seq) {
  STATUS status;

  /* GE defines (epic.h) for opexcitemode:
    SELECTIVE 0, NON_SELECTIVE 1, FOCUS 2 */
  const float hardpulse_duration = 1ms;
  float adaptive_crusherscale = 1.0;

  /* Clear potential gradient waveforms in the KS_SELRF objects before we choose our RF pulses */
  ks_init_wave(&seq->selrfexc.gradwave);
  ks_init_wave(&seq->selrfref1st.gradwave);
  ks_init_wave(&seq->selrfref2nd.gradwave);
  ks_init_wave(&seq->selrfref.gradwave);

  cvoverride(opvthick, exist(opslquant) * exist(opslthick), _opslquant.fixedflag, existcv(opslquant));
  ksfse_excthickness = (exist(opslquant) - 2 * rhslblank) * exist(opslthick);
  ksfse_gscalerfexc = 1.0;

  if (ksfse.zphaseenc.areaoffset > 0 || ksfse.zphaseenc.grad.area == 0) {
    return ks_error("%s: Call ks_eval_phaser(zphasenc) with .areaoffset = 0, before calling this function", __FUNCTION__);
  } else {
    /* we want the same big enough crusher for any kz encoding variation accross the ETL, where even the
    most negative kz encoding gradient will not be able to cancel out the positive crushers */
    adaptive_crusherscale = ksfse_crusherscale + (ksfse.zphaseenc.grad.area / KS_RF_STANDARD_CRUSHERAREA);
  }


  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  if (opexcitemode == NON_SELECTIVE) {
    /* Non-selective 90 hard excitaion */
    status = ks_eval_rf_hard(&seq->selrfexc.rf, "rfexc", hardpulse_duration, 90);
    if (status != SUCCESS) return status;
    seq->selrfexc.rf.role = KS_RF_ROLE_EXC;
  } else {
    /* Selective 90 using a sharp high-BW minimum phase excitation pulse */
    seq->selrfexc.rf = exc_3dfgre;
    seq->selrfexc.rf.flip = 90.0;
  }

  seq->selrfexc.slthick = ksfse_excthickness / ksfse_gscalerfexc * (opexcitemode != NON_SELECTIVE);

  status = ks_eval_stretch_rf(&seq->selrfexc.rf, rf_stretch_all * rf_stretch_rfexc);
  if (status != SUCCESS) return status;

  status = ks_eval_selrf(&seq->selrfexc, "rfexc");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  RF Refocusing (1st echo)
  *******************************************************************************************************/
  status = ks_eval_rf_hard(&seq->selrfref1st.rf, "rfref1st", hardpulse_duration, opflip);
  if (status != SUCCESS) return status;
  seq->selrfref1st.rf.role = KS_RF_ROLE_REF;

  seq->selrfref1st.slthick = 0; /* N.B.: sel gradient = 0 if .selrfref1st.slthick = 0 (ks_eval_selrf()) */

  status = ks_eval_stretch_rf(&seq->selrfref1st.rf, rf_stretch_all * rf_stretch_rfref);
  if (status != SUCCESS) return status;

  seq->selrfref1st.crusherscale = adaptive_crusherscale;
  status = ks_eval_selrf(&seq->selrfref1st, "rfref1st");
  if (status != SUCCESS) return status;

  /* Left crusher: Merge excitation rephaser into left crusher */
  /* N.B.: Right crusher will be embedded in zphasenc in ksfse_eval_setupobjects() */
  seq->selrfexc.postgrad.duration = 0; /* disable the rephaser of the excitation */
  seq->selrfref1st.pregrad.area += seq->selrfexc.postgrad.area; /* note: postgrad.area is negative ! */
  status = ks_eval_trap(&seq->selrfref1st.pregrad, seq->selrfref1st.pregrad.description);
  if (status != SUCCESS) return status;


  /*******************************************************************************************************
   *  RF Refocusing (2nd echo)
   *******************************************************************************************************/
  seq->selrfref2nd.rf = seq->selrfref1st.rf;
  seq->selrfref2nd.slthick = seq->selrfref1st.slthick;
  seq->selrfref2nd.crusherscale = seq->selrfref1st.crusherscale;
  status = ks_eval_selrf(&seq->selrfref2nd, "rfref2nd");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  RF Refocusing (3rd-Nth echo)
   *******************************************************************************************************/
  seq->selrfref.rf = seq->selrfref1st.rf;
  seq->selrfref.slthick = seq->selrfref1st.slthick;
  seq->selrfref.crusherscale = seq->selrfref1st.crusherscale;
  status = ks_eval_selrf(&seq->selrfref, "rfref");
  if (status != SUCCESS) return status;


  /*******************************************************************************************************
   *  Move crushers area from selrf.pregrad/postgrad to zphasenc.areaoffset
   *  Disable pre/postgrads by setting their duration to 0
   *******************************************************************************************************/
  seq->selrfref1st.postgrad.duration = 0; /* right crusher only */
  seq->selrfref2nd.pregrad.duration = 0;
  seq->selrfref2nd.postgrad.duration = 0;
  seq->selrfref.pregrad.duration = 0;
  seq->selrfref.postgrad.duration = 0;

  ksfse.zphaseenc.areaoffset = ksfse.selrfref1st.postgrad.area;
  status = ks_eval_phaser(&ksfse.zphaseenc, "zphaseenc"); /* update zphaseenc, now with .areaoffset > 0 */
  if (status != SUCCESS) return status;


  return SUCCESS;

} /* ksfse_eval_setuprfpulses_3D() */



STATUS ksfse_eval_setuprfpulses_recovery(KSFSE_SEQUENCE *seq) {
  STATUS status;

  ks_init_wave(&seq->selrfrecover.gradwave);
  ks_init_wave(&seq->selrfrecoverref.gradwave);

  /*******************************************************************************************************
   * Post-ETL forced recovery: T1-w Optimization / T2 fast Recovery
   *******************************************************************************************************/

  /* Recovery "negative" excitation (selrfrecover) */
  seq->selrfrecover.rf = seq->selrfexc.rf; /* already potentially RF-stretched */
  seq->selrfrecover.slthick = seq->selrfexc.slthick;

  status = ks_eval_selrf(&seq->selrfrecover, "rfrecover");
  if (status != SUCCESS) return status;

  /* no postgrad by setting duration = 0 (or pregrad either since KS_RF_ROLE_EXC) */
  seq->selrfrecover.postgrad.duration = 0;

  /* Mirror RF wave using "-1" (negative stretch factor), will mirror the excitation RF pulse waveform */
  status = ks_eval_stretch_rf(&seq->selrfrecover.rf, -1);
  if (status != SUCCESS) return status;


  /* Recovery refocusing (selrfrecoverref). Use flip angle and design from 'selrfref.rf' but left crusher
     area from selrfref1st.pregrad.area */
  seq->selrfrecoverref.rf = seq->selrfref.rf;
  seq->selrfrecoverref.slthick = seq->selrfref.slthick;
  seq->selrfrecoverref.crusherscale = seq->selrfref1st.crusherscale;
  status = ks_eval_selrf(&seq->selrfrecoverref, "rfrecoverref");
  if (status != SUCCESS) return status;

  if (KS_3D_SELECTED) {
    seq->selrfrecoverref.pregrad.duration = 0; /* zphaseenc.areaoffset takes over */
  }

  seq->selrfrecoverref.postgrad.area = seq->selrfref1st.pregrad.area;
  status = ks_eval_trap(&seq->selrfrecoverref.postgrad, seq->selrfrecoverref.postgrad.description);
  if (status != SUCCESS) return status;

  return SUCCESS;

}


/**
 *******************************************************************************************************
 @brief #### Set the SSI time for the sequence

 @retval int SSI time in [us]
********************************************************************************************************/
int ksfse_eval_ssitime() {

  /* SSI time CV:
     Empirical finding as a function of etl on how much SSI time we need to update.
     But, use a longer SSI time when we write out data to file in scan() */
  ksfse_ssi_time = RUP_GRD(IMax(2, KSFSE_MIN_SSI_TIME + 13 * opetl, _ksfse_ssi_time.minval));

  /* Copy SSI CV to seqctrl field used by setssitime() */
  ksfse.seqctrl.ssi_time = ksfse_ssi_time;

  /* SSI time one-sequence-off workaround:
     We set the hardware ssitime in ks_scan_playsequence(), but it acts on the next sequence module, hence
     we aren't doing this correctly when using multiple sequence modules (as KSChemSat etc).
     One option would be to add a short dummy sequence ks_scan_playsequence(), but need to investigate
     if there is a better way. For now, let's assume the the necessary update time is the longest for
     the main sequence (this function), and let the ssi time for all other sequence modules (KSChemSat etc)
     have the same ssi time as the main sequence. */
  kschemsat_ssi_time    = ksfse_ssi_time;
  ksspsat_ssi_time      = ksfse_ssi_time;
  ksinv_ssi_time        = ksfse_ssi_time;
  ksinv_filltr_ssi_time = ksfse_ssi_time;

  return ksfse_ssi_time;

} /* ksfse_eval_ssitime() */




/**
 *******************************************************************************************************
 @brief #### Sets up all sequence objects for the main sequence module (KSFSE_SEQUENCE ksfse)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
 STATUS ksfse_eval_setupobjects() {
   STATUS status;

  /* Readout gradient and data acquisition */
  ksfse.read.fov = opfov;
  ksfse.read.res = RUP_FACTOR(opxres, 2); /* Round UP to nearest multiple of 2 */

  ksfse.read.rampsampling = ksfse_rampsampling;
  if (ksfse.read.rampsampling)
    ksfse.read.acqdelay = 16; /* us on the ramp until acq should begin */
  if (opautote == PSD_MINTE) { /* PSD_MINTE = 2 */
    ksfse_kxnover = ksfse_eval_optimalkxnover(&ksfse); /* Partial Fourier */
    ksfse.read.nover = ksfse_kxnover;
  } else {
    ksfse.read.nover = 0; /* Full Fourier */
  }
  ksfse.read.acq.rbw = oprbw;
  ksfse.read.paddingarea = ksfse_xcrusherarea;
  if (ks_eval_readtrap(&ksfse.read, "read") == FAILURE)
    return FAILURE;

  /* read dephaser */
  ksfse.readdephaser.area = ksfse.read.area2center;
  if (ks_eval_trap(&ksfse.readdephaser, "readdephaser") == FAILURE)
    return FAILURE;

  /* phase encoding gradient */
  ksfse.phaseenc.fov = opfov * opphasefov;
  ksfse.phaseenc.res = RUP_FACTOR((int) (opyres * opphasefov), 2); /* round up (RUP) to nearest multiple of 2 */

  if (ksfse.read.nover == 0 && opnex < 1) {
    int kynover;
    kynover = ksfse.phaseenc.res * (opnex - 0.5);
    kynover = ((kynover + 1) / 2) * 2; /* round to nearest even number */
    if (kynover < KSFSE_MINHNOVER)
      kynover = KSFSE_MINHNOVER; /* protect against too few overscans */
    ksfse.phaseenc.nover = IMin(2, kynover, ksfse.phaseenc.res / 2);
  } else {
    ksfse.phaseenc.nover = 0;
  }

  /* set .R and .nacslines fields of ksfse.phaseenc using ks_eval_phaser_setaccel() before calling ks_eval_phaser() */
  if (opasset) {
    cvoverride(ksfse_minacslines, 0, PSD_FIX_OFF, PSD_EXIST_ON);
  } else if (oparc) {
    ksfse_minacslines = _ksfse_minacslines.defval;
  }
  if (ks_eval_phaser_setaccel(&ksfse.phaseenc, ksfse_minacslines, opaccel_ph_stride) == FAILURE)
    return FAILURE;

  if (ks_eval_phaser(&ksfse.phaseenc, "phaseenc") == FAILURE)
    return FAILURE;


  /* z phase encoding gradient (N.B. 3D is not yet implemented in this sequence) */
  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */

    ksfse.selrfref1st.postgrad.duration = 0; /* disable the right crusher gradient (.duration = 0), and put area necessary in zphaseenc.areaoffset */
    ksfse.zphaseenc.areaoffset = 0; /* explicitly 0 here, since modified later in ksfse_eval_setuprfpulses_3D() */
    ksfse.zphaseenc.fov = opvthick;
    ksfse.zphaseenc.res = IMax(2, 1, opslquant);
    ksfse.zphaseenc.nover = 0;

    /* set .R and .nacslines fields of ksfse.zphaseenc using ks_eval_phaser_setaccel() before calling ks_eval_phaser() */
    if (opasset) {
      cvoverride(ksfse_minzacslines, 0, PSD_FIX_OFF, PSD_EXIST_ON);
    } else if (oparc) {
      ksfse_minzacslines = _ksfse_minzacslines.defval;
    }
    if (ks_eval_phaser_setaccel(&ksfse.zphaseenc, ksfse_minzacslines, opaccel_sl_stride) == FAILURE)
      return FAILURE;

    /* another call done in ksfse_eval_setuprfpulses_3D() with .areaoffset > 0 */
    if (ks_eval_phaser(&ksfse.zphaseenc, "zphaseenc") == FAILURE)
      return FAILURE;

  } else {

    ks_init_phaser(&ksfse.zphaseenc);

  }


  /* setup RF pulses in FSE train */
  if (KS_3D_SELECTED) {
    if (ksfse_eval_setuprfpulses_3D(&ksfse) == FAILURE)
      return FAILURE;
  } else {
    if (ksfse_eval_setuprfpulses_2D(&ksfse) == FAILURE)
      return FAILURE;
  }

  /* Add recovery pulses after the main Echo Train, common for 2D and 3D */
  if (ksfse_recovery) {
    status = ksfse_eval_setuprfpulses_recovery(&ksfse);
    if (status != SUCCESS) return status;
  } else {
    ks_init_selrf(&ksfse.selrfrecover);
    ks_init_selrf(&ksfse.selrfrecoverref);
  }

  /* post-read spoiler */
  ksfse.spoiler.area = ksfse_spoilerarea;
  if (ks_eval_trap(&ksfse.spoiler, "spoiler") == FAILURE)
    return FAILURE;

  /* init seqctrl */
  ks_init_seqcontrol(&ksfse.seqctrl);
  strcpy(ksfse.seqctrl.description, "ksfsemain");
  ksfse_eval_ssitime();

  return SUCCESS;

} /* ksfse_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Sets the min/max TE and echo spacing for the FSE train based on rBW, res and ETL

 Based on the duration of the sequence objects involved, this function first calculates the minimum echo
 spacing in the FSE train (`ksfse_esp`). Then, if the SSFSE flag is set (opssfse), the ETL (opetl) is
 forced to be equal to the number of phase encoding lines acquired (see ks_eval_phaseviewtable()),
 otherwise the chosen ETL is used to calculate how many TRs (or shots) is necessary to fill k-space
 (`ksfse.phaseenc_plan.num_shots`). This value is used later in scan.

 Next, if the user has selected that the "ETL should set TE" (ksfse_etlte = TRUE), the echo time
 is forced to be equal to the most optimal one in the center of the echo train (optecho).
 The benefits of setting ksfse_etlte are a) reduced T2-blurring due to faster k-space traversal, and
 b) no FSE ghosting. The drawback is that TE needs to be controlled via changing ETL in the UI, but
 image quality wise, it may still be worth it. If ksfse_etlte = FALSE, ksfse_calc_echo() will find the
 `bestecho`, which is the echo index in the FSE train closest to the desired TE. When `bestecho` ends up
 being equal to `optecho` (as enforced by ksfse_etlte), the image quality improves, however this it not
 possible, especially for long ETLs with a normal TE of 80-100 ms.

 Last, this function calls ksfse_eval_TEmenu() to change the TE menu so the optimal TE is always at the
 top, followed by other TEs one or more echo spacings from the optimal TE.

 N.B.: `ksfse_esp` is the shortest time allowed between the RF excitation and the first echo, which is
 also the same time needed between two consecutive echoes in the FSE train.
 `ksfse_esp` is used in ksfse_pg(). If the pulse sequence design changes in ksfse_pg() such that more/less
 time is needed to the first echo, or between consecutive echoes, ksfse_esp must here be updated to
 avoid gradient overlaps.

 @retval STATUS `SUCCESS` or `FAILURE`
******************************************************************************************************/
STATUS ksfse_eval_TErange() {
  int min90_180 = 0;
  int min180_echo = 0;
  double optecho, bestecho;
  int fixed_teflag = _opte.fixedflag;
  int exist_teflag = _opte.existflag;
  STATUS status;


  /* echo spacing (esp) */
  ksfse_esp = ksfse_eval_esp(&min90_180, &min180_echo, ksfse_slicecheck, &ksfse);

  /* ETL */
  if (opssfse == PSD_ON) {
    /* SSFSE case */
    cvoverride(opetl, ksfse.phaseenc.numlinestoacq, PSD_FIX_ON, PSD_EXIST_ON);
  } else {
    if (opetl < 1) {
      cvoverride(opetl, 1, PSD_FIX_ON, PSD_EXIST_ON);
    } else if (opetl > ksfse.phaseenc.numlinestoacq) {
      return ks_error("ksfse_eval_TErange: Please reduce ETL to %d", ksfse.phaseenc.numlinestoacq);
    }
  }

  /* if single shot (2D), ks_phaseencoding_generate_2Dfse() will not allow non-optimal TE, i.e. linear k-space sweep
     is required. Therefore, ETL must control TE via setting ksfse_etlte = TRUE */
  if (CEIL_DIV(ksfse.phaseenc.numlinestoacq, opetl) == 1) {
    cvoverride(ksfse_etlte, TRUE, PSD_FIX_ON, PSD_EXIST_ON);
  } else {
    _ksfse_etlte.fixedflag = FALSE;
  }


  /* calc spacing between RF pulses used for T1-w opt. */
  if (ksfse_recovery) {

    int recovery_min_read2ref = (ksfse.read.grad.duration - ksfse.read.time2center - ksfse.read.acqdelay) +
    ksfse.selrfrecoverref.pregrad.duration +
    ksfse.selrfrecoverref.grad.ramptime +
    ksfse.selrfrecoverref.rf.start2iso;

    int recovery_min_ref2exc = ksfse.selrfrecoverref.rf.iso2end +
    IMax(2, ksfse.readdephaser.duration,
    ksfse.selrfrecoverref.grad.ramptime + ksfse.selrfrecoverref.postgrad.duration) +
    ksfse.selrfrecoverref.grad.ramptime +
    ksfse.selrfrecoverref.rf.start2iso;

    if (ksfse_slicecheck) {
      recovery_min_read2ref += ksfse.read.grad.ramptime;
      recovery_min_ref2exc = ksfse.selrfrecoverref.rf.iso2end +
      ksfse.selrfrecoverref.grad.ramptime +
      ksfse.selrfrecoverref.postgrad.duration +
      ksfse.readdephaser.duration +
      ksfse.selrfrecover.grad.ramptime +
      ksfse.selrfrecover.rf.start2iso;
    }

    int ksfse_recovery_spacing = IMax(2, recovery_min_read2ref, recovery_min_ref2exc) * 2;

    ksfse_esp = IMax(2, ksfse_esp, ksfse_recovery_spacing);
  }

  ksfse_esp += GRAD_UPDATE_TIME * 2; /* 8us extra margin */
  ksfse_esp = RUP_FACTOR(ksfse_esp, 8); /* make sure ksfse_esp is divisible by 8us (as we will need to use ksfse_esp/2 on 4us grid) */


  /* protect against too long sequence before we are having trouble in pg */
  if (ksfse_esp * opetl > 2s) {
    return ks_error("%s: Too long sequence duration (%.1f ms)", __FUNCTION__, (ksfse_esp * opetl) / 1000.0);
  }

  /* bestecho: opte rounded off. optecho: ignores 'opte' input */
  status = ks_fse_calcecho(&bestecho, &optecho, &ksfse.phaseenc, opte, opetl, ksfse_esp);
  if (status != SUCCESS) return status;

  setpopup(opte, PSD_OFF);


  if (ksfse_etlte) {
    /* ETL is controlling the use of an optimal TE to ensure a linear k-space sweep */
    cvoverride(opte, (int) (ksfse_esp * optecho), PSD_FIX_ON, PSD_EXIST_ON);
    pite1nub = 0;
    _opte.defval = opte;
    pite1val2 = opte;
    avminte = opte;
    avmaxte = opte;

    /* must set opautote here so that the TE menu is shaded rather than removed */
    cvoverride(opautote, PSD_MINTEFULL, PSD_FIX_OFF, PSD_EXIST_ON);

  } else {

    /* minimum TE */
    avminte = ksfse_esp;

    if (opautote || (opte < avminte)) {
      cvoverride(opte, avminte, PSD_FIX_ON, PSD_EXIST_ON);
    } else {
      /* round opte to nearest valid value */
      cvoverride(opte, (int) (ksfse_esp * bestecho), fixed_teflag, exist_teflag);
    }

    /* maximum TE */
    avmaxte = ksfse_esp * opetl;

    /* Setup TE menu */
    ksfse_eval_TEmenu(ksfse_esp, avmaxte, opetl, optecho);

  }


  { /* Update opuser1 to show optimal TE and echo spacing) */
    char tmpstr[100];
    sprintf(tmpstr, "%s [opt=%.1f, esp=%d]", _ksfse_etlte.descr, (ksfse_esp * optecho) / 1000.0, ksfse_esp / 1000);
    cvdesc(opuser1, tmpstr);
  }

  return SUCCESS;

} /* ksfse_eval_TErange() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to KSInversion functions to add single and dual IR support to this sequence

 It is important that ksfse_eval_inversion() is called after other sequence modules have been set up and
 added to the KS_SEQ_COLLECTION struct in my_cveval(). Otherwise the TI and TR timing will be wrong.

 Whether IR is on or off is determined by ksinv1_mode, which is set up in KSINV_EVAL()->ksinv_eval().
 If it is off, this function will return quietly.

 This function calls ksinv_eval_multislice() (KSInversion.e), which takes over the responsibility of
 TR timing that otherwise is determined in ksfse_eval_tr().
 ksinv_eval_multislice() sets seqcollection.evaltrdone = TRUE, which indicates that TR timing has been done.
 ksfse_eval_tr() checks whether seqcollection.evaltrdone = TRUE to avoid that non-inversion TR timing
 overrides the TR timing set up in ksinv_eval_multislice().

 At the end of this function, TR validation and heat/SAR checks are done.

 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_inversion(KS_SEQ_COLLECTION *seqcollection) {
  STATUS status;
  int slperpass, npasses;
  int approved_TR = FALSE;

  status = KSINV_EVAL(seqcollection, 26, 27, 28, 29); /* args 2-6: integer X corresponds to opuserX CV */
  if (status != SUCCESS) return status;

  if (((int) *ksinv1_mode) == KSINV_OFF) {
    /* If no IR1 flag on, return */
    return SUCCESS;
  }

  if (KS_3D_SELECTED) {
    return ks_error("%s: This function is only for 2D scans", __FUNCTION__);
  }

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    npasses = 2;
  else
    npasses = 1;


  while (approved_TR == FALSE) {

    /* Inversion (specific to 2D FSE/EPI type of PSDs). Must be done after all other sequence modules have been set up */
    slperpass = CEIL_DIV((int) exist(opslquant), npasses);

    status = ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);
    if (status != SUCCESS) return status;

    /* ksinv_eval_multislice() sets seqcollection.evaltrdone = TRUE. This indicates that TR timing has been done.
       ksfse_eval_tr() check whether seqcollection.evaltrdone = TRUE to avoid that non-inversion TR timing overrides the
       intricate TR timing with inversion module(s). At the end of ksinv_eval_multislice(), TR validation and heat/SAR checks are done */
    status = ksinv_eval_multislice(seqcollection, &ks_slice_plan, ksfse_scan_coreslice_nargs, 0, NULL, &ksfse.seqctrl);
    if (status != SUCCESS) return status;

    if (existcv(optr) && existcv(opslquant) && opflair == OPFLAIR_INTERLEAVED && optr > ksinv_maxtr_t1flair) {
      /* T1-FLAIR, too long TR */
      if (npasses > exist(opslquant)) {
        return ks_error("%s: T1-FLAIR: TR not met for single slice per TR", __FUNCTION__);
      }
      npasses++; /* increase #passes and call ksinv_eval_multislice() again with a new ks_slice_plan */
    } else if (existcv(optr) && existcv(opslquant) && opflair == OPFLAIR_INTERLEAVED && optr < ksinv_mintr_t1flair) {
      /* T1-FLAIR, too short TR */
      return ks_error("%s: T1-FLAIR: Min TR is %.0f ms. Increase slices or ETL", __FUNCTION__, ksinv_mintr_t1flair/1000.0);
    } else {
      /* non-T1-FLAIR, or T1-FLAIR with approved TR value */
      approved_TR = TRUE;
    }

  } /* while (approved_TR == FALSE)  */


  return SUCCESS;

} /* ksfse_eval_inversion() */




/**
 *******************************************************************************************************
 @brief #### Evaluation of number of slices / TR, set up of slice plan, TR validation and SAR checks

 With the current sequence collection (see my_cveval()), and a function pointer to an
 argument-standardized wrapper function (ksfse_scan_sliceloop_nargs()) to the slice loop function
 (ksfse_scan_sliceloop(), this function calls GEReq_eval_TR(), where number of slices that can fit
 within one TR is determined by adding more slices as input argument to the slice loop function.
 For more details see GEReq_eval_TR().

 With the number of slices/TR now known, a standard 2D slice plan is set up using ks_calc_sliceplan()
 and the duration of the main sequence is increased based on timetoadd_perTR, which was returned by
 GEReq_eval_TR(). timetoadd_perTR > 0 when optr > avmintr and when heat or SAR restrictions requires
 `avmintr` to be larger than the net sum of sequence modules in the slice loop.

 This function first checks whether seqcollection.evaltrdone == TRUE. This is e.g. the case for inversion
 where the TR timing instead is controlled using ksfse_eval_inversion() (calling ksinv_eval_multislice()).

 At the end of this function, TR validation and heat/SAR checks are done using GEReq_eval_checkTR_SAR().
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_tr(KS_SEQ_COLLECTION *seqcollection) {
  int timetoadd_perTR;
  STATUS status;
  int slperpass, min_npasses;

  if (seqcollection->evaltrdone == TRUE) {
    /*
     We cannot call GEReq_eval_TR() or GEReq_eval_checkTR_SAR(..., ksfse_scan_sliceloop_nargs, ...) if e.g. the inversion sequence module is used. This is because
     ksinv_scan_sliceloop() is used instead of ksfse_scan_sliceloop(). When ksinv1.params.mode != 0 (i.e. inversion sequence module on), the TR timing and
     heat/SAR limits checks are done in ksinv_eval_multislice(), which is called from ksfse_eval_inversion().
     In the future, other sequence modules may want to take over the responsibility of TR calculations and SAR checks, in which case they need to end their corresponding function
     by setting evaltrdone = TRUE to avoid double processing here */
    return SUCCESS;
  }

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    min_npasses = 2;
  else
    min_npasses = 1;

  /* Calculate # slices per TR and how much spare time we have within the current TR by running the slice loop. */
  status = GEReq_eval_TRrange(&slperpass, &timetoadd_perTR, min_npasses, ksfse_mintr, ksfse_maxtr, seqcollection, ksfse_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Calculate the slice plan (ordering) and passes (acqs). ks_slice_plan is passed to GEReq_predownload_store_sliceplan() in predownload() */
  if (KS_3D_SELECTED) {
    ks_calc_sliceplan(&ks_slice_plan, exist(opvquant), 1 /* seq 3DMS */);
  } else {
    ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);
  }

  /* We spread the available timetoadd_perTR evenly, by increasing the .duration of each slice by timetoadd_perTR/ks_slice_plan.nslices_per_pass */
  ksfse.seqctrl.duration = RUP_GRD(ksfse.seqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

  /* Update SAR values in the UI (error will occur if the sum of sequence durations differs from optr)  */
  status = GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, ksfse_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;


  /* Fill in the 'tmin' and 'tmin_total'. tmin_total is only like GEs use of the variable when TR = minTR */
  tmin = ksfse.seqctrl.min_duration;
  tmin_total = ksfse.seqctrl.duration;

  return SUCCESS;

} /* ksfse_eval_tr() */




/**
 *******************************************************************************************************
 @brief #### Set the number of dummy scans for the sequence and calls ksfse_scan_scanloop() to determine
        the length of the scan

        After setting the number of dummy scans based on the current TR, the ksfse_scan_scanloop() is
        called to get the scan time. `pitscan` is the UI variable for the scan clock shown in the top
        right corner on the MR scanner.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_eval_scantime() {

  /* ksfse_dda default = 2 */

  if (optr > 6s || opetl == ksfse.phaseenc.numlinestoacq) {
    /* For long TRs or single-shot FSE, don't use dummies */
    ksfse_dda = 0;
  } else if ((optr > 1s) && (opflair != OPFLAIR_INTERLEAVED)) {
    /* For medium long TRs and not T1-FLAIR */
    ksfse_dda = 1;
  }

  pitscan = ksfse_scan_scanloop();

  return SUCCESS;

} /* ksfse_eval_scantime() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: CVCHECK
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Returns error of various parameter combinations that are not allowed for ksfse
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_check() {

  /* Show resolution, BW per pixel & echo spacing in the UI */
#if EPIC_RELEASE >= 26
  piinplaneres = 1;
  pirbwperpix = 1;
  piesp = 1;
  ihinplanexres = ksfse.read.fov/ksfse.read.res;
  ihinplaneyres = ksfse.phaseenc.fov/ksfse.phaseenc.res;
  ihrbwperpix = (1000.0 * ksfse.read.acq.rbw * 2.0)/ksfse.read.res;
  ihesp = ksfse_esp/1000.0;
#endif

  /* Force the user to select the Fast Spin echo button. This error needs to be in cvcheck(), not in
     cvinit()/cveval() to avoid it to trigger also when Fast Spin Echo has been selected */
  if (!((oppseq == PSD_SE || oppseq == PSD_IR) && opfast == PSD_ON && existcv(opfast))) {
    return ks_error("%s: Please first select the 'Fast Spin Echo' button", ks_psdname);
  }

  if (KS_3D_SELECTED && opcube) {
    return ks_error("%s: Please select either FRFSE-XL or FSE", __FUNCTION__);
  }

  if (oparc && KS_3D_SELECTED && (ksfse.zphaseenc.R > ksfse.phaseenc.R)) {
    /* Unclear why, but zR > R leads to corrupted images for ARC and 3D.
    Probably a bug that can be fixed later. Limited experience (July 2018) */
    return ks_error("%s: Need Slice acceleration <= Phase accleration", __FUNCTION__);
  }

  return SUCCESS;

} /* ksfse_check() */



/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: PREDOWNLOAD
 *
 *******************************************************************************************************
 *******************************************************************************************************/



/**
 *******************************************************************************************************
 @brief #### Plotting of sequence modules and slice timing to PNG/SVG/PDF files

 The ks_plot_*** functions used in here will save plots to disk depending on the value of the CV
 `ks_plot_filefmt` (see KS_PLOT_FILEFORMATS). E.g. if ks_plot_filefmt = KS_PLOT_OFF, nothing will be
 written to disk. On the MR scanner, the output will be located in /usr/g/mrraw/plot/\<ks_psdname\>. In
 simulation, it will be placed in the current directory (./plot/).

 Please see the documentation on how to install the required python version and links. Specifically,
 there must be a link /usr/local/bin/apython pointing to the Anaconda 2 python binary (v. 2.7).

 In addition, the following text files are printed out
 - \<ks_psdname\>_objects.txt
 - \<ks_psdname\>_seqcollection.txt

 @return STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_predownload_plot(KS_SEQ_COLLECTION* seqcollection) {
  char tmpstr[1000];

#ifdef PSD_HW
  sprintf(tmpstr, "/usr/g/mrraw/%s_objects.txt", ks_psdname);
#else
  sprintf(tmpstr, "./%s_objects.txt", ks_psdname);
#endif
  FILE *fp  = fopen(tmpstr, "w");

  /* Note: 'fp' can be replaced with 'stdout' or 'stderr' to get these
     values printed out in the WTools window in simulation. However,
     heavy printing may result in that the WTools window closes,
     why we here write to a file ksfse_objects.txt instead */
  ks_print_readtrap(ksfse.read, fp);
  ks_print_trap(ksfse.readdephaser, fp);
  ks_print_phaser(ksfse.phaseenc, fp);
  ks_print_trap(ksfse.zphaseenc.grad, fp);
  ks_print_trap(ksfse.spoiler, fp);
  ks_print_selrf(ksfse.selrfexc, fp);
  ks_print_selrf(ksfse.selrfref1st, fp);
  ks_print_selrf(ksfse.selrfref2nd, fp);
  ks_print_selrf(ksfse.selrfref, fp);
  if (ksinv1.params.irmode != KSINV_OFF) {
    ks_print_selrf(ksinv1.selrfinv, fp);
  }
  fclose(fp);


  /* ks_plot_host():
  Plot each sequence module as a separate file (PNG/SVG/PDF depending on ks_plot_filefmt (GERequired.e))
  See KS_PLOT_FILEFORMATS in KSFoundation.h for options.
  Note that the phase encoding amplitudes corresponds to the first shot, as set by the call to ksfse_scan_seqstate below */
  ksfse_scan_seqstate(ks_scan_info[0], 0);
  ks_plot_host(seqcollection, &ksfse.phaseenc_plan);

  /* Sequence timing plot: */
  ks_plot_slicetime_begin();
  ksfse_scan_scanloop();
  ks_plot_slicetime_end();

  /* ks_plot_tgt_reset():
  Creates sub directories and clear old files for later use of ksfse_scan_acqloop()->ks_plot_tgt_addframe().
  ks_plot_tgt_addframe() will only write in MgdSim (WTools) to avoid timing issues on the MR scanner. Hence,
  unlike ks_plot_host() and the sequence timing plot, one has to open MgdSim and press RunEntry (and also
  press PlotPulse several times after pressing RunEntry).
  ks_plot_tgt_reset() will create a 'makegif_***.sh' file that should be run in a terminal afterwards
  to create the animiated GIF from the dat files */
  ks_plot_tgt_reset(&ksfse.seqctrl);


  return SUCCESS;

} /* ksfse_predownload_plot() */




/**
 *******************************************************************************************************
 @brief #### Last-resort function to override certain recon variables not set up correctly already

 For most cases, the GEReq_predownload_*** functions in predownload() in ksfse.e set up
 the necessary rh*** variables for the reconstruction to work properly. However, if this sequence is
 customized, certain rh*** variables may need to be changed. Doing this here instead of in predownload()
 directly separates these changes from the standard behavior.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_predownload_setrecon() {

  return SUCCESS;

} /* ksfse_predownload_setrecon() */




@pg
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: PULSEGEN - builing of the sequence from the sequence objects
 *
 *  HOST: Called in cveval() to dry-run the sequence to determine timings
 *  TGT:  Waveforms are being written to hardware and necessary memory automatically alloacted
 *
 *******************************************************************************************************
 *******************************************************************************************************/






/**
 *******************************************************************************************************
 @brief #### Sets the phase encoding amplitudes in the FSE train on hardware using the phase enc. table and shot index

 This function will quietly return early when called on HOST. On IPG, it will set the instruction amplitudes
 of the phase encoding gradients in the FSE train given the phase encoding table, the pointer to the
 single phase encoding object for all phase encodes in the echo train, and the shot index.

 The `shot` index must be in range [0, ceil(pe.numlinestoacq/etl)] and is used to select the current
 row of `etl` different amplitudes in `phaseenc_plan[][shot]`.

 The KS_PHASER object must have been placed out `2*etl` times in `ksfse_pg()` before calling this
 function. The `etl` dephasing gradients before each readout in the echo train correspond to even
 indices, i.e. 0,2,4,...,(2*etl-1), whereas the rephasing gradients after each readout correspond to
 odd indices. This is an effect of that all `ks_pg_***()` functions sort the instances of an object in
 time.

 If `shot < 0` (e.g. `shot = KS_NOTSET = -1`), all phase encoding amplitudes will be set to zero.

 @param[in] phaseenc_plan_ptr Pointer to the phase encoding table (KS_PHASEENCODING_PLAN) (2D & 3D)
 @param[in] phaser Pointer to a KS_PHASER ("ky")
 @param[in] zphaser Pointer to a KS_PHASER ("kz"). Pass in NULL for 2D
 @param[in] shot Which `shot` index to play out for this echo train.
                 `shot = KS_NOTSET` will set all phase encoding gradients to zero.
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_etlphaseamps(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, KS_PHASER *phaser, KS_PHASER *zphaser, int shot) {
  int echo;
  KS_PHASEENCODING_COORD coord = KS_INIT_PHASEENCODING_COORD;

  if (phaseenc_plan_ptr->etl == KS_NOTSET) {
    return SUCCESS; /* we haven't set it up yet */
  }

  /* TODO: Check that #instance for phaser and zphaser is equal to phaseenc_plan_ptr->etl * 2 - 1.
    If 1 less that 2*etl, this indicates no fastrecovery. Don't need the last arg then */

  for (echo = 0; echo < phaseenc_plan_ptr->etl; echo++) {

    coord = ks_phaseencoding_get(phaseenc_plan_ptr, echo, shot);

    ks_scan_phaser_toline(phaser,   0 + 2 * echo, coord.ky); /* dephaser */
    ks_scan_phaser_fromline(phaser, 1 + 2 * echo, coord.ky); /* rephaser */

    if (zphaser != NULL) {
      ks_scan_phaser_toline(zphaser,  0 + 2 * echo, coord.kz); /* dephaser */
      ks_scan_phaser_fromline(zphaser, 1 + 2 * echo, coord.kz); /* rephaser */
    }

  } /* for echo in etl */

  return SUCCESS;

} /* ksfse_etlphaseamps() */




/**
 *******************************************************************************************************
 @brief #### 2DFSE: Updates the spoiler amplitude on hardware during scanning depending on current `etl` and `shot`

 This function updates the spoiler amplitude during scanning, and will return quietly if called on HOST.

 @param[in] phaseenc_plan_ptr Pointer to the phase encoding table (KS_PHASEENCODING_PLAN) (2D & 3D)
 @param[in] spoiler Pointer to the KS_TRAP spoiler object
 @param[in] res Phase encoding resolution
 @param[in] shot `shot` index in range `[0, ceil(pe.numlinestoacq/etl)]`.
 @return void
********************************************************************************************************/
void ksfse_spoilamp(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, KS_TRAP *spoiler, int res, int shot) {
  KS_PHASEENCODING_COORD coord = KS_INIT_PHASEENCODING_COORD;

  /* change spoil direction with respect to last phase encoding blip */
  if (shot >= 0) {
    int i = 1;
    double kspace_dist = 0.0;
    for (i = 0; i < phaseenc_plan_ptr->etl; i++) {
      coord = ks_phaseencoding_get(phaseenc_plan_ptr, i, shot);
      if (coord.ky != KS_NOTSET) {
        kspace_dist = ((res - 1.0) / 2.0) - coord.ky;
      }
    }
    if (kspace_dist >= 0.0) {
      coord = ks_phaseencoding_get(phaseenc_plan_ptr, phaseenc_plan_ptr->etl - 1, shot);
      if (coord.ky == KS_NOTSET) {
        ks_scan_trap_ampscale(spoiler, 0, -1.0);
      } else {
        ks_scan_trap_ampscale(spoiler, 0, 1.0);
      }
    } else {
      coord = ks_phaseencoding_get(phaseenc_plan_ptr, phaseenc_plan_ptr->etl - 1, shot);
      if (coord.ky == KS_NOTSET) {
        ks_scan_trap_ampscale(spoiler, 0, 1.0);
      } else {
        ks_scan_trap_ampscale(spoiler, 0, -1.0);
      }
    }
  }

} /* ksfse_spoilamp() */



/**
 *******************************************************************************************************
 @brief #### The ksfse (main) pulse sequence

 This is the main pulse sequence in ksfse.e using the sequence objects in KSFSE_SEQUENCE with
 the sequence module name "ksfsemain" (= ksfse.seqctrl.description)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_pg(int start_time) {

  KS_SEQLOC tmploc = KS_INIT_SEQLOC;
  int readpos_start = KS_NOTSET;
  int spoiler_pos = KS_NOTSET;
  int i;

  if (start_time < KS_RFSSP_PRETIME) {
    return ks_error("%s: 1st arg (pos start) must be at least %d us", __FUNCTION__, KS_RFSSP_PRETIME);
  }


  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;
  tmploc.pos = RUP_GRD(start_time + KS_RFSSP_PRETIME);
  tmploc.board = ZGRAD;

  /* N.B.: ks_pg_selrf()->ks_pg_rf() detects that ksfse.selrfexc is an excitation pulse
     (ksfse.selrfexc.rf.role = KS_RF_ROLE_EXC) and will also set ksfse.seqctrl.momentstart
     to the absolute position in [us] of the isocenter of the RF excitation pulse */
  if (ks_pg_selrf(&ksfse.selrfexc, tmploc, &ksfse.seqctrl) == FAILURE)
    return FAILURE;


  /*******************************************************************************************************
   *  X dephaser (between 90 and 1st 180)
   *******************************************************************************************************/
  if (ksfse_slicecheck) {
    tmploc.pos = ksfse.seqctrl.momentstart + ksfse.selrfexc.rf.iso2end + ksfse.selrfexc.grad.ramptime;
    tmploc.board = ZGRAD;
  } else {
    tmploc.pos = ksfse.seqctrl.momentstart + ksfse.selrfexc.rf.iso2end;
    tmploc.board = XGRAD;
  }
  if (ks_pg_trap(&ksfse.readdephaser, tmploc, &ksfse.seqctrl) == FAILURE)
    return FAILURE;

  /*******************************************************************************************************
  *  Generate the refocusing flip angles
  -------------------------------------------------------------------------------------------------------*/
  double flip_angles[512]; /* rad */

  if (ksfse_vfa) {

    STATUS status = ks_pg_fse_flip_angle_taperoff(flip_angles,
                                                  opetl,
                                                  ksfse.selrfref1st.rf.flip, ksfse.selrfref2nd.rf.flip, ksfse.selrfref.rf.flip,
                                                  80.0, /* degrees */
                                                  opflair != OPFLAIR_INTERLEAVED);
    if (status != SUCCESS) return ks_error("ks_pg_fse_flip_angle_taperoff failed");

    /* modify rfpulse-struct for SAR calcs. */
    ks_pg_mod_fse_rfpulse_structs(&ksfse.selrfref1st, &ksfse.selrfref2nd, &ksfse.selrfref,
                                  flip_angles,
                                  opetl);

  }



  /*******************************************************************************************************
  *  FSE train: Begin
  -------------------------------------------------------------------------------------------------------*/
  for (i = 0; i < opetl; i++) {

    /* Selective RF Refocus with left (pregrad.) and right (postgrad.) crushers */
    tmploc.board = ZGRAD;
    if (i == 0) {
      /* special case for 1st pulse with at least a smaller left crusher */
      tmploc.pos = ksfse.seqctrl.momentstart + (i + 0.5) * ksfse_esp - ksfse.selrfref1st.rf.start2iso - ksfse.selrfref1st.grad.ramptime - ksfse.selrfref1st.pregrad.duration;

      if (ksfse_vfa)
        tmploc.ampscale = flip_angles[i] / ksfse.selrfref1st.rf.flip;

      if (ks_pg_selrf(&ksfse.selrfref1st, tmploc, &ksfse.seqctrl) == FAILURE)
        return FAILURE;
      tmploc.ampscale = 1;

    } else if (i == 1) {
      tmploc.pos = ksfse.seqctrl.momentstart + (i + 0.5) * ksfse_esp - ksfse.selrfref2nd.rf.start2iso - ksfse.selrfref2nd.grad.ramptime - ksfse.selrfref2nd.pregrad.duration;

      if (ksfse_vfa)
        tmploc.ampscale = flip_angles[i] / ksfse.selrfref2nd.rf.flip;

      if (ks_pg_selrf(&ksfse.selrfref2nd, tmploc, &ksfse.seqctrl) == FAILURE)
        return FAILURE;
      tmploc.ampscale = 1;

    } else {
      tmploc.pos = ksfse.seqctrl.momentstart + (i + 0.5) * ksfse_esp - ksfse.selrfref.rf.start2iso - ksfse.selrfref.grad.ramptime - ksfse.selrfref.pregrad.duration;

      if (ksfse_vfa)
        tmploc.ampscale = flip_angles[i] / ksfse.selrfref.rf.flip;

      if (ks_pg_selrf(&ksfse.selrfref, tmploc, &ksfse.seqctrl) == FAILURE)
        return FAILURE;
      tmploc.ampscale = 1;

    }

    /* ksfse_esp dependent time at beginning of readout ramp */
    readpos_start = ksfse.seqctrl.momentstart + (i + 1) * ksfse_esp - ksfse.read.time2center;

    /*******************************************************************************************************
    *  Readouts
    *******************************************************************************************************/
    tmploc.pos = readpos_start;
    if (ksfse_slicecheck)
      tmploc.board = ZGRAD;
    else
      tmploc.board = XGRAD;
    if (ks_pg_readtrap(&ksfse.read, tmploc, &ksfse.seqctrl) == FAILURE)
      return FAILURE;

    /*******************************************************************************************************
    *  Phase encoding dephasers & rephasers
    *******************************************************************************************************/
    tmploc.board = YGRAD;
    tmploc.pos = readpos_start + ksfse.read.acqdelay - ksfse.phaseenc.grad.duration;
    if (ks_pg_phaser(&ksfse.phaseenc, tmploc, &ksfse.seqctrl) == FAILURE) /* instance 2*i */
      return FAILURE;
    tmploc.pos = readpos_start + ksfse.read.grad.duration - ksfse.read.acqdelay;
    if (ks_pg_phaser(&ksfse.phaseenc, tmploc, &ksfse.seqctrl) == FAILURE) /* instance 2*i + 1 */
      return FAILURE;

    /*******************************************************************************************************
    *  Z phase encoding dephasers & rephasers (3D)
    *******************************************************************************************************/
    if (ksfse.zphaseenc.grad.duration > 0) {
      tmploc.board = ZGRAD;
      tmploc.pos = readpos_start + ksfse.read.acqdelay - ksfse.zphaseenc.grad.duration;
      if (ks_pg_phaser(&ksfse.zphaseenc, tmploc, &ksfse.seqctrl) == FAILURE) /* instance 2*i */
        return FAILURE;
      tmploc.pos = readpos_start + ksfse.read.grad.duration - ksfse.read.acqdelay;
      if (ks_pg_phaser(&ksfse.zphaseenc, tmploc, &ksfse.seqctrl) == FAILURE) /* instance 2*i + 1 */
        return FAILURE;
    }

  } /* opetl */

  /*------------------------------------------------------------------------------------------------------
   *  FSE train: End
   *******************************************************************************************************/


  /*******************************************************************************************************
   * Phase encoding table
   * written to /usr/g/mrraw/ks_phaseencodingtable.txt (HW) or ./ks_phaseencodingtable.txt (SIM)
   *
   * Need to call this in ksfse_pg() so it is run both on HOST and TGT. This, since the phase table
   * is dynamically allocated in ks_phaseencoding_generate_2Dfse()->ks_phaseencoding_resize()
   *
   * For 3D, ks_phaseencoding_generate_2Dfse() just repeats the same ETL ky path for every kz. This is just
   * for testing, and a better ks_phaseencoding_generate_*** function would be needed to do optimal ky-kz
   * trajectory for 3D
   *******************************************************************************************************/
  if (ks_phaseencoding_generate_2Dfse(&ksfse.phaseenc_plan, "",
                                      &ksfse.phaseenc, (KS_3D_SELECTED) ? &ksfse.zphaseenc : NULL,
                                      opte, opetl, ksfse_esp) == FAILURE)
     return FAILURE;

  ks_phaseencoding_print(&ksfse.phaseenc_plan);

  /* set phase encoding amp as for the first shot in the scan loop so it is displayed in WTools MGDSim */
  ksfse_etlphaseamps(&ksfse.phaseenc_plan, &ksfse.phaseenc, (KS_3D_SELECTED) ? &ksfse.zphaseenc : NULL, 0);

  /*******************************************************************************************************
   * Post-ETL forced recovery: T1-w Optimization / T2 fast Recovery
   *******************************************************************************************************/
  if (ksfse_recovery) {

    int lastReadoutCenter = ksfse.seqctrl.momentstart + opetl * ksfse_esp;

    /* Place extra refocusing pulse */
    tmploc.board = ZGRAD;
    tmploc.pos = lastReadoutCenter + ksfse_esp/2 - ksfse.selrfrecoverref.rf.start2iso - ksfse.selrfrecoverref.grad.ramptime - ksfse.selrfrecoverref.pregrad.duration;
    tmploc.ampscale = (ksfse_vfa) ? flip_angles[opetl-1] / ksfse.selrfrecoverref.rf.flip : 1;

    if (ks_pg_selrf(&ksfse.selrfrecoverref, tmploc, &ksfse.seqctrl) == FAILURE)
      return FAILURE;

    /* Place rewinder of previous readout in order to get back to the center of k-space */
    tmploc.pos = lastReadoutCenter + ksfse_esp - ksfse.selrfrecover.rf.start2iso - ksfse.readdephaser.duration;
    tmploc.ampscale = 1;
    if (ksfse_slicecheck) {
      tmploc.board = ZGRAD;
      tmploc.pos -= ksfse.selrfrecover.grad.ramptime;
    } else {
      tmploc.board = XGRAD;
    }
    if (ks_pg_trap(&ksfse.readdephaser, tmploc, &ksfse.seqctrl) == FAILURE)
      return FAILURE;

    /* Place excitation pulse */
    tmploc.board = ZGRAD;
    tmploc.pos = lastReadoutCenter + ksfse_esp - ksfse.selrfrecover.rf.start2iso - ksfse.selrfrecover.grad.ramptime - ksfse.selrfrecover.pregrad.duration;

    if (ksfse_recovery == KSFSE_RECOVERY_FAST) {
      tmploc.ampscale = -1;
    } else { /* = KSFSE_RECOVERY_T1WOPT */
      tmploc.ampscale = 1;
    }
    if (ks_pg_selrf(&ksfse.selrfrecover, tmploc, &ksfse.seqctrl) == FAILURE)
      return FAILURE;
    tmploc.ampscale = 1;

    /* spoiler pos */
    spoiler_pos = tmploc.pos + ksfse.selrfrecover.pregrad.duration + ksfse.selrfrecover.grad.duration;

  } else {

    /* spoiler pos */
    spoiler_pos = ksfse.seqctrl.momentstart + opetl * ksfse_esp + ksfse.read.grad.duration - ksfse.read.time2center - ksfse.read.acqdelay + ksfse.phaseenc.grad.duration;

  } /* ksfse_recovery */

  /*******************************************************************************************************
   *  Gradient spoiler on Y
   *******************************************************************************************************/
  tmploc.board = YGRAD;
  tmploc.pos = spoiler_pos;
  tmploc.ampscale = 1;
  if (ks_pg_trap(&ksfse.spoiler, tmploc, &ksfse.seqctrl) == FAILURE)
    return FAILURE;
  tmploc.pos += ksfse.spoiler.duration;
  ksfse_spoilamp(&ksfse.phaseenc_plan, &ksfse.spoiler, ksfse.phaseenc.res, 0);


 /*******************************************************************************************************
   *  Set the minimal sequence duration (ksfse.seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  tmploc.pos = RUP_GRD(tmploc.pos);

#ifdef HOST_TGT
  /* On HOST only: Sequence duration (ksfse.seqctrl.ssi_time must be > 0 and is added to ksfse.seqctrl.min_duration in ks_eval_seqctrl_setminduration() */
  ksfse.seqctrl.ssi_time = ksfse_eval_ssitime();
  ks_eval_seqctrl_setminduration(&ksfse.seqctrl, tmploc.pos); /* tmploc.pos now corresponds to the end of last gradient in the sequence */
#endif

  return SUCCESS;

} /* ksfse_pg() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: SCAN in @pg section (functions accessible to both HOST and TGT)
 *
 *  Here are functions related to the scan process (ksfse_scan_***) that have to be placed here in @pg
 *  (not @rsp) to make them also accessible on HOST in order to enable scan-on-host for TR timing
 *  in my_cveval()
 *
 *******************************************************************************************************
 *******************************************************************************************************/



/**
 *******************************************************************************************************
 @brief #### Sets the current state of all ksfse sequence objects being part of KSFSE_SEQUENCE

 This function sets the current state of all ksfse sequence objects being part of KSFSE_SEQUENCE, incl.
 gradient amplitude changes, RF freq/phases and receive freq/phase based on current slice position and
 phase encoding indices.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more. This could for example be useful when certain lines or slices
 need to be rescanned due to image artifacts detected during scanning.

 @param[in] slice_info Position of the slice to be played out (one element in the `ks_scan_info[]` array)
 @param[in] shot `shot` index in range `[0, ksfse.phaseenc_plan.num_shots - 1]`
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_scan_seqstate(SCAN_INFO slice_info, int shot) {
  int i;
  float rfphase = 0.0;
  KS_PHASEENCODING_COORD coord;

  ks_scan_rotate(slice_info);

  ks_scan_selrf_setfreqphase(&ksfse.selrfexc,    0,        slice_info, rfphase /* [deg] */);
  ks_scan_selrf_setfreqphase(&ksfse.selrfref1st, INSTRALL, slice_info, rfphase + 90 /* [deg] */);
  ks_scan_selrf_setfreqphase(&ksfse.selrfref2nd, INSTRALL, slice_info, rfphase + 90 /* [deg] */);
  ks_scan_selrf_setfreqphase(&ksfse.selrfref,    INSTRALL, slice_info, rfphase + 90 /* [deg] */);
  if (ksfse_recovery) {
    ks_scan_selrf_setfreqphase(&ksfse.selrfrecoverref, INSTRALL, slice_info, rfphase + 90 /* [deg] */);
    ks_scan_selrf_setfreqphase(&ksfse.selrfrecover, 0, slice_info, rfphase /* [deg] */);
  }

  /* FOV offsets (by changing freq/phase of ksfse.read) */
  if (shot >= 0) {
    for (i = 0; i < ksfse.phaseenc_plan.etl; i++) {

      coord = ks_phaseencoding_get(&ksfse.phaseenc_plan, i, shot);

      if (KS_3D_SELECTED) {
        float zfovratio = (opslquant * opslthick) / opfov;
        float zchop_phase = 0.0;
        if (oparc && (coord.kz % 2)) {
          /* GEs ARC recon ignores RHF_ZCHOP bit in 'rhformat', but expects 3D data to be z-chopped for proper slice sorting.
          In GERequired.e:GEReq_predownload_setrecon_voldata(), RHF_ZCHOP is unset by default. In combination with
          that we do not do zchop for non-ARC scans (incl ASSET), this works well. But for ARC scans, we must zchop. That is,
          we add 180 phase to every odd kz encoded line, which is the same as a final z fftshift in the image domain */
          zchop_phase = 180.0;
        }
        ks_scan_offsetfov3D(&ksfse.read, i, slice_info, coord.ky, opphasefov, coord.kz, zfovratio, rfphase + zchop_phase);
      } else {
        ks_scan_offsetfov(&ksfse.read, i, slice_info, coord.ky, opphasefov, rfphase);
      }

    } /* etl */
  } /* shot > 0 */

  /* change phase encoding amplitudes */
  ksfse_etlphaseamps(&ksfse.phaseenc_plan, &ksfse.phaseenc, (KS_3D_SELECTED) ? &ksfse.zphaseenc : NULL, shot);

  /* change spoiler amplitude */
  ksfse_spoilamp(&ksfse.phaseenc_plan, &ksfse.spoiler, ksfse.phaseenc.res, shot);

  /* Turn off T1-w opt. in DDAs */
  if ((ksfse_recovery) && (shot < 0)) {
    ks_scan_rf_off(&ksfse.selrfrecover.rf, 0);
    ks_scan_rf_off(&ksfse.selrfrecoverref.rf, 0);
  }

  return SUCCESS;

} /* ksfse_scan_seqstate() */




/**
 *******************************************************************************************************
 @brief #### Sets all RF pulse amplitudes to zero

 @return void
********************************************************************************************************/
void ksfse_scan_rf_off() {
  ks_scan_rf_off(&ksfse.selrfexc.rf,    INSTRALL);
  ks_scan_rf_off(&ksfse.selrfref1st.rf, INSTRALL);
  ks_scan_rf_off(&ksfse.selrfref2nd.rf, INSTRALL);
  ks_scan_rf_off(&ksfse.selrfref.rf,    INSTRALL);
  ks_scan_rf_off(&ksfse.selrfrecover.rf, INSTRALL);
  ks_scan_rf_off(&ksfse.selrfrecoverref.rf, INSTRALL);
} /* ksfse_scan_rf_off() */



/**
 *******************************************************************************************************
 @brief #### Sets all RF pulse amplitudes on

 @return void
********************************************************************************************************/
void ksfse_scan_rf_on() {
  ks_scan_rf_on(&ksfse.selrfexc.rf,    INSTRALL);
  ks_scan_rf_on(&ksfse.selrfref1st.rf, INSTRALL);
  ks_scan_rf_on(&ksfse.selrfref2nd.rf, INSTRALL);
  ks_scan_rf_on(&ksfse.selrfref.rf,    INSTRALL);
  ks_scan_rf_on(&ksfse.selrfrecover.rf, INSTRALL);
  ks_scan_rf_on(&ksfse.selrfrecoverref.rf, INSTRALL);
}



/**
 *******************************************************************************************************
 @brief #### Plays out one slice in real time during scanning together with other active sequence modules

  On TGT on the MR system (PSD_HW), this function sets up (ksfse_scan_seqstate()) and plays out the
  core ksfse sequence with optional sequence modules also called in this function. The low-level
  function call `startseq()`, which actually starts the realtime sequence playout is called from within
  ks_scan_playsequence(), which in addition also returns the time to play out that sequence module (see
  time += ...).

  On HOST (in ksfse_eval_tr()) we call ksfse_scan_sliceloop_nargs(), which in turn calls this function
  that returns the total time in [us] taken to play out this core slice. These times are increasing in
  each parent function until ultimately ksfse_scan_scantime(), which returns the total time of the
  entire scan.

  After each call to ks_scan_playsequence(), ks_plot_slicetime() is called to add slice-timing
  information on file for later PNG/PDF-generation of the sequence. As scanning is performed in real-time
  and may fail if interrupted, ks_plot_slicetime() will return quietly if it detects both IPG (TGT)
  and PSD_HW (on the MR scanner). See predownload() for the PNG/PDF generation.

  @param[in] slice_pos Position of the slice to be played out (one element in the global
                      `ks_scan_info[]` array)
  @param[in] dabslice  0-based slice index for data storage
  @param[in] shot `shot` index (over ky and kz)
  @param[in] exc Excitation index in range `[0, NEX-1]`, where NEX = number of excitations (opnex)
  @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksfse_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, /* psd specific: */ int shot, int exc) {
  int i;
  int dabop, dabview, acqflag;
  int time = 0;
  float tloc = 0.0;
  KS_PHASEENCODING_COORD coord;

  if (slice_pos != NULL)
    tloc = slice_pos->optloc;


  /*******************************************************************************************************
  * SpSat sequence module
  *******************************************************************************************************/
  time += ksspsat_scan_playsequences(ks_perform_slicetimeplot);


  /*******************************************************************************************************
  * Chemsat sequence module
  *******************************************************************************************************/
  kschemsat_scan_seqstate(&kschemsat);
  time += ks_scan_playsequence(&kschemsat.seqctrl);
  ks_plot_slicetime(&kschemsat.seqctrl, 1, NULL, KS_NOTSET, slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD); /* no slice location for fat sat */


  /*******************************************************************************************************
  * ksfse main sequence module
  *******************************************************************************************************/
  if (slice_pos != NULL) {
    ksfse_scan_rf_on();
    ksfse_scan_seqstate(*slice_pos, (ksfse_noph != PSD_ON) ? shot : KS_NOTSET); /* shot. if = KS_NOTSET, no phase encodes */
  } else {
    ksfse_scan_rf_off(); /* false slice, shut off RF pulses */
  }


  for (i = 0; i < ksfse.read.acq.base.ngenerated; i++) {
    /* N.B.: Looping over ksfse.read.acq.base.ngenerated corresponds to:
       HOST: No looping since ksfse.read.acq.base.ngenerated is 0 on HOST
       TGT: ETL.
       This protects calls to loaddab() on HOST
    */
    coord = ks_phaseencoding_get(&ksfse.phaseenc_plan, i, shot);

    /* data routing control */
    acqflag = (shot >= 0 && slice_pos != NULL && coord.ky >= 0 && dabslice >= 0) ? DABON : DABOFF; /* open or close data receiver */
    dabop = (exc <= 0) ? DABSTORE : DABADD; /* replace or add to data */

    if (KS_3D_SELECTED) {
      if (ks_scan_info[1].optloc > ks_scan_info[0].optloc)
        dabslice = (opslquant * opvquant - 1) - coord.kz;
      else
        dabslice = coord.kz;
    }

    dabview = (shot >= 0) ? coord.ky : KS_NOTSET;

    if (ksfse.phaseenc.R > 1 && ksfse.phaseenc.nacslines == 0 && dabview != KS_NOTSET) {
      /* ASSET case triggered by R > 1 and no ACS lines */
      dabview /= ksfse.phaseenc.R; /* store in compressed BAM without empty non-acquired lines */
    }

    loaddab(&ksfse.read.acq.echo[i], dabslice, 0, dabop, dabview + 1, acqflag, PSD_LOAD_DAB_ALL); /* see epicfuns.h for alternatives to loaddab() */

  } /* etl */

  time += ks_scan_playsequence(&ksfse.seqctrl);
  ks_plot_slicetime(&ksfse.seqctrl, 1, &tloc, opslthick, slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD);

  return time; /* in [us] */

} /* ksfse_scan_coreslice() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksfse_scan_coreslice() with standardized input arguments

 KSInversion.e has functions (ksinv_eval_multislice(), ksinv_eval_checkTR_SAR() and
 ksinv_scan_sliceloop()) that expect a standardized function pointer to the coreslice function of a main
 sequence. When inversion mode is enabled for the sequence, ksinv_scan_sliceloop() is used instead of
 ksfse_scan_sliceloop() in ksfse_scan_acqloop(), and the generic ksinv_scan_sliceloop() function need a
 handle to the coreslice function of the main sequence.

 In order for these `ksinv_***` functions to work for any pulse sequence they need a standardized
 function pointer with a fixed set of input arguments. As different pulse sequences may need different
 number of input arguments (with different meaning) this ksfse_scan_coreslice_nargs() wrapper function
 provides the argument translation for ksfse_scan_coreslice().

 The function pointer must have SCAN_INFO and slice storage index (dabslice) as the first two input
 args, while remaining input arguments (to ksfse_scan_coreslice()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksfse_scan_coreslice().

 @param[in] slice_pos Pointer to the SCAN_INFO struct corresponding to the current slice to be played out
 @param[in] dabslice  0-based slice index for data storage
 @param[in] nargs Number of extra input arguments to ksfse_scan_coreslice() in range [0,2]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksfse_scan_coreslice()
 @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksfse_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args) {
  int shot = 0;
  int exc = 0;

  if (nargs < 0 || nargs > 2) {
    ks_error("%s: 4th arg (void **) must contain up to 2 elements in the following order: shot, exc", __FUNCTION__);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 4th arg (void **) cannot be NULL if nargs (3rd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    shot = *((int *) args[0]);
  }
  if (nargs >= 2 && args[1] != NULL) {
    exc = *((int *) args[1]);
  }

  return ksfse_scan_coreslice(slice_pos, dabslice, /* psd specific: */ shot, exc); /* in [us] */

} /* ksfse_scan_coreslice_nargs() */




/**
 *******************************************************************************************************
 @brief #### Plays out `slperpass` slices corresponding to one TR

 This function gets a spatial slice location index based on the pass index and temporal position within
 current pass. It then calls ksfse_scan_coreslice() to play out one coreslice (i.e. the main ksfse main
 sequence + optional sequence modules, excluding inversion modules).

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] passindx  Pass index in range [0, ks_slice_plan.npasses - 1]
 @param[in] shot `shot` index in range `[0,  ksfse.phaseenc_plan.num_shots - 1]`
 @param[in] exc Excitation index in range `[0, NEX-1]`, where NEX = number of excitations (opnex)
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksfse_scan_sliceloop(int slperpass, int passindx, int shot, int exc) {
  int time = 0;
  int slloc, sltimeinpass;
  SCAN_INFO centerposition = ks_scan_info[0]; /* first slice chosen here, need only rotation stuff */

  if (KS_3D_SELECTED) {
    int centerslice = opslquant/2;
    /* for future 3D multislab support, let passindx update centerposition */
    centerposition.optloc = (ks_scan_info[centerslice-1].optloc + ks_scan_info[centerslice].optloc)/2.0;
  }

  for (sltimeinpass = 0; sltimeinpass < slperpass; sltimeinpass++) {

    SCAN_INFO *current_slice = &centerposition;

    if (!KS_3D_SELECTED) { /* 2D */
      /* slice location from slice plan */
      slloc = ks_scan_getsliceloc(&ks_slice_plan, passindx, sltimeinpass);

      /* if slloc = KS_NOTSET, pass in NULL as first argument to indicate 'false slice' */
      current_slice = (slloc != KS_NOTSET) ? &ks_scan_info[slloc]: NULL;
    }

    time += ksfse_scan_coreslice(current_slice, sltimeinpass, shot, exc);

  }

  return time; /* in [us] */

} /* ksfse_scan_sliceloop() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksfse_scan_sliceloop() with standardized input arguments

 For TR timing heat/SAR calculations of regular 2D multislice sequences, GEReq_eval_TR(),
 ks_eval_mintr() and GEReq_eval_checkTR_SAR() use a standardized function pointer with a fixed set of
 input arguments to call the sliceloop of the main sequence with different number of slices to check
 current slice loop duration. As different pulse sequences may need different number of input arguments
 (with different meaning) this ksfse_scan_sliceloop_nargs() wrapper function provides the argument
 translation for ksfse_scan_sliceloop().

 The function pointer must have an integer corresponding to the number of slices to use as its first
 argument while the remaining input arguments (to ksfse_scan_sliceloop()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksfse_scan_sliceloop().

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] nargs Number of extra input arguments to ksfse_scan_sliceloop() in range [0,4]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksfse_scan_sliceloop()
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksfse_scan_sliceloop_nargs(int slperpass, int nargs, void **args) {
  int passindx = 0;
  int shot = KS_NOTSET;   /* off */
  int exc = 0;

  if (nargs < 0 || nargs > 3) {
    ks_error("%s: 3rd arg (void **) must contain up to 3 elements: passindx, shot, exc", __FUNCTION__);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 3rd arg (void **) cannot be NULL if nargs (2nd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    passindx = *((int *) args[0]);
  }
  if (nargs >= 2 && args[1] != NULL) {
    shot = *((int *) args[1]);
  }
  if (nargs >= 3 && args[2] != NULL) {
    exc = *((int *) args[2]);
  }

  return ksfse_scan_sliceloop(slperpass, passindx, shot, exc); /* in [us] */

} /* ksfse_scan_sliceloop_nargs() */




/**
 *******************************************************************************************************
 @brief #### Plays out all phase encodes for all slices belonging to one pass

 This function traverses through all shots (`ksfse.phaseenc_plan.num_shots`) to be played out and runs the
 ksfse_scan_sliceloop() for each set of shots and excitation. If ksfse_dda > 0, dummy scans
 will be played out before the phase encoding begins.

 In the case of inversion, ksinv_scan_sliceloop() is called instead of ksfse_scan_sliceloop(), where
 the former takes a function pointer to ksfse_scan_coreslice_nargs() in order to be able to play out
 the coreslice in a timing scheme set by ksinv_scan_sliceloop().

 @param[in] passindx  0-based pass index in range `[0, ks_slice_plan.npasses - 1]`
 @retval passlooptime Time taken in [us] to play out all phase encodes and excitations for `slperpass`
                      slices. Note that the value is a `float` instead of `int` to avoid int overrange
                      at 38 mins of scanning
********************************************************************************************************/
float ksfse_scan_acqloop(int passindx) {
  float time = 0.0;
  int shot, exc;

  for (shot = -ksfse_dda; shot < ksfse.phaseenc_plan.num_shots; shot++) {

    /* shot < 0 means dummy scans, and is handled in ksfse_scan_coreslice(), ksfse_scan_seqstate() and ksfse_etlphaseamps() */

    if (shot == 0 && ksfse_dda > 0) {
      ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_DUMMY);
    }

    for (exc = 0; exc < (int) ceil(opnex); exc++) { /* ceil rounds up opnex < 1 (used for partial Fourier) to 1 */

      if (ksinv1.params.irmode != KSINV_OFF) {
        void *args[2] = {(void *) &shot, (void *) &exc}; /* pass on args via ksinv_scan_sliceloop() to ksfse_scan_coreslice() */
        int nargs = sizeof(args) / sizeof(void *);
        time += (float) ksinv_scan_sliceloop(&ks_slice_plan, ks_scan_info, passindx, &ksinv1, &ksinv2, &ksinv_filltr,
                                              (shot < 0) ? KSINV_LOOP_DUMMY : KSINV_LOOP_NORMAL, ksfse_scan_coreslice_nargs, nargs, args);
      } else {
        time += (float) ksfse_scan_sliceloop(ks_slice_plan.nslices_per_pass, passindx, shot, exc);
      }

      ks_plot_slicetime_endofslicegroup("ksfse shots");

    } /* for exc */

    /* save a frame of the main sequence for later generation of an animated GIF (only in MgdSim, WTools) */
    if (shot >= 0) {
      ks_plot_tgt_addframe(&ksfse.seqctrl);
    }

  } /* for shot */

  ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_STANDARD);
  return time; /* in [us] */

} /* ksfse_scan_acqloop() */




/**
 *******************************************************************************************************
 @brief #### Plays out all volumes and passes of a single or multi-pass scan

 This function performs the entire scan and traverses through passes and volumes. For now, since
 `opmph = 0` as multiphase is controlled outside the psd via PSD_IOPT_DYNPL, opfphases will always be 1.
 For each `passindx` (in range `[0, ks_slice_plan.npasses-1]`), ksfse_scan_acqloop() will be called to
 acquire all data for the current set of slices belong to the current pass (acquisition). At the end of
 each pass, GEReq_endofpass() is called to trigger GE's recon and to dump Pfiles (if `autolock = 1`).

 @retval scantime Total scan time in [us] (`float` to avoid int overrange after 38 mins)
********************************************************************************************************/
float ksfse_scan_scanloop() {
  float time = 0.0;

  for (volindx = 0; volindx < opfphases; volindx++) { /* opfphases is # volumes (BUT: opfphases always 1 since opmph = 0) */

    for (passindx = 0; passindx < ks_slice_plan.npasses; passindx++) { /* acqs = passes */

      time += ksfse_scan_acqloop(passindx);

#ifdef IPG
      GEReq_endofpass();
#endif

    } /* end: acqs (pass) loop */

  } /* end: volume loop */

  return time; /* in [us] */

} /* ksfse_scan_acqloop() */





@rspvar
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: RSP variables (accessible on HOST and TGT). Global variables that are used
 *  by multiple functions in scan(). RSP variables can be viewed live on the MR scanner by Display RSP
 *  in the SCAN menu
 *
 *******************************************************************************************************
 *******************************************************************************************************/

int volindx, passindx;



@rsp
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: SCAN in @rsp section (functions only accessible on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/**
 *******************************************************************************************************
 @brief #### Common initialization for prescan entry points MPS2 and APS2 as well as the SCAN entry point
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksfse_scan_init(void) {

  GEReq_initRSP();

  /* Here goes code common for APS2, MPS2 and SCAN */

  ks_scan_switch_to_sequence(&ksfse.seqctrl);  /* switch to main sequence */
  scopeon(&seqcore); /* Activate scope for core */
  syncon(&seqcore);  /* Activate sync for core */
  setssitime(ksfse.seqctrl.ssi_time / HW_GRAD_UPDATE_TIME);

  /* can we make these independent on global rsptrigger and rsprot in orderslice? */
  settriggerarray( (short) ks_slice_plan.nslices_per_pass, rsptrigger);

  return SUCCESS;

} /* ksfse_scan_init() */




/**
 *******************************************************************************************************
 @brief #### Prescan loop called from both APS2 and MPS2 entry points
 @retval STATUS `SUCCESS` or `FAILURE`
*******************************************************************************************************/
STATUS ksfse_scan_prescanloop(int nloops, int dda) {
  int i, echoindx, sltimeinpass, slloc;
  int centerecho = IMin(2, opetl-1, opte / ksfse_esp);

  /* turn off receivers for all echoes */
  for (echoindx = 0; echoindx < ksfse.read.acq.base.ngenerated; echoindx++) {
    loaddab(&ksfse.read.acq.echo[echoindx], 0, 0, DABSTORE, 0, DABOFF, PSD_LOAD_DAB_ALL);
  }

  /* play dummy scans to get into steady state */
  for (i = -dda; i < nloops; i++) {

    /* loop over slices */
    for (sltimeinpass = 0; sltimeinpass < ks_slice_plan.nslices_per_pass; sltimeinpass++) {

      /* slice location from slice plan */
      slloc = ks_scan_getsliceloc(&ks_slice_plan, 0, sltimeinpass);

      if (slloc != KS_NOTSET) {
        /* modify sequence for next playout */
        ksfse_scan_rf_on();
        ksfse_scan_seqstate(ks_scan_info[slloc], KS_NOTSET); /* KS_NOTSET => no phase encodes */

      } else {
        ksfse_scan_rf_off();
      }

      /* data routing control */
      if (i >= 0) {
        /* turn on receiver for center echo */
        loaddab(&ksfse.read.acq.echo[centerecho], 0, 0, DABSTORE, 0, DABON, PSD_LOAD_DAB_ALL);
      }

      ks_scan_playsequence(&ksfse.seqctrl);

    } /* for slices */

  } /* for nloops */


  return SUCCESS;

} /* ksfse_scan_prescanloop() */
