/*******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : KSFoundation.h
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
* @file KSFoundation.h
* @brief This file contains the most documentation, and contains all definitions, sequence objects
*        (typedef structs) and function prototypes for KSFoundation. `@inline` this file in the main sequence
********************************************************************************************************/


#ifndef KSFOUNDATION_H
#define KSFOUNDATION_H

#include <stdarg.h>
extern int abort_on_kserror;

#if defined(IPG) && defined(PSD_HW) || EPIC_RELEASE < 25
#define WARN_UNUSED_RESULT /**< Compiler flag for DV25 and higher, causing a compiler error if the returned function value is not used by the calling function */
#else
/* GCC specific function attribute */
#define WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#endif

/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSFoundation.h: #defines, enums and typedef structs (esp. the psd objects)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/*******************************************************************************************************
 *  #defines
 *******************************************************************************************************/

/* general */
#define KS_NOTSET -1 /**< Unrealistic value used on some variables to trigger errors */
#define KS_INFINITY (1.0/0.0) /**< Infinity */

#define _cvdesc(cv, string)\
{\
    if( NULL != string ) {\
        if( FALSE == (cv)->staticdescrflag ) {\
            free( (void *)((cv)->descr) );\
        }\
        (cv)->descr = strdup( string );\
        (cv)->staticdescrflag = FALSE;\
    }\
}

/* Default update times for InterSequence Interupts. pre=4, post=32 */
#define KS_ISI_predelay 256
#define KS_ISI_time 256
#define KS_ISI_rotupdatetime 12
#define KS_ISI_postdelay 256

/* Board selections */
#define KS_MINPLATEAUTIME 8 /**< Shortest plateautime of a trapezoid (KS_TRAP) */

/* RF related */
#define KS_RFSSP_PRETIME 64 /**< Time in [us] before an RF pulse that is needed for SSP packets. May sometimes be taken into account */
#define KS_RFSSP_POSTTIME 56 /**< Time in [us] after an RF pulse that is needed for SSP packets. May sometimes be taken into account */
#define KS_RF_STANDARD_CRUSHERAREA 2000.0

/* EPI realated */
#define KS_EPI_MIN_INTERTRAIN_SSPGAP 80 /**< EXPERIMENTAL. Check how the SSP packets in the beginning/end of the EPI train can be packed to minimize this one for all possible acq. parameters */
#ifndef L_REF
#define L_REF 10
#endif


/* Make sure Premier gradients are defined for cfgcoiltype */
#ifndef PSD_HRMW_COIL
#define PSD_HRMW_COIL 13
#endif
#define HAVE_PREMIER_GRADIENTS (cfgcoiltype == PSD_HRMW_COIL)

/* convenience defines */
#define KS_SAVEPFILES RHXC_AUTO_LOCK /**< Bit for `rhexecctrl` to dump Pfiles */
#define KS_GERECON (RHXC_AUTO_DISPLAY+RHXC_XFER_IM) /**< Bit for `rhexecctrl` for GE product image reconstruction */
#define KS_3D_SELECTED (opimode == PSD_3D || opimode == PSD_3DM)
#define KS_3D_SINGLESLAB_SELECTED (opimode == PSD_3D)
#define KS_3D_MULTISLAB_SELECTED (opimode == PSD_3DM)

/*******************************************************************************************************
 *  Initializations for sequence objects
 *******************************************************************************************************/
/* array limits */
#define KS_DESCRIPTION_LENGTH 128  /**< Max # of characters in the description of the various sequence objects */
#define KS_MAXWAVELEN 10000 /**< KS_MAXWAVELEN (10000) sample points */
#define KS_MAXUNIQUE_RF 20 /**< Maximum number of *different* RF pulses in the sequence (c.f. also grad_rf_empty**.h) */
#define KS_MAXUNIQUE_TRAP 200 /**< Maximum number of *different* KS_TRAPs in the sequence */
#define KS_MAXUNIQUE_WAVE 200 /**< Maximum number of *different* KS_WAVEs in the sequence */
#define KS_MAXUNIQUE_SEQUENCES 200 /**< Maximum number of pulses sequence modules, including core, (i.e. with own SEQLENGTH/bofffset()) in this pulse sequence */
#define KS_MAX_PHASEDYN 1025 /**< Maximum number of phase encoding steps in a KS_PHASER sequence object */
#define KS_MAXUNIQUE_READ 500 /**< Maximum number of readout instances */
#define KS_MAXINSTANCES 500

#define KS_EPI_MINBLIPAREA 100 /**< Default value of lowest EPI blip area until blip is made wider to avoid discretization errors */

/* declaration inits of sequence objects */
#define KS_INITZEROS(n) {[0 ... (n-1)] = 0} /**< C macro to initialize arrays with zeros at declaration */
#define KS_INITVALUE(n,a) {[0 ... (n-1)] = a} /**< C macro to initialize each element in an array with a number at declaration */
#define KS_INIT_DESC KS_INITZEROS(KS_DESCRIPTION_LENGTH)/**< Default values for KS_DESCRIPTION strings */
#define KS_INIT_SEQLOC {KS_NOTSET, KS_NOTSET, 1.0} /**< Default values for KS_SEQLOC structs */
#define KS_INIT_WFINSTANCE {NULL, 0, NULL, {KS_INIT_SEQLOC}} /**< Default values for KS_WFINSTANCE structs (internal use) */
#define KS_INIT_WAIT {{0,0,NULL,sizeof(KS_WAIT)}, KS_INIT_DESC, 0, KS_INITVALUE(KS_MAXINSTANCES, KS_INIT_SEQLOC), NULL, NULL} /**< Default values for KS_WAIT sequence objects */
#define KS_INIT_ISIROT {KS_INIT_WAIT, KS_INIT_WAIT, NULL, 0, 0, 0, 0}
#define KS_INIT_TRAP {{0,0,NULL,sizeof(KS_TRAP)}, KS_INIT_DESC, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, KS_INITVALUE(KS_MAXINSTANCES,KS_INIT_SEQLOC), NULL, NULL, NULL}  /**< Default values for KS_TRAP sequence objects */
#define KS_INIT_READ {{0,0,NULL,sizeof(KS_READ)}, KS_INIT_DESC, 0, KS_NOTSET, {0.0, 0, 0.0, 0.0, KS_NOTSET, 0, 0, 0}, KS_INITVALUE(KS_MAXINSTANCES,KS_NOTSET), NULL} /**< Default values for KS_READ sequence objects */
#define KS_INIT_READ_EPI {{0,0,NULL,sizeof(KS_READ)}, KS_INIT_DESC, 0, 250.0, {0.0, 0, 0.0, 0.0, KS_NOTSET, 0, 0, 0}, KS_INITVALUE(KS_MAXINSTANCES,KS_NOTSET), NULL} /**< Default values for KS_READ sequence objects in KS_EPI */
#define KS_INIT_READTRAP {KS_INIT_READ, 240.0, 256, 0, 0, 0, 0.0, 0.0, 0.0, 0, KS_INIT_TRAP, KS_INIT_TRAP} /**< Default values for KS_READTRAP sequence objects */
#define KS_INIT_READTRAP_EPI {KS_INIT_READ_EPI, 240.0, 64, 0, 0, 0, 0.0, 0.0, 0.0, 0,  KS_INIT_TRAP, KS_INIT_TRAP} /**< Default values for the KS_READTRAP sequence objects in KS_EPI */
#define KS_INIT_PHASEENCTABLE KS_INITZEROS(KS_MAX_PHASEDYN) /**< Default values for the phase encoding table *.linetoacq* in the KS_PHASER sequence object */
#define KS_INIT_PHASER     {KS_INIT_TRAP, 240.0, KS_NOTSET, 0, 1, 0, 0.0, 0, KS_INIT_PHASEENCTABLE} /**< Default values for KS_PHASER sequence objects */
#define KS_INIT_PHASEENCODING_COORD {KS_NOTSET, KS_NOTSET}
#define KS_INIT_PHASEENCODING_PLAN {KS_NOTSET, KS_NOTSET, KS_INIT_DESC, NULL, NULL, NULL, FALSE}
#define KS_INIT_EPI {KS_INIT_READTRAP_EPI, KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_PHASER, KS_INIT_PHASER, 0, 0, 0, 0, 1.0, KS_EPI_MINBLIPAREA} /**< Default values for KS_EPI sequence objects */

#define KS_INIT_WAVEVALUE 0 /**< Default value for one element in a KS_WAVEFORM */
#define KS_INIT_WAVEFORM KS_INITVALUE(KS_MAXWAVELEN, KS_INIT_WAVEVALUE) /**< Default values for KS_WAVEFORM */
#define KS_INIT_WAVE {{0,0,NULL,sizeof(KS_WAVE)}, KS_INIT_DESC, 0, 0, KS_INIT_WAVEFORM, {0,0,0}, KS_NOTSET, KS_INITVALUE(KS_MAXINSTANCES,KS_INIT_SEQLOC), NULL, NULL, NULL} /**< Default values for KS_WAVE sequence objects */

#define KS_INIT_READWAVE {KS_INITVALUE(3,KS_INIT_WAVE), KS_INIT_WAVE, KS_INIT_WAVE, KS_INIT_READ, KS_INITVALUE(3, 0), KS_INITVALUE(3, 0.0), 0.0, 0.0, 0, 0}
#define KS_INIT_DIXON_DUALREADTRAP {KS_INIT_READWAVE, KS_INIT_DESC, 0,0,0,0,0.0,0, KS_INITVALUE(2,0),0,0.0,0,0,0,0.0,0.0, KS_INITVALUE(4,0)} /**< Default values for KS_DIXON_DUALREADTRAP sequence objects */

#if EPIC_RELEASE >= 27
#define RX27_APPLY_HADAMARD ,1
#else
#define RX27_APPLY_HADAMARD
#endif
#define KS_INIT_RFPULSE {NULL, NULL, 0.0,0.0,0.0,0.0,0.0,0,0.0,0.0,0.0,0.0,NULL,0.0,0.0,0,0,-1,0.0,NULL,0,NULL RX27_APPLY_HADAMARD} /**< Default values for GE's RF_PULSE structure */
#define KS_INIT_RF {KS_RF_ROLE_NOTSET, KS_NOTSET, KS_NOTSET, 0.0, 0.0, KS_NOTSET, KS_NOTSET, KS_NOTSET, KS_INIT_DESC, KS_INIT_RFPULSE, KS_INIT_WAVE, KS_INIT_WAVE, KS_INIT_WAVE} /**< Default values for KS_RF sequence objects */
#define KS_INIT_SELRF {KS_INIT_RF, KS_NOTSET, 1.0, KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_TRAP, KS_INIT_WAVE, KS_INIT_SMS_INFO} /**< Default values for KS_SELRF sequence objects */


#define KS_INIT_GRADRFCTRL {KS_INITZEROS(KS_MAXUNIQUE_RF), 0, KS_INITZEROS(KS_MAXUNIQUE_TRAP), 0, KS_INITZEROS(KS_MAXUNIQUE_WAVE), 0, KS_INITZEROS(KS_MAXUNIQUE_READ), 0, FALSE /* is_cleared_on_tgt */ } /**< Default values for KS_GRADRFCTRL control handler */
#define KS_INIT_SEQ_HANDLE {NULL, 0, NULL} /**< Default values for the KS_SEQ_HANDLE struct */
#define KS_INIT_SEQ_CONTROL {0, 0, 1000, 0, KS_NOTSET, FALSE, KS_INIT_DESC, KS_INIT_SEQ_HANDLE, KS_INIT_GRADRFCTRL} /**< Default values for the KS_SEQ_CONTROL struct */

#define KS_INIT_SEQ_COLLECTION {0, KS_SEQ_COLLECTION_ALLOWNEW, FALSE, KS_INITVALUE(KS_MAXUNIQUE_SEQUENCES, NULL)} /**< Default values for the KS_SEQ_CONTROL struct */
#define KS_INIT_SAR {0, 0, 0, 0} /**< Default values for the KS_SAR struct */
#define KS_INIT_SLICEPLAN {0,0,0,{{0,0,0}}}; /**< Default values for the KS_SLICE_PLAN struct */
#define KS_INIT_SMS_INFO {1, 0, 0} /**< Default values for the KS_INIT_SMS_INFO struct */

#define KS_INIT_LOGGRD {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } /**< Default values for GE's loggrd struct */
#define KS_INIT_PHYSGRD { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } /**< Default values for GE's phygrd struct */

#define KS_MAT3x3_IDENTITY {1,0,0,0,1,0,0,0,1} /**< Identity matrix initialization for KS_MAT3x3 */
#define KS_MAT4x4_IDENTITY {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1}/**< Identity matrix initialization for KS_MAT4x4 */

/*******************************************************************************************************
 *  Misc typedefs
 *******************************************************************************************************/
typedef char KS_DESCRIPTION[KS_DESCRIPTION_LENGTH]; /**< Char array used in all KS_**** sequence objects */
typedef float KS_WAVEFORM[KS_MAXWAVELEN]; /**< Waveform array for RF, Theta or custom gradients */
typedef short KS_IWAVE[KS_MAXWAVELEN]; /**< Interim short integer array to copy to hardware (internal use) */
typedef double KS_MAT3x3[9]; /**< Array to store a row major 3x3 matrix */
typedef double KS_MAT4x4[16]; /**< Array to store a row major 4x4 matrix */

/*******************************************************************************************************
 *  Plot related
 *******************************************************************************************************/
typedef enum {
  KS_PLOT_OFF,
  KS_PLOT_MAKEPDF,
  KS_PLOT_MAKESVG,
  KS_PLOT_MAKEPNG
} KS_PLOT_FILEFORMATS;
typedef enum {
  KS_PLOT_STANDARD,
  KS_PLOT_NO_EXCITATION
} KS_PLOT_EXCITATION_MODE;
typedef enum {
  KS_PLOT_PASS_WAS_DUMMY,
  KS_PLOT_PASS_WAS_CALIBRATION,
  KS_PLOT_PASS_WAS_STANDARD
} KS_PLOT_PASS_MODE;

/*******************************************************************************************************
 *  Basic sequence objects
 *******************************************************************************************************/

/** @brief #### `typedef struct` used as argument to `ks_pg_***` functions to control where and when to place a sequence object (e.g. KS_TRAP)

    For most sequence objects, the field `.board` should be one of:
    - XGRAD
    - YGRAD
    - ZGRAD
    - RHO
    - THETA
    - OMEGA

    For sequence objects operating on more than one gradient board at a time (like KS_EPI), the field `.board` denotes a combination of two axes:
    - KS_FREQX_PHASEY
    - KS_FREQY_PHASEX
    - KS_FREQX_PHASEZ
    - KS_FREQZ_PHASEX
    - KS_FREQY_PHASEZ
    - KS_FREQZ_PHASEY

    The `.ampscale` field must be in range [-1.0, 1.0] and modifies the designed KS_*** object on a per-instance basis. A few sequence functions (e.g. ks_pg_phaser()) ignores
    this value, but in general it is used to modify all, or a part, of a given KS_*** object


    ### Example

    \code{.c}
    @pg (TGT)
      KS_SEQLOC tmploc = KS_INIT_SEQLOC; // board-time-ampscale entity to control where and when a sequence object should be placed
      tmploc.board = XGRAD;
      tmploc.pos = 20ms;
      tmploc.ampscale = -1.0; // negate the amplitude of the KS_TRAP 'mytrap' designed by ks_eval_trap()
      ks_pg_trap(&mytrap, tmploc, ...); // place an instance of mytrap at absolute position 20ms (beginning of attack ramp) on XGRAD
    \endcode
*/
typedef struct _seqloc_s {
  int board;  /**< XGRAD, YGRAD, ZGRAD, RHO, OMEGA, THETA, KS_FREQX_PHASEY, KS_FREQY_PHASEX, KS_FREQX_PHASEZ, KS_FREQZ_PHASEX, KS_FREQY_PHASEZ, KS_FREQZ_PHASEY, KS_XYZ */
  int pos;   /**< Absolute position in [us] */
  float ampscale;  /**< Modifies the amplitude of the sequence object per instance (i.e. per `ks_pg_***()` call). Allowed range [-1.0, +1.0]. Ignored by e.g. ks_pg_phaser() */
} KS_SEQLOC;



/** @brief #### (*Internal use*) Structure being a part of various sequence objects to sort them in time across boards
 */
typedef struct _wfinstance_s {
  int boardinstance; /**< GE's instance number in the `WF_PULSE` struct associated with a sequence object (e.g. KS_TRAP) */
  WF_PULSE *wf; /**< pointer to one or more WF_PULSES that interact with hardware for current sequence object */
  KS_SEQLOC loc; /**< storage of KS_SEQLOC struct used for one particular instance for the current sequence object  */
} KS_WFINSTANCE;



/** @brief ####  (*Internal use*) Structure being a part of various sequence object to keep count of instances on HOST and TGT
 */
typedef struct _base_s {
  int ninst; /**< Number of instances of the object obtained by dry running the PG section in `cveval()` on HOST. base.ninst` used later on TGT for memory allocation */
  int ngenerated; /**< number of sequence objects actually placed in the `@pg` section on TGT. Checked against `base.ninst` */
  void *next; /**< pointer to the next object in the linked list */
  int size; /**< size of the parent object */
} KS_BASE;




/** @brief #### Core sequence object that adds wait periods in the pulse sequence (see ks_eval_wait(), ks_pg_wait()). Can be placed on any sequence board
    @image html KS_WAIT.png KS_WAIT
    <br>

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_wait() call(s)) that can be run on both HOST and TGT. This
    function should be called exactly once in `cveval()` (after ks_eval_wait() and other `ks_eval_***()` functions). ks_pg_wait() will throw an error on TGT if this has not been done.

    ### Example

    \code{.c}
    @ipgexport (HOST)
    KS_WAIT mywait = KS_INIT_WAIT;
    KS_SEQ_CONTROL seqctrl;

    @host
    cveval() {
      ks_eval_wait(&mywait, "mywaitname", duration);
    }

    @pg
      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 10ms;

      tmploc.board = XGRAD;
      ks_pg_wait(&mywait, tmploc, &seqctrl); // first instance (#0) on XGRAD at 10ms
      tmploc.board = YGRAD;
      ks_pg_wait(&mywait, tmploc, &seqctrl); // a second instance (#1) on YGRAD at 10ms
      tmploc.board = ZGRAD;
      ks_pg_wait(&mywait, tmploc, &seqctrl); // a third instance (#2) on ZGRAD at 10ms

    @rsp (TGT)
    scan() {
      ks_scan_wait(&mywait, INSTRALL, 2ms); // will change the period of all instances of this KS_WAIT object to 2 ms
    }

    \endcode
*/
typedef struct _wait_s {
  KS_BASE base; /**<  *Internal use* */
  KS_DESCRIPTION description; /**< Descriptive string for the wait object */
  int duration; /**< Duration of the wait object in [us] */
  KS_SEQLOC locs[KS_MAXINSTANCES]; /* to allow generation of PSD plots on HOST */
  WF_PULSE *wfpulse;  /**< *Internal use* */
  KS_WFINSTANCE *wfi; /**< *Internal use* */
} KS_WAIT;



/** @brief #### Struct for in-sequence rotations using ISI vector interupts
*/
typedef struct _isirot_s {
  KS_WAIT waitfun; /**< First SSP packet that assigns the ISI number to hardware to execute the rotation function */
  KS_WAIT waitrot; /**<  Second SSP packet that performs the rotation matrix interrupt */
  SCAN_INFO *scan_info; /**< Array of scan_info structs, with as many elements as calls to ks_pg_isirot() */
  int isinumber; /**< A free (not used) isi number in range [4,7] */
  int duration; /**< The sum of durations of the two WAIT (SSP) pulses */
  int counter; /**< Run-time counter, initialized to 0 by ks_pg_isirot() */
  int numinstances; /**< The number of times placed out in the sequence and the number of elements in scan_info */
} KS_ISIROT;


/** @brief #### Core sequence object for making trapezoids on X,Y,Z, and OMEGA boards
    @image html KS_TRAP.png KS_TRAP
    <br>

    When making trapezoids on X, Y, or Z boards, the amplitude units are [G/cm], while units are arbitrary on OMEGA.

    First note that for RF slice selection, phase encoding, or readouts there are *other* sequence objects and functions that in use their own KS_TRAPs internally.

    Direct use of KS_TRAP objects applies only to cases where a standalone gradient with a certain area is desired, usually acting as a gradient spoiler.
    To add a trapezoid to a pulse sequence as e.g. a gradient spoiler, first declare a KS_TRAP sequence object in the `@ipgexport` section (see example below).
    In `cveval()`, the desired area of the trapezoid (unit: [(G/cm) us]) is then set by assigning a value to the `.area` field in the KS_TRAP object.
    This serves as input information, from which the duration, ramptime, and amplitude is calculated by calling ks_eval_trap().
    The second argument to ks_eval_trap(..., "name", ...) is the *description* that is inserted into the `.description` field of the KS_TRAP.
    On TGT, this name is also used in when naming the WF_PULSEs internally, with a '.#' suffix added at the end, where '#' is the first letter of the board
    it is placed on. Hence, for a description called "myspoiler", it will appear in TimeHist in *MGD Sim/WTools* as `myspoiler.xa` (ramp-up), `myspoiler.x` (plateau),
    and `myspoiler.xd` if it is placed on board XGRAD.

    The general function for setting up a KS_TRAP is ks_eval_trap(), where slewrate and gradient amplitude are constrained by the default system
    limits to allow for *simultaneous* use on all 3 axis at the same time. The slewrate and gradient amplitude limits can be slacked if one
    can be sure that the KS_TRAP will be used on one or two axes at a time, by instead calling ks_eval_trap1() or ks_eval_trap2(). The difference is
    seen for (double) oblique slices, where strong slice angulation and the use of ks_eval_trap1() can produce up to 3x stronger gradient than ks_eval_trap().
    These `ks_eval_trap***()` functions are all calling the one and same ks_eval_trap_constrained() function, where slewrate and gradient amplitude limits as
    well as minimum plateautime are explicitly given as input arguments. This function can also be called directly. In summary, call:

    - ks_eval_trap()  - for generic use
    - ks_eval_trap1() - if this trapezoid will be placed on one board at a time, with no other gradients running on other boards simultaneously. This will
                        increase the maximum amplitude for double oblique scans by up to 3 times.
    - ks_eval_trap2() - if this trapezoid will be placed on at most two boards at a time with no other gradients running on other boards simultaneously
    - ks_eval_trap_constrained() - if manual control of slewrate, gradient max and minimum plateau time is desired

    Once a KS_TRAP object has been *designed* using ks_eval_trap(), the same KS_TRAP object can be freely placed on XGRAD, YGRAD and ZGRAD
    as many times as desired, by only changing the second argument each time (to avoid waveform overlaps). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD (or OMEGA)
    - `.pos`: Absolute time in [us] of the start of the attack ramp of the trapezoid
    - `.ampscale`: A factor that must be in range [-1.0,1.0] that is multiplied with `.amp` to yield a per-instance (i.e. per-placement) amplitude ([G/cm]).
    The simplest is to use 1.0, which makes the KS_TRAP object to be placed out on the board as initially designed using ks_eval_trap().

    NOTE: Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_TRAP object is placed, the *instance* number of the KS_TRAP
    is automatically sorted in time. If two instances of one KS_TRAP occur at the same time (`.pos`) on different boards, XGRAD comes before YGRAD, which comes before ZGRAD.
    These abstract, sorted, instance numbers are used by `ks_scan_***() functions in scan() to refer to a specific instance of a KS_TRAP object in the sequence.

    When a trapezoid is placed on OMEGA, neither the designed amplitude (`.amp` field in KS_TRAP) nor the `.ampscale` (in KS_SEQLOC) has an effect on the final frequency modulation.
    Instead the run-time amplitude of a KS_TRAP object on the OMEGA board is controlled in scan() via a function called ks_scan_omegatrap_hz().

    Advanced tip: After calling ks_eval_trap(), the field `.duration` will correspond to the total duration of the trapezoid. If one manually sets this field to 0
    (after ks_eval_trap()), ks_pg_trap() will detect the zero duration and ignore placing this out in the `@pg` section without an error.
    This can sometimes be a convienient way of conditionally or temporarily disable a trapezoid.
    Moreover, sequence dependent timing functions also see this trapezoid having zero duration, making timing calculations to correspond
    well to the ignored placement of the trapezoid in the `@pg` section.

    In scan() on TGT, the amplitude of each instance of the KS_TRAP object can be individually scaled in run-time using ks_scan_trap_ampscale().
    The third argument to this function is another amplitude scaling factor that must be in range [-1.0,1.0]. The final amplitude of the trapezoid in [G/cm]
    becomes the product of the following:
    - `.amp ` field of KS_TRAP (set by ks_eval_trap() in `cveval()`)
    - `.ampscale` field of KS_SEQLOC (2nd arg to ks_pg_trap() in the `@pg` section that alters each instance)
    - 3rd argument to ks_scan_trap_ampscale()

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_trap() call(s)) that can be run on both HOST and TGT. This
    function should be called exactly once in `cveval()` (after ks_eval_trap() and other `ks_eval_***()` functions). ks_pg_trap() will throw an error on TGT if this has not been done.
    See KS_SEQ_CONTROL for an example

    The `.gradnum[]` array is modified by ks_pg_trap() when run on HOST, to keep count of how many times the KS_TRAP will be placed in the `@pg` section. This information is used
    in ks_eval_gradrflimits() together with the sequence module's common KS_SEQ_CONTROL object to calculate gradient heating limits for the sequence module.


    ### Example

    \code{.c}
    @ipgexport (HOST)
    KS_TRAP mytrap = KS_INIT_TRAP;
    KS_SEQ_CONTROL seqctrl;

    @host (HOST)
    cveval() {
      mytrap.area = 1000.0; // [(G/cm)*us]
      ks_eval_trap(&mytrap, "myspoiler");
    }

    @pg
      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.board = XGRAD;
      tmploc.pos = 10ms;
      tmploc.ampscale = 1.0;

      ks_pg_trap(&mytrap, tmploc, &seqctrl); // first instance (#0) of this trap in the sequence

      tmploc.pos += mytrap.duration;
      tmploc.ampscale = -1.0;

      ks_pg_trap(&mytrap, tmploc, &seqctrl); // a second instance (#1) of this trap right after the 0th, with negative amplitude

    @rsp (TGT)
    scan() {
      ks_scan_trap_ampscale(&mytrap, 0, 0.68); // will make the amplitude 0.68 times the original amp for the 0-th instance of this KS_TRAP
    }
    \endcode
*/
typedef struct _trap_s {
  KS_BASE base; /**<  *Internal use* */
  KS_DESCRIPTION description; /**< Descriptive string for the KS_TRAP object with maximum KS_DESCRIPTION_LENGTH characters */
  float amp;   /**< Gradient amplitude in [G/cm]   */
  float area;   /**< Gradient area in [(G/cm)*us]   */
  int ramptime;   /**< Duration of each ramp of the trapezoid in [us] */
  int plateautime; /**< Duration of the plateau of the trapezoid in [us] */
  int duration;   /**< Duration of the entire trapezoid (plateautime + 2*ramptime) in [us]   */
  int gradnum[3]; /**<  *Internal use* for gradient heating calculations */
  KS_SEQLOC locs[KS_MAXINSTANCES]; /* to allow generation of PSD plots on HOST */
  WF_PULSE **wfpulse; /**< *Internal use* */
  KS_WFINSTANCE *wfi; /**< *Internal use* */
  float *rtscale; /**< *Internal use* */
} KS_TRAP;



/** @brief #### Core sequence object making arbitrary waveforms on any board (using float data format)
    @image html KS_WAVE.png KS_WAVE
    <br>

    The KS_WAVE sequence object contains a KS_WAVEFORM (`float[KS_MAXWAVELEN]`) to hold the waveform. The physical unit of the waveform in the KS_WAVE
    object depends the board on which it is placed in pulsegen(). For the
    - gradient boards (XGRAD, YGRAD, ZGRAD), the unit is [G/cm]
    - THETA board, the unit is [degrees]
    - RF and OMEGA boards, the units are arbitrary (c.f. ks_eval_rf() and ks_eval_wave())

    Similar to the KS_TRAP sequence object, KS_WAVE is a core object used in other objects such as KS_RF. For RF pulse generation, direct use of
    KS_WAVE functions in e.g. `cveval()` or in the `@pg` section should be *avoided* as there is no mechanism to do the proper RF scaling. For RF, use instead KS_RF and KS_SELRF.

    Placing out a KS_WAVE is done in the `@pg` section using ks_pg_wave().
    A key feature with ks_pg_wave() is that all waveforms are double buffered. This allows replacing waveforms in run-time (scan()) from TR to TR. As ks_pg_wave() is used
    for all sequence objects dealing with waves, RF pulses, THETA, and OMEGA waveforms in the KS_RF objects are all double buffered as well.
    To replace a waveform in scan(), the function ks_scan_wave2hardware() is used.

    The `.gradnum[]` field is modified by ks_pg_wave() on HOST to keep count of how many times the KS_WAVE has been placed in the `@pg` section. This information is used
    in ks_eval_gradrflimits() together with the sequence's common KS_SEQ_CONTROL object to calculate gradient heating limits for the sequence.

    NOTE: Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_WAVE object is placed, the *instance* number of the KS_WAVE
    is automatically sorted in time. If two instances of one KS_WAVE occur at the same time (`.pos`) on different boards, XGRAD comes before YGRAD, which comes before ZGRAD.
    These abstract, sorted, instance numbers are used by ks_scan_***() functions in scan() to refer to a specific instance of a KS_WAVE object in the sequence. However,
    unlike KS_TRAP, replacing e.g. a waveform in run-time for an instance of a KS_WAVE will affect all instances on the same board. This, since there is only one hardwave
    waveform per board for each KS_WAVE.

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_wave() call(s)) that can be run on both HOST and TGT. This
    function should be called exactly once in `cveval()` (after ks_eval_wave() and other `ks_eval_***()` functions). ks_pg_wave() will throw an error on TGT if this has not been done.
    See KS_SEQ_CONTROL for an example

    ### Example

    \code{.c}
    @ipgexport (HOST)
    KS_WAVE mywave = KS_INIT_WAVE;
    KS_SEQ_CONTROL seqctrl;

    @host
    cveval() {

      ks_eval_wave(&mywave, "mywavedesc", res, duration, some_floatarray);
      ...or...
      ks_eval_wave_file(&mywave, "mywavedesc", res, duration, "myfilename", "float"); // read from disk in float format (no header)
      ...or...
      ks_eval_wave_file(&mywave, "mywavedesc", res, duration, "myfilename", "short"); // read from disk in short format (no header)
      ...or...
      ks_eval_wave_file(&mywave, "mywavedesc", res, duration, "myfilename", "ge"); // read from disk in GE's external wave format

    }

    @pg
      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 10ms;
      tmploc.board = XGRAD;
      ks_pg_wave(&mywave, tmploc, &seqctrl); // Same wave object *can* be placed on multiple boards (but not recommended as the units differ between gradient and RF/OMEGA boards)

    @rsp (TGT)
    scan() {
      ...fill in mywave.wave[] with new content, then call...
      ks_scan_wave2hardware(&mywave, 0); // updates hardware waveform on the board corresponding to instance 0 with new content in mywave.wave[]
    }
    \endcode


*/
typedef struct {
  KS_BASE base; /**<  *Internal use* */
  KS_DESCRIPTION description; /**< Descriptive string for the KS_WAVE object with maximum KS_DESCRIPTION_LENGTH characters */
  int res; /**< Number of sample points in wave */
  int duration; /**< Duration in [us]. Must divisible with .res */
  KS_WAVEFORM waveform; /**< Waveform in [G/cm] (XGRAD, YGRAD, ZGRAD), [degrees] (THETA). Boards RHO and OMEGA have arbitrary units */
  int gradnum[3]; /**< *Internal use* for gradient heating calculations */
  int gradwave_units;
  KS_SEQLOC locs[KS_MAXINSTANCES]; /* to allow generation of PSD plots on HOST */
  WF_PULSE **wfpulse; /**< *Internal use* */
  KS_WFINSTANCE *wfi; /**< *Internal use* */
  float *rtscale; /**< *Internal use* */
} KS_WAVE;



/** @brief #### Core sequence object that handles a data acquisition window
    @image html KS_READ.png KS_READ
    <br>

    The KS_READ core sequence object is responsible for acquiring data in a certain time window using some receiver bandwidth [kHz]. Direct use of KS_READ
    applies to cases like MR spectroscopy where no gradients are involved during data acquisition. It can also be used together with a KS_WAVE to make
    arbitrary non-Cartesian readouts (as there is currently no composite object ready to handle non-Cartesian readouts).

    The information necessary for an acquisition window is:
    - `.rbw`  - the desired receiver bandwidth / FOV in [kHz] (max: 250)
    - `.duration` - the duration in [us]

    On calling ks_eval_read() in `cveval()` the function will validate the desired rBW and round it to the nearest valid value. Also the duration will be rounded up
    to fit a whole number of samples in the acquisition window.

    NOTE: Regardless of the order the KS_READ object is placed out in the `@pg` section, its *instance* index is automatically sorted in time, like KS_TRAP and KS_WAVE.
    Hence, `myacqwin.echo[0]` in the example below will always be the first acquisition window in time belonging to this KS_READ object. The number of instances of
    each KS_READ object in the sequence is given by `.base.ngenerated` (on TGT) and `.base.ninst` (on HOST). In scan(), use `.base.ngenerated` instead of
    relying on other variables such as `opnecho` when e.g. calling `loaddab()`.

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_read() call(s)) that can be run on both HOST and TGT. This
    function should be called exactly once in `cveval()` (after ks_eval_read() and other `ks_eval_***()` functions). ks_pg_read() will throw an error on TGT if this has not been done.

    ### Example

    \code{.c}
    @ipgexport (HOST)
    KS_READ myacqwin = KS_INIT_READ;

    @host
    cveval() {
      myacqwin.rbw = 31.25; // kHz/FOV
      myacqwin.duration = 8ms;
      ks_eval_read(&myacqwin, "myreadout");
    }

    @pg

      for (echoindx = 0; echoindx < opnecho; echoindx++){
        ks_pg_read(&myacqwin, 10ms + echoindx*(10ms)); // Data acquisition w/o gradients could be used for e.g. spectroscopy
      }

    @rsp (TGT)
    scan() {
      for (echoindx = 0; echoindx < myacqwin.base.ngenerated; echoindx++) {
           loaddab(&myacqwin.echo[echoindx], sliceindx, echoindx, DABSTORE, dabview, DABON, PSD_LOAD_DAB_ALL);
      }
    }
    \endcode
*/
typedef struct _acq_s {
  KS_BASE base; /**< *Internal use* */
  KS_DESCRIPTION description;  /**< Descriptive string for the KS_READ object with maximum KS_DESCRIPTION_LENGTH characters */
  int duration; /**< Duration of the acquisition window in [us] */
  float rbw; /**< Receiver bandwidth per FOV in [kHz] (max: 250) */
  FILTER_INFO filt; /**< GE's standard filter structure (used in e.g. setfilter()) */
  int pos[KS_MAXUNIQUE_READ]; /* to allow generation of PSD plots on HOST */
  WF_PULSE *echo; /**< N.B.: We need one WF_PULSE per instance so KS_WFINSTANCE is not needed for KS_READ */
} KS_READ;



