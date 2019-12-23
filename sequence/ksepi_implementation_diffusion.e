/******************************************************************************************************
 * Neuro MR Physics group
 * Department of Neuroradiology
 * Karolinska University Hospital
 * Stockholm, Sweden
 *
 * Filename : ksepi_implementation_diffusion.e
 *
 * Authors  : Stefan Skare, Enrico Avventi, Henric Rydén, Ola Norbeck, Tim Sprenger, Johan Berglund
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
* @file ksepi_implementation_diffusion.e
* @brief This file contains the implementation details for the diffusion part of the *ksepi* psd
********************************************************************************************************/


@global

/* allow 1024 image volumes per scan */
#define MAX_DIFSCHEME_LENGTH 1024
typedef float DIFFSCHEME[3][MAX_DIFSCHEME_LENGTH];

/* emmweber --- second gradient orientation --> second diffusion scheme  */
/*typedef float DIFFSCHEME_2[3][MAX_DIFSCHEME_LENGTH];*/

typedef enum {
  OFFLINE_DIFFRETURN_ALL = 0, 
  OFFLINE_DIFFRETURN_ACQUIRED = 1,
  OFFLINE_DIFFRETURN_B0 = 2,
  OFFLINE_DIFFRETURN_MEANDWI = 4,
  OFFLINE_DIFFRETURN_MEANADC = 8,
  OFFLINE_DIFFRETURN_EXPATT = 16,
  OFFLINE_DIFFRETURN_FA = 32,
  OFFLINE_DIFFRETURN_CFA = 64,
} OFFLINE_DIFFRETURN_MODE;






