/*******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : KSChemSat.e
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
* @file KSChemSat.e
* @brief This file contains FatSat (KSChemSat) and should be `@inline`'d at the beginning of a KSFoundation PSD
********************************************************************************************************/

@global
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSChemSat.e: Global section
 *
 *******************************************************************************************************
 *******************************************************************************************************/

enum {KSCHEMSAT_OFF, KSCHEMSAT_FAT, KSCHEMSAT_WATER};
enum {KSCHEMSAT_RF_STD, KSCHEMSAT_RF_SINC};

#define KSCHEMSAT_MODULE_LOADED /* can be used to check whether the KSChemsat module has been included in a main psd */

#define KSCHEMSAT_DEFAULT_FLIP 95
#define KSCHEMSAT_DEFAULT_SINCRF_BW_15T 150 /* for 1.5T */
#define KSCHEMSAT_DEFAULT_SINCRF_BW_3T 300 /* for 3T */
#define KSCHEMSAT_DEFAULT_SINCRF_TBP 4
#define KSCHEMSAT_DEFAULT_SPOILERAREA 5000
#define KSCHEMSAT_DEFAULT_SSITIME 1000 /* try to reduce this value */

/** @brief #### `typedef struct` holding steering parameters for KSChemSat
*/
typedef struct _KSCHEMSAT_PARAMS {
  int satmode;
  float flip;
  int rfoffset; /* [Hz] */
  int rftype;
  int sincrf_bw;
  int sincrf_tbp;
  float spoilerarea;
  int ssi_time;
} KSCHEMSAT_PARAMS;
#define KSCHEMSAT_INIT_PARAMS {KSCHEMSAT_OFF, KSCHEMSAT_DEFAULT_FLIP, 0, KSCHEMSAT_RF_STD, KSCHEMSAT_DEFAULT_SINCRF_BW_3T, KSCHEMSAT_DEFAULT_SINCRF_TBP, KSCHEMSAT_DEFAULT_SPOILERAREA, KSCHEMSAT_DEFAULT_SSITIME}

/** @brief #### `typedef struct` holding all information about the KSChemSat sequence module incl. all gradients and waveforms
*/
typedef struct _KSCHEMSAT_SEQUENCE {
  KS_BASE base;
  KS_SEQ_CONTROL seqctrl;
  KSCHEMSAT_PARAMS params;
  KS_RF rf;
  KS_TRAP spoiler;
} KSCHEMSAT_SEQUENCE;
#define KSCHEMSAT_INIT_SEQUENCE {{0,0,NULL,sizeof(KSCHEMSAT_SEQUENCE)}, KS_INIT_SEQ_CONTROL, KSCHEMSAT_INIT_PARAMS, KS_INIT_RF, KS_INIT_TRAP}


/* Function prototypes */
int kschemsat_pg(KSCHEMSAT_SEQUENCE *chemsat);

@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSChemSat.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
KSCHEMSAT_SEQUENCE kschemsat = KSCHEMSAT_INIT_SEQUENCE;


