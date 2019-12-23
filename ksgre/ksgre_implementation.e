/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename	: ksgre_implementation.e
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
* @file ksgre_implementation.e
* @brief This file contains the implementation details for the *ksgre* psd
********************************************************************************************************/

@global

#define KSGRE_MINHNOVER 16
#define KSGRE_DEFAULT_SSI_TIME 200 /* which may allow us to use the same SSI for other sequence modules too */
#define KSGRE_DEFAULT_SSI_TIME_SSFP 100

#ifndef GEREQUIRED_E
#error GERequired.e must be inlined before ksgre_implementation.e
#endif

/** @brief #### `typedef struct` holding all all gradients and waveforms for the ksgre sequence
*/
typedef struct KSGRE_SEQUENCE {
  KS_SEQ_CONTROL seqctrl; /**< Control object keeping track of the sequence and its components */
  KS_READTRAP read; /**< Readout trapezoid including data acquisition window */
  KS_TRAP readdephaser; /**< Static dephaser for readout trapezoid */
  KS_TRAP readrephaser_ssfp; /**< Static dephaser for readout trapezoid (SSFP design) */
  KS_PHASER phaseenc; /**< Phase encoding (YGRAD). 2D & 3D */
  KS_PHASER zphaseenc; /**< 3D: Second phase encoding (ZGRAD) */
  KS_TRAP spoiler; /**< Gradient spoiler at the end of sequence */
  KS_SELRF selrfexc; /**< Excitation RF pulse with slice select and rephasing gradient */
  KS_TRAP fcompread; /**< Extra gradient for flowcomp in read direction */
  KS_TRAP fcompslice; /**< Extra gradient for flowcomp in slice direction */
  KS_PHASEENCODING_PLAN phaseenc_plan; /**<  Phase encoding plan, for 2D and 3D use */
} KSGRE_SEQUENCE;
#define KSGRE_INIT_SEQUENCE {KS_INIT_SEQ_CONTROL, KS_INIT_READTRAP, KS_INIT_TRAP, KS_INIT_TRAP, \
                             KS_INIT_PHASER, KS_INIT_PHASER, KS_INIT_TRAP, KS_INIT_SELRF, KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_PHASEENCODING_PLAN};



@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/*****************************************************************************************************
* RF Excitation
*****************************************************************************************************/
float ksgre_excthickness = 0;
float ksgre_gscalerfexc = 0.9; /* default gradient scaling for slice thickness */
int ksgre_slicecheck = 0 with {0.0, 1.0, 0.0, VIS, "move readout to z axis for slice thickness test",};
float ksgre_spoilerarea = 1500.0 with {0.0, 10000.0, 1500.0, VIS, "ksgre spoiler gradient area",};
int ksgre_sincrf = 0 with {0, 1, 0, VIS, "Use Sinc RF",};
float ksgre_sincrf_bw = 2500 with {0, 100000, 2500, VIS, "Sinc RF BW",};
float ksgre_sincrf_tbw = 2 with {2, 100, 2, VIS, "Sinc RF TBW",};
int ksgre_rfexc_choice = 0 with {0, 2, 0, VIS, "RF pulse 0(fast)-1-2(high FA)",};

/*****************************************************************************************************
* Readout(s)
*****************************************************************************************************/
int ksgre_kxnover = 32 with {KSGRE_MINHNOVER, 512, 32, VIS, "Num kx overscans for minTE",};
int ksgre_rampsampling = FALSE with {FALSE, TRUE, FALSE, VIS, "Rampsampling [0:OFF 1:ON]",};
int ksgre_extragap = 0 with {0, 100ms, 0, VIS, "extra gap between readouts [us]",};

/*****************************************************************************************************
* Phase encoding
*****************************************************************************************************/
int ksgre_minacslines  = 8 with {0, 512, 8, VIS, "Minimum ACS lines for ARC",};
int ksgre_minzacslines = 8 with {0, 512, 8, VIS, "Minimum z ACS lines for ARC",};

/*****************************************************************************************************
*  Sequence general
*****************************************************************************************************/
int ksgre_pos_start = KS_RFSSP_PRETIME with {0, , KS_RFSSP_PRETIME, VIS, "us from start until the first waveform begins",};
int ksgre_ssi_time = KSGRE_DEFAULT_SSI_TIME with {32, , KSGRE_DEFAULT_SSI_TIME, VIS, "time from eos to ssi in intern trig",};
int ksgre_dda = 2 with {0, 200, 2, VIS, "Number of dummy scans for steady state",};
int ksgre_debug = 1 with {0, 100, 1, VIS, "Write out e.g. plot files (unless scan on HW)",};
int ksgre_imsize = KS_IMSIZE_MIN256 with {KS_IMSIZE_NATIVE, KS_IMSIZE_MIN256, KS_IMSIZE_MIN256, VIS, "img. upsamp. [0:native 1:pow2 2:min256]"};
int ksgre_abort_on_kserror = FALSE with {0, 1, 0, VIS, "Hard program abort on ks_error [0:OFF 1:ON]",};;
int ksgre_ellipsekspace = TRUE with {FALSE, TRUE, TRUE, VIS, "ky-kz coverage 0:Rect 1:Elliptical",};

/*****************************************************************************************************
* Temporary CVs for testing
*****************************************************************************************************/
float ksgre_fattune = 0;

@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/* the KSGRE Sequence object */
KSGRE_SEQUENCE ksgre = KSGRE_INIT_SEQUENCE;

/* extra padding time at the end of sequence for bSSFP (FIESTA) */
int ksgre_ssfp_endtime = 0;


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: Host declarations
 *
 *******************************************************************************************************
 *******************************************************************************************************/

abstract("GRE [KSFoundation]");
psdname("ksgre");

/* function prototypes */
STATUS ksgre_pg(int);
int ksgre_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, int shot, int exc);
int ksgre_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args);
int ksgre_scan_sliceloop(int slperpass, int passindx, int shot, int exc);
int ksgre_scan_sliceloop_nargs(int slperpass, int nargs, void **args);
float ksgre_scan_acqloop(int); /* float since scan clock will be 0:00 if scan time > 38 mins otherwise */
float ksgre_scan_scanloop();
int ksgre_eval_ssitime();
STATUS ksgre_scan_seqstate(SCAN_INFO slice_info, int shot);
#include "epic_iopt_util.h"
#include <psdiopt.h>


/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: CVINIT
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

  PSD_IOPT_DYNPL mode is used for this PSD (ksgre)
********************************************************************************************************/
int sequence_iopts[] = {
  PSD_IOPT_ARC, /* oparc */
  PSD_IOPT_ASSET, /* opasset */
  PSD_IOPT_EDR, /* opptsize */
  PSD_IOPT_DYNPL, /* opdynaplan */
  PSD_IOPT_SEQUENTIAL, /* opirmode */
  PSD_IOPT_ZIP_512, /* opzip512 */
  PSD_IOPT_IR_PREP, /* opirprep */
  PSD_IOPT_MILDNOTE, /* opsilent */
  PSD_IOPT_FLOW_COMP, /* opfcomp */
#ifdef UNDEF
  PSD_IOPT_ZIP_1024, /* opzip1024 */
  PSD_IOPT_SLZIP_X2, /* opzip2 */
  PSD_IOPT_MPH, /* opmph */
  PSD_IOPT_NAV, /* opnav */
#endif
};




/**
 *******************************************************************************************************
 @brief #### Initial handling of imaging options buttons and top-level CVs at the PSD type-in page
 @return void
********************************************************************************************************/
void ksgre_init_imagingoptions(void) {
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

  if (oppseq == PSD_SSFP) {
    /* Sequential forced on SSFP to keep TR minimal, i.e. one slice at a time */
    set_required_disabled_option(PSD_IOPT_SEQUENTIAL);
    set_disallowed_option(PSD_IOPT_CARD_GATE);
  }

  /* This is likely good for PSD_3DM scans: 
  if (KS_3D_MULTISLAB_SELECTED) {
    set_required_disabled_option(PSD_IOPT_SEQUENTIAL);
  }
  */

#ifdef SIM
  oppseq = PSD_GE;
  setexist(oppseq, PSD_ON);
  opirmode = PSD_OFF; /* default interleaved slices */
  setexist(opirmode, PSD_ON);
#endif

} /* ksgre_init_imagingoptions() */




