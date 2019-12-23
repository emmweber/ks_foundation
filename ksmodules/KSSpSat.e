/*******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : KSSpSat.e
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
* @file KSSpSat.e
* @brief This file contains Spatial Sat and should be `@inline`'d at the beginning of a KSFoundation PSD
********************************************************************************************************/

@global
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSSpSat.e: Global section
 *
 *******************************************************************************************************
 *******************************************************************************************************/

enum {KSSPSAT_OFF, KSSPSAT_IMPLICIT, KSSPSAT_EXPLICIT};
enum {KSSPSAT_1, KSSPSAT_2, KSSPSAT_3, KSSPSAT_4, KSSPSAT_5, KSSPSAT_6, KSSPSAT_MAXNUMSAT};
enum {KSSPSAT_NEG=1, KSSPSAT_POS, KSSPSAT_HAD, KSSPSAT_PARA};
enum {KSSPSAT_RF_STD, KSSPSAT_RF_COMPLEX, KSSPSAT_RF_MAXRFTYPES};

#define KSSPSAT_MODULE_LOADED /* can be used to check whether the KSSpsat module has been included in a main psd */

#define KSSPSAT_DEFAULT_FLIP 95
#define KSSPSAT_DEFAULT_SPOILERSCALE 5.0
#define KSSPSAT_DEFAULT_SPOILALLAXES 1
#define KSSPSAT_DEFAULT_SSITIME 1000 /* try to reduce this value */

#define KSSPSAT_EXPLICITSAT_DISABLED 9990.0 /* Set by UI on MR-scanner */
#define KSSPSAT_IMPLICITSAT_DISABLED 9999.0 /* Set by UI on MR-scanner */

/** @brief #### `typedef struct` holding information about the prescribed FOV border (3D)
*/
typedef struct _KSSPSAT_VOLBORDER {
  float freq_min;
  float freq_max;
  float phase_min;
  float phase_max;
  float slice_min;
  float slice_max;
} KSSPSAT_VOLBORDER;
#define KSSPSAT_INIT_VOLBORDER {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}


/** @brief #### `typedef struct` holding information about one spatial saturation pulse location and thickness
*/
typedef struct _KSSPSAT_LOC {
  SCAN_INFO loc; /* .optloc [mm], .oprot */
  float thickness; /* [mm] */
  int gradboard; /* XGRAD, YGRAD, ZGRAD */
  int active; /* KSSPSAT_OFF, KSSPSAT_IMPLICIT, KSSPSAT_EXPLICIT */
} KSSPSAT_LOC;
#define KSSPSAT_INIT_LOC {DEFAULT_AXIAL_SCAN_INFO, 0, KS_NOTSET, KSSPSAT_OFF}

/** @brief #### `typedef struct` holding steering parameters for KSSpSat
*/
typedef struct _KSSPSAT_PARAMS {
  KSSPSAT_VOLBORDER volborder;
  float flip;
  int rftype;
  float spoilerscale; /* scale factor for postgrad spoiler for each selrf (ksspsat.selrf[i].crusherscale) */
  int spoilallaxes;
  int oblmethod;
  int ssi_time;
} KSSPSAT_PARAMS;
#define KSSPSAT_INIT_PARAMS {KSSPSAT_INIT_VOLBORDER, KSSPSAT_DEFAULT_FLIP, KSSPSAT_RF_COMPLEX, KSSPSAT_DEFAULT_SPOILERSCALE, KSSPSAT_DEFAULT_SPOILALLAXES, PSD_OBL_RESTRICT, KSSPSAT_DEFAULT_SSITIME}


/** @brief #### `typedef struct` holding all all gradients and waveforms for the KSSpSat sequence module
*/
typedef struct _KSSPSAT_SEQUENCE {
  KS_BASE base;
  KS_SEQ_CONTROL seqctrl;
  KSSPSAT_LOC satlocation;
  KS_SELRF selrf;
} KSSPSAT_SEQUENCE;
#define KSSPSAT_INIT_SEQUENCE {{0,0,NULL,sizeof(KSSPSAT_SEQUENCE)}, KS_INIT_SEQ_CONTROL, KSSPSAT_INIT_LOC, KS_INIT_SELRF}


/* Function prototypes */
int ksspsat_pg(KSSPSAT_SEQUENCE *ksspsat);
void ksspsat_scan_seqstate(KSSPSAT_SEQUENCE *ksspsat, float rfphase);



