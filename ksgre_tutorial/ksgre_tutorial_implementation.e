/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename	: ksgre_tutorial_implementation.e
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
* @file ksgre_tutorial_implementation.e
* @brief This file contains the implementation details for the *ksgre* psd
********************************************************************************************************/

@global

#define KSGRE_DEFAULT_SSI_TIME 500

#ifndef GEREQUIRED_E
#error GERequired.e must be inlined before ksgre_tutorial_implementation.e
#endif

/** @brief #### `typedef struct` holding all all gradients and waveforms for the ksgre sequence
*/
typedef struct KSGRE_SEQUENCE {
  KS_SEQ_CONTROL seqctrl;
  KS_READTRAP read;
  KS_TRAP readdephaser;
  KS_PHASER phaseenc;
  KS_TRAP spoiler;
  KS_SELRF selrfexc;
} KSGRE_SEQUENCE;
#define KSGRE_INIT_SEQUENCE {KS_INIT_SEQ_CONTROL, KS_INIT_READTRAP, KS_INIT_TRAP, \
                             KS_INIT_PHASER, KS_INIT_TRAP, KS_INIT_SELRF};



@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

float ksgre_gscalerfexc = 0.9; /* default gradient scaling for slice thickness */
float ksgre_spoilerarea = 2000.0 with {0.0, 10000.0, 2000.0, VIS, "ksgre spoiler gradient area",};
int ksgre_ssi_time = KSGRE_DEFAULT_SSI_TIME with {32, , KSGRE_DEFAULT_SSI_TIME, VIS, "time from eos to ssi in intern trig",};
int ksgre_dda = 2 with {0, 200, 2, VIS, "Number of dummy scans for steady state",};

float ksgre_spoilreadarea = 603.0 ;

@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

/* the KSGRE Sequence object */
KSGRE_SEQUENCE ksgre = KSGRE_INIT_SEQUENCE;


@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: Host declarations
 *
 *******************************************************************************************************
 *******************************************************************************************************/

abstract("GRE Tutorial [KSFoundation]");
psdname("ksgre_tutorial");

int ksgre_scan_sliceloop_nargs(int slperpass, int nargs, void **args);
float ksgre_scan_acqloop(int passindx);
float ksgre_scan_scanloop();
STATUS ksgre_scan_seqstate(SCAN_INFO slice_info, int kyview);

#include "epic_iopt_util.h"
#include <psdiopt.h>


/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: CVINIT
 *
 *******************************************************************************************************
 *******************************************************************************************************/


int sequence_iopts[] = {
  PSD_IOPT_SEQUENTIAL /* opirmode */
#ifdef UNDEF
  PSD_IOPT_ARC, /* oparc */
  PSD_IOPT_ASSET, /* opasset */
  PSD_IOPT_EDR, /* opptsize */
  PSD_IOPT_DYNPL, /* opdynaplan */
  PSD_IOPT_ZIP_512, /* opzip512 */
  PSD_IOPT_IR_PREP, /* opirprep */
  PSD_IOPT_MILDNOTE, /* opsilent */
  PSD_IOPT_ZIP_1024, /* opzip1024 */
  PSD_IOPT_SLZIP_X2, /* opzip2 */
  PSD_IOPT_MPH, /* opmph */
  PSD_IOPT_NAV, /* opnav */
  PSD_IOPT_FLOW_COMP, /* opfcomp */
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

  /* default slice order is interleaved */
  cvdef(opirmode, 0); opirmode = 0;

} /* ksgre_init_imagingoptions() */




/**
 *******************************************************************************************************
 @brief #### Initial setup of user interface (UI) with default values for menus and fields
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_init_UI(void) {

  /* Menus and button content 
     See epic.h or ksgre.e for more pi*** CVs to use to set up the user menus and buttons */
  
  /* Gradient Echo Type of sequence */
  acq_type = TYPGRAD; /* loadrheader.e rheaderinit: sets eeff = 1 */

  /* show "Minimum" as 1st option in TR menu */
  pitrval2 = PSD_MINIMUMTR;

  /* show "MinimumFull" as 1st option in TE menu */
  pite1val2 = PSD_MINFULLTE;

  /* show flip angle menu */
  pifanub = 2;
  
  /* hide second bandwidth option */
  pircb2nub = 0;

  /* default low FA */
  cvdef(opflip, 5);
  opflip = _opflip.defval;

  return SUCCESS;

} /* ksgre_init_UI() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: CVEVAL
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

  /* add code here that is related to the user interface (i.e. scan parameter) changes */

  return SUCCESS;

} /* ksgre_eval_UI() */