/**
 *******************************************************************************************************
 @brief #### Initial setup of user interface (UI) with default values for menus and fields
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_init_UI(void) {

  /* Gradient Echo Type of sequence */
  acq_type = TYPGRAD; /* loadrheader.e rheaderinit: sets eeff = 1 */

  /* rampsampling on by default for SSFP scans to reduce TE & TR */
  ksgre_rampsampling = (oppseq == PSD_SSFP) ? TRUE : FALSE;

  /* rBW */
  if (oppseq == PSD_SSFP /* = 4 */) {
    cvdef(oprbw, 125.0);
    pircbval2 = 31.25;
    pircbval3 = 41.67;
    pircbval4 = 50.0;
    pircbval5 = 62.50;
    pircbval6 = 125.0;
  } else {
    cvdef(oprbw, 31.25);
    pircbval2 = 13.89;
    pircbval3 = 31.25;
    pircbval4 = 41.67;
    pircbval5 = 50.0;
    pircbval6 = 62.50;
  }
  oprbw = _oprbw.defval;
  cvmax(oprbw, 250);
  pidefrbw = _oprbw.defval;
  pircbnub  = 31; /* number of variable bandwidth */
  pircb2nub = 0; /* no second bandwidth option */

  /* NEX */
  cvdef(opnex, 1);
  opnex = _opnex.defval;
  cvmin(opnex, 0.55);
  pinexnub = 63;
  pinexval2 = 0.55;
  pinexval3 = 0.65;
  pinexval4 = 0.75;
  pinexval5 = 1;
  pinexval6 = 2;

  /* FOV */
  opfov = 240;
  pifovnub = 5;
  pifovval2 = 200;
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
  cvdef(opxres, 128);
  opxres = 128;
  pixresnub = 63;
  pixresval2 = 64;
  pixresval3 = 128;
  pixresval4 = 192;
  pixresval5 = 256;
  pixresval6 = 320;

  /* phase (y) resolution */
  cvmin(opyres, 16);
  cvdef(opyres, 128);
  opyres = _opyres.defval;
  piyresnub = 63;
  piyresval2 = 64;
  piyresval3 = 128;
  piyresval4 = 192;
  piyresval5 = 256;
  piyresval6 = 320;

  /* Num echoes */
  piechnub = 63;
  cvdef(opnecho, 1);
  cvmax(opnecho, 16);
  opnecho = _opnecho.defval;
  piechdefval = _opnecho.defval;
  piechval2 = 1;
  piechval3 = 2;
  piechval4 = 4;
  piechval5 = 8;
  piechval6 = 16;

  /* TE */
  avmaxte = 1s;
  avminte = 0;
  pitetype = PSD_LABEL_TE_NORM; /* alt. PSD_LABEL_TE_EFF */
  cvdef(opte, 20ms);
  opte = _opte.defval;
  if (oppseq == PSD_SSFP) {
    pite1nub = 4;
    opautote = PSD_MINTEFULL;
  } else {
    pite1nub = 63;
  }
  pite1val2 = PSD_MINIMUMTE; /* opautote: PSD_MINTE = 2 */
  pite1val3 = PSD_MINFULLTE; /* opautote: PSD_MINTEFULL = 1 */
  pite1val4 = PSD_FWINPHASETE; /* opautote: PSD_FWINPHS = 3 */
  pite1val5 = PSD_FWOUTPHASETE; /* opautote: PSD_FWOUTPHS = 4 */
  if (cffield == 30000)
    pite1val6 = 18ms; /* for T2*-w */
  else
    pite1val6 = 35ms; /* for T2*-w */

  /* TE2 */
  pite2nub = 0;

  /* TR */
  if (oppseq == PSD_SSFP || opfast == TRUE) {
    pitrnub = 0; /* '0': shown but greyed out (but only if opautotr = 1, otherwise TR menu is hidden) */
    cvoverride(opautotr, PSD_ON, PSD_FIX_OFF, PSD_EXIST_ON);
  } else {
    pitrnub = 6; /* '2': only one menu choice (Minimum = AutoTR) */
  }
  cvdef(optr, 100ms);
  optr = _optr.defval;
  pitrval2 = PSD_MINIMUMTR;
  pitrval3 = 25ms;
  pitrval4 = 35ms;
  pitrval5 = 45ms;
  pitrval6 = 100ms;


  /* FA */
  cvdef(opflip, 10);
  opflip = _opflip.defval;
#if EPIC_RELEASE >= 24
  pifamode = PSD_FLIP_ANGLE_MODE_EXCITE;
#endif
  pifanub = 6;
  if (KS_3D_SELECTED && (oppseq != PSD_SSFP)) {
    pifaval2 = 10;
    pifaval3 = 12;
    pifaval4 = 15;
    pifaval5 = 18;
    pifaval6 = 20;
  } else {
    pifaval2 = 10;
    pifaval3 = 20;
    pifaval4 = 30;
    if (oppseq == PSD_SSFP) {
      pifaval5 = 40;
      pifaval6 = 50;
    } else {
      pifaval5 = 60;
      pifaval6 = 90;
    }
  } 

  /* slice thickness */
  pistnub = 5;
  if (KS_3D_SELECTED) {
    cvdef(opslthick, 1);
    pistval2 = 0.8;
    pistval3 = 0.9;
    pistval4 = 1;
    pistval5 = 1.5;
    pistval6 = 2;
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
    piisnub = 4;
    piisval2 = 0;
    piisval3 = 0.5;
    piisval4 = 1;
    piisval5 = 4;
    piisval6 = 20;
  }

  /* default # of slices */
  cvdef(opslquant, 30);

  /* 3D slice settings */
  if (KS_3D_SELECTED) { /* PSD_3D (=2) or PSD_3DM (=6) */
    pimultislab = 0; /* 0: forces only single slab, 1: allow multi-slab */
    pilocnub = 4;
    pilocval2 = 32;
    pilocval3 = 64;
    pilocval4 = 128;
    /* opslquant = #slices in slab. opvquant = #slabs */
    cvdef(opslquant, 32);
  }

  opslquant = _opslquant.defval;

  /* Multi phase (i.e. multi volumes) */
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
  
  /* For 3D non-SSFP non-Sinc scans, let the user choose between fast scans and high FA */
  cvmod(opuser1, _ksgre_rfexc_choice.minval, _ksgre_rfexc_choice.maxval, _ksgre_rfexc_choice.defval, _ksgre_rfexc_choice.descr, 0, " ");
  opuser1 = _ksgre_rfexc_choice.defval;
  ksgre_rfexc_choice = _ksgre_rfexc_choice.defval;
  if (KS_3D_SELECTED && oppseq != PSD_SSFP && ksgre_sincrf == FALSE) /* PSD_3D or PSD_3DM */
    piuset |= use1;
  else
    piuset &= ~use1;

  /* For 3D, choose between rectangular and elliptic k-space sampling (ky-kz plane) */
  cvmod(opuser2, _ksgre_ellipsekspace.minval, _ksgre_ellipsekspace.maxval, _ksgre_ellipsekspace.defval, _ksgre_ellipsekspace.descr, 0, " ");  
  opuser2 = _ksgre_ellipsekspace.defval;
  ksgre_ellipsekspace = _ksgre_ellipsekspace.defval;
  if (KS_3D_SELECTED) /* PSD_3D or PSD_3DM */
    piuset |= use2;
  else
    piuset &= ~use2;

  /* opuser16: Recon number*/
  cvmod(opuser16, 0, 9999, 0, "Recon number", 0, " ");
  opuser16 = _opuser16.defval;

#ifdef REV
  /* show GIT revision using REV variable from the Imakefile */
  char userstr[100];
  sprintf(userstr,"                      Recon number [PSD's version: %s]", REV);
  cvdesc(opuser16, userstr);
  piuset |= use16;
#endif
  
  /*
     Reserved opusers:
     -----------------
     ksgre_eval_inversion(): opuser26-29
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

} /* ksgre_init_UI() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: CVEVAL
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Gets the current UI and checks for valid inputs
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_UI() {

  if (ksgre_init_UI() == FAILURE)
    return FAILURE;

  ksgre_rfexc_choice = (int) opuser1;

  ksgre_ellipsekspace = (int) opuser2;

  rhrecon = (int) opuser16;

  /* Reserved opusers:
     -----------------
     ksgre_eval_inversion(): opuser26-29
     GE reserves: opuser36-48 (epic.h)
   */

  return SUCCESS;

} /* ksgre_eval_UI() */




