/*******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : GERequired.e
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
* @file GERequired.e
* @brief This file has several sections that should be \@inline'd for a main pulse sequence
*        written entirely in KSFoundation EPIC. See instructions for each section on where to \@inline
********************************************************************************************************/




@pulsedef
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: Pulsedef section (EPIC Macros)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Creates a hardware sequence for the current sequence module

 This EPIC macro is adapted from GE's EPIC macro `SEQLENGTH`. The `seqctrl` (KS_SEQ_CONTROL) struct for
 the current sequence module is passed in as the second argument to this function, where
 `seqctrl.duration` holds the information on the duration of the sequence module and passed on to
 `createseq()`. During scanning, ks_scan_playsequence(), which takes a KS_SEQ_CONTROL struct as input,
 internally calls `boffset()` to make a real-time hardware switch to this sequence module by passing in
 `seqctrl.handle.offset` set by KS_SEQLENGTH().

 KS_SEQLENGTH() must be called in `pulsegen()` after the sequence (module) has been layed out using
 various `ks_pg_***` calls. It must also be after GEReq_pulsegenBegin() and before GEReq_pulsegenEnd()
 and `buildinstr()`. The first argument to KS_SEQLENGTH() is GE's name of the pulse sequence
 module, which by convention usually begins with "seq***". The hardware sequence handle is then
 named `off_seq***` and this handle is stored in `seqctrl.handle.offset`.

 #### EPIC macro Parameters
 - arg 1: Name of the sequence module (only used for this function call)
 - arg 2: The KS_SEQ_CONTROL struct for the current sequence module
********************************************************************************************************/
KS_SEQLENGTH(seq_name, seq_struct) {

var: {
#ifndef $[seq_name]_set
#define $[seq_name]_set
#else
#error KS_SEQLENGTH: Sequence name $[seq_name] (arg 1) already taken
#endif
    SEQUENCE_ENTRIES  off_$[seq_name];
    WF_PULSE $[seq_name];
#if defined(HOST_TGT)
    int idx_$[seq_name];   /* sequence entry index */
#endif
  }
insert: predownload => {
  /* dont indent the closing bracket */
}
insert: cvinit => {
  /* dont indent the closing bracket */
}

subst: {
    {
      if ($[seq_struct].duration > 0) {

        if ($[seq_struct].duration - $[seq_struct].ssi_time < 0) {

          ks_error("KS_SEQLENGTH (%s): (.duration - .ssi_time) is negative", $[seq_struct].description);

        } else {

          STATUS status = pulsename(&$[seq_name], "$[seq_name]");
          if (status != SUCCESS) {
            ks_error("KS_SEQLENGTH (%s): pulsename($[seq_name]) failed", $[seq_struct].description);
          }  
          status = createseq(&$[seq_name], $[seq_struct].duration - $[seq_struct].ssi_time, off_$[seq_name]);
          if (status != SUCCESS) {
            ks_error("KS_SEQLENGTH (%s): createseq($[seq_name]) failed", $[seq_struct].description);
          } 

#if defined(HOST_TGT)
          /* Update sequence counter and get current sequence entry index */
          status = updateIndex( &idx_$[seq_name] );
          if (status != SUCCESS) {
            ks_error("KS_SEQLENGTH (%s): updateIndex($[seq_name]) failed", $[seq_struct].description);
          }
          printDebug( DBLEVEL1, (dbLevel_t)seg_debug, "KS_SEQLENGTH",
                      "idx_$[seq_name] = %d\n", idx_$[seq_name] );
          $[seq_struct].handle.index = idx_$[seq_name];
#endif
          /* copy seqyence_enties to the KS_SEQ seq_struct */
          $[seq_struct].handle.offset = off_$[seq_name];
          $[seq_struct].handle.pulse = &$[seq_name];
        } /* duration - ssi_time > 0 */

      } /* duration > 0 */
    }
  }
}


@global
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: Global section
 *
 *******************************************************************************************************
 *******************************************************************************************************/

#define GEREQUIRED_E

#include "grad_rf_empty.globals.h"

#ifndef MAX_ENTRY_POINTS
#define MAX_ENTRY_POINTS 15
#endif

#define MAX_TR_OVERSHOOT 200 /* 200 us round-up allowed per TR */

#if EPIC_RELEASE<26
#define DEFAULT_SCAN_INFO_HEAD .optloc = 0.0, .oprloc = 0.0, .opphasoff = 0.0
#else
#define DEFAULT_SCAN_INFO_HEAD .optloc = 0.0, .oprloc = 0.0, .opphasoff = 0.0, .optloc_shift = 0.0, .oprloc_shift = 0.0, .opphasoff_shift = 0.0, .opfov_freq_scale = 1.0, .opfov_phase_scale = 1.0, .opslthick_scale = 1.0
#endif

/* post-DV24 this is defined in $ESETOP/psd/include/epic_geometry_types.h */
#undef DEFAULT_AXIAL_SCAN_INFO
#define DEFAULT_AXIAL_SCAN_INFO { DEFAULT_SCAN_INFO_HEAD, .oprot = {1.0, 0.0, 0.0, \
                                                                    0.0, 1.0, 0.0, \
                                                                    0.0, 0.0, 1.0}}

#define DEFAULT_AX_SCAN_INFO_FREQ_LR DEFAULT_AXIAL_SCAN_INFO

#define DEFAULT_AX_SCAN_INFO_FREQ_AP { DEFAULT_SCAN_INFO_HEAD, .oprot = {0.0, 1.0, 0.0, \
                                                                        -1.0, 0.0, 0.0, \
                                                                         0.0, 0.0, 1.0}}

#define DEFAULT_SAG_SCAN_INFO_FREQ_SI { DEFAULT_SCAN_INFO_HEAD, .oprot = {0.0, 0.0, 1.0, \
                                                                          0.0, 1.0, 0.0, \
                                                                         -1.0, 0.0, 0.0}}

#define DEFAULT_SAG_SCAN_INFO_FREQ_AP { DEFAULT_SCAN_INFO_HEAD, .oprot = {0.0, 0.0, 1.0, \
                                                                          1.0, 0.0, 0.0, \
                                                                          0.0, 1.0, 0.0}}

#define DEFAULT_COR_SCAN_INFO_FREQ_SI { DEFAULT_SCAN_INFO_HEAD, .oprot = {0.0, 1.0, 0.0, \
                                                                          0.0, 0.0, 1.0, \
                                                                          1.0, 0.0, 0.0}}

#define DEFAULT_COR_SCAN_INFO_FREQ_LR { DEFAULT_SCAN_INFO_HEAD, .oprot = {-1.0, 0.0, 0.0, \
                                                                           0.0, 0.0, 1.0, \
                                                                           0.0, 1.0, 0.0}}


#include <math.h>
#if EPIC_RELEASE<26 && defined(HW_IO)
#include <stdioLib.h>
#else
#include <stdio.h>
#include <stdlib.h>
#endif

#if (EPIC_RELEASE > 27) || (EPIC_RELEASE == 27 && EPIC_PATCHNUM >= 3)
/* RX27_R03 requires bool to be assigned as Prescan.e->PSipg now includes addrfbits.h.
   For now typedef it here for RX27_R03 or later. Long term solution is likely to switch to g++ compiler
   for Host */
typedef int bool;
#endif

#include <string.h>

#include "em_psd_ermes.in"

#include "stddef_ep.h"
#include "epicconf.h"
#include "pulsegen.h"
#include "support_func.h"
#include "epic_error.h"
#include "epicfuns.h"
#include "epic_loadcvs.h"
#include "InitAdvisories.h"
#include "psdiopt.h"
#include "epic_iopt_util.h"
#include "filter.h"

#include <sokPortable.h>  /* includes for option key functionality */


@inline Prescan.e PSglobal

#include "KSFoundation.h"


@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
@inline Prescan.e PSipgexport

RF_PULSE_INFO rfpulseInfo[RF_FREE] = { {0, 0} };
int avail_image_time;
int act_tr; /* required by pulsegen on host (analyze_gradients.c) */

/* used together in scan() instead of rsp_info. Setup in predownload() of the main sequence 
  (epic_geometry_types.h: DEFAULT_AXIAL_SCAN_INFO) */
SCAN_INFO ks_scan_info[SLTAB_MAX] = {DEFAULT_AXIAL_SCAN_INFO}; /* {{0, 0, 0, {0,0,0,0,0,0,0,0,0}}}; */

KS_SLICE_PLAN ks_slice_plan = KS_INIT_SLICEPLAN;

int ks_sarcheckdone = FALSE;

char ks_psdname[256];
int ks_perform_slicetimeplot = FALSE;


@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
@inline loadrheader.e rheadercv
@inline vmx.e SysCVs
@inline Prescan.e PScvs

int obl_debug = 0 with {0, 1, 0, INVIS, "On(=1) to print messages for obloptimize",};
int obl_method = PSD_OBL_OPTIMAL with {PSD_OBL_RESTRICT, PSD_OBL_OPTIMAL, PSD_OBL_OPTIMAL, INVIS, "On(=1) to optimize the targets based on actual rotation matrices",};
/* filter_echo1 must be defined for prescan for the noise measurement */
int filter_echo1 = 0 with {, , , INVIS, "Scan filter slot number needed for prescan",};

int pw_passpacket = 50ms with {10ms, 1000ms, 50ms, VIS, "Duration of the passpacket sequence",};
/* KSFoundation CVs */
int ks_rfconf      = ENBL_RHO1 + ENBL_THETA + ENBL_OMEGA + ENBL_OMEGA_FREQ_XTR1; /* 1 + 4 + 8 + 128 = 141 */
int ks_simscan     = 1 with {0, 1, 1, VIS, "Simulate slice locations if 1 (and in simulation)",};
float ks_srfact    = 1.0 with {0.01, 3.0, 1.0, VIS, "Slewrate factor (low value = slower gradients)",};
float ks_qfact     = 1.0 with {0.1, 40.0, 1.0, VIS, "Quietness factor",};
float ks_gheatfact = 1.0 with {0.0, 1.0, 1.0, VIS, "Degree of honoring gradient heating calculations (0:ignore, 1:fully obey)"};
int ks_plot_filefmt = KS_PLOT_MAKEPNG with {KS_PLOT_OFF,KS_PLOT_MAKEPNG,KS_PLOT_MAKEPNG, VIS, "Plot format 0:off 1:PDF 2:SVG 3:PNG"};
int ks_plot_kstmp = FALSE with {FALSE,TRUE,FALSE, VIS, "0: off 1:Copy plots to mrraw/kstmp"};


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: HOST functions and variables
 *
 *******************************************************************************************************
 *******************************************************************************************************/

#ifndef KS_PSD_USE_APX
#define KS_PSD_USE_APX 0
#endif 

#include "sar_pm.h" /* must be before grad_rf_XXXX.h */
#include "grad_rf_empty.h" /* declaration of rfpulse[] here must be before PShost */

static char supfailfmt[] = "Support routine %s failed";
float maxB1[MAX_ENTRY_POINTS], maxB1Seq;

#include <stdlib.h>
#include <sysDep.h>
#include <sysDepSupport.h>      /* FEC : fieldStrength dependency libraries */

/* unless 24-25x */
%ifndef EPIC_RELEASE_IS_25x
%ifndef EPIC_RELEASE_IS_24x
#include "psdopt.h"
@inline loadrheader.e rheaderhost
%endif
%endif

@inline vmx.e HostDef
@inline Prescan.e PShostVars
@inline Prescan.e PShost
@inline InitAdvisories.e InitAdvPnlCVs



/**
 *******************************************************************************************************
 @brief #### Mandatory GE function. Includes predownload.in

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS calcPulseParams(void) {

#include "predownload.in" /* include 'canned' predownload code */

  return SUCCESS;

} /* calcPulseParams() */




/**
 *******************************************************************************************************
 @brief #### Simulate scan locations in simulation (WTools)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS simscan(void) {

#ifndef PSD_HW

  int i, j;
  int num_slice;
  float z_delta;    /* change in z_loc between slices */
  float r_delta;    /* change in r_loc between slices */
  double alpha, beta, gamma; /* rotation angles about x, y, z respectively */

  num_slice = opslquant;

  r_delta = opfov / num_slice;
  z_delta = opslthick + opslspace;

  ks_scan_info[0].optloc = - 0.5 * z_delta * (num_slice - 1);
  ks_scan_info[0].oprloc = 0;

  for (i = 1; i < 9; i++)
    ks_scan_info[0].oprot[i] = 0.0;

  switch (exist(opplane)) {
  case PSD_AXIAL:
    ks_scan_info[0].oprot[0] = 1.0;
    ks_scan_info[0].oprot[4] = 1.0;
    ks_scan_info[0].oprot[8] = 1.0;
    break;
  case PSD_SAG:
    ks_scan_info[0].oprot[2] = 1.0;
    ks_scan_info[0].oprot[4] = 1.0;
    ks_scan_info[0].oprot[6] = 1.0;
    break;
  case PSD_COR:
    ks_scan_info[0].oprot[2] = 1.0;
    ks_scan_info[0].oprot[6] = 1.0;
    ks_scan_info[0].oprot[7] = 1.0;
    break;
  case PSD_OBL:
    alpha = PI / 4.0; /* rotation about x (applied first) */
    beta = 0;   /* rotation about y (applied 2nd) */
    gamma = 0;  /* rotation about z (applied 3rd) */
    ks_scan_info[0].oprot[0] = cos(gamma) * cos(beta);
    ks_scan_info[0].oprot[1] = cos(gamma) * sin(beta) * sin(alpha) -
                            sin(gamma) * cos(alpha);
    ks_scan_info[0].oprot[2] = cos(gamma) * sin(beta) * cos(alpha) +
                            sin(gamma) * sin(alpha);
    ks_scan_info[0].oprot[3] = sin(gamma) * cos(beta);
    ks_scan_info[0].oprot[4] = sin(gamma) * sin(beta) * sin(alpha) +
                            cos(gamma) * cos(alpha);
    ks_scan_info[0].oprot[5] = sin(gamma) * sin(beta) * cos(alpha) -
                            cos(gamma) * sin(alpha);
    ks_scan_info[0].oprot[6] = -sin(beta);
    ks_scan_info[0].oprot[7] = cos(beta) * sin(alpha);
    ks_scan_info[0].oprot[8] = cos(beta) * cos(alpha);
    break;
  }

  for (i = 1; i < num_slice; i++) {
    ks_scan_info[i].optloc = ks_scan_info[i - 1].optloc + z_delta;
    ks_scan_info[i].oprloc = i * r_delta;
    for (j = 0; j < 9; j++)
      ks_scan_info[i].oprot[j] = ks_scan_info[0].oprot[j];
  }