/**
 *******************************************************************************************************
 @brief #### Sets up all sequence objects for the main sequence module (KSGRE_SEQUENCE ksgre)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_setupobjects() {
  STATUS status;

  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/

  /* RF pulse choice (KSFoundation_GERF.h) */
  ksgre.selrfexc.rf = exc_3dfgre;

  ksgre.selrfexc.rf.flip = opflip;
  ksgre.selrfexc.slthick = opslthick / ksgre_gscalerfexc;

  /* selective RF excitation */
  if (ks_eval_selrf(&ksgre.selrfexc, "rfexc") == FAILURE)
    return FAILURE;

  /*******************************************************************************************************
   *  Readout
   *******************************************************************************************************/

  ksgre.read.fov = opfov;
  ksgre.read.res = RUP_FACTOR(opxres, 2); /* round up (RUP) to nearest multiple of 2 */
  ksgre.read.acq.rbw = oprbw;
  status = ks_eval_readtrap(&ksgre.read, "read");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  Readout dephaser
   *******************************************************************************************************/

  ksgre.readdephaser.area = -ksgre.read.area2center;
  status = ks_eval_trap(&ksgre.readdephaser, "readdephaser");
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
  *  Phase encoding
  *******************************************************************************************************/
 
  ksgre.phaseenc.fov = opfov * opphasefov;
  ksgre.phaseenc.res = RUP_FACTOR((int) (opyres * opphasefov), 2); /* round up (RUP) to nearest multiple of 2 */

  if (ks_eval_phaser(&ksgre.phaseenc, "phaseenc") == FAILURE)
    return FAILURE;

  /*******************************************************************************************************
  *  Spoiler
  *******************************************************************************************************/
/* ------ emmweber --------------*/
  ksgre.spoiler.area = ksgre_spoilreadarea;

  if (ks_eval_trap(&ksgre.spoiler, "spoiler") == FAILURE)
    return FAILURE;

  /*******************************************************************************************************
   *  Init (reset) sequence control and set the SSI time
   *******************************************************************************************************/
  ks_init_seqcontrol(&ksgre.seqctrl);
  strcpy(ksgre.seqctrl.description, "ksgremain");
  /* Copy SSI CV to seqctrl field used by setssitime() */
  ksgre.seqctrl.ssi_time = RUP_GRD(ksgre_ssi_time);

  return SUCCESS;

} /* ksgre_eval_setupobjects() */