/**
 *******************************************************************************************************
 @brief #### Sets up all sequence objects for the main sequence module (KSGRE_SEQUENCE ksgre)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_setupobjects() {
  STATUS status;  

  /* RF choices */
  if (ksgre_sincrf) {
    status = ks_eval_rf_sinc(&ksgre.selrfexc.rf, "", ksgre_sincrf_bw, ksgre_sincrf_tbw, opflip, KS_RF_SINCWIN_HAMMING);
    if (status != SUCCESS) return status;
    ksgre.selrfexc.rf.role = KS_RF_ROLE_EXC;
  } else {
    if (oppseq == PSD_SSFP) {
      if (KS_3D_SELECTED) {
        ksgre.selrfexc.rf = ssfp_tbw3_01_001_pm_250; /* KSFoundation_GERF.h */
      } else {
        /* for now, use 4k BW sinc for 2D SSFP */
        status = ks_eval_rf_sinc(&ksgre.selrfexc.rf, "", 4000, 2, opflip, KS_RF_SINCWIN_HAMMING);
        if (status != SUCCESS) return status;
        ksgre.selrfexc.rf.role = KS_RF_ROLE_EXC;  
      }
    } else {
      if (KS_3D_SELECTED) {
        /* ksgre_rfexc_choice: Low values => shorter TE but lower max FA */
        if (ksgre_rfexc_choice == 0)
          ksgre.selrfexc.rf = exc_tbw8_01_001_150; /* KSFoundation_GERF.h */
        else if (ksgre_rfexc_choice == 1)
          ksgre.selrfexc.rf = exc_3d8min; /* KSFoundation_GERF.h */
        else if (ksgre_rfexc_choice == 2)
          ksgre.selrfexc.rf = exc_3d16min; /* KSFoundation_GERF.h */
      } else {
        ksgre.selrfexc.rf = exc_3dfgre; /* KSFoundation_GERF.h */
      }
    }
  }

  if (KS_3D_SELECTED) {
    cvoverride(opvthick, exist(opslquant) * exist(opslthick), _opslquant.fixedflag, existcv(opslquant));
    ksgre_excthickness = (exist(opslquant) - 2 * rhslblank) * exist(opslthick);
    ksgre_gscalerfexc = 1.0;
  } else {
    ksgre_excthickness = opslthick;
  }

  ksgre.selrfexc.rf.flip = opflip;
  ksgre.selrfexc.slthick = ksgre_excthickness / ksgre_gscalerfexc;

  /* selective RF excitation */
  if (ks_eval_selrf(&ksgre.selrfexc, "rfexc") == FAILURE)
    return FAILURE;


  /* readout gradient and data acquisition */
  ksgre.read.fov = opfov;
  ksgre.read.res = RUP_FACTOR(opxres, 2); /* round up (RUP) to nearest multiple of 2 */
  ksgre.read.rampsampling = ksgre_rampsampling;
  if (ksgre.read.rampsampling)
    ksgre.read.acqdelay = 64; /* us on the ramp until acq should begin */
  if (opautote == PSD_MINTE) { /* PSD_MINTE = 2 */
    ksgre.read.nover = IMin(2,ksgre_kxnover,ksgre.read.res/2); /* Partial Fourier */
  } else {
    ksgre.read.nover = 0; /* Full Fourier */
  }
  ksgre.read.acq.rbw = oprbw;
  if (ks_eval_readtrap(&ksgre.read, "read") == FAILURE)
    return FAILURE;

  /* read dephaser */
  ksgre.readdephaser.area = -ksgre.read.area2center;
  if (ks_eval_trap(&ksgre.readdephaser, "readdephaser") == FAILURE)
    return FAILURE;

  /* read rephaser (SSFP) */
  if (oppseq == PSD_SSFP) {
    ksgre.readrephaser_ssfp.area = ksgre.read.area2center - ksgre.read.grad.area;
    if (ks_eval_trap(&ksgre.readrephaser_ssfp, "readrephaser_ssfp") == FAILURE)
      return FAILURE;
  } else {
    ks_init_trap(&ksgre.readrephaser_ssfp);
  }

  if (opfcomp == TRUE) {
    /* X: Add second x dephaser */
    ksgre.fcompread.area = -ksgre.readdephaser.area;
    if (ks_eval_trap(&ksgre.fcompread, "readdephaser1") == FAILURE)
      return FAILURE;
    
    /* X: Now, make normal readdephaser twice as large */
    ksgre.readdephaser.area *= 2;
    if (ks_eval_trap(&ksgre.readdephaser, "readdephaser2") == FAILURE)
      return FAILURE;

    /* Z: Add second z rephaser to complete 0th and 1st moment nulling of slice selection */
    ksgre.fcompslice.area = -ksgre.selrfexc.postgrad.area;
    if (ks_eval_trap(&ksgre.fcompslice, "rfexc.reph2") == FAILURE)
      return FAILURE;   

    /* Z: Now, make normal z rephaser twice as large */
    ksgre.selrfexc.postgrad.area *= 2;
    if (ks_eval_trap(&ksgre.selrfexc.postgrad, "rfexc.reph1") == FAILURE)
      return FAILURE;

  } else {
    ks_init_trap(&ksgre.fcompread);
    ks_init_trap(&ksgre.fcompslice);
  }

  /* phase encoding gradient */
  ksgre.phaseenc.fov = opfov * opphasefov;
  ksgre.phaseenc.res = RUP_FACTOR((int) (opyres * opphasefov), 2); /* round up (RUP) to nearest multiple of 2 */
  if (ksgre.read.nover == 0 && opnex < 1) {
    int kynover;
    kynover = ksgre.phaseenc.res * (opnex - 0.5);
    kynover = ((kynover + 1) / 2) * 2; /* round to nearest even number */
    if (kynover < KSGRE_MINHNOVER)
      kynover = KSGRE_MINHNOVER; /* protect against too few overscans */
    ksgre.phaseenc.nover = IMin(2, kynover, ksgre.phaseenc.res/2);
  } else {
    ksgre.phaseenc.nover = 0;
  }

  /* set .R and .nacslines fields of ksgre.phaseenc using ks_eval_phaser_setaccel() before calling ks_eval_phaser() */
  if (opasset) {
    cvoverride(ksgre_minacslines, 0, PSD_FIX_OFF, PSD_EXIST_ON);
  } else if (oparc) {
    ksgre_minacslines = _ksgre_minacslines.defval;
  }
  if (ks_eval_phaser_setaccel(&ksgre.phaseenc, ksgre_minacslines, opaccel_ph_stride) == FAILURE)
    return FAILURE;

  if (ks_eval_phaser(&ksgre.phaseenc, "phaseenc") == FAILURE)
    return FAILURE;

  /* z phase encoding gradient */
  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */

    if (opfcomp == TRUE) {
      ksgre.zphaseenc.areaoffset = 0;
    } else {
      ksgre.selrfexc.postgrad.duration = 0; /* disable the slice rephaser gradient (.duration = 0), and put area necessary in zphaseenc.areaoffset */
      ksgre.zphaseenc.areaoffset = ksgre.selrfexc.postgrad.area; /* copy the area info */
    }
    ksgre.zphaseenc.fov = opvthick;
    ksgre.zphaseenc.res = IMax(2, 8, opslquant);
    ksgre.zphaseenc.nover = 0;

    /* set .R and .nacslines fields of ksgre.zphaseenc using ks_eval_phaser_setaccel() before calling ks_eval_phaser() */
    if (opasset) {
      cvoverride(ksgre_minzacslines, 0, PSD_FIX_OFF, PSD_EXIST_ON);
    } else if (oparc) {
      ksgre_minzacslines = _ksgre_minzacslines.defval;
    }
    if (ks_eval_phaser_setaccel(&ksgre.zphaseenc, ksgre_minzacslines, opaccel_sl_stride) == FAILURE)
      return FAILURE;

    if (ks_eval_phaser(&ksgre.zphaseenc, "zphaseenc") == FAILURE)
      return FAILURE;

  } else {

     ks_init_phaser(&ksgre.zphaseenc);

  }

  /* post-read spoiler */
  ksgre.spoiler.area = (opnecho % 2 == 0) ? -1*ksgre_spoilerarea : ksgre_spoilerarea;
  if (ks_eval_trap(&ksgre.spoiler, "spoiler") == FAILURE)
    return FAILURE;

  /* init seqctrl */
  ks_init_seqcontrol(&ksgre.seqctrl);
  strcpy(ksgre.seqctrl.description, "ksgremain");
  ksgre_eval_ssitime();

  return SUCCESS;

} /* ksgre_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Sets the min/max TE based on the durations of the sequence objects in KSGRE_SEQUENCE (ksgre)

 N.B.: The minTE (avminte) and maxTE (avmaxte) ensures TE (opte) to be in the valid range for this pulse
 sequence to be set up in ksgre_pg(). If the pulse sequence design changes in ksgre_pg(), by
 adding/modifying/removing sequence objects in a way that affects the intended TE, this function needs
 to be updated too.

 @retval STATUS `SUCCESS` or `FAILURE`
******************************************************************************************************/
STATUS ksgre_eval_TErange() {
  float fieldscale = (float) B0_15000 / (float) cffield;
  int fatwater_halflap = (fieldscale * 4.47ms) / 2; /* [us] */
  int fatwater_numhalflaps;

  /* Minimum TE. Note that zphaseenc.grad.duration = 0 for 2D and ksgre.selrfexc.postgrad.duration = 0 for 3D */
  avminte = ksgre.selrfexc.rf.iso2end;
  if (ksgre_slicecheck) {
    avminte += ksgre.selrfexc.grad.ramptime + ksgre.selrfexc.postgrad.duration + ksgre.fcompslice.duration + ksgre.zphaseenc.grad.duration + IMax(2, ksgre.readdephaser.duration, ksgre.phaseenc.grad.duration);
  } else {
    avminte += IMax(3, \
        ksgre.fcompread.duration + ksgre.readdephaser.duration + ksgre.read.acqdelay, \
        ksgre.phaseenc.grad.duration, \
        ksgre.selrfexc.grad.ramptime + ksgre.selrfexc.postgrad.duration + ksgre.fcompslice.duration + ksgre.zphaseenc.grad.duration);
  }
  avminte += ksgre.read.time2center - ksgre.read.acqdelay; /* from start of acq win to k-space center */

  if (opautote == PSD_FWINPHS) {
    /* fat-water in-phase */
    avminte = CEIL_DIV(avminte, 2 * fatwater_halflap) * (2 * fatwater_halflap);
  } else if (opautote == PSD_FWOUTPHS) {
    /* fat-water out-of-phase */
    fatwater_numhalflaps = CEIL_DIV(avminte, fatwater_halflap);
    if ((fatwater_numhalflaps % 2) == 0)
      fatwater_numhalflaps++; /* make sure it is odd */
    avminte = fatwater_halflap * fatwater_numhalflaps;
  }

  avminte += GRAD_UPDATE_TIME * 2; /* 8us extra margin */
  avminte = RUP_FACTOR(avminte, 8); /* round up to make time divisible by 8us */

  /* bSSFP (FIESTA): TE = TR/2 */
  if (oppseq == PSD_SSFP) {
    int echocenter2momentstart;
    echocenter2momentstart = ksgre.read.grad.duration - ksgre.read.time2center - ksgre.read.acqdelay; /* end of acqwin */

    echocenter2momentstart += IMax(3, \
    ksgre.read.acqdelay + ksgre.readrephaser_ssfp.duration, \
    ksgre.phaseenc.grad.duration, \
    KS_3D_SELECTED ? ksgre.zphaseenc.grad.duration : ksgre.selrfexc.postgrad.duration); /* end of spoiler/rephaser */

    echocenter2momentstart += ksgre.seqctrl.ssi_time; /* add SSI time. This is end of TR */
    echocenter2momentstart += ksgre_pos_start + ksgre.selrfexc.grad.ramptime + ksgre.selrfexc.rf.start2iso; /* beginning of sequence to momentstart */
    echocenter2momentstart = RUP_GRD(echocenter2momentstart);

    if (avminte <= echocenter2momentstart) {
      avminte += echocenter2momentstart - avminte;
      ksgre_ssfp_endtime = 0;
    } else {
      ksgre_ssfp_endtime = avminte - echocenter2momentstart;
    }
  }

  /* MaxTE. avmaxte = avminte if opautote != FALSE */
  avmaxte = avminte;
  if (opautote == FALSE) {
    if (existcv(optr)) {
      if (opautotr) {
        /* TR = minTR, i.e. the current TE is also the maximum TE */
        if (existcv(opte))
          avmaxte = opte;
      } else {
        /* maximum TE dependent on the chosen TR */
        avmaxte = optr - ksgre.seqctrl.ssi_time; /* maximum sequence duration for this TR (implies one slice per TR) */
        avmaxte -= ksgre.spoiler.duration; /* subtract ksgre.spoiler time */
        avmaxte -= (ksgre.read.grad.duration - ksgre.read.time2center); /* center of k-space to end of read decay ramp + extra gap */
        if (opnecho > 1) {
          avmaxte -= (opnecho - 1) * (ksgre.read.grad.duration + ksgre_extragap); /* for multi-echo */
        }
      }
    } else {
      avmaxte = 1s;
    }
  }

  if (opautote) {
    setpopup(opte, PSD_OFF);
    cvoverride(opte, avminte, PSD_FIX_ON, PSD_EXIST_ON); /* AutoTE: force TE to minimum */
  } else {
    setpopup(opte, PSD_ON);
    if (opte < avminte)
      opte = avminte;
  }

  return SUCCESS;

} /* ksgre_eval_TErange() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to KSInversion functions to add single and dual IR support to this sequence

 N.B.: For now, ksgre.e has the same inversion logic as ksfse.e and this function is similar to
 ksfse_eval_inversion(). This is not used in clinical practice for 3D GRE and should be viewed as a placeholder.
 Once 3D mode is supported with ksgre.e, this section should change to perform an MP-RAGE type or BRAVO type
 of preparation instead.

 It is important that ksgre_eval_inversion() is called after other sequence modules have been set up and
 added to the KS_SEQ_COLLECTION struct in my_cveval(). Otherwise the TI and TR timing will be wrong.

 Whether IR is on or off is determined by ksinv1_mode, which is set up in KSINV_EVAL()->ksinv_eval().
 If it is off, this function will return quietly.

 This function calls ksinv_eval_multislice() (KSInversion.e), which takes over the responsibility of
 TR timing that otherwise is determined in ksgre_eval_tr().
 ksinv_eval_multislice() sets seqcollection.evaltrdone = TRUE, which indicates that TR timing has been done.
 ksgre_eval_tr() checks whether seqcollection.evaltrdone = TRUE to avoid that non-inversion TR timing
 overrides the TR timing set up in ksinv_eval_multislice().

 At the end of this function, TR validation and heat/SAR checks are done.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_inversion(KS_SEQ_COLLECTION *seqcollection) {
  STATUS status;
  int slperpass, npasses;
  int approved_TR = FALSE;

  /* Set up up to four opusers for inversion control */
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

    status = ksinv_eval_multislice(seqcollection, &ks_slice_plan, ksgre_scan_coreslice_nargs, 0, NULL, &ksgre.seqctrl);
    if (status != SUCCESS) return status;

    if (existcv(optr) && opflair == OPFLAIR_INTERLEAVED && optr > ksinv_maxtr_t1flair) {
      /* T1-FLAIR */
      if (npasses > exist(opslquant)) {
        return ks_error("%s: T1-FLAIR: TR not met for single slice per TR", __FUNCTION__);
      }
      npasses++; /* increase #passes and call ksinv_eval_multislice() again with a new ks_slice_plan */
    } else {
      /* non-T1-FLAIR, or T1-FLAIR with approved TR value */
      approved_TR = TRUE;
    }

  } /* while (approved_TR == FALSE)  */


  /* Check TR timing and SAR limits */
  status = ksinv_eval_checkTR_SAR(seqcollection, &ks_slice_plan, ksgre_scan_coreslice_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* ksgre_eval_inversion() */






/**
 *******************************************************************************************************
 @brief #### Evaluation of number of slices / TR, set up of slice plan, TR validation and SAR checks

 With the current sequence collection (see my_cveval()), and a function pointer to an
 argument-standardized wrapper function (ksgre_scan_sliceloop_nargs()) to the slice loop function
 (ksgre_scan_sliceloop(), this function calls GEReq_eval_TR(), where number of slices that can fit
 within one TR is determined by adding more slices as input argument to the slice loop function.
 For more details see GEReq_eval_TR().

 With the number of slices/TR now known, a standard 2D slice plan is set up using ks_calc_sliceplan()
 and the duration of the main sequence is increased based on timetoadd_perTR, which was returned by
 GEReq_eval_TR(). timetoadd_perTR > 0 when optr > avmintr and when heat or SAR restrictions requires
 `avmintr` to be larger than the net sum of sequence modules in the slice loop.

 This function first checks whether seqcollection.evaltrdone == TRUE. This is e.g. the case for inversion
 where the TR timing instead is controlled using ksgre_eval_inversion() (calling ksinv_eval_multislice()).

 At the end of this function, TR validation and heat/SAR checks are done using GEReq_eval_checkTR_SAR().
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_tr(KS_SEQ_COLLECTION *seqcollection) {
  int timetoadd_perTR;
  STATUS status;
  int slperpass, min_npasses;

  if (seqcollection->evaltrdone == TRUE) {
    /* We cannot call GEReq_eval_TR() or GEReq_eval_checkTR_SAR(..., ksgre_scan_sliceloop_nargs, ...) if e.g. the inversion sequence module is used. This is because
     ksinv_scan_sliceloop() is used instead of ksgre_scan_sliceloop(). When ksinv1.params.mode != 0 (i.e. inversion sequence module on), the TR timing is done in
     ksinv_eval_multislice(), which is called from ksgre_eval_inversion().
     In the future, other sequence modules may want to take over the responsibility of TR calculations and SAR checks, in which case they need to end their corresponding function
     by setting evaltrdone = TRUE to avoid double processing here */
    return SUCCESS;
  }

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    min_npasses = 2;
  else
    min_npasses = 1;

   /* Calculate # slices per TR, # acquisitions and how much spare time we have within the current TR by running the slice loop, honoring heating and SAR limits */
  status = GEReq_eval_TR(&slperpass, &timetoadd_perTR, min_npasses, seqcollection, ksgre_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Calculate the slice plan (ordering) and passes (acqs). ks_slice_plan is passed to GEReq_predownload_store_sliceplan() in predownload() */
  if (KS_3D_SELECTED) {
    ks_calc_sliceplan(&ks_slice_plan, exist(opvquant), 1 /* seq 3DMS */);
  } else {
    ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);
  } 
  /* We spread the available timetoadd_perTR evenly, by increasing the .duration of each slice by timetoadd_perTR/slperpass */
  ksgre.seqctrl.duration = RUP_GRD(ksgre.seqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

  /* Update SAR values in the UI (error will occur if the sum of sequence durations differs from optr) */
  status = GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, ksgre_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Fill in the 'tmin' and 'tmin_total'. tmin_total is only like GEs use of the variable when TR = minTR */
  tmin = ksgre.seqctrl.min_duration;
  tmin_total = ksgre.seqctrl.duration;

  return SUCCESS;

} /* ksgre_eval_tr() */