@cv
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation_diffusion.e: CVs (modifiable on HOST, readable on TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/
int ksepi_diffusion_ramptime = 1500 with {300, 30ms, 1500, VIS, "Ramp times for diffusion gradients", };
float ksepi_diffusion_maxamp = 0.0 with {0.0, 7.0, 3.0, VIS, "Cap for diffusion gradient amplitude", };
float ksepi_diffusion_amp = 0.0 with {0.0, 7.0, 0.0, VIS, "View-only: Current diffusion gradient amplitude", };
int ksepi_diffusion_echotime = 0 with {0, , 0, VIS, "View-only: Echo time necessary to meet the desired b-value", };
float ksepi_diffusion_2ndcrushfact = 2.0 with {0.1, 10.0, 2.0, VIS, "Scale factor for 2nd crusher for opdualspinecho",};
int ksepi_diffusion_returnmode = OFFLINE_DIFFRETURN_ALL with {OFFLINE_DIFFRETURN_ALL, 128, OFFLINE_DIFFRETURN_ALL, VIS, "Diff maps All:0 Acq:1 b0:2 DWI:4 ADC:8 Exp:16 FA:32 cFA:64",};

@ipgexport
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation_diffusion.e: IPG Export (accessible on HOST and TGT)
 *
 *******************************************************************************************************
 *******************************************************************************************************/

DIFFSCHEME diffscheme;
DIFFSCHEME diffscheme_2;
int ndiffdirs = 6;



@host
/*******************************************************************************************************
 *******************************************************************************************************
 *
 *  ksepi_implementation_diffusion.e: Host functions
 *
 *******************************************************************************************************
 *******************************************************************************************************/


STATUS ksepi_diffusion_readtensorfile(DIFFSCHEME diffscheme, DIFFSCHEME diffscheme_2, int nb0, int ndirs) {
    int i;
    FILE *fp; 
    
    char tmpstr[1000];
    int lineskip = TRUE;
    char matchstr[10];
    int matchlen;

    /*emmweber ----*/
    FILE *fp2;
    char tmpstr2[1000];
    int lineskip2 = TRUE;
    char matchstr2[10];
    int matchlen2;
    /*-------*/

/* 1st ---------- tensor*/
#ifdef PSD_HW
    char *tensorfile = "/usr/g/research/emmweber/tensor1.dat";
    char *tensorfile2 = "/usr/g/research/emmweber/tensor2.dat";
#else
    char *tensorfile = "./tensor1.dat";
    char *tensorfile2 = "./tensor2.dat";
#endif

    if (nb0 < 0) {
        return ks_error("# T2 (b0) images must be > 0");
    }

    if (ndirs < 6 || ndirs > 150) {
        return ks_error("# diff. directions must be in range [6,150]");
    }

    /* clear table */
    for (i = 0; i < MAX_DIFSCHEME_LENGTH; i++) {
        diffscheme[XGRAD][i] = diffscheme[YGRAD][i] = diffscheme[ZGRAD][i] = 0.0;

    }


    /* read from tensor.dat */

    if ((fp = fopen(tensorfile, "r" )) == NULL) {
        return ks_error("%s: Could not open file: %s", __FUNCTION__, tensorfile);
    }

    /* what to line content look for in the file */
    sprintf(matchstr, "%d", ndirs);
    matchlen = strlen(matchstr);

    while (lineskip) {
        fgets(tmpstr, 1000, fp);
        lineskip = strncmp(matchstr, tmpstr, matchlen);
    }

    for (i = 0; i < ndirs; i++) {
        if (fgets(tmpstr, 1000, fp) == NULL) {
            ks_error("%s: Error reading file: %s for #dirs = %d, direction %d", __FUNCTION__, tensorfile, ndirs, i);
        }
        sscanf(tmpstr, "%f %f %f", &diffscheme[XGRAD][nb0 + i], &diffscheme[YGRAD][nb0 + i], &diffscheme[ZGRAD][nb0 + i]);
                       
    }

    fclose(fp);

/*emmweber ----- read from tensor2.dat------*/



 /* clear table */
    for (i = 0; i < MAX_DIFSCHEME_LENGTH; i++) {
        diffscheme_2[XGRAD][i] = diffscheme_2[YGRAD][i] = diffscheme_2[ZGRAD][i] = 0.0;

    }


     if ((fp2 = fopen(tensorfile2, "r" )) == NULL) {
        return ks_error("%s: Could not open file: %s", __FUNCTION__, tensorfile2);
    }

    /* what to line content look for in the file */
    sprintf(matchstr2, "%d", ndirs);
    matchlen2 = strlen(matchstr2);

    while (lineskip2) {
        fgets(tmpstr2, 1000, fp2);
        lineskip2 = strncmp(matchstr2, tmpstr2, matchlen2);
    }

    for (i = 0; i < ndirs; i++) {
        if (fgets(tmpstr2, 1000, fp2) == NULL) {
            ks_error("%s: Error reading file: %s for #dirs = %d, direction %d", __FUNCTION__, tensorfile2, ndirs, i);
        }
        sscanf(tmpstr2, "%f %f %f", &diffscheme_2[XGRAD][nb0 + i], &diffscheme_2[YGRAD][nb0 + i], &diffscheme_2[ZGRAD][nb0 + i]);
                       
    }

    fclose(fp2);

    return SUCCESS;
}
/*-------------------------*/


float ksepi_diffusion_getmaxb() {
   float maxb = 0.0;
#ifdef PSD_HW
    int i;
    /* On the MR scanner, opval should be set to the highest bvalue in the bvalstab list */
    for (i = 0; i < opnumbvals; i++) {
        if (bvalstab[i] > maxb) {
            maxb = bvalstab[i];
        }
    }
#else
    maxb = opbval;
#endif    

    return maxb;
}


STATUS ksepi_diffusion_init_UI() {
    int i;

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return SUCCESS;
    }

    /* Number of b-values menu (opnumbvals) */
    pinumbnub = 63;
    pinumbval2 = 1;
    pinumbval3 = 2;
    pinumbval4 = 3;
    pinumbval5 = 4;
    pinumbval6 = 5;

    cvmax(opbval, 30000);
    cvdef(opbval, 1000);
    opbval = _opbval.defval;

    /* b-value table menu */
    pibvalstab = 1; /* show bvalue table */
    if (existcv(opnumbvals) == FALSE) {
        /* until number of b-value has been selected, set up a range of b-values */
        for (i = 0; i < 10; i++)
            bvalstab[i] = 1000 + 500 * i;
    }

    avminbvalstab = 10;
    avmaxbvalstab = 20000;

    pidifnextab = 1; /* show NEX input in table, but only allow 1 */
    avmindifnextab = 1;
    avmaxdifnextab = 1;

    /* Hide number of NEX for T2 menu (opdifnext2) */
    pidifnext2nub = 0;
    avmindifnext2 = 1;
    avmaxdifnext2 = 1;
    cvoverride(opdifnext2, 1, PSD_FIX_ON, PSD_EXIST_ON);
    cvoverride(rhdifnext2, 1, PSD_FIX_ON, PSD_EXIST_ON);


    /* Number of T2 menu (opdifnumt2) */
    pidifnumt2defval = 1;
    cvdef(opdifnumt2, pidifnumt2defval);
    opdifnumt2 = pidifnumt2defval;
    pidifnumt2nub = 15;
    pidifnumt2val2 = 1;
    pidifnumt2val3 = 2;
    pidifnumt2val4 = 3;

    /* Number of diffusion directions menu (opdifnumdirs) */
    pidifnumdirsnub = 15;
    pidifnumdirsdefval = 6;     
    pidifnumdirsval2 = 6;
    pidifnumdirsval3 = 15;
    pidifnumdirsval4 = 25;

#if EPIC_RELEASE >= 26
    /* no synthetic bvalues menu */
    pinumsynbnub = 0;
#endif

    /* Only allow MinTE (i.e. partial Fourier ky) or MinFullTE */
    pitetype = PSD_LABEL_TE_EFF; /* alt. PSD_LABEL_TE_EFF */
    cvdef(opte, 200ms);
    opte = _opte.defval;
    pite1nub = 6;
    pite1val2 = PSD_MINIMUMTE;
    pite1val3 = PSD_MINFULLTE;

    /* Upsample DWI data to nearest power of 2 */
    ksepi_imsize = KS_IMSIZE_POW2;

    /* show shots 1-5 */
    pishotval2 = 1;
    pishotval3 = 2;
    pishotval4 = 3;
    pishotval5 = 4;
    pishotval6 = 5;
    cvdef(opnshots, 3);
    opnshots = _opnshots.defval;


    /* Don't allow multiple acqs for DW-EPI */
    pitrnub = 2; /* Minimum */
    pitrval2 = PSD_MINIMUMTR;
    piisil = PSD_OFF;

    /* Optimize TE / super G check box */
#if EPIC_RELEASE >= 27    
    pimintediflabel = HAVE_PREMIER_GRADIENTS; /* Label indicator: 0 - Optimize TE, 1 - Super G */
    pimintedifvis = HAVE_PREMIER_GRADIENTS; /* Visibility of the "Optimize TE"/"Super G" button : 0 - invisible, 1 - visible */
#endif

    /* Max diffusion amplitude to work with [G/cm] (based on trial and error) */
    if (HAVE_PREMIER_GRADIENTS) {
        if (opmintedif) { 

            ks_gheatfact = 0.18; /* Obey gradient heating a little bit (increases TR). 0.18 may not be optimal for all cases */

            /* 70 mT/m with longer TR */
            _ksepi_diffusion_maxamp.defval = FMin(3, phygrd.xfs, phygrd.yfs, phygrd.zfs);

        } else {

            /* b=1200 is quite arbitrary, but b=3000 needs for sure longer TR 
            b <= 1200: Don't obey gradient heating to keep TR minimal (as default in GERequired.e) */
            ks_gheatfact = (ksepi_diffusion_getmaxb() > 1200) ? 0.16 : 0;

            /* without increasing min TR for b < 1500, max diff amp seems to be ~50 mT/m (~70%) */
            _ksepi_diffusion_maxamp.defval = 0.70 * FMin(3, phygrd.xfs, phygrd.yfs, phygrd.zfs);
            
        }
    } else {
        /* by default, use 85% of physical max to allow for angled slices */
        _ksepi_diffusion_maxamp.defval = 0.85 * FMin(3, phygrd.xfs, phygrd.yfs, phygrd.zfs);
    }
    ksepi_diffusion_maxamp = _ksepi_diffusion_maxamp.defval;


    return SUCCESS;
}





STATUS ksepi_diffusion_eval_UI() {
    int i, b, j;
    STATUS status;
    DIFFSCHEME diffscheme_norm1;

    /*emmweber----*/
    DIFFSCHEME diffscheme_norm2;
    /*------*/

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return SUCCESS;
    }


    /* clear diffusion scheme table */
    for (i = 0; i < MAX_DIFSCHEME_LENGTH; i++) {
        diffscheme[0][i] = diffscheme[1][i] = diffscheme[2][i] = 0.0;
        diffscheme_norm1[0][i] = diffscheme_norm1[1][i] = diffscheme_norm1[2][i] = 0.0;
/* emmweber ----------------*/
        diffscheme_2[0][i] = diffscheme_2[1][i] = diffscheme_2[2][i] = 0.0;
        diffscheme_norm2[0][i] = diffscheme_norm2[1][i] = diffscheme_norm2[2][i] = 0.0;
        /*--------------------------------*/
    }

#ifdef PSD_HW
    {
        float maxb = ksepi_diffusion_getmaxb();
        if (existcv(opnumbvals) && maxb > 0) {
            opbval = maxb;
        }
    }
