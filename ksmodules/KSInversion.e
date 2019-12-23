/*******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : KSInversion.e
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
* @file KSInversion.e
* @brief This file contains an inversion preparation module that should be `@inline`'d at the beginning
         of a KSFoundation PSD
********************************************************************************************************/




@global
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSInversion.e: Global section
 *
 *******************************************************************************************************
 *******************************************************************************************************/

enum {KSINV_OFF, KSINV_IR_SIMPLE, KSINV_IR_SLICEAHEAD, KSINV_FLAIR_BLOCK, KSINV_FLAIR_T2PREP_BLOCK};
enum {KSINV_RF_STD, KSINV_RF_ADIABATIC, KSINV_RF_CUSTOM};
typedef enum {KSINV_LOOP_NORMAL, KSINV_LOOP_DUMMY, KSINV_LOOP_SLICEAHEAD_FIRST, KSINV_LOOP_SLICEAHEAD_LAST} KSINV_LOOP_MODE;

#define KSINV_MODULE_LOADED /* can be used to check whether the KSInversion module has been included in a main psd */

#define KSINV_DEFAULT_FLIP 180
#define KSINV_DEFAULT_SPOILERAREA 5000
#define KSINV_DEFAULT_SSITIME 1000 /* try to reduce this value */
#define KSINV_DEFAULT_STARTPOS 100
#define KSINV_FILLTR_SSITIME 1000 /* try to reduce this value */
#define KSINV_MINTR_T2FLAIR 8000000 /* default minTR [us] for T2FLAIR, 8 [s] */
#define KSINV_MINTR_T1FLAIR 1300000 /* default minTR [us] for T1FLAIR, 1.3 [s] */
#define KSINV_MAXTR_T1FLAIR 2500000 /* default maxTR [us] for T1FLAIR, 2.5 [s] */
#define KSINV_MAXTHICKFACT 3.0 /* how much the inversion slice thickness may increase over opslthick */

/* values in [ms] */
#define T1_CSF_3T   4500
#define T1_CSF_1_5T 3600
#define T1_GM_3T   1400
#define T1_GM_1_5T 1100
#define T1_WM_3T   750
#define T1_WM_1_5T 600
#define T1_FAT_3T   340
#define T1_FAT_1_5T 260


/** @brief #### `typedef struct` holding steering parameters for KSInversion
*/
typedef struct _KSINV_PARAMS {
  int irmode; /* KSINV_OFF, KSINV_IR_SIMPLE, KSINV_IR_SLICEAHEAD, KSINV_FLAIR_BLOCK, KSINV_FLAIR_T2PREP_BLOCK */
  float flip;
  float slthick;
  int rfoffset; /* [Hz] */
  int rftype; /* KSINV_RF_STD or KSINV_RF_ADIABATIC */
  float spoilerarea;
  int approxti; /* Allow TI to be approximized */
  int startpos; /* time from beginning of inv seq to the beginning of the inversion pulse */
  int nslicesahead; /* Only used for irmode = KSINV_IR_SLICEAHEAD */
  int nflairslices; /* #slices that can fit in a KSINV_FLAIR_BLOCK or KSINV_FLAIR_T2PREP_BLOCK*/
  int ssi_time;
  /* T2prep related */
  float flip_exc;
  float slthick_exc;
  int N_Refoc;
  int t2prep_TE;
  int rftype_refoc; /* KSINV_RF_STD or KSINV_RF_ADIABATIC */
} KSINV_PARAMS;
#define KSINV_INIT_PARAMS {KSINV_OFF, KSINV_DEFAULT_FLIP, KS_NOTSET, 0, KSINV_RF_STD, KSINV_DEFAULT_SPOILERAREA, FALSE, KSINV_DEFAULT_STARTPOS, 0, 0, KSINV_DEFAULT_SSITIME, 90, KS_NOTSET, 1, KS_NOTSET, KSINV_RF_STD}

/** @brief #### typedef struct holding all information about the KSInversion sequence module incl. all gradients and waveforms
*/
typedef struct _KSINV_SEQUENCE {
  KS_BASE base;
  KS_SEQ_CONTROL seqctrl;
  KSINV_PARAMS params; /* input params */
  KS_SELRF selrfinv; /* Used for inversion and/or refocung pulse for t2prep */
  KS_TRAP spoiler;
  KS_SELRF selrfexc; /* t2prep */
  KS_SELRF selrfflip; /* t2prep */
  KS_SELRF selrfrefoc;
} KSINV_SEQUENCE;
#define KSINV_INIT_SEQUENCE {{0,0,NULL,sizeof(KSINV_SEQUENCE)}, KS_INIT_SEQ_CONTROL, KSINV_INIT_PARAMS, KS_INIT_SELRF, KS_INIT_TRAP, KS_INIT_SELRF, KS_INIT_SELRF, KS_INIT_SELRF}


/* Function prototypes */
STATUS ksinv_eval_checkTR_SAR(KS_SEQ_COLLECTION *seqcollection, KS_SLICE_PLAN *slice_plan, int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args);
int ksinv_pg(KSINV_SEQUENCE *);
int ksinv_scan_sliceloop(const KS_SLICE_PLAN *slice_plan, const SCAN_INFO *slice_positions, int passindx, 
                         KSINV_SEQUENCE *ksinv1, KSINV_SEQUENCE *ksinv2, KS_SEQ_CONTROL *ksinv_filltr, KSINV_LOOP_MODE ksinv_loop_mode,
                         int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args);


@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSInversion.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
KSINV_SEQUENCE ksinv1 = KSINV_INIT_SEQUENCE; /* for one IR pulse */
KSINV_SEQUENCE ksinv2 = KSINV_INIT_SEQUENCE; /* for dual IR (DIR) */
KS_SEQ_CONTROL ksinv_filltr = KS_INIT_SEQ_CONTROL; /* dead time between the end of main sequence and end of TR for FLAIR and gradient heating */

/* Variables to connect to the four opusers reserved by KSINV_EVAL() */
int ksinv1_ti = 0;
int ksinv2_ti = 0;

int use_ir1_mode = 0;
int use_ir1_t1 = 0;
int use_ir2_mode = 0;
int use_ir2_t1 = 0;

/* opuser pointers */
float *ksinv1_mode = NULL;
float *ksinv2_mode = NULL;
float *ksinv1_t1value = NULL;
float *ksinv2_t1value = NULL;
_cvfloat *_ksinv1_mode = NULL;
_cvfloat *_ksinv2_mode = NULL;
_cvfloat *_ksinv1_t1value = NULL;
_cvfloat *_ksinv2_t1value = NULL;


@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSInversion.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
int ksinv_ssi_time = KSINV_DEFAULT_SSITIME with {10, 20000, KSINV_DEFAULT_SSITIME, VIS, "Time from eos to ssi in intern trig",};
int ksinv_filltr_ssi_time = KSINV_FILLTR_SSITIME with {10, 20000, KSINV_FILLTR_SSITIME, VIS, "Time from eos to ssi in intern trig",};
int ksinv_mintr_t2flair = KSINV_MINTR_T2FLAIR with {0, 30s, KSINV_MINTR_T2FLAIR, VIS, "Min TR for T2-FLAIR",};
int ksinv_mintr_t1flair = KSINV_MINTR_T1FLAIR with {0, 30s, KSINV_MINTR_T1FLAIR, VIS, "Min TR for T1-FLAIR",};
int ksinv_maxtr_t1flair = KSINV_MAXTR_T1FLAIR with {0, 30s, KSINV_MAXTR_T1FLAIR, VIS, "Max TR for T1-FLAIR",};
int ksinv_slicecheck = 0 with {0.0, 1.0, 0.0, VIS, "move slice sel to x axis for slice thickness test",};
int ksinv_approxti = 1 with {0, 1, 1, VIS, "allow approx. TI for sliceahead IR mode",};

/* CVs for KSINV_PARAMS */
float ksinv_flip = KSINV_DEFAULT_FLIP with {0, 360, KSINV_DEFAULT_FLIP, VIS, "RF flip angle [deg]",};
float ksinv_slthickfact = 1.0 with {0, KSINV_MAXTHICKFACT, 1.0, VIS, "Inversion sl.thick / opslthick factor",};
int ksinv_rfoffset = 0 with { -10000, 10000, 0, VIS, "RF excitation freq offset [Hz]",};
int ksinv_rftype = KSINV_RF_ADIABATIC  with {KSINV_RF_STD, KSINV_RF_ADIABATIC, KSINV_RF_ADIABATIC, VIS, "RF type (0:Std 1:Adiabatic)",};
float ksinv_spoilerarea = KSINV_DEFAULT_SPOILERAREA with {0, 100000, KSINV_DEFAULT_SPOILERAREA, VIS, "Spoiler area",};
int ksinv_startpos = KSINV_DEFAULT_STARTPOS with {16, 10000, KSINV_DEFAULT_STARTPOS, VIS, "Start time of the first grad/RF inversion pulse in sequence module",};

/* CVs for T2 preppred T2 FLAIR --> KSINV_FLAIR_T2PREP_BLOCK*/
int ksinv_t2prep = 0 with {0, 1, 0, VIS, "Use T2 preperation instead of conventional Inversion",};
int ksinv_t2prep_exc_flip = 90 with {0, 180, 90, VIS, "Flip angle of the excitation pulse and the flip down/up pulse for T2 prep",};
int ksinv_t2prep_N_Refoc = 1 with {1, 16, 1, VIS, "Number of refocusing pulses in the T2 inversion preperation",};
int ksinv_t2prep_TE = 100ms with {30ms, 300ms, 100ms, VIS, "TE for T2 inv preperation",};
int ksinv_t2prep_rftype_refoc = KSINV_RF_STD with {KSINV_RF_STD, KSINV_RF_ADIABATIC, KSINV_RF_STD, VIS, "RF type (0:Std 1:Adiabatic)",};
float ksinv_slthickfact_exc = 1.0 with {0, KSINV_MAXTHICKFACT, 1.0, VIS, "Inversion sl.thick / opslthick factor",};
@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSInversion.e: HOST functions and variables
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Resets the KSINV_PARAMS struct (arg 1) to KSINV_INIT_PARAMS

 @param[out] params Pointer to the ksinv params struct used to steer the behavior of this inversion
                     sequence module
 @return void
********************************************************************************************************/
void ksinv_init_params(KSINV_PARAMS *params) {
  KSINV_PARAMS defparams = KSINV_INIT_PARAMS;
  *params = defparams;
} /* ksinv_init_params() */




/**
 *******************************************************************************************************
 @brief #### Resets the KSINV_SEQUENCE struct (arg 1) to KSINV_INIT_SEQUENCE

 As KSINV_INIT_SEQUENCE contains KSINV_PARAMS, which sets the field `.irmode = KSINV_OFF`,
 calling ksinv_init_sequence() will disable the `ksinversion` sequence module (i.e. turn off inversion)

 @param[out] ksinv Pointer to KSINV_SEQUENCE
 @return void
********************************************************************************************************/
void ksinv_init_sequence(KSINV_SEQUENCE *ksinv) {
  KSINV_SEQUENCE defseq = KSINV_INIT_SEQUENCE;
  *ksinv = defseq;
  ksinv_init_params(&ksinv->params);
} /* ksinv_init_sequence() */




/**
 *******************************************************************************************************
 @brief #### Copy CVs into a common params struct (KSINV_PARAMS) used to steer this sequence module

 @param[out] params Pointer to the ksinv params struct used to steer the behavior of this inversion
                     sequence module
 @param[in] mode Inversion mode, one of: KSINV_OFF, KSINV_IR_SIMPLE, KSINV_IR_SLICEAHEAD, KSINV_FLAIR_BLOCK
 @return void
********************************************************************************************************/
void ksinv_eval_copycvs(KSINV_PARAMS *params, int mode) {

  ksinv_init_params(params);

  params->irmode = mode;

  if (params->irmode != KSINV_OFF) {
    params->flip = ksinv_flip;
    if (KS_3D_SELECTED) {
      params->slthick = opvthick * ksinv_slthickfact;
    } else {
      params->slthick = opslthick * ksinv_slthickfact;
    }
    params->rfoffset = ksinv_rfoffset;
    params->rftype = ksinv_rftype;
    params->spoilerarea = ksinv_spoilerarea;
    if (params->irmode == KSINV_IR_SLICEAHEAD) {
      params->approxti = ksinv_approxti; /* Only applicable for sliceahead mode */
    } else {
      params->approxti = FALSE;
    }
    params->startpos = RUP_GRD(ksinv_startpos);
    params->nslicesahead = 0;
    params->nflairslices = 0;

    if (params->irmode == KSINV_FLAIR_T2PREP_BLOCK) {
        params->slthick_exc = opslthick * ksinv_slthickfact_exc;
        params->flip_exc = ksinv_t2prep_exc_flip;
        params->N_Refoc = ksinv_t2prep_N_Refoc;
        params->t2prep_TE = ksinv_t2prep_TE;
        params->rftype_refoc = ksinv_t2prep_rftype_refoc;
    }   
  }

  /* SSI time */
  params->ssi_time = ksinv_ssi_time;

} /* ksinv_eval_copycvs() */




/**
 *******************************************************************************************************
 @brief #### Sets up the RF sequence object for the inversion sequence module (KSINV_SEQUENCE ksinv)

 This function is called from ksinv_eval_setupobjects()

 @param[in,out] ksinv Pointer to a KSINV_SEQUENCE sequence module to be set up
 @param[in] suffix Suffix string to att to "ksinv" for the description of the sequence module
 @param[in,out] custom_selrf Optional pointer to KS_SELRF for custom inversion RF pulse. Pass NULL to use
                         default RF pulses.
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_setuprf(KSINV_SEQUENCE *ksinv, const char *suffix, KS_SELRF *custom_selrf) {
  STATUS status;
  char tmpstr[1000];

  /* if irmode == KSINV_OFF, reset and return */
  if (ksinv->params.irmode == KSINV_OFF) {
    ksinv_init_sequence(ksinv);
    return SUCCESS;
  }

  if (custom_selrf != NULL) {

    ksinv->selrfinv = *custom_selrf;
    ksinv->params.rftype = KSINV_RF_CUSTOM;
    return SUCCESS;

  } else if (ksinv->params.rftype == KSINV_RF_ADIABATIC) {

    ksinv->selrfinv.rf = adinv_shNvrg5b; /* KSFoundation_GERF.h */

  } else if (ksinv->params.rftype == KSINV_RF_STD) {

    ksinv->selrfinv.rf = inv_invI0; /* KSFoundation_GERF.h */

  } else {

    return ks_error("%s: invalid RF type (ksinv.params.rftype = %d)", __FUNCTION__, ksinv->params.rftype);

  }

  /* N.B. The designed (i.e. nominal) flip angle varies a lot between GE's inversion RF pulses:
     - adinv_sh3t2: 250 deg.
     - shNvrg5b: 43.82 deg.
     - invI0: (non-adiabatic) 178 deg
     So it is important to set the desired FA now after the 'ksinv->selrfinv.rf =' assignment above.
     The relation between .selrfinv.rf.flip and .selrfinv.rf.rfpulse.nom_fa can be used internally for RF scaling
  */
  ksinv->selrfinv.rf.flip = ksinv->params.flip; /* desired FA */
  ksinv->selrfinv.rf.cf_offset = ksinv->params.rfoffset; /* Exciter offset in Hz */
  ksinv->selrfinv.slthick = ksinv->params.slthick;
  sprintf(tmpstr, "ksinv_selinv%s", suffix);

  status = ks_eval_selrf(&ksinv->selrfinv, tmpstr);
  if (status != SUCCESS) return status;


  return SUCCESS;

} /* ksinv_eval_setuprf() */