/**
 *******************************************************************************************************
 @brief #### Sets the min TE based on the durations of the sequence objects in KSGRE_SEQUENCE (ksgre)

 @retval STATUS `SUCCESS` or `FAILURE`
******************************************************************************************************/
STATUS ksgre_eval_TErange() {
 
  /* Minimum TE */
  avminte = ksgre.selrfexc.rf.iso2end;
  avminte += IMax(3, \
        ksgre.readdephaser.duration + ksgre.read.acqdelay, \
        ksgre.phaseenc.grad.duration, \
        ksgre.selrfexc.grad.ramptime + ksgre.selrfexc.postgrad.duration);
  avminte += ksgre.read.time2center - ksgre.read.acqdelay; /* from start of acq win to k-space center */
  avminte = RUP_FACTOR(avminte + 8us, 8); /* add 8us margin and round up to make time divisible by 8us */

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

 At the end of this function, TR validation and heat/SAR checks are done using GEReq_eval_checkTR_SAR().
 @param[in] seqcollection Pointer to the KS_SEQ_COLLECTION struct holding all sequence modules
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_eval_tr(KS_SEQ_COLLECTION *seqcollection) {
  int timetoadd_perTR;
  STATUS status;
  int slperpass, min_npasses;

  /* interleaved slices in slice gap menu, force 2+ acqs */
  if (opileave)
    min_npasses = 2;
  else
    min_npasses = 1;

   /* Calculate # slices per TR, # acquisitions and how much spare time we have within the current TR by running the slice loop, honoring heating and SAR limits */
  status = GEReq_eval_TR(&slperpass, &timetoadd_perTR, min_npasses, seqcollection, ksgre_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  /* Calculate the slice plan (ordering) and passes (acqs). ks_slice_plan is passed to GEReq_predownload_store_sliceplan() in predownload() */
  ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);

  /* We spread the available timetoadd_perTR evenly, by increasing the .duration of each slice by timetoadd_perTR/slperpass */
  ksgre.seqctrl.duration = RUP_GRD(ksgre.seqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

  /* Update SAR values in the UI (error will occur if the sum of sequence durations differs from optr) */
  status = GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, ksgre_scan_sliceloop_nargs, 0, NULL);
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* ksgre_eval_tr() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: CVCHECK
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/**
 *******************************************************************************************************
 @brief #### Returns error of various parameter combinations that are not allowed for ksgre
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_check() {


  return SUCCESS;

} /* ksgre_check() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_tutorial_implementation.e: PREDOWNLOAD
 *
 *******************************************************************************************************
 *******************************************************************************************************/



/**
 *******************************************************************************************************
 @brief #### Plotting of sequence modules and slice timing to PNG/SVG/PDF files

 The ks_plot_*** functions used in here will save plots to disk depending on the value of the CV 
 `ks_plot_filefmt` (see KS_PLOT_FILEFORMATS). E.g. if ks_plot_filefmt = KS_PLOT_OFF, nothing will be
 written to disk. On the MR scanner, the output will be located in /usr/g/mrraw/plot/<ks_psdname>. In
 simulation, it will be placed in the current directory (./plot/).

 Please see the documentation on how to install the required python version and links. Specifically,
 there must be a link /usr/local/bin/apython pointing to the Anaconda 2 python binary (v. 2.7).

 In addition, the following text files is printed out
 - <ks_psdname>_objects.txt

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
  ks_print_phaser(ksgre.phaseenc, fp);
  ks_print_trap(ksgre.spoiler, fp);
  ks_print_selrf(ksgre.selrfexc, fp);
  fclose(fp);


  /* ks_plot_host():
  Plot each sequence module as a separate file (PNG/SVG/PDF depending on ks_plot_filefmt (GERequired.e))
  See KS_PLOT_FILEFORMATS in KSFoundation.h for options.
  Note that the phase encoding amplitudes corresponds to the first shot, as set by the call to ksgre_scan_seqstate below */
  ksgre_scan_seqstate(ks_scan_info[0], 0);
  ks_plot_host(seqcollection, NULL);

  /* Sequence timing plot */
  ks_plot_slicetime_begin();
  ksgre_scan_scanloop();
  ks_plot_slicetime_end();

  /* ks_plot_tgt_reset():
  Creates sub directories and clear old files for later use of ksgre_scan_acqloop()->ks_plot_tgt_addframe().
  ks_plot_tgt_addframe() will only write in MgdSim (WTools) to avoid timing issues on the MR scanner. Hence,
  unlike ks_plot_host() and the sequence timing plot, one has to open MgdSim and press RunEntry (and also
  press PlotPulse several times after pressing RunEntry). */
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
 *  ksgre_tutorial_implementation.e: PULSEGEN - builing of the sequence from the sequence objects
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
STATUS ksgre_pg() {
  KS_SEQLOC tmploc = KS_INIT_SEQLOC;
  int readstart_pos;
  int endofseq_pos;
  STATUS status;


  /*******************************************************************************************************
   *  RF Excitation
   *******************************************************************************************************/
  tmploc.pos = RUP_GRD(KS_RFSSP_PRETIME);
  tmploc.board = ZGRAD;

  /* N.B.: ks_pg_selrf()->ks_pg_rf() detects that ksgre.selrfexc is an excitation pulse
     (ksgre.selrfexc.rf.role = KS_RF_ROLE_EXC) and will also set ksgre.seqctrl.momentstart
     to the absolute position in [us] of the isocenter of the RF excitation pulse */
  status = ks_pg_selrf(&ksgre.selrfexc, tmploc, &ksgre.seqctrl);
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
  *  Readout timing
  *******************************************************************************************************/

  /* With ksgre.seqctrl.momentstart set by ks_pg_selrf(&ksgre.selrfexc, ...), the absolute readout position
     can be determined (for both full Fourier and partial Fourier readouts using ksgre.read.time2center) */
  readstart_pos = ksgre.seqctrl.momentstart + opte - ksgre.read.time2center;

  /*******************************************************************************************************
   *  Phase encoding
   *******************************************************************************************************/

   /* emmweber */
  /* tmploc.pos = readstart_pos + RUP_GRD(ksgre.read.acqdelay) - ksgre.phaseenc.grad.duration - 380; */

  tmploc.pos = readstart_pos - ksgre.phaseenc.grad.duration ;
  tmploc.board = YGRAD;

  status = ks_pg_phaser(&ksgre.phaseenc, tmploc, &ksgre.seqctrl);
  if (status != SUCCESS) return status;

  /* set phase encode amps to first ky view (for plotting & moment calcs in WTools) */
  ks_scan_phaser_toline(&ksgre.phaseenc, 0, 0);

  /*******************************************************************************************************
   *  Readout dephaser
   *******************************************************************************************************/

  tmploc.pos = readstart_pos - ksgre.readdephaser.duration;
  tmploc.board = XGRAD;

  status = ks_pg_trap(&ksgre.readdephaser, tmploc, &ksgre.seqctrl);
  if (status != SUCCESS) return status;

  /*******************************************************************************************************
   *  Readout
   *******************************************************************************************************/

  tmploc.pos = readstart_pos;
  tmploc.board = XGRAD;

  status = ks_pg_readtrap(&ksgre.read, tmploc, &ksgre.seqctrl);
  if (status != SUCCESS) return status;



  /*******************************************************************************************************
   *  Spoiler
   *******************************************************************************************************/

  tmploc.pos = readstart_pos + ksgre.read.grad.duration;
  tmploc.board = XGRAD;
  status = ks_pg_trap(&ksgre.spoiler, tmploc, &ksgre.seqctrl);

  if (status != SUCCESS) return status;


  /* emmweber -------- Y spoiler grad ---------------------------*/

  
  tmploc.board = YGRAD;
  ks_pg_trap(&ksgre.spoiler, tmploc, &ksgre.seqctrl);

  /* emmweber -------- Z spoiler grad ---------------------------*/
  tmploc.board = ZGRAD;
  ks_pg_trap(&ksgre.spoiler, tmploc, &ksgre.seqctrl);



  /*******************************************************************************************************
   *  Set the minimal sequence duration (ksgre.seqctrl.min_duration) by calling
   *  ks_eval_seqctrl_setminduration()
   *******************************************************************************************************/

  endofseq_pos = RUP_GRD(tmploc.pos + ksgre.spoiler.duration);

#ifdef HOST_TGT
  /* On HOST only: Sequence duration (ksgre.seqctrl.ssi_time must be > 0 and is added to ksgre.seqctrl.min_duration in ks_eval_seqctrl_setminduration() */
  ks_eval_seqctrl_setminduration(&ksgre.seqctrl, endofseq_pos); /* endofseq_pos now corresponds to the end of last gradient in the sequence */
#endif

  return SUCCESS;

} /* ksgre_pg() */




/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksgre_implementation.e: SCAN in @pg section (functions accessible to both HOST and TGT)
 *
 *  Here are functions related to the scan process (ksgre_scan_***) that have to be placed here in @pg
 *  (not @rsp) to make them also accessible on HOST in order to enable scan-on-host for TR timing
 *  in my_cveval()
 *
 *******************************************************************************************************
 *******************************************************************************************************/




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
 @param[in] kyview Phase encoding index related to `ksgre.phaseenc`. A value outside of
                   `[0, ksgre.phaseenc.res-1]` will set the phase encoding gradient amplitude to 0.
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ksgre_scan_seqstate(SCAN_INFO slice_info, int kyview) {
  float rfphase = 0;

  /* rotate the slice plane */
  ks_scan_rotate(slice_info);

  /* RF frequency & phase */
  ks_scan_rf_on(&ksgre.selrfexc.rf, INSTRALL);
  ks_scan_selrf_setfreqphase(&ksgre.selrfexc, 0 /* instance */, slice_info, rfphase);

  /* FOV offsets (by changing freq/phase of ksgre.read) */
  ks_scan_offsetfov(&ksgre.read, INSTRALL, slice_info, kyview, opphasefov, rfphase);

  /* phase enc amp */
  ks_scan_phaser_toline(&ksgre.phaseenc,   0, kyview); 

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
  @param[in] kyindx Phase encoding index related to `ksgre.phaseenc`. A value outside of
                    `[0, ksgre.phaseenc.res-1]` will set the phase encoding gradient amplitude to 0.
  @param[in] exc Excitation index in range [0, NEX-1], where NEX = number of excitations (opnex)
  @retval coreslicetime Time taken in [us] to play out one slice with potentially other sequence modules
********************************************************************************************************/
int ksgre_scan_coreslice(const SCAN_INFO *slice_pos, int dabslice, /* psd specific: */ int kyindx, int exc) {
  int echoindx;
  int dabop, dabview, acqflag;
  int time = 0;
  float tloc = 0.0;

  if (slice_pos != NULL) {
    /* modify sequence for next playout */
    ksgre_scan_seqstate(*slice_pos, ksgre.phaseenc.linetoacq[kyindx]);
    tloc = slice_pos->optloc;
  } else {
    /* false slice, shut off RF */
    ks_scan_rf_off(&ksgre.selrfexc.rf, INSTRALL);
  }

  /* data acquisition control */
  acqflag = (kyindx >= 0 && slice_pos != NULL && dabslice >= 0) ? DABON : DABOFF; /* open or close data receiver */
  dabop = (exc <= 0) ? DABSTORE : DABADD; /* replace or add to data */
  dabview = (kyindx >= 0) ? ksgre.phaseenc.linetoacq[kyindx] : KS_NOTSET;

  for (echoindx = 0; echoindx < ksgre.read.acq.base.ngenerated; echoindx++) {
    loaddab(&ksgre.read.acq.echo[echoindx], dabslice, echoindx, dabop, dabview + 1, acqflag, PSD_LOAD_DAB_ALL);
  }

  time += ks_scan_playsequence(&ksgre.seqctrl);

  int plottag = (slice_pos == NULL) ? KS_PLOT_NO_EXCITATION : KS_PLOT_STANDARD;
  ks_plot_slicetime(&ksgre.seqctrl, 1, &tloc, opslthick, plottag);

  return time; /* in [us] */

} /* ksgre_scan_coreslice() */




/**
 *******************************************************************************************************
 @brief #### Plays out `slperpass` slices corresponding to one TR

 This function gets a spatial slice location index based on the pass index and temporal position within
 current pass. It then calls ksgre_scan_coreslice() to play out one coreslice (i.e. the main ksgre main
 sequence + optional sequence modules, excluding inversion modules).

 @param[in] slperpass Number of slices to play in the slice loop
 @param[in] passindx  0-based pass index in range [0, ks_slice_plan.npasses - 1]
 @param[in] kyindx Phase encoding index related to `ksgre.phaseenc`. A value outside of
                   `[0, ksgre.phaseenc.res-1]` will set the phase encoding gradient amplitude to 0.
 @param[in] exc Excitation index in range [0, NEX-1], where NEX = number of excitations (opnex)
 @retval slicelooptime Time taken in [us] to play out `slperpass` slices
********************************************************************************************************/
int ksgre_scan_sliceloop(int slperpass, int passindx, int kyindx, int exc) {
  int time = 0;
  int slloc, sltimeinpass;

  for (sltimeinpass = 0; sltimeinpass < slperpass; sltimeinpass++) {

    /* slice location from slice plan (KS_NOTSET (= -1) means dummy slice) */
    slloc = ks_scan_getsliceloc(&ks_slice_plan, passindx, sltimeinpass);

    time += ksgre_scan_coreslice((slloc != KS_NOTSET) ? &ks_scan_info[slloc] : NULL, sltimeinpass, kyindx, exc);

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
  int kyindx = KS_NOTSET; /* off */
  int exc = 0;

  if (nargs < 0 || nargs > 3) {
    ks_error("%s: 3rd arg (void **) must contain up to 4 elements: passindx, kyindx, exc", __FUNCTION__);
    return -1;
  } else if (nargs > 0 && args == NULL) {
    ks_error("%s: 3rd arg (void **) cannot be NULL if nargs (2nd arg) != 0", __FUNCTION__);
    return -1;
  }

  if (nargs >= 1 && args[0] != NULL) {
    passindx = *((int *) args[0]);
  }
  if (nargs >= 2 && args[1] != NULL) {
    kyindx = *((int *) args[1]);
  }
  if (nargs >= 3 && args[2] != NULL) {
    exc = *((int *) args[2]);
  }

  return ksgre_scan_sliceloop(slperpass, passindx, kyindx, exc); /* in [us] */

} /* ksgre_scan_sliceloop_nargs() */




/**
 *******************************************************************************************************
 @brief #### Plays out all phase encodes for all slices belonging to one pass

 This function traverses through all phase encodes to be played out and runs the
 ksgre_scan_sliceloop() for each set of kyindx, and excitation. If ksgre_dda > 0, dummy scans
 will be played out before the phase encoding begins.

 @param[in] passindx  0-based pass index in range [0, ks_slice_plan.npasses - 1]
 @retval passlooptime Time taken in [us] to play out all phase encodes and excitations for `slperpass`
                      slices. Note that the value is a `float` instead of `int` to avoid int overrange
                      at 38 mins of scanning
********************************************************************************************************/
float ksgre_scan_acqloop(int passindx) {
  float time = 0.0;
  int dda, kyindx, exc;

  /* dummy scans for steady state */
  for (dda = 0; dda < ksgre_dda; dda++) {
    time += (float) ksgre_scan_sliceloop(ks_slice_plan.nslices_per_pass, passindx, KS_NOTSET, KS_NOTSET);
    ks_plot_slicetime_endofslicegroup("ksgre dummy TR");
  }
  if (ksgre_dda > 0) {
    ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_DUMMY);
  }

  for (kyindx = 0; kyindx < ksgre.phaseenc.numlinestoacq; kyindx++) {
    for (exc = 0; exc < (int) ceil(opnex); exc++) { /* ceil rounds up opnex < 1 (used for partial Fourier) to 1 */

      time += (float) ksgre_scan_sliceloop(ks_slice_plan.nslices_per_pass, passindx, kyindx, exc);

    } /* for exc */


    ks_plot_slicetime_endofslicegroup("ksgre line");

    /* save a frame of the main sequence */
    ks_plot_tgt_addframe(&ksgre.seqctrl);

  } /* for kyindx */

  ks_plot_slicetime_endofpass(KS_PLOT_PASS_WAS_STANDARD);

  return time; /* in [us] */

} /* ksgre_scan_acqloop() */




/**
 *****************************************************************************************************
 @brief #### Plays out all passes of a single or multi-pass scan

 This function traverses through all phase encodes to be played out, and runs the ksgre_scan_sliceloop()
 for each set of kyindx and excitation. If ksgre_dda > 0, dummy scans will be played out before
 the phase encoding begins.

 @retval scantime Total scan time in [us] (float to avoid int overrange after 38 mins)
********************************************************************************************************/
float ksgre_scan_scanloop() {
  float time = 0.0;

  for (volindx = 0; volindx < opfphases; volindx++) { /* opfphases is # volumes */

    for (passindx = 0; passindx < ks_slice_plan.npasses; passindx++) {

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
 *  ksgre_tutorial_implementation.e: RSP variables (accessible on HOST and TGT). Global variables that are used
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
 *  ksgre_implementation.e: SCAN in @rsp section (functions only accessible on TGT)
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

  /* play first 'dda' dummy scans to get into steady state before start acquiring data */
  for (i = -dda; i < nloops; i++) {

    /* loop over slices */
    for (sltimeinpass = 0; sltimeinpass < ks_slice_plan.nslices_per_pass; sltimeinpass++) {

      slloc = ks_scan_getsliceloc(&ks_slice_plan, 0, sltimeinpass);

      /* modify sequence for next playout */
      ksgre_scan_seqstate(ks_scan_info[slloc], KS_NOTSET); /* KS_NOTSET => no phase encoding */

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






