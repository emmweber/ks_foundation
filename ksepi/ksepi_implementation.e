/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : ksepi_implementation.e
 *
 * Authors  : Stefan Skare, Enrico Avventi, Henric Rydén, Ola Norbeck, Tim Sprenger, Johan Berglund
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
* @file ksepi_implementation.e
* @brief This file contains the implementation details for the *ksepi* psd
********************************************************************************************************/


@global

#define KSEPI_MINHNOVER 8 /* N.B. overscans below about 16-24 should be avoided for long TE */
#define KSEPI_MAXRBW_NORAMPSAMPLING 125.0

#define KSEPI_DEFAULT_SSI_TIME_ICEHARDWARE 100
#define KSEPI_DEFAULT_SSI_TIME 1500

#if EPIC_RELEASE < 26
#define MAXVAL_KSEPI_ONLINERECON 1
#else
#define MAXVAL_KSEPI_ONLINERECON 0
#endif

#ifndef GEREQUIRED_E
#error GERequired.e must be inlined before ksepi_implementation.e
#endif


/** @brief #### `typedef struct` holding all all gradients and waveforms for the ksepi sequence
*/
typedef struct KSEPI_SEQUENCE {
  KS_SEQ_CONTROL seqctrl; /**< Control object keeping track of the sequence and its components */
  KS_EPI epitrain; /**< EPI readout train including de/rephasers, readout and phase enc blips */
  KS_EPI epireftrain; /**< Phase reference EPI train for ghost correction */
  KS_TRAP spoiler; /**< Gradient spoiler after FSE train */
  KS_SELRF selrfexc; /**< Excitation RF pulse with slice select and rephasing gradient */
  KS_SELRF selrfref; /**< First refocusing RF pulse */
  KS_SELRF selrfref2; /**< Second RF refocusing pulse when opdualspinecho = 1 */
  KS_TRAP diffgrad; /**<  Both diffusion gradients when opdualspinecho = 0 (monopolar) */
  KS_TRAP diffgrad2; /**< opdualspinecho = 1 (twice-refocused) uses both difgrad1 and difgrad2 */
  KS_WAIT pre_delay; /**< For echotime shifting --> ghost minimization for multishot */
  KS_WAIT post_delay; /**< For echotime shifting --> ghost minimization for multishot */
  KS_TRAP fcompphase; /**< Extra gradient for flowcomp in phase direction (2 instances) */
  KS_TRAP fcompslice; /**< Extra gradient for flowcomp for slice excitation */
  KS_PHASEENCODING_PLAN full_peplan; /**< fully sampled phase encoding plan for 2D and 3D use */
  KS_PHASEENCODING_PLAN ref_peplan; /**< phase encoding plan used for reference volume */
  KS_PHASEENCODING_PLAN peplan; /**< phase encoding plan (may be undersampled) for 2D and 3D use */
  KS_PHASEENCODING_PLAN *current_peplan; /**< pointer to the plan currently in use */
} KSEPI_SEQUENCE;

/* need to split up init macro into two parts to avoid "too long line" by the EPIC preprocessor */
#define KSEPI_INIT_SEQUENCE1 KS_INIT_SEQ_CONTROL, KS_INIT_EPI, KS_INIT_EPI, KS_INIT_TRAP, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_WAIT, KS_INIT_WAIT
#define KSEPI_INIT_SEQUENCE2 KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_PHASEENCODING_PLAN, KS_INIT_PHASEENCODING_PLAN, KS_INIT_PHASEENCODING_PLAN, NULL
#define KSEPI_INIT_SEQUENCE {KSEPI_INIT_SEQUENCE1, KSEPI_INIT_SEQUENCE2};

/** @brief #### FLEET sequence module for GRAPPA calibration volume in the presence of motion
*/
typedef struct KSEPI_FLEET_SEQUENCE {
  KS_SEQ_CONTROL seqctrl;
  KS_EPI epitrain;
  KS_TRAP spoiler;
  KS_SELRF selrfexc;
  KS_WAIT pre_delay; /**< For echotime shifting --> ghost minimization for multishot */
  KS_WAIT post_delay; /**< For echotime shifting --> ghost minimization for multishot */
  KS_PHASEENCODING_PLAN peplan; /**< for 2D and 3D use */
} KSEPI_FLEET_SEQUENCE;
#define KSEPI_FLEET_INIT_SEQUENCE {KS_INIT_SEQ_CONTROL, KS_INIT_EPI, KS_INIT_TRAP, KS_INIT_SELRF, KS_INIT_WAIT, KS_INIT_WAIT, KS_INIT_PHASEENCODING_PLAN};

/** @brief #### Enums to switch between multishot vs. parallel imaging modes
*/
typedef enum {
  KSEPI_MULTISHOT_OFF, /* 0 */
  KSEPI_MULTISHOT_ALLVOLS, /* 1 */
  KSEPI_MULTISHOT_1STVOL, /* 2 */
  KSEPI_MULTISHOT_B0VOLS, /* 3 */
} KSEPI_MULTISHOT_MODE;


@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/*****************************************************************************************************
* RF Excitation
*****************************************************************************************************/
float ksepi_excthickness = 0;
float ksepi_gscalerfexc = 0.9 with {0.1, 3.0, 0.9, VIS, "Excitation slice thk scaling (< 1.0 thicker slice)",}; /* default gradient scaling for slice thickness */
int ksepi_slicecheck = 0 with {0.0, 1.0, 0.0, VIS, "move readout to z axis for slice thickness test",};
float ksepi_spoilerarea = 3000.0 with {0.0, 10000.0, 3000.0, VIS, "ksepi ksepi.spoiler gradient area",};
int ksepi_rfspoiling = 1 with {0, 1, 1, VIS, "Enable RF spoiling 1:on 0:off",};
int ksepi_fse90 = 0 with {0, 1, 0, VIS, "Use FSE90 instead of SPSP for non-fatsat",};
int ksepi_rf3Dopt = 0 with {0, 1, 0, VIS, "Choose optimized SPSP pulse for 3D [0:OFF]",};
float ksepi_kissoff_factor = 0.04 with {0, 1, 0.04, VIS, "Slice oversampling fraction on each side (3D)",};
/*****************************************************************************************************
* RF Refocusing
*****************************************************************************************************/
float ksepi_crusherscale = 1.0 with { -20.0, 20.0, 1.0, VIS, "scaling of crusher gradient area",};
float ksepi_gscalerfref = 0.9 with {0.1, 3.0, 0.9, VIS, "Refocusing slice thk scaling (< 1.0 thicker slice)",}; 

/*****************************************************************************************************
* EPI train - readout
*****************************************************************************************************/
int ksepi_rampsampling = 1 with {0, 1, 1, VIS, "Rampsampling [0:OFF 1:ON]",};
int ksepi_readlobegap = 0 with {0, 10ms, 0, VIS, "extra gap between readout lobes [us]",};
int ksepi_echogap = 0 with {0, 100ms, 0, VIS, "extra gap between EPI echoes [us]",};
int ksepi_readsign = 1 with { -1.0, 1.0, 1.0, VIS, "Readout polarity: +1/-1",};
float ksepi_readampmax = 3.0 with {0.0, 5.0, 3.0, VIS, "Max grad amp for EPI readout lobes",};
float ksepi_sr = 0.01 with {0.0, , 0.01, VIS, "EPI SR: amp/ramp [(G/cm) / us]",};
int ksepi_esp = 0 with {0, 1000000, 0, VIS, "View-only: Echo spacing in [us]",};

/*****************************************************************************************************
* EPI train - phase encoding
*****************************************************************************************************/
int ksepi_blipsign = KS_EPI_POSBLIPS with {KS_EPI_NEGBLIPS, KS_EPI_POSBLIPS, KS_EPI_POSBLIPS, VIS, "Blip polarity: +1/-1",};
int ksepi_echotime_shifting = 1 with {0, 1, 1, VIS, "Enable echo time shifting for multi shot",};
int ksepi_kynover = 24 with {KSEPI_MINHNOVER, 512, 24, VIS, "#extralines for MinTE",};
int ksepi_kznover = 0 with {0, 512, 0, VIS, "#extralines in kz",};
int ksepi_ky_R = 1 with {1, 512, 1, VIS, "Acceleration in ky",};
int ksepi_kz_R = 1 with {1, 512, 1, VIS, "Acceleration in kz",};
int ksepi_kz_nacslines = 16 with {0, 512, 16, VIS, "Number of acs lines in kz",};
int ksepi_caipi = 0 with {0, 512, 0, VIS, "CAIPIRINHA shift (affects 3D epi only. Set 0 for no CAIPI)",};

/*****************************************************************************************************
* Flow comp directions (when opfcomp = 1, only for GE-EPI)
*****************************************************************************************************/
int ksepi_fcy = 1 with {0, 1, 0, VIS, "Flowcomp Y when opfcomp"};
int ksepi_fcz = 1 with {0, 1, 0, VIS, "Flowcomp Z when opfcomp"};

/*****************************************************************************************************
* FLEET calibration volume
*****************************************************************************************************/
int ksepi_fleet = 0 with {0, 1, 0, VIS, "FLEET calibration volume [0:OFF 1:ON]",};
float ksepi_fleet_flip = 15.0 with {0.1, 90.0, 15.0, VIS, "FLEET flip angle [deg]",};
int ksepi_fleet_dda = 0 with {0, 200, 0, VIS, "Dummies for FLEET module",};
int ksepi_fleet_num_ky = 36 with {1, 512, 36, VIS, "Number of ky encodes for FLEET module",};
int ksepi_fleet_num_kz = 24 with {1, 512, 24, VIS, "Number of kz encodes for FLEET module (3D only)",};

/*****************************************************************************************************
* phase reference lines EPI train
*****************************************************************************************************/
int ksepi_reflines = 0 with {0, 96, 0, VIS, "Number of phase reference lines per shot",};

/*****************************************************************************************************
* SWI recon
*****************************************************************************************************/
int ksepi_swi_returnmode = 0 with {0, 7, 0, VIS, "SWI recon 0:Off 1:Acq 2:SWI 4:SWIphase",};

/*****************************************************************************************************
* Sequence general
*****************************************************************************************************/
int ksepi_pos_start = KS_RFSSP_PRETIME with {0, , KS_RFSSP_PRETIME, INVIS, "us from start until the first waveform begins",};
int ksepi_ssi_time = KSEPI_DEFAULT_SSI_TIME with {32, , KSEPI_DEFAULT_SSI_TIME, VIS, "time from eos to ssi in intern trig",};
int ksepi_dda = 1 with {0, 200, 1, VIS, "Number of dummy scans for steady state",};
int ksepi_debug = 1 with {0.0, 100, 1.0, VIS, "Write out e.g. plot files (unless scan on HW)"};
int ksepi_imsize = KS_IMSIZE_POW2 with {KS_IMSIZE_NATIVE, KS_IMSIZE_MIN256, KS_IMSIZE_POW2, VIS, "img. upsamp. [0:native 1:pow2 2:min256]"};
int ksepi_abort_on_kserror = FALSE with {0, 1, 0, VIS, "Hard program abort on ks_error [0:OFF 1:ON]",};
int ksepi_onlinerecon = 0 with {0, MAXVAL_KSEPI_ONLINERECON, 0, VIS, "Online recon [0:OFF 1:ON]",};
int ksepi_ghostcorr = 1 with {0, 1, 1, VIS, "Ghost correction [0:OFF 1:ON]",};
int ksepi_ref_nsegments = 1 with {1, 512, 1, VIS, "Number of kz segments in reference volume",};
int ksepi_multishot_control = KSEPI_MULTISHOT_B0VOLS with {KSEPI_MULTISHOT_OFF, KSEPI_MULTISHOT_B0VOLS, KSEPI_MULTISHOT_B0VOLS, VIS, "0:PI 1:All MulShot 2:1stMulShot 3:b0MulShot",};
int ksepi_multivolpfile = TRUE with {FALSE, TRUE, TRUE, VIS, "Store all data in a single Pfile (pre DV26)",};

/*****************************************************************************************************
* Temporary CVs for testing
*****************************************************************************************************/



@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/* the KSEPI Sequence object */
KSEPI_SEQUENCE ksepi = KSEPI_INIT_SEQUENCE;

/* the KSEPI Sequence object */
KSEPI_FLEET_SEQUENCE ksepi_fleetseq = KSEPI_FLEET_INIT_SEQUENCE;

/* time offset between two EPI trains */
int ksepi_interechotime = 0;

/* Delay between 2 subsequent shots [us] for echo time shifting */
float ksepi_echotime_shifting_shotdelay = 0;

/* Sum of pre and post delay (=constant) */
int ksepi_echotime_shifting_sumdelay = 0;


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: Host functions
 *
 *******************************************************************************************************
 *******************************************************************************************************/

abstract("EPI [KSFoundation]");
psdname("ksepi");

/* function prototypes */
STATUS ksepi_eval_flowcomp_phase(KS_TRAP *fcphase, const KS_EPI *epi, KS_DESCRIPTION desc);
STATUS ksepi_pg(int);
int ksepi_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, int shot);
int ksepi_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args);
int ksepi_scan_sliceloop(int slperpass, int volindx, int passindx, int shot);
int ksepi_scan_sliceloop_nargs(int slperpass, int nargs, void **args);
STATUS ksepi_scan_seqstate(SCAN_INFO slice_info, int shot);
float ksepi_scan_acqloop(int, int, int); /* float since scan clock will be 0:00 if scan time > 38 mins otherwise */
float ksepi_scan_scanloop();

#include "epic_iopt_util.h"
#include <psdiopt.h>
#include <KSFoundation_KSRF.h>

/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: CVINIT
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

  PSD_IOPT_MPH mode should be used for ksepi since the psd rather than the HOST should perform the
  multiple volumes.
  However, PSD_IOPT_MPH (opmph = 1) does not work with rhref=5 (integrated refscan), so have to use an
  `opuser` variable instead to set opfphases for ksepi. Hence we are not using PSD_IOPT_MPH or
  PSD_IOPT_DYNPL, and there is no "Multiphase" imaging option button in the UI.
  Integrated refscan does not support multishot or multiecho either, so these menus will only be available
  when online recon is set to off (ksepi_onlinerecon).

  For details on how to make GE's diffusion recon process accept all kinds of EPI data (not only DW-EPI)
  and perform rampsampling and Nyquist ghost correction using a leading extra 1st volume using no EPI
  blips (integrated refscan), see GEReq_predownload_setrecon_epi() and follow the CV ksepi_ghostcorr = 1
  in this file. opnecho = 1 and opnshot = 1 are necessary.
********************************************************************************************************/

int sequence_iopts[] = {
#if EPIC_RELEASE < 26
  PSD_IOPT_ASSET, /* opasset (SENSE) */
#else
  PSD_IOPT_ARC, /* oparc (only allow for 3D below) */
#endif
  PSD_IOPT_MPH, /* opmph */
  PSD_IOPT_EDR, /* opptsize */
  PSD_IOPT_ZIP_512, /* opzip512 */
  PSD_IOPT_IR_PREP, /* opirprep */
  PSD_IOPT_MILDNOTE, /* opsilent */
  PSD_IOPT_FLOW_COMP, /* opfcomp */
  PSD_IOPT_SEQUENTIAL, /* opirmode */
#ifdef UNDEF
  PSD_IOPT_ZIP_1024, /* opzip1024 */
  PSD_IOPT_SLZIP_X2, /* opzip2 */
  PSD_IOPT_NAV, /* opnav */
#endif
};