/** @brief #### Composite sequence object for RF (with optional OMEGA & THETA pulses)
    @image html KS_RF.png KS_RF
    <br>

    The composite KS_RF sequence object holds all information necessary to create RF pulses, both real and freq/phase modulated ones.
    For RF pulses with slice selection, use a KS_SELRF object instead, which contains a KS_RF object and KS_TRAP objects. The KS_RF object (be it standalone or
    a part of KS_SELRF) needs to be set up along the lines described here

    ### RF Design

    Independent of the design method chosen (see below), KS_RF has some field members worth mentioning:
    - `.role`: This is a label for the *role* of the RF pulse. This information is primarily used by ks_eval_selrf() to determine what gradients to apply
      for slice selection. Valid values for `.role` are
      - KS_RF_ROLE_EXC (for excitation)
      - KS_RF_ROLE_REF (for refocusing)
      - KS_RF_ROLE_CHEMSAT (for fat-sat, non-slice selective)
      - KS_RF_ROLE_INV (for inversion)
      - KS_RF_ROLE_SPSAT (for spatial saturation)
    - `.flip`: The desired flip angle of the RF pulse [degrees]
    - `.bw`: The bandwidth of the RF pulse [Hz]
    - `.iso2end` and `.start2iso`: These fields are for convenience and easier timing calculations and are set in ks_eval_rf().
       The value of `.iso2end` is equal to `.rfpulse.isodelay` and refers to the time from the effective center of the RF pulse to the end.
       Field `.iso2end` must have a correct value before calling ks_eval_rf().
       The `.start2iso` field is the time from the beginning of the RF pulse to its effective center, calculated as `.rfwave.duration - .iso2end` in ks_eval_rf()
    - `.cf_offset`: is used to change the relative center frequency for non-slice selective RFs. A typical application is non-slice selective
       fat saturation.
    - `.designinfo`: is an optional string to keep track of useful RF design details (mostly for debugging purposes), and it is up to the
       user to fill this in, except for some pre-generated RF pulses available in KSFoundation_GERF.h
    - `.amp`: This field is set to 1 by ks_eval_rf(), but will get a proper value after calling GEReq_eval_rfscaling().
       The value of `.amp` is used in the `@pg` section by ks_pg_rf() to properly amplitude scale the actual RF waveform before internally calling ks_pg_wave()
       using the `.rfwave` field.

    #### Method 1: Using pre-defined KS_RF objects
    The simplest way to create a KS_RF object is to use one of the RF pulses in GE's product sequences, some of which are available in KSFoundation_GERF.h.
    To use these ready-made RF pulses, perform the following steps:
    1. Declare a KS_RF object in the `@ipgexport` section
       - `KS_RF myrf = KS_INIT_RF;`
    2. Assign the KS_RF object after choosing one in KSFoundation_GERF.h
       - e.g. `myrf = exc_fse90;`
    3. Call ks_eval_rf() or ks_eval_selrf() to name and initialize the RF pulse

    The field `.flip` can be changed anytime between ks_eval_rf() and GEReq_eval_rfscaling(), e.g. by setting `.flip = opflip`

    #### Method 2: Creating Sinc RF pulses
    For small flip angles, the Fourier transform of the RF envelope is a good approximation of the final slice profile and SLR designed pulses may not be necessary.
    For these cases, the function ks_eval_rf_sinc() can be used to create a Sinc RF pulse (as a KS_RF object) with a desired
    bandwidth (BW), time-bandwidth-product (TBW) and window function (e.g. KS_RF_SINCWIN_HAMMING), as follows:
    1. Declare a KS_RF object in the `@ipgexport` section
       - `KS_RF mysincrf = KS_INIT_RF;`
    2. Call ks_eval_rf_sinc() to populate the KS_RF object
       - The *duration* of the RF pulse (`mysincrf.rfwave.duration`) depends on the chosen BW and TBW
    3. Assign the *role* of the RF pulse
       - `mysincrf.role = KS_RF_ROLE_EXC; // or KS_RF_ROLE_REF, KS_RF_ROLE_INV, KS_RF_ROLE_CHEMSAT`

    Note that in most scenarios a KS_SELRF is used instead of a KS_RF, as Sinc RFs are typically used with slice selection. Hence, in practice,
    a KS_SELRF should be declared, and the above procedure should be applied to the `.rf` field (of type KS_RF) in the KS_SELRF object.

    #### Method 3: Creating custom RF pulses
    Another method is to copy a waveform designed elsewhere into the `.rfwave` (KS_WAVE) field of the KS_RF object.
    This can be done from either memory (ks_eval_wave()) or disk (ks_eval_wave_file()).

    Assuming we have an RF envelope in some float array `myexternalrfwave[]`, the following steps are performed:
    1. Declare a KS_RF object in the `@ipgexport` section
       - `KS_RF mycustomrf = KS_INIT_RF;`
    2. Call ks_eval_wave() as `ks_eval_wave(&mycustomrf.rfwave, "", res, duration, myexternalrfwave);`
       - If the RF pulse should use a THETA or OMEGA waveform, do the same procedure for the fields `.thetawave` and/or `.omegawave`
       - *res* should be number of elements in *myexternalrfwave*
       - *duration* (in [us]) must be an integer multiple (>= 2x) of *res*
    3. Assign the following fields manually:
       - `.role`
       - `.flip` [degrees] (will also be the nominal flip angle)
       - `.bw` [Hz]
       - `.iso2end` [us]    (the time from effective center of the RF pulse to the end)
    4. Call ks_eval_rfstat() to populate the RF_PULSE struct (`mycustomrf.rfpulse`) that is needed for RF scaling and SAR calculations
       - Note that ks_eval_rfstat() only works for real RF pulses (without THETA or OMEGA waveforms). For complex RF pulses, the `.rfpulse` struct
         needs to be set up manually
    5. Call ks_eval_rf() or ks_eval_selrf() to name and initialize the RF pulse, and to let the KS_SEQ_CONTROL struct link to it for later RF scaling
       in ks_eval_gradrflimits()


    ### Automatic RF scaling and SAR calculations (for sequences written entirely using KSFoundation)
    First make sure there is a separate *sequence making function* in the `@pg` section that holds all function calls to the various `ks_pg_***()` functions building up the sequence.
    E.g. there is a ksfse_pg() function in ksfse.e.
    - It is crucial that this function, only when called on HOST at the end of the function, sets `seqctrl.min_duration` to a value corresponding to the number of us to the end of the sequence module (see example below).
    - As this *sequence making function*  is to be played out in both `cveval()` (on HOST) and in `pulsegen()` in the `@pg` section (on TGT), UsePgenOnHost() must be set in the Imakefile
    - Multiple sequence modules (such as main sequence, FatSat, Inversion etc.), each with its own KS_SEQ_CONTROL handle and sequence making function, are added to one common KS_SEQ_COLLECTION for
      all sequence modules involved. This KS_SEQ_COLLECTION struct is passed both to RF scaling (GEReq_eval_rfscaling()) and SAR handling (GEReq_eval_checkTR_SAR(), which calls ks_eval_gradrflimits()) routines.
    - Please see KS_SEQ_COLLECTION for more information on the order of events necessary in `cveval()` to perform RF scaling and SAR handling. **


    ### Example for a pulse sequence entirely written in KSFoundation

    \code{.c}
    @ipgexport (HOST)
    KS_RF myfatsat = KS_INIT_RF;
    KS_SEQ_CONTROL seqctrl;

    @host

    cveval() {
      KS_SEQ_COLLECTION seqcollection;
      ks_init_seqcollection(&seqcollection);

      if (cffield == 30000)
        myfatsat = chemsat_cs3t; // chemsat_cs3t is a const KS_RF declared in KSFoundation_GERF.h
      else
        myfatsat = chemsat_csm; // chemsat_csm is a const KS_RF declared in KSFoundation_GERF.h

      ks_eval_rf(&myfatsat, "myfatsat");

      mypsd_pg(); // at the end of mypsd_pg(), seqctrl.min_duration needs to be set to the absolute end time in [us] of this sequence (module)

      // add this sequence module to the sequence collection
      ks_eval_addtoseqcollection(&seqcollection, &seqctrl);

      // perform RF scaling using all sequence modules to be used (e.g. main sequence, FatSat, Inversion etc.)
      GEReq_eval_rfscaling(&seqcollection);

      // TR timing, slice ordering and SAR calcs, in four steps.
      // Here we assume there is a wrapper function (mysliceloop_nargs(int slperpass, int nargs, void **args)) to the sequence's sliceloop function (e.g. mysliceloop()),
      // where e.g. mysliceloop_nargs(7, 0, NULL) plays out seven 2D slices and returns the slice loop duration in [us]
      // Also, it is assumed the the sliceloop function calls ks_scan_playsequence() to accumulate the time required for all its sequence modules

      // Step 1: Calculate # slices per TR and how much spare time we have within the current TR by running the slice loop
      //         Output 1: slperpass - Number of slices that fit within the selected TR (optr)
      //         Output 2: timetoadd_perTR - The necessary filling time to reach the set TR, given slperpass slices
      GEReq_eval_TR(&slperpass, &timetoadd_perTR, 0, seqcollection, mysliceloop_nargs, 0, NULL);

      // Step 2: Calculate the slice plan (slice sorting over one or more passes) and passes (acqs) for normal interleaved 2D imaging
      //          ks_slice_plan is passed to GEReq_predownload_store_sliceplan() in predownload()
      ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);

      // Step 3: Spread the available `timetoadd_perTR` evenly on the main sequence module, by increasing the .duration of each slice by timetoadd_perTR/slperpass
      seqctrl.duration = RUP_GRD(seqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

      // Step 4: Check that TR is fullfilled by dryrunning the slice loop with updated seqctrl.duration fields for the sequence modules involved.
      //         Update SAR values in the UI (error will occur if the sum of sequence durations differs from optr)
      GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, mysliceloop_nargs, 0, NULL);

    } // end of cveval()


    @pg

    void mypsd_pg() {
      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 1ms;
      ks_pg_rf(&myfatsat, tmploc, &seqctrl); // play the fat-sat RF pulse, beginning at 1ms into the sequence

      tmploc.pos = 20ms;
      tmploc.ampscale = 0.5;
      ks_pg_rf(&myfatsat, tmploc, &seqctrl); // contrived example where a 2nd instance of the RF pulse is played out at 20ms with half the flip angle

      tmploc.pos += myfatsat.rfwave.duration; // time for the end of last sequence entry

    #ifndef IPG
        // HOST only (make also sure, seqctrl.ssi_time > 0 before calling this function):
        ks_eval_seqctrl_setminduration(&seqctrl, tmploc.pos);
    #endif
    }

    pulsegen() {
       mypsd_pg();
       KS_SEQLENGTH(seqcore, seqctrl); // The only KSFoundation EPIC Macro - KS_SEQLENGTH() - which takes a KS_SEQ_CONTROL object as 2nd arg
    }


    @rsp (TGT)
    scan() {
       ...for run-time amplitude modulation of the 1st instance of the RF pulse (i.e. the one at 20ms), call...
       ks_scan_rf_ampscale(&myfatsat, 0, 0.5); // reduces the 1st instance of the RF pulse by another factor of 2

       ks_scan_rf_off(&myfatsat, 0); // turn OFF the 0th instance of the RF pulse
       ks_scan_rf_on(&myfatsat, 0); // turn ON the 0th instance of the RF pulse
       ks_scan_rf_on_chop(&myfatsat, 0); // turn ON the 0th instance and toggle the sign of the RF pulse every time it is called
    }
    \endcode

    ### RF scaling when KS_RF object(s) are added to an *existing standard EPIC* sequence
    When KS_RF objects are added to an existing GE product sequence (or any other standard EPIC sequence), RF scaling and SAR calculations
    are already taken care of for the non-KSFoundation RF-pulses. To include also the KS_RF pulses (including the KS_RF objects in KS_SELRF) as
    a part of the main sequence's RF scaling, the following steps are needed:
    1. Add one new *SLOT* in the `rfpulse[]` struct array for each KS_RF (or KS_SELRF) object by editing `grad_rf_<psdname>.h`. The file `grad_rf_empty.h` in
       the KSFoundation folder can be used as a template. This only serves a place holder to fill up space in `rfpulse[]`, and no need to
       edit the `grad_rf_<psdname>.h` further
    2. Increase `RF_FREE1` (sometimes `RF_FREE2`) in `grad_rf_<psdname>.globals.h` and add `defines` for the new slots
    3. After setting up the KS_RF objects using one of the methods above, make sure the `.rfpulse` field of each KS_RF object has the fields:
       - `.activity = PSD_SCAN_ON`
       - `.num = <number of instances of this KS_RF object in the sequence>`
    4. Copy the `.rfpulse` field of each KS_RF object in to each corresponding *SLOT* in the `rfpulse[]` array. E.g.:
       - `rfpulse[MYOWNFATSAT_SLOT] = myfatsat.rfpulse;` where `MYOWNFATSAT_SLOT` has been defined as an available number less than RF_FREE1
         in `grad_rf_<psdname>.globals.h`
*/

typedef struct _rf_s {
  int role; /**< The **purpose** of the RF pulse. Valid values: `KS_RF_ROLE_EXC, KS_RF_ROLE_REF, KS_RF_ROLE_CHEMSAT, KS_RF_ROLE_INV, KS_RF_ROLE_SPSAT` */
  float flip; /**< The flip angle in [degrees] */
  float bw; /**< The bandwidth of the RF pulse [Hz] */
  float cf_offset; /**< Center frequency offset in [Hz] for non-slice selective RF. Use e.g. 0 for water, 220 (1.5T) or 440 (3T) for fat */
  float amp; /**< Relative amplitude, **not** in [G], set by GE's RF scaling routines using ks_eval_gradrflimits()  */
  int start2iso; /**< Time from start of RF pulse to its magnetic center in [us] */
  int iso2end; /**< Time from the magnetic center of the RF pulse to the end in [us] */
  int iso2end_subpulse; /**< Time for last subpulse to end of RF waveform. Used by SPSP */
  KS_DESCRIPTION designinfo;  /**< Descriptive string regarding the RF pulse design with maximum KS_DESCRIPTION_LENGTH characters */
  RF_PULSE rfpulse; /**< *Internal use* (`typedef struct RF_PULSE`) */
  KS_WAVE rfwave; /**< KS_WAVE object for RF. Unit: [a.u.] */
  KS_WAVE omegawave; /**< Optional KS_WAVE object for OMEGA (frequency modulation). Unit: [a.u.] */
  KS_WAVE thetawave; /**< Optional KS_WAVE object for THETA (phase modulation). Unit: [degrees] */
} KS_RF;




/** @brief #### `typedef struct` that is a part of the KS_SEQ_CONTROL `typedef struct`, used internally to collect gradient & RF usage for heating and SAR calcs. Should not be used directly.

    KS_TRAP and KS_WAVE generate gradient heating and KS_RF generates both SAR to the patient and RF amplifier heating, and all three sequence objects
    must also produce waveforms that stay within the system power limits.

    Each sequence module of a pulse sequence (incl. the main sequence module) must have a KS_SEQ_CONTROL, which in turn contains a KS_GRADRFCTRL that can
    reach each RF, TRAP, and WAVE object in that sequence module. For more information, see KS_SEQ_CONTROL and KS_SEQ_COLLECTION.
*/
typedef struct _gradrfctrl_s {
  KS_RF *rfptr[KS_MAXUNIQUE_RF]; /**< allow max KS_MAXUNIQUE_RF, see also grad_rf_empty*h */
  int numrf;  /**< Number of *unique* KS_RF in the sequence */
  KS_TRAP *trapptr[KS_MAXUNIQUE_TRAP]; /**< allow max KS_MAXUNIQUE_TRAP different KS_TRAP */
  int numtrap; /**< Number of *unique* KS_TRAP in the sequence */
  KS_WAVE *waveptr[KS_MAXUNIQUE_WAVE]; /**< allow max KS_MAXUNIQUE_WAVE different KS_WAVE */
  int numwave; /**< Number of *unique* KS_WAVE in the sequence */
  KS_READ* readptr[KS_MAXUNIQUE_READ]; /**< Allow max KS_MAXUNIQUE_READ readout instances */
  int numacq; /** Number of readout instances */
  int is_cleared_on_tgt; /**< flag indicating if gradrfctrl has been initialized on tgt */
} KS_GRADRFCTRL;



/**
 * @brief #### Internal `typedef struct` that is a part of the KS_SEQ_CONTROL `typedef struct`. Should not be used directly
 *
 * KS_SEQ_HANDLE is used internally by the KS_SEQLENGTH() macro to define the end of the sequence module in \@pg and by
 * ks_scan_playsequence() on TGT during scanning to switch sequence module by calling ks_scan_switch_to_sequence()->boffset()
 */
typedef struct _seq_handle_s {
  long *offset;
  int index;
  WF_PULSE *pulse;
} KS_SEQ_HANDLE;



/** @brief #### A multi-purpose controller struct for each sequence module to facilitate RF scaling, SAR calculations, sequence duration and sequence switching
    @image html KS_SEQ_CONTROL.png KS_SEQ_CONTROL
    <br>

    Each sequence module in the pulse sequence should have a dedicated KS_SEQ_CONTROL struct associated with it. For example, one may have the following KS_SEQ_CONTROL structs in a pulse sequence,
    where there is one main sequence and an fatsat module plugin that technically are two sequences - or sequence modules - (via the use of KS_SEQLENGTH()):
    - mymainseqctrl    - Sequence control for the main sequence, i.e. the only sequence that is storing data (the *actual* sequence)
    - fatsatseqctrl - Sequence control for the fatsat sequence module

    The KS_SEQ_CONTROL struct has multiple uses and could be viewed as the *administrator* for each sequence module. Here is a list of uses and steps neccesary to achieve the intended functionality:

    #### In `cveval()` on HOST:

    - Collection of information on how many times each KS_TRAP or KS_RF object is placed out in `pulsegen()` for the particular sequence module.
      - Preferrably, there is a *sequence generating function* that may be named e.g. *seqmodulename*`_pg()`, which contains all ks_pg_trap(), ks_pg_rf() (and other `ks_pg_***()`) calls that
        build up the sequence module by placing out its sequence objects. The KS_SEQ_CONTROL struct for the current sequence module should be the last argument to each `ks_pg_***()` call in *seqmodulename*`_pg()`.
      - By running *seqmodulename*`_pg()` in `cveval()` the `seqctrl.gradrf` field will be updated with pointers to its sequence objects, allowing `seqctrl` to also know the number of occurrences of each trapezoid or RF.
      - This information is used for RF scaling, gradient heating and SAR calculations, after adding the sequence modules to one common KS_SEQ_COLLECTION struct using ks_eval_addtoseqcollection().
    - Somewhere in `cveval()`, the SSI time for the sequence modules needs to be set. This is the time the sequence module needs to update its waveforms from one playout to the next during scanning.
      Often 1 ms is enough, but for long sequence modules it may need to be increased, especially if debugging outputs are used. It can also be set lower, sometimes down to about 0.1 ms.
    - In `cveval()`, the *seqmodulename*`_pg()` function for each sequence module should be called *after* the `ks_eval_***()` calls setting up the sequence objects, but *before* the TR timing, RF scaling and SAR calculations.
      Inside each *seqmodulename*`_pg()` function the `.duration` and `.min_duration` fields of the KS_SEQ_CONTROL struct should be set to the actual minimum duration
      of the sequence module (the [us] value corresponding to the absolute position of the last gradient or RF waveform). See ks_eval_seqctrl_setminduration() in the example below.


    #### On TGT:

    - In `pulsegen()`: The KS_SEQ_CONTROL struct is the 2nd arg to KS_SEQLENGTH(), which defines the hardware sequence duration (using the `seqctrl.duration` value) for the sequence module.
      Using KS_SEQLENGTH() instead of GE's SEQLENGTH() macro allows sequence module playouts, and switching between modules, in `scan()` using ks_scan_playsequence().
    - In `scan()`, and its psd-specific subroutines: The KS_SEQ_CONTROL struct is passed to ks_scan_playsequence() to switch to and play out this sequence module in real time during scanning. ks_scan_playsequence() also returns `seqctrl.duration`, allowing
      timing checks on HOST by dry-running scan functions in `cveval()`. E.g. the scan clock is set by GE's `pitscan` variable, which can be set by calling `scanloop()` in the simplified example below.



    ### Example use of KS_SEQ_CONTROL with one main sequence module and one fatsat sequence module

    \code{.c}

    @ipgexport
    KS_SEQ_CONTROL mymainseqctrl;
    KS_SEQ_CONTROL fatsatseqctrl;



    @host

    cveval() {

      setup_sequenceobjects(); // see below
      setup_fatsatsequenceobjects(); // details not shown in this example

      // call each *seqmodule*_pg() function here and make sure each seqctrl.duration field > 0 for those sequence modules that should be used in the current setting.
      mypsd_pg(); // also updates mymainseqctrl.gradrf, mymainseqctrl.min_duration = mymainseqctrl.duration > 0
      myfatsat_pg(); // some fatsat sequence module that also updates fatsatseqctrl.gradrf, fatsatseqctrl.min_duration = fatsatseqctrl.duration > 0

      // TR timing & SAR calcs here (for details, see the KS_SEQ_COLLECTION documentation)

      pitscan = scanloop(); // Value of scan clock by dry-running the scan on HOST

    }

    void setup_sequenceobjects() {

      ks_eval_selrf(&myselrf, "myexc"); // selective RF excitation
      ks_eval_phaser(&myphaser, "myphaseenc"); // phase encoding
      ks_eval_trap(&mydephaser, "readdephaser"); // read dephaser
      ks_eval_readtrap(&myreadout, "myreadout"); // readout with trapezoid

      // Init seqctrl
      ks_init_seqcontrol(&mymainseqctrl); // Reset contents of KS_SEQ_CONTROL to KS_INIT_SEQ_CONTROL
      strcpy(mymainseqctrl.description, "mymainseq"); // add description to it
      mymainseqctrl.ssi_time = 1ms; // Optional: Set SSI time (default: 1 ms)

    }



    @pg

    void mypsd_pg() {
      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 1ms;
      ks_pg_selrf(&myselrf, tmploc, &mymainseqctrl); // play the RF pulse, beginning at 1ms into the sequence

      tmploc.pos += myselrf.grad.duration + myselrf.postgrad.duration;
      ks_pg_phaser(&myphaser, tmploc, &mymainseqctrl);

      tmploc.pos += myphaser.grad.duration;
      ks_pg_readtrap(&myreadout, tmploc, &mymainseqctrl);

      tmploc.pos += myreadout.grad.duration; // time for the end of last sequence entry

    #ifndef IPG // On HOST only (i.e. not IPG/TGT)
      ks_eval_seqctrl_setminduration(&mymainseqctrl, tmploc.pos); // sets mymainseqctrl.duration = mymainseqctrl.min_duration = tmploc.pos + mymainseqctrl.ssi_time
    #endif

    }

    pulsegen() {

       mypsd_pg();
       KS_SEQLENGTH(seqcore, mymainseqctrl);

       myfatsat_pg();
       KS_SEQLENGTH(seqfat, fatsatseqctrl);

    }



    // declare scanloop in @pg section instead of @rsp to allow it to be called on HOST too. This, to figure out how long one TR is.
    float scanloop() {
      float time = 0.0;

      for (ky = 0; ky < opyres; ky++) {
        for (i = 0; i < opslquant; i++) {
          // ... do some phase encoding etc (not shown)...
          time += ks_scan_playsequence(&fatsatseqctrl); // if fatsatseqctrl.duration > 0, it plays sequence in real time (on TGT) and returns the time in [us] equal to value of fatsatseqctrl.duration
          time += ks_scan_playsequence(&mymainseqctrl); // if mymainseqctrl.duration > 0, it plays sequence in real time (on TGT) and returns the time in [us] equal to value of mymainseqctrl.duration
        }
      }

      return time; // return the time in [us] for opslquant number of slices
    }



    @rsp

    scan() {

      scanloop();

    }

    \endcode
*/
typedef struct _seq_control_s {
  int min_duration; /**< In [us]. The minimum possible sequence duration based on the end of the last gradient/RF waveform. Lower limit of the .duration field that must be manually set */
  int nseqinstances; /**< Number of playouts in scan loop. ks_scan_playsequence() increments this on HOST for each call. Value is set to zero by ks_eval_seqcollection_resetninst() */
  int ssi_time; /**< In [us]. The SSI time (hardware update time) for the sequence module. Default is 1000 us */
  int duration; /**< In [us]. The actual duration of the sequence module. Must be >= .min_duration, and is used in KS_SEQLENGTH() and for SAR check and TR validation (GEReq_eval_checkTR_SAR()) */
  int momentstart; /**< In [us]. Magnetic reference point for the excitation pulse (TE = 0) relative to the start of the sequence module. This field is set automatically by ks_pg_rf() if `rf.role = KS_RF_ROLE_EXC`,
                        under the assumption that there is only one excitation RF pulse in each sequence module. If not, `.momentstart` should be set manually. Besides TE calculations in the
                        sequence module's pg function itself, `.momentstart` for a main sequence is also used in KSInversion.e for TI timing. */
  int rfscalingdone; /**< Default FALSE (until GEReq_eval_rfscaling() sets it to TRUE). For safety reasons (and to make sure correct FA is set), ks_pg_rf() (and hence ks_pg_selrf())
                          refuses to place the RF pulse belonging to this sequence module if `.rfscalingdone` = FALSE. */
  KS_DESCRIPTION description; /**< Description of the sequence module */
  KS_SEQ_HANDLE handle; /**< *Internal use*. Used to keep track of the global sequence index */
  KS_GRADRFCTRL gradrf; /**< *Internal use*. Used to gather pointers to RF and gradient objects in the sequence module */
} KS_SEQ_CONTROL;



/** @brief #### Collection handle of all sequence modules involved in the pulse sequence, used for RF scaling, TR timing and SAR calculations

    A pulse sequence consists of one or more sequence modules - one of them being the main pulse sequence, while the other ones may be add-on features like e.g. FatSat, Inversion etc.
    These sequence modules, each having its own KS_SEQ_CONTROL struct, are played in `scan()` according to some pattern. As a collection they produce some:
    - total duration for the given number of slices
    - SAR given the various RF pulses involved in the sequence modules

    To perform an overarching RF scaling (accounting also for the prescan RF pulses), TR timing and SAR calculation, the collection of sequence modules (KS_SEQ_COLLECTION) involved is used.

    While the KS_SEQ_CONTROL struct could be viewed as the administrator for *each* sequence module, there is a single KS_SEQ_COLLECTION struct administrating the *entire* pulse sequence. This KS_SEQ_COLLECTION handle
    is only needed in `cveval()` and is passed to GEReq_eval_rfscaling(), GEReq_eval_TR(), and GEReq_eval_checkTR_SAR(), which should all be called in `cveval()`.

    A sequence module (KS_SEQ_CONTROL) is added to the sequence collection (KS_SEQ_COLLECTION) by calling ks_eval_addtoseqcollection(), but it will be added only if `seqctrl.duration > 0` . Setting *mypluginmodule*`.duration = 0`
    indicates *don't use*, and hence it will neither be a part of RF scaling or SAR calculations. Moreover, since ks_scan_playsequence() in `scan()` checks if `seqctrl.duration = 0`
    (returns 0 duration and skips playing the module in `scan()`), the TR timing follows automatically.

    This is also analogous to how KS_TRAP, KS_RF and other sequence objects, on a smaller scale, are ignored by the `ks_pg_***()` functions if the `.duration` field is set to 0.


    ### Example use of KS_SEQ_COLLECTION with one main sequence module and one fatsat sequence module

    \code{.c}

    @ipgexport

    KS_SEQ_CONTROL mymainseqctrl;
    KS_SEQ_CONTROL fatsatseqctrl;


    @host

    cveval() {

      // Collection (handle) of all sequence modules
      KS_SEQ_COLLECTION seqcollection;
      ks_init_seqcollection(&seqcollection); // Important: Reset the collection every time


      // ... set up the sequence objects in each sequence module here using ks_eval_***() functions etc. (not shown in this example) ...


      // call each <seqmodule>_pg() function here and make sure each seqctrl.duration field > 0 for those sequence modules that should be used
      mypsd_pg(); // also updates mymainseqctrl.gradrf, mymainseqctrl.min_duration = mymainseqctrl.duration > 0
      myfatsat_pg(); // some fatsat sequence module that also updates fatsatseqctrl.gradrf, fatsatseqctrl.min_duration = fatsatseqctrl.duration > 0

      // Add the KS_SEQ_CONTROLs to be used to the KS_SEQ_COLLECTION
      ks_eval_addtoseqcollection(&seqcollection, &mymainseqctrl); // add the main sequence to the collection (ignored if mymainseqctrl.duration = 0)
      ks_eval_addtoseqcollection(&seqcollection, &fatsatseqctrl); // add the fatsat sequence module to the collection (ignored if fatsatseqctrl.duration = 0)

      // Perform the RF scaling (across all sequence modules as well as the prescan RF pulses) to get the correct actual FA
      GEReq_eval_rfscaling(&seqcollection);

      // [2D multi-slice specific] Get the number of slices per TR (slperpass) and the necessary padding time to reach the desired TR (timetoadd_perTR)
      // mysliceloop_nargs() is a slice loop wrapper function with standardized input args, passed as a function pointer to GEReq_eval_TR()
      // For more details on this function pointer, see documentation for GEReq_eval_TR() and GEReq_eval_checkTR_SAR()
      GEReq_eval_TR(&slperpass, &timetoadd_perTR, 0, seqcollection, mysliceloop_nargs, 0, NULL);

      // Calculate the slice plan (slice ordering and number of passes (acqs))
      // ks_slice_plan (declared in GERequired.e) is passed to GEReq_predownload_store_sliceplan() in predownload()
      ks_calc_sliceplan(&ks_slice_plan, exist(opslquant), slperpass);

      // Spread the available timetoadd_perTR evenly, by increasing the .duration field for the main sequence by timetoadd_perTR/ks_slice_plan.nslices_per_pass
      mymainseqctrl.duration = RUP_GRD(mymainseqctrl.duration + CEIL_DIV(timetoadd_perTR, ks_slice_plan.nslices_per_pass));

      // Check the actual TR and update SAR values in the UI (error will occur if the sum of sequence durations differs from optr)
      GEReq_eval_checkTR_SAR(seqcollection, ks_slice_plan.nslices_per_pass, mysliceloop_nargs, 0, NULL);

      // Scan clock
      pitscan = scanloop();

    }




    @pg

    void mypsd_pg() {

      // ... calls to various ks_pg_***() functions here

      tmploc.pos += myreadout.grad.duration; // time for the end of last sequence entry (in this case the end of the readout gradient)

    #ifndef IPG // On HOST only (i.e. not IPG/TGT)
      ks_eval_seqctrl_setminduration(&mymainseqctrl, tmploc.pos); // sets mymainseqctrl.duration = mymainseqctrl.min_duration = tmploc.pos + mymainseqctrl.ssi_time
    #endif

    }


    pulsegen() {

       mypsd_pg();
       KS_SEQLENGTH(seqcore, mymainseqctrl);

       myfatsat_pg();
       KS_SEQLENGTH(seqfat, fatsatseqctrl);

    }



    // play one slice loop, i.e. one TR
    int mysliceloop(int slperpass, int ky) {

       for (i = 0; i < slperpass; i++) {

          // ... do some phase encoding etc based on value of 'ky' (not shown)...

          time += ks_scan_playsequence(&fatsatseqctrl); // if fatsatseqctrl.duration > 0, it plays sequence in real time (on TGT) and returns the time in [us] equal to value of fatsatseqctrl.duration

          time += ks_scan_playsequence(&mymainseqctrl); // if mymainseqctrl.duration > 0, it plays sequence in real time (on TGT) and returns the time in [us] equal to value of mymainseqctrl.duration

        }
    }


    // wrapper function to sliceloop with standardized input args to be used as function pointer to GEReq_eval_TR() and GEReq_eval_checkTR_SAR()
    // nargs and args aren't used in this case
    int mysliceloop_nargs(int slperpass, int nargs, void **args) {

       mysliceloop(slperpass, 0);

    }


    // declare scanloop in @pg section instead of @rsp to allow it to be called on HOST too. This, to figure out how long one TR is.
    float scanloop() {
      float time = 0.0;

      for (ky = 0; ky < opyres; ky++) {

        time += mysliceloop();

      }

      return time; // return the time in [us] for the scan
    }



    @rsp

    scan() {

      scanloop();

    }

    \endcode
 */
typedef struct _seq_collection_s {
  int numseq; /**< Number of sequence modules */
  int mode; /**< Flag to determine if new sequence modules may be added. Initialized to KS_SEQ_COLLECTION_ALLOWNEW,
                 and set to KS_SEQ_COLLECTION_LOCKED by GEReq_eval_TR() and GEReq_eval_rfscaling() to prevent accidental adding of modules too late */
  int evaltrdone; /**< Flag to determine if TR timing has been done. The sequence may have more than one function that could be responsible for the TR timing,
                       but only one should be called for any given configuration. As an example is the inversion module (KSInversion.e), which takes over the TR
                       timing if the inversion flag is set */
  KS_SEQ_CONTROL *seqctrlptr[KS_MAXUNIQUE_SEQUENCES]; /* Max KS_MAXUNIQUE_SEQUENCES (= 200) sequence modules may be added */
} KS_SEQ_COLLECTION;



/**
 * @brief #### Struct to keep SAR parameters together. Used in ks_eval_gradrflimits() and GEReq_eval_checkTR_SAR_calcs()
 *
 */
typedef struct _sar_s {
  double average; /**< Average SAR */
  double coil; /**< Coil SAR */
  double peak; /**< Peak SAR */
  double b1rms; /**< Root-mean-square B1 */
} KS_SAR;



/**
 * @brief #### Struct holding all information about slice locations and aquisition order
 *
 * #### Background
 * For 2D imaging one can fit a certain number of slices within each TR, and one may often need multiple TRs (or passes) to play out
 * all slices. GE's product sequences uses the following CVs:
 * - `opslquant` (number of slices in total, taken from the prescribed slices in the UI)
 * - `slquant1` (number of slices that can fit within one TR)
 * - `acqs` (number of passes, acquisitions, or TRs necessary to acquire all slices)

 * Then typically `orderslice()` is called to set up the global `data_acq_order` array, which is used in the reconstruction
 *
 * #### ks_slice_plan
 * This is replaced with one `ks_slice_plan`, effectively making `acqs` and `slquant1` obsolete, and making `scan()` only dependent on one KS_SLICE_PLAN.
 * This is e.g. beneficial for multiband (SMS) imaging, where there is one slice plan for the calibration step and another slice plan for the
 * slice-accelerated scan.
 *
 * Multiple functions can exist to create different KS_SLICE_PLANs (instead of using `orderslice()`), and for standard interleaved 2D imaging (odd slices followed by
 * even slices), there is aleady a ks_calc_sliceplan() function, which in turn calls ks_calc_sliceplan_interleaved(), where the level of slice interleaving can be set.
 *
 * As GE's `data_acq_order()` is critical for the image reconstruction, this has to be filled in correctly before scanning, and this is done
 * by store the `ks_slice_plan` information by calling GEReq_predownload_store_sliceplan() in predownload().
 *
 * `ks_slice_plan` is declared as KS_SLICE_PLAN in GERequired.e, hence there is no need to declare it for each pulse sequence.
 *
 */
typedef struct _KS_SLICE_PLAN {
  int nslices; /**< Number of slices in total (opslquant) */
  int npasses; /**< Number of TRs or passes (i.e. acquisitions) necessary to acquire all slices */
  int nslices_per_pass; /**< Number of slices that can fit each TR (pass) */
  DATA_ACQ_ORDER acq_order[SLICE_FACTOR * DATA_ACQ_MAX]; /**< Table of slice locations, slice order, and pass index for the scan */
} KS_SLICE_PLAN;



/**
 * @brief #### Internal `typedef struct` that is a part of the KS_SELRF `typedef struct`, used to store information about the pulses SMS properties.
 *
 * - `mb_factor` (number of slices simultaneously excited)
 * - `slice_gap` (distance between two simultaneously excited slices)
 * - `pulse_type` (ks_enum_smstype: what kind of pulse it is. PINS, PINS-DANTE or regular multiplexed pulse)
 *
 */
typedef struct _sms_info_s {
  int mb_factor;
  float slice_gap;
  int pulse_type;
} KS_SMS_INFO;



/*******************************************************************************************************
 *  Composite Sequence objects
 *******************************************************************************************************/

