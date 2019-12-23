/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : ksgre.e
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
* @file ksgre.e
* @brief This file contains the overall structure for the *ksgre* psd
*
* **MR-contrasts supported**
* - GRASS
* - SPGR
* - bSSFP (FIESTA)
*
* **Features**
* - ASSET & ARC with GE recon
* - Multi-echo
* - Fat-Sat
* - Spatial Sat
* - Single & dual inversion (FLAIR-block, sliceahead-IR, simple IR). 2D only
* - 2D & 3D data acquisition
*
********************************************************************************************************/


@inline epic.h
@inline GERequired.e
@inline KSSpSat.e
@inline KSChemSat.e
@inline KSInversion.e
@inline ksgre_implementation.e

@global

/*****************************************************************************************************
 * GLOBALS
 *****************************************************************************************************/



#include "KSFoundation.h"

/* GE RF Pulses (c.f. KSFoundation_GERFpulses.m) */
#include <KSFoundation_GERF.h>

@ipgexport
/*****************************************************************************************************
 * IPG Export
 *****************************************************************************************************/


@cv
/*****************************************************************************************************
 * CVs
 *****************************************************************************************************/


@host
/*****************************************************************************************************
 * Host Functions and variables
 *****************************************************************************************************/

  /* Collection (handle) of all sequence modules */
  KS_SEQ_COLLECTION seqcollection;

/*****************************************************************************************************
 * CVINIT (Executes at init and when a change is made in the user interface)
 *****************************************************************************************************/