/**
 *******************************************************************************************************
 @brief #### The SSI time for the sequence

 @retval int SSI time in [us]
********************************************************************************************************/
int ksgre_eval_ssitime() {

  /* SSI time CV:
     Empirical finding on how much SSI time we need to update.
     But, use a longer SSI time when we write out data to file in scan() */
  if (KS_3D_SELECTED && (oppseq == PSD_SSFP))
    ksgre_ssi_time = RUP_GRD(IMax(2, KSGRE_DEFAULT_SSI_TIME_SSFP, _ksgre_ssi_time.minval));
  else
    ksgre_ssi_time = RUP_GRD(IMax(2, KSGRE_DEFAULT_SSI_TIME, _ksgre_ssi_time.minval));

  /* Copy SSI CV to seqctrl field used by setssitime() */
  ksgre.seqctrl.ssi_time = RUP_GRD(ksgre_ssi_time);

  /* SSI time one-sequence-off workaround:
     We set the hardware ssitime in ks_scan_playsequence(), but it acts on the next sequence module, hence
     we aren't doing this correctly when using multiple sequence modules (as KSChemSat etc).
     One option would be to add a short dummy sequence ks_scan_playsequence(), but need to investigate
     if there is a better way. For now, let's assume the the necessary update time is the longest for
     the main sequence (this function), and let the ssi time for all other sequence modules (KSChemSat etc)
     have the same ssi time as the main sequence. */
  kschemsat_ssi_time    = ksgre_ssi_time;
  ksspsat_ssi_time      = ksgre_ssi_time;
  ksinv_ssi_time        = ksgre_ssi_time;
  ksinv_filltr_ssi_time = ksgre_ssi_time;

  return ksgre_ssi_time;

} /* ksgre_eval_ssitime() */