/** @brief #### Composite sequence object for slice-selective RF
    @image html KS_SELRF.png KS_SELRF
    <br>

    The KS_SELRF composite sequence object contains a KS_RF object and three KS_TRAP objects and an optional KS_WAVE object. The purpose of the KS_SELRF
    object is to provide a complete functionality for slice selection. Depending on the declared *role* (`.rf.role`), and the fields like
    `.slthick`, the KS_TRAP objects will be set up differently in ks_eval_selrf(). The KS_TRAP fields in KS_SELRF are:
    - `.pregrad`: A gradient that *may* be present *before* the RF slice selection
    - `.grad`: The slice selection gradient that is applied at the same time as the KS_RF RF pulse
    - `.postgrad`: A gradient that *may* be present *after* the RF slice selection

    The following values of `.rf.role` are allowed:
    - `KS_RF_ROLE_EXC`, indicating an RF *excitation* role. ks_eval_selrf() will in this case:
      - disable `.pregrad`
      - make `.grad` to have a plateautime equal to the RF duration (`.rf.rfwave.duration`) and the gradient amplitude (`.grad.amp` [G/cm])
        will be set to the proper value, depending on the BW (`.rf.bw`) and slice thickness (`.slthick`). Note that the slice thickness often needs to be made
        larger to compensate from slice narrowing due to multiple RF pulses. GE uses `gscale_rfX` CVs with values often between 0.8-0.9. Dividing with this number
        gives a thicker slice in the calculations. The field `.grad.description` will have a ".trap" suffix added to it
      - make `.postgrad` to have a gradient area that rephases the slice. This is dependent on the isodelay of the RF pulse (`.rf.iso2end`) and the slice select
        gradient amplitude (`.grad.amp`). The field `.postgrad.description` will have a ".reph" suffix added to it
    - `KS_RF_ROLE_REF`, indicating an RF *refocusing* role. ks_eval_selrf() will in this case:
      - use `.pregrad` to make the left crusher (never *bridged* with slice selection). The size of the crusher can be controlled by `.crusherscale`.
        The field `.pregrad.description` will have a ".LC" suffix added to it
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - use `.postgrad` to make the right crusher (never *bridged* with slice selection). The size of the crusher can be controlled by `.crusherscale`.
        The field `.postgrad.description` will have a ".RC" suffix added to it
    - `KS_RF_ROLE_INV`, indicating an RF *inversion* role. ks_eval_selrf() will in this case:
      - disable `.pregrad`
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - disable `.postgrad`
    - `KS_RF_ROLE_SPSAT`, indicating a *spatial RF saturation*. ks_eval_selrf() will in this case:
      - disable `.pregrad`
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - use `.postgrad` to make a gradient spoiler (never *bridged* with slice selection). The size of the spoiler can be controlled by `.crusherscale`.
        The field `.postgrad.description` will have a ".spoiler" suffix added to it

    The role `KS_RF_ROLE_CHEMSAT`, indicates a non-slice selective, chemically selective, RF (usually *fat-sat*). ks_eval_selrf() will in this case throw an error since
    no gradients should be used

    With ks_eval_selrf(), the default slewrate and maximum gradient amplitude are used for the KS_TRAP objects, and it is possible (with few applications) to play out
    three simultaneous gradients during slice selection. For oblique slices, the maximum gradient strength will however be reduced.
    For high-bandwidth RF pulses and thin slices, it may be beneficial to allow for a larger maximum gradient strength for oblique slice planes. This can be done by instead
    calling:
    - ks_eval_selrf1(): where one *promises* that only one (1) gradient (trapezoid) will be played out at a time during slice selection (i.e. no other gradients
      are active on other boards during this time). This is usually the case anyway for slice selection, hence the ks_eval_selrf1() function could be used as standard
    - ks_eval_selrf2(): where one *promises* that maximum two (2) gradients will be played out at a time during slice selection. This gives a maxiumum gradient amplitude
      that lies in between that of ks_eval_selrf() and ks_eval_selrf1()
    - ks_eval_selrf_constrained(): where full control is given to the *slewrate* and the *maximum gradient strength*

    #### Using a custom gradient wave for slice selection
    To support e.g. VERSEd RF excitations, a custom gradient wave can be used.

    If `.gradwave.res > 0`, ks_eval_selrf() will disable `.grad` and use `.gradwave` instead.
    When `.rf.role = KS_RF_ROLE_EXC`, the rephasing gradient area (in `.postgrad`) will also be calculated by integrating the gradient waveform
    from the RF isocenter to the end. `.gradwave` must be created *before* calling ks_eval_selrf() using either ks_eval_wave() or ks_eval_wave_file(), and the units must
    be in [G/cm]. To further scale the amplitude of `.gradwave` before calling ks_pg_selrf(), consider e.g. ks_wave_multiplyval(), ks_wave_absmax(), and possibly
    ks_wave_addval().

    In the `@pg` section,  if `.gradwave.res > 0`, ks_pg_selrf() will place out the `.gradwave` instead of `.grad`. As all KS_WAVE objects are double buffered,
    it is possible to swap out the gradient waveform in `scan() if necessary.

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_selrf() call(s)) that can be run on both HOST and TGT. This
    function should be called once in `cveval()` (after ks_eval_selrf() and other `ks_eval_***()` functions). ks_pg_selrf() will throw an error on TGT if this has not been done.
    An error will also occur on TGT if the RF pulse and the associated KS_SEQ_CONTROL struct governing the sequence (module) has not undergone RF scaling using GEReq_eval_rfscaling().

    ### Example

    \code{.c}
    @ipgexport (HOST)

    KS_SEQ_CONTROL seqctrl;
    KS_SELRF myselexc = KS_INIT_SELRF;

    @host

    cveval() {

      myselexc.rf = exc_3dfgre; // const KS_RF in KSFoundation_GERF.h. .role already set to KS_RF_ROLE_EXC in exc_3dfgre

      myselexc.rf.flip = opflip; // FA value from UI
      myselexc.slthick = opslquant; // Slice thickness value from UI

      ks_eval_selrf(&myselexc, "myselexc"); // selective RF excitation, including the slice rephaser

      // ... see KS_SEQ_CONTROL and KS_SEQ_COLLECTION for details on RF scaling and SAR ...

    }

    @pg

      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 1ms; // Place the beginning of the first gradient belonging to the KS_SELRF object here
      tmploc.board = ZGRAD; // Place the gradients on ZGRAD
      ks_pg_selrf(&myselexc, tmploc, &seqctrl); // instance #0 of the RF pulse, beginning at 1ms into the sequence


    @rsp (TGT)

      // Change frequency of the RF pulse to excite the correct slice location (scan_info[].tloc contains the mm offset from isocenter)
      ks_scan_selrf_setfreqphase(&myselexc, 0, scan_info[slice], myrfphase);

    \endcode

*/
typedef struct _selrf_s {
  KS_RF rf;  /**< See KS_RF */
  /* input design: */
  float slthick;  /**< Slice thickness in [mm] (often needs to be scaled up 10-15% to really achieve the expected thickness, depending on number of RF pulses) */
  float crusherscale; /**< Relative area of the refocusing crusher gradients. Only used when `.rf.role = KS_RF_ROLE_REF`. Default: 1.0  */
  /* output: */
  KS_TRAP pregrad; /**< Pre Slice Select gradient. `KS_RF_ROLE_REF`: Left Crusher. `KS_RF_ROLE_EXC/KS_RF_ROLE_INV`: *Off* (*Off* state given by `pregrad.duration = 0`) */
  KS_TRAP grad; /**< Slice Select gradient */
  KS_TRAP postgrad; /**< Post Slice Select gradient. `KS_RF_ROLE_REF`: Right Crusher. `KS_RF_ROLE_EXC`: Slice rephaser. `KS_RF_ROLE_SPSAT`: Spoiler. `KS_RF_ROLE_INV`: *Off*. (*Off* state given by `postgrad.duration = 0`) */
  KS_WAVE gradwave;  /**< Optional external gradient instead of using `.grad`. Default: *Off* (*Off* state given by `gradwave.res = 0`) */
  KS_SMS_INFO sms_info; /**< Information about the pulses SMS properties */
} KS_SELRF;



/** @brief #### Composite sequence object for data readout using a trapezoid gradient
    @image html KS_READTRAP.png KS_READTRAP
    <br>

    KS_READTRAP is a composite sequence object used to read out data while a trapezoid is played out, which is applicable to Cartesian, propeller and radial pulse sequences. The KS_READTRAP object
    is set up by calling ks_eval_readtrap(), but before calling this function, the following fields in KS_READTRAP must be set up:
    1. `.fov`: Desired image Field-of-View (FOV) in [mm] along the sequence board one intends to place the KS_READTRAP on (typically XGRAD)
    2. `.res`: Number of pixels within the FOV
    3. `.acq.rbw`: Receiver bandwidth (rBW) in [kHz/FOV]. Maximum is 250
    4. `.rampsampling`: If non-zero, data acquisition will be performed on the ramps of the trapezoid as well. This reduces the readout time, especially for high rBWs.
    5. `.acqdelay`: Needs to be set only if `.rampsampling = 1`. The `.acqdelay` (in [us]) will dictate the time from the start of the ramp-up until
       data acquisition will begin
    6. `.nover`: Number of *overscans*. If 0, a full echo will be generated (filling k-space). If > 0, fractional echo (i.e. shorter TE) will be set up with
       `.nover` number of extra sample points beyond `.res/2`.
       The total number of samples will be `.res/2 + .nover`. Values of `.nover` between 1 and about 16 should be avoided since half Fourier reconstruction
       methods will likely have difficulties
    7. `.freqoffHz`: Static offset frequency in Hz. Can be used to e.g. center fat instead of water

    If the KS_READTRAP object is initialized with KS_INIT_READTRAP, the fields `.nover`, `.rampsampling`, `.acqdelay` and `.freqoffHz` will all be zero (steps 4-7 can be skipped)

    Based on the information in the KS_READTRAP object, ks_eval_readtrap() will set up its `.grad` trapezoid (KS_TRAP) and its acquisition window `.acq` (KS_READ).

    If `.rampsampling = 1`, ks_eval_readtrap() will also copy the shape of `.grad` into `.omega` (also KS_TRAP).
    This is needed for FOV-offsets in the readout direction when data acquisition is done on both the ramps and on the plateau,
    and ks_pg_readtrap() and ks_scan_offsetfov() will handle the `.omega` KS_TRAP so that the intended FOV shift in [mm] will be performed.

    ks_eval_readtrap() will also fill in the convenience fields `.area2center` and `.time2center` properly. `.area2center` is useful to use as desired input `.area` for a read dephaser,
    and `.time2center` makes sequence timing calculations easier. Both fields take partial/full Fourier (`.nover`) into account.

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_readtrap() call(s)) that can be run on both HOST and TGT. This
    function should be called once in `cveval()` (after ks_eval_readtrap() and other `ks_eval_***()` functions). ks_pg_readtrap() will throw an error on TGT if this has not been done.

    ### Multi-echo example (also showing a read dephaser)

    \code{.c}
    @ipgexport (HOST)

    KS_SEQ_CONTROL seqctrl;
    KS_READTRAP myreadout = KS_INIT_READTRAP; // readout trapezoid including data acquisition window
    KS_TRAP myreaddephaser = KS_INIT_TRAP; // dephaser gradient for the readout


    cveval() {

      myreadout.fov = opfov; // FOV menu in UI
      myreadout.res = opxres; // Freq res. menu in UI
      myreadout.acq.rbw = oprbw; // Receiver bandwidth menu in UI
      ks_eval_readtrap(&myreadout, "myreadout"); // setup the readout with trapezoid

      myreaddephaser.area = -myreadout.area2center; // works for both partial (.nover > 0) and full Fourier (.nover = 0)
      ks_eval_trap(&myreaddephaser, "myreaddephaser"); // setup the dephaser gradient

    }

    @pg

      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 15ms; // start reading out after 15ms
      tmploc.board = XGRAD; // place the readout on XGRAD

      for (i = 0; i < opnecho; i++) { // opnecho is "number of echoes" menu in the UI
        ks_pg_readtrap(&myreadout, tmploc, &seqctrl);
        tmploc.pos += myreadout.grad.duration; // forward the position to the next readout
        tmploc.ampscale *= -1.0; // negate the readout amplitude for even echoes
      }

    @rsp (TGT)

      ks_scan_offsetfov(&myreadout, INSTRALL, scan_info[slice], kyview, opphasefov, 0); // FOV-shift all readouts according to scan_info[]

    \endcode

*/
typedef struct _readtrap_s {
  KS_READ acq; /**< Data acq window (incl. filter info) (set by ks_eval_readtrap()) */
  /* input design: */
  float fov;  /**< FOV in the frequency encoding direction [mm] (must be set before calling ks_eval_readtrap()) */
  int res;  /**< Number of pixels in the frequency encoding direction  (must be set before calling ks_eval_readtrap()) */
  int rampsampling; /**< 0 [default]: data acquisition on the plateau of the trapezoid, 1: data acquisition also on the ramps (optionally set before ks_eval_readtrap()) */
  int nover;  /**< 0 [default]: Full Fourier imaging (full k-space), >0: Partial Fourier (in freq.dir.). Actual value sets the number of partial Fourier overscans.  (optionally set before ks_eval_readtrap()) */
  int acqdelay; /**< Time [us] until data sampling should start relative to the attack ramp start. Must be set manually when `.rampsampling` = 1. Without rampsampling, `.acqdelay` is set to `.ramptime` (if paddingarea = 0)  */
  float paddingarea; /**< 0 [default]: Minimum gradient area [(G/cm)*us] before or after the start of the sampling window on the plateau part (applies only when `.rampsampling` = 0) */
  float freqoffHz; /**< 0 [default]: Static frequency offset in [Hz] that is to be added to the FOV dependent frequency offset (c.f. ks_scan_offsetfov()) */
  /* output: */
  float area2center; /**< Gradient area until center of k-space (convenient information set by ks_eval_readtrap()) */
  int time2center; /**< Time [us] until center of k-space (convenient information set by ks_eval_readtrap()) */
  KS_TRAP grad; /**< Gradient during data acq  (set by ks_eval_readtrap()) */
  KS_TRAP omega; /**< OMEGA trapezoid for frequency modulation during data acquisition when .rampsampling = 1, otherwise not used. (set by ks_eval_readtrap()) */
} KS_READTRAP;


typedef struct _readwave_s {
  KS_WAVE grads[3];
  KS_WAVE omega;
  KS_WAVE theta;
  KS_READ acq;
  int delay[3]; /* Relative delay of the grads [us], applied in ks_pg_readwave() */
  float amp[3]; /* Gradient amplitudes */
  float freqoffHz; /**< 0 [default]: Static frequency offset in [Hz] that is to be added to the FOV dependent frequency offset (c.f. ks_scan_offsetfov_readwave()) */
  float fov;
  int res;
  int rampsampling;
  int nover; /**< 0 [default]: Full Fourier imaging (full k-space), >0: Partial Fourier (in freq.dir.). */
} KS_READWAVE;



/** @brief #### Composite sequence object for phase encoding using a trapezoid gradient
    @image html KS_PHASER.png KS_PHASER
    <br>

    KS_PHASER is a composite sequence object that is used for phase encoding. 2D Cartesian imaging requires one KS_PHASER, while 3D Cartesian imaging requires two different
    KS_PHASER objects, each with its own FOV, resolution and acceleration. The KS_PHASER object is set up by calling ks_eval_phaser(), but before calling this function,
    the following fields in KS_PHASER must be set up:
    1. `.fov`: The desired image Field-of-View (FOV) in [mm] along the sequence board one intends to place the KS_PHASER on (typically YGRAD, for 3D also ZGRAD)
    2. `.res`: The number of pixels within the FOV
    3. `.nover`: Number of *overscans*. If 0, a full-Fourier k-space will be set up. If > 0, partial Fourier will be set up (shorter scan time) where
       `.nover` number of extra k-space lines beyond `.res/2`. If < 0, partial Fourier will be set up, but with flipped k-space coverage.
       The total number of samples will be `.res/2 + .nover`. Values of `.nover` between 1 and about 16 should be avoided since half Fourier reconstruction
       methods will likely have difficulties.
    4. `.R`: The parallel imaging acceleration factor
    5. `.nacslines`: If `.R > 1`, `.nacslines` is the number of calibration lines around k-space center for parallel imaging calibration.
    6. `.areaoffset`: It is possible to embed a static gradient area in the phase encoding functionality of KS_PHASER. This is useful for 3D imaging, where
       the area needed for the rephaser of the slice select gradient can be put into `.areaoffset`. This makes the KS_PHASER object to act as both slice rephaser and
       slice phaser encoding gradient, which can shorten TE.

    If the KS_PHASER object is initialized with KS_INIT_PHASER, `.nover`, `.nacslines` and `.areaoffset` will be zero, and `.R` will be 1 (steps 3-6 can be skipped)

    Based on the information in the KS_PHASER object, ks_eval_phaser() will set up the `.grad` trapezoid (KS_TRAP), `.numlinestoacq`, and the array `.linetoacq[]`.
    The field `.numlinestoacq` is an integer corresponding to the actual number of lines to acquire, which is also the number of relevant elements in `.linetoacq[]`, containing the complete list
    of phase encoding lines to acquire (honoring partial Fourier, parallel imaging acceleration and ACS lines).

    In the `@pg` section, the ks_pg_phaser() function is used to place the KS_PHASER object on a certain board at some position in time (`.ampscale` must be 1.0 for ks_pg_phaser()).

    To acquire a given phase encoding line in `scan()`, ks_scan_phaser_toline() is called. For a rephaser gradient, which should undo the phase encoding gradient
    after the readout, the function ks_scan_phaser_fromline() is used.

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_phaser() call(s)) that can be run on both HOST and TGT. This
    function should be called once in `cveval()` (after ks_eval_phaser() and other `ks_eval_***()` functions). ks_pg_phaser() will throw an error on TGT if this has not been done.

    ### Example

    \code{.c}
    @ipgexport (HOST)

    KS_SEQ_CONTROL seqctrl;
    KS_PHASER myphaseenc = KS_INIT_PHASER;

    cveval() {

      myphaseenc.fov = opfov * opphasefov; // opfov is the FOV menu ([mm]), and opphasefov the phase/freq FOV ratio in the UI
      myphaseenc.res = opyres * opphasefov; // opyres is the Phase resolution menu in the UI (usually defined as resolution for a full FOV)

      ks_eval_phaser(&myphaseenc, "myphaseenc");
    }

    @pg

    KS_SEQLOC tmploc = KS_INIT_SEQLOC;

    tmploc.pos = 3ms; // place the KS_PHASER object at position 3ms
    tmploc.board = YGRAD;
    ks_pg_phaser(&myphaseenc, tmploc, &seqctrl); // instance #0 of this KS_PHASER (used as phase encoding before the readout)

    tmploc.pos = 12ms; // place the KS_PHASER object at position 12ms (after some readout not shown here)
    ks_pg_phaser(&myphaseenc, tmploc, &seqctrl); // instance #1 of this KS_PHASER (used to rewind the phase after the readout)


    @rsp (TGT)
    for (i = 0; i < myphaseenc.numlinestoacq; i++) {
      ks_scan_phaser_toline(  &myphaseenc, 0, myphaseenc.linetoacq[i]); // 0th instance of KS_PHASER (from k-space center TO the desired line)
      ks_scan_phaser_fromline(&myphaseenc, 1, myphaseenc.linetoacq[i]); // 1st instance of KS_PHASER (from the desired line back to k-space center)
    }
    \endcode
*/
typedef struct _phase_s {
  KS_TRAP grad; /**< Trapezoid set up by ks_eval_phaser() */
  float fov;  /**< Field-of-View (FOV) in the phase encoding direction, in [mm]. Must be set before calling ks_eval_phaser() */
  int res; /**< Number of pixels in the FOV. Must be set before calling ks_eval_phaser() */
  int nover; /**< Number of overscan lines without parallel imaging (i.e. # lines beyond half k-space for partial Fourier). (default: 0) */
  int R; /**< 1 [default]: Parallel imaging acceleration factor */
  int nacslines; /**< Number of extra lines around k-space center for calibration, when R > 1 */
  float areaoffset; /**< For embedding e.g. a static slice rephaser in the phase encoding gradient (useful in 3D imaging) */
  int numlinestoacq;  /**< Number of lines to acquire (honoring partial Fourier and parallel imaging acceleration (R >= 1). Number of values in linetoacq[] */
  int linetoacq[KS_MAX_PHASEDYN]; /**< Array holding the phase encoding lines to acquire. 0:first line, (`.res` - 1): last line */
} KS_PHASER;



/**
 * @brief #### Struct holding a 3D k-space phase encoding location (ky,kz)
 *
 * This struct is used in KS_PHASEENCODING_PLAN
 *
 * - `ky` first phase encoding direction (typically played on YGRAD)
 * - `kz` second phase encoding direction (typically played on ZGRAD)
 *
 * Note that `KS_PHASEENCODING_COORD coord = KS_INIT_PHASEENCODING_COORD;` will initialize both coordinates
 * to KS_NOTSET (-1). This *means* "don't use", and effectively in scan, this will set corresponding gradient amplitude
 * to zero, possibly also shutting off acquisition depending on the situation.
 *
 * For 2D scans, `.kz` should remain `KS_NOTSET`
 */
typedef struct _3dphaseencodingplan_coord_s {
  int ky;
  int kz;
} KS_PHASEENCODING_COORD;



/**
 * @brief #### Phase encoding plan for the sequence (2D and 3D)
 *
 * This struct is used in KS_PHASEENCODING_PLAN
 *
 * - `num_shots` Number of times the sequence is played out (shots over ky and kz). Without parallel imaging, this
 *   should typically be Nky x Nkz / etl for 3D and Nky / etl for 2D
 * - `etl` Number of acquisition windows per sequence playout (echo train length)
 * - `entries` Array of `KS_PHASEENCODING_COORD` coordinates with `num_shots` * `etl` entries. See ks_phaseencoding_resize()
 * - `phaser` Pointer to the sequence's KS_PHASER for the first phase encoding direction (YGRAD). This allows gradient amplitude
 *   changes via the `KS_PHASEENCODING_PLAN` alone during scan, as well as aiding in generating interative HTML plotting
 * - `zphaser` Pointer to the sequence's KS_PHASER for the second phase encoding direction (ZGRAD)
 * - `is_cleared_on_tgt` (Internal use) Semafor to incicate that memory pointers needs to be reset on TGT (IPG) for entries, phaser, zphaser
 *
 * Creating a phase encoding plans may be done with ks_phaseencoding_generate_simple(), ks_phaseencoding_generate_simple_ellipse(),
 * ks_phaseencoding_generate_2Dfse(), ks_phaseencoding_generate_epi() or a sequence specific function, depending on the situation.
 *
 * It is critically important that generation of the plan is performed in ks***_pg() (in section \@pg) and called both on HOST and TGT (IPG). For ksfse.e, ksepi.e and
 * ksgre.e, the phase encoding plan is generated in ksfse_pg(), ksepi_pg(), and ksgre_pg() respectively. On HOST ks***_pg() is called in cveval()
 * (or my_cveval()) everytime the UI or a CV is changed, and with a correctly set up KS_PHASEENCODING_PLAN on HOST, the host plotting routines and dry-running
 * of the scan for TR timing and scan clock will be correct. On TGT, the .entries field will be re-populated as ks***_pg() is called again.
 *
 * For pulse sequences with only one echo, or
 * where the same [ky,kz] coordinate is used for all ETL, ks_phaseencoding_generate_simple() and ks_phaseencoding_generate_simple_ellipse() should
 * suffice. For 2D FSE (and trivial 3D FSE), ks_phaseencoding_generate_2Dfse() can be used (such as in ksfse.e). For more advanced trajectories,
 * similar to GE's CUBE sequence or Compressed Sensing, functions generating these plans are currently not ready (Sept 2018).
 */
typedef struct _3dphaseencodingplan_s {
  int num_shots;
  int etl;
  KS_DESCRIPTION description; /**< Descriptive string for the KS_PHASEENCODING_PLAN object with maximum KS_DESCRIPTION_LENGTH characters */
  KS_PHASEENCODING_COORD *entries;
  KS_PHASER *phaser;
  KS_PHASER *zphaser;
  int is_cleared_on_tgt;
} KS_PHASEENCODING_PLAN;



/** @brief #### Composite sequence object for EPI readout
    @image html KS_EPI.png KS_EPI
    <br>

    The KS_EPI composite sequence object controls an entire EPI train (including de/rephasers on freq & phase axes). The KS_EPI object consists of several fields, four of which are other sequence objects:
    - KS_READTRAP `.read`: The EPI readout lobes including data acquisition
    - KS_TRAP `.readphaser`: The dephaser and rephaser gradients before and after the core EPI train, on the same board as `.read`
    - KS_TRAP `.blip`: The blip gradients in the phase encoding direction between the readout lobes
    - KS_PHASER `.blipphaser`: The dephaser & rephaser gradients on the same board as the `.blip` gradients.
      For multi-shot EPI these gradients will change in scan() when calling ks_scan_epi_shotcontrol()

    The KS_EPI object is set up in `cveval()` using ks_eval_epi(), but before calling this function, portions of the `.read` field (KS_READTRAP) and `.blipphaser` field (KS_PHASER) must be set up.
    Here follows a minimal list of fields that must be set:
    1. `.read.fov`: The Field-of-View (FOV) in the frequency encoding (readout) direction
    2. `.read.res`: The number of pixels within the FOV along the frequency encoding direction
    3. `.blipphaser.fov`: The Field-of-View (FOV) in the phase encoding direction
    4. `.blipphaser.res`: The number of pixels within the FOV along the phase encoding direction
    5. `.blipphaser.R`: Either the number of EPI shots or the parallel imaging factor
    6. `.read.rampsampling`: Whether rampsampling should be used (see KS_READTRAP). Value of 1 is recommended for EPI
    7. `.read.acq.rbw`: The receiver bandwidth in [kHz/FOV]. Maximum: 250

    If the KS_EPI object is initialized with KS_INIT_EPI on declaration, `.read.rampsampling` will already be set to 1 and `.read.acq.rbw` will be set to 250.0 (hence steps 6-7 can be skipped).

    Single-shot EPI acquisitions are geometrically distorted to some degree depending on chosen `.read.res` and `.blipphaser.fov`. To reduce the EPI distortions, either multi-shot EPI
    or parallel imaging acceleration can be used. For both alternatives, every Rth phase encoding line is acquired in k-space as the EPI train is played out. *R* corresponds to the number
    of shots (`opnshots` menu in the UI) or the parallel imaging factor. Therefore, e.g. a 4-shot EPI readout is identical to an *R* = 4 accelerated EPI readout
    with the same FOV and resolution, why one same field `.R` may be used to control the EPI train setup, be it multi-shot or parallel imaging acceleration (but not both at the same time).
    What differs between multi-shot and parallel imaging acceleration in the acquisition is only whether the `.blipphaser` should change from TR to TR.
    Hence, to set up a KS_EPI object, use the field `.R` for both multi-shot EPI and parallel imaging scenarios.

    The remaining fields of interest in the KS_EPI sequence objects are:
    - `.etl`: This is the echo-train-length (ETL) of the EPI readout train, set by ks_eval_epi() based on `.blipphaser.res` and `.blipphaser.R`
    - `.read_spacing`: Additional spacing in [us] between readout lobes. Default value is zero, but can be set > 0 if additional gradients is to be inserted between the readout lobes.
      One scenario is adding CAIPIRINHA blips on ZGRAD during the time where the EPI readout is played out in the pulse sequence
    - `.duration`: Convenience information for timing calculations, set by ks_eval_epi(). This is the total time in [us] for the EPI train, including the dephasers and rephasers on the frequency and phase axes.
      Note that there are also `.duration` fields for each of the four `KS_***` sequence objects in KS_EPI, stating the duration of each of these components.
    - `.time2center`: Convenience information for timing calculations, set by ks_eval_epi(). The time in [us] from the start of the first dephaser until the center of k-space is reached.
      This deviates from `.duration/2` for partial Fourier EPI trains where `.blipphaser.nover > 0` (a.k.a. fractional NEX, but typically shown as MiniumTE in the UI for EPI)

    It is a *requirement* that there is a (*sequence generating*) function in the `@pg` section (containing the ks_pg_epi() call(s)) that can be run on both HOST and TGT. This
    function should be called exactly once in `cveval()` (after ks_eval_epi() and other `ks_eval_***()` functions). ks_pg_epi() will throw an error on TGT if this has not been done.


    ### Example

    \code{.c}
    @ipgexport (HOST)

    KS_SEQ_CONTROL seqctrl;
    KS_EPI myepi = KS_INIT_EPI;

    cveval() {

      myepi.read.fov = opfov; // FOV menu in UI
      myepi.read.res = opxres; // Freq res. in UI
      myepi.blipphaser.fov = opfov; // FOV menu in UI (EPI uses typically square FOVs)
      myepi.blipphaser.res = opyres; // Phaser res. in UI
      myepi.blipphaser.R = opnshots; // Number of shots menu in UI

      ks_eval_epi(&myepi, "myepi", &gradrfctrl); // setup the KS_EPI object

    }

    @pg

      KS_SEQLOC tmploc = KS_INIT_SEQLOC;

      tmploc.pos = 25ms; // start the EPI train after 25ms
      tmploc.board = KS_FREQX_PHASEY; // place the EPI train with frequency encoding on XGRAD and phase encoding on YGRAD
      tmploc.ampscale = 1.0; // In ks_pg_epi(), only 1.0 and -1.0 are allowed. This controls the initial readout polarity

      ks_pg_epi(&myepi, tmploc, &seqctrl);


    @rsp (TGT)

    for (i = 0; i < myepi.blipphaser.R; i++) {
      ks_scan_epi_shotcontrol(&myepi,
                            0, // echo #, i.e. number of EPI trains
                            scan_info[slice], // mm info for current slice
                            phaseshot, // shot #. 0->(opnshots-1)
                            KS_EPI_POSBLIPS); // alternatively KS_EPI_NEGBLIPS (to play out negative EPI blips, with `.blipphaser` polarity automatically adjusted
    }

    \endcode
*/
typedef struct _epi_s {
  KS_READTRAP read; /**< EPI readout lobe (etl instances per EPI train) */
  KS_TRAP readphaser; /**< EPI read dephaser (instance #0) and read rephaser (instance #1) */
  KS_TRAP blip; /**< EPI blips (`.etl`-1 instances per EPI train) */
  KS_PHASER blipphaser; /**< EPI blip dephaser (instance #0) and blip rephaser (instance #1) */
  KS_PHASER zphaser;  /**< Second phase encoding (ZGRAD) field, zphaser.res > 1 triggers 3D (ks_eval_epi) */
  int etl; /**< Echo-Train-Length (ETL), set by ks_eval_epi() */
  int read_spacing; /**< 0 [default]: Optional extra spacing between readout lobes [us] */
  int duration; /**< Duration of EPI train, including dephasers and rephasers [us] */
  int time2center; /**< Time from the beginning of first EPI dephaser to the position corresponding to the center of k-space [us] */
  float blipoversize; /**< 1.0 [default]: Blip widening factor to allow for oblique Nyquist ghost correction */
  float minbliparea; /**< (*Internal use*) Minimum blip area until the blip needs to be widened to reduce discretization errors. If `.blip.area < .minbliparea`, `.blipoversize` will be increased above 1.5 */
} KS_EPI;


typedef struct _dixon_dualreadtrap_s {
  KS_READWAVE readwave;
  KS_DESCRIPTION description;
  /* input: */
  int available_acq_time; /**< Time available to acquire data [us]*/
  int spare_time_pre; /**< Time available before start of acquisition for ramping up and padding area */
  int spare_time_post; /**< Time available from end of acquisition for ramping down and padding area */
  int allowed_overflow_post; /**< Allowed overflow duration where no sampling occurs */
  float paddingarea; /**< 0 [default]: Minimum gradient area [(G/cm)*us] before and after the start of the sampling window */
  int min_nover; /**< Minimum number of partial Fourier overscans. */

  /* output: */
  int shifts[2]; /* Dephasing times at k-space center [us] */
  int nover;  /** Partial Fourier (in freq.dir.). The number of partial Fourier overscans, honoring min_nover. (convenient information set by ks_eval_dixon_dualreadtrap() */
  float area2center; /**< Gradient area until center of k-space (convenient information set by ks_eval_dixon_dualreadtrap()) */
  int time2center; /**< Time [us] until center of k-space (convenient information set by ks_eval_dixon_dualreadtrap()) */
  int overflow_post; /**< Necessary overflow duration, always <= allowed_overflow_post [us] */
  int acqdelay; /**<  */
  float nsa; /**<  */
  float efficiency; /**<  */
  int rampsampling[4]; /* Support points for chopping acq and ramp sampling */
} KS_DIXON_DUALREADTRAP;

/*******************************************************************************************************
 *  external variables
 *******************************************************************************************************/

/* Karolinska (GERequired.e) */
extern int ks_rhoboard;

/* GE */
extern LOG_GRAD loggrd;
extern PHYS_GRAD phygrd;




/* gradient related */
enum ks_enum_trapparts {G_ATTACK, G_PLATEAU, G_DECAY};
enum ks_enum_boarddef {KS_X, KS_Y, KS_Z, KS_RHO, KS_RHO2, KS_THETA, KS_OMEGA, KS_SSP, KS_FREQX_PHASEY, KS_FREQY_PHASEX, KS_FREQX_PHASEZ, KS_FREQZ_PHASEX, KS_FREQY_PHASEZ, KS_FREQZ_PHASEY, KS_XYZ, KS_ALL};

/* EPI related */
typedef enum {KS_EPI_POSBLIPS = 1, KS_EPI_NOBLIPS = 0, KS_EPI_NEGBLIPS = -1} ks_enum_epiblipsign; /* positive or negative blips. Don't change the enum values (+1, -1)! */
enum ks_enum_diffusion {KS_EPI_DIFFUSION_OFF, KS_EPI_DIFFUSION_ON, KS_EPI_DIFFUSION_PRETEND_FOR_RECON};

/* reconstruction related */
enum ks_enum_imsize {KS_IMSIZE_NATIVE, KS_IMSIZE_POW2, KS_IMSIZE_MIN256};
enum ks_enum_datadestination {KS_DONT_SEND = -1, KS_SENDTOBAM = 0, KS_SENDTORTP = 1};
enum ks_enum_accelmenu {KS_ACCELMENU_FRACT, KS_ACCELMENU_INT};

/* RF related */
enum ks_enum_rfrole {KS_RF_ROLE_NOTSET, KS_RF_ROLE_EXC, KS_RF_ROLE_REF, KS_RF_ROLE_CHEMSAT, KS_RF_ROLE_SPSAT, KS_RF_ROLE_INV};
enum ks_enum_sincwin {KS_RF_SINCWIN_OFF, KS_RF_SINCWIN_HAMMING, KS_RF_SINCWIN_HANNING, KS_RF_SINCWIN_BLACKMAN, KS_RF_SINCWIN_BARTLETT};

/* wave related */
enum ks_enum_wavebuf {KS_WF_MAIN, KS_WF_BUF1, KS_WF_BUF2, KS_WF_SIZE};

/* SMS related */
enum ks_enum_smstype {
  KS_SELRF_SMS_MB,
  KS_SELRF_SMS_PINS,
  KS_SELRF_SMS_PINS_DANTE,
  KS_SELRF_SMS_MULTI_PINS,
  KS_SELRF_SMSTYPE_SIZE};

enum ks_enum_sms_phase_mod {
  KS_SELRF_SMS_PHAS_MOD_OFF,
  KS_SELRF_SMS_PHAS_MOD_PHAS,
  KS_SELRF_SMS_PHAS_MOD_AMPL,
  KS_SELRF_SMS_PHAS_MOD_QUAD,
  KS_SELRF_SMS_PHAS_MOD_SIZE};

enum {KS_SEQ_COLLECTION_ALLOWNEW, KS_SEQ_COLLECTION_LOCKED};
enum ks_enum_grad_scaling_policy {KS_GRADWAVE_ABSOLUTE, KS_GRADWAVE_RELATIVE};


/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSFoundation.h: Function Prototypes available on HOST (KSFoundation_host.c)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/*******************************************************************************************************
 *  Init
 *******************************************************************************************************/

/** @brief #### Resets a KS_READ sequence object to its default value (KS_INIT_READ)
 *  @param[out] read Pointer to KS_READ
 *  @return void
 */