#endif /* ifdef SIM */

  return SUCCESS;

} /* simscan() */



/**
 *******************************************************************************************************
 @brief #### Initialize logical and physical gradient specifications

 This function calls inittargets() to get the physical gradient characteristics from the MR-system, 
 followed by a call to obloptimize() (slice angulation dependence) to get the logical gradient 
 specifications for the current slice angulation.

 The ramp times (loggrd.xrt/yrt/zrt) are quite conservative (and longer than the ramptimes for phygrd).
 Preliminary testing indicates that the difference between the loggrd and phygrad structs can be reduced 
 by a factor of two (not very scientific!) as a standard measure.

 For further control over the slewrate, the `srfact` argument is passed to ks_init_slewratecontrol(), 
 which can both slow down and increase the gradient slewrate.

 @param[out] loggrd The global logical gradient specification struct (dependent on slice angulation via
 global SCAN_INFO scan_info[] struct).

 @param[out] phygrd The global physical gradient struct
 @param[in] srfact
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_init_gradspecs(LOG_GRAD *loggrd, PHYS_GRAD *phygrd, float srfact) {
  int initnewgeo = 1;

  /* default gradient specs */
  inittargets(loggrd, phygrd);

  /* optimal loggrd based on current slice angulations */
  if (obloptimize(loggrd, phygrd, scan_info, exist(opslquant),
                  ((obl_method==PSD_OBL_RESTRICT) ? 4 /*oblique plane*/ : opphysplane), exist(opcoax), (int) obl_method,
                  exist(obl_debug), &initnewgeo, cfsrmode) == FAILURE) {
    return ks_error("ks_init_loggrd: obloptimize failed");
  }

  /* obloptimize() ramptimes too conservative, let's cut the difference
     between loggrd.xrt and phygrd.xrt in half */
  loggrd->xrt = (loggrd->xrt - phygrd->xrt) / 2 + phygrd->xrt;
  loggrd->yrt = (loggrd->yrt - phygrd->yrt) / 2 + phygrd->yrt;
  loggrd->zrt = (loggrd->zrt - phygrd->zrt) / 2 + phygrd->zrt;

  /* reduce slewrate if srfact < 1 */
  if (ks_init_slewratecontrol(loggrd, phygrd, srfact) == FAILURE)
    return FAILURE;

  return SUCCESS;

} /* GEReq_init_gradspecs() */




/**
 *******************************************************************************************************
 @brief #### Sets up the menu for parallel imaging (ARC or ASSET) with max/min range

 @param[in] integeraccel Flag to make acceleration menu contain only integer acceleration factors
                          enums: KS_ARCMENU_FRACTACCEL (0), KS_ARCMENU_INTACCEL (1)
 @param[in] maxaccel     Maximum allowed acceleration factor for the sequence
 @retval    STATUS      `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_init_accelUI(int integeraccel, int maxaccel) {

  /* Acceleration menu */
  cfaccel_ph_maxstride = maxaccel;
  cvmax(opaccel_ph_stride, cfaccel_ph_maxstride);
  avminaccel_ph_stride = 1.0;
  avmaxaccel_ph_stride = cfaccel_ph_maxstride;
  piarccoilrestrict = 1; /* disable ARC option for single-channel coil (cf. epic.h) */

  if (KS_3D_SELECTED) { /* PSD_3D or PSD_3DM */
    cfaccel_sl_maxstride = maxaccel;
    cvmax(opaccel_sl_stride, cfaccel_sl_maxstride);
    avminaccel_sl_stride = 1.0;
    avmaxaccel_sl_stride = cfaccel_sl_maxstride;
  }

  if ((oparc || opasset == ASSET_SCAN) && maxaccel > 1) {
    if (integeraccel) {
      piaccel_phnub = 1 + maxaccel;
      piaccel_phval2 = 1.0;
      piaccel_phval3 = 2.0;
      piaccel_phval4 = 3.0;
      piaccel_phval5 = 4.0;
      piaccel_phval6 = 5.0;
      piaccel_phedit = 0; /* don't allow user to type in value */
    } else {
      piaccel_phnub = IMin(2, 6, maxaccel * 2);
      piaccel_phval2 = 1.0;
      piaccel_phval3 = 1.5;
      piaccel_phval4 = 2.0;
      piaccel_phval5 = 2.5;
      piaccel_phval6 = 3.0;
      piaccel_phedit = 1;
    }
    piaccel_ph_stride = 2.0;
    if (KS_3D_SELECTED) {
      if (integeraccel) {
        piaccel_slnub = 1 + maxaccel;
        piaccel_slval2 = 1.0;
        piaccel_slval3 = 2.0;
        piaccel_slval4 = 3.0;
        piaccel_slval5 = 4.0;
        piaccel_slval6 = 5.0;
        piaccel_sledit = 0; /* don't allow user to type in value */
      } else {
        piaccel_slnub = IMin(2, 6, maxaccel * 2);
        piaccel_slval2 = 1.0;
        piaccel_slval3 = 1.5;
        piaccel_slval4 = 2.0;
        piaccel_slval5 = 2.5;
        piaccel_slval6 = 3.0;
        piaccel_sledit = 1;
      }
      piaccel_sl_stride = 1.0;
    } else {
      piaccel_slnub = 0;
    }
  } else {
    piaccel_phnub = 0;
    piaccel_slnub = 0;
    cvoverride(opaccel_ph_stride, 1.0, PSD_FIX_OFF, PSD_EXIST_OFF);
    cvoverride(opaccel_sl_stride, 1.0, PSD_FIX_OFF, PSD_EXIST_OFF);
  }

  return SUCCESS;

} /* GEReq_init_accelUI() */





/**
 *******************************************************************************************************
 @brief #### Calculate the number of slices per TR and TR padding time (2D imaging)

 This function calculates the number of slices that can fit in one TR (optr) based on the duration and
 occurences of the sequence modules in the sequence collection (KS_SEQ_COLLECTION) determined by calling
 the sequence sliceloop (wrapper) function.

 As the number of arguments to the sequence's sliceloop is psd-dependent, the function pointer
 `play_loop` must be a wrapper function to the sliceloop function taking standardized input arguments
 `(int) nargs` and `(void **) args`. This sliceloop wrapper function must be on the form:
 `int sliceloop_nargs(int slperpass, int nargs, void **args);`
 returning the duration in [us] to play out `slperpass` number of slices.
 If the sliceloop function does not need any additional input arguments, `nargs = 0`, and `args = NULL`.

 The minimum allowed TR is determined by ks_eval_mintr(), which honors SAR/heating limitations. If
 `opautotr = 1`, `optr` will be updated here, otherwise if `optr` is too short, an error will be returned
 to the operator.

 The calling function can specify the minimum acqs that are allowed, as well as a minimum and maximum TR
 interval. Setting `maxtr = 0` disables the upper TR limit. Setting `requested_minacqs <= 1`, disables
 the min acqs requirement.

 This function should be called at the end of cveval() after all sequence modules have been set up and
 dry-runned on host by calling each sequence module's `****_pg()` function. See also the documentation for
 KS_SEQ_CONTROL and KS_SEQ_COLLECTION.

 @param[out] slperpass Number of slices that can fit within each TR
 @param[out] timetoadd_perTR The total time in [us] that must be distributed manually to one or more
             sequence modules after the call to GEReq_eval_TR() in order to meet the desired TR
 @param[in] requested_minacqs The desired minimum number of acquisitions (passes)
 @param[in] mintr Lowest allowed TR in [us]
 @param[in] maxtr Highest allowed TR in [us]. 0: Disabled
 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] play_loop Function pointer to (the wrapper function to) the sliceloop function of the sequence
 @param[in] nargs Number of extra input arguments to the sliceloop wrapper function.
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's sliceloop function
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_eval_TRrange(int *slperpass, int *timetoadd_perTR, int requested_minacqs, int mintr, int maxtr, KS_SEQ_COLLECTION *seqcollection,
                                 int (*play_loop)(int /*nslices*/, int /*nargs*/, void ** /*args*/), int nargs, void **args) {
  STATUS status;
  int numacqs = 0;
  int i;
  int numrfexclocations = (KS_3D_SELECTED) ? exist(opvquant) : exist(opslquant);
  int slicetime;
  int nslices_perTR = KS_NOTSET;
  int nslices_shortest_scantime = KS_NOTSET;
  int lowest_scantime = KS_NOTSET;
  int singleslice_time = KS_NOTSET;
  int requested_maxslices = KS_NOTSET;
  int maxslices_time = KS_NOTSET;

  /* if another function has already performed TR timing calcs, don't do it again */
  if (seqcollection->evaltrdone == TRUE) {
    return SUCCESS;
  }
  
  if (seqcollection == NULL || seqcollection->numseq == 0) {
    return ks_error("%s: Please add pulse sequence modules to the sequence collection before calling this function", __FUNCTION__);
  }

  if (mintr < 0 || maxtr < 0) {
    return ks_error("%s: min/max TR cannot be negative", __FUNCTION__);
  } else if ((maxtr > 0) && (maxtr <= mintr)) {
    return ks_error("%s: max TR must be > minTR, or 0 (disabled)", __FUNCTION__);
  }

  /* make sure seqctrl.duration at least equal to seqctrl.min_duration */
  status = ks_eval_seqcollection_durations_atleastminimum(seqcollection);
  if (status != SUCCESS) return FAILURE;

  singleslice_time = ks_eval_mintr(1, seqcollection, ks_gheatfact, play_loop, nargs, args);
  if (singleslice_time <= 0) return FAILURE;

  if ((maxtr > 0) && (maxtr < singleslice_time)) {
    return ks_error("%s: Max TR must be > %.1f ms", __FUNCTION__, singleslice_time / 1000.0);
  }
  if ((mintr > 0) && (mintr < singleslice_time)) {
    return ks_error("%s: Min TR must be > %.1f ms", __FUNCTION__, singleslice_time / 1000.0);
  }
    if ((maxtr > 0) && ((maxtr - mintr) < singleslice_time)) {
    return ks_error("%s: The TR interval must be > %.1f ms", __FUNCTION__, singleslice_time / 1000.0);
  }

  /* #acqs cannot exceed #slices. If sequential scanning, #acqs = #slices */
  if (requested_minacqs < 1) {
    requested_minacqs = 1;
  } else if ((requested_minacqs > numrfexclocations) || (opirmode == TRUE)) {
    requested_minacqs = numrfexclocations;
  }
  requested_maxslices = CEIL_DIV(numrfexclocations, requested_minacqs);
  maxslices_time = ks_eval_mintr(requested_maxslices, seqcollection, ks_gheatfact, play_loop, nargs, args);



  if (opautotr) {  /* AutoTR: User selected pitrval2 = PSD_MINIMUMTR */

    if (maxtr > 0 || mintr > 0) { /* in-range autoTR */

      /* Check which combination that results in the lowest scan time, and max/min # slices in range */
      for (i = 1; i <= numrfexclocations; i++) {
        numacqs = CEIL_DIV(numrfexclocations, i);
        slicetime = ks_eval_mintr(i, seqcollection, ks_gheatfact, play_loop, nargs, args);
        if (slicetime >= mintr && (maxtr == 0 || slicetime <= maxtr) && (numacqs >= requested_minacqs)) {
          if (lowest_scantime == KS_NOTSET) {
            nslices_shortest_scantime = i;
            lowest_scantime = slicetime * numacqs;
          } else if (slicetime * numacqs <= lowest_scantime * 1.01) {
            /* 1.01 to avoid round-off effects of slicetime and to slightly favor fewer acqs and longer TRs
            when the scantime is nearly identical */
            nslices_shortest_scantime = i;
            lowest_scantime = slicetime * numacqs;
          }
        }
      }

      if (lowest_scantime == KS_NOTSET) {
        /* failed to find solution within the interval, the range is probably too high for the set
           of slices.  Need to add padding to reach mintr. This
             is done by setting optr = avmintr = mintr (see also timetoadd_perTR below)*/
        if (maxslices_time < mintr) {
          nslices_perTR = requested_maxslices;
          avmintr = mintr;
        } else {
          return ks_error("%s: Programming error", __FUNCTION__);
        }
      } else {
        nslices_perTR = nslices_shortest_scantime;
        avmintr = ks_eval_mintr(nslices_perTR, seqcollection, ks_gheatfact, play_loop, nargs, args);
      }

    } else { /* minimum TR (using requested_minacqs) */

      nslices_perTR = requested_maxslices;
      avmintr = ks_eval_mintr(nslices_perTR, seqcollection, ks_gheatfact, play_loop, nargs, args);

    }

    avmaxtr = avmintr;
    cvoverride(optr, avmintr, PSD_FIX_ON, PSD_EXIST_ON);

  } else { /* Manual TR */

    avmintr = singleslice_time;
    avmaxtr = _optr.maxval;

    /* how many slices can we MAXIMALLY fit in one TR ? */
    if (opirmode == 1) { /* sequential */
      nslices_perTR = 1;
    } else {
      if (existcv(optr)) {
        if (optr < avmintr)
          return ks_error("%s: Increase the TR to %.1f ms", __FUNCTION__, avmintr / 1000.0);
        if ((mintr > 0) && (optr < mintr))
          return ks_error("%s: Increase the TR to %.1f ms", __FUNCTION__, mintr / 1000.0);
        if ((maxtr > 0) && (optr > maxtr))
          return ks_error("%s: Decrease the TR to %.1f ms", __FUNCTION__, maxtr / 1000.0);
      }      
      nslices_perTR = ks_eval_maxslicespertr(exist(optr), seqcollection, ks_gheatfact, play_loop, nargs, args);
      nslices_perTR = IMax(2, 1, nslices_perTR); /* safeguard against < 1 */
    }

  } /* Auto/Manual TR */


  /* how many acqs (runs) do we need to get all prescribed slices ? */
  numacqs = CEIL_DIV(numrfexclocations, nslices_perTR);

  /* how many slices SHOULD we play out per pass (keeping numrfexclocations and numacqs)?
     This may be less than nslices_perTR depending on divisibility */
  *slperpass = CEIL_DIV(numrfexclocations, numacqs); /* round up */

  /* run once more with the actual number of slices per TR, mostly so that ks_eval_gradrflimits() will set the
  description of `optr` correctly */
  ks_eval_mintr(*slperpass, seqcollection, ks_gheatfact, play_loop, nargs, args);

  /* run before each call to function pointer `play_loop()` (next line) to set all `seqctrl.ninst` to 0 */
  ks_eval_seqcollection_resetninst(seqcollection);

  /* Update seqcollection.seqctrl[*].ninst given '*slperpass' number of slices
     time [us] for one sequence playout incl. the SSI time and necessary dead time to
     make up the expected TR. To be used in KS_SEQLENGTH() in pulsegen() */
  *timetoadd_perTR = exist(optr) - play_loop(*slperpass, nargs, args);

  /* prevent further addition of new sequence modules */
  seqcollection->mode = KS_SEQ_COLLECTION_LOCKED;

  /* Flag that we have completed this function */
  seqcollection->evaltrdone = TRUE;



  /* Set UI and advisory panel variables */
  avail_image_time = RDN_GRD(exist(optr));
  act_tr = avail_image_time;
  ihtr = act_tr; /* image header TR */

  avminslquant = 1;
  if (KS_3D_SELECTED == FALSE) {
  avmaxslquant = nslices_perTR; /* UI value ("Max # Slices:") */
  avmaxacqs = numacqs; /* UI value ("# of Acqs:") */
  } else {
    avmaxslquant = 2048;
    avmaxacqs = 1;
  }

  return SUCCESS;

} /* GEReq_eval_TRrange() */