/**
 *******************************************************************************************************
 @brief #### Set the number of dummy scans for the sequence and calls ksgre_scan_scanloop() to determine
        the length of the scan

        After setting the number of dummy scans based on the current TR, the ksfse_scan_scanloop() is
        called to get the scan time. `pitscan` is the UI variable for the scan clock shown in the top
        right corner on the MR scanner.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_scantime() {

  /* number of dummy TRs to use to reach steady state */
  if (oppseq == PSD_SSFP)
    ksgre_dda = 20; /* since single-slice, it's quick anyway */
  else
    ksgre_dda = 4;

  /* call the scan loop function to get the total scan time. pitscan is the countdown timer shown in
     the top-right corner on the MR scanner */
  pitscan = ksgre_scan_scanloop();

  return SUCCESS;
}





/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: CVCHECK
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Returns error of various parameter combinations that are not allowed for ksgre
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_check() {

  /* Show resolution & BW per pixel in the UI */
#if EPIC_RELEASE >= 26
  piinplaneres = 1;
  pirbwperpix = 1;
  ihinplanexres = ksgre.read.fov/ksgre.read.res;
  ihinplaneyres = ksgre.phaseenc.fov/ksgre.phaseenc.res;
  ihrbwperpix = (1000.0 * ksgre.read.acq.rbw * 2.0)/ksgre.read.res;
#endif

  /* Force the user to select the Gradient Echo button. This error needs to be in cvcheck(), not in
     cvinit()/cveval() to avoid it to trigger also when Gradient Echo hass been selected */
  if (oppseq == PSD_SE || opepi == PSD_ON) {
    return ks_error("%s: Please first select the 'Gradient Echo' button", ks_psdname);
  }

  /* SSFP symmetric RF watchdog */
  if ((oppseq == PSD_SSFP) && (abs(ksgre.selrfexc.rf.rfwave.duration/2 - ksgre.selrfexc.rf.iso2end) > GRAD_UPDATE_TIME)) {
    return ks_error("ksgre_check: Symmetric RF pulses are required for SSFP scans");
  }

  /* SSFP duration watchdog (to assure TE = TR/2) */
  if (existcv(opte) && existcv(optr) && existcv(opflip) && (oppseq == PSD_SSFP) && (ksgre.seqctrl.duration > ksgre.seqctrl.min_duration)) {
    return ks_error("ksgre_check: SAR/heating penalty - reduce FA");
  }

  if (oparc && KS_3D_SELECTED && (ksgre.zphaseenc.R > ksgre.phaseenc.R)) {
    /* Unclear why, but zR > R leads to corrupted images for ARC and 3D.
    Probably a bug that can be fixed later. Limited experience (July 2018) */
    return ks_error("%s: Need Slice acceleration <= Phase accleration", __FUNCTION__);
  }

  return SUCCESS;

} /* ksgre_check() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: PREDOWNLOAD
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
STATUS ksgre_predownload_plot(KS_SEQ_COLLECTION* seqcollection) {
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
     why we here write to a file ksgre_objects.txt instead */
  ks_print_readtrap(ksgre.read, fp);
  ks_print_trap(ksgre.readdephaser, fp);
  ks_print_trap(ksgre.readrephaser_ssfp, fp);
  ks_print_phaser(ksgre.phaseenc, fp);
  ks_print_phaser(ksgre.zphaseenc, fp);
  ks_print_trap(ksgre.spoiler, fp);
  ks_print_selrf(ksgre.selrfexc, fp);
  fclose(fp);


  /* ks_plot_host():
  Plot each sequence module as a separate file (PNG/SVG/PDF depending on ks_plot_filefmt (GERequired.e))
  See KS_PLOT_FILEFORMATS in KSFoundation.h for options.
  Note that the phase encoding amplitudes corresponds to the first shot, as set by the call to ksgre_scan_seqstate below */
  ksgre_scan_seqstate(ks_scan_info[0], 0);
  ks_plot_host(seqcollection, &ksgre.phaseenc_plan);

  /* Sequence timing plot */
  ks_plot_slicetime_begin();
  ksgre_scan_scanloop();
  ks_plot_slicetime_end();

  /* ks_plot_tgt_reset():
  Creates sub directories and clear old files for later use of ksfse_scan_acqloop()->ks_plot_tgt_addframe().
  ks_plot_tgt_addframe() will only write in MgdSim (WTools) to avoid timing issues on the MR scanner. Hence,
  unlike ks_plot_host() and the sequence timing plot, one has to open MgdSim and press RunEntry (and also
  press PlotPulse several times after pressing RunEntry).
  ks_plot_tgt_reset() will create a 'makegif_***.sh' file that should be run in a terminal afterwards 
  to create the animiated GIF from the dat files */
  ks_plot_tgt_reset(&ksgre.seqctrl);


  return SUCCESS;

}  /* ksgre_predownload_plot() */


/**
 *******************************************************************************************************
 @brief #### Last-resort function to override certain recon variables not set up correctly already

 For most cases, the GEReq_predownload_*** functions in predownload() in ksgre.e set up
 the necessary rh*** variables for the reconstruction to work properly. However, if this sequence is
 customized, certain rh*** variables may need to be changed. Doing this here instead of in predownload()
 directly separates these changes from the standard behavior.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_predownload_setrecon() {

  return SUCCESS;

} /* ksgre_predownload_setrecon() */




@pg
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: PULSEGEN - builing of the sequence from the sequence objects
 *
 *  HOST: Called in cveval() to dry-run the sequence to determine timings
 *  TGT:  Waveforms are being written to hardware and necessary memory automatically alloacted
 *
 *******************************************************************************************************
 *******************************************************************************************************/




/**
 *******************************************************************************************************
 @brief #### The ksgre (main) pulse sequence

 This is the main pulse sequence in ksgre.e using the sequence objects in KSGRE_SEQUENCE with
 the sequence module name "ksgremain" (= ksgre.seqctrl.description)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_pg(int start_time) {
  KS_SEQLOC tmploc = KS_INIT_SEQLOC;
  int readstart_pos, readend_pos;
  int i;
  int endposx = 0;
  int endposy = 0;
  int endposz = 0;
  STATUS status;

#ifdef HOST_TGT
  if (opte < avminte) {
    /* we cannot proceed until TE is larger than the minimum TE (see ksgre_eval_TErange()).
       Return a long seq duration and pretend all is good */
    ks_eval_seqctrl_setminduration(&ksgre.seqctrl, 1s);
    return SUCCESS;
  }