void ks_init_read(KS_READ *read);

/** @brief #### Resets a KS_TRAP sequence object to its default value (KS_INIT_TRAP)
 *  @param[out] trap Pointer to KS_TRAP
 *  @return void
 */
void ks_init_trap(KS_TRAP *trap);

/** @brief #### Resets a KS_WAIT sequence object to its default value (KS_INIT_WAIT)
 *  @param[out] wait Pointer to KS_WAIT
 *  @return void
 */
void ks_init_wait(KS_WAIT *wait);

/** @brief #### Resets a KS_WAVE sequence object to its default value (KS_INIT_WAVE)
 *  @param[out] wave Pointer to KS_WAVE
 *  @return void
 */
void ks_init_wave(KS_WAVE *wave);

/** @brief #### Resets a KS_RF sequence object to its default value (KS_INIT_RF)
 *  @param[out] rf Pointer to KS_RF
 *  @return void
 */
void ks_init_rf(KS_RF *rf);

/** @brief #### Resets a KS_SMS_INFO sequence object to its default value (KS_INIT_SMS_INFO)
 *  @param[out] sms_info Pointer to KS_SMS_INFO
 *  @return void
 */
void ks_init_sms_info(KS_SMS_INFO *sms_info);

/** @brief #### Resets a KS_SELRF sequence object to its default value (KS_INIT_SELRF)
 *  @param[out] selrf Pointer to KS_SELRF
 *  @return void
 */
void ks_init_selrf(KS_SELRF *selrf);

/** @brief #### Resets a KS_READTRAP sequence object to its default value (KS_INIT_READTRAP)
 *  @param[out] readtrap Pointer to KS_READTRAP
 *  @return void
 */
void ks_init_readtrap(KS_READTRAP *readtrap);

/** @brief #### Resets a KS_PHASER sequence object to its default value (KS_INIT_PHASER)
 *  @param[out] phaser Pointer to KS_PHASER
 *  @return void
 */
void ks_init_phaser(KS_PHASER *phaser);

/** @brief #### Resets a KS_EPI sequence object to its default value (KS_INIT_EPI)
 *  @param[out] epi Pointer to KS_EPI
 *  @return void
 */
void ks_init_epi(KS_EPI *epi);

/** @brief #### Resets a KS_DIXON_DUALREADTRAP sequence object to its default value (KS_INIT_DIXON_DUALREADTRAP)
 *  @param[in,out] dual_readtrap Pointer to KS_DIXON_DUALREADTRAP
 *  @return void
 */
void ks_init_dixon_dualreadtrap(KS_DIXON_DUALREADTRAP* dual_readtrap);

/** @brief #### Resets KS_GRADRFCTRL to its default value (KS_INIT_GRADRFCTRL)
 *  @param[out] gradrfctrl Pointer to KS_GRADRFCTRL
 *  @return void
 */
void ks_init_gradrfctrl(KS_GRADRFCTRL *gradrfctrl);

/** @brief #### Resets KS_SEQ_CONTROL to its default value (KS_INIT_SEQ_CONTROL)
 *  @param[out] seqcontrol Pointer to KS_INIT_SEQ_CONTROL
 *  @return void
 */
void ks_init_seqcontrol(KS_SEQ_CONTROL *seqcontrol);

/** @brief #### Resets KS_SEQ_COLLECTION to its default value (KS_INIT_SEQ_COLLECTION)
 *  @param[out] seqcollection Pointer to KS_INIT_SEQ_COLLECTION
 *  @return void
 */
void ks_init_seqcollection(KS_SEQ_COLLECTION *seqcollection);


/** @brief #### Changes existing (globally used) loggrd and phygrd structs (set up by `inittargets()` in e.g. GEReq_init_gradspecs())

    If `srfact` < 1.0, both `phygrd` and `loggrd` are updated, and the gradients will be switched propotionally slower. This can be used to make the
    acquistion quieter. If `srfact` > 1.0, only `loggrd` will be updated. This could be used as an attempt to switch the gradients faster, but should be
    used with care as the risk for peripheral nerve stimulation (PNS) increases and the gradients may trip.

    @param[in,out] loggrd  Pointer to LOG_GRAD
    @param[in,out] phygrd  Pointer to PHYS_GRAD
    @param[in] srfact Slewrate factor (< 1.0 means less acquistic noise and reduced risk for PNS)
    @return void
*/
STATUS ks_init_slewratecontrol(LOG_GRAD *loggrd, PHYS_GRAD *phygrd, float srfact) WARN_UNUSED_RESULT;









/*******************************************************************************************************
 *  Eval
 *******************************************************************************************************/


/** @brief #### Adds a sequence module (KS_SEQ_CONTROL) to the KS_SEQ_COLLECTION struct for later RF scaling and SAR calculations

    The KS_SEQ_CONTROL object will be ignored if added previously or if its `.duration` field is zero. A zero duration of a KS_SEQ_CONTROL
    indicates that this sequence module should not be used with the current settings

 *  @param[in,out] seqcollection Pointer to the KS_SEQ_COLLECTION for the sequence
 *  @param[in] seqctrl Pointer to KS_SEQ_CONTROL
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_addtoseqcollection(KS_SEQ_COLLECTION *seqcollection, KS_SEQ_CONTROL *seqctrl) WARN_UNUSED_RESULT;


/** @brief #### *Internal use*. Adds a trapezoid (KS_TRAP) to the KS_GRADRFCTRL struct for later gradient heating calculations in ks_eval_gradrflimits()

    The KS_TRAP object will be ignored if added previously

 *  @param[in,out] gradrfctrl Pointer to the KS_GRADRFCTRL for the sequence
 *  @param[in] trap Pointer to KS_TRAP
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_addtraptogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_TRAP *trap) WARN_UNUSED_RESULT;


/** @brief #### *Internal use*. Adds a wave (KS_WAVE) - if it is not a part of a KS_RF object - to the KS_GRADRFCTRL struct for later gradient heating calculations in ks_eval_gradrflimits()

    The KS_WAVE object will be ignored if added previously

 *  @param[in,out] gradrfctrl Pointer to the KS_GRADRFCTRL for the sequence
 *  @param[in] wave Pointer to KS_WAVE
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_addwavetogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_WAVE *wave) WARN_UNUSED_RESULT;


/** @brief #### *Internal use*. Adds an RF pulse to the KS_GRADRFCTRL struct for later SAR & RF power calculations in ks_eval_gradrflimits()

    The RF object will be ignored if added previously

 *  @param[in,out] gradrfctrl Pointer to the KS_GRADRFCTRL for the sequence
 *  @param[in] rf Pointer to KS_RF
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_addrftogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_RF *rf) WARN_UNUSED_RESULT;

/** @brief #### *Internal use*. Adds an acquisition to the KS_GRADRFCTRL struct. Used for plotting
 * @param[in,out] gradrfctrl Pointer to the KS_GRADRFCTRL for the sequence
 * @param[in] read Pointer to acquisition object.
 * @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_addreadtogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_READ *read) WARN_UNUSED_RESULT;

/** @brief #### Sets up a wait pulse using a KS_WAIT sequence object

    This function should be called in `cveval()` and defines a wait pulse whose duration can be changed at scan-time up to `.duration` [us].

    If ks_eval_wait() returns FAILURE, one must also make sure `cveval()` returns FAILURE, otherwise an error message created in ks_eval_wait() will
    not be seen in the UI.

 *  @param[out] wait        Pointer to the KS_WAIT object to be set up
 *  @param[in]  desc        A description (text string) of the KS_WAIT object. This description is used for pulse sequence generation
                            (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in]  maxduration The desired maximum duration in [us] of the KS_WAIT object
 *  @retval     STATUS      `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_wait(KS_WAIT *wait, const char * const desc, int maxduration) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_ISIROT object to be used for real-time coordinate rotations

    See also ks_pg_isirot() and ks_scan_isirotate().

 *  @param[out] isirot      Pointer to the KS_ISIROT object to be set up
 *  @param[in]  desc        A description (text string) of the KS_ISIROT object
 *  @param[in]  isinumber   A free ISI interrupt number in range [4,7]
 *  @retval     STATUS      `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_isirot(KS_ISIROT *isirot, const char * const desc, int isinumber) WARN_UNUSED_RESULT;


/** @brief #### Sets up a data acquisition window using a KS_READ sequence object

    This function should be called in `cveval()` and defines a data acquisition window of a certain duration with some receiver bandwidth.
    Before calling this function, the following fields in the KS_READ object must be set:
    - `.rbw`: The desired receiver bandwidth / FOV in [kHz] (max: 250)
    - `.duration`: The duration in [us]

    ks_eval_read() will validate the desired rBW and round it to the nearest valid value. Also the duration will be rounded up
    to fit a whole number of samples in the acquisition window.

    To use an acquisition window *with* a gradient, see KS_READTRAP and ks_eval_readtrap()

    If ks_eval_read() returns FAILURE, one must also make sure `cveval()` returns FAILURE, otherwise an error message created in ks_eval_read()
    will not be seen in the UI.

 *  @param[in,out] read Pointer to the KS_READ object to be set up
 *  @param[in] desc A description (text string) of the KS_READ object. This description is used for pulse sequence generation
                   (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_read(KS_READ *read, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a trapezoid using a KS_TRAP sequence object with gradient constraints specified as input arguments

    Before calling this function, the following field in the KS_TRAP object must be set:
    - `.area`: Desired gradient area in units of [(G/cm) * us]

    ks_eval_trap_constrained() will make a trapezoid pulse with the desired area, constrained by the specified
    maximum gradient amplitude, slewrate, and minimum plateau time (args 3-5).

    If ks_eval_trap_constrained() returns FAILURE, one must also make sure `cveval()` returns FAILURE, otherwise an error message created in
    ks_eval_trap_constrained() will not be seen in the UI.

    There are three wrapper functions to this function (ks_eval_trap(), ks_eval_trap1(), ks_eval_trap2()) that have reduced number of input arguments,
    and calls ks_eval_trap_constrained() with different preset gradient constraints. ks_eval_trap() makes fewest assumptions, making it the most general choice.

 *  @param[in,out] trap Pointer to the KS_TRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_TRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @param[in] minduration Optional minimum duration ([us]). A zero value is used to disregard this constraint
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_trap_constrained(KS_TRAP *trap, const char * const desc, float ampmax, float slewrate, int minduration) WARN_UNUSED_RESULT;


/** @brief #### Sets up a trapezoid using a KS_TRAP sequence object with preset gradient constraints

    Before calling this function, the following field in the KS_TRAP object must be set:
    - `.area`: Desired gradient area in units of [(G/cm) * us]

    This is a wrapper function to ks_eval_trap_constrained() with gradient constraints set to allow this KS_TRAP to be simultaneously
    played on XGRAD, YGRAD, ZGRAD for any slice angulation.

 *  @param[in,out] trap Pointer to the KS_TRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_TRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_trap( KS_TRAP *trap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a trapezoid using a KS_TRAP sequence object with preset gradient constraints

    Before calling this function, the following field in the KS_TRAP object must be set:
    - `.area`: Desired gradient area in units of [(G/cm) * us]

    This is a wrapper function to ks_eval_trap_constrained() with gradient constraints set to allow this KS_TRAP to be simultaneously
    played on up to two (2) logical gradients for any slice angulation.

 *  @param[in,out] trap Pointer to the KS_TRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_TRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_trap2(KS_TRAP *trap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a trapezoid using a KS_TRAP sequence object with preset gradient constraints

    Before calling this function, the following field in the KS_TRAP object must be set:
    - `.area`: Desired gradient area in units of [(G/cm) * us]

    This is a wrapper function to ks_eval_trap_constrained() with gradient constraints set to allow this KS_TRAP to
    only be played out on one (1) logical gradient at a time. No gradient may be active on another board while this trapezoid is played out.

 *  @param[in,out] trap Pointer to the KS_TRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_TRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_trap1(KS_TRAP *trap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid, subject to gradient constraints specified as input arguments

    Before calling this function, the following fields in the KS_READTRAP object must be set:
    1. `.fov`: Desired image Field-of-View (FOV) in [mm] along the sequence board one intends to place the KS_READTRAP on (typically XGRAD)
    2. `.res`: Number of pixels within the FOV
    3. `.acq.rbw`: Receiver bandwidth (rBW) in [kHz/FOV]. Maximum is 250
    4. `.rampsampling`: If non-zero, data acquisition will be performed on the ramps of the trapezoid as well. This reduces the readout time, especially for high rBWs.
    5. `.acqdelay`: Needs to be set only if `.rampsampling = 1`. The `.acqdelay` (in [us]) will dictate the time from the start of the ramp-up until
       data acquisition will begin
    6. `.nover`: Number of 'overscans'. If 0, a full echo will be generated (filling k-space). If > 0, fractional echo (i.e. shorter TE) will be set up with
       `.nover` number of extra sample points beyond `.res/2`.
       The total number of samples will be `.res/2 + .nover`. Values of `.nover` between 1 and about 16 should be avoided since half Fourier reconstruction
       methods will likely have difficulties.

    If the KS_READTRAP object is initialized with KS_INIT_READTRAP, the fields `.nover`, `.rampsampling` and `.acqdelay` will all be zero (steps 4-6 can be skipped)

    Based on the information in the KS_READTRAP object, ks_eval_readtrap_constrained() will set up its `.grad` trapezoid (KS_TRAP) and its acquisition
    window `.acq` (KS_READ), constrained by the specified maximum gradient amplitude, slewrate, and minimum plateau time (args 3-5).

    If `.rampsampling = 1`, ks_eval_readtrap_constrained() will also copy the shape of `.grad` to `.omega` (also a KS_TRAP).
    This is needed for FOV-offsets in the readout direction when data acquisition is done on both the ramps and on the plateau,
    and ks_pg_readtrap() and ks_scan_offsetfov() will handle the `.omega` KS_TRAP so that the intended FOV shift in [mm] will be performed.

    ks_eval_readtrap_constrained() will also fill in the convenience fields `.area2center` and `.time2center` properly. `.area2center` is useful to use as `.area`
    for a read dephaser, and `.time2center` makes sequence timing calculations easier. Both fields take partial/full Fourier (`.nover`) into account.

    If ks_eval_readtrap_constrained() returns FAILURE, one must also make sure `cveval()` returns FAILURE, otherwise an error message created in
    ks_eval_readtrap_constrained() will not be seen in the UI.

    There are three wrapper functions to this function (ks_eval_readtrap(), ks_eval_readtrap1(), ks_eval_readtrap2()) that have reduced number of input arguments,
    and calls ks_eval_readtrap_constrained() with different preset gradient constraints.
    ks_eval_readtrap() makes fewest assumptions, making it the most general choice.

 *  @param[in,out] readtrap Pointer to the KS_READTRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_READTRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_readtrap_constrained(KS_READTRAP *readtrap, const char * const desc, float ampmax, float slewrate) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_readtrap_constrained() with gradient constraints set to allow this KS_READTRAP to simultaneously be
    played on XGRAD, YGRAD, ZGRAD for any slice angulation. This is the generic and safest configuration, but for readouts with small FOV and high
    rBW, the gradient limits may be reached, especially for double oblique slices.
    See ks_eval_readtrap_constrained() for details on fields that need to be set before calling this function.

 *  @param[in,out] readtrap Pointer to the KS_READTRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_READTRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_readtrap( KS_READTRAP *readtrap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_readtrap_constrained() with gradient constraints set to allow this KS_TRAP to simultaneously be
    played on up to two (2) logical gradients for any slice angulation.
    For double oblique slice angulations, this function will allow for smaller FOVs and higher rBWs than ks_eval_readtrap().

    See ks_eval_readtrap_constrained() for details on fields that need to be set before calling this function.

 *  @param[in,out] readtrap Pointer to the KS_READTRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_READTRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_readtrap2(KS_READTRAP *readtrap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_readtrap_constrained() with gradient constraints set to allow this KS_TRAP to
    only be played out on one (1) logical gradient at a time. No gradient may be active on another board while this trapezoid is played out.
    For double oblique slice angulations, this function will allow for smaller FOVs and higher rBWs than ks_eval_readtrap() and ks_eval_readtrap2().
    See ks_eval_readtrap_constrained() for details on fields that need to be set before calling this function.

 *  @param[in,out] readtrap Pointer to the KS_READTRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_READTRAP object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_readtrap1(KS_READTRAP *readtrap, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up which lines to acquire for a KS_PHASER object

    This function sets the following fields in a KS_PHASER object
    1. `.numlinestoacq`: Number of phase encoding lines to acquire
    2. `.linetoacq[]`: Array, where the first `.numlinestoacq` elements denotes *which* lines to acquire with indices corresponding to a fully sampled k-space.
        The top-most line has index 0 and the bottom-most line has index (`.res`-1).

    These two fields are set based on `.res`, `.nover`, `.nacslines`, and `.R` in the KS_PHASER object. If `.nover` < 0, partial Fourier will be set
    up, but with flipped k-space coverage

 *  @param[in,out] phaser Pointer to the KS_PHASER object to be set up
 *  @return void
 */
void ks_eval_phaseviewtable(KS_PHASER *phaser);



/** @brief #### Adjusts the phase encoding resolution to the nearest valid value

  Phase resolution must be divisible by `.R` and be even, and there are additional requirements
  for partial ky Fourier scans. Moreover, for parallel imaging using ASSET, only the acquired lines
  are stored in the data (compressed BAM), resulting in an R times lower value for rhnframes.

  Here are the rules:

  - Resolution (and overscan) choice must guarantee that (rhhnover + rhnframes) is an even number
  - Full Fourier, ASSET:
    - rhnframes = res / R
    - rhhnover = 0
    - => res / R must be even
  - Partial Fourier:
    - rhnframes = (res / 2) / R
    - rhhnover = overscans/R
    - => res / (2 * R) and (res / (2 * R) + overscans) must be even<br>
      - overscans/R and (res/2)/R must be integers
      - => res must be divisible by (4 * R)
      - => overscans must be divisible by (2 * R)

  @param[in,out] phaser        Pointer to KS_PHASER
  @param[in] desc A description (text string) of the KS_PHASER object, only used for error msg
  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_phaser_adjustres(KS_PHASER *phaser, const char * const desc) WARN_UNUSED_RESULT;



/**
 * [ks_eval_phaser_setaccel description]
 * @param[in,out] phaser        Pointer to KS_PHASER
 * @param[in]     min_acslines  Minimum # of ACS lines
 * @param[in]     R             (floating point) acceleration (taken e.g. from the UI `opaccel_ph_stride`)
 * @retval        STATUS       `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_phaser_setaccel(KS_PHASER *phaser, int min_acslines, float R) WARN_UNUSED_RESULT;



/** @brief #### Sets up a trapezoid for phase encoding, subject to gradient constraints specified as input arguments

    Before calling this function, the following fields in KS_PHASER must be set up:
    1. `.fov`: The desired image Field-of-View (FOV) in [mm] along the sequence board one intends to place the KS_PHASER on (typically YGRAD, for 3D also ZGRAD)
    2. `.res`: The number of pixels within the FOV
    3. `.nover`: Number of 'overscans'. If 0, a full-Fourier k-space will be set up. If > 0, partial Fourier will be set up (shorter scan time) where
       `.nover` number of extra k-space lines beyond `.res/2`. If < 0, partial Fourier will be set up, but with flipped k-space coverage.
       The total number of samples will be `.res/2 + abs(.nover)`. Absolute values of `.nover` between 1 and about 16 should be avoided since
       half Fourier reconstruction methods will likely have difficulties
    4. `.R`: The parallel imaging acceleration factor
    5. `.nacslines`: If `.R > 1`, the value of `.nacslines` is the number of calibration lines around k-space center for parallel imaging calibration
    6. `.areaoffset`: It is possible to embed a static gradient area in the phase encoding functionality of KS_PHASER. This is useful for 3D imaging, where
       the area needed for the rephaser for the slice select gradient can be put into `.areaoffset`. This makes the KS_PHASER to act as both slice rephaser and
       slice phase encoding gradient, which can shorten TE

    If the KS_PHASER object is initialized with KS_INIT_PHASER, `.nover`, `.nacslines` and `.areaoffset` will be zero, and `.R` will be 1 (steps 3-6 can be skipped)

    Based on the information in the KS_PHASER object, ks_eval_phaser_constrained() will set up the `.grad` trapezoid (KS_TRAP). By internally calling
    ks_eval_phaseviewtable(), `.numlinestoacq`, and the array `.linetoacq[]` are also set up.
    The field `.numlinestoacq` is an integer corresponding to the actual number of lines to acquire, and also the number of elements to read in `.linetoacq[]`, containing the complete list
    of phase encoding lines to acquire (honoring partial Fourier, parallel imaging acceleration and ACS lines)

    If ks_eval_phaser_constrained() returns FAILURE, one must also make sure `cveval()` returns FAILURE, otherwise an error message created in
    ks_eval_phaser_constrained() will not be seen in the UI

    There are three wrapper functions to this function (ks_eval_phaser(), ks_eval_phaser1(), ks_eval_phaser2()) that have reduced number of input arguments,
    and calls ks_eval_phaser_constrained() with different preset gradient constraints. ks_eval_phaser() makes fewest assumptions, making it the most general choice

 *  @param[in,out] phaser Pointer to the KS_PHASER object to be set up
 *  @param[in] desc A description (text string) of the KS_PHASER object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @param[in] minplateautime The minimum plateau time of the trapezoid ([us])
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_phaser_constrained(KS_PHASER *phaser, const char * const desc,
                                  float ampmax, float slewrate, int minplateautime) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_phaser_constrained() with gradient constraints set to allow this KS_PHASER to simultaneously be
    played on XGRAD, YGRAD, ZGRAD for any slice angulation. This is the generic and safest configuration, but the duration of the KS_PHASER
    object may increase for double oblique slices

    See ks_eval_phaser_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] phaser Pointer to the KS_PHASER object to be set up
 *  @param[in] desc A description (text string) of the KS_PHASER object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_phaser( KS_PHASER *phaser, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_phaser_constrained() with gradient constraints set to allow this KS_PHASER to simultaneously be
    played on up to two (2) logical gradients for any slice angulation.
    For double oblique slice angulations, this function may allow for shorter duration than ks_eval_phaser()

    See ks_eval_phaser_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] phaser Pointer to the KS_PHASER object to be set up
 *  @param[in] desc A description (text string) of the KS_PHASER object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_phaser2(KS_PHASER *phaser, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an acquisition window with a trapezoid with preset gradient constraints

    This is a wrapper function to ks_eval_phaser_constrained() with gradient constraints set to allow this KS_PHASER to
    only be played out on one (1) logical gradient at a time. No gradient may be active on another board while this trapezoid is played out.
    For double oblique slice angulations, this function may allow for shorter duration than ks_eval_phaser() and ks_eval_phaser2()

    See ks_eval_phaser_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] phaser Pointer to the KS_PHASER object to be set up
 *  @param[in] desc A description (text string) of the KS_PHASER object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_phaser1(KS_PHASER *phaser, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_WAVE object based on a waveform (KS_WAVEFORM) in memory

    ks_eval_wave() copies the content of a KS_WAVEFORM into a KS_WAVE sequence object. KS_WAVEFORM (5th arg) is a `typedef` for a float array with a fixed length of
    KS_MAXWAVELEN elements. Hence, a KS_WAVEFORM, or float array, must first be created and filled with some wave contents before calling this function. *res*
    elements are copied from the input KS_WAVEFORM to the field `.waveform` in the KS_WAVE object (1st arg). *duration* (4th arg) must be
    divisible by *res* (3rd arg) and at least 2x *res*.

    When using (i.e. calling ks_pg_wave()) the waveform for:
    1. RF or OMEGA, nothing needs to be done in terms of amplitude scaling. For RF, amplitude scaling is handled via the KS_RF object, and
    for OMEGA the number of [Hz] are set directly in run-time (scan())
    2. THETA, the waveform needs to be scaled to units of [degrees]
    3. XGRAD, YGRAD, or ZGRAD, the waveform needs to be scaled to units of [G/cm]

 *  @param[out] wave KS_WAVE object to be created
 *  @param[in] desc A description (text string) of the KS_WAVE object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] res Resolution of the waveform, i.e. number of elements from KS_WAVEFORM (5th arg) to read
 *  @param[in] duration Desired duration in [us] of the waveform (must be divisible with *res*)
 *  @param[in] waveform KS_WAVEFORM (float array of max length KS_MAXWAVELEN) with existing waveform content
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_wave(KS_WAVE *wave, const char * const desc, int res, int duration, KS_WAVEFORM waveform) WARN_UNUSED_RESULT;


/** @brief #### Flips the contents of the KS_WAVEFORM in a KS_WAVE object

    ks_eval_mirrorwave() replaces the KS_WAVEFORM with its (temporally) mirrored version. This can be used to e.g.
    mirror a minimum phase excitation pulse for fast recovery and T1-optimization in FSE sequences (ksfse.e).#pragma endregion
    See also ks_eval_stretch_rf().

 *  @param[in,out] wave KS_WAVE object, whose KS_WAVEFORM to be mirrored
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_mirrorwave(KS_WAVE *wave);


/** @brief #### Sets up a KS_WAVE object based on a waveform that resides on disk

    ks_eval_wave_file() reads waveforms on disk into a KS_WAVE. The data format (arg 6) may currently be one of:
    1. "GE": GE's file format for external pulses (.rho, .gz, etc.). The data will be divided by a factor of MAX_PG_WAMP (32766) before copied to KS_WAVE
    2. "short": Plain short integer format. The data will be divided by a factor of MAX_PG_WAMP (32766) before copied to KS_WAVE
    3. "float": Plain float format. Data will be read in as is and copied to KS_WAVE

    When the first two formats are used the field `.waveform` in KS_WAVE will contain data in the range [-1.0,1.0]. *res* elements are read from
    disk in the specified format into the field `.waveform` in the KS_WAVE object (1st arg). *duration* (4th arg) must be
    divisible by *res* (3rd arg) and at least 2x *res*.

    When using (i.e. calling ks_pg_wave()) the waveform for:
    1. RF or OMEGA, nothing needs to be done in terms of amplitude scaling. For RF, amplitude scaling is handled via the KS_RF object, and
    for OMEGA the number of [Hz] are set directly in run-time (scan())
    2. THETA, the waveform needs to be scaled to units of [degrees]
    3. XGRAD, YGRAD, or ZGRAD, the waveform needs to be scaled to units of [G/cm]

 *  @param[out] wave KS_WAVE object to be created
 *  @param[in] desc A description (text string) of the KS_WAVE object. This description is used for pulse sequence generation
                        (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] res KS_WAVE object to be created
 *  @param[in] duration KS_WAVE object to be created
 *  @param[in] filename Filename on disk
 *  @param[in] format String denoting the data format on disk. Valid values are: "ge" (reads GE's *.rho files with 32byte header), "short", and "float", the
                      latter two being header-less
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_wave_file(KS_WAVE *wave, const char * const desc, int res, int duration, const char *const filename, const char *const format) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_RF object with a Sinc pulse shape

    For small flip angles, the Fourier transform of the RF envelope is a good approximation of the final slice profile and SLR designed pulses may not be necessary.
    For these cases, this function can be used to create a Sinc RF pulse (as a KS_RF object) with a desired bandwidth (BW), time-bandwidth-product (TBW)
    and window function (e.g. KS_RF_SINCWIN_HAMMING, see ks_enum_sincwin). An increased TBW results in more Sinc lobes and sharper slice profiles,
    and the minimum value is 2. The *duration* of the RF pulse (`.rfwave.duration`) increases when BW decreases or TBW increases

 *  @param[out] rf KS_RF object to be created
 *  @param[in] desc  A description (text string) of the KS_RF object. This description is used for pulse sequence generation
                       (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] bw Bandwidth of the RF pulse [Hz]
 *  @param[in] tbw Time-bandwidth-product of the RF pulse. Higher value gives sharper slice profiles but increases the duration
 *  @param[in] flip Nominal flip angle of the RF pulse
 *  @param[in] wintype Window function over the Sinc. See ks_enum_sincwin for enums names that steer the window choice
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rf_sinc(KS_RF *rf,  const char * const desc, double bw, double tbw, float flip, int wintype) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_RF object with a Hyperbolic Secant shape
*/
STATUS ks_eval_rf_secant(KS_RF *rf, const char * const desc, float A0, float tbw, float bw);


/** @brief Sets up a KS_RF object with a rectangular (hard) pulse of a given duration

    This function creates a hard RF pulse of the desired duration. Hard pulses are typically used as non-slice selective RF pulses, as their slice profile would
    be very poor (Sinc-like). The resolution of the RF pulse created is equal to the duration/2

 *  @param[out] rf KS_RF object to be created
 *  @param[in] desc A description (text string) of the KS_RF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] duration Desired duration in [us] of the waveform (must be even)
 *  @param[in] flip Nominal flip angle of the RF pulse
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rf_hard(KS_RF *rf, const char * const desc, int duration, float flip) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_RF object with a rectangular (hard) pulse with optimal duration for fat selection/saturation

    This function creates a hard RF pulse with optimal duration for fat selection/saturation. Hard pulses are typically used as non-slice selective RF pulses.
    Their slice profile is sinc-like and with this function you can create a hard pulse with a sinc-minima at the center of the spectral fat-peak.
    You can select wich minima using the input 'order'. A higher order generates a longer pulse duration with a more narrow frequency response. If the
    pulse is tuned to the fat peak, using input 'offsetFreq', the minimia will instead end up at the water-peak.
    The resolution of the RF pulse created is equal to the duration/2

 *  @param[out] rf KS_RF object to be created
 *  @param[in] desc A description (text string) of the KS_RF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] order Select wich minima to use
 *  @param[in] flip Nominal flip angle of the RF pulse
 *  @param[in] offsetFreq choose center frequency offset
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rf_hard_optimal_duration(KS_RF *rf, const char * const desc, int order, float flip, float offsetFreq) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_RF object as a Binomial RF pulse

    This function creates a binomial RF pulse, which consists of a series of hard pulses. Binomial pulses are used for spectral selection.
    They utilize the difference in resonance frequency of different tissue types, such as water and fat.
    Increasing the number of sub-pulses will improve the spectral selectivity but also increse the pulse duration.

 *  @param[out] rf KS_RF object to be created
 *  @param[in] desc A description (text string) of the KS_RF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] offResExc If 0 the pulse will excite the spinns at the center frequency, If 1 the pulse will excite the spinns
                         at the offset frequency (given by input: offsetFreq)
 *  @param[in] nPulses Number of sub-pulses
 *  @param[in] flip Nominal flip angle of the RF pulse
 *  @param[in] offsetFreq choose center frequency offset in Hz
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rf_binomial(KS_RF *rf, const char * const desc, int offResExc, int nPulses, float flip, float offsetFreq) WARN_UNUSED_RESULT;

/** @brief #### Sets up the RF_PULSE structure of a KS_RF object

    For RF scaling, SAR calculation, and RF heating calculations, GE uses a global array of RF_PULSE structs, where each RF pulse is associated
    with one RF_PULSE struct each. This struct array contains RF pulses from Prescan as well as the pulse sequence itself, and is normally
    declared in a grad_rf_<psd>.h file.

    Here, each KS_RF object has its own RF_PULSE struct (the field `.rfpulse`), which this function sets up. The following fields in the KS_RF
    object must be set before calling this ks_eval_rfstat()
    1. `.rfwave`: Must contain the RF pulse waveform. An error is return if either `.thetawave` or `.omegawave` are non-empty (complex RF pulses not allowed)
    2. `.bw`: The bandwidth of the RF pulse [Hz]
    3. `.iso2end`: Time from the magnetic center of the RF pulse to the end, in [us]
    4. `.flip`: The flip angle of the RF pulse [degrees]. In this function, `.flip` will set `.rfpulse.nom_fa` and make sure `.rfpulse.act_fa` points to `.flip`

    The RF waveform will be amplitude scaled so that its maximum absolute amplitude is 1.0 before making the calculations. Also the proper links between fields
    int the `.rfpulse` (RF_PULSE) struct and the parent fields in KS_RF are set up by calling ks_eval_rf_relink()

    Credits: This function has been made largely after the code by Atsushi Takahashi, GE Healthcare.

 *  @param[in,out] rf KS_RF object to calculate the RF_PULSE parameters for (in field `.rfpulse`)
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rfstat(KS_RF *rf) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_RF object

    See documentation for the KS_RF object for details on how to prepare the KS_RF object before calling ks_eval_rf()

    This function does *not* set up a KS_RF object by itself, merely it peforms final validation, naming, makes sure fields and links in KS_RF
    are properly set up. ks_eval_rf() should be called for non-slice selective RF pulses.
    For slice-selective RF pulses, use KS_SELRF and call ks_eval_selrf() instead

 *  @param[in,out] rf Pointer to the KS_RF object to be set up
 *  @param[in] desc A description (text string) of the KS_RF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_rf(KS_RF *rf, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### (*Internal use*) Relinks pointers between fields in a KS_RF object

    This function is used by other RF functions to make sure that the links from pointers in `.rfpulse` are relinked to other fields
    inside the KS_RF object. This function does not need to be called manually as long as either ks_eval_rf(), ks_eval_selrf() are called.

    If a KS_RF object is copied to another KS_RF object by simple assignment ('=' sign), then these pointers must be updated before the assigned KS_RF object can
    be used. Best practice is to call ks_eval_rf() or ks_eval_selrf() instead of this function, as more validation is performed and because description of
    the new KS_RF is also updated

 *  @param[in,out] rf Pointer to the KS_RF object to be set up
*/
void ks_eval_rf_relink(KS_RF *rf);