STATUS GEReq_eval_TR(int *slperpass, int *timetoadd_perTR, int requested_minacqs, KS_SEQ_COLLECTION *seqcollection,
                                 int (*play_loop)(int /*nslices*/, int /*nargs*/, void ** /*args*/), int nargs, void **args) {
 
  return GEReq_eval_TRrange(slperpass, timetoadd_perTR, requested_minacqs, 0, 0, seqcollection, play_loop, nargs, args);


} /* GEReq_eval_TR() */




/**
 *******************************************************************************************************
 @brief #### Performs RF scaling of all RF pulses in the KS_SEQ_COLLECTION and Prescan
 
 RF scaling is a complicated process across RF pulses in scan (multiple sequence modules) and prescan, 
 where the desired flip angles should be met partly using the maxB1 info for each RF pulse and scale
 it relative to the prescan result. This is done via a combination of scan and prescan attenuation factors 
 (xmtaddScan) in the `entry_point_table[]`, an extra global scaling factor, and change of the (instruction)
 amplitude of each RF pulse.

 This function performs all these tasks using a KS_SEQ_COLLECTION as input. The sequence collection struct
 contains one KS_SEQ_CONTROL struct for each sequence module, which via the field `gradrf.rfptr[]` has
 access to all KS_RF objects in the sequence module. As the `***_pg()` function for each sequence module
 should have been called prior to this function, the number of occurrences of each RF pulse is known.
 Moreover, the rfstat specification for every RF pulse is located in:
 seqcollection->seqctrl[]->gradrf->rfptr[]->rf.rfpulse
 which is used by ks_eval_seqcollection2rfpulse() to rewrite the global `rfpulse[]` struct array required
 by GE's RF scaling functions peakB1() and setScale().

 At the end of this function, the seqcollection mode is locked, preventing accidental addition of new
 sequence modules to the seqcollection using ks_eval_addtoseqcollection(). Moreover, each sequence module
 will have its `rfscalingdone` field set to TRUE to signal to ks_pg_rf() that the RF pulse belonging to 
 that sequence module has indeed been RF scaled properly. This extra safety mechanism makes it difficult
 to use ks_pg_rf() without first passing through this function and have the seqcollection struct set up.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_eval_rfscaling(KS_SEQ_COLLECTION *seqcollection) {
  int i;
  STATUS status;


  if (seqcollection == NULL || seqcollection->numseq == 0) {
    return ks_error("%s: Please add pulse sequence modules to the sequence collection before calling this function", __FUNCTION__);
  }

  /* use global rfpulse[] array (that is also featuring in Prescan.e) */
  for (i = 0; i < KS_MAXUNIQUE_RF; i++) {
    rfpulse[i].activity = 0;
  }

  /* Update the global RF pulse array rfpulse[] with the contents of the RF pulses in the sequence modules.
     This also includes resetting all .activity fields to zero for the first KS_MAXUNIQUE_RF elements in rfpulse[] */
  status = ks_eval_seqcollection2rfpulse(rfpulse, seqcollection);
  if (status != SUCCESS) return status;


  /* find the peak B1 for each entry point and the max B1 across all entry points */
#if EPIC_RELEASE >= 24
  status = findMaxB1Seq(&maxB1Seq, maxB1, MAX_ENTRY_POINTS, rfpulse, RF_FREE);
  if (status != SUCCESS) {
    return ks_error("%s: findMaxB1Seq() failed", __FUNCTION__);
  }
#else
  {
    int entry;
    maxB1Seq = 0.0;
    for (entry = 0; entry < MAX_ENTRY_POINTS; entry++) {
      status = peakB1(&maxB1[entry], entry, RF_FREE, rfpulse);
      if (status != SUCCESS) {
        return ks_error("%s: peakB1() failed", __FUNCTION__);
      }
      if (maxB1[entry] > maxB1Seq) {
        maxB1Seq = maxB1[entry];
      }
    } /* for */
  }
#endif

  /* RF: How much do we need to attenuate the RF pulses in scan. */
  double my_xmtaddScan = -200 * log10(maxB1[L_SCAN] / maxB1Seq) + getCoilAtten();
  if (my_xmtaddScan > cfdbmax) {
    extraScale = (float) pow(10.0, (cfdbmax - my_xmtaddScan) / 200.0); /* N.B.: 'extraScale' is declared as CV in Prescan.e */
    my_xmtaddScan = cfdbmax;
  } else {
    extraScale = 1.0;
  }

  /* RF: Scale the rfpulse amplitudes */
  status = setScale(L_SCAN, RF_FREE, rfpulse, maxB1[L_SCAN], extraScale);
  if (status != SUCCESS) {
    return ks_error("%s: setScale failed", __FUNCTION__);
  }

  /* fill entry_point_table */
  status = entrytabinit(entry_point_table, (int)ENTRY_POINT_MAX);
  if (status != SUCCESS) {
    return ks_error("%s: entrytabinit() failed", __FUNCTION__);
  }
  strcpy( entry_point_table[L_SCAN].epname, "scan");
  entry_point_table[L_SCAN].epxmtadd = (short)rint( (double) my_xmtaddScan);
  entry_point_table[L_SCAN].epstartrec = rhdab0s;
  entry_point_table[L_SCAN].ependrec = rhdab0e;
  entry_point_table[L_SCAN].epfastrec = 0;
  entry_point_table[L_APS2] = entry_point_table[L_MPS2] = entry_point_table[L_SCAN];
  strcpy(entry_point_table[L_APS2].epname, "aps2");
  strcpy(entry_point_table[L_MPS2].epname, "mps2");

  /* Prescan: Final RF scaling of the Prescan entries, using the maxB1[] and maxB1Seq values computed above */
@inline Prescan.e PSpredownload

  /* prevent further addition of new sequence modules */
  seqcollection->mode = KS_SEQ_COLLECTION_LOCKED;

  /* Flag each sequence module that RF scaling has been done */
  for (i = 0; i < seqcollection->numseq; i++) {
    seqcollection->seqctrlptr[i]->rfscalingdone = TRUE;
  }

  return SUCCESS;

} /* GEReq_eval_rfscaling() */




/**
 *******************************************************************************************************
 @brief #### Checks that sequence modules sum up to TR, honoring SAR/heating limits
 
 This function is called by GEReq_eval_checkTR_SAR() (non-inversion use) and ksinv_eval_checkTR_SAR()
 (inversion use) to check that the sequence modules played out in the slice loop sum up to the specified
 TR (optr) accounting for SAR/heating limits. Moreover, the SAR values are updated in the UI, and the 
 CV ks_sarcheckdone is set to TRUE. This CV is set to FALSE in GEReq_cvinit() and check whether it is
 TRUE in GEReq_predownload() to make sure SAR calculation have been performed before scanning.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] intended_time Usually repetition time (optr) if this function was called from 
            GEReq_eval_checkTR_SAR(), but should correspond to the intended time to play the corresponding
            number of sequence instances now set in seqcollection[]->seqctrl.ninst
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_eval_checkTR_SAR_calcs(KS_SEQ_COLLECTION *seqcollection, int intended_time) {
  KS_SAR sar;
  int duration_withinlimits;
  int nettime;
  STATUS status;

  if (seqcollection->evaltrdone == FALSE) {
    return ks_error("%s: Please call GEReq_eval_TR() before calling this function", __FUNCTION__);
  }

  /* Print out the sequence collection time table. In simulation it appears in the WTools main window */
#ifdef PSD_HW
    FILE *fp = fopen("/usr/g/mrraw/seqcollection.txt", "w");
    ks_print_seqcollection(seqcollection, fp);
    fclose(fp);
#else
    ks_print_seqcollection(seqcollection, stderr);
#endif

  /*
  The duration based on the sequence collection struct, which is the product .nseqinstances and .duration fields in each sequence
  modules, summed over all sequence modules.
  The .nseqinstances field becomes > 0 by the call to: GEReq_eval_TR()->ks_eval_mintr()->play_loop()->ks_scan_playsequence()
  The .duration field is initially set to .min_duration by GEReq_eval_TR()->ks_eval_seqcollection_durations_atleastminimum(), but the
  .duration field of at least one sequence module should have been set larger than its .min_duration based on the amount of
  timetoadd_perTR returned by GEReq_eval_TR()  */
  nettime = ks_eval_seqcollection_gettotalduration(seqcollection);
  if (nettime <= 0) {
    
    return FAILURE;
  }

  /* duration_withinlimits = nettime + grad/RF SAR/heat penalty time */
  duration_withinlimits = ks_eval_gradrflimits(&sar, seqcollection, ks_gheatfact);
  if (duration_withinlimits == KS_NOTSET) {
    return FAILURE;
  }

  /* Make sure the global RF pulse array rfpulse[] is updated with the contents of the RF pulses in the sequence modules.
     This also includes resetting all .activity fields to zero for the first KS_MAXUNIQUE_RF elements in rfpulse[] */
  status = ks_eval_seqcollection2rfpulse(rfpulse, seqcollection);
  if (status != SUCCESS) return status;


  /* report to UI */
  piasar = (float) sar.average;
  picasar = (float) sar.coil;
  pipsar = (float) sar.peak;
#if EPIC_RELEASE >= 24
  pib1rms = (float) sar.b1rms;
#endif

  if (existcv(opslquant) == FALSE) {
    /* if #slices has not been set yet, hold on complaining */
    return SUCCESS;
  }

  if (nettime < duration_withinlimits) {
    return ks_error("%s: Duration of seq. modules (%d) < grad/rf limits (%d)", __FUNCTION__, nettime, duration_withinlimits);
  }
  if (nettime < intended_time) {
    return ks_error("%s: Duration of seq. modules (%d) < %d", __FUNCTION__, nettime, intended_time);
  }

  if (nettime - intended_time > MAX_TR_OVERSHOOT) {
    /* small excess in nettime is expected due to roundups of .duration to nearest 4us, but we cannot accept too much */
    /* return */ ks_error("%s: Duration of seq. modules (%d) %d us too long", __FUNCTION__, nettime, nettime - intended_time);
  }

#if EPIC_RELEASE > 27 || (EPIC_RELEASE == 27 && EPIC_PATCHNUM > 1)
  status = setupPowerMonitor(&entry_point_table[L_SCAN], sar.average);
#else  
  status = setupPowerMonitor(&entry_point_table[L_SCAN], L_SCAN, RF_FREE, rfpulse,
                             nettime, sar.average, sar.coil, sar.peak);
#endif                             
  if (status != SUCCESS) {
    return ks_error("%s: setupPowerMonitor failed", __FUNCTION__);
  }

  /* prevent further addition of new sequence modules */
  seqcollection->mode = KS_SEQ_COLLECTION_LOCKED;


  /* Flag that SAR check has been done */
  ks_sarcheckdone = TRUE;

  return SUCCESS;

} /* GEReq_eval_checkTR_SAR_calcs() */




/**
 *******************************************************************************************************
 @brief #### Runs the slice loop and validates TR and SAR/hardware limits

 This function first makes sure that the `.nseqinstances` field for each sequence module in the sequence
 collection corresponds to the number of times played out in the sequence's sliceloop function.

 In simulation (WTools), ks_print_seqcollection() will print out a table of the sequence modules in
 the sequence collection in the WToolsMgd window.

 Finally, GEReq_eval_checkTR_SAR_calcs() is called to check that the TR is correct and within SAR/hardware
 limits.

 N.B.: For inversion sequences, ksinv_eval_checkTR_SAR() is used to do the same thing, with the difference
 that ksinv_scan_sliceloop() is used instead.

 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] nslices Number of slices in TR
 @param[in] play_loop Function pointer to (the wrapper function to) the sliceloop function
 @param[in] nargs Number of extra input arguments to the sliceloop wrapper function.
 @param[in] args  Void pointer array pointing to the variables containing the actual values needed for
                       the sliceloop function
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_eval_checkTR_SAR(KS_SEQ_COLLECTION *seqcollection, int nslices, int (*play_loop)(int /*nslices*/, int /*nargs*/, void ** /*args*/), int nargs, void **args) {

  if (seqcollection == NULL || seqcollection->numseq == 0) {
    return ks_error("%s: Please add pulse sequence modules to the sequence collection before calling this function", __FUNCTION__);
  }

  /* set all `seqctrl.nseqinstances` to 0 */
  ks_eval_seqcollection_resetninst(seqcollection);
  play_loop(nslices, nargs, args); /* => seqctrl.nseqinstances = # times each seq. module has been played out */

  return GEReq_eval_checkTR_SAR_calcs(seqcollection, optr);

} /* GEReq_eval_checkTR_SAR() */




