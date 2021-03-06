/*
 *  ksgre_tutorial.tgtex.h
 *
 *  Do not edit this file. It is automatically generated by EPIC.
 *
 *  Date : Nov 24 2018
 *  Time : 13:36:59
 */

#ifndef h_ksgre_tutorial_tgtex_h
#define h_ksgre_tutorial_tgtex_h


/*
 *  ipgexport
 *  variables serialized from the host to the target compilation objects
 */

RSP_INFO rsp_info[DATA_ACQ_MAX] = { {0,0,0,0} };
/* changed following 2 parameters from short to int. YH */
long rsprot[TRIG_ROT_MAX][9]= {{0}};    /* rotation matrix for this slice */
long rsptrigger[TRIG_ROT_MAX]= {0};   /* trigger type */

long ipg_alloc_instr[PSD_MAX_PROCESSORS] = {
PSD_GRADX_INSTR_SIZE,
PSD_GRADY_INSTR_SIZE,
PSD_GRADZ_INSTR_SIZE,
PSD_RHO1_INSTR_SIZE,
PSD_RHO2_INSTR_SIZE,
PSD_THETA_INSTR_SIZE,
PSD_OMEGA_INSTR_SIZE,
PSD_SSP_INSTR_SIZE,
PSD_AUX_INSTR_SIZE};


RSP_INFO asrsp_info[3] = { {0,0,0,0} };   /* transmit, receive locations for autoshim */
/* changed from short to in.  YH */
long sat_rot_matrices[SAT_ROT_MAX][9]= {{0}}; /* rotation matrices for sp sat */
int  sat_rot_ex_indices[7]= {0};   /* indices of rotation matrices for explicit sp sat */

/* following parameters are new for 55 */ /* added  YH 10/14/94 */
/* physical gradient characteristics */
/* MRIhc08159: Initializations added */
PHYS_GRAD phygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
/* logical gradient characteristics */
LOG_GRAD  loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
/* logical gradient chars. for graphic sat */
LOG_GRAD satloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
/* logical gradient characteristics */
LOG_GRAD asloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
SCAN_INFO asscan_info[3] = { {0,0,0,0,0,0,0,0,0,{0}} };
/* MRIge43968 (BJM): redefined from long PSrot[10] to the following.. */
/* redefined to long PSrot from int as per CARDIAC34.01 version */
long PSrot[PRESCAN_ROT_MAX][9]= {{0}};             /* prescan rotation matrix */

/* ************************************
   Prescan modification parameter (GE)
   ************************************  */
long PSrot_mod[PRESCAN_ROT_MAX][9]= {{0}};             /* prescan rotation matrix */
 
PHASE_OFF phase_off[DATA_ACQ_MAX] = { {0,0} };
int yres_phase= {0};  /* offset in phase direction in mm */
int yoffs1= {0};  /* intermediate phase offset variable */

/*** RT ***/
/* For use in SpSat.e */
/* storage of original concat sat offsets */
int off_rfcsz_base[DATA_ACQ_MAX]= {0};
/* storage of original matrix location */
SCAN_INFO scan_info_base[1] = { {0,0,0,0,0,0,0,0,0,{0}} };

/* For use in Prescan.e and psds */
/* storage of original x, y, and z offsets */
float xyz_base[DATA_ACQ_MAX][3]= {{0}};
/* storage of original rotation matrices */
long rsprot_base[TRIG_ROT_MAX][9]= {{0}};
/*** End RT ***/

/* Begin RTIA */
int rtia_first_scan_flag = 1 ; 
/* End RTIA */

RSP_PSC_INFO rsp_psc_info[MAX_PSC_VQUANT] = { {0,0,0,{0},0,0,0} };

/*************************************************************************
 * These structures are copy for target side. We will copy from host
 * @reqexport section to @ipgexport section.
 * The COIL_INFO and TX_COIL_INFO is defined                 
 * in /vobs/lx/include/CoilParameters.h
 *************************************************************************/

COIL_INFO coilInfo_tgt[MAX_COIL_SETS] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };

COIL_INFO volRecCoilInfo_tgt[MAX_COIL_SETS] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };

COIL_INFO fullRecCoilInfo_tgt[MAX_COIL_SETS] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };

TX_COIL_INFO txCoilInfo_tgt[MAX_TX_COIL_SETS] = { { 0,0,0,0,0,0,0,0,0,{0},0,0,{0},{0},{0},{0},0 } };

int cframpdir_tgt = 1;
int chksum_rampdir_tgt = 1447292810UL;