#else
    /* In SIM (WTools), we let opbval set bvalstab[] since we are in simulation and can't access bvalstab[] in EvalTool
       If opnumbvals > 1, we make the bvalstab[] a linearly increasing function of opbval with
       bvalstab[opnumbvals-1] = opbval */
    for (i = 0; i < opnumbvals; i++) {
       bvalstab[i] = (i + 1.0) / ((float) opnumbvals) * opbval;
    }
#endif

    /* Diffusion direction menu */
    pidifrecnub = FALSE; /* but on for opdfaxall */
    cvmax(opdifnumdirs, MAX_DIFSCHEME_LENGTH);


    if (opdfaxall) {
        pidifrecnub = TRUE;
        ndiffdirs = 3;

        for (i = 0; i < ndiffdirs; i++) {
            diffscheme[i][opdifnumt2 + i] = 1; /* X, Y, Z */
            /*  emmweber ------  */
            diffscheme_2[i][opdifnumt2 + i] = 1; /* X, Y, Z */
            /*------------------------------*/
        }

    } else if (opdfax3in1) {

        return ks_error("%s: 3in1 is not yet supported", __FUNCTION__);

    } else if (opdfaxtetra) {

        return ks_error("%s: TETRA is not yet supported", __FUNCTION__);

    } else if (optensor) {

        if (existcv(opdifnumdirs)) {
            /* we need to rely on number of diffusion directions via 'ndiffdirs' instead of opdifnumdirs (which is
            the value given by the menu) at a time when opdifnumdirs' existflag is set. Later in ksepi_diffusion_predownload_setrecon(),
            if we are doing optensor with multiple b-values, we need to change opdifnumdirs to = opnumbvals * ndiffdirs, and
            at the same time unset the existflag of opdifnumdirs.
            This, since GE does not yet support multi-bvalues for optensor mode, and because the integrated ref scan recon of the
            DTI data unfortunately checks for opdifnumdirs instead of rhnumdifdirs.
            Here, we MUST here check for the existance of opdifnumdirs to avoid recursion when cveval() (and this function) is executed
            after predownload before scanning. */
            ndiffdirs = opdifnumdirs;
        }

        /* avoid problems if ndiffdirs = 0 before #directions has been chosen by setting it to 6 */
        if (ndiffdirs == 0)
            ndiffdirs = 6;

        status = ksepi_diffusion_readtensorfile(diffscheme, diffscheme_2, opdifnumt2, ndiffdirs);

        if (status != SUCCESS) return status;

    } else {
        ndiffdirs = 1;

        /* One diffusion direction (default if none of above matches) */
        /* cvoverride(opdifnumdirs, 1, PSD_FIX_OFF, PSD_EXIST_ON); */
        diffscheme[XGRAD][opdifnumt2] = (opdfaxx != 0);
        diffscheme[YGRAD][opdifnumt2] = (opdfaxy != 0);
        diffscheme[ZGRAD][opdifnumt2] = (opdfaxz != 0);

        /* if no opXXX CVs have been set yet (on MR scanner as the PSD loads), default to one direction in Z */
        if (!existcv(opdfaxx) && !existcv(opdfaxy) && !existcv(opdfaxz))
            diffscheme[ZGRAD][opdifnumt2] = 1;

    }


    /* make sure all diffusion directions are normalized */
    for (i = 0; i < ndiffdirs; i++) {
        float dnorm = sqrt(
                          diffscheme[XGRAD][opdifnumt2 + i] * diffscheme[XGRAD][opdifnumt2 + i] +
                          diffscheme[YGRAD][opdifnumt2 + i] * diffscheme[YGRAD][opdifnumt2 + i] +
                          diffscheme[ZGRAD][opdifnumt2 + i] * diffscheme[ZGRAD][opdifnumt2 + i]);

        /*emmweber ---- PB with B0 directly inserted in the tensor file */
        
        
        if (dnorm <= 0.000001) {
            /*return ks_error("%s: A diffusion direction has zero norm", __FUNCTION__);*/
            dnorm =1;
        }

        diffscheme_norm1[XGRAD][opdifnumt2 + i] = diffscheme[XGRAD][opdifnumt2 + i] / dnorm;
        diffscheme_norm1[YGRAD][opdifnumt2 + i] = diffscheme[YGRAD][opdifnumt2 + i] / dnorm;
        diffscheme_norm1[ZGRAD][opdifnumt2 + i] = diffscheme[ZGRAD][opdifnumt2 + i] / dnorm;

        /*emmweber tensor 2*/
        if (num_oscillations>0){

            float dnorm2 = sqrt(
                          diffscheme_2[XGRAD][opdifnumt2 + i] * diffscheme_2[XGRAD][opdifnumt2 + i] +
                          diffscheme_2[YGRAD][opdifnumt2 + i] * diffscheme_2[YGRAD][opdifnumt2 + i] +
                          diffscheme_2[ZGRAD][opdifnumt2 + i] * diffscheme_2[ZGRAD][opdifnumt2 + i]);

         if (dnorm2 <= 0.000001) {
            /*return ks_error("%s: A diffusion direction has zero norm", __FUNCTION__);*/
            dnorm2 =1;
          }
            diffscheme_norm2[XGRAD][opdifnumt2 + i] = diffscheme_2[XGRAD][opdifnumt2 + i] / dnorm2;
            diffscheme_norm2[YGRAD][opdifnumt2 + i] = diffscheme_2[YGRAD][opdifnumt2 + i] / dnorm2;
            diffscheme_norm2[ZGRAD][opdifnumt2 + i] = diffscheme_2[ZGRAD][opdifnumt2 + i] / dnorm2;
             
        }

        
    }

    /* repeat and scale diffusion scheme for multiple b-values */
    for (b = 0; b < opnumbvals; b++) {
        /* The square-root of the b-value ratio is used to scale the diffusion gradients across b-values */
        float gscale = pow( (float) bvalstab[b] / (float) opbval, 0.5);

        
         for (i = 0; i < ndiffdirs; i++) {
            j = i + b * ndiffdirs;
            diffscheme[XGRAD][opdifnumt2 + j] = diffscheme_norm1[XGRAD][opdifnumt2 + i] * gscale;
            diffscheme[YGRAD][opdifnumt2 + j] = diffscheme_norm1[YGRAD][opdifnumt2 + i] * gscale;
            diffscheme[ZGRAD][opdifnumt2 + j] = diffscheme_norm1[ZGRAD][opdifnumt2 + i] * gscale;

            /* emmweber ----- DDE second tensor*/
            if (num_oscillations>0){
            diffscheme_2[XGRAD][opdifnumt2 + j] = diffscheme_norm2[XGRAD][opdifnumt2 + i] * gscale;
            diffscheme_2[YGRAD][opdifnumt2 + j] = diffscheme_norm2[YGRAD][opdifnumt2 + i] * gscale;
            diffscheme_2[ZGRAD][opdifnumt2 + j] = diffscheme_norm2[ZGRAD][opdifnumt2 + i] * gscale;
            }
            /*-------------------------------------*/
          }
    }

    /* Save number of volumes total in opfphases based on the length of the diffusion scheme.
       Need to do this here, before we reach predownload() as opfphases is used as an input argument
       to GEReq_predownload_setrecon_epi()->GEReq_predownload_setrecon_voldata(). */
       opfphases = opdifnumt2 + opnumbvals * ndiffdirs;


    /* write diffusion scheme out for debugging */
    {
        FILE *fp;
#ifdef PSD_HW
        fp = fopen("/usr/g/mrraw/diffusionscheme.txt", "w");
#else
        fp = fopen("./diffusionscheme.txt", "w");
#endif
        fprintf(fp, "Max b-value (opbval): %d s/mm^2\n\n", opbval);
        fprintf(fp, "b-values:\n");
        for (i = 0; i < opnumbvals; i++) {
            float gscale = pow( (float) bvalstab[i] / (float) opbval, 0.5);
            fprintf(fp, "%.1f %.2f\n", bvalstab[i], gscale);
        }
        fprintf(fp, "\n");
        for (i = 0; i < opfphases; i++) {
            fprintf(fp, "%f\t%f\t%f\n", diffscheme[XGRAD][i], diffscheme[YGRAD][i], diffscheme[ZGRAD][i]);
        }
/*emmweber----------------------------------------*/
        if (num_oscillations>0){
            fprintf(fp, "Max b-value (opbval): %d s/mm^2\n\n", opbval);
            fprintf(fp, "b-values:\n");
            for (i = 0; i < opnumbvals; i++) {
                float gscale = pow( (float) bvalstab[i] / (float) opbval, 0.5);
            fprintf(fp, "%.1f %.2f\n", bvalstab[i], gscale);
            }
            fprintf(fp, "\n");
            fprintf(fp, "second diffusion scheme: \n");
            for (i = 0; i < opfphases; i++) {
            fprintf(fp, "%f\t%f\t%f\n", diffscheme_2[XGRAD][i], diffscheme_2[YGRAD][i], diffscheme_2[ZGRAD][i]);
             }
        }
        fclose(fp);
    }

    return SUCCESS;

  

