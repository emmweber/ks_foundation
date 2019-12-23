/******************************************************************************************************
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename	: grad_rf_empty.globals.h
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
* @file grad_rf_empty.globals.h
* @brief This file sets up SLOT numbers from 0-19, sets RF_FREE1 to 20 (KS_MAXUNIQUERF) and includes
         `rf_Prescan.globals.h`, which will define SLOT numbers for Prescan and sets RF_FREE
********************************************************************************************************/


#ifndef  grad_rf_empty_globals_INCL
#define  grad_rf_empty_globals_INCL

#define KSRF00_SLOT 0
#define KSRF01_SLOT 1
#define KSRF02_SLOT 2
#define KSRF03_SLOT 3
#define KSRF04_SLOT 4
#define KSRF05_SLOT 5
#define KSRF06_SLOT 6
#define KSRF07_SLOT 7
#define KSRF08_SLOT 8
#define KSRF09_SLOT 9
#define KSRF10_SLOT 10
#define KSRF11_SLOT 11
#define KSRF12_SLOT 12
#define KSRF13_SLOT 13
#define KSRF14_SLOT 14
#define KSRF15_SLOT 15
#define KSRF16_SLOT 16
#define KSRF17_SLOT 17
#define KSRF18_SLOT 18
#define KSRF19_SLOT 19
/* see KSFoundation.h: KS_MAXUNIQUE_RF 20, which must match the # of KSRFxx_SLOT */
#define RF_FREE1 20
/* alternative with Sat Support:
#define RFSX1_SLOT 20
#define RFSX2_SLOT 21
#define RFSY1_SLOT 22
#define RFSY2_SLOT 23
#define RFSZ1_SLOT 24
#define RFSZ2_SLOT 25
#define RFSE1_SLOT 26
#define RFSE2_SLOT 27
#define RFSE3_SLOT 28
#define RFSE4_SLOT 29
#define RFSE5_SLOT 30
#define RFSE6_SLOT 31
#define RF_FREE1 32
*/
#define GX_FREE 1
#define GY_FREE 1
#define GZ_FREE 1

#include "rf_Prescan.globals.h"

#endif /* grad_rf_empty_globals_INCL */