/** @brief #### In-place stretching of a KS_RF object

    This function takes a KS_RF object already set up, having some resolution (`rfwave.res`), bandwidth (`.bw`), duration (`rfwave.duration`)
    and waveform (`.rfwave.waveform`) and performs a linear interpolation of the waveform contained in `.rfwave.waveform` so its new duration becomes

    `newDuration = oldDuration * stretch_factor`

    - Note that regardless of the input resolution of the waveform, the output resolution will always be newDuration/2.
    - The description of the stretched KS_RF object (`.rfwave.description`) is updated with a suffix *stretched*
    - The fields `.start2iso`, `.iso2end` and `.bw` are automatically updated to reflect the new duration

 *  @param[in,out] rf Pointer to the KS_RF object to be stretched
 *  @param[in]  stretch_factor Stretch factor (float) that widens/shortens the RF pulse if larger/smaller than 1.0. If negative, the RF waveform will be mirrored (in time)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_stretch_rf(KS_RF *rf, float stretch_factor);



/** @brief #### (*Internal use*) Sets up a trapezoid for RF slice selection

    This function is used by ks_eval_selrf_constrained() (and its wrapper functions, e.g. ks_eval_selrf()), and there is no need
    to use this function directly.

    Based on the RF bandwidth and duration, this function will create a trapezoid gradient that with this type of RF pulse creates a slice
    with the desired thickness, by in turn calling ks_calc_selgradamp().

 *  @param[out] trap Pointer to the KS_TRAP object to be set up
 *  @param[in] desc A description (text string) of the KS_PHASER object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in] slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @param[in] slthick The desired slice thickness in [mm]. If = 0, the slice selection gradient will have zero amplitude (hard pulses)
 *  @param[in] bw The bandwidth of the RF pulse to use with the gradient. If = 0, the slice selection gradient will have zero amplitude (hard pulses)
 *  @param[in] rfduration The duration of the RF pulse to use with the gradient
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seltrap(KS_TRAP *trap, const char * const desc, float slewrate, float slthick, float bw, int rfduration) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_SELRF object for RF slice selection, subject to gradients constraints specified as input arguments

   This function does *not* set up the KS_RF field in KS_SELRF itself, see KS_RF and ks_eval_rf() for more details on how to prepare the `.rf` field in KS_SELRF
   before calling ks_eval_selrf_constrained()

   The following fields in the KS_SELRF object must be set up before calling this function:
   1. A ready KS_RF object, with a proper `.rf.role` (see below for details)
   2. `.slthick`: Slice thickness in [mm]. Note that the slice thickness often needs to be made larger to compensate from slice narrowing due to multiple RF pulses. GE
      uses usually `gscale_rfX` CVs with values often between 0.8-0.9. Dividing with this number gives a thicker slice in the calculations. NOTE:
      `.slthick = 0` is accepted and results in zero gradient amplitude with minimal 4us ramps and a plateautime = .rf.rfwave.duration (cf. ks_eval_seltrap()->ks_calc_selgradamp())

   ks_eval_selrf_constrained() checks `.rf.role` to decide on how to set up its gradient objects. The following values of `.rf.role` are allowed:
    - `KS_RF_ROLE_EXC`, indicating an RF *excitation* role. ks_eval_selrf_constrained() will in this case:
      - disable `.pregrad`
      - make `.grad.plateautime` equal to the RF duration (`.rf.rfwave.duration`) and the gradient amplitude (`.grad.amp` [G/cm])
        will be set to the proper value depending on the BW (`.rf.bw`) and slice thickness (`.slthick`).
        The field `.grad.description` will have a ".trap" suffix added to it
      - make `.postgrad` to have a gradient area that rephases the slice. This is dependent on the isodelay of the RF pulse (`.rf.iso2end`) and the slice select
        gradient amplitude (`.grad.amp`). The field `.postgrad.description` will have a ".reph" suffix added to it
    - `KS_RF_ROLE_REF`, indicating an RF *refocusing* role. ks_eval_selrf_constrained() will in this case:
      - use `.pregrad` to make the left crusher (never *bridged* with slice selection). The size of the crusher can be controlled by `.crusherscale`.
        The field `.pregrad.description` will have a ".LC" suffix added to it
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - use `.postgrad` to make the right crusher (never *bridged* with slice selection). The size of the crusher can be controlled by `.crusherscale`.
        The field `.postgrad.description` will have a ".RC" suffix added to it
    - `KS_RF_ROLE_INV`, indicating an RF *inversion* role. ks_eval_selrf_constrained() will in this case:
      - disable `.pregrad`
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - disable `.postgrad`
    - `KS_RF_ROLE_SPSAT`, indicating a *spatial RF saturation*. ks_eval_selrf_constrained() will in this case:
      - disable `.pregrad`
      - do the same with `.grad` as done for `KS_RF_ROLE_EXC`
      - use `.postgrad` to make a gradient spoiler (never *bridged* with slice selection). The size of the spoiler can be controlled by `.crusherscale`.
        The field `.postgrad.description` will have a ".spoiler" suffix added to it

    The role `KS_RF_ROLE_CHEMSAT`, indicates a non-slice selective, chemically selective, RF (usually *fat-sat*). ks_eval_selrf_constrained() will in this case throw an error since
      no gradients should be used

    There are three wrapper functions to this function (ks_eval_selrf(), ks_eval_selrf1(), ks_eval_selrf2()) that have reduced number of input arguments,
    and calls ks_eval_selrf_constrained() with different preset gradient constraints. ks_eval_selrf() makes fewest assumptions, making it the most general choice.

    #### Using a custom gradient wave for slice selection (`.gradwave`)
    To support e.g. VERSEd RF excitations, a custom gradient wave can be used. If `.gradwave.res > 0`, ks_eval_selrf_constrained() will disable `.grad` and use `.gradwave` instead.
    When `.rf.role = KS_RF_ROLE_EXC`, the rephasing gradient area (in `.postgrad`) will be calculated by integrating the gradient waveform
    from the RF isocenter to the end. `.gradwave` must be created *before* calling ks_eval_selrf_constrained() using either ks_eval_wave() or ks_eval_wave_file(), and the units must
    be in [G/cm]. To further scale the amplitude of `.gradwave` before calling ks_eval_selrf_constrained(), consider e.g. ks_wave_multiplyval(), ks_wave_absmax(), and possibly
    ks_wave_addval()

 *  @param[in,out] selrf    Pointer to the KS_SELRF object to be set up
 *  @param[in]     desc     A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                            (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in]     ampmax   The maximum allowed gradient amplitude ([G/cm])
 *  @param[in]     slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @retval        STATUS   `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_selrf_constrained(KS_SELRF *selrf, const char * const desc, float ampmax, float slewrate) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_SELRF object for RF slice selection with preset gradient constraints

    This is a wrapper function to ks_eval_selrf_constrained() with gradient constraints set to allow this KS_SELRF to be played on any axis
    while other gradients (set up with the same constraints) can be played out on the other two gradient boards, for any slice angulation.
    This is the generic and safest configuration, but for thin slices and high RF BWs, the gradient limits may be reached, especially for double oblique slices

    See ks_eval_selrf_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] selrf Pointer to the KS_SELRF object to be set up
 *  @param[in] desc A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_selrf(KS_SELRF *selrf, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_SELRF object for RF slice selection with preset gradient constraints

    This is a wrapper function to ks_eval_selrf_constrained() with gradient constraints set to allow this KS_SELRF to be played on any axis
    while one more gradient (set up with the same constraints) can be played out on another gradient board, for any slice angulation.
    For double oblique slice angulations, this function will allow for thinner slices and higher RF BWs than ks_eval_selrf()

    See ks_eval_selrf_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] selrf Pointer to the KS_SELRF object to be set up
 *  @param[in] desc A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_selrf2(KS_SELRF *selrf, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up a KS_SELRF object for RF slice selection with preset gradient constraints

    This is a wrapper function to ks_eval_selrf_constrained() with gradient constraints set to allow this KS_SELRF to be played on any axis, as long as
    no other gradients are be played out simultaneously.
    For double oblique slice angulations, this function will allow for thinner slices and higher RF BWs than ks_eval_selrf() and ks_eval_selrf2()

    See ks_eval_selrf_constrained() for details on fields that need to be set before calling this function

 *  @param[in,out] selrf Pointer to the KS_SELRF object to be set up
 *  @param[in] desc A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                    (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_selrf1(KS_SELRF *selrf, const char * const desc) WARN_UNUSED_RESULT;


/** @brief #### Sets up an array with values for phase modulation between slices in a multi-band (MB) RF

 *  @param[out] sms_phase_modulation Array with phase modulation between slices in a MB RF
 *  @param[in] sms_multiband_factor The multi-band acceleration factor
 *  @param[in] sms_phase_modulation_mode See ks_enum_smstype for options
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_sms_get_phase_modulation(float *sms_phase_modulation, const int sms_multiband_factor, const int sms_phase_modulation_mode) WARN_UNUSED_RESULT;


/** @brief #### Finds a stretch factor leading to the specified peak B1

  *  @param[in] selrf rf object KS_SELRF
  *  @param[in] max_b1 peak B1
  *  @param[in] scaleFactor initial stretch factor
  *  @param[in] sms_multiband_factor SMS factor
  *  @param[in] sms_phase_modulation_mode SMS phase modulation mode
  *  @param[in] sms_slice_gap SMS slice gap
  *  @return float stretch factor
*/
float ks_eval_findb1(KS_SELRF *selrf, float max_b1, double scaleFactor, int sms_multiband_factor, int sms_phase_modulation_mode, float sms_slice_gap);


/** @brief #### Creates a SMS (simultaneous-multi-slice) version of a KS_SELRF object

 *  @param[out] selrfMB                    Pointer to multiband (SMS) KS_SELRF object
 *  @param[in]  selrf                      The original (single-band) KS_SELRF object (set up using ks_eval_selrf())
 *  @param[in]  sms_multiband_factor       The multi-band acceleration factor
 *  @param[in]  sms_phase_modulation_mode  See ks_enum_smstype for options
 *  @param[in]  sms_slice_gap              Slice gap in [mm] for the selrfMB pulse
 *  @param[in]  debug                      Debug flag for writing out text files (SIM: in current dir HW:/usr/g/mrraw/kstmp)
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_sms_make_multiband(KS_SELRF *selrfMB, const KS_SELRF *selrf, const int sms_multiband_factor, const int sms_phase_modulation_mode, const float sms_slice_gap, int debug) WARN_UNUSED_RESULT;


/** @brief #### Calculates the resulting slice gap in [mm] for SMS RF

 *  @param[in] sms_multiband_factor The multi-band acceleration factor
 *  @param[in] org_slice_positions  SCAN_INFO struct holding the original slice information
 *  @param[in] nslices              Prescribed number of slices
 *  @param[in] slthick              Prescribed slice thickness
 *  @param[in] slspace              Prescribed slice spacing
 *  @retval    slicegap             SMS slice gap in [mm]
 */
float ks_eval_sms_calc_slice_gap(int sms_multiband_factor, const SCAN_INFO *org_slice_positions, int nslices, float slthick, float slspace);

/** @brief #### Calculates the CAIPI blip area

 *  @param[in] caipi_fov_shift The FOV shift in units of faction of FOV (e.g. 2 means shift of FOV/2)
 *  @param[in] sms_slice_gap Slice gap in [mm] for the selrfMB pulse
 *  @retval caipi_blip_area The area of the CAIPIRINHA blip in [(G/cm) * us]
 */
float ks_eval_sms_calc_caipi_area(int caipi_fov_shift, float sms_slice_gap);


/** @brief #### Creates a PINS RF pulse (KS_SELRF) based on a KS_SELRF object

 *  @param[out] selrfPINS PINS RF pulse (KS_SELRF object)
 *  @param[in] selrf The original (single-band) KS_SELRF object (set up using ks_eval_selrf())
 *  @param[in] sms_slice_gap Slice gap in [mm] for the selrfMB pulse
 *  @retval STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_sms_make_pins(KS_SELRF *selrfPINS, const KS_SELRF *selrf, float sms_slice_gap);
STATUS ks_eval_sms_make_pins_dante(KS_SELRF *selrfPINS, const KS_SELRF *selrf, float sms_slice_gap);



/** @brief #### Find nearest neighbor index (NEEDS BETTER DOCUMENTATION)
 *  @param[in] value
 *  @param[in] x      Input array
 *  @param[in] length Length of array
 *  @retval    index  Index into array
 */
int ks_eval_findNearestNeighbourIndex(float value, const float *x, int length);


/** @brief #### Linear interpolation

 *  @param[in]  x         Input array of x coordinates for data (y)
 *  @param[in]  x_length  Length of array
 *  @param[in]  y         Input array of data (same length as x)
 *  @param[in]  xx        Array of new sample points of the data in y
 *  @param[in]  xx_length Length of array with new sample points
 *  @param[out] yy        Output array with interpolated data
 *  @retval     STATUS    `SUCCESS` or `FAILURE`
 */
void ks_eval_linear_interp1(const float *x, int x_length, const float *y, const float *xx, int xx_length, float *yy);


/** @brief #### Converts a trapezoid object (KS_TRAP) to a wave object (KS_WAVE)

    The input KS_TRAP object will be converted to a KS_WAVE object, which will have its `.waveform` (float array) field filled with
    the shape of the trapezoid with the maintained GRAD_UPDATE_TIME (4 [us]) sample duration. The `.waveform` amplitude on the plateau will be `.amp` [G/cm].

 *  @param[out] wave   Pointer to a KS_WAVE object to be set up with same shape as the trapezoid (KS_TRAP) in arg 2
 *  @param[in]  trap   The trapezoid to convert into a waveform
 *  @retval     STATUS `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_trap2wave(KS_WAVE *wave, const KS_TRAP *trap) WARN_UNUSED_RESULT;



STATUS ks_eval_append_two_waves(KS_WAVE* first_wave, KS_WAVE* second_wave) WARN_UNUSED_RESULT;

STATUS ks_eval_concatenate_waves(int num_waves, KS_WAVE* target_wave, KS_WAVE** waves_to_append) WARN_UNUSED_RESULT;

/** @brief #### Sets up a KS_EPI composite sequence object, subject to gradients constraints specified as input arguments

    The KS_EPI composite sequence object controls an entire EPI train (including de/rephasers on freq & phase axes).
    Four fields in KS_EPI are other sequence objects:
    - KS_READTRAP `.read`: The EPI readout lobes including data acquisition
    - KS_TRAP `.readphaser`: The dephaser & rephaser gradients before & after the train of readout lobes, on the same board as `.read`
    - KS_TRAP `.blip`: The blip gradients in the phase encoding direction between the readout lobes
    - KS_PHASER `.blipphaser`: The dephaser & rephaser gradients on the same board as the `.blip` gradients.
      For multi-shot EPI these gradients will change in scan() when calling ks_scan_epi_shotcontrol()

    Before calling this function, portions of the `.read` field (KS_READTRAP) and `.blipphaser` field (KS_PHASER) must be set up.
    Here follows a list of fields that must be set:
    1. `.read.fov`: The Field-of-View (FOV) in the frequency encoding (readout) direction
    2. `.read.res`: The number of pixels within the FOV along the frequency encoding direction
    3. `.blipphaser.fov`: The Field-of-View (FOV) in the phase encoding direction
    4. `.blipphaser.res`: The number of pixels within the FOV along the phase encoding direction
    5. `.blipphaser.R`: Either the number of EPI shots or the parallel imaging factor
    6. `.read.rampsampling`: Whether rampsampling should be used (see KS_READTRAP). Value of 1 is recommended for EPI
    7. `.read.acq.rbw`: The receiver bandwidth in [kHz/FOV]. Maximum: 250 (recommended)

    If the KS_EPI object is initialized with KS_INIT_EPI on declaration, `.read.rampsampling` will already be set to 1 and `.read.acq.rbw`
    will be set to 250.0 (hence steps 6-7 can be skipped).

    Single-shot EPI acquisitions are geometrically distorted to some degree depending on chosen `.read.res` and `.blipphaser.fov`. To reduce the EPI distortions, either multi-shot EPI
    or *parallel imaging* acceleration can be used. For both alternatives, every Rth phase ecoding lines are acquired in k-space as the EPI train is played out. *R* corresponds to the number
    of shots (`opnshots` menu in the UI) or the parallel imaging factor. Therefore, e.g. a 4-shot EPI readout is identical to an *R* = 4 accelerated EPI readout
    with the same FOV and resolution, why one same field `.R` may be used to control the EPI train setup, be it multi-shot or parallel imaging acceleration (but not both at the same time).
    What differs between multi-shot and parallel imaging acceleration in the acquisition is only whether the `.blipphaser` should change from TR to TR.
    Hence, to set up a KS_EPI object, use the field `.R` for both multi-shot EPI and parallel imaging scenarios.

    The remaining fields of interest in the KS_EPI sequence objects are:
    - `.etl`: This is the echo-train-length (ETL) of the EPI readout train, set by ks_eval_epi() based on `.blipphaser.res` and `.blipphaser.R`
    - `.read_spacing`: Additional spacing in [us] between readout lobes. Default value is zero, but can be set > 0 if additional gradients is to be inserted between the readout lobes.
      One scenario is adding CAIPIRINHA blips on ZGRAD during the time where the EPI readout is played out in the pulse sequence
    - `.duration`: Convenience information for timing calculations, set by ks_eval_epi(). This is the total time in [us] for the EPI train, including the de/rephasers on the frequency/phase axes.
      Note that there are also `.duration` fields for each of the four `KS_***` sequence objects in KS_EPI, stating the duration of each of these components.
    - `.time2center`: Convenience information for timing calculations, set by ks_eval_epi(). The time in [us] from the start of the first dephaser until the center of k-space is reached.
      This deviates from `<epi>.duration/2` for partial Fourier EPI trains where `.blipphaser.nover > 0` (a.k.a. fractional NEX, but typically shown as MiniumTE in the UI for EPI)

    If peripheral nerve stimulation would be observed, consider calling ks_eval_epi_constrained() with reduced *slewrate*. This will however increase
    the geometric distortions in the images

 *  @param[in,out] epi      Pointer to the KS_EPI object to be set up
 *  @param[in]     desc     A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                            (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
 *  @param[in]     ampmax   The maximum allowed gradient amplitude ([G/cm])
 *  @param[in]     slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 *  @retval        STATUS   `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_epi_constrained(KS_EPI *epi, const char * const desc, float ampmax, float slewrate) WARN_UNUSED_RESULT;


/** @brief #### Set convenience info for KS_EPI based on objects' timing in KS_EPI */
STATUS ks_eval_epi_setinfo(KS_EPI *epi);


/**
 *******************************************************************************************************
 @brief #### Get maximum amplitude and slewrate for the EPI readout constrained by hardware and PNS

 Get a reasonably optimized max gradient amplitude and slewrate for the EPI train.
 This function results in similar values as GE's epigradopts(), where
 gradient system limits and peripheral-nerve-stimulation (PNS) are not to be exceeded.
 ks_eval_epi_maxamp_slewrate() has no dB/dt model, but is dependent on xres (assuming fixed FOV,
 rampsampling and maxmimum rBW).
 This has also been tested for axial and oblique scans on volunteers at Karolinska without PNS experience
 using FOV = 24 cm on both DV750 and DV750w with rampsampling and rBW = 250.
 If PNS should still occur, the slewrate value passed to ks_eval_epi_constrained() should be decreased.
 The units of the slewrate is [(G / cm) / us], i.e. gradient amp in G / cm divided by the ramptime in us.
 This value times 1e4 gives slewrate in SI units: T / m / s (up to e.g. 200).

 @param[out]     ampmax   The maximum allowed gradient amplitude ([G/cm])
 @param[out]     slewrate The maximum allowed slewrate ([(G/cm) / us]). Value of 0.01 corresponds to 100 mT/m/s
 @param[in]      xres The frequency encoding resolution
 @param[in]      quietnessfactor Value >= 1 used for optional gradient derating
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ks_eval_epi_maxamp_slewrate(float *ampmax, float *slewrate, int xres, float quietnessfactor);



/** @brief #### Sets up a KS_EPI composite sequence object with preset gradient constraints

    This is a wrapper function to ks_eval_epi_constrained() with a reduced set of input arguments using preset gradient constraints. These constraints
    should allow for EPI readouts for double oblique slice angulations, but the values for *ampmax* or *slewrate* may not be optimal. If peripheral nerve
    stimulation (PNS) would be observed, consider calling ks_eval_epi_constrained() directly with reduced *slewrate*. This will however increase
    the geometric distortions in the images

    See ks_eval_epi_constrained() for more details on fields in KS_EPI that must be set before calling this function

 *  @param[in,out] epi    Pointer to the KS_EPI object to be set up
 *  @param[in]     desc   A description (text string) of the KS_SELRF object. This description is used for pulse sequence generation
                          (seen in the file generated by *TimeHist* in *MGD Sim/WTools*)
    @param[in]      quietnessfactor Value >= 1 used for optional gradient derating
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_eval_epi(KS_EPI *epi, const char * const desc, float quietnessfactor) WARN_UNUSED_RESULT;


/**
 * @brief #### Returns the time required to play out a certain number of sequence modules over some interval, honoring SAR, RF power and gradient heating constraints
 *
 * This function uses one KS_SEQ_COLLECTION struct holding the RF and gradient information for the entire psd (involving one or more sequence modules)
 * to check if an interval can be played out as is or if the overall duration needs to be increased to honor SAR and hardware limits.
 * The interval of measurement is given by the function pointer passed to ks_eval_mintr(), which typically is a sliceloop function playing
 * out the slices for one TR (using one or more sequence modules).
 *
 * The net time for this period is given by the sum of instances and durations of the sequence modules involved. This information is taken from
 * ks_eval_seqcollection_gettotalduration(), which sums the product of the duration of each sequence module by the number of instances of each
 * sequence module.
 *
 * ks_eval_gradrflimits() will call GE's regular SAR, RF power and gradient heating functions after creating temporary RF_PULSE and GRAD_PULSE structs
 * using the sequence objects (RF and gradients) in the sequence modules.
 *
 * The gradient information for all sequence modules is accessed via `seqcollection->seqctrlptr[i].gradrf.trapptr[...]`, while the RF information
 * for all sequence modules is accessed via `seqcollection->seqctrlptr[i].gradrf.rfptr[...]`, with *i* being the internal sequence module index.
 *
 * GE's hardware and SAR check functions will return new minimum durations, which may be equal or larger than the net time, depending on the hardware and safety
 * limits. The largest new minimum duration is the return value for this function. Also, if the 1st argument (KS_SAR *) is not pointing to NULL,
 * the SAR information will be stored in this struct, so it can be used by the calling function.
 *
 * Currently, KSFoundation does not use GE's new gradheat method where cornerpoints of the sequence waveforms are used for the gradient heating
 * calculations. When using the old method, the `minseq()` function will likely be too conservative and may add unnecessary time penalty. The level of
 * exaggeration is not clear, why there is a temporary solution with a 'gheatfact' as an input argument, where it is up to the EPIC programmer to decide on this.
 * This variable should be 1.0 to fully obey the old gradient heating calculations (understanding the minimum TR can bump up significantly).
 * To fully ignore gradient heating calculations a value of 0.0 is used. The proper value of this variable, that would correspond to the actual hardware gradient limits,
 * is not known at the moment, but a value closer to 0.0 than 1.0 better matches the new gradient heating model used by GE's product psds. Having said that,
 * absolutely no guarantees are given in terms of gradient damage or similar.
 *
 * See also: ks_eval_mintr(), ks_eval_maxslicespertr(), ks_eval_seqcollection_gettotalduration()
 *
 * @param[out]  sar           Pointer to KS_SAR struct with SAR parameters. If NULL, no attempt to store SAR parameters will be done. If
 *                            not null, KS_SAR will be set up. In addition, the description of GE's CV 'optr' will be changed so that
 *                            one can see the limit factor and how much time that had to be added to be within specs. This information can be
 *                            viewed on the MR system while scanning by DisplayCV and type in 'optr'.
 * @param[in]   seqcollection A KS_SEQ_COLLECTION struct, which have undergone a reset of `seqctlptr[].nseqinstances` followed by a single run of
 *                            the sequence's slice loop or equivalent period
 * @param[in]   gheatfact     Experimental fudge factor in range [0.0, 1.0] to control how much to obey the gradient heating calculations using the old
 *                            gradient heating model. It is up to the EPIC programmer to set this to a proper value for now. This input argument can hopefully be
 *                            removed in the future
 * @retval      int           Minimum time in [us] that is needed to safetly play out the `.nseqinstances` sequence modules over the intended interval (usually one *TR* for 2D sequences)
 */
int ks_eval_gradrflimits(KS_SAR *sar, KS_SEQ_COLLECTION *seqcollection, float gheatfact);


/**
 * @brief #### Returns the minimum TR based on the content of a slice loop, adding additional time due to SAR and hardware constraints if necessary
 *
 * This function relies on the existence of a slice loop (wrapper) function that can be run on both HOST and TGT. In addition, it needs a KS_SEQ_COLLECTION struct
 * containing references to the sequence modules (KS_SEQ_CONTROL) used in the slice loop.
 * ks_eval_mintr() will call the slice loop, passed in as a function pointer, with *nslices* as the first argument.
 *
 * Different psds have different arguments to their slice loop function depending on what is needed to know for the particular sequence,
 * but a standardized argument list of the sliceloop function is required to allow it to be passed in to ks_eval_mintr().
 * Therefore, a small wrapper function is likely needed for the psd's sliceloop. Moreover, the sliceloop function must return the time in [us] (int) corresponding to the
 * duration to play out the slice loop for *nslices* number of slices. E.g. if there is a psd specific function
 * \code{.c}
   int mysliceloop(int nslices, int ky, int exc, float somecustominfo) {
      int time = 0;

      for (i = 0; i < nslices; i++) {
         time += ks_scan_playsequence(&fatsatseqctrl); // play the fatsat sequence module, and count up fatsatseqctrl.nseqinstances by 1
         time += ks_scan_playsequence(&mymainseqctrl); // play the main sequence, and count up mymainseqctrl.nseqinstances by 1
      }

     return time; // return the duration of the sliceloop given 'nslices' slices.
                  // This time is used to set the scan clock, while the .nseqinstances and .duration fields of each seqctrl struct
                  // is used by ks_eval_gradrflimits() and ks_eval_mintr() to determine the total duration. .nseqinstances must be
                  // known to calculate SAR in order to get the correct number of RF pulses for the slice loop via seqctrl.gradrf.rfptr[]
   }
   \endcode

 * there should be a wrapper function with the following fixed input args:
 * 1. nslices
 * 2. nargs (number of extra arguments)
 * 3. args (pointer to array of `(void *)` for the *nargs* extra arguments)
 *
 * The most important argument is *nslices*, which must be passed to `mysliceloop()` so that different times are returned for different *nslices*. Hence, `mysliceloop()` must
 * also have *nslices* as an input argument.
 *
 * #### Scenario 1:
 * If the remaining arguments to `mysliceloop()` (like *ky*, *exc*, *somecustominfo*) do **not** affect the sequence timing, the sliceloop wrapper function can be written as
 * (using mysliceloop() above):
   \code{.c}
   int mysliceloop_nargs(int nslices, int nargs, void **args) {

      mysliceloop(nslices, 0, 0, 0.0); // args 2-4 are set to 0 since ky, exc, or somecustominfo do not change the sliceloop timing and we will
                                       // only evaluate this on HOST where we are dry-running the sliceloop for timing reasons

  }
  \endcode
 *
 * #### Scenario 2:
 * If some of the remaining arguments to `mysliceloop()` (like *ky*, *exc*, *somecustominfo*) affect the sequence timing, the sliceloop wrapper function can be written as
 * (using mysliceloop() above):
  \code{.c}
  int mysliceloop_nargs(int nslices, int nargs, void **args) {
    int ky = 0;
    int exc = 0;
    float somecustominfo = 0;

    if (nargs >= 1 && args[0] != NULL) {
      ky = *((int *) args[0]); // cast from (void *) to (int *) and dereference
    }
    if (nargs >= 2 && args[1] != NULL) {
      exc = *((int *) args[1]); // cast from (void *) to (int *) and dereference
    }
    if (nargs >= 3 && args[2] != NULL) {
      somecustominfo = *((float *) args[2]); // cast from (void *) to (float *) and dereference
    }

    return mysliceloop(nslices, ky, exc, somecustominfo);
  }
  \endcode
 *
 * For scenario #2, *nargs* and *args* must be set up before calling ks_eval_mintr(), e.g. like:
   \code{.c}
   void *args[] = {(void *) &ky,
                   (void *) &exc,
                   (void *) &somecustominfo}; // pass on the args to mysliceloop() via mysliceloop_nargs()
   int nargs = sizeof(args) / sizeof(void *);

   ks_eval_mintr(nslices, &seqcollection, mysliceloop_nargs, nargs, args);
   \endcode
 *
 *
 * #### Calculation of the minimum TR in three steps using ks_eval_mintr():
 * 1. Set the `.nseqinstances` field to 0 for all KS_SEQ_CONTROL structs being a part of the KS_SEQ_COLLECTION using ks_eval_seqcollection_resetninst()
 * 2. Run the slice loop (wrapper) function for the psd (see above) passed in as a function pointer. This will set the `.nseqinstances` field for each sequence module
 *    equal to the number of playouts of that sequence module in the slice loop
 * 3. Call ks_eval_gradrflimits(), which will
 *    - use the `.nseqinstances` and `.duration` fields of each sequence module to determine the total net duration for the given number of slices
 *    - add potential extra time to keep us within SAR and hardware limits
 *
 *
 * The return value of ks_eval_gradrflimits() is also the return value of ks_eval_mintr()
 *
 *
 * @param[in]   nslices       Number of slices to play out in the slice loop
 * @param[in]   seqcollection A KS_SEQ_COLLECTION struct, which have undergone a reset of `seqctlptr[].nseqinstances` followed by a single run of
 *                            the sequence's slice loop or equivalent period
 * @param[in]   gheatfact     Experimental fudge factor in range [0.0, 1.0] to control how much to obey the gradient heating calculations using the old
 *                            gradient heating model. It is up to the EPIC programmer to set this to a proper value for now. This input argument can hopefully be
 *                            removed in the future
 * @param[in]   play_loop     Function pointer to the sliceloop (wrapper) function of the sequence. This function should perform all time consuming tasks for one TR. It is a requirement
 *                            that this function has three input arguments: `int nslices, int nargs, void **args`
 * @param[in]   nargs         Number of extra arguments to the slice loop wrapper function. This can be 0 if the slice loop is only temporally dependent on *nslices*
 * @param[in]   args          void * pointer array to extra arguments. This can be NULL if the slice loop is temporally dependent only on *nslices*
 * @retval      int           Minimum time in [us] that is needed to safetly play out the `.nseqinstances` sequence modules over the intended interval (usually one *TR* for 2D sequences)
 */
int ks_eval_mintr(int nslices, KS_SEQ_COLLECTION *seqcollection, float gheatfact, int (*play_loop)(int, int, void **), int nargs, void **args);



/**
 * @brief #### Returns the maximum number of slices that can be played out in one TR, honoring SAR and hardware constraints
 *
 * The maximum numbers of slices per TR is determined by calling ks_eval_mintr() with an increasing number of slices until the input TR value is reached
 *
 * @param[in]   TR            Repetition time in [us]
 * @param[in]   seqcollection A KS_SEQ_COLLECTION struct, which have undergone a reset of `seqctlptr[].nseqinstances` followed by a single run of
 *                            the sequence's slice loop or equivalent period
 * @param[in]   gheatfact     Experimental fudge factor in range [0.0, 1.0] to control how much to obey the gradient heating calculations using the old
 *                            gradient heating model. It is up to the EPIC programmer to set this to a proper value for now. This input argument can hopefully be
 *                            removed in the future
 * @param[in]   play_loop     Function pointer to the sliceloop (wrapper) function of the sequence. This function should perform all time consuming tasks for one TR. It is a requirement
 *                            that this function has three input arguments: `int nslices, int nargs, void **args`
 * @param[in]   nargs         Number of extra arguments to the slice loop wrapper function. This can be 0 if the slice loop is only temporally dependent on *nslices*
 * @param[in]   args          void * pointer array to extra arguments. This can be NULL if the slice loop is temporally dependent only on *nslices*
 * @retval      int           Maximum number of slices that can fit in one TR
 */
int ks_eval_maxslicespertr(int TR, KS_SEQ_COLLECTION *seqcollection, float gheatfact, int (*play_loop)(int /*nslices*/, int /*nargs*/, void ** /*args*/), int nargs, void **args);


/**
 * @brief #### Sets the minimum duration and duration fields of a KS_SEQ_CONTROL struct based on some minimum time (arg 2)
 *
 * It is recommended that this function is put at the end of the sequence generating function for the current sequence module (c.f. KS_SEQ_CONTROL), e.g. *mypsd*_pg(), which
 * is a point where one knows how long the pulse sequence is, as the last gradient or RF waveform has been placed out. After passing the known minimum allowed sequence module
 * duration as arg2 to ks_eval_seqctrl_setminduration(), *both* `seqctrl.duration` and `seqctrl.min_duration are set to this minimum value + the SSI time for the sequence module
 * (which must be > 0 before calling this function).
 *
 * This function is only available on HOST for the reason that the `.duration` field should not be reset to the minimum duration on TGT. The recommended order of events is the following:
 *
 * 1. In `cveval()` on HOST: Call *mypsd*_pg(). Having the ks_eval_seqctrl_setminduration() call at the end of *mypsd*_pg(), with the second argument (minimum duration) set to the absolute time corresponding to
 *    the last waveform, it is assured that both `seqctrl.duration` (which can grow bigger later) and `seqctrl.min_duration` (which should not be modified later) is equal to the
 *    same minimum possible value at this point.
 * \code{.c}
  #ifndef IPG // make it explicit that this function is to be called only on HOST (not IPG)
   // ...end of mypsd_pg()...
   // N.B.: .seqctrl.ssi_time must be > 0 before calling ks_eval_seqctrl_setminduration()
   ks_eval_seqctrl_setminduration(&ksfse.seqctrl, tmploc.pos); // tmploc.pos now corresponds to the end of last gradient in the sequence
  #endif
  \endcode
 * 2. In `cveval()` on HOST, after the *mypsd*_pg() call: Do some TR timing calculations and increase the `seqctrl.duration` field(s) for one or more sequence modules to fill up
 *    to the intended TR. The reasons for why `seqctrl.duration` needs to be larger than  `seqctrl.min_duration` could be either that the TR is larger than the minimum possible by
 *    the waveforms, and/or that SAR or hardware constraints (reported back by ks_eval_mintr()) mandates that additional time must be added to the sequence to honor these limits.
 * 3. In `pulsegen()` on TGT (IPG): The *mypsd*_pg() function is called to place out the actual hardware waveforms, followed by the "sequence ending here"-call to KS_SEQLENGTH(), which
 *    is using `seqctrl.duration` to determine the length of the sequence module. As efforts have been made on HOST to set `seqctrl.duration`, we cannot have ks_eval_seqctrl_setminduration()
 *    to reset it again on TGT when *mypsd*_pg() is called. Hence this is why ks_eval_seqctrl_setminduration() is only accessible on HOST
 *
 *
 * @param[in,out]  seqctrl Pointer to KS_SEQ_CONTROL struct for the current sequence module
 * @param[in]      mindur  mindur + `.ssi_time` => `.min_duration` = `.duration
 * @retval         STATUS  `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seqctrl_setminduration(KS_SEQ_CONTROL *seqctrl, int mindur);


/**
 * @brief #### Sets the `.duration` field of the sequence module (KS_SEQ_CONTROL), while checking that the input value is not less than `.min_duration`
 *
 * @param[in,out] seqctrl Pointer to KS_SEQ_CONTROL struct for the current sequence module
 * @param[in]     dur     Desired duration of the current sequence module (including its SSI time, `.ssi_time`)
 * @retval        STATUS  `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seqctrl_setduration(KS_SEQ_CONTROL *seqctrl, int dur);

/**
 * @brief #### Sets the `.duration` fields of all sequence modules being part of the sequence collection (KS_SEQ_COLLECTION) to their `.min_duration` value
 *
 * @param[in,out] seqcollection Pointer to KS_SEQ_COLLECTION struct holding pointers to all sequence modules
 * @retval        STATUS        `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seqcollection_durations_setminimum(KS_SEQ_COLLECTION *seqcollection) WARN_UNUSED_RESULT;

/**
 * @brief #### Assures the `.duration` fields of all sequence modules being part of the sequence collection (KS_SEQ_COLLECTION) are at least their `.min_duration` value
 *
 * @param[in,out] seqcollection Pointer to KS_SEQ_COLLECTION struct holding pointers to all sequence modules
 * @retval        STATUS        `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seqcollection_durations_atleastminimum(KS_SEQ_COLLECTION *seqcollection) WARN_UNUSED_RESULT;


/** @brief #### Set the `.nseqinstances` field of each sequence module (KS_SEQ_CONTROL) equal to 0
 *
 * This function is called in ks_eval_mintr() and GEReq_eval_TR() to reset the sequence module counters before calling the psd's scanloop function,
 * where the ks_scan_playsequence() functions internally increment `.nseqinstances` by one every time they are called
 *
 * @param[in,out] seqcollection Collection of all sequence modules (KS_SEQ_COLLECTION). C.f. ks_eval_addtoseqcollection()
 * @return void
*/
void ks_eval_seqcollection_resetninst(KS_SEQ_COLLECTION *seqcollection);

/** @brief #### Print out the duration of each sequence module in the sequence collection to a file pointer
 * Besides printing out the duration of each sequence module, it will also show the number of occurences
 * of each sequence module each TR. However, for this to be correct ks_eval_seqcollection_resetninst() should first be called
 * followed by one call to the sequence's sliceloop function to increment each .seqctrl.nseqinstances field.
 * See e.g. GEReq_eval_checkTR_SAR().
 * @param[in] seqcollection Collection of all sequence modules (KS_SEQ_COLLECTION). C.f. ks_eval_addtoseqcollection()
 * @param[in] fp File pointer to file to write to
 * @return    void
*/
void ks_print_seqcollection(KS_SEQ_COLLECTION *seqcollection, FILE *fp);

/** @brief #### Returns the total duration of the sequence collection
 *
 * Based on the `seqctrl.ninstances` and `seqctrl.duration` fields for each KS_SEQ_CONTROL (sequence module) that
 * have been added to the sequence collection struct (KS_SEQ_COLLECTION), this function returns the total duration
 * of the sequence collection. No time is added to comply with SAR or hardware limits, hence this time may not be
 * possible to use in practice. See ks_eval_mintr(), GEReq_eval_TR(), and ks_eval_gradrflimits() for more details.
 * @param[in] seqcollection Collection of all sequence modules (KS_SEQ_COLLECTION). C.f. ks_eval_addtoseqcollection()
 * @retval    int           Time in [us]
*/
int ks_eval_seqcollection_gettotalduration(KS_SEQ_COLLECTION *seqcollection);