STATUS ksinv_eval_setupt2prep(KSINV_SEQUENCE *ksinv) {
  STATUS status;
    status = SUCCESS;

    ksinv->selrfexc.rf = exc_ssfse90new;
    ksinv->selrfexc.rf.flip = ksinv->params.flip_exc;
    ksinv->selrfexc.slthick = ksinv->params.slthick_exc;
    status = ks_eval_selrf(&ksinv->selrfexc, "ksinv_T2prep_exc");
    if (status != SUCCESS) return status;

    ksinv->selrfflip.rf = exc_ssfse90new;
    ksinv->selrfflip.slthick = ksinv->params.slthick_exc;
    ksinv->selrfflip.rf.flip = ksinv->params.flip_exc;
    status = ks_eval_selrf(&ksinv->selrfflip, "ksinv_T2prep_flip");
    if (status != SUCCESS) return status;

    if (ksinv->params.rftype == KSINV_RF_ADIABATIC) {
      /*adiabatic refoc and inversion pulses  */      
      if (cffield == 30000){
        ksinv->selrfinv.rf = adinv_sh3t2; /* KSFoundation_GERF.h */
      } else {
        ksinv->selrfinv.rf = adinv_shNvrg5b; /* KSFoundation_GERF.h */
      }
    } else {
      ksinv->selrfinv.rf = ref_se1b4;
    }

    if (ksinv->params.rftype_refoc == KSINV_RF_ADIABATIC) {
      /*adiabatic refoc and inversion pulses  */      
      if (cffield == 30000){
        ksinv->selrfrefoc.rf = adinv_sh3t2; /* KSFoundation_GERF.h */  
      } else {
        ksinv->selrfrefoc.rf = adinv_shNvrg5b; /* KSFoundation_GERF.h */         
      }
    } else {
      ksinv->selrfrefoc.rf = ref_se1b4;
    }

    ksinv->selrfrefoc.rf.role =  KS_RF_ROLE_REF;      
    ksinv->selrfrefoc.rf.flip = ksinv->params.flip;
    ksinv->selrfrefoc.slthick = ksinv->params.slthick;
    status = ks_eval_selrf(&ksinv->selrfrefoc, "ksinv_T2prep_refoc");
    if (status != SUCCESS) return status;

    ksinv->selrfinv.rf.role =  KS_RF_ROLE_INV;
    ksinv->selrfinv.rf.flip = ksinv->params.flip;
    ksinv->selrfinv.slthick = ksinv->params.slthick;
    status = ks_eval_selrf(&ksinv->selrfinv, "ksinv_T2prep_inv");
    if (status != SUCCESS) return status;

    ksinv->selrfflip.pregrad = ksinv->selrfflip.postgrad;
    /* ksinv->selrfexc.pregrad is empty --> no postgrad for selrfflip.postgrad*/
    ksinv->selrfflip.postgrad = ksinv->selrfexc.pregrad;

  return SUCCESS;

} /* ksinv_eval_setupt2prep() */

/**
 *******************************************************************************************************
 @brief #### Sets up the sequence objects for the inversion sequence module (KSINV_SEQUENCE ksinv)

 KSInversion.e has two inversion sequence modules, `ksinv1` and `ksinv2`, the latter only active for
 dual-IR. These are both declared in `@ipgexport` in KSInversion.e.

 This function takes one of these sequence modules as first input argument (called from
 ksinv_eval()) and sets up the sequence objects in that KSINV_SEQUENCE, with `suffix` as the unique suffix
 name for the sequence module (currently "1" and "2" in ksinv_eval()).

 @param[in,out] ksinv Pointer to a KSINV_SEQUENCE sequence module to be set up
 @param[in] suffix Suffix string to att to "ksinv" for the description of the sequence module
 @param[in,out] custom_selrf Optional pointer to KS_SELRF for custom inversion RF pulse. Pass NULL to use
                         default RF pulses.
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_setupobjects(KSINV_SEQUENCE *ksinv, const char *suffix, KS_SELRF *custom_selrf) {
  STATUS status;
  char tmpstr[1000];

  /* if irmode == KSINV_OFF, reset and return */
  if (ksinv->params.irmode == KSINV_OFF) {
    ksinv_init_sequence(ksinv);
    return SUCCESS;
  }

  if (ksinv->params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {
    /* t2prepped selective RF inversion */
    status = ksinv_eval_setupt2prep(ksinv);
    if (status != SUCCESS) return status;
  } else {
    /* Selective RF inversion */
    status = ksinv_eval_setuprf(ksinv, suffix, custom_selrf);
    if (status != SUCCESS) return status;
  }

  /* set up spoiler */
  ksinv->spoiler.area = ksinv->params.spoilerarea;
  sprintf(tmpstr, "ksinv_spoiler%s", suffix);
  /* make a trap that has 3x lower slewrate than normal, since minimum IR seq duration is not time critical */
  status = ks_eval_trap_constrained(&ksinv->spoiler, tmpstr, ks_syslimits_ampmax(loggrd), ks_syslimits_slewrate(loggrd) / 3.0, 0);
  /* status = ks_eval_trap(&ksinv->spoiler, tmpstr); */
  if (status != SUCCESS) return status;


  /* Name seqmodule and setup seqctrl with desired SSI time and zero duration. .min_duration will be set in ksinv_pg() */
  ks_init_seqcontrol(&ksinv->seqctrl);
  sprintf(tmpstr, "ksinv%s", suffix);
  strcpy(ksinv->seqctrl.description, tmpstr);

  return SUCCESS;

} /* ksinv_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Calculates the TI value necessary to null the signal from a tissue with a given T1 value,
             the TR of the sequence and the main sequence duration, all in [us]

 @param[in] TR Repetition time in [us]
 @param[in] T1value The T1 value of the tissue to be nulled in [us]
 @param[in] seqdur The duration of the main sequence in [us]
 @retval TItime Inversion time in [us]
*/
int ksinv_eval_nullti(int TR, int T1value, int seqdur) {

  return (int) ((double) T1value * ( log(2.0) - log(1.0 + exp(-((double) TR - (double) seqdur)/((double) T1value))) ));

} /* ksinv_eval_nullti() */




/**
 *******************************************************************************************************
 @brief <h4>Sets the sequence module duration of a KSINV_SEQUENCE module based on an inversion time (TI)
            and the delay time from the start of the main sequence to its excitation center</h4>

 For simple main sequences consisting of only one sequence module each time it is played out (i.e. without
 additional fatsat or spatial sat sequences attached before each main sequence), `coreslice_momentstart`
 is typically a small value of a few [ms] indicating the isocenter of the excitation pulse of the main
 sequence measured from the start of the main sequence. When e.g. a fatsat pulse sequence module is added
 before each main sequence module, this needs to be taken into account to get the correct inversion time.
 In these cases `coreslice_momentstart` should be larger (to also include any leading extra sequence
 module between the inversion module and the main sequence module, and consequently the duration of the
 inversion module becomes proportionally smaller. If `TI` is short in relation to `coreslice_momentstart`
 this function will return an error.

 @param[in,out] ksinv Pointer to a KSINV_SEQUENCE sequence module
 @param[in] TI Desired inversion time in [us]
 @param[in] coreslice_momentstart The delay time from the end of the inversion module to the isocenter
                                   of the excitation pulse of the main sequence
 @retval TItime Inversion time in [us]
*/
STATUS ksinv_eval_duration(KSINV_SEQUENCE *ksinv, int TI, int coreslice_momentstart) {

  if (ksinv->seqctrl.momentstart <= 0) {
    return ks_error("%s: Moment start position of the inversion sequence (arg 1) must be > 0", __FUNCTION__);
  }
  if (TI <= 0) {
    return ks_error("%s: TI must be > 0", __FUNCTION__);
  }
  if (coreslice_momentstart <= 0) {
    return ks_error("%s: The core slice moment start position must be  > 0", __FUNCTION__);
  }
  if (ksinv->params.irmode != KSINV_IR_SIMPLE) {
       return ks_error("%s: ksinv.params.irmode must be KSINV_IR_SIMPLE for this function", __FUNCTION__);
  }

  ksinv->params.nslicesahead = 0;
  ksinv->params.nflairslices = 0;

  ksinv->seqctrl.duration = RUP_GRD(TI + ksinv->seqctrl.momentstart - coreslice_momentstart);

  if (ksinv->seqctrl.min_duration > ksinv->seqctrl.duration) {
    return ks_error("%s: Input args resulted in a a too short inv. seq. duration", __FUNCTION__);
  }

  return SUCCESS;

} /* ksinv_eval_duration() */