/**
 *******************************************************************************************************
 @brief #### Sets mandatory global GE arrays for data acquisition

 The following global GE arrays are set based on slperpass (arg 1) and global op** variables:
    - `data_acq_order[]`: Critical for scanning
    - `rsp_info[]`: Copied from scan_info[] (the graphically prescibed slices), for conformance. Is a 
       temporally sorted version
       of scan_info[] with integer rotation matrices. Not needed for scanning.
    - `rsptrigger[]`: Set to TRIG_INTERN for now.

    data_acq_order[] is only available on HOST, why this function also copies data_acq_order[] to 
    ks_data_acq_order[], which is an `ipgexport` array accessible on both HOST and TGT. This can be used
    by ks_scan_getsliceloc() to be independent on rsp_info[] during scan.

 The slice plan is stored as a text file ("ks_sliceplan.txt") in the current directory in simulation and in
 /usr/g/mrraw on the MR scanner by calling ks_print_sliceplan().

 @param[in] slice_plan The current slice plan (KS_SLICE_PLAN) set up for the sequence (see ks_calc_sliceplan())
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_store_sliceplan(KS_SLICE_PLAN slice_plan) {
  int i, j, time;

  if (CEIL_DIV(slice_plan.nslices, slice_plan.nslices_per_pass) != slice_plan.npasses) {
    return ks_error("%s: inconsistent slice plan - #acqs", __FUNCTION__);
  }

  if (!KS_3D_SELECTED && slice_plan.nslices != exist(opslquant)) {
    return ks_error("%s: inconsistent slice plan - #slices", __FUNCTION__);
  }

  /* initialize rsp_info, rtsprot and rsptrigger */
  for (i = 0; i < DATA_ACQ_MAX; i++) {
    rsp_info[i].rsptloc = 0;
    rsp_info[i].rsprloc = 0;
    rsp_info[i].rspphasoff = 0;
    rsptrigger[i] = TRIG_INTERN;
    for (j = 0; j < 9; j++)
      rsprot[i][j] = 0;
  }

  /* copy to global data_acq_order, which must be correct for main sequence or scan will not start */
  for (i = 0; i < slice_plan.nslices; i++) {
    data_acq_order[i].slloc = slice_plan.acq_order[i].slloc;
    data_acq_order[i].slpass = slice_plan.acq_order[i].slpass;
    data_acq_order[i].sltime = slice_plan.acq_order[i].sltime;
  } /* for slice locations */

  for (i = slice_plan.nslices; i < SLICE_FACTOR*DATA_ACQ_MAX; i++) {
    data_acq_order[i].slloc = 0;
    data_acq_order[i].slpass = 0;
    data_acq_order[i].sltime = 0;
  } /* for rest of data_acq_order */

  time = 0;
  for (i = 0; i < slice_plan.npasses; ++i) {
    for (j = 0; j < slice_plan.nslices_per_pass; ++j) {
      int slloc = ks_scan_getsliceloc(&slice_plan, i, j);
      if (slloc == KS_NOTSET) {continue;}

      rsp_info[time].rsptloc = scan_info[slloc].optloc;
      rsp_info[time].rsprloc = scan_info[slloc].oprloc;
      rsp_info[time].rspphasoff = scan_info[slloc].opphasoff;

      scale(&scan_info[slloc].oprot, &rsprot[time], 1, &loggrd, &phygrd, 0);

      /* Future: here we could change to a variable to support gating. TRIG_ECG, TRIG_AUX etc */
      rsptrigger[time] = TRIG_INTERN;

      ++time;
    }
  }

  STATUS status = calcChecksumScanInfo(&chksum_scaninfo, scan_info, slice_plan.nslices, psdcrucial_debug);
  if (status != SUCCESS) {
    epic_error(1, "PSD data integrity violation detected in PSD, Please try again or restart the system.",
               EM_PSD_PSDCRUCIAL_DATA_FAILURE, EE_ARGS(1), SYSLOG_ARG);
    return status;
  }

  /* Save acquisition table to disk for debugging */
#ifdef PSD_HW
  FILE *daqfp = fopen("/usr/g/mrraw/ks_sliceplan.txt", "w");
#else
  FILE *daqfp = fopen("./ks_sliceplan.txt", "w");
#endif

  ks_print_sliceplan(slice_plan, daqfp);

  fclose(daqfp);


  /* set GE acqs and slquant1 CVs for look and feel */
  _slquant1.fixedflag = 0;
  _acqs.fixedflag = 0;
  slquant1 = slice_plan.nslices_per_pass;
  acqs = slice_plan.npasses;
  /* prescan */
  picalmode = 0;
  pislquant = slquant1;

  return SUCCESS;

}



/**
 *******************************************************************************************************
 @brief #### Sets mandatory global GE arrays for data acquisition (3D imaging)

 The following global GE arrays are set based on slperpass (arg 1) and global op** variables:
    - `data_acq_order[]`: Critical for scanning
    - `rsp_info[]`: Copied from scan_info[] (the graphically prescibed slices), for conformance. Is a 
       temporally sorted version
       of scan_info[] with integer rotation matrices. Not needed for scanning.
    - `rsptrigger[]`: Set to TRIG_INTERN for now.

    data_acq_order[] is only available on HOST, why this function also copies data_acq_order[] to 
    ks_data_acq_order[], which is an `ipgexport` array accessible on both HOST and TGT. This can be used
    by ks_scan_getsliceloc() to be independent on rsp_info[] during scan.

 
 GEReq_predownload_store_sliceplan3D() has different input args compared to the 2D version. Here,
 a temporary slice plan is created based on slices_in_slab and slabs in order to create the proper
 content of data_acq_order[]. Note that it wouldn't have worked to pass ks_slice_plan for 3D. This is because
 we need a ks_slice_plan that is consistent with RF excitations for 2D, 3D, 3DMS in each sequence's 
 looping structure in scan. For 3D, this very ks_slice_plan can then not also create the proper data_acq_order
 array here. This is why we pass in slices_in_slab and slabs instead and create e temp slice plan solely
 for the purpose of data_acq_order.

 @param[in] slices_in_slab Number of slices in a slab
 @param[in] slabs Number slabs
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_store_sliceplan3D(int slices_in_slab, int slabs) {
  KS_SLICE_PLAN slice_plan;

  /* TODO: unclear for 3D MS, inteleaved and sequential */
  ks_calc_sliceplan_interleaved(&slice_plan, slices_in_slab * slabs, slices_in_slab, 1);

  return GEReq_predownload_store_sliceplan(slice_plan);

  }


/**
 *******************************************************************************************************
 @brief #### Assigns a global filter slot for a main sequence

 This function must be called in predownload() after GE's initfilter() function, which resets all filter
 slots for scan and prescan entry points. The initfilter() function is called in GEReq_cvinit().

 Given the FILTER_INFO of the acquisition window for the main pulse sequence (arg 1), this function 
 assigns a new slot number (that matches one of the hardware slots in the data receive chain.

 The `.epfilter` and `.epprexres` of GE's global struct array `entry_point_table[]` is also set.

 @param[in] filt Pointer to FILTER_INFO struct (`.filt` field in KS_READ)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_setfilter(FILTER_INFO *filt) {

  setfilter(filt, SCAN);

  entry_point_table[L_SCAN].epfilter = (unsigned char) filt->fslot;
  entry_point_table[L_SCAN].epprexres = filt->outputs;


  /* APS2 & MPS2 */
  entry_point_table[L_APS2] = entry_point_table[L_MPS2] = entry_point_table[L_SCAN];  /* copy scan into APS2 & MPS2 */
  strcpy(entry_point_table[L_APS2].epname, "aps2");
  strcpy(entry_point_table[L_MPS2].epname, "mps2");

  return SUCCESS;

} /* GEReq_predownload_setfilter() */




/**
 *******************************************************************************************************
 @brief #### Generates the vrgf.param file for rampsampling correction

 When the `.rampsampling` field of a KS_READTRAP is set to 1, 1D gridding in the frequency encoding 
 direction is necessary before FFT to obtain an equidistant k-space. 
 GE's product reconstruction uses a file (`vrgf.param`) for this, which is generated by this function.

 See also GEReq_predownload_setrecon_readphase(), which sets VRGF-specific global variables.

 @param[in] readtrap
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_genVRGF(const KS_READTRAP * const readtrap) {
  FILE *fpVRGF;
  float beta = 1.0;
  float alpha = 2.0 / (beta + 1.0);
#ifdef SIM
  fpVRGF = fopen("./vrgf.param", "w");
#else
  fpVRGF = fopen("/usr/g/bin/vrgf.param", "w");
#endif

  /* based on: /ESE.../.../psdsupport/genVRGF.c  */

  /* NOTE: The static file /usr/g/bin/vrgf.param2, i.e. with a trailing "2", containing the following 
     must exist on the system in order for the executable /usr/g/bin/vrgf to generate vrgf.dat from 
     the vrgf.param we are about to write:
     VRGFNORM=   1
     GAIN=     1.0
     VRGFWN=     1
     ALPHA=   0.46
     BETA=     1.0
     VRGFODS=  0.0
     VRGFCC=     0
     VRGFGS=     1
     VRGFSGG=    0
     VRGFBWF= -1.0
  */


  fprintf(fpVRGF, "VRGFIP=    %d\n", readtrap->acq.filt.outputs);
  fprintf(fpVRGF, "VRGFOP=    %d\n", readtrap->res);
  fprintf(fpVRGF, "PERIOD=    %f\n", readtrap->acq.filt.tsp);
  fprintf(fpVRGF, "WAVE_CHOICE=  %d\n", 1);
  fprintf(fpVRGF, "G1=        %d\n", 1);
  fprintf(fpVRGF, "G2=        %f\n", readtrap->grad.amp);
  fprintf(fpVRGF, "G3=        %f\n", (readtrap->grad.plateautime / 2) / 1.0e6);
  fprintf(fpVRGF, "G4=        %f\n", readtrap->grad.ramptime / 1.0e6);
  fprintf(fpVRGF, "G5=        %f\n", alpha);
  fprintf(fpVRGF, "G6=        %f\n", beta);
  fprintf(fpVRGF, "G7=        %f\n", 0.0);
  fprintf(fpVRGF, "G8=        %f\n", readtrap->acq.rbw * 1.0e3);
  fprintf(fpVRGF, "G9=        %f\n", 0.0);

  if (fclose(fpVRGF) != 0) {
    ks_error("Can't close vrgf.param");
  }

  return SUCCESS;

} /* GEReq_predownload_genVRGF() */




/**
 *******************************************************************************************************
 @brief #### Generates the rowflip.param file for KS_EPI

 GE's reconstruction (and data dumping) of EPI data (where every other readout is negative) needs to
 know which k-space lines that have been acquired with a negative gradient to perform a row flip
 on these lines before proceeding with Pfile writing and FFT processing.

 @param[in] epi Pointer to KS_EPI
 @param[in] blipsign KS_EPI_POSBLIPS or KS_EPI_NEGBLIPS
 @param[in] assetflag Flag for ASSET mode or not (0: off, 2: ASSET_SCAN (on))
 @param[in] dorowflip If 0, write just ones to let rowflipping process for Pfiles being executed without actual flipping
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_genrowflip(KS_EPI *epi, int blipsign, int assetflag, int dorowflip) {
  FILE *rowflipfp;
  int i = 0;
  int j = 0;
  int kyview = 0;
  int view1st, viewskip;
  int readsign = 1;
  int rowskip, res;
#ifdef SIM
  rowflipfp = fopen("./rowflip.param", "w");
#else
  rowflipfp = fopen("/usr/g/bin/rowflip.param", "w");
#endif

  fprintf(rowflipfp, "# EPI recon control\n");
  fprintf(rowflipfp, "#\n");
  fprintf(rowflipfp, "# ky line number/flip operation\n");
  fprintf(rowflipfp, "%d %d\n", 0, 1);

  if (assetflag == ASSET_SCAN) {
    rowskip = 1;
    res = epi->blipphaser.res / epi->blipphaser.R;
  } else {
    rowskip = epi->blipphaser.R;
    res = epi->blipphaser.res;
  }

  for (i = 0; i < epi->etl; i++) {
    for (j = 0; j < rowskip; j++) {
      kyview = i * rowskip + j;
      readsign = (i % 2) ? -1 : 1;
      if (blipsign == KS_EPI_POSBLIPS && (epi->etl % 2 == 0)) {
        readsign *= -1;
      }
      fprintf(rowflipfp, "%d %d\n", kyview + 1, (dorowflip) ? readsign : 1);
    }
  }
  for (kyview = i * rowskip + j; kyview < res; kyview++)
    fprintf(rowflipfp, "%d %d\n", kyview + 1, 1);

  fprintf(rowflipfp, "#\n#\n#intleave 1stview skip gpol bpol gy1f rfpol tf nechoes init_echo_pol\n" );

  for (j = 0; j < rowskip; j++) {
    if (blipsign == KS_EPI_POSBLIPS && (epi->etl % 2 == 0)) {
      view1st = (assetflag == ASSET_SCAN) ? (epi->blipphaser.numlinestoacq - 1) : (epi->blipphaser.linetoacq[(epi->blipphaser.numlinestoacq - 1)] + j);
      viewskip = -rowskip;
    } else {
      view1st = (assetflag == ASSET_SCAN) ? 0 : (epi->blipphaser.linetoacq[0] + j);
      viewskip = rowskip;
    }
    fprintf(rowflipfp, "%d %d %d %d %d %d %d %d %d %d\n", j, view1st + 1, viewskip, 1, blipsign, 0 /* max int dephaser */, 1 /* rfpol*/, 0 /* tf */, epi->etl, 1);
  }

  fprintf(rowflipfp, "# esp (usec)\n");
  fprintf(rowflipfp, "%d \n", epi->read.grad.duration);
  fprintf(rowflipfp, "# tsp (usec)\n");
  fprintf(rowflipfp, "%f \n", epi->read.acq.filt.tsp);
  fprintf(rowflipfp, "# input samples\n");
  fprintf(rowflipfp, "%d \n", epi->read.acq.filt.outputs);
  fprintf(rowflipfp, "# readout amplitude (G/cm)\n");
  fprintf(rowflipfp, "%f \n", epi->read.grad.amp);
  fprintf(rowflipfp, "# Row FT size\n");
  fprintf(rowflipfp, "%d \n", epi->read.res);
  fprintf(rowflipfp, "# rhhnover \n");
  fprintf(rowflipfp, "%d \n", epi->blipphaser.nover);
  fprintf(rowflipfp, "# etl\n");
  fprintf(rowflipfp, "%d \n", epi->etl);
  fprintf(rowflipfp, "# number of interleaves\n");
  fprintf(rowflipfp, "%d \n", epi->blipphaser.R);
  fprintf(rowflipfp, "# low pass filter setting (kHz), or -1 for std. rcvr.\n");
  fprintf(rowflipfp, "%d \n", -1);
  fprintf(rowflipfp, "# total number of images\n");
  fprintf(rowflipfp, "%d \n", opslquant);
  fprintf(rowflipfp, "# end of file");

  fclose(rowflipfp);

  return SUCCESS;

} /* GEReq_predownload_genrowflip() */