/** @brief #### Returns the total duration of the sequence collection
 *
 * Based on the `seqctrl.ninstances` and `seqctrl.min_duration` fields for each KS_SEQ_CONTROL (sequence module) that
 * have been added to the sequence collection struct (KS_SEQ_COLLECTION), this function returns the total minimum
 * duration possible of the sequence collection, i.e. the time needed to play out the sequence waveforms without any
 * deadtime. See ks_eval_mintr(), GEReq_eval_TR(), and ks_eval_gradrflimits() for more details
 *
 * @param[in] seqcollection Collection of all sequence modules (KS_SEQ_COLLECTION). C.f. ks_eval_addtoseqcollection()
 * @retval    int           Time in [us]
*/
int ks_eval_seqcollection_gettotalminduration(KS_SEQ_COLLECTION *seqcollection);

/**
 * @brief #### (*Internal use*) Sets up GE's `rfpulse[]` array from the contents of a KS_SEQ_COLLECTION struct
 *
 * To use GE's `maxsar()` and `maxseqrfamp()` functions in ks_eval_gradrflimits() there needs to be an
 * `rfpulse[]` array containing info about the RF pulses. This info is for standard EPIC psds stored
 * on disk in a file grad_rf_<psdname>.h. KSFoundation EPIC psds with one or more sequence modules (KS_SEQ_CONTROL)
 * have all RF information stored in *seqcollection->seqctrlptr[i].gradrf.rfptr[]*. This function takes
 * all RF information from all sequence modules in the sequence collection and puts in the proper format
 * in `rfpulse[]`. Then `rfpulse[]` can be passed on to `maxsar()` and `maxseqrfamp()` (see ks_eval_gradrflimits())
 *
 * @param[out] rfpulse       Pointer to rfpulse[] array
 * @param[in]  seqcollection Pointer to the sequence collection struct for the sequence
 * @retval     STATUS        `SUCCESS` or `FAILURE`
 */
STATUS ks_eval_seqcollection2rfpulse(RF_PULSE *rfpulse, KS_SEQ_COLLECTION *seqcollection);

/**
 * @brief #### (*Internal use*) Creates a `GRAD_PULSE` struct from a KS_TRAP object
 *
 * To use GE's `minseq()` function that determines gradient heating limits from the gradient usage, a GRAD_PULSE array
 * needs to be generated for each gradient axis. This info is for standard EPIC psds stored
 * on disk in a file grad_rf_<psdname>.h. KSFoundation EPIC psds with one or more sequence modules (KS_SEQ_CONTROL)
 * being part of a KS_SEQ_COLLECTION struct, have all gradient trapezoid (KS_TRAP) information stored
 * in seqcollection->seqctrlptr[i].gradrf.trapptr[]. Hence, from the seqcollection struct it is possible to reach
 * all KS_TRAP for all sequence modules (see ks_eval_gradrflimits()), which one by one can be converted
 * to GRAD_PULSE structs using this function.
 *
 * @param[in] trp        Pointer to a KS_TRAP object
 * @param[in] gradchoice XGRAD, YGRAD, or ZGRAD, specifying which gradient this is used on
 * @retval    GRAD_PULSE A gradient pulse structure in GE's standard form
 */
GRAD_PULSE ks_eval_makegradpulse(KS_TRAP *trp, int gradchoice);







/*******************************************************************************************************
 *  Misc
 *******************************************************************************************************/


void ks_read_header_pool(int* exam_number, int* series_number, int* run_number);


/** @brief #### Gives the next higher 2^N for a given number

 *  @param[in] x Integer (usually related to resolution)
 *  @retval nextpow2 Unsigned integer with a value equal to the nearest larger power-of-2
*/
unsigned int ks_calc_nextpow2(unsigned int x);


/** @brief #### Rounds up a value in [us] to nearest whole [ms]

 *  @param[in] time Time in [us]
 *  @retval newtime Time in [us], rounded up to next whole [ms] unless already rounded
*/
int ks_calc_roundupms(int time);


/** @brief #### Sets up GE's FILTER_INFO struct based on dwell (sample point) time and duration of an acquisition window

    This function is used internally by ks_eval_read() as a part of the setup of a KS_READ sequence object, which contains the `.filt` (FILTER_INFO)
    field that is used with the corresponding acquisition window in the field `.echo` of the KS_READ object

    ks_calc_filter() will set the field `.filt.slot` to `KS_NOTSET` (= -1). A final (global) hardware slot number is set when either `setfilter()` or
    GEReq_predownload_setfilter() is called in `predownload()`. With the assigned slot number, ks_pg_read() in `pulsegen()` will connect this filter to the
    acquisition window by internally calling `setrfltrs()`

    #### Steps for a main sequence written entirely using KSFoundation
    - GE's function `initfilter()` is called in the *Requiredcvinit* section of GERequired.e. Make sure this section is \@inline'd in `cvinit()` in the main sequence
    - In predownload(): GEReq_predownload_setfilter() should be called instead of `setfilter()`, after \@inlining the *RequiredpredownloadBegin* section of GERequired.e.
      Pass the `.filt` field set up by this function to GEReq_predownload_setfilter()

 *  @param[out] echo_filter FILTER_INFO struct needed for data acquisition
 *  @param[in] tsp Duration in [us] for each data sample (dwell time) in the acquisition window. Minimum: 2 [us]
 *  @param[in] duration Duration in [us] of the entire data acquisition window
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_calc_filter(FILTER_INFO *echo_filter, int tsp, int duration) WARN_UNUSED_RESULT;


/** @brief #### Convert receiver bandwidth to dwell time

 *  @param[in] bw +/- bandwidth per FOV in [kHz]. Maximum: 250
 *  @retval tsp Duration in [us] for each data sample (dwell time) in the acquisition window
*/
int ks_calc_bw2tsp(float bw);

/** @brief #### Convert dwell time to receiver bandwidth

 *  @param[in] tsp Duration in [us] for each data sample in the acquisition window. Minimum: 2 [us]
 *  @retval bw +/- bandwidth per FOV in [kHz]
*/
float ks_calc_tsp2bw(int tsp);

/** @brief #### Calculates the time from start of gradient until area is reached

 *  @param[in] trap KS_TRAP* Trapezoid gradient
 *  @param[in] area Area to reach
 *  @retval time in [us]
*/
int ks_calc_trap_time2area(KS_TRAP* trap, float area);

/** @brief #### Round receiver bandwidth to nearest valid value

    As the dwell time is an integer and the reciprocal of receiver bandwidth, only certain values of receiver bandwidth
    are possible. This functions rounds a desired receiver bandwidth to the nearest valid value

 *  @param[in] bw +/- bandwidth per FOV in [kHz]. Maximum: 250
 *  @retval bw Rounded +/- bandwidth per FOV in [kHz]
*/
float ks_calc_nearestbw(float bw);


/** @brief #### Find the maximum reciever bandwidth based on a max gradient amplitude and FOV

    As the dwell time is an integer and the reciprocal of receiver bandwidth, only certain values of receiver bandwidth
    are possible. This functions rounds a desired receiver bandwidth to the nearest valid value

 *  @param[in] ampmax Max gradient amplitude allowed
 *  @param[in] fov FOV in the readout direction [mm]
 *  @retval bw Rounded +/- bandwidth per FOV in [kHz]
*/
float ks_calc_max_rbw(float ampmax, float fov);

/** @brief #### Calculates the minimum readout FOV

    Given a maximum allowed gradient amplitude in [G/cm] and a dwell time in [us] (see ks_calc_bw2tsp()), the minimum
    possible readout FOV in [mm] is calculated. This function is called internally by ks_eval_readtrap_constrained() when
    rampsampling is not used (`.rampsampling = 0`)

 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] tsp Duration in [us] for each data sample in the acquisition window. Minimum: 2 [us]
 *  @retval minFOV Minimum FOV in the readout direction
*/
float ks_calc_minfov(float ampmax, int tsp);


/** @brief #### Calculates the minimum slice thickness [mm]

    Given an RF bandwidth in [kHz], this function returns the minimum slice thickness possible
    given the gradient max amplitude.

 *  @param[in] bw RF bandwidth in [kHz]
 *  @retval minSliceThickness Minimum slice thickness in [mm]
*/
float ks_calc_minslthick(float bw);


/** @brief #### Calculates the minimum dwell time

    Given a maximum allowed gradient amplitude in [G/cm] and a readout FOV in [mm], the smallest dwell time (i.e. largest rBW) in [us] is calculated.

 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] fov FOV in the readout direction
 *  @retval tsp Duration in [us] for each data sample in the acquisition window
*/
int ks_calc_mintsp(float ampmax, float fov);

/** @brief #### Calculates maximum receiver bandwidth

    Given a maximum allowed gradient amplitude in [G/cm] and a readout FOV in [mm], the largest rBW time (i.e. smallest dwell time) in [us] is calculated.

 *  @param[in] ampmax The maximum allowed gradient amplitude ([G/cm])
 *  @param[in] fov FOV in the readout direction
 *  @retval rbw Receiver bandwidth in kHz.
*/
float ks_calc_max_rbw(float ampmax, float fov);


/** @brief #### Calculates the gradient area needed to move one pixel in k-space

    Given a readout FOV in [mm], the gradient area needed to move one pixel in a fully sampled k-space is calculated

 *  @param[in] fov FOV in the readout direction
 *  @retval area Gradient area in [(G/cm) * us]
*/
float ks_calc_fov2gradareapixel(float fov);


/** @brief #### Internal use for correct migration of KS_PHASEENCODING_PLAN from HOST to TGT (IPG)

 *  @param[in] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @return void
*/
void ks_phaseencoding_init_tgt(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr);


/** @brief #### Get [ky,kz] coordinate from KS_PHASEENCODING_PLAN for given echo and shot
 *
 *  If the .ky and .kz values returned by this function is = KS_NOTSET (-1), it indicates that
 *  this echo/shot combination should have zero phase encoding and should be ignored.
 *  For 2D, .kz will always be KS_NOTSET
 *
 *  @param[in] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @param[in] echo Echo index in the sequence ETL in range `[0,ETL-1]`
 *  @param[in] shot Shot index (i.e. how many times the sequence is played out per slice).
 *                  For 3D, this is the combined number of shots over ky and kz
 *  @retval `KS_PHASEENCODING_COORD`
*/
KS_PHASEENCODING_COORD ks_phaseencoding_get(const KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int echo, int shot);


/** @brief #### Set [ky,kz] coordinate from KS_PHASEENCODING_PLAN for given echo and shot
 *
 *  If the .ky and .kz values passed to this function is = KS_NOTSET (-1), it indicates that
 *  this echo/shot combination should have zero phase encoding and should be ignored. However, ignored
 *  echo/shot combinations are not necessary since the etl*num_shots entries in `.entries` of KS_PHASEENCODING_PLAN
 *  are always initialized to KS_NOTSET by ks_phaseencoding_resize(). Hence, it is only necessary to explicitly
 *  set the echo/shot combination for ky/kz coordinates being acquired.
 *
 *  For 2D, kz (5th arg) should always be KS_NOTSET.
 *
 *  @param[in] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @param[in] echo Echo index in the sequence ETL in range `[0,ETL-1]`
 *  @param[in] shot Shot index (in range [0,how many times the sequence is played out per slice - 1]).
 *                  For 3D, this is the combined number of shots over ky and kz
 *  @param[in] ky K-space coordinate along the first (only for 2D) phase encoding direction (integer) in range `[0, phaser.numlinestoacq-1]`
 *  @param[in] kz K-space coordinate along the second (use KS_NOTSET for 2D) phase encoding direction (integer) in range `[0, zphaser.numlinestoacq-1]`
 *  @return void
*/
void ks_phaseencoding_set(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int echo, int shot, int ky, int kz);


/** @brief #### Print out KS_PHASEENCODING_PLAN to a text file
 *
 * In SIM (WTools), a file ks_phaseencodingtable.txt will be generated in the current directory
 * On HW (MR scanner), the same file will be located in /usr/g/mrraw
 *
 *  @param[in] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @return void
*/
void ks_phaseencoding_print(const KS_PHASEENCODING_PLAN *phaseenc_plan_ptr);


/** @brief #### Reallocate memory for KS_PHASEENCODING_PLAN entries
 *
 *  For every (and custom) ks_phaseencoding_generate_** functions, this function must be called before ks_phaseencoding_set()
 *  so that there is memory allocataed for the array of KS_PHASEENCODING_COORD
 *
 *  @param[in] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @param[in] etl The number of acquisition window in the pulse sequence, or echo train length (ETL)
 *  @param[in] num_shots Number of shots (i.e. how many times the sequence is played out per slice). For 3D, shot is over both ky and kz
 *  @return void
*/
STATUS ks_phaseencoding_resize(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int etl, int num_shots);


/** @brief #### Generation of a KS_PHASEENCODING_PLAN for any sequence having only one echo (or same phasenc step for all echoes)
 * 
 *  For sequences having only one echo (ETL=1) or having more echoes but where all echoes have the same ky/kz coordinate,
 *  there is no special logic necessary regarding which order to traverse the ky-kz plane over shots.
 *
 *  Parallel imaging in ky (and kz for 3D), with acs lines, is set up as usual using ks_eval_phaser() first before calling this function.
 *  For 2D, the phase encoding object (KS_PHASER) is then passed in as the 2nd arg to this function, with the 3rd arg being `NULL`.
 *  For 3D, both KS_PHASERs are passed in as 2nd and 3rd args, each with their own acceleration and resolution.
 *  For both 2D and 3D, the KS_PHASEENCODING_PLAN will be set up based on the KS_PHASER(s), but for 2D all entries.kz in the
 *  KS_PHASEENCODING_PLAN will be KS_NOTSET (-1)
 *
 *  @param[out] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @param[in] desc A description (text string) of the KS_PHASEENCODING_PLAN object. This description is used in the psd plot.
 *  @param[in] phaser Pointer to the KS_PHASER object for the first (3D) / only (2D) phase encoding direction
 *  @param[in] zphaser Pointer to the KS_PHASER object for the second phase encoding direction (NULL for 2D)
 *  @return void
*/
STATUS ks_phaseencoding_generate_simple(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser);


/** @brief #### Generation of a KS_PHASEENCODING_PLAN for any sequence having only one echo (or same phasenc step for all echoes) - ellipse version
 *
 *  For sequences having only one echo (ETL=1) or having more echoes but where all echoes have the same ky/kz coordinate,
 *  there is no special logic necessary regarding which order to traverse the ky-kz plane over shots.
 *
 *  Parallel imaging in ky (and kz for 3D), with acs lines, is set up as usual using ks_eval_phaser() first before calling this function.
 *  For 2D, the phase encoding object (KS_PHASER) is then passed in as the 2nd arg to this function, with the 3rd arg being `NULL`.
 *  For 3D, both KS_PHASERs are passed in as 2nd and 3rd args, each with their own acceleration and resolution.
 *  For both 2D and 3D, the KS_PHASEENCODING_PLAN will be set up based on the KS_PHASER(s), but for 2D all entries.kz in the
 *  KS_PHASEENCODING_PLAN will be KS_NOTSET (-1). This function will create an elliptical k-space in ky/kz. For rectangular k-space, 
 *  use `ks_phaseencoding_generate_simple`.
 *
 *  @param[out] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 *  @param[in] desc A description (text string) of the KS_PHASEENCODING_PLAN object. This description is used in the psd plot.
 *  @param[in] phaser Pointer to the KS_PHASER object for the first (3D) / only (2D) phase encoding direction
 *  @param[in] zphaser Pointer to the KS_PHASER object for the second phase encoding direction (NULL for 2D)
 *  @return void
*/
STATUS ks_phaseencoding_generate_simple_ellipse(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser);



/**
 *******************************************************************************************************
 @brief #### Calculates the ETL index corresponding the desired TE given a KS_PHASER object and echo spacing

 Given the KS_PHASER object used in the FSE train (containing res and partial ky Fourier info),
 the desired effective echo time (`TE` [us]), the echo train length (`etl`) and the echo spacing between
 consecutive echoes (`esp` [us]), this function calculates two echo indices:

 - `bestecho`: is the 0-based index corresponding to the echo in the FSE train that should be placed
   in the center of k-space, i.e. the echo that most closely matches the desired TE. If `bestecho` is
   an integer value (although it is in double format), the data acquired for this echo should *straddle*
   the k-space center. `bestecho` can also be an interger + 0.5, indicating that there are two echo
   indices that should be placed around the k-space center. For example, floor(bestecho) corresponds
   to the echo index that should be placed just below the k-space center and ceil(bestecho) corresponds
   to the echo index that should be placed just above the k-space center. I.e. when `bestecho = *.5`,
   no single echo index will straddle the k-space center, and the k-space line located at ky position
   +0.5 will come from data acquired from echo #[floor(bestecho)] and ky position -0.5 correspondingly
   from echo #[ceil(bestecho)].
 - `optecho`: is the 0-based index corresponding to an ideal TE choice that would allow the data from the
   echoes in the FSE train to be placed out linearly each time. Doing so will reduce ghosting and T2
   blurring. Hence, `optecho` ignores the input TE value here, but the calling function can use this
   information to determine k-space acquisition order, but also to suggest a TE (optecho * esp) that
   would result in optimal image quality for the chosen ETL.

 @param[out] bestecho Pointer to the echo number in the train that should be placed at the center of
                      k-space given the current ETL and ESP
 @param[out] optecho Pointer to the optimal echo number in the train that would allow k-space to be
                     sampled linearly (to reduce T2-blurring and ghosting)
 @param[in] pe Pointer to a KS_PHASER
 @param[in] TE (Echo Time in [us])
 @param[in] etl (EchoTrain Length)
 @param[in] esp (Echo Spacing in [us])
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ks_fse_calcecho(double *bestecho, double *optecho, KS_PHASER *pe, int TE, int etl, int esp);




/**
 *******************************************************************************************************
 @brief #### 2DFSE: Makes a KS_PHASEENCODING_PLAN depending on etl, desired TE, and echo spacing (esp)

 This function is only executed on TGT and will return early when called on HOST.

 The phase encoding sorting is depending on many factors. First, the desired TE will dictate which one
 (or two) of the echoes in the FSE train (of length `etl`) that should be placed in the center. This
 is determined based on the properties of the KS_PHASER object (phase encoding gradients in the FSE train),
 `TE` and `esp` by calling ksfse_calc_echo().

 Second, the sorting of the echoes will first of all depend on whether `bestecho` is equal to `optecho`.
 If it is, then the `etl` echoes can be placed out linearly in k-space (from the bottom->top of k-space,
 or vice versa). This will produce the best image quality with minimal T2-blurring and FSE ghosting.

 As partial ky Fourier is allowed, this function first checks on which side (top or bottom half) of k-space
 that has more room for the echo indices that are either before or after the `bestecho` index corresponding
 to the desired `TE`. The goal with this is to try to sweep k-space as linearly as possible in as much
 of the center portion of k-space as possible when `bestecho != optecho`.

 When `bestecho != optecho`, there will be data from either the first or last echo indices that won't fit
 in k-space if placed next to a neighboring index. If this data would be placed on the other size of
 k-space (that still needs lines to be filled in), where e.g. echo index #0 would be placed next to echo
 index #(etl-1), strong ghosting will occur due to the much strong signal from echo #0 compared to #(etl-1).
 With an echo train length of `etl`, k-space is filled in `numshots = ceil(numlinestoacq / etl`. Using
 half of the numshots lines for each echo index a linear sweep of the center half of k-space can is layed
 out. To avoid FSE ghosting, the numshots/2 remaining lines for each early or late echo index are placed
 such as neighboring ky lines will never have a change in echo index by more than one. For example if
 `etl = 8`, `esp = 10 ms` and `TE = 25`, then `bestecho = 1.5` and `optecho = 4.5`. We avoid to sort the
 echoes in the following k-space order for ghosting reasons:
 7-6-0-1*2-3-4-5 (* = k-space center)
 since there will be a strong discontinuity between 6 and 0.
 Instead we use groups of numshots/2 per echo index (and get two groups per echo index in k-space):
 5-4-3-2-1-0-0-1*2-3-4-5-6-7-6-5

 @param[out] phaseenc_plan_ptr Pointer to KS_PHASEENCODING_PLAN
 @param[in] desc A description (text string) of the KS_PHASEENCODING_PLAN object. This description is used in the psd plot.
 @param[in] phaser Pointer to a KS_PHASER
 @param[in] zphaser Pointer to a KS_PHASER (3D) or NULL (2D)
 @param[in] TE (Echo Time in [us])
 @param[in] etl (EchoTrain Length)
 @param[in] esp (Echo Spacing in [us])
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ks_phaseencoding_generate_2Dfse(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser, int TE, int etl, int esp);




/**
 *******************************************************************************************************
 @brief #### EPI: Makes a KS_PHASEENCODING_PLAN suitable for 2D or 3D epi

 The etl is the number of readouts in the EPI train, derived from the phaser. The number of ky shots is
 also given by the phaser, while the number of kz shots is given by zphaser. Any partial fourier is
 handled by the phasers, and acceleration and acs lines in the z direction is handled by zphaser. For 3D
 EPI, the number of shots in the phase encoding plan will be the product of the number of shots in the
 ky direction and the number of kz lines to acquire.

 Each shot will be played out in a single kz plane. The shot order will be linear in ky and kz. The ky
 shots will be in the inner loop, unless kzshotsfirst is TRUE.

 @param[out] phaseenc_plan_ptr Pointer to the phase encoding plan
 @param[in] desc A description (text string) of the KS_PHASEENCODING_PLAN object. This description is used in the psd plot.
 @param[in] epitrain Pointer to a KS_EPI
 @param[in] blipsign Should be either `KS_EPI_POSBLIPS` or `KS_EPI_NEGBLIPS`
 @param[in] numkyshots Number of ky shots to play. Must be within 1-R and evenly divisble with R. Set =1
                       for single-shot EPI. Set to phaser.R for full multi-shot EPI.
 @param[in] numsegments Number of kz encodes to play              
 @param[in] caipi Use CAIPIRINHA sampling pattern (affects 3D epi only)
 @retval STATUS `SUCCESS` or `FAILURE`
********************************************************************************************************/
STATUS ks_phaseencoding_generate_epi(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_EPI *epitrain, int blipsign, int numkyshots, int numsegments, int caipi);




/**
 * @brief #### Calculates the data acquisition order for a standard interleaved 2D scans using one or more passes

    This function calls ks_calc_slice_acquisition_order_interleaved() with the last argument being 2,
    indicating an interleave factor of 2. This will make odd slices in each pass to be acquired first, followed
    by the even slices.

 * @param[out] slice_plan The slice plan (KS_SLICE_PLAN) set up earlier using ks_calc_sliceplan() or similar
 * @param[in]  nslices    Total number of slices (usually opslquant)
 * @param[in]  slperpass  Number of slices per pass (i.e. per TR)
 * @retval     STATUS     `SUCCESS` or `FAILURE`
 */
STATUS ks_calc_sliceplan(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass);

/**
 * @brief #### Calculates the data acquisition order for custom interleaved 2D scans using one or more passes
 *
 *  The last argument to this function indicates the interleave factor of slices *within* each pass.
 *  If this value is
 *  - 1: The slices will be acquired in spatial order (*within* each pass)
 *  - 2: The odd slices will be acquired first, followed by the even slices in each pass (standard practice)
 *  - 3: etc.
 *
 * @param[out] slice_plan         Pointer to the slice plan (KS_SLICE_PLAN) set up earlier using ks_calc_sliceplan() or similar
 * @param[in]  nslices            Total number of slices (usually opslquant)
 * @param[in]  slperpass          Number of slices per pass (i.e. per TR)
 * @param[in]  inpass_interleaves Interleave factor of slices in a pass
 * @retval     STATUS             `SUCCESS` or `FAILURE`
*/
STATUS ks_calc_sliceplan_interleaved(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass, int inpass_interleaves);



/**
 * @brief #### Calculates the data acquisition order for simulaneous-multi-slice (SMS)2D scans
 * @param[out] slice_plan        The slice plan (KS_SLICE_PLAN) set up earlier using ks_calc_sliceplan() or similar
 * @param[in]  nslices           Total number of slices (usually opslquant)
 * @param[in]  slperpass         Number of slices per pass (i.e. per TR)
 * @param[in]  multiband_factor  Number of SMS slices
 * @retval     STATUS            `SUCCESS` or `FAILURE`
 */
STATUS ks_calc_sliceplan_sms(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass, int multiband_factor);



/** @brief #### Calculates the data acquisition order for single acquisition SMS

 *  @param[out] dacq    Data acquisition order array (local)
 *  @param[in]  nslices Total number of slices prescribed
 *  @retval     int     Resulting number of passes (or acqs) (in this case 1)
*/
int ks_calc_slice_acquisition_order_smssingleacq(DATA_ACQ_ORDER *dacq, int nslices);

/** @brief #### Calculates the minimum time gap between adjacent slices in a SMS acquisition

 *  @param[out] dacq    Data acquisition order array (local)
 *  @param[in]  nslices Total number of slices prescribed
 *  @retval     int     The minimum time gap between adjacent slices
*/
int ks_calc_sms_min_gap(DATA_ACQ_ORDER *dacq, int nslices);

/*******************************************************************************************************
 *  Print
 *******************************************************************************************************/

/**
 * @brief #### Writes a KS_SLICE_PLAN to a file pointer
 * @param slice_plan KS_SLICE_PLAN for the sequence
 * @param fp         A file pointer (or `stderr`)
 * @return void
 */
void ks_print_sliceplan(const KS_SLICE_PLAN slice_plan, FILE *fp);

/** @brief #### Writes a KS_WAVEFORM to disk with the specified filename

 *  @param[in] waveform A KS_WAVEFORM (i.e. float array) to be written
 *  @param[in] filename String with the output file name
 *  @param[in] res Number of elements in the waveform to be written
 *  @return void
 */
void ks_print_waveform(const KS_WAVEFORM waveform, char *filename, int res);

/** @brief #### Writes out the contents of a KS_READ sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] read A KS_READ object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_read(KS_READ read, FILE *fp);

/** @brief #### Writes out the contents of a KS_TRAP sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] trap A KS_TRAP object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_trap(KS_TRAP trap, FILE *fp);

/** @brief #### Writes out the contents of a KS_READTRAP sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] readtrap A KS_READTRAP object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_readtrap(KS_READTRAP readtrap, FILE *fp);

/** @brief #### Writes out the contents of a KS_PHASER sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] phaser A KS_PHASER object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_phaser(KS_PHASER phaser, FILE *fp);

/** @brief #### Writes out the contents of a KS_EPI sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] epi A KS_EPI object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_epi(KS_EPI epi, FILE *fp);

/** @brief #### Writes out the contents of a KS_RF sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] rf A KS_RF object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_rf(KS_RF rf, FILE *fp);

/** @brief #### Writes out the contents of an RF_PULSE struct for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] rfpulse An RF_PULSE struct (`<rf>.rfpulse`) to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_rfpulse(RF_PULSE rfpulse, FILE *fp);

/** @brief #### Writes out the contents of a KS_SELRF sequence object for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] selrf A KS_SELRF object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_selrf(KS_SELRF selrf, FILE *fp);

/** @brief #### Writes out the contents of KS_GRADRFCTRL for debugging

    If 2nd argument is `stderr` or `stdout`, the printed result will be seen in WTools for simulation.
    On the MR system, `stderr` will show up in one of the mgd_term windows.
    A file pointer (opened with e.g. fp = fopen("/usr/g/mrraw/myname.txt","w")) saves a text file to disk

 *  @param[in] gradrfctrl A KS_GRADRFCTRL object to be printed
 *  @param[in] fp A file pointer (or `stderr`)
 *  @return void
 */
void ks_print_gradrfctrl(KS_GRADRFCTRL gradrfctrl, FILE *fp);



/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSFoundation.h: Function Prototypes available on HOST and TGT (KSFoundation_common.c)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/** @brief #### Common error message function for HOST and TGT

    - On the MR-scanner, this function will append error messages with a timestamp to the file `/usr/g/mrraw/ksf_errors.txt`
    in addition to sending an `epic_error()`, which will show the error at the bottom of the UI
    - In simluation, the error message will be seen both in Evaltool and in the main WTools window

 *  @param[in] format Standard C printf input arguments
 *  @retval STATUS Returns FAILURE
*/
STATUS ks_error(const char *format, ...)
/* GCC's attribute specifying that ks_error has the same signature of printf */
__attribute__ ((format (printf, 1, 2)));


/** @brief #### Common debug message function for HOST and TGT

    - On the MR-scanner, this function will append error messages with a timestamp to the file `/usr/g/mrraw/ksf_debug.txt`

 *  @param[in] format Standard C printf input arguments
 *  @retval STATUS Returns SUCCESS
*/
STATUS ks_dbg(const char *format, ...)
/* GCC's attribute specifying that ks_dbg has the same signature of printf */
__attribute__ ((format (printf, 1, 2)));


/** @brief #### Check for ICE Hardware (e.g. RX27+ on SIGNA Premier)
 *  @retval int 1: ICE 0: MGD
*/
int ks_syslimits_hasICEhardware();



/** @brief #### Clear debug file content
*/
void ks_dbg_reset();


/** @brief #### Returns the maximum gradient amplitude that can be used on all gradient boards simultaneously

    Since the waveform design (using `ks_eval_***()` functions) is separated from the placement of waveforms (using `ks_pg_***()` functions),
    the maximum gradient limit to use for gradient design must account for the least capable gradient board given the current
    slice angulation. ks_syslimits_ampmax() assumes that all gradients may be on simultaneously

    The return value from this function can be passed in as `ampmax` to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval gradmax Maximum gradient amplitude ([G/cm]) that can be used on all boards simultaneously
*/
float ks_syslimits_ampmax(LOG_GRAD loggrd);

/** @brief #### Returns the maximum gradient amplitude that can be used on two gradient boards simultaneously

    Since the waveform design (using `ks_eval_***()` functions) is separated from the placement of waveforms (using `ks_pg_***()` functions),
    the maximum gradient limit to use for gradient design must account for the least capable gradient board given the current
    slice angulation. ks_syslimits_ampmax2() assumes that gradients are played out on at most one more board at the same time as the current trapezoid

    The return value from this function can be passed in as `ampmax` to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval gradmax Maximum gradient amplitude ([G/cm]) that can be used on 2 boards simultaneously
*/
float ks_syslimits_ampmax2(LOG_GRAD loggrd);

/** @brief #### Returns the maximum gradient amplitude that can be used on all gradient boards simultaneously

    Since the waveform design (using `ks_eval_***()` functions) is separated from the placement of waveforms (using `ks_pg_***()` functions),
    the maximum gradient limit to use for gradient design must account for the least capable gradient board given the current
    slice angulation. ks_syslimits_ampmax1() assumes that no other gradient is played out on another board at the same time as the current trapezoid

    The return value from this function can be passed in as `ampmax` to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval gradmax Maximum gradient amplitude ([G/cm]) that can be used on 2 boards simultaneously
*/
float ks_syslimits_ampmax1(LOG_GRAD loggrd);

/** @brief #### Returns the minimum ramp time to get from zero to full gradient scale

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval ramptime Ramptime in [us] to get from zero to full gradient scale
*/
int ks_syslimits_ramptimemax(LOG_GRAD loggrd);

/** @brief #### Returns the maximum slewrate that can be used on all gradient boards simultaneously

   The return value from this function is the ratio of ks_syslimits_ampmax() and ks_syslimits_ramptimemax() and can be passed in as `slewrate`
   to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval slewrate Maximum slewrate ([(G/cm) / us]) that can be used on all boards simultaneously
*/
float ks_syslimits_slewrate(LOG_GRAD loggrd);

/** @brief #### Returns the maximum slewrate that can be used on two gradient boards simultaneously

   The return value from this function is the ratio of ks_syslimits_ampmax2() and ks_syslimits_ramptimemax() and can be passed in as `slewrate`
   to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval slewrate Maximum slewrate ([(G/cm) / us]) that can be used on all boards simultaneously
*/
float ks_syslimits_slewrate2(LOG_GRAD loggrd);

/** @brief #### Returns the maximum slewrate that can be used on one gradient board at a time

   The return value from this function is the ratio of ks_syslimits_ampmax1() and ks_syslimits_ramptimemax() and can be passed in as `slewrate`
   to all `ks_eval***_constrained()` functions

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @retval slewrate Maximum slewrate ([(G/cm) / us]) that can be used on all boards simultaneously
*/
float ks_syslimits_slewrate1(LOG_GRAD loggrd);

/** @brief #### Returns the maximum target amplitude for a board (*internal use*)

    For gradient boards, the field `.tx`, `.ty` or `.tz` is returned. For non-gradient boards, 1.0 is returned.
    This function is used internally by `ks_pg_***()` functions and there should be no need to call it directly.

 *  @param[in] loggrd GE's LOG_GRAD struct, dependent on the gradient system and current slice angulation
 *  @param[in] board The board on which the current trapezoid or waveform is to be played out on
 *  @retval gradamp Maximum target amplitude for a board
*/
float ks_syslimits_gradtarget(LOG_GRAD loggrd, WF_PROCESSOR board);

/** @brief #### Returns the integer phase (*not in use*)

    All phase values in KSFoundation are in [degrees], including flip angles, RF/receive phases and THETA waveforms.
    This function is therefore currently not used. See instead ks_phase_degrees2hw()

 *  @param[in] radphase Phase in radians
 *  @retval intphase Integer phase to use on THETA board on hardware
*/
short ks_phase_radians2hw(float radphase);

/** @brief #### Returns the integer phase (*internal use*)

    All phase values in KSFoundation are in [degrees], including flip angles, RF/receive phases and THETA waveforms.
    This function is used internally by another internal function ks_wave2iwave(), which is in turn called by ks_pg_wave()

 *  @param[in] degphase Phase in degrees
 *  @retval intphase Integer phase to use on THETA board on hardware
*/
short ks_phase_degrees2hw(float degphase);

/** @brief #### Returns the gradient amplitude in [G/cm] necessary for slice selection (*internal use*)

    Given an RF bandwidth in [Hz] and a slice thickness in [mm], this function calculates the
    gradient strength in [G/cm] necessary to produce a slice with the given slice thickness

    This function is used by ks_eval_seltrap(), ks_eval_selrf_constrained() and ks_scan_selrf_setfreqphase()

 *  @param[in] rfbw The bandwidth of the RF pulse to use with the gradient
 *  @param[in] slthick The desired slice thickness in [mm]
 *  @retval gradamp Gradient amplitude to use [G/cm]
*/
float ks_calc_selgradamp(float rfbw, float slthick);

/** @brief #### Returns the number of samples in a KS_WAVE sequence object

 *  @param[in] wave KS_WAVE object
 *  @retval res Resolution (i.e. number of samples) in the KS_WAVE object
*/
int ks_wave_res(const KS_WAVE *wave);

/** @brief #### Returns the maximum value in a KS_WAVEFORM

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @retval maxval Maximum value
*/
float ks_waveform_max(const KS_WAVEFORM waveform, int res);

/** @brief #### Returns the maximum value in a KS_WAVE sequence object

 *  @param[in] wave KS_WAVE object
 *  @retval maxval Maximum value
*/
float ks_wave_max(const KS_WAVE *wave);

/** @brief #### Returns the minimum value in a KS_WAVEFORM

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @retval minval Minimum value
*/
float ks_waveform_min(const KS_WAVEFORM waveform, int res);

/** @brief #### Returns the minimum value in a KS_WAVE sequence object

 *  @param[in] wave KS_WAVE object
 *  @retval minval Minimum value
*/
float ks_wave_min(const KS_WAVE *wave);

/** @brief #### Returns the maximum absolute value in a KS_WAVEFORM

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @retval absmaxval Maximum absolute value
*/
float ks_waveform_absmax(const KS_WAVEFORM waveform, int res);