/**
 *******************************************************************************************************
 @brief #### Initial handling of imaging options buttons and top-level CVs at the PSD type-in page
 @return void
********************************************************************************************************/
void ksepi_init_imagingoptions(void) {
  int numopts = sizeof(sequence_iopts) / sizeof(int);

  psd_init_iopt_activity();
  activate_iopt_list(numopts, sequence_iopts);
  enable_iopt_list(numopts, sequence_iopts);

  /* Imaging option control functions (using PSD_IOPT_ZIP_512 as example):
    - Make an option unchecked and not selectable: disable_ioption(PSD_IOPT_ZIP_512)
    - Make an option checked and not selectable:   set_required_disabled_option(PSD_IOPT_ZIP_512)
    - Remove the imaging option:                   deactivate_ioption(PSD_IOPT_ZIP_512)
  */

  /* Do not allow 3D multislab to be selected until supported by the PSD */
  cvmax(opimode, PSD_3D);

  /* Button accept control */
  cvmax(opflair, OPFLAIR_GROUP); /* allow T2-FLAIR */
  cvmax(opepi, 1);
  cvdef(opepi, 1);
  cvmax(opmph, 1);

  if (KS_3D_SELECTED) {
    deactivate_ioption(PSD_IOPT_IR_PREP);
  } else {
    deactivate_ioption(PSD_IOPT_ARC); /* No arc for 2D */
  }

  /* flow comp only for GE-EPI */
  if (exist(oppseq) == PSD_SE) {
    deactivate_ioption(PSD_IOPT_FLOW_COMP);
  }

  if (opflair) {
    deactivate_ioption(PSD_IOPT_IR_PREP);
  }

  if (opdiffuse == KS_EPI_DIFFUSION_ON) {
    deactivate_ioption(PSD_IOPT_MPH);
  }

  /* Allow diffusion, but also diffusion recon pipeline for non-diffusion EPI to
  allow for integrated refscan (rhref = 5) to remove Nyquist ghosting for all EPI variants.
  If the user selects DW-EPI in the UI, opdiffuse is set to 1 by the host interface.
  The integrated refscan in GE's online recon requires opdiffuse > 0, but not necessarily 1.
  The following enum is declared in KSFoundation.h:
  {KS_EPI_DIFFUSION_OFF = 0, KS_EPI_DIFFUSION_ON = 1, KS_EPI_DIFFUSION_PRETEND_FOR_RECON = 2}
  So, to let this psd to know if diffusion is really wanted, we check whether opdiffuse is exactly
  1, like if (opdiffuse == KS_EPI_DIFFUSION_ON) in ksepi_implementation.e and ksepi_implementation_diffusion.e.
  I.e. it is important not to check just for "if (opdiffuse)".
  In GERequired()->GEReq_predownload_setrecon_epi(), we check whether opdiffuse = KS_EPI_DIFFUSION_ON,
  and if not, we set opdiffuse = KS_EPI_DIFFUSION_PRETEND_FOR_RECON. Copy and pasting the non-diffusion-scan
  will therefore not enable the diffusion gradients either.  */
  cvmax(opdiffuse, KS_EPI_DIFFUSION_PRETEND_FOR_RECON); /* = 2 */
  cvdesc(opdiffuse, "0: Off 1: On 2: pretend for recon");

#ifdef SIM
  opepi = !KS_3D_SELECTED;
  setexist(opepi, PSD_ON);
  opirmode = PSD_OFF; /* default interleaved slices */
  setexist(opirmode, PSD_ON);
#endif

  /* GERequired.e:GEReq_cvinit() sets ks_qfact (acoustic reduction) when
     ART (opsilent) has been selected. For medium/high ART, ks_qfact is set to 8/20.
     However, for EPI, the geometric distortions becomes too severe so need to
     reduce ks_qfact for EPI (and hence the amount of acoustic reduction).
     In ksepi.e:cvinit() GEReq_cvinit() is called before ksepi_init_imagingoptions(),
     so this code will override the ks_qfact values set in GEReq_cvinit() */
  if (opsilent) {
    _ks_qfact.existflag = TRUE;
    if (opsilentlevel == 1) {
      /* moderate ART (small acoustic reduction) */
      ks_qfact = 4;
      ksepi_diffusion_ramptime = 1500;
    } else {
      /* high ART (moderate acoustic reduction) */
      ks_qfact = 8;
      ksepi_diffusion_ramptime = 2500;
    }
  } else {
    ks_qfact = 1;
    ksepi_diffusion_ramptime = 1500; /* we don't reduce too much to avoid bed vibrations */
  }



  pipure = PSD_PURE_COMPATIBLE_2; /* or maybe PSD_PURE_COMPATIBLE_1 ? */


} /* ksepi_init_imagingoptions() */




/**
 *******************************************************************************************************
 @brief #### Initial setup of user interface (UI) with default values for menus and fields
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_init_UI(void) {
  STATUS status;

  /* Slice oversampling for 3D to avoid aliasing */
  if (KS_3D_SELECTED) {
    pislblank = ksepi_kissoff_factor * exist(opslquant);
  }

  /* Spin or Gradient Echo EPI */
  if (exist(oppseq) == PSD_SE || exist(oppseq) == PSD_IR) {
    acq_type = TYPSPIN; /* SE, FLAIR, or Diffusion EPI */
  } else {
    acq_type = TYPGRAD; /* GRE-EPI */
  }

  /* force flow comp off for non-GE-EPI */
  if (acq_type != TYPGRAD) {
    cvoverride(opfcomp, FALSE, PSD_FIX_ON, PSD_EXIST_ON);
  }

  /* rBW */
  pircbnub = 5; /* number of variable bandwidth */
  pircb2nub = 0; /* no second bandwidth option */
  cvmin(oprbw, 15.625);
  if (ksepi_rampsampling) {
    cvmax(oprbw, 250);
    cvdef(oprbw, 250);
    pircbval2 = 31.25;
    pircbval3 = 62.50;
    pircbval4 = 125.0;
    pircbval5 = 250.0;
  } else {
    cvmax(oprbw, KSEPI_MAXRBW_NORAMPSAMPLING);
    cvdef(oprbw, 62.5);
    pircbval2 = 31.25;
    pircbval3 = 62.50;
    pircbval4 = 83.33;
    pircbval5 = KSEPI_MAXRBW_NORAMPSAMPLING;
  }
  if (oprbw > _oprbw.maxval) {
    /* this avoid minFOV errors for rBW = 250 when FOV < 35 cm */
    cvoverride(oprbw, KSEPI_MAXRBW_NORAMPSAMPLING, _oprbw.fixedflag, _oprbw.existflag);
  }
  oprbw = _oprbw.defval;
  pidefrbw = _oprbw.defval;

  /* NEX - never show. Partial Fourier in ky is done with opte = MINTE, not with NEX < 1 */
  cvdef(opnex, 1);
  opnex = _opnex.defval;
  cvmin(opnex, 1);
  cvmax(opnex, 1);
  pinexnub = 0;
  pinexval2 = 1;
  pinexval3 = 1;
  pinexval4 = 1;
  pinexval5 = 1;
  pinexval6 = 1;

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

  /* phase (y) resolution */
  cvmin(opyres, 16);

  if (KS_3D_SELECTED) {
      /* assuming many shots for 3D */
      cvdef(opxres, 320);
      pixresnub = 63;
      pixresval2 = 192;
      pixresval3 = 256;
      pixresval4 = 288;
      pixresval5 = 320;
      pixresval6 = 384;

      cvdef(opyres, 320);
      piyresnub = 63;
      piyresval2 = 192;
      piyresval3 = 256;
      piyresval4 = 288;
      piyresval5 = 320;
      piyresval6 = 384;
  } else {
    cvdef(opxres, 64);
    cvdef(opyres, 64);
    if (opdiffuse == KS_EPI_DIFFUSION_ON) {
      pixresnub = 63;
      pixresval2 = 96;
      pixresval3 = 128;
      pixresval4 = 160;
      pixresval5 = 192;
      pixresval6 = 224;

      piyresnub = 63;
      piyresval2 = 96;
      piyresval3 = 128;
      piyresval4 = 160;
      piyresval5 = 192;
      piyresval6 = 224;
    } else {
      pixresnub = 63;
      pixresval2 = 32;
      pixresval3 = 64;
      pixresval4 = 96;
      pixresval5 = 128;
      pixresval6 = 160;

      piyresnub = 63;
      piyresval2 = 32;
      piyresval3 = 64;
      piyresval4 = 96;
      piyresval5 = 128;
      piyresval6 = 160;
    }
  }
  opxres = _opxres.defval;
  opyres = _opyres.defval;


  /* Num echoes */
  piechnub = 63;
  cvdef(opnecho, 1);
  cvmax(opnecho, 8);
  opnecho = _opnecho.defval;
  piechdefval = _opnecho.defval;
  piechval2 = 1;
  piechval3 = 2;
  piechval4 = 4;
  piechval5 = 6;
  piechval6 = 8;

  /* ETL */
  cvmax(opetl, 1024);
  pietlnub = 0;

  /* TE */
  avmaxte = 1s;
  avminte = 0;
  avminte2 = 0;
  pitetype = PSD_LABEL_TE_EFF; /* alt. PSD_LABEL_TE_EFF */
  cvdef(opte, 200ms);
  opte = _opte.defval;
  pite1nub = 63;
  pite1val2 = PSD_MINIMUMTE;
  pite1val3 = PSD_MINFULLTE;
  pite1val4 = 30ms;
  pite1val5 = 50ms;
  pite1val6 = 70ms;

  /* TE2 */
  /* pite2nub = 0; */

  /* TR */
  cvdef(optr, 2s);
  optr = _optr.defval;
  if (opfast == TRUE) {
    pitrnub = 0; /* '0': shown but greyed out (but only if opautotr = 1, otherwise TR menu is hidden) */
    cvoverride(opautotr, PSD_ON, PSD_FIX_OFF, PSD_EXIST_ON);
  } else {
    pitrnub = 6; /* '2': only one menu choice (Minimum = AutoTR) */
  }
  pitrval2 = PSD_MINIMUMTR;
  pitrval3 = 1000ms;
  pitrval4 = 2000ms;
  pitrval5 = 3000ms;
  pitrval6 = 4000ms;

  /* FA */
  if (acq_type == TYPSPIN) {
    cvdef(opflip, 180); /* refocusing RF: initialize with low FA to avoid gradrf complaints on load */
#if EPIC_RELEASE >= 24
    pifanub = 0; /* can also be e.g. 2 to allow modification of refocusing flip angle */
    pifamode = PSD_FLIP_ANGLE_MODE_REFOCUS;
    pifaval2 = 180;
#else
    pifanub = 0;
#endif
  } else {
    pifanub = 6;
#if EPIC_RELEASE >= 24
    pifamode = PSD_FLIP_ANGLE_MODE_EXCITE;
#endif
    cvdef(opflip, 10);
    pifaval2 = 10;
    pifaval3 = 15;
    pifaval4 = 20;
    pifaval5 = 30;
    pifaval6 = 90;
  }
  opflip = _opflip.defval;


  /* slice thickness */
  pistnub = 5;
  if (!KS_3D_SELECTED) {
    cvdef(opslthick, 4);
    pistval2 = 3;
    pistval3 = 4;
    pistval4 = 5;
    pistval5 = 6;
    pistval6 = 10;
  } else {
    cvdef(opslthick, 2);
    pistval2 = 1.50;
    pistval3 = 1.75;
    pistval4 = 2.00;
    pistval5 = 2.25;
    pistval6 = 2.50;
  }
  opslthick = _opslthick.defval;

  /* slice spacing */
  cvdef(opslspace, 0);
  opslspace = _opslspace.defval;
  piisil = PSD_ON;
  if (!KS_3D_SELECTED) {
    piisnub = 4;
    piisval2 = 0;
    piisval3 = 0.5;
    piisval4 = 1;
    piisval5 = 4;
    piisval6 = 20;
  } else { /* change these to do overlaps */
    piisnub = 0;
    piisval2 = 0;
  }

  /* default # of slices */
  cvdef(opslquant, 30);

  /* 3D slice settings */
  if (KS_3D_SELECTED) {/* PSD_3D (=2) or PSD_3DM (=6) */

    if (opimode == PSD_3DM) {
      return ks_error("ksepi: 3D multislab mode not supported");
    }

    if (acq_type == TYPSPIN) {
      return ks_error("ksepi: 3D spin echo epi not supported");
    }

    pimultislab = 0; /* 0: forces only single slab, 1: allow multi-slab */
    pilocnub = 4;
    pilocval2 = 32;
    pilocval3 = 64;
    pilocval4 = 128;
    /* opslquant = #slices in slab. opvquant = #slabs */
    cvdef(opslquant, 32);
  }

  /* Multi phase (i.e. multi volumes) */
  if (opmph) {
    pimphscrn = 1;   /* display Multi-Phase Parameter screen */
    pifphasenub = 6;
    pifphaseval2 = 10;
    pifphaseval3 = 20;
    pifphaseval4 = 50;
    pifphaseval5 = 100;
    pifphaseval6 = 200;
    pisldelnub = 0;
    /*
    pisldelval3 = 1s;
    pisldelval4 = 2s;
    pisldelval5 = 5s;
    pisldelval6 = 10s;
    */
    piacqnub = 0;
    setexist(opacqo, 1);
    pihrepnub = 0;  /* no XRR gating */
  } else {
    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
      cvoverride(opfphases, 1, PSD_FIX_OFF, PSD_EXIST_OFF);
    }
    pimphscrn = 0;   /* do not display the Multi-Phase Parameter screen */
  }


  /* Prescan buttons (autoshim). c.f. epic.h */
  pipscoptnub = 1; /* Bit map of number of Prescan option buttons. 0=none, 1=autoshim, 2=phase corr */

  /* opuser0: show GIT revision (GITSHA) using REV variable from the Imakefile */
#ifdef REV
  char userstr[100];
  sprintf(userstr, "PSD version: %s", REV);
  cvmod(opuser0, 0, 0, 0, userstr, 0, " ");
  piuset |= use0;
#endif

  /* opuser1: Number of overscans (extra kylines) for partial Fourier */
  cvmod(opuser1, _ksepi_kynover.minval, _ksepi_kynover.maxval, _ksepi_kynover.defval, _ksepi_kynover.descr, 0, " ");
  opuser1 = _ksepi_kynover.defval;
  piuset |= use1;

  cvmod(opuser2, _ksepi_blipsign.minval, _ksepi_blipsign.maxval, _ksepi_blipsign.defval, _ksepi_blipsign.descr, 0, " ");
  opuser2 = _ksepi_blipsign.defval;
  piuset |= use2;

  cvmod(opuser3, _ksepi_onlinerecon.minval, _ksepi_onlinerecon.maxval, _ksepi_onlinerecon.defval, _ksepi_onlinerecon.descr, 0, " ");
  opuser3 = _ksepi_onlinerecon.defval;
#if EPIC_RELEASE < 26
     piuset |= use3;
#else
     piuset &= ~use3; /* Hide this for DV26+ as EPI without HyperDABs is no longer supported. Custom recons are now necessary */