@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSChemSat.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
int kschemsat_flag = KSCHEMSAT_OFF with {KSCHEMSAT_OFF, KSCHEMSAT_WATER, KSCHEMSAT_OFF, VIS, "flag for kschemsat (0:Off 1:FatSat 2:WaterSat)",};
float kschemsat_flip = KSCHEMSAT_DEFAULT_FLIP with {0, 360, KSCHEMSAT_DEFAULT_FLIP, VIS, "RF flip angle [deg]",};
int kschemsat_rftype = KSCHEMSAT_RF_STD  with {KSCHEMSAT_RF_STD, KSCHEMSAT_RF_SINC, KSCHEMSAT_RF_STD, VIS, "RF type (0:Std 1:Sinc)",};
int kschemsat_sinc_bw = KSCHEMSAT_DEFAULT_SINCRF_BW_3T with {2, 100000, 300, VIS, "Sinc RF BW",};
int kschemsat_sinc_tbp = KSCHEMSAT_DEFAULT_SINCRF_TBP with {2, 20, 2, VIS, "Sinc RF Time-Bandwidth-Product",};
int kschemsat_rfoffset = 0 with {-1000, 1000, 0, VIS, "RF excitation freq offset [Hz]",};
float kschemsat_spoilerarea = KSCHEMSAT_DEFAULT_SPOILERAREA with {0, 10000, KSCHEMSAT_DEFAULT_SPOILERAREA, VIS, "Spoiler area",};
int kschemsat_ssi_time = KSCHEMSAT_DEFAULT_SSITIME with {10, 20000, KSCHEMSAT_DEFAULT_SSITIME, VIS, "Time from eos to ssi in intern trig",};


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSChemSat.e: HOST functions and variables
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/**
 *******************************************************************************************************
 @brief #### Resets the KSCHEMSAT_PARAMS struct (arg 1) to KSCHEMSAT_INIT_PARAMS
 @param[out] params Pointer to the kschemsat params struct used to steer the behavior of this fatsat
                    sequence module
 @return void
********************************************************************************************************/
void kschemsat_init_params(KSCHEMSAT_PARAMS *params) {
  KSCHEMSAT_PARAMS defparams = KSCHEMSAT_INIT_PARAMS;
  *params = defparams;
}




/**
 *******************************************************************************************************
 @brief #### Resets the KSCHEMSAT_SEQUENCE struct (arg 1) to KSCHEMSAT_INIT_SEQUENCE

 As KSCHEMSAT_INIT_SEQUENCE contains KSCHEMSAT_PARAMS, which sets the field `.satmode = KSCHEMSAT_OFF`,
 calling kschemsat_init_sequence() will disable the `kschemsat` sequence module (i.e. turn off fatsat)

 @param[out] kschemsat Pointer to KSCHEMSAT_SEQUENCE
 @return void
********************************************************************************************************/
void kschemsat_init_sequence(KSCHEMSAT_SEQUENCE *kschemsat) {
  KSCHEMSAT_SEQUENCE defseq = KSCHEMSAT_INIT_SEQUENCE;
  *kschemsat = defseq;
  strcpy(kschemsat->seqctrl.description, "kschemsat");
} /* kschemsat_init_sequence() */




/**
 *******************************************************************************************************
 @brief #### Copy CVs into a common params struct (KSCHEMSAT_PARAMS) used to steer this sequence module

 @param[out] params Pointer to the kschemsat params struct used to steer the behavior of this fatsat
                    sequence module
 @return void
********************************************************************************************************/
void kschemsat_eval_copycvs(KSCHEMSAT_PARAMS *params) {

  params->satmode = kschemsat_flag;

  /* RF */
  params->flip = kschemsat_flip;
  params->rfoffset = kschemsat_rfoffset;
  params->rftype = kschemsat_rftype;
  if (params->rftype == KSCHEMSAT_RF_SINC) {
    params->sincrf_bw = kschemsat_sinc_bw;
    params->sincrf_tbp = kschemsat_sinc_tbp;
  } else {
    params->sincrf_bw = KS_NOTSET;
    params->sincrf_tbp = KS_NOTSET;
  }

  /* Spoiler */
  params->spoilerarea = kschemsat_spoilerarea;

  /* SSI time */
  params->ssi_time = kschemsat_ssi_time;

} /* kschemsat_eval_copycvs() */