/** @brief #### Returns the maximum absolute value in a KS_IWAVE

 *  @param[in] waveform KS_IWAVE (short int array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_IWAVE
 *  @retval absmaxval Maximum absolute value
*/
short ks_iwave_absmax(const KS_IWAVE waveform, int res);

/** @brief #### Returns the maximum absolute value in a KS_WAVE sequence object

 *  @param[in] wave KS_WAVE object
 *  @retval absmaxval Maximum absolute value
*/
float ks_wave_absmax(const KS_WAVE *wave);

/** @brief #### Returns the area of a KS_WAVEFORM over a specified interval given in [us]

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] start [us] Start position of area calculation in [us] (0 = start of waveform)
 *  @param[in] end [us] End position of area calculation in [us] (res * dwelltime = end of waveform)
 *  @param[in] dwelltime [us] of each waveform point (duration/res)
 *  @retval area The area of the KS_WAVEFORM over the specified interval in [(G/cm) * us]
*/
float ks_waveform_area(const KS_WAVEFORM waveform, int start /* [us] */, int end /* [us] */, int dwelltime /* [us] */);

/** @brief #### Returns the area of a KS_WAVE object over a specified interval given in [us]

 *  @param[in] wave KS_WAVE object
 *  @param[in] start [us] Start position of area calculation in [us] (0 = start of waveform)
 *  @param[in] end [us] End position of area calculation in [us] (`.duration` = end of waveform)
 *  @retval area The area of the KS_WAVE object over the specified interval in [(G/cm) * us]
*/
float ks_wave_area(const KS_WAVE *wave, int start /* [us] */, int end /* [us] */);

/** @brief #### Returns the sum of a KS_WAVEFORM

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @retval sum The sum of the KS_WAVEFORM
*/
float ks_waveform_sum(const KS_WAVEFORM waveform, int res);

/** @brief #### Returns the sum of a KS_WAVE sequence object

 *  @param[in] wave KS_WAVE object
 *  @retval sum The sum of the KS_WAVEFORM
*/
float ks_wave_sum(const KS_WAVE *wave);

/** @brief #### Returns the 2-norm of a KS_WAVEFORM

 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res  Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @retval norm2 The 2-norm of a KS_WAVEFORM
*/
float ks_waveform_norm(const KS_WAVEFORM waveform, int res);

/** @brief #### Returns the 2-norm of a KS_WAVE

 *  @param[in] wave KS_WAVE object
 *  @retval norm2 The 2-norm of a KS_WAVE
*/
float ks_wave_norm(const KS_WAVE *wave);

/** @brief #### Calculates a KS_WAVEFORM with the cumulative sum (i.e. integral) of a KS_WAVEFORM

 *  @param[out] cumsumwaveform KS_WAVEFORM (float array)
 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
*/
void ks_waveform_cumsum(KS_WAVEFORM cumsumwaveform, const KS_WAVEFORM waveform, int res);

/** @brief #### Calculates a KS_WAVE with the cumulative sum (i.e. integral) of a KS_WAVE

 *  @param[out] cumsumwave KS_WAVE object
 *  @param[in] wave KS_WAVE
*/
void ks_wave_cumsum(KS_WAVE *cumsumwave, const KS_WAVE *wave);

/** @brief #### In-place multiplication of one KS_WAVEFORM with another KS_WAVEFORM

    Multiplication of waveform `a` (arg 1) with waveform `b` (arg 2) as:
    `a *= b`

 *  @param[in,out] waveform_mod KS_WAVE object
 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
*/
void ks_waveform_multiply(KS_WAVEFORM waveform_mod, const KS_WAVEFORM waveform, int res);

/** @brief #### In-place multiplication of one KS_WAVE with another KS_WAVE

    Multiplication of waveform `a` (arg 1) with waveform `b` (arg 2) as:
    `a *= b`

    If the duration of the two KS_WAVE objects have different resolution, the shorter KS_WAVE will be multiplied
    with the first part of the longer KS_WAVE

 *  @param[in,out] wave_mod KS_WAVE object
 *  @param[in] wave KS_WAVE object
*/
void ks_wave_multiply(KS_WAVE *wave_mod, const KS_WAVE *wave);

/** @brief #### In-place addition of one KS_WAVEFORM with another KS_WAVEFORM

    Addition of waveform `a` (arg 1) with waveform `b` (arg 2) as:
    `a += b`

 *  @param[in,out] waveform_mod KS_WAVEFORM (float array)
 *  @param[in] waveform KS_WAVEFORM (float array)
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
*/
void ks_waveform_add(KS_WAVEFORM waveform_mod, const KS_WAVEFORM waveform, int res);

/** @brief #### In-place addition of one KS_WAVE with another KS_WAVE

    Addition of waveform `a` (arg 1) with waveform `b` (arg 2) as:
    `a *= b`

    If the duration of the two KS_WAVE objects have different resolution, the shorter KS_WAVE will be added to
    the first part of the longer KS_WAVE

 *  @param[in,out] wave_mod KS_WAVE object
 *  @param[in] wave KS_WAVE object
*/
void ks_wave_add(KS_WAVE *wave_mod, const KS_WAVE *wave);

/** @brief #### In-place scalar multiplication of a KS_WAVEFORM

    The values in a KS_WAVEFORM are multiplied with a scalar value `val`

 *  @param[in,out] waveform KS_WAVEFORM (float array)
 *  @param[in] val Floating point value to multiply with
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
*/
void ks_waveform_multiplyval(KS_WAVEFORM waveform, float val, int res);

/** @brief #### In-place scalar multiplication of a KS_WAVE

    The waveform values in a KS_WAVE sequence object (`.waveform[]`) are multiplied with a scalar value `val`

 *  @param[in,out] wave KS_WAVE object
 *  @param[in] val Floating point value to multiply with
*/
void ks_wave_multiplyval(KS_WAVE *wave, float val);

/** @brief #### In-place scalar addition of a KS_WAVEFORM

    The values in a KS_WAVEFORM are added with a scalar value `val`

 *  @param[in,out] waveform KS_WAVEFORM (float array)
 *  @param[in] val Floating point value to add
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
*/
void ks_waveform_addval(KS_WAVEFORM waveform, float val, int res);

/** @brief #### In-place scalar addition of a KS_WAVE

    The waveform values in a KS_WAVE sequence object (`.waveform[]`) are added with a scalar value `val`

 *  @param[in,out] wave KS_WAVE object
 *  @param[in] val Floating point value to add
*/
void ks_wave_addval(KS_WAVE *wave, float val);

/** @brief #### (*Internal use*) Conversion of a KS_WAVEFORM to a short int array for use on hardware

    This function is used internally by ks_pg_wave() and there should be no need to call this function directly.

    For all boards except THETA, this function auto-scales the (float) values in KS_WAVEFORM so that the maximum absolute value
    becomes +/- 32766. The output short int (KS_IWAVE) array is to be copied to hardware. For a KS_WAVEFORM on the THETA board,
    the necessary phase wraps and scaling to short int format is performed using ks_phase_degrees2hw().
    GE's requirement of only having even numbers in the waveform except for a final odd value (end-of-waveform) is also taken care of here

    Note that the preservation of the physical units are done in ks_pg_wave() by setting the correct instruction amplitude to multiply this auto-scaled
    waveform with in the sequence's hardware memory

 *  @param[out] iwave KS_IWAVE (short int array)
 *  @param[in] waveform KS_WAVEFORM
 *  @param[in] res Resolution (i.e. number of samples) in the KS_WAVEFORM
 *  @param[in] board One of XGRAD, YGRAD, ZGRAD, RHO, THETA, OMEGA
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_waveform2iwave(KS_IWAVE iwave, const KS_WAVEFORM waveform, int res, int board) WARN_UNUSED_RESULT;

/** @brief #### (*Internal use*) Conversion of waveform content in a KS_WAVE sequence object to a short int array for use on hardware

    This function is used internally by ks_pg_wave() and there should be no need to call this function directly.

    For all boards except THETA, this function auto-scales the (float) values in the `.waveform[]` field so that the maximum absolute value
    becomes +/- 32766. The output short int (KS_IWAVE) array is to be copied to hardware. For a KS_WAVE on the THETA board,
    the necessary phase wraps and scaling to short int format is performed using ks_phase_degrees2hw().
    GE's requirement of only having even numbers in the waveform except for a final odd value (end-of-waveform) is also taken care of here

    Note that the preservation of the physical units are done in ks_pg_wave() by setting the correct instruction amplitude to multiply this auto-scaled
    waveform with in the sequence's hardware memory

 *  @param[out] iwave KS_IWAVE (short int array)
 *  @param[in] wave KS_WAVE
 *  @param[in] board One of XGRAD, YGRAD, ZGRAD, RHO, THETA, OMEGA
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_wave2iwave(KS_IWAVE iwave, const KS_WAVE *wave, int board) WARN_UNUSED_RESULT;


/** @brief #### Returns the pointer to XTR or RBA for an echo WF_PULSE (*internal use*)

    This function is used internally by ks_pg_read() to get pointers to the XTR and RBA SSP packets for an acquisition window

 *  @param[in] echo Pointer to an echo (WF_PULSE)
 *  @param[in] suffix String being "xtr", "rba", or empty
 *  @retval wfptr Pointer to a WF_PULSE
*/
WF_PULSE * ks_pg_echossp(WF_PULSE *echo, char *suffix);


/** @brief #### Places a KS_TRAP sequence object on a board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_TRAP sequence object that creates a static trapezoid in the pulse sequence.
    The same KS_TRAP object can be freely placed on XGRAD, YGRAD and ZGRAD
    as many times as desired, by only changing the second argument each time (to avoid waveform overlaps). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD (or OMEGA)
    - `.pos`: Absolute time in [us] of the start of the attack ramp of the trapezoid
    - `.ampscale`: A factor that must be in range [-1.0,1.0] that is multiplied with `.amp` to yield a per-instance (i.e. per-placement) amplitude ([G/cm]).
    The simplest is to use 1.0, which makes the KS_TRAP object to be placed out on the board as initially designed using ks_eval_trap(). For the OMEGA board, this factor
    must be 1.0.

    Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_TRAP object is placed,
    the *instance* number of the KS_TRAP is automatically sorted in time. If two instances of one KS_TRAP occur at the same time (`.pos`) on different boards,
    XGRAD comes before YGRAD, which comes before ZGRAD. These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a
    specific instance of a KS_TRAP object in the sequence

    If the `.duration` field in the KS_TRAP object is 0, ks_pg_trap() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    When a trapezoid is placed on OMEGA, neither the designed amplitude (the `.amp` field in KS_TRAP) nor the `.ampscale` (in KS_SEQLOC) has an effect on the final frequency modulation.
    Instead the run-time amplitude of a KS_TRAP object on the OMEGA board is controlled in scan() via a function called ks_scan_omegatrap_hz()

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] trap Pointer to a KS_TRAP sequence object
 *  @param[in]     loc  KS_SEQLOC struct to specify when and where to place the KS_TRAP
 *  @param[in,out]     ctrl Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_TRAP
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_trap(KS_TRAP *trap, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_READ sequence object at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_READ sequence object that creates an acquisition window in the pulse sequence.
    The same KS_READ object can be freely placed as many times as desired, by only changing the second argument each time (to avoid overlaps).
    The second argument is an integer with the absolute time in [us] of the start of the acquisition. System gradient delays are accounted for in ks_pg_read()
    by internally adjusting the position by adding the system variable `psd_grd_wait` to the position value. This assures the gradients boards and acquisition window
    are in sync on the MR system.

    Regardless of the order the acquisition windows are placed out in the `@pg` section, the *instance* number of the KS_READ is automatically sorted in time

    If the `.duration` field in the KS_READ object is 0, ks_pg_read() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] read Pointer to a KS_READ sequence object
 *  @param[in] pos Absolute time in [us] when to start data acquisition
 *  @param[in,out] ctrl Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_READ
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_read(KS_READ *read, int pos, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_PHASER sequence object on a board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_PHASER sequence object that creates a dynamic trapezoid for phase encoding. For 3D applications,
    two different KS_PHASER objects should have been designed by calling ks_eval_phaser() on each KS_PHASER as FOV and resolution typically differ for the two phase
    encoding directions.
    The same KS_PHASER object can be freely placed on XGRAD, YGRAD and ZGRAD as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). For Cartesian applications, phase encoding gradients such as KS_PHASER are typically placed out on YGRAD (phase encoding axis),
    for 3D also on ZGRAD. For 3D, the KS_PHASER object may embed a slice rephaser (static trapezoid) by setting `.areaoffset` to a non-zero value (see ks_eval_phaser()).
    The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD
    - `.pos`: Absolute time in [us] of the start of the attack ramp of the phase encoding trapezoid
    - `.ampscale`: For KS_PHASER objects, this must be 1.0. If not, ks_pg_phaser() will throw an error. Amplitude control should solely be done in scan using
      ks_scan_phaser_toline() and ks_scan_phaser_fromline().

    Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_PHASER object is placed,
    the *instance* number of the KS_PHASER is automatically sorted in time. If two instances of one KS_PHASER occur at the same time (`.pos`) on different boards,
    XGRAD comes before YGRAD, which comes before ZGRAD.
    These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a specific instance of a KS_PHASER object in the sequence

    If the `.duration` field in the KS_PHASER object is 0, ks_pg_phaser() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] phaser Pointer to a KS_PHASER sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when and where to place the KS_PHASER
 *  @param[in,out]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_PHASER
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_phaser(KS_PHASER *phaser, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_READTRAP sequence object on a board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_READTRAP sequence object consisting of a trapezoid (KS_TRAP) and an acquisition window (KS_READ).
    The same KS_READTRAP object can be freely placed on XGRAD, YGRAD and ZGRAD as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). For Cartesian applications, readouts such as KS_READTRAP are typically placed on XGRAD (frequency encoding axis).
    The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD
    - `.pos`: Absolute time in [us] of the start of the attack ramp of the readout trapezoid
    - `.ampscale`: For KS_READTRAP objects, this must be either +1.0 or -1.0 so that the FOV is not altered. Negative amplitudes will automatically be taken into account in
      ks_scan_offsetfov() to create the necessary frequency offset

    Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_READTRAP object is placed,
    the *instance* number of the KS_READTRAP is automatically sorted in time. If two instances of one KS_READTRAP occur at the same time (`.pos`) on different boards,
    XGRAD comes before YGRAD, which comes before ZGRAD.
    These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a specific instance of a KS_READTRAP object in the sequence.

    If the `.duration` field in the KS_READTRAP object is 0, ks_pg_readtrap() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] readtrap Pointer to a KS_READTRAP sequence object
 *  @param[in]     loc      KS_SEQLOC struct to specify when and where to place the KS_READTRAP
 *  @param[in,out]     ctrl     Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_READTRAP
 *  @retval        STATUS   `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_readtrap(KS_READTRAP *readtrap, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_WAVE sequence object on a board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_WAVE sequence object that creates an arbitrary waveform in the pulse sequence.
    The same KS_WAVE object can be placed on any board as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). However, the RHO (RF) board should be avoided as this bypasses RF scaling and SAR calculations, providing no control over the flip angle.
    For RF waveforms, always use KS_RF (or KS_SELRF). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD, OMEGA, THETA
    - `.pos`: Absolute time in [us] of the start of the waveform. For `RF`, OMEGA and THETA, `pos_rf_wait` will be added to this time to take system delays into account
    - `.ampscale`: For gradient boards, this factor must be in range [-1.0,1.0] that is multiplied with the waveform to yield a per-instance (i.e. per-placement)
    amplitude ([G/cm]). For THETA, only values of +1.0 and -1.0 is allowed, and for OMEGA only 1.0 is allowed

    The KS_WAVE sequence object contains a KS_WAVEFORM (float[KS_MAXWAVELEN]) to hold the waveform. The physical unit of the waveform in the KS_WAVE
    object depends the board on which it is placed using ks_pg_wave(). For the
    - gradient boards (XGRAD, YGRAD, ZGRAD), the unit is [G/cm]
    - THETA board, the unit is [degrees]
    - RF (RHO) and OMEGA boards, the units are arbitrary (c.f. ks_eval_rf() and ks_eval_wave()). Don't call ks_pg_wave() directly to place a KS_WAVE on the RF board

    When a waveform is placed on OMEGA, neither the waveform amplitude nor the `.ampscale` (in KS_SEQLOC) affects the final frequency modulation.
    Instead the run-time amplitude of a KS_WAVE object on the OMEGA board is controlled in scan() via a function called ks_scan_omegawave_hz(), where the largest value
    in the field `.waveform[]` in the KS_WAVE will correspond to the value in [Hz] provided.

    If the `.duration` field in the KS_WAVE object is 0, ks_pg_wave() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    All KS_WAVE objects are double buffered in ks_pg_wave() so that waveforms can be replaced in run-time (scan()) using ks_scan_wave2hardware()

    Regardless of the order placed out in the `@pg` section, and on which boards (XGRAD, YGRAD, ZGRAD) the KS_WAVE object is placed,
    the *instance* number of the KS_WAVE is automatically sorted in time. If two instances of one KS_WAVE occur at the same time (`.pos`) on different boards,
    XGRAD comes before YGRAD, which comes before ZGRAD.
    These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a specific instance of a KS_WAVE object in the sequence.

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] wave   Pointer to a KS_WAVE sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when and where to place the KS_WAVE
 *  @param[in,out]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_WAVE
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_wave(KS_WAVE *wave, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_RF sequence object on a board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_RF sequence object that creates an RF pulse in the pulse sequence.
    The same KS_RF object can be placed out as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: *Ignored*. `.rfwave` will always be placed on RHO. If the resolution of `.omegawave` is non-zero it will be placed on OMEGA, and
      correspondingly for `.thetawave` on THETA
    - `.pos`: Absolute time in [us] of the start of the waveform
    - `.ampscale`: A factor that must be in range [-1.0,1.0] that is multiplied with `.amp` to yield a per-instance (i.e. per-placement) amplitude. For KS_RF objects
      this will cause the flip angle to be reduced on a per-instance basis. This can be used to generate a variable flip-angle train of RF pulses using a single KS_RF object.
      An `.ampscale` of -1.0 is equivalent to adding a 180 degree RF phase shift to the RF pulse

    If the `rfwave.duration` field in the KS_RF object is 0, ks_pg_rf() will return SUCCESS and quietly ignore placing it out. This is a part of the mechanism that setting
    the `.duration` field to 0 in `cveval()` should eliminate its existance in both timing calulations and in the pulse sequence generation in `@pg`

    As ks_pg_rf() internally calls ks_pg_wave() for its KS_WAVEs, double buffering will be used for all hardware waveforms, allowing waveforms to be replaced in
    run-time (scan()) using ks_scan_wave2hardware()

    Regardless of the order placed out in the `@pg` section the KS_RF object is placed, the *instance* number of the KS_RF is automatically sorted in time.
    These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a specific instance of a KS_RF object in the sequence.

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

    When ks_pg_rf() is run in `cveval()` (on HOST), the field `.rfpulse.activity` that was first set to 0 by ks_eval_rf() is now set to
    `PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON` by ks_pg_rf().
    This triggers the RF functions used in ks_eval_gradrflimits() to include this KS_RF object in RF scaling and SAR calculations. Each time ks_pg_rf() is called, the
    field `.rfpulse.num` is incremented after being first set to 0 by ks_eval_rf(). Hence, it is crucial that the *sequence generating* function (c.f. KS_SEQ_CONTROL)
    containing all `ks_pg_***()` calls is executed between the ks_eval_rf() setup call and the call to ks_eval_gradrflimits()

 *  @param[in,out] rf     Pointer to a KS_RF sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when to place the KS_RF
 *  @param[in,out]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_RF
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_rf(KS_RF *rf, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_SELRF sequence object on a gradient (and RF) board at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_SELRF sequence object that creates an RF pulse with associated trapezoids in the pulse sequence.
    The same KS_SELRF object can be placed out as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: Choose between XGRAD, YGRAD, ZGRAD for the board on which `.pregrad`, `.grad` (or `.gradwave`) and `.postgrad` should be placed
    - `.pos`: Absolute time in [us] of the start of the `.pregrad` attack ramp. If `.pregrad` has zero duration, `.pos` will in effect refer to the start of the `.grad`
      attack ramp
    - `.ampscale`: A factor that must be in range [-1.0,1.0] that is multiplied with `rf.rfwave.amp` to yield a per-instance (i.e. per-placement) amplitude. For KS_SELRF objects
      the `.ampscale` value will be passed on its internal call to ks_pg_rf(), but not to its internal ks_pg_trap() calls. Hence `.ampscale` will
      have the same effect for ks_pg_selrf() as for ks_pg_rf(), with no per-instance control of the amplitude of the gradients involved. A reduced `.ampscale`
      will cause the flip angle to be reduced on a per-instance basis. This can be used to generate a variable flip-angle train of selective RF pulses using a single
      KS_SELRF object. An `.ampscale` of -1.0 is equivalent to adding a 180 degree RF phase shift to the RF pulse

    If the `.gradwave` field has a non-zero resolution, ks_pg_selrf() will place out the `.gradwave` (KS_WAVE) instead of the `.grad` (KS_TRAP) during the time the RF
    pulse is played out. An error is thrown if `.gradwave.duration` (if `.gradwave.res` > 0) is not equal to the `.rf.rfwave.duration`. If `.pregrad` or `.postgrad` has
    zero duration, they will not be placed out. The *existance* of non-zero `.pregrad` and `.postgrad` is determined by ks_eval_selrf() based on `.rf.role`

    As ks_pg_selrf() internally calls ks_pg_wave() for its KS_WAVEs, hardware double buffering will be used for all waveforms, allowing waveforms to be replaced in
    run-time (scan()) using ks_scan_wave2hardware()

    Regardless of the order placed out in the `@pg` section the KS_SELRF object is placed, the *instance* number of the KS_SELRF is automatically sorted in time.
    These abstract, sorted, instance numbers are used by `ks_scan_***()` functions in scan() to refer to a specific instance of a KS_SELRF object in the sequence.

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] selrf   Pointer to a KS_SELRF sequence object
 *  @param[in]     loc     KS_SEQLOC struct to specify when and where to place the KS_SELRF
 *  @param[in,out]     ctrl    Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_SELRF
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_selrf(KS_SELRF *selrf, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places a KS_WAIT sequence object on all boards at some position in the pulse sequence

    This function should be called in the `@pg` section to place out a KS_WAIT sequence object that creates a wait pulse.
    The same KS_WAIT object can be placed out as many times as desired, by only changing the second argument each time
    (to avoid waveform overlaps). The second argument is a KS_SEQLOC struct with three fields:
    - `.board`: *Ignored*
    - `.pos`: Absolute time in [us] of the start of the wait pulse
    - `.ampscale`: *Ignored*

    This function will insert a deadtime of duration equal to the `.duration` field in the KS_WAIT object at position `.pos`.
    This delay can be changed in run-time by calling ks_scan_wait().

    GENERAL NOTE: It is a **requirement** that the function in the `@pg` section containing all `ks_pg_***()` calls is also called exactly once in `cveval()` after
    the calls to the corresponding `ks_eval_***()` functions that design the KS_*** sequence objects. Each `ks_pg_***()` will throw an error if this has not been done.

 *  @param[in,out] wait   Pointer to a KS_WAIT sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when and where to place the KS_WAIT
 *  @param[in,out]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_WAIT
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_wait(KS_WAIT *wait, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places out an intersequence interrupt at a specific time in the sequence module

    This function connects the execution of a psd-specific rotation function in realtime when time passes this point in the
    sequence. This is done by two KS_WAIT pulses (being part of KS_ISIROT) on the SSP board.

    Example of use in a `myseqmodule_pg()` function of the sequence module (in pulsegen()):

    \code{.c}
    // add some padding time before the SSP pulses (not well tested how much of KS_ISI_predelay that is necessary)
    mypos += RUP_GRD(KS_ISI_predelay);

    status = ks_pg_isirot(&myisirot, myscaninfo, mypos, myisirotatefun, myseqctrl);
    if (status != SUCCESS) return status;

    // add some padding time after the SSP pulses (not well tested how much of KS_ISI_postdelay that is necessary)
    mypos += RUP_GRD(myisirot.duration + KS_ISI_postdelay);
    \endcode

    where the psd-specific rotation function is declared as:

    \code{.c}
    // Intra sequence interrupts placed as WAIT pulses on the SSP board may be used to call for an immediate
    // rotation of the logical coordinate system in real time as these WAIT pulses are played out, as
    // opposed to during the SSI time for the sequence module.
    // The WAIT pulse is assigned a control number (isi number) that is then connected to this void function
    // using `isivector()` in ks_pg_isirot(). No input arguments can be passed to this function. Instead the
    // rotation information specific to the sequence module is provided in `myscaninfo.oprot`. The acutal
    // rotation work, incl. keeping track of number of isi pulses played out is done by ks_scan_isirotate().
    void myisirotatefun() {

    #ifdef IPG
      ks_scan_isirotate(&myisirot);
    #endif

    }
    \endcode
    Note that the only difference between the psd-specific `myisirotatefun()` and the general ks_scan_isirotate() is that
    `myisirotatefun()` has no input arguments. Input arguments cannot be used as it is called from an interrupt routine,
    not from some other parent function.

    Care must be taken when mixing the use of ks_scan_rotate() (executing during the SSI time) and these ISI interrupts, so
    that they are executed in the correct order. One way is to consistently avoid the use of ks_scan_rotate() and instead
    return to the prescribed slice rotation by calling ks_pg_isirot() again, last in the same `myseqmodule_pg()` function,
    this time using the prescribed scan_info struct:

    \code{.c}
    status = ks_pg_isirot(&myisirot, ks_scan_info[0], mypos, myisirotatefun, myseqctrl);
    if (status != SUCCESS) return status;
    \endcode

 *  @param[in,out] isirot Pointer to a KS_ISIROT sequence object
 *  @param[in]     scan_info SCAN_INFO struct holding an `.oprot` matrix to be used for real-time rotation
 *  @param[in]     pos   Absolute position in [us] in the pulse sequence when this rotation should occur
 *  @param[in]     rotfun Function pointer to the psd-specific rotation function
 *  @param[in,out] ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_isirot(KS_ISIROT *isirot, SCAN_INFO scan_info, int pos, void *rotfun, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places out the dephasing gradients of a KS_EPI object (*used by ks_pg_epi()*)

    This function is called internally by ks_pg_epi() to place out the dephasing gradients of a KS_EPI object. See ks_pg_epi() for more details

    For advanced usage of KS_EPI, it is possible to call ks_pg_epi_dephaser(), ks_pg_epi_echo() and ks_pg_epi_rephasers() separately instead of the single call
    to ks_pg_epi(). This allows the dephasing and rephasing gradients to be detached from the core EPI readout part

 *  @param[in,out] epi    Pointer to a KS_EPI sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when and where to place the dephasers of the KS_EPI object
 *  @param[in]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_EPI
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_epi_dephasers(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places out the rephasing gradients of a KS_EPI object (*used by ks_pg_epi()*)

    This function is called internally by ks_pg_epi() to place out the rephasing gradients of a KS_EPI object. See ks_pg_epi() for more details

    For advanced usage of KS_EPI, it is possible to call ks_pg_epi_dephaser(), ks_pg_epi_echo() and ks_pg_epi_rephasers() separately instead of the single call
    to ks_pg_epi(). This allows the dephasing and rephasing gradients to be detached from the core EPI readout part

 *  @param[in,out] epi    Pointer to a KS_EPI sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when to place the rephasers of the KS_EPI object
 *  @param[in]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_EPI
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_epi_rephasers(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places out the core part a KS_EPI object (*used by ks_pg_epi()*)

    This function is called internally by ks_pg_epi() to place out the core part of a KS_EPI object. The core part is the EPI train without leading
    dephaser gradients or trailing rephaser gradients. See ks_pg_epi() for more details

    For advanced usage of KS_EPI, it is possible to call ks_pg_epi_dephaser(), ks_pg_epi_echo() and ks_pg_epi_rephasers() separately instead of the single call
    to ks_pg_epi(). This allows the dephasing and rephasing gradients to be detached from the core EPI readout part

 *  @param[in,out] epi Pointer to a KS_EPI sequence object
 *  @param[in] loc KS_SEQLOC struct to specify when to place the core part of the KS_EPI object
 *  @param[in]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_EPI
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_epi_echo(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/** @brief #### Places out a KS_EPI object (EPI train including dephaser and rephaser gradients)

    This function should be called in the `@pg` section to place out a KS_EPI sequence object that creates an EPI readout including dephaser and rephaser gradients.
    The moments of all trapezoids in the KS_EPI object sum to zero on the two axes the KS_EPI object is placed on. The KS_EPI object is to be placed on two out of three
    gradients, why special values for the field `loc.board` must be used. The value should state which logical board (X,Y or Z) that should be used for the readout
    lobes (FREQ) and which logical board (X, Y or Z) that should be used for the blips (PHASE). One example is KS_FREQX_PHASEY, which will put the EPI readout lobes on
    XGRAD and the phase encoding blips on YGRAD

    The same KS_EPI object can be placed out 16 times per sequence. This limitation is due to the hard limitation on the number of echoes (i.e. different k-spaces per image
    plane and image volume) that can be acquired per scan. Each time an instance of the KS_EPI object is placed out using ks_pg_epi(), the second argument
    (the KS_SEQLOC struct) should be modified:
    - `.board`: Choose between `KS_FREQX_PHASEY`, `KS_FREQY_PHASEX`, `KS_FREQX_PHASEZ`, `KS_FREQZ_PHASEX`, `KS_FREQY_PHASEZ`, `KS_FREQZ_PHASEY`
    - `.pos`: Absolute time in [us] of the start of the first dephaser gradient
    - `.ampscale`: For KS_EPI objects, valid values are only +1.0 and -1.0, and this will control the polarity of the first readout gradient. This is rarely needed, and 1.0
      should be the standard choice as this does only affect gradient delays and Nyquist ghosting, not the geometric distortion direction.

    The *sign* of the EPI blips will control the direction of the geometric distortions, and this is *not* done via `.ampscale` but in run-time using ks_scan_epi_shotcontrol()

    For advanced usage of KS_EPI, it is possible to call ks_pg_epi_dephaser(), ks_pg_epi_echo() and ks_pg_epi_rephasers() separately instead of the single call
    to ks_pg_epi(). This allows the dephasing and rephasing gradients to be detached from the core EPI readout part

 *  @param[in,out] epi    Pointer to a KS_EPI sequence object
 *  @param[in]     loc    KS_SEQLOC struct to specify when to place the core part of the KS_EPI object
 *  @param[in]     ctrl   Pointer to the KS_SEQ_CONTROL struct corresponding to the sequence module for this KS_EPI
 *  @retval        STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_pg_epi(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) WARN_UNUSED_RESULT;


/*******************************************************************************************************
 *  Matrix functions (row major)
 *******************************************************************************************************/

/** @brief #### Makes a 4x4 zero matrix

 *  @param[in,out] m Matrix (KS_MAT4x4)
 *  @return void
*/
void ks_mat4_zero(KS_MAT4x4 m);

/** @brief #### Creates a 4x4 identity matrix

 *  @param[in,out] m Matrix (KS_MAT4x4)
 *  @return void
*/
void ks_mat4_identity(KS_MAT4x4 m);

/** @brief #### Prints a 4x4 matrix to stdout

 *  @param[in] m Matrix (KS_MAT4x4)
 *  @return void
*/
void ks_mat4_print(const KS_MAT4x4 m);

/** @brief #### Multiplication of two 4x4 matrices

    Matrix product: [rhs_left] * [rhs_right]

 *  @param[out] lhs Matrix product (KS_MAT4x4)
 *  @param[in] rhs_left Left matrix (KS_MAT4x4)
 *  @param[in] rhs_right Right matrix (KS_MAT4x4)
 *  @return void
*/
void ks_mat4_multiply(KS_MAT4x4 lhs, const KS_MAT4x4 rhs_left, const KS_MAT4x4 rhs_right);

/** @brief #### Inversion of a 4x4 matrix

    4x4 matrix inversion (http://download.intel.com/design/PentiumIII/sml/24504301.pdf

 *  @param[out] lhs Inverted matrix (KS_MAT4x4)
 *  @param[in] rhs Matrix to be inverted (KS_MAT4x4)
 *  @return void
*/
void ks_mat4_invert(KS_MAT4x4 lhs, const KS_MAT4x4 rhs);

/** @brief #### Set geometry for KS_MAT4x4

 *  @param[out] lhs set matrix (KS_MAT4x4)
 *  @param[in]  x   displacement (mm)
 *  @param[in]  y   displacement (mm)
 *  @param[in]  z   displacement (mm)
 *  @param[in]  xr  rotation (deg)
 *  @param[in]  yr  rotation (deg)
 *  @param[in]  zr  rotation (deg)
 *  @return void
*/
void ks_mat4_setgeometry(KS_MAT4x4 lhs, float x, float y, float z, float xr, float yr, float zr);


/** @brief #### Create a new 4x4 matrix with a rotation around a single axis

 *  @param[out] rhs Rotation matrix (KS_MAT4x4)
 *  @param[in] rot Amount of rotation around `axis` [degrees]
 *  @param[in] axis One of (include the quotes): 'x', 'y', 'z'
 *  @return void
*/
void ks_mat4_setrotation1axis(KS_MAT4x4 rhs, float rot, char axis);

/** @brief #### Extract a 3x3 rotation matrix from a 4x4 transformation matrix

 *  @param[out] R 3x3 rotation matrix (KS_MAT3x3), row major
 *  @param[in] M Transformation matrix (KS_MAT4x4), row major
 *  @return void
*/
void ks_mat4_extractrotation(KS_MAT3x3 R, const KS_MAT4x4 M);

/* T : array of size 3, M : row-major 4x4 matrix */

/** @brief #### Extract a 3 element array with translations from a 4x4 transformation matrix

 *  @param[out] T Float array with 3 elements (must be allocated)
 *  @param[in] M Transformation matrix (KS_MAT4x4), row major
 *  @return void
*/
void ks_mat4_extracttranslation(double *T, const KS_MAT4x4 M);

/** @brief #### Creates a 3x3 identity matrix

 *  @param[in,out] m Matrix (KS_MAT3x3)
 *  @return void
*/
void ks_mat3_identity(KS_MAT3x3 m);

/** @brief #### Multiplication of two 3x3 matrices

    Matrix product: [rhs_left] * [rhs_right]

 *  @param[out] lhs Matrix product (KS_MAT3x3)
 *  @param[in] rhs_left Left matrix (KS_MAT3x3)
 *  @param[in] rhs_right Right matrix (KS_MAT3x3)
 *  @return void
*/
void ks_mat3_multiply(KS_MAT3x3 lhs, const KS_MAT3x3 rhs_left, const KS_MAT3x3 rhs_right);

/** @brief #### Prints a 3x3 matrix to stdout

 *  @param[in] m Matrix (KS_MAT3x3)
 *  @return void
*/
void ks_mat3_print(const KS_MAT3x3 m);

/** @brief #### Rotate a 3x1 vector by a 3x3 rotation matrix (alibi)

    Apply an active (alibi) rotation -- i.e w = R * v

 *  @param[out] w Output vector (float array with 3 elements)
 *  @param[in] R Rotation matrix (KS_MAT3x3)
 *  @param[in] v Input vector (float array with 3 elements)
 *  @return void
*/
void ks_mat3_apply(double *w, const KS_MAT3x3 R, const double *v);

/** @brief #### Rotate a 3x1 vector by the inverse of 3x3 rotation matrix (alias)

    Apply a passive (alias) rotation -- i.e w = R' * v = R^-1 * v

 *  @param[out] w Output vector (float array with 3 elements)
 *  @param[in] R Rotation matrix (KS_MAT3x3)
 *  @param[in] v Input vector (float array with 3 elements)
 *  @return void
*/
void ks_mat3_invapply(double *w, const KS_MAT3x3 R, const double *v);