@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSSpSat.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

KSSPSAT_SEQUENCE ksspsat[KSSPSAT_MAXNUMSAT] = {KSSPSAT_INIT_SEQUENCE, KSSPSAT_INIT_SEQUENCE, KSSPSAT_INIT_SEQUENCE, KSSPSAT_INIT_SEQUENCE, KSSPSAT_INIT_SEQUENCE, KSSPSAT_INIT_SEQUENCE};
KSSPSAT_PARAMS ksspsat_params = KSSPSAT_INIT_PARAMS;



@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSSpSat.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
int ksspsat_flag = KSSPSAT_OFF with {KSSPSAT_OFF, KSSPSAT_EXPLICIT, KSSPSAT_OFF, VIS, "flag for ksspsat (0:Off 1:Implicit 2:Explicit)",};
float ksspsat_flip = KSSPSAT_DEFAULT_FLIP with {0, 360, KSSPSAT_DEFAULT_FLIP, VIS, "RF flip angle [deg]",};
int ksspsat_rftype = KSSPSAT_RF_COMPLEX with {KSSPSAT_RF_STD, KSSPSAT_RF_COMPLEX, KSSPSAT_RF_COMPLEX, VIS, "0: SLR Sat 1: Complex Sat",};
float ksspsat_spoilerscale = KSSPSAT_DEFAULT_SPOILERSCALE with {0.0, 20.0, KSSPSAT_DEFAULT_SPOILERSCALE, VIS, "scaling of spoiler gradient area",};
int ksspsat_spoilallaxes = KSSPSAT_DEFAULT_SPOILALLAXES with {0.0, 1.0, KSSPSAT_DEFAULT_SPOILALLAXES, VIS, "apply spoiler on all axes",};
int ksspsat_ssi_time = KSSPSAT_DEFAULT_SSITIME with {10, 20000, KSSPSAT_DEFAULT_SSITIME, VIS, "Time from eos to ssi in intern trig",};
int ksspsat_debug = 0 with {0, 1, 0, VIS, "KSSpSat debug flag",};
int ksspsat_oblmethod = PSD_OBL_RESTRICT with {PSD_OBL_RESTRICT, PSD_OBL_OPTIMAL, PSD_OBL_RESTRICT, VIS, "obl. grad optimization for sat",};


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSSpSat.e: HOST functions and variables
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Resets the KSSPSAT_PARAMS struct (arg 1) to KSSPSAT_INIT_PARAMS
 @param[out] params Pointer to the ksspsat params struct used to steer the behavior of this spsat
                    sequence module
 @return void
********************************************************************************************************/
void ksspsat_init_params(KSSPSAT_PARAMS *params) {
  KSSPSAT_PARAMS defparams = KSSPSAT_INIT_PARAMS;
  *params = defparams;
}



/**
 *******************************************************************************************************
 @brief #### Resets the KSSPSAT_SEQUENCE struct (arg 1) to KSSPSAT_INIT_SEQUENCE

 As KSSPSAT_INIT_SEQUENCE contains KSSPSAT_PARAMS, which sets the field `.satmode = KSSPSAT_OFF`,
 calling ksspsat_init_sequence() will disable the `ksspsat` sequence module (i.e. turn off spsat)

 @param[out] ksspsat Pointer to KSSPSAT_SEQUENCE
 @return void
********************************************************************************************************/
void ksspsat_init_sequence(KSSPSAT_SEQUENCE *ksspsat) {
  KSSPSAT_SEQUENCE defseq = KSSPSAT_INIT_SEQUENCE;
  *ksspsat = defseq;
  strcpy(ksspsat->seqctrl.description, "ksspsat");
} /* ksspsat_init_sequence() */




/**
 *******************************************************************************************************
 @brief #### Copy CVs into a common params struct (KSSPSAT_PARAMS) used to steer this sequence module

 @param[out] params Pointer to the ksspsat params struct used to steer the behavior of this spsat
                    sequence module
 @return void
********************************************************************************************************/
void ksspsat_eval_copycvs(KSSPSAT_PARAMS *params) {

  /* RF */
  params->flip = ksspsat_flip;
  params->rftype = ksspsat_rftype;

  /* SELRF postgrad (acting as spoiler after each SAT RF) */
  params->spoilerscale = ksspsat_spoilerscale;

  params->ssi_time = ksspsat_ssi_time;

  params->oblmethod = ksspsat_oblmethod;

} /* ksspsat_eval_copycvs() */