#endif

  if (start_time < KS_RFSSP_PRETIME) {
    return ks_error("%s: 1st arg (pos start) must be at least %d us", __FUNCTION__, KS_RFSSP_PRETIME);
  }

  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;
  tmploc.pos = RUP_GRD(start_time);
  tmploc.board = ZGRAD;

  /* N.B.: ks_pg_selrf()->ks_pg_rf() detects that ksgre.selrfexc is an excitation pulse
     (ksgre.selrfexc.rf.role = KS_RF_ROLE_EXC) and will also set ksgre.seqctrl.momentstart
     to the absolute position in [us] of the isocenter of the RF excitation pulse */
  status = ks_pg_selrf(&ksgre.selrfexc, tmploc, &ksgre.seqctrl);
  if (status != SUCCESS) return status;

  /* forward to end of selrfexc.postgrad */
  tmploc.pos += ksgre.selrfexc.pregrad.duration + ksgre.selrfexc.grad.duration + ksgre.selrfexc.postgrad.duration;
  
  /* Second flow comp gradient slice for slice excitation */
  if (ks_pg_trap(&ksgre.fcompslice, tmploc, &ksgre.seqctrl) == FAILURE) /* N.B.: will return quietly if ksgre.fcompslice.duration = 0 (opfcomp = 0) */
    return FAILURE;
  
  /*******************************************************************************************************
  *  Readout timing
  *******************************************************************************************************/

  /* With ksgre.seqctrl.momentstart set by ks_pg_selrf(&ksgre.selrfexc, ...), the absolute readout position
     can be determined (for both full Fourier and partial Fourier readouts using ksgre.read.time2center) */
  readstart_pos = ksgre.seqctrl.momentstart + opte - ksgre.read.time2center;


  /*******************************************************************************************************
   *  Pre-read: Dephasers
   *******************************************************************************************************/

  /********************  Z  ********************/
  if (ksgre.zphaseenc.grad.duration > 0) {
    /* 3D: use .zphaseenc (with embedded slice rephaser via .areaoffset != 0) instead of .selrfexc.postgrad (not placed out since its .duration = 0) */
    tmploc.pos += ksgre.fcompslice.duration; /* fcompslice.duration = 0 unless opfcomp */
    if (ks_pg_phaser(&ksgre.zphaseenc, tmploc, &ksgre.seqctrl) == FAILURE)
      return FAILURE;

    ks_scan_phaser_toline(&ksgre.zphaseenc, 0, 0);
  }

  /********************  Y  ********************/
  tmploc.pos = readstart_pos + RUP_GRD(ksgre.read.acqdelay) - ksgre.phaseenc.grad.duration;
  tmploc.board = YGRAD;
  if (ks_pg_phaser(&ksgre.phaseenc, tmploc, &ksgre.seqctrl) == FAILURE)
    return FAILURE;

  /* set phase encode amps to first ky view (for plotting & moment calcs in WTools) */
  ks_scan_phaser_toline(&ksgre.phaseenc, 0, 0); /* dephaser */

  /********************  X  ********************/
  if (ksgre_slicecheck)
    tmploc.board = ZGRAD; /* move the readout to the Z-axis to view the slice thickness in the image */
  else
    tmploc.board = XGRAD;
  tmploc.pos = readstart_pos - ksgre.readdephaser.duration;
  if (ks_pg_trap(&ksgre.readdephaser, tmploc, &ksgre.seqctrl) == FAILURE)
    return FAILURE;

  tmploc.pos = readstart_pos - ksgre.readdephaser.duration - ksgre.fcompread.duration;
  if (ks_pg_trap(&ksgre.fcompread, tmploc, &ksgre.seqctrl) == FAILURE) /* N.B.: will return quietly if ksgre.fcompread.duration = 0 */
    return FAILURE;


  /*******************************************************************************************************
   *  Readout(s)
   *******************************************************************************************************/

  if (ksgre_slicecheck)
    tmploc.board = ZGRAD;
  else
    tmploc.board = XGRAD;

  /* ksgre.read at TE = opte (1st echo) */
  tmploc.pos = readstart_pos;
  tmploc.ampscale = 1.0;
  for (i = 0; i < opnecho; i++) {
    if (ks_pg_readtrap(&ksgre.read, tmploc, &ksgre.seqctrl) == FAILURE)
      return FAILURE;
    tmploc.pos += ksgre.read.grad.duration + ksgre_extragap * ((i + 1) < opnecho); /* don't add extra gap after the last readout */
    tmploc.ampscale *= -1.0;
  }
  readend_pos = tmploc.pos; /* absolute time for end of last readout trapezoid */
  tmploc.ampscale = 1.0;


  /*******************************************************************************************************
   *  Post-read: Rephasers & spoilers
   *******************************************************************************************************/

  /********************  X  ********************/
  tmploc.board = XGRAD;
  tmploc.pos = readend_pos;
  if (oppseq == PSD_SSFP) {
    if (ks_pg_trap(&ksgre.readrephaser_ssfp, tmploc, &ksgre.seqctrl) == FAILURE) /* read rephaser */
      return FAILURE;
    endposx = tmploc.pos + ksgre.readrephaser_ssfp.duration; /* absolute time for end of last waveform on X */
  } else {
    if (ks_pg_trap(&ksgre.spoiler, tmploc, &ksgre.seqctrl) == FAILURE)
      return FAILURE;
    endposx = tmploc.pos + ksgre.spoiler.duration; /* absolute time for end of last waveform on X */
  }

  /********************  Y  ********************/
  /* phase encoding rephaser on Y (common for GRE, SPGR & SSFP) */
  tmploc.board = YGRAD;
  tmploc.pos = readend_pos - RDN_GRD(ksgre.read.acqdelay); /* Y rephaser can start at the end of the acqwin */
  if (ks_pg_phaser(&ksgre.phaseenc, tmploc, &ksgre.seqctrl) == FAILURE)
    return FAILURE;
  endposy = tmploc.pos + ksgre.phaseenc.grad.duration; /* absolute time for end of last waveform on Y */

  ks_scan_phaser_fromline(&ksgre.phaseenc, 1, 0); /* rephaser */

  /********************  Z  ********************/
  tmploc.board = ZGRAD;
  tmploc.pos = readend_pos - RDN_GRD(ksgre.read.acqdelay); /* Z rephaser/spoiler can start at the end of the acqwin */

  if (oppseq == PSD_SSFP) {

    if (ksgre.zphaseenc.grad.duration > 0) { /* 3D */
      /* z phase encoding rephaser (if 3D SSFP) */
      if (ks_pg_phaser(&ksgre.zphaseenc, tmploc, &ksgre.seqctrl) == FAILURE)
        return FAILURE;
      endposz = tmploc.pos + ksgre.zphaseenc.grad.duration;

      ks_scan_phaser_fromline(&ksgre.zphaseenc, 1, 0);

    } else { /* 2D SSFP */
      /* endtime - postgrad.duration = starting point for z postgrad trapezoid */
      tmploc.pos += IMax(3, \
                         RUP_GRD(ksgre.read.acqdelay) + ksgre.readrephaser_ssfp.duration, \
                         ksgre.phaseenc.grad.duration, \
                         ksgre.selrfexc.postgrad.duration) + ksgre_ssfp_endtime - ksgre.selrfexc.postgrad.duration;

      /* another instance of the slice rephaser, placed at the very end. Relies on isodelay = rfwave.duration / 2 */
      if (ks_pg_trap(&ksgre.selrfexc.postgrad, tmploc, &ksgre.seqctrl) == FAILURE)
        return FAILURE;
      endposz = tmploc.pos + ksgre.selrfexc.postgrad.duration;
    }

  } else { /* non-SSFP */

    if (ks_pg_trap(&ksgre.spoiler, tmploc, &ksgre.seqctrl) == FAILURE)
      return FAILURE;
    endposz = tmploc.pos + ksgre.spoiler.duration;

  }

  /*******************************************************************************************************
   *  Setup phase encoding table for scan (2D + 3D)
   *******************************************************************************************************/
  if (ksgre_ellipsekspace && KS_3D_SELECTED) { /* 3D */
    status = ks_phaseencoding_generate_simple_ellipse(&ksgre.phaseenc_plan, "", &ksgre.phaseenc, &ksgre.zphaseenc);
  } else {
    status = ks_phaseencoding_generate_simple(&ksgre.phaseenc_plan, "", &ksgre.phaseenc, (KS_3D_SELECTED) ? &ksgre.zphaseenc : NULL);
  }
  if (status != SUCCESS) return status;
  ks_phaseencoding_print(&ksgre.phaseenc_plan);


  /*******************************************************************************************************
   *  Set the minimal sequence duration (ksgre.seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* end position of all axes. Make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  tmploc.pos = RUP_GRD(IMax(3, endposx, endposy, endposz));

#ifdef HOST_TGT
  /* On HOST only: Sequence duration (ksgre.seqctrl.ssi_time must be > 0 and is added to ksgre.seqctrl.min_duration in ks_eval_seqctrl_setminduration() */
  ksgre.seqctrl.ssi_time = ksgre_eval_ssitime();
  ks_eval_seqctrl_setminduration(&ksgre.seqctrl, tmploc.pos); /* tmploc.pos now corresponds to the end of last gradient in the sequence */
#endif

  return SUCCESS;

} /* ksgre_pg() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: SCAN in @pg section (functions accessible to both HOST and TGT)
 *
 *  Here are functions related to the scan process (ksgre_scan_***) that have to be placed here in @pg
 *  (not @rsp) to make them also accessible on HOST in order to enable scan-on-host for TR timing
 *  in my_cveval()
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Returns a new RF phase based on an input counter and one of three GRE modes

 This function is largely what makes the difference between the the types of gradient echo sequences
 by different phase increment policies. For SPGR, RF spoiling is wanted and one tries to not repeat the
 same RF phase in a series of consecutive excitation. For bSSFP, the flip angle should be 'negative' every
 other time, which is accomplished by setting the RF phase to 0 or 180 [deg]. In all other cases (values
 of oppseq), the RF phase is set to 0.

 @param[in] counter Counter from the calling function that should increment by 1 outside this function
 @retval phase RF phase in [deg] to be passed to ks_scan_selrf_setfreqphase() and ks_scan_offsetfov()
********************************************************************************************************/
float ksgre_scan_phase(int counter) {
  float phase = 0;

  if (oppseq == PSD_SPGR /* = 5 */ ) {
    /* RF spoiling */
    phase = ks_scan_rf_phase_spoiling(counter);
  } else if (oppseq == PSD_SSFP /* = 4 */) {
    /* balanced SSFP */
    if (counter % 2)
      phase = 180;
    else
      phase = 0;
  } else {
    /* Gradient spoiling */
    phase = 0;
  }

  return phase;

} /* ksgre_scan_phase() */