/** @brief #### Updates a SCAN_INFO struct using physical and logical 4x4 transformation matrices
 *
 *  Updates the slice location -- e.g for motion correction (physical space) or propeller rotations (logical space)
 *
 *  M_physical and M_logical are row-major 4x4 matricies that describe rotations
 *  (R_physical, R_logical) and translations (T_physical, T_logical) of the FOV
 *  in the physical and logical coordinate systems, respectively.
 *  If R_slice and T_slice describe the position of the prescribed FOV contained
 *  in orig_loc then new_loc will describe the overall rotation R_new and translation
 *  T_new of the FOV such that:
 *
 *  `R_new = R_physical * R_slice * R_logical`
 *
 *  `T_new = R_logical^-1 * (R_slice^-1 * R_physical^-1 * T_physical + T_slice + T_logical)`
 *
 *  NOTE: All transformations are expected to be active (alibi) that denote a change of
 *  position/orientation, not passive (alias) that denote a change of coordinates system.
 *  See https://en.wikipedia.org/wiki/Active_and_passive_transformation
 *
 *  SCAN_INFO is defined in $ESE_TOP/psd/include/epic_geometry_types.h and the global `scan_info`
 *  variable is an array of SCAN_INFO structs holding information of the graphically prescribed slices
 *
 *  @param[out] new_loc Pointer to a SCAN_INFO struct holding the new slice information
 *  @param[in] orig_loc SCAN_INFO struct holding the original slice information
 *  @param[in] M_physical Transformation matrix (4x4) in the physical space
 *  @param[in] M_logical Transformation matrix (4x4) in the logical (i.e. XGRAD, YGRAD, ZGRAD) space
 *  @return void
*/
void ks_scan_update_slice_location(SCAN_INFO *new_loc, const SCAN_INFO orig_loc, const KS_MAT4x4 M_physical, const KS_MAT4x4 M_logical);

/** @brief #### Performs a rotation of the logical system on hardware (WARP)

    The field `.oprot` (9-element array) in the SCAN_INFO struct holds the rotation matrix that should be played out

    This function performs the necessary scaling of the rotation matrix using `loggrd`
    and `phygrd` and then calls `setrotatearray()`, which performs the actual rotation
    on hardware during the next SSI time.

    See ks_scan_update_slice_location() for detail on how to create new SCAN_INFO structs in run-time

 *  @param[in] slice_info SCAN_INFO struct holding new slice information
 *  @return void
*/
void ks_scan_rotate(SCAN_INFO slice_info);



/** @brief #### Performs an immediate rotation of the logical system on hardware (WARP)

    This function needs a psd-specific wrapper function to execute (see ks_pg_isirot())
    since the ISI interupt routine is calling a void function without input arguments.
    This psd-specific wrapper function should only contain the call to ks_scan_isirotate()
    with the psd-specific KS_ISIROT set up in pulsegen().

    For N number of calls to ks_pg_isirot() in the sequence module's pg-function, the field
    `isirot.numinstances` will be set to N, and this many ISI interrupt with a corresponding
    `isirot.isinumber` exist in the sequence module. Valid ISI numbers are 4-7, and one available
    number should be linked to one specific wrapper function using ks_eval_isirot() and
    ks_pg_isirot().

    In real-time, ks_scan_isirotate() will increment the `isirot.counter` field by 1 and restart
    at 0 after `isirot->numinstances`. `isirot.counter` is set to 0 in ks_pg_isirot().
    Based on the value of the `.counter` field, it will assign a pre-stored SCAN_INFO struct
    corresponding to this counter value. Again, this connection is done by ks_pg_isirot().

    ks_scan_isirotate() takes the current SCAN_INFO and converts it to long int, and then calls
    setrotateimm(..., WARP_UPDATE_ON_SSP_INT);

 *  @param[in] isirot Pointer to the KS_ISIROT struct set up by ks_pg_isirot()
 *  @return void
*/
void ks_scan_isirotate(KS_ISIROT *isirot);




STATUS ks_pg_fse_flip_angle_taperoff(double *flip_angles,
                                     int etl,
                                     double flip1, double flip2, double flip3,
                                     double target_flip,
                                     int start_middle);


void ks_pg_mod_fse_rfpulse_structs(KS_SELRF *rf1, KS_SELRF *rf2, KS_SELRF *rf3, const double *flip_angles, const int etl);



/** @brief #### Resets the usage counters on TGT for a KS_TRAP sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] trap Pointer to a KS_TRAP sequence object
 *  @return void
*/
void ks_instancereset_trap(KS_TRAP *trap);

/** @brief #### Resets the usage counters on TGT for a KS_WAIT sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] wait Pointer to a KS_WAIT sequence object
 *  @return void
*/
void ks_instancereset_wait(KS_WAIT *wait);

/** @brief #### Resets the usage counters on TGT for a KS_PHASER sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] phaser Pointer to a KS_PHASER sequence object
 *  @return void
*/
void ks_instancereset_phaser(KS_PHASER *phaser);

/** @brief #### Resets the usage counters on TGT for a KS_READTRAP sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] readtrap Pointer to a KS_READTRAP sequence object
 *  @return void
*/
void ks_instancereset_readtrap(KS_READTRAP *readtrap);

/** @brief #### Resets the usage counters on TGT for a KS_RF sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] rf Pointer to a KS_RF sequence object
 *  @return void
*/
void ks_instancereset_rf(KS_RF *rf);

/** @brief #### Resets the usage counters on TGT for a KS_SELRF sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] selrf Pointer to a KS_SELRF sequence object
 *  @return void
*/
void ks_instancereset_selrf(KS_SELRF *selrf);

/** @brief #### Resets the usage counters on TGT for a KS_EPI sequence object (*advanced use*)

    This function is for *advanced use* where a single *sequence generating* function is used
    in parallel in multiple sequences (i.e. in different SEQLENGTH()). This should be called
    after calling ks_copy_and_reset_obj()

    The function sets `.base.ngenerated` to 0 (counter for number of times placed out on TGT),
    and sets `.wfpulse` and `.wfi` to NULL to trigger the allocation of new hardware memory, before
    running the *sequence generating* function again.

 *  @param[in,out] epi Pointer to a KS_EPI sequence object
 *  @return void
*/
void ks_instancereset_epi(KS_EPI *epi);


/* Sorting */

/** @brief #### Compares two WF_INSTANCEs by time, then board

    This function is used by the qsort() routine in ks_compare_wfi_by_timeboard()

    If two WF_INSTANCEs occur at the same time, XGRAD will come before YGRAD and
    YGRAD before ZGRAD

 *  @param[in] a Pointer to the first KS_WFINSTANCE
 *  @param[in] b Pointer to the second KS_WFINSTANCE
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_wfi_by_timeboard(const KS_WFINSTANCE *a, const KS_WFINSTANCE *b);

/** @brief #### Compares two WF_INSTANCES by board, then time

    This function is used by the qsort() routine in ks_compare_wfi_by_boardtime()

    WF_INSTANCEs are sorted first by board. If two WF_INSTANCEs occur on the same board, t
    they will be sorted in time

 *  @param[in] a Pointer to the first KS_WFINSTANCE
 *  @param[in] b Pointer to the second KS_WFINSTANCE
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_wfi_by_boardtime(const KS_WFINSTANCE *a, const KS_WFINSTANCE *b);

/** @brief #### Compares two WF_PULSES in time

    This function is used by the qsort() routine in ks_sort_wfp_by_time(), which
    is called from ks_pg_read() for data acquisition sorting purposes. It is assumed
    both WF_PULSEs have only one instance

 *  @param[in] a Pointer to the first WF_PULSE
 *  @param[in] b Pointer to the second WF_PULSE
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_wfp_by_time(const WF_PULSE *a, const WF_PULSE *b);

/** @brief #### Compares two int pointers

 *  @param[in] v1 Pointer to the first int pointer
 *  @param[in] v2 Pointer to the second int pointer
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_pint(const void *v1, const void *v2);

/** @brief #### Compares two short pointers

 *  @param[in] v1 Pointer to the first short pointer
 *  @param[in] v2 Pointer to the second shot pointer
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_pshort(const void *v1, const void *v2);

/** @brief #### Compares two float pointers

 *  @param[in] v1 Pointer to the first float pointer
 *  @param[in] v2 Pointer to the second float pointer
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_pfloat(const void *v1, const void *v2);

/** @brief #### Compares two integers (int)

 *  @param[in] v1 Pointer to the first int
 *  @param[in] v2 Pointer to the second int
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_int(const void *v1, const void *v2);

/** @brief #### Compares two integers (short)

 *  @param[in] v1 Pointer to the first short
 *  @param[in] v2 Pointer to the second short
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_short(const void *v1, const void *v2);

/** @brief #### Compares two floats

 *  @param[in] v1 Pointer to the first float
 *  @param[in] v2 Pointer to the second float
 *  @retval value Larger or less than 0 depending on sorting order
*/
int ks_compare_float(const void *v1, const void *v2);

/** @brief #### Sort an array of integers (int)

 *  @param[out] sortedindx Array of indices into the `array` to make it sorted
 *  @param[in,out] array Array to be sorted
 *  @param[in] n Number of elements in array
 *  @return void
*/
void ks_sort_getsortedindx(int *sortedindx, int *array, int n);

/** @brief #### Sort an array of integers (short)

 *  @param[out] sortedindx Array of indices into the `array` to make it sorted
 *  @param[in,out] array Array to be sorted
 *  @param[in] n Number of elements in array
 *  @return void
*/
void ks_sort_getsortedindx_s(int *sortedindx, short *array, int n);

/** @brief #### Sort an array of floats

 *  @param[out] sortedindx Array of indices into the `array` to make it sorted
 *  @param[in,out] array Array to be sorted
 *  @param[in] n Number of elements in array
 *  @return void
*/
void ks_sort_getsortedindx_f(int *sortedindx, float *array, int n);

/** @brief #### Sort WF_INSTANCEs in time, then board

    This is the sorting method used in all ks_pg_***() functions

 *  @param[in,out] a Array of KS_WFINSTANCE elements
 *  @param[in] nitems Number of elements in array
 *  @return void
*/
void ks_sort_wfi_by_timeboard(KS_WFINSTANCE *a, int nitems);

/** @brief #### Sort WF_INSTANCEs by board, then time

    This function is an alternative to ks_sort_wfi_by_timeboard(), which is *not*
    used at the moment

 *  @param[in,out] a Array of KS_WFINSTANCE elements
 *  @param[in] nitems Number of elements in array
 *  @return void
*/
void ks_sort_wfi_by_boardtime(KS_WFINSTANCE *a, int nitems);

/** @brief #### Sort WF_PULSEs in time

    This is the sorting method used in ks_pg_read()

    It is assumed that all a[idx] for idx in [0,nitems) have only one instance each

 *  @param[in,out] a Array of WF_PULSE elements
 *  @param[in] nitems Number of elements in array
 *  @return void
*/
void ks_sort_wfp_by_time(WF_PULSE *a, int nitems);





/*******************************************************************************************************
 *  Plot functions
 *******************************************************************************************************/
void ks_plot_slicetime_begin();
void ks_plot_slicetime(KS_SEQ_CONTROL *ctrl, int nslices, float *slicepos_mm, float slthick_mm, KS_PLOT_EXCITATION_MODE exctype);
void ks_plot_slicetime_endofslicegroup(const char* desc);
void ks_plot_slicetime_endofpass();
void ks_plot_slicetime_end();
void ks_plot_host_slicetime_begin();
void ks_plot_host_slicetime(KS_SEQ_CONTROL *ctrl, int nslices, float *slicepos_mm, float slthick_mm, KS_PLOT_EXCITATION_MODE exctype);
void ks_plot_host_slicetime_endofslicegroup(const char* desc);
void ks_plot_host_slicetime_endofpass();
void ks_plot_host_slicetime_end();
void ks_plot_host(KS_SEQ_COLLECTION* seqcollection, KS_PHASEENCODING_PLAN* plan);
void ks_plot_host_seqctrl(KS_SEQ_CONTROL* ctrl, KS_PHASEENCODING_PLAN* plan);
void ks_plot_host_seqctrl_manyplans(KS_SEQ_CONTROL* ctrl, KS_PHASEENCODING_PLAN** plan, const int num_plans);
void ks_plot_tgt_reset(KS_SEQ_CONTROL* ctrl);

/**
 * Writes a plot frame to file
 * @param ctrl Pointer to sequence control
 *
 */
void ks_plot_tgt_addframe(KS_SEQ_CONTROL* ctrl);





/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  KSFoundation.h: Function Prototypes available on TGT (KSFoundation_tgt.c)
 *
 *******************************************************************************************************
 *******************************************************************************************************/


/** @brief #### Changes the amplitude of one or all instances of an RF pulse (KS_RF)

    This function multiplies one instance of a KS_RF object with an amplitude scale factor (3rd arg)
    that must be in range [-1.0,1.0]. To change all instances of a KS_RF object, use `INSTRALL` as the 2nd argument.

    The actual flip angle for an instance of a KS_RF object is the multiplication of the three factors:
    1. The designed flip angle
    2. The per-instance `.ampscale` in the KS_SEQLOC struct passed to ks_pg_rf()
    3. The `ampscale` value passed in as 3rd argument to this function.
    Since both ampscale factors are forced to be in range [-1.0,1.0], it is not possible to increase the flip angle
    beyond the designed value (`.flip`)

 *  @param[in,out] rf Pointer to KS_RF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] ampscale RF amplitude scale factor in range [-1.0,1.0]
*/
void ks_scan_rf_ampscale(KS_RF *rf, int instanceno, float ampscale);

/** @brief #### Resets the amplitude of one or all instances of an RF pulse (KS_RF)

    This function (re)sets the RF amplitude to the state given by ks_pg_rf()

 *  @param[in,out] rf Pointer to KS_RF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
*/
void ks_scan_rf_on(KS_RF *rf, int instanceno);

/** @brief #### Resets the amplitude of one or all instances of an RF pulse (KS_RF) and toggles the sign (chopping)

    Everytime this function is called, the magnitude of the RF amplitude will be (re)set the RF amplitude to the state given by ks_pg_rf()
    and the polarity of the RF amplitude will be changed. If this function is called each TR (RF chopping) for a linear single-line k-space acquisition,
    a FOV/2 shift will occur in the image with any DC component shifted out to the edges of the image FOV.

 *  @param[in,out] rf Pointer to KS_RF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
*/
void ks_scan_rf_on_chop(KS_RF *rf, int instanceno);

/** @brief #### Sets the amplitude of one or all instances of an RF pulse (KS_RF) to zero

    This can be undone by calling ks_scan_rf_on(), ks_scan_rf_on_chop(), or ks_scan_rf_ampscale()

 *  @param[in,out] rf Pointer to KS_RF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
*/
void ks_scan_rf_off(KS_RF *rf, int instanceno);


/** @brief #### Updates the frequency and phase of one or all instances of a slice selective RF pulse (KS_SELRF)

    This function alters the frequency of the RF pulse in a KS_SELRF object to excite a spatial location
    corresponding to the information in `sliceinfo.tloc`. The phase of the RF pulse is also updated

 *  @param[in,out] selrf Pointer to KS_SELRF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] rfphase Phase of the RF pulse in [degrees]
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_selrf_setfreqphase(KS_SELRF *selrf, int instanceno, SCAN_INFO sliceinfo, float rfphase);


/** @brief #### Updates the off-center phase-modulation of one or all instances of a PINS RF pulse (KS_SELRF)

    This function alters the phase of the PINS RF pulse in a KS_SELRF object to excite spatial locations
    corresponding to the information in `sliceinfo.tloc`.

 *  @param[in,out] selrf Pointer to KS_SELRF
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] sms_multiband_factor
 *  @param[in] sms_slice_gap in [mm]
 *  @param[in] rfphase Phase of the RF pulse in [degrees]
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_selrf_setfreqphase_pins(KS_SELRF *selrf, int instanceno, SCAN_INFO sliceinfo, int sms_multiband_factor, float sms_slice_gap, float rfphase);


/** @brief #### Updates the phase of one or all instances of an RF pulse (KS_RF)

    This function sets the phase of an RF pulse object (KS_RF). Can be used for RF spoiling

 *  @param[in,out] rf Pointer to KS_SEL
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] rfphase Phase of the RF pulse in [degrees]
*/
void ks_scan_rf_setphase(KS_RF* rf, int instanceno, float rfphase /* deg */);

/** @brief #### Moves a waveform belonging to a KS_WAVE sequence object to hardware

    This function copies a waveform to one of the two hardware waveform buffers (belonging to the KS_WAVE object) that
    is currently not in use for the current sequence playout. The selection of which buffer to update is handled automatically by the function,
    which will also change the waveform pointer to the updated buffer so it will be used for the next sequence playout

    If the 2nd argument (`newwave`, of type KS_WAVEFORM (float array)) is
    1. not NULL, the content of `newwave` is used
    2. NULL, it is assumed that the `.waveform` field of KS_WAVE has been updated with new contents and is copied to hardware instead of `newwave`

 *  @param[in,out] wave Pointer to KS_WAVE
 *  @param[in] newwave KS_WAVEFORM to copy to hardware (if `NULL`, the `.waveform` field in KS_WAVE will be used instead)
*/
void ks_scan_wave2hardware(KS_WAVE *wave, const KS_WAVEFORM newwave);


/** @brief #### Updates the frequency and phase to create a FOV shift assuming that the k-space voxels/pixels are isometric
 *
 *  @param[in,out] readtrap Pointer to KS_READTRAP
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] ky phase offset in k-space measured in voxels/pixels
 *  @param[in] kz phase offset in k-space  measured in voxels/pixels
 *  @param[in] rcvphase Receiver phase in [degrees] of the acquisition window corresponding to the KS_READTRAP and instanceno
 */
void ks_scan_offsetfov_iso(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, double ky, double kz, double rcvphase);


/** @brief #### Updates the frequency and phase of one or all instances of a KS_READTRAP to create a FOV shift

    This function can be used by 2D Cartesian pulse sequences to build up the phase ramp in k-space necessary to shift the image FOV. The desired
    image FOV shift is given by the SCAN_INFO struct passed in as 3rd argument. The `view` field and the `phasefovratio` arguments are necessary to know
    where in the physical k-space the acquired data is placed. Knowing this and the FOV offset in the phase encoding direction, the necessary receiver phase
    for the current `view` can be set. After this function has been called for all `view` numbers, the necessary phase ramp has been set up in k-space to
    perform the phase FOV shift in the image domain. The `rcvphase` is added to the receive phase required for the FOV shift. In general, the `rcvphase`
    should be the same as the phase of the RF excitation pulse.

    For rampsampled acquisitions (`.rampsampling` = 1 in KS_READTRAP), the ks_scan_offsetfov_iso() function called will internally call ks_scan_omegatrap_hz()
    for FOV shifts in the readout direction. Both ks_scan_offsetfov() and ks_scan_offsetfov3D() calls the same ks_scan_offsetfov_iso() function after performing unit
    conversions of the input arguments.

 *  @param[in,out] readtrap Pointer to KS_READTRAP
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] view Phase encoding line to acquire with index corresponding to a fully sampled k-space [0, res-1]
 *  @param[in] phasefovratio The ratio of FOVphase/FOVfreq (as `opphasefov`)
 *  @param[in] rcvphase Receiver phase in [degrees] of the acquisition window corresponding to the KS_READTRAP and instanceno
*/
void ks_scan_offsetfov(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, int view, float phasefovratio, float rcvphase);


/** @brief #### Updates the frequency and phase of one or all instances of a KS_READTRAP to create a FOV shift

    This function can be used by 3D Cartesian pulse sequences to build up the phase ramp in k-space necessary to shift the image FOV. The desired
    image FOV shift is given by the SCAN_INFO struct passed in as 3rd argument. The `kyview`/`kzview` field and the `phasefovratio`/`zphasefovratio` arguments are necessary to know
    where in the physical k-space the acquired data is placed. Knowing this and the FOV offset in both phase encoding directions, the necessary receiver phase
    for the current `kyview`/`kzview` can be set. After this function has been called for all `kyview`/`kzview` numbers, the necessary phase ramp has been set up in k-space to
    perform the phase FOV shift in the image domain. The `rcvphase` is added to the receive phase required for the FOV shift. In general, the `rcvphase`
    should be the same as the phase of the RF excitation pulse.

    For rampsampled acquisitions (`.rampsampling` = 1 in KS_READTRAP), the ks_scan_offsetfov_iso() function called will internally call ks_scan_omegatrap_hz()
    for FOV shifts in the readout direction. Both ks_scan_offsetfov() and ks_scan_offsetfov3D() calls the same ks_scan_offsetfov_iso() function after performing unit
    conversions of the input arguments.

 *  @param[in,out] readtrap Pointer to KS_READTRAP
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] kyview Phase encoding line to acquire with index corresponding to a fully sampled k-space [0, res-1] (YGRAD)
 *  @param[in] phasefovratio The ratio of FOVphase/FOVfreq (as `opphasefov`)
 *  @param[in] kzview Z Phase encoding line to acquire with index corresponding to a fully sampled k-space [0, res-1] (ZGRAD)
 *  @param[in] zphasefovratio The ratio of FOVslice/FOVfreq (as `(opslquant * opslthick) / opfov`)
 *  @param[in] rcvphase Receiver phase in [degrees] of the acquisition window corresponding to the KS_READTRAP and instanceno
*/
void ks_scan_offsetfov3D(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, int kyview, float phasefovratio, int kzview, float zphasefovratio, float rcvphase /* [deg] */);


void ks_scan_offsetfov_readwave(KS_READWAVE* readwave, int instanceno, SCAN_INFO sliceinfo, int kyview, float phasefovratio, float rcvphase);

/** @brief #### Updates a KS_TRAP object on the OMEGA board to produce a frequency offset

    A KS_TRAP object on OMEGA is used for rampsampled acquisitions and is placed out using ks_pg_readtrap() for a KS_READTRAP object if
    the field `.rampsampling` = 1. This will cause a trapezoidal frequency shift during the readout instead of a fixed frequency offset when rampsampling
    is not used. An error is returned if the current instance of the KS_TRAP is on another board than OMEGA

    For Cartesian applications, there is no need to call this function directly, since ks_scan_offsetfov() already calls this function

    Special note for OMEGA: Neither the `.amp` field nor the `.ampscale` field passed in to ks_pg_trap() has an effect. Only the `Hz` argument controls
    the frequency shift

 *  @param[in,out] trap Pointer to KS_TRAP
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] Hz Desired frequency offset in [Hz] at the plateau of the trapezoid
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_omegatrap_hz(KS_TRAP *trap, int instanceno, float Hz);


/** @brief #### Updates a KS_WAVE object on the OMEGA board to produce a frequency offset

    A KS_WAVE object on OMEGA can be used to perform a dynamic frequency offset
    1. while an RF pulse is played out. One example is Spectral-Spatial RF pulses
    2. during data acquisition

 *  @param[in,out] wave Pointer to KS_WAVE
 *  @param[in] instanceno Instance of KS_RF to change (`INSTRALL` changes all instances)
 *  @param[in] Hz Desired frequency offset in [Hz] for the point in the KS_WAVE with the largest absolute amplitude
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_omegawave_hz(KS_WAVE *wave, int instanceno, float Hz);


/** @brief #### Updates the wait period of all instances of a KS_WAIT sequence object. The value of `waitperiod` must not exceed
    `.duration`.

 *  @param[in,out] wait Pointer to KS_WAIT
 *  @param[in] waitperiod Time in [us] to wait
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_wait(KS_WAIT *wait, int waitperiod);


/** @brief #### Updates the amplitude of one or all instances of a KS_TRAP sequence object

    This function multiplies one instance of a KS_TRAP object with an amplitude scale factor (3rd arg)
    that should be in range [-1.0,1.0] to avoid slewrate issues. To change all instances of a KS_TRAP object, use `INSTRALL` as the 2nd argument.

    The actual amplitude for an instance of a KS_TRAP object is the multiplication of the three factors:
    1. The designed amplitude [G/cm]
    2. The per-instance `.ampscale` in the KS_SEQLOC struct passed to ks_pg_trap()
    3. The `ampscale` value passed in as 3rd argument to this function.

 *  @param[in,out] trap Pointer to KS_TRAP
 *  @param[in] instanceno Instance of KS_TRAP to change (`INSTRALL` changes all instances)
 *  @param[in] ampscale Gradient amplitude scale factor, normally in range [-1.0,1.0], but the range [-1.2, 1.2] is allowed to allow certain run-time gradient corrections
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_trap_ampscale(KS_TRAP *trap, int instanceno, float ampscale);


/** @brief #### Updates the amplitude of a selection of instances of a KS_TRAP sequence object

    This function multiplies some instances of a KS_TRAP object with an amplitude scale factor (5th arg)
    that should be in range [-1.0,1.0] to avoid slewrate issues.

    The instances to change are `start + i * skip`, where `i` goes from 0 to `count`. FAILURE is returned if either
    start or `start` + `count` * `skip` out of range or `count` is negative

 *  @param[in,out] trap Pointer to KS_TRAP
 *  @param[in] start First instance number of the KS_TRAP
 *  @param[in] skip Difference in instance number between consecutive instances
 *  @param[in] count Number of instances to change in total
 *  @param[in] ampscale Gradient amplitude scale factor, normally in range [-1.0,1.0], but the range [-1.2, 1.2] is allowed to allow certain run-time gradient corrections
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_trap_ampscale_slice(KS_TRAP *trap, int start, int skip, int count, float ampscale);


/** @brief #### Updates the amplitude of a KS_PHASER sequence object to move some arbitrary distance in k-space

    This function sets the amplitude of the gradient for a KS_PHASER object so that a shift in k-space of `pixelunits`
    number of pixels is produced. If `pixelunits` is 1.0, the gradient area corresponds to one pixel shift in a fully sampled k-space (no parallel imaging)
    along the board the KS_PHASER object is placed on. `pixelunits` is of type `float` and any non-integer value is accepted, and the sign of `pixelunits`
    determines the direction of k-space shift

 *  @param[in,out] phaser Pointer to KS_PHASER
 *  @param[in] instanceno Instance of KS_TRAP to change (`INSTRALL` changes all instances)
 *  @param[in] pixelunits Non-integer pixel units in a fully sampled k-space to move
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_phaser_kmove(KS_PHASER *phaser, int instanceno, double pixelunits);


/** @brief #### Updates the amplitude of a KS_PHASER sequence object to move from the k-space center to a desired k-space line

    This function sets the amplitude of the gradient for a KS_PHASER object to produce a k-space shift *from* the center of k-space *to* the `view` number (3rd arg).
    The `view` number must be an integer in range [0, `.res`-1], and the number refers to a fully sampled k-space (without parallel imaging)

 *  @param[in,out] phaser Pointer to KS_PHASER
 *  @param[in] instanceno Instance of KS_TRAP to change (`INSTRALL` changes all instances)
 *  @param[in] view Phase encoding line to acquire with index corresponding to a fully sampled k-space [0, res-1]
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_phaser_toline(KS_PHASER *phaser, int instanceno, int view);


/** @brief #### Updates the amplitude of a KS_PHASER sequence object to move from a k-space line to the k-space center

    This function sets the amplitude of the gradient for a KS_PHASER object to produce a k-space shift *from* the `view` number (3rd arg) *to* the k-space center.
    The `view` number must be an integer in range [0, `.res`-1], and the number refers to a fully sampled k-space (without parallel imaging)

 *  @param[in,out] phaser Pointer to KS_PHASER
 *  @param[in] instanceno Instance of KS_TRAP to change (`INSTRALL` changes all instances)
 *  @param[in] view Phase encoding line to acquire with index corresponding to a fully sampled k-space [0, res-1]
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_phaser_fromline(KS_PHASER *phaser, int instanceno, int view);


/** @brief #### Returns the spatially sorted slice index from a DATA_ACQ_ORDER struct array

    This function finds the spatially sorted slice index (`.slloc`) in range [0, nslices-1] given the sequence's DATA_ACQ_ORDER struct array
    (in slice_plan.acq_order)

 *  @param[in] slice_plan   Pointer to the slice plan (KS_SLICE_PLAN) for the sequence
 *  @param[in] passindx     Current pass index ([0, acqs-1])
 *  @param[in] sltimeinpass Temporal index of the `n` slices acquired in each pass ([0, n-1])
 *  @retval    slloc        Spatially sorted slice index
*/
int ks_scan_getsliceloc(const KS_SLICE_PLAN *slice_plan, int passindx, int sltimeinpass);


/** @brief #### Returns the temporally sorted slice index from a DATA_ACQ_ORDER struct array

    This function finds the temporally sorted slice index (`.sltime`) in range [0, nslices-1] given the sequence's DATA_ACQ_ORDER struct array
    (in slice_plan.acq_order)

 *  @param[in] slice_plan   Pointer to the slice plan (KS_SLICE_PLAN) for the sequence
 *  @param[in] passindx     Current pass index ([0, acqs-1])
 *  @param[in] slloc        Spatially sorted slice index [0, nslices-1]
 *  @retval    sltimeinpass Temporal index of the `n` slices acquired in each pass ([0, n-1])
*/
int ks_scan_getslicetime(const KS_SLICE_PLAN *slice_plan, int passindx, int slloc);



/* TODO: document */
ks_enum_epiblipsign ks_scan_epi_verify_phaseenc_plan(KS_EPI *epi, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot);



/** @brief #### Changes the gradient state of a KS_EPI object for the given slice information

    This function has two different tasks. First, it controls the EPI blips and sets the EPI dephaser and rephaser amplitude given the current `phaseshot`
    and `blipsign`. If `phaseshot` is outside the valid range ([0, `.blipphaser.R`-1], all gradient amplitudes on the blip (phase encoding) axis will be zero.
    This can be useful to acquire a refscan for Nyquist ghost correction. Second, it sets up the proper frequency and phase modulation per readout lobe to
    produce the desired FOV offset in both the frequency and phase encoding directions

 *  @param[in,out] epi Pointer to KS_EPI
 *  @param[in] echo EPI echo index (up to 16 EPI trains supported)
 *  @param[in] sliceinfo SCAN_INFO struct for the current slice to be played out
 *  @param[in] phaseenc_plan Pointer to the phase encoding plan
 *  @param[in] shot Linear ky kz `shot` index in range `[0, (phaseenc_plan.num_shots-1)]`
 *  @param[in] rcvphase Receiver phase in degrees, for RF spoiling.
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_epi_shotcontrol(KS_EPI *epi, int echo, SCAN_INFO sliceinfo, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot, float rcvphase);


/** @brief #### Loads the data storage information to hardware for the acquisition windows in a KS_EPI sequence object

    This function specifies where to store the data acquired for each readout lobe in the KS_EPI train given current:
    - `echo`: First instance of the KS_EPI train is 0
    - `slice`: Slice index, 0-based
    - `shot`: Linear ky kz `shot` index in range `[0, (phaseenc_plan.num_shots-1)]`
    - `phaseenc_plan`: phaseenc_plan Pointer to the phase encoding plan

    If `shot` is outside the valid range, a baseline view (view 0 in loaddab()) will be acquired.

    If `slice` is < 0, data acquisition is turned *off* in loaddab()

 *  @param[in,out] epi Pointer to KS_EPI
 *  @param[in] echo EPI echo index to work on (up to 16 EPI trains supported)
 *  @param[in] storeecho EPI echo index for storing (usually the same as echo)
 *  @param[in] slice Slice index where to store the data (0-based)
 *  @param[in] phaseenc_plan Pointer to the phase encoding plan
 *  @param[in] shot Linear ky kz `shot` index in range `[0, (phaseenc_plan.num_shots-1)]`
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
void ks_scan_epi_loadecho(KS_EPI *epi, int echo, int storeecho, int slice, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot);


/** @brief #### Data routing control for RTP

 *  @param[in,out] read Pointer to KS_READ
 *  @param[in] dabacqctrl DABON or DABOFF
 *  @param[in] fatoffset Frequency offset in [Hz] for the current data acquisition window
 *  @return void
*/
void ks_scan_acq_to_rtp(KS_READ *read, TYPDAB_PACKETS dabacqctrl, float fatoffset);


/* alternative to boffset */
void ks_scan_switch_to_sequence(KS_SEQ_CONTROL *ctrl);

/* ssitime, boffset and startseq */
int ks_scan_playsequence(KS_SEQ_CONTROL *ctrl);


/** @brief #### loaddab() with extra arguments for current acquisition and image volume

 *  @param[in] pulse Pointer to WF_PULSE in a KS_READ
 *  @param[in] slice 0-based *temporal* slice index (2D) or kz encoding step typically (3D)
 *  @param[in] echo 0-based echo in the echo train
 *  @param[in] view 1-based ky view number
 *  @param[in] acq 0-based acquisition index (always 0 if all slices fit in one TR)
 *  @param[in] vol 0-based volume index (always 0 if only one volume)
 *  @param[in] acqon_flag DABON or DABOFF
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_scan_loaddabwithindices(WF_PULSE_ADDR pulse,
                                  LONG slice,
                                  LONG echo,
                                  LONG view,
                                  uint8_t acq,
                                  uint8_t vol,
                                  TYPDAB_PACKETS acqon_flag);


/** @brief #### loaddab() with extra arguments for current acquisition and image volume and current excitation (NEX)

 *  @param[in] pulse Pointer to WF_PULSE in a KS_READ
 *  @param[in] slice 0-based *temporal* slice index (2D) or kz encoding step typically (3D)
 *  @param[in] echo 0-based echo in the echo train
 *  @param[in] view 1-based ky view number
 *  @param[in] acq 0-based acquisition index (always 0 if all slices fit in one TR)
 *  @param[in] vol 0-based volume index (always 0 if only one volume)
 *  @param[in] operation DABSTORE, DABADD (for 2nd to last excitation)
 *  @param[in] acqon_flag DABON or DABOFF
 *  @retval STATUS `SUCCESS` or `FAILURE`
*/
STATUS ks_scan_loaddabwithindices_nex(WF_PULSE_ADDR pulse,
                                      LONG slice,
                                      LONG echo,
                                      LONG view,
                                      uint8_t acq,
                                      uint8_t vol,
                                      LONG operation,
                                      TYPDAB_PACKETS acqon_flag);


/** @brief #### play a wait sequence in a loop untill a RTP message is received.
 *
 *  @param[out] rtpmsg pointer to memory that will be filled by the RTP message
 *  @param[in] maxmsgsize size in bytes of the memory pointed by rtpmsg
 *  @param[in] maxwait timing out period in [ms]
 *  @param[in] waitctrl pointer to the KS_SEQ_CONTROL of a wait sequence.
 *             If NULL, the provided  maxwait is ignored and a value of zero used instead.
 *  @retval size of the received message, zero if timed out
 */
int ks_scan_wait_for_rtp(void *rtpmsg, int maxmsgsize, int maxwait, KS_SEQ_CONTROL *waitctrl);

/** @brief #### Create a copy of any sequence object with a KS_BASE as first member

   Create a copy of the object pointed by pobj and insert it into the linked list in second position. finally reset the (base part of) original object.

   It is *required* that `pobj` can be casted to (KS_BASE *), which is the pointed object should have a KS_BASE as first member. Note that other,
   object-specific, actions may need to be  performed to finalize the reset. This includes calls to ks_instancereset_***() functions on each member of the
   current `pobj`
 *  @param[in] pobj Pointer to a sequence object of some kind
 *  @return void
*/

void ks_copy_and_reset_obj(void *pobj);


/** @brief #### Show the clock in the UI with the remaining scan time

*/
void ks_show_clock(FLOAT scantime);


 /** @brief #### Returns spoiling phase for a given RF counter
 * @param[in]  counter [RF number]
 * @return     phase   [Phase in degrees]
 */
float ks_scan_rf_phase_spoiling(int counter);

/**
 * Clears KS_GRADRFCTRL on TGT.
 * Called in ks_pg_trap, ks_pg_wave, and ks_pg_rf if the field `is_cleared_on_tgt` is false.
 * @param gradrfctrl [pointer to KS_GRADRFCTRL]
 */
void ks_tgt_reset_gradrfctrl(KS_GRADRFCTRL* gradrfctrl);

int ks_eval_clear_readwave(KS_READWAVE* readwave);
int ks_eval_clear_dualreadtrap(KS_DIXON_DUALREADTRAP* dual_read);

#endif /* KSFOUNDATION_H */