/**
 *******************************************************************************************************
 @brief #### Get number of Graphical (GRx) Sat pulses that are active in the UI

 This function returns the number of graphical saturation pulses that have been explicitly placed out
 in the UI by the user. This includes both implicit and explicit sat bands. *Implicit* sat bands occur
 when the user selects a sat edge (S,I,A,P,R,L) of the FOV but does not click on the localizer image.
 Implicit sat bands are parallel to the logical axes and do not need a unique rotation matrix, and which
 FOV side to saturate is determined by the logical gradient axis choice (XGRAD, YGRAD, ZGRAD).

 @param[in] ksspsat Pointer to KSSPSAT_SEQUENCE
 @return numsats Number of GRx Sat pulses active in the UI
********************************************************************************************************/
int ksspsat_eval_numsats(KSSPSAT_SEQUENCE *ksspsat) {
  int i;
  int n = 0;

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++)
    n += ksspsat[i].satlocation.active != KSSPSAT_OFF;

  return n;

} /* ksspsat_eval_numsats() */


/**
 *******************************************************************************************************
 @brief #### Get the FOV volume borders in mm from the isocenter

 @param[out] v Pointer to the KSSPSAT_VOLBORDER struct holding this information
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval_volborder(KSSPSAT_VOLBORDER *v) {
  int i, nslices;

  if (KS_3D_SELECTED)
    nslices = exist(opslquant) * exist(opvquant);
  else
    nslices = exist(opslquant);

  v->freq_min = scan_info[0].oprloc;
  v->freq_max = scan_info[0].oprloc;
  v->phase_min = scan_info[0].opphasoff;
  v->phase_max = scan_info[0].opphasoff;
  v->slice_min = scan_info[0].optloc;
  v->slice_max = scan_info[0].optloc;

  for (i = 1; i < nslices; i++) {
    if (scan_info[i].oprloc > v->freq_max)
      v->freq_max = scan_info[i].oprloc;
    else if (scan_info[i].oprloc < v->freq_min)
      v->freq_min = scan_info[i].oprloc;

    if (scan_info[i].opphasoff > v->phase_max)
      v->phase_max = scan_info[i].opphasoff;
    else if (scan_info[i].opphasoff < v->phase_min)
      v->phase_min = scan_info[i].opphasoff;

    if (scan_info[i].optloc > v->slice_max)
      v->slice_max = scan_info[i].optloc;
    else if (scan_info[i].optloc < v->slice_min)
      v->slice_min = scan_info[i].optloc;
  }

  v->freq_min -= exist(opfov) / 2.0;
  v->freq_max += exist(opfov) / 2.0;
  v->phase_min -= (exist(opfov) * exist(opphasefov)) / 2.0;
  v->phase_max += (exist(opfov) * exist(opphasefov)) / 2.0;
  v->slice_min -= exist(opslthick) / 2.0;
  v->slice_max += exist(opslthick) / 2.0;

  return SUCCESS;

} /* ksspsat_eval_volborder() */