/*------------------------------------------*/
}




void SolveCubic(double  a,         /* coefficient of x^3 */
        double  b,         /* coefficient of x^2 */
        double  c,         /* coefficient of x   */
        double  d,         /* constant term      */
        int    *nsol, /* # of distinct solutions */
        double *x)         /* array of solutions      */
{
  double    a1 = b/a, a2 = c/a, a3 = d/a;
  double    Q = (a1*a1 - 3.0*a2)/9.0;
  double    R = (2.0*a1*a1*a1 - 9.0*a1*a2 + 27.0*a3)/54.0;
  double    R2_Q3 = R*R - Q*Q*Q;
  double    theta;

  if (R2_Q3 <= 0){
    *nsol = 3;
    theta = acos(R/sqrt(Q*Q*Q));
    x[0] = -2.0 * sqrt(Q) * cos( theta/3.0) - a1/3.0;
    x[1] = -2.0 * sqrt(Q) * cos( (theta+2.0*PI)/3.0) - a1/3.0;
    x[2] = -2.0 * sqrt(Q) * cos( (theta+4.0*PI)/3.0) - a1/3.0;
  } else {
    *nsol = 1;
    x[0] = pow( sqrt(R2_Q3) + fabs(R), 1/3.0);
    x[0] += Q/x[0];
    x[0] *= (R < 0.0) ? 1 : -1;
    x[0] -= a1/3.0;
  }

}