/**
 *******************************************************************************************************
 @brief #### Sets up the sequence objects for the chemsat sequence module (KSCHEMSAT_SEQUENCE kschemsat)

 This fatsat sequence module consists of an RF pulse (selectable via `.params.rftype` and a spoiler
 trapezoid gradient.

 @param[in,out] kschemsat Pointer to KSCHEMSAT_SEQUENCE
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS kschemsat_eval_setupobjects(KSCHEMSAT_SEQUENCE *kschemsat) {
  STATUS status;

  kschemsat_rfoffset = 0;
  if (opfat) {
    kschemsat_flag = KSCHEMSAT_FAT;
    kschemsat_rfoffset = -(float) SDL_GetChemicalShift(cffield);
  } else if (opwater) {
    kschemsat_flag = KSCHEMSAT_WATER;
  } else {
    kschemsat_flag = KSCHEMSAT_OFF;
  }

  if (cffield == 30000) {
    kschemsat_sinc_bw = KSCHEMSAT_DEFAULT_SINCRF_BW_3T;
  } else {
    kschemsat_sinc_bw = KSCHEMSAT_DEFAULT_SINCRF_BW_15T;
  }

  /* Fill in the struct kschemsat.sequence.params based on corresponding kschemsat_*** CVs (see CV section)
     The CVs should only be used to steer the content of field .params, which in turn should control further decisions */
  kschemsat_eval_copycvs(&kschemsat->params);

  if (kschemsat->params.satmode == KSCHEMSAT_OFF) {
    kschemsat_init_sequence(kschemsat);
    return SUCCESS;
  }

  /* RF */
  if (kschemsat->params.rftype == KSCHEMSAT_RF_SINC) {
    /* create a KS_RF using ks_eval_rf_sinc */
    status = ks_eval_rf_sinc(&kschemsat->rf, "kschemsat_rf", kschemsat->params.sincrf_bw, kschemsat->params.sincrf_tbp, kschemsat->params.flip, KS_RF_SINCWIN_HAMMING);
    if (status != SUCCESS) return status;
    kschemsat->rf.role = KS_RF_ROLE_CHEMSAT;
  } else {
    if (cffield == 30000)
      kschemsat->rf = chemsat_cs3t; /* KSFoundation_GERF.h */
    else
      kschemsat->rf = chemsat_csm; /* KSFoundation_GERF.h */
    kschemsat->rf.flip = kschemsat->params.flip;
    if (ks_eval_rf(&kschemsat->rf, "kschemsat_rf") == FAILURE)
      return FAILURE;
  }
  kschemsat->rf.cf_offset = kschemsat->params.rfoffset; /* Exciter offset in Hz */

  /* ks_print_rf(kschemsat->rf, stderr); fflush(stderr); */

  /* set up spoiler */
  kschemsat->spoiler.area = kschemsat->params.spoilerarea;
  status = ks_eval_trap(&kschemsat->spoiler, "kschemsat_spoiler");
  if (status != SUCCESS) return status;


  /* setup seqctrl with desired SSI time and zero duration. .min_duration will be set in kschemsat_pg() */
  ks_init_seqcontrol(&kschemsat->seqctrl);
  strcpy(kschemsat->seqctrl.description, "kschemsat");

  return SUCCESS;

} /* kschemsat_eval_setupobjects() */





/**
 *******************************************************************************************************
 @brief #### Chemsat evaluation function, to be called from the cveval() function of the main sequence

 This function calls kschemsat_eval_setupobjects() to design the RF pulse and spoiler for this fatsat
 sequence module. It then calls kschemsat_pg() to determine the (minimum) sequence module duration.
 Finally, the sequence module `kschemsat` is added to the sequence collection struct passed in from the
 cveval() function of the main sequence.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS kschemsat_eval(KS_SEQ_COLLECTION *seqcollection) {
  STATUS status;

  /* N.B.:
    - UI CV opfat = 1: FatSat (kschemsat_flag = KSCHEMSAT_FAT)
    - UI CV opwater = 1: WaterSat (kschemsat_flag = KSCHEMSAT_WATER)
    - UI CV opfat = opwater = 0: Off
  */
  status = kschemsat_eval_setupobjects(&kschemsat);
  if (status != SUCCESS) return status;

  /* kschemsat_pg() will return early if kschemsat.params.satmode == KSCHEMSAT_OFF => kschemsat.seqctrl.duration = 0 */
  status = kschemsat_pg(&kschemsat);
  if (status != SUCCESS) return status;

  /* ks_eval_addtoseqcollection() will only add to collection if kschemsat.seqctrl.duration > 0 */
  status = ks_eval_addtoseqcollection(seqcollection, &kschemsat.seqctrl);
  if (status != SUCCESS) return status;

  return status;

} /* kschemsat_eval() */