/**
 *******************************************************************************************************
 @brief #### Populate the `satlocation` field of the KSSPSAT_PARAMS struct

 This function gets information from the UI regarding the sat pulses, whether they are implicit or
 explicit, their thickness and offset, and for explicit pulses also the rotation matrix.

 The user can select up to 6 sat band in total in the UI, which may be only implicit or explicit, or a
 mix of both. First, information on the implicit sat pulses is collected by checking for the CVs `opsatx`
 etc. (managed by the host interface, i.e. the UI). The UI maps `opsatx` to frequency encoding (despite
 that the sat is expressed in patient terms: Superior, Inferior, etc.), and correspondingly `opsaty` maps
 to the phase encoding direction and `opsatz` to the slice direction.

 When two oppositely placed implicit sat bands have different thickness, `opsatx` (and `opsaty`/`opsatz`)
 is set to KSSPSAT_PARA (4), indicating that two separate RF pulses should be played out. When two
 oppositely placed implicit sat bands have the same thickness, `opsatx` = KSSPSAT_HAD (3), which is an
 indication for that a single hadamard RF pulse should be used to saturate both sides. This is not yet
 supported, so for now both KSSPSAT_HAD and KSSPSAT_PARA will result in two separate RF pulses.

 If the user selects one of the sat band buttons (S,I,A,P,R,L), and then also clicks on the localizer
 image, the implicit sat (one of S,I,A,P,R,L) is now replaced with an explicit sat. The UI sets then the
 corresponding `opsatx/y/z` to 0, and sets instead one of the bits in the bitmask CV `opexsatmask`.

 Explicit sat bands receives the rotation information from the transpose of `eg_sat_rot` instead of the
 `scan_info` struct, slice selection is always ZGRAD, the thickness is taken from `opexsatthick1-6`, and
 the slice offset from `opexsatloc1-6`.

 @param[in,out] ksspsat Pointer to KSSPSAT_SEQUENCE
 @param[in] params Pointer to the ksspsat params struct used to steer the behavior of this spsat
                    sequence module
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval_satplacements_from_UI(KSSPSAT_SEQUENCE *ksspsat, KSSPSAT_PARAMS *params) {
  STATUS status;
  int i, j;
  float sat_info[6][9];


  /***************** IMPLICIT SAT (at the FOV edges) *****************/


  /* Determine FOV box */
  status = ksspsat_eval_volborder(&params->volborder);
  if (status != SUCCESS) return status;

  /* Init all sat bands to off state */
  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++)
    ksspsat[i].satlocation.active = KSSPSAT_OFF;

  /* Init all sat rotations to scan plane */
  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++)
    memcpy(ksspsat[i].satlocation.loc.oprot, scan_info[0].oprot, 9 * sizeof(float));

  /* Implicit sat thicknesses */
  ksspsat[KSSPSAT_1].satlocation.thickness = (float) exist(opdfsathick1);
  ksspsat[KSSPSAT_2].satlocation.thickness = (float) exist(opdfsathick2);
  ksspsat[KSSPSAT_3].satlocation.thickness = (float) exist(opdfsathick3);
  ksspsat[KSSPSAT_4].satlocation.thickness = (float) exist(opdfsathick4);
  ksspsat[KSSPSAT_5].satlocation.thickness = (float) exist(opdfsathick5);
  ksspsat[KSSPSAT_6].satlocation.thickness = (float) exist(opdfsathick6);


  /* Implicit Sat(s) - Frequency encoding direction */
  if (opsatx == KSSPSAT_POS || opsatx == KSSPSAT_PARA || opsatx == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_2].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_2].satlocation.loc.optloc = params->volborder.freq_max + ksspsat[KSSPSAT_2].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_2].satlocation.gradboard = XGRAD;
  }
  if (opsatx == KSSPSAT_NEG || opsatx == KSSPSAT_PARA || opsatx == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_1].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_1].satlocation.loc.optloc = params->volborder.freq_min - ksspsat[KSSPSAT_1].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_1].satlocation.gradboard = XGRAD;
  }

  /* Implicit Sat(s) - Phase encoding direction */
  if (opsaty == KSSPSAT_POS || opsaty == KSSPSAT_PARA || opsaty == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_4].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_4].satlocation.loc.optloc = params->volborder.phase_max + ksspsat[KSSPSAT_4].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_4].satlocation.gradboard = YGRAD;
  }
  if (opsaty == KSSPSAT_NEG || opsaty == KSSPSAT_PARA || opsaty == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_3].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_3].satlocation.loc.optloc = params->volborder.phase_min - ksspsat[KSSPSAT_3].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_3].satlocation.gradboard = YGRAD;
  }

  /* Implicit Sat(s) - Slice direction */
  if (opsatz == KSSPSAT_POS || opsatz == KSSPSAT_PARA || opsatz == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_6].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_6].satlocation.loc.optloc = params->volborder.slice_max + ksspsat[KSSPSAT_6].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_6].satlocation.gradboard = ZGRAD;
  }
  if (opsatz == KSSPSAT_NEG || opsatz == KSSPSAT_PARA || opsatz == KSSPSAT_HAD) {
    ksspsat[KSSPSAT_5].satlocation.active = KSSPSAT_IMPLICIT;
    ksspsat[KSSPSAT_5].satlocation.loc.optloc = params->volborder.slice_min - ksspsat[KSSPSAT_5].satlocation.thickness / 2.0;
    ksspsat[KSSPSAT_5].satlocation.gradboard = ZGRAD;
  }



  /***************** EXPLICIT SAT (manually placed) *****************/


  /* matrix transpose */
  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {
    sat_info[i][0] = eg_sat_rot[i][0];
    sat_info[i][1] = eg_sat_rot[i][3];
    sat_info[i][2] = eg_sat_rot[i][6];
    sat_info[i][3] = eg_sat_rot[i][1];
    sat_info[i][4] = eg_sat_rot[i][4];
    sat_info[i][5] = eg_sat_rot[i][7];
    sat_info[i][6] = eg_sat_rot[i][2];
    sat_info[i][7] = eg_sat_rot[i][5];
    sat_info[i][8] = eg_sat_rot[i][8];
  }

  int exsat_mask = 1;
  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++, exsat_mask = exsat_mask << 1) {

    /* 0-5: I, S, P, A, L, R */
    if (opexsatmask & exsat_mask) {

      int freeslot = KS_NOTSET;

      for (j = 0; j < KSSPSAT_MAXNUMSAT; j++) {
        if (ksspsat[j].satlocation.active == KSSPSAT_OFF) {
          freeslot = j;
          break;
        }
      }
      if (freeslot == KS_NOTSET) {
        return ks_error("%s: No free slots for explicit sat", __FUNCTION__);
      }

      /* mark as explicit sat */
      ksspsat[freeslot].satlocation.active = KSSPSAT_EXPLICIT;

      /* copy rotation matrix from sat_info[][] array set up by the host interface (not the psd) */
      memcpy(ksspsat[freeslot].satlocation.loc.oprot, sat_info[i], 9 * sizeof(float));

      /* Always ZGRAD since we are setting the slice angle via the rotation matrix for explicit sat */
      ksspsat[freeslot].satlocation.gradboard = ZGRAD;

      /* Transmit location and thickness from CVs set by the host interface (not the psd) */
      if (i == KSSPSAT_1) {
        ksspsat[freeslot].satlocation.thickness = opexsathick1;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc1;
      } else if (i == KSSPSAT_2) {
        ksspsat[freeslot].satlocation.thickness = opexsathick2;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc2;
      } else if (i == KSSPSAT_3) {
        ksspsat[freeslot].satlocation.thickness = opexsathick3;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc3;
      } else if (i == KSSPSAT_4) {
        ksspsat[freeslot].satlocation.thickness = opexsathick4;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc4;
      } else if (i == KSSPSAT_5) {
        ksspsat[freeslot].satlocation.thickness = opexsathick5;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc5;
      } else if (i == KSSPSAT_6) {
        ksspsat[freeslot].satlocation.thickness = opexsathick6;
        ksspsat[freeslot].satlocation.loc.optloc = opexsatloc6;
      }

    }
  }


  return SUCCESS;

} /* ksspsat_eval_satplacements_from_UI() */