/*******************************************************************************************************
 ************************************ Modify rh/ih/pi/op vars for recon           **********************
 *******************************************************************************************************/



/**
 *******************************************************************************************************
 @brief #### Writes a kacq_yz.txt.***** file for use with GE's product ARC recon

 If phaser.R > 1, a file is written to disk with phase encoding steps in an ARC accelerated
 scan ("kacq_yz.txt.*****"). This function has been adapted from GE's ARC.e, but supports only 2D
 (i.e. 1D-acceleration)
 
 @param[in]  readtrap Pointer to readout trapezoid. Used to determine k-space peak along kx
 @param[in]  phaser   Pointer to phase encoding object (KS_PHASER) with acceleration
 @param[in]  zphaser   Pointer to z phase encoding object (KS_PHASER) with acceleration. NULL for 2D
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_setrecon_writekacq(const KS_READTRAP * const readtrap, const KS_PHASER * const phaser, const KS_PHASER * const zphaser) {

  FILE *fp;
  CHAR kacqFilename[BUFSIZ];
  int view;
  int arc_kx_peak_pos = 0; /* sample point units */
  int arc_ky_peak_pos = -1;
  const CHAR kacqArcFilename[BUFSIZ] = "kacq_yz.txt";
  int num_echoes = 1; /* we don't understand what a value > 1 would mean. cf. ARC.e */
  int echo_index, slice;
  int numzencodes = (zphaser != NULL) ? zphaser->numlinestoacq : 1;

#ifdef PSD_HW
  const CHAR kacqPath[BUFSIZ] = "/usr/g/psddata/";
  const CHAR kacqRawPath[BUFSIZ] = "/usr/g/mrraw/";
  sprintf(kacqFilename, "%s%s.%d", kacqPath, kacqArcFilename, rhkacq_uid);
#else
  const CHAR kacqPath[BUFSIZ] = "./";
  const CHAR kacqRawPath[BUFSIZ] = "./";
  sprintf(kacqFilename, "%s%s", kacqPath, kacqArcFilename);
#endif

  fp = fopen(kacqFilename, "w");

  /* position of k-space center in sample points along kx
     time2center - acqdelay is the time in [us] from start of acq window to the center of k-space
     acq.filt.tsp is the time in [us] for one sample point (with or without ramp sampling */
  arc_kx_peak_pos = (readtrap->time2center - readtrap->acqdelay) / readtrap->acq.filt.tsp;

  /* disabled flag ? */
  arc_ky_peak_pos = -1;

  /* kacq header */
  fprintf(fp, "GE_KTACQ\t201\t0\n");
  fprintf(fp, "num_sampling_patterns\t%d\n", num_echoes);
  fprintf(fp, "num_mask_patterns\t%d\n", 0);
  fprintf(fp, "kx_peak_pos\t%d\n", arc_kx_peak_pos);
  /* fprintf(fp, "ky_peak_pos\t%d\n", arc_ky_peak_pos); */
  fprintf(fp, "---\n");

  /* Reconstruction schedule */
  fprintf(fp, "# Reconstruction schedule\n");
  fprintf(fp, "# t, Echo, Cal Table, Cal Pass, Accel Table, Accel Pass, Mask Table\n");
  fprintf(fp, "RECON_SCHEDULE\t%d\t%d\n", num_echoes, 7);
  fprintf(fp, "---\n");
  for (echo_index = 0; echo_index < num_echoes; echo_index++) {
    fprintf(fp,"%d\t%d\t%d\t%d\t%d\t%d\t%d\n", 0, echo_index, -1, 0, echo_index, 0, -1);
  }

  /* Accelerated sampling pattern */
for (echo_index = 0; echo_index < num_echoes; echo_index++) {

  fprintf(fp, "# Sampling Pattern 0 (Accel)\n");
  fprintf(fp, "# View Offset, Pass Offset, ky, kz\n");

    fprintf(fp, "SAMPLING_PATTERN\t%d\t%d\n", phaser->numlinestoacq * numzencodes, 4);
    fprintf(fp, "max_stride\t%d\t%d\n", phaser->R, (zphaser != NULL) ? zphaser->R : 1);
  int dimy;
  if (phaser->nover != 0)
    dimy = phaser->res / 2 + abs(phaser->nover); /* half nex */
  else
    dimy = phaser->res;
    fprintf(fp, "pattern_dimensions\t%d\t%d\n", dimy, (zphaser != NULL) ? exist(opslquant) : 1);
  fprintf(fp, "---\n");
    for (slice = 0; slice < numzencodes; slice++) {
  for (view = 0; view < phaser->numlinestoacq; view++) {
        if (zphaser != NULL)
          fprintf(fp, "%d\t%d\t%d\t%d\n", phaser->linetoacq[view] + 1 + (zphaser->linetoacq[view] * num_echoes + echo_index) * rhdayres, 0, phaser->linetoacq[view], zphaser->linetoacq[slice]);
        else
          fprintf(fp, "%d\t%d\t%d\t%d\n", phaser->linetoacq[view] + 1 + echo_index * rhdayres, 0, phaser->linetoacq[view], 0);
  }
    }

  } /* echo */

  fclose(fp);

  /* Automatically copy kacq file to a unique filename in
     /usr/g/mrraw if autolock is on */
  if (autolock == TRUE) {
    /* Copy file by reading to and writing from a buffer */
    CHAR kacqMrrawFilename[BUFSIZ];
    CHAR kacqRawFilename[BUFSIZ];
    FILE *srcFile = NULL;
    FILE *dstFile = NULL;
    size_t elemRead, elemWritten;
    size_t bufSz = 8192;
    char buf[8192];

    sprintf(kacqRawFilename, "%s.%d", kacqArcFilename, rhkacq_uid);
    sprintf(kacqMrrawFilename, "%s%s", kacqRawPath, kacqRawFilename);

    srcFile = fopen(kacqFilename, "rb");
    dstFile = fopen(kacqMrrawFilename, "wb");

    elemRead = bufSz;
    while (elemRead == bufSz) {
      elemRead = fread(buf, sizeof(char), bufSz, srcFile);
      elemWritten = fwrite(buf, sizeof(char), elemRead, dstFile);
    }
    fclose(srcFile);
    fclose(dstFile);

  } /* autolock */

    return SUCCESS;

} /* GEReq_predownload_setrecon_writekacq() */




/**
 *******************************************************************************************************
 @brief #### Sets rh*** variables related to parallel imaging acceleration

 @param[in] readtrap Pointer to KS_READTRAP
 @param[in] phaser   Pointer to KS_PHASER (phase)
 @param[in] zphaser   Pointer to KS_PHASER (slice). NULL for 2D
 @param[in] datadestination Value to assign to `rhexecctrl` (c.f. epic.h)
   
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_setrecon_accel(const KS_READTRAP * const readtrap, const KS_PHASER * const phaser, const KS_PHASER * const zphaser, int datadestination) {
  STATUS status;

  /* make sure we will be able to set all these CVs */
  _rhasset.fixedflag = FALSE;
  _rhasset_R.fixedflag = FALSE;
  _rhhnover.fixedflag = FALSE;
  _rhnframes.fixedflag = FALSE;
  _rhdayres.fixedflag = FALSE;

  if (phaser->R <= 1 && (zphaser == NULL || zphaser->R <= 1)) {
    rhasset = 0;
    rhasset_R = 1.0;
    rhassetsl_R = 1.0;
    return SUCCESS;
  }

  rhtype1 |= RHTYP1BAM0FILL; /* once more, just in case */

  if (datadestination & RHXC_XFER_IM) {
    /* if we are going to use GE recon (RHXC_XFER_IM = 8) */

    if (phaser->nacslines > 0) { /* ARC */

      /* ARC uses full BAM, i.e. stores the acquired lines at their proper locations in k-space with zero lines in between */
      rhhnover = abs(phaser->nover);
      rhnframes = phaser->numlinestoacq; /* # of acquired lines */
      rhdayres = (phaser->nover != 0) ? (phaser->res/2 + abs(phaser->nover) + 1) : (phaser->res + 1);

      rhasset = ACCEL_ARC; /* tell recon we are doing ARC only if we have ACS lines  */
      status = GEReq_predownload_setrecon_writekacq(readtrap, phaser, zphaser);
      if (status != SUCCESS) return status;

    } else { /* ASSET */

      /* ASSET uses compressed BAM, i.e. stores only the acquired lines */
      rhhnover = abs(phaser->nover) / phaser->R;
      rhnframes = (phaser->nover != 0) ? (phaser->res / (2 * phaser->R)) : (phaser->res / phaser->R);
      rhdayres = rhnframes + rhhnover + 1;

      rhasset = ASSET_SCAN; /* if we don't have ACS lines, we will need to recon the data using some external calibration */
    }

  } else {

    /* store data as ARC (full BAM) */
    rhhnover = abs(phaser->nover);
    rhnframes = phaser->numlinestoacq; /* # of acquired lines */
    rhdayres = (phaser->nover != 0) ? (phaser->res / 2 + abs(phaser->nover) + 1) : (phaser->res + 1);

    rhasset = 0; /* we are going to do the reconstruction offline */
  }

  rhasset_R = 1.0 / phaser->R; /* inverse of acceleration factor */
  rhassetsl_R = (zphaser != NULL) ? (1.0 / zphaser->R) : 1;

  return SUCCESS;

} /* GEReq_predownload_setrecon_accel() */



void  GEReq_predownload_setrecon_phase(const KS_PHASER * const phaser, const float readfov, const int datadestination) {
  /* make sure we will be able to set all these CVs */
  _rhasset.fixedflag = FALSE;
  _rhasset_R.fixedflag = FALSE;
  _rhhnover.fixedflag = FALSE;
  _rhnframes.fixedflag = FALSE;
  _rhdayres.fixedflag = FALSE;

  if (phaser->nover != 0) { /* partial Fourier ky */
    rhnframes = phaser->res / 2;
    rhtype |= RHTYPFRACTNEX;
  } else {
    rhnframes = phaser->res;
    rhtype &= ~RHTYPFRACTNEX;
  }

  rhhnover = abs(phaser->nover);
  rhdayres = rhnframes + rhhnover + 1;


  rhexecctrl = datadestination;
  if (op3dgradwarp && !(rhexecctrl & RHXC_XFER_IM)) {
    /* 3D gradwarp requires at least one of the following bits set:
       #define RHXC_XFER_IM                    0x0008  8 (GE online recon)
       #define RHXC_SAVE_IM                    0x0010  16
    */
    (rhexecctrl) |= RHXC_SAVE_IM; /* parentheses around rhexecctrl prevents EPIC preprocessor to add fixedflag check */
  }

  rhphasescale = phaser->fov / readfov;
  if (phaser->R <= 1) {
    rhasset = 0;
    rhasset_R = 1.0;
    return;
  }

  rhtype1 |= RHTYP1BAM0FILL; /* once more, just in case */

  if (datadestination & RHXC_XFER_IM) {
    /* if we are going to use GE recon (RHXC_XFER_IM = 8) */
    if (phaser->nacslines > 0) { /* ARC */
      /* ARC uses full BAM, i.e. stores the acquired lines at their proper locations in k-space with zero lines in between */
      rhhnover = abs(phaser->nover);
      rhnframes = phaser->numlinestoacq; /* # of acquired lines */
      rhdayres = (phaser->nover != 0) ? (phaser->res/2 + abs(phaser->nover) + 1) : (phaser->res + 1);
      rhasset = ACCEL_ARC; /* tell recon we are doing ARC only if we have ACS lines  */
    } else { /* ASSET */
      /* ASSET uses compressed BAM, i.e. stores only the acquired lines */
      rhhnover = abs(phaser->nover) / phaser->R;
      rhnframes = (phaser->nover != 0) ? (phaser->res / (2 * phaser->R)) : (phaser->res / phaser->R);
      rhdayres = rhnframes + rhhnover + 1;
      rhasset = ASSET_SCAN; /* if we don't have ACS lines, we will need to recon the data using some external calibration */
    }
  } else {
    /* store data as ARC (full BAM) */
    rhhnover = abs(phaser->nover);
    rhnframes = phaser->numlinestoacq; /* # of acquired lines */
    rhdayres = (phaser->nover != 0) ? (phaser->res / 2 + abs(phaser->nover) + 1) : (phaser->res + 1);
    rhasset = 0; /* we are going to do the reconstruction offline */
  }

  rhasset_R = 1.0 / phaser->R; /* inverse of acceleration factor */
} /* GEReq_predownload_setrecon_phase() */