@pg
/*******************************************************************************************************
*******************************************************************************************************
*
*  KSChemSat.e: PULSEGEN functions
*                Accessible on TGT, and also HOST if UsePgenOnHost() in the Imakefile
*
*******************************************************************************************************
*******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### The kschemsat (fatsat) pulse sequence module

 This is the fatsat sequence module in kschemsat.e using the sequence objects in KSCHEMSAT_SEQUENCE with
 the sequence module name "kschemsat" (= kschemsat.seqctrl.description). On HOST, the minimum duration
 of the sequence module is set by ks_eval_seqctrl_setminduration().

 @param[in,out] kschemsat Pointer to KSCHEMSAT_SEQUENCE
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS kschemsat_pg(KSCHEMSAT_SEQUENCE *kschemsat) {
  STATUS status;
  KS_SEQLOC loc = KS_INIT_SEQLOC;
  loc.pos = RUP_GRD(KS_RFSSP_PRETIME + 32);

  /* return early if sat mode is off */
  if (kschemsat->params.satmode == KSCHEMSAT_OFF) {
    return SUCCESS;
  }

#ifdef IPG
  /* TGT (IPG) only: return early if sequence module duration is zero */
  if (kschemsat->seqctrl.duration == 0)
    return SUCCESS;
#endif

  /* RF */
  status = ks_pg_rf(&kschemsat->rf, loc, &kschemsat->seqctrl);
  if (status != SUCCESS) return status;

  loc.pos += kschemsat->rf.rfwave.duration;

  /* Y spoiler */
  loc.board = YGRAD;
  status = ks_pg_trap(&kschemsat->spoiler, loc, &kschemsat->seqctrl);
  if (status != SUCCESS) return status;

  /* Z spoiler */
  loc.board = ZGRAD;
  status = ks_pg_trap(&kschemsat->spoiler, loc, &kschemsat->seqctrl);
  if (status != SUCCESS) return status;

  loc.pos += kschemsat->spoiler.duration;

 /*******************************************************************************************************
   *  Set the minimal sequence duration (ksspsat->seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  loc.pos = RUP_GRD(loc.pos);

#ifdef HOST_TGT
  /* HOST only: Sequence duration (kschemsat->seqctrl.ssi_time must be > 0 and is added to kschemsat->seqctrl.min_duration in ks_eval_seqctrl_setminduration()
     if kschemsat->params.satmode = KSCHEMSAT_OFF, then 2nd arg will be zero, making both kschemsat->seqctrl.min_duration and .duration = 0 */
  kschemsat->seqctrl.ssi_time = kschemsat->params.ssi_time;
  ks_eval_seqctrl_setminduration(&kschemsat->seqctrl, loc.pos); /* loc.pos now corresponds to the end of last gradient in the sequence */
#endif

  return SUCCESS;

} /* kschemsat_pg() */




/**
 *******************************************************************************************************
 @brief #### Sets the current state of all kschemsat sequence objects being part of KSCHEMSAT_SEQUENCE

 This function sets the current state of all kschemsat sequence objects being part of KSCHEMSAT_SEQUENCE,
 incl. gradient amplitude and RF phase changes.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more.

 @return void
********************************************************************************************************/
void kschemsat_scan_seqstate(KSCHEMSAT_SEQUENCE *kschemsat) {
#ifdef IPG
  static int counter = 0;

  float rfphase = ks_scan_rf_phase_spoiling(counter++);

  ks_scan_rf_setphase(&kschemsat->rf, INSTRALL, rfphase);

#endif
}