/**
 *******************************************************************************************************
 @brief #### Writes out the geometric information of the active sat bands to `spsat.txt`

 On the MR system (PSD_HW), this file will be located in `/usr/g/mrraw`, while in simulation it will be
 located in the current psd directory.

 @param[in] ksspsat Pointer to KSSPSAT_SEQUENCE
 @param[in] params Pointer to the ksspsat params struct used to steer the behavior of this spsat
                    sequence module
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval_satplacements_dump(KSSPSAT_SEQUENCE *ksspsat, KSSPSAT_PARAMS *params) {
  float *rot;
  int i;

#ifdef PSD_HW
  FILE *fp = fopen("/usr/g/mrraw/spsat.txt", "w");
#else
  FILE *fp = fopen("./spsat.txt", "w");
#endif

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {
    fprintf(fp, "Sat Pulse #%d: ", i);
    if (ksspsat[i].satlocation.active == KSSPSAT_OFF)
      fprintf(fp, "Off\n");
    else if (ksspsat[i].satlocation.active == KSSPSAT_EXPLICIT)
      fprintf(fp, "Explicit\n");
    else if (ksspsat[i].satlocation.active == KSSPSAT_IMPLICIT)
      fprintf(fp, "Implicit\n");

    fprintf(fp, "Grad: ");
    if (ksspsat[i].satlocation.gradboard == XGRAD)
      fprintf(fp, "XGRAD (Freq)");
    else if (ksspsat[i].satlocation.gradboard == YGRAD)
      fprintf(fp, "YGRAD (Phase)");
    else if (ksspsat[i].satlocation.gradboard == ZGRAD)
      fprintf(fp, "ZGRAD (Slice)");

    fprintf(fp, "\nThickness: %.2f\n", ksspsat[i].satlocation.thickness);
    fprintf(fp, "Location: %.2f\n", ksspsat[i].satlocation.loc.optloc);

    rot = ksspsat[i].satlocation.loc.oprot;
    fprintf(fp, "Rotation:\n");
    fprintf(fp, "%.3f %.3f %.3f\n%.3f %.3f %.3f\n%.3f %.3f %.3f\n\n", rot[0], rot[3], rot[6], rot[1], rot[4], rot[7], rot[2], rot[5], rot[8]);
  }

  fprintf(fp, "Volume borders:\n-  Freq: %.2f %.2f\n- Phase: %.2f %.2f\n- Slice: %.2f %.2f\n", params->volborder.freq_min, params->volborder.freq_max, params->volborder.phase_min, params->volborder.phase_max, params->volborder.slice_min, params->volborder.slice_max);

  rot = scan_info[0].oprot;
  fprintf(fp, "\nSlice rotation:\n");
  fprintf(fp, "%.3f %.3f %.3f\n%.3f %.3f %.3f\n%.3f %.3f %.3f\n\n", rot[0], rot[3], rot[6], rot[1], rot[4], rot[7], rot[2], rot[5], rot[8]);



  fclose(fp);

  return SUCCESS;

}




/**
 *******************************************************************************************************
 @brief #### Assigns a loggrd structure specific to the spatial saturation sequence module

 @param[out] satloggrd Pointer to LOG_GRAD
 @param[in] slice_info Pointer to SCAN_INFO, holding rotation information about current sat slice
 @param[in] satoblmethod PSD_OBL_RESTRICT or PSD_OBL_OPTIMAL
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval_loggrd(LOG_GRAD *satloggrd, SCAN_INFO *slice_info, int satoblmethod) {
  int initnewgeo = 1;

  /* copy loggrd from GERequired.e */
  *satloggrd = loggrd;

  if (obloptimize(satloggrd, &phygrd, slice_info, 1, ((satoblmethod == PSD_OBL_RESTRICT) ? 4 /*oblique plane*/ : opphysplane), exist(opcoax),
                  (int) satoblmethod, exist(obl_debug), &initnewgeo, cfsrmode) == FAILURE) {
    return ks_error("%s: obloptimize failed", __FUNCTION__);
  }

  return SUCCESS;

}