#endif


  /* enum {KSEPI_MULTISHOT_OFF=0,KSEPI_MULTISHOT_ALLVOLS=1,KESPI_MULTISHOT_1STVOL=2, KSEPI_MULTISHOT_B0VOLS=3 */
  if (KS_3D_SELECTED) {
    piuset &= ~use5;
    cvdef(ksepi_multishot_control, 0);
  } else {
    piuset |= use5;
    if (opdiffuse == KS_EPI_DIFFUSION_ON) {
      cvdef(ksepi_multishot_control, 3);
      cvdesc(ksepi_multishot_control, "0:PI 1:All MulShot 2:1stMulShot 3:b0MulShot");
    } else {
      cvdef(ksepi_multishot_control, 2);
      cvdesc(ksepi_multishot_control, "0:PI 1:All MulShot 2:1stMulShot");
    }
  }
  cvmod(opuser5, _ksepi_multishot_control.minval, _ksepi_multishot_control.maxval, _ksepi_multishot_control.defval, _ksepi_multishot_control.descr, 0, " ");
  opuser5 = (float) _ksepi_multishot_control.defval;

  /* OFFLINE_DIFFRETURN_ALL = 0, OFFLINE_DIFFRETURN_ACQUIRED = 1, OFFLINE_DIFFRETURN_B0 = 2, OFFLINE_DIFFRETURN_MEANDWI = 4, OFFLINE_DIFFRETURN_MEANADC = 8, OFFLINE_DIFFRETURN_EXPATT = 16, OFFLINE_DIFFRETURN_FA = 32, OFFLINE_DIFFRETURN_CFA = 64; */
  cvmod(opuser6, _ksepi_diffusion_returnmode.minval, _ksepi_diffusion_returnmode.maxval, _ksepi_diffusion_returnmode.defval, _ksepi_diffusion_returnmode.descr, 0, " ");
  opuser6 = (float) _ksepi_diffusion_returnmode.defval;
  if (opdiffuse) {
    piuset |= use6;
  } else {
    piuset &= ~use6;
  }

  cvmod(opuser7, _ksepi_swi_returnmode.minval, _ksepi_swi_returnmode.maxval, _ksepi_swi_returnmode.defval, _ksepi_swi_returnmode.descr, 0, " ");
  opuser7 = (float) _ksepi_swi_returnmode.defval;
  if (oppseq != PSD_SE) { /* show for GE variants (PSD_GE, PSD_SPGR, ...) */
   piuset |= use7;
  } else {
   piuset &= ~use7;
   cvoverride(ksepi_swi_returnmode, 0, PSD_FIX_OFF, PSD_EXIST_OFF);
  }

  /* make FLEET volume for GRAPPA calibration  */
  _ksepi_fleet.defval = !KS_3D_SELECTED; /* Default off for 3D */
  cvmod(opuser8, _ksepi_fleet.minval, _ksepi_fleet.maxval, _ksepi_fleet.defval, _ksepi_fleet.descr, 0, " ");
  opuser8 = (float) _ksepi_fleet.defval;
  if (KS_3D_SELECTED || ksepi_onlinerecon == TRUE)
    piuset &= ~use8;
  else
    piuset |= use8;

  /* Number of phase reference lines for ghost correction per shot */
  cvdef(ksepi_reflines, 0);
  ksepi_reflines = _ksepi_reflines.defval;

  cvmod(opuser9, _ksepi_reflines.minval, _ksepi_reflines.maxval, _ksepi_reflines.defval, _ksepi_reflines.descr, 0, " ");
  opuser9 = (float) _ksepi_reflines.defval;
  if (KS_3D_SELECTED || ksepi_onlinerecon == TRUE)
    piuset &= ~use9;
  else
    piuset |= use9;

  if (KS_3D_SELECTED) {
    piuset |= use12;
    cvdef(ksepi_rf3Dopt, 1);
  } else {
    piuset &= ~use12;
    cvdef(ksepi_rf3Dopt, 0);
  }
  ksepi_rf3Dopt = _ksepi_rf3Dopt.defval;
  cvmod(opuser12, _ksepi_rf3Dopt.minval, _ksepi_rf3Dopt.maxval, _ksepi_rf3Dopt.defval, "Choose 3D RF", 0, " ");
  opuser12 = (float) _ksepi_rf3Dopt.defval;

  if (KS_3D_SELECTED) {
    cvmod(opuser15, _ksepi_kz_nacslines.minval, _ksepi_kz_nacslines.maxval, _ksepi_kz_nacslines.defval, _ksepi_kz_nacslines.descr, 0, " ");
    opuser15 = (int) _ksepi_kz_nacslines.defval;
    piuset |= use15;
  } else {
    piuset &= ~use15;
  }

  /*
     Reserved opusers:
     -----------------
     ksepi_diffusion_predownload_setrecon(): opuser20-25 (needed by GE's recon)
     ksepi_eval_inversion(): opuser26-29
     GE reserves: opuser36-48 (epic.h)
   */


  /* Acceleration menu (max accel = 4). But we don't show ARC for 2D */
  GEReq_init_accelUI(KS_ACCELMENU_INT, 4);

  /* multi-shot button (see also ksepi_eval_UI()) */
  pishotnub = 63;
  if (KS_3D_SELECTED) {
    pishotval2 = 8;
    pishotval3 = 12;
    pishotval4 = 16;
    pishotval5 = 24;
    pishotval6 = 32;
    cvdef(opnshots, 16);
} else {
    pishotval2 = 1;
    pishotval3 = 2;
    pishotval4 = 4;
    pishotval5 = 8;
    pishotval6 = 16;
    cvdef(opnshots, 1);
  }
  cvmin(opnshots, 1);
  cvmax(opnshots, 512);
  opnshots = _opnshots.defval;

  /* Make R/L freq encoding attempts (a la epi2.e) */
  if ((TX_COIL_LOCAL == getTxCoilType() && (exist(opplane) == PSD_AXIAL || exist(opplane)== PSD_COR) ) ||
      (TX_COIL_LOCAL == getTxCoilType() &&  exist(opplane) == PSD_OBL && existcv(opplane) && (exist(opobplane) == PSD_AXIAL || exist(opobplane) == PSD_COR) )) {
      piswapfc = 1;
  } else {
      piswapfc = 0;
  }



  /* Diffusion init */
  status = ksepi_diffusion_init_UI();
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* ksepi_init_UI() */





/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: CVEVAL
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/*****************************************************************************************************
 * CVEVAL functions (Execute when a change is made in the user interface)
 *****************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Gets the current UI and checks for valid inputs
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_eval_UI() {
  STATUS status;

  if (ksepi_init_UI() == FAILURE)
    return FAILURE;

  /*** Copy UserCVs to human readable CVs ***/
  if (existcv(opautote) && opautote == PSD_MINTE) {
    ksepi_kynover = (int) opuser1;
    if (ksepi_kynover < _ksepi_kynover.minval || ksepi_kynover > _ksepi_kynover.maxval)
      return ks_error("'#extralines for minTE' is out of range");
  }

  ksepi_blipsign = (int) opuser2;
  if (ksepi_blipsign != KS_EPI_POSBLIPS && ksepi_blipsign != KS_EPI_NEGBLIPS) {
    return ks_error("The EPI blip sign must be either +1 or -1"); /* User error */
  }

  ksepi_onlinerecon = (int) opuser3;
  if (ksepi_onlinerecon != FALSE && ksepi_onlinerecon != TRUE) {
    return ks_error("Recon flag must be 0 or 1"); /* User error */
  }

  /* ksepi_ky_R = 1 means that k-space is fully sampled over opnshots TR
     ksepi_ky_R = opnshots means that k-space is sampled once with undersampling factor of opnshots
     See also ksepi_pg()->ks_phaseencoding_generate_epi() where multiple phase encoding plans are set up. */
  if (KS_3D_SELECTED) {
    ksepi_ky_R = opaccel_ph_stride;
  } else {
    ksepi_ky_R = opnshots;
  }
  if (opnshots % ksepi_ky_R != 0) {
    return ks_error("R must be an integer factor of opnshots"); /* User error */
  }

  /* Reserved opusers:
     -----------------
     ksepi_diffusion_predownload_setrecon(): opuser20-25 (needed by GE's recon)
     ksepi_eval_inversion(): opuser26-29
     GE reserves: opuser36-48 (epic.h)
  */

  /* Multi-shot (shown only if not online recon or ASSET. rhref = 5 cannot deal with multi-shot data) */
  if (ksepi_onlinerecon || (opasset == ASSET_SCAN)) {
    pishotnub = 0; /* hide multishot menu */
    cvoverride(ksepi_multishot_control, KSEPI_MULTISHOT_OFF, PSD_FIX_OFF, PSD_EXIST_ON);
    piuset &= ~use5;
    cvoverride(opnshots, 1, PSD_FIX_OFF, PSD_EXIST_ON);
    cvoverride(ksepi_ky_R, ksepi.epitrain.blipphaser.R, PSD_FIX_OFF, PSD_EXIST_ON);
    piechnub = 0;
    autolock = 0; /* don't save Pfiles by default if online recon. Can be manually overridden as any CV */
  } else {
    ksepi_multishot_control = (int) (KS_3D_SELECTED) ? 0 : opuser5;
    if (ksepi_multishot_control < _ksepi_multishot_control.minval || ksepi_multishot_control > _ksepi_multishot_control.maxval) {
      return ks_error("multishot control (CV5) must be in range [%d,%d]", _ksepi_multishot_control.minval, _ksepi_multishot_control.maxval);
    }
    cvoverride(opasset, FALSE, _opasset.fixedflag, _opasset.existflag); /* force asset off, but keep exist/fixed status */
    pishotnub = 63;
    piechnub = 63;
#if EPIC_RELEASE < 26
    autolock = 1; /* save Pfiles by default if no online recon. Can be manually overridden as any CV */
#else
    autolock = 0; /* as of DV26+, we use Scan Archives instead of Pfiles for EPI */
#endif
  }

  if (ksepi_onlinerecon == FALSE && (opdiffuse == KS_EPI_DIFFUSION_ON)) {
    piuset |= use6;
    ksepi_diffusion_returnmode = (int) opuser6;
  } else {
    piuset &= ~use6;
  }

  /* Don't do the extra ghost correction volume (integrated refscan) if ETL = 1 */
  if (ksepi.epitrain.etl == 1) {
    ksepi_ghostcorr = FALSE;
  } else {
    ksepi_ghostcorr = TRUE;
  }

  /* Diffusion eval */
  status = ksepi_diffusion_eval_UI();
  if (status != SUCCESS) return status;

  ksepi_swi_returnmode = (int) opuser7;

  if (ksepi_onlinerecon == FALSE) {
    ksepi_fleet = (int) opuser8;
    ksepi_reflines = (int) opuser9;
  } else {
    cvoverride(ksepi_fleet, FALSE, PSD_FIX_OFF, PSD_EXIST_ON);
    cvoverride(ksepi_reflines, 0, PSD_FIX_OFF, PSD_EXIST_ON);
  }

  ksepi_rf3Dopt = (int) opuser12;

  ksepi_kz_nacslines = (int) opuser15;

  return SUCCESS;

} /* ksepi_eval_UI() */




STATUS ksepi_eval_flowcomp_phase(KS_TRAP *fcphase, const KS_EPI *epi, KS_DESCRIPTION desc) {

  /* set time origin at end of bipolar flow comp lobe/beginning of epi.blipphaser */
  float dummy1 = 0.0;
  float dummy2 = 0.0;
  float zeromomentsum = 0.0;
  float firstmomentsum = 0.0;
  int pulsepos = 0;
  int invertphase = 0;
  int pulsecnt;
  int epiesp = 0;
  
  epiesp = (epi->read.grad.duration + epi->read_spacing);

  /* compute moments for blips */
  pulsepos = epi->blipphaser.grad.duration + epiesp - epi->blip.duration / 2;
  
  int blips2cent = ((epi->blipphaser.nover != 0) ? (epi->blipphaser.nover / epi->blipphaser.R) : (epi->etl / 2)) - 1;

  for (pulsecnt = 0; pulsecnt < blips2cent; pulsecnt++) {
    /* N.B.: pulsepos is updated in rampmoments() */
    rampmoments(0.0,           epi->blip.amp, epi->blip.ramptime,    invertphase, &pulsepos, &dummy1, &dummy2, &zeromomentsum, &firstmomentsum);
    rampmoments(epi->blip.amp, epi->blip.amp, epi->blip.plateautime, invertphase, &pulsepos, &dummy1, &dummy2, &zeromomentsum, &firstmomentsum);
    rampmoments(epi->blip.amp, 0.0,           epi->blip.ramptime,    invertphase, &pulsepos, &dummy1, &dummy2, &zeromomentsum, &firstmomentsum);
    pulsepos += (epiesp - epi->blip.duration);
  }

  ks_init_trap(fcphase);

  if (zeromomentsum != 0 && firstmomentsum != 0) {
    int fcramp, fcplateau, dummy;
    float fcamp;
    amppwygmn(zeromomentsum, firstmomentsum, epi->blipphaser.grad.ramptime, epi->blipphaser.grad.plateautime, epi->blipphaser.grad.ramptime, 
              0.0, 0.0, (double) ks_syslimits_ampmax(loggrd), (double) ks_syslimits_ramptimemax(loggrd), 0, 
              &fcramp, &fcplateau, &dummy, &fcamp);

    fcphase->amp = fcamp;
    fcphase->ramptime = fcramp;
    fcphase->plateautime = fcplateau;
    fcphase->duration = 2 * fcphase->ramptime + fcphase->plateautime;
    fcphase->area = fcphase->duration * ((float) fcphase->ramptime + fcphase->plateautime);
    sprintf(fcphase->description, desc);
  }

  return SUCCESS;

} /* ksepi_eval_flowcomp() */



STATUS ksepi_eval_setuprf_3dexc(KS_SELRF *selrfexc, int rf3Dopt) {


    selrfexc->rf = spsp_ss30260334; /* 3T SPSP */
    selrfexc->gradwave = spsp_ss30260334_gz; /* normalized to 1 G/cm */

    if (rf3Dopt > 0) {

      if (exist(opslquant) * exist(opslthick) >= 150) {

        /* 150 mm pulses goes here */
        selrfexc->rf       = exc_SPSP3D_150mm_stbw10_etbw4_lin_lin; /* 3T SPSP */
        selrfexc->gradwave = exc_SPSP3D_150mm_stbw10_etbw4_lin_lin_gz; /* normalized to 1 G/cm */

      }

    } /* rf3Dopt > 0 */

    char tmpstr[KS_DESCRIPTION_LENGTH+20];
    sprintf(tmpstr, "Choose 3D RF [%s]", selrfexc->rf.designinfo);
    cvdesc(opuser12, tmpstr);

  return SUCCESS;
}


STATUS ksepi_eval_setuprf() {

  /* selective RF excitation */
  if (opfat || ksepi_fse90 == TRUE) {
    ksepi.selrfexc.rf = exc_fse90; /* KSFoundation_GERF.h */
    ks_init_wave(&ksepi.selrfexc.gradwave); /* clear gradwave */
  } else {
    if (cffield == 30000) {
      if (KS_3D_SELECTED) {
        if (ksepi_eval_setuprf_3dexc(&ksepi.selrfexc, ksepi_rf3Dopt) == FAILURE)
          return FAILURE;
      } else {
        /* In 2D always use the standard GE pulse for now */
        ksepi.selrfexc.rf = spsp_ss30260334; /* 3T SPSP */
        ksepi.selrfexc.gradwave = spsp_ss30260334_gz; /* normalized to 1 G/cm */
      }
    } else {
      ksepi.selrfexc.rf = spsp_ss1528822; /* 1.5T SPSP */
      ksepi.selrfexc.gradwave = spsp_ss1528822_gz; /* normalized to 1 G/cm */
    }
  } /* RF Excitation */

  if (acq_type == TYPSPIN)
    ksepi.selrfexc.rf.flip = 90.0; /* always 90 FA for SE-EPI */
  else
    ksepi.selrfexc.rf.flip = opflip; /* variable FA for GE-EPI */

  if (KS_3D_SELECTED) {
    cvoverride(opvthick, exist(opslquant) * exist(opslthick), _opslquant.fixedflag, existcv(opslquant));
    ksepi_excthickness = (exist(opslquant) - 2 * pislblank) * exist(opslthick);
  } else {
    ksepi_excthickness = opslthick;
  }

  /* Don't oversize slices for 3D */
  ksepi_gscalerfexc = (KS_3D_SELECTED) ? 1.0 : 0.9;
  ksepi_gscalerfref = (KS_3D_SELECTED) ? 1.0 : 0.9;
  
  ksepi.selrfexc.slthick = ksepi_excthickness / ksepi_gscalerfexc;

  if (ks_eval_selrf1(&ksepi.selrfexc, "rfexc") == FAILURE)
    return FAILURE;


  /* selective RF refocusing */
  if (acq_type == TYPSPIN) {
    ksepi.selrfref.rf = ref_se1b4;
    ksepi.selrfref.rf.flip = opflip; /* since pifamode = PSD_FLIP_ANGLE_MODE_REFOCUS when TYPSPIN */
    ksepi.selrfref.slthick = ksepi_excthickness / ksepi_gscalerfref;
    ksepi.selrfref.crusherscale = ksepi_crusherscale;

    if (ks_eval_selrf1(&ksepi.selrfref, "rfref") == FAILURE)
      return FAILURE;
  } else {
    ks_init_selrf(&ksepi.selrfref); /* GE-EPI: reset to default values (incl. zero .duration) */
  }

  /* selective RF refocusing with diffusion and opdualspinecho */
  if (acq_type == TYPSPIN && opdiffuse == KS_EPI_DIFFUSION_ON && opdualspinecho) {
    ksepi.selrfref2.rf = ref_se1b4;
    ksepi.selrfref2.rf.flip = opflip; /* since pifamode = PSD_FLIP_ANGLE_MODE_REFOCUS when TYPSPIN */
    ksepi.selrfref2.slthick = ksepi_excthickness / ksepi_gscalerfref;
    ksepi.selrfref2.crusherscale = ksepi_crusherscale * ksepi_diffusion_2ndcrushfact; /* ksepi_diffusion_2ndcrushfact times bigger crushers to avoid stimulated echoes */

    if (ks_eval_selrf1(&ksepi.selrfref2, "rfref2") == FAILURE)
      return FAILURE;
  } else {
    ks_init_selrf(&ksepi.selrfref2); /* Not opdualspinecho diffusion: reset to default values (incl. zero .duration) */
  }

  return SUCCESS;

} /* ksepi_eval_setuprf() */