/**
 *******************************************************************************************************
 @brief #### Sets the current state of all ksgre sequence objects being part of KSGRE_SEQUENCE

 This function sets the current state of all ksgre sequence objects being part of KSGRE_SEQUENCE, incl.
 gradient amplitude changes, RF freq/phases and receive freq/phase based on current slice position and
 phase encoding indices.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more. This could for example be useful when certain lines or slices
 need to be rescanned due to image artifacts detected during scanning.

 @param[in] slice_info Position of the slice to be played out (one element in the `ks_scan_info[]` array)
 @param[in] shot `shot` index in range `[0, ksgre.phaseenc_plan.num_shots - 1]`
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_scan_seqstate(SCAN_INFO slice_info, int shot) {
  float rfphase = 0.0;
  int echo = 0; /* only one phase encode for all echoes for now */
  KS_PHASEENCODING_COORD coord;

  ks_scan_rotate(slice_info);

  /* RF frequency & phase */
  rfphase = ksgre_scan_phase(spgr_phase_counter++);
  if (oppseq == PSD_SSFP /* = 4 */ && fiesta_firstplayout == TRUE) {
    /* half FA for the 1st RF played for current acquistion (= slice, since sequential mode) */
    ks_scan_rf_ampscale(&ksgre.selrfexc.rf, INSTRALL, 0.5);
    fiesta_firstplayout = FALSE;
  } else {
    ks_scan_rf_on(&ksgre.selrfexc.rf, INSTRALL);
  }
  ks_scan_selrf_setfreqphase(&ksgre.selrfexc, 0 /* instance */, slice_info, rfphase);


  /* ky, kz coordinate to play (for 2D: coord.kz = KS_NOTSET) */
  coord = ks_phaseencoding_get(&ksgre.phaseenc_plan, echo, shot);

  /* FOV offsets (by changing freq/phase of ksgre.read) */
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
    ks_scan_offsetfov3D(&ksgre.read, INSTRALL, slice_info, coord.ky, opphasefov, coord.kz, zfovratio, rfphase + zchop_phase);
  } else {
    ks_scan_offsetfov(&ksgre.read, INSTRALL, slice_info, coord.ky, opphasefov, rfphase);
  }

  /* phase enc amps */
  ks_scan_phaser_toline(&ksgre.phaseenc,   0, coord.ky); /* dephaser. instance #0 of phaseenc */
  ks_scan_phaser_fromline(&ksgre.phaseenc, 1, coord.ky); /* rephaser. instance #1 of phaseenc */

  /* z phase enc amp */
  if (ksgre.zphaseenc.grad.duration > 0) { /* PSD_3D or PSD_3DM */
    /* dephaser (incl. slice rephaser in .areaoffset). instance #0 */
    ks_scan_phaser_toline(&ksgre.zphaseenc, 0, coord.kz);

    if (ksgre.zphaseenc.grad.base.ngenerated == 2) {
      /* rephaser (incl. slice prephaser in .areaoffset for next excitation). instance #1 */
      ks_scan_phaser_fromline(&ksgre.zphaseenc, 1, coord.kz);
    }
  }

  return SUCCESS;

} /* ksgre_scan_seqstate() */




/**
 *******************************************************************************************************
 @brief #### Plays out one slice in real time during scanning together with other active sequence modules

  On TGT on the MR system (PSD_HW), this function sets up (ksgre_scan_seqstate()) and plays out the
  core ksgre sequence with optional sequence modules also called in this function. The low-level
  function call `startseq()`, which actually starts the realtime sequence playout is called from within
  ks_scan_playsequence(), which in addition also returns the time to play out that sequence module (see
  time += ...).

  On HOST (in ksgre_eval_tr()) we call ksgre_scan_sliceloop_nargs(), which in turn calls this function
  that returns the total time in [us] taken to play out this core slice. These times are increasing in
  each parent function until ultimately ksgre_scan_scantime(), which returns the total time of the
  entire scan.

  After each call to ks_scan_playsequence(), ks_plot_slicetime() is called to add slice-timing
  information on file for later PDF-generation of the sequence. As scanning is performed in real-time
  and may fail if interrupted, ks_plot_slicetime() will return quietly if it detects both IPG (TGT)
  and PSD_HW (on the MR scanner). See predownload() for the PNG/PDF generation.

  @param[in] slice_pos Position of the slice to be played out (one element in the global
                      `ks_scan_info[]` array)
  @param[in] dabslice  0-based slice index for data storage
  @param[in] shot `shot` index (over ky and kz)
  @param[in] exc Excitation index in range `[0, NEX-1]`, where NEX = number of excitations (opnex)
  @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksgre_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, /* psd specific: */ int shot, int exc) {
  int echoindx;
  int dabop, dabview, acqflag;
  int time = 0;
  float tloc = 0.0;
  KS_PHASEENCODING_COORD coord;
  int echo = 0; /* only one phase encode for all echoes for now */

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
  * ksgre main sequence module
  *******************************************************************************************************/
  if (slice_pos != NULL) {
    /* modify sequence for next playout */
    ksgre_scan_seqstate(*slice_pos, shot);
  } else {
    /* false slice, shut off RF */
    ks_scan_rf_off(&ksgre.selrfexc.rf, INSTRALL);
  }

  coord = ks_phaseencoding_get(&ksgre.phaseenc_plan, echo, shot);

  /* data acquisition control */
  acqflag = (shot >= 0 && slice_pos != NULL && coord.ky >= 0 && slice_pos != NULL && dabslice >= 0) ? DABON : DABOFF; /* open or close data receiver */
  dabop = (exc <= 0) ? DABSTORE : DABADD; /* replace or add to data */

  if (KS_3D_SELECTED) {
    if (ks_scan_info[1].optloc > ks_scan_info[0].optloc)
      dabslice = (opslquant * opvquant - 1) - coord.kz;
    else
      dabslice = coord.kz;
  }

  dabview = (shot >= 0) ? coord.ky : KS_NOTSET;

  if (ksgre.phaseenc.R > 1 && ksgre.phaseenc.nacslines == 0 && dabview != KS_NOTSET) /* ASSET case triggered by R > 1 and no ACS lines */
    dabview /= ksgre.phaseenc.R; /* store in compressed BAM without empty non-acquired lines */

  for (echoindx = 0; echoindx < ksgre.read.acq.base.ngenerated; echoindx++) {
    ks_scan_loaddabwithindices_nex(&ksgre.read.acq.echo[echoindx], dabslice, echoindx, dabview + 1, /*acq*/ 0, /*vol*/ 0, dabop, acqflag);
  }

  time += ks_scan_playsequence(&ksgre.seqctrl);
  ks_plot_slicetime(&ksgre.seqctrl, 1, &tloc, opslthick, slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD);

  return time; /* in [us] */

} /* ksgre_scan_coreslice() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksgre_scan_coreslice() with standardized input arguments

 KSInversion.e has functions (ksinv_eval_multislice(), ksinv_eval_checkTR_SAR() and
 ksinv_scan_sliceloop()) that expect a standardized function pointer to the coreslice function of a main
 sequence. When inversion mode is enabled for the sequence, ksinv_scan_sliceloop() is used instead of
 ksgre_scan_sliceloop() in ksgre_scan_acqloop(), and the generic ksinv_scan_sliceloop() function need a
 handle to the coreslice function of the main sequence.

 In order for these `ksinv_***` functions to work for any pulse sequence they need a standardized
 function pointer with a fixed set of input arguments. As different pulse sequences may need different
 number of input arguments (with different meaning) this ksgre_scan_coreslice_nargs() wrapper function
 provides the argument translation for ksgre_scan_coreslice().

 The function pointer must have SCAN_INFO and slice storage index (dabslice) as the first two input
 args, while remaining input arguments (to ksgre_scan_coreslice()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksgre_scan_coreslice().

 @param[in] slice_pos Pointer to the SCAN_INFO struct corresponding to the current slice to be played out
 @param[in] dabslice  0-based slice index for data storage
 @param[in] nargs Number of extra input arguments to ksgre_scan_coreslice() in range [0,3]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksgre_scan_coreslice()
 @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksgre_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args) {
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

  return ksgre_scan_coreslice(slice_pos, dabslice, /* psd specific: */ shot, exc); /* in [us] */

} /* ksgre_scan_coreslice_nargs() */