/**
 *******************************************************************************************************
 @brief #### Sets up the sequence objects for the spatial sat sequence module (KSSPSAT_SEQUENCE ksspsat)

 This spatial sat sequence module consists of an RF pulse (selectable via `ksspsat_params.rftype`.

 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval_setupobjects() {
  STATUS status;
  int i;

  status = ksspsat_eval_satplacements_from_UI(ksspsat, &ksspsat_params);
  if (status != SUCCESS) return status;

  if (ksspsat_debug) {
    status = ksspsat_eval_satplacements_dump(ksspsat, &ksspsat_params);
    if (status != SUCCESS) return status;
  }

  /* Fill in the struct ksspsat_params based on corresponding ksspsat_*** CVs (see CV section)
     The CVs should only be used to steer the content of field .params, which in turn should control further decisions */
  ksspsat_eval_copycvs(&ksspsat_params);

  if (! ksspsat_eval_numsats(ksspsat)) {
    return SUCCESS;
  }

  /* up to 6 (KSSPSAT_MAXNUMSAT) selective RF pulses */
  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {

    if (ksspsat[i].satlocation.active != KSSPSAT_OFF) {    
      char tmpstr[100];
      if (ksspsat_params.rftype == KSSPSAT_RF_COMPLEX) {
        ksspsat[i].selrf.rf = spsatc_satqptbw12; /* Complex Sat RF pulse. KSFoundation_GERF.h */
      } else {
        ksspsat[i].selrf.rf = spsat_dblsatl0; /* SLR Sat RF pulse. KSFoundation_GERF.h */
      }
      ksspsat[i].selrf.rf.flip = ksspsat_params.flip;
      ksspsat[i].selrf.slthick = ksspsat[i].satlocation.thickness;
      ksspsat[i].selrf.crusherscale = ksspsat_params.spoilerscale; /* as rf role is KS_RF_ROLE_SPSAT, only postgrad will be active */
      sprintf(tmpstr, "ksspsat%d_selrf", i+1);

      /* obloptimize sat (satloggrd declared in epic.h) */
      ksspsat_eval_loggrd(&satloggrd, &ksspsat[i].satlocation.loc, ksspsat_params.oblmethod);

      if (ks_eval_selrf_constrained(&ksspsat[i].selrf, tmpstr, ks_syslimits_ampmax(satloggrd), ks_syslimits_slewrate(satloggrd)) == FAILURE)
        return FAILURE;


      /* setup seqctrl with desired SSI time and zero duration. .min_duration will be set in ksspsat_pg() */
      ks_init_seqcontrol(&ksspsat->seqctrl);
      sprintf(tmpstr, "ksspsat%d", i+1);
      strcpy(ksspsat[i].seqctrl.description, tmpstr);

    } /* if active */


  } /* for KSSPSAT_MAXNUMSAT */


  return SUCCESS;

} /* ksspsat_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Spatial Sat evaluation function, to be called from the cveval() function of the main sequence

 This function calls ksspsat_eval_setupobjects() to design the RF pulse and spoiler for this spatial sat
 sequence module. It then calls ksspsat_pg() to determine the (minimum) sequence module duration.
 Finally, the sequence module `ksspsat` is added to the sequence collection struct passed in from the
 cveval() function of the main sequence.

 @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_eval(KS_SEQ_COLLECTION *seqcollection) {
  STATUS status;
  int i;

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {
    ksspsat_init_sequence(&ksspsat[i]);
  }

  status = ksspsat_eval_setupobjects();
  if (status != SUCCESS) return status;

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {

    if (ksspsat[i].satlocation.active != KSSPSAT_OFF) {

      status = ksspsat_pg(&ksspsat[i]);
      if (status != SUCCESS) return status;

      /* ks_eval_addtoseqcollection() will only add to collection if ksspsat.seqctrl.duration > 0 */
      status = ks_eval_addtoseqcollection(seqcollection, &ksspsat[i].seqctrl);
      if (status != SUCCESS) return status;

    } /* if active */

  }

  return status;

} /* ksspsat_eval() */