STATUS ksepi_eval_setupfleet() {

  ksepi_fleetseq.selrfexc = ksepi.selrfexc;
  ksepi_fleetseq.selrfexc.rf.flip = ksepi_fleet_flip;
  if (ks_eval_selrf1(&ksepi_fleetseq.selrfexc, "fleetrfexc") == FAILURE)
    return FAILURE;

  /* echo time shifting */
  ks_init_wait(&ksepi_fleetseq.pre_delay);
  ks_init_wait(&ksepi_fleetseq.post_delay);
  if (ksepi_echotime_shifting == TRUE) {
    /*** Set up a pair of wait objects that are used to shift back the RF up to the echospacing ***/
    if (ks_eval_wait(&ksepi_fleetseq.pre_delay,"ksepi_fleet_wait_pre", GRAD_UPDATE_TIME) == FAILURE) {
      return FAILURE;
    }
    if (ks_eval_wait(&ksepi_fleetseq.post_delay,"ksepi_fleet_wait_post", ksepi_echotime_shifting_sumdelay - GRAD_UPDATE_TIME) == FAILURE) {
      return FAILURE;
    }
  }

  ksepi_fleetseq.epitrain = ksepi.epitrain;
  ksepi_fleetseq.epitrain.blipphaser.res = IMin(2, 
                                                RUP_FACTOR((int) ksepi_fleet_num_ky, 2), /* round up (RUP) to nearest multiple of 2 */
                                                (ksepi.epitrain.blipphaser.nover != 0) ? (ksepi.epitrain.blipphaser.res/2 + abs(ksepi.epitrain.blipphaser.nover)) : ksepi.epitrain.blipphaser.res);
  ksepi_fleetseq.epitrain.blipphaser.nover = 0; /* no partial Fourier for FLEET */
  
  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */
    ksepi_fleetseq.epitrain.zphaser.res = IMax(2, 1, IMin(2, ksepi_fleet_num_kz, opslquant));
  } else {
    ksepi_fleetseq.epitrain.zphaser.res = KS_NOTSET;
  }
  
  if (ks_eval_epi(&ksepi_fleetseq.epitrain, "epifleet", ks_qfact) == FAILURE)
    return FAILURE;

  ksepi_fleetseq.spoiler.area = ksepi_spoilerarea;
  if (ks_eval_trap(&ksepi_fleetseq.spoiler, "fleetspoiler") == FAILURE)
    return FAILURE;

  ks_init_seqcontrol(&ksepi_fleetseq.seqctrl);
  strcpy(ksepi_fleetseq.seqctrl.description, "ksepifleet");

  return SUCCESS;
}


/**
 *******************************************************************************************************
 @brief #### Sets up all sequence objects for the main sequence module (KSEPI_SEQUENCE ksepi)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_eval_setupobjects() {

  /* All RF related setup in separate function */
  if (ksepi_eval_setuprf() == FAILURE)
    return FAILURE;

 
  /* EPI readout */
  ksepi.epitrain.read_spacing = ksepi_readlobegap;
  ksepi.epitrain.read.acq.rbw = oprbw;
  ksepi.epitrain.read.fov = opfov;
  ksepi.epitrain.read.res = RUP_FACTOR(opxres, 2); /* round up (RUP) to nearest multiple of 2 */
  ksepi.epitrain.read.rampsampling = ksepi_rampsampling;
  ksepi.epitrain.read.nover = 0; /* never partial Fourier in kx for EPI */

  ksepi.epitrain.blipphaser.fov = opfov * opphasefov;
  ksepi.epitrain.blipphaser.res = RUP_FACTOR((int) (opyres * opphasefov), 2); /* round up (RUP) to nearest multiple of 2 */

  /* upsample to nearest power of 2 for res up to 256. For higher matrix sizes, use native res
     KSFoundation.h: {KS_IMSIZE_NATIVE, KS_IMSIZE_POW2, KS_IMSIZE_MIN256} */
  if (ksepi.epitrain.read.res < 256 && ksepi.epitrain.blipphaser.res < 256) {
    ksepi_imsize = KS_IMSIZE_POW2;
  } else {
    ksepi_imsize = KS_IMSIZE_NATIVE;
  }

  if (opautote == PSD_MINTE) /* partial Fourier in ky */
    ksepi.epitrain.blipphaser.nover = ksepi_kynover;
  else
    ksepi.epitrain.blipphaser.nover = 0;

  if (opasset == ASSET_SCAN) {
    /* ASSET acceleration, without acs lines (since 2nd arg = 0) */
    if (ks_eval_phaser_setaccel(&ksepi.epitrain.blipphaser, 0, opaccel_ph_stride) == FAILURE)
      return FAILURE;
  } else {
    /* R is used as multishot if not ASSET has been selected */
    ksepi.epitrain.blipphaser.R = opnshots; /* using multi-shot to accelerate EPI readout */
    ksepi.epitrain.blipphaser.nacslines = 0; /* never have acs lines for EPI */
  }

  /* z phase encoding gradient for the 3D case (one zphase enc. per TR, not real 3D EPI) */
  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */
    ksepi_kz_R = opaccel_sl_stride;
    ksepi.epitrain.zphaser.fov = opvthick;
    ksepi.epitrain.zphaser.res = IMax(2, 1, opslquant);
    ksepi.epitrain.zphaser.nover = IMin(2, ksepi_kznover, ksepi.epitrain.zphaser.res/2);
    ksepi.epitrain.zphaser.R = ksepi_kz_R;
    ksepi.epitrain.zphaser.nacslines = ksepi_kz_nacslines;
  } else {
    ksepi.epitrain.zphaser.res = KS_NOTSET; /* ks_eval_epi will clear zphaser if res <= 1 */
  }

  if (ks_eval_epi(&ksepi.epitrain, "epi", ks_qfact) == FAILURE) {
    return FAILURE;
  }

  /* echo time shifting */
  ks_init_wait(&ksepi.pre_delay);
  ks_init_wait(&ksepi.post_delay);

  if (ksepi_echotime_shifting == TRUE) {
    /*** Set up a pair of wait objects that are used to shift back the RF up to the echospacing ***/
    ksepi_echotime_shifting_shotdelay = ksepi.epitrain.read.grad.duration/ksepi.epitrain.blipphaser.R;
    ksepi_echotime_shifting_sumdelay = RUP_GRD((int) (ksepi_echotime_shifting_shotdelay * (ksepi.epitrain.blipphaser.R-1))) + GRAD_UPDATE_TIME;
    if (ks_eval_wait(&ksepi.pre_delay,"ksepi_wait_pre", GRAD_UPDATE_TIME) == FAILURE) {
      return FAILURE;
    }
    if (ks_eval_wait(&ksepi.post_delay,"ksepi_wait_post", ksepi_echotime_shifting_sumdelay - GRAD_UPDATE_TIME) == FAILURE) {
      return FAILURE;
    }
  }

  if (ksepi_reflines > 0) {
    ksepi.epireftrain = ksepi.epitrain;
    ksepi.epireftrain.blipphaser.nover = 0;
    ksepi.epireftrain.blipphaser.res = ksepi_reflines * ksepi.epireftrain.blipphaser.R;

   if (ks_eval_epi(&ksepi.epireftrain, "epireflines", ks_qfact) == FAILURE) {
      return FAILURE;
    }
  }
  else {
    ks_init_epi(&ksepi.epireftrain);
  }

  /* Flow comp */
  ks_init_trap(&ksepi.fcompphase);
  ks_init_trap(&ksepi.fcompslice);

  if (opfcomp == TRUE) {

    if (ksepi_fcy) {
      /* Y: Need two extra phase gradients for flowcomp */
      if (ksepi_eval_flowcomp_phase(&ksepi.fcompphase, &ksepi.epitrain, "fcompphase") == FAILURE)
        return FAILURE;
    }

    if (ksepi_fcz) {
      /* Z: Add second z rephaser to complete 0th and 1st moment nulling of slice selection */
      ksepi.fcompslice.area = -ksepi.selrfexc.postgrad.area;
      if (ks_eval_trap(&ksepi.fcompslice, "fcompslice2") == FAILURE)
        return FAILURE;   

      /* Z: Now, make normal z rephaser twice as large */
      ksepi.selrfexc.postgrad.area *= 2;
      if (ks_eval_trap(&ksepi.selrfexc.postgrad, "rfexc.reph_fc1") == FAILURE)
        return FAILURE;
    }

  } /* opfcomp */



  /* It is useful to be able to see the current echo spacing in DisplayCV to determine distortion levels etc */
  cvoverride(ksepi_esp, ksepi.epitrain.read.grad.duration + ksepi.epitrain.read_spacing, PSD_FIX_ON, PSD_EXIST_ON);

  /* for consistency, set opetl to the actual one for the EPI train even though ETL menu should never be visible for EPI */
  cvoverride(opetl, ksepi.epitrain.etl, PSD_FIX_ON, PSD_EXIST_ON);


  /* protect against too long sequence. It appears that opnecho * ksepi.epitrain.etl cannot be >= 1024 */
  if (ksepi.epitrain.etl * opnecho >= 1024)
    return ks_error("# readouts >= 1024. Please reduce echoes, phase res. or increase NumShots");

  /* post-read ksepi.spoiler */
  ksepi.spoiler.area = ksepi_spoilerarea;
  if (ks_eval_trap(&ksepi.spoiler, "spoiler") == FAILURE)
    return FAILURE;

  /* diffusion weighting */
  /* set up the diffusion gradient objects in 'ksepi'. If opdiffuse != KS_EPI_DIFFUSION_ON,
    this function will reset the diffusion objects */
  if (ksepi_diffusion_eval_gradients_TE(&ksepi) == FAILURE)
      return FAILURE;


  /* init seqctrl */
  ks_init_seqcontrol(&ksepi.seqctrl);
  strcpy(ksepi.seqctrl.description, "ksepimain");

  /* Setup FLEET sequence */
  if (ksepi_eval_setupfleet() == FAILURE)
    return FAILURE;

  return SUCCESS;

} /* ksepi_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Sets the min/max TE based on the durations of the sequence objects in KSEPI_SEQUENCE (ksepi)

 This function handles the TE range for SE-EPI, GE-EPI and DW-EPI (opdiffuse == KS_EPI_DIFFUSION_ON).

 Multiple EPI trains (opnecho > 1) are supported but will only work if ksepi_onlinerecon = FALSE, since
 GE's integrated refscan does not seem to work with multiple EPI trains (or multi-shot).
 Time between the EPI readouts is controlled using `ksepi_echogap`, yielding a `ksepi_interechotime`
 variable used in ksepi_pg().

 N.B.: The minTE (avminte) and maxTE (avmaxte) ensures TE (opte) to be in the valid range for this pulse
 sequence to be set up in ksepi_pg(). If the pulse sequence design changes in ksepi_pg(), by
 adding/modifying/removing sequence objects in a way that affects the intended TE, this function needs
 to be updated too.

 @retval STATUS `SUCCESS` or `FAILURE`
******************************************************************************************************/
STATUS ksepi_eval_TErange() {
  int min90_180, min180_echo;

  if (acq_type == TYPSPIN) {

    /* minimum TE: Spin-Echo EPI case (also diffusion) */

    /*** minimum time needed between RF exc center to RF ref center ***/
    min90_180 = ksepi.selrfexc.rf.iso2end + KS_RFSSP_POSTTIME + ksepi.selrfexc.grad.ramptime + ksepi.selrfexc.postgrad.duration;
    if (ksepi_reflines > 0) {
      min90_180 += ksepi.epireftrain.duration;
    }
    min90_180 += ksepi.diffgrad.duration;
    min90_180 += ksepi.selrfref.pregrad.duration + KS_RFSSP_PRETIME + ksepi.selrfref.grad.ramptime + ksepi.selrfref.rf.start2iso;

    /*** minimum time needed between RF ref center and echo center (using selrfref or selrfref2 (opdualspinecho) ***/
    min180_echo = ksepi.diffgrad.duration; /* zero if not opdiffuse == KS_EPI_DIFFUSION_ON  */
    min180_echo += ksepi.epitrain.time2center;

    if (ksepi_echotime_shifting == TRUE) {
      min180_echo += GRAD_UPDATE_TIME;
    }

    if (opdiffuse == KS_EPI_DIFFUSION_ON && opdualspinecho) {
      min180_echo += ksepi.selrfref2.rf.iso2end + ksepi.selrfref2.grad.ramptime + KS_RFSSP_POSTTIME + ksepi.selrfref2.postgrad.duration;

      /* minimum TE is 4x the biggest of the two */
      avminte = IMax(2, min90_180, min180_echo) * 4;

      /* Also check that the middle two diffusion gradients (diffgrad2) fits.
         There should be a time corresponding to TE/2 between the two 180 pulses for opdualspinecho, and within this time two instances
         of ksepi.diffgrad2 must be possible to fit in (2nd and 3rd diffusion gradient) */
      int avail_time = (avminte/2);
      avail_time -= ksepi.selrfref.rf.iso2end + ksepi.selrfref.grad.ramptime + KS_RFSSP_POSTTIME + ksepi.selrfref.postgrad.duration; /* right crusher for 1st 180 */
      avail_time -= ksepi.selrfref2.pregrad.duration + KS_RFSSP_PRETIME + ksepi.selrfref2.grad.ramptime + ksepi.selrfref2.rf.start2iso; /* left crusher for 2nd 180 */
      if (ksepi.diffgrad2.duration * 2 > avail_time) {
       return ks_error("%s: DualSE diffusion - not enough space for 'diffgrad2'", __FUNCTION__);
      }

    } else {
      min180_echo += ksepi.selrfref.rf.iso2end + ksepi.selrfref.grad.ramptime + KS_RFSSP_POSTTIME + ksepi.selrfref.postgrad.duration;

      /* minimum TE is 2x the biggest of the two */
      avminte = IMax(2, min90_180, min180_echo) * 2;
    }

  } else { /* GE-EPI */

    /* RF center to rephaser end */
    avminte = ksepi.selrfexc.rf.iso2end + KS_RFSSP_POSTTIME + ksepi.selrfexc.grad.ramptime;
    if (ksepi_slicecheck == TRUE) {
      avminte += IMax(2,
                      2 * ksepi.fcompphase.duration + ksepi.epitrain.blipphaser.grad.duration, /* Y */
                      ksepi.selrfexc.postgrad.duration + ksepi.fcompslice.duration + ksepi.epitrain.zphaser.grad.duration \
                      + ksepi.epitrain.readphaser.duration) /* X + Z */;
    } else { /* Normal imaging case */
      avminte += IMax(3,
                      ksepi.epitrain.readphaser.duration, /* X */
                      2 * ksepi.fcompphase.duration + ksepi.epitrain.blipphaser.grad.duration, /* Y */
                      ksepi.selrfexc.postgrad.duration + ksepi.fcompslice.duration + ksepi.epitrain.zphaser.grad.duration) /* Z */;
    }

    if (ksepi_reflines > 0) {
      avminte += ksepi.epireftrain.duration;
    }

    /* EPI dephaser start to echo center (this includes ksepi.epitrain.readphaser.duration/ksepi.epitrain.blipphaser.grad.duration).
      Since the dephasers have been added in the IMax(3, ...) above, we need to exclude this time to get TE down to minimum */
    avminte += ksepi.epitrain.time2center - IMax(3, ksepi.epitrain.readphaser.duration, ksepi.epitrain.blipphaser.grad.duration, ksepi.epitrain.zphaser.grad.duration);
    if (ksepi_echotime_shifting == TRUE) {
      avminte += GRAD_UPDATE_TIME;
    }
  }

  avminte += GRAD_UPDATE_TIME * 2; /* 8us extra margin */
  avminte = RUP_FACTOR(avminte, 8); /* round up to make time divisible by 8us */

  avmaxte = avminte; /* initialization only to avoid avmaxte = 0 */

  /* time offset between two EPI trains (up to 16 echoes = EPI trains) */
  ksepi_interechotime = ksepi.epitrain.duration + ksepi_echogap + (acq_type == TYPSPIN) * (KS_RFSSP_PRETIME + ksepi.selrfref.pregrad.duration + ksepi.selrfref.grad.duration + ksepi.selrfref.postgrad.duration + KS_RFSSP_POSTTIME);


  /* maximum TE */
  if (existcv(optr)) {
    if (opautotr) {
      /* TR = minTR, i.e. the current TE is also the maximum TE */
      if (opautote)
        avmaxte = avminte;
      else if (existcv(opte))
        avmaxte = opte;
      else
        avmaxte = avminte;
    } else {
      /* maximum TE dependent on the chosen TR */
      avmaxte = optr - ksepi.seqctrl.ssi_time; /* maximum sequence duration for this TR (implies one slice per TR) */
      avmaxte -= ksepi.spoiler.duration; /* subtract ksepi.spoiler time */
      avmaxte -= ksepi.epitrain.duration - ksepi.epitrain.time2center;
      if (opnecho > 1) {
        avmaxte -= (opnecho - 1) * ksepi_interechotime; /* for multi-echo */
      }
    }
  } else {
    avmaxte = 1s;
  }

  if (opnecho == 2) {
    /* for opnecho == 2, the TE2 button appears although we have greyed it out (pite2nub = 0).
       Make avminte2/opte2 contain the actual number */
    avminte2 = avminte + ksepi_interechotime;
    avmaxte2 = avmaxte + ksepi_interechotime;
    opte2 = opte       + ksepi_interechotime;
  }

  if (opautote) {
    setpopup(opte, PSD_OFF);
    cvoverride(opte, avminte, PSD_FIX_ON, PSD_EXIST_ON); /* AutoTE: force TE to minimum */
  } else if (existcv(opte)) {
    setpopup(opte, PSD_ON);
    if (opte < avminte)
      return ks_error("TE=%.1f too small. Please increase TE to %.1f", opte / 1000.0, avminte / 1000.0);
    if (opte > avmaxte)
      return ks_error("TE=%.1f too large. Please decrease to %.1f", opte / 1000.0, avmaxte / 1000.0);
  }


  return SUCCESS;

} /* ksepi_TErange() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function to KSInversion functions to add single and dual IR support to this sequence

 It is important that ksepi_eval_inversion() is called after other sequence modules have been set up and
 added to the KS_SEQ_COLLECTION struct in my_cveval(). Otherwise the TI and TR timing will be wrong.

 Whether IR is on or off is determined by ksinv1_mode, which is set up in KSINV_EVAL()->ksinv_eval().
 If it is off, this function will return quietly.

 This function calls ksinv_eval_multislice() (KSInversion.e), which takes over the responsibility of
 TR timing that otherwise is determined in ksepi_eval_tr().
 ksinv_eval_multislice() sets seqcollection.evaltrdone = TRUE, which indicates that TR timing has been done.
 ksepi_eval_tr() checks whether seqcollection.evaltrdone = TRUE to avoid that non-inversion TR timing
 overrides the TR timing set up in ksinv_eval_multislice().

 At the end of this function, TR validation and heat/SAR checks are done.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_eval_inversion(KS_SEQ_COLLECTION *seqcollection) {
  STATUS status;
  int slperpass, npasses;
  int approved_TR = FALSE;

  status = KSINV_EVAL(seqcollection, 26, 27, 28, 29); /* args 2-6: integer X corresponds to opuserX CV */
  if (status != SUCCESS) return status;

  if (((int) *ksinv1_mode) == KSINV_OFF) {
    /* If no IR1 flag on, return */
    return SUCCESS;
  }

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    npasses = 2;
  else
    npasses = 1;


  while (approved_TR == FALSE) {

    /* Inversion (specific to 2D FSE/EPI type of PSDs). Must be done after all other sequence modules have been set up */
    slperpass = CEIL_DIV((int) exist(opslquant), npasses);

    if (KS_3D_SELECTED) {
      status = ks_calc_sliceplan(&ks_slice_plan, exist(opvquant), 1 /* seq 3DMS */);
    } else {
      status = ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);
    }
    if (status != SUCCESS) return status;

    /* ksinv_eval_multislice() sets seqcollection.evaltrdone = TRUE. This indicates that TR timing has been done.
       ksepi_eval_tr() check whether seqcollection.evaltrdone = TRUE to avoid that non-inversion TR timing overrides the
       intricate TR timing with inversion module(s). At the end of ksinv_eval_multislice(), TR validation and heat/SAR checks are done */
    status = ksinv_eval_multislice(seqcollection, &ks_slice_plan, ksepi_scan_coreslice_nargs, 0, NULL, &ksepi.seqctrl);
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
  status = ksinv_eval_checkTR_SAR(seqcollection, &ks_slice_plan, ksepi_scan_coreslice_nargs, 0, NULL);
  if (status != SUCCESS) return status;


  return SUCCESS;

} /* ksepi_eval_inversion() */