/**
 *******************************************************************************************************
 @brief #### Plays out `slperpass` slices corresponding to one TR

 This function gets a spatial slice location index based on the pass index and temporal position within
 current pass. It then calls ksgre_scan_coreslice() to play out one coreslice (i.e. the main ksgre main
 sequence + optional sequence modules, excluding inversion modules).

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] passindx  0-based pass index in range [0, ks_slice_plan.npasses - 1]
 @param[in] shot `shot` index in range `[0,  ksgre.phaseenc_plan.num_shots - 1]`
 @param[in] exc Excitation index in range [0, NEX-1], where NEX = number of excitations (opnex)
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksgre_scan_sliceloop(int slperpass, int passindx, int shot, int exc) {
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

    time += ksgre_scan_coreslice(current_slice, sltimeinpass, shot, exc);

  }

  return time; /* in [us] */

} /* ksgre_scan_sliceloop() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksgre_scan_sliceloop() with standardized input arguments

 For TR timing heat/SAR calculations of regular 2D multislice sequences, GEReq_eval_TR(),
 ks_eval_mintr() and GEReq_eval_checkTR_SAR() use a standardized function pointer with a fixed set of
 input arguments to call the sliceloop of the main sequence with different number of slices to check
 current slice loop duration. As different pulse sequences may need different number of input arguments
 (with different meaning) this ksgre_scan_sliceloop_nargs() wrapper function provides the argument
 translation for ksgre_scan_sliceloop().

 The function pointer must have an integer corresponding to the number of slices to use as its first
 argument while the remaining input arguments (to ksgre_scan_sliceloop()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksgre_scan_sliceloop().

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] nargs Number of extra input arguments to ksgre_scan_sliceloop() in range [0,4]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksgre_scan_sliceloop()
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksgre_scan_sliceloop_nargs(int slperpass, int nargs, void **args) {
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

  return ksgre_scan_sliceloop(slperpass, passindx, shot, exc); /* in [us] */

} /* ksgre_scan_sliceloop_nargs() */



/**
 *******************************************************************************************************
 @brief #### Plays out all phase encodes for all slices belonging to one pass

 This function traverses through all phase encodes to be played out and runs the
 ksgre_scan_sliceloop() for each set of kyindx, kzindx, and excitation. If ksgre_dda > 0, dummy scans
 will be played out before the phase encoding begins.

 In the case of inversion, ksinv_scan_sliceloop() is called instead of ksgre_scan_sliceloop(), where
 the former takes a function pointer to ksgre_scan_coreslice_nargs() in order to be able to play out
 the coreslice in a timing scheme set by ksinv_scan_sliceloop().

 @param[in] passindx  0-based pass index in range [0, ks_slice_plan.npasses - 1]
 @retval passlooptime Time taken in [us] to play out all phase encodes and excitations for `slperpass`
                      slices. Note that the value is a `float` instead of `int` to avoid int overrange
                      at 38 mins of scanning
********************************************************************************************************/
float ksgre_scan_acqloop(int passindx) {
  float time = 0.0;
  int shot, exc;

  fiesta_firstplayout = TRUE; /* for every new acq., prepare for half flip-angle for next RF pulse only */

  for (shot = -ksgre_dda; shot < ksgre.phaseenc_plan.num_shots; shot++) {

    /* shot < 0 means dummy scans, and is handled in ksgre_scan_coreslice() and ksgre_scan_seqstate() */
    if (shot == 0 && ksgre_dda > 0) {
      ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_DUMMY);
    }

    for (exc = 0; exc < (int) ceil(opnex); exc++) { /* ceil rounds up opnex < 1 (used for partial Fourier) to 1 */

      if (ksinv1.params.irmode != KSINV_OFF) {
        void *args[2] = {(void *) &shot, (void *) &exc}; /* pass on args via ksinv_scan_sliceloop() to ksgre_scan_coreslice() */
        int nargs = sizeof(args) / sizeof(void *);
        time += (float) ksinv_scan_sliceloop(&ks_slice_plan, ks_scan_info, passindx, &ksinv1, &ksinv2, &ksinv_filltr,
                                              (shot < 0) ? KSINV_LOOP_DUMMY : KSINV_LOOP_NORMAL, ksgre_scan_coreslice_nargs, nargs, args);
      } else {
        time += (float) ksgre_scan_sliceloop(ks_slice_plan.nslices_per_pass, passindx, shot, exc);          
      }

    } /* for exc */

    ks_plot_slicetime_endofslicegroup("ksgre shots");

    /* save a frame of the main sequence for later generation of an animated GIF using ./psdplot/makegif_ksgre.sh */
    if (shot >= 0) {
      ks_plot_tgt_addframe(&ksgre.seqctrl);
    }
  
  } /* for shot */
  
  ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_STANDARD);
  return time; /* in [us] */

} /* ksgre_scan_acqloop() */




/**
 *****************************************************************************************************
 @brief #### Plays out all passes of a single or multi-pass scan

 This function traverses through all phase encodes to be played out, and runs the ksgre_scan_sliceloop()
 for each set of kyindx, kzindx, and excitation. If ksgre_dda > 0, dummy scans will be played out before
 the phase encoding begins.

 In the case of inversion, ksinv_scan_sliceloop() is called instead of ksgre_scan_sliceloop(), where the
 former takes a function pointer to ksgre_scan_coreslice_nargs() in order to be able to play out the
 coreslice in a timing scheme set by ksinv_scan_sliceloop().

 @retval scantime Total scan time in [us] (float to avoid int overrange after 38 mins)
********************************************************************************************************/
float ksgre_scan_scanloop() {
  float time = 0.0;

  for (volindx = 0; volindx < opfphases; volindx++) { /* opfphases is # volumes (BUT: opfphases for now always 1 since opmph = 0) */

    for (passindx = 0; passindx < ks_slice_plan.npasses; passindx++) {
      /* 2D: ks_slice_plan.npasses * ks_slice_plan.nslices_per_pass >= opslquant, depending on divisibility
         3D: ks_slice_plan.npasses * ks_slice_plan.nslices_per_pass >= opvquant,  depending on divisibility */

      time += ksgre_scan_acqloop(passindx);

#ifdef IPG
      /* Send instruction to dump Pfile (if autolock = 1) and for GE's recon to start reconstructing the slices for current pass */
      GEReq_endofpass();
#endif

    } /* end: acqs (pass) loop */

  } /* end: volume loop */

  return time;

} /* ksgre_scan_scanloop() */





@rspvar
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: RSP variables (accessible on HOST and TGT). Global variables that are used
 *  by multiple functions in scan(). RSP variables can be viewed live on the MR scanner by Display RSP
 *  in the SCAN menu
 *
 *******************************************************************************************************
 *******************************************************************************************************/

int volindx, passindx;
int fiesta_firstplayout = 1;
int spgr_phase_counter = 0;





@rsp
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksfse_implementation.e: SCAN in @rsp section (functions only accessible on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/**
 *****************************************************************************************************
 @brief #### Common initialization for prescan entry points MPS2 and APS2 as well as the SCAN entry point
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_scan_init(void) {

  GEReq_initRSP();

  /* Here goes code common for APS2, MPS2 and SCAN */

  ks_scan_switch_to_sequence(&ksgre.seqctrl);  /* switch to main sequence */
  scopeon(&seqcore); /* Activate scope for core */
  syncon(&seqcore);  /* Activate sync for core */
  setssitime(ksgre.seqctrl.ssi_time/HW_GRAD_UPDATE_TIME);

  /* can we make these independent on global rsptrigger and rsprot in orderslice? */
  settriggerarray( (short) ks_slice_plan.nslices_per_pass, rsptrigger);

  spgr_phase_counter = 0;
  fiesta_firstplayout = TRUE;

  return SUCCESS;

} /* ksgre_scan_init() */



/**
 *****************************************************************************************************
 @brief #### Prescan loop called from both APS2 and MPS2 entry points
 @retval STATUS `SUCCESS` or `FAILURE`
*******************************************************************************************************/
STATUS ksgre_scan_prescanloop(int nloops, int dda) {
  int i, echoindx, sltimeinpass, slloc;

  /* turn off receivers for all echoes */
  for (echoindx = 0; echoindx < ksgre.read.acq.base.ngenerated; echoindx++) {
    loaddab(&ksgre.read.acq.echo[echoindx], 0, 0, DABSTORE, 0, DABOFF, PSD_LOAD_DAB_ALL);
  }

  /* play dummy scans to get into steady state */
  for (i = -dda; i < nloops; i++) {

    /* loop over slices */
    for (sltimeinpass = 0; sltimeinpass < ks_slice_plan.nslices_per_pass; sltimeinpass++) {

      /* slice location from slice plan (unless bSSFP, where we only play out center slice) */
      if (oppseq == PSD_SSFP)
        slloc = CEIL_DIV(opslquant, 2);
      else
        slloc = ks_scan_getsliceloc(&ks_slice_plan, 0, sltimeinpass);

      /* modify sequence for next playout */
      ksgre_scan_seqstate(ks_scan_info[slloc], KS_NOTSET); /* KS_NOTSET => no phase encodes */

      /* data routing control */
      if (i >= 0) {
        /* turn on receiver for 1st echo */
        if (ksgre.read.acq.base.ngenerated > 0)
          loaddab(&ksgre.read.acq.echo[0], 0, 0, DABSTORE, 0, DABON, PSD_LOAD_DAB_ALL);
      }

      ks_scan_playsequence(&ksgre.seqctrl);

    } /* for slices */

  } /* for nloops */

  return SUCCESS;

} /* ksgre_scan_prescanloop() */