void GEReq_predownload_setrecon_readwave(const KS_READWAVE* const readwave, const int yres, int imsize_policy, int datadestination) {
  int max_xy;

  /* make sure we will be able to set all these CVs */
  _rhfrsize.fixedflag = FALSE;
  _rhdaxres.fixedflag = FALSE;
  _rhvrgf.fixedflag = FALSE;
  _rhvrgfxres.fixedflag = FALSE;

  /* raw data freq (x) size (works for both non-VRGF and VRGF) */
  rhfrsize = readwave->acq.filt.outputs;
  rhdaxres = readwave->acq.filt.outputs;

  /* ramp sampling */
  rhvrgf = readwave->rampsampling;
  rhvrgfxres = readwave->res;

  piforkvrgf = 0; /* 1 causes scan to spawn the vrgf process upon download */
  rhtype1 &= ~(RHTYP1FVRGF + RHTYP1PCORVRGF);
  rhuser32 = 0.0;
  rhuser33 = 0.0;
  rhuser34 = 0.0;
  rhuser35 = 0.0;
  
  /* image size */
  max_xy = IMax(2, readwave->res, yres);

  rhmethod = 1; /* enable reduced image size, so we are in control */
  if (imsize_policy == KS_IMSIZE_MIN256) {
    max_xy = (max_xy > 256) ? 512 : 256; /* final image size is either 512 or 256 */
  } else if (imsize_policy == KS_IMSIZE_POW2) {
    max_xy = ks_calc_nextpow2((unsigned int) max_xy); /* round up to nearest power of 2 if imsize_policy = KS_IMSIZE_POW2 */
  }

  /* recon image size with optional zerofilling */
  if (opzip512 && max_xy < 512) {
    max_xy = 512;
  } else if (opzip1024 && max_xy < 1024) {
    max_xy = 1024;
  }
  rhimsize = max_xy;
  rhrcxres = rhimsize;
  rhrcyres = rhimsize;

  /* freq. partial Fourier */
  if (abs(readwave->nover) > 0) {
    /* fractional echo (partial Fourier kx) */
    pitfeextra = rhfrsize * abs(readwave->nover) / (float)(readwave->res/2 + abs(readwave->nover));
  } else {
    pitfeextra = 0;
  }
  rhfeextra = pitfeextra;
  rhheover = readwave->nover;

  /* chopping control */
  rhtype |= RHTYPCHP; /* ( |= 1) no chopping processing needed in recon */

  /* 3D recon flag */
  if(opimode == PSD_3D || opimode == PSD_3DM)
    rhtype |= RHTYP3D;
  else
    rhtype &= ~RHTYP3D;



} /* GEReq_predownload_setrecon_readwave() */


/**
 *******************************************************************************************************
 @brief #### Sets required global rh*** variables for Cartsian imaging

 For Cartesian pulse sequences, using one KS_READTRAP and one KS_PHASER (each of which may have multiple
 instances), the required rh*** variables are set based on the content of the sequence objects 
 KS_READTRAP (arg 1) and KS_PHASER (arg 2). The fields in each sequence object, including e.g. partial 
 Fourier and rampsampling, controls the setting of GE's rh*** variables. In addition, the third argument
 specifies the desired upsampling policy for small matrix sizes.

 @param[in] readtrap Pointer to KS_READTRAP
 @param[in] phaser Pointer to KS_PHASER
 @param[in] zphaser Pointer to KS_PHASER (slice). NULL for 2D
 @param[in] imsize_policy Choose between `KS_IMSIZE_NATIVE`, `KS_IMSIZE_POW2`, `KS_IMSIZE_MIN256`
 @param[in] datadestination Value for the rhexecctrl variable. Bitmasks for: KS_SAVEPFILES (dump Pfiles) and KS_GERECON (product recon)
 @return void
********************************************************************************************************/
void GEReq_predownload_setrecon_readphase(const KS_READTRAP * const readtrap, const KS_PHASER * const phaser, const KS_PHASER * const zphaser, int imsize_policy, int datadestination) {
  int max_xy;

  /* make sure we will be able to set all these CVs */
  _rhfrsize.fixedflag = FALSE;
  _rhdaxres.fixedflag = FALSE;
  _rhdayres.fixedflag = FALSE;
  _rhnframes.fixedflag = FALSE;
  _rhhnover.fixedflag = FALSE;
  _rhvrgf.fixedflag = FALSE;
  _rhvrgfxres.fixedflag = FALSE;
  _rhasset.fixedflag = FALSE;
  _rhasset_R.fixedflag = FALSE;

  /* raw data freq (x) size (works for both non-VRGF and VRGF) */
  rhfrsize = readtrap->acq.filt.outputs;
  rhdaxres = readtrap->acq.filt.outputs;

  /* ramp sampling */
  rhvrgf = readtrap->rampsampling;
  rhvrgfxres = readtrap->res;

  if (readtrap->rampsampling) {
    piforkvrgf = 1; /* 1 causes scan to spawn the vrgf process upon download */
    rhtype1 |= (RHTYP1FVRGF + RHTYP1PCORVRGF); /* VRGF and VRGFafterPC */

    /* write vrgf.param */
    GEReq_predownload_genVRGF(readtrap);

    /* VRGF (rampsampling): Store shape of the read lobe to determine the k-space travel along kx (freq. dir.) for offline VRGF correction */
    rhuser32 = readtrap->acq.filt.tsp; /* time between sample points [often 2us] */
    rhuser33 = readtrap->grad.amp; /* Readout gradient amplitude */
    rhuser34 = (float) (readtrap->grad.plateautime / 2) / 1.0e6; /* half plateau time */
    rhuser35 = (float) (readtrap->grad.ramptime) / 1.0e6; /* attack/decay time */
  } else {
    piforkvrgf = 0; /* 1 causes scan to spawn the vrgf process upon download */
    rhtype1 &= ~(RHTYP1FVRGF + RHTYP1PCORVRGF);
    rhuser32 = 0.0;
    rhuser33 = 0.0;
    rhuser34 = 0.0;
    rhuser35 = 0.0;
  }


  /* image size */
  if (phaser != NULL) {
    max_xy = IMax(2, readtrap->res, phaser->res);
  } else {
    max_xy = readtrap->res;
  }

  rhmethod = 1; /* enable reduced image size, so we are in control */
  if (imsize_policy == KS_IMSIZE_MIN256) {
    max_xy = (max_xy > 256) ? 512 : 256; /* final image size is either 512 or 256 */
  } else if (imsize_policy == KS_IMSIZE_POW2) {
    max_xy = ks_calc_nextpow2((unsigned int) max_xy); /* round up to nearest power of 2 if imsize_policy = KS_IMSIZE_POW2 */
  }

  /* recon image size with optional zerofilling */
  if (opzip512 && max_xy < 512) {
    max_xy = 512;
  } else if (opzip1024 && max_xy < 1024) {
    max_xy = 1024;
  }
  rhimsize = max_xy;
  rhrcxres = rhimsize;
  rhrcyres = rhimsize;

  /* freq. partial Fourier */
  if (abs(readtrap->nover) > 0) {
    /* fractional echo (partial Fourier kx) */
    pitfeextra = rhfrsize - readtrap->res / 2;
  } else {
    pitfeextra = 0;
  }
  rhfeextra = pitfeextra;

  /* chopping control */
  rhtype |= RHTYPCHP; /* ( |= 1) no chopping processing needed in recon */

  /* 3D recon flag */
  if (KS_3D_SELECTED)
    rhtype |= RHTYP3D;
  else
    rhtype &= ~RHTYP3D;

  /* phase encoding (see also GEReq_predownload_setrecon_accel(), which may override these values) */
  if (phaser != NULL) {
    if (phaser->nover != 0) { /* partial Fourier ky */
      rhnframes = phaser->res / 2;
      rhtype |= RHTYPFRACTNEX;
    } else {
      rhnframes = phaser->res;
      rhtype &= ~RHTYPFRACTNEX;
    }

    rhhnover = abs(phaser->nover);
    rhdayres = rhnframes + rhhnover + 1;

    rhexecctrl = datadestination;
    if (op3dgradwarp && !(rhexecctrl & RHXC_XFER_IM)) {
      /* 3D gradwarp requires at least one of the following bits set:
         #define RHXC_XFER_IM                    0x0008  8 (GE online recon)
         #define RHXC_SAVE_IM                    0x0010  16
      */
      (rhexecctrl) |= RHXC_SAVE_IM; /* parentheses around rhexecctrl prevents EPIC preprocessor to add fixedflag check */
    }

#if EPIC_RELEASE >= 26
    if (datadestination & RHXC_XFER_IM) {
      rhdacqctrl &= ~8192; /* enable GE's Orchestra Live recon */
    } else {
      rhdacqctrl |= 8192; /* disable GE's Orchestra Live recon */
    }
#endif

    /* Set up ARC/ASSET flags if R > 1 otherwise shut them off */
    GEReq_predownload_setrecon_accel(readtrap, phaser, zphaser, datadestination);

    rhphasescale = phaser->fov / readtrap->fov;

  } /* phaser != NULL */

} /* GEReq_predownload_setrecon_readphase() */