STATUS ksepi_diffusion_calcTE(double *TE_s, int exciso2end /* [us] */, int crsh1_half180 /* [us] */, int half180_crsh2 /* [us] */, int crsh3_half180 /* [us] */,
                              int half180_crsh4 /* [us] */, int readout2echo /* [us] */, int ramptime /* [us] */, float G /* [G/cm] */, int bval_desired /* [s/mm^2] */, int dualspinechoflag) {
    double exciso2end_s    = 1.0E-6 * RUP_GRD(exciso2end); /* [s] */
    double crsh1_half180_s = 1.0E-6 * RUP_GRD(crsh1_half180); /* [s] */
    double half180_crsh2_s = 1.0E-6 * RUP_GRD(half180_crsh2); /* [s] */
    double crsh3_half180_s = 1.0E-6 * RUP_GRD(crsh3_half180); /* [s] */
    double half180_crsh4_s = 1.0E-6 * RUP_GRD(half180_crsh4); /* [s] */
    double readout2echo_s  = 1.0E-6 * RUP_GRD(readout2echo); /* [s] */
    double ramptime_s      = 1.0E-6 * RUP_GRD(ramptime); /* [s] */
    double fixedtime_s;
    double gam_SI = (2 * PI * 42.58E6); /* [rad/(sT)] */
    double G_SI = G / 100.0; /* [G/cm] -> [T/m] */
    double sol[3];
    int nsol;
    double c0, c1, c2, c3, c0new;

    /* all double variables are in SI units (see genbvalcode.m for details on c0-c3 below) */

    if (dualspinechoflag) { /* 2x180 */

        fixedtime_s = FMax(2, exciso2end_s + crsh1_half180_s, half180_crsh4_s + readout2echo_s) + 2.0 * ramptime_s;

        c3 = 1.0 / 1.2E1;

        c2 = crsh3_half180_s * (-3.0 / 1.6E1) - exciso2end_s * (1.0 / 1.6E1) - fixedtime_s * (7.0 / 1.6E1) - half180_crsh2_s * (3.0 / 1.6E1) + half180_crsh4_s * (1.0 / 1.6E1) + ramptime_s * (1.0 / 4.0);

        c1 = crsh3_half180_s * fixedtime_s * (1.0 / 2.0) + crsh3_half180_s * half180_crsh2_s * (1.0 / 2.0) + exciso2end_s * fixedtime_s * (1.0 / 2.0) + fixedtime_s * half180_crsh2_s * (1.0 / 2.0) - fixedtime_s * half180_crsh4_s * (1.0 / 2.0) -
             exciso2end_s * ramptime_s * (1.0 / 2.0) - fixedtime_s * ramptime_s * (1.0 / 2.0) + half180_crsh4_s * ramptime_s * (1.0 / 2.0) + (crsh3_half180_s * crsh3_half180_s) * (1.0 / 4.0) + (fixedtime_s * fixedtime_s) * (1.0 / 2.0) +
             (half180_crsh2_s * half180_crsh2_s) * (1.0 / 4.0) - (ramptime_s * ramptime_s) * (1.0 / 1.2E1);

        c0 = (crsh3_half180_s * crsh3_half180_s) * fixedtime_s * (-1.0 / 2.0) - crsh3_half180_s * (half180_crsh2_s * half180_crsh2_s) * (1.0 / 4.0) - (crsh3_half180_s * crsh3_half180_s) * half180_crsh2_s * (1.0 / 4.0) - exciso2end_s * (fixedtime_s * fixedtime_s) -
             fixedtime_s * (half180_crsh2_s * half180_crsh2_s) * (1.0 / 2.0) + (fixedtime_s * fixedtime_s) * half180_crsh4_s + crsh3_half180_s * (ramptime_s * ramptime_s) * (1.3E1 / 1.2E1) + (crsh3_half180_s * crsh3_half180_s) * ramptime_s * (1.0 / 4.0) -
             exciso2end_s * (ramptime_s * ramptime_s) + fixedtime_s * (ramptime_s * ramptime_s) * (7.0 / 6.0) - (fixedtime_s * fixedtime_s) * ramptime_s + half180_crsh2_s * (ramptime_s * ramptime_s) * (1.3E1 / 1.2E1) + (half180_crsh2_s * half180_crsh2_s) * ramptime_s * (1.0 / 4.0) +
             half180_crsh4_s * (ramptime_s * ramptime_s) - (crsh3_half180_s * crsh3_half180_s * crsh3_half180_s) * (1.0 / 1.2E1) + (fixedtime_s * fixedtime_s * fixedtime_s) * (1.0 / 3.0) - (half180_crsh2_s * half180_crsh2_s * half180_crsh2_s) * (1.0 / 1.2E1) +
             (ramptime_s * ramptime_s * ramptime_s) * (1.0 / 1.5E1) - crsh3_half180_s * fixedtime_s * half180_crsh2_s - crsh3_half180_s * fixedtime_s * ramptime_s + crsh3_half180_s * half180_crsh2_s * ramptime_s * (1.0 / 2.0) + exciso2end_s * fixedtime_s * ramptime_s * 2.0 -
             fixedtime_s * half180_crsh2_s * ramptime_s - fixedtime_s * half180_crsh4_s * ramptime_s * 2.0;

    } else { /* 1x180 */

        fixedtime_s = FMax(2, exciso2end_s + crsh1_half180_s, half180_crsh2_s + readout2echo_s) + 2.0 * ramptime_s;

        c3 = 1.0 / 12.0;

        c2 = -(exciso2end_s + fixedtime_s - half180_crsh2_s - ramptime_s) / 4.0;

        c1 = exciso2end_s * fixedtime_s - fixedtime_s * half180_crsh2_s - exciso2end_s * ramptime_s + half180_crsh2_s * ramptime_s - ramptime_s * ramptime_s / 12.0;

        c0 = (fixedtime_s * fixedtime_s) * half180_crsh2_s - exciso2end_s * (fixedtime_s * fixedtime_s) - exciso2end_s * (ramptime_s * ramptime_s) +
             (7 * fixedtime_s * (ramptime_s * ramptime_s)) / 6 - (fixedtime_s * fixedtime_s) * ramptime_s + half180_crsh2_s * (ramptime_s * ramptime_s) +
             (fixedtime_s * fixedtime_s * fixedtime_s) / 3 - (7 * (ramptime_s * ramptime_s * ramptime_s)) / 15 + 2 * exciso2end_s * fixedtime_s * ramptime_s - 2 * fixedtime_s * half180_crsh2_s * ramptime_s;

    }

    /* bval = 1.0E-6 * gam_SI * gam_SI * G_SI * G_SI * (c3 * pow(TE_s, 3.0) + c2 * pow(TE_s, 2.0) + c1 * TE_s + c0);  leading 1.0E-6 makes bval in s/mm^2 (e.g. b = 1000)
        where
            double gam_SI = (2 * PI * 42.58E6); [rad/(sT)]
            double G_SI = G [G/cm] / 100.0; [T/m]

        b(TE_s) = 1.0E-6 * gam_SI * gam_SI * G_SI * G_SI * (c3 * pow(TE_s, 3.0) + c2 * pow(TE_s, 2.0) + c1 * TE_s + c0);  [s/mm^2]
        desired b-value: bval_desired; [s/mm^2]
        F(TE_s) = b(TE_s) - bval_desired
        Find TE_s that gives F(TE_s) = 0   => TE_s that will yield the correct b-value
        F(TE_s) = 1.0E-6 * gam_SI * gam_SI * G_SI * G_SI * (c3 * pow(TE_s, 3.0) + c2 * pow(TE_s, 2.0) + c1 * TE_s + c0) - bval_desired = 0
        =>
        F(TE_s) = 1.0E-6 * gam_SI * gam_SI * G_SI * G_SI * (c3 * pow(TE_s, 3.0) + c2 * pow(TE_s, 2.0) + c1 * TE_s + (c0 - bval_desired/(1.0E-6 * gam_SI * gam_SI * G_SI * G_SI)))
        => [divide leading factors and make a new c0new = c0 - bval_desired/(1.0E-6 * gam_SI * gam_SI * G_SI * G_SI)
        Fnew(TE_s) = c3 * pow(TE_s, 3.0) + c2 * pow(TE_s, 2.0) + c1 * TE_s + c0new
        Put in c3, c2, c1, c0new into SolveCubic function to get TE_s where F(TE_s) = 0
    */
    c0new = c0 - (double) bval_desired / (1.0E-6 * gam_SI * gam_SI * G_SI * G_SI);

    /* Solve cubic function in TE */
    SolveCubic(c3, c2, c1, c0new, &nsol, sol);

    if (nsol == 3)
        *TE_s = FMax(3, sol[0], sol[1], sol[2]);
    else
        *TE_s = sol[0];


    return SUCCESS;
}