STATUS cvinit(void) {
  STATUS status;

  status = GEReq_cvinit();
  if (status != SUCCESS) return status;

  /* reset debug file ./ks_debug.txt (SIM) or /usr/g/mrraw/ks_debug.txt (HW) */
  ks_dbg_reset();

  /* Imaging Options buttons */
  ksgre_init_imagingoptions();

  /* Inversion UI init */
  status = ksinv_init_UI();
  if (status != SUCCESS) return status;

  /* Setup UI buttons */
  status = ksgre_init_UI();
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* cvinit() */



/*****************************************************************************************************
 * CVEVAL (Executes when a change is made in the user interface)
 *****************************************************************************************************/

STATUS cveval(void) {

    /*
   cveval() is called 37+ times per UI button push on the MR system, while cvcheck() is only called once.
   For a faster execution we have a my_cveval() function that is called in cvcheck() instead
   */

  return SUCCESS;
}


STATUS my_cveval(void) {
  STATUS status;

  ks_init_seqcollection(&seqcollection);

  status = GEReq_cveval();
  if (status != SUCCESS) return status;

  /* User Interface updates & opuserCV sync */
  status = ksgre_eval_UI();
  if (status != SUCCESS) return status;

  /* Setup sequence objects */
  status = ksgre_eval_setupobjects();
   if (status != SUCCESS) return status;

  /* Calculate minimum (and maximum TE) */
  status = ksgre_eval_TErange();
  if (status != SUCCESS) return status;

  /* Run the sequence once (and only once after ksgre_eval_setupobjects()) in cveval() to
     get the sequence duration and the number of object instances (for grad/rf limits in GEReq...limits()) */
  status = ksgre_pg(ksgre_pos_start);
  if (status != SUCCESS) return status;

  status = ks_eval_addtoseqcollection(&seqcollection, &ksgre.seqctrl);
  if (status != SUCCESS) return status;


  /*--------- Begin: Additional sequence modules -----------*/

   /* Spatial Sat */
  status = ksspsat_eval(&seqcollection);
  if (status != SUCCESS) return status;
  
  /* ChemSat */
  status = kschemsat_eval(&seqcollection);
  if (status != SUCCESS) return status;

  /* Inversion (general & GRE specific). Must be the last sequence module added */
  if (!KS_3D_SELECTED) { 
    status = ksgre_eval_inversion(&seqcollection);
    if (status != SUCCESS) return status;
  }

  /*--------- End: Additional sequence modules -----------*/


  /* Min TR, #slices per TR, RF/gradient heating & SAR */
  status = ksgre_eval_tr(&seqcollection);
  if (status != SUCCESS) return status;

  /* RF scaling across sequence modules */
  status = GEReq_eval_rfscaling(&seqcollection);
  if (status != SUCCESS) return status;

  /* scan time */
  status = ksgre_eval_scantime();
  if (status != SUCCESS) return status;

  return SUCCESS;

} /* my_cveval() */


/*****************************************************************************************************
 * CVCHECK (Executes when a change is made in the user interface)
 *****************************************************************************************************/

STATUS cvcheck(void) {
  STATUS status;

  status = my_cveval();
  if (status != SUCCESS) return status;

  status = GEReq_cvcheck();
  if (status != SUCCESS) return status;

  status = ksgre_check();
  if (status != SUCCESS) return status;

  abort_on_kserror = ksgre_abort_on_kserror;

  return SUCCESS;

} /* cvcheck() */


/*****************************************************************************************************
 * PREDOWNLOAD (Executes when pressing SaveRx on MR scanner (HW) or on value change in EvalTool (SIM)
 ****************************************************************************************************/
STATUS predownload( void ) {
  STATUS status;

  status = GEReq_predownload();
  if (status != SUCCESS) return status;

  /* Set filter slot # for SCAN, APS2, MPS2 */
  GEReq_predownload_setfilter(&ksgre.read.acq.filt);

  /* slice ordering */
  /* The following GE globals must be set appropriately:
     data_acq_order[], rsp_info[], rsprot[], rsptrigger[]. This is a must for a main pulse sequence */
  if (KS_3D_SELECTED) {
    status = GEReq_predownload_store_sliceplan3D(opslquant, opvquant);
  } else {
    status = GEReq_predownload_store_sliceplan(ks_slice_plan);
  }
  if (status != SUCCESS) return status;

  /* generic rh-vars setup */
  GEReq_predownload_setrecon_readphase(&ksgre.read, &ksgre.phaseenc, KS_3D_SELECTED ? &ksgre.zphaseenc : NULL, \
                                       ksgre_imsize, KS_SAVEPFILES * autolock + KS_GERECON * (rhrecon < 1000) /* online recon if rhrecon < 1000 */);
  GEReq_predownload_setrecon_annotations_readtrap(&ksgre.read, ksgre_extragap);
  GEReq_predownload_setrecon_voldata(opfphases, ks_slice_plan); /* opfphases = number of volumes */

  /* KSInversion predownload */
  status = ksinv_predownload_setrecon();
  if (status != SUCCESS) return status;

  /* further sequence specific recon settings that have not been set correctly at this point */
  status = ksgre_predownload_setrecon();
  if (status != SUCCESS) return status;

  /* plotting of sequence modules and slice timing to disk */
  ksgre_predownload_plot(&seqcollection);

  return SUCCESS;

} /* predownload() */


@pg
/*****************************************************************************************************
 * PULSEGEN (Executes when pressing Scan or Research->Download)
 *****************************************************************************************************/

STATUS pulsegen( void ) {

  GEReq_pulsegenBegin();

  /* Main Pulse Sequence */
  ksgre_pg(ksgre_pos_start);
  KS_SEQLENGTH(seqcore, ksgre.seqctrl);

  /* Spatial Sat */
  ksspsat_pulsegen();

  /* ChemSat sequence module */
  kschemsat_pg(&kschemsat);
  KS_SEQLENGTH(seqKSChemSat, kschemsat.seqctrl); /* does nothing if kschemsat.seqctrl.duration = 0 */

  /* Inversion sequence modules */
  ksinv_pulsegen();

  GEReq_pulsegenEnd();

  buildinstr(); /* load the sequencer memory */

  return SUCCESS;

} /* pulsegen() */


@rspvar
/*****************************************************************************************************
 * RSP Variables
 * Accessible for tgt.c (on TGT)
 *****************************************************************************************************/


@rsp
/*****************************************************************************************************
 * RSP Functions
 * Accessible for tgt.c (on TGT)
 *****************************************************************************************************/

/*****************************************************************************************************
 * MPS2: Manual Prescan ("Scan TR"). Should run the main sequence without phase encoding gradients
 * to determine receiver gains R1 (analog) and R2 (digital)
 *****************************************************************************************************/

STATUS mps2(void) {
  rspent = L_MPS2;
  strcpy(psdexitarg.text_arg, "mps2");

  if (ksgre_scan_init() == FAILURE)
    return rspexit();

 if (ksgre_scan_prescanloop(30000, ksgre_dda) == FAILURE)
   return rspexit();

  rspexit();

  return SUCCESS;

} /* end mps2() */


/*****************************************************************************************************
 * APS2: Auto Prescan ("Scan TR"). Should run the main sequence without phase encoding gradients
 * to determine receiver gains R1 (analog) and R2 (digital)
 *****************************************************************************************************/

STATUS aps2(void) {

  rspent = L_APS2;
  strcpy(psdexitarg.text_arg, "aps2");

  if (ksgre_scan_init() == FAILURE)
    return rspexit();

  if (ksgre_scan_prescanloop(100, ksgre_dda) == FAILURE)
    return rspexit();

  rspexit();

  return SUCCESS;

} /* aps2() */


/*****************************************************************************************************
 * SCAN: Executed when pressing Scan. Runs the sequence
 * The code is halted at the function call startseq() and waits for the SSI interrupt at the end of
 * each sequence playout
 *****************************************************************************************************/


STATUS scan(void) {

  rspent = L_SCAN;
  strcpy(psdexitarg.text_arg, "scan");

  if (ksgre_scan_init() == FAILURE)
    return rspexit();

  /* Scan hierarchy:

    Without inversion:
    ksgre_scan_scanloop() - Data for the entire scan
        ksgre_scan_acqloop() - All data for one set of slices that fit within one TR (one acquisition)
            ksgre_scan_sliceloop() - One set of slices that fit within one TR played out for one shot
                 ksgre_scan_coreslice() - One slice playout, with optional other sequence modules

    With inversion:
    ksgre_scan_scanloop() - Data for the entire scan
        ksgre_scan_acqloop() - All data for one set of slices that fit within one TR (one acquisition)
            ksinv_scan_sliceloop() - One set of slices that fit within one TR played out for one shot
                                     using the sliceloop in KSInversion.e. Note that ksinv_scan_sliceloop()
                                     takes over the TR timing from ksgre_scan_sliceloop() and uses a
                                     function pointer to ksgre_scan_coreslice_nargs() to execute the
                                     contents of ksgre_scan_coreslice().
  */
  ksgre_scan_scanloop();

  GEReq_endofscan();

  /* So we can see the sequence in plotter after scan completes */
  ks_scan_switch_to_sequence(&ksgre.seqctrl);

  rspexit();

  return SUCCESS;

}   /* scan() */