/**
 *******************************************************************************************************
 @brief #### Sets ih*** variables for TE and rBW annotation
 
 Uses the global UI CVs `opnecho`, `opnex`, `opte` and `opte2`

 @param[in] tsp Dwell time in [us], i.e. the duration of one sample (which is also 1/rBW)
 @param[in] readdur Duration in [us] of the readout window
 @param[in] time2center Time in [us] to the center of the echo
 @param[in] echogap Gap between two echoes
 @return void
********************************************************************************************************/
void GEReq_predownload_setrecon_annotations(int tsp, int readdur, int time2center, int echogap) {

  int duration1, duration2;
  int echo_timeoffset2evenecho, echo_timeoffset2oddecho;
  int roundinglimit = 40ms;

  /* rBW annotation */
  ihvbw1 = 1.0e3 / (tsp * 2.0);
  ihvbw2 = ihvbw1;
  ihvbw3 = ihvbw1;
  ihvbw4 = ihvbw1;
  ihvbw5 = ihvbw1;
  ihvbw6 = ihvbw1;
  ihvbw7 = ihvbw1;
  ihvbw8 = ihvbw1;
  ihvbw9 = ihvbw1;
  ihvbw10 = ihvbw1;
  ihvbw11 = ihvbw1;
  ihvbw12 = ihvbw1;
  ihvbw13 = ihvbw1;
  ihvbw14 = ihvbw1;
  ihvbw15 = ihvbw1;
  ihvbw16 = ihvbw1;

  /* NEX annotation */
  ihnex = opnex;

  /* TE */
  ihte1 = (opte > roundinglimit) ? ks_calc_roundupms(opte) : opte;

  duration1 = (readdur - time2center) * 2 + echogap; /* 2x (time from k-space center to edge for 1st echo) + additional echo gap */
  duration2 = time2center * 2 + echogap; /* 2x (time from start to k-space center for 1st echo) + additional echo gap */

  if ((eeff == 1 && oeff == 0) || (eeff == 0 && oeff == 1) || (acq_type == TYPSPIN)) { /* alternating readout gradient polarity across echoes (like often in GRE), or SpinEcho */
    echo_timeoffset2evenecho = duration1; /* between 1 and 2, 3 and 4 etc. */
    echo_timeoffset2oddecho  = duration2; /* between 2 and 3, 4 and 5 etc. */
  } else { /* same readout gradient polarity across echoes */
    /* we have a GRE sequence, and there are likely flyback gradients
       between each readout to allow for the readout gradient polarity to have the same sign for all echoes */
    echo_timeoffset2evenecho = readdur + echogap; /* between 1 and 2, 3 and 4 etc. */
    echo_timeoffset2oddecho  = readdur + echogap; /* between 2 and 3, 4 and 5 etc. */
  }

  if (opnecho == 2) {
    if (pite2nub && existcv(opte2) && opte2 > 0) { /* use opte2 if the button is visible and it was selected */
      ihte2 = opte2;
    } else {
      /* partial Fourier note: 2nd readout will have its relative k-space center mirrored */
      ihte2 = opte + echo_timeoffset2evenecho;
    }
  } else if (opnecho > 2) {
    int pos = opte + echo_timeoffset2evenecho;
    ihte2 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte3 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte4 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte5 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte6 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte7 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte8 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte9 =  (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte10 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte11 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte12 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte13 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte14 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte15 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos; pos += echo_timeoffset2oddecho;
    ihte16 = (pos > roundinglimit) ? ks_calc_roundupms(pos) : pos;
  }

  /* rhte/rhte2 end up in the raw section of the rawdata header (rdb_hdr_te, rdb_hdr_te2)
     while opte/opte in the image section (te,te2). For opnecho > 2, the te2 field is sometimes 0, why
     we also need to rely on rdb_hdr_te2 for offline reconstruction */
  rhte = ihte1;
  rhte2 = ihte2;


  /* Flip Angle */
  ihflip = opflip;

} /* GEReq_predownload_setrecon_annotations() */




/**
 *******************************************************************************************************
 @brief #### Sets ih*** variables for TE and rBW annotation based on a KS_READTRAP
 
 This is a wrapper function to GEReq_predownload_setrecon_annotations() using a KS_READTRAP

 @param[in] readtrap Pointer to KS_READTRAP
 @param[in] echogap Gap between two echoes
 @return void
********************************************************************************************************/
void GEReq_predownload_setrecon_annotations_readtrap(KS_READTRAP *readtrap, int echogap) {

  GEReq_predownload_setrecon_annotations(readtrap->acq.filt.tsp, readtrap->grad.duration, readtrap->time2center, echogap);

} /* GEReq_predownload_setrecon_annotations_readtrap() */




/**
 *******************************************************************************************************
 @brief #### Sets ih*** variables for TE and rBW annotation based on a KS_EPI
 
 This is a wrapper function to GEReq_predownload_setrecon_annotations() using a KS_EPI

 @param[in] epi Pointer to KS_EPI
 @param[in] echogap Gap between two EPI trains
 @return void
********************************************************************************************************/
void GEReq_predownload_setrecon_annotations_epi(KS_EPI *epi, int echogap) {
  int maxtime_dephasers = IMax(2, epi->readphaser.duration, epi->blipphaser.grad.duration);
  int maxtime_rephasers = IMax(2, epi->readphaser.duration, epi->blipphaser.grad.duration);
  int halfkspace_duration = ((epi->read.grad.duration + epi->read_spacing) * epi->etl / 2) - epi->read_spacing / 2;
  /* time for extra lines beyond half-kspace for partial Fourier in ky */
  int overscan_duration = ((epi->read.grad.duration + epi->read_spacing) * (epi->blipphaser.nover / epi->blipphaser.R)) - epi->read_spacing / 2;
  int epiduration, time2center;

  if (opautote == PSD_MINTE) {
    epiduration = (maxtime_dephasers + overscan_duration + halfkspace_duration + maxtime_rephasers);
    time2center = maxtime_dephasers + overscan_duration;
  } else {
    epiduration = (maxtime_dephasers + 2 * halfkspace_duration + maxtime_rephasers);
    time2center = maxtime_dephasers + halfkspace_duration;
  }
  GEReq_predownload_setrecon_annotations(epi->read.acq.filt.tsp, epiduration, time2center, echogap);


} /* GEReq_predownload_setrecon_annotations_epi() */




/**
 *******************************************************************************************************
 @brief #### Sets rh*** variables related to multi-volume imaging

 The combination of rh*** variables allow for 50,000 image planes in GE's database.

 However, Pfile data stops writing after 512 planes. To store more than 512 image planes as rawdata, 
 RDS (Raw Data Server) or multivolume Pfiles can be used instead. It is possible that other mechanisms 
 will be available through GE's upcoming Orchestra Live in the future.

 @param[in] numvols    Number of volumes (`opfphases`)
 @param[in] slice_plan The slice plan (KS_SLICE_PLAN), set up using ks_calc_sliceplan() or similar
 @return void
********************************************************************************************************/
void GEReq_predownload_setrecon_voldata(int numvols, const KS_SLICE_PLAN slice_plan) {
  int numechoes;

  if (numvols < 1)
    numvols = 1;

  /* GE's CVs for #slices/TR and #passes (acqs) */
  _slquant1.fixedflag = 0;
  _acqs.fixedflag = 0;
  slquant1 = slice_plan.nslices_per_pass;
  acqs = slice_plan.npasses;
  /* prescan */
  picalmode = 0;
  pislquant = slquant1;

  /* rhscnframe and rhpasframe are used when scanning in auto-pass mode w/o specific pass-packets (like GEendpass).
  To enable auto-pass mode, set rhtype1 |= RHTYP1AUTOPASS and set these variables to the proper value.
  It is unclear how this would work with partial Fourier and ARC, and has not been tested. */
  rhscnframe = 0 /* rhnslices*ceil(opnex)*rhdayres */;
  rhpasframe = 0 /* slquant1*ceil(opnex)*rhdayres */;
  rhtype1 &= ~RHTYP1AUTOPASS; /* diable auto-pass. I.e. require the use of pass packets (which is standard anyway) in scan to dump Pfiles */

  /* raw size */
  numechoes = IMax(2, rhnecho, opnecho);
  if (!KS_3D_SELECTED) {
    rhrawsize = slquant1 * numechoes * (2 * rhptsize) * rhdaxres * rhdayres;
  } else {
    rhrawsize = opslquant * numechoes * (2 * rhptsize) * rhdaxres * rhdayres;
  }

  {
    char tmpstr[100];
    sprintf(tmpstr, "rhrawsize = %d bytes/channel (KSFoundation)", (int) rhrawsize);
    cvdesc(rhrawsizeview, tmpstr);
  }

  /* Volumes & total size */
  rhnphases = numvols;  /* must be = numvols (not numvols*acqs=#pfiles !!)
         - if 1 when numvols >1:
         Prep Action failed: error please try again. ErrorLog="The integer value for ps_to_rs[0] in the header = 0 "
         - if numvols*acqs when acqs > 1 and numvols == 1:
         Scan failed (after few secs, no images)  */
  rhnpasses = rhnphases * slice_plan.npasses;  /* must be == # volumes (Pfiles) dumped or system hangs and needs rebooting ! */
  rhreps    = rhnphases;
  if (!KS_3D_SELECTED) {
    rhnslices = slice_plan.nslices * rhnphases;
  } else {
    rhnslices = opslquant * opvquant * rhnphases;
  }
  rhmphasetype = 0; /* Interleaved multiphase */

  rhtype1 |= RHTYP1BAM0FILL ; /* zerofill BAM for clean Pfiles */
  rhformat &= ~RHF_ZCHOP; /* no z chopping by default */
  rhformat |= RHF_SINGLE_PHASE_INFO;

  /* Gradwarp Mode */
  rhuser47 = cfgradcoil;
  
  /* copy useful variables to raw header for recon */
  /* rhuser32-35 are reserved for off-line VRGF correction (Karolinska) */
  rhuser48 = pitscan; /* scan time */

} /* GEReq_predownload_setrecon_voldata() */




/**
 *******************************************************************************************************
 @brief #### Wrapper function that set up rh*** variable for a KS_EPI object using other functions

 Calls GEReq_predownload_setrecon_readphase(), GEReq_predownload_setrecon_voldata() and 
 GEReq_predownload_setrecon_annotations_epi(), and GEReq_predownload_genrowflip(). Additionally, 
 some rh*** variables are overridden for EPI.

 @param[in] epi             Pointer to KS_EPI
 @param[in] numvols2store   Number of volumes to store (including calibration vols such as ghostcorr)
 @param[in] slice_plan      The slice plan (KS_SLICE_PLAN) set up using ks_slice_plan() or similar
 @param[in] echogap         Gap between two EPI trains in [us]
 @param[in] blipsign        KS_EPI_POSBLIPS or KS_EPI_NEGBLIPS
 @param[in] datadestination Value passed on to GEReq_predownload_setrecon_readphase() to set rhexecctrl
 @param[in] multishotflag   0: Parallel imaging mode 1: Multishot mode
 @param[in] ghostcorrflag   Integrated refscan (Nyquist ghost correction). 0:Off, 1:On
 @param[in] imsize_policy   Choice between `KS_IMSIZE_NATIVE`, `KS_IMSIZE_POW2`, `KS_IMSIZE_MIN256`
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload_setrecon_epi(KS_EPI *epi, int numvols2store, const KS_SLICE_PLAN slice_plan, int echogap, int blipsign, int datadestination, int multishotflag, int ghostcorrflag, int imsize_policy) {

#if EPIC_RELEASE >= 26  
        if (datadestination & RHXC_XFER_IM) {
          return ks_error("%s: Online recon not supported for KS_EPI data on DV26 or later", __FUNCTION__); 
        }
#endif

  GEReq_predownload_setrecon_readphase(&epi->read, &epi->blipphaser, NULL, imsize_policy, datadestination); /* also sets rhasset when R > 1 */
  GEReq_predownload_setrecon_voldata(numvols2store, slice_plan); /* opfphases = number of volumes */
  GEReq_predownload_setrecon_annotations_epi(epi, echogap);


  /* EPI specific rh* vars  */
  rhileaves = epi->blipphaser.R;
  rhkydir = (blipsign == KS_EPI_POSBLIPS) ? 2 : 0;
  rhmphasetype = 0; /* Interleaved multiphase */

  if (multishotflag > 0) {
    /* .R for multi-shot. Override values set in GEReq_predownload_setrecon_readphase()->GEReq_predownload_setrecon_accel() */
    _rhasset.fixedflag = FALSE;
    _rhasset_R.fixedflag = FALSE;
    rhasset = 0;
    rhasset_R = 1.0;
  }

  /* Turn on row-flipping if ETL > 1 */
  if (epi->etl > 1) {
    rhformat |= RHF_USE_FLIPTABLE;
    if (datadestination & RHXC_XFER_IM) {
      /* Online recon: Single-shot w/ or w/o ASSET */
      GEReq_predownload_genrowflip(epi, blipsign, rhasset, TRUE);
    } else {
      /* Offline recon, say we do rowflip in rhformat, because otherwise GERecon('EPI.ComputeCoefficients') does not
      work (requires RHF_USE_FLIPTABLE to be set).
      But let's not set any negative entries in the file for offline use to avoid rowflipping to actually occur:
      DV26+: This file is ignored for scan archives
      Pre DV26: We don't want the rows to be flipped correctly in the Pfile currently since we don't understand
      why the lines are flipped wrong for mulitshot EPI. We deal with rowflipping ourselves in the recon
      */
      GEReq_predownload_genrowflip(epi, blipsign, rhasset, FALSE);      
    }
  } else {
    rhformat &= ~RHF_USE_FLIPTABLE;
  }

  /* fermi filter */
  rhfermr = opxres/2;


  /* override flip control set in GEReq_predownload()->{@inline loadrheader.e rheaderinit} 
  N.B.: ks_scan_epi_loadecho() changes the view indices based on the blipsign argument. Hence, 
  there is no need to inform recon that k-space data should be flipped (as opposed to the product
  epi.e/epi2.e, which use oepf = 1 when pepolar = 1) */
  eepf = 0;
  eeff = 0;
  oepf = 0;
  oeff = 0;
  set_echo_flip(&rhdacqctrl, &chksum_rhdacqctrl, eepf, oepf, eeff, oeff); /* clear bit 1 - flips image in phase dir */

#if EPIC_RELEASE >= 26
    rhdacqctrl |= 8192; /* disable Orchestra recon */
#endif

  /* save echo spacing value into rhesp */
  rhesp = epi->read.grad.duration;



  /* default but see below */
  rhpctemporal = 1;
  rhpccoil = 0;
  rhref = 0;
  rhtype1 &= ~RHTYP1DIFFUSIONEPI;

  /* Nyquist ghost correction using integrated ref scan combined with online recon (RHXC_XFER_IM) requires diffusion mode
     so here we pretend we are doing this */
  if (ghostcorrflag) {

    rhtype1 |= RHTYP1DIFFUSIONEPI; 

  #if EPIC_RELEASE < 26
    if (datadestination & RHXC_XFER_IM) {

        if ((multishotflag > 0) && (epi->blipphaser.R > 1)) {
      
          /* GE's online recon cannot do this type of ghost correction for multi-shot */
          return ks_error("%s: GhostCal+OnlineRecon requires single-shot", __FUNCTION__);
      
        } else {

          if (opdiffuse != KS_EPI_DIFFUSION_ON) {
            /* we have a non-diffusion EPI scan (e.g. SE-EPI or GE-EPI) that we want to use with GE's integrated
            refscan (rhref = 5), which only allows single-shot DW-EPI
            DV26 Update: The new Orchestra recon does not accept normal DAB packets, only HyperDAB packets (loadhsdab())
            which is not supported by the use of KS_EPI objects. This means that as of DV26+, GE's online recon cannot be used
            to recon EPI data with KS_EPI (i.e. not ksepi.e) */
            cvoverride(opdiffuse, KS_EPI_DIFFUSION_PRETEND_FOR_RECON, PSD_FIX_ON, PSD_EXIST_ON);
            cvoverride(optensor, 16, PSD_FIX_ON, PSD_EXIST_ON);
            cvoverride(rhnumdifdirs, 1, PSD_FIX_ON, PSD_EXIST_ON); /* Prep Action Failed if 0 */
            cvoverride(opdifnumdirs, 0, PSD_FIX_ON, PSD_EXIST_ON);
            cvoverride(opdifnumt2, opfphases, PSD_FIX_ON, PSD_EXIST_ON);
          }                

          rhref = 5;/* inform GE's product recon that we want this type of ghost correction */

        } /* Online recon prior to DV26 */
   }
  #endif

  }



  return SUCCESS;

} /* GEReq_predownload_setrecon_epi() */




