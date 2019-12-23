/******************************************************************************************************
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename	: grad_rf_empty.h
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
* @file grad_rf_empty.h
* @brief This file sets up the global `rfpulse[]` struct array, used for RF scaling,
*        with KS_MAXUNIQUERF (=20) number of empty RF_PULSE member slots, followed by including RF_PULSE
*        struct from "rf_Prescan.h"
*
*  It is required that rfpulse[], rfpulseInfo[] arrays, and RF_FREE exist in the main sequence.
*
*  For GE's pulse sequences,
*   - rfpulse[] is declared in grad_rf_<seqname>.h
*   - RF_FREE is automatically set in rf_Prescan.h based on RF_FREE1 in grad_rf_<seqname>.globals.h
*   - rfpulseInfo[] is declared in `@ipgexport` for all GE sequences.
*
*  For pulse sequences written entirely using KSFoundation
*   - rfpulse[] is declared in this file
*   - RF_FREE is automatically set in rf_Prescan.h based on RF_FREE1 in grad_rf_empty.globals.h
*   - rfpulseInfo[] is declared in `@ipgexport` of GERequired.e
********************************************************************************************************/




/* only do this once in any given compilation.*/
#ifndef  grad_rf_empty_INCL
#define  grad_rf_empty_INCL

/* #define MAX(x,y) ( (x>y) ? x : y ) */


RF_PULSE rfpulse[RF_FREE] = {

  /*  KSRF00_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF01_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF02_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF03_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF04_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF05_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF06_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF07_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF08_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF09_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF10_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF11_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF12_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF13_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF14_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF15_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF16_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF17_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF18_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,
  /*  KSRF19_SLOT */
  {(int *) NULL,
   (FLOAT *) NULL,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   (FLOAT *) NULL,
   0,
   0,
   PSD_PULSE_OFF,
   0, 0, 0,
   (int *) NULL,
   0,
   (int *) NULL
  } ,

#ifndef DOXYGEN_EXCLUDE
#include "rf_Prescan.h"
#endif /* DOXYGEN_EXCLUDE */

};


GRAD_PULSE gradx[GX_FREE] = {

  {G_TRAP,
     (int *) NULL,
     (int *) NULL,
     (int *) NULL,
     (FLOAT *)NULL,
     (FLOAT *) NULL,
     (FLOAT *)NULL,
     (FLOAT *)NULL,
     (char *)NULL,
     0,                   /* num */
     1.0,                 /* scale */
     (int *) NULL,        /* time */
     0.0,                 /* tdelta */
     1.0,                 /* powscale */
     0.0,                 /* power */
     0.0,                 /* powpos */
     0.0,                 /* powneg */
     0.0,                 /* powabs */
     0.0,                 /* amptran */
     0,                   /* pwm time */
     0,                   /* bridge */
     0.0}

}; /* gradx */




GRAD_PULSE grady[GY_FREE] = {

   {G_TRAP,
     (int *) NULL,
     (int *) NULL,
     (int *) NULL,
     (FLOAT *)NULL,
     (FLOAT *) NULL,
     (FLOAT *)NULL,
     (FLOAT *)NULL,
     (char *)NULL,
     0,                   /* num */
     1.0,                 /* scale */
     (int *) NULL,        /* time */
     0.0,                 /* tdelta */
     1.0,                 /* powscale */
     0.0,                 /* power */
     0.0,                 /* powpos */
     0.0,                 /* powneg */
     0.0,                 /* powabs */
     0.0,                 /* amptran */
     0,                   /* pwm time */
     0,                   /* bridge */
     0.0}

}; /* grady */


GRAD_PULSE gradz[GZ_FREE] = {

  {G_TRAP,
     (int *) NULL,
     (int *) NULL,
     (int *) NULL,
     (FLOAT *)NULL,
     (FLOAT *) NULL,
     (FLOAT *)NULL,
     (FLOAT *)NULL,
     (char *)NULL,
     0,                   /* num */
     1.0,                 /* scale */
     (int *) NULL,        /* time */
     0.0,                 /* tdelta */
     1.0,                 /* powscale */
     0.0,                 /* power */
     0.0,                 /* powpos */
     0.0,                 /* powneg */
     0.0,                 /* powabs */
     0.0,                 /* amptran */
     0,                   /* pwm time */
     0,                   /* bridge */
     0.0}               /* SGD */

}; /* gradz */


#endif  /* grad_rf_empty_INCL */