SeqCfgInfo seqcfginfo = {0,0,0,0,0,0,{0,0,0,0,0},{{0,0,0,0,0,0,{0,0,0,0}}},{{0,0,{0},0,{0}}},{{0,0,0,0,0,0,0,0}}}; 



/*
 * Copyright 2017 General Electric Company.  All rights reserved.
 */

/*
 * \file epic_rspvar.eh
 *
 * This EPIC source file declares target RSP variables common across all
 * PSDs.  Note that variables uniquely used by specific to PSD(s) may be
 * included here to ensure that the variables are present for code which
 * sets these variables. 
 *
 * RSP variables should be put into their respective psdsource
 * modules whenever possible. 
 *
 * This file is included in epic.h
 *
 */
 
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  GERequired.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
/*********************************************************************
 *                  PRESCAN.E IPGEXPORT SECTION                      *
 *                                                                   *
 * Standard C variables of _any_ type common for both the Host and   *
 * Tgt PSD processes. Declare here all the complex type, e.g.,       *
 * structures, arrays, files, etc.                                   *
 *                                                                   *
 * NOTE FOR Lx:                                                      *
 * Since the architectures between the Host and the Tgt sides are    *
 * different, the memory alignment for certain types varies. Hence,  *
 * the following types are "forbidden": short, char, and double.     *
 *********************************************************************/
int PSfreq_offset[ENTRY_POINT_MAX]= {0};
int cfl_tdaq= {0};
int cfh_tdaq= {0};
int rcvn_tdaq= {0};
long rsp_PSrot[MAX_PSC_VQUANT] [9]= {{0}};
long rsp_rcvnrot[1][9]= {{0}};
long rsrsprot[RFSHIM_SLQ][9] = {{0}}; /* rot for B1 Map */
long dtgrsprot[DYNTG_SLQ][9] = {{0}}; /* rot for dynTG B1 Map */
long calrsprot[CAL_SLTAB_MAX + 1][9] = {{0}}; /* rot for Auto Cal */
long coilrsprot[CAL_SLTAB_MAX + 1][9] = {{0}}; /* rot for Auto Cal */
int min_ssp= {0}; /* Minimum required time between consecutive RF pulses */

RSP_INFO rsrsp_info[RFSHIM_SLQ] = { {0,0,0,0} };  /* B1 Map rsp info */
RSP_INFO dtgrsp_info[DYNTG_SLQ] = { {0,0,0,0} };  /* dynTG B1 Map rsp info */
RSP_INFO calrsp_info[64] = { {0,0,0,0} };  /* Ext Cal rsp info */
RSP_INFO coilrsp_info[64] = { {0,0,0,0} };  /* Auto Coil rsp info */
ZY_INDEX cal_zyindex[CAL_SLTAB_MAX*CAL_VIEWTAB_MAX] = { {0,0,0} };
ZY_INDEX coil_zyindex[CAL_SLTAB_MAX*CAL_VIEWTAB_MAX] = { {0,0,0} };

/* For presscfh MRIhc08321 */
PSC_INFO presscfh_info[MAX_PSC_VQUANT]={ {0,0,0,{0},0,0,0} };

/* YMSmr09211  04/26/2006 YI */

LOG_GRAD  cflloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  ps1loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  cfhloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  rcvnloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  rsloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  dtgloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  calloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  coilloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD  maptgloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };

PHYS_GRAD original_pgrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };


WF_PROCESSOR read_axis = XGRAD;
WF_PROCESSOR killer_axis = YGRAD;
WF_PROCESSOR tg_killer_axis = YGRAD;
WF_PROCESSOR tg_read_axis = XGRAD;



RF_PULSE_INFO rfpulseInfo[RF_FREE] = { {0, 0} };
int avail_image_time= {0};
int act_tr= {0}; /* required by pulsegen on host (analyze_gradients.c) */

/* used together in scan() instead of rsp_info. Setup in predownload() of the main sequence 
  (epic_geometry_types.h: DEFAULT_AXIAL_SCAN_INFO) */
SCAN_INFO ks_scan_info[SLTAB_MAX] = {DEFAULT_AXIAL_SCAN_INFO}; /* {{0, 0, 0, {0,0,0,0,0,0,0,0,0}}}; */

KS_SLICE_PLAN ks_slice_plan = KS_INIT_SLICEPLAN;

int ks_sarcheckdone = FALSE;

char ks_psdname[256]= {0};
int ks_perform_slicetimeplot = FALSE;


/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/* the KSGRE Sequence object */
KSGRE_SEQUENCE ksgre = KSGRE_INIT_SEQUENCE;


long _lasttgtex = 0;

#endif /* h_ksgre_tutorial_tgtex_h */