@pg
/*******************************************************************************************************
*******************************************************************************************************
*
*  KSSpSat.e: PULSEGEN functions
*                Accessible on TGT, and also HOST if UsePgenOnHost() in the Imakefile
*
*******************************************************************************************************
*******************************************************************************************************/








/**
 *******************************************************************************************************
 @brief #### The ksspsat (spatial sat) pulse sequence module

 This is the spatial sat sequence module in ksspsat.e using the sequence objects in KSSPSAT_SEQUENCE with
 the sequence module name "ksspsat" (= ksspsat.seqctrl.description). On HOST, the minimum duration
of the sequence module is set by ks_eval_seqctrl_setminduration().

@param[in, out] ksspsat Pointer to KSSPSAT_SEQUENCE
@retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksspsat_pg(KSSPSAT_SEQUENCE *ksspsat) {
  STATUS status;
  KS_SEQLOC loc = KS_INIT_SEQLOC;
  loc.pos = RUP_GRD(KS_RFSSP_PRETIME + 32);

  if (ksspsat->satlocation.active == KSSPSAT_OFF) {
    return SUCCESS;
  }

#ifdef IPG
  /* TGT (IPG) only: return early if sequence module duration is zero */
  if (ksspsat->seqctrl.duration == 0)
    return SUCCESS;