/**
 *******************************************************************************************************
 @brief #### Evaluation of number of slices / TR, set up of slice plan, TR validation and SAR checks

 With the current sequence collection (see my_cveval()), and a function pointer to an
 argument-standardized wrapper function (ksepi_scan_sliceloop_nargs()) to the slice loop function
 (ksepi_scan_sliceloop(), this function calls GEReq_eval_TR(), where number of slices that can fit
 within one TR is determined by adding more slices as input argument to the slice loop function.
 For more details see GEReq_eval_TR().

 With the number of slices/TR now known, a standard 2D slice plan is set up using ks_calc_sliceplan()
 and the duration of the main sequence is increased based on timetoadd_perTR, which was returned by
 GEReq_eval_TR(). timetoadd_perTR > 0 when optr > avmintr and when heat or SAR restrictions requires
 `avmintr` to be larger than the net sum of sequence modules in the slice loop.

 This function first checks whether seqcollection.evaltrdone == TRUE. This is e.g. the case for inversion
 where the TR timing instead is controlled using ksepi_eval_inversion() (calling ksinv_eval_multislice()).

 At the end of this function, TR validation and heat/SAR checks are done using GEReq_eval_checkTR_SAR().
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_eval_tr(KS_SEQ_COLLECTION *seqcollection) {
  int timetoadd_perTR;
  STATUS status;
  int slperpass, min_npasses;

  if (seqcollection->evaltrdone == TRUE) {
    /*
     We cannot call GEReq_eval_TR() or GEReq_eval_checkTR_SAR(..., ksepi_scan_sliceloop_nargs, ...) if e.g. the inversion sequence module is used. This is because
     ksinv_scan_sliceloop() is used instead of ksepi_scan_sliceloop(). When ksinv1.params.mode != 0 (i.e. inversion sequence module on), the TR timing and
     heat/SAR limits checks are done in ksinv_eval_multislice(), which is called from ksepi_eval_inversion().
     In the future, other sequence modules may want to take over the responsibility of TR calculations and SAR checks, in which case they need to end their corresponding function
     by setting evaltrdone = TRUE to avoid double processing here */
    return SUCCESS;
  }

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    min_npasses = 2;
  else
    min_npasses = 1;

  /* Calculate # slices per TR, # acquisitions and how much spare time we have within the current TR by running the slice loop. */
  status = GEReq_eval_TR(&slperpass, &timetoadd_perTR, min_npasses, seqcollection, ksepi_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Calculate the slice plan (ordering) and passes (acqs). ks_slice_plan is passed to GEReq_predownload_store_sliceplan() in predownload() */
  if (KS_3D_SELECTED) {
    ks_calc_sliceplan(&ks_slice_plan, exist(opvquant), 1 /* seq 3DMS */);
  } else {
    ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);
  }


  /* We spread the available timetoadd_perTR evenly, by increasing the .duration of each slice by timetoadd_perTR/ksepi_slperpass */
  ksepi.seqctrl.duration = RUP_GRD(ksepi.seqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

  /* Update SAR values in the UI (error will occur if the sum of sequence durations differs from optr) */
  status = GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, ksepi_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Fill in the 'tmin' and 'tmin_total'. tmin_total is only like GEs use of the variable when TR = minTR */
  tmin = ksepi.seqctrl.min_duration;
  tmin_total = ksepi.seqctrl.duration;

  return SUCCESS;

} /* ksepi_eval_tr() */




/**
 *******************************************************************************************************
 @brief #### The SSI time for the sequence

 @retval int SSI time in [us]
********************************************************************************************************/
int ksepi_eval_ssitime() {

  /* SSI time CV:
     Empirical finding on how much SSI time we need to update.
     But, use a longer SSI time when we write out data to file in scan() */
  ksepi_ssi_time = RUP_GRD(IMax(2, 
                          ks_syslimits_hasICEhardware() ? KSEPI_DEFAULT_SSI_TIME_ICEHARDWARE : KSEPI_DEFAULT_SSI_TIME, 
                          _ksepi_ssi_time.minval));

  /* Copy SSI CV to seqctrl field used by setssitime() */
  ksepi.seqctrl.ssi_time = RUP_GRD(ksepi_ssi_time);
  ksepi_fleetseq.seqctrl.ssi_time = RUP_GRD(ksepi_ssi_time);

  /* SSI time one-sequence-off workaround:
     We set the hardware ssitime in ks_scan_playsequence(), but it acts on the next sequence module, hence
     we aren't doing this correctly when using multiple sequence modules (as KSChemSat etc).
     One option would be to add a short dummy sequence ks_scan_playsequence(), but need to investigate
     if there is a better way. For now, let's assume the the necessary update time is the longest for
     the main sequence (this function), and let the ssi time for all other sequence modules (KSChemSat etc)
     have the same ssi time as the main sequence. */
  kschemsat_ssi_time    = ksepi_ssi_time;
  ksspsat_ssi_time      = ksepi_ssi_time;
  ksinv_ssi_time        = ksepi_ssi_time;
  ksinv_filltr_ssi_time = ksepi_ssi_time;

  return ksepi_ssi_time;

} /* ksepi_eval_ssitime() */




/**
 *******************************************************************************************************
 @brief #### Set the number of dummy scans for the sequence and calls ksepi_scan_scanloop() to determine
        the length of the scan

        After setting the number of dummy scans based on the current TR, the ksepi_scan_scanloop() is
        called to get the scan time. `pitscan` is the UI variable for the scan clock shown in the top
        right corner on the MR scanner.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_eval_scantime() {

  if (optr > 6s)
    ksepi_dda = 0;
  else if (optr >= 1s)
    ksepi_dda = 1;
  else if (optr > 350ms)
    ksepi_dda = 2;
  else
    ksepi_dda = 4;

  if (ksepi_dda > 0)
    ksepi_dda -= ksepi_ghostcorr; /* remove one dummy TR as the ghost corr TR is also acting as one */

  pitscan = ksepi_scan_scanloop();

  return SUCCESS;

} /* ksepi_eval_scantime() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: CVCHECK
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Returns error of various parameter combinations that are not allowed for ksepi
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_check() {

  /* Force the user to select the Echo Planar Imaging button. This error needs to be in cvcheck(), not in
     cvinit()/cveval() to avoid it to trigger also when Echo Planar Imaging has been selected.
     Without opepi = 1, the images won't show up correctly in the GE DB after the 1st volume */

  if (!KS_3D_SELECTED && opepi == PSD_OFF) {
    return ks_error("%s: Please first select the 'Echo Planar Imaging' button", ks_psdname);
  }

  if (existcv(opte) && existcv(opnex) && opautote == PSD_MINTE && opnex < 1.0) {
    ks_error("%s: TE = MinTE and NEX < 1 is not allowed", __FUNCTION__);
  }

  if (ksepi_reflines > ksepi.epitrain.etl) {
    ks_error("%s: ksepi_reflines cannot be larger than echo train length ", __FUNCTION__);
  }

  if (existcv(opnshots) && (opasset == ASSET_SCAN) && (opnshots > 1)) {
    return ks_error("%s: ASSET not compatible with multishot", __FUNCTION__);
  }

  if (existcv(opnshots) && existcv(opslquant) && existcv(optr) && (opdiffuse != KS_EPI_DIFFUSION_ON) && (ksepi_multishot_control == KSEPI_MULTISHOT_B0VOLS)) {
    return ks_error("%s: Multishot control can only be 3 for DW-EPI", __FUNCTION__);
  }

  if (opasset != 0 && opasset != ASSET_SCAN) {
    return ks_error("%s: ASSET flag must be either 0 (OFF) or 2 (ON)", __FUNCTION__);
  }

  if (opdiffuse == KS_EPI_DIFFUSION_ON && oppseq == 2) {
    return ks_error("%s: Select SpinEcho for Diffusion", __FUNCTION__);
  }


#if EPIC_RELEASE >= 26

  /* Pixel size in UI */
  piinplaneres = 1;
  ihinplanexres = opfov / ksepi.epitrain.read.res;
  ihinplaneyres = (opfov * opphasefov) / ksepi.epitrain.blipphaser.res;

  /* show echo spacing in UI */
  piesp = 1;
  ihesp = ksepi.epitrain.read.grad.duration / 1000.0;

#endif


  return SUCCESS;

} /* ksepi_check() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: PREDOWNLOAD
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
STATUS ksepi_predownload_plot(KS_SEQ_COLLECTION* seqcollection) {
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
     why we here write to a file ksepi_objects.txt instead */
  ks_print_selrf(ksepi.selrfexc, fp);
  ks_print_selrf(ksepi.selrfref, fp);
  ks_print_selrf(ksepi.selrfref2, fp); /* opdualspinecho = 1, opdiffuse = 1 */
  ks_print_trap(ksepi.diffgrad, fp); /* opdiffuse = 1 */
  ks_print_trap(ksepi.diffgrad2, fp); /* opdualspinecho = 1, opdiffuse = 1 */
  ks_print_epi(ksepi.epitrain, fp);
  ks_print_epi(ksepi.epireftrain, fp);
  ks_print_trap(ksepi.spoiler, fp);
  fclose(fp);


  /* ks_plot_host():
  Plot each sequence module as a separate file (PNG/SVG/PDF depending on ks_plot_filefmt (GERequired.e))
  See KS_PLOT_FILEFORMATS in KSFoundation.h for options.
  Note that the phase encoding amplitudes corresponds to the first shot, as set by the call to ksepi_scan_seqstate below */
  ksepi_scan_seqstate(ks_scan_info[0], 0);

  KS_PHASEENCODING_PLAN *plans[] = {&ksepi.full_peplan, &ksepi.ref_peplan, &ksepi.peplan};
  int num_plans = sizeof(plans) / sizeof(KS_PHASEENCODING_PLAN *);
  ks_plot_host_seqctrl_manyplans(&ksepi.seqctrl, plans, num_plans);
  ks_plot_host_seqctrl(&ksepi_fleetseq.seqctrl, &ksepi_fleetseq.peplan);

  /* Sequence timing plot */
  ks_plot_slicetime_begin();
  ksepi_scan_scanloop();
  ks_plot_slicetime_end();

  /* ks_plot_tgt_reset():
  Creates sub directories and clear old files for later use of ksepi_scan_acqloop()->ks_plot_tgt_addframe().
  ks_plot_tgt_addframe() will only write in MgdSim (WTools) to avoid timing issues on the MR scanner. Hence,
  unlike ks_plot_host() and the sequence timing plot, one has to open MgdSim and press RunEntry (and also
  press PlotPulse several times after pressing RunEntry).
  ks_plot_tgt_reset() will create a 'makegif_***.sh' file that should be run in a terminal afterwards
  to create the animiated GIF from the dat files */
  ks_plot_tgt_reset(&ksepi.seqctrl);


  return SUCCESS;

}  /* ksepi_predownload_plot() */