STATUS ksepi_diffusion_eval_gradients_TE(KSEPI_SEQUENCE *ksepi) {
    double TE_s;
    int exciso2end    = ksepi->selrfexc.rf.iso2end + KS_RFSSP_POSTTIME + ksepi->selrfexc.grad.ramptime + ksepi->selrfexc.postgrad.duration; /* RF excitation isocenter to end of exc rephaser [us] */
    int crsh1_half180 = ksepi->selrfref.pregrad.duration + KS_RFSSP_PRETIME + ksepi->selrfref.grad.ramptime + ksepi->selrfref.rf.start2iso; /* left crusher start to RF isocenter of 1st/only 180 [us] */
    int half180_crsh2 = ksepi->selrfref.rf.iso2end + ksepi->selrfref.grad.ramptime + KS_RFSSP_POSTTIME + ksepi->selrfref.postgrad.duration; /*  RF isocenter to end of right crusher of 1st/only 180 [us] */
    int crsh3_half180 = 0; /* left crusher start to RF isocenter of 2nd 180 (opdualspinecho only) [us] */
    int half180_crsh4 = 0; /* RF isocenter to end of right crusher of 2nd 180 (opdualspinecho only) [us] */
    int fixedtime = 0;
    int bvalue_validated = FALSE;
    int remaining_attempts = 30;

    /* Clear both trap objects */
    ks_init_trap(&ksepi->diffgrad);
    ks_init_trap(&ksepi->diffgrad2);

    if (ksepi_reflines > 0) {
        exciso2end += ksepi->epireftrain.duration;
    }

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return SUCCESS;
    }

    /* Diffusion amplitude to start out with [G/cm]. May decrease if b-value very small */
    _ksepi_diffusion_amp.fixedflag = 0;
    ksepi_diffusion_amp = ksepi_diffusion_maxamp;

    /* Round the diffusion ramp time to nearest 4 us */
    cvoverride(ksepi_diffusion_ramptime, RUP_GRD(ksepi_diffusion_ramptime), _ksepi_diffusion_ramptime.fixedflag, _ksepi_diffusion_ramptime.existflag);

    if (opdualspinecho) {
        crsh3_half180 = ksepi->selrfref2.pregrad.duration + KS_RFSSP_PRETIME + ksepi->selrfref2.grad.ramptime + ksepi->selrfref2.rf.start2iso;
        half180_crsh4 = ksepi->selrfref2.rf.iso2end + ksepi->selrfref2.grad.ramptime + KS_RFSSP_POSTTIME + ksepi->selrfref2.postgrad.duration;
        fixedtime = IMax(2, exciso2end + crsh1_half180, half180_crsh4 + ksepi->pre_delay.duration + ksepi->epitrain.time2center) + 2 * ksepi_diffusion_ramptime;
    } if (num_oscillations>0){
        fixedtime = IMax(2, exciso2end + crsh1_half180, half180_crsh2 + ksepi->pre_delay.duration + ksepi->epitrain.time2center) + 2 * ksepi_diffusion_ramptime;

}else {
        fixedtime = IMax(2, exciso2end + crsh1_half180, half180_crsh2 + ksepi->pre_delay.duration + ksepi->epitrain.time2center) + 2 * ksepi_diffusion_ramptime;
    }
    fixedtime = RUP_GRD(fixedtime);



    while (bvalue_validated == FALSE) {

        if (ksepi_diffusion_calcTE(
            &TE_s, exciso2end /* [us] */, crsh1_half180 /* [us] */, half180_crsh2 /* [us] */, crsh3_half180 /* [us] */,
            half180_crsh4 /* [us] */,  ksepi->epitrain.time2center /* [us] */, ksepi_diffusion_ramptime /* [us] */,
            ksepi_diffusion_amp /* [G/cm] */, opbval /* [s/mm^2] */, opdualspinecho) == FAILURE) {
            return FAILURE;
        }

        /* Save the TE found to the CV for later verification. ksepi_diffusion_echotime in [us] */
        cvoverride(ksepi_diffusion_echotime, (TE_s * 1E6), PSD_FIX_OFF, PSD_EXIST_OFF);
        ksepi_diffusion_echotime = RUP_GRD(ksepi_diffusion_echotime);

        if (opdualspinecho) {
            /* Set diffusion plateau times based on found TE */
            ksepi->diffgrad.plateautime = RDN_GRD(ksepi_diffusion_echotime / 4 - fixedtime);
            ksepi->diffgrad2.plateautime = RDN_GRD((ksepi_diffusion_echotime / 2 - half180_crsh2 - crsh3_half180 - 4 * ksepi_diffusion_ramptime) / 2);

            if ((ksepi->diffgrad.plateautime >= (2 * GRAD_UPDATE_TIME)) && (ksepi->diffgrad2.plateautime >= (2 * GRAD_UPDATE_TIME))) {
                bvalue_validated = TRUE;
            }

            /* Build up the trap object(s) manually, now that we know the plateau time(s) */
            ksepi->diffgrad.amp  = ksepi_diffusion_amp; /* [G/cm] */
            ksepi->diffgrad2.amp = ksepi_diffusion_amp; /* [G/cm] */
            ksepi->diffgrad.ramptime  = ksepi_diffusion_ramptime;
            ksepi->diffgrad2.ramptime = ksepi_diffusion_ramptime;
            strcpy(ksepi->diffgrad.description,  "diffgrad1_4");
            strcpy(ksepi->diffgrad2.description, "diffgrad2_3");
        } 

        else if (num_oscillations>0){/*emmweber ---- DDE --- */
            /* Set diffusion plateau times based on found TE */

            /* emmweber test for adding two diff gradients ------------- */
           

            ksepi->mytrap_1.plateautime = RDN_GRD(ksepi_diffusion_echotime / 4 - fixedtime);
            ksepi->mytrap_2.plateautime = RDN_GRD(ksepi_diffusion_echotime / 4 - fixedtime);
            /*-------------------------*/

            if ((ksepi->mytrap_1.plateautime >= (2 * GRAD_UPDATE_TIME)) && (ksepi->mytrap_2.plateautime >= (2 * GRAD_UPDATE_TIME))) {
                bvalue_validated = TRUE;
            }

    

            /*emmweber ----- DDE------------*/
            ksepi->mytrap_1.amp = ksepi_diffusion_amp; /*[G/cm]*/
            ksepi->mytrap_1.ramptime = RUP_GRD(ksepi_diffusion_ramptime);
            strcpy(ksepi->mytrap_1.description,"DDE_1");

            ksepi->mytrap_2.amp = ksepi_diffusion_amp; /*[G/cm]*/
            ksepi->mytrap_2.ramptime = RUP_GRD(ksepi_diffusion_ramptime);
            strcpy(ksepi->mytrap_2.description,"DDE_2");
            /*-------------------------*/

        }

        else{
/*Stetskal --- */
            /* Set diffusion plateau times based on found TE */

             ksepi->diffgrad.plateautime = RDN_GRD(ksepi_diffusion_echotime / 2 - fixedtime);
           

            if (ksepi->diffgrad.plateautime >= (2 * GRAD_UPDATE_TIME)) {
                bvalue_validated = TRUE;
            }

            /* Build up the trap object(s) manually, now that we know the plateau time(s) */
            ksepi->diffgrad.amp = ksepi_diffusion_amp; /* [G/cm] */
            ksepi->diffgrad.ramptime = RUP_GRD(ksepi_diffusion_ramptime);
            strcpy(ksepi->diffgrad.description,  "diffgrad");

        }

        if (bvalue_validated == FALSE) {
            /* Too low b-value or long ramptimes leading to negative plateau times?
               Reduce diffusion gradient amplitude and try again */
            ksepi_diffusion_amp *= 0.95;
            remaining_attempts--;
            if (remaining_attempts < 0) {
                return ks_error("%s: TE => negative diffusion gradient plateau time", __FUNCTION__);
            }
        }
    }

    /* duration and are are consequences of the fields just set (N.B. all are initialized to zero by ks_init_trap()) */
    ksepi->diffgrad.duration  = ksepi->diffgrad.plateautime  + 2 * ksepi->diffgrad.ramptime;
    ksepi->diffgrad2.duration = ksepi->diffgrad2.plateautime + 2 * ksepi->diffgrad2.ramptime;
    ksepi->diffgrad.area  = ksepi->diffgrad.amp  * (float) (ksepi->diffgrad.plateautime  + ksepi->diffgrad.ramptime);
    ksepi->diffgrad2.area = ksepi->diffgrad2.amp * (float) (ksepi->diffgrad2.plateautime + ksepi->diffgrad2.ramptime);
    
    /*emmweber -- DDE---*/
    ksepi->mytrap_1.duration = ksepi->mytrap_1.plateautime + 2 * ksepi->mytrap_1.ramptime; 
    ksepi->mytrap_2.duration = ksepi->mytrap_2.plateautime + 2 * ksepi->mytrap_2.ramptime; 
    ksepi->mytrap_1.area  = ksepi->mytrap_1.amp  * (float) (ksepi->mytrap_1.plateautime  + ksepi->mytrap_1.ramptime);
    ksepi->mytrap_2.area  = ksepi->mytrap_2.amp  * (float) (ksepi->mytrap_2.plateautime + ksepi->mytrap_2.ramptime);

    /*---------------*/

    return SUCCESS;
}