#endif

  /* SelRF (including postgrad for spoiler) */
  loc.board = ksspsat->satlocation.gradboard;
  status = ks_pg_selrf(&ksspsat->selrf, loc, &ksspsat->seqctrl);
  if (status != SUCCESS) return status;

  /* Optional spoiling using the postgrad trapezoid on the remaining two axes */
  if (ksspsat_params.spoilallaxes) {
    KS_SEQLOC tmploc = loc;
    tmploc.pos += ksspsat->selrf.grad.duration;
    switch (ksspsat->satlocation.gradboard) {
    case XGRAD:
      tmploc.board = YGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      tmploc.board = ZGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      break;
    case YGRAD:
      tmploc.board = XGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      tmploc.board = ZGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      break;
    case ZGRAD:
      tmploc.board = XGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      tmploc.board = YGRAD; status = ks_pg_trap(&ksspsat->selrf.postgrad, tmploc, &ksspsat->seqctrl); if (status != SUCCESS) return status;
      break;
    }
  }

  loc.pos += ksspsat->selrf.grad.duration + ksspsat->selrf.postgrad.duration + KS_RFSSP_POSTTIME;

 /*******************************************************************************************************
   *  Set the minimal sequence duration (ksspsat->seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  /* make sure we are divisible by GRAD_UPDATE_TIME (4us) */
  loc.pos = RUP_GRD(loc.pos);

#ifdef HOST_TGT
  /* HOST only: Sequence duration (ksspsat->seqctrl.ssi_time must be > 0 and is added to ksspsat->seqctrl.min_duration in ks_eval_seqctrl_setminduration()
     if ksspsat_params.satmode = KSSPSAT_OFF, then 2nd arg will be zero, making both ksspsat->seqctrl.min_duration and .duration = 0 */
  ksspsat->seqctrl.ssi_time = ksspsat_params.ssi_time;
  ks_eval_seqctrl_setminduration(&ksspsat->seqctrl, loc.pos); /* loc.pos now corresponds to the end of last gradient in the sequence */
#endif

  return SUCCESS;

} /* ksspsat_pg() */



STATUS ksspsat_pulsegen() {
  int i;

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {
    if (ksspsat[i].satlocation.active != KSSPSAT_OFF) {

      ksspsat_pg(&ksspsat[i]);

      switch (i) {
      case KSSPSAT_1:
        KS_SEQLENGTH(seqKSSpSat1, ksspsat[i].seqctrl);
        break;
      case KSSPSAT_2:
        KS_SEQLENGTH(seqKSSpSat2, ksspsat[i].seqctrl);
        break;
      case KSSPSAT_3:
        KS_SEQLENGTH(seqKSSpSat3, ksspsat[i].seqctrl);
        break;
      case KSSPSAT_4:
        KS_SEQLENGTH(seqKSSpSat4, ksspsat[i].seqctrl);
        break;
      case KSSPSAT_5:
        KS_SEQLENGTH(seqKSSpSat5, ksspsat[i].seqctrl);
        break;
      case KSSPSAT_6:
        KS_SEQLENGTH(seqKSSpSat6, ksspsat[i].seqctrl);
        break;
      }

    }
  }

  return SUCCESS;
}





/**
 *******************************************************************************************************
 @brief #### Sets the current state of all ksspsat sequence objects being part of KSSPSAT_SEQUENCE

 This function sets the current state of all ksspsat sequence objects being part of KSSPSAT_SEQUENCE,
 incl. gradient amplitude changes, RF freq/phase for the current slice position.

 The idea of having a 'seqstate' function is to be able to come back to a certain sequence state at any
 time and possibly play it out once more.

 @return void
********************************************************************************************************/
void ksspsat_scan_seqstate(KSSPSAT_SEQUENCE *ksspsat, float rfphase) {
#ifdef IPG

  if (ksspsat->satlocation.active != KSSPSAT_OFF) {
    ks_scan_rotate(ksspsat->satlocation.loc);
    ks_scan_selrf_setfreqphase(&ksspsat->selrf, 0, ksspsat->satlocation.loc, rfphase);
  }

#endif
}




int ksspsat_scan_playsequences(int perform_slicetimeplot) {
  int i;
  int time = 0;
  static int counter = 0;

  float rfphase = ks_scan_rf_phase_spoiling(counter++);

  for (i = 0; i < KSSPSAT_MAXNUMSAT; i++) {

    ksspsat_scan_seqstate(&ksspsat[i], rfphase);

    time += ks_scan_playsequence(&ksspsat[i].seqctrl);

    if (perform_slicetimeplot) {
      /* spatial sat not necessarily in the slice direction, so can't trust its thickness or direction.
        save it as 1000 mm thick at center (0) for now just to be able to mark it in time in the plot */
      ks_plot_slicetime(&ksspsat[i].seqctrl, 1, NULL, KS_NOTSET, KS_PLOT_STANDARD);
    }

  }

  return time;
}