/**
 *******************************************************************************************************
 @brief #### Sets the sequence module duration of a KSINV_SEQUENCE as well as TI and TR (slice-ahead IR)

 This function enables the *slice-ahead* inversion mode, where the duration of the sequence module is
 determined while iteratively finding TI and TR, based on the duration and momentstart of the
 core slice playout. One 'core slice' consists of the main sequence and all other sequence modules played
 out every time with the main sequence directly before or after, e.g. [FatSat]-[SpatialSat]-[Mainsequence].

 Optionally, one can pass in an `approxti_flag`. If `FALSE (= 0)`, then the inversion module duration is
 set to meet exactly the TI that will null a tissue with a T1-value of `T1value_toNull`. As with any IR
 module, the minimum duration (`ksinv.seqctrl.min_duration) given by the RF pulse and spoiler is very
 short in comparison to the actual duration (`ksinv.seqctrl.duration) since TI >> min_duration.

 This function reduces the duration significantly by playing the IR module several slices ahead of the
 main sequence slice. This reduces the ksinv sequence module duration by one or more whole units of
 `coreslice_duration`, while still magnetically maintaining the inversion time (TI). The number of slices
 that the inversion module should be played out ahead of the main sequence is stored in
 ksinv.params.nslicesahead. Now, if `approxti_flag = TRUE`, the duration of this ksinv sequence module
 will be set to its minimum (`ksinv.seqctrl.min_duration`), and TI will be approximated to
 a whole number of `coreslice_duration`. This works best for long `T1value_toNull` and reasonably
 short `coreslice_duration` as the percent error in TI will be low. With `approxti_flag = TRUE` the
 scan time will be significantly reduced in general.

 As this function estimates the optimal TR and TI iteratively, AutoTR and AutoTI modes must be used
 when calling this function. Typically T1-FLAIR uses slice-ahead IR, but STIR should also be more
 efficient compared to a simple IR approach. See also ksinv_eval_multislice().

 @param[in,out] ksinv Pointer to KSINV_SEQUENCE sequence module to set up
 @param[out] TR Pointer to the repetition time (TR) resulting from the interative search in [us]
 @param[out] TI Pointer to the inversion time (TI) resulting from the interative search in [us]
 @param[in] approxti_flag 0: Make TI exact 1: Make TI approximate (shorter scan time in general)
 @param[in] coreslice_momentstart Time between the end of the inversion module and the moment start
                                  of the main sequence.
 @param[in] coreslice_duration Duration of the 'core slice' (main sequence + other attached sequence modules)
 @param[in] mainseq_mindur Minimum duration of just the main sequence (used by ksinv_eval_nullti())
 @param[in] T1value_toNull T1 value to null in [us]
 @param[in] slperpass Number of slices to play out in one pass (acquisition)
 @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ksinv_eval_duration_t1value(KSINV_SEQUENCE *ksinv, int *TR /* [us] */, int *TI /* [us] */, int approxti_flag /* approx. TI */, int coreslice_momentstart /* [us] */,
                                   int coreslice_duration /* [us] */, int mainseq_mindur, int T1value_toNull /* [us] */, int slperpass) {

  if (ksinv->seqctrl.momentstart <= 0) {
    return ks_error("%s (%s): Moment start position of the inversion sequence (arg 1) must be > 0", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (TR == NULL) {
    return ks_error("%s (%s): TR pointer cannot be NULL", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (TI == NULL) {
    return ks_error("%s (%s): TI pointer cannot be NULL", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (coreslice_momentstart <= 0) {
    return ks_error("%s (%s): The core slice moment start position must be  > 0", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (coreslice_duration <= 0) {
    /* core slice duration is the sequence time (incl. SSI time) for the main sequence and other sequence modules that
    are played just before each main sequence (e.g. ChemSat, GRx Sat, Simple IR etc.) */
    return ks_error("%s (%s): The core slice time (arg 4) [attached seq. modules+ main seq.] must be > 0", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (slperpass < 1) {
    return ks_error("%s (%s): slperpass must be > 0", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (ksinv->params.irmode != KSINV_IR_SIMPLE && ksinv->params.irmode != KSINV_IR_SLICEAHEAD) {
    return ks_error("%s (%s): ksinv.params.irmode must be either KSINV_IR_SIMPLE or KSINV_IR_SLICEAHEAD for this function", __FUNCTION__, ksinv->seqctrl.description);
  }

  int i = 0;
  int iter_max = 50;
  int TItol = 20; /* TI error tolerance in [us] */
  int tempTI;
  int hasconverged = FALSE;
  int reduce_sliceahead = 0;
  int minimumTR_forslices = slperpass * (ksinv->seqctrl.min_duration + coreslice_duration);

  *TR = minimumTR_forslices;
  *TI = ksinv_eval_nullti(*TR, T1value_toNull, mainseq_mindur);

  ksinv->seqctrl.duration = ksinv->seqctrl.min_duration;

  if (approxti_flag == TRUE) {
    /* Optimal TI is approximated using discrete number of slice-aheads with ksinv->seqctrl.duration = ksinv->seqctrl.min_duration */

    /* set .duration = .min_duration (again to be safe) */
    ksinv->seqctrl.duration = ksinv->seqctrl.min_duration;

    /* integer nslicesahead that comes closest to the desired TI */
    ksinv->params.nslicesahead = (int) (((float) (*TI + ksinv->seqctrl.momentstart - ksinv->seqctrl.min_duration - coreslice_momentstart)) / ((float) (coreslice_duration + ksinv->seqctrl.min_duration)) + 0.5);

    /* adjust TI to reflect the approximation */
    *TI = ksinv->params.nslicesahead * (coreslice_duration + ksinv->seqctrl.min_duration) - ksinv->seqctrl.momentstart + ksinv->seqctrl.min_duration + coreslice_momentstart;

    return SUCCESS;
  }


  while (hasconverged == FALSE && ksinv->params.nslicesahead >= 0) {

    while (hasconverged == FALSE && i++ < iter_max) {

      if (ksinv->params.irmode == KSINV_IR_SLICEAHEAD && slperpass > 1) {

        ksinv->params.nslicesahead = (*TI + ksinv->seqctrl.momentstart - ksinv->seqctrl.min_duration - coreslice_momentstart) / (coreslice_duration + ksinv->seqctrl.min_duration) - reduce_sliceahead;

        if (ksinv->params.nslicesahead < 0) {
          ksinv->params.nslicesahead = 0;
        } else if (ksinv->params.nslicesahead > (slperpass - 1)) {
          ksinv->params.nslicesahead = slperpass - 1;
        }
      } else {
        ksinv->params.nslicesahead = 0;
      }

      /* duration of inversion module */
      ksinv->seqctrl.duration = RUP_GRD((*TI + ksinv->seqctrl.momentstart - coreslice_momentstart - ksinv->params.nslicesahead * coreslice_duration) / (ksinv->params.nslicesahead + 1));

      /* prevent too small durations */
      if (ksinv->seqctrl.min_duration > ksinv->seqctrl.duration) {
        ksinv->seqctrl.duration = ksinv->seqctrl.min_duration;
      }

      /* Update TR and TI after IR duration update */
      *TR = slperpass * (ksinv->seqctrl.duration + coreslice_duration);
      tempTI = ksinv_eval_nullti(*TR, T1value_toNull, mainseq_mindur);

      hasconverged = abs(tempTI - *TI) < TItol;

      *TI = tempTI;

    } /* inner while */

    reduce_sliceahead++;
    i = 0;

  } /* outer while */


  /* watchdogs */
  if (i >= iter_max) {
    return ks_error("%s (%s): No solution. Increase ETL or #slices", __FUNCTION__, ksinv1.seqctrl.description);
  }
  if (*TI == 0) {
    return ks_error("%s (%s): TI became zero", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (*TR < minimumTR_forslices) {
    return ks_error("%s (%s): TR became too short to fit the number of slices", __FUNCTION__, ksinv->seqctrl.description);
  }
  if (ksinv->seqctrl.min_duration > ksinv->seqctrl.duration) {
    return ks_error("%s: Input args resulted in a a too short inv. seq. duration", __FUNCTION__);
  }

  return SUCCESS;

} /* ksinv_eval_duration_t1value() */





/**
 *******************************************************************************************************
 @brief #### Sets the sequence module duration of a KSINV_SEQUENCE for a FLAIR block design

 This function sets the duration for an KSINV_SEQUENCE module in a FLAIR block design,
 where `ksinv.params.nflairslices` number of inversion pulses are played first (at different slice
 locations) followed by equally many 'core slice' playouts (main sequence + optional other sequence
 modules attached to the main sequence).

 The maximum number of FLAIR slices is capped by `slperpass`, which is the maximum number of slices to
 fit in one TR. As each inversion module must be as long as the `coreslice_duration` in a FLAIR block
 design, the integer number of flair slices (`ksinv.params.nflairslices`) rarely fit exactly in the
 desired TI time, why the duration of the inversion modules are increased to exactly fit this available
 time. This means that after calling this function, one must make sure that the duration of the main
 sequence is also increased accordingly. This is done in ksinv_eval_multislice().

 @param[in,out] ksinv Pointer to KSINV_SEQUENCE sequence module to set up
 @param[in] TI The inversion time (TI) resulting from the interative search in [us]
 @param[in] coreslice_momentstart Time between the end of closest inversion module and the moment start
                                  of the main sequence.
 @param[in] coreslice_duration Duration of the coreslice (main sequence + other attached sequence modules)
 @param[in] slperpass Number of slices to play out in one pass (acquisition)
 @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ksinv_eval_duration_flairblock(KSINV_SEQUENCE *ksinv, int TI, int coreslice_momentstart, int coreslice_duration, int slperpass) {
  int avail_flairseqtime;

  if (TI <= 0) {
    return ks_error("%s: TI must be > 0", __FUNCTION__);
  }
  if (coreslice_momentstart <= 0) {
    return ks_error("%s: The core slice moment start position must be > 0", __FUNCTION__);
  }
  if (coreslice_duration <= 0) {
    /* core slice duration is the sequence time (incl. SSI time) for the main sequence and other sequence modules that
    are played just before each main sequence (e.g. ChemSat, GRx Sat, Simple IR etc.) */
    return ks_error("%s: The core slice time (arg 3) [attached seq. modules+ main seq.] must be > 0", __FUNCTION__);
  }
  if (ksinv->seqctrl.min_duration > coreslice_duration) {
    return ks_error("%s: Minimum FLAIR slice duration must be less than the core slice time", __FUNCTION__);
  }
  if (TI < ksinv->seqctrl.min_duration - ksinv->seqctrl.momentstart + coreslice_momentstart) {
    return ks_error("%s: TI too short to fit one inversion slice", __FUNCTION__);
  }

  if (ksinv->params.irmode != KSINV_FLAIR_BLOCK && ksinv->params.irmode != KSINV_FLAIR_T2PREP_BLOCK) {
    return ks_error("%s: ksinv.params.irmode must be KSINV_FLAIR_BLOCK or KSINV_FLAIR_T2PREP_BLOCK for this function", __FUNCTION__);
  }
  if (slperpass < 1) {
    return ks_error("%s: #slices per pass (5th arg) must be at least 1", __FUNCTION__);
  }

  ksinv->params.nslicesahead = 0;

  avail_flairseqtime = TI - coreslice_momentstart + ksinv->seqctrl.momentstart;

  /* how many slices that can be fitted within 'opti' */
  ksinv->params.nflairslices = avail_flairseqtime / coreslice_duration;

  if (ksinv->params.nflairslices == 0) {
  /* round-up (fall back to simple IR style). We have already checked that TI is long enough to fit one IR playout */
    ksinv->params.nflairslices = 1;
  }

  /* don't exceed the total number of slices per pass */
  if (ksinv->params.nflairslices > slperpass) {
    ksinv->params.nflairslices = slperpass;
  }

  ksinv->params.nflairslices -= ksinv->params.nflairslices % ksinv->selrfinv.sms_info.mb_factor;

  /* increase the duration to fill up to 'avail_flairseqtime'
  N.B: The calling function must also increase the duration of its main sequence to fill up corresponding 'avail_flairseqtime' in the core slice block */
  ksinv->seqctrl.duration = RUP_GRD(avail_flairseqtime / ksinv->params.nflairslices);

  if (ksinv->seqctrl.duration < coreslice_duration && ksinv->params.nflairslices > 1) {
    return ks_error("%s: FLAIR slice duration became shorter than coreslice duration", __FUNCTION__);
  }

  return SUCCESS;

} /* ksinv_eval_duration_flairblock() */




/**
 *******************************************************************************************************
 @brief #### Sets the duration of a wait sequence (filltr) between FLAIR-blocks to meet manual TR

 In ksinv_eval_duration_flairblock(), `ksinv.params.nflairslices` number of inversion pulses are played
 out before equally many main sequence playouts. This time corresponds to:
 `2 * ksinv.params.nflairslices * coreslice_duration`

 If TR is set manually (AutoTR off), this filltr wait sequence module is set to fill up the time to the
 desired TR. When ksinv.params.nflairslices <= number of slices per pass, two or more FLAIR-blocks will
 be played out in ksinv_scan_sliceloop(), where each block will end with this wait sequence. Therefore,
 the duration of this wait sequence will be reduced in time if used more than once in each slice loop,
 to keep the same total wait duration given by:
 `filltr duration = TR - N * (2 * ksinv.params.nflairslices * coreslice_duration`, where N is an integer
 >= 1.

 If the duration is zero, the description will be ignored and set to "fillTR_disabled".

 @param[in,out] filltr Pointer to the KS_SEQ_CONTROL for the fillTR wait sequence
 @param[in] desc Description of the wait sequence
 @param[in] duration Duration of the wait sequence
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_setfilltr(KS_SEQ_CONTROL *filltr, const char * const desc, int duration) {

  strcpy(filltr->description, desc);

  if (duration > 0) {
    strcpy(filltr->description, desc);
    filltr->ssi_time = ksinv_filltr_ssi_time;
    filltr->min_duration = RUP_GRD(ksinv_filltr.ssi_time);
    filltr->duration = RUP_GRD(duration);

    if (filltr->duration < filltr->min_duration || filltr->duration < filltr->ssi_time) {
      return ks_error("%s: filltr.duration must be >= .min_duration and .ssi_time", __FUNCTION__);
    }

  } else {
    ks_init_seqcontrol(filltr);
    filltr->ssi_time = ksinv_filltr_ssi_time;
    strcpy(filltr->description, "fillTR_disabled");
  }

  return SUCCESS;

} /* ksinv_eval_setfilltr() */




/**
 *******************************************************************************************************
 @brief #### Initializes inversion related UI

 Pre-DV26:
 - T2FLAIR set by: opflair == OPFLAIR_GROUP
 - T1FLAIR set by: opflair == OPFLAIR_INTERLEAVED

 DV26+:
 UI buttons have been moved from column 2 (under FastSpinEcho/SSFSE) to column 3 (imaging options)
 - T2FLAIR set by: opt2flair == TRUE
 - T1FLAIR set by: opt1flair == TRUE

 To be compatible with previous releases, this function sets the legacy opflair CV to the correct value,
 so that (for now) sequences using KSInversion.e can continue to use opflair despite the DV26 UI change.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_init_UI() {

#if EPIC_RELEASE >= 26

  set_incompatible(PSD_IOPT_T1FLAIR, PSD_IOPT_T2FLAIR); 

  if (opt1flair == TRUE && opt2flair == TRUE) {
    return ks_error("%s: Selection of T1FLAIR and T2FLAIR is not allowed", __FUNCTION__);
  } else if (opt1flair == TRUE && opt2flair == FALSE) {
    cvoverride(opflair, OPFLAIR_INTERLEAVED, PSD_FIX_ON, PSD_EXIST_ON);
  } else if (opt2flair == TRUE && opt1flair == FALSE) {
    cvoverride(opflair, OPFLAIR_GROUP, PSD_FIX_ON, PSD_EXIST_ON);
  } else {
    cvoverride(opflair, FALSE, PSD_FIX_ON, PSD_EXIST_ON);
  }
  
#endif

  return SUCCESS;
}


/**
 *******************************************************************************************************
 @brief #### Gets the current UI and checks for valid inputs related to the inversion module(s)

 The inversion mode(s) is initially dependent on the UI selections: T2-FLAIR, T1-FLAIR, IR-prep.
 Only 2D+Fast-SpinEcho enables the T2-FLAIR and T1-FLAIR buttons, but 2D+EchoPlanar enables a
 FLAIR-EPI button, which is the same thing as T2-FLAIR.

 If the T2-FLAIR button is selected, `opflair = OPFLAIR_GROUP`, resulting in a FLAIR-block design
 (`ksinv1.params.mode = KSINV_FLAIR_BLOCK`).

 If the T1-FLAIR button is selected, `opflair = OPFLAIR_INTERLEAVED`, resulting in a slice-ahead inversion
 mode (`ksinv1.params.mode = KSINV_IR_SLICEAHEAD`).

 In T2-FLAIR and T1-FLAIR modes, only the first of the four UserCVs reserved by KSINV_EVAL() is shown.

 For custom IR control, using simple IR or dual IR (in simple or sliceahead modes), opflair should be
 0 and opirprep should be 1. For FSE (ksfse.e), this advanced mode is set by selecting
 FSE-IR. For EPI (ksepi.e), this mode is set by selecting SE-EPI, GE-EPI or DW-EPI and then
 selecting IRprep.

 This function is used to set up inversion for 2D sequences and is not suited for future 3D psd support.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_UI() {


  cvmin(opti, 0);
  cvmax(opti, 20s);
  cvmax(optr, 240s); /* 4 mins */


  if (oppseq != PSD_IR /* 3 */ && opirprep == FALSE && opflair == FALSE) {
    /* no IR selection, disable everything IR related */
    piuset &= ~(use_ir1_mode + use_ir1_t1 + use_ir2_mode + use_ir2_t1);
    *ksinv1_mode = 0; _ksinv1_mode->existflag = TRUE; _ksinv1_mode->fixedflag = TRUE;
    *ksinv2_mode = 0; _ksinv2_mode->existflag = TRUE; _ksinv2_mode->fixedflag = TRUE;
    pitinub = 0;
    return SUCCESS;
  } else {
    /* GE's ARC recon does not seem to like the combined use of
      a) inversion
      b) interleaved spacing (opileave)

      We can avoid this at the PSD selection stage by not allowing ARC
      at all (disable_ioption) with any kind of inversion. This prevents however also ARC inversion
      w/o interleaved spacing. A second level of defense is to allow ARC for inversion, but to check
      whether interleaved spacing is on and if R > 1 (opaccel_ph_stride), but also checking if autolock
      is off. If autolock is on, one assumes that the user wants to reconstruct the data from Pfiles,
      which works without problems with ARC, inversion and interleaved spacing.

      First defense at PSD selection: Inversion is enabled => disable ARC option. Comment this out
      to allow ARC but instead be trapped by the second defense */
    disable_ioption(PSD_IOPT_ARC);

    /* Second defense against ARC, interleaved spacing and inversion, if rawdata is not saved */
    if ((opileave == TRUE) && (oparc == TRUE) && (opaccel_ph_stride > 1.0) && (autolock == FALSE)) {
      return ks_error("%s: Use ASSET for Inversion & Intleave Spacing", __FUNCTION__);
    }

  }


  if (opflair == OPFLAIR_GROUP || opflair == OPFLAIR_INTERLEAVED) {

    /* T2-FLAIR or T1-FLAIR */
    if (cffield == 30000) {
      _ksinv1_t1value->defval = T1_CSF_3T;
      _ksinv2_t1value->defval = T1_WM_3T;
    } else {
      _ksinv1_t1value->defval = T1_CSF_1_5T;
      _ksinv2_t1value->defval = T1_WM_1_5T;
    }
  } else {
    /* maybe STIR */
    if (cffield == 30000) {
      _ksinv1_t1value->defval = T1_FAT_3T;
    } else {
      _ksinv1_t1value->defval = T1_FAT_1_5T;
    }
    _ksinv2_t1value->defval = 50; /* ms */
  }

  /* presets for T1-FLAIR and T2-FLAIR */
  if (opflair == OPFLAIR_GROUP) {
    /* T2-FLAIR */
    pitival2 = 3000ms;
    pitival3 = 0; /* should never show */
    pitival4 = 0;
    pitival5 = 0;
    pitival6 = 0;
    if (_optr.defval < ksinv_mintr_t2flair) {
      _optr.defval = ksinv_mintr_t2flair;
    }
    if (ksinv_t2prep == 1) {
      _ksinv1_mode->defval = KSINV_FLAIR_T2PREP_BLOCK;
    } else {
      _ksinv1_mode->defval = KSINV_FLAIR_BLOCK;
    }

  } else if (opflair == OPFLAIR_INTERLEAVED) {
    /* T1-FLAIR (must use autoTI) */
    pitival2 = 700ms;
    pitival3 = 0; /* should never show */
    pitival4 = 0;
    pitival5 = 0;
    pitival6 = 0;
    _ksinv1_mode->defval = KSINV_IR_SLICEAHEAD;
  } else {
    pitival2 = 150ms;
    pitival3 = 200ms;
    pitival4 = 250ms;
    pitival5 = 300ms;
    pitival6 = 350ms;
    _ksinv1_mode->defval = KSINV_IR_SIMPLE;
  }

  /*** begin: opusers ***/

  /* [opuser] IR #1 mode */
  _ksinv1_mode->minval = KSINV_OFF;
  _ksinv1_mode->maxval = KSINV_FLAIR_T2PREP_BLOCK;
  _cvdesc(_ksinv1_mode, "IR1 [0:Off 1:IR 2:SA-IR 3:FLAIR]");
  if (_ksinv1_mode->existflag == FALSE) {
    *ksinv1_mode = _ksinv1_mode->defval;
  }

  /* [opuser] IR #2 mode */
  _ksinv2_mode->minval = KSINV_OFF;
  _ksinv2_mode->maxval = KSINV_IR_SLICEAHEAD;
  _ksinv2_mode->defval = KSINV_OFF;
  _cvdesc(_ksinv2_mode, "IR2 [0:Off 1:IR 2:SA-IR]");
  if (_ksinv2_mode->existflag == FALSE) {
    *ksinv2_mode = _ksinv2_mode->defval;
  }

  /* [opuser] IR #1. T1 value to NULL in [ms] (N.B.: not TI, but T1!) */
  _ksinv1_t1value->minval = 0;
  _ksinv1_t1value->maxval = 10000;
  {
    char tmpstr[100];
    if (cffield == 30000) {
      sprintf(tmpstr, "    IR1 - T1 to null           [CSF:%d GM:%d WM:%d Fat:%d]", T1_CSF_3T, T1_GM_3T, T1_WM_3T, T1_FAT_3T);
    } else if (cffield == 15000) {
      sprintf(tmpstr, "    IR1 - T1 to null           [CSF:%d GM:%d WM:%d Fat:%d]", T1_CSF_1_5T, T1_GM_1_5T, T1_WM_1_5T, T1_FAT_1_5T);
    }
    _cvdesc(_ksinv1_t1value, tmpstr);
  }
  if (_ksinv1_t1value->existflag == FALSE) {
    *ksinv1_t1value = _ksinv1_t1value->defval;
  }

  /* [opuser] IR #2. T1 value to NULL in [ms] (N.B.: not TI, but T1!) */
  _ksinv2_t1value->minval = 0;
  _ksinv2_t1value->maxval = 10000;
  _cvdesc(_ksinv2_t1value, "IR2 - T1 to null");
  if (_ksinv2_t1value->existflag == FALSE) {
    *ksinv2_t1value = _ksinv2_t1value->defval;
  }

  /* turn on all these opuser CVs */
  piuset |= use_ir1_mode + use_ir1_t1 + use_ir2_mode + use_ir2_t1;

  if (((int) *ksinv1_mode) == KSINV_OFF) {
    /* if we are not doing inversion, hide the TI menu and other opusers and set opti = 0 */
    piuset &= ~(use_ir1_t1 + use_ir2_mode + use_ir2_t1);
    ksinv1_ti = 0;
    ksinv2_ti = 0;
    pitinub = 0;
    _ksinv1_mode->existflag = FALSE;
    _ksinv2_mode->existflag = FALSE;
  } else {
    /* Default: allow AutoTI and 5+1 rows in TI menu */
    piautoti = 1;
    pitinub = 6;
  }

  /* Set AutoTR and AutoTI */
  opautotr = TRUE;
  opautoti = TRUE;

  if (((int) *ksinv1_mode) == KSINV_IR_SLICEAHEAD) {
    pitrnub = 0; /* '2': only one menu choice (Minimum = AutoTR). '0': shown but greyed out (if also opautotr = 1) */
    pitinub = -1; /* '2': only one menu choice (AutoTI). '-1': shown but greyed out */
  }

  if (opflair == OPFLAIR_GROUP || opflair == OPFLAIR_INTERLEAVED) {
    /* T2-FLAIR or T1-FLAIR. Branded options, narrow options down */

    /* remove 0 mm gap from slice spacing menu */
    piisil = PSD_ON;
    float minspacing = exist(opslthick) / 2.0;
    piisnub = 5;
    piisval2 = minspacing;
    piisval3 = minspacing + 1;
    piisval4 = minspacing + 2;
    piisval5 = minspacing + 3;
    piisval6 = minspacing + 4;

    cvdef(opslspace, minspacing);
    opslspace = _opslspace.defval;

    if (opflair == OPFLAIR_INTERLEAVED) {
      pitrnub = 0;
      pitinub = -1;
      cvoverride(opautotr, PSD_ON, PSD_FIX_OFF, PSD_EXIST_ON);
    } else {
      pitrnub = 2; /* '2': only one menu choice (Minimum = AutoTR). '0': shown but greyed out (if also opautotr = 1) */
      pitinub = 2; /* '2': only one menu choice (AutoTI). '-1': shown but greyed out */
    }    

    /* disable 2nd IR for T1/T2-FLAIR */
    _ksinv2_mode->existflag = FALSE;
    *ksinv2_mode = 0;
    ksinv2_ti = 0;
    piuset &= ~(use_ir1_mode + use_ir2_mode + use_ir2_t1);
  }

  /* if not AutoTI, set internal TI variable to selected TI (opti) and hide T1value opuser */
  if (opautoti == FALSE) {
    piuset &= ~use_ir1_t1;
    ksinv1_ti = exist(opti);
  }

  if (((int) *ksinv2_mode) == KSINV_OFF) {
    piuset &= ~use_ir2_t1;
    ksinv2_ti = 0;
  }


  return SUCCESS;

} /* ksinv_eval_UI() */




/* To avoid macro length limitations, KSINV_EVAL() had to be split up into three
   smaller macros: KSINV_PIUSE, KSINV_OPUSER_VALS, KSINV_OPUSER_STRUCTS */
#define KSINV_PIUSE(o1, o2, o3, o4)\
({\
 use_ir1_mode = use ## o1;\
 use_ir1_t1 = use ## o2;\
 use_ir2_mode = use ## o3;\
 use_ir2_t1 = use ## o4;\
})

#define KSINV_OPUSER_VALS(o1, o2, o3, o4)\
({\
 ksinv1_mode = &opuser ## o1;\
 ksinv1_t1value = &opuser ## o2;\
 ksinv2_mode = &opuser ## o3;\
 ksinv2_t1value = &opuser ## o4;\
})

#define KSINV_OPUSER_STRUCTS(o1, o2, o3, o4)\
({\
 _ksinv1_mode = &_opuser ## o1;\
 _ksinv1_t1value = &_opuser ## o2;\
 _ksinv2_mode = &_opuser ## o3;\
 _ksinv2_t1value = &_opuser ## o4;\
})


/**
 *******************************************************************************************************
 @brief #### C-macro assigning four UserCV slots and then calling ksinv_eval()
 @param[in,out] sptr Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] o1 A number (not a variable) between 0 and 35 corresponding to the first UserCV used
 @param[in] o2 A number (not a variable) between 0 and 35 corresponding to the second UserCV used
 @param[in] o3 A number (not a variable) between 0 and 35 corresponding to the third UserCV used
 @param[in] o4 A number (not a variable) between 0 and 35 corresponding to the fourth UserCV used
********************************************************************************************************/
#define KSINV_EVAL(sptr, o1, o2, o3, o4)\
({\
  KSINV_PIUSE(o1, o2, o3, o4);\
  KSINV_OPUSER_VALS(o1, o2, o3, o4);\
  KSINV_OPUSER_STRUCTS(o1, o2, o3, o4);\
  ksinv_eval(sptr, NULL);\
})





#define KSINV_EVAL_CUSTOMRF(sptr, rfptr, o1, o2, o3, o4)\
({\
  KSINV_PIUSE(o1, o2, o3, o4);\
  KSINV_OPUSER_VALS(o1, o2, o3, o4);\
  KSINV_OPUSER_STRUCTS(o1, o2, o3, o4);\
  ksinv_eval(sptr, rfptr);\
})




/**
 *******************************************************************************************************
 @brief <h4> Gets the IR-related UI parameters, creates sequence objects and min_duration for the
             inversion module(s), and adds these modules to KS_SEQ_COLLECTION. </h4>
 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in,out] custom_selrf Optional pointer to KS_SELRF for custom inversion RF pulse. Pass NULL to use
                         default RF pulses.
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval(KS_SEQ_COLLECTION *seqcollection, KS_SELRF *custom_selrf) {
  STATUS status;

  ksinv_init_sequence(&ksinv1);/* 1st IR */
  ksinv_init_sequence(&ksinv2);/* 2nd IR */
  ks_init_seqcontrol(&ksinv_filltr); /* init fillTR for FLAIR-block */

  status = ksinv_eval_UI();
  if (status != SUCCESS) return status;

  if (((int) *ksinv1_mode) == KSINV_OFF) {
    /* If no IR1 flag on, return quietly */
    return SUCCESS;
  }

  /* Set inversion slice thickness. N.B.: 'avmaxacqs' = number of acqs shown in the UI (a.k.a. acqs = npasses) */
  if (existcv(opslthick) && (opslthick > 0)) {
    int intleavefact = IMax(2, 1, avmaxacqs);
    float slthickfact = intleavefact * (opslthick + opslspace) / opslthick;
    ksinv_slthickfact = (slthickfact <= KSINV_MAXTHICKFACT) ? slthickfact : KSINV_MAXTHICKFACT;
    ksinv_slthickfact_exc = ksinv_slthickfact;
  }
  if (existcv(optr) && existcv(opslquant) && existcv(opslspace) && opflair && (avmaxacqs <= 1) && (opssfse == FALSE) && (opslspace <= 0) && (opileave == 0)) {
    /* for single acquisition T1-FLAIR or T2-FLAIR, prevent too little spacing between slices it not interleaved
    spacing, but only once the user has set number of slices, TR, and slice gap (so we don't complain too early) */
    return ks_error("%s: Use slice gap or Intleave", __FUNCTION__);
  }


  /* single or 1st IR */
  ksinv_eval_copycvs(&ksinv1.params, (int) *ksinv1_mode);

  status = ksinv_eval_setupobjects(&ksinv1, "1", custom_selrf);
  if (status != SUCCESS) return status;

  status = ksinv_pg(&ksinv1);
  if (status != SUCCESS) return status;

  status = ks_eval_addtoseqcollection(seqcollection, &ksinv1.seqctrl);
  if (status != SUCCESS) return status;

  /* FillTR sequence for KSINV_FLAIR_BLOCK. This is added after all slices have been played out each TR instead
  of increasing the duration of the main pulse sequence to fullfill TR */
  status = ksinv_eval_setfilltr(&ksinv_filltr, "fillTR", 0); /* initialize to zero */
  if (status != SUCCESS) return status;


  if (((int) *ksinv2_mode) != KSINV_OFF) {

    ksinv_eval_copycvs(&ksinv2.params, (int) *ksinv2_mode);

    status = ksinv_eval_setupobjects(&ksinv2, "2", custom_selrf);
    if (status != SUCCESS) return status;

    status = ksinv_pg(&ksinv2);
    if (status != SUCCESS) return status;

    status = ks_eval_addtoseqcollection(seqcollection, &ksinv2.seqctrl);
    if (status != SUCCESS) return status;

  }

  return status;

} /* ksinv_eval() */





/**
 *******************************************************************************************************
 @brief #### Calculates the minimum TR allowed for the ksinv_scan_sliceloop()

 Given the current durations of the sequence modules involved in the ksinv_scan_sliceloop(), this
 function calculates the minimum TR, accounting also for SAR and hardware limits.

 This function expects a pointer to a scan function playing out one `coreslice`. The `coreslice` should
 play out the main sequence once (i.e. one slice), but the coreslice function may also play optional
 other sequence modules that should always be played together with the main sequence (e.g. fatsat).

 As the number of arguments to the sequence's coreslice is psd-dependent, the function pointer
 `play_coreslice` must be a wrapper function to the coreslice function taking standardized input arguments
 `(int) core_nargs` and `(void **) core_args`. This coreslice wrapper function must be on the form:
 `int coreslice_nargs(SCAN_INFO *, int storeslice, int core_nargs, void **core_args);`
 If the coreslice function does not need any additional input arguments, `core_nargs = 0`, and `core_args = NULL`.

 With this function pointer, ksinv_scan_sliceloop() can replace the sequence (non-inversion) sliceloop function,
 and play out the inversion module(s) and the sequence module(s) in the coreslice function.

 After resetting the `seqctrl.nseqinstances` for all sequence modules in the sequence collection,
 ksinv_scan_sliceloop() is called once to increment `seqctrl.nseqinstances` by 1 for every time each
 sequence modules is played out. With this updated information, `seqcollection` is passed to
 ks_eval_gradrflimits(), which will calculate the total duration and add additional time for SAR/hardware
 limits. This time is the return value of ksinv_eval_mintr().

 @param[in] slice_plan Pointer to the KS_SLICE_PLAN struct holding the slice order information
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] gheatfact Value in range [0,1] denoting how much the gradient heating limits should be honored (0:none, 1:full)
 @param[in] ksinv1    Pointer to KSINV_SEQUENCE corresponding to the 1st (or only) inversion. Cannot be NULL
 @param[in] ksinv2    Pointer to KSINV_SEQUENCE corresponding to an optional 2nd inversion. May be NULL
 @param[in] ksinv_filltr    Pointer to KS_SEQ_CONTROL for fillTR sequence for FLAIR block modes. May be NULL
 @param[in] play_coreslice Function pointer to (the wrapper function to) the coreslice function of the sequence
 @param[in] core_nargs Number of extra input arguments to the coreslice wrapper function.
 @param[in] core_args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's coreslice function
 @retval minTR Minimum TR for ksinv_scan_sliceloop() honoring SAR and hardware limits
********************************************************************************************************/
int ksinv_eval_mintr(const KS_SLICE_PLAN *slice_plan, KS_SEQ_COLLECTION *seqcollection, float gheatfact, KSINV_SEQUENCE *ksinv1, KSINV_SEQUENCE *ksinv2, KS_SEQ_CONTROL *ksinv_filltr,
                     int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args) {

  /* must be run before each call to function pointer `play_coreslice()` to set all `seqctrl.nseqinstances` to 0 */
  ks_eval_seqcollection_resetninst(seqcollection);

  ksinv_scan_sliceloop(slice_plan, ks_scan_info, 0, ksinv1, ksinv2, ksinv_filltr, FALSE, play_coreslice, core_nargs, core_args); /* get sequence instance counts */

  return ks_eval_gradrflimits(NULL, seqcollection, gheatfact); /* minTR within limits given the number of sequence instances, durations and RF/grad content */

} /* ksinv_eval_mintr() */




/**
 *******************************************************************************************************
 @brief #### Calculates the maximum slices per TR using ksinv_scan_sliceloop()

 @param[in] TR Repetition time in [us]
 @param[in] temp_slice_plan Pointer to the KS_SLICE_PLAN struct holding the slice order information
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] gheatfact Value in range [0,1] denoting how much the gradient heating limits should be honored (0:none, 1:full)
 @param[in] ksinv1    Pointer to KSINV_SEQUENCE corresponding to the 1st (or only) inversion. Cannot be NULL
 @param[in] ksinv2    Pointer to KSINV_SEQUENCE corresponding to an optional 2nd inversion. May be NULL
 @param[in] ksinv_filltr    Pointer to KS_SEQ_CONTROL for fillTR sequence for FLAIR block modes. May be NULL
 @param[in] play_coreslice Function pointer to (the wrapper function to) the coreslice function of the sequence
 @param[in] core_nargs Number of extra input arguments to the coreslice wrapper function.
 @param[in] core_args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's coreslice function
 @retval MaxSlicesPerTR Maximum slices that can fit in the specified TR, honoring SAR and hardware limits
********************************************************************************************************/
int ksinv_eval_maxslicespertr(int TR, KS_SLICE_PLAN temp_slice_plan, KS_SEQ_COLLECTION *seqcollection, float gheatfact, 
                              KSINV_SEQUENCE *ksinv1, KSINV_SEQUENCE *ksinv2, KS_SEQ_CONTROL *ksinv_filltr,
                              int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args) {
  int max_slquant1 = 0;
  int i, invslicelooptime;
  for (i = 1; i < 1024; i++) {

    temp_slice_plan.nslices_per_pass = i; /* hack the slice plan with 'i' #slices to see when invslicelooptime becomes larger than TR */

    invslicelooptime = ksinv_eval_mintr(&temp_slice_plan, seqcollection, gheatfact, ksinv1, ksinv2, ksinv_filltr, play_coreslice, core_nargs, core_args);

    if (invslicelooptime == KS_NOTSET) {
      return KS_NOTSET;
    }
    if (invslicelooptime > TR) {
      return max_slquant1;
    }
    max_slquant1 = i;
  }

  return max_slquant1;

} /* ksinv_eval_maxslicespertr() */




/**
 *******************************************************************************************************
 @brief #### FLAIR block calculations

 @param[in,out] ksinv Pointer to KSINV_SEQUENCE. ksinv.params.irmode must be KSINV_FLAIR_BLOCK and ksinv.seqctrl.min_duration and ksinv.seqctrl.momentstart both > 0.
 @param[out] filltr_time The time that needs to be added after all slices played out to fill up to the manual TR
 @param[in,out] repetition_time Pointer to the repetition time [us]. If autotr_flag = TRUE, this value will be set and returned as TR to the calling function. If autotr_flag = FALSE, 'repetition_time' will be used as TR here
 @param[in,out] inversion_time Pointer to the inversion time [us]. If 'T1tonull' > 0, this value will be set and returned as TI to the calling function. If 'T1tonull' = 0, 'inversion_time' will be used as TI here
 @param[in] autotr_flag TRUE/FALSE flag for autoTR. If TRUE, 'repetition_time' will be updated
 @param[in] T1tonull T1-value to null. 0: Off (value of 'inversion_time' is used. >0: Use this T1-value to calculate the TI value and update and return 'inversion_time'
 @param[in] coreslice_momentstart Time between the end of closest inversion module and the moment start of the main sequence.
 @param[in] coreslice_duration Duration of the coreslice (main sequence + other attached sequence modules)
 @param[in] slperpass Number of slices to play out in one pass (acquisition)

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_flairblock(KSINV_SEQUENCE *ksinv, int *filltr_time, int *repetition_time, int *inversion_time, int autotr_flag, int T1tonull, int coreslice_momentstart, int coreslice_duration, int slperpass) {
  int i = 0;
  int iter_max = 20;
  int TRtol = 20; /* TR error tolerance in [us] */
  int hasconverged = FALSE;
  int cap_nflairslices = FALSE;
  int lowest_nflairslices = slperpass;
  int minTR, TR, TI;
  int nflairblocks;
  int lastTR = 0;
  int flair_duration;
  int timetoadd_perTR;
  STATUS status;

  if (filltr_time == NULL || repetition_time == NULL || inversion_time == NULL) {
    return ks_error("%s: 2nd-4th args must be non-NULL int pointers", __FUNCTION__);
  }
  if (autotr_flag != 0 && autotr_flag != 1) {
    return ks_error("%s: autotr flag must be 0 (false) or 1 (true)", __FUNCTION__);
  }

  if (autotr_flag) {
    /* AutoTR */
    TR = 20s; /* starting guess */
  } else {
    TR = *repetition_time;
  }


  do {

    if (T1tonull > 0) {
      /* AutoTI: set TI based on T1tonull and current TR (AutoTR) or fixed TR */
      TI = ksinv_eval_nullti(TR, T1tonull, coreslice_duration);
    } else {
      TI = *inversion_time;
    }

    /* duration of each inversion module in the FLAIR block. This function sets the field ksinv.params.nflairslices */
    status = ksinv_eval_duration_flairblock(ksinv, TI, coreslice_momentstart, coreslice_duration, (cap_nflairslices == TRUE) ? lowest_nflairslices : slperpass);
    if (status != SUCCESS) return status;

    /* minimum TR (ignoring grad/RF heating and SAR) */
    nflairblocks = CEIL_DIV(slperpass, ksinv->params.nflairslices); /* number of FLAIR blocks */

    flair_duration = (nflairblocks * ksinv->params.nflairslices + slperpass) * ksinv->seqctrl.duration;

    /* keep minTR above ksinv_mintr_t2flair */
    minTR = IMax(2, flair_duration, ksinv_mintr_t2flair);

    if (autotr_flag == TRUE) {
      TR = minTR;
    }

    /* wait sequence after each set (group) of FLAIR + core slices to fill up TR. C.f. ksinv_scan_sliceloop() */
    timetoadd_perTR = IMax(2, TR, ksinv_mintr_t2flair) - flair_duration;
    *filltr_time = RUP_GRD(timetoadd_perTR / nflairblocks);

    if (autotr_flag == TRUE) {

      /* converge check and lastTR update */
      hasconverged = abs(lastTR - minTR) < TRtol;
      lastTR = minTR;

      if (ksinv->params.nflairslices < lowest_nflairslices && cap_nflairslices == FALSE) {
        /* In the event that the number of FLAIR slices toggles between two (or more) values, this iteration process may not converge.
           We monitor the lowest nflairslices that occur during the first iteration round (lowest_nflairslices). If we reach iter_max, use lowest_nflairslices
           instead of slperass as last arg to ksinv_eval_duration_flairblock() to force nflairslices to this value, and re-iterate.
           If still no convergence, lowest_nflairslices is reduced by 1 */
        lowest_nflairslices = ksinv->params.nflairslices;
      }
      if (++i == iter_max) {
        /* Things to do when we have reached #iterations */
        if (lowest_nflairslices > 1) {
          i = 0; /* reset iteration counter */
          if (cap_nflairslices == FALSE) {
            /* try iterating a second time, now with the lowest number of nflairslices used in the iterations (lowest_nflairslices) */
            cap_nflairslices = TRUE;
          } else {
            /* try iterating again after the second time, now with lowest_nflairslices reduced by 1 */
            lowest_nflairslices--;
          }
        } else {
          return ks_error("%s: FLAIR-block - Combination of TI & TR not found after %d iterations", __FUNCTION__, iter_max);
        }
      }

    } /* autotr_flag */

  } while ((autotr_flag == TRUE) && (hasconverged == FALSE)); /* only iterate for AutoTR */


  if (TR < ksinv_mintr_t2flair) {
     return ks_error("%s: TR must be increased to %d ms", __FUNCTION__, CEIL_DIV(ksinv_mintr_t2flair, 1000));
  }
  
  *inversion_time = TI;
  *repetition_time = TR;

  return SUCCESS;

}



STATUS ksinv_eval_flairblock_withmainupdate(KSINV_SEQUENCE *ksinv, KS_SEQ_CONTROL *ksinv_filltr, KS_SEQ_CONTROL *mainseqctrl, int *repetition_time, int *inversion_time, int autotr_flag, int T1tonull, int coreslice_momentstart, int coreslice_duration, int slperpass) {
  STATUS status;
  int filltr_duration;

  status = ksinv_eval_flairblock(ksinv, &filltr_duration, repetition_time, inversion_time, autotr_flag, T1tonull, coreslice_momentstart, coreslice_duration, slperpass);
  if (status != SUCCESS) return status;

  /* set up fill TR sequence (to be played out CEIL_DIV(slperpass, ksinv->params.nflairslices) times per TR) unless filltr_duration < ssi_time */
  status = ksinv_eval_setfilltr(ksinv_filltr, "fillTR", (filltr_duration > ksinv_filltr_ssi_time) * filltr_duration);
  if (status != SUCCESS) return status;

  /* We must have the same seq duration for ksinv->seqctrl.duration and the coreslice duration, add round-up time due to nflairslices divisibility to the duration of the main sequence. */
  if (ksinv->seqctrl.duration > coreslice_duration) {
    mainseqctrl->duration += RUP_GRD(ksinv->seqctrl.duration - coreslice_duration);
  }

  return SUCCESS;

}





/**
 *******************************************************************************************************
 @brief #### Calculates the duration of inversion module(s) for various inversion modes

 This function is to be used by a 2D psd to set the inversion duration(s) for `ksinv1` and possibly `ksinv2`
 (dual IR). Before calling this function, the `ksinv->params.irmode` (and `ksinv2.params.irmode`) must be set
 to steer which type of inversion that should be performed. Here follows the inversion modes supported by this
 function:

 Single inversion (`ksinv2.params.irmode = KSINV_OFF`):
 1. `ksinv1.params.irmode = KSINV_FLAIR_BLOCK`:
    - Heat handling: None, but will be caught in final SAR check at the end. Unlikely to happen for T2-FLAIR
 2. `ksinv1.params.irmode = KSINV_IR_SIMPLE` and manual TR (`opautotr = FALSE`):
    - Heat handling: Increase mainseqctrl->duration based on timetoadd_perTR
 3. `ksinv1.params.irmode = KSINV_IR_SLICEAHEAD`  *or*  `ksinv1.params.irmode = KSINV_IR_SIMPLE` and (`opautotr = TRUE`)
    - Heat handling: C.f. "Early grad/RF heat calculations" that increases mainseqctrl->duration *before* IR/TR timing calculations

 Dual inversion:
 1. `ksinv1.params.irmode = KSINV_IR_SIMPLE` and `ksinv2.params.irmode = KSINV_IR_SIMPLE`
 2. `ksinv1.params.irmode = KSINV_IR_SLICEAHEAD` and `ksinv2.params.irmode = KSINV_IR_SIMPLE`
 3. `ksinv1.params.irmode = KSINV_FLAIR_BLOCK` and `ksinv2.params.irmode = KSINV_IR_SIMPLE`
 4. `ksinv1.params.irmode = KSINV_IR_SLICEAHEAD` and `ksinv2.params.irmode = KSINV_IR_SLICEAHEAD`. TI1 (opti) will be approximated

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] slice_plan Pointer to the KS_SLICE_PLAN struct holding the slice order information
 @param[in] play_coreslice Function pointer to (the wrapper function to) the coreslice function of the sequence
 @param[in] core_nargs Number of extra input arguments to the coreslice wrapper function.
 @param[in] core_args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's coreslice function
 @param[in] mainseqctrl Pointer to the KS_SEQ_CONTROL struct for the main sequence

 @retval MaxSlicesPerTR Maximum slices that can fit in the specified TR, honoring SAR and hardware limits
********************************************************************************************************/
STATUS ksinv_eval_multislice(KS_SEQ_COLLECTION *seqcollection, KS_SLICE_PLAN *slice_plan, int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args, KS_SEQ_CONTROL *mainseqctrl) {

  STATUS status;
  int coreslice_momentstart;
  int coreslice_duration;
  int minTR = 0;
  int timetoadd_perTR;
  SCAN_INFO dummy_slice_pos = DEFAULT_AXIAL_SCAN_INFO; /* dummy slice info for coreslice */


  /* return early if we don't have at least one inversion */
  if (ksinv1.params.irmode == KSINV_OFF) {
    return SUCCESS;
  }

  /* return early if #slices/TR = 0 */
  if (slice_plan->nslices_per_pass == 0) {
    return SUCCESS;
  }


  if (ksinv1.params.irmode == KSINV_OFF && ksinv2.params.irmode != KSINV_OFF) {
    return ks_error("%s: DualIR: If 2nd IR is on, so must the 1st IR", __FUNCTION__);
  } else if (ksinv1.params.irmode != KSINV_IR_SLICEAHEAD && ksinv2.params.irmode == KSINV_IR_SLICEAHEAD) {
    return ks_error("%s: DualIR: If 2nd IR is sliceahead, so must the 1st IR", __FUNCTION__);
  } else if (ksinv2.params.irmode == KSINV_FLAIR_BLOCK || ksinv2.params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {
    return ks_error("%s: DualIR: 2nd IR cannot be a FLAIR block", __FUNCTION__);
  }

  if (ksinv1.params.irmode != KSINV_IR_SLICEAHEAD && ksinv1.params.approxti == TRUE) {
    return ks_error("%s: 1st IR (ksinv1): approximate TI only applicable to sliceahead IR mode", __FUNCTION__);
  }
  if (ksinv2.params.irmode != KSINV_IR_SLICEAHEAD && ksinv2.params.approxti == TRUE) {
    return ks_error("%s: 2nd IR (ksinv2): approximate TI only applicable to sliceahead IR mode", __FUNCTION__);
  }

  /* ks_eval_seqcollection_durations_atleastminimum() makes sure seqctrl.duration is at least seqctrl.min_duration for all sequence modules */
  status = ks_eval_seqcollection_durations_atleastminimum(seqcollection);
  if (status != SUCCESS) return status;


  if ( (ksinv1.params.irmode == KSINV_IR_SLICEAHEAD) || ((ksinv1.params.irmode == KSINV_IR_SIMPLE) && (opautoti == TRUE) && (opautotr == TRUE)) ) {

    /*******************************************************************************************************
     * Early grad/RF heat calculations
     *******************************************************************************************************/

    /* For KSINV_IR_SLICEAHEAD mode, we need to check for grad/RF heating *first* in a worst case scenario where all sequence
       modules have .duration = .min_duration. The penalty time is added the main sequence duration to be within the limits.
       After this, we can start calculating the IR time(s). This is due to that the KSINV_IR_SLICEAHEAD mode in part uses inversion
       pulses from the previous TR to invert slices in the current TR, why the TR cannot be changed (increased) after these
       calculations due to later heating issues. The same applies to simple IR mode with both AutoTR and AutoTI.
       For these two cases, both TR and TI are consequences of the chosen T1 null value */

    /* at this point, the IR module(s), main sequence, and other sequence modules should have .duration = .min_duration. Check worst case (minimum duration modules) */
    minTR = ksinv_eval_mintr(slice_plan, seqcollection, ks_gheatfact, &ksinv1, &ksinv2, NULL, play_coreslice, core_nargs, core_args);
    if (minTR == KS_NOTSET) return FAILURE;

    
    /* how much TR needs to increase if we have only minimum duration modules */
    timetoadd_perTR = minTR - ksinv_scan_sliceloop(slice_plan, ks_scan_info, 0, &ksinv1, &ksinv2, NULL, FALSE, play_coreslice, core_nargs, core_args);

    /* we spread the available timetoadd_perTR evenly, by increasing .duration of each slice by timetoadd_perTR/slice_plan->nslices_per_pass */
    mainseqctrl->duration += RUP_GRD(CEIL_DIV(timetoadd_perTR, slice_plan->nslices_per_pass));

  }

  /* get coreslice time, i.e. time for one slice. Note that this must come after early grad/RF heat calculation to reflect the increased mainseq duration */
  coreslice_duration = play_coreslice(&dummy_slice_pos, 0, core_nargs, core_args);

  /* momentstart will be = mainseqctrl->momentstart if there is no other sequence module in play_coreslice(). However if the coreslice function contains
  other sequence module they are required to be placed before the main sequence module to assure the inversion time is correctly calculated */
  coreslice_momentstart = coreslice_duration - mainseqctrl->duration + mainseqctrl->momentstart;



  if (ksinv1.params.irmode == KSINV_IR_SLICEAHEAD && ksinv2.params.irmode == KSINV_IR_SLICEAHEAD) {

    /*******************************************************************************************************
     * First and second IR when both are in mode KSINV_IR_SLICEAHEAD
     *******************************************************************************************************/

    /* mainseqctrl->duration already prolonged to meed grad/RF limits if necessary (see above).
       If both inversion pulses modes are KSINV_IR_SLICEAHEAD, the first IR has to get an approximate TI time using an
       (integer) ksinv1.params.nslicesahead and ksinv1.seqctrl.duration = ksinv1.seqctrl.min_duration. When calculating
       the sequence duration for ksinv2, we need to reserve this minimum time (ksinv1.seqctrl.min_duration) between the
       main sequence and ksinv2. Both IR pulses in KSINV_IR_SLICEAHEAD mode is faster, but the TI time for the first one
       will not be exact. For an FSE train of 200 ms, the TI will be rounded off by 200/2 ms at most, but since the 1st
       TI is usually 2500 ms when two IRs are used it may be ok */

    if (opautotr == FALSE || opautoti == FALSE) {
      return ks_error("%s: sliceahead mode requires AutoTI and AutoTR", __FUNCTION__);
    }

    /* 1st IR duration fixed to minimum */
    ksinv1.seqctrl.duration = ksinv1.seqctrl.min_duration;

    /* 2nd IR: get sequence module duration, TR and TI based on T1 null value and coreslice duration (iterative). Approximate TI if ksinv2.approxti = TRUE */
    status = ksinv_eval_duration_t1value(&ksinv2, &minTR, &ksinv2_ti, ksinv2.params.approxti, coreslice_momentstart, coreslice_duration + ksinv1.seqctrl.duration, mainseqctrl->min_duration, (int) (*ksinv2_t1value * 1000.0) /* [ms]->[us] */, slice_plan->nslices_per_pass);
    if (status != SUCCESS) return status;

    /* 1st IR (TI based on T1 to null) */
    ksinv1_ti = ksinv_eval_nullti(minTR, (int) (*ksinv1_t1value * 1000.0) /* [ms]->[us] */, mainseqctrl->min_duration);

    /* 1st IR (always approximate TI, using .duration = .min_duration) */
    ksinv1.params.nslicesahead = (ksinv1_ti + ksinv1.seqctrl.momentstart - coreslice_momentstart - ksinv1.seqctrl.min_duration) / (coreslice_duration + ksinv1.seqctrl.min_duration);
    ksinv1_ti = ksinv1.params.nslicesahead * (coreslice_duration + ksinv1.seqctrl.min_duration) - ksinv1.seqctrl.momentstart + coreslice_momentstart;


  } else if (ksinv2.params.irmode == KSINV_IR_SIMPLE) {

    /*******************************************************************************************************
     * Second IR in mode KSINV_IR_SIMPLE
     *******************************************************************************************************/

     /* N.B: The TR we pass in to ksinv_eval_nullti() will be from last UI evaluation.
       This may change when opautotr = TRUE, and a new TI2 will cause a new TR due to TI1 calcs below,
       which in turn will cause a new TI2 etc. Can this be made non-iteratitve ? */
    ksinv2_ti = ksinv_eval_nullti(exist(optr), (int) (*ksinv2_t1value * 1000.0) /* [ms]->[us] */, mainseqctrl->min_duration);

    status = ksinv_eval_duration(&ksinv2, ksinv2_ti, coreslice_momentstart);
    if (status != SUCCESS) return status;

  }



  if (ksinv1.params.irmode == KSINV_FLAIR_BLOCK || ksinv1.params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {

    /*******************************************************************************************************
     * First IR in mode KSINV_FLAIR_BLOCK or KSINV_FLAIR_T2PREP_BLOCK (T2-FLAIR)
     *******************************************************************************************************/
    int TR;

    if (opautotr == FALSE) { /* Manual TR */
      int filltr_duration;

      /* minTR: Call ksinv_eval_flairblock() first in AutoTR mode to get the minimum TR to report back to the UI, then proceed with the actual TR (optr)
      using ksinv_eval_flairblock_withmainupdate(), where we also update the main sequence duration */
      status = ksinv_eval_flairblock(&ksinv1, &filltr_duration, &minTR, &ksinv1_ti, TRUE, (opautoti) * (*ksinv1_t1value * 1000.0),
                                   ksinv2.seqctrl.duration + coreslice_momentstart, ksinv2.seqctrl.duration + coreslice_duration, slice_plan->nslices_per_pass);

      TR = exist(optr);
      
      /* Maximum slices that would fit the chosen manual TR */
      int i = 0;
      while (1) {
        /* N.B. arg 3 (TR) not modified in ksinv_eval_flairblock() when arg 5 (opautotr) = FALSE */
        status = ksinv_eval_flairblock(&ksinv1, &filltr_duration, &TR, &ksinv1_ti, FALSE, (opautoti) * (*ksinv1_t1value * 1000.0),
                                     ksinv2.seqctrl.duration + coreslice_momentstart, ksinv2.seqctrl.duration + coreslice_duration, slice_plan->nslices_per_pass + i);
        if (filltr_duration <= 0) {
          avmaxslquant = slice_plan->nslices_per_pass + i - 1; break;
        } else {
          i++;
        }
      }

    } /* Manual TR */

    status = ksinv_eval_flairblock_withmainupdate(&ksinv1, &ksinv_filltr, mainseqctrl, (opautotr) ? (&minTR) : (&TR), 
                                                  &ksinv1_ti, opautotr, (opautoti) * (*ksinv1_t1value * 1000.0),
                                                  ksinv2.seqctrl.duration + coreslice_momentstart, ksinv2.seqctrl.duration + coreslice_duration, slice_plan->nslices_per_pass);
    if (status != SUCCESS) return status;

    if (opautotr) {
      /* show the optimal # slices to avoid inversion dummy inversion slices so the user can see what is the most time
         efficient number of slices (i.e. when scantime/slice is the lowest) */
      avmaxslquant = CEIL_DIV(slice_plan->nslices_per_pass, ksinv1.params.nflairslices) * ksinv1.params.nflairslices;
    } else if (existcv(optr)) {
      /* watch out for very narrow band of manual TR values between minTR and [minTR + nflairblocks*ksinv_filltr.ssi_time] where
      the sequence modules do not sum up to the intended optr since we have not been able to use the filltr sequence with this 
      short duration. Increase the minTR to trigger an error */
      int nflairblocks = CEIL_DIV(slice_plan->nslices_per_pass, ksinv1.params.nflairslices); /* number of FLAIR blocks */
      if (TR > minTR) {
        minTR = CEIL_DIV(minTR + nflairblocks * ksinv_filltr.ssi_time, 1000) * 1000;
      }
    }

    /* add the fillTR sequence module to the sequence collection (ignored if ksinv_filltr.duration = 0) */
    status = ks_eval_addtoseqcollection(seqcollection, &ksinv_filltr);
    if (status != SUCCESS) return status;   

  } else if (ksinv1.params.irmode == KSINV_IR_SIMPLE && (opautotr == FALSE || opautoti == FALSE)) {

    /*******************************************************************************************************
    * First IR in mode KSINV_IR_SIMPLE and not both AutoTI and AutoTR
    *******************************************************************************************************/

    if (opautoti) {
      /* AutoTI: set TI based on ksinv1_t1value and current (manual) TR */
      ksinv1_ti = ksinv_eval_nullti(exist(optr), (int) (*ksinv1_t1value * 1000.0) /* [ms]->[us] */, mainseqctrl->min_duration);
    }

    /* set the sequence module duration */
    status = ksinv_eval_duration(&ksinv1, ksinv1_ti, coreslice_momentstart);
    if (status != SUCCESS) return status;

    /* calculate min TR given the ksinv_scan_sliceloop() duration and addition heating penalties */
    minTR = ksinv_eval_mintr(slice_plan, seqcollection, ks_gheatfact, &ksinv1, &ksinv2, NULL, play_coreslice, core_nargs, core_args);
    if (minTR == KS_NOTSET) return FAILURE;

    /* how much time to add due to long manual TR (opautotr = FALSE) or due to heating (opautotr = TRUE) */
    if (opautotr == FALSE) {
      timetoadd_perTR = exist(optr) - ksinv_scan_sliceloop(slice_plan, ks_scan_info, 0, &ksinv1, &ksinv2, NULL, FALSE, play_coreslice, core_nargs, core_args);
    } else {
      timetoadd_perTR = minTR - ksinv_scan_sliceloop(slice_plan, ks_scan_info, 0, &ksinv1, &ksinv2, NULL, FALSE, play_coreslice, core_nargs, core_args);
    }

    /* we spread the available timetoadd_perTR evenly, by increasing .duration of each slice by timetoadd_perTR/slice_plan->nslices_per_pass */
    mainseqctrl->duration += RUP_GRD(CEIL_DIV(timetoadd_perTR, slice_plan->nslices_per_pass));


  } else if ( ((ksinv1.params.irmode == KSINV_IR_SLICEAHEAD) && (ksinv2.params.irmode != KSINV_IR_SLICEAHEAD)) || ((ksinv1.params.irmode == KSINV_IR_SIMPLE) && (opautoti == TRUE) && (opautotr == TRUE)) ) {

    /*******************************************************************************************************
     * First IR, in mode
     * - KSINV_IR_SIMPLE with AutoTI and AutoTR
     * - KSINV_IR_SLICEAHEAD, when second IR was not KSINV_IR_SLICEAHEAD
     * For both cases, early heating control has been done
     *******************************************************************************************************/

     if (opautotr == FALSE || opautoti == FALSE) {
      return ks_error("%s: sliceahead mode requires both AutoTI and AutoTR", __FUNCTION__);
    }

    /* get sequence module duration, TR and TI based on T1 null value and coreslice duration */
    status = ksinv_eval_duration_t1value(&ksinv1, &minTR, &ksinv1_ti, ksinv1.params.approxti, coreslice_momentstart, coreslice_duration, mainseqctrl->min_duration, (int) (*ksinv1_t1value * 1000.0) /* [ms]->[us] */, slice_plan->nslices_per_pass);
    if (status != SUCCESS) return status;

  }


  /*******************************************************************************************************
  * update UI and GE globals
  *******************************************************************************************************/

  /* for AutoTI, update TI menu (first row) with the value in ksinv1_ti as well as opti */
  if (opautoti == TRUE) {
    pitival2 = ksinv1_ti;
    cvoverride(opti, ksinv1_ti, PSD_FIX_ON, PSD_EXIST_ON);
  }

  if (ksinv2.params.irmode != KSINV_OFF) { /* update opuser for IR2 T1-value with TI information */
    char tmpstr[200];
    sprintf(tmpstr, "IR2 - T1 to null (TI=%d ms)", ksinv2_ti / 1000);
    _cvdesc(_ksinv2_t1value, tmpstr);

    if ((ksinv1_ti - ksinv1.seqctrl.min_duration) < ksinv2_ti) {
      return ks_error("%s: IR2 must be shorter than IR1", __FUNCTION__);
    }
  }

  /* set npasses in slice plan to be consistent with nslices and nslices_per_pass */
  avmaxacqs = slice_plan->npasses; /* UI value ("# of Acqs:") */

  /* update min TR advisory */
  avmintr = minTR;
  avmaxtr = 100s;

  /* make sure TR in UI (optr) is long enough */
  if (opautotr == TRUE) {

    avmaxtr = minTR;

    cvoverride(optr, minTR, PSD_FIX_ON, PSD_EXIST_ON);

    if (ksinv1.params.irmode != KSINV_FLAIR_BLOCK && ksinv1.params.irmode != KSINV_FLAIR_T2PREP_BLOCK) {
      avmaxslquant = slice_plan->nslices_per_pass;
    }

  } else if (existcv(optr) && (optr < minTR)) {

    return ks_error("%s: increase TR to %.1f ms (seq./heating limit)", __FUNCTION__, minTR / 1000.0);

  } else {
    if (avmaxslquant < slice_plan->nslices_per_pass) {
      /* avoid the max slices value in the UI to show up smaller than the prescribed slices/pass now that all is good */
      avmaxslquant = slice_plan->nslices_per_pass;
    }
  }

  /* prevent further addition of other sequence modules. Inversion must be last one added to the
    sequence collection to keep inversion timing correct */
  seqcollection->mode = KS_SEQ_COLLECTION_LOCKED;

  /* synonyms for optr: avail_image_time and act_tr */
  avail_image_time = RDN_GRD(exist(optr));
  act_tr = avail_image_time;
  ihtr = act_tr; /* image header TR */
  avminslquant = 1;


  /*******************************************************************************************************
  * Final SAR check
  *******************************************************************************************************/
  /* assure that we have taken care of TR timing and grad/RF heating issues so that we don't call GEReq_eval_TR() again
     This also prevents further addition of other sequence modules */
  seqcollection->evaltrdone = TRUE;

  /* Check TR timing and SAR limits */
  status = ksinv_eval_checkTR_SAR(seqcollection, slice_plan, play_coreslice, core_nargs, core_args);
  if (status != SUCCESS) return status;



return SUCCESS;

} /* ksinv_eval_multislice() */





/**
 *******************************************************************************************************
 @brief #### Runs the inversion slice loop and validates TR and SAR/hardware limits

 This function first makes sure that the `.nseqinstances` field for each sequence module in the sequence
 collection corresponds to the number of times played out in ksinv_scan_sliceloop()

 In simulation (WTools), ks_print_seqcollection() will print out a table of the sequence modules in
 the sequence collection in the WToolsMgd window.

 Finally, GEReq_eval_checkTR_SAR_calcs() is called to check that the TR is correct and within SAR/hardware
 limits.

 N.B.: For non-inversion sequences, ks_eval_checkTR_SAR() is used to do the same thing, with the difference
 that the psd's sliceloop function is used instead of ksinv_scan_sliceloop().

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @param[in] slice_plan Pointer to the KS_SLICE_PLAN struct holding the slice order information
 @param[in] play_coreslice Function pointer to (the wrapper function to) the coreslice function of the sequence
 @param[in] core_nargs Number of extra input arguments to the coreslice wrapper function.
 @param[in] core_args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's coreslice function
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_eval_checkTR_SAR(KS_SEQ_COLLECTION *seqcollection, KS_SLICE_PLAN *slice_plan, int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args) {
  STATUS status;

  /* set all `seqctrl.nseqinstances` to 0 */
  ks_eval_seqcollection_resetninst(seqcollection);

  /* set all `seqctrl.nseqinstances` to the number of occurrences */
  ksinv_scan_sliceloop(slice_plan, ks_scan_info, 0, &ksinv1, &ksinv2, &ksinv_filltr, FALSE, play_coreslice, core_nargs, core_args);

  /* validate TR and check that we are within SAR/hardware limits */
  status = GEReq_eval_checkTR_SAR_calcs(seqcollection, optr);
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* ksinv_eval_checkTR_SAR() */




/**
 *******************************************************************************************************
 @brief #### Checks related to inversion

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_check() {

  if (existcv(optr) && (opflair == OPFLAIR_INTERLEAVED) && (optr < KSINV_MINTR_T1FLAIR)) {
    ks_error("%s: TR should be >= %d ms for T1FLAIR", __FUNCTION__, KSINV_MINTR_T1FLAIR/1000);
  }

return SUCCESS;

}




/**
 *******************************************************************************************************
 @brief #### Sets IR-related recon variables in predownload

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_predownload_setrecon() {

  if (ksinv1_mode != KSINV_OFF) {
    cvoverride(ihti, ksinv1_ti, PSD_FIX_ON, PSD_EXIST_ON); /* same as opti */
  }

  return SUCCESS;

} /* ksinv_predownload_setrecon() */






@pg
/*******************************************************************************************************
*******************************************************************************************************
*
*  KSInversion.e: PULSEGEN functions
*                Accessible on TGT, and also HOST if UsePgenOnHost() in the Imakefile
*
*******************************************************************************************************
*******************************************************************************************************/

KS_MAT4x4 Mphysical_inversion = KS_MAT4x4_IDENTITY;




/**
 *******************************************************************************************************
 @brief #### Generation of the waveforms for the sequence objects in a KSINV_SEQUENCE

 Two KSINV_SEQUENCE structs are currently declared in KSInversion.e, `ksinv1` and `ksinv2`. By passing
 each one of them to this function, will generate the actual sequence on TGT. On HOST, the
 `seqctrl.min_duration` field is set and used by TI/TR calculations.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_pg(KSINV_SEQUENCE *ksinv) {
  STATUS status;
  KS_SEQLOC loc = KS_INIT_SEQLOC;


  if (ksinv->params.irmode == KSINV_OFF)
    return SUCCESS;

#ifdef IPG
  /* TGT (IPG) only: return early if sequence module duration is zero */
  if (ksinv->seqctrl.duration == 0)
    return SUCCESS;
#endif


  loc.pos = ksinv->params.startpos;

  if (loc.pos % GRAD_UPDATE_TIME) {
    return ks_error("%s: Start position of RF pulse must be divisible by GRAD_UPDATE_TIME (ksinv->params.rfstartpos = %d)", __FUNCTION__, ksinv->params.startpos);
  }
  if (loc.pos < KS_RFSSP_PRETIME) {
    return ks_error("%s: Start position of RF pulse must be at least %d [us] (ksinv->params.rfstartpos = %d)", __FUNCTION__, KS_RFSSP_PRETIME, ksinv->params.startpos);
  }

  /* RF */
  if (ksinv_slicecheck){
    loc.board = XGRAD;
  } else {
    loc.board = ZGRAD;
  }


  if (ksinv->params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {

    if (ks_pg_selrf(&ksinv->selrfexc, loc, &ksinv->seqctrl) == FAILURE)
    return FAILURE;

    int mag_center_exc = loc.pos + ksinv->selrfexc.grad.ramptime + ksinv->selrfexc.rf.start2iso;

    /* now refocussing pulses*/
    /* we make sure that that delta_t_refoc/2 is a multiple of GRAD_UPDATE_TIME using the RUP_GRD function (division results are integer truncated) */
    int delta_t_refoc_half = RUP_GRD(ksinv->params.t2prep_TE  / ksinv->params.N_Refoc / 2);

    /* first refocusing pulse*/
    loc.pos = mag_center_exc + delta_t_refoc_half - ksinv->selrfrefoc.grad.ramptime - ksinv->selrfrefoc.rf.start2iso - ksinv->selrfrefoc.pregrad.duration;
    if (ks_pg_selrf(&ksinv->selrfrefoc, loc, &ksinv->seqctrl) == FAILURE)
    return FAILURE;
    /* all other refocusing pulses*/
    int n;
    for (n = 1; n < ksinv->params.N_Refoc; n++) {
      loc.pos += 2*delta_t_refoc_half;
      if (ks_pg_selrf(&ksinv->selrfrefoc, loc, &ksinv->seqctrl) == FAILURE)
      return FAILURE;
    }

    /***************************************************************************************************
     *  two different versions
     *  non adiabatic (+90)-(n*180)-(+90)
     *  adiabatic (+90)-(n*180)-(-90)-(180)
     *  the polarity of the flip angle of the flip pulse is set with loc.ampscale
     ***************************************************************************************************/

    loc.pos = mag_center_exc + ksinv->params.N_Refoc*delta_t_refoc_half*2 - ksinv->selrfflip.grad.ramptime - ksinv->selrfflip.rf.start2iso - ksinv->selrfflip.pregrad.duration;
    
    if (ksinv->params.rftype == KSINV_RF_ADIABATIC) {
      loc.ampscale = -1;
    } else {
      loc.ampscale = 1;
    }

    if (ks_pg_selrf(&ksinv->selrfflip, loc, &ksinv->seqctrl) == FAILURE)
    return FAILURE;
    
    /* Save absolute time in sequence for moment start, it is important to do that after 
    ks_pg_selrf(&ksinv->selrfflip, loc, &ksinv->seqctrl) because otherwise ksinv->seqctrl.momentstart would be overwritten as
    the "ROLE" of selrfflip is an excitation pulse, there is no ROLE for a flipup pulse yet */
    ksinv->seqctrl.momentstart = mag_center_exc;   

    loc.ampscale = 1; /* set it back to default */
    /* waveform overlap problems between selrfflip and selrfinv on DV25 --> 5*GRAD_UPDATE_TIME safety margin */
    loc.pos += ksinv->selrfflip.pregrad.duration + ksinv->selrfflip.grad.duration + 5*GRAD_UPDATE_TIME;
    
    if (ksinv->params.rftype == KSINV_RF_ADIABATIC) {
      if (ks_pg_selrf(&ksinv->selrfinv, loc, &ksinv->seqctrl) == FAILURE)
      return FAILURE;
      loc.pos += (ksinv->selrfinv.grad.duration > 0) ? ksinv->selrfinv.grad.duration : ksinv->selrfinv.gradwave.duration;
    }
  } else {

    /* Save absolute time in sequence for moment start */
    ksinv->seqctrl.momentstart = loc.pos + ksinv->selrfinv.grad.ramptime + ksinv->selrfinv.rf.start2iso;

    status = ks_pg_selrf(&ksinv->selrfinv, loc, &ksinv->seqctrl);
    if (status != SUCCESS) return status;

    loc.pos += (ksinv->selrfinv.grad.duration > 0) ? ksinv->selrfinv.grad.duration : ksinv->selrfinv.gradwave.duration;

  }

  /* Z spoiler */
  loc.board = YGRAD;
  status = ks_pg_trap(&ksinv->spoiler, loc, &ksinv->seqctrl);
  if (status != SUCCESS) return status;
  loc.pos += ksinv->spoiler.duration;


 /*******************************************************************************************************
   *  Set the minimal sequence duration (ksinv->seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  loc.pos = RUP_GRD(loc.pos);

#ifdef HOST_TGT
  /* On HOST only: Sequence module duration (ksinv->seqctrl.ssi_time must be > 0 and is added to ksinv->seqctrl.min_duration in ks_eval_seqctrl_setminduration()) */
  ksinv->seqctrl.ssi_time = ksinv->params.ssi_time;
  ks_eval_seqctrl_setminduration(&ksinv->seqctrl, loc.pos); /* loc.pos now corresponds to the end of last gradient in the sequence */
#endif


  return SUCCESS;

} /* ksinv_pg() */




/**
 *******************************************************************************************************
 @brief #### Generation of all inversion-related sequence modules

 This function should be called directly from the `pulsegen()` function in a psd to create up to three
 sequence modules that can be used during scan.

 N.B.: If ksinvX.seqctrl.duration = 0, both ksinv_pg() and KS_SEQLENGTH() will return early avoiding this
 sequence module to be created. Similarly for the seqInvFillTR wait sequence.

 @return void
********************************************************************************************************/
void ksinv_pulsegen() {

  /* First (only) Inversion sequence module */
  ksinv_pg(&ksinv1);
  KS_SEQLENGTH(seqInv1, ksinv1.seqctrl); /* does nothing if ksinv1.seqctrl.duration = 0 */

  /* 2nd Inversion sequence module */
  ksinv_pg(&ksinv2);
  KS_SEQLENGTH(seqInv2, ksinv2.seqctrl); /* does nothing if ksinv2.seqctrl.duration = 0 */

  /* FillTR sequence for some inversion cases */
  KS_SEQLENGTH(seqInvFillTR, ksinv_filltr); /* does nothing if ksinv_filltr.duration = 0 */

} /* ksinv_pulsegen() */




/**
 *******************************************************************************************************
 @brief #### Sets the current state of a KSINV_SEQUENCE during scanning

 This function sets the current state of all `ksinv` sequence objects being part of KSINV_SEQUENCE,
 specifically slice-dependent RF freq/phases changes.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more. This could for example be useful when certain lines or slices
 need to be rescanned due to image artifacts detected during scanning.

 @param[in] ksinv Pointer to KSINV_SEQUENCE
 @param[in] slice_info Pointer to position of the slice to be played out (one element in the `ks_scan_info[]` array)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksinv_scan_seqstate(KSINV_SEQUENCE *ksinv, const SCAN_INFO *slice_info) {

  if (ksinv->params.irmode == KSINV_OFF || ksinv->seqctrl.duration == 0)
    return SUCCESS;

  if (slice_info != NULL) {

    ks_scan_rotate(*slice_info);

    if (ksinv->params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {
      ks_scan_rf_on(&ksinv->selrfexc.rf, INSTRALL);
      ks_scan_selrf_setfreqphase(&ksinv->selrfexc, INSTRALL, *slice_info, 0);

      ks_scan_rf_on(&ksinv->selrfrefoc.rf, INSTRALL);
      ks_scan_selrf_setfreqphase(&ksinv->selrfrefoc, INSTRALL, *slice_info, 90);

      ks_scan_rf_on(&ksinv->selrfinv.rf, INSTRALL);
      ks_scan_selrf_setfreqphase(&ksinv->selrfinv, INSTRALL, *slice_info, 0);

      ks_scan_rf_on(&ksinv->selrfflip.rf, INSTRALL);
      ks_scan_selrf_setfreqphase(&ksinv->selrfflip, INSTRALL, *slice_info, 0);

    } else {  
      ks_scan_rf_on(&ksinv->selrfinv.rf, 0);

      if (ksinv->selrfinv.sms_info.pulse_type == KS_SELRF_SMS_PINS_DANTE) {
        ks_scan_selrf_setfreqphase_pins(&ksinv->selrfinv, 0, *slice_info,
                                        ksinv->selrfinv.sms_info.mb_factor, ksinv->selrfinv.sms_info.slice_gap, 0.0);
      } else {
        ks_scan_selrf_setfreqphase(&ksinv->selrfinv, 0, *slice_info, 0);
      }
    }

  } else {

    ks_scan_rf_off(&ksinv->selrfinv.rf, 0);

  }

  return SUCCESS;

} /* ksinv_scan_seqstate() */




/**
 *******************************************************************************************************
 @brief #### Plays out one inversion slice in real time during scanning

  On TGT on the MR system (PSD_HW), this function sets up (ksepi_scan_seqstate()) and plays out one
  KSINV_SEQUENCE. The low-level function call `startseq()`, which actually starts the realtime sequence
  playout is called from within ks_scan_playsequence(), which in addition also returns the time to play
  out that sequence module (see time += ...).

  On HOST (in ksepi_eval_tr()) we call ksepi_scan_sliceloop_nargs(), which in turn calls this function
  that returns the total time in [us] taken to play out this core slice. These times are increasing in
  each parent function until ultimately ksepi_scan_scantime(), which returns the total time of the
  entire scan.

  @param[in] ksinv Pointer to KSINV_SEQUENCE
  @param[in] slice_pos Pointer to position of the slice to be played out (one element in the `ks_scan_info[]` array)
  @retval irtime Time taken in [us] to play out one inversion slice
********************************************************************************************************/
int ksinv_scan_irslice(KSINV_SEQUENCE *ksinv, const SCAN_INFO *slice_pos) {
  SCAN_INFO slice_pos_updated;
  int time = 0;
  float tloc = 0.0;

  if (ksinv == NULL) {
    return 0;
  }

  if (ksinv->params.irmode != KSINV_OFF && ksinv->seqctrl.duration > 0) {

    if (slice_pos != NULL) {
      /* N.B.: Mphysical_inversion is an ipgexport KS_MAT4x4 variable that e.g. the main sequence can update in real time */
      ks_scan_update_slice_location(&slice_pos_updated, *slice_pos, Mphysical_inversion, NULL);
      tloc = slice_pos_updated.optloc;
      ksinv_scan_seqstate(ksinv, &slice_pos_updated);
    } else {
      ksinv_scan_seqstate(ksinv, slice_pos);
    }

    /* SMS offset */
    float offset = (ksinv->selrfinv.sms_info.slice_gap / 2) * (ksinv->selrfinv.sms_info.mb_factor - 1);
    float sms_slice_positions[ksinv->selrfinv.sms_info.mb_factor];
    int slice = 0;
    for (slice = 0; slice < ksinv->selrfinv.sms_info.mb_factor; ++slice) {
      if (slice_pos != NULL)
        sms_slice_positions[slice] = tloc + ksinv->selrfinv.sms_info.slice_gap * (0.5 + slice - (ksinv->selrfinv.sms_info.mb_factor / 2.0)) + offset;
      else
        sms_slice_positions[slice] = 0;
    }

    ks_plot_slicetime(&ksinv->seqctrl,
                      ksinv->selrfinv.sms_info.mb_factor,
                      sms_slice_positions,
                      ksinv->selrfinv.slthick,
                      slice_pos == NULL ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD);

    time += ks_scan_playsequence(&ksinv->seqctrl);

  }

  return time;

} /* ksinv_scan_irslice() */




/**
 *******************************************************************************************************
 @brief #### Plays out `slice_plan.nslices_per_pass` slices corresponding to one TR for inversion psds

 This function should replace the sliceloop function of a 2D psd when inversion is enabled. It will take
 over the sequence timing for one TR by playing out the inversion sequence module(s) and other sequence
 modules in an order that is subject to the inversion mode (`ksinvX.params.irmode`). The non-inversion
 sequence modules should be played out together in a 'core slice' function of the psd. This core slice
 function should have a wrapper function with standardized input arguments that conmplies with the
 function pointer (and core_nargs, core_args) passed to this function.

 @param[in] slice_plan  Pointer to the slice plan (KS_SLICE_PLAN) set up earlier using ks_calc_sliceplan() or similar
 @param[in] slice_positions Pointer to the SCAN_INFO array corresponding to the slice locations (typically `ks_scan_info`)
 @param[in] passindx  Pass index in range `[0, ks_slice_plan.npasses - 1]`
 @param[in] ksinv1    Pointer to KSINV_SEQUENCE corresponding to the 1st (or only) inversion. Cannot be NULL
 @param[in] ksinv2    Pointer to KSINV_SEQUENCE corresponding to an optional 2nd inversion. May be NULL
 @param[in] ksinv_filltr    Pointer to KS_SEQ_CONTROL for fillTR sequence for FLAIR block modes. May be NULL
 @param[in] ksinv_loop_mode If KSINV_LOOP_DUMMY, this function will pass in KS_NOTSET (-1) as the 2nd argument to 'play_coreslice'.
                       For this to work, the play_coreslice() function (usually the main sequence's coreslice),
                       must check if it's 2nd arg is KS_NOTSET, and if so shut off data collection in loaddab()
                       KSINV_LOOP_NORMAL: Slice excitation ON, Data acq. ON
                       KSINV_LOOP_DUMMY: Slice excitation ON, Data acq. OFF
                       KSINV_LOOP_SLICEAHEAD_FIRST: Slice excitation ON for IR, OFF for coreslice, Data acq. OFF
                       KSINV_LOOP_SLICEAHEAD_LAST: Slice excitation OFF for IR, ON for coreslice, Data acq. ON

 @param[in] play_coreslice Function pointer to (the wrapper function to) the coreslice function of the sequence
 @param[in] core_nargs Number of extra input arguments to the coreslice wrapper function.
 @param[in] core_args  Void pointer array pointing to the variables containing the actual values needed for
                       the sequence's coreslice function
 @retval slicelooptime Time taken in [us] to play out `slice_plan.nslices_per_pass` slices
********************************************************************************************************/
int ksinv_scan_sliceloop(const KS_SLICE_PLAN *slice_plan, const SCAN_INFO *slice_positions, int passindx, 
                         KSINV_SEQUENCE *ksinv1, KSINV_SEQUENCE *ksinv2, KS_SEQ_CONTROL *ksinv_filltr, KSINV_LOOP_MODE ksinv_loop_mode,
                         int (*play_coreslice)(const SCAN_INFO *, int, int, void **), int core_nargs, void **core_args) {
  int time = 0;
  int i, sltimeinpass;
  int slloc, sltime_adjusted;
  const SCAN_INFO *slpos;

  if (ksinv1 == NULL) {
    ks_error("%s: 4th arg cannot be NULL", __FUNCTION__);
    return KS_NOTSET;
  }
  if (ksinv1->params.irmode == KSINV_OFF) {
    return 0;  /* if the IR mode for the 1st IR is off, return quietly */
  }
  if (slice_plan == NULL) {
    ks_error("%s: 1st arg cannot be NULL", __FUNCTION__);
    return KS_NOTSET;
  }
  if (slice_positions == NULL) {
    ks_error("%s: 2nd arg cannot be NULL", __FUNCTION__);
    return KS_NOTSET;
  }

  if (play_coreslice == NULL) {
    ks_error("%s: 7th arg must be a function pointer to the coreslice function", __FUNCTION__);
    return KS_NOTSET;
  }


  if (ksinv1->params.irmode == KSINV_FLAIR_BLOCK || ksinv1->params.irmode == KSINV_FLAIR_T2PREP_BLOCK) {
    /* For classic T2-FLAIR, we often end up with 2 sets of FLAIR+core per TR
       Here is a generalization, where number of sets is equal to:
       CEIL_DIV(slice_plan->nslices_per_pass, ksinv1->params.nflairslices), where slice_plan->nslices_per_pass = CEIL_DIV(slice_plan->nslices, slice_plan->npasses)
    */
   
    /* make sure nflairslices > 0, or else we will be stuck here as sltimeinpass will remain at 0 forever */
    if (ksinv1->params.nflairslices <= 0) {
      ks_error("%s: ksinv1.params.nflairslices must be > 0", __FUNCTION__);
      return -1;
    }

    sltimeinpass = 0;

    while (sltimeinpass < slice_plan->nslices_per_pass) {

      /*--------- 1st inversion sequence module as FLAIR block -----------*/
      for (i = 0; i < ksinv1->params.nflairslices; i++) {
        slloc = ks_scan_getsliceloc(slice_plan, passindx, sltimeinpass + i);
        slpos = (slloc != KS_NOTSET) ? &slice_positions[slloc] : NULL;
        time += ksinv_scan_irslice(ksinv1, slpos /* if NULL, shut off RF */);
      }

      for (i = 0; (i < ksinv1->params.nflairslices) && (sltimeinpass + i < slice_plan->nslices_per_pass); i++) {

        slloc = ks_scan_getsliceloc(slice_plan, passindx, sltimeinpass + i);
        slpos = (slloc != KS_NOTSET) ? &slice_positions[slloc] : NULL;

        if (ksinv2 != NULL) {
          /*--------- optional 2nd inversion sequence module (DIR mode) attached to each coreslice playout -----------*/
          time += ksinv_scan_irslice(ksinv2, slpos /* if NULL, shut off RF */);
        }

        /*--------- "coreslice": main sequence module (may include e.g. GRx Sat, FatSat etc.) -----------*/
        time += play_coreslice(
                  slpos, /* if NULL, shut off RF. The coreslice function must also shut data acquisition off regardless of next arg */
                  (ksinv_loop_mode == KSINV_LOOP_DUMMY) ? KS_NOTSET : (sltimeinpass + i), /* if KS_NOTSET (-1), shut off data acquisition */
                  core_nargs, core_args);
      }

      sltimeinpass += ksinv1->params.nflairslices;

      if (ksinv_filltr != NULL) {
        /*--------- fillTR sequence module (to fill up to manual TR in CEIL_DIV(nslices_per_pass, ksinv1->params.nflairslices) chunks) -----------*/
        time += ks_scan_playsequence(ksinv_filltr);
        ks_plot_slicetime(ksinv_filltr, 1, NULL, KS_NOTSET, KS_PLOT_NO_EXCITATION); /* Add a filler to slicetime plot */
      }

    } /* while */


  } else {

    int sltime_start = (ksinv_loop_mode == KSINV_LOOP_SLICEAHEAD_FIRST) ? (slice_plan->nslices_per_pass - ksinv1->params.nslicesahead) : 0;

    for (sltimeinpass = sltime_start; sltimeinpass < slice_plan->nslices_per_pass; sltimeinpass++) {

      /*--------- 1st inversion sequence module -----------*/
      if (ksinv1->params.irmode == KSINV_IR_SIMPLE || ksinv1->params.irmode == KSINV_IR_SLICEAHEAD)  {
        sltime_adjusted = (sltimeinpass + ksinv1->params.nslicesahead) % slice_plan->nslices_per_pass;
        slloc = ks_scan_getsliceloc(slice_plan, passindx, sltime_adjusted);
        slpos = (slloc != KS_NOTSET) ? &slice_positions[slloc] : NULL;        
        slpos = ((ksinv_loop_mode == KSINV_LOOP_SLICEAHEAD_LAST) && (sltime_adjusted < ksinv1->params.nslicesahead)) ? NULL : slpos;
        time += ksinv_scan_irslice(ksinv1, slpos /* if NULL, shut off RF */);
      }

      /*--------- 2nd inversion sequence module -----------*/
      if (ksinv2 != NULL && (ksinv2->params.irmode == KSINV_IR_SIMPLE || ksinv2->params.irmode == KSINV_IR_SLICEAHEAD)) {
        sltime_adjusted = (sltimeinpass + ksinv2->params.nslicesahead) % slice_plan->nslices_per_pass;
        slloc = ks_scan_getsliceloc(slice_plan, passindx, sltime_adjusted);
        slpos = (slloc != KS_NOTSET) ? &slice_positions[slloc] : NULL;
        time += ksinv_scan_irslice(ksinv2, slpos /* if NULL, shut off RF */);
      }

      /*--------- "coreslice": main sequence module (may include e.g. GRx Sat, FatSat etc.) -----------*/
      slloc = ks_scan_getsliceloc(slice_plan, passindx, sltimeinpass);
      slpos = (slloc != KS_NOTSET) ? &slice_positions[slloc] : NULL;
      slpos = (ksinv_loop_mode == KSINV_LOOP_SLICEAHEAD_FIRST) ? NULL : slpos;
      time += play_coreslice(
                slpos, /* if NULL, shut off RF. The coreslice function must also shut data acquisition off regardless of next arg */
                (ksinv_loop_mode == KSINV_LOOP_DUMMY) ? KS_NOTSET : sltimeinpass, /* if KS_NOTSET (-1), shut off data acquisition */
                core_nargs,
                core_args);

    } /* slice in pass */

  } /* else (not FLAIR-block) */

  return time;

} /* ksinv_scan_sliceloop() */
 
                         

int ksinv_scan_sliceloop_nargs(int slperpass, int nargs, void **args) {
  KS_SLICE_PLAN slice_plan = KS_INIT_SLICEPLAN;
  slice_plan.nslices_per_pass = slperpass;
  SCAN_INFO *slice_positions = NULL;
  int passindx = 0;
  KSINV_SEQUENCE *ksinv1 = NULL;
  KSINV_SEQUENCE *ksinv2 = NULL;
  KS_SEQ_CONTROL *ksinv_filltr = NULL;
  KSINV_LOOP_MODE ksinv_loop_mode = KSINV_LOOP_NORMAL;
  int (*play_coreslice)(const SCAN_INFO *, int, int, void **) = 0;
  int core_nargs = 0;
  void **core_args = NULL;

  if (nargs < 0 || nargs > 3) {
    ks_error("%s: 3rd arg (void **) must contain 7 or 9 elements: slice_positions, passindx, &ksinv1, &ksinv2, &ksinv_filltr, play_as_dummy, play_coreslice [, core_nargs, core_args]", __FUNCTION__);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 3rd arg (void **) cannot be NULL if nargs (2nd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    slice_positions = (SCAN_INFO *) args[0];
  }
  if (nargs >= 2 && args[1] != NULL) {
    passindx = *((int *) args[1]);
  }
  if (nargs >= 3 && args[2] != NULL) {
    ksinv1 = (KSINV_SEQUENCE *) args[2];
  }
  if (nargs >= 4 && args[3] != NULL) {
    ksinv2 = (KSINV_SEQUENCE *) args[3];
  }
  if (nargs >= 5 && args[4] != NULL) {
    ksinv_filltr = (KS_SEQ_CONTROL *) args[4];
  }
  if (nargs >= 6 && args[5] != NULL) {
    ksinv_loop_mode = *((KSINV_LOOP_MODE *) args[5]);
  }
  if (nargs >= 7 && args[6] != NULL) {
    play_coreslice = (int (*)(const SCAN_INFO *, int, int, void **)) args[6];
  }
  if (nargs >= 8 && args[7] != NULL) {
    core_nargs = *((int *) args[7]);
  }
  if (nargs >= 9 && args[8] != NULL) {
    core_args = (void **) args[8];
  }

  return ksinv_scan_sliceloop(&slice_plan, slice_positions, passindx, ksinv1, ksinv2, ksinv_filltr, ksinv_loop_mode, play_coreslice, core_nargs, core_args); /* in [us] */

} /* ksfse_scan_sliceloop_nargs() */