/**
 *******************************************************************************************************
 @brief #### Last-resort function to override certain recon variables not set up correctly already

 For most cases, the GEReq_predownload_*** functions in predownload() in ksepi.e set up
 the necessary rh*** variables for the reconstruction to work properly. However, if this sequence is
 customized, certain rh*** variables may need to be changed. Doing this here instead of in predownload()
 directly separates these changes from the standard behavior.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_predownload_setrecon() {

  /* GERequired.e uses: rhuser32-25 (VRGF) and rhuser48 (scantime) */


  rhuser29 = (float) ksepi_fleet_num_ky; /* store for custom recon to know */

  rhuser30 = (float) ksepi_reflines; /* store for custom recon to know */

  rhuser31 = (float) ksepi_multishot_control; /* store for custom recon to know */

  rhuser47 = (float) opfphases; /* number of imaging volumes (may be less than rhnphases due to cal vols. opfphases does not show up in raw header) */


  rhrecon = 961; /* VRE recon using Matlab recon (recon_epi.m). See matlab/deploy/rpmbuild on how to make an RPM */

#if EPIC_RELEASE < 26
  /* rhrawsize = slquant1 * opnecho * (2 * rhptsize) * rhdaxres * rhdayres; */

  if (ksepi_multivolpfile) {
    rhtype1 |= RHTYP1RCALLPASS;
    rhrawsize *= ks_slice_plan.npasses;
  } else {
    rhtype1 &= ~RHTYP1RCALLPASS;
  }

#endif
  return SUCCESS;

} /* ksepi_predownload_setrecon() */




@pg
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: PULSEGEN - builing of the sequence from the sequence objects
 *
 *  HOST: Called in cveval() to dry-run the sequence to determine timings
 *  TGT:  Waveforms are being written to hardware and necessary memory automatically alloacted
 *
 *******************************************************************************************************
 *******************************************************************************************************/





/**
 *******************************************************************************************************
 @brief #### The ksepi (main) pulse sequence

 This is the main pulse sequence in ksepi.e using the sequence objects in KSEPI_SEQUENCE with
 the sequence module name "ksepimain" (= ksepi.seqctrl.description)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_pg(int start_time) {
  KS_SEQLOC tmploc = KS_INIT_SEQLOC;
  int epi_startpos = KS_NOTSET;
  int fc_startpos = KS_NOTSET;
  int fcz_endpos = KS_NOTSET;
  int echo, board;

  if (start_time < KS_RFSSP_PRETIME) {
    return ks_error("%s: 1st arg (pos start) must be at least %d us", __FUNCTION__, KS_RFSSP_PRETIME);
  }

#ifdef HOST_TGT
  if (opte < avminte) {
    /* we cannot proceed until TE is in range.
       Return a long seq duration and pretend all is good */
    ks_eval_seqctrl_setminduration(&ksepi.seqctrl, 1s);
    return SUCCESS;
  }
#endif


  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;
  tmploc.pos = RUP_GRD(start_time + KS_RFSSP_PRETIME);
  tmploc.board = ZGRAD;

  /* N.B.: ks_pg_selrf()->ks_pg_rf() detects that ksepi.selrfexc is an excitation pulse
     (ksepi.selrfexc.rf.role = KS_RF_ROLE_EXC) and will also set ksepi.seqctrl.momentstart
     to the absolute position in [us] of the isocenter of the RF excitation pulse */
  if (ks_pg_selrf(&ksepi.selrfexc, tmploc, &ksepi.seqctrl) == FAILURE)
    return FAILURE;

  /* forward to end of selrfexc.postgrad (works for when slice sel gradient is KS_TRAP or KS_WAVE as only
     one of them can have non-zero duration at a given time) */
  tmploc.pos += ksepi.selrfexc.pregrad.duration + ksepi.selrfexc.grad.duration + ksepi.selrfexc.gradwave.duration + ksepi.selrfexc.postgrad.duration;
  
  /* Second flow comp gradient slice for slice excitation */
  if (ks_pg_trap(&ksepi.fcompslice, tmploc, &ksepi.seqctrl) == FAILURE) /* N.B.: will return quietly if ksepi.fcompslice.duration = 0 (opfcomp = 0) */
    return FAILURE;
  fcz_endpos = tmploc.pos + ksepi.fcompslice.duration;

  /*******************************************************************************************************
  *  EPI phase reference lines
  *******************************************************************************************************/
  tmploc.board = KS_FREQX_PHASEY;
  tmploc.pos = ksepi.seqctrl.momentstart + ksepi.selrfexc.rf.iso2end + ksepi.selrfexc.grad.ramptime + ksepi.selrfexc.postgrad.duration;
  tmploc.ampscale = ksepi_readsign;
  if (ks_pg_epi(&ksepi.epireftrain, tmploc, &ksepi.seqctrl) == FAILURE)
    return FAILURE;

  /*******************************************************************************************************
  *  EPI trains: Begin   (> 1 only supported with offline recon)
  -------------------------------------------------------------------------------------------------------*/
  for (echo = 0; echo < opnecho; echo++) {

    if (acq_type == TYPSPIN) {
      if (opdiffuse == KS_EPI_DIFFUSION_ON && echo == 0) {
        if (ksepi_diffusion_pg(&ksepi, opte) == FAILURE)
          return FAILURE;
      } else {
        if (echo == 0) /* RF refocusing pulse for 1st EPI train at TE/2 */
          tmploc.pos = ksepi.seqctrl.momentstart + opte / 2 - ksepi.selrfref.rf.start2iso - ksepi.selrfref.grad.ramptime - ksepi.selrfref.pregrad.duration;
        else /* RF refocusing pulse between two EPI trains (2nd-Nth EPI train are played out as tight as possible when ksepi_echogap = 0). Use epi_startpos from previous echo index (see below) */
          tmploc.pos = epi_startpos + ksepi.epitrain.duration + KS_RFSSP_PRETIME + ksepi_echogap / 2;
        tmploc.board = ZGRAD;
        if (ks_pg_selrf(&ksepi.selrfref, tmploc, &ksepi.seqctrl) == FAILURE)
          return FAILURE;
      }
    } /* acq_type == TYPSPIN */

    /*******************************************************************************************************
    *  EPI readout including de/rephasers on freq, phase and slice encoding axes (net zero moment on both axes)
    *******************************************************************************************************/
    tmploc.board = (ksepi_slicecheck) ? KS_FREQZ_PHASEY : KS_FREQX_PHASEY;
    epi_startpos = ksepi.seqctrl.momentstart + opte - ksepi.epitrain.time2center + (echo * ksepi_interechotime);
    tmploc.pos = epi_startpos;
    tmploc.ampscale = ksepi_readsign;
    if (ks_pg_epi(&ksepi.epitrain, tmploc, &ksepi.seqctrl) == FAILURE)
      return FAILURE;

    /* Two extra dephasers for flowcomp on phase */
    tmploc.board = YGRAD;
    tmploc.pos = epi_startpos + IMax(3, ksepi.epitrain.readphaser.duration, ksepi.epitrain.blipphaser.grad.duration, ksepi.epitrain.zphaser.grad.duration); /* after all dephasers */

    tmploc.pos -= ksepi.epitrain.blipphaser.grad.duration + 2 * ksepi.fcompphase.duration;
    fc_startpos = tmploc.pos;
    tmploc.ampscale = 1;
    if (ks_pg_trap(&ksepi.fcompphase, tmploc, &ksepi.seqctrl) == FAILURE) /* instance #0. N.B.: will return quietly if ksepi.fcompphase.duration = 0 */
      return FAILURE;

    tmploc.pos += ksepi.fcompphase.duration;
    tmploc.ampscale = -1;
    if (ks_pg_trap(&ksepi.fcompphase, tmploc, &ksepi.seqctrl) == FAILURE) /* instance #1 */
      return FAILURE;

    /*******************************************************************************************************
    *  EPI echo time shifting
    *******************************************************************************************************/
    if (ksepi_echotime_shifting == TRUE && echo == 0) {
      for (board = XGRAD; board <= SSP; board++) {
        tmploc.board = board;
        if (oppseq == PSD_SE) {
          /* 2D: SE-EPI or DW-EPI */
           tmploc.pos = epi_startpos - GRAD_UPDATE_TIME;
        } else {
          /* 2D/3D: GE-EPI
           For XGRAD and YGRAD, place wait pulse just before dephasers (incl flowcomp if present), the smallest of epi_startpos and fc_startpos
           For the other boards, place wait pulse after last slice rephaser (incl slice flowcomp if present) */
           tmploc.pos = (board <= YGRAD) ? (IMin(2, epi_startpos, fc_startpos) - GRAD_UPDATE_TIME) : (fcz_endpos + GRAD_UPDATE_TIME + KS_RFSSP_POSTTIME);
        }
        if (ks_pg_wait(&ksepi.pre_delay, tmploc, &ksepi.seqctrl) != SUCCESS) {
          return FAILURE;
        }
      }
    }


  }
  /*------------------------------------------------------------------------------------------------------
   *  EPI trains: End
   *******************************************************************************************************/

  /*******************************************************************************************************
   *  Gradient spoilers on Y and Z (at the same time)
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;
  tmploc.pos = epi_startpos + ksepi.epitrain.duration;
  tmploc.board = YGRAD;
  if (ks_pg_trap(&ksepi.spoiler, tmploc, &ksepi.seqctrl) == FAILURE)
    return FAILURE;
  tmploc.board = ZGRAD;
  if (ks_pg_trap(&ksepi.spoiler, tmploc, &ksepi.seqctrl) == FAILURE)
    return FAILURE;

  tmploc.pos += ksepi.spoiler.duration;

  /*******************************************************************************************************
  *  EPI echo time shifting (post EPI readouts)
  *******************************************************************************************************/
  if (ksepi_echotime_shifting == TRUE) {
    tmploc.pos += GRAD_UPDATE_TIME;
    tmploc.board = KS_ALL;
    if (ks_pg_wait(&ksepi.post_delay, tmploc, &ksepi.seqctrl) != SUCCESS) {
      return FAILURE;
    }
    tmploc.pos += IMax(2, psd_grd_wait, psd_rf_wait) + GRAD_UPDATE_TIME;
    tmploc.pos += ksepi_echotime_shifting_sumdelay;
  }

  /*******************************************************************************************************
   *  Set the minimal sequence duration (ksepi.seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  tmploc.pos = RUP_GRD(tmploc.pos);

#ifdef HOST_TGT
  /* On HOST only: Sequence duration (ksepi.seqctrl.ssi_time must be > 0 and is added to ksepi.seqctrl.min_duration in ks_eval_seqctrl_setminduration() */
  ksepi.seqctrl.ssi_time = ksepi_eval_ssitime();
  ks_eval_seqctrl_setminduration(&ksepi.seqctrl, tmploc.pos); /* tmploc.pos now corresponds to the end of last gradient in the sequence */
#endif

  /*******************************************************************************************************
   * Phase encoding table
   *
   * Need to call this in ksepi_pg() so it is run both on HOST and TGT. This, since the phase table
   * is dynamically allocated in ks_phaseencoding_generate_epi()->ks_phaseencoding_resize()
   *******************************************************************************************************/
  if (ks_phaseencoding_generate_epi(&ksepi.full_peplan, "Fully sampled EPI volume",
                                      &ksepi.epitrain, 
                                      ksepi_blipsign, 
                                      ksepi.epitrain.blipphaser.R, 
                                      ksepi.epitrain.zphaser.numlinestoacq, 
                                      ksepi_caipi) == FAILURE) {
    return FAILURE;
  }
  if (ks_phaseencoding_generate_epi(&ksepi.ref_peplan, "EPI reference volume",
                                      &ksepi.epitrain, 
                                      ksepi_blipsign, 
                                      ksepi.epitrain.blipphaser.R, 
                                      ksepi_ref_nsegments,
                                      ksepi_caipi) == FAILURE) {
    return FAILURE;
  }
  if (ks_phaseencoding_generate_epi(&ksepi.peplan, "Accelerated EPI volume",
                                      &ksepi.epitrain,
                                      ksepi_blipsign, 
                                      ksepi.epitrain.blipphaser.R / ksepi_ky_R,
                                      ksepi.epitrain.zphaser.numlinestoacq,
                                      ksepi_caipi) == FAILURE) {
    return FAILURE;
  }

  ksepi.current_peplan = &ksepi.full_peplan;

  /* KS_NOTSET -> turns off phase blips for phase reference lines */
  ks_scan_epi_shotcontrol(&ksepi.epireftrain, 0, ks_scan_info[0], NULL, KS_NOTSET, 0);

  /* set EPI dephasers and blips to the first shot so we get the correct plots in WTools */
  ks_scan_epi_shotcontrol(&ksepi.epitrain, 0, ks_scan_info[0], &ksepi.full_peplan, 0, 0);

  return SUCCESS;

} /* ksepi_pg() */