STATUS ksepi_diffusion_predownload_setrecon() {

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return SUCCESS;
    }


    /* enforced copying of diffusion related opXXX to rhXXX */
    cvoverride(rhnumbvals, opnumbvals, PSD_FIX_ON, PSD_EXIST_ON);


    /* mimic GE, but not sure these are needed */
    rhapp_option = opdifproctype; /* does this ever change from 0 ? */

    /* opuser 20-25 will be used by GE's DTI feature, but is also good to know for non-tensor
     * for custom off-line DWI recons.
     * rhuser 20,21,22 will be set by recon after reading in tensor.dat
     * 20,21,22 represent the diffusion direction coeffs
     */
    opuser23 = opdifnumt2;
    opuser24 = ndiffdirs;
    rhuser23 = opdifnumt2; /* rhuser 23 and 24 needed by recon to read tensor.dat */
    rhuser24 = ndiffdirs;
    opuser25 = opdualspinecho;

    rhnumdifdirs = (ndiffdirs > 1) ? ndiffdirs : 1;

    if (optensor) {

        rhdptype = 0;

        /* multi-bvalue (multi-shell DTI/HARDI) hack for optensor.
        We need to trick GE's diffusion recon to believe we have opdifnumdirs = opnumbvals * ndiffdirs.
        This does not enable the data to be procecced by e.g. GE's FuncTool when opnumbvals > 1, but will put the
        images in the DB for use by external DTI/HARDI software */
        if (opnumbvals > 1 && existcv(opdifnumdirs)) {
            /* MUST make the existflag for opdifnumdirs = 0 here to avoid circular evaluation on HOST
            by calling ksepi_eval_diffusion_UI() and predownload multiple times */
            cvoverride(opdifnumdirs, opnumbvals * ndiffdirs, PSD_FIX_OFF, PSD_EXIST_OFF); /* Don't change PSD_EXIST_OFF */
        }

        opuser_usage_tag = DTI_PROC;
        rhuser_usage_tag = DTI_PROC;

    } else {


        opuser_usage_tag = 0;
        rhuser_usage_tag = 0;

        /* non-tensor */
        if (opsavedf == 1)
            rhdptype = 1;
        else if (opsavedf == 2)
            rhdptype = 3;

    }

    return SUCCESS;
}




@pg


STATUS ksepi_diffusion_pg(KSEPI_SEQUENCE *ksepi, int TE) {
    KS_SEQLOC tmploc = KS_INIT_SEQLOC;
    int i;

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return SUCCESS;
    }

    /* First diffusion gradient right after the excitation */
    tmploc.ampscale = 1.0;
    tmploc.pos = ksepi->seqctrl.momentstart + ksepi->selrfexc.rf.iso2end + ksepi->selrfexc.grad.ramptime + ksepi->selrfexc.postgrad.duration;



    if (ksepi_reflines>0) {
        tmploc.pos += ksepi->epireftrain.duration;
    }