/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the beginning of cvinit()

 In the beginning of `cvinit()` the following lines should be added:
 \code{.c}
 STATUS status = GEReq_cvinit();
 if (status != SUCCESS) return status;
 \endcode

 This function sets up various global GE stuff, including e.g. the gradient specs. The gradient specs
 are controlled by `ks_srfact` and `ks_qfact`. `ks_srfact` Should have a value that will allow scanning on
 all MR systems without PNS effects. Also, `ks_srfact` does not affect the EPI train in ksepi.e, since it
 controls the slewrate and gradient max separately. `ks_qfact` is supposed to be 1 by default, with the 
 purpose to from an optimal setting reduce the slewrate to reduce the acoustic noise. A default value of
 1.0 will make the system perform best but with high acoustic noise. A value of about 8-10 may be a good
 trade-off between acoustic noise reduction and reasonable image quality.

 In this function, `ks_sarcheckdone` is set to FALSE. This CV is checked in GEReq_predownload() and 
 ks_pg_rf(), which both will complain if it is not has been set to TRUE. GEReq_eval_checkTR_SAR_calcs() 
 sets this CV to TRUE.

 It is important that an error returned from GEReq_cvinit() also results in an error in `cvinit()`, 
 otherwise it will not show up in the UI.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_cvinit(void) {

  /* ART: Acoustic noise reduction
    Imaging option button "Acoustic reduction":
      - PSD_IOPT_MILDNOTE in sequence_iopts[]
      - Sets CV opsilent = TRUE
    When acoustic noise reduction (ART) imaging option is checked, enable the ART tab in the UI too
    by forcing cfnumartlevels = 2
    - "Moderate" radio button on ART tab: CV opsilentlevel = 1
    - "High" radio button on ART tab: CV opsilentlevel = 2
   */
  cvoverride(cfnumartlevels, 2, PSD_FIX_OFF, PSD_EXIST_ON);
  pinumartlevels = cfnumartlevels;
  
  if (opsilent) {
    _ks_qfact.existflag = TRUE;
    if (opsilentlevel == 1) {
      /* moderate */
      ks_qfact = 8;
    } else {
      /* high */
      ks_qfact = 20;
    }
  } else {
    ks_qfact = 1;
  }


  {
@inline vmx.e SysParmInit
  }

  EpicConf();

  /* set gradient limitations (calling GEs obloptimize() & further ramptime modifications) */
  GEReq_init_gradspecs(&loggrd, &phygrd, ks_srfact / ks_qfact);

  /* resets all filter #. From this point, ok to call setfilter() */
  initfilter();

  /* setsysparams() sets psd_grd_wait and psd_rf_wait for the system */
  setsysparms();
#ifdef SIM
  /* In simulation, we don't want them to confuse the timing in WTools */
  _psd_grd_wait.fixedflag = 0;
  _psd_rf_wait.fixedflag = 0;
  psd_grd_wait = 0;
  psd_rf_wait = 0;
#endif

#include "cvinit.in"  /* Runs the code generated by macros in preproc.*/

  /* GE CVs that could use a wider min/max range: */
  cvmax(rhfrsize, 32768);
  cvmax(rhdaxres, 32768);
  cvmax(opphasefov, 5); /* to allow larger FOV in phase enc dir that freq */
  cvmax(rhnslices, 50000); /* 50,000, which is 5x of RHF_MAX_IMAGES_MULTIPHASE = 10000 */
  cvmax(rhreps, 2048); /* max 2048 vols */
  cvmax(rhnphases, 2048); /* max 2048 vols */
  cvmax(opfphases, 2048); /* max 2048 vols */
  cvmax(opyres, 1024); /* max 1024 yres */
  cvmax(opslthick, 200); /* max 200 mm slice thickness */
  cvmax(optr, 60s); /* max 60s TR */
  cvmax(ihtr, 60s);
  cvmax(rhref, 5); /* Allow 1st-volume ghost correction as GE's diffusion EPI (only works for single shot) */
  cvmax(opbval, 30000);
  cvmax(opileave, 1);

  /* activate Advisory panel */
  piadvise = PSD_ON;
  piadvmin  = (1 << PSD_ADVTE); /* TE Advisory on */
  piadvmin |= (1 << PSD_ADVTR);  /* TR Advisory on */
  piadvmin |= (1 << PSD_ADVRCVBW);/* rBW Advisory on */
  piadvmin |= (1 << PSD_ADVFOV);/* FOV Advisory on */
  piadvmax = piadvmin;

  {
@inline Prescan.e PScvinit
  }


  /* KSFoundation indicator variable for completed SAR checks (c.f. GEReq_eval_checkTR_SAR_calcs(), which sets it to TRUE) */
  ks_sarcheckdone = FALSE;

 /* GE's psd_name seems not be available on TGT, to let's copy this one */
#if EPIC_RELEASE > 27 || (EPIC_RELEASE == 27 && EPIC_PATCHNUM > 1)
/* #if EPIC_RELEASE >= 27 */
/* Since RX27R02, GE's psd_name no longer exists */
{
  strcpy(ks_psdname, get_psd_name());
}
#else
  strcpy(ks_psdname, psd_name);
#endif


  return SUCCESS;

} /* GEReq_cvinit() */




/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the beginning of cveval()

 In the beginning of `cveval()` the following lines should be added:
 \code{.c}
 STATUS status = GEReq_cveval();
 if (status != SUCCESS) return status;
 \endcode

 This function up various global GE stuff, and copies also the struct array `scan_info`, holding the
 prescribed slice locations to `ks_scan_info`, the latter which can also be accessible on TGT.

 Simulation (WTools): If we have ks_simscan = 1 (default), simscan() will have make up slice locations in
 ks_scan_info based on opslthick, opslspace and opslquant. Note, GE clears scan_info between cvcheck() 
 and predownload() when in simulation. Hence, we now have the opposite case, i.e. we have some slice info
 data in ks_scan_info but nothing in scan_info.

 It is important that an error returned from GEReq_cveval() also results in an error in `cveval()`, 
 otherwise it will not show up in the UI.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_cveval(void) {

  {
@inline vmx.e SysParmEval
@inline Prescan.e PScveval
@inline loadrheader.e rheadereval
  }

 InitAdvPnlCVs();

#ifdef PSD_HW
 /* MR scanner (hardware): copy scan_info to ks_scan_info, so we can use this data on TGT */
 memcpy(ks_scan_info, scan_info, opslquant*sizeof(SCAN_INFO));
#else
  /* WTools (sim) */
  if (ks_simscan)
    simscan();
#endif

  return SUCCESS;

} /* GEReq_cveval() */


/**
 *******************************************************************************************************
 @brief #### Mandatory APx functions for PSDs from DV26

 DV26 requires getAPxAlgorithm() and getAPxParam() functions to exist in each PSD.
 Empty getAPxAlgorithm() and getAPxParam() functions are declared below in GERequired.e to allow
 compilation on DV26. If a PSD wants to use this new functionality in DV26 it should add the following
 line:
 #define KS_PSD_USE_APX 1
 in its @global section, so that KS_PSD_USE_APX is not set to 0 here, and hence getAPxAlgorithm() and
 getAPxParam() wont be redeclared here in GERequired.e.
********************************************************************************************************/
#if (KS_PSD_USE_APX == 0) && (EPIC_RELEASE >= 26)
void getAPxParam(optval *min,
            optval   *max,
            optdelta *delta,
            optfix   *fix,
            float    coverage,
            int      algorithm) {
    /* Need to be filled when APx is supported in this PSD */
}

int getAPxAlgorithm(optparam *optflag, int *algorithm) {
    return APX_CORE_NONE;
}
#endif



/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the beginning of cvcheck()

 In the beginning of `cvcheck()` the following lines should be added:
 \code{.c}
 STATUS status = GEReq_cveval();
 if (status != SUCCESS) return status;
 \endcode

 It is important that an error returned from GEReq_cvcheck() also results in an error in `cvcheck()`, 
 otherwise it will not show up in the UI.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_cvcheck(void) {

  if (existcv(optr) && optr < avmintr) {
    epic_error(use_ermes, "The minimum TR is %-d ms", EM_PSD_TR_OUT_OF_RANGE, EE_ARGS(1), INT_ARG, (avmintr / 1ms));
    return ADVISORY_FAILURE;
  }
  if ((exist(opte) < avminte) && existcv(opte)) {
    epic_error(use_ermes, "The minimum TE is %-d ms", EM_PSD_TE_OUT_OF_RANGE1, 1, INT_ARG, (avminte / 1ms));
    return ADVISORY_FAILURE;
  }
  if ((exist(opte) > avmaxte) && existcv(opte)) {
    epic_error(use_ermes, "The maximum TE is %-d ms", EM_PSD_TE_OUT_OF_RANGE1, 1, INT_ARG, (avmaxte / 1ms));
    return ADVISORY_FAILURE;
  }

  return SUCCESS;

} /* GEReq_cvcheck() */




/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the beginning of predownload()

 In the beginning of `predownload()` the following lines should be added:
 \code{.c}
 STATUS status = GEReq_predownload();
 if (status != SUCCESS) return status;
 \endcode

 This function up various global GE stuff related to recon and data filters. Also, `ks_sarcheckdone` is
 checked to make sure that GEReq_eval_checkTR_SAR_calcs() has been called to monitor SAR/heating limits.

 It is important that an error returned from GEReq_predownload() also results in an error in `predownload()`, 
 otherwise it will not show up in the UI.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS GEReq_predownload(void) {

  {
@inline vmx.e PreDownLoad
  }

  nex = ceil(opnex); /* nex is used in rheaderinit instead of opnex, so must set it here. otherwise prescan fails */

  /* UsePgenOnHost() (Imakefile) likes calling calcPulseParams() at this spot, containing "predownload.in" */
  calcPulseParams();

 {
@inline loadrheader.e rheaderinit   /* default handling of recon variables */
@inline Prescan.e PSfilter
  }

  /* Set rhkacq_uid for ARC support and linking plots */
  int uid;
  struct tm now;
  time_t now_epoch = time(NULL);
  /* Generate unique ID for this scan for naming kacq files and
     debug files.  Use the current date and time (MMDDHHMMSS).
     Cannot include the year because this is larger than a
     signed 32-bit integer */
  localtime_r(&now_epoch, &now);
  uid = now.tm_sec +
        now.tm_min  * 100 +
        now.tm_hour * 10000 +
        now.tm_mday * 1000000 +
        (now.tm_mon + 1) * 100000000;
  rhkacq_uid = uid;


 /* Check that SAR calculations have been performed */
  if (ks_sarcheckdone != TRUE) {
#ifdef SIM
    if (existcv(optr) == TRUE && existcv(opte) == TRUE && existcv(opslquant) == TRUE) {
      /* In simulation (WTools), predownload is called every time a CV is changed but
      ks_sarcheckdone will not be set to TRUE in GEReq_eval_checkTR_SAR_calcs() unless
      optr, opte and opslquant have all been set (existcv() != FALSE). Hence, in simulation,
      we cannot throw an error before these have been set */
      return ks_error("%s: Missing call to GEReq_eval_checkTR_SAR()", __FUNCTION__);
    }
#else
    return ks_error("%s: Missing call to GEReq_eval_checkTR_SAR()", __FUNCTION__);
#endif
  }

 return SUCCESS;

} /* GEReq_predownload() */




@pg
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: PULSEGEN functions
 *                Accessible on TGT, and also HOST if UsePgenOnHost() in the Imakefile
 *
 *******************************************************************************************************
 *******************************************************************************************************/
#include <stdio.h>
#include <stdlib.h>

@inline Prescan.e PSipg

/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the beginning of pulsegen()

 In the beginning of `pulsegen()` the following lines should be added:
 \code{.c}
 GEReq_pulsegenBegin();
 \endcode

 This function up various global GE stuff related to pulsegen()
********************************************************************************************************/
void GEReq_pulsegenBegin(void) {

  sspinit(psd_board_type);

  {
@inline vmx.e VMXpg
  }
} /* GEReq_pulsegenBegin() */




/**
 *******************************************************************************************************
 @brief #### Helper function to be called at the end of pulsegen()

 In the end of `pulsegen()`, but before `buildinstr()`, the following lines should be added:
 \code{.c}
 GEReq_pulsegenEnd();
 \endcode

 This function up prescan pulsegen and adds a PASSPACK sequence ("GEendpass"), which is used to dump
 rawdata and mark the end of scan. See GEReq_endofpass() and GEReq_endofscan() and how they are used
 in a psd.
********************************************************************************************************/
void GEReq_pulsegenEnd(void) {

#ifdef IPG
  {
@inline Prescan.e PSpulsegen
  }

/* pass sequence to dump Pfiles */
PASSPACK(GEendpass, pw_passpacket-1ms);
SEQLENGTH(GEpass, pw_passpacket, GEpass);

#endif
} /* GEReq_pulsegenEnd() */




/**
 *******************************************************************************************************
 @brief #### Sets SSP word in sequence off_GEpass() to trigger data (Pfile) writing and reconstruction

 After calling this function, the parent function must switch back to the previous/main sequence 
 using ks_scan_playsequence() (or *boffset()*).
********************************************************************************************************/
void GEReq_endofpass() {
#ifdef IPG
  boffset(off_GEpass);
  setwamp(SSPD + DABPASS, &GEendpass, 2 ); /* end of pass */
  startseq(0, (short) MAY_PAUSE);
#endif
} /* GEReq_endofpass() */




/**
 *******************************************************************************************************
 @brief #### Sets SSP word in sequence off_GEpass() to tell system that scan is done
********************************************************************************************************/
void GEReq_endofscan() {
#ifdef IPG
  boffset(off_GEpass);
  setwamp(SSPD + DABSCAN, &GEendpass, 2 ); /* end of scan */
  startseq(0, (short) MAY_PAUSE);
#endif
} /* GEReq_endofscan() */




/**
 *******************************************************************************************************
 @brief #### Sets SSP word in sequence off_GEpass() to tell system that scan is done
********************************************************************************************************/
void GEReq_endofpassandscan() {
  #ifdef IPG
    boffset(off_GEpass);
    setwamp(SSPD + DABPASS + DABSCAN, &GEendpass, 2 ); /* end of scan */
    startseq(0, (short) MAY_PAUSE);
  #endif
  } /* GEReq_endofscan() */
  
  

/*****************************************************************************************************
 * RSP Variables
 * Accessible for tgt.c (on TGT)
 *****************************************************************************************************/
@rspvar

short debugstate;              /* required by PSfasttg, PSexpresstg, ASautoshim */
short viewtable[513];

extern PSD_EXIT_ARG psdexitarg;
int rspent;
int rspdda;
int rspbas;
int rspvus;
int rspgy1;
int rspasl;
int rspesl;
int rspchp;
int rspnex;
int rspslq;
int rspsct;
int rsprep;
short chopamp;

/* For Prescan */
int seqCount;
int view, excitation, debug; /* these are needed from DV26 */

@inline Prescan.e PSrspvar





/*****************************************************************************************************
 * RSP Functions
 * Accessible for tgt.c (on TGT)
 *****************************************************************************************************/
@rsp

/* For IPG Simulator: will generate the entry point list in the IPG tool */
CHAR *entry_name_list[ENTRY_POINT_MAX] = {
  "scan",
  "mps2",
  "aps2",
@inline Prescan.e PSeplist
};

/* Do not move the line above and do not insert any code or blank
   lines before the line above.  The code inline'd from Prescan.e
   adds more entry points and closes the list. */
@inline Prescan.e PScore




/**
 *******************************************************************************************************
 @brief #### Not sure what this function does, but it exists in all product psds.
********************************************************************************************************/
void dummylinks(void) {
  epic_loadcvs( "thefile" ); /* for downloading CVs */
}




/**
 *******************************************************************************************************
 @brief #### RSP Init. To be inserted in the psdinit() function (or scan()) in the main sequence
********************************************************************************************************/
void GEReq_initRSP(void) {

  /* Initialize everything to a known state */
  setrfconfig((short) ks_rfconf);   /* ENBL_RHO1 + ENBL_THETA + ENBL_OMEGA + ENBL_OMEGA_FREQ_XTR1 = 141 */
  rspqueueinit(200);  /* Initialize to 200 entries */
  syncoff(&GEpass);   /* Deactivate sync during pass */
}