/**
 *******************************************************************************************************
 @brief #### The fleet pulse sequence for GRAPPA calibration

 This is the fleet pulse sequence in ksepi.e using the sequence objects in KSEPI_FLEET_SEQUENCE with
 the sequence module name "ksepifleet" (= ksepi_fleet.seqctrl.description)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_pg_fleet(int start_time) {
  KS_SEQLOC tmploc = KS_INIT_SEQLOC;

  if (ksepi_fleet == FALSE) {
    return SUCCESS;
  }

  if (start_time < KS_RFSSP_PRETIME) {
    return ks_error("%s: 1st arg (pos start) must be at least %d us", __FUNCTION__, KS_RFSSP_PRETIME);
  }

  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;
  tmploc.pos = RUP_GRD(start_time + KS_RFSSP_PRETIME);
  tmploc.board = ZGRAD;

  /* N.B.: ks_pg_selrf()->ks_pg_rf() detects that ksepi_fleetseq.selrfexc is an excitation pulse
     (ksepi_fleetseq.selrfexc.rf.role = KS_RF_ROLE_EXC) and will also set ksepi_fleetseq.seqctrl.momentstart
     to the absolute position in [us] of the isocenter of the RF excitation pulse */
  if (ks_pg_selrf(&ksepi_fleetseq.selrfexc, tmploc, &ksepi_fleetseq.seqctrl) == FAILURE)
    return FAILURE;

  tmploc.pos = ksepi_fleetseq.seqctrl.momentstart;
  tmploc.pos += KS_RFSSP_POSTTIME + ksepi_fleetseq.selrfexc.rf.iso2end + ksepi_fleetseq.selrfexc.grad.ramptime + ksepi_fleetseq.selrfexc.postgrad.duration;

  /*******************************************************************************************************
  *  EPI echo time shifting
  *******************************************************************************************************/
  if (ksepi_echotime_shifting == TRUE) {
    tmploc.board = KS_ALL;
    if (ks_pg_wait(&ksepi_fleetseq.pre_delay, tmploc, &ksepi_fleetseq.seqctrl) != SUCCESS) {
      return FAILURE;
    }
    tmploc.pos += GRAD_UPDATE_TIME;
  }

  /*******************************************************************************************************
  *  EPI readout including de/rephasers on freq and phase encoding axes (net zero moment on both axes)
  *******************************************************************************************************/

  if (ksepi_slicecheck)
    tmploc.board = KS_FREQZ_PHASEY;
  else
    tmploc.board = KS_FREQX_PHASEY;
  tmploc.ampscale = ksepi_readsign;
  if (ks_pg_epi(&ksepi_fleetseq.epitrain, tmploc, &ksepi_fleetseq.seqctrl) == FAILURE) {
    return FAILURE;
  }
  tmploc.pos += ksepi_fleetseq.epitrain.duration; /* end of EPI (incl. x/y rephasers, but not zphaser) */

  /*******************************************************************************************************
   *  Gradient spoilers on Y and Z (at the same time)
   *******************************************************************************************************/
  tmploc.ampscale = 1.0;

  tmploc.board = YGRAD;
  if (ks_pg_trap(&ksepi_fleetseq.spoiler, tmploc, &ksepi_fleetseq.seqctrl) == FAILURE)
    return FAILURE;
  tmploc.board = ZGRAD;
  if (ks_pg_trap(&ksepi_fleetseq.spoiler, tmploc, &ksepi_fleetseq.seqctrl) == FAILURE)
    return FAILURE;

  tmploc.pos += ksepi_fleetseq.spoiler.duration;

  /*******************************************************************************************************
  *  EPI echo time shifting
  *******************************************************************************************************/
  if (ksepi_echotime_shifting == TRUE) {
    tmploc.pos += GRAD_UPDATE_TIME;
    tmploc.board = KS_ALL;
    if (ks_pg_wait(&ksepi_fleetseq.post_delay, tmploc, &ksepi.seqctrl) != SUCCESS) {
      return FAILURE;
    }
    tmploc.pos += IMax(2, psd_grd_wait, psd_rf_wait) + GRAD_UPDATE_TIME;
    tmploc.pos += ksepi_echotime_shifting_sumdelay;
  }

  /*******************************************************************************************************
   *  Set the minimal sequence duration (ksepi.seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  tmploc.pos = RUP_GRD(tmploc.pos);

#ifdef HOST_TGT
  /* On HOST only: Sequence duration (ksepi_fleetseq.seqctrl.ssi_time must be > 0 and is added to ksepi_fleetseq.seqctrl.min_duration in ks_eval_seqctrl_setminduration() */
  ksepi_fleetseq.seqctrl.ssi_time = ksepi_eval_ssitime();
  ks_eval_seqctrl_setminduration(&ksepi_fleetseq.seqctrl, tmploc.pos); /* tmploc.pos now corresponds to the end of last gradient in the sequence */
#endif

  /*******************************************************************************************************
   * Phase encoding table
   * Need to call this in ksepi_pg_fleet() so it is run both on HOST and TGT. This, since the phase table
   * is dynamically allocated in ks_phaseencoding_generate_epi()->ks_phaseencoding_resize()
   *******************************************************************************************************/

  if (ks_phaseencoding_generate_epi(&ksepi_fleetseq.peplan, "Fully sampled EPI volume",
                                    &ksepi_fleetseq.epitrain,
                                    ksepi_blipsign, 
                                    ksepi_fleetseq.epitrain.blipphaser.R, 
                                    ksepi_fleetseq.epitrain.zphaser.numlinestoacq,
                                    ksepi_caipi) == FAILURE) {
    return FAILURE;
  }

  /* set EPI dephasers and blips to the first shot so we get the correct plots in WTools */
  ks_scan_epi_shotcontrol(&ksepi_fleetseq.epitrain, 0, ks_scan_info[0], &ksepi_fleetseq.peplan, 0, 0);

  return SUCCESS;

} /* ksepi_pg_fleet() */




/**
 *******************************************************************************************************
 @brief #### Sets the current state of all ksepi sequence objects being part of KSEPI_SEQUENCE

 This function sets the current state of all ksepi sequence objects being part of KSEPI_SEQUENCE, incl.
 gradient amplitude changes, RF freq/phases and receive freq/phase based on current slice position and
 phase encoding indices.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more. This could for example be useful when certain lines or slices
 need to be rescanned due to image artifacts detected during scanning.

 @param[in] slice_info Position of the slice to be played out (one element in the `ks_scan_info[]` array)
 @param[in] shot Linear ky kz `shot` index in range `[0, (ksepi.peplan.num_shots-1)]`
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_scan_seqstate(SCAN_INFO slice_info, int shot) {
  int echo;
  int exc_rfphase;

  /* RF frequency & phase */
  if (ksepi_rfspoiling) {
    exc_rfphase = ks_scan_rf_phase_spoiling(rfspoiling_phase_counter);
    rfspoiling_phase_counter++;
  } else {
    exc_rfphase = 0;
  }


  ks_scan_rotate(slice_info);

  ks_scan_rf_on(&ksepi.selrfexc.rf, INSTRALL);
  ks_scan_rf_on(&ksepi.selrfref.rf, INSTRALL);

  ks_scan_selrf_setfreqphase(&ksepi.selrfexc, 0,        slice_info, exc_rfphase);
  ks_scan_selrf_setfreqphase(&ksepi.selrfref, INSTRALL, slice_info, exc_rfphase+90);

  if (opdiffuse == KS_EPI_DIFFUSION_ON && opdualspinecho) {
    ks_scan_rf_on(&ksepi.selrfref2.rf, 0);
    ks_scan_selrf_setfreqphase(&ksepi.selrfref2, 0, slice_info, exc_rfphase+90);
  }

  /* EPI echoes (i.e. EPI trains) */
  for (echo = 0; echo < opnecho; echo++) {
    ks_scan_epi_shotcontrol(&ksepi.epitrain, echo, slice_info, ksepi.current_peplan, shot, exc_rfphase);
  } /* opnecho */
  ks_scan_epi_shotcontrol(&ksepi.epireftrain, 0, slice_info, NULL, KS_NOTSET, exc_rfphase);

  return SUCCESS;

} /* ksepi_scan_seqstate() */


STATUS ksepi_fleet_scan_seqstate(const SCAN_INFO *slice_info, int shot) {
  int exc_rfphase;

  /* RF frequency & phase */
  if (ksepi_rfspoiling) {
    exc_rfphase = ks_scan_rf_phase_spoiling(rfspoiling_phase_counter);
    rfspoiling_phase_counter++;
  } else {
    exc_rfphase = 0;
  }

  if (slice_info != NULL) {
    ks_scan_rotate(*slice_info);
    ks_scan_rf_on(&ksepi_fleetseq.selrfexc.rf, INSTRALL);
    ks_scan_selrf_setfreqphase(&ksepi_fleetseq.selrfexc, 0, *slice_info, exc_rfphase);
    ks_scan_epi_shotcontrol(&ksepi_fleetseq.epitrain, 0, *slice_info, &ksepi_fleetseq.peplan, shot, exc_rfphase);
  } else {
    ks_scan_rf_off(&ksepi_fleetseq.selrfexc.rf, INSTRALL);
  }

  return SUCCESS;
} /* ksepi_fleet_scan_seqstate() */


/**
 *******************************************************************************************************
 @brief #### Sets all RF pulse amplitudes to zero

 @return void
********************************************************************************************************/
void ksepi_scan_rf_off() {
  ks_scan_rf_off(&ksepi.selrfexc.rf, INSTRALL);
  ks_scan_rf_off(&ksepi.selrfref.rf, INSTRALL);

  if (opdiffuse == KS_EPI_DIFFUSION_ON && opdualspinecho) {
    ks_scan_rf_off(&ksepi.selrfref2.rf, INSTRALL);
  }
}




/**
 *******************************************************************************************************
 @brief #### Plays out one slice in real time during scanning together with other active sequence modules

  On TGT on the MR system (PSD_HW), this function sets up (ksepi_scan_seqstate()) and plays out the
  core ksepi sequence with optional sequence modules also called in this function. The low-level
  function call `startseq()`, which actually starts the realtime sequence playout is called from within
  ks_scan_playsequence(), which in addition also returns the time to play out that sequence module (see
  time += ...).

  On HOST (in ksepi_eval_tr()) we call ksepi_scan_sliceloop_nargs(), which in turn calls this function
  that returns the total time in [us] taken to play out this core slice. These times are increasing in
  each parent function until ultimately ksepi_scan_scantime(), which returns the total time of the
  entire scan.

  After each call to ks_scan_playsequence(), ks_plot_slicetime() is called to add slice-timing
  information on file for later PDF-generation of the sequence. As scanning is performed in real-time
  and may fail if interrupted, ks_plot_slicetime() will return quietly if it detects both IPG (TGT)
  and PSD_HW (on the MR scanner). See predownload() for the PNG/PDF generation.

  @param[in] slice_pos Position of the slice to be played out (one element in the global
                      `ks_scan_info[]` array)
  @param[in] dabslice  0-based slice index for data storage
  @param[in] shot Linear ky kz `shot` index in range `[0, (ksepi.peplan.num_shots-1)]`
  @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksepi_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, /* psd specific: */ int shot) {
  int echo;
  int time = 0;
  float tloc = 0.0;
  SCAN_INFO slice_pos_updated;
  KS_MAT4x4 Mphysical = KS_MAT4x4_IDENTITY;
  const KS_MAT4x4 Identity = KS_MAT4x4_IDENTITY;

  if (slice_pos != NULL)
    tloc = slice_pos->optloc;

  /*******************************************************************************************************
  * Update slice info
  *******************************************************************************************************/
  if (slice_pos != NULL) {
    ks_scan_update_slice_location(&slice_pos_updated, *slice_pos, Mphysical, Identity);
  }

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
  * ksepi main sequence module
  *******************************************************************************************************/
  if (slice_pos != NULL) {
    /* modify sequence for next playout. If not entry point scan (e.g. L_REF), use no ky phase encodes */
    ksepi_scan_seqstate(slice_pos_updated, (rspent == L_SCAN) ? shot : KS_NOTSET);
  } else {
    /* false slice, shut off RF */
    ksepi_scan_rf_off();
  }

  /* data routing control */
  KS_PHASEENCODING_COORD coord = ks_phaseencoding_get(ksepi.current_peplan, 0, shot); /* coord to first line of EPI train */
  if (KS_3D_SELECTED) {
    if (ks_scan_info[1].optloc > ks_scan_info[0].optloc)
      dabslice = (opslquant * opvquant - 1) - coord.kz;
    else
      dabslice = coord.kz;
  }
  for (echo = 0; echo < opnecho; echo++) {
    ks_scan_epi_loadecho(&ksepi.epitrain, echo, echo, dabslice, ksepi.current_peplan, shot);
  }
  if (ksepi_reflines > 0) {
    /* store phase reference lines as opnecho:th echo */
    ks_scan_epi_loadecho(&ksepi.epireftrain, 0, opnecho, dabslice, ksepi.current_peplan, shot);
  }

  time += ks_scan_playsequence(&ksepi.seqctrl);
  ks_plot_slicetime(&ksepi.seqctrl, 1, &tloc, opslthick, slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD);

  return time; /* in [us] */

} /* ksepi_scan_coreslice() */


/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksepi_scan_coreslice() with standardized input arguments

 KSInversion.e has functions (ksinv_eval_multislice(), ksinv_eval_checkTR_SAR() and
 ksinv_scan_sliceloop()) that expect a standardized function pointer to the coreslice function of a main
 sequence. When inversion mode is enabled for the sequence, ksinv_scan_sliceloop() is used instead of
 ksepi_scan_sliceloop() in ksepi_scan_acqloop(), and the generic ksinv_scan_sliceloop() function need a
 handle to the coreslice function of the main sequence.

 In order for these `ksinv_***` functions to work for any pulse sequence they need a standardized
 function pointer with a fixed set of input arguments. As different pulse sequences may need different
 number of input arguments (with different meaning) this ksepi_scan_coreslice_nargs() wrapper function
 provides the argument translation for ksepi_scan_coreslice().

 The function pointer must have SCAN_INFO and slice storage index (dabslice) as the first two input
 args, while remaining input arguments (to ksepi_scan_coreslice()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksepi_scan_coreslice().

 @param[in] slice_pos Pointer to the SCAN_INFO struct corresponding to the current slice to be played out
 @param[in] dabslice  0-based slice index for data storage
 @param[in] nargs Number of extra input arguments to ksepi_scan_coreslice() in range [0,2]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksepi_scan_coreslice()
 @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksepi_scan_coreslice_nargs(const SCAN_INFO *slice_pos, int dabslice, int nargs, void **args) {
  int shot = 0;

  if (nargs < 0 || nargs > 1) {
    ks_error("%s: 4th arg (void **) must contain 0-1 elements (shot), not %d", __FUNCTION__, nargs);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 4th arg (void **) cannot be NULL if nargs (3rd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    shot = *((int *) args[0]);
  }

  return ksepi_scan_coreslice(slice_pos, dabslice, shot); /* in [us] */

} /* ksepi_scan_coreslice_args() */


int ksepi_fleet_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, int shot) {
  int time = 0;
  float tloc = 0.0;

  if (ksepi_fleetseq.seqctrl.duration == 0) {
    return 0;
  }

  if (slice_pos != NULL)
    tloc = slice_pos->optloc; /* real slice */
  else
    dabslice = KS_NOTSET; /* shut off data acq if false slice */

  ksepi_fleet_scan_seqstate(slice_pos, (rspent == L_SCAN) ? shot  : KS_NOTSET);
  KS_PHASEENCODING_COORD coord = ks_phaseencoding_get(&ksepi_fleetseq.peplan, 0, shot); /* coord to first line of EPI train */
  if (KS_3D_SELECTED) {
    if (ks_scan_info[1].optloc > ks_scan_info[0].optloc)
      dabslice = (opslquant * opvquant - 1) - coord.kz;
    else
      dabslice = coord.kz;
  }
  ks_scan_epi_loadecho(&ksepi_fleetseq.epitrain, 0, 0, dabslice, &ksepi_fleetseq.peplan, shot);
  time += ks_scan_playsequence(&ksepi_fleetseq.seqctrl);
  ks_plot_slicetime(&ksepi_fleetseq.seqctrl, 1, &tloc, ksepi_fleetseq.selrfexc.slthick,
                    slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD);

  return time; /* in [us] */

} /* ksepi_fleet_scan_coreslice() */


/**
 *******************************************************************************************************
 @brief #### Plays out `slperpass` slices corresponding to one TR

 This function gets a spatial slice location index based on the pass index and temporal position within
 current pass. It then calls ksepi_scan_coreslice() to play out one coreslice (i.e. the main ksepi main
 sequence + optional sequence modules, excluding inversion modules).

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] volindx  Volume index in range `[0, opfphases - 1]`
 @param[in] passindx  Pass index in range `[0, ks_slice_plan.npasses - 1]`
 @param[in] shot Linear ky kz `shot` index in range `[0, (ksepi.peplan.num_shots-1)]`
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksepi_scan_sliceloop(int slperpass, int volindx, int passindx, int shot) {
  int time = 0;
  int slloc, sltimeinpass;
  SCAN_INFO centerposition = ks_scan_info[0]; /* first slice chosen here, need only rotation stuff */

  (void) volindx;

  if (KS_3D_SELECTED) {
    int centerslice = opslquant/2;
    /* for future 3D multislab support, let passindx update centerposition */
    centerposition.optloc = (ks_scan_info[centerslice-1].optloc + ks_scan_info[centerslice].optloc)/2.0;
  }


  for (sltimeinpass = 0; sltimeinpass < slperpass; sltimeinpass++) {

    SCAN_INFO *current_slice = &centerposition;
    if (!KS_3D_SELECTED) {
      /* slice location from slice plan */
      slloc = ks_scan_getsliceloc(&ks_slice_plan, passindx, sltimeinpass);
      current_slice = (slloc != KS_NOTSET) ? &ks_scan_info[slloc] : NULL;
    }
    time += ksepi_scan_coreslice(current_slice, sltimeinpass, shot);

  }

  return time; /* in [us] */

} /* ksepi_scan_sliceloop() */