/*------------------------------------------- */
    /* Selective RF Refocus with left (pregrad.) and right (postgrad.) crushers */
     if (opdualspinecho) {


/* emweber ----- change position of forst gradient to inculde it in the dualspin echo condition -- (before, outside the condition) */
        for (i = XGRAD; i <= ZGRAD; i++) {
        tmploc.board = i;
        if (ks_pg_trap(&ksepi->diffgrad, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;
        }

/* ----------------------------------------*/

        tmploc.board = ZGRAD;
        tmploc.pos = ksepi->seqctrl.momentstart + RUP_GRD(TE / 4) - ksepi->selrfref.rf.start2iso - ksepi->selrfref.grad.ramptime - ksepi->selrfref.pregrad.duration;
        if (ks_pg_selrf(&ksepi->selrfref, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

        /* opdualspinecho: Second diffusion gradient after the 1st refocusing pulse */
        tmploc.ampscale = -1.0;
        tmploc.pos += ksepi->selrfref.pregrad.duration + ksepi->selrfref.grad.duration + ksepi->selrfref.postgrad.duration;
        for (i = XGRAD; i <= ZGRAD; i++) {
            tmploc.board = i;
            if (ks_pg_trap(&ksepi->diffgrad2, tmploc, &ksepi->seqctrl) == FAILURE)
                return FAILURE;
        }

        /* opdualspinecho: Third diffusion gradient right after the second */
        tmploc.ampscale = 1.0;
        tmploc.pos += ksepi->diffgrad2.duration;
        for (i = XGRAD; i <= ZGRAD; i++) {
            tmploc.board = i;
            if (ks_pg_trap(&ksepi->diffgrad2, tmploc, &ksepi->seqctrl) == FAILURE)
                return FAILURE;
        }

        tmploc.board = ZGRAD;
        tmploc.pos = ksepi->seqctrl.momentstart + RUP_GRD(TE * 3 / 4) - ksepi->selrfref2.rf.start2iso - ksepi->selrfref2.grad.ramptime - ksepi->selrfref2.pregrad.duration;
        if (ks_pg_selrf(&ksepi->selrfref2, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

        /* opdualspinecho: Fourth diffusion gradient after the 2nd refocusing pulse */
        tmploc.ampscale = -1.0;
        tmploc.pos += ksepi->selrfref2.pregrad.duration + ksepi->selrfref2.grad.duration + ksepi->selrfref2.postgrad.duration;
        for (i = XGRAD; i <= ZGRAD; i++) {
            tmploc.board = i;
            if (ks_pg_trap(&ksepi->diffgrad, tmploc, &ksepi->seqctrl) == FAILURE)
                return FAILURE;
        }

    } else if (num_oscillations>0) { /* emmweber -- DDE --- after refocusing pulse */

            
            int optm = opuser51;

            if ((optm<= ksepi->mytrap_1.ramptime) && (optm<= ksepi->mytrap_2.ramptime)){
            printf("Tooshort mixing time, must be at least %i\n", ksepi->mytrap_1.ramptime);
                optm=5000 ;
            }


            for (i = XGRAD; i <= ZGRAD; i++) {
                tmploc.board = i;
                if (ks_pg_trap(&ksepi->mytrap_1, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

            }

            tmploc.ampscale = -1.0;
            tmploc.pos+= ksepi->mytrap_1.duration+2000; /*optm;*/

            for (i = XGRAD; i <= ZGRAD; i++) {
                tmploc.board = i;
                if (ks_pg_trap(&ksepi->mytrap_1, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

            }

            /* refocusing pulse ----------------*/
            tmploc.ampscale = 1.0;
            tmploc.pos = ksepi->seqctrl.momentstart + TE / 2 - ksepi->selrfref.rf.start2iso - ksepi->selrfref.grad.ramptime - ksepi->selrfref.pregrad.duration;
            if (ks_pg_selrf(&ksepi->selrfref, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

            /* Third diffusion gradient (after the refocusing pulse) */
        
            tmploc.ampscale = 1.0;
            tmploc.pos += ksepi->selrfref.pregrad.duration + ksepi->selrfref.grad.duration + ksepi->selrfref.postgrad.duration;
            


         for (i = XGRAD; i <= ZGRAD; i++) {
            tmploc.board = i;
            if (ks_pg_trap(&ksepi->mytrap_2, tmploc, &ksepi->seqctrl) == FAILURE)
                return FAILURE;
        }

            tmploc.ampscale = -1.0;
            tmploc.pos+=ksepi->mytrap_2.duration+2000;

         for (i = XGRAD; i <= ZGRAD; i++) {
            tmploc.board = i;
            if (ks_pg_trap(&ksepi->mytrap_2, tmploc, &ksepi->seqctrl) == FAILURE)
              
              return FAILURE;
        }
        /*--------------------------------------------------------------*/

    } else{/* tejskal-Tanner diffusion -----------*/


            /* emweber ----- change position of first gradient to inculde it in the dualspin echo condition -- (before, outside the condition) */
            for (i = XGRAD; i <= ZGRAD; i++) {
                tmploc.board = i;
                if (ks_pg_trap(&ksepi->diffgrad, tmploc, &ksepi->seqctrl) == FAILURE)
                    return FAILURE;
            }

/* ----------------------------------------*/


            tmploc.pos = ksepi->seqctrl.momentstart + TE / 2 - ksepi->selrfref.rf.start2iso - ksepi->selrfref.grad.ramptime - ksepi->selrfref.pregrad.duration;
         if (ks_pg_selrf(&ksepi->selrfref, tmploc, &ksepi->seqctrl) == FAILURE)
            return FAILURE;

            /* Second diffusion gradient after the refocusing pulse */
        
            tmploc.ampscale = 1.0;
            tmploc.pos += 200ms;/*ksepi->selrfref.pregrad.duration + ksepi->selrfref.grad.duration + ksepi->selrfref.postgrad.duration;*/
        
            for (i = XGRAD; i <= ZGRAD; i++) {
                tmploc.board = i;
                if (ks_pg_trap(&ksepi->diffgrad, tmploc, &ksepi->seqctrl) == FAILURE)
                return FAILURE;
        }


    }


    return SUCCESS;
}


void ksepi_diffusion_scan_diffamp(KSEPI_SEQUENCE *ksepi, int volindx) {
    int i;

    if (opdiffuse != KS_EPI_DIFFUSION_ON) {
        return;
    }

    /*
       d: ksepi.diffgrad
      d2: ksepi.diffgrad2 (opdualspinecho only)
    #<x>: instance number <x>

    opdualspinecho = TRUE (Twice-refocused):
    ========================================

             _d#0__                  ____d2#3___
    XGRAD __/      \___             /           \___        ___
                       \___d2#0____/                \__d#3_/
             _d#1__                  ____d2#4___
    YGRAD __/      \___             /           \___        ___
                       \___d2#2____/                \__d#4_/
             _d#2__                  ____d2#5___
    ZGRAD __/      \___             /           \___        ___
                       \___d2#3____/                \__d#5_/


    opdualspinecho = FALSE (Stejskal-Tanner):
    =========================================

             _d#0__     _d#3__
    XGRAD __/      \___/      \___
             _d#1__     _d#4__
    YGRAD __/      \___/      \___
             _d#2__     _d#5__
    ZGRAD __/      \___/      \___

    */


    for (i = XGRAD; i <= ZGRAD; i++) {
        
        if (opdualspinecho) {

            /*emmweber --- added in the condition*/
            float amp = (volindx >= 0) ? diffscheme[i][volindx] : 0; /* 0 if volindx < 0 */
            ks_scan_trap_ampscale_slice(&ksepi->diffgrad, i, 3, 2, amp);
            /*------*/
            ks_scan_trap_ampscale_slice(&ksepi->diffgrad2, i, 3, 2, amp);

        }
        /*emmweber -------- DDE*/
        else if (num_oscillations>0) {

            
            
            float amp1 = (volindx >= 0) ? diffscheme[i][volindx] : 0; /* 0 if volindx < 0 */
            float amp2 = (volindx >= 0) ? diffscheme_2[i][volindx] : 0; /* 0 if volindx < 0 */
            printf("am1=%f\n",amp1 );

           /* ks_scan_trap_ampscale (&ksepi->mytrap_2,i,amp2) ;*/


            ks_scan_trap_ampscale_slice(&ksepi->mytrap_1, i, 3, 2, amp1);
            ks_scan_trap_ampscale_slice(&ksepi->mytrap_2, i, 3, 2, amp2);

        }
        else{
            /*emmweber --- added in the condition*/
            float amp = (volindx >= 0) ? diffscheme[i][volindx] : 0; /* 0 if volindx < 0 */
            ks_scan_trap_ampscale_slice(&ksepi->diffgrad, i, 3, 2, amp);
        }
    }


}