/* FLEET sliceloop plays all shots sequentially */
int ksepi_fleet_scan_sliceloop(int slperpass, int volindx, int passindx) {
  int time = 0;
  int slloc, sltimeinpass, shot;
  SCAN_INFO centerposition = ks_scan_info[0]; /* first slice chosen here, need only rotation stuff */

  (void) volindx;

  if (KS_3D_SELECTED) {
    int centerslice = opslquant/2;
    /* for future 3D multislab support, let passindx update centerposition */
    centerposition.optloc = (ks_scan_info[centerslice-1].optloc + ks_scan_info[centerslice].optloc)/2.0;
  }

  for (sltimeinpass = 0; sltimeinpass < slperpass; sltimeinpass++) {

    SCAN_INFO *current_slice = &centerposition;
    if (!KS_3D_SELECTED) {
      /* slice location from slice plan */
      slloc = ks_scan_getsliceloc(&ks_slice_plan, passindx, sltimeinpass);
      current_slice = (slloc != KS_NOTSET) ? &ks_scan_info[slloc] : NULL;
    }

    for (shot = -ksepi_fleet_dda; shot < ksepi_fleetseq.peplan.num_shots; shot++) {

      if (ksepi_echotime_shifting == TRUE) {
        KS_PHASEENCODING_COORD coord = ks_phaseencoding_get(&ksepi_fleetseq.peplan, 0, shot); /* coord to first line of EPI train */
        const int kyshot = coord.ky % ksepi_fleetseq.peplan.phaser->R;

        ks_enum_epiblipsign blipsign = ks_scan_epi_verify_phaseenc_plan(&ksepi_fleetseq.epitrain, &ksepi_fleetseq.peplan, shot);
        int post_delay = 0;

        if (blipsign == KS_EPI_POSBLIPS) {
         post_delay = (kyshot <= 0) ? GRAD_UPDATE_TIME : RUP_GRD((int) (ksepi_echotime_shifting_shotdelay * kyshot));
        } else if (blipsign == KS_EPI_NEGBLIPS) {
         post_delay = (kyshot <= 0) ? GRAD_UPDATE_TIME : RUP_GRD((int) (ksepi_echotime_shifting_shotdelay * (ksepi_fleetseq.peplan.phaser->R-1-kyshot)));
        }

        ks_scan_wait(&ksepi.pre_delay, ksepi_echotime_shifting_sumdelay - post_delay);
        ks_scan_wait(&ksepi.post_delay, post_delay);
      }

      time += ksepi_fleet_scan_coreslice(current_slice, (shot >= 0) ? sltimeinpass : KS_NOTSET, (shot >= 0) ? shot : KS_NOTSET);

    }
    ks_plot_slicetime_endofslicegroup(ksepi_fleet_dda > 0 ? "FLEET shots (incl dummies)" : "FLEET shots");
  }

  ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_CALIBRATION);

  return time;

}


/**
 *******************************************************************************************************
 @brief #### Wrapper function to ksepi_scan_sliceloop() with standardized input arguments

 For TR timing heat/SAR calculations of regular 2D multislice sequences, GEReq_eval_TR(),
 ks_eval_mintr() and GEReq_eval_checkTR_SAR() use a standardized function pointer with a fixed set of
 input arguments to call the sliceloop of the main sequence with different number of slices to check
 current slice loop duration. As different pulse sequences may need different number of input arguments
 (with different meaning) this ksepi_scan_sliceloop_nargs() wrapper function provides the argument
 translation for ksepi_scan_sliceloop().

 The function pointer must have an integer corresponding to the number of slices to use as its first
 argument while the remaining input arguments (to ksepi_scan_sliceloop()) are stored in the generic void
 pointer array with `nargs` elements, which is then unpacked before calling ksepi_scan_sliceloop().

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] nargs Number of extra input arguments to ksepi_scan_sliceloop() in range [0,3]
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                  ksepi_scan_sliceloop()
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksepi_scan_sliceloop_nargs(int slperpass, int nargs, void **args) {
  int volindx = 0;
  int passindx = 0;
  int shot = KS_NOTSET; /* off */

  if (nargs < 0 || nargs > 3) {
    ks_error("%s: 3rd arg (void **) must contain up to 3 elements: volindx, passindx, shot. Not %d", __FUNCTION__, nargs);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 3rd arg (void **) cannot be NULL if nargs (2nd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    volindx = *((int *) args[0]);
  }
  if (nargs >= 2 && args[1] != NULL) {
    passindx = *((int *) args[1]);
  }
  if (nargs >= 3 && args[2] != NULL) {
    shot = *((int *) args[2]);
  }

  return ksepi_scan_sliceloop(slperpass, volindx, passindx, shot); /* in [us] */

} /* ksepi_scan_sliceloop_nargs() */





/**
 *******************************************************************************************************
 @brief #### Plays out all phase encodes for all slices belonging to one pass

 This function traverses through all shots (`ksepi_numshots`) to be played out and runs the
 ksepi_scan_sliceloop() for each set of shots and excitation. If ksepi_dda > 0, dummy scans
 will be played out before the phase encoding begins.

 In the case of inversion, ksinv_scan_sliceloop() is called instead of ksepi_scan_sliceloop(), where
 the former takes a function pointer to ksepi_scan_coreslice_nargs() in order to be able to play out
 the coreslice in a timing scheme set by ksinv_scan_sliceloop().

 @param[in] passindx  0-based pass index in range `[0, ks_slice_plan.npasses - 1]`
 @param[in] volindx  0-based image volume index in range `[0, opfphases - 1]`
 @param[in] multishotflag ksepi.epitrain.blipphaser.R is used as...
                          0: Parallel imaging factor
                          1: Multi-shot (all volumes, KSEPI_MULTISHOT_ON)
                          2: Multi-shot (multishot vol 1 (volindx=0), PI for vols 2-N, KSEPI_MULTISHOT_ON_VOL1)
                          3: Multi-shot (multishot for b0 volumes), PI for diffusion volumes (only when opdiffuse > 0)
 @retval passlooptime Time taken in [us] to play out all phase encodes and excitations for `slperpass`
                      slices. Note that the value is a `float` instead of `int` to avoid int overrange
                      at 38 mins of scanning
********************************************************************************************************/
float ksepi_scan_acqloop(int passindx, int volindx, int multishotflag) {
  float time = 0.0;
  int shot, kyshot;
  KS_PHASEENCODING_COORD coord;
  int ndummies = 0;
  int is_multishot = (multishotflag == KSEPI_MULTISHOT_ALLVOLS) || \
                     (multishotflag == KSEPI_MULTISHOT_1STVOL && (volindx == 0)) || \
                     (multishotflag == KSEPI_MULTISHOT_B0VOLS && opdiffuse && (volindx < opdifnumt2));

  if (ksepi_ghostcorr && volindx == -1) { /* reference volume */
    ksepi.current_peplan = &ksepi.ref_peplan;
  } else if (is_multishot) { /* multishot volume */
    ksepi.current_peplan = &ksepi.full_peplan;
  } else { /* accelerated volume */
    ksepi.current_peplan = &ksepi.peplan;
  }

  if (ksepi_fleet && volindx == -ksepi_fleet - ksepi_ghostcorr) { /* FLEET volume */
    time += (float) ksepi_fleet_scan_sliceloop(ks_slice_plan.nslices_per_pass, volindx, passindx);
  }
  else { /* non-FLEET volumes */
    if (volindx == 0)
      ndummies = ksepi_dda;
    else
      ndummies = 0;

    for (shot = -ndummies; shot < ksepi.current_peplan->num_shots; shot++) {

      if (shot == 0 && ndummies > 0) {
        ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_DUMMY);
      }

      if (ksepi_echotime_shifting == TRUE) {
        coord = ks_phaseencoding_get(ksepi.current_peplan, 0, shot); /* coord to first line of EPI train */
        kyshot = coord.ky % ksepi.current_peplan->phaser->R;

        ks_enum_epiblipsign blipsign = ks_scan_epi_verify_phaseenc_plan(&ksepi.epitrain, ksepi.current_peplan, shot);
        int post_delay = 0;

        if (blipsign == KS_EPI_POSBLIPS) {
         post_delay = (kyshot <= 0) ? GRAD_UPDATE_TIME : RUP_GRD((int) (ksepi_echotime_shifting_shotdelay * kyshot));
        } else if (blipsign == KS_EPI_NEGBLIPS) {
         post_delay = (kyshot <= 0) ? GRAD_UPDATE_TIME : RUP_GRD((int) (ksepi_echotime_shifting_shotdelay * (ksepi.current_peplan->phaser->R-1-kyshot)));
        }

        ks_scan_wait(&ksepi.pre_delay, ksepi_echotime_shifting_sumdelay - post_delay);
        ks_scan_wait(&ksepi.post_delay, post_delay);
      }

      if (ksinv1.params.irmode != KSINV_OFF) {
        void *args[] = {(void *) &shot}; /* pass on args via ksinv_scan_sliceloop() to ksepi_scan_coreslice() */
        int nargs = sizeof(args) / sizeof(void *);
        time += (float) ksinv_scan_sliceloop(&ks_slice_plan, ks_scan_info, passindx, &ksinv1, &ksinv2, &ksinv_filltr,
                                              (shot < 0) ? KSINV_LOOP_DUMMY : KSINV_LOOP_NORMAL, ksepi_scan_coreslice_nargs, nargs, args);
      } else {
        time += (float) ksepi_scan_sliceloop(ks_slice_plan.nslices_per_pass, volindx, passindx, shot);
      }

      ks_plot_slicetime_endofslicegroup(volindx < 0 ? "ksepi ghostcorr" : "ksepi shots");

      /* save a frame of the main sequence */
      if (shot >= 0) {
        ks_plot_tgt_addframe(&ksepi.seqctrl);
      }

    } /* for shot */
    ks_plot_slicetime_endofpass(volindx < 0 ? KS_PLOT_PASS_WAS_CALIBRATION : KS_PLOT_PASS_WAS_STANDARD);
  }

  return time; /* in [us] */

} /* ksepi_scan_acqloop() */




/**
 *******************************************************************************************************
 @brief #### Plays out all volumes and passes of a single or multi-pass scan

 This function performs the entire scan and traverses through passes and volumes.
 For each `passindx` (in range `[0, ks_slice_plan.npasses-1]`), and `volindx`, ksepi_scan_acqloop()
 will be called to acquire all data for the current set of slices belong to the current
 pass (acquisition). At the end of each pass, GEReq_endofpass() is called to trigger GE's recon and
 to dump Pfiles (if `autolock = 1`). `volindx` will start at -1 if `ksepi_ghostcorr = 1`, in which case
 a leading extra image volume will be played out without phase encoding blips. This data is used by GE's
 integrated refscan (rhref=5) to ghost correct the remaining volumes. This process requires single-shot
 (ksepi.epitrain.phaseenc.R = 1) and single-echo (opnecho = 1). However, for offline reconstruction, it
 is possible to still use this extra volume for ghost correction even though ksepi.epitrain.phaseenc.R > 1
 and/or opnecho > 1.

 @retval scantime Total scan time in [us] (`float` to avoid int overrange after 38 mins)
********************************************************************************************************/
float ksepi_scan_scanloop() {
  float time = 0.0;
  int volindx, passindx;

  for (volindx = -ksepi_fleet - ksepi_ghostcorr; volindx < opfphases; volindx++) { /* opfphases = # volumes */

    if (ksepi_ghostcorr && volindx == -1) /* if ghostcorr is used it will be volume -1 */
      rspent = L_REF; /* will make zero phase encodes in ksepi_scan_coreslice() */
    else
      rspent = L_SCAN;

    if (opdiffuse == KS_EPI_DIFFUSION_ON) {
      ksepi_diffusion_scan_diffamp(&ksepi, volindx);
    }

    for (passindx = 0; passindx < ks_slice_plan.npasses; passindx++) {

      time += ksepi_scan_acqloop(passindx, volindx, ksepi_multishot_control);

#ifdef IPG
      if ( !((volindx + 1 == opfphases) && (passindx + 1 == ks_slice_plan.npasses)) ) {
        GEReq_endofpass(); /* don't play last time, we rely now on  GEReq_endofpassandscan() in ksepi.e:scan() */
      }
#endif

    } /* end: acqs (pass) loop */

  } /* end: volume loop */

  return time; /* in [us] */

} /* ksepi_scan_scanloop() */





@rspvar
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: RSP variables (accessible on HOST and TGT). Global variables that are used
 *  by multiple functions in scan(). RSP variables can be viewed live on the MR scanner by Display RSP
 *  in the SCAN menu
 *
 *******************************************************************************************************
 *******************************************************************************************************/

int rfspoiling_phase_counter = 0;

@rsp
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation.e: SCAN in @rsp section (functions only accessible on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/**
 *******************************************************************************************************
 @brief #### Common initialization for prescan entry points MPS2 and APS2 as well as the SCAN entry point
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksepi_scan_init(void) {

  GEReq_initRSP();

  /* Here goes code common for APS2, MPS2 and SCAN */

  ks_scan_switch_to_sequence(&ksepi.seqctrl);  /* switch to main sequence */
  scopeon(&seqcore); /* Activate scope for core */
  syncon(&seqcore);  /* Activate sync for core */
  setssitime(ksepi.seqctrl.ssi_time / HW_GRAD_UPDATE_TIME);

  /* can we make these independent on global rsptrigger and rsprot in orderslice? */
  settriggerarray( (short) ks_slice_plan.nslices_per_pass, rsptrigger);

  rfspoiling_phase_counter = 0;

  return SUCCESS;

} /* ksepi_scan_init() */




/**
 *******************************************************************************************************
 @brief #### Prescan loop called from both APS2 and MPS2 entry points
 @retval STATUS `SUCCESS` or `FAILURE`
*******************************************************************************************************/
STATUS ksepi_scan_prescanloop(int nloops, int dda) {
  int i, echoindx, sliceindx, shotindx, sltimeinpass;
  int slloc;

  /* turn off receivers for all echoes (thanks to slice = KS_NOTSET) */
  for (echoindx = 0; echoindx < opnecho; echoindx++) {
    ks_scan_epi_loadecho(&ksepi.epitrain, echoindx, echoindx, KS_NOTSET, NULL, KS_NOTSET);
  }
  if (ksepi_reflines > 0) {
    /* store phase reference echo as opnecho */
    ks_scan_epi_loadecho(&ksepi.epireftrain, 0, opnecho, KS_NOTSET, NULL, KS_NOTSET);
  }

  /* Diffusion gradients must be off during prescan to get the correct receiver gain */
  if (opdiffuse == KS_EPI_DIFFUSION_ON) {
    ksepi_diffusion_scan_diffamp(&ksepi, KS_NOTSET); /* KS_NOTSET zeroes all diffusion gradient amplitudes */
  }

  /* play dummy scans to get into steady state */
  for (i = -dda; i < nloops; i++) {

    /* loop over slices */
    for (sltimeinpass = 0; sltimeinpass < ks_slice_plan.nslices_per_pass; sltimeinpass++) {

      /* slice location from slice plan */
      slloc = ks_scan_getsliceloc(&ks_slice_plan, 0, sltimeinpass);

      /* modify sequence for next playout */
      ksepi_scan_seqstate(ks_scan_info[slloc], KS_NOTSET);

      /* data routing control */
      echoindx = 0; /* just to 1st echo for prescan */
      sliceindx = 0;
      shotindx = 0;
      if (i >= 0) {
        ks_scan_epi_loadecho(&ksepi.epitrain, echoindx, echoindx, sliceindx, NULL, shotindx);
      }

      ks_scan_playsequence(&ksepi.seqctrl);

    } /* for slices */

  } /* for nloops */

  return SUCCESS;

} /* ksepi_scan_prescanloop() */
