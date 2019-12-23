typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef int wchar_t;
typedef signed char int8_t;
typedef short int int16_t;
typedef int int32_t;
__extension__
typedef long long int int64_t;
typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
__extension__
typedef unsigned long long int uint64_t;
typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef int int_least32_t;
__extension__
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
__extension__
typedef unsigned long long int uint_least64_t;
typedef signed char int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
__extension__
typedef long long int int_fast64_t;
typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
__extension__
typedef unsigned long long int uint_fast64_t;
typedef int intptr_t;
typedef unsigned int uintptr_t;
__extension__
typedef long long int intmax_t;
__extension__
typedef unsigned long long int uintmax_t;
typedef char s8;
typedef unsigned char n8;
typedef int16_t s16;
typedef uint16_t n16;
typedef long s32;
typedef unsigned long n32;
typedef int64_t s64;
typedef uint64_t n64;
typedef float f32;
typedef double f64;
struct EXT_CERD_PARAMS
{
  s32 alg;
  s32 demod;
} ;
typedef struct {
  f64 filfrq;
  struct EXT_CERD_PARAMS cerd;
  s32 taps;
  s32 outputs;
  s32 prefills;
  s32 filter_slot;
} PSD_FILTER_GEN;
enum
{
    COIL_CONNECTOR_A,
    COIL_CONNECTOR_P1,
    COIL_CONNECTOR_P2,
    COIL_CONNECTOR_P3,
    COIL_CONNECTOR_P4,
    COIL_CONNECTOR_P5,
    NUM_COIL_CONNECTORS,
    NUM_COIL_CONNECTORS_PADDED = 8,
    COIL_CONNECTOR_PORT0 = COIL_CONNECTOR_A,
    COIL_CONNECTOR_PORT1 = COIL_CONNECTOR_P1,
    COIL_CONNECTOR_PORT2 = COIL_CONNECTOR_P2,
    COIL_CONNECTOR_PORT3 = COIL_CONNECTOR_P3,
    COIL_CONNECTOR_PORT4 = COIL_CONNECTOR_P4,
    COIL_CONNECTOR_PORT5 = COIL_CONNECTOR_P5,
    COIL_CONNECTOR_MCRV = NUM_COIL_CONNECTORS,
    NUM_COIL_CONNECTORS_INC_MCRV = NUM_COIL_CONNECTORS + 1
};
enum
{
    COIL_CONNECTOR_MNS_LEGACY_TOP,
    COIL_CONNECTOR_C_LEGACY_BOTTOM,
    COIL_CONNECTOR_PORT_A,
    COIL_CONNECTOR_PORT_B,
    NUM_COIL_CONNECTORS_PRE_HDV
};
enum
{
    COIL_STATE_UNKNOWN,
    COIL_STATE_DISCONNECTED,
    COIL_STATE_CONNECTED,
    COIL_STATE_ID,
    COIL_STATE_COMPLETE,
    NUM_COIL_STATES
};
enum
{
    COIL_INVALID,
    COIL_VALID,
    NUM_COIL_VALID_VALUES
};
enum
{
    COIL_TYPE_TRANSMIT,
    COIL_TYPE_RECEIVE,
    NUM_COIL_TYPE_VALUES
};
enum
{
    BODY_TRANSMIT_DISABLE,
    BODY_TRANSMIT_ENABLE,
    NUM_BODY_TRANSMIT_ENABLE_VALUES
};
enum
{
    TRANSMIT_SELECT_NONE,
    TRANSMIT_SELECT_A,
    TRANSMIT_SELECT_P1,
    TRANSMIT_SELECT_LEGACY_HEAD,
    TRANSMIT_SELECT_LEGACY_MC,
    TRANSMIT_SELECT_1MNS,
    NUM_TRANSMIT_SELECTS
};
enum
{
    MNS_CONVERTER_SELECT_NONE = 0x00000000,
    MNS_CONVERTER_SELECT_A = 0x00000001,
    MNS_CONVERTER_SELECT_MASK = 0x00000001,
};
enum
{
    COIL_ID_TYPE_REQUIRED = 0,
    COIL_ID_TYPE_PRESENCE_ONLY = 1,
    COIL_ID_TYPE_NOT_REQUIRED = 2,
    NUM_COIL_ID_TYPES
};
enum
{
    COIL_INT_FAULT_CHECK_UNSUPPORTED,
    COIL_INT_FAULT_CHECK_SUPPORTED,
    NUM_COIL_INT_FAULT_CHECK_TYPES
};
typedef struct
{
    n32 receiverID;
    n32 connectorStartCh;
    n32 receiverStartCh;
    n32 numChannels;
} CPRM_ENTRY_TYPE;
typedef struct
{
    n32 numCprmEntries;
    n32 pad;
    CPRM_ENTRY_TYPE coilPortReceiverMap[2];
} CPRM_TYPE;
typedef struct
{
    CPRM_TYPE cprm[NUM_COIL_CONNECTORS];
} COIL_PORTS_RX_MAPS_TYPE;
enum {
    TX_POS_BODY,
    TX_POS_HEAD,
    TX_POS_EXTREMITY,
    TX_POS_XIPHOID,
    TX_POS_STERN,
    TX_POS_BREAST,
    TX_POS_HEAD_XIPHOID,
    TX_POS_HEAD_BODY,
    TX_POS_NECK,
    NUM_TX_POSITIONS
};
typedef struct CTMEntry
{
   n8 receiverID;
   n8 receiverChannel;
   n16 entryMask;
} CTMEntryType;
typedef struct QuadVolWeight
{
    n8 receiverID;
    n8 receiverChannel;
    n8 pad[2];
    f32 recWeight;
    f32 recPhaseDeg;
} QuadVolWeightType;
typedef struct CTTEntry
{
    s8 logicalCoilName[128];




    s8 clinicalCoilName[32];




    n32 configUID;




    n32 coilTypeMask;




    n32 isActiveScanConfig;




    CTMEntryType channelTranslationMap[256];




    QuadVolWeightType quadVolReceiveWeights[16];




    n32 numChannels;

} ChannelTransTableEntryType;
enum
{
    NORMAL_COIL,
    F000_COIL,
    FG00_COIL,
    P000_COIL,
    PG00_COIL,
    R000_COIL,
    SERV_COIL
};
typedef struct _INSTALL_COIL_INFO_
{
    char coilCode[(32 + 8)];
    int isInCoilDatabase;
}INSTALL_COIL_INFO;
typedef struct _INSTALL_COIL_CONNECTOR_INFO_
{
    int connector;
    int needsInstall;
    INSTALL_COIL_INFO installCoilInfo[4];
}INSTALL_COIL_CONNECTOR_INFO;
typedef struct coil_config_params
{
    char coilName[16];
    char GEcoilName[24];
    short pureCorrection;
    int maxNumOfReceivers;
    int coilType;
    int txCoilType;
    int fastTGmode;
    int fastTGstartTA;
    int fastTGstartRG;
    int nuclide;
    int tRPAvolumeRecEnable;
    int pureCompatible;
    int aps1StartTA;
    int cflStartTA;
    int cfhSensitiveAnatomy;
    float pureLambda;
    float pureTuningFactorSurface;
    float pureTuningFactorBody;
    float cableLoss;
    float coilLoss;
    float reconScale;
    float autoshimFOV;
    float coilWeights[4][256];
    ChannelTransTableEntryType cttEntry[4];
} COIL_CONFIG_PARAM_TYPE;
typedef struct application_config_param_type
{
    int aps1StartTA;
    int cflStartTA;
    int AScfPatLocChangeRL;
    int AScfPatLocChangeAP;
    int AScfPatLocChangeSI;
    int TGpatLocChangeRL;
    int TGpatLocChangeAP;
    int TGpatLocChangeSI;
    int autoshimFOV;
    int fastTGstartTA;
    int fastTGstartRG;
    int fastTGmode;
    int cfhSensitiveAnatomy;
    int aps1Mod;
    int aps1Plane;
    int pureCompatible;
    int maxFOV;
    int assetThresh;
    int scic_a_used;
    int scic_s_used;
    int scic_c_used;
    float aps1ModFOV;
    float aps1ModPStloc;
    float aps1ModPSrloc;
    float opthickPSMod;
    float pureScale;
    float pureCorrectionThreshold;
    float pureLambda;
    float pureTuningFactorSurface;
    float pureTuningFactorBody;
    float scic_a[7];
    float scic_s[7];
    float scic_c[7];
    int assetSupported;
    float assetValues[3];
    int arcSupported;
    float arcValues[3];
    int sagCalEnabled;
    int scenicEnabled;
    float slice_down_sample_rate;
    float inplane_down_sample_rate;
    int num_levels_max;
    int num_iterations_max;
    float convergence_threshold;
    int gain_clamp_mode;
    float gain_clamp_value;
} APPLICATION_CONFIG_PARAM_TYPE;
typedef struct application_config_hdr
{
    int error;
    char clinicalName[32];
    APPLICATION_CONFIG_PARAM_TYPE appConfig;
} APPLICATION_CONFIG_HDR;
typedef struct {
    s8 coilName[32];
    s32 txIndexPri;
    s32 txIndexSec;
    n32 rxCoilType;
    n32 hubIndex;
    n32 rxNucleus;
    n32 aps1Mod;
    n32 aps1ModPlane;
    n32 coilSepDir;
    s32 assetCalThreshold;
    f32 aps1ModFov;
    f32 aps1ModSlThick;
    f32 aps1ModPsTloc;
    f32 aps1ModPsRloc;
    f32 autoshimFov;
    f32 assetCalMaxFov;
    f32 maxB1Rms;
    n32 pureCompatible;
    f32 pureLambda;
    f32 pureTuningFactorSurface;
    f32 pureTuningFactorBody;
    n32 numChannels;
    f32 switchingSpeed;
} COIL_INFO;
typedef struct {
    s32 coilAtten;
    n32 txCoilType;
    n32 txPosition;
    n32 txNucleus;
    n32 txAmp;
    f32 maxB1Peak;
    f32 maxB1Squared;
    f32 cableLoss;
    f32 coilLoss;
    f32 reflCoeffSquared[10];
    f32 reflCoeffMassOffset;
    f32 reflCoeffCurveType;
    f32 exposedMass[8];
    f32 lowSarExposedMass[8];
    f32 jstd[12];
    f32 meanJstd[12];
    f32 separationStdev;
} TX_COIL_INFO;
typedef struct _psd_coil_info_
{
    COIL_INFO imgRcvCoilInfo[10];
    COIL_INFO volRcvCoilInfo[10];
    COIL_INFO fullRcvCoilInfo[10];
    TX_COIL_INFO txCoilInfo[5];
    int numCoils;
} PSD_COIL_INFO;
enum
{
    CFG_VAL_APS_NOT_PRESENT = 0,
    CFG_VAL_APS_PRESENT = 1
};
enum
{
    CFG_VAL_CFB_NOT_PRESENT = 0,
    CFG_VAL_CFB_PRESENT = 1
};
enum
{
    CFG_VAL_RCV_SWITCH_16_CH_SWITCH = 0,
    CFG_VAL_RCV_SWITCH_8_CH_SWITCH = 1,
    CFG_VAL_RCV_SWITCH_MEGASWITCH = 2,
    CFG_VAL_RCV_SWITCH_RF_HUB = 3,
    CFG_VAL_RCV_SWITCH_NONE = 4
};
enum
{
    CFG_VAL_RECEIVER_DCERD = 0,
    CFG_VAL_RECEIVER_RRF = 1,
    CFG_VAL_RECEIVER_RRX = 2,
    CFG_VAL_RECEIVER_DPP = 3
};
enum
{
    CFG_VAL_SRI_SERIAL = 0,
    CFG_VAL_SRI_CAN = 1
};
enum
{
    CFG_VAL_TNS_UTNS = 0,
    CFG_VAL_TNS_TDM = 1
};
enum
{
    CFG_VAL_DACQ_DRF = 0,
    CFG_VAL_DACQ_VRF = 1,
    CFG_VAL_DACQ_IVRF = 2
};
enum
{
    CFG_VAL_HEC_NOT_PRESENT = 0
};
enum
{
    CFG_VAL_DV_CABINET = 0,
    CFG_VAL_ISC_CABINET = 1,
    CFG_VAL_HD_CABINET = 2,
    CFG_VAL_CABINET_TYPE_MAX_NUM,
};
enum
{
    CFG_VAL_ONEWIRE_NET_ENV_MON_ONLY = 0,
    CFG_VAL_ONEWIRE_NET_PHPS = 1
};
enum
{
    CFG_VAL_SSC_TYPE_MGD = 0,
    CFG_VAL_SSC_TYPE_ICE = 1,
    CFG_VAL_SSC_TYPE_MAX_NUM = 2
};
enum
{
    CFG_VAL_ICE_CAN_FIBER_DISABLED = 0,
    CFG_VAL_ICE_CAN_FIBER_ENABLED = 1
};
enum
{
    CFG_VAL_TERMSERVER_NOT_PRESENT = 0,
    CFG_VAL_TERMSERVER_PRESENT = 1
};
enum
{
    CFG_VAL_FIELDSTRENGTH_0_0T = 0,
    CFG_VAL_FIELDSTRENGTH_0_35T = 3500,
    CFG_VAL_FIELDSTRENGTH_0_70T = 7000,
    CFG_VAL_FIELDSTRENGTH_1_0T = 10000,
    CFG_VAL_FIELDSTRENGTH_1_5T = 15000,
    CFG_VAL_FIELDSTRENGTH_3_0T = 30000,
    CFG_VAL_FIELDSTRENGTH_7_0T = 70000
};
enum
{
    CFG_VAL_SRPS_NOT_PRESENT = 0,
    CFG_VAL_SRPS_OR_ESRPS = 1
};
enum
{
    CFG_ESTOP_TYPE_SMC = 0,
    CFG_ESTOP_TYPE_EXT = 1,
    CFG_ESTOP_TYPE_MAX_NUM = 2
};
enum
{
    CFG_VAL_PTX_NOT_CAPABLE = 0,
    CFG_VAL_PTX_CAPABLE = 1,
};
enum
{
    CFG_VAL_DPP_TYPE_GEN1 = 0,
    CFG_VAL_DPP_TYPE_GEN2 = 1,
    CFG_VAL_DPP_TYPE_NUM_TYPES
};
enum
{
    CFG_VAL_BODYCOIL_TYPE_0 = 0,
    CFG_VAL_BODYCOIL_TYPE_1 = 1,
    CFG_VAL_BODYCOIL_TYPE_2 = 2,
    CFG_VAL_BODYCOIL_TYPE_3 = 3,
    CFG_VAL_BODYCOIL_TYPE_4 = 4,
    CFG_VAL_BODYCOIL_TYPE_5 = 5,
    CFG_VAL_BODYCOIL_TYPE_6 = 6,
    CFG_VAL_BODYCOIL_TYPE_7 = 7,
    CFG_VAL_BODYCOIL_TYPE_8 = 8,
    CFG_VAL_BODYCOIL_TYPE_9 = 9,
    CFG_VAL_BODYCOIL_TYPE_10 = 10,
    CFG_VAL_BODYCOIL_TYPE_11 = 11,
    CFG_VAL_BODYCOIL_TYPE_12 = 12,
    CFG_VAL_BODYCOIL_TYPE_13 = 13
};
enum
{
    CFG_VAL_BODYCOIL_POLARITY_UNFLIPPED = 0,
    CFG_VAL_BODYCOIL_POLARITY_FLIPPED = 1
};
enum
{
    CFG_WIRED_PAC = 3,
    CFG_WIRELESS_PAC = 4,
    CFG_UNKNOWN_PAC_TYPE = 10
};
enum
{
    CFG_VAL_MCBIAS_VOLTAGE = 0,
    CFG_VAL_MCBIAS_CURRENT = 1
};
enum
{
    CFG_VAL_CABMON1_TYPE = 1,
    CFG_VAL_CABMON2_TYPE = 2,
    CFG_VAL_CABMON3_TYPE = 3
};
enum
{
    CFG_VAL_RECEIVE_FREQ_BANDS_DISABLED = 0,
    CFG_VAL_RECEIVE_FREQ_BANDS_ENABLED = 1
};
typedef struct {
    s16 pmPredictSAR;
    s16 pmContinuousUpdate;
} power_monitor_table_t;
typedef struct {
    char epname[16];
    n32 epamph;
    n32 epampb;
    n32 epamps;
    n32 epampc;
    n32 epwidthh;
    n32 epwidthb;
    n32 epwidths;
    n32 epwidthc;
    n32 epdcycleh;
    n32 epdcycleb;
    n32 epdcycles;
    n32 epdcyclec;
    n8 epsmode;
    n8 epfilter;
    n8 eprcvrband;
    n8 eprcvrinput;
    n8 eprcvrbias;
    n8 eptrdriver;
    n8 epfastrec;
    s16 epxmtadd;
    s16 epprexres;
    s16 epshldctrl;
    s16 epgradcoil;
    n32 eppkpower;
    n32 epseqtime;
    s16 epstartrec;
    s16 ependrec;
    power_monitor_table_t eppmtable;
    n8 epGeneralBankIndex;
    n8 epGeneralBankIndex2;
    n8 epR1BankIndex;
    n8 epNbTransmitSelect;
    n8 epBbTransmitSelect;
    n32 epMnsConverterSelect;
    n32 epRxCoilType;
    f32 epxgd_cableirmsmax;
    f32 epcoilAC_powersum;
    n8 enableReceiveFreqBands;
    s32 offsetReceiveFreqLower;
    s32 offsetReceiveFreqHigher;
} entry_point_table_t;
typedef entry_point_table_t ENTRY_POINT_TABLE;
typedef entry_point_table_t ENTRY_PNT_TABLE;
typedef enum ANATOMY_ATTRIBUTE {
    ATTRIBUTE_CODE_MEANING,
    ATTRIBUTE_CATEGORY,
    ATTRIBUTE_APX_BH,
    ATTRIBUTE_MAGIC,
    ATTRIBUTE_SAG_CAL,
    ATTRIBUTE_3DGW_BSPLINE_INTERP,
    ATTRIBUTE_2DFSE_ANNEFACT_REDUCTION,
    ATTRIBUTE_ENABLE_PURE_BLUR,
    ATTRIBUTE_PURE_BLUR,
    ATTRIBUTE_NEAR_HEAD,
    ATTRIBUTE_CALIB_TABLE_MOVE_THRESH,
    ATTRIBUTE_VIRTUAL_CHANNEL_RECON,
    ATTRIBUTE_OPTIMAL_SNR_RECON,
    ATTRIBUTE_SELF_SENSITIVITY_UNIFORM_CORRECTION
} ANATOMY_ATTRIBUTE_E;
typedef enum ANATOMY_ATTRIBUTE_CATEGORY {
    ATTRIBUTE_CATEGORY_HEAD,
    ATTRIBUTE_CATEGORY_NECK,
    ATTRIBUTE_CATEGORY_UPPEREXTREMITIES,
    ATTRIBUTE_CATEGORY_CHEST,
    ATTRIBUTE_CATEGORY_ABDOMEN,
    ATTRIBUTE_CATEGORY_SPINE,
    ATTRIBUTE_CATEGORY_PELVIS,
    ATTRIBUTE_CATEGORY_LOWEREXTREMITIES
} ANATOMY_ATTRIBUTE_CATEGORY_E;
size_t getAnatomyAttribute(const int id, const char* attribute, char* result, size_t len);
int getAnatomyAttributeCached(const int key_id, const int attribute, char* attribute_result);
int isApplicationAllowedForAnatomy(int key_id, int application);
int isCategoryMatchForAnatomy(int key_id, int category);
int getIntAnatomyAttribute(const int key_id, const int attribute, int* attribute_result_int);
int getFloatAnatomyAttribute(const int key_id, const int attribute, float* attribute_result_float);
typedef struct
{
    float oprloc;
    float opphasoff;
    float optloc;
    float oprloc_shift;
    float opphasoff_shift;
    float optloc_shift;
    float opfov_freq_scale;
    float opfov_phase_scale;
    float opslthick_scale;
    float oprot[9];
} SCAN_INFO;
typedef struct
{
    float oppsctloc;
    float oppscrloc;
    float oppscphasoff;
    float oppscrot[9];
    int oppsclenx;
    int oppscleny;
    int oppsclenz;
} PSC_INFO;
typedef struct {
    float opgirthick;
    float opgirtloc;
    float opgirrot[9];
} GIR_INFO;
typedef struct
{
    short slloc;
    short slpass;
    short sltime;
} DATA_ACQ_ORDER;
typedef struct {
    float rsptloc;
    float rsprloc;
    float rspphasoff;
    int slloc;
 } RSP_INFO;
typedef struct {
    int ysign;
    int yoffs;
} PHASE_OFF;
typedef struct {
  float rsppsctloc;
  float rsppscrloc;
  float rsppscphasoff;
  long rsppscrot[10];
  int rsppsclenx;
  int rsppscleny;
  int rsppsclenz;
 } RSP_PSC_INFO;
typedef enum {
    TYPXGRAD = 0,
    TYPYGRAD = 1,
    TYPZGRAD = 2,
    TYPRHO1 = 3,
    TYPRHO2 = 4,
    TYPTHETA = 5,
    TYPOMEGA = 6,
    TYPSSP = 7,
    TYPAUX = 8,
    TYPBXGRAD,
    TYPBYGRAD,
    TYPBZGRAD,
    TYPBRHO1,
    TYPBRHO2,
    TYPBTHETA,
    TYPBOMEGA,
    TYPBSSP,
    TYPBAUX
} WF_PROCESSOR;
typedef enum {
    TYPINSTRMEM = 0,
    TYPWAVEMEM = 1
} WF_HARDWARE_TYPE;
typedef enum {
    TOHARDWARE = 0,
    FROMHARDWARE = 1
} HW_DIRECTION;
typedef enum {
    SSPS1 = 0,
    SSPS2 = 1,
    SSPS3 = 2,
    SSPS4 = 3
} SSP_S_ATTRIB;
typedef struct {
  s32 abcode;
  char text_string[256];
  char text_arg[16];
  s32 *longarg[4];
} PSD_EXIT_ARG;
typedef enum GRADIENT_COILS
{
    PSD_55_CM_COIL = 1,
    PSD_60_CM_COIL = 2,
    PSD_TRM_COIL = 3,
    PSD_4_COIL = 4,
    PSD_5_COIL = 5,
    PSD_CRM_COIL = 6,
    PSD_HFO_COIL = 7,
    PSD_XRMB_COIL = 8,
    PSD_OVATION_COIL = 9,
    PSD_10_COIL = 10,
    PSD_XRMW_COIL = 11,
    PSD_VRMW_COIL = 12,
    PSD_HRMW_COIL = 13,
    PSD_BRM2_COIL = 14
} GRADIENT_COIL_E;
typedef enum BODY_COIL_TYPES
{
    PSD_15_BRM_BODY_COIL = 0,
    PSD_15_TRM_BODY_COIL = 0,
    PSD_15_HDE_BODY_COIL = 0,
    PSD_15_CRM_BODY_COIL = 1,
    PSD_30_CRM_BODY_COIL = 2,
    PSD_30_TRM_BODY_COIL = 3,
    PSD_30_XRM_BODY_COIL = 4,
    PSD_15_XRM_BODY_COIL = 5,
    PSD_15_XRMW_BODY_COIL = 6,
    PSD_30_XRMW_BODY_COIL = 7,
    PSD_30_NEONATAL_BODY_COIL = 8,
    PSD_30_XRMW_PET_BODY_COIL = 9,
    PSD_30_VRMW_BODY_COIL = 10,
    PSD_30_HRMW_BODY_COIL = 11,
    PSD_30_VRMW_VCP_BODY_COIL = 12,
    PSD_15_VRMW_BODY_COIL = 13
} BODY_COIL_TYPE_E;
typedef enum PSD_BOARD_TYPE
{
    PSDCERD = 0,
    PSDDVMR,
    NUM_PSD_BOARD_TYPES
} PSD_BOARD_TYPE_E;
typedef enum SSC_TYPE
{
    SSC_TYPE_MGD = 0,
    SSC_TYPE_ICE = 1
} SSC_TYPE_E;
typedef enum GRADIENT_COIL_METHOD
{
    GRADIENT_COIL_METHOD_AUTO = -1,
    GRADIENT_COIL_METHOD_DC = 0,
    GRADIENT_COIL_METHOD_AC = 1,
    GRADIENT_COIL_METHOD_QAC = 2
} GRADIENT_COIL_METHOD_E;
typedef enum POWER_IN_HEAT_CALC
{
    AVERAGE_POWER = 0,
    MAXIMUM_POWER = 1
} POWER_IN_HEAT_CALC_E;
typedef enum GRADIENT_PULSE_TYPE
{
    G_RAMP = 1,
    G_TRAP = 2,
    G_SIN = 3,
    G_CONSTANT = 4,
    G_ARBTRAP = 5,
    G_USER = 6,
    G_EMPTY = -1,
} GRADIENT_PULSE_TYPE_E;
typedef struct {
  int ptype;
  int *attack;
  int *decay;
  int *pw;
  float *amps;
  float *amp;
  float *ampd;
  float *ampe;
  char *gradfile;
  int num;
  float scale;
  int *time;
  int tdelta;
  float powscale;
  float power;
  float powpos;
  float powneg;
  float powabs;
  float amptran;
  int pwm;
  int bridge;
  float intabspwmcurr;
} GRAD_PULSE;
typedef struct {
  int *pw;
  float *amp;
  float abswidth;
  float effwidth;
  float area;
  float dtycyc;
  float maxpw;
  int num;
  float max_b1;
  float max_int_b1_sq;
  float max_rms_b1;
  float nom_fa;
  float *act_fa;
  float nom_pw;
  float nom_bw;
  unsigned int activity;
  unsigned char reference;
  int isodelay;
  float scale;
  int *res;
  int extgradfile;
  int *exciter;
  int apply_as_hadamard_factor;
} RF_PULSE;
typedef struct {
  int change;
  int newres;
} RF_PULSE_INFO;
typedef enum {
    NORMAL_CONTROL_MODE = 0,
    FIRST_CONTROL_MODE = 1,
    SECOND_CONTROL_MODE = 2,
    LOWSAR_CONTROL_MODE = 3
} regulatory_control_mode_e;
typedef enum epic_slice_order_type_e
{
    TYPNCAT =0,
    TYPCAT =1,
    TYPXRR =2,
    TYPMPMP =3,
    TYPSSMP =4,
    TYP3D =5,
    TYPNORMORDER =6,
    TYPFASTMPH =7,
    TYPF3D =8,
    TYP3DMSNCAT =9,
    TYP3DMSCAT =10,
    TYP3DFSENCAT =11,
    TYP3DFSECAT =12,
    TYPRTG =13,
    TYPF3DMPH =14,
    TYPSSFSEINT =15,
    TYPSSFSESEQ =16,
    TYPSSFSEXRR =17,
    TYPSSFSERTG =18,
    TYPSEQSLIC =19,
    TYPF3DMSMPH =20,
    TYPSSFSEFLAIR=21,
    TYPMAVRIC =22,
    TYPNCATFLAIR =23,
    TYPMDMENORM =24,
    TYPMULTIBAND =25,
    TYPSSFSEMPH =26,
    TYPF3DCINE =27,
    TYPF3DMSCINE =28,
    TYPNCATRTG =29,
    TYPCATRTG =30,
    TYPMULTIBAND2=31,
    TYPMULTIBANDNORMORDER =32
} epic_slice_order_type;
typedef enum exciter_type {
    NO_EXCITER = 0,
    MASTER_EXCITER,
    SLAVE_EXCITER,
    ALL_EXCITERS
} exciterSelection;
typedef enum receiver_type {
    NO_RECEIVER = 0,
    MASTER_RECEIVER,
    SLAVE_RECEIVER,
    ALL_RECEIVERS
} receiverSelection;
typedef enum oscillator_source {
    LO_MASTER_RCVALL = 0,
    LO_SLAVE_RCVB1,
    LO_SLAVE_RCVB2,
    LO_SLAVE_RCVB3,
    LO_SLAVE_RCVB4,
    LO_SLAVE_RCVB1B2,
    LO_SLAVE_RCVB1B3,
    LO_SLAVE_RCVB1B4,
    LO_SLAVE_RCVB1B2B3,
    LO_SLAVE_RCVB1B2B4,
    LO_SLAVE_RCVB1B3B4,
    LO_SLAVE_RCVB2B3,
    LO_SLAVE_RCVB2B4,
    LO_SLAVE_RCVB2B3B4,
    LO_SLAVE_RCVB3B4,
    LO_SLAVE_RCVALL,
    NO_LO_CHANGE
} demodSelection;
typedef enum nav_type {
    NAV_OFF = 0,
    NAV_ON,
    NAV_MASTER,
    NAV_SLAVE,
    NO_NAV_CHANGE
} navSelection;
typedef enum VALUE_SYSTEM_TYPE
{
  NON_VALUE_SYSTEM = 0,
  VALUE_SYSTEM_HDE,
  VALUE_SYSTEM_SVEM,
  VALUE_SYSTEM_SVDM,
  VALUE_SYSTEM_SVDMP
} VALUE_SYSTEM_TYPE_E;
typedef enum PSD_PATIENT_ENTRY {
    PSD_PATIENT_ENTRY_HEAD_FIRST = 1,
    PSD_PATIENT_ENTRY_FEET_FIRST = 2,
    PSD_PATIENT_ENTRY_AXIAL = 3,
    PSD_PATIENT_ENTRY_SIDE = 4,
    PSD_PATIENT_ENTRY_VERTICAL = 5,
    PSD_PATIENT_ENTRY_RESERVED = 6,
    PSD_PATIENT_ENTRY_HEAD_FIRST_PLUS_25DEG = 7,
    PSD_PATIENT_ENTRY_HEAD_FIRST_MINUS_25DEG = 8,
    PSD_PATIENT_ENTRY_FEET_FIRST_PLUS_25DEG = 9,
    PSD_PATIENT_ENTRY_FEET_FIRST_MINUS_25DEG = 10
} PSD_PATIENT_ENTRY_E;
typedef enum CAL_MODE
{
    CAL_MODE_MIN = 0,
    CAL_MODE_STANDARD = 0,
    CAL_MODE_BREATHHOLD_FREEBREATHING = 1,
    CAL_MODE_FREEBREATHING = 2,
    CAL_MODE_MAX = 2
} CAL_MODE_E;
typedef enum RG_CAL_MODE {
    RG_CAL_MODE_MIN = 0,
    RG_CAL_MODE_MEASURED = 0,
    RG_CAL_MODE_HIGH_FIXED = 1,
    RG_CAL_MODE_LOW_FIXED = 2,
    RG_CAL_MODE_AUTO = 3,
    RG_CAL_MODE_MAX = 3
} RG_CAL_MODE_E;
typedef enum ADD_SCAN_TYPE {
    ADD_SCAN_TYPE_NONE = 0,
    ADD_SCAN_HEADLOC_SCOUT = 1
} ADD_SCAN_TYPE_E;
typedef enum PSD_SLTHICK_LABEL
{
    PSD_SLTHICK_LABEL_SLTHICK = 0,
    PSD_SLTHICK_LABEL_RESOLUTION = 1
} PSD_SLTHICK_LABEL_E;
typedef enum PSD_NAV_TYPE {
  PSD_NAV_TYPE_90_180 = 0,
  PSD_NAV_TYPE_CYL
} PSD_NAV_TYPE_E;
typedef enum PSD_FLIP_ANGLE_MODE_LABEL {
    PSD_FLIP_ANGLE_MODE_EXCITE = 0,
    PSD_FLIP_ANGLE_MODE_REFOCUS = 1
} PSD_FLIP_ANGLE_LABEL_E;
typedef enum PSD_AUTO_TR_MODE_LABEL {
    PSD_AUTO_TR_MODE_MANUAL_TR = 0,
    PSD_AUTO_TR_MODE_IN_RANGE_TR = 1,
    PSD_AUTO_TR_MODE_ADVANCED_IN_RANGE_TR = 2
} PSD_AUTO_TR_MODE_LABEL_E;
typedef enum CARDIAC_GATE_TYPE
{
    CARDIAC_GATE_TYPE_MIN = 0,
    CARDIAC_GATE_TYPE_NONE = 0,
    CARDIAC_GATE_TYPE_ECG = 1,
    CARDIAC_GATE_TYPE_PG = 2,
    CARDIAC_GATE_TYPE_MAX = 2
} CARDIAC_GATE_TYPE_E;
typedef char CHAR;
typedef s16 SHORT;
typedef int INT;
typedef INT LONG;
typedef f32 FLOAT;
typedef f64 DOUBLE;
typedef n8 UCHAR;
typedef n16 USHORT;
typedef unsigned int UINT;
typedef UINT ULONG;
typedef int STATUS;
typedef void * ADDRESS;
typedef enum e_axis {
    X = 0,
    Y,
    Z
} t_axis;

typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;
__extension__ typedef long long int __quad_t;
__extension__ typedef unsigned long long int __u_quad_t;
__extension__ typedef __u_quad_t __dev_t;
__extension__ typedef unsigned int __uid_t;
__extension__ typedef unsigned int __gid_t;
__extension__ typedef unsigned long int __ino_t;
__extension__ typedef __u_quad_t __ino64_t;
__extension__ typedef unsigned int __mode_t;
__extension__ typedef unsigned int __nlink_t;
__extension__ typedef long int __off_t;
__extension__ typedef __quad_t __off64_t;
__extension__ typedef int __pid_t;
__extension__ typedef struct { int __val[2]; } __fsid_t;
__extension__ typedef long int __clock_t;
__extension__ typedef unsigned long int __rlim_t;
__extension__ typedef __u_quad_t __rlim64_t;
__extension__ typedef unsigned int __id_t;
__extension__ typedef long int __time_t;
__extension__ typedef unsigned int __useconds_t;
__extension__ typedef long int __suseconds_t;
__extension__ typedef int __daddr_t;
__extension__ typedef long int __swblk_t;
__extension__ typedef int __key_t;
__extension__ typedef int __clockid_t;
__extension__ typedef void * __timer_t;
__extension__ typedef long int __blksize_t;
__extension__ typedef long int __blkcnt_t;
__extension__ typedef __quad_t __blkcnt64_t;
__extension__ typedef unsigned long int __fsblkcnt_t;
__extension__ typedef __u_quad_t __fsblkcnt64_t;
__extension__ typedef unsigned long int __fsfilcnt_t;
__extension__ typedef __u_quad_t __fsfilcnt64_t;
__extension__ typedef int __ssize_t;
typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;
__extension__ typedef int __intptr_t;
__extension__ typedef unsigned int __socklen_t;
struct _IO_FILE;

typedef struct _IO_FILE FILE;


typedef struct _IO_FILE __FILE;
typedef struct
{
  int __count;
  union
  {
    unsigned int __wch;
    char __wchb[4];
  } __value;
} __mbstate_t;
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));
typedef __builtin_va_list __gnuc_va_list;
struct _IO_jump_t; struct _IO_FILE;
typedef void _IO_lock_t;
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  int _pos;
};
enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
struct _IO_FILE {
  int _flags;
  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;
  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;
  struct _IO_marker *_markers;
  struct _IO_FILE *_chain;
  int _fileno;
  int _flags2;
  __off_t _old_offset;
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];
  _IO_lock_t *_lock;
  __off64_t _offset;
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;
  int _mode;
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];
};
typedef struct _IO_FILE _IO_FILE;
struct _IO_FILE_plus;
extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);
typedef __ssize_t __io_write_fn (void *__cookie, __const char *__buf,
     size_t __n);
typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);
typedef int __io_close_fn (void *__cookie);
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_peekc_locked (_IO_FILE *__fp);
extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
   __gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
    __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);
extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);
extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__));
typedef __gnuc_va_list va_list;
typedef __off_t off_t;
typedef __ssize_t ssize_t;

typedef _G_fpos_t fpos_t;

extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;

extern int remove (__const char *__filename) __attribute__ ((__nothrow__));
extern int rename (__const char *__old, __const char *__new) __attribute__ ((__nothrow__));

extern int renameat (int __oldfd, __const char *__old, int __newfd,
       __const char *__new) __attribute__ ((__nothrow__));

extern FILE *tmpfile (void) ;
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__)) ;

extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__)) ;
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;

extern int fclose (FILE *__stream);
extern int fflush (FILE *__stream);

extern int fflush_unlocked (FILE *__stream);

extern FILE *fopen (__const char *__restrict __filename,
      __const char *__restrict __modes) ;
extern FILE *freopen (__const char *__restrict __filename,
        __const char *__restrict __modes,
        FILE *__restrict __stream) ;

extern FILE *fdopen (int __fd, __const char *__modes) __attribute__ ((__nothrow__)) ;
extern FILE *fmemopen (void *__s, size_t __len, __const char *__modes)
  __attribute__ ((__nothrow__)) ;
extern FILE *open_memstream (char **__bufloc, size_t *__sizeloc) __attribute__ ((__nothrow__)) ;

extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__));
extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__));

extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
         size_t __size) __attribute__ ((__nothrow__));
extern void setlinebuf (FILE *__stream) __attribute__ ((__nothrow__));

extern int fprintf (FILE *__restrict __stream,
      __const char *__restrict __format, ...);
extern int printf (__const char *__restrict __format, ...);
extern int sprintf (char *__restrict __s,
      __const char *__restrict __format, ...) __attribute__ ((__nothrow__));
extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg);
extern int vprintf (__const char *__restrict __format, __gnuc_va_list __arg);
extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg) __attribute__ ((__nothrow__));


extern int snprintf (char *__restrict __s, size_t __maxlen,
       __const char *__restrict __format, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));
extern int vsnprintf (char *__restrict __s, size_t __maxlen,
        __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));

extern int vdprintf (int __fd, __const char *__restrict __fmt,
       __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 2, 0)));
extern int dprintf (int __fd, __const char *__restrict __fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));

extern int fscanf (FILE *__restrict __stream,
     __const char *__restrict __format, ...) ;
extern int scanf (__const char *__restrict __format, ...) ;
extern int sscanf (__const char *__restrict __s,
     __const char *__restrict __format, ...) __attribute__ ((__nothrow__));
extern int fscanf (FILE *__restrict __stream, __const char *__restrict __format, ...) __asm__ ("" "__isoc99_fscanf") ;
extern int scanf (__const char *__restrict __format, ...) __asm__ ("" "__isoc99_scanf") ;
extern int sscanf (__const char *__restrict __s, __const char *__restrict __format, ...) __asm__ ("" "__isoc99_sscanf") __attribute__ ((__nothrow__));


extern int vfscanf (FILE *__restrict __s, __const char *__restrict __format,
      __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (__const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (__const char *__restrict __s,
      __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__scanf__, 2, 0)));
extern int vfscanf (FILE *__restrict __s, __const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vfscanf")
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (__const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vscanf")
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (__const char *__restrict __s, __const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vsscanf")
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__scanf__, 2, 0)));


extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);
extern int getchar (void);

extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
extern int fgetc_unlocked (FILE *__stream);

extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);
extern int putchar (int __c);

extern int fputc_unlocked (int __c, FILE *__stream);
extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);
extern int getw (FILE *__stream);
extern int putw (int __w, FILE *__stream);

extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;
extern char *gets (char *__s) ;

extern __ssize_t __getdelim (char **__restrict __lineptr,
          size_t *__restrict __n, int __delimiter,
          FILE *__restrict __stream) ;
extern __ssize_t getdelim (char **__restrict __lineptr,
        size_t *__restrict __n, int __delimiter,
        FILE *__restrict __stream) ;
extern __ssize_t getline (char **__restrict __lineptr,
       size_t *__restrict __n,
       FILE *__restrict __stream) ;

extern int fputs (__const char *__restrict __s, FILE *__restrict __stream);
extern int puts (__const char *__s);
extern int ungetc (int __c, FILE *__stream);
extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s) ;

extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
         size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
          size_t __n, FILE *__restrict __stream) ;

extern int fseek (FILE *__stream, long int __off, int __whence);
extern long int ftell (FILE *__stream) ;
extern void rewind (FILE *__stream);

extern int fseeko (FILE *__stream, __off_t __off, int __whence);
extern __off_t ftello (FILE *__stream) ;

extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);
extern int fsetpos (FILE *__stream, __const fpos_t *__pos);


extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void perror (__const char *__s);

extern int sys_nerr;
extern __const char *__const sys_errlist[];
extern int fileno (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern FILE *popen (__const char *__command, __const char *__modes) ;
extern int pclose (FILE *__stream);
extern char *ctermid (char *__s) __attribute__ ((__nothrow__));
extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__));
extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__));

typedef enum e_fopen_mode {
   READ_MODE = 0,
   WRITE_MODE
} t_fopen_mode;
STATUS DefOpenUsrFile( const CHAR *filename, const CHAR *marker );
STATUS DefOpenFile( const CHAR *markername );
STATUS DefFindKey( const CHAR *key, const INT mark );
STATUS DefReadData( const CHAR *format_str, ADDRESS data_addr );
STATUS DefCloseFile( void );
INT ExtractNameTo( CHAR *orig_name, CHAR *key, CHAR *new_name );
double FMax( int info, ... );
double FMin( int info, ... );
int IMax( int info, ... );
int IMin( int info, ... );
short floatsAlmostEqualAbsolute( const float a,
                                 const float b,
                                 const float tol );
short floatsAlmostEqualRelative( const float a,
                                 const float b,
                                 const float fract );
short floatsAlmostEqualEpsilons( const float a,
                                 const float b,
                                 const unsigned int neps );
short floatsAlmostEqualEpsilon( const float a,
                                const float b );
short floatAlmostZeroAbsolute( const float a,
                               const float tol );
short floatIdenticallyZero( const float a );
short floatsAlmostEqualNulps( const float a,
                              const float b,
                              const n32 nulps );
float floatUlp( const float a );
short floatIsInteger( const float a );
short floatIsNormal( const float a );
short floatIsInfinite( const float a );
short floatIsPositiveInfinity( const float a );
short floatIsNegativeInfinity( const float a );
short floatIsNan( const float a );
short doublesAlmostEqualAbsolute( const double a,
                                  const double b,
                                  const double tol );
short doublesAlmostEqualRelative( const double a,
                                  const double b,
                                  const double fract );
short doublesAlmostEqualEpsilons( const double a,
                                  const double b,
                                  const unsigned int neps );
short doublesAlmostEqualEpsilon( const double a,
                                 const double b );
short doubleAlmostZeroAbsolute( const double a,
                                const double tol );
short doubleIdenticallyZero( const double a );
short doublesAlmostEqualNulps( const double a,
                               const double b,
                               const n64 nulps );
double doubleUlp( const double a );
short doubleIsInteger( const double a );
short doubleIsNormal( const double a );
short doubleIsInfinite( const double a );
short doubleIsPositiveInfinity( const double a );
short doubleIsNegativeInfinity( const double a );
short doubleIsNan( const double a );
typedef float datavalue;
datavalue median(const datavalue * p, const int kernel_size);
void smooth(float *data, int numpts, int kernel_size, int skip);
void intarr2float(float * f_a, const int * a, const int numpt);
void generate_polycurve(float * result, const float * xdata, const float * coeff, const int order, const int numpt);
STATUS weighted_polyfit( float * fittedResult,
               float * coeff,
               const float * ydata ,
               const float * xdata,
               const float * weight,
               const int order,
               const int numpt );
FILE *OpenFile( const CHAR *filename, const t_fopen_mode mode );
STATUS CloseFile( FILE *plotdata_fptr );
STATUS RewindFile( FILE *plotdata_fptr );
STATUS RemoveFile( const CHAR *filename );
STATUS FileExists( const CHAR *filename );
LONG FileDate( CHAR *path );
void WriteError( const CHAR *string );
STATUS FileExecs( const CHAR *filename );
STATUS IsaWDir( const CHAR *filename );
STATUS IsSunview( void );
const char *Resides( const char *env_varname );
const char *SetBase( const char *filename );
const char *ExtractBase( const char *filename );
int RNEAREST_RF( int n, int fact );
ADDRESS WTAlloc( size_t size );
void WTFree( ADDRESS address );
STATUS
activate_usercv( const int usercv );
STATUS
deactivate_usercv( const int usercv );
STATUS
deactivate_all_usercvs( void );
STATUS
activate_reserved_usercv( const int usercv );
STATUS
deactivate_reserved_usercv( const int usercv );
STATUS
deactivate_all_reserved_usercvs( void );
enum
{
    SEQ_CFG_SEQ_ID_GRAD_X = 0,
    SEQ_CFG_SEQ_ID_GRAD_Y = 1,
    SEQ_CFG_SEQ_ID_GRAD_Z = 2,
};
enum
{
    SEQ_CFG_TYPE_NONE = 0x00000000,
    SEQ_CFG_TYPE_SSP = 0x00000001,
    SEQ_CFG_TYPE_GRAD_X = 0x00000002,
    SEQ_CFG_TYPE_GRAD_Y = 0x00000004,
    SEQ_CFG_TYPE_GRAD_Z = 0x00000008,
    SEQ_CFG_TYPE_RHO = 0x00000010,
    SEQ_CFG_TYPE_THETA = 0x00000020,
    SEQ_CFG_TYPE_OMEGA = 0x00000040,
    SEQ_CFG_TYPE_RF_TX = 0x00000080,
    SEQ_CFG_TYPE_RF_RX = 0x00000100,
};
enum
{
    SEQ_CFG_RF_GROUP_MODE_NONE = 0x00000000,
    SEQ_CFG_RF_GROUP_MODE_DUAL_SEQUENCE = 0x00000001,
};
enum
{
    SEQ_CFG_MAX_RF_GROUPS = 3,
    SEQ_CFG_CORE_RF_CHANNEL_1 = 0,
    SEQ_CFG_CORE_RF_CHANNEL_2 = 1,
    SEQ_CFG_NUM_CORE_RF_CHANNELS = 2,
    SEQ_CFG_CORE_TYPE_NONE = 0x0000,
    SEQ_CFG_CORE_TYPE_PRIMARY = 0x0001,
    SEQ_CFG_CORE_TYPE_SECONDARY = 0x0002,
    SEQ_CFG_CORE_TYPE_4RF_MODE = 0x0004,
    SEQ_CFG_CORE_TYPE_6RF_MODE = 0x0008,
    SEQ_CFG_MAX_CORES = 5,
    SEQ_CFG_MAX_CORE_SEQS = 8,
    SEQ_CFG_MAX_SECONDARY_CORE_SEQS = 7,
    SEQ_CFG_MAX_SEQ_IDS = (SEQ_CFG_MAX_CORE_SEQS +
                                       ((SEQ_CFG_MAX_CORES - 1) *
                                        SEQ_CFG_MAX_SECONDARY_CORE_SEQS)),
    SEQ_CFG_DEBUG_OPTION_DEFAULT = 0,
};
typedef struct
{
    n32 sscType;
    n32 ptxCapable;
    n32 fieldStrength;
    n32 rfAmpType;
    n32 receiverType;
} SeqCfgSysCfgInfo;
typedef struct
{
    s32 seqId;
    n32 seqType;
    s32 duplicateSeqId;
    s32 sspSeqId;
    s32 rfGroupId;
    s32 rfGroupTxChannel;
    n32 coreId;
    s32 coreRfChannel;
} SeqCfgSeqInfo;
typedef struct
{
    s32 coreId;
    n32 coreType;
    s32 requiredPhysicalTxId[SEQ_CFG_MAX_RF_GROUPS];
    n32 numSeqs;
    n32 seqs[SEQ_CFG_MAX_CORE_SEQS];
} SeqCfgCoreInfo;
typedef struct
{
    n32 txAmp;
    n32 txCoilType;
    n32 txNucleus;
    n32 txChannels;
} SeqCfgRfTxInfo;
typedef struct
{
    n32 rfGroupId;
    n32 numAppTxChannels;
    n32 txSeqTypes;
    n32 rxFlag;
    n32 rxSeqTypes;
    n32 mode;
    SeqCfgRfTxInfo txInfo;
} SeqCfgRfGroupInfo;
typedef struct
{
    s32 valid;
    n32 debugOptions;
    n32 numRfGroups;
    n32 numCores;
    n32 numAppSeqs;
    n32 numSeqs;
    SeqCfgSysCfgInfo sysCfg;
    SeqCfgRfGroupInfo rfGroups[SEQ_CFG_MAX_RF_GROUPS];
    SeqCfgCoreInfo cores[SEQ_CFG_MAX_CORES];
    SeqCfgSeqInfo seqs[SEQ_CFG_MAX_SEQ_IDS];
} SeqCfgInfo;
typedef struct SeqType
{
    n32 seqID;
    n32 seqOpt;
    char *pName;
} SeqType;
typedef enum {
    DABNORM,
    DABCINE,
    DABON,
    DABOFF
} TYPDAB_PACKETS;
typedef enum {
    NOPASS,
    PASSTHROUGH
} TYPACQ_PASS;
typedef SeqType SeqData;
typedef long WF_HW_WAVEFORM_PTR;
typedef long WF_HW_INSTR_PTR;
typedef ADDRESS WF_PULSE_FORWARD_ADDR;
typedef ADDRESS WF_INSTR_PTR;
typedef struct INST_NODE {
    struct INST_NODE *next;
    WF_HW_INSTR_PTR wf_instr_ptr;
    long amplitude;
    long period;
    long start;
    long end;
    long entry_group;
    WF_PULSE_FORWARD_ADDR pulse_hdr;
    WF_HW_INSTR_PTR wf_instr_ptr_secssp[SEQ_CFG_MAX_CORES];
    int num_iters;
    long* ampl_iters;
} WF_INSTR_HDR;
typedef struct {
    short amplitude;
} CONST_EXT;
typedef struct {
    short amplitude;
    float separation;
    float nsinc_cycles;
    float alpha;
} HADAMARD_EXT;
typedef struct {
    short start_amplitude;
    short end_amplitude;
} RAMP_EXT;
typedef struct {
    short amplitude;
    float nsinc_cycles;
    float alpha;
} SINC_EXT;
typedef struct {
    short amplitude;
    float start_phase;
    float phase_length;
    short offset;
} SINUSOID_EXT;
typedef union {
    CONST_EXT constext;
    HADAMARD_EXT hadamard;
    RAMP_EXT ramp;
    SINC_EXT sinc;
    SINUSOID_EXT sinusoid;
} WF_PULSE_EXT;
typedef enum {
    TYPBITS,
    TYPBRIDGED_CONST,
    TYPBRIDGED_RAMP,
    TYPCONSTANT,
    TYPEXTERNAL,
    TYPHADAMARD,
    TYPRAMP,
    TYPRESERVE,
    TYPSINC,
    TYPSINUSOID
} WF_PULSE_TYPES;
typedef enum {
    SSPUNKN,
    SSPDAB,
    SSPRBA,
    SSPXTR,
    SSPSYNC,
    SSPFREQ,
    SSPUBR,
    SSPPA,
    SSPPD,
    SSPPM,
    SSPPMD,
    SSPPEA,
    SSPPED,
    SSPPEM,
    SSPRFBITS,
    SSPSEQ,
    SSPSCP,
    SSPPASS,
    SSPATTEN,
    SSP3DIM,
    SSPTREG
} WF_PGMTAG;
typedef enum {
    PSDREUSEP,
    PSDNEWP
} WF_PGMREUSE;
typedef struct PULSE {
    const char *pulsename;
    long ninsts;
    WF_HW_WAVEFORM_PTR wave_addr;
    int board_type;
    WF_PGMREUSE reusep;
    WF_PGMTAG tag;
    long addtag;
    int id;
    long ctrlfield;
    WF_INSTR_HDR *inst_hdr_tail;
    WF_INSTR_HDR *inst_hdr_head;
    WF_PROCESSOR wavegen_type;
    WF_PULSE_TYPES type;
    short resolution;
    struct PULSE *assoc_pulse;
    WF_PULSE_EXT *ext;
    int rfgroup;
    int ptx_flag;
    int seq_id;
    int rx_flag;
    WF_HW_WAVEFORM_PTR wave_addr_secssp[SEQ_CFG_MAX_CORES];
} WF_PULSE;
typedef WF_PULSE * WF_PULSE_ADDR;
typedef struct INST_QUEUE_NODE {
    WF_INSTR_HDR *instr;
    struct INST_QUEUE_NODE *next;
    struct INST_QUEUE_NODE *new_queue;
    struct INST_QUEUE_NODE *last_queue;
} WF_INSTR_QUEUE;
typedef long SEQUENCE_ENTRIES[SEQ_CFG_MAX_SEQ_IDS];
typedef struct ENTRY_PT_NODE{
    WF_PULSE_ADDR ssp_pulse;
    long *entry_addresses;
    long time;
    struct ENTRY_PT_NODE *next;
} SEQUENCE_LIST;
typedef enum rbw_update_type {OVERWRITE_NONE, OVERWRITE_OPRBW, OVERWRITE_OPRBW2} RBW_UPDATE_TYPE;
typedef enum filter_block_type {SCAN, PRESCAN} FILTER_BLOCK_TYPE;
typedef struct {
  float decimation;
  int tdaq;
  float bw;
  float tsp;
  int fslot;
  int outputs;
  int prefills;
  int taps;
  } FILTER_INFO;
typedef struct
{
    int fit_order;
    int total_bases_per_axis;
    int num_terms[3][56];
    float alpha[3][56][6];
    float tau[3][56][6];
    int termIndex2xyzOrderMapping[3][56];
    int xyzOrder2termIndexMapping[6][6][6];
} HOEC_CAL_INFO;
typedef struct
{
    float hoec_coef[56][3];
    int hoec_xorder[56];
    int hoec_yorder[56];
    int hoec_zorder[56];
} RDB_HOEC_BASES_TYPE;
typedef struct {
    int xfull;
    int yfull;
    int zfull;
    float xfs;
    float yfs;
    float zfs;
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
    float xcc;
    float ycc;
    float zcc;
    float xbeta;
    float ybeta;
    float zbeta;
    float xirms;
    float yirms;
    float zirms;
    float xipeak;
    float yipeak;
    float zipeak;
    float xamptran;
    float yamptran;
    float zamptran;
    float xiavrgabs;
    float yiavrgabs;
    float ziavrgabs;
    float xirmspos;
    float yirmspos;
    float zirmspos;
    float xirmsneg;
    float yirmsneg;
    float zirmsneg;
    float xpwmdc;
    float ypwmdc;
    float zpwmdc;
} PHYS_GRAD;
typedef struct {
    int x;
    int xy;
    int xz;
    int xyz;
} t_xact;
typedef struct {
    int y;
    int xy;
    int yz;
    int xyz;
} t_yact;
typedef struct {
    int z;
    int xz;
    int yz;
    int xyz;
} t_zact;
typedef struct {
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
} ramp_t;
typedef struct {
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
    ramp_t opt;
    t_xact xrta;
    t_yact yrta;
    t_zact zrta;
    t_xact xfta;
    t_yact yfta;
    t_zact zfta;
    float xbeta;
    float ybeta;
    float zbeta;
    float tx_xyz;
    float ty_xyz;
    float tz_xyz;
    float tx_xy;
    float tx_xz;
    float ty_xy;
    float ty_yz;
    float tz_xz;
    float tz_yz;
    float tx;
    float ty;
    float tz;
    float xfs;
    float yfs;
    float zfs;
    float xirms;
    float yirms;
    float zirms;
    float xipeak;
    float yipeak;
    float zipeak;
    float xamptran;
    float yamptran;
    float zamptran;
    float xiavrgabs;
    float yiavrgabs;
    float ziavrgabs;
    float xirmspos;
    float yirmspos;
    float zirmspos;
    float xirmsneg;
    float yirmsneg;
    float zirmsneg;
    float xpwmdc;
    float ypwmdc;
    float zpwmdc;
    float scale_1axis_risetime;
    float scale_2axis_risetime;
    float scale_3axis_risetime;
} LOG_GRAD;
typedef struct {
    float xfs;
    float yfs;
    float zfs;
    int xrt;
    int yrt;
    int zrt;
    float xbeta;
    float ybeta;
    float zbeta;
    float xfov;
    float yfov;
    int xres;
    int yres;
    int ileaves;
    float xdis;
    float ydis;
    float zdis;
    float tsp;
    int osamps;
    float fbhw;
    int vvp;
    float pnsf;
    float taratio;
    float zarea;
} OPT_GRAD_INPUT;
typedef struct {
    float *agxw;
    int *pwgxw;
    int *pwgxwa;
    float *agyb;
    int *pwgyb;
    int *pwgyba;
    float *agzb;
    int *pwgzb;
    int *pwgzba;
    int *frsize;
    int *pwsamp;
    int *pwxgap;
} OPT_GRAD_PARAMS;


typedef __clock_t clock_t;



typedef __time_t time_t;


typedef __clockid_t clockid_t;
typedef __timer_t timer_t;
struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };

struct tm
{
  int tm_sec;
  int tm_min;
  int tm_hour;
  int tm_mday;
  int tm_mon;
  int tm_year;
  int tm_wday;
  int tm_yday;
  int tm_isdst;
  long int tm_gmtoff;
  __const char *tm_zone;
};


struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };
struct sigevent;
typedef __pid_t pid_t;

extern clock_t clock (void) __attribute__ ((__nothrow__));
extern time_t time (time_t *__timer) __attribute__ ((__nothrow__));
extern double difftime (time_t __time1, time_t __time0)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern time_t mktime (struct tm *__tp) __attribute__ ((__nothrow__));
extern size_t strftime (char *__restrict __s, size_t __maxsize,
   __const char *__restrict __format,
   __const struct tm *__restrict __tp) __attribute__ ((__nothrow__));

typedef struct __locale_struct
{
  struct __locale_data *__locales[13];
  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;
  const char *__names[13];
} *__locale_t;
typedef __locale_t locale_t;
extern size_t strftime_l (char *__restrict __s, size_t __maxsize,
     __const char *__restrict __format,
     __const struct tm *__restrict __tp,
     __locale_t __loc) __attribute__ ((__nothrow__));

extern struct tm *gmtime (__const time_t *__timer) __attribute__ ((__nothrow__));
extern struct tm *localtime (__const time_t *__timer) __attribute__ ((__nothrow__));

extern struct tm *gmtime_r (__const time_t *__restrict __timer,
       struct tm *__restrict __tp) __attribute__ ((__nothrow__));
extern struct tm *localtime_r (__const time_t *__restrict __timer,
          struct tm *__restrict __tp) __attribute__ ((__nothrow__));

extern char *asctime (__const struct tm *__tp) __attribute__ ((__nothrow__));
extern char *ctime (__const time_t *__timer) __attribute__ ((__nothrow__));

extern char *asctime_r (__const struct tm *__restrict __tp,
   char *__restrict __buf) __attribute__ ((__nothrow__));
extern char *ctime_r (__const time_t *__restrict __timer,
        char *__restrict __buf) __attribute__ ((__nothrow__));
extern char *__tzname[2];
extern int __daylight;
extern long int __timezone;
extern char *tzname[2];
extern void tzset (void) __attribute__ ((__nothrow__));
extern int daylight;
extern long int timezone;
extern int stime (__const time_t *__when) __attribute__ ((__nothrow__));
extern time_t timegm (struct tm *__tp) __attribute__ ((__nothrow__));
extern time_t timelocal (struct tm *__tp) __attribute__ ((__nothrow__));
extern int dysize (int __year) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int nanosleep (__const struct timespec *__requested_time,
        struct timespec *__remaining);
extern int clock_getres (clockid_t __clock_id, struct timespec *__res) __attribute__ ((__nothrow__));
extern int clock_gettime (clockid_t __clock_id, struct timespec *__tp) __attribute__ ((__nothrow__));
extern int clock_settime (clockid_t __clock_id, __const struct timespec *__tp)
     __attribute__ ((__nothrow__));
extern int clock_nanosleep (clockid_t __clock_id, int __flags,
       __const struct timespec *__req,
       struct timespec *__rem);
extern int clock_getcpuclockid (pid_t __pid, clockid_t *__clock_id) __attribute__ ((__nothrow__));
extern int timer_create (clockid_t __clock_id,
    struct sigevent *__restrict __evp,
    timer_t *__restrict __timerid) __attribute__ ((__nothrow__));
extern int timer_delete (timer_t __timerid) __attribute__ ((__nothrow__));
extern int timer_settime (timer_t __timerid, int __flags,
     __const struct itimerspec *__restrict __value,
     struct itimerspec *__restrict __ovalue) __attribute__ ((__nothrow__));
extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
     __attribute__ ((__nothrow__));
extern int timer_getoverrun (timer_t __timerid) __attribute__ ((__nothrow__));

typedef struct timespec GEtimespec;
typedef unsigned short int dbkey_exam_type;
typedef short int dbkey_magic_type;
typedef short int dbkey_series_type;
typedef int dbkey_image_type;
typedef struct {
   char su_id[4];
   dbkey_magic_type mg_no;
   dbkey_exam_type ex_no;
   dbkey_series_type se_no;
   dbkey_image_type im_no;
} DbKey;
typedef char OP_NMRID_TYPE[12];
typedef struct {
 n16 rev;
 n16 length;
 OP_NMRID_TYPE req_nmrid;
 OP_NMRID_TYPE resp_nmrid;
 n16 opcode;
 n16 packet_type;
 n16 seq_num;
 n32 status;
 } OP_HDR1_TYPE;
typedef struct _OP_HDR_TYPE {
 s8 rev;
 s8 endian;
 n16 length;
 OP_NMRID_TYPE req_nmrid;
 OP_NMRID_TYPE resp_nmrid;
 n16 opcode;
 n16 packet_type;
 n16 seq_num;
 n16 pad;
 n32 status;
 } OP_HDR_TYPE;
typedef struct _OP_RECN_READY_TYPE
{
    DbKey dbkey;
    s32 seq_number;
    GEtimespec time_stamp;
    s32 run_no;
    s32 prep_flag;
    n32 patient_checksum;
    char clinicalCoilName[32];
} OP_RECN_READY_TYPE;
typedef struct _OP_RECN_READY_PACK_TYPE
{
    OP_HDR_TYPE hdr;
    OP_RECN_READY_TYPE req;
} OP_RECN_READY_PACK_TYPE;
typedef struct
{
    s32 somes32bitint;
    n16 somen16bitint;
    char somechar;
    unsigned long someulong;
    float somefloat;
} OP_RECN_FOO_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_RECN_FOO_TYPE req;
} OP_RECN_FOO_PACK_TYPE;
typedef struct _OP_RECN_START_TYPE
{
    s32 seq_number;
    GEtimespec time_stamp;
} OP_RECN_START_TYPE;
typedef struct _OP_RECN_START_PACK_TYPE
{
    OP_HDR_TYPE hdr;
    OP_RECN_START_TYPE req;
} OP_RECN_START_PACK_TYPE;
typedef struct
{
    s32 seq_number;
    s32 status;
    s32 aborted_pass_num;
} OP_RECN_SCAN_STOPPED_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_RECN_SCAN_STOPPED_TYPE req;
} OP_RECN_SCAN_STOPPED_PACK_TYPE;
typedef struct
{
    DbKey dbkey;
    s32 seq_number;
    char scan_initiator[12];
} OP_RECN_STOP_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_RECN_STOP_TYPE req;
} OP_RECN_STOP_PACK_TYPE;
typedef struct
{
    s32 seq_number;
} OP_RECN_IM_ALLOC_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_RECN_IM_ALLOC_TYPE req;
} OP_RECN_IM_ALLOC_PACK_TYPE;
typedef struct
{
    s32 seq_number;
} OP_RECN_SCAN_STARTED_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_RECN_SCAN_STARTED_TYPE req;
} OP_RECN_SCAN_STARTED_PACK_TYPE;
extern int fastcard_viewtable[2048];
typedef struct
{
    s32 table_size;
    s32 block_size;
    s32 first_entry_index;
    s32 table[256];
} OP_VIEWTABLE_UPDATE_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    OP_VIEWTABLE_UPDATE_TYPE pkt;
} OP_VIEWTABLE_UPDATE_PACK_TYPE;
typedef struct
{
    n64 mrhdr;
    n64 pixelhdr;
    n64 pixeldata;
    n64 raw_offset;
    n64 raw_receivers;
    n64 pixeldata3;
} MROR_ADDR_BLOCK;
typedef struct
{
    OP_HDR_TYPE hdr;
    MROR_ADDR_BLOCK mrab;
} MROR_ADDR_BLOCK_PKT;
typedef struct
{
    n32 recon_ts;
} MROR_RETRIEVAL_DONE_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    MROR_RETRIEVAL_DONE_TYPE retrieve_done;
} __attribute__((__may_alias__)) MROR_ADDR_BLOCK_PACK_TYPE;
typedef struct
{
    s32 exam_number;
    s32 calib_flag;
} SCAN_CALIB_INFO_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    SCAN_CALIB_INFO_TYPE info;
} SCAN_CALIB_INFO_PACK_TYPE;
typedef struct _OP_RECN_SIZE_CHECK_TYPE
{
    n64 total_bam_size;
    n64 total_disk_size;
} OP_RECN_SIZE_CHECK_TYPE;
typedef struct _OP_RECN_SIZE_CHECK_PACK_TYPE
{
    OP_HDR_TYPE hdr;
    OP_RECN_SIZE_CHECK_TYPE req;
} OP_RECN_SIZE_CHECK_PACK_TYPE;
typedef struct
{
    s32 exam_number;
} EXAM_SCAN_DONE_TYPE;
typedef struct
{
    OP_HDR_TYPE hdr;
    EXAM_SCAN_DONE_TYPE info;
} EXAM_SCAN_DONE_PACK_TYPE;
typedef struct _POSITION_DETECTION_DONE_TYPE
{
    n32 object_detected;
    f32 object_si_position_mm;
    f32 right_most_voxel_mm;
    f32 anterior_most_voxel_mm;
    f32 superior_most_voxel_mm;
    n32 checksum;
} POSITION_DETECTION_DONE_TYPE;
typedef struct _POSITION_DETECTION_DONE_PACK_TYPE
{
    OP_HDR_TYPE hdr;
    POSITION_DETECTION_DONE_TYPE info;
} POSITION_DETECTION_DONE_PACK_TYPE;
typedef struct _OP_CTT_UPDATE_TYPE
{
    s64 calUniqueNo;
    ChannelTransTableEntryType cttentry[4];
    n32 errorCode;
} OP_CTT_UPDATE_TYPE;
typedef struct _OP_CTT_UPDATE_PACK_TYPE
{
    OP_HDR_TYPE hdr;
    OP_CTT_UPDATE_TYPE req;
} OP_CTT_UPDATE_PACK_TYPE;
typedef enum PSD_PSC_CONTROL
{
    PSD_CONTROL_PSC_SKIP = -1,
    APS_CONTROL_PSC = 0,
    PSD_CONTROL_PSC_RUN = 1,
    PSD_CONTROL_PSC_SPECIAL = 2
} PSD_PSC_CONTROL_E;
typedef enum GRADSHIM_SELECTION
{
    GRADSHIM_OFF = 0,
    GRADSHIM_ON = 1,
    GRADSHIM_AUTO = 2
} GRADSHIM_SELECTION_E;
typedef enum PRESSCFH_EXCITATION_TYPE {
    PRESSCFH_SLICE = 1,
    PRESSCFH_SLAB = 2,
    PRESSCFH_SHIMVOL = 3,
    PRESSCFH_SHIMVOL_SLICE = 4,
    PRESSCFH_NONE = 5
} PRESSCFH_EXCITATION_TYPE_E;
typedef struct zy_index {
    n16 view;
    n16 slice;
    n16 flags;
} ZY_INDEX;
typedef struct zy_dist1 {
    float distance;
    n16 view;
    n16 slice;
    n16 flags;
} ZY_DIST1;
typedef struct _RDB_SLICE_INFO_ENTRY
{
    short pass_number;
    short slice_in_pass;
    float gw_point1[3];
    float gw_point2[3];
    float gw_point3[3];
    short transpose;
    short rotate;
    unsigned int coilConfigUID;
    float fov_freq_scale;
    float fov_phase_scale;
    float slthick_scale;
    float freq_loc_shift;
    float phase_loc_shift;
    float slice_loc_shift;
    short sliceGroupId;
    short sliceIndexInGroup;
} RDB_SLICE_INFO_ENTRY;
s32 seqCfgInit(SeqCfgInfo *pSeqCfg,
               const SeqCfgSysCfgInfo *pSysCfg,
               n32 debugOptions);
s32 seqCfgSetRfTxInfo(SeqCfgInfo *pSeqCfg,
                      n32 rfGroupId,
                      n32 txAmp,
                      n32 txCoilType,
                      n32 txNucleus,
                      n32 txChannels);
s32 seqCfgSetAppRfSeqUsage(SeqCfgInfo *pSeqCfg,
                           n32 rfGroupId,
                           n32 txSeqTypes,
                           n32 rxFlag,
                           n32 rxSeqTypes);
s32 seqCfgGetTxConfigs(const SeqCfgInfo *pSeqCfg,
                       n32 rfGroupId,
                       n32 *pTxConfigs,
                       n32 *pNumTxConfigs);
s32 seqCfgSetAppTxUsage(SeqCfgInfo *pSeqCfg,
                        n32 rfGroupId,
                        n32 numAppTxChannels);
s32 seqCfgValidate(SeqCfgInfo *pSeqCfg);
s32 seqCfgGetNumAppSeqs(const SeqCfgInfo *pSeqCfg,
                        n32 *pNumAppSeqs);
s32 seqCfgGetNumSeqs(const SeqCfgInfo *pSeqCfg,
                     n32 *pNumSeqs);
s32 seqCfgLookupSeqId(const SeqCfgInfo *pSeqCfg,
                      n32 rfGroupId,
                      n32 rfGroupTxChannel,
                      n32 rfTxRxType,
                      n32 seqType,
                      n32 *pSeqId);
s32 seqCfgLookupSeqIds(const SeqCfgInfo *pSeqCfg,
                       n32 rfGroupId,
                       n32 rfTxRxType,
                       n32 seqType,
                       n32 *pSeqIds,
                       n32 *pNumSeqIds);
const SeqCfgSeqInfo * seqCfgGetSeqInfo(const SeqCfgInfo *pSeqCfg,
                                       n32 seqId);
extern int cfswgut;
extern int cfswrfut;
extern int cfswssput;
extern int cfhwgut;
extern int cfhwrfut;
extern int cfhwssput;
typedef char EXTERN_FILENAME[80];
typedef char *EXTERN_FILENAME2;

typedef long double float_t;
typedef long double double_t;

extern double acos (double __x) __attribute__ ((__nothrow__)); extern double __acos (double __x) __attribute__ ((__nothrow__));
extern double asin (double __x) __attribute__ ((__nothrow__)); extern double __asin (double __x) __attribute__ ((__nothrow__));
extern double atan (double __x) __attribute__ ((__nothrow__)); extern double __atan (double __x) __attribute__ ((__nothrow__));
extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__)); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__));
extern double cos (double __x) __attribute__ ((__nothrow__)); extern double __cos (double __x) __attribute__ ((__nothrow__));
extern double sin (double __x) __attribute__ ((__nothrow__)); extern double __sin (double __x) __attribute__ ((__nothrow__));
extern double tan (double __x) __attribute__ ((__nothrow__)); extern double __tan (double __x) __attribute__ ((__nothrow__));
extern double cosh (double __x) __attribute__ ((__nothrow__)); extern double __cosh (double __x) __attribute__ ((__nothrow__));
extern double sinh (double __x) __attribute__ ((__nothrow__)); extern double __sinh (double __x) __attribute__ ((__nothrow__));
extern double tanh (double __x) __attribute__ ((__nothrow__)); extern double __tanh (double __x) __attribute__ ((__nothrow__));


extern double acosh (double __x) __attribute__ ((__nothrow__)); extern double __acosh (double __x) __attribute__ ((__nothrow__));
extern double asinh (double __x) __attribute__ ((__nothrow__)); extern double __asinh (double __x) __attribute__ ((__nothrow__));
extern double atanh (double __x) __attribute__ ((__nothrow__)); extern double __atanh (double __x) __attribute__ ((__nothrow__));


extern double exp (double __x) __attribute__ ((__nothrow__)); extern double __exp (double __x) __attribute__ ((__nothrow__));
extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__)); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__));
extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__)); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__));
extern double log (double __x) __attribute__ ((__nothrow__)); extern double __log (double __x) __attribute__ ((__nothrow__));
extern double log10 (double __x) __attribute__ ((__nothrow__)); extern double __log10 (double __x) __attribute__ ((__nothrow__));
extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__)); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__));


extern double expm1 (double __x) __attribute__ ((__nothrow__)); extern double __expm1 (double __x) __attribute__ ((__nothrow__));
extern double log1p (double __x) __attribute__ ((__nothrow__)); extern double __log1p (double __x) __attribute__ ((__nothrow__));
extern double logb (double __x) __attribute__ ((__nothrow__)); extern double __logb (double __x) __attribute__ ((__nothrow__));


extern double exp2 (double __x) __attribute__ ((__nothrow__)); extern double __exp2 (double __x) __attribute__ ((__nothrow__));
extern double log2 (double __x) __attribute__ ((__nothrow__)); extern double __log2 (double __x) __attribute__ ((__nothrow__));


extern double pow (double __x, double __y) __attribute__ ((__nothrow__)); extern double __pow (double __x, double __y) __attribute__ ((__nothrow__));
extern double sqrt (double __x) __attribute__ ((__nothrow__)); extern double __sqrt (double __x) __attribute__ ((__nothrow__));


extern double hypot (double __x, double __y) __attribute__ ((__nothrow__)); extern double __hypot (double __x, double __y) __attribute__ ((__nothrow__));


extern double cbrt (double __x) __attribute__ ((__nothrow__)); extern double __cbrt (double __x) __attribute__ ((__nothrow__));


extern double ceil (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __ceil (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double fabs (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __fabs (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double floor (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __floor (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double fmod (double __x, double __y) __attribute__ ((__nothrow__)); extern double __fmod (double __x, double __y) __attribute__ ((__nothrow__));
extern int __isinf (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finite (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinf (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finite (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double drem (double __x, double __y) __attribute__ ((__nothrow__)); extern double __drem (double __x, double __y) __attribute__ ((__nothrow__));
extern double significand (double __x) __attribute__ ((__nothrow__)); extern double __significand (double __x) __attribute__ ((__nothrow__));

extern double copysign (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __copysign (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));


extern double nan (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __nan (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnan (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnan (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double j0 (double) __attribute__ ((__nothrow__)); extern double __j0 (double) __attribute__ ((__nothrow__));
extern double j1 (double) __attribute__ ((__nothrow__)); extern double __j1 (double) __attribute__ ((__nothrow__));
extern double jn (int, double) __attribute__ ((__nothrow__)); extern double __jn (int, double) __attribute__ ((__nothrow__));
extern double y0 (double) __attribute__ ((__nothrow__)); extern double __y0 (double) __attribute__ ((__nothrow__));
extern double y1 (double) __attribute__ ((__nothrow__)); extern double __y1 (double) __attribute__ ((__nothrow__));
extern double yn (int, double) __attribute__ ((__nothrow__)); extern double __yn (int, double) __attribute__ ((__nothrow__));

extern double erf (double) __attribute__ ((__nothrow__)); extern double __erf (double) __attribute__ ((__nothrow__));
extern double erfc (double) __attribute__ ((__nothrow__)); extern double __erfc (double) __attribute__ ((__nothrow__));
extern double lgamma (double) __attribute__ ((__nothrow__)); extern double __lgamma (double) __attribute__ ((__nothrow__));


extern double tgamma (double) __attribute__ ((__nothrow__)); extern double __tgamma (double) __attribute__ ((__nothrow__));

extern double gamma (double) __attribute__ ((__nothrow__)); extern double __gamma (double) __attribute__ ((__nothrow__));
extern double lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__)); extern double __lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__));

extern double rint (double __x) __attribute__ ((__nothrow__)); extern double __rint (double __x) __attribute__ ((__nothrow__));
extern double nextafter (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __nextafter (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double nexttoward (double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __nexttoward (double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double remainder (double __x, double __y) __attribute__ ((__nothrow__)); extern double __remainder (double __x, double __y) __attribute__ ((__nothrow__));
extern double scalbn (double __x, int __n) __attribute__ ((__nothrow__)); extern double __scalbn (double __x, int __n) __attribute__ ((__nothrow__));
extern int ilogb (double __x) __attribute__ ((__nothrow__)); extern int __ilogb (double __x) __attribute__ ((__nothrow__));
extern double scalbln (double __x, long int __n) __attribute__ ((__nothrow__)); extern double __scalbln (double __x, long int __n) __attribute__ ((__nothrow__));
extern double nearbyint (double __x) __attribute__ ((__nothrow__)); extern double __nearbyint (double __x) __attribute__ ((__nothrow__));
extern double round (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __round (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double trunc (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __trunc (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__)); extern double __remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__));
extern long int lrint (double __x) __attribute__ ((__nothrow__)); extern long int __lrint (double __x) __attribute__ ((__nothrow__));
extern long long int llrint (double __x) __attribute__ ((__nothrow__)); extern long long int __llrint (double __x) __attribute__ ((__nothrow__));
extern long int lround (double __x) __attribute__ ((__nothrow__)); extern long int __lround (double __x) __attribute__ ((__nothrow__));
extern long long int llround (double __x) __attribute__ ((__nothrow__)); extern long long int __llround (double __x) __attribute__ ((__nothrow__));
extern double fdim (double __x, double __y) __attribute__ ((__nothrow__)); extern double __fdim (double __x, double __y) __attribute__ ((__nothrow__));
extern double fmax (double __x, double __y) __attribute__ ((__nothrow__)); extern double __fmax (double __x, double __y) __attribute__ ((__nothrow__));
extern double fmin (double __x, double __y) __attribute__ ((__nothrow__)); extern double __fmin (double __x, double __y) __attribute__ ((__nothrow__));
extern int __fpclassify (double __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern int __signbit (double __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern double fma (double __x, double __y, double __z) __attribute__ ((__nothrow__)); extern double __fma (double __x, double __y, double __z) __attribute__ ((__nothrow__));

extern double scalb (double __x, double __n) __attribute__ ((__nothrow__)); extern double __scalb (double __x, double __n) __attribute__ ((__nothrow__));

extern float acosf (float __x) __attribute__ ((__nothrow__)); extern float __acosf (float __x) __attribute__ ((__nothrow__));
extern float asinf (float __x) __attribute__ ((__nothrow__)); extern float __asinf (float __x) __attribute__ ((__nothrow__));
extern float atanf (float __x) __attribute__ ((__nothrow__)); extern float __atanf (float __x) __attribute__ ((__nothrow__));
extern float atan2f (float __y, float __x) __attribute__ ((__nothrow__)); extern float __atan2f (float __y, float __x) __attribute__ ((__nothrow__));
extern float cosf (float __x) __attribute__ ((__nothrow__)); extern float __cosf (float __x) __attribute__ ((__nothrow__));
extern float sinf (float __x) __attribute__ ((__nothrow__)); extern float __sinf (float __x) __attribute__ ((__nothrow__));
extern float tanf (float __x) __attribute__ ((__nothrow__)); extern float __tanf (float __x) __attribute__ ((__nothrow__));
extern float coshf (float __x) __attribute__ ((__nothrow__)); extern float __coshf (float __x) __attribute__ ((__nothrow__));
extern float sinhf (float __x) __attribute__ ((__nothrow__)); extern float __sinhf (float __x) __attribute__ ((__nothrow__));
extern float tanhf (float __x) __attribute__ ((__nothrow__)); extern float __tanhf (float __x) __attribute__ ((__nothrow__));


extern float acoshf (float __x) __attribute__ ((__nothrow__)); extern float __acoshf (float __x) __attribute__ ((__nothrow__));
extern float asinhf (float __x) __attribute__ ((__nothrow__)); extern float __asinhf (float __x) __attribute__ ((__nothrow__));
extern float atanhf (float __x) __attribute__ ((__nothrow__)); extern float __atanhf (float __x) __attribute__ ((__nothrow__));


extern float expf (float __x) __attribute__ ((__nothrow__)); extern float __expf (float __x) __attribute__ ((__nothrow__));
extern float frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__)); extern float __frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__));
extern float ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__)); extern float __ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__));
extern float logf (float __x) __attribute__ ((__nothrow__)); extern float __logf (float __x) __attribute__ ((__nothrow__));
extern float log10f (float __x) __attribute__ ((__nothrow__)); extern float __log10f (float __x) __attribute__ ((__nothrow__));
extern float modff (float __x, float *__iptr) __attribute__ ((__nothrow__)); extern float __modff (float __x, float *__iptr) __attribute__ ((__nothrow__));


extern float expm1f (float __x) __attribute__ ((__nothrow__)); extern float __expm1f (float __x) __attribute__ ((__nothrow__));
extern float log1pf (float __x) __attribute__ ((__nothrow__)); extern float __log1pf (float __x) __attribute__ ((__nothrow__));
extern float logbf (float __x) __attribute__ ((__nothrow__)); extern float __logbf (float __x) __attribute__ ((__nothrow__));


extern float exp2f (float __x) __attribute__ ((__nothrow__)); extern float __exp2f (float __x) __attribute__ ((__nothrow__));
extern float log2f (float __x) __attribute__ ((__nothrow__)); extern float __log2f (float __x) __attribute__ ((__nothrow__));


extern float powf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __powf (float __x, float __y) __attribute__ ((__nothrow__));
extern float sqrtf (float __x) __attribute__ ((__nothrow__)); extern float __sqrtf (float __x) __attribute__ ((__nothrow__));


extern float hypotf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __hypotf (float __x, float __y) __attribute__ ((__nothrow__));


extern float cbrtf (float __x) __attribute__ ((__nothrow__)); extern float __cbrtf (float __x) __attribute__ ((__nothrow__));


extern float ceilf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __ceilf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float fabsf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __fabsf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float floorf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __floorf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float fmodf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __fmodf (float __x, float __y) __attribute__ ((__nothrow__));
extern int __isinff (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finitef (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinff (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finitef (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float dremf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __dremf (float __x, float __y) __attribute__ ((__nothrow__));
extern float significandf (float __x) __attribute__ ((__nothrow__)); extern float __significandf (float __x) __attribute__ ((__nothrow__));

extern float copysignf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __copysignf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));


extern float nanf (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __nanf (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnanf (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnanf (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float j0f (float) __attribute__ ((__nothrow__)); extern float __j0f (float) __attribute__ ((__nothrow__));
extern float j1f (float) __attribute__ ((__nothrow__)); extern float __j1f (float) __attribute__ ((__nothrow__));
extern float jnf (int, float) __attribute__ ((__nothrow__)); extern float __jnf (int, float) __attribute__ ((__nothrow__));
extern float y0f (float) __attribute__ ((__nothrow__)); extern float __y0f (float) __attribute__ ((__nothrow__));
extern float y1f (float) __attribute__ ((__nothrow__)); extern float __y1f (float) __attribute__ ((__nothrow__));
extern float ynf (int, float) __attribute__ ((__nothrow__)); extern float __ynf (int, float) __attribute__ ((__nothrow__));

extern float erff (float) __attribute__ ((__nothrow__)); extern float __erff (float) __attribute__ ((__nothrow__));
extern float erfcf (float) __attribute__ ((__nothrow__)); extern float __erfcf (float) __attribute__ ((__nothrow__));
extern float lgammaf (float) __attribute__ ((__nothrow__)); extern float __lgammaf (float) __attribute__ ((__nothrow__));


extern float tgammaf (float) __attribute__ ((__nothrow__)); extern float __tgammaf (float) __attribute__ ((__nothrow__));

extern float gammaf (float) __attribute__ ((__nothrow__)); extern float __gammaf (float) __attribute__ ((__nothrow__));
extern float lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__)); extern float __lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__));

extern float rintf (float __x) __attribute__ ((__nothrow__)); extern float __rintf (float __x) __attribute__ ((__nothrow__));
extern float nextafterf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __nextafterf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float remainderf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __remainderf (float __x, float __y) __attribute__ ((__nothrow__));
extern float scalbnf (float __x, int __n) __attribute__ ((__nothrow__)); extern float __scalbnf (float __x, int __n) __attribute__ ((__nothrow__));
extern int ilogbf (float __x) __attribute__ ((__nothrow__)); extern int __ilogbf (float __x) __attribute__ ((__nothrow__));
extern float scalblnf (float __x, long int __n) __attribute__ ((__nothrow__)); extern float __scalblnf (float __x, long int __n) __attribute__ ((__nothrow__));
extern float nearbyintf (float __x) __attribute__ ((__nothrow__)); extern float __nearbyintf (float __x) __attribute__ ((__nothrow__));
extern float roundf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __roundf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float truncf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __truncf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__)); extern float __remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__));
extern long int lrintf (float __x) __attribute__ ((__nothrow__)); extern long int __lrintf (float __x) __attribute__ ((__nothrow__));
extern long long int llrintf (float __x) __attribute__ ((__nothrow__)); extern long long int __llrintf (float __x) __attribute__ ((__nothrow__));
extern long int lroundf (float __x) __attribute__ ((__nothrow__)); extern long int __lroundf (float __x) __attribute__ ((__nothrow__));
extern long long int llroundf (float __x) __attribute__ ((__nothrow__)); extern long long int __llroundf (float __x) __attribute__ ((__nothrow__));
extern float fdimf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __fdimf (float __x, float __y) __attribute__ ((__nothrow__));
extern float fmaxf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __fmaxf (float __x, float __y) __attribute__ ((__nothrow__));
extern float fminf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __fminf (float __x, float __y) __attribute__ ((__nothrow__));
extern int __fpclassifyf (float __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern int __signbitf (float __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern float fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__)); extern float __fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__));

extern float scalbf (float __x, float __n) __attribute__ ((__nothrow__)); extern float __scalbf (float __x, float __n) __attribute__ ((__nothrow__));

extern long double acosl (long double __x) __attribute__ ((__nothrow__)); extern long double __acosl (long double __x) __attribute__ ((__nothrow__));
extern long double asinl (long double __x) __attribute__ ((__nothrow__)); extern long double __asinl (long double __x) __attribute__ ((__nothrow__));
extern long double atanl (long double __x) __attribute__ ((__nothrow__)); extern long double __atanl (long double __x) __attribute__ ((__nothrow__));
extern long double atan2l (long double __y, long double __x) __attribute__ ((__nothrow__)); extern long double __atan2l (long double __y, long double __x) __attribute__ ((__nothrow__));
extern long double cosl (long double __x) __attribute__ ((__nothrow__)); extern long double __cosl (long double __x) __attribute__ ((__nothrow__));
extern long double sinl (long double __x) __attribute__ ((__nothrow__)); extern long double __sinl (long double __x) __attribute__ ((__nothrow__));
extern long double tanl (long double __x) __attribute__ ((__nothrow__)); extern long double __tanl (long double __x) __attribute__ ((__nothrow__));
extern long double coshl (long double __x) __attribute__ ((__nothrow__)); extern long double __coshl (long double __x) __attribute__ ((__nothrow__));
extern long double sinhl (long double __x) __attribute__ ((__nothrow__)); extern long double __sinhl (long double __x) __attribute__ ((__nothrow__));
extern long double tanhl (long double __x) __attribute__ ((__nothrow__)); extern long double __tanhl (long double __x) __attribute__ ((__nothrow__));


extern long double acoshl (long double __x) __attribute__ ((__nothrow__)); extern long double __acoshl (long double __x) __attribute__ ((__nothrow__));
extern long double asinhl (long double __x) __attribute__ ((__nothrow__)); extern long double __asinhl (long double __x) __attribute__ ((__nothrow__));
extern long double atanhl (long double __x) __attribute__ ((__nothrow__)); extern long double __atanhl (long double __x) __attribute__ ((__nothrow__));


extern long double expl (long double __x) __attribute__ ((__nothrow__)); extern long double __expl (long double __x) __attribute__ ((__nothrow__));
extern long double frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__)); extern long double __frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__));
extern long double ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__)); extern long double __ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__));
extern long double logl (long double __x) __attribute__ ((__nothrow__)); extern long double __logl (long double __x) __attribute__ ((__nothrow__));
extern long double log10l (long double __x) __attribute__ ((__nothrow__)); extern long double __log10l (long double __x) __attribute__ ((__nothrow__));
extern long double modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__)); extern long double __modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__));


extern long double expm1l (long double __x) __attribute__ ((__nothrow__)); extern long double __expm1l (long double __x) __attribute__ ((__nothrow__));
extern long double log1pl (long double __x) __attribute__ ((__nothrow__)); extern long double __log1pl (long double __x) __attribute__ ((__nothrow__));
extern long double logbl (long double __x) __attribute__ ((__nothrow__)); extern long double __logbl (long double __x) __attribute__ ((__nothrow__));


extern long double exp2l (long double __x) __attribute__ ((__nothrow__)); extern long double __exp2l (long double __x) __attribute__ ((__nothrow__));
extern long double log2l (long double __x) __attribute__ ((__nothrow__)); extern long double __log2l (long double __x) __attribute__ ((__nothrow__));


extern long double powl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __powl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double sqrtl (long double __x) __attribute__ ((__nothrow__)); extern long double __sqrtl (long double __x) __attribute__ ((__nothrow__));


extern long double hypotl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __hypotl (long double __x, long double __y) __attribute__ ((__nothrow__));


extern long double cbrtl (long double __x) __attribute__ ((__nothrow__)); extern long double __cbrtl (long double __x) __attribute__ ((__nothrow__));


extern long double ceill (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __ceill (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double fabsl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __fabsl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double floorl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __floorl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double fmodl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __fmodl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern int __isinfl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finitel (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinfl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finitel (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double dreml (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __dreml (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double significandl (long double __x) __attribute__ ((__nothrow__)); extern long double __significandl (long double __x) __attribute__ ((__nothrow__));

extern long double copysignl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __copysignl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));


extern long double nanl (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __nanl (__const char *__tagb) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnanl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnanl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double j0l (long double) __attribute__ ((__nothrow__)); extern long double __j0l (long double) __attribute__ ((__nothrow__));
extern long double j1l (long double) __attribute__ ((__nothrow__)); extern long double __j1l (long double) __attribute__ ((__nothrow__));
extern long double jnl (int, long double) __attribute__ ((__nothrow__)); extern long double __jnl (int, long double) __attribute__ ((__nothrow__));
extern long double y0l (long double) __attribute__ ((__nothrow__)); extern long double __y0l (long double) __attribute__ ((__nothrow__));
extern long double y1l (long double) __attribute__ ((__nothrow__)); extern long double __y1l (long double) __attribute__ ((__nothrow__));
extern long double ynl (int, long double) __attribute__ ((__nothrow__)); extern long double __ynl (int, long double) __attribute__ ((__nothrow__));

extern long double erfl (long double) __attribute__ ((__nothrow__)); extern long double __erfl (long double) __attribute__ ((__nothrow__));
extern long double erfcl (long double) __attribute__ ((__nothrow__)); extern long double __erfcl (long double) __attribute__ ((__nothrow__));
extern long double lgammal (long double) __attribute__ ((__nothrow__)); extern long double __lgammal (long double) __attribute__ ((__nothrow__));


extern long double tgammal (long double) __attribute__ ((__nothrow__)); extern long double __tgammal (long double) __attribute__ ((__nothrow__));

extern long double gammal (long double) __attribute__ ((__nothrow__)); extern long double __gammal (long double) __attribute__ ((__nothrow__));
extern long double lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__)); extern long double __lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__));

extern long double rintl (long double __x) __attribute__ ((__nothrow__)); extern long double __rintl (long double __x) __attribute__ ((__nothrow__));
extern long double nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double remainderl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __remainderl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double scalbnl (long double __x, int __n) __attribute__ ((__nothrow__)); extern long double __scalbnl (long double __x, int __n) __attribute__ ((__nothrow__));
extern int ilogbl (long double __x) __attribute__ ((__nothrow__)); extern int __ilogbl (long double __x) __attribute__ ((__nothrow__));
extern long double scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__)); extern long double __scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__));
extern long double nearbyintl (long double __x) __attribute__ ((__nothrow__)); extern long double __nearbyintl (long double __x) __attribute__ ((__nothrow__));
extern long double roundl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __roundl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double truncl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __truncl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__)); extern long double __remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__));
extern long int lrintl (long double __x) __attribute__ ((__nothrow__)); extern long int __lrintl (long double __x) __attribute__ ((__nothrow__));
extern long long int llrintl (long double __x) __attribute__ ((__nothrow__)); extern long long int __llrintl (long double __x) __attribute__ ((__nothrow__));
extern long int lroundl (long double __x) __attribute__ ((__nothrow__)); extern long int __lroundl (long double __x) __attribute__ ((__nothrow__));
extern long long int llroundl (long double __x) __attribute__ ((__nothrow__)); extern long long int __llroundl (long double __x) __attribute__ ((__nothrow__));
extern long double fdiml (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __fdiml (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double fmaxl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __fmaxl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double fminl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __fminl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern int __fpclassifyl (long double __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern int __signbitl (long double __value) __attribute__ ((__nothrow__))
     __attribute__ ((__const__));
extern long double fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__)); extern long double __fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__));

extern long double scalbl (long double __x, long double __n) __attribute__ ((__nothrow__)); extern long double __scalbl (long double __x, long double __n) __attribute__ ((__nothrow__));
extern int signgam;
enum
  {
    FP_NAN,
    FP_INFINITE,
    FP_ZERO,
    FP_SUBNORMAL,
    FP_NORMAL
  };
typedef enum
{
  _IEEE_ = -1,
  _SVID_,
  _XOPEN_,
  _POSIX_,
  _ISOC_
} _LIB_VERSION_TYPE;
extern _LIB_VERSION_TYPE _LIB_VERSION;
struct exception
  {
    int type;
    char *name;
    double arg1;
    double arg2;
    double retval;
  };
extern int matherr (struct exception *__exc);


union wait
  {
    int w_status;
    struct
      {
 unsigned int __w_termsig:7;
 unsigned int __w_coredump:1;
 unsigned int __w_retcode:8;
 unsigned int:16;
      } __wait_terminated;
    struct
      {
 unsigned int __w_stopval:8;
 unsigned int __w_stopsig:8;
 unsigned int:16;
      } __wait_stopped;
  };
typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));

typedef struct
  {
    int quot;
    int rem;
  } div_t;
typedef struct
  {
    long int quot;
    long int rem;
  } ldiv_t;


__extension__ typedef struct
  {
    long long int quot;
    long long int rem;
  } lldiv_t;

extern size_t __ctype_get_mb_cur_max (void) __attribute__ ((__nothrow__)) ;

extern double atof (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern int atoi (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern long int atol (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;


__extension__ extern long long int atoll (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;


extern double strtod (__const char *__restrict __nptr,
        char **__restrict __endptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;


extern float strtof (__const char *__restrict __nptr,
       char **__restrict __endptr) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern long double strtold (__const char *__restrict __nptr,
       char **__restrict __endptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;


extern long int strtol (__const char *__restrict __nptr,
   char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern unsigned long int strtoul (__const char *__restrict __nptr,
      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

__extension__
extern long long int strtoq (__const char *__restrict __nptr,
        char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
__extension__
extern unsigned long long int strtouq (__const char *__restrict __nptr,
           char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

__extension__
extern long long int strtoll (__const char *__restrict __nptr,
         char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
__extension__
extern unsigned long long int strtoull (__const char *__restrict __nptr,
     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern char *l64a (long int __n) __attribute__ ((__nothrow__)) ;
extern long int a64l (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;
typedef __loff_t loff_t;
typedef __ino_t ino_t;
typedef __dev_t dev_t;
typedef __gid_t gid_t;
typedef __mode_t mode_t;
typedef __nlink_t nlink_t;
typedef __uid_t uid_t;
typedef __id_t id_t;
typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;
typedef __key_t key_t;
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));
typedef int register_t __attribute__ ((__mode__ (__word__)));
typedef int __sig_atomic_t;
typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
typedef __sigset_t sigset_t;
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
typedef __suseconds_t suseconds_t;
typedef long int __fd_mask;
typedef struct
  {
    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];
  } fd_set;
typedef __fd_mask fd_mask;

extern int select (int __nfds, fd_set *__restrict __readfds,
     fd_set *__restrict __writefds,
     fd_set *__restrict __exceptfds,
     struct timeval *__restrict __timeout);
extern int pselect (int __nfds, fd_set *__restrict __readfds,
      fd_set *__restrict __writefds,
      fd_set *__restrict __exceptfds,
      const struct timespec *__restrict __timeout,
      const __sigset_t *__restrict __sigmask);

__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
            unsigned int __minor)
     __attribute__ ((__nothrow__));
typedef __blksize_t blksize_t;
typedef __blkcnt_t blkcnt_t;
typedef __fsblkcnt_t fsblkcnt_t;
typedef __fsfilcnt_t fsfilcnt_t;
typedef unsigned long int pthread_t;
typedef union
{
  char __size[36];
  long int __align;
} pthread_attr_t;
typedef struct __pthread_internal_slist
{
  struct __pthread_internal_slist *__next;
} __pthread_slist_t;
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;
    int __kind;
    unsigned int __nusers;
    __extension__ union
    {
      int __spins;
      __pthread_slist_t __list;
    } __spins_union;
  } __data;
  char __size[24];
  long int __align;
} pthread_mutex_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;
typedef unsigned int pthread_key_t;
typedef int pthread_once_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    unsigned char __flags;
    unsigned char __shared;
    unsigned char __pad1;
    unsigned char __pad2;
    int __writer;
  } __data;
  char __size[32];
  long int __align;
} pthread_rwlock_t;
typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;
typedef volatile int pthread_spinlock_t;
typedef union
{
  char __size[20];
  long int __align;
} pthread_barrier_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;

extern long int random (void) __attribute__ ((__nothrow__));
extern void srandom (unsigned int __seed) __attribute__ ((__nothrow__));
extern char *initstate (unsigned int __seed, char *__statebuf,
   size_t __statelen) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern char *setstate (char *__statebuf) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
struct random_data
  {
    int32_t *fptr;
    int32_t *rptr;
    int32_t *state;
    int rand_type;
    int rand_deg;
    int rand_sep;
    int32_t *end_ptr;
  };
extern int random_r (struct random_data *__restrict __buf,
       int32_t *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int srandom_r (unsigned int __seed, struct random_data *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
   size_t __statelen,
   struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 4)));
extern int setstate_r (char *__restrict __statebuf,
         struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern int rand (void) __attribute__ ((__nothrow__));
extern void srand (unsigned int __seed) __attribute__ ((__nothrow__));

extern int rand_r (unsigned int *__seed) __attribute__ ((__nothrow__));
extern double drand48 (void) __attribute__ ((__nothrow__));
extern double erand48 (unsigned short int __xsubi[3]) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern long int lrand48 (void) __attribute__ ((__nothrow__));
extern long int nrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern long int mrand48 (void) __attribute__ ((__nothrow__));
extern long int jrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void srand48 (long int __seedval) __attribute__ ((__nothrow__));
extern unsigned short int *seed48 (unsigned short int __seed16v[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void lcong48 (unsigned short int __param[7]) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
struct drand48_data
  {
    unsigned short int __x[3];
    unsigned short int __old_x[3];
    unsigned short int __c;
    unsigned short int __init;
    unsigned long long int __a;
  };
extern int drand48_r (struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int erand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int lrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int nrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int mrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int jrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int seed48_r (unsigned short int __seed16v[3],
       struct drand48_data *__buffer) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int lcong48_r (unsigned short int __param[7],
        struct drand48_data *__buffer)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *malloc (size_t __size) __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;
extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;


extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__warn_unused_result__));
extern void free (void *__ptr) __attribute__ ((__nothrow__));

extern void cfree (void *__ptr) __attribute__ ((__nothrow__));

extern void *alloca (size_t __size) __attribute__ ((__nothrow__));

extern void *valloc (size_t __size) __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;
extern int posix_memalign (void **__memptr, size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern void abort (void) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));
extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));

extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));

extern void exit (int __status) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));


extern void _Exit (int __status) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));


extern char *getenv (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern char *__secure_getenv (__const char *__name)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int putenv (char *__string) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int setenv (__const char *__name, __const char *__value, int __replace)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int unsetenv (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int clearenv (void) __attribute__ ((__nothrow__));
extern char *mktemp (char *__template) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int mkstemp (char *__template) __attribute__ ((__nonnull__ (1))) ;
extern int mkstemps (char *__template, int __suffixlen) __attribute__ ((__nonnull__ (1))) ;
extern char *mkdtemp (char *__template) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern int system (__const char *__command) ;

extern char *realpath (__const char *__restrict __name,
         char *__restrict __resolved) __attribute__ ((__nothrow__)) ;
typedef int (*__compar_fn_t) (__const void *, __const void *);

extern void *bsearch (__const void *__key, __const void *__base,
        size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;
extern void qsort (void *__base, size_t __nmemb, size_t __size,
     __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));
extern int abs (int __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

__extension__ extern long long int llabs (long long int __x)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

extern div_t div (int __numer, int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;


__extension__ extern lldiv_t lldiv (long long int __numer,
        long long int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *gcvt (double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3))) ;
extern char *qecvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qfcvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3))) ;
extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qecvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qfcvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));

extern int mblen (__const char *__s, size_t __n) __attribute__ ((__nothrow__)) ;
extern int mbtowc (wchar_t *__restrict __pwc,
     __const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__)) ;
extern int wctomb (char *__s, wchar_t __wchar) __attribute__ ((__nothrow__)) ;
extern size_t mbstowcs (wchar_t *__restrict __pwcs,
   __const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__));
extern size_t wcstombs (char *__restrict __s,
   __const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__ ((__nothrow__));

extern int rpmatch (__const char *__response) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int getsubopt (char **__restrict __optionp,
        char *__const *__restrict __tokens,
        char **__restrict __valuep)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2, 3))) ;
extern int getloadavg (double __loadavg[], int __nelem)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));



extern void *memcpy (void *__restrict __dest,
       __const void *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memmove (void *__dest, __const void *__src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
        int __c, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memchr (__const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncpy (char *__restrict __dest,
        __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcoll (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strxfrm (char *__restrict __dest,
         __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern int strcoll_l (__const char *__s1, __const char *__s2, __locale_t __l)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 3)));
extern size_t strxfrm_l (char *__dest, __const char *__src, size_t __n,
    __locale_t __l) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 4)));
extern char *strdup (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));
extern char *strndup (__const char *__string, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));

extern char *strchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strrchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern size_t strcspn (__const char *__s, __const char *__reject)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strspn (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strpbrk (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strstr (__const char *__haystack, __const char *__needle)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern char *__strtok_r (char *__restrict __s,
    __const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));
extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
         char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));

extern size_t strlen (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));

extern size_t strnlen (__const char *__string, size_t __maxlen)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));

extern char *strerror (int __errnum) __attribute__ ((__nothrow__));

extern int strerror_r (int __errnum, char *__buf, size_t __buflen) __asm__ ("" "__xpg_strerror_r") __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern char *strerror_l (int __errnum, __locale_t __l) __attribute__ ((__nothrow__));
extern void __bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void bcopy (__const void *__src, void *__dest, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *index (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *rindex (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern int ffs (int __i) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int strcasecmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strsep (char **__restrict __stringp,
       __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strsignal (int __sig) __attribute__ ((__nothrow__));
extern char *__stpcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *__stpncpy (char *__restrict __dest,
   __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpncpy (char *__restrict __dest,
        __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

STATUS EpicConf(void);
extern SHORT DAB_length[2];
extern SHORT DAB_bits[2][16];
extern LONG DAB_start;
extern SHORT PROPDAB_length[2];
extern SHORT PROPDAB_bits[2][23];
extern LONG PROPDAB_start;
extern SHORT XTR_length[2];
extern SHORT XTR_bits[2][18];
extern LONG XTR_start;
extern SHORT RBA_length[2];
extern SHORT RBA_bits[2][12];
extern LONG RBA_start;
extern SHORT FAST_RBA_length;
extern SHORT FAST_RBA_bits[];
extern LONG FAST_RBA_start;
extern SHORT FAST_PROG_length;
extern SHORT FAST_PROG_bits[];
extern LONG FAST_PROG_start;
extern SHORT FAST_DIAG_length;
extern SHORT FAST_DIAG_bits[];
extern LONG FAST_DIAG_start;
extern SHORT SUF_length;
extern SHORT SUF_bits[];
extern LONG SUF_start;
extern SHORT HSDAB_length;
extern SHORT HSDAB_bits[];
extern SHORT HSDAB_start;
extern SHORT DIFFDAB_length;
extern SHORT DIFFDAB_bits[];
extern SHORT DIFFDAB_start;
extern SHORT COPY_DAB_length;
extern SHORT COPY_DAB_bits[];
extern SHORT COPY_DAB_start;
extern SHORT txatten_bits[17];
extern SHORT DIM_length;
extern SHORT DIM_bits[];
extern LONG DIM_start;
extern SHORT DIM2_length;
extern SHORT DIM2_bits[];
extern LONG DIM2_start;
extern SHORT sq_sync_length[2];
extern SHORT sq_sync_bits[2][13];
extern SHORT sq_lockout_length;
extern SHORT sq_lockout_bits[];
extern SHORT pass_length;
extern SHORT pass_bits[];
extern LONG pass_start;
extern SHORT ATTEN_unlock_length[2];
extern SHORT ATTEN_unlock_bits[2][6];
extern LONG ATTEN_start;
extern INT psd_gxwcnt;
extern INT psd_pulsepos;
extern INT psd_eparity;
extern FLOAT psd_etbetax, psd_etbetay;
extern CHAR psd_epstring[];
extern LONG rfupa;
extern LONG rfupd;
extern LONG rfublwait;
extern INT EDC;
extern INT RDC;
extern INT ECF;
extern INT EMISC;
extern INT ESSL;
extern INT ESYNC;
extern INT ETHETA;
extern INT EUBL;
extern INT EXTATTEN;
extern INT ERFREQ;
extern INT ERPHASE;
extern INT RFLTRS;
extern INT RFLTRC;
extern INT RFUBL;
extern INT RSYNC;
extern INT RATTEN;
extern INT RRFSEL;
extern INT ESEL0;
extern INT ESEL1;
extern INT ESEL_ALL;
extern INT RSEL0;
extern INT RSEL1;
extern INT RSEL_ALL;
extern INT RATTEN_ALL;
extern INT RATTEN_1;
extern INT RATTEN_2;
extern INT RATTEN_3;
extern INT RATTEN_4;
extern INT RLOOP;
extern INT RHEADI;
extern INT RFAUX;
extern INT RFBODYI;
extern INT ECCF;
extern INT EDSYNC;
extern INT EMRST;
extern INT EMSSS1;
extern INT EMSSS2;
extern INT EMSSS3;
extern INT ESSP;
extern INT EXUBL;
extern INT EDDSP;
extern INT EATTEN_TEST;
extern INT ETHETA_L;
extern INT EOMEGA_L;
extern INT RBA;
extern INT RBL;
extern INT RFF;
extern INT RDSYNC;
extern INT RSAD;
extern INT RSUF;
extern INT RUBL;
extern INT RUBL_1;
extern INT RUBL_2;
extern INT RUBL_3;
extern INT RUBL_4;
extern INT RATTEN_FSEL;
extern INT RATTEN_3DB;
extern INT RATTEN_6DB;
extern INT RATTEN_12DB;
extern INT RATTEN_23DB;
extern INT FAST_EDC;
extern INT FAST_RDC;
extern INT FAST_RFLTRS;
extern INT RFHUBSEL;
extern INT HUBIND;
extern INT R1IND;
extern INT EXTATTEN_Q;
extern INT DB_I;
extern INT DB_Q;
extern INT PHASELAG_Q;
extern INT SRI_C;
extern INT EDC;
extern INT RDC;
extern INT ECF;
extern INT EMISC;
extern INT ESSL;
extern INT ESYNC;
extern INT ETHETA;
extern INT EUBL;
extern INT EXTATTEN;
extern INT EXTATTEN_Q;
extern INT PHASELAG_Q;
extern INT DDIQSWOC;
extern INT DB_I;
extern INT DB_Q;
extern INT SRI_C;
extern INT RFHUBSEL;
extern INT HUBIND;
extern INT R1IND;
extern INT ERFREQ;
extern INT ERPHASE;
extern INT RFLTRS;
extern INT RFLTRC;
extern INT RFUBL;
extern INT RSYNC;
extern INT RATTEN;
extern INT RRFSEL;
extern INT ESEL0;
extern INT ESEL1;
extern INT ESEL_ALL;
extern INT RSEL0;
extern INT RSEL1;
extern INT RSEL_ALL;
extern INT RATTEN_ALL;
extern INT RATTEN_1;
extern INT RATTEN_2;
extern INT RATTEN_3;
extern INT RATTEN_4;
extern INT RLOOP;
extern INT RHEADI;
extern INT RFAUX;
extern INT RFBODYI;
extern INT ECCF;
extern INT EDSYNC;
extern INT EMRST;
extern INT EMSSS1;
extern INT EMSSS2;
extern INT EMSSS3;
extern INT ESSP;
extern INT EXUBL;
extern INT EDDSP;
extern INT EATTEN_TEST;
extern INT ETHETA_L;
extern INT EOMEGA_L;
extern INT RBA;
extern INT RBL;
extern INT RFF;
extern INT RDSYNC;
extern INT RSAD;
extern INT RSUF;
extern INT RUBL;
extern INT RUBL_1;
extern INT RUBL_2;
extern INT RUBL_3;
extern INT RUBL_4;
extern INT RATTEN_FSEL;
extern INT RATTEN_3DB;
extern INT RATTEN_6DB;
extern INT RATTEN_12DB;
extern INT RATTEN_23DB;
extern INT FAST_EDC;
extern INT FAST_RDC;
extern INT FAST_RFLTRS;
extern INT RRFMISC;
extern INT LOSOURCE;
extern INT cfrfupa;
extern INT cfrfupd;
extern INT cfrfminunblk;
extern INT cfrfminblank;
extern INT cfrfminblanktorcv;
extern float cfrfampftconst;
extern float cfrfampftlinear;
extern float cfrfampftquadratic;
extern INT SEDC;
extern const INT opcode_xcvr[NUM_PSD_BOARD_TYPES][66];
extern int psd_board_type;
extern int psd_id_count;
extern int bd_index;
typedef enum aptype_e
{
    UNKNOWN = 0,
    REFLEX100,
    REFLEX200,
    REFLEX400,
    REFLEX800
} aptype_t;
aptype_t check_apconfig( const int e_flag );
STATUS init_apconfig( const int n_proc,
                      const float memsize,
                      const int proc_type,
                      const int e_flag );
typedef enum dbLevel_e
{
    NODEBUG = 0,
    DBLEVEL1,
    DBLEVEL2,
    DBLEVEL3,
    DBLEVEL4,
    DBLEVEL5,
    DBLEVEL6,
    DBLEVEL7,
    DBLEVEL8,
    DBLEVEL9,
    DBLEVEL10
} dbLevel_t;
    int appendGradientModelOrganizationDirectory( char* directory,
                                                  const size_t dirLenMax );
    void
    appendUniquePsdIdSeconds( char* fileName,
                              const size_t fileNameSize );
    void printDebug( const dbLevel_t level,
                     const dbLevel_t dbLevel,
                     const char *functionName,
                     const char *format,
                     ... );
    void setDebugFileExt( char * fileName,
                          const size_t fileNameSize,
                          const int fileFlag );
    void getDebugFile( char * debugFileName,
                       const size_t debugFileNameSize,
                       const char * baseFileName,
                       const int fileFlag,
                       const int checkMxPath );
    FILE * openGradientModelDebugFile( const int fileFlag,
                                       const int checkMxPath,
                                       const int appendFlag );
typedef struct {
   float real;
   float imag;
} COMPLEX;
typedef struct
{
    void* fftwPlan;
    int N;
    int dir;
} PLAN_info;
typedef struct
{
    int nelems;
    int logb2_nelems;
    int numPowOf2Plans;
    COMPLEX* setupTmpv;
    void** FFTW_fplansBA;
    void** FFTW_fplansBU;
    void** FFTW_fplansFA;
    void** FFTW_fplansFU;
    PLAN_info FFTW_fplanBA_fft1_cin;
    PLAN_info FFTW_fplanBU_fft1_cin;
    PLAN_info FFTW_fplanFA_fft1_cin;
    PLAN_info FFTW_fplanFU_fft1_cin;
} FFT_setup;
int CFFT( COMPLEX*,
           const int,
           const int );
void CFFT_version();
typedef struct
{
        long I;
        long Q;
} lcomplex;
typedef struct
{
        double I;
        double Q;
} dcomplex;
extern COMPLEX FCadd( const COMPLEX a,
                       const COMPLEX b );
extern COMPLEX FCsub( const COMPLEX a,
                       const COMPLEX b );
extern COMPLEX FCneg( const COMPLEX a );
extern COMPLEX FCmul( const COMPLEX a,
                       const COMPLEX b );
extern COMPLEX FCipow( const COMPLEX a,
                        const int z );
extern COMPLEX FCdiv( const COMPLEX a,
                       const COMPLEX b );
extern COMPLEX FComplex( const float real,
                          const float imaginary );
extern float FCabs( const COMPLEX z );
extern float FCang( const COMPLEX z );
extern COMPLEX FConjg( const COMPLEX z );
extern COMPLEX FCsqrt( const COMPLEX z );
extern COMPLEX FRCmul( const COMPLEX a,
                        const float x );
extern COMPLEX FRCdiv( const COMPLEX a,
                        const float x );
extern COMPLEX FCexp( const COMPLEX a );
extern void hprintComplex( const COMPLEX a,
                           const char n );
extern float FCdot( const COMPLEX a,
                    const COMPLEX b );
extern float FCang1( const COMPLEX a,
                     const COMPLEX b );
extern float FCang2( const COMPLEX a,
                     const COMPLEX b );
extern void FCswap2( COMPLEX * const a,
                     COMPLEX * const b );
extern void FCfft_shift( COMPLEX * a,
                         int const length );
extern void FCfft_1d( COMPLEX * const a,
                      const int complex_element_cnt,
                      const int iopt );
typedef struct mss_result_s
{
    INT minseqgrad;
    INT minseqcoil;
    INT minseqcoilx;
    INT minseqcoily;
    INT minseqcoilz;
    INT minseqcoilburst;
    INT minseqcoilvrms;
    INT minseqgrddrv;
    INT minseqgrddrv_case;
    INT minseqgpm;
    INT minseqgpm_maxpow;
    INT minseqpdu;
    INT minseqps;
    INT minseqpdubreaker;
    INT minseqxfmr;
    INT minseqcoilcool;
    INT minseqsyscool;
    INT minseqccucool;
    INT minseqcable;
    INT minseqcable_maxpow;
    INT minseqcableburst;
    INT minseqchoke;
    INT minseqbusbar;
    FLOAT vol_ratio_est_req;
    FLOAT burstcooltime;
    FLOAT xa2s;
    FLOAT ya2s;
    FLOAT za2s;
    FLOAT ACxpower;
    FLOAT ACypower;
    FLOAT ACzpower;
    FLOAT ACpowerSum_Watts;
    FLOAT cableCurrentRMSmax_Amps;
    FLOAT peakSPL;
    FLOAT avgSPL;
    FLOAT avgSPL_non_wt;
    FLOAT SGAlosslow[3];
    FLOAT SGAlosshigh[3];
    FLOAT XPSpowerhigh[3];
    FLOAT XPSpowerlow[3];
    INT minseqcoil_3axis;
    INT minseqcoil_each[3];
    INT minseqcable_each[3];
    INT minseqcable_maxpow_each[3];
    INT minseqgrddrv_case_each[3];
    INT minseqgrddrv_each[3];
    INT minseqgpm_PDU;
    INT minseqgpm_each[3];
    INT minseqgpm_LV_each[3];
    INT minseqgpm_HV_each[3];
    INT minseqgpm_Itank;
    INT minseqgpm_maxpow_3axis;
    INT minseqgpm_maxpow_each[3];
    INT minseqps_each[3];
    INT minseqchoke_each[3];
    INT minseqbusbar_each[3];
} mss_result_t;
typedef struct mss_hw_s
{
    double amp2Gauss[3];
    double maxCurrent[3];
    double gcontirms;
    double irmsPerAxis[3][3];
    int gradamp;
    int gcoiltype;
    int gradmode;
    int srmode;
    int updateTime;
    float coilDC_gain;
    float coilDC_Rx;
    float coilDC_Ry;
    float coilDC_Rz;
    float coilDC_Lx;
    float coilDC_Ly;
    float coilDC_Lz;
    float coilAC_gain;
    float coilAC_xgain;
    float coilAC_ygain;
    float coilAC_zgain;
    float coilAC_power;
    float coilAC_power_1axis;
    float coilAC_powerburst;
    float coilAC_temp_base_burst;
    float coilAC_temp_limit_burst;
    float coilAC_timeconstant_burst;
    float coilAC_RxA;
    float coilAC_RyA;
    float coilAC_RzA;
    float coilAC_RxB;
    float coilAC_RyB;
    float coilAC_RzB;
    float coilAC_RxC;
    float coilAC_RyC;
    float coilAC_RzC;
    float coilAC_lumpR1x;
    float coilAC_lumpR1y;
    float coilAC_lumpR1z;
    float coilAC_lumpR2x;
    float coilAC_lumpR2y;
    float coilAC_lumpR2z;
    float coilAC_lumpL1x;
    float coilAC_lumpL1y;
    float coilAC_lumpL1z;
    float coilAC_lumpL2x;
    float coilAC_lumpL2y;
    float coilAC_lumpL2z;
    float coilAC_lumpL3x;
    float coilAC_lumpL3y;
    float coilAC_lumpL3z;
    float coilAC_lumpR3x;
    float coilAC_lumpR3y;
    float coilAC_lumpR3z;
    float coilAC_lumpL4x;
    float coilAC_lumpL4y;
    float coilAC_lumpL4z;
    float coilAC_lumpR4x;
    float coilAC_lumpR4y;
    float coilAC_lumpR4z;
    float coilAC_lumpR5x;
    float coilAC_lumpR5y;
    float coilAC_lumpR5z;
    float coilAC_lumpCx;
    float coilAC_lumpCy;
    float coilAC_lumpCz;
    float coilAC_lumpRcable;
    float coilAC_lumpRoutputFilter;
    float coilAC_lumpLoutputFilter;
    float coilAC_timeres;
    int coilAC_fftpoints;
    float coilQAC_A[7];
    float coilQAC_B[3];
    float coilQAC_maxtime;
    float coilQAC_const;
    float coilQAC_heat_maxtime;
    float coilQAC_heat_slope;
    float coilQAC_heat_const;
    float coil_irmslimit_total;
    float xgd_timeres;
    float xgd_cableirmslimit;
    float xgd_cableirmslimit_burst;
    float xgd_cabletimeconstant_burst;
    float xgd_chokepowerlimit;
    float xgd_busbartemplimit;
    float xps_avglvpwrlimit;
    float xps_avghvpwrlimit;
    float xps_avgpdulimit;
    float xgd_IGBTtemplimit;
    float xfd_power_limit;
    float xfd_temp_limit;
    int ecc_modeling;
    float ecc_xtau1;
    float ecc_xtau2;
    float ecc_xtau3;
    float ecc_ytau1;
    float ecc_ytau2;
    float ecc_ytau3;
    float ecc_ztau1;
    float ecc_ztau2;
    float ecc_ztau3;
    float ecc_xalpha1;
    float ecc_xalpha2;
    float ecc_xalpha3;
    float ecc_yalpha1;
    float ecc_yalpha2;
    float ecc_yalpha3;
    float ecc_zalpha1;
    float ecc_zalpha2;
    float ecc_zalpha3;
    float ps_avgpwrLimit;
    float ps_avgpwrLimit_total;
    float ps_pkpwrLimit;
    float ps_pkpwrLimit_total;
    float pdu_avgpwrLimit;
    float pdu_pkpwrLimit;
    float pdu_breakercurrentLimit;
    float cooling_coilLimit;
    float cooling_ccuLimit;
    float cooling_sysLimit;
    float coilACpower_axisPer;
    int cooling_model;
    float xfmr_rmsLimit;
    float coil_vrmsLimit;
    float resist_wattLimit;
    int seq_repeat_rate;
} mss_hw_t;
typedef struct mss_wave_s
{
    FLOAT *time;
    FLOAT *ampl[3];
    FLOAT *pul_type[3];
    INT num_points;
    INT num_iters;
    INT encode_mode;
    INT burstreps;
    FLOAT *resampledTime;
    FLOAT *resampledCurrent[3];
    COMPLEX *resampledCurrentFFT[3];
    FLOAT *resampledVoltage[3];
    FLOAT *resampledPower[3];
    INT resampledTotalPoints;
    FLOAT *amplifierLoss[3];
    FLOAT resampledTimeStep;
    COMPLEX *netLoad[3];
    float *Pcoil_ladder[3];
    float *Pcoil_ladderWorst[3];
} mss_wave_t;
typedef struct mss_waveforms_s
{
    mss_wave_t *average;
    mss_wave_t *maximum;
} mss_waveforms_t;
typedef struct mss_geo_s
{
    SCAN_INFO *lscninfo;
    INT n_slices;
} mss_geo_t;
typedef struct mss_flags_s
{
    int hiFreqMode;
    int coilCompositeRMSMethod;
    int psCompositeIntegralMethod;
    int sgaGradDriverMethod;
    int gradHeatFile;
    int gradCoilMethod;
    int burstMode;
    int stopwatchFlag;
    int cveval_counter;
    int value_system_flag;
    int e_flag;
    dbLevel_t debug;
    int xgd_optimization;
    int eccupdatetime;
    int checkMxPath;
    int runCapBankModel;
    int acoustic_flag;
    int enable_grad_model_logging;
} mss_flags_t;
INT isCoilDBEnabled( void );
void getTxAndExciter( INT *txIndex,
                      INT *exciterIndex,
                      INT *exciterUsed,
                      INT *numTxIndexUsed,
                      const COIL_INFO coilinfo[],
                      const INT ncoils );
INT getTxIndex( const COIL_INFO coilinfo );
void getCoilIndex( INT *coilIndex,
                   INT *indexFilled,
                   const COIL_INFO coilinfo[],
                   const INT ncoils,
                   const INT txIndex );
s32 getCoilAtten( void );
INT getNumTxCoils( const COIL_INFO coilinfo[],
                   const INT ncoils );
f32 getTxCoilMaxB1Peak( void );
n32 getTxCoilType( void );
n32 getTxAmp( void );
n32 getTxNucleus( void );
n32 getTxChannels( void );
n32 getRxCoilType( void );
n32 getRxNumChannels( void );
n32 getVolRxNumChannels( void );
n32 getTxPosition( void );
n32 getAps1Mod( void );
n32 getAps1ModPlane( void );
f32 getAps1ModFov( void );
f32 getAps1ModSlThick( void );
f32 getAps1ModPsRloc( void );
f32 getAps1ModPsTloc( void );
void getSilentSpec( const INT silent,
                    INT * const Gctrl,
                    FLOAT * const Glimit,
                    FLOAT * const Srate );
void getRioGradSpec( const INT rio_gradspec_flag,
                    INT * const Gctrl,
                    FLOAT * const Glimit,
                    FLOAT * const Srate );
void getRioExtremeGradSpec(const INT rio_40170_gradspec_flag,
                          INT * const Gctrl,
                          FLOAT * const Glimit,
                          FLOAT * const Srate);
PHYS_GRAD getOrigphygrd( void );
int is3TeslaWideSystem( void );
int isDVWideSystem( void );
int isIceHardware( void );
int isHeadNeckTxPosition( void );
int isDVSystem( void );
int isSVSystem( void );
int isKizunaSystem( void );
int isRioSystem( void);
int isK15TSystem( void );
int isValueSystem( void);
int isStarterSystem( void);
STATUS configSystem( void );
STATUS entrytabinit( ENTRY_POINT_TABLE *entryPoint,
                     const INT numEntries );
STATUS setsysparms( void );
STATUS setupConfig( void );
STATUS set_grad_spec( const INT spec_ctrl,
                      FLOAT g_max,
                      FLOAT s_rate,
                      const INT duty_limit,
                      const INT debug );
STATUS UpdateEntryTabRecCoil( ENTRY_POINT_TABLE * const entryTab,
                              const INT index );
void copyCoilInfo(void);
typedef struct s_list {
    INT time;
    FLOAT ampl;
    INT ptype;
} t_list;
    STATUS calcChecksumScanInfo(
        n32 *chksum_val, const SCAN_INFO *si, const int numslices, int psdcrucial_debug
    );
    void dump_vol_shift_scale(
        const int num_slice
    );
    STATUS endview(
        INT resolution,
        INT *last_phase_iamp
    );
    long hostToRspRotMat(
        const float fval
    );
    STATUS orderslice(
        const INT acqType, const INT numLocs, const INT locsPerPass,
        const INT gating
    );
    STATUS orderslice2(
        const INT acqType, const INT numLocs, const INT numAcqs, INT *sl_pass,
        INT *prescan_pass, const INT gating
    );
    STATUS scalerotmatscrc(
        long (*rsprot)[9], const LOG_GRAD *lgrad, const PHYS_GRAD *pgrad,
        const INT slquant, const INT debug, const INT rampdir, const n32 chksum_rampdir
    );
    STATUS setupphasetable(
        SHORT *phaseTab, INT respCompType, INT phaseRes
    );
    STATUS set_echo_flip(
        int *rhdacqctrl, n32 * chksum_rhdacqctrl, const int eepf, const int oepf,
        const int eeff, const int oeff
    );
    extern STATUS (*typ3dmscat)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislab, INT numLocs, INT numSlabs, INT numAcqs
    );
    extern STATUS (*typ3dmsncat)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislab, INT numLocs, INT numSlabs, INT numAcqs
    );
    extern STATUS (*typcard)(
        DATA_ACQ_ORDER data_acq_order[], INT *indexrot, INT numLocs, INT maxphase
    );
    extern STATUS (*typcat)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs,
        INT numAcqs, INT opimode, INT oppseq, INT opflaxall,
        INT oppomp, INT rhnpomp
    );
    extern STATUS (*typcatxrr)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs,
        INT numReps
    );
    extern STATUS (*typfsa)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT *locsPass, INT numAcqs
    );
    extern STATUS (*typncat)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs,
        INT opimode, INT oppseq, INT opflaxall
    );
    extern STATUS (*typncatxrr)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs,
        INT numReps
    );
    extern STATUS (*typncatPomp)(
        DATA_ACQ_ORDER *tempAcqTab, INT *pislice, INT numLocs, INT numAcqs
    );
    extern STATUS (*typssfse)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT *locsPerPass, INT numAcqs, INT orderType
    );
    extern STATUS (*typssfseint)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs
    );
    extern STATUS (*typssfseseq)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs
    );
    extern STATUS (*typxrr)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs
    );
    extern STATUS (*typxrrPomp)(
        DATA_ACQ_ORDER *tempAcqTab, INT *pislice, INT numLocs, INT numAcqs
    );
    extern STATUS (*typncatoptflair)(
        DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs
    );
typedef enum logging_apptype
{
    L_PSD_APPS = 0,
    L_OTHER_APPS
} logging_apptype_e;
typedef enum log_level
{
    LOG_LEVEL_ERROR,
    LOG_LEVEL_INFO
} log_level_e;
typedef enum trace_level
{
    TRACE_LEVEL_DEBUG,
    TRACE_LEVEL_INFO,
    TRACE_LEVEL_WARNING,
    TRACE_LEVEL_ERROR,
    TRACE_LEVEL_FATAL,
    TRACE_LEVEL_NONE
} trace_level_e;
typedef enum trace_file_name_style
{
    TRACE_FULL_FILE_PATH,
    TRACE_BASE_FILE_NAME
} trace_file_name_style_e;
typedef enum
{
    LOG_TRACE_FAILED = -1,
    LOG_TRACE_OK
} log_trace_return_e;
typedef const void* trace_module;
log_trace_return_e log_trace_service_register( const char *app_name,
                                               const trace_level_e app_trace_level,
                                               const logging_apptype_e app_type,
                                               const char *output_dir );
log_trace_return_e log_trace_service_log_message( const log_level_e msg_log_level,
                                                  const char *calling_file_name,
                                                  const int calling_line_no,
                                                  const char *module,
                                                  const char *format,
                                                  ... );
trace_module log_trace_service_get_trace_module( const char *module_name );
log_trace_return_e log_trace_service_set_module_buffer_size( trace_module t_module,
                                                             const size_t size );
log_trace_return_e log_trace_service_trace_message( const trace_level_e msg_trace_level,
                                                    const char *calling_file_name,
                                                    const int calling_line_no,
                                                    trace_module t_module,
                                                    const char *format,
                                                    ... );
log_trace_return_e log_trace_service_flush_trace_module_buffer( trace_module t_module );
log_trace_return_e log_trace_service_remove_trace_module( trace_module t_module );
log_trace_return_e log_trace_service_update_trace_level( void );
log_trace_return_e log_trace_service_is_trace_active( const trace_level_e msg_trace_level,
                                                      trace_module t_module );
log_trace_return_e log_trace_service_deregister( void );
log_trace_return_e log_trace_service_close_connection( void );
typedef struct maxslquanttps_option
{
        FLOAT arcRxToAcqSlicesSlope;
        FLOAT arcRxToAcqSlicesIntercept;
        INT discoTotalAcqPoints;
} MAXSLQUANTTPS_OPTION;
STATUS b0Dither_ifile( FLOAT * const dither_val,
                       const INT control,
                       const DOUBLE dx,
                       const DOUBLE dy,
                       const DOUBLE dz,
                       const DOUBLE agxw,
                       const INT esp,
                       const INT nslices,
                       const INT debug,
                       long (*const rsprot)[9],
                       const FLOAT * const ccinx,
                       const FLOAT * const cciny,
                       const FLOAT * const ccinz,
                       const INT * const esp_in,
                       const FLOAT * const fesp_in,
                       const FLOAT * const g0,
                       const INT * const num_elements,
                       const INT * const exist );
STATUS b0DitherFile( FLOAT *dither_val,
                     INT control,
                     DOUBLE dx,
                     DOUBLE dy,
                     DOUBLE dz,
                     DOUBLE agxw,
                     INT esp,
                     INT nslices,
                     INT debug,
                     long (*rsprot)[9],
                     FLOAT *buffer );
STATUS epiRecvFrqPhs( const INT nslices,
                      const INT nileaves,
                      const INT etl,
                      const DOUBLE xtr_rba_time,
                      FLOAT *const reftime,
                      const DOUBLE frtime,
                      const DOUBLE opfov,
                      const INT opyres,
                      const DOUBLE fovar,
                      FLOAT *const b0_dither_val,
                      INT **const rf_phase_spgr,
                      const INT dro,
                      const INT dpo,
                      RSP_INFO *const rspinfo,
                      INT *const view1st,
                      INT *const viewskip,
                      INT *const gradpol,
                      const INT ref_mode,
                      const INT kydir,
                      const INT dc_chop_flag,
                      const INT pepolar_flag,
                      INT ***const recv_freq,
                      DOUBLE ***const recv_phase_angle,
                      INT ***const recv_phase_ctrl,
                      FLOAT *const gldelayfval,
                      const DOUBLE ampgxw,
                      const INT debug,
                      const INT refxoff,
                      const FLOAT asset_factor,
                      const INT iref_etl,
                      FLOAT *const sl_cfoffset,
                      INT esp );
STATUS OpenDelayFile( FLOAT *buffer );
STATUS OpenDitherFile( const INT coiltype,
                       FLOAT * const buffer );
STATUS OpenDitherInterpoFile( INT coiltype,
                              FLOAT * const ccinx,
                              FLOAT * const cciny,
                              FLOAT * const ccinz,
                              INT * const esp_in,
                              FLOAT * const fesp_in,
                              FLOAT * const g0,
                              INT * const num_elements,
                              INT * const exist );
STATUS optdda( INT *dda,
               const INT T1_dda );
INT phase_order_fgre3d( SHORT * const view_tab,
                        const INT phase_order,
                        const INT rspviews,
                        const INT viewoffset,
                        const INT nframes,
                        const INT noverscans,
                        const FLOAT fractnex );
STATUS prescanslice( INT * const slpass,
                     INT * const sltime,
                     const LONG numLocs );
STATUS prescanslice1( INT * const preslorder,
                      const INT pre_slquant,
                      const LONG numLocs );
STATUS pcflowtarget( const INT flaxx,
                     const INT flaxy,
                     const INT flaxz,
                     const DOUBLE derate_factor,
                     FLOAT * const xtarget,
                     FLOAT * const ytarget,
                     FLOAT * const ztarget,
                     const LOG_GRAD * const Loggrdp,
                     const INT derate_flag );
STATUS genVRGF( const OPT_GRAD_PARAMS * const gradout,
                const INT xres,
                const DOUBLE period,
                const DOUBLE tamp,
                const DOUBLE tfthw,
                const DOUBLE tadw,
                const DOUBLE alpha,
                const DOUBLE beta );
void psd_init_iopts( void );
STATUS cvsetfeatures( void );
STATUS cvfeatureiopts( void );
STATUS cvevaliopts( void );
STATUS calcqmapshift( INT * const qmap_shift,
                      const INT slquant,
                      const INT nshifts,
                      const INT shift_ind );
STATUS info_fields_display( INT *pi_inplaneres,
                         INT *pi_rbwperpix,
                         INT *pi_esp,
                         FLOAT *inplanexres,
                         FLOAT *inplaneyres,
                         FLOAT *rbwperpix,
                         FLOAT *esp,
                         INT pibitmask,
                         INT act_esp,
                         INT method_for_ypixsize );
void copyCoilInfo(void);
void rfB1optplus( void );
void rfB1opt( void );
STATUS setScale( const INT entryPoint,
                 const INT numPulseEntries,
                 const RF_PULSE *rfpulse,
                 const FLOAT maxB1,
                 const FLOAT extraScale );
STATUS rfsafetyopt( FLOAT * const opt_deratingfactor,
                    const INT rfscale_flag,
                    FLOAT * const orig_rfscale,
                    FLOAT * const limit_scale_seed,
                    const INT rf1slot,
                    RF_PULSE * const rfpulse,
                    RF_PULSE_INFO * const rfpulseInfo );
typedef enum slicesort_acq_type
{
    PSD_FRONT_LOADED_SLICE_SORT = 0,
    PSD_DISTRIBUTED_SLICE_SORT = 1
} slicesort_acq_type_e;
STATUS setAccelPulldown( const float arc_ph_maxaccel,
                         const float arc_sl_maxaccel,
                         float* piaccel_phval2,
                         float* piaccel_phval3,
                         float* piaccel_phval4,
                         float* piaccel_phval5,
                         float* piaccel_phval6,
                         int* piaccel_phnub,
                         int* piaccel_phedit,
                         float* piaccel_slval2,
                         float* piaccel_slval3,
                         float* piaccel_slval4,
                         float* piaccel_slval5,
                         float* piaccel_slval6,
                         int* piaccel_slnub,
                         int* piaccel_sledit,
                         float *ph_stepsize,
                         float *sl_stepsize );
STATUS fseminti( INT * const mintitime,
                 const INT hrf0,
                 const INT pw_gzrf0d,
                 const INT cs_sattime,
                 const INT sp_sattime,
                 const INT satdelay,
                 const INT t_exa );
STATUS imgtimutil( LONG const premidRF1_time,
                   LONG const acqType,
                   LONG const gating,
                   LONG * const availimagetime );
STATUS optspecir( FLOAT *opttheta,
                  INT *maxti,
                  INT soltype );
STATUS seqtime( LONG * const Seqtime,
                const LONG availimagetime,
                const INT Slquant1,
                const INT acqType );
STATUS seqtype( LONG *Seqtype );
STATUS slicein1( INT * const Slquant1,
                 const INT numAcqs,
                 const INT acqType );
STATUS slicesort( INT * const Slquant1,
                  INT * const sl_pass,
                  INT * const sl_angle,
                  const INT maxlocsPerPass,
                  INT * const numAcqs,
                  INT * const numAngles,
                  const INT MaxAcq,
                  const INT acqType );
STATUS setnexctrl( INT * const Nex,
                   FLOAT * const Fn,
                   FLOAT * const Truenex,
                   INT * const Oddnex,
                   INT * const Halfnex);
STATUS amppwcrush( GRAD_PULSE * const rightgradcrush,
                   GRAD_PULSE * const leftgradcrush,
                   const INT echonum,
                   const DOUBLE crushscale,
                   const DOUBLE targetamp,
                   DOUBLE ampslicesel,
                   const DOUBLE stdarea,
                   const INT minconstpw,
                   const INT rmpfullscale );
STATUS amppwlcrsh( GRAD_PULSE * const gradleftcrush,
                   GRAD_PULSE * const gradrightcrush,
                   const DOUBLE area_rephase,
                   const DOUBLE amp_180slicesel,
                   const DOUBLE target_amp,
                   const INT minconstpw,
                   const INT rmpfullscale,
                   INT *attackpw_180slicesel );
STATUS crusherutil( FLOAT * const crusher_scale,
                    const INT psd_type );
STATUS dbdtderate( LOG_GRAD * const lgrad,
                   const INT debug );
short isdbdtper( void );
short isdbdtts( void );
STATUS amp_rt_dbdtopt( FLOAT * target_ampmax, INT * target_rtmin, INT slewrate, FLOAT ampscaling, FLOAT ampmaxlimit );
STATUS amppwfcse1( GRAD_PULSE * const gxf11,
                   GRAD_PULSE * const gxf21,
                   GRAD_PULSE * const gzf11,
                   GRAD_PULSE * const gzf21,
                   const GRAD_PULSE * const gxw,
                   const GRAD_PULSE * const gzrf1,
                   const GRAD_PULSE * const gzrf2,
                   const GRAD_PULSE * const gzrf2l1,
                   const GRAD_PULSE * const gzrf2r1,
                   const DOUBLE pw_read,
                   const DOUBLE fnecho,
                   const DOUBLE pcor90,
                   const DOUBLE pcor180,
                   const DOUBLE xtarget,
                   const INT pw_rampx,
                   const DOUBLE ztarget,
                   const INT pw_rampz,
                   const INT te,
                   const INT isodelay );
STATUS amppwfcse1opt( GRAD_PULSE * const gxf11,
                      GRAD_PULSE * const gxf21,
                      GRAD_PULSE * const gzf11,
                      GRAD_PULSE * const gzf21,
                      const GRAD_PULSE * const gxw,
                      const GRAD_PULSE * const gzrf1,
                      const GRAD_PULSE * const gzrf2,
                      const GRAD_PULSE * const gzrf2l1,
                      const GRAD_PULSE * const gzrf2r1,
                      const DOUBLE pw_read,
                      const DOUBLE fnecho,
                      const DOUBLE pcor90,
                      const DOUBLE pcor180,
                      const DOUBLE xtarget,
                      const INT pw_rampx,
                      const DOUBLE ztarget,
                      const INT pw_rampz,
                      const INT te,
                      const INT isodelay,
                      const INT xflow_gap,
                      INT *minte_temp );
STATUS amppwfcse2( GRAD_PULSE * const gxf12,
                   GRAD_PULSE * const gxf22,
                   GRAD_PULSE * const gzf12,
                   GRAD_PULSE * const gzf22,
                   const GRAD_PULSE * const gxw,
                   const GRAD_PULSE * const gxw2,
                   const GRAD_PULSE * const gzrf1,
                   const GRAD_PULSE * const gzrf2,
                   const GRAD_PULSE * const gzrf2l2,
                   const GRAD_PULSE * const gzrf2r2,
                   const DOUBLE pw_read,
                   const DOUBLE te2_te1,
                   const DOUBLE pcor180,
                   const DOUBLE xtarget,
                   const INT pw_rampx,
                   const DOUBLE ztarget,
                   const INT pw_rampz );
STATUS amppwfcse2opt( GRAD_PULSE * const gxf12,
                      GRAD_PULSE * const gxf22,
                      GRAD_PULSE * const gzf12,
                      GRAD_PULSE * const gzf22,
                      const GRAD_PULSE * const gxw,
                      const GRAD_PULSE * const gxw2,
                      const GRAD_PULSE * const gzrf1,
                      const GRAD_PULSE * const gzrf2,
                      const GRAD_PULSE * const gzrf2l2,
                      const GRAD_PULSE * const gzrf2r2,
                      const DOUBLE pw_read,
                      const INT te1,
                      const INT te2,
                      const DOUBLE pcor180,
                      const DOUBLE xtarget,
                      const INT pw_rampx,
                      const DOUBLE ztarget,
                      const INT pw_rampz,
                      const INT xflow_gap,
                      INT * const minte2_temp );
STATUS amppwgxfc2( const DOUBLE a_gxw,
                   const INT pw_gxw,
                   const INT pw_gxwd,
                   const INT pw_gxw2a,
                   const INT pw_gxw2,
                   const INT pw_ramp,
                   const INT avail_time,
                   const DOUBLE loggrd_target,
                   const INT te1_te2,
                   FLOAT * const a_gxfc2,
                   INT * const pw_gxfc2a,
                   INT * const pw_gxfc2,
                   INT * const pw_gxfc2d,
                   FLOAT * const a_gxfc3,
                   INT * const pw_gxfc3a,
                   INT * const pw_gxfc3,
                   INT * const pw_gxfc3d );
STATUS amppwgxfcmin( const DOUBLE a_gxw,
                     const INT pw_gxwa,
                     const INT pw_gxw,
                     const INT pw_gxwd,
                     const INT avail_time,
                     const DOUBLE frac_echo,
                     const DOUBLE amp_target,
                     const INT pw_rampx,
                     const DOUBLE xbeta,
                     FLOAT * const a_gx1,
                     INT * const pw_gx1a,
                     INT * const pw_gx1,
                     INT * const pw_gx1d,
                     FLOAT * const a_gxfc,
                     INT * const pw_gxfca,
                     INT * const pw_gxfc,
                     INT * const pw_gxfcd );
STATUS amppwgzfc( const DOUBLE a_gzrf1,
                  const INT pw_gzrf1a,
                  const INT pw_gzrf1,
                  const INT pw_gzrf1d,
                  const INT pw_ramp,
                  const INT avail_time,
                  FLOAT *a_gz1,
                  INT *pw_gz1a,
                  INT *pw_gz1,
                  INT *pw_gz1d,
                  FLOAT *a_gzfc,
                  INT *pw_gzfca,
                  INT *pw_gzfc,
                  INT *pw_gzfcd );
STATUS amppwgzfcmin( const DOUBLE a_gzrf1,
                     const INT pw_gzrf1a,
                     const INT fulltexb,
                     const INT pw_gzrf1d,
                     const INT avail_time,
                     const INT off_90,
                     const DOUBLE amp_target,
                     const INT pw_rampz,
                     const DOUBLE zbeta,
                     FLOAT * const a_gz1,
                     INT * const pw_gz1a,
                     INT * const pw_gz1,
                     INT * const pw_gz1d,
                     FLOAT * const a_gzfc,
                     INT * const pw_gzfca,
                     INT * const pw_gzfc,
                     INT * const pw_gzfcd );
STATUS amppwgx1( FLOAT *ampgx1,
                 INT *c_pwgx1,
                 INT *a_pwgx1,
                 INT *d_pwgx1,
                 INT seq_type,
                 DOUBLE area,
                 const DOUBLE area_ramp,
                 const INT avai_ptime,
                 const DOUBLE fract_echo,
                 const INT minconstpw,
                 const INT rmpfullscale,
                 const DOUBLE target );
STATUS calcfilter( FILTER_INFO * const echortf,
                   const DOUBLE des_bandwidth,
                   const INT outputs,
                   const RBW_UPDATE_TYPE update_rbw );
STATUS calcfilter_half_integer_decimation( FILTER_INFO * const echortf,
                                           const DOUBLE des_bandwidth,
                                           const INT outputs,
                                           const RBW_UPDATE_TYPE update_rbw );
void dump_filter_info( const FILTER_INFO * const filtinfo );
STATUS epigradopt( const OPT_GRAD_INPUT *const gradin,
                   OPT_GRAD_PARAMS *const gradout,
                   FLOAT *const pidbdtts,
                   FLOAT *const pidbdtper,
                   const DOUBLE cfdbdtts,
                   const DOUBLE cfdbdtper,
                   const DOUBLE cfdbdtdx,
                   const DOUBLE cfdbdtdy,
                   const INT reqesp,
                   const INT autogap,
                   const INT rampsamp,
                   const INT vrgsamp,
                   const INT debug );
STATUS epigradopt_zblips( const OPT_GRAD_INPUT *const gradin,
                   OPT_GRAD_PARAMS *const gradout,
                   FLOAT *const pidbdtts,
                   FLOAT *const pidbdtper,
                   FLOAT *const dbdtperx,
                   FLOAT *const dbdtpery,
                   FLOAT *const dbdtperz,
                   const DOUBLE cfdbdtts,
                   const DOUBLE cfdbdtper,
                   const DOUBLE cfdbdtdx,
                   const DOUBLE cfdbdtdy,
                   const DOUBLE cfdbdtdz,
                   const INT reqesp,
                   const INT autogap,
                   const INT rampsamp,
                   const INT vrgsamp,
                   const INT debug );
STATUS filterutilv6( FILTER_INFO * const echo1rtf,
                     FILTER_INFO * const echo2rtf,
                     const INT outputs,
                     const DOUBLE fnecholim,
                     const INT pwramp,
                     const INT read_timel,
                     const INT read_timer,
                     const INT read_wingl,
                     const INT read_wingr,
                     const INT read_wing2l,
                     const INT read_wing2r,
                     const INT treadvbw,
                     const INT maxseqtime );
STATUS fractecho( INT * const tfe_extra,
                  const DOUBLE fnecho_lim,
                  const INT seq_type,
                  const INT min_tenfe,
                  const INT read_pw,
                  const INT max_gx1time,
                  const DOUBLE amp_targetx,
                  const INT target_xrt,
                  const INT xres,
                  const DOUBLE fov );
STATUS maxwell_pc_calc( const INT max_flag,
                        const INT num_points,
                        const INT debug,
                        const INT pwgx1a,
                        const INT pwgx1,
                        const INT pwgx1d,
                        const INT pwgxfca,
                        const INT pwgxfc,
                        const INT pwgxfcd,
                        const INT pwgz1a,
                        const INT pwgz1,
                        const INT pwgz1d,
                        const INT pwgzfca,
                        const INT pwgzfc,
                        const INT pwgzfcd,
                        const INT pwgyfe1a,
                        const INT pwgyfe1,
                        const INT pwgyfe1d,
                        const INT pwgxwa,
                        const INT pwgy1a,
                        const INT pwgy1,
                        const INT pwgy1d,
                        const INT pwgzrf1d,
                        const DOUBLE flow_wdth_x,
                        const DOUBLE flow_wdth_z,
                        const INT iagx1fen,
                        const INT iagx1feu,
                        const INT iagx1fed,
                        const INT iagx2fen,
                        const INT iagx2feu,
                        const INT iagx2fed,
                        const INT iagz1fen,
                        const INT iagz1feu,
                        const INT iagz1fed,
                        const INT iagz2fen,
                        const INT iagz2feu,
                        const INT iagz2fed,
                        const INT iagy1feu,
                        const INT iagy1fed,
                        const INT iagy2feu,
                        const INT iagy2fed,
                        const DOUBLE agxw,
                        const DOUBLE agzrf1,
                        const long * const rotmat,
                        FLOAT * const maxcoef1a,
                        FLOAT * const maxcoef1b,
                        FLOAT * const maxcoef1c,
                        FLOAT * const maxcoef1d,
                        FLOAT * const maxcoef2a,
                        FLOAT * const maxcoef2b,
                        FLOAT * const maxcoef2c,
                        FLOAT * const maxcoef2d,
                        FLOAT * const maxcoef3a,
                        FLOAT * const maxcoef3b,
                        FLOAT * const maxcoef3c,
                        FLOAT * const maxcoef3d );
STATUS maxwellcomp( FLOAT * const a_mid,
                    INT * const pw_attack,
                    INT * const pw_mid,
                    INT * const pw_decay,
                    const DOUBLE maxterm,
                    const DOUBLE a_start,
                    const DOUBLE targetAmp,
                    const INT riseTime,
                    FLOAT * const r1,
                    FLOAT * const r2,
                    FLOAT * const r3 );
STATUS trapmaxwell( const DOUBLE a_start,
                    const INT pw_attack,
                    const DOUBLE a_mid,
                    const INT pw_mid,
                    const DOUBLE a_end,
                    const INT pw_decay,
                    FLOAT * const maxterm );
STATUS amppwgmn( const DOUBLE ref_area,
                 const DOUBLE ref_moment,
                 const DOUBLE encode_area,
                 const DOUBLE moment_area,
                 const INT max_allowable_time,
                 const DOUBLE beta,
                 DOUBLE targetamp,
                 const INT ramp2target,
                 const INT minconstpw,
                 FLOAT *a_gmn1,
                 INT *pw_gmn1a,
                 INT *pw_gmn1,
                 INT *pw_gmn1d,
                 FLOAT *a_gmn2,
                 INT *pw_gmn2a,
                 INT *pw_gmn2,
                 INT *pw_gmn2d );
STATUS calctrap1stmom( FLOAT *moment,
                       DOUBLE ampl,
                       INT attack,
                       INT plateau,
                       INT decay,
                       DOUBLE timeref );
STATUS optgmn( const DOUBLE a_left,
               const INT pw_lefta,
               const INT pw_left,
               const INT pw_leftd,
               const DOUBLE a_right,
               const INT pw_righta,
               const INT pw_right,
               const INT pw_rightd,
               FLOAT *a_mid,
               INT *pw_mida,
               INT *pw_mid,
               INT *pw_midd,
               const DOUBLE rate,
               INT *pos_mid,
               INT *pos_right );
STATUS rampmoments( const DOUBLE ampinitial,
                    const DOUBLE ampfinal,
                    const INT duration,
                    const INT invertphaseflag,
                    INT * const pulsepos,
                    FLOAT * const zerothmoment,
                    FLOAT * const firstmoment,
                    FLOAT * const zeromomentsum,
                    FLOAT * const firstmomentsum );
STATUS minseqbusbar( INT * const minseqtime,
                     const INT minseqcable,
                     const INT tmin_minseq );
STATUS minseqcable( INT * const minseqtime,
                    FLOAT * const xa2s,
                    FLOAT * const ya2s,
                    FLOAT * const za2s,
                    const INT srmode,
                    const GRAD_PULSE * const gradx,
                    const GRAD_PULSE * const grady,
                    const GRAD_PULSE * const gradz,
                    const INT numXpulse,
                    const INT numYpulse,
                    const INT numZpulse,
                    const DOUBLE gcontirms,
                    const INT tmin_minseq );
STATUS power_peraxis_cable( FLOAT * const power,
                            const INT numPulses,
                            const GRAD_PULSE * const grad );
STATUS power_peraxis( FLOAT *const power,
                      const INT numPulses,
                      GRAD_PULSE *const grad );
STATUS minseqcoil( INT *const minseqtime,
                   FLOAT *const xa2s,
                   FLOAT *const ya2s,
                   FLOAT *const za2s,
                   const INT srmode,
                   GRAD_PULSE *const gradx,
                   GRAD_PULSE *const grady,
                   GRAD_PULSE *const gradz,
                   const INT numXpulse,
                   const INT numYpulse,
                   const INT numZpulse,
                   const DOUBLE gcontirms );
STATUS minseqgrad( INT *const minseqgrddrv,
                   INT *const minseqgrddrvx,
                   INT *const minseqgrddrvy,
                   INT *const minseqgrddrvz,
                   INT *const ro_time,
                   INT *const pe_time,
                   INT *const ss_time,
                   INT *const px_time,
                   INT *const py_time,
                   INT *const pz_time,
                   GRAD_PULSE *const gradx,
                   GRAD_PULSE *const grady,
                   GRAD_PULSE *const gradz,
                   const INT numx,
                   const INT numy,
                   const INT numz,
                   const LOG_GRAD *const lgrad,
                   const PHYS_GRAD *const pgrad,
                   SCAN_INFO *const scaninfotab,
                   INT slquant,
                   const INT plane_type,
                   const INT coaxial,
                   const INT _sigrammode,
                   const INT debug,
                   FLOAT *const amptrans_px,
                   FLOAT *const amptrans_py,
                   FLOAT *const amptrans_pz,
                   FLOAT *const amptrans_lx,
                   FLOAT *const amptrans_ly,
                   FLOAT *const amptrans_lz,
                   FLOAT *const abspower_px,
                   FLOAT *const abspower_py,
                   FLOAT *const abspower_pz,
                   FLOAT *const abspower_lx,
                   FLOAT *const abspower_ly,
                   FLOAT *const abspower_lz,
                   FLOAT *const power_lx,
                   FLOAT *const pospower_lx,
                   FLOAT *const negpower_lx,
                   FLOAT *const power_ly,
                   FLOAT *const pospower_ly,
                   FLOAT *const negpower_ly,
                   FLOAT *const power_lz,
                   FLOAT *const pospower_lz,
                   FLOAT *const negpower_lz,
                   INT *const minseqgpm );
STATUS minseqgram( INT *minseqtime,
                   INT *ro_time,
                   INT *pe_time,
                   INT *ss_time,
                   INT *px_time,
                   INT *py_time,
                   INT *pz_time,
                   GRAD_PULSE *gradx,
                   GRAD_PULSE *grady,
                   GRAD_PULSE *gradz,
                   INT numx,
                   INT numy,
                   INT numz,
                   PHYS_GRAD *pgrad,
                   SCAN_INFO *scaninfotab,
                   INT slquant,
                   INT plane_type,
                   INT coaxial,
                   INT _sigrammode,
                   INT debug,
                   FLOAT *amptrans_px,
                   FLOAT *amptrans_py,
                   FLOAT *amptrans_pz,
                   FLOAT *amptrans_lx,
                   FLOAT *amptrans_ly,
                   FLOAT *amptrans_lz,
                   FLOAT *abspower_px,
                   FLOAT *abspower_py,
                   FLOAT *abspower_pz,
                   FLOAT *abspower_lx,
                   FLOAT *abspower_ly,
                   FLOAT *abspower_lz );
STATUS minseqgrddrv( LONG *const minseqtime,
                     FLOAT *const power,
                     FLOAT *const pospower,
                     FLOAT *const negpower,
                     const INT numPulses,
                     GRAD_PULSE *const grad,
                     const INT gramtype,
                     const DOUBLE irmspos,
                     const DOUBLE irmsneg,
                     const DOUBLE irms,
                     const DOUBLE ampgcmfs,
                     const DOUBLE gcmfs );
STATUS minseqsys( INT * const Minseqsys );
STATUS obloptimize( LOG_GRAD * const lgrad,
                    PHYS_GRAD * const pgrad,
                    SCAN_INFO * const scaninfotab,
                    INT slquant,
                    const INT plane_type,
                    const INT coaxial,
                    const INT method,
                    const INT debug,
                    INT * const newgeo,
                    const INT srmode );
STATUS obloptimize_epi( LOG_GRAD * const lgrad,
                        PHYS_GRAD * const pgrad,
                        SCAN_INFO * const scaninfotab,
                        INT slquant,
                        const INT plane_type,
                        const INT coaxial,
                        const INT method,
                        const INT debug,
                        INT * const newgeo,
                        const INT srmode );
STATUS obloptimizecalc( LOG_GRAD * const lgrad,
                        PHYS_GRAD * const pgrad,
                        SCAN_INFO * const scaninfotab,
                        INT slquant,
                        const INT plane_type,
                        const INT coaxial,
                        const INT method,
                        const INT debug,
                        INT * const newgeo,
                        const INT srmode,
                        const INT epimode );
STATUS l_p_transver( FLOAT * const phy,
                     const FLOAT a,
                     const FLOAT b,
                     const FLOAT c,
                     const DOUBLE logx,
                     const DOUBLE logy,
                     const DOUBLE logz );
STATUS ampfov( FLOAT *Ampfov,
               const DOUBLE readout_filter,
               const DOUBLE fov );
STATUS amppwgrad( const DOUBLE targetArea,
                  const DOUBLE targetAmp,
                  const DOUBLE startAmp,
                  const DOUBLE endAmp,
                  const INT riseTime,
                  const INT minConst,
                  FLOAT *Amp,
                  INT *Attack,
                  INT *Pw,
                  INT *Decay );
STATUS amppwgradmethod( const GRAD_PULSE * const gradpulse,
                        const DOUBLE targetArea,
                        const DOUBLE targetAmp,
                        const DOUBLE startAmp,
                        const DOUBLE endAmp,
                        const INT riseTime,
                        const INT minConst );
STATUS fitresol( SHORT * const resolution,
                 INT * const pulsewidth,
                 INT maxlimit,
                 const INT minlimit,
                 const INT cycle );
STATUS generatespiral_1( const float fov,
                         const int matrix,
                         const int nPoints,
                         const int nInterleaves,
                         const float deltaT,
                         const float slewMax,
                         const float gradMax,
                         int * const Gx,
                         int * const Gy,
                         float * const Kx,
                         float * const Ky,
                         float * const W,
                         float * const f,
                         float * const dbdtper_t );
STATUS generatespiral_2( const float fov,
                         const int matrix,
                         const int nPoints,
                         const int nInterleaves,
                         const float deltaT,
                         const float slewMax,
                         const float gradMax,
                         const float alpha,
                         int * const Gx,
                         int * const Gy,
                         float * const f );
STATUS getbeta( FLOAT *beta,
                WF_PROCESSOR wgname,
                LOG_GRAD *lgrad );
STATUS getramptime( INT * const risetime,
                    INT * const falltime,
                    const WF_PROCESSOR wgname,
                    const LOG_GRAD * const lgrad );
STATUS gettarget( FLOAT * const target,
                  const WF_PROCESSOR wgname,
                  const LOG_GRAD * const lgrad );
STATUS ileaveinit( const INT nframes,
                   const INT kydir,
                   const INT intleaves,
                   const INT alt_fact,
                   const INT gpolarity,
                   const INT bpolarity,
                   const INT debug,
                   const INT rfamp,
                   const INT blipamp,
                   const INT pepolarity,
                   const INT etl,
                   const INT seqdata,
                   const DOUBLE tshift,
                   const INT tfon,
                   const INT fract_ky,
                   const DOUBLE ky_off,
                   const INT num_overscan,
                   const INT pe_end_iamp,
                   const INT esp,
                   const DOUBLE tsp,
                   const INT samples,
                   const DOUBLE ro_amp,
                   const INT xft_size,
                   const INT slquant,
                   const INT lpf,
                   const INT iref_etl,
                   INT * const gy1f,
                   INT * const view1st,
                   INT * const viewskip,
                   INT * const tf,
                   INT * const rfpol,
                   INT * const gradpol,
                   INT * const blippol,
                   INT * const mintf );
STATUS inittargets( LOG_GRAD *const lgrad,
                    PHYS_GRAD *const pgrad );
STATUS initpgradtargets( PHYS_GRAD *const phys_grad );
STATUS setuppgrad( PHYS_GRAD *const phys_grad );
STATUS initlgradtargets( LOG_GRAD *const log_grad );
STATUS optramp( LONG *pulsewidth,
                const DOUBLE ampdelta,
                const DOUBLE maxamp,
                const INT rmp2fullscale,
                const INT defineType );
INT psd_getgradmode( void );
STATUS scalerotmats( long (*rsprot)[9],
                     const LOG_GRAD *lgrad,
                     const PHYS_GRAD *pgrad,
                     const INT slquant,
                     const INT debug );
STATUS maxfov( FLOAT *Maxfov );
STATUS maxnecho( INT *Maxnecho,
                 LONG nonTEtime,
                 LONG maxSeqTime,
                 INT echoType );
STATUS maxpass( INT * const Maxpass,
                const INT acqType,
                const INT numLocs,
                const INT locsPerPass );
STATUS maxphases( INT * const Maxphases,
                  const LONG seqTimPresc,
                  const INT acqType,
                  const LONG otherslicelimit );
STATUS maxslquant( INT * const Maxslquant,
                   const INT repetitionTime,
                   const INT otherslicelimit,
                   const INT acqType,
                   const INT seqTimPresc );
STATUS maxslquant1( const INT Maxslquant,
                    INT * const repetitionTime,
                    const INT acqType,
                    const INT seqTimPresc,
                    const INT gating );
STATUS maxslquanttps( INT * const Maxslquanttps,
                      const INT imageSize,
                      const INT siSize,
                      const INT numTemporalPhases,
                      const MAXSLQUANTTPS_OPTION *option );
INT maxslquantBasedOnEnergyLimit(const FLOAT sar,
                                 const FLOAT sarLimit,
                                 const INT slicesInOnePass);
STATUS maxte1( LONG *Maxte1,
               LONG maxSeqTime,
               INT echoType,
               LONG nonTEtime,
               INT min_fullte );
STATUS maxte2( LONG * const Maxte2,
               const LONG maxSeqTime,
               const LONG nonTEtime );
STATUS maxti( INT * const maxtitime,
              const INT gating,
              const INT te_time,
              const INT nonteti,
              const INT slquant_one,
              const INT tmin,
              const INT left_rf0_time,
              const INT left_rf1_time );
STATUS maxti_rep( INT * const maxtitime,
                  const INT gating,
                  const INT te_time,
                  const INT nonteti,
                  const INT slquant_one,
                  const INT tmin,
                  const INT left_rf0_time,
                  const INT left_rf1_time,
                  const INT num_reps );
STATUS maxtr( INT * const Maxtr );
STATUS maxyres( INT * const Maxyres,
                const DOUBLE targetAmp,
                const INT ramp_time,
                const INT avaiPhaseTime,
                const DOUBLE fov,
                const GRAD_PULSE * const gradstruct_y,
                const INT stepsize );
STATUS minfov( FLOAT * const Minfov,
               const GRAD_PULSE * const gradstruct,
               const DOUBLE foview,
               const INT seq_type,
               const INT phase_time,
               const INT freq_time,
               const DOUBLE readout_BW,
               const INT phase_encode_resolution,
               const INT existyres,
               const INT phasestep,
               const DOUBLE yaspect_ratio,
               const INT flow_comp_type,
               const INT readout_pw,
               const DOUBLE fractecho_fact,
               const DOUBLE gxwtargetamp,
               const DOUBLE gx1targetamp,
               const INT ramp2xtarget,
               const DOUBLE gy1targetamp,
               const INT ramp2ytarget );
STATUS minpulsesep( INT * const Minpulsesep,
                    const INT pwgzrf1d,
                    const INT pwgzrf2l1a,
                    const INT pwgzrf2l1,
                    const INT pwgzrf2l1d );
STATUS minte1_enh( INT * const Minte1,
                   const INT yresolution,
                   const DOUBLE foview,
                   const INT min_seq1,
                   const INT min_seq2,
                   const INT min_seq3,
                   const INT seq_type,
                   const INT echo_type,
                   const INT read_pw,
                   const DOUBLE left_wing_area,
                   const INT iso_delay,
                   const INT rf_180_pw,
                   const INT flow_comp_type,
                   const DOUBLE fnecho_lim,
                   const GRAD_PULSE *gradstruct_y,
                   const DOUBLE gxw_target,
                   const DOUBLE gx1_target,
                   const INT pw_rampx );
STATUS minte1( INT * const Minte1,
               const INT yresolution,
               const DOUBLE foview,
               const INT min_seq1,
               const INT min_seq2,
               const INT min_seq3,
               const INT seq_type,
               const INT echo_type,
               const INT read_pw,
               const INT iso_delay,
               const INT rf_180_pw,
               const INT flow_comp_type,
               const DOUBLE fnecho_lim,
               const GRAD_PULSE *gradstruct_y,
               const DOUBLE gxw_target,
               const DOUBLE gx1_target,
               const INT pw_rampx );
STATUS minte2( INT * const Minte2,
               const INT tfe_extra,
               const INT min_seq1,
               const INT min_seq2,
               const INT seq_type,
               const INT echo_type,
               const INT read_pw1,
               const DOUBLE amp_read1,
               const INT read_pw2,
               const DOUBLE amp_read2,
               const INT flow_comp_type,
               const DOUBLE target_ampx,
               const INT target_xrt );
STATUS minti( INT * const Minti,
              const INT slquant1,
              const INT tmin,
              const INT tileftovers,
              const INT sat2flag );
STATUS mintr( LONG * const Mintr,
              const INT acqType,
              const LONG minseqTime,
              const INT Slquant1,
              const INT gating );
STATUS zoom_limit( INT *index_limit,
                   FLOAT *off_cent_dist,
                   const INT app_grad_type,
                   const INT grad_mode,
                   const INT zoom_coil_index,
                   const FLOAT zoom_fov_xy,
                   const FLOAT zoom_fov_z,
                   const FLOAT zoom_dist_ax,
                   const FLOAT zoom_dist_cor,
                   const FLOAT zoom_dist_sag,
                   const DOUBLE foview,
                   const DOUBLE fov_phase_frac,
                   const INT imag_plane,
                   const INT slquant,
                   SCAN_INFO *scaninfotab );
void advroundup( INT * const adv_panel_value );
void advrounddown( INT * const adv_panel_value );
STATUS highlow( INT * const low,
                INT * const high,
                const INT resolution,
                const SHORT * const waveform );
STATUS scale( FLOAT (*inrotmat)[9],
              long (*outrotmat)[9],
              const INT slquant,
              const LOG_GRAD * const lgrad,
              const PHYS_GRAD * const pgrad,
              const INT contdebug );
STATUS unscale( long (*inrotmat)[9],
                FLOAT (*outrotmat)[9],
                const INT slquant,
                const LOG_GRAD * const lgrad,
                const PHYS_GRAD * const pgrad,
                const INT contdebug );
STATUS newrotatearray( long (*inrot)[9],
                       long (*outrot)[9],
                       const DOUBLE alpha,
                       const DOUBLE beta,
                       const DOUBLE gamma,
                       const INT slquant,
                       const LOG_GRAD * const lgrad,
                       const PHYS_GRAD * const pgrad,
                       const INT contdebug );
STATUS xyztofpn( long (*rotmit)[9],
                 const INT slquant,
                 FLOAT (*xyz)[3],
                 RSP_INFO * const fpn,
                 const LOG_GRAD * const lgrad,
                 const PHYS_GRAD * const pgrad,
                 const INT contdebug );
STATUS fpntoxyz( long (*rotmit)[9],
                 const INT slquant,
                 FLOAT (*xyz)[3],
                 const RSP_INFO * const tpn,
                 const LOG_GRAD * const lgrad,
                 const PHYS_GRAD * const pgrad,
                 const INT contdebug );
STATUS matrixcheck( const INT maxx,
                    const INT maxy );
STATUS matrixcheck_ext( const INT max_x,
                        INT max_y,
                        const INT min_yres );
STATUS modrotmats( long (*inrot)[9],
                   long (*outrot)[9],
                   const INT alpha,
                   const INT beta,
                   const INT gamma,
                   const INT slquant,
                   const INT debug );
STATUS orderphases( SHORT * const phase2view,
                    const INT respCompType,
                    const INT phaseRes );
STATUS vrghighlow( INT * const low,
                   INT * const high,
                   const INT resolution,
                   const SHORT * const waveform );
STATUS amppwencode( const GRAD_PULSE* const gradpulse,
                    INT *total_pw,
                    const DOUBLE target_amp,
                    const INT rise_time,
                    const DOUBLE fov,
                    const INT num_encodes,
                    const DOUBLE area_offset );
STATUS
amppwencode_slice( const GRAD_PULSE *gradpulse,
                   INT *total_pw,
                   const DOUBLE target_amp,
                   const INT rise_time,
                   const DOUBLE slabthick,
                   const INT num_encodes,
                   const DOUBLE area_offset );
STATUS
amppwencodecalc( const GRAD_PULSE *gradpulse,
                 INT *total_pw,
                 const DOUBLE target_amp,
                 const INT rise_time,
                 const DOUBLE fov,
                 const INT num_encodes,
                 const DOUBLE area_offset );
STATUS amppwencode2( const GRAD_PULSE* const gradpulse,
                     INT *total_pw,
                     const DOUBLE target_amp,
                     const INT rise_time,
                     const DOUBLE fov,
                     const INT num_encodes,
                     const DOUBLE area_offset,
                     DOUBLE area_offset_scale );
STATUS amppwencodefse( FLOAT *ampencode,
                       INT *pw_encode,
                       const DOUBLE fov,
                       const INT encodes,
                       const INT logaxis,
                       const INT xflag,
                       const INT yflag,
                       const INT zflag );
STATUS amppwencodet( FLOAT *a_attack,
                     FLOAT *a_decay,
                     INT *pw_middle,
                     INT *pw_attack,
                     INT *pw_decay,
                     const DOUBLE target_amp,
                     const INT rise_time,
                     const DOUBLE fov,
                     const INT size );
STATUS amppwtpe( FLOAT *a_attack,
                 FLOAT *a_decay,
                 INT *pw_middle,
                 INT *pw_attack,
                 INT *pw_decay,
                 const DOUBLE target_amp,
                 const INT rise_time,
                 const DOUBLE target_area );
STATUS amppwtpe2( FLOAT *a_attack,
                  FLOAT *a_decay,
                  INT *pw_middle,
                  INT *pw_attack,
                  INT *pw_decay,
                  const DOUBLE target_amp,
                  const INT rise_time,
                  const DOUBLE target_area,
                  const DOUBLE target_area_largest );
void amppwygmn( const DOUBLE zeromoment,
                const DOUBLE firstmoment,
                const INT pw_gy1fa,
                const INT pw_gy1f,
                const INT pw_gy1fd,
                const DOUBLE a_gy1fa,
                const DOUBLE a_gy1fb,
                const DOUBLE targetamp,
                const DOUBLE ramp2target,
                const INT method,
                INT *pw_gymna,
                INT *pw_gymn,
                INT *pw_gymnd,
                FLOAT *a_gymn );
STATUS avepepowscale( FLOAT *scale_fact,
                      INT num_encodes,
                      INT overscans );
STATUS
avepepowscale_slice( FLOAT *scale_fact,
                     INT num_encodes,
                     INT overscans );
STATUS
avepepowscalecalc( FLOAT *scale_fact,
                   INT num_encodes,
                   INT overscans,
                   FLOAT fov );
STATUS blipcorr( INT * const ia_gyb_corr,
                 const DOUBLE da_gyb_corr,
                 const INT debug,
                 long (*rsprot)[9],
                 const DOUBLE mult_fact,
                 const INT xfs,
                 const INT yfs,
                 const INT zfs,
                 const DOUBLE itx,
                 const DOUBLE ity,
                 const DOUBLE itz,
                 const INT control,
                 const INT nslices,
                 const LOG_GRAD * const lgrad,
                 const INT pw_gyb,
                 const INT pw_gyba,
                 const DOUBLE a_gxw );
STATUS blipcorrdel( FLOAT * const bc_delx,
                    FLOAT * const bc_dely,
                    FLOAT * const bc_delz,
                    const INT esp,
                    const INT coiltype,
                    const INT debug );
STATUS avecrushpepowscale( FLOAT *const scale_fact,
                           const INT num_encodes,
                           const INT overscans,
                           const int even_sym,
                           const float crush_area,
                           const float fov );
STATUS
calcrecphase( int *rec_phase,
              const float phase_offset,
              const float fov,
              const float phase_fov,
              const float nop_factor,
              const float asset_factor);
INT get_tsp_mgd( void );
FLOAT get_max_rbw_hw( void );
STATUS calcvalidrbw( const DOUBLE des_bandwidth,
                     FLOAT * const rbw,
                     FLOAT * const max_bw,
                     FLOAT *decimation,
                     const RBW_UPDATE_TYPE override_rbw,
                     const int vrgf_samp );
STATUS initfilter( void );
STATUS setfilter( FILTER_INFO * const echofilt,
                  const FILTER_BLOCK_TYPE type );
void dump_runtime_filter_info( const PSD_FILTER_GEN *filtgen );
STATUS specparamset( FLOAT * const gamma,
                     INT * const bbandfilt,
                     INT * const xmtband,
                     const INT nucleus );
STATUS getGamma( FLOAT * const gamma,
                 const INT nucleus );
STATUS minseqrfamp_coil( INT *Minseqrfamp,
                         const INT numPulses,
                         const RF_PULSE *rfpulse,
                         const INT entry,
                         const INT activeExciter,
                         const TX_COIL_INFO txCoil );
STATUS minseqrfamp_exciter( INT *Minseqrfamp_exciter,
                            const INT numPulses,
                            const RF_PULSE *rfpulse,
                            const INT entry,
                            INT *exciterUsedFlag );
STATUS minseqrfamp_b1scale( INT *Minseqrfamp,
                            const INT numPulses,
                            const RF_PULSE *rfpulse,
                            const INT entry );
STATUS minseqrfamp( INT *Minseqrfamp,
                    const INT numPulses,
                    const RF_PULSE *rfpulse,
                    const INT entry );
STATUS rfamppowlimit( double *rfamplimit,
                      const TX_COIL_INFO* txCoil );
STATUS pulseEnergyB1LimitForCoil( double* coil_b1_limit,
                                  const RF_PULSE* const pulse,
                                  const TX_COIL_INFO* const txCoil );
STATUS pulseEnergyB1Limit( double* b1limit,
                           const RF_PULSE* const pulse );
void setuprfpulse( const INT slot,
                   INT *pw,
                   FLOAT *amp,
                   const DOUBLE abswidth,
                   const DOUBLE effwidth,
                   const DOUBLE area,
                   const DOUBLE dtycyc,
                   const DOUBLE maxpw,
                   const INT num,
                   const DOUBLE max_b1,
                   const DOUBLE max_int_b1_sq,
                   const DOUBLE max_rms_b1,
                   const DOUBLE nom_fa,
                   FLOAT *act_fa,
                   const DOUBLE nom_pw,
                   const DOUBLE nom_bw,
                   const UINT activity,
                   const UCHAR reference,
                   const INT isodelay,
                   const DOUBLE scale,
                   INT *res,
                   const INT extgradfile,
                   INT *exciter,
                   const INT hadamardfactor,
                   RF_PULSE *rfpulse );
void updaterfpulse( const INT slot,
                    const DOUBLE abswidth,
                    const DOUBLE effwidth,
                    const DOUBLE area,
                    const DOUBLE dtycyc,
                    const DOUBLE maxpw,
                    const INT num,
                    const DOUBLE max_b1,
                    const DOUBLE max_int_b1_sq,
                    const DOUBLE max_rms_b1,
                    const DOUBLE nom_fa,
                    const DOUBLE nom_pw,
                    const DOUBLE nom_bw,
                    const UINT activity,
                    const UCHAR reference,
                    const INT isodelay,
                    const DOUBLE scale,
                    const INT extgradfile,
                    const INT hadamardfactor,
                    RF_PULSE *rfpulse );
void setrfpulsepointers( const INT slot,
                         INT *pw,
                         FLOAT *amp,
                         FLOAT *act_fa,
                         INT *res,
                         INT *exciter,
                         RF_PULSE *rfpulse );
void setupslices( INT *sliceTab,
                  const RSP_INFO *rspInfoTab,
                  const INT numLocs,
                  const DOUBLE gradStrength,
                  const DOUBLE receiveBW,
                  const DOUBLE fov,
                  const INT transmitFlag );
void receivefreqcheck( const SCAN_INFO * scan_info,
                       const INT numlocs,
                       const float receiveBW,
                       float * newRBW,
                       const float fov,
                       const float act_field_strength,
                       const float noisefreefreqlow,
                       const float noisefreefreqhigh,
                       const float minrbw,
                       const float cerdmaxbw);
void receivefreqcheckprop( const float cfreqtemplow,
                           const float cfreqtemphigh,
                           const float receiveBW,
                           float * newRBW,
                           const float fov,
                           float oversampling_factor,
                           float act_field_strength,
                           const float orig_noisefreefreqlow,
                           const float orig_noisefreefreqhigh,
                           float minrbw,
                           float maxcerdbw);
void receivefreqcalc( const float cfreqtemplow,
                      const float cfreqtemphigh,
                      const float receiveBW,
                      float * newRBW,
                      const float act_field_strength,
                      const float noisefreefreqlow,
                      const float noisefreefreqhigh,
                      const float cerdmaxbw);
void receivefreqoffsetcalc( const SCAN_INFO * scan_info,
                            const INT numLocs,
                            const float receiveBW,
                            const float fov,
                            int * offsetfreqlow,
                            int * offsetfreqhigh);
void calcvalidreceivebw( float *newRBW,
                         float oversampling_factor,
                         float maxcerdbw);
STATUS altrfgen( const INT gentypflag,
                 const INT resolution,
                 const SHORT *kernel,
                 const DOUBLE cycles,
                 const DOUBLE slice_offset,
                 const DOUBLE slice_mod_fact,
                 const SHORT *phase_kernel,
                 const DOUBLE start_phase,
                 SHORT *result_wave,
                 const DOUBLE freq_step );
STATUS altcomplexrfgen( const INT gentypflag,
                        const INT resolution,
                        const SHORT *kernel_rho,
                        const SHORT *kernel_theta,
                        const DOUBLE cycles,
                        const DOUBLE slice_offset,
                        const DOUBLE slice_mod_fact,
                        const SHORT *phase_kernel,
                        const DOUBLE start_phase,
                        SHORT *result_wave_rho,
                        SHORT *result_wave_theta,
                        const DOUBLE freq_step );
static const double FAILSAFE_JSTD = 1.0e4;
static const double JSTD_RX_SI_CHANGE_THRESHOLD = 5.0;
typedef enum jstdPositionErr_e {
    JSTDPOS_ASSIGNMENT_ERROR = 0,
    JSTDPOS_NO_ERROR = 1,
    JSTDPOS_CALCULATION_ERROR,
    JSTDPOS_DATA_ERROR,
    JSTDPOS_CONDITION_ERROR
} jstdPositionErr_e;
typedef struct jstdConditions_s {
        int activate;
        double mass;
        n32 tx_coil_type;
} jstdConditions_t;
typedef POSITION_DETECTION_DONE_TYPE jstdReferencePosition_t;
typedef struct jstdPositionResult_s {
        double wholeBodyJstd;
        double headJstdFraction;
        double headJstd;
        double headMass;
        double partialBodyMassFraction;
        double partialBodyJstdFraction;
        double offset;
        jstdPositionErr_e errcode;
} jstdPositionResult_t;
typedef struct jstdResults_s {
        double coilJstd;
        double coilMeanJstd;
        jstdPositionResult_t rxPosition;
} jstdResults_t;
     jstdReferencePosition_t jstdReferencePosition();
    short usablePositionDependentConfig( void );
    short usablePositionDependentConfigAtMass( const double mass );
    short usePositionDependentEnergy( jstdConditions_t* conditions );
    jstdPositionResult_t positionDependentJstdCalculation( const double mass, const double position );
typedef enum scalerfpulses_b1_derate_type
{
    DERATE_B1_BY_COIL = 1,
    DERATE_B1_MIN_SAR_COIL = 2
} scalerfpulses_b1_derate_type_e;
double calcCoilWeight( const TX_COIL_INFO* txCoil,
                       const double mass );
double calcExtremityLimit( const TX_COIL_INFO* txCoil,
                           const double mass,
                           const double maxExtremity,
                           const double maxBody );
double calcHeadWeight( const double mass );
double calcStdRF( const RF_PULSE * const rfpulse,
                  const DOUBLE b1Val,
                  const double gamma_factor );
STATUS maxsar( INT * const Maxseqsar,
                   INT * const Maxslicesar,
                   DOUBLE * const Avesar,
                   DOUBLE * const Cavesar,
                   DOUBLE * const Pksar,
                   DOUBLE * const B1rms,
                   const INT numPulses,
                   const RF_PULSE * const rfpulse,
                   const INT entry,
                   const INT tr_val );
STATUS maxsar_coil( INT * const Maxseqsar,
                    INT * const Maxslicesar,
                    DOUBLE * const Avesar,
                    DOUBLE * const Cavesar,
                    DOUBLE * const Pksar,
                    const INT numPulses,
                    const RF_PULSE * const rfpulse,
                    const INT entry,
                    const TX_COIL_INFO txCoil,
                    const INT activeExciter,
                    const int TR_val );
STATUS maxsar_exciter( INT *Maxseqsar_exciter,
                       INT *Maxslicesar_exciter,
                       DOUBLE *Avesar_exciter,
                       DOUBLE *Cavesar_exciter,
                       DOUBLE *Pksar_exciter,
                       DOUBLE *B1rms_exciter,
                       const INT numPulses,
                       const RF_PULSE * const rfpulse,
                       const INT entry,
                       const int TR_val,
                       INT *exciterUsedFlag );
STATUS maxseqsar( INT * const Maxseqsar,
                  const INT numPulses,
                  const RF_PULSE * const rfpulse,
                  const INT entry );
STATUS maxseqsar_b1scale( INT * const Maxseqsar,
                          const INT numPulses,
                          const RF_PULSE *rfpulse,
                          const INT entry );
STATUS maxseqslicesar( INT * const Maxseqsar,
                       INT * const Maxslicesar,
                       const INT numPulses,
                       const RF_PULSE * const rfpulse,
                       const INT entry );
STATUS maxslicesar( INT * const Maxslicesar,
                    const INT numPulses,
                    const RF_PULSE * const rfpulse,
                    const INT entry );
STATUS maxslicesar_b1scale( INT * const Maxslicesar,
                            const INT numPulses,
                            const RF_PULSE *rfpulse,
                            const INT entry );
STATUS maxslicesar_modified( LONG * const Maxslicesar,
                             const INT numPulses,
                             const RF_PULSE * const rfpulse,
                             const INT entry,
                             const INT tr_val );
STATUS peakAveSars( double * const Avesar,
                    double * const Cavesar,
                    double * const Pksar,
                    double * const B1rms,
                    const int numPulses,
                    const RF_PULSE * const rfpulse,
                    const int entry,
                    const int tr_val );
STATUS publishImagingSar( const int numPulses,
                          const RF_PULSE *rfpulse,
                          const int tr_val );
STATUS sarEstimates( double *Avesar,
                     double *Cavesar,
                     double *Pksar,
                     double *B1rms,
                     const int numPulses,
                     const RF_PULSE *rfpulse,
                     const int entry,
                     const int tr_val );
STATUS powermon( ENTRY_POINT_TABLE * const entryPoint,
                 const INT entry,
                 const INT numPulses,
                 const RF_PULSE *rfpulse,
                 const INT sarTseq );
s16 scalePowermonWatts( const float wattsperkg );
STATUS setupPowerMonitor( ENTRY_POINT_TABLE * const entryPoint,
                          const double avg_sar );
STATUS scalerfpulses_coil( const DOUBLE weight,
                           const INT gcoiltype,
                           const INT numPulses,
                           const RF_PULSE * const rfpulse,
                           const INT entry,
                           RF_PULSE_INFO * const rfpulseInfo,
                           const int derate_type,
                           const TX_COIL_INFO txCoil,
                           const INT activeExciter );
STATUS scalerfpulses( const DOUBLE weight,
                      const INT gcoiltype,
                      const INT numPulses,
                      const RF_PULSE * const rfpulse,
                      const INT entry,
                      RF_PULSE_INFO * const rfpulseInfo );
STATUS scalerfpulses_derate( const DOUBLE weight,
                             const INT gcoiltype,
                             const INT numPulses,
                             const RF_PULSE * const rfpulse,
                             const INT entry,
                             RF_PULSE_INFO * const rfpulseInfo,
                             const INT b1_derate_type );
STATUS scalerfpulses2ut( const DOUBLE derateb1,
                         const INT updatetime,
                         const RF_PULSE * const rfpulse,
                         const INT entry,
                         const INT pulse,
                         RF_PULSE_INFO * const rfpulseInfo,
                         const INT activeExciter );
STATUS scalerfpulsescalc( const INT oldpwrf,
                          INT newpwrf,
                          const INT updatetime,
                          const RF_PULSE * const rfpulse,
                          const INT entry,
                          const INT pulse,
                          RF_PULSE_INFO * const rfpulseInfo,
                          const INT activeExciter );
STATUS findMaxB1Seq( float *maxB1Seq,
                     float *maxB1,
                     const INT numEntries,
                     const RF_PULSE * const rfpulse,
                     const INT numPulseEntries );
STATUS peakB1( FLOAT *maxB1Val,
               const INT entryPoint,
               const INT numPulseEntries,
               const RF_PULSE * const rfpulse );
STATUS peakB1_exciter( FLOAT *maxB1Val,
                       const INT entryPoint,
                       const INT numPulseEntries,
                       const RF_PULSE * const rfpulse,
                       const INT activeExciter );
STATUS calcB1Val( DOUBLE *b1Val,
                  DOUBLE *scale,
                  const RF_PULSE * const rfpulse,
                  const INT pulse,
                  const UCHAR active,
                  const INT e_flag );
STATUS calcPulseB1Rms( DOUBLE *b1RMSVal,
                       DOUBLE *scale,
                       const RF_PULSE * const rfpulse,
                       const INT pulse,
                       const UCHAR active,
                       const INT e_flag );
STATUS calcIntegratedB1Squared( DOUBLE *b1Sqr,
                                DOUBLE *scale,
                                const RF_PULSE * const rfpulse,
                                const INT pulse,
                                const UCHAR active,
                                const INT e_flag );
STATUS peakHardrfB1( FLOAT *maxB1Val,
                     const INT entryPoint,
                     const INT numPulseEntries,
                     const RF_PULSE * const rfpulse );
STATUS peakHardrfB1_exciter( FLOAT *maxB1Val,
                             const INT entryPoint,
                             const INT numPulseEntries,
                             const RF_PULSE * const rfpulse,
                             const INT activeExciter );
STATUS calcRFPower( double * const power_factor,
                    double * const coil_jstd,
                    const TX_COIL_INFO txCoil );
STATUS calcMeanRFPower( double * const mean_power_factor,
                        double * const mean_coil_jstd,
                        const TX_COIL_INFO txCoil );
STATUS calcRFPowerDual( double * const power_factor,
                        double * const mean_power_factor,
                        double * const coil_jstd,
                        double * const mean_coil_jstd,
                        const TX_COIL_INFO txCoil );
STATUS peakrf( DOUBLE * const peak_output,
               DOUBLE * const est_jstd,
               const INT numPulses,
               const RF_PULSE *rfpulse,
               const INT entry );
STATUS peakrf_exciter( DOUBLE * const peak_output_exciter,
                       DOUBLE * const est_jstd_exciter,
                       const INT numPulses,
                       const RF_PULSE * const rfpulse,
                       const INT entry,
                       INT *exciterUsedFlag );
STATUS peakrf_coil( DOUBLE * const peak_output,
                    DOUBLE * const est_jstd,
                    const INT numPulses,
                    const RF_PULSE *rfpulse,
                    const INT entry,
                    const INT activeExciter,
                    const TX_COIL_INFO txCoil );
STATUS mean_peakrf_coil( DOUBLE * const mean_peak_output,
                         DOUBLE * const mean_est_jstd,
                         const INT numPulses,
                         const RF_PULSE *rfpulse,
                         const INT entry,
                         const INT activeExciter,
                         const TX_COIL_INFO txCoil );
STATUS dual_peakrf_coil( DOUBLE * const peak_output,
                         DOUBLE * const mean_peak_output,
                         DOUBLE * const est_jstd,
                         DOUBLE * const mean_est_jstd,
                         const INT numPulses,
                         const RF_PULSE *rfpulse,
                         const INT entry,
                         const INT activeExciter,
                         const TX_COIL_INFO txCoil );
STATUS calcJstd( double * const jstd,
                 const double weight,
                 const TX_COIL_INFO txCoil,
                 const int gradcoil,
                 const int field );
STATUS calcMeanJstd( double * const meanJstd,
                     const double weight,
                     const TX_COIL_INFO txCoil,
                     const int gradcoil,
                     const int field );
STATUS calcDualJstd( double * const jstd,
                     double * const meanJstd,
                     const double weight,
                     const TX_COIL_INFO txCoil,
                     const int gradcoil,
                     const int field );
STATUS calcJstdSet( jstdResults_t* results,
                    const double weight,
                    const TX_COIL_INFO* txCoil,
                    const int gradcoil,
                    const int field );
STATUS calcRfForward( double * const rfforward,
                      const double weight,
                      const TX_COIL_INFO txCoil,
                      const int gradcoil,
                      const int field );
void applyDiscretionaryB1Limit( double * const b1limit );
STATUS amplifierB1Limit( double * const B1_limit,
                         const TX_COIL_INFO txCoil );
STATUS coilB1Limit( double * const B1_limit,
                    const TX_COIL_INFO txCoil );
void calcTGLimit( int * const tgcap_output,
                  int * const tgwindow_output,
                  const float maxB1Seq,
                  const TX_COIL_INFO txCoil );
void requestRTSarForApplication( int rtsar_application_flag );
STATUS amppwcombpe( const DOUBLE a_start,
                    const DOUBLE area_const,
                    const DOUBLE area_pe,
                    const DOUBLE max_amp,
                    const DOUBLE slew_rate,
                    const INT nencodes,
                    INT *pw_attack,
                    INT *pw_plat,
                    INT *pw_decay,
                    FLOAT *a_base,
                    FLOAT *a_ramp );
STATUS amppwgz1( FLOAT *ampgz1,
                 INT *c_pwgz1,
                 INT *a_pwgz1,
                 INT *d_pwgz1,
                 const DOUBLE area,
                 const INT avai_ptime,
                 const INT minconstpw,
                 const INT rmpfullscale,
                 const DOUBLE target );
STATUS ampslice( FLOAT *amp_slice_select,
                 const LONG trans_bwd,
                 const DOUBLE slice_thk,
                 const DOUBLE factor,
                 const INT def_type );
STATUS minslicethick( FLOAT *amp_slice_select,
                      const LONG trans_bwd,
                      const DOUBLE slice_thk,
                      const DOUBLE factor,
                      const INT def_type );
void dump_Data_Acquisition_Order_Table( const INT numAcqs,
                                        const INT sl_in_pass[] );
void printPHYSGRAD( trace_module t_module,
                    const PHYS_GRAD *pulse );
void printLOGGRAD( trace_module t_module,
                   const LOG_GRAD *pulse );
void printCVARG( trace_module t_module,
                 const int opcv_type,
                 const void *cv_arg,
                 const char *cv_name );
void printEntrypointLabel( const trace_level_e level,
                           const trace_module t_module ,
                           const int entry );
void psd_dump_scan_info( void );
void psd_dump_rsp_info( void );
void psd_dump_psc_info( void );
void psd_dump_rsp_psc_info( void );
void psd_dump_coil_info( void );
void
set_vol_shift_cvs( void );
void
set_vol_scale_cvs( const int gradCoilType,
                   const int scaleDirBit,
                   const int scaleConstraintFlag,
                   int* volScaleType,
                   int* volScaleConstraintType);
FLOAT
get_act_freq_fov( void );
FLOAT
get_act_phase_fov( void );
STATUS
calcOptimizedPulses( LOG_GRAD *p_loggrd,
                     FLOAT *Pidbdtper,
                     FLOAT *derate_factor,
                     const FLOAT cf_dbdt_per,
                     const INT core_index,
                     const INT debug_level,
                     const INT e_flag,
                     const INT higher_dbdt_mode );
void
calcTGLimitAtOffset( int off_freq,
                     int *tg_limit,
                     int debug );
int
getCornerPointFileGenerationFlag( void );
STATUS
getCornerPoints( FLOAT **p_time,
                 FLOAT *ampl[3],
                 FLOAT *pul_type[3],
                 INT *num_totpoints,
                 INT *num_iters,
                 const LOG_GRAD *log_grad,
                 const INT seq_entry_index,
                 const INT samp_rate,
                 const INT min_tr,
                 const FLOAT dbdtinf,
                 const FLOAT dbdtfactor,
                 const FLOAT efflength,
                 const INT max_encode_mode,
                 const mss_flags_t* flags );
int
getPulsegenOnHostStopwatchFlag( void );
STATUS
minseq( INT *p_minseqgrad,
        GRAD_PULSE *gradx,
        const INT gx_free,
        GRAD_PULSE *grady,
        const INT gy_free,
        GRAD_PULSE *gradz,
        const INT gz_free,
        const LOG_GRAD *loggrd,
        const INT seq_entry_index,
        const INT samp_rate,
        const INT min_tr,
        const INT e_flag,
        const INT debug_flag );
void setLinearModel1(void);
void setLinearModel2(void);
int calcLinearModel(const int model_etl,
                    const int real_etl);
STATUS
updateIndex( int *index );
INT
updateTGLimitAtOffset( int tglimit,
                       int tglimit2 );
STATUS
set_app_grad_modeling( const INT debug );
STATUS
set_igbt_spec( const INT debug );
STATUS
set_Rio_40170_spec( const INT debug);
void
setupdBdtFlags( mss_flags_t* flags );
STATUS
shimvol_slice_intersect( PSC_INFO *shimvol_info,
                         SCAN_INFO *slice_info,
                         FLOAT margin,
                         INT debug );
STATUS getbeta( FLOAT *beta, WF_PROCESSOR wgname, LOG_GRAD *lgrad );
STATUS getramptime( INT *const risetime, INT *const falltime, const WF_PROCESSOR wgname, const LOG_GRAD *const lgrad );
STATUS gettarget( FLOAT *const target, const WF_PROCESSOR wgname, const LOG_GRAD *const lgrad );
STATUS setxdcntrl( WF_PULSE *pulse_ptr, INT state, INT rcvr);
FLOAT get_act_freq_fov( void );
FLOAT get_act_phase_fov( void );
void epic_error( const int ermes, const char *plain_fmt, const int ermes_num,
                 const int num_args, ... );
int log_error(const char* pathname, const char* filename, const int headerinfo,
              const char* format, ...);
typedef enum DABOUTHUBINDEX
{
    DABOUTHUBINDEX_NOSWITCH = 0,
    DABOUTHUBINDEX_PRIMARY,
    DABOUTHUBINDEX_SECONDARY
} DABOUTHUBINDEX_E;
typedef enum DATA_FRAME_DESTINATION
{
    ROUTE_TO_RECON = 0,
    ROUTE_TO_RTP
} DATA_FRAME_DESTINATION_E;
STATUS
attenlockon( WF_PULSE_ADDR pulse );
STATUS
attenlockoff( WF_PULSE_ADDR pulse );
STATUS
BoreOverTemp( INT monitor_temp,
              INT debug );
STATUS
buildinstr( void );
STATUS
calcdelay( FLOAT *delay_val,
           INT control,
           DOUBLE gldelayx,
           DOUBLE gldelayy,
           DOUBLE gldelayz,
           INT *defaultdelay,
           INT nslices,
           INT gradmode,
           INT debug,
           long(*rsprot)[9] );
STATUS
calcdelayfile( FLOAT *delay_val,
               INT control,
               DOUBLE gldelayx,
               DOUBLE gldelayy,
               DOUBLE gldelayz,
               INT *defaultdelay,
               INT nslices,
               INT debug,
               long(*rsprot)[9],
               FLOAT *buffer );
LONG
calciphase( DOUBLE phase );
STATUS
copyframe( WF_PULSE_ADDR pulse,
           LONG frame_control,
           LONG pass_src,
           LONG slice_src,
           LONG echo_src,
           LONG view_src,
           LONG pass_des,
           LONG slice_des,
           LONG echo_des,
           LONG view_des,
           LONG nframes,
           TYPDAB_PACKETS acqon_flag );
STATUS
create3dim( WF_PULSE_ADDR pulse,
            LONG pos_readout,
            LONG pos_ref );
STATUS
create3dim2( WF_PULSE_ADDR pulse,
             LONG pos_readout,
             LONG pos_ref );
STATUS
rfon( WF_PULSE_ADDR pulse,
      LONG index );
STATUS
rfoff( WF_PULSE_ADDR pulse,
       LONG index );
STATUS
scopeoff( WF_PULSE_ADDR pulse );
STATUS
scopeon( WF_PULSE_ADDR pulse );
STATUS
setPSDtags( WF_PULSE_ADDR pulse,
            WF_PGMREUSE reuse,
            WF_PGMTAG tag,
            LONG addtag,
            INT id,
            INT board_type,
            STATUS force );
STATUS
getctrl( long *ctrl,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
getiwave( long *waveform_ix,
          WF_PULSE_ADDR pulse,
          LONG index );
STATUS
getiphase( INT *phase,
           WF_PULSE_ADDR pulse,
           LONG index );
STATUS
getphase( FLOAT *phase,
          WF_PULSE_ADDR pulse,
          LONG index );
STATUS
getieos( SHORT *eos,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
getpulse( WF_PULSE_ADDR *ret_pulse,
          WF_PULSE_ADDR pulse,
          WF_PGMTAG tagfield,
          INT id,
          LONG index );
STATUS
getssppulse( WF_PULSE_ADDR *ssppulse,
             WF_PULSE_ADDR pulse,
             const CHAR *pulsesuff,
             LONG index );
STATUS
getssppulse_modal( WF_PULSE_ADDR *ssppulse,
                   WF_PULSE_ADDR pulse,
                   const CHAR *pulsesuff,
                   LONG index,
                   LONG exit_mode );
STATUS
getiamp( SHORT *amplitude,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
getperiod( long *period,
           WF_PULSE_ADDR pulse,
           LONG index );
STATUS
getwamp( SHORT *amplitude,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
getweos( SHORT *eos,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
getwave( LONG *waveform_ix,
         WF_PULSE_ADDR pulse );
void
init_wf_queue(void);
STATUS
initfastrec( WF_PULSE_ADDR pulse,
             LONG pos_ref,
             LONG xres,
             LONG tsptics,
             LONG deltics,
             LONG lpf );
int
isRFEnvelopeWaveformGenerator( const WF_PROCESSOR waveform_gen_rf );
int
isRFWaveformGenerator( const WF_PROCESSOR waveform_gen_rf );
STATUS
movewave( SHORT *pulse_mem,
          WF_PULSE_ADDR pulse,
          LONG index,
          INT resolution,
          HW_DIRECTION direction );
void
requestTransceiver( int bd_type,
                    exciterSelection e,
                    receiverSelection r );
void
requestTransceiverDemod( int bd_type,
                         exciterSelection e,
                         receiverSelection r,
                         demodSelection o,
                         navSelection n );
void
RFEnvelopeWaveformGeneratorCheck( const CHAR *pulse_name,
                                  const WF_PROCESSOR waveform_gen );
void
RFWaveformGeneratorCheck( const CHAR *pulse_name,
                          const WF_PROCESSOR waveform_gen );
STATUS
setattenlock( STATUS restore_flag,
              WF_PULSE_ADDR pulse );
STATUS
setctrl( LONG ctrl_mask,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
setfastdly( WF_PULSE_ADDR pulse,
            LONG deltics );
STATUS
setfreqphase( LONG frequency,
              LONG phase,
              WF_PULSE_ADDR pulse );
STATUS
setfrequency( LONG frequency,
              WF_PULSE_ADDR pulse,
              LONG index );
STATUS
setfreqarray( INT* frequency,
              WF_PULSE_ADDR pulse,
              LONG arraySize );
STATUS
setmrtouchdriver( const float freq,
                  const int cycles,
                  const int amp );
void
SetHWMem( void );
STATUS
setiamp( INT amplitude,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
setiampssp( LONG amplitude,
            WF_PULSE_ADDR pulse,
            LONG index );
STATUS
setiampall( INT amplitude,
            WF_PULSE_ADDR pulse,
            LONG index );
STATUS
setiamparray(SHORT* amplitude,
             WF_PULSE_ADDR pulse,
             LONG arraySize);
STATUS
setiampimm( INT amplitude,
            WF_PULSE_ADDR pulse,
            LONG index );
STATUS
setiamptimm( INT amplitude,
             WF_PULSE_ADDR pulse,
             LONG index );
STATUS
setiphase( LONG phase,
           WF_PULSE_ADDR pulse,
           LONG index );
STATUS
setphase( DOUBLE phase,
          WF_PULSE_ADDR pulse,
          LONG index );
STATUS
setphasearray( INT* phase,
               WF_PULSE_ADDR pulse,
               LONG arraySize );
STATUS
setiampt( INT amplitude,
          WF_PULSE_ADDR pulse,
          LONG index );
STATUS
setieos( INT eos_flag,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
setperiod( LONG period,
           WF_PULSE_ADDR pulse,
           LONG index );
STATUS
setrf( STATUS restore_flag,
       WF_PULSE_ADDR pulse,
       LONG index );
STATUS
setrfltrs( LONG filter_no,
           WF_PULSE_ADDR pulse );
STATUS
setEpifilter( LONG filter_no,
              WF_PULSE_ADDR pulse );
STATUS
settransceiver( INT board );
STATUS
setwampimm( INT amplitude,
            WF_PULSE_ADDR pulse,
            LONG index );
STATUS
setwamp( INT amplitude,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
setwave( WF_HW_WAVEFORM_PTR waveform_ix,
         WF_PULSE_ADDR pulse,
         LONG index );
void
simulationInit( long *rot_ptr );
STATUS
setweos( INT eos_flag,
         WF_PULSE_ADDR pulse,
         LONG index );
STATUS
sspextload( LONG *loc_addr,
            WF_PULSE_ADDR pulse,
            LONG index,
            INT resolution,
            HW_DIRECTION direction,
            SSP_S_ATTRIB s_attr );
STATUS
sspinit( INT psd_board_type );
STATUS
sspload( SHORT *loc_addr,
         WF_PULSE_ADDR pulse,
         LONG index,
         INT resolution,
         HW_DIRECTION direction,
         SSP_S_ATTRIB s_attr );
STATUS
syncon( WF_PULSE_ADDR pulse );
STATUS
syncoff( WF_PULSE_ADDR pulse );
STATUS
movewaversp( void );
STATUS
stretchpulse( INT oldres,
              INT newres,
              SHORT *opulse,
              SHORT *newpulse );
STATUS
AddToInstrQueue( WF_INSTR_QUEUE *queue,
                 WF_INSTR_HDR *instr_ptr );
ADDRESS
AllocNode( LONG size );
STATUS
FreeNode( ADDRESS address );
STATUS
FreePSDHeap( void );
ADDRESS
TempAllocNode( LONG size );
STATUS
BridgeTrap( WF_PULSE_ADDR *pulses,
            LONG n_pulses,
            STATUS bridge_first,
            WF_INSTR_QUEUE *queue );
STATUS
BuildBridgesIn( WF_INSTR_QUEUE *queue );
STATUS
CreatePulse( WF_PULSE_ADDR pulse,
             SeqData seqdata,
             WF_PROCESSOR waveform_gen,
             WF_PULSE_TYPES waveform_type,
             INT resol,
             WF_PULSE_EXT *extension,
             WF_HW_WAVEFORM_PTR wave_addr );
STATUS
FreePsdsQ( void );
STATUS
AddToPsdQ( WF_PULSE_ADDR pulse );
LONG
GetMinPeriod( WF_PROCESSOR waveform_gen,
              LONG pulse_width,
              const INT sworhw_flag );
INT
SetResol( LONG pulse_width,
          LONG min_period );
STATUS
TimeHist( const CHAR *ipgname );
STATUS
acqctrl( TYPDAB_PACKETS acqon_flag,
         INT recvr,
         WF_PULSE_ADDR pulse );
void
MsgHndlr( const CHAR *routine,
          ... );
STATUS
acqq( WF_PULSE_ADDR pulse,
      LONG pos_ref,
      LONG dab_ref,
      LONG xtr_ref,
      LONG fslot_value,
      TYPDAB_PACKETS cine_flag );
STATUS
propAcqq( WF_PULSE_ADDR pulse,
      LONG pos_ref,
      LONG dab_ref,
      LONG xtr_ref,
      LONG fslot_value);
STATUS
acqq2( WF_PULSE_ADDR dabpulse,
       WF_PULSE_ADDR rcvpulse,
       LONG pos_ref,
       LONG fslot_value,
       LONG dabstart,
       TYPDAB_PACKETS cine_flag,
       TYPACQ_PASS passthrough_flag );
STATUS
addrfbits( WF_PULSE_ADDR pulse,
           LONG offset,
           LONG refstart,
           LONG refduration );
STATUS
fastAddrfbits( WF_PULSE_ADDR pulse,
               LONG offset,
               LONG refstart,
               LONG refduration,
               LONG init_ublnk_time );
STATUS
setrfcontrol( SHORT selectamp,
              int mod_number,
              WF_PULSE_ADDR pulse,
              LONG index );
STATUS
attenflagon( WF_PULSE_ADDR pulse,
             LONG index );
STATUS
attenflagoff( WF_PULSE_ADDR pulse,
              LONG index );
STATUS
createatten( WF_PULSE_ADDR pulse,
             LONG start );
STATUS
createbits( WF_PULSE_ADDR pulse,
            WF_PROCESSOR waveform_gen,
            INT resol,
            SHORT *bits_array );
STATUS
createcine( WF_PULSE *pulse,
            const CHAR *name );
STATUS
createconst( WF_PULSE_ADDR pulse,
             WF_PROCESSOR waveform_gen,
             LONG pulse_width,
             INT amplitude );
STATUS
createextwave( WF_PULSE_ADDR pulse,
               WF_PROCESSOR waveform_gen,
               INT resol,
               CHAR *ext_wave_pathname );
void
destroyExtWave( void );
void
printExtWave( void );
STATUS
createhadamard( WF_PULSE_ADDR pulse,
                WF_PROCESSOR waveform_gen,
                INT resol,
                INT amplitude,
                DOUBLE sep,
                DOUBLE ncycles,
                DOUBLE alpha );
void
CleanUp( void );
STATUS
creatediffdab( WF_PULSE_ADDR pulse,
             LONG pos_ref );
STATUS
createhsdab( WF_PULSE_ADDR pulse,
             LONG pos_ref );
STATUS
createhscdab( WF_PULSE_ADDR pulse,
              LONG pos_ref,
              TYPDAB_PACKETS cine_flag );
STATUS
createinstr( WF_PULSE_ADDR pulse,
             LONG start,
             LONG pulse_width,
             LONG ampl );
STATUS
createpass( WF_PULSE_ADDR pulse,
            LONG start );
STATUS
createramp( WF_PULSE_ADDR pulse,
            WF_PROCESSOR waveform_gen,
            LONG pulse_width,
            INT start_amp,
            INT end_amp,
            INT resol,
            DOUBLE ramp_beta );
STATUS
createreserve( WF_PULSE_ADDR pulse,
               WF_PROCESSOR waveform_gen,
               INT resol );
STATUS
createsinc( WF_PULSE_ADDR pulse,
            WF_PROCESSOR waveform_gen,
            INT resol,
            INT amplitude,
            DOUBLE ncycles,
            DOUBLE alpha );
STATUS
createsinusoid( WF_PULSE_ADDR pulse,
                WF_PROCESSOR waveform_gen,
                INT resol,
                INT amplitude,
                DOUBLE start_phase,
                DOUBLE phase_length,
                INT offset );
STATUS
createseq( WF_PULSE_ADDR ssp_pulse,
           LONG length,
           long int *entry_array );
STATUS
createtraps( WF_PROCESSOR wgname,
             WF_PULSE *traparray,
             WF_PULSE *traparraya,
             WF_PULSE *traparrayd,
             INT ia_start,
             INT ia_end,
             DOUBLE a_base,
             DOUBLE a_delta,
             INT nsteps,
             INT pw_plateau,
             INT pw_attack,
             INT pw_decay,
             INT slope_direction,
             DOUBLE target_amp,
             DOUBLE beta );
STATUS
addubr( WF_PULSE_ADDR pulse,
        LONG pos_ref );
STATUS
createubr( WF_PULSE_ADDR pulse,
           LONG pos_ref,
           const INT index );
STATUS
dabrecorder( int record_mask );
STATUS
epiacqq( WF_PULSE_ADDR pulse,
         LONG pos_ref,
         LONG dab_ref,
         LONG xtr_ref,
         LONG fslot_value,
         TYPDAB_PACKETS cine_flag,
         LONG receiver_type,
         LONG dab_on );
STATUS
loaddab( WF_PULSE_ADDR pulse,
         LONG slice,
         LONG echo,
         LONG oper,
         LONG view,
         TYPDAB_PACKETS acqon_flag,
         LONG ctrlmask );
STATUS
loaddab_hub_r1( WF_PULSE_ADDR pulse,
                LONG slice,
                LONG echo,
                LONG oper,
                LONG view,
                LONG hubIndex,
                LONG r1Index,
                TYPDAB_PACKETS acqon_flag,
                LONG ctrlmask );
STATUS
loadpropdab( WF_PULSE_ADDR pulse,
         LONG oper,
         LONG frameType,
         LONG instanceIndex,
         LONG sliceIndex,
         LONG echotrainIndex,
         LONG bladeIndex,
         LONG bladeViewIndex,
         INT bladeAngle,
         LONG bValIndex,
         LONG diffDirIndex,
         LONG volIndex,
         TYPDAB_PACKETS acqon_flag,
         LONG ctrlmask );
STATUS
loaddabwithnex( WF_PULSE_ADDR pulse,
                LONG nex,
                LONG slice,
                LONG echo,
                LONG oper,
                LONG view,
                TYPDAB_PACKETS acqon_flag,
                LONG ctrlmask );
STATUS
loaddabwithangle( WF_PULSE_ADDR pulse,
                INT angle,
                LONG slice,
                LONG echo,
                LONG oper,
                LONG view,
                TYPDAB_PACKETS acqon_flag,
                LONG ctrlmask );
STATUS
loaddab2( WF_PULSE_ADDR pulse,
          WF_PULSE_ADDR rbapulse,
          LONG slice,
          LONG echo,
          LONG oper,
          LONG view,
          TYPDAB_PACKETS acqon_flag );
STATUS
load3d( WF_PULSE_ADDR pulse,
        LONG view,
        TYPDAB_PACKETS acqon_flag );
STATUS
loaddabecho( WF_PULSE_ADDR pulse,
             LONG echo );
STATUS
loaddaboper( WF_PULSE_ADDR pulse,
             LONG oper );
STATUS
loaddabset( WF_PULSE_ADDR pulse,
            TYPDAB_PACKETS dab_acq,
            TYPDAB_PACKETS rba_acq );
STATUS
loaddabslice( WF_PULSE_ADDR pulse,
              LONG slice );
STATUS
loaddabview( WF_PULSE_ADDR pulse,
             LONG view );
STATUS
load3decho( WF_PULSE_ADDR pulse,
            LONG view,
            LONG echo,
            TYPDAB_PACKETS acqon_flag );
STATUS
loadcine( WF_PULSE_ADDR pulse,
          INT arr,
          INT op,
          LONG pview,
          INT frame1,
          INT frame2,
          INT frame3,
          INT frame4,
          LONG delay,
          LONG fslice,
          TYPDAB_PACKETS acqon_flag );
STATUS
loaddiffdab( WF_PULSE_ADDR pulse,
           LONG ecno,
           LONG dab_op,
           LONG frame,
           LONG instance,
           LONG slnum,
           LONG vstart,
           LONG vskip,
           LONG numv,
           LONG bindex,
           LONG dirindex,
           LONG vol,
           LONG gradpol,
           TYPDAB_PACKETS acqon_flag,
           LONG ctrlmask );
STATUS
loadhsdab( WF_PULSE_ADDR pulse,
           LONG slnum,
           LONG ecno,
           LONG dab_op,
           LONG vstart,
           LONG vskip,
           LONG vnum,
           LONG card_rpt,
           LONG k_read,
           TYPDAB_PACKETS acqon_flag,
           LONG ctrlmask );
STATUS
movestretchedwave( const char* fileloc,
                   const int old_res,
                   WF_PULSE_ADDR pulse,
                   const int pulse_index,
                   const int new_res );
STATUS
movewave( SHORT *pulse_mem,
          WF_PULSE_ADDR pulse,
          LONG index,
          INT resolution,
          HW_DIRECTION direction );
STATUS
movewaveimm( SHORT *pulse_mem,
             WF_PULSE_ADDR pulse,
             LONG index,
             INT resolution,
             HW_DIRECTION direction );
STATUS
linkpulses( INT l_arg,
            ... );
STATUS
pulsename( WF_PULSE_ADDR pulse,
           const CHAR *pulse_name );
LONG
pbeg( WF_PULSE_ADDR pulse,
      const CHAR *pulse_name,
      LONG index );
LONG
pbegall( WF_PULSE_ADDR pulse,
         LONG index );
LONG
pbegallssp( WF_PULSE_ADDR pulse,
            LONG index );
LONG
pend( WF_PULSE_ADDR pulse,
      const CHAR *pulse_name,
      LONG index );
LONG
pendall( WF_PULSE_ADDR pulse,
         LONG index );
LONG
pendallssp( WF_PULSE_ADDR pulse,
            LONG index );
WF_INSTR_HDR
*GetFreqInstrNode( WF_PULSE *this_pulse,
                   LONG index,
                   const CHAR *name );
void
init_pgen_times( void );
void
print_pgen_times( void );
void
start_timer( long *start_time );
void
end_timer( long start_time,
           INT function_index,
           const CHAR *name );
LONG
pmid( WF_PULSE_ADDR pulse,
      const CHAR *pulse_name,
      LONG index );
LONG
pmidall( WF_PULSE_ADDR pulse,
         LONG index );
void
psdexit( INT ermes_no,
         INT abcode,
         const CHAR *txt_str,
         const CHAR *routine,
         ... );
STATUS
routeDataFrameDab( WF_PULSE_ADDR dab_pulse,
                   const DATA_FRAME_DESTINATION_E destination,
                   const INT coilswitchmethod );
STATUS
routeDataFrameXtr( WF_PULSE_ADDR xtr_pulse,
                   const DATA_FRAME_DESTINATION_E destination,
                   const INT coilswitchmethod );
STATUS
setnullpulsename( WF_PULSE_ADDR pulse);
STATUS
trapezoid( WF_PROCESSOR wgname,
           const CHAR *name,
           WF_PULSE_ADDR pulseptr,
           WF_PULSE_ADDR pulseptra,
           WF_PULSE_ADDR pulseptrd,
           LONG pw_pulse,
           LONG pw_pulsea,
           LONG pw_pulsed,
           LONG ia_pulse,
           LONG ia_pulsewa,
           LONG ia_pulsewb,
           LONG ia_start,
           LONG ia_end,
           LONG position,
           LONG trp_parts,
           LOG_GRAD *loggrd );
WF_INSTR_HDR
*GetPulseInstrNode( WF_PULSE_ADDR pulse,
                    LONG position );
STATUS
psd_update_spu_hrate( LONG hrate );
STATUS
psd_update_spu_trigger_window( LONG trigger_window );
STATUS
setdaboutcoilswitchhubindex( WF_PULSE_ADDR dab_pulse,
                             const DABOUTHUBINDEX_E index,
                             const INT coilswitchmethod );
int
get_disable_exciter_unblank( void );
STATUS
setiampiter( INT * amplitude,
          INT num_iters,
          WF_PULSE_ADDR pulse,
          LONG index,
          INT sign_flag);
STATUS
setiamptiter( INT * amplitude,
          INT num_iters,
          WF_PULSE_ADDR pulse,
          LONG index,
          INT sign_flag);
STATUS
settxattenabs( WF_PULSE_ADDR pulse,
               int wavegen_type,
               int txAttenI,
               int txAttenQ,
               float phaseQoffset );
STATUS
settxattendelta( WF_PULSE_ADDR pulse,
                 int wavegen_type,
                 int deltaTxAttenI,
                 int deltaTxAttenQ,
                 float deltaPhaseQoffset );
STATUS
initSeqCfg(void);
STATUS
setupSeqCfg(int rfgroup,
            int numapptxchannels,
            int rxflag,
            int rxtheta,
            int rxomega);
STATUS
getNumSeqIDs(int * numIDs);
STATUS
sortOutSeqs(int rfgroup);
STATUS
setPgenSeqFlag(int seqtype,
          int seqid,
          int * pgenflag);
STATUS
setTxSeqFlag(int seqtype,
        int * txflag);
STATUS
setSeqLegacyName(int seqtype,
                  int * legacyname);
int
getTxRxType(int seqname,
            int rxflag);
STATUS
getSeqID(int * seqid,
         int rfgroup,
         int seqname,
         int txchannel,
         int rxflag);
const SeqCfgSeqInfo *
getSeqInfo(int seqID);
void *
getSeqCfgData(void);
int
getNumAppTxChannels(int rfgroup);
STATUS
mapWavegen2SeqName(int * seqname,
                   WF_PROCESSOR waveform_gen);
STATUS
getWaveSeqOpt(int * seqopt,
              int rfgroup,
              int seqname,
              int ptxflag,
              int rxflag,
              int opmode);
STATUS
getWaveSeqDataWavegen(SeqData * seqdata,
                      WF_PROCESSOR wgen,
                      int rfgroup,
                      int ptxflag,
                      int rxflag, int opmode);
STATUS
getWaveSeqDataPulse(SeqData * seqdata,
                    WF_PULSE_ADDR pulse, int opmode);
STATUS
getWaveSeqDataPulsePtx(SeqData * seqdata,
                       WF_PULSE_ADDR pulse, int channel_index);
STATUS
getInstrSeqOpt(int * seqopt,
               int seqid,
               int opmode);
STATUS
getInstrSeqDataSeqID(SeqData * seqdata,
                     int seqid,
                     int opmode);
STATUS
getInstrSeqDataPulse(SeqData * seqdata,
                     WF_PULSE_ADDR pulse,
                     int opmode);
STATUS
getInstrSeqDataPulsePtx(SeqData * seqdata,
                        WF_PULSE_ADDR pulse,
                        int channel_index);
STATUS
setrxflag(WF_PULSE_ADDR pulse,
          int rxflag);
STATUS
setptxflag(WF_PULSE_ADDR pulse,
           int ptxflag);
STATUS
setrfgroup(WF_PULSE_ADDR pulse,
           int rfgroup);
STATUS
setiphasePtx(LONG phase,
             WF_PULSE_ADDR pulse,
             LONG index,
             INT channel_index);
STATUS
setiphasePtxall(LONG * phase,
                INT arraysize,
                WF_PULSE_ADDR pulse,
                LONG index);
STATUS
setiphasePtxallplus(LONG phase0,
                    LONG * phase,
                    INT arraysize,
                    WF_PULSE_ADDR pulse,
                    LONG index);
STATUS
setphasePtx(DOUBLE phase,
            WF_PULSE_ADDR pulse,
            LONG index,
            INT channel_index);
STATUS
setphasePtxall(DOUBLE * phase,
               INT arraysize,
               WF_PULSE_ADDR pulse,
               LONG index);
STATUS
setphasePtxallplus(DOUBLE phase0,
                   DOUBLE * phase,
                   INT arraysize,
                   WF_PULSE_ADDR pulse,
                   LONG index);
STATUS
setiampPtx(INT amplitude,
           WF_PULSE_ADDR pulse,
           LONG index,
           INT channel_index);
STATUS
setiampPtxall(INT * amplitude,
              INT arrarsize,
              WF_PULSE_ADDR pulse,
              LONG index);
STATUS
setiampPtxallsign(INT * amplitude,
                  INT sign_flag,
                  INT arrarsize,
                  WF_PULSE_ADDR pulse,
                  LONG index);
STATUS
movewaveimmPtx(SHORT *pulse_mem,
               WF_PULSE_ADDR pulse,
               LONG index,
               INT resolution,
               HW_DIRECTION direction,
               INT channel_index);
STATUS
movewaveimmPtxall(SHORT **pulse_mem,
                  INT arraysize,
                  WF_PULSE_ADDR pulse,
                  LONG index,
                  INT resolution,
                  HW_DIRECTION direction);
STATUS
sspextloadPtx(LONG *loc_addr1,
              WF_PULSE_ADDR pulse,
              LONG index, INT resolution,
              HW_DIRECTION direction,
              SSP_S_ATTRIB s_attr,
              INT channel_index);
STATUS
movewavememimm(WF_PULSE_ADDR pulse,
             WF_PROCESSOR waveform_gen,
             SHORT * pulse_mem,
             WF_HW_WAVEFORM_PTR moveto_mem,
             INT resolution,
             HW_DIRECTION direction );
INT
createwreserve( WF_PULSE_ADDR pulse,
               WF_PROCESSOR waveform_gen,
               INT resol );
INT
createwramp( WF_PULSE_ADDR pulse,
            WF_PROCESSOR waveform_gen,
            INT resol,
            INT start_amp,
            INT end_amp,
            DOUBLE ramp_beta );
int
getAppTxChannels( void );
int
getNumSeqs(void);
int
isPgenSeq(int seqid);
int
isTxSeq(int seqid);
int
getSeqLegacyName(int seqid);
int
getNumSecSsps(void);
int
getSecSspId(int seqid);
int epic_loadcvs( const char *file );
void InitAdvPnlCVs(void);
enum IMGOPT {
  IMGOPT_NONE = 0,
  IMGOPT_ASSET,
  IMGOPT_BLURCANCEL,
  IMGOPT_BSP,
  IMGOPT_CALIB,
  IMGOPT_CCOMP,
  IMGOPT_CLASSIC,
  IMGOPT_DEPREP,
  IMGOPT_DIFF,
  IMGOPT_EPI,
  IMGOPT_ET,
  IMGOPT_EXTDYRANGE,
  IMGOPT_FAST,
  IMGOPT_FLOWCOMP,
  IMGOPT_FLUORO,
  IMGOPT_FMRI,
  IMGOPT_FR,
  IMGOPT_FULLTRAIN,
  IMGOPT_FW_FAT,
  IMGOPT_FW_WATER,
  IMGOPT_GATING,
  IMGOPT_IRPREP,
  IMGOPT_MAGXFR,
  IMGOPT_MPH,
  IMGOPT_MSTATION,
  IMGOPT_NAVIGATOR,
  IMGOPT_NOPHASEWRAP,
  IMGOPT_PHSEN,
  IMGOPT_POMP,
  IMGOPT_REALTIME,
  IMGOPT_RESPCOMP,
  IMGOPT_RESPTRIG,
  IMGOPT_RT_BLURCANCEL,
  IMGOPT_SEQUENTL,
  IMGOPT_SMTPREP,
  IMGOPT_SPIRAL,
  IMGOPT_SQPIX,
  IMGOPT_SS,
  IMGOPT_SSRF,
  IMGOPT_T2PREP,
  IMGOPT_TRF,
  IMGOPT_VARBW,
  IMGOPT_ZIP1024,
  IMGOPT_ZIP2,
  IMGOPT_ZIP4,
  IMGOPT_ZIP512,
  IMGOPT_VERSE,
  IMGOPT_MART,
  IMGOPT_ADVANCED_NEX,
  IMGOPT_DYNPL,
  IMGOPT_ART,
  IMGOPT_IDEAL,
  IMGOPT_MRCP,
  IMGOPT_ARC,
  IMGOPT_PROMO,
  IMGOPT_ASLPREP,
  IMGOPT_MRF,
  IMGOPT_MSDE,
  IMGOPT_MULTIBAND,
  IMGOPT_FLEX,
  IMGOPT_CS,
  IMGOPT_T1FLAIR,
  IMGOPT_T2FLAIR,
  IMGOPT_SRPREP,
  IMGOPT_DWDUO,
  MAX_IMGOPT_VAL
};
typedef enum psd_iopt_nums {
    PSD_IOPT_CARD_GATE,
    PSD_IOPT_RESP_COMP,
    PSD_IOPT_FLOW_COMP,
    PSD_IOPT_CLASSIC,
    PSD_IOPT_EDR,
    PSD_IOPT_SEQUENTIAL,
    PSD_IOPT_MPH,
    PSD_IOPT_SQR_PIX,
    PSD_IOPT_MAG_TRANS,
    PSD_IOPT_TLRD_RF,
    PSD_IOPT_RESP_TRIG,
    PSD_IOPT_FULL_TRAIN,
    PSD_IOPT_ZIP_1024,
    PSD_IOPT_CARD_MON,
    PSD_IOPT_ZIP_512,
    PSD_IOPT_SLZIP_X2,
    PSD_IOPT_SLZIP_X4,
    PSD_IOPT_SMART_PREP,
    PSD_IOPT_FMRI,
    PSD_IOPT_REAL_TIME,
    PSD_IOPT_MULTI_STATION,
    PSD_IOPT_BLOOD_SUP,
    PSD_IOPT_T2_PREP,
    PSD_IOPT_SSRF,
    PSD_IOPT_RT_BC,
    PSD_IOPT_NAV,
    PSD_IOPT_FLUORO,
    PSD_IOPT_PHASE_SENSE,
    PSD_IOPT_ASSET,
    PSD_IOPT_DE_PREP,
    PSD_IOPT_IR_PREP,
    PSD_IOPT_SR_PREP,
    PSD_IOPT_VERSE,
    PSD_IOPT_MART,
    PSD_IOPT_DYNPL,
    PSD_IOPT_MILDNOTE,
    PSD_IOPT_IDEAL,
    PSD_IOPT_MRCP,
    PSD_IOPT_ARC,
    PSD_IOPT_PROMO,
    PSD_IOPT_ASL_PREP,
    PSD_IOPT_MRF,
    PSD_IOPT_MULTIBAND,
    PSD_IOPT_CS,
    PSD_IOPT_FLEX,
    PSD_IOPT_MSDE,
    PSD_IOPT_FR,
    PSD_IOPT_T1FLAIR,
    PSD_IOPT_T2FLAIR,
    PSD_IOPT_DWDUO,
    PSD_NUM_IOPTS
} psd_iopt_e;
typedef struct psdiopt_s {
    int iopt_num;
    char iopt_name[8192];
    char *slot;
    int key;
    int max_on_state;
    int max_off_state;
    int def_on_state;
    int def_off_state;
} psdiopt_t;
STATUS
psd_init_iopt_activity( void );
int
ioptlist_cvnum( void );
STATUS
activate_ioption( const int iopt );
STATUS
activate_iopt_list( const int numopts,
                    const int *ioptarr );
STATUS
display_all_iopts( void );
STATUS
deactivate_ioption( const int iopt );
STATUS
deactivate_iopt_list( const int numopts,
                      const int *ioptarr );
STATUS
deactivate_all_iopts( void );
STATUS
enable_ioption( const int iopt );
STATUS
enable_iopt_list( const int numopts,
                  const int *ioptarr );
STATUS
disable_ioption( const int iopt );
STATUS
disable_iopt_list( const int numopts,
                   const int *ioptarr );
void
set_base_iopt_compatibilities( void );
STATUS
set_compatibility( const int iopt1,
                   const int iopt2,
                   const short compatibility );
STATUS
set_compatible( const int iopt1,
                const int iopt2 );
STATUS
set_incompatible( const int iopt1,
                  const int iopt2 );
STATUS
set_list_compatible( const int iopt1,
                     const int *ioptarr,
                     const int numopts );
STATUS
set_list_incompatible( const int iopt1,
                       const int *ioptarr,
                       const int numopts );
STATUS
set_forcing( const int iopt1,
             const int iopt2 );
STATUS
set_required_disabled_option( const int iopt1 );
STATUS
set_disallowed_option( const int iopt1 );
int
return_iopt_activity( const int iopt );
int
return_iopt_compatibility( const int iopt1,
                           const int iopt2 );
int
iopt_key( const int the_iopt );
int
valid_iopt_key( const int the_key );
STATUS
set_iopt_key( const int the_iopt,
              const int the_key );
STATUS
iopt_cvcheck( void );
int
is_iopt_selected( const int the_iopt );
int
return_iopt_cv_num( const int the_iopt );
int
return_iopt_cv_on_val( const int the_iopt );
int
return_iopt_cv_off_val( const int the_iopt );
STATUS
return_iopt_cv_name( const int the_iopt,
                     char *iopt_cv );
void
return_iopt_name(int iopt_num,char *iopt_name);
int
find_iopt_by_cv_name( char *iopt_cv );
    extern s32 sokNA( n32 sok );
    extern s32 op_keyNA( char* key_name );
    extern s32 checkOptionKey( n32 sok );
    extern s32 checkOptionKeyEngine( n32 sok, s32* warnings );
    extern s32 checkKey( char* key_name );
    extern s32 get_key_status( char* key_name, s32* license_type, n32* expiry_date );
    extern s32 get_product_option_key_status();
    extern s32 get_product_option_key_mismatch();
    extern int get_num_channels( int *const channelCount);
STATUS PScvinit(void);
STATUS PS1cvinit(void);
STATUS CFLcvinit(void);
STATUS CFHcvinit(void);
STATUS FTGcvinit(void);
STATUS XTGcvinit(void);
STATUS RGcvinit(void);
STATUS AScvinit(void);
STATUS RCVNcvinit(void);
STATUS DTGcvinit(void);
STATUS RScvinit(void);
STATUS ExtCalcvinit(void);
STATUS AutoCoilcvinit(void);
STATUS PScveval(void);
STATUS PScveval1(int local_ps_te);
STATUS PS1cveval(FLOAT *opthickPS);
STATUS CFLcveval(FLOAT opthickPS);
STATUS CFHfilter(int xres);
STATUS CFHcveval(FLOAT opthickPS);
STATUS FTGcveval(void);
STATUS XTGcveval(void);
STATUS RGcveval(void);
STATUS AScveval(void);
STATUS RCVNcveval(void);
STATUS DTGcveval(void);
STATUS RScveval(void);
STATUS ExtCalcveval(void);
STATUS AutoCoilcveval(void);
STATUS PSfilter(void);
STATUS PSpredownload(void);
STATUS PS1predownload(void);
STATUS CFLpredownload(void);
STATUS CFHpredownload(void);
STATUS FTGpredownload(void);
STATUS XTGpredownload(void);
STATUS ASpredownload(void);
STATUS DTGpredownload(void);
STATUS RSpredownload(void);
STATUS ExtCalpredownload(void);
STATUS AutoCoilpredownload(void);
STATUS RCVNpredownload(void);
STATUS
generateZyIndex(ZY_INDEX * zy_index,
                const int zy_views,
                const int zy_slices,
                const float yFov,
                const float zFov,
                const int psc_pfkr_flag,
                const float psc_pfkr_fraction,
                int *zy_sampledPoints);
int psc_dist_compare(const void *dist1, const void *dist2);
STATUS mps1(void);
STATUS aps1(void);
STATUS cfl(void);
STATUS cfh(void);
STATUS fasttg(void);
STATUS expresstg(void);
STATUS RFshim(void);
STATUS DynTG(void);
STATUS mapTg(void);
STATUS Autocoil(void);
STATUS extcal(void);
STATUS autoshim(void);
STATUS rcvn(void);
STATUS avg(void);
STATUS single1(void);
STATUS aws(void);
STATUS PSpulsegen(void);
STATUS PS1pulsegen(INT posstart);
STATUS CFLpulsegen(INT posstart);
STATUS CFHpulsegen(INT posstart);
STATUS FTGpulsegen(void);
STATUS XTGpulsegen(void);
STATUS ASpulsegen(void);
STATUS RCVNpulsegen(INT posstart);
STATUS DTGpulsegen(void);
STATUS ExtCalpulsegen(void);
STATUS AutoCoilpulsegen(void);
STATUS SliceAcqOrder(int *sl_acq_order, int rx_sls);
STATUS RSpulsegen(void);
STATUS PSmps1(INT mps1nex);
STATUS PScfl(void);
STATUS PScfh(void);
STATUS PSrcvn(void);
STATUS NoiseCalrcvn(void);
void StIRMod(void);
STATUS PSinit(long (*PSrotmat)[9]);
STATUS PSfasttg(INT pre_slice, INT debugstate);
STATUS PSexpresstg(INT pre_slice, INT debugstate);
STATUS PSrfshim(void);
STATUS PSdyntg(void);
STATUS PSextcal(void);
STATUS PSautocoil(void);
STATUS FastTGCore( DOUBLE slice_loc, INT ftg_disdaqs, INT ftg_views,
                   INT ftg_nex, INT ftg_debug );
STATUS eXpressTGCore( DOUBLE slice_loc, INT xtg_disdaqs, INT xtg_views,
                   INT xtg_nex, INT xtg_debug );
INT ASautoshim(INT rspsct);
STATUS CoilSwitchSetCoil( const COIL_INFO coil,
                          const INT setRcvPortFlag);
int CoilSwitchGetTR(const int setRcvPortFlag);
int doTG(int psd_psc_control);
int doAS(int psd_psc_control);
STATUS phase_ordering(SHORT *view_tab, const INT phase_order, const INT yviews, const INT yetl);
void SDL_PrintFStrengthWarning( const int psdCode,
                                const int fieldStrength,
                                const char * const fileName,
                                const int lineNo );
void SDL_Print0_7Debug( const int psdCode,
                        const char *const fileName,
                        const int lineNo);
void SDL_Print3_0Debug( const int psdCode,
                        const char *const fileName,
                        const int lineNo);
void SDL_Print4_0Debug( const int psdCode,
                        const char *const fileName,
                        const int lineNo);
void SDL_FStrengthPanic( const int psdCode,
                         const int fieldStrength,
                         const char *const fileName,
                         const int lineNo);
STATUS SDL_CheckValidFieldStrength( const int psdCode,
                                    const int fieldStrength,
                                    const int use_ermes );
void SDL_SetLimTE( const int psdCode,
                   const int fStrength,
                   const int opautote,
                   int * const llimte1,
                   int * const llimte2,
                   int * const llimte3,
                   int * const ulimte1,
                   int * const ulimte2,
                   int * const ulimte3 );
void SDL_CalcRF1RF2Scale( const int psdCode,
                          const int fStrength,
                          const int coilType,
                          const float slThickness,
                          float * const gscale_rf1,
                          float * const gscale_rf2,
                          float * const gscale_rf1se1,
                          float * const gscale_rf1se2 );
void SDL_SetFOV( const int psdCode,
                 const int fStrength );
void SDL_SetSLTHICK( const int psdCode,
                     const int fStrength );
void SDL_SetCS( const int psdCode,
                const int fStrength );
    float SDL_GetChemicalShift( const int fStrength );
    STATUS SDL_RFDerating( double * const deRateB1,
                           const int fStrength,
                           const double weight,
                           const TX_COIL_INFO txCoil,
                           const GRADIENT_COIL_E gcoiltype );
    STATUS SDL_RFDerating_calc( double * const deRateB1,
                                const int fStrength,
                                const double weight,
                                const TX_COIL_INFO txCoil,
                                const GRADIENT_COIL_E gcoiltype,
                                const int prescan_entry,
                                double safety_factor );
    STATUS SDL_RFDerating_entry( double * const deRateB1,
                                 const int fStrength,
                                 const double weight,
                                 const TX_COIL_INFO txCoil,
                                 const GRADIENT_COIL_E gcoiltype,
                                 const int entry );
    STATUS SDL_RFDerating_entry_sat( double * const deRateB1,
                                     const int fStrength,
                                     const double weight,
                                     const TX_COIL_INFO txCoil,
                                     const GRADIENT_COIL_E gcoiltype,
                                     const int entry,
                                     const double safetyfactor );
    void SDL_InitSPSATRFPulseInfo( const int fStrength,
                                   const int rfSlot,
                                   int * const pw_rfse1,
                                   RF_PULSE_INFO rfPulseInfo[] );
int dynTG_sliceloc(float *dynTG_sliceloc, const int dynTG_nslices, const int imaging_nslices, const int debug_flag);
extern int abort_on_kserror;
typedef char KS_DESCRIPTION[128];
typedef float KS_WAVEFORM[10000];
typedef short KS_IWAVE[10000];
typedef double KS_MAT3x3[9];
typedef double KS_MAT4x4[16];
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
typedef struct _seqloc_s {
  int board;
  int pos;
  float ampscale;
} KS_SEQLOC;
typedef struct _wfinstance_s {
  int boardinstance;
  WF_PULSE *wf;
  KS_SEQLOC loc;
} KS_WFINSTANCE;
typedef struct _base_s {
  int ninst;
  int ngenerated;
  void *next;
  int size;
} KS_BASE;
typedef struct _wait_s {
  KS_BASE base;
  KS_DESCRIPTION description;
  int duration;
  KS_SEQLOC locs[500];
  WF_PULSE *wfpulse;
  KS_WFINSTANCE *wfi;
} KS_WAIT;
typedef struct _isirot_s {
  KS_WAIT waitfun;
  KS_WAIT waitrot;
  SCAN_INFO *scan_info;
  int isinumber;
  int duration;
  int counter;
  int numinstances;
} KS_ISIROT;
typedef struct _trap_s {
  KS_BASE base;
  KS_DESCRIPTION description;
  float amp;
  float area;
  int ramptime;
  int plateautime;
  int duration;
  int gradnum[3];
  KS_SEQLOC locs[500];
  WF_PULSE **wfpulse;
  KS_WFINSTANCE *wfi;
  float *rtscale;
} KS_TRAP;
typedef struct {
  KS_BASE base;
  KS_DESCRIPTION description;
  int res;
  int duration;
  KS_WAVEFORM waveform;
  int gradnum[3];
  int gradwave_units;
  KS_SEQLOC locs[500];
  WF_PULSE **wfpulse;
  KS_WFINSTANCE *wfi;
  float *rtscale;
} KS_WAVE;
typedef struct _acq_s {
  KS_BASE base;
  KS_DESCRIPTION description;
  int duration;
  float rbw;
  FILTER_INFO filt;
  int pos[500];
  WF_PULSE *echo;
} KS_READ;
typedef struct _rf_s {
  int role;
  float flip;
  float bw;
  float cf_offset;
  float amp;
  int start2iso;
  int iso2end;
  int iso2end_subpulse;
  KS_DESCRIPTION designinfo;
  RF_PULSE rfpulse;
  KS_WAVE rfwave;
  KS_WAVE omegawave;
  KS_WAVE thetawave;
} KS_RF;
typedef struct _gradrfctrl_s {
  KS_RF *rfptr[20];
  int numrf;
  KS_TRAP *trapptr[200];
  int numtrap;
  KS_WAVE *waveptr[200];
  int numwave;
  KS_READ* readptr[500];
  int numacq;
  int is_cleared_on_tgt;
} KS_GRADRFCTRL;
typedef struct _seq_handle_s {
  long *offset;
  int index;
  WF_PULSE *pulse;
} KS_SEQ_HANDLE;
typedef struct _seq_control_s {
  int min_duration;
  int nseqinstances;
  int ssi_time;
  int duration;
  int momentstart;
  int rfscalingdone;
  KS_DESCRIPTION description;
  KS_SEQ_HANDLE handle;
  KS_GRADRFCTRL gradrf;
} KS_SEQ_CONTROL;
typedef struct _seq_collection_s {
  int numseq;
  int mode;
  int evaltrdone;
  KS_SEQ_CONTROL *seqctrlptr[200];
} KS_SEQ_COLLECTION;
typedef struct _sar_s {
  double average;
  double coil;
  double peak;
  double b1rms;
} KS_SAR;
typedef struct _KS_SLICE_PLAN {
  int nslices;
  int npasses;
  int nslices_per_pass;
  DATA_ACQ_ORDER acq_order[1 * (2048)];
} KS_SLICE_PLAN;
typedef struct _sms_info_s {
  int mb_factor;
  float slice_gap;
  int pulse_type;
} KS_SMS_INFO;
typedef struct _selrf_s {
  KS_RF rf;
  float slthick;
  float crusherscale;
  KS_TRAP pregrad;
  KS_TRAP grad;
  KS_TRAP postgrad;
  KS_WAVE gradwave;
  KS_SMS_INFO sms_info;
} KS_SELRF;
typedef struct _readtrap_s {
  KS_READ acq;
  float fov;
  int res;
  int rampsampling;
  int nover;
  int acqdelay;
  float paddingarea;
  float freqoffHz;
  float area2center;
  int time2center;
  KS_TRAP grad;
  KS_TRAP omega;
} KS_READTRAP;
typedef struct _readwave_s {
  KS_WAVE grads[3];
  KS_WAVE omega;
  KS_WAVE theta;
  KS_READ acq;
  int delay[3];
  float amp[3];
  float freqoffHz;
  float fov;
  int res;
  int rampsampling;
  int nover;
} KS_READWAVE;
typedef struct _phase_s {
  KS_TRAP grad;
  float fov;
  int res;
  int nover;
  int R;
  int nacslines;
  float areaoffset;
  int numlinestoacq;
  int linetoacq[1025];
} KS_PHASER;
typedef struct _3dphaseencodingplan_coord_s {
  int ky;
  int kz;
} KS_PHASEENCODING_COORD;
typedef struct _3dphaseencodingplan_s {
  int num_shots;
  int etl;
  KS_DESCRIPTION description;
  KS_PHASEENCODING_COORD *entries;
  KS_PHASER *phaser;
  KS_PHASER *zphaser;
  int is_cleared_on_tgt;
} KS_PHASEENCODING_PLAN;
typedef struct _epi_s {
  KS_READTRAP read;
  KS_TRAP readphaser;
  KS_TRAP blip;
  KS_PHASER blipphaser;
  KS_PHASER zphaser;
  int etl;
  int read_spacing;
  int duration;
  int time2center;
  float blipoversize;
  float minbliparea;
} KS_EPI;
typedef struct _dixon_dualreadtrap_s {
  KS_READWAVE readwave;
  KS_DESCRIPTION description;
  int available_acq_time;
  int spare_time_pre;
  int spare_time_post;
  int allowed_overflow_post;
  float paddingarea;
  int min_nover;
  int shifts[2];
  int nover;
  float area2center;
  int time2center;
  int overflow_post;
  int acqdelay;
  float nsa;
  float efficiency;
  int rampsampling[4];
} KS_DIXON_DUALREADTRAP;
extern int ks_rhoboard;
extern LOG_GRAD loggrd;
extern PHYS_GRAD phygrd;
enum ks_enum_trapparts {G_ATTACK, G_PLATEAU, G_DECAY};
enum ks_enum_boarddef {KS_X, KS_Y, KS_Z, KS_RHO, KS_RHO2, KS_THETA, KS_OMEGA, KS_SSP, KS_FREQX_PHASEY, KS_FREQY_PHASEX, KS_FREQX_PHASEZ, KS_FREQZ_PHASEX, KS_FREQY_PHASEZ, KS_FREQZ_PHASEY, KS_XYZ, KS_ALL};
typedef enum {KS_EPI_POSBLIPS = 1, KS_EPI_NOBLIPS = 0, KS_EPI_NEGBLIPS = -1} ks_enum_epiblipsign;
enum ks_enum_diffusion {KS_EPI_DIFFUSION_OFF, KS_EPI_DIFFUSION_ON, KS_EPI_DIFFUSION_PRETEND_FOR_RECON};
enum ks_enum_imsize {KS_IMSIZE_NATIVE, KS_IMSIZE_POW2, KS_IMSIZE_MIN256};
enum ks_enum_datadestination {KS_DONT_SEND = -1, KS_SENDTOBAM = 0, KS_SENDTORTP = 1};
enum ks_enum_accelmenu {KS_ACCELMENU_FRACT, KS_ACCELMENU_INT};
enum ks_enum_rfrole {KS_RF_ROLE_NOTSET, KS_RF_ROLE_EXC, KS_RF_ROLE_REF, KS_RF_ROLE_CHEMSAT, KS_RF_ROLE_SPSAT, KS_RF_ROLE_INV};
enum ks_enum_sincwin {KS_RF_SINCWIN_OFF, KS_RF_SINCWIN_HAMMING, KS_RF_SINCWIN_HANNING, KS_RF_SINCWIN_BLACKMAN, KS_RF_SINCWIN_BARTLETT};
enum ks_enum_wavebuf {KS_WF_MAIN, KS_WF_BUF1, KS_WF_BUF2, KS_WF_SIZE};
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
void ks_init_read(KS_READ *read);
void ks_init_trap(KS_TRAP *trap);
void ks_init_wait(KS_WAIT *wait);
void ks_init_wave(KS_WAVE *wave);
void ks_init_rf(KS_RF *rf);
void ks_init_sms_info(KS_SMS_INFO *sms_info);
void ks_init_selrf(KS_SELRF *selrf);
void ks_init_readtrap(KS_READTRAP *readtrap);
void ks_init_phaser(KS_PHASER *phaser);
void ks_init_epi(KS_EPI *epi);
void ks_init_dixon_dualreadtrap(KS_DIXON_DUALREADTRAP* dual_readtrap);
void ks_init_gradrfctrl(KS_GRADRFCTRL *gradrfctrl);
void ks_init_seqcontrol(KS_SEQ_CONTROL *seqcontrol);
void ks_init_seqcollection(KS_SEQ_COLLECTION *seqcollection);
STATUS ks_init_slewratecontrol(LOG_GRAD *loggrd, PHYS_GRAD *phygrd, float srfact) ;
STATUS ks_eval_addtoseqcollection(KS_SEQ_COLLECTION *seqcollection, KS_SEQ_CONTROL *seqctrl) ;
STATUS ks_eval_addtraptogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_TRAP *trap) ;
STATUS ks_eval_addwavetogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_WAVE *wave) ;
STATUS ks_eval_addrftogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_RF *rf) ;
STATUS ks_eval_addreadtogradrfctrl(KS_GRADRFCTRL *gradrfctrl, KS_READ *read) ;
STATUS ks_eval_wait(KS_WAIT *wait, const char * const desc, int maxduration) ;
STATUS ks_eval_isirot(KS_ISIROT *isirot, const char * const desc, int isinumber) ;
STATUS ks_eval_read(KS_READ *read, const char * const desc) ;
STATUS ks_eval_trap_constrained(KS_TRAP *trap, const char * const desc, float ampmax, float slewrate, int minduration) ;
STATUS ks_eval_trap( KS_TRAP *trap, const char * const desc) ;
STATUS ks_eval_trap2(KS_TRAP *trap, const char * const desc) ;
STATUS ks_eval_trap1(KS_TRAP *trap, const char * const desc) ;
STATUS ks_eval_readtrap_constrained(KS_READTRAP *readtrap, const char * const desc, float ampmax, float slewrate) ;
STATUS ks_eval_readtrap( KS_READTRAP *readtrap, const char * const desc) ;
STATUS ks_eval_readtrap2(KS_READTRAP *readtrap, const char * const desc) ;
STATUS ks_eval_readtrap1(KS_READTRAP *readtrap, const char * const desc) ;
void ks_eval_phaseviewtable(KS_PHASER *phaser);
STATUS ks_eval_phaser_adjustres(KS_PHASER *phaser, const char * const desc) ;
STATUS ks_eval_phaser_setaccel(KS_PHASER *phaser, int min_acslines, float R) ;
STATUS ks_eval_phaser_constrained(KS_PHASER *phaser, const char * const desc,
                                  float ampmax, float slewrate, int minplateautime) ;
STATUS ks_eval_phaser( KS_PHASER *phaser, const char * const desc) ;
STATUS ks_eval_phaser2(KS_PHASER *phaser, const char * const desc) ;
STATUS ks_eval_phaser1(KS_PHASER *phaser, const char * const desc) ;
STATUS ks_eval_wave(KS_WAVE *wave, const char * const desc, int res, int duration, KS_WAVEFORM waveform) ;
STATUS ks_eval_mirrorwave(KS_WAVE *wave);
STATUS ks_eval_wave_file(KS_WAVE *wave, const char * const desc, int res, int duration, const char *const filename, const char *const format) ;
STATUS ks_eval_rf_sinc(KS_RF *rf, const char * const desc, double bw, double tbw, float flip, int wintype) ;
STATUS ks_eval_rf_secant(KS_RF *rf, const char * const desc, float A0, float tbw, float bw);
STATUS ks_eval_rf_hard(KS_RF *rf, const char * const desc, int duration, float flip) ;
STATUS ks_eval_rf_hard_optimal_duration(KS_RF *rf, const char * const desc, int order, float flip, float offsetFreq) ;
STATUS ks_eval_rf_binomial(KS_RF *rf, const char * const desc, int offResExc, int nPulses, float flip, float offsetFreq) ;
STATUS ks_eval_rfstat(KS_RF *rf) ;
STATUS ks_eval_rf(KS_RF *rf, const char * const desc) ;
void ks_eval_rf_relink(KS_RF *rf);
STATUS ks_eval_stretch_rf(KS_RF *rf, float stretch_factor);
STATUS ks_eval_seltrap(KS_TRAP *trap, const char * const desc, float slewrate, float slthick, float bw, int rfduration) ;
STATUS ks_eval_selrf_constrained(KS_SELRF *selrf, const char * const desc, float ampmax, float slewrate) ;
STATUS ks_eval_selrf(KS_SELRF *selrf, const char * const desc) ;
STATUS ks_eval_selrf2(KS_SELRF *selrf, const char * const desc) ;
STATUS ks_eval_selrf1(KS_SELRF *selrf, const char * const desc) ;
STATUS ks_eval_sms_get_phase_modulation(float *sms_phase_modulation, const int sms_multiband_factor, const int sms_phase_modulation_mode) ;
float ks_eval_findb1(KS_SELRF *selrf, float max_b1, double scaleFactor, int sms_multiband_factor, int sms_phase_modulation_mode, float sms_slice_gap);
STATUS ks_eval_sms_make_multiband(KS_SELRF *selrfMB, const KS_SELRF *selrf, const int sms_multiband_factor, const int sms_phase_modulation_mode, const float sms_slice_gap, int debug) ;
float ks_eval_sms_calc_slice_gap(int sms_multiband_factor, const SCAN_INFO *org_slice_positions, int nslices, float slthick, float slspace);
float ks_eval_sms_calc_caipi_area(int caipi_fov_shift, float sms_slice_gap);
STATUS ks_eval_sms_make_pins(KS_SELRF *selrfPINS, const KS_SELRF *selrf, float sms_slice_gap);
STATUS ks_eval_sms_make_pins_dante(KS_SELRF *selrfPINS, const KS_SELRF *selrf, float sms_slice_gap);
int ks_eval_findNearestNeighbourIndex(float value, const float *x, int length);
void ks_eval_linear_interp1(const float *x, int x_length, const float *y, const float *xx, int xx_length, float *yy);
STATUS ks_eval_trap2wave(KS_WAVE *wave, const KS_TRAP *trap) ;
STATUS ks_eval_append_two_waves(KS_WAVE* first_wave, KS_WAVE* second_wave) ;
STATUS ks_eval_concatenate_waves(int num_waves, KS_WAVE* target_wave, KS_WAVE** waves_to_append) ;
STATUS ks_eval_epi_constrained(KS_EPI *epi, const char * const desc, float ampmax, float slewrate) ;
STATUS ks_eval_epi_setinfo(KS_EPI *epi);
STATUS ks_eval_epi_maxamp_slewrate(float *ampmax, float *slewrate, int xres, float quietnessfactor);
STATUS ks_eval_epi(KS_EPI *epi, const char * const desc, float quietnessfactor) ;
int ks_eval_gradrflimits(KS_SAR *sar, KS_SEQ_COLLECTION *seqcollection, float gheatfact);
int ks_eval_mintr(int nslices, KS_SEQ_COLLECTION *seqcollection, float gheatfact, int (*play_loop)(int, int, void **), int nargs, void **args);
int ks_eval_maxslicespertr(int TR, KS_SEQ_COLLECTION *seqcollection, float gheatfact, int (*play_loop)(int , int , void ** ), int nargs, void **args);
STATUS ks_eval_seqctrl_setminduration(KS_SEQ_CONTROL *seqctrl, int mindur);
STATUS ks_eval_seqctrl_setduration(KS_SEQ_CONTROL *seqctrl, int dur);
STATUS ks_eval_seqcollection_durations_setminimum(KS_SEQ_COLLECTION *seqcollection) ;
STATUS ks_eval_seqcollection_durations_atleastminimum(KS_SEQ_COLLECTION *seqcollection) ;
void ks_eval_seqcollection_resetninst(KS_SEQ_COLLECTION *seqcollection);
void ks_print_seqcollection(KS_SEQ_COLLECTION *seqcollection, FILE *fp);
int ks_eval_seqcollection_gettotalduration(KS_SEQ_COLLECTION *seqcollection);
int ks_eval_seqcollection_gettotalminduration(KS_SEQ_COLLECTION *seqcollection);
STATUS ks_eval_seqcollection2rfpulse(RF_PULSE *rfpulse, KS_SEQ_COLLECTION *seqcollection);
GRAD_PULSE ks_eval_makegradpulse(KS_TRAP *trp, int gradchoice);
void ks_read_header_pool(int* exam_number, int* series_number, int* run_number);
unsigned int ks_calc_nextpow2(unsigned int x);
int ks_calc_roundupms(int time);
STATUS ks_calc_filter(FILTER_INFO *echo_filter, int tsp, int duration) ;
int ks_calc_bw2tsp(float bw);
float ks_calc_tsp2bw(int tsp);
int ks_calc_trap_time2area(KS_TRAP* trap, float area);
float ks_calc_nearestbw(float bw);
float ks_calc_max_rbw(float ampmax, float fov);
float ks_calc_minfov(float ampmax, int tsp);
float ks_calc_minslthick(float bw);
int ks_calc_mintsp(float ampmax, float fov);
float ks_calc_max_rbw(float ampmax, float fov);
float ks_calc_fov2gradareapixel(float fov);
void ks_phaseencoding_init_tgt(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr);
KS_PHASEENCODING_COORD ks_phaseencoding_get(const KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int echo, int shot);
void ks_phaseencoding_set(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int echo, int shot, int ky, int kz);
void ks_phaseencoding_print(const KS_PHASEENCODING_PLAN *phaseenc_plan_ptr);
STATUS ks_phaseencoding_resize(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, int etl, int num_shots);
STATUS ks_phaseencoding_generate_simple(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser);
STATUS ks_phaseencoding_generate_simple_ellipse(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser);
STATUS ks_fse_calcecho(double *bestecho, double *optecho, KS_PHASER *pe, int TE, int etl, int esp);
STATUS ks_phaseencoding_generate_2Dfse(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_PHASER *phaser, KS_PHASER *zphaser, int TE, int etl, int esp);
STATUS ks_phaseencoding_generate_epi(KS_PHASEENCODING_PLAN *phaseenc_plan_ptr, const char * const desc, KS_EPI *epitrain, int blipsign, int numkyshots, int numsegments, int caipi);
STATUS ks_calc_sliceplan(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass);
STATUS ks_calc_sliceplan_interleaved(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass, int inpass_interleaves);
STATUS ks_calc_sliceplan_sms(KS_SLICE_PLAN *slice_plan, int nslices, int slperpass, int multiband_factor);
int ks_calc_slice_acquisition_order_smssingleacq(DATA_ACQ_ORDER *dacq, int nslices);
int ks_calc_sms_min_gap(DATA_ACQ_ORDER *dacq, int nslices);
void ks_print_sliceplan(const KS_SLICE_PLAN slice_plan, FILE *fp);
void ks_print_waveform(const KS_WAVEFORM waveform, char *filename, int res);
void ks_print_read(KS_READ read, FILE *fp);
void ks_print_trap(KS_TRAP trap, FILE *fp);
void ks_print_readtrap(KS_READTRAP readtrap, FILE *fp);
void ks_print_phaser(KS_PHASER phaser, FILE *fp);
void ks_print_epi(KS_EPI epi, FILE *fp);
void ks_print_rf(KS_RF rf, FILE *fp);
void ks_print_rfpulse(RF_PULSE rfpulse, FILE *fp);
void ks_print_selrf(KS_SELRF selrf, FILE *fp);
void ks_print_gradrfctrl(KS_GRADRFCTRL gradrfctrl, FILE *fp);
STATUS ks_error(const char *format, ...)
__attribute__ ((format (printf, 1, 2)));
STATUS ks_dbg(const char *format, ...)
__attribute__ ((format (printf, 1, 2)));
int ks_syslimits_hasICEhardware();
void ks_dbg_reset();
float ks_syslimits_ampmax(LOG_GRAD loggrd);
float ks_syslimits_ampmax2(LOG_GRAD loggrd);
float ks_syslimits_ampmax1(LOG_GRAD loggrd);
int ks_syslimits_ramptimemax(LOG_GRAD loggrd);
float ks_syslimits_slewrate(LOG_GRAD loggrd);
float ks_syslimits_slewrate2(LOG_GRAD loggrd);
float ks_syslimits_slewrate1(LOG_GRAD loggrd);
float ks_syslimits_gradtarget(LOG_GRAD loggrd, WF_PROCESSOR board);
short ks_phase_radians2hw(float radphase);
short ks_phase_degrees2hw(float degphase);
float ks_calc_selgradamp(float rfbw, float slthick);
int ks_wave_res(const KS_WAVE *wave);
float ks_waveform_max(const KS_WAVEFORM waveform, int res);
float ks_wave_max(const KS_WAVE *wave);
float ks_waveform_min(const KS_WAVEFORM waveform, int res);
float ks_wave_min(const KS_WAVE *wave);
float ks_waveform_absmax(const KS_WAVEFORM waveform, int res);
short ks_iwave_absmax(const KS_IWAVE waveform, int res);
float ks_wave_absmax(const KS_WAVE *wave);
float ks_waveform_area(const KS_WAVEFORM waveform, int start , int end , int dwelltime );
float ks_wave_area(const KS_WAVE *wave, int start , int end );
float ks_waveform_sum(const KS_WAVEFORM waveform, int res);
float ks_wave_sum(const KS_WAVE *wave);
float ks_waveform_norm(const KS_WAVEFORM waveform, int res);
float ks_wave_norm(const KS_WAVE *wave);
void ks_waveform_cumsum(KS_WAVEFORM cumsumwaveform, const KS_WAVEFORM waveform, int res);
void ks_wave_cumsum(KS_WAVE *cumsumwave, const KS_WAVE *wave);
void ks_waveform_multiply(KS_WAVEFORM waveform_mod, const KS_WAVEFORM waveform, int res);
void ks_wave_multiply(KS_WAVE *wave_mod, const KS_WAVE *wave);
void ks_waveform_add(KS_WAVEFORM waveform_mod, const KS_WAVEFORM waveform, int res);
void ks_wave_add(KS_WAVE *wave_mod, const KS_WAVE *wave);
void ks_waveform_multiplyval(KS_WAVEFORM waveform, float val, int res);
void ks_wave_multiplyval(KS_WAVE *wave, float val);
void ks_waveform_addval(KS_WAVEFORM waveform, float val, int res);
void ks_wave_addval(KS_WAVE *wave, float val);
STATUS ks_waveform2iwave(KS_IWAVE iwave, const KS_WAVEFORM waveform, int res, int board) ;
STATUS ks_wave2iwave(KS_IWAVE iwave, const KS_WAVE *wave, int board) ;
WF_PULSE * ks_pg_echossp(WF_PULSE *echo, char *suffix);
STATUS ks_pg_trap(KS_TRAP *trap, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_read(KS_READ *read, int pos, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_phaser(KS_PHASER *phaser, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_readtrap(KS_READTRAP *readtrap, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_wave(KS_WAVE *wave, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_rf(KS_RF *rf, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_selrf(KS_SELRF *selrf, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_wait(KS_WAIT *wait, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_isirot(KS_ISIROT *isirot, SCAN_INFO scan_info, int pos, void *rotfun, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_epi_dephasers(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_epi_rephasers(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_epi_echo(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
STATUS ks_pg_epi(KS_EPI *epi, KS_SEQLOC loc, KS_SEQ_CONTROL *ctrl) ;
void ks_mat4_zero(KS_MAT4x4 m);
void ks_mat4_identity(KS_MAT4x4 m);
void ks_mat4_print(const KS_MAT4x4 m);
void ks_mat4_multiply(KS_MAT4x4 lhs, const KS_MAT4x4 rhs_left, const KS_MAT4x4 rhs_right);
void ks_mat4_invert(KS_MAT4x4 lhs, const KS_MAT4x4 rhs);
void ks_mat4_setgeometry(KS_MAT4x4 lhs, float x, float y, float z, float xr, float yr, float zr);
void ks_mat4_setrotation1axis(KS_MAT4x4 rhs, float rot, char axis);
void ks_mat4_extractrotation(KS_MAT3x3 R, const KS_MAT4x4 M);
void ks_mat4_extracttranslation(double *T, const KS_MAT4x4 M);
void ks_mat3_identity(KS_MAT3x3 m);
void ks_mat3_multiply(KS_MAT3x3 lhs, const KS_MAT3x3 rhs_left, const KS_MAT3x3 rhs_right);
void ks_mat3_print(const KS_MAT3x3 m);
void ks_mat3_apply(double *w, const KS_MAT3x3 R, const double *v);
void ks_mat3_invapply(double *w, const KS_MAT3x3 R, const double *v);
void ks_scan_update_slice_location(SCAN_INFO *new_loc, const SCAN_INFO orig_loc, const KS_MAT4x4 M_physical, const KS_MAT4x4 M_logical);
void ks_scan_rotate(SCAN_INFO slice_info);
void ks_scan_isirotate(KS_ISIROT *isirot);
STATUS ks_pg_fse_flip_angle_taperoff(double *flip_angles,
                                     int etl,
                                     double flip1, double flip2, double flip3,
                                     double target_flip,
                                     int start_middle);
void ks_pg_mod_fse_rfpulse_structs(KS_SELRF *rf1, KS_SELRF *rf2, KS_SELRF *rf3, const double *flip_angles, const int etl);
void ks_instancereset_trap(KS_TRAP *trap);
void ks_instancereset_wait(KS_WAIT *wait);
void ks_instancereset_phaser(KS_PHASER *phaser);
void ks_instancereset_readtrap(KS_READTRAP *readtrap);
void ks_instancereset_rf(KS_RF *rf);
void ks_instancereset_selrf(KS_SELRF *selrf);
void ks_instancereset_epi(KS_EPI *epi);
int ks_compare_wfi_by_timeboard(const KS_WFINSTANCE *a, const KS_WFINSTANCE *b);
int ks_compare_wfi_by_boardtime(const KS_WFINSTANCE *a, const KS_WFINSTANCE *b);
int ks_compare_wfp_by_time(const WF_PULSE *a, const WF_PULSE *b);
int ks_compare_pint(const void *v1, const void *v2);
int ks_compare_pshort(const void *v1, const void *v2);
int ks_compare_pfloat(const void *v1, const void *v2);
int ks_compare_int(const void *v1, const void *v2);
int ks_compare_short(const void *v1, const void *v2);
int ks_compare_float(const void *v1, const void *v2);
void ks_sort_getsortedindx(int *sortedindx, int *array, int n);
void ks_sort_getsortedindx_s(int *sortedindx, short *array, int n);
void ks_sort_getsortedindx_f(int *sortedindx, float *array, int n);
void ks_sort_wfi_by_timeboard(KS_WFINSTANCE *a, int nitems);
void ks_sort_wfi_by_boardtime(KS_WFINSTANCE *a, int nitems);
void ks_sort_wfp_by_time(WF_PULSE *a, int nitems);
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
void ks_plot_tgt_addframe(KS_SEQ_CONTROL* ctrl);
void ks_scan_rf_ampscale(KS_RF *rf, int instanceno, float ampscale);
void ks_scan_rf_on(KS_RF *rf, int instanceno);
void ks_scan_rf_on_chop(KS_RF *rf, int instanceno);
void ks_scan_rf_off(KS_RF *rf, int instanceno);
void ks_scan_selrf_setfreqphase(KS_SELRF *selrf, int instanceno, SCAN_INFO sliceinfo, float rfphase);
void ks_scan_selrf_setfreqphase_pins(KS_SELRF *selrf, int instanceno, SCAN_INFO sliceinfo, int sms_multiband_factor, float sms_slice_gap, float rfphase);
void ks_scan_rf_setphase(KS_RF* rf, int instanceno, float rfphase );
void ks_scan_wave2hardware(KS_WAVE *wave, const KS_WAVEFORM newwave);
void ks_scan_offsetfov_iso(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, double ky, double kz, double rcvphase);
void ks_scan_offsetfov(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, int view, float phasefovratio, float rcvphase);
void ks_scan_offsetfov3D(KS_READTRAP *readtrap, int instanceno, SCAN_INFO sliceinfo, int kyview, float phasefovratio, int kzview, float zphasefovratio, float rcvphase );
void ks_scan_offsetfov_readwave(KS_READWAVE* readwave, int instanceno, SCAN_INFO sliceinfo, int kyview, float phasefovratio, float rcvphase);
void ks_scan_omegatrap_hz(KS_TRAP *trap, int instanceno, float Hz);
void ks_scan_omegawave_hz(KS_WAVE *wave, int instanceno, float Hz);
void ks_scan_wait(KS_WAIT *wait, int waitperiod);
void ks_scan_trap_ampscale(KS_TRAP *trap, int instanceno, float ampscale);
void ks_scan_trap_ampscale_slice(KS_TRAP *trap, int start, int skip, int count, float ampscale);
void ks_scan_phaser_kmove(KS_PHASER *phaser, int instanceno, double pixelunits);
void ks_scan_phaser_toline(KS_PHASER *phaser, int instanceno, int view);
void ks_scan_phaser_fromline(KS_PHASER *phaser, int instanceno, int view);
int ks_scan_getsliceloc(const KS_SLICE_PLAN *slice_plan, int passindx, int sltimeinpass);
int ks_scan_getslicetime(const KS_SLICE_PLAN *slice_plan, int passindx, int slloc);
ks_enum_epiblipsign ks_scan_epi_verify_phaseenc_plan(KS_EPI *epi, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot);
void ks_scan_epi_shotcontrol(KS_EPI *epi, int echo, SCAN_INFO sliceinfo, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot, float rcvphase);
void ks_scan_epi_loadecho(KS_EPI *epi, int echo, int storeecho, int slice, KS_PHASEENCODING_PLAN *phaseenc_plan, int shot);
void ks_scan_acq_to_rtp(KS_READ *read, TYPDAB_PACKETS dabacqctrl, float fatoffset);
void ks_scan_switch_to_sequence(KS_SEQ_CONTROL *ctrl);
int ks_scan_playsequence(KS_SEQ_CONTROL *ctrl);
STATUS ks_scan_loaddabwithindices(WF_PULSE_ADDR pulse,
                                  LONG slice,
                                  LONG echo,
                                  LONG view,
                                  uint8_t acq,
                                  uint8_t vol,
                                  TYPDAB_PACKETS acqon_flag);
STATUS ks_scan_loaddabwithindices_nex(WF_PULSE_ADDR pulse,
                                      LONG slice,
                                      LONG echo,
                                      LONG view,
                                      uint8_t acq,
                                      uint8_t vol,
                                      LONG operation,
                                      TYPDAB_PACKETS acqon_flag);
int ks_scan_wait_for_rtp(void *rtpmsg, int maxmsgsize, int maxwait, KS_SEQ_CONTROL *waitctrl);
void ks_copy_and_reset_obj(void *pobj);
void ks_show_clock(FLOAT scantime);
float ks_scan_rf_phase_spoiling(int counter);
void ks_tgt_reset_gradrfctrl(KS_GRADRFCTRL* gradrfctrl);
int ks_eval_clear_readwave(KS_READWAVE* readwave);
int ks_eval_clear_dualreadtrap(KS_DIXON_DUALREADTRAP* dual_read);
typedef struct KSGRE_SEQUENCE {
  KS_SEQ_CONTROL seqctrl;
  KS_READTRAP read;
  KS_TRAP readdephaser;
  KS_PHASER phaseenc;
  KS_TRAP spoiler;
  KS_SELRF selrfexc;
} KSGRE_SEQUENCE;
const KS_RF exc_fl901mc = {KS_RF_ROLE_EXC,90,886,0,1,2500,1500,-1,"GE RF pulse: rffl901mc.rho",{((void *)0),((void *)0),0.3728,0.2516,0.2909,0.616,0.616,0,0.0505,0.00257,0.0253,90,((void *)0),4000,886,0,0,1500,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,4000,{0,0.00348,0,-0.00403,-0.00781,-0.01111,-0.01386,-0.01624,-0.01837,-0.02039,-0.02240,-0.02435,-0.02637,-0.02851,-0.03070,-0.03308,-0.03552,-0.03815,-0.04084,-0.04364,-0.04663,-0.04975,-0.05292,-0.05622,-0.05963,-0.06311,-0.06672,-0.07038,-0.07422,-0.07807,-0.08198,-0.08600,-0.09003,-0.09418,-0.09833,-0.10248,-0.10670,-0.11097,-0.11518,-0.11945,-0.12373,-0.12800,-0.13215,-0.13636,-0.14045,-0.14454,-0.14851,-0.15241,-0.15620,-0.15992,-0.16346,-0.16688,-0.17018,-0.17329,-0.17622,-0.17897,-0.18153,-0.18391,-0.18599,-0.18788,-0.18946,-0.19081,-0.19185,-0.19264,-0.19307,-0.19319,-0.19300,-0.19246,-0.19154,-0.19026,-0.18861,-0.18660,-0.18409,-0.18129,-0.17799,-0.17427,-0.17012,-0.16548,-0.16041,-0.15492,-0.14893,-0.14246,-0.13557,-0.12818,-0.12031,-0.11195,-0.10309,-0.09376,-0.08393,-0.07361,-0.06287,-0.05158,-0.03986,-0.02765,-0.01502,-0.00189,0.01148,0.02551,0.03998,0.05481,0.07013,0.08588,0.10200,0.11848,0.13532,0.15254,0.17005,0.18794,0.20613,0.22456,0.24336,0.26235,0.28157,0.30098,0.32064,0.34041,0.36037,0.38046,0.40060,0.42086,0.44119,0.46145,0.48184,0.50211,0.52237,0.54251,0.56260,0.58249,0.60233,0.62193,0.64127,0.66038,0.67924,0.69780,0.71605,0.73393,0.75145,0.76854,0.78520,0.80138,0.81713,0.83233,0.84704,0.86114,0.87469,0.88763,0.89990,0.91162,0.92260,0.93298,0.94256,0.95154,0.95978,0.96722,0.97394,0.97992,0.98511,0.98956,0.99322,0.99609,0.99817,0.99951,1,0.99976,0.99872,0.99695,0.99438,0.99109,0.98706,0.98224,0.97674,0.97058,0.96368,0.95611,0.94793,0.93908,0.92968,0.91961,0.90899,0.89788,0.88622,0.87402,0.86138,0.84832,0.83477,0.82091,0.80663,0.79198,0.77709,0.76183,0.74632,0.73057,0.71464,0.69853,0.68223,0.66575,0.64927,0.63261,0.61594,0.59916,0.58243,0.56571,0.54904,0.53238,0.51578,0.49930,0.48288,0.46664,0.45053,0.43454,0.41879,0.40322,0.38784,0.37270,0.35775,0.34316,0.32876,0.31459,0.30074,0.28719,0.27394,0.26094,0.24837,0.23604,0.22407,0.21242,0.20106,0.19008,0.17939,0.16908,0.15919,0.14955,0.14027,0.13142,0.12281,0.11463,0.10676,0.09931,0.09217,0.08539,0.07905,0.07294,0.06733,0.06202,0.05725,0.05286,0.04908,0.04566,0.04334,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_fse90 = {KS_RF_ROLE_EXC,90,800,0,1,2292,1708,-1,"GE RF pulse: rffse90.rho",{((void *)0),((void *)0),0.3777,0.2713,0.3615,0.7462,0.7462,0,0.0406013,0.0017884,0.0211473,90,((void *)0),4000,800,0,0,1708,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,4000,{0,0,-0.00006,-0.00037,-0.00092,-0.00177,-0.00299,-0.00464,-0.00678,-0.00922,-0.01184,-0.01447,-0.01697,-0.01911,-0.02081,-0.02197,-0.02258,-0.02283,-0.02283,-0.02265,-0.02240,-0.02228,-0.02234,-0.02265,-0.02307,-0.02374,-0.02448,-0.02533,-0.02619,-0.02710,-0.02802,-0.02893,-0.02985,-0.03076,-0.03168,-0.03259,-0.03351,-0.03443,-0.03528,-0.03620,-0.03705,-0.03791,-0.03876,-0.03961,-0.04041,-0.04126,-0.04206,-0.04279,-0.04358,-0.04431,-0.04499,-0.04572,-0.04633,-0.04700,-0.04761,-0.04816,-0.04865,-0.04914,-0.04956,-0.04999,-0.05030,-0.05060,-0.05078,-0.05097,-0.05109,-0.05115,-0.05121,-0.05115,-0.05103,-0.05091,-0.05066,-0.05036,-0.04999,-0.04950,-0.04901,-0.04840,-0.04767,-0.04688,-0.04602,-0.04511,-0.04401,-0.04291,-0.04169,-0.04035,-0.03888,-0.03736,-0.03577,-0.03406,-0.03223,-0.03028,-0.02820,-0.02606,-0.02381,-0.02142,-0.01892,-0.01630,-0.01355,-0.01068,-0.00769,-0.00452,-0.00128,0.00171,0.00525,0.00885,0.01264,0.01654,0.02057,0.02472,0.02905,0.03345,0.03803,0.04279,0.04761,0.05262,0.05774,0.06299,0.06842,0.07398,0.07966,0.08552,0.09144,0.09754,0.10383,0.11018,0.11671,0.12336,0.13020,0.13709,0.14417,0.15138,0.15870,0.16615,0.17378,0.18147,0.18934,0.19728,0.20540,0.21358,0.22194,0.23042,0.23897,0.24770,0.25649,0.26540,0.27443,0.28353,0.29280,0.30208,0.31154,0.32100,0.33065,0.34035,0.35012,0.35995,0.36990,0.37991,0.38998,0.40011,0.41030,0.42062,0.43093,0.44131,0.45169,0.46213,0.47262,0.48318,0.49368,0.50430,0.51486,0.52548,0.53604,0.54666,0.55728,0.56791,0.57847,0.58903,0.59958,0.61008,0.62058,0.63102,0.64140,0.65177,0.66209,0.67228,0.68248,0.69261,0.70262,0.71257,0.72240,0.73222,0.74187,0.75145,0.76091,0.77025,0.77947,0.78856,0.79753,0.80638,0.81511,0.82366,0.83208,0.84032,0.84844,0.85638,0.86413,0.87170,0.87914,0.88635,0.89337,0.90026,0.90685,0.91332,0.91955,0.92559,0.93145,0.93701,0.94244,0.94757,0.95251,0.95721,0.96167,0.96594,0.96991,0.97369,0.97723,0.98047,0.98352,0.98627,0.98877,0.99109,0.99310,0.99481,0.99634,0.99756,0.99860,0.99933,0.99976,1,0.99994,0.99969,0.99915,0.99829,0.99725,0.99591,0.99438,0.99255,0.99048,0.98816,0.98566,0.98285,0.97980,0.97650,0.97302,0.96924,0.96527,0.96106,0.95660,0.95196,0.94708,0.94201,0.93670,0.93121,0.92547,0.91955,0.91345,0.90716,0.90069,0.89398,0.88714,0.88012,0.87292,0.86559,0.85808,0.85039,0.84258,0.83465,0.82653,0.81829,0.80992,0.80144,0.79283,0.78411,0.77525,0.76634,0.75731,0.74815,0.73900,0.72966,0.72032,0.71086,0.70140,0.69181,0.68217,0.67253,0.66282,0.65305,0.64323,0.63340,0.62357,0.61368,0.60380,0.59391,0.58402,0.57413,0.56424,0.55436,0.54447,0.53464,0.52481,0.51499,0.50522,0.49551,0.48581,0.47610,0.46652,0.45694,0.44742,0.43795,0.42855,0.41922,0.40994,0.40072,0.39163,0.38253,0.37356,0.36471,0.35592,0.34719,0.33858,0.33004,0.32161,0.31325,0.30501,0.29689,0.28884,0.28090,0.27309,0.26534,0.25771,0.25026,0.24281,0.23555,0.22841,0.22139,0.21449,0.20772,0.20100,0.19447,0.18806,0.18171,0.17555,0.16944,0.16346,0.15760,0.15193,0.14631,0.14082,0.13545,0.13020,0.12513,0.12012,0.11524,0.11048,0.10584,0.10132,0.09693,0.09266,0.08851,0.08442,0.08051,0.07666,0.07300,0.06946,0.06604,0.06293,0.06006,0.05750,0.05530,0.05347,0.05201,0.05078,0.04950,0.04804,0.04627,0.04389,0.04077,0.03687,0.03229,0.02735,0.02222,0.01727,0.01270,0.00873,0.00562,0.00330,0.00171,0.00073,0.00018,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_fse902 = {KS_RF_ROLE_EXC,90,800,0,1,3250,1750,-1,"GE RF pulse: rffse902.rho",{((void *)0),((void *)0),0.3777,0.2713,0.3615,0.7462,0.7462,0,0.0406013,0.0017884,0.0211473,90,((void *)0),5000,800,0,0,1750,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,5000,{0,0,0.00018,0.00073,0.00171,0.00330,0.00562,0.00873,0.01270,0.01727,0.02222,0.02735,0.03229,0.03687,0.04077,0.04389,0.04627,0.04804,0.04950,0.05078,0.05201,0.05347,0.05530,0.05750,0.06006,0.06293,0.06604,0.06946,0.07300,0.07666,0.08051,0.08442,0.08851,0.09266,0.09693,0.10132,0.10584,0.11048,0.11524,0.12012,0.12513,0.13020,0.13545,0.14082,0.14631,0.15193,0.15760,0.16346,0.16944,0.17555,0.18171,0.18806,0.19447,0.20100,0.20772,0.21449,0.22139,0.22841,0.23555,0.24281,0.25026,0.25771,0.26534,0.27309,0.28090,0.28884,0.29689,0.30501,0.31325,0.32161,0.33004,0.33858,0.34719,0.35592,0.36471,0.37356,0.38253,0.39163,0.40072,0.40994,0.41922,0.42855,0.43795,0.44742,0.45694,0.46652,0.47610,0.48581,0.49551,0.50522,0.51499,0.52481,0.53464,0.54447,0.55436,0.56424,0.57413,0.58402,0.59391,0.60380,0.61368,0.62357,0.63340,0.64323,0.65305,0.66282,0.67253,0.68217,0.69181,0.70140,0.71086,0.72032,0.72966,0.73900,0.74815,0.75731,0.76634,0.77525,0.78411,0.79283,0.80144,0.80992,0.81829,0.82653,0.83465,0.84258,0.85039,0.85808,0.86559,0.87292,0.88012,0.88714,0.89398,0.90069,0.90716,0.91345,0.91955,0.92547,0.93121,0.93670,0.94201,0.94708,0.95196,0.95660,0.96106,0.96527,0.96924,0.97302,0.97650,0.97980,0.98285,0.98566,0.98816,0.99048,0.99255,0.99438,0.99591,0.99725,0.99829,0.99915,0.99969,0.99994,1,0.99976,0.99933,0.99860,0.99756,0.99634,0.99481,0.99310,0.99109,0.98877,0.98627,0.98352,0.98047,0.97723,0.97369,0.96991,0.96594,0.96167,0.95721,0.95251,0.94757,0.94244,0.93701,0.93145,0.92559,0.91955,0.91332,0.90685,0.90026,0.89337,0.88635,0.87914,0.87170,0.86413,0.85638,0.84844,0.84032,0.83208,0.82366,0.81511,0.80638,0.79753,0.78856,0.77947,0.77025,0.76091,0.75145,0.74187,0.73222,0.72240,0.71257,0.70262,0.69261,0.68248,0.67228,0.66209,0.65177,0.64140,0.63102,0.62058,0.61008,0.59958,0.58903,0.57847,0.56791,0.55728,0.54666,0.53604,0.52548,0.51486,0.50430,0.49368,0.48318,0.47262,0.46213,0.45169,0.44131,0.43093,0.42062,0.41030,0.40011,0.38998,0.37991,0.36990,0.35995,0.35012,0.34035,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_fl902mc = {KS_RF_ROLE_EXC,90,886,0,1,1660,3340,-1,"GE RF pulse: rffl902mc.rho",{((void *)0),((void *)0),0.3728,0.2516,0.2909,0.616,0.616,0,0.0505,0.00257,0.0253,90,((void *)0),5000,886,0,0,3340,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,5000,{0,0.04337,0.04566,0.04907,0.05286,0.05728,0.06204,0.06735,0.07297,0.07904,0.08539,0.09217,0.09931,0.10678,0.11463,0.12284,0.13141,0.14029,0.14957,0.15918,0.16910,0.17942,0.19007,0.20106,0.21241,0.22407,0.23603,0.24839,0.26096,0.27393,0.28718,0.30076,0.31462,0.32875,0.34315,0.35777,0.37269,0.38786,0.40321,0.41877,0.43455,0.45051,0.46663,0.48286,0.49928,0.51576,0.53236,0.54903,0.56572,0.58245,0.59917,0.61592,0.63262,0.64925,0.66576,0.68221,0.69854,0.71465,0.73058,0.74633,0.76183,0.77706,0.79199,0.80660,0.82089,0.83477,0.84829,0.86135,0.87402,0.88620,0.89785,0.90899,0.91961,0.92965,0.93905,0.94790,0.95611,0.96368,0.97055,0.97674,0.98224,0.98703,0.99106,0.99435,0.99695,0.99872,0.99973,1,0.99948,0.99814,0.99606,0.99319,0.98953,0.98511,0.97989,0.97394,0.96722,0.95975,0.95151,0.94256,0.93295,0.92261,0.91159,0.89990,0.88760,0.87466,0.86111,0.84701,0.83233,0.81710,0.80139,0.78518,0.76855,0.75143,0.73394,0.71606,0.69781,0.67925,0.66039,0.64125,0.62191,0.60231,0.58251,0.56261,0.54253,0.52235,0.50209,0.48183,0.46147,0.44118,0.42085,0.40062,0.38044,0.36036,0.34040,0.32063,0.30100,0.28156,0.26234,0.24335,0.22459,0.20615,0.18796,0.17008,0.15253,0.13535,0.11847,0.10199,0.08588,0.07016,0.05484,0.03998,0.02551,0.01147,-0.00189,-0.01502,-0.02768,-0.03989,-0.05161,-0.06287,-0.07361,-0.08396,-0.09375,-0.10309,-0.11194,-0.12030,-0.12818,-0.13559,-0.14249,-0.14896,-0.15494,-0.16044,-0.16550,-0.17011,-0.17426,-0.17798,-0.18128,-0.18412,-0.18659,-0.18863,-0.19028,-0.19156,-0.19245,-0.19300,-0.19321,-0.19309,-0.19263,-0.19187,-0.19083,-0.18949,-0.18787,-0.18601,-0.18390,-0.18155,-0.17899,-0.17624,-0.17331,-0.17017,-0.16691,-0.16346,-0.15992,-0.15622,-0.15241,-0.14853,-0.14454,-0.14048,-0.13636,-0.13218,-0.12799,-0.12372,-0.11945,-0.11521,-0.11097,-0.10672,-0.10251,-0.09833,-0.09418,-0.09006,-0.08600,-0.08200,-0.07807,-0.07422,-0.07041,-0.06671,-0.06311,-0.05963,-0.05622,-0.05292,-0.04975,-0.04666,-0.04367,-0.04086,-0.03815,-0.03555,-0.03308,-0.03073,-0.02850,-0.02640,-0.02435,-0.02240,-0.02042,-0.01840,-0.01627,-0.01389,-0.01111,-0.00784,-0.00403,0,0.00351,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_ssfse90new = {KS_RF_ROLE_EXC,90,1280,0,1,1004,996,-1,"GE RF pulse: rfssfse90new.rho",{((void *)0),((void *)0),0.3648,0.2647,0.3578,0.7538,0.7538,0,0.0820572,0.00356446,0.0422165,90,((void *)0),2000,1280,0,0,996,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},200,2000,{0,-0.00043,-0.00214,-0.00604,-0.01257,-0.02008,-0.02643,-0.02930,-0.02814,-0.02466,-0.02075,-0.01807,-0.01679,-0.01642,-0.01630,-0.01605,-0.01563,-0.01495,-0.01404,-0.01288,-0.01148,-0.00977,-0.00775,-0.00537,-0.00269,0.00018,0.00360,0.00745,0.01166,0.01630,0.02142,0.02698,0.03302,0.03949,0.04651,0.05402,0.06202,0.07056,0.07959,0.08918,0.09931,0.11005,0.12128,0.13306,0.14539,0.15827,0.17176,0.18574,0.20027,0.21535,0.23091,0.24696,0.26350,0.28053,0.29799,0.31582,0.33413,0.35280,0.37191,0.39132,0.41104,0.43106,0.45126,0.47171,0.49234,0.51309,0.53397,0.55490,0.57584,0.59678,0.61765,0.63841,0.65898,0.67942,0.69957,0.71947,0.73900,0.75816,0.77690,0.79515,0.81292,0.83007,0.84667,0.86260,0.87780,0.89233,0.90606,0.91894,0.93103,0.94220,0.95245,0.96179,0.97015,0.97754,0.98389,0.98920,0.99353,0.99676,0.99890,1,1,0.99890,0.99676,0.99353,0.98920,0.98389,0.97754,0.97015,0.96179,0.95245,0.94220,0.93103,0.91894,0.90606,0.89233,0.87780,0.86260,0.84667,0.83007,0.81292,0.79515,0.77690,0.75816,0.73900,0.71947,0.69957,0.67942,0.65898,0.63841,0.61765,0.59678,0.57584,0.55490,0.53397,0.51309,0.49234,0.47171,0.45132,0.43106,0.41104,0.39132,0.37191,0.35280,0.33413,0.31582,0.29799,0.28053,0.26350,0.24696,0.23091,0.21535,0.20027,0.18574,0.17176,0.15827,0.14539,0.13306,0.12128,0.11005,0.09931,0.08918,0.07959,0.07056,0.06202,0.05402,0.04651,0.03949,0.03302,0.02698,0.02142,0.01630,0.01166,0.00745,0.00360,0.00018,-0.00269,-0.00537,-0.00775,-0.00977,-0.01148,-0.01288,-0.01404,-0.01495,-0.01563,-0.01605,-0.01630,-0.01642,-0.01679,-0.01807,-0.02075,-0.02466,-0.02814,-0.02930,-0.02643,-0.02008,-0.01257,-0.00604,-0.00214,-0.00043,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_3dfgre = {KS_RF_ROLE_EXC,30,3664,0,1,2760,440,-1,"GE RF pulse: rf3dfgre.rho",{((void *)0),((void *)0),0.1878,0.1005,0.0949,0.2633,0.2132,0,0.0644207,0.001335,0.02043,30,((void *)0),3200,3664,0,0,440,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},320,3200,{0,-0.00098,-0.00482,-0.01129,-0.01575,-0.01422,-0.00952,-0.00610,-0.00494,-0.00470,-0.00433,-0.00385,-0.00317,-0.00244,-0.00153,-0.00055,0.00031,0.00153,0.00287,0.00427,0.00574,0.00726,0.00885,0.01044,0.01196,0.01355,0.01508,0.01654,0.01788,0.01911,0.02014,0.02106,0.02179,0.02228,0.02252,0.02252,0.02222,0.02173,0.02088,0.01984,0.01843,0.01685,0.01495,0.01282,0.01044,0.00781,0.00501,0.00208,-0.00079,-0.00397,-0.00720,-0.01044,-0.01367,-0.01685,-0.01990,-0.02277,-0.02545,-0.02789,-0.03003,-0.03186,-0.03333,-0.03436,-0.03498,-0.03510,-0.03479,-0.03400,-0.03272,-0.03095,-0.02869,-0.02594,-0.02277,-0.01917,-0.01514,-0.01074,-0.00604,-0.00110,0.00378,0.00909,0.01447,0.01984,0.02515,0.03034,0.03528,0.03998,0.04425,0.04810,0.05152,0.05432,0.05652,0.05805,0.05890,0.05902,0.05835,0.05689,0.05469,0.05164,0.04785,0.04334,0.03809,0.03223,0.02570,0.01868,0.01117,0.00330,-0.00464,-0.01300,-0.02149,-0.02991,-0.03821,-0.04627,-0.05396,-0.06122,-0.06788,-0.07386,-0.07905,-0.08338,-0.08680,-0.08918,-0.09046,-0.09064,-0.08967,-0.08753,-0.08417,-0.07966,-0.07404,-0.06726,-0.05945,-0.05066,-0.04096,-0.03052,-0.01935,-0.00763,0.00421,0.01666,0.02918,0.04169,0.05402,0.06598,0.07746,0.08826,0.09821,0.10718,0.11506,0.12171,0.12702,0.13081,0.13313,0.13380,0.13282,0.13013,0.12574,0.11970,0.11201,0.10273,0.09192,0.07966,0.06617,0.05146,0.03571,0.01917,0.00195,-0.01550,-0.03345,-0.05139,-0.06922,-0.08661,-0.10340,-0.11927,-0.13416,-0.14778,-0.15992,-0.17042,-0.17909,-0.18580,-0.19044,-0.19288,-0.19307,-0.19087,-0.18641,-0.17952,-0.17030,-0.15888,-0.14521,-0.12946,-0.11182,-0.09235,-0.07135,-0.04895,-0.02539,-0.00098,0.02381,0.04920,0.07459,0.09980,0.12446,0.14826,0.17091,0.19221,0.21174,0.22938,0.24483,0.25777,0.26814,0.27571,0.28029,0.28182,0.28017,0.27535,0.26729,0.25600,0.24153,0.22401,0.20350,0.18025,0.15437,0.12611,0.09571,0.06348,0.02966,-0.00513,-0.04102,-0.07746,-0.11408,-0.15046,-0.18629,-0.22108,-0.25453,-0.28627,-0.31594,-0.34310,-0.36758,-0.38894,-0.40701,-0.42141,-0.43203,-0.43869,-0.44113,-0.43930,-0.43313,-0.42251,-0.40756,-0.38821,-0.36459,-0.33675,-0.30489,-0.26918,-0.22987,-0.18721,-0.14137,-0.09284,-0.04175,0.01111,0.06604,0.12238,0.17970,0.23762,0.29573,0.35372,0.41110,0.46750,0.52261,0.57602,0.62742,0.67649,0.72288,0.76634,0.80657,0.84344,0.87670,0.90612,0.93170,0.95324,0.97076,0.98419,0.99347,0.99872,1,0.99738,0.99097,0.98089,0.96741,0.95068,0.93097,0.90838,0.88323,0.85577,0.82622,0.79491,0.76213,0.72807,0.69304,0.65733,0.62113,0.58469,0.54831,0.51218,0.47653,0.44149,0.40725,0.37399,0.34188,0.31099,0.28145,0.25331,0.22676,0.20167,0.17823,0.15644,0.13624,0.11768,0.10071,0.08533,0.07251,0.06354,0.05695,0.04663,0.02936,0.01209,0.00250,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_3d16min = {KS_RF_ROLE_EXC,45,7232,0,1,1348,252,-1,"GE RF pulse: rf3d16min.rho",{((void *)0),((void *)0),0.195,0.1036,0.0943,1,1,0,0.194498,0.00627166,0.0627166,45,((void *)0),1600,7232,0,0,252,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},800,1600,{0,0,0,0.00018,0.00055,0.00116,0.00208,0.00311,0.00427,0.00537,0.00629,0.00702,0.00739,0.00757,0.00757,0.00751,0.00745,0.00745,0.00763,0.00787,0.00818,0.00855,0.00891,0.00934,0.00971,0.01013,0.01050,0.01093,0.01129,0.01172,0.01209,0.01245,0.01282,0.01318,0.01355,0.01386,0.01422,0.01459,0.01489,0.01520,0.01550,0.01575,0.01605,0.01630,0.01648,0.01672,0.01685,0.01703,0.01715,0.01727,0.01734,0.01740,0.01746,0.01746,0.01740,0.01734,0.01727,0.01715,0.01697,0.01679,0.01654,0.01630,0.01599,0.01569,0.01532,0.01489,0.01447,0.01398,0.01349,0.01294,0.01239,0.01178,0.01111,0.01038,0.00971,0.00891,0.00812,0.00726,0.00641,0.00549,0.00458,0.00360,0.00256,0.00159,0.00055,-0.00024,-0.00134,-0.00244,-0.00360,-0.00476,-0.00598,-0.00720,-0.00848,-0.00971,-0.01099,-0.01227,-0.01361,-0.01489,-0.01624,-0.01752,-0.01886,-0.02014,-0.02149,-0.02277,-0.02411,-0.02539,-0.02667,-0.02789,-0.02918,-0.03034,-0.03156,-0.03272,-0.03388,-0.03498,-0.03601,-0.03705,-0.03809,-0.03906,-0.03992,-0.04084,-0.04163,-0.04242,-0.04309,-0.04376,-0.04438,-0.04492,-0.04541,-0.04584,-0.04621,-0.04645,-0.04669,-0.04688,-0.04694,-0.04694,-0.04688,-0.04676,-0.04651,-0.04627,-0.04590,-0.04547,-0.04492,-0.04438,-0.04370,-0.04291,-0.04212,-0.04120,-0.04022,-0.03919,-0.03803,-0.03687,-0.03559,-0.03424,-0.03284,-0.03137,-0.02985,-0.02820,-0.02655,-0.02484,-0.02307,-0.02118,-0.01929,-0.01740,-0.01538,-0.01337,-0.01129,-0.00922,-0.00708,-0.00494,-0.00275,-0.00055,0.00128,0.00354,0.00574,0.00800,0.01025,0.01245,0.01471,0.01691,0.01911,0.02130,0.02344,0.02558,0.02765,0.02973,0.03168,0.03363,0.03552,0.03742,0.03919,0.04090,0.04254,0.04407,0.04554,0.04694,0.04828,0.04950,0.05066,0.05170,0.05262,0.05347,0.05414,0.05481,0.05530,0.05567,0.05597,0.05609,0.05616,0.05609,0.05585,0.05555,0.05512,0.05451,0.05384,0.05298,0.05207,0.05097,0.04975,0.04840,0.04700,0.04541,0.04370,0.04193,0.03998,0.03797,0.03583,0.03357,0.03119,0.02875,0.02625,0.02356,0.02088,0.01807,0.01514,0.01221,0.00916,0.00604,0.00293,-0.00006,-0.00317,-0.00647,-0.00983,-0.01318,-0.01654,-0.01996,-0.02338,-0.02680,-0.03021,-0.03357,-0.03699,-0.04035,-0.04364,-0.04694,-0.05017,-0.05335,-0.05646,-0.05951,-0.06250,-0.06543,-0.06824,-0.07093,-0.07355,-0.07612,-0.07850,-0.08075,-0.08295,-0.08497,-0.08686,-0.08857,-0.09015,-0.09162,-0.09290,-0.09400,-0.09498,-0.09577,-0.09638,-0.09681,-0.09711,-0.09717,-0.09705,-0.09675,-0.09632,-0.09565,-0.09479,-0.09376,-0.09247,-0.09107,-0.08948,-0.08765,-0.08564,-0.08350,-0.08112,-0.07862,-0.07587,-0.07300,-0.06995,-0.06672,-0.06336,-0.05976,-0.05609,-0.05225,-0.04828,-0.04413,-0.03992,-0.03559,-0.03107,-0.02649,-0.02185,-0.01709,-0.01221,-0.00732,-0.00232,0.00232,0.00739,0.01251,0.01764,0.02283,0.02802,0.03314,0.03833,0.04346,0.04853,0.05359,0.05860,0.06354,0.06842,0.07319,0.07789,0.08246,0.08692,0.09125,0.09546,0.09949,0.10340,0.10712,0.11072,0.11408,0.11732,0.12031,0.12312,0.12568,0.12806,0.13020,0.13215,0.13380,0.13526,0.13642,0.13734,0.13801,0.13844,0.13862,0.13850,0.13807,0.13740,0.13648,0.13526,0.13380,0.13203,0.12995,0.12763,0.12507,0.12220,0.11909,0.11573,0.11207,0.10822,0.10407,0.09968,0.09504,0.09022,0.08515,0.07984,0.07435,0.06861,0.06275,0.05664,0.05042,0.04401,0.03742,0.03076,0.02393,0.01697,0.00995,0.00281,-0.00403,-0.01129,-0.01862,-0.02600,-0.03339,-0.04077,-0.04822,-0.05561,-0.06299,-0.07026,-0.07752,-0.08472,-0.09180,-0.09882,-0.10572,-0.11243,-0.11909,-0.12550,-0.13178,-0.13789,-0.14381,-0.14948,-0.15492,-0.16017,-0.16511,-0.16987,-0.17433,-0.17848,-0.18232,-0.18592,-0.18916,-0.19215,-0.19471,-0.19703,-0.19893,-0.20051,-0.20173,-0.20259,-0.20308,-0.20320,-0.20295,-0.20234,-0.20131,-0.19990,-0.19813,-0.19600,-0.19343,-0.19050,-0.18721,-0.18354,-0.17945,-0.17506,-0.17024,-0.16511,-0.15962,-0.15376,-0.14753,-0.14106,-0.13422,-0.12702,-0.11958,-0.11188,-0.10383,-0.09559,-0.08704,-0.07825,-0.06928,-0.06006,-0.05066,-0.04108,-0.03131,-0.02136,-0.01135,-0.00122,0.00867,0.01898,0.02942,0.03986,0.05036,0.06079,0.07129,0.08173,0.09217,0.10248,0.11274,0.12287,0.13288,0.14277,0.15254,0.16206,0.17140,0.18049,0.18940,0.19807,0.20643,0.21449,0.22230,0.22975,0.23689,0.24367,0.25002,0.25606,0.26167,0.26692,0.27175,0.27608,0.27999,0.28346,0.28646,0.28902,0.29103,0.29262,0.29366,0.29421,0.29427,0.29378,0.29280,0.29134,0.28932,0.28676,0.28371,0.28011,0.27602,0.27138,0.26625,0.26057,0.25441,0.24776,0.24068,0.23305,0.22493,0.21638,0.20735,0.19789,0.18800,0.17768,0.16700,0.15589,0.14442,0.13258,0.12043,0.10792,0.09510,0.08198,0.06861,0.05500,0.04114,0.02710,0.01288,-0.00116,-0.01569,-0.03040,-0.04517,-0.06006,-0.07496,-0.08991,-0.10486,-0.11982,-0.13471,-0.14955,-0.16432,-0.17897,-0.19343,-0.20778,-0.22194,-0.23592,-0.24959,-0.26308,-0.27626,-0.28914,-0.30172,-0.31392,-0.32583,-0.33730,-0.34835,-0.35897,-0.36916,-0.37887,-0.38809,-0.39681,-0.40499,-0.41262,-0.41976,-0.42630,-0.43222,-0.43759,-0.44229,-0.44638,-0.44986,-0.45273,-0.45486,-0.45639,-0.45724,-0.45736,-0.45688,-0.45566,-0.45370,-0.45114,-0.44784,-0.44381,-0.43911,-0.43374,-0.42764,-0.42086,-0.41342,-0.40524,-0.39639,-0.38693,-0.37673,-0.36593,-0.35445,-0.34237,-0.32961,-0.31630,-0.30233,-0.28780,-0.27272,-0.25703,-0.24086,-0.22413,-0.20686,-0.18916,-0.17097,-0.15229,-0.13325,-0.11372,-0.09382,-0.07355,-0.05292,-0.03198,-0.01074,0.01038,0.03217,0.05420,0.07648,0.09894,0.12159,0.14436,0.16725,0.19020,0.21327,0.23640,0.25954,0.28267,0.30574,0.32882,0.35183,0.37472,0.39749,0.42013,0.44259,0.46493,0.48697,0.50882,0.53043,0.55173,0.57273,0.59342,0.61381,0.63377,0.65342,0.67265,0.69145,0.70982,0.72771,0.74516,0.76213,0.77861,0.79460,0.80999,0.82488,0.83922,0.85302,0.86620,0.87884,0.89086,0.90228,0.91308,0.92327,0.93286,0.94183,0.95013,0.95776,0.96484,0.97119,0.97693,0.98205,0.98651,0.99036,0.99353,0.99609,0.99799,0.99927,0.99994,1,0.99945,0.99829,0.99652,0.99420,0.99127,0.98779,0.98376,0.97919,0.97406,0.96844,0.96228,0.95569,0.94861,0.94104,0.93298,0.92456,0.91564,0.90637,0.89672,0.88665,0.87627,0.86553,0.85448,0.84307,0.83141,0.81951,0.80730,0.79491,0.78227,0.76940,0.75633,0.74315,0.72978,0.71623,0.70262,0.68882,0.67497,0.66105,0.64707,0.63303,0.61900,0.60490,0.59080,0.57670,0.56260,0.54856,0.53458,0.52066,0.50681,0.49301,0.47934,0.46573,0.45230,0.43893,0.42575,0.41268,0.39974,0.38705,0.37441,0.36202,0.34981,0.33779,0.32595,0.31429,0.30287,0.29164,0.28060,0.26985,0.25923,0.24892,0.23885,0.22896,0.21931,0.20991,0.20076,0.19185,0.18318,0.17469,0.16651,0.15852,0.15083,0.14332,0.13606,0.12904,0.12220,0.11567,0.10932,0.10322,0.09730,0.09162,0.08619,0.08094,0.07587,0.07111,0.06647,0.06208,0.05786,0.05384,0.04999,0.04633,0.04291,0.03961,0.03662,0.03388,0.03144,0.02930,0.02747,0.02576,0.02399,0.02210,0.01990,0.01721,0.01422,0.01111,0.00812,0.00543,0.00324,0.00165,0.00067,0.00018,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_3d8min = {KS_RF_ROLE_EXC,30,14403,0,1,676,124,-1,"GE RF pulse: rf3d8min.rho",{((void *)0),((void *)0),0.196,0.1045,0.0954,1,1,0,0.256422,0.00549569,0.0828831,30,((void *)0),800,14403,0,0,124,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,800,{0,0.00012,0.00092,0.00269,0.00494,0.00690,0.00769,0.00769,0.00757,0.00787,0.00848,0.00928,0.01007,0.01086,0.01160,0.01239,0.01312,0.01379,0.01447,0.01508,0.01569,0.01618,0.01660,0.01697,0.01721,0.01734,0.01734,0.01727,0.01703,0.01672,0.01624,0.01556,0.01483,0.01392,0.01288,0.01166,0.01032,0.00885,0.00720,0.00543,0.00354,0.00146,-0.00037,-0.00256,-0.00494,-0.00732,-0.00983,-0.01239,-0.01502,-0.01764,-0.02020,-0.02283,-0.02539,-0.02796,-0.03040,-0.03272,-0.03491,-0.03705,-0.03894,-0.04071,-0.04230,-0.04364,-0.04474,-0.04560,-0.04621,-0.04657,-0.04663,-0.04639,-0.04590,-0.04505,-0.04395,-0.04248,-0.04071,-0.03870,-0.03632,-0.03369,-0.03076,-0.02765,-0.02423,-0.02057,-0.01672,-0.01270,-0.00855,-0.00427,0,0.00427,0.00873,0.01318,0.01764,0.02197,0.02625,0.03034,0.03424,0.03797,0.04138,0.04456,0.04737,0.04987,0.05201,0.05371,0.05500,0.05579,0.05616,0.05609,0.05548,0.05439,0.05280,0.05066,0.04810,0.04499,0.04145,0.03742,0.03296,0.02808,0.02289,0.01727,0.01135,0.00519,-0.00085,-0.00745,-0.01416,-0.02094,-0.02777,-0.03461,-0.04132,-0.04792,-0.05426,-0.06043,-0.06623,-0.07172,-0.07679,-0.08143,-0.08552,-0.08906,-0.09199,-0.09431,-0.09595,-0.09687,-0.09711,-0.09662,-0.09534,-0.09333,-0.09052,-0.08704,-0.08271,-0.07770,-0.07203,-0.06562,-0.05860,-0.05097,-0.04279,-0.03412,-0.02496,-0.01544,-0.00568,0.00409,0.01434,0.02466,0.03498,0.04529,0.05542,0.06531,0.07489,0.08405,0.09278,0.10096,0.10853,0.11536,0.12141,0.12666,0.13105,0.13447,0.13691,0.13831,0.13868,0.13801,0.13618,0.13331,0.12928,0.12421,0.11805,0.11085,0.10261,0.09345,0.08338,0.07239,0.06067,0.04822,0.03510,0.02149,0.00739,-0.00671,-0.02136,-0.03614,-0.05097,-0.06574,-0.08027,-0.09449,-0.10834,-0.12159,-0.13416,-0.14607,-0.15705,-0.16706,-0.17604,-0.18385,-0.19044,-0.19575,-0.19972,-0.20228,-0.20332,-0.20289,-0.20100,-0.19752,-0.19252,-0.18599,-0.17793,-0.16847,-0.15754,-0.14521,-0.13160,-0.11677,-0.10078,-0.08375,-0.06580,-0.04700,-0.02747,-0.00745,0.01276,0.03357,0.05457,0.07551,0.09632,0.11689,0.13697,0.15644,0.17518,0.19300,0.20979,0.22542,0.23976,0.25264,0.26399,0.27364,0.28157,0.28768,0.29189,0.29409,0.29427,0.29244,0.28847,0.28243,0.27431,0.26412,0.25191,0.23775,0.22163,0.20369,0.18397,0.16261,0.13972,0.11542,0.08985,0.06318,0.03552,0.00702,-0.02173,-0.05127,-0.08112,-0.11103,-0.14088,-0.17036,-0.19935,-0.22774,-0.25520,-0.28157,-0.30678,-0.33053,-0.35268,-0.37313,-0.39163,-0.40811,-0.42233,-0.43429,-0.44387,-0.45089,-0.45535,-0.45718,-0.45620,-0.45254,-0.44607,-0.43679,-0.42477,-0.41000,-0.39248,-0.37228,-0.34951,-0.32418,-0.29640,-0.26637,-0.23408,-0.19972,-0.16346,-0.12537,-0.08570,-0.04456,-0.00220,0.04102,0.08545,0.13062,0.17634,0.22236,0.26851,0.31466,0.36056,0.40603,0.45083,0.49490,0.53794,0.57987,0.62052,0.65965,0.69719,0.73295,0.76689,0.79875,0.82860,0.85619,0.88152,0.90447,0.92504,0.94317,0.95880,0.97192,0.98248,0.99060,0.99615,0.99933,1,0.99829,0.99432,0.98810,0.97967,0.96918,0.95672,0.94238,0.92627,0.90850,0.88921,0.86846,0.84649,0.82329,0.79912,0.77403,0.74815,0.72166,0.69462,0.66715,0.63944,0.61155,0.58359,0.55564,0.52786,0.50034,0.47317,0.44644,0.42013,0.39443,0.36941,0.34505,0.32143,0.29860,0.27663,0.25551,0.23530,0.21602,0.19770,0.18031,0.16389,0.14839,0.13380,0.12012,0.10737,0.09553,0.08454,0.07441,0.06513,0.05658,0.04889,0.04187,0.03583,0.03089,0.02710,0.02356,0.01904,0.01300,0.00690,0.00244,0.00043,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_tbw8_01_001_150 = {KS_RF_ROLE_EXC,15,26666.7,0,1,238,62,-1,"GE RF pulse: tbw8_01_001_150.rho",{((void *)0),((void *)0),0.2495,0.1458,0.1473,1,1,0,0.221475,0.00214499,0.0845575,15,((void *)0),300,26666.7,0,0,62,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},150,300,{0,-0.00726,-0.00501,-0.00519,-0.00488,-0.00427,-0.00342,-0.00201,-0.00018,0.00195,0.00488,0.00818,0.01184,0.01618,0.02081,0.02582,0.03095,0.03620,0.04138,0.04639,0.05109,0.05542,0.05884,0.06165,0.06379,0.06415,0.06366,0.06208,0.05841,0.05365,0.04749,0.03937,0.03021,0.01990,0.00800,-0.00452,-0.01782,-0.03168,-0.04566,-0.05963,-0.07282,-0.08527,-0.09669,-0.10590,-0.11365,-0.11927,-0.12159,-0.12183,-0.11927,-0.11280,-0.10407,-0.09223,-0.07673,-0.05909,-0.03882,-0.01593,0.00824,0.03382,0.06018,0.08661,0.11280,0.13734,0.16053,0.18153,0.19862,0.21309,0.22334,0.22810,0.22926,0.22475,0.21394,0.19917,0.17854,0.15211,0.12214,0.08716,0.04816,0.00684,-0.03742,-0.08307,-0.12916,-0.17518,-0.21943,-0.26198,-0.30086,-0.33480,-0.36495,-0.38833,-0.40432,-0.41488,-0.41629,-0.40896,-0.39553,-0.37179,-0.33944,-0.30104,-0.25301,-0.19777,-0.13758,-0.07007,0.00201,0.07709,0.15602,0.23628,0.31722,0.39791,0.47665,0.55374,0.62626,0.69407,0.75798,0.81401,0.86333,0.90728,0.94110,0.96753,0.98791,0.99756,1,0.99670,0.98340,0.96411,0.93994,0.90783,0.87164,0.83208,0.78734,0.74052,0.69206,0.64158,0.59086,0.53989,0.48984,0.44094,0.39309,0.34823,0.30556,0.26485,0.22847,0.19459,0.16297,0.13606,0.11152,0.08930,0.07129,0.05536,0.04138,0.03095,0.02374,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_tbw6_01_001_150 = {KS_RF_ROLE_EXC,15,20000,0,1,222,78,-1,"GE RF pulse: tbw6_01_001_150.rho",{((void *)0),((void *)0),0.288,0.1784,0.187,1,1,0,0.174412,0.00162796,0.0736649,15,((void *)0),300,20000,0,0,78,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},150,300,{0,-0.00964,-0.01190,-0.01441,-0.01709,-0.01996,-0.02295,-0.02600,-0.02905,-0.03211,-0.03510,-0.03797,-0.04053,-0.04279,-0.04468,-0.04615,-0.04700,-0.04731,-0.04694,-0.04572,-0.04376,-0.04096,-0.03723,-0.03259,-0.02698,-0.02051,-0.01306,-0.00476,0.00439,0.01422,0.02472,0.03577,0.04724,0.05896,0.07081,0.08252,0.09406,0.10511,0.11549,0.12501,0.13355,0.14076,0.14655,0.15064,0.15296,0.15333,0.15162,0.14765,0.14137,0.13276,0.12183,0.10847,0.09278,0.07489,0.05487,0.03290,0.00909,-0.01624,-0.04285,-0.07050,-0.09882,-0.12745,-0.15614,-0.18434,-0.21187,-0.23811,-0.26289,-0.28560,-0.30599,-0.32363,-0.33822,-0.34939,-0.35683,-0.36031,-0.35958,-0.35445,-0.34481,-0.33059,-0.31173,-0.28816,-0.26015,-0.22761,-0.19081,-0.14997,-0.10535,-0.05725,-0.00610,0.04785,0.10407,0.16212,0.22151,0.28182,0.34243,0.40292,0.46280,0.52146,0.57847,0.63334,0.68565,0.73497,0.78087,0.82311,0.86126,0.89514,0.92456,0.94922,0.96911,0.98413,0.99426,0.99951,1,0.99585,0.98712,0.97418,0.95709,0.93628,0.91192,0.88439,0.85406,0.82122,0.78624,0.74950,0.71135,0.67216,0.63230,0.59208,0.55185,0.51193,0.47256,0.43405,0.39663,0.36043,0.32576,0.29274,0.26143,0.23195,0.20442,0.17890,0.15528,0.13374,0.11414,0.09650,0.08063,0.06659,0.05426,0.04352,0.03430,0.02643,0.01978,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF exc_bw4_800us = {KS_RF_ROLE_EXC,30,4000,0,1,422,378,-1,"GE RF pulse: rf_bw4_800us.rho",{((void *)0),((void *)0),0.4032,0.2913,0.4032,0.9784,0.9784,0,0.0606762,0.000864594,0.0328746,30,((void *)0),800,4000,0,0,378,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,800,{0,0,0,0,0,0.00006,0.00012,0.00024,0.00043,0.00067,0.00092,0.00116,0.00140,0.00165,0.00189,0.00208,0.00232,0.00256,0.00287,0.00317,0.00348,0.00385,0.00427,0.00470,0.00519,0.00568,0.00616,0.00671,0.00732,0.00794,0.00861,0.00928,0.01001,0.01074,0.01160,0.01245,0.01331,0.01428,0.01532,0.01636,0.01746,0.01862,0.01984,0.02112,0.02240,0.02381,0.02521,0.02667,0.02826,0.02985,0.03150,0.03327,0.03510,0.03699,0.03894,0.04096,0.04309,0.04523,0.04749,0.04981,0.05225,0.05469,0.05725,0.05994,0.06269,0.06549,0.06842,0.07148,0.07459,0.07776,0.08106,0.08448,0.08796,0.09150,0.09522,0.09901,0.10285,0.10688,0.11097,0.11518,0.11945,0.12385,0.12836,0.13300,0.13770,0.14253,0.14747,0.15254,0.15766,0.16291,0.16828,0.17378,0.17939,0.18507,0.19087,0.19685,0.20289,0.20900,0.21528,0.22163,0.22816,0.23476,0.24141,0.24825,0.25514,0.26216,0.26930,0.27651,0.28377,0.29122,0.29866,0.30629,0.31398,0.32180,0.32967,0.33761,0.34566,0.35384,0.36208,0.37038,0.37875,0.38723,0.39578,0.40438,0.41305,0.42178,0.43063,0.43948,0.44845,0.45743,0.46646,0.47555,0.48465,0.49387,0.50302,0.51230,0.52152,0.53079,0.54013,0.54947,0.55881,0.56815,0.57755,0.58695,0.59629,0.60569,0.61503,0.62443,0.63377,0.64304,0.65238,0.66160,0.67082,0.68003,0.68913,0.69822,0.70726,0.71623,0.72514,0.73399,0.74272,0.75145,0.76006,0.76854,0.77696,0.78533,0.79357,0.80168,0.80968,0.81762,0.82543,0.83306,0.84063,0.84807,0.85534,0.86254,0.86956,0.87640,0.88311,0.88970,0.89611,0.90234,0.90844,0.91436,0.92010,0.92565,0.93103,0.93621,0.94122,0.94604,0.95062,0.95508,0.95935,0.96338,0.96722,0.97088,0.97436,0.97760,0.98065,0.98352,0.98608,0.98852,0.99066,0.99261,0.99432,0.99585,0.99707,0.99811,0.99896,0.99951,0.99988,1,0.99988,0.99957,0.99902,0.99829,0.99725,0.99603,0.99463,0.99298,0.99109,0.98901,0.98669,0.98419,0.98138,0.97845,0.97528,0.97186,0.96826,0.96448,0.96045,0.95617,0.95178,0.94714,0.94232,0.93731,0.93206,0.92669,0.92108,0.91534,0.90936,0.90325,0.89697,0.89056,0.88390,0.87713,0.87023,0.86315,0.85595,0.84856,0.84105,0.83342,0.82567,0.81780,0.80980,0.80162,0.79338,0.78502,0.77654,0.76799,0.75932,0.75053,0.74168,0.73271,0.72368,0.71458,0.70543,0.69621,0.68693,0.67759,0.66825,0.65885,0.64945,0.63993,0.63047,0.62089,0.61137,0.60178,0.59214,0.58256,0.57291,0.56333,0.55368,0.54410,0.53452,0.52493,0.51541,0.50589,0.49643,0.48697,0.47751,0.46817,0.45883,0.44955,0.44040,0.43124,0.42214,0.41317,0.40420,0.39529,0.38650,0.37777,0.36904,0.36043,0.35189,0.34347,0.33510,0.32680,0.31862,0.31050,0.30257,0.29463,0.28688,0.27919,0.27162,0.26418,0.25685,0.24959,0.24251,0.23543,0.22853,0.22169,0.21498,0.20839,0.20192,0.19557,0.18934,0.18324,0.17726,0.17140,0.16560,0.15998,0.15449,0.14912,0.14381,0.13868,0.13361,0.12873,0.12391,0.11921,0.11457,0.11011,0.10578,0.10151,0.09736,0.09339,0.08948,0.08570,0.08198,0.07843,0.07496,0.07160,0.06830,0.06513,0.06208,0.05909,0.05622,0.05347,0.05078,0.04822,0.04572,0.04334,0.04102,0.03882,0.03668,0.03467,0.03266,0.03076,0.02893,0.02710,0.02539,0.02374,0.02216,0.02063,0.01917,0.01782,0.01654,0.01538,0.01428,0.01331,0.01245,0.01166,0.01099,0.01038,0.00971,0.00909,0.00830,0.00745,0.00647,0.00537,0.00421,0.00311,0.00208,0.00122,0.00061,0.00024,0.00006,0,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ssfp_tbw2_1_01 = {KS_RF_ROLE_EXC,90,4000,0,1,250,250,-1,"GE RF pulse: tbw2_1_01.rho",{((void *)0),((void *)0),0.5947,0.444,0.5947,1,1,0,0.197458,0.00865607,0.131576,90,((void *)0),500,4000,0,0,250,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,500,{0,0.10230,0.10749,0.11268,0.11805,0.12348,0.12916,0.13508,0.14124,0.14759,0.15406,0.16059,0.16688,0.17298,0.17939,0.18824,0.19410,0.20155,0.20906,0.21644,0.22407,0.23164,0.23946,0.24715,0.25520,0.26332,0.27181,0.28011,0.28847,0.29677,0.30599,0.31441,0.32338,0.33230,0.34139,0.35061,0.35989,0.36922,0.37862,0.38802,0.39755,0.40719,0.41690,0.42648,0.43618,0.44619,0.45596,0.46579,0.47580,0.48569,0.49570,0.50571,0.51578,0.52579,0.53592,0.54599,0.55613,0.56626,0.57633,0.58628,0.59653,0.60648,0.61655,0.62650,0.63645,0.64634,0.65623,0.66606,0.67582,0.68547,0.69511,0.70469,0.71422,0.72362,0.73289,0.74217,0.75127,0.76030,0.76927,0.77806,0.78685,0.79540,0.80394,0.81224,0.82055,0.82854,0.83654,0.84435,0.85204,0.85949,0.86694,0.87408,0.88110,0.88799,0.89471,0.90118,0.90753,0.91369,0.91967,0.92547,0.93103,0.93640,0.94165,0.94659,0.95135,0.95593,0.96026,0.96441,0.96832,0.97198,0.97546,0.97870,0.98175,0.98456,0.98712,0.98944,0.99152,0.99341,0.99506,0.99646,0.99768,0.99860,0.99927,0.99976,1,1,0.99976,0.99927,0.99860,0.99768,0.99646,0.99506,0.99341,0.99152,0.98944,0.98712,0.98456,0.98175,0.97870,0.97546,0.97198,0.96832,0.96441,0.96026,0.95593,0.95135,0.94659,0.94165,0.93640,0.93103,0.92547,0.91967,0.91369,0.90753,0.90118,0.89471,0.88799,0.88110,0.87408,0.86694,0.85949,0.85204,0.84435,0.83654,0.82854,0.82055,0.81224,0.80394,0.79540,0.78685,0.77806,0.76927,0.76030,0.75127,0.74217,0.73289,0.72362,0.71422,0.70469,0.69511,0.68547,0.67582,0.66606,0.65623,0.64634,0.63645,0.62650,0.61655,0.60648,0.59653,0.58628,0.57633,0.56626,0.55613,0.54599,0.53592,0.52579,0.51578,0.50571,0.49570,0.48569,0.47580,0.46579,0.45596,0.44619,0.43618,0.42648,0.41690,0.40719,0.39755,0.38802,0.37862,0.36922,0.35989,0.35061,0.34139,0.33230,0.32338,0.31441,0.30599,0.29677,0.28847,0.28011,0.27181,0.26332,0.25520,0.24715,0.23946,0.23164,0.22407,0.21644,0.20906,0.20155,0.19410,0.18824,0.17939,0.17298,0.16688,0.16059,0.15406,0.14759,0.14124,0.13508,0.12916,0.12348,0.11805,0.11268,0.10749,0.10230,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ssfp_tbw3_01_001_pm_250 = {KS_RF_ROLE_EXC,45,6000,0,1,250,250,-1,"GE RF pulse: tbw3_01_001_pm_250.rho",{((void *)0),((void *)0),0.4121,0.3,0.4112,1,1,0,0.142811,0.00305924,0.0782207,45,((void *)0),500,6000,0,0,250,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,500,{0,-0.01666,-0.00732,-0.00238,-0.00214,-0.00189,-0.00146,-0.00098,-0.00037,0.00037,0.00110,0.00208,0.00311,0.00427,0.00562,0.00696,0.00861,0.01032,0.01221,0.01428,0.01642,0.01892,0.02149,0.02423,0.02728,0.03034,0.03382,0.03742,0.04120,0.04535,0.04950,0.05414,0.05884,0.06379,0.06916,0.07447,0.08039,0.08643,0.09266,0.09937,0.10602,0.11329,0.12067,0.12824,0.13630,0.14442,0.15302,0.16181,0.17079,0.18031,0.18983,0.19984,0.21003,0.22035,0.23122,0.24208,0.25343,0.26491,0.27657,0.28871,0.30080,0.31331,0.32601,0.33877,0.35201,0.36526,0.37875,0.39242,0.40609,0.42013,0.43423,0.44845,0.46280,0.47720,0.49179,0.50638,0.52109,0.53580,0.55057,0.56534,0.58011,0.59488,0.60960,0.62437,0.63896,0.65354,0.66801,0.68229,0.69664,0.71061,0.72459,0.73839,0.75188,0.76543,0.77837,0.79131,0.80400,0.81627,0.82854,0.84014,0.85168,0.86285,0.87347,0.88415,0.89398,0.90368,0.91302,0.92169,0.93042,0.93817,0.94574,0.95294,0.95935,0.96582,0.97125,0.97644,0.98126,0.98523,0.98914,0.99206,0.99475,0.99701,0.99835,0.99969,1,1,0.99969,0.99835,0.99701,0.99475,0.99206,0.98914,0.98523,0.98126,0.97644,0.97125,0.96582,0.95935,0.95294,0.94574,0.93817,0.93042,0.92169,0.91302,0.90368,0.89398,0.88415,0.87347,0.86285,0.85168,0.84014,0.82854,0.81627,0.80400,0.79131,0.77837,0.76543,0.75188,0.73839,0.72459,0.71061,0.69664,0.68229,0.66801,0.65354,0.63896,0.62437,0.60960,0.59488,0.58011,0.56534,0.55057,0.53580,0.52109,0.50638,0.49179,0.47720,0.46280,0.44845,0.43423,0.42013,0.40609,0.39242,0.37875,0.36526,0.35201,0.33877,0.32601,0.31331,0.30080,0.28871,0.27657,0.26491,0.25343,0.24208,0.23122,0.22035,0.21003,0.19984,0.18983,0.18031,0.17079,0.16181,0.15302,0.14442,0.13630,0.12824,0.12067,0.11329,0.10602,0.09937,0.09266,0.08643,0.08039,0.07447,0.06916,0.06379,0.05884,0.05414,0.04950,0.04535,0.04120,0.03742,0.03382,0.03034,0.02728,0.02423,0.02149,0.01892,0.01642,0.01428,0.01221,0.01032,0.00861,0.00696,0.00562,0.00427,0.00311,0.00208,0.00110,0.00037,-0.00037,-0.00098,-0.00146,-0.00189,-0.00214,-0.00238,-0.00732,-0.01666,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ssfp_3d_600us_01p_01s_10khz = {KS_RF_ROLE_EXC,45,10089.4,0,1,298,302,-1,"GE RF pulse: rf3d_600us_01p_01s_10khz.rho",{((void *)0),((void *)0),0.2211,0.1456,0.1665,0.3356,0.3356,0,0.29395,0.00754861,0.112165,45,((void *)0),600,10089.4,0,0,302,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},300,600,{0,0,0.00006,0.00037,0.00092,0.00195,0.00360,0.00586,0.00818,0.01001,0.01068,0.01062,0.01038,0.01056,0.01141,0.01257,0.01373,0.01483,0.01587,0.01685,0.01788,0.01886,0.01984,0.02081,0.02167,0.02252,0.02326,0.02393,0.02454,0.02503,0.02539,0.02570,0.02582,0.02582,0.02564,0.02533,0.02484,0.02417,0.02332,0.02222,0.02100,0.01953,0.01782,0.01593,0.01373,0.01135,0.00879,0.00592,0.00287,-0.00024,-0.00372,-0.00745,-0.01141,-0.01563,-0.01996,-0.02454,-0.02924,-0.03412,-0.03919,-0.04431,-0.04956,-0.05487,-0.06031,-0.06574,-0.07117,-0.07660,-0.08198,-0.08722,-0.09241,-0.09742,-0.10230,-0.10694,-0.11133,-0.11542,-0.11921,-0.12269,-0.12568,-0.12830,-0.13044,-0.13203,-0.13313,-0.13361,-0.13343,-0.13270,-0.13123,-0.12904,-0.12611,-0.12238,-0.11781,-0.11249,-0.10627,-0.09919,-0.09119,-0.08234,-0.07251,-0.06177,-0.05011,-0.03748,-0.02393,-0.00946,0.00574,0.02210,0.03931,0.05750,0.07654,0.09644,0.11713,0.13862,0.16090,0.18385,0.20753,0.23183,0.25673,0.28212,0.30806,0.33437,0.36111,0.38809,0.41537,0.44278,0.47037,0.49789,0.52548,0.55289,0.58017,0.60721,0.63389,0.66014,0.68595,0.71123,0.73582,0.75975,0.78288,0.80522,0.82659,0.84698,0.86639,0.88464,0.90173,0.91760,0.93219,0.94549,0.95739,0.96795,0.97699,0.98462,0.99078,0.99536,0.99847,1,1,0.99847,0.99536,0.99078,0.98462,0.97699,0.96795,0.95739,0.94549,0.93219,0.91760,0.90173,0.88464,0.86639,0.84698,0.82659,0.80522,0.78288,0.75975,0.73582,0.71123,0.68595,0.66014,0.63389,0.60721,0.58017,0.55289,0.52548,0.49789,0.47037,0.44278,0.41537,0.38809,0.36111,0.33437,0.30806,0.28212,0.25673,0.23183,0.20753,0.18385,0.16090,0.13862,0.11713,0.09644,0.07654,0.05750,0.03931,0.02210,0.00574,-0.00946,-0.02393,-0.03748,-0.05011,-0.06177,-0.07251,-0.08234,-0.09119,-0.09919,-0.10627,-0.11249,-0.11781,-0.12238,-0.12611,-0.12904,-0.13123,-0.13270,-0.13343,-0.13361,-0.13313,-0.13203,-0.13044,-0.12830,-0.12568,-0.12269,-0.11921,-0.11542,-0.11133,-0.10694,-0.10230,-0.09742,-0.09241,-0.08722,-0.08198,-0.07660,-0.07117,-0.06574,-0.06031,-0.05487,-0.04956,-0.04431,-0.03919,-0.03412,-0.02924,-0.02454,-0.01996,-0.01563,-0.01141,-0.00745,-0.00372,-0.00024,0.00287,0.00592,0.00879,0.01135,0.01373,0.01593,0.01782,0.01953,0.02100,0.02222,0.02332,0.02417,0.02484,0.02533,0.02564,0.02582,0.02582,0.02570,0.02539,0.02503,0.02454,0.02393,0.02326,0.02252,0.02167,0.02081,0.01984,0.01886,0.01788,0.01685,0.01587,0.01483,0.01373,0.01257,0.01141,0.01056,0.01038,0.01062,0.01068,0.01001,0.00818,0.00586,0.00360,0.00195,0.00092,0.00037,0.00006,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF excnonsel_fermi100 = {KS_RF_ROLE_EXC,15,12000,0,1,50,50,-1,"GE RF pulse: fermi100.rho",{((void *)0),((void *)0),0.6865,0.6374,0.6865,1,1,0,0.142549,0.00129516,0.113805,15,((void *)0),100,12000,0,0,50,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},50,100,{0,0.00577,0.01303,0.02905,0.06342,0.13273,0.25676,0.43765,0.63657,0.79772,0.89886,0.95248,0.97836,0.99029,0.99564,0.99808,0.99911,0.99960,0.99982,0.99991,0.99997,0.99997,1,1,1,1,1,1,0.99997,0.99997,0.99991,0.99982,0.99957,0.99908,0.99799,0.99548,0.98990,0.97748,0.95065,0.89517,0.79122,0.62730,0.42788,0.24919,0.12821,0.06107,0.02796,0.01251,0.00555,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ref_se1b4 = {KS_RF_ROLE_REF,180,905,0,1,1600,1600,-1,"GE RF pulse: rfse1b4.rho",{((void *)0),((void *)0),0.2874,0.1799,0.1867,0.4486,0.4486,0,0.177,0.01803,0.0751,180,((void *)0),3200,905,0,0,1600,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,3200,{0,-0.00427,-0.00647,-0.00879,-0.01111,-0.01349,-0.01587,-0.01831,-0.02081,-0.02338,-0.02594,-0.02857,-0.03119,-0.03388,-0.03656,-0.03931,-0.04206,-0.04480,-0.04761,-0.05042,-0.05323,-0.05609,-0.05890,-0.06177,-0.06464,-0.06745,-0.07032,-0.07319,-0.07599,-0.07886,-0.08167,-0.08448,-0.08722,-0.08997,-0.09272,-0.09540,-0.09809,-0.10071,-0.10334,-0.10590,-0.10841,-0.11091,-0.11329,-0.11567,-0.11799,-0.12025,-0.12244,-0.12452,-0.12659,-0.12861,-0.13050,-0.13233,-0.13404,-0.13569,-0.13728,-0.13874,-0.14015,-0.14143,-0.14259,-0.14369,-0.14466,-0.14552,-0.14625,-0.14686,-0.14735,-0.14778,-0.14802,-0.14814,-0.14814,-0.14802,-0.14771,-0.14729,-0.14674,-0.14601,-0.14515,-0.14417,-0.14301,-0.14167,-0.14021,-0.13856,-0.13673,-0.13477,-0.13264,-0.13032,-0.12788,-0.12519,-0.12238,-0.11933,-0.11616,-0.11280,-0.10920,-0.10548,-0.10157,-0.09742,-0.09308,-0.08863,-0.08393,-0.07898,-0.07392,-0.06861,-0.06311,-0.05744,-0.05158,-0.04547,-0.03919,-0.03272,-0.02600,-0.01911,-0.01196,-0.00464,0.00269,0.01044,0.01837,0.02649,0.03485,0.04340,0.05219,0.06116,0.07038,0.07972,0.08936,0.09913,0.10914,0.11939,0.12977,0.14039,0.15125,0.16224,0.17347,0.18489,0.19648,0.20833,0.22035,0.23250,0.24489,0.25746,0.27016,0.28310,0.29622,0.30947,0.32290,0.33645,0.35018,0.36410,0.37814,0.39230,0.40658,0.42105,0.43557,0.45022,0.46499,0.47983,0.49472,0.50974,0.52475,0.53989,0.55503,0.57016,0.58536,0.60056,0.61570,0.63084,0.64591,0.66093,0.67588,0.69078,0.70549,0.72014,0.73454,0.74889,0.76299,0.77684,0.79051,0.80394,0.81707,0.82995,0.84246,0.85467,0.86651,0.87798,0.88909,0.89971,0.90997,0.91973,0.92901,0.93780,0.94604,0.95379,0.96094,0.96759,0.97363,0.97906,0.98389,0.98810,0.99170,0.99463,0.99695,0.99860,0.99963,1,0.99969,0.99878,0.99713,0.99493,0.99200,0.98852,0.98437,0.97955,0.97418,0.96820,0.96167,0.95453,0.94690,0.93866,0.92993,0.92071,0.91101,0.90081,0.89025,0.87920,0.86779,0.85595,0.84380,0.83129,0.81847,0.80535,0.79198,0.77831,0.76445,0.75041,0.73613,0.72166,0.70707,0.69236,0.67753,0.66258,0.64756,0.63248,0.61741,0.60221,0.58707,0.57187,0.55674,0.54160,0.52646,0.51144,0.49643,0.48154,0.46670,0.45193,0.43728,0.42276,0.40829,0.39401,0.37984,0.36581,0.35189,0.33816,0.32454,0.31112,0.29787,0.28475,0.27181,0.25905,0.24654,0.23415,0.22194,0.20991,0.19807,0.18647,0.17506,0.16383,0.15278,0.14192,0.13129,0.12086,0.11066,0.10065,0.09083,0.08124,0.07184,0.06263,0.05365,0.04486,0.03632,0.02796,0.01978,0.01184,0.00409,-0.00330,-0.01062,-0.01770,-0.02460,-0.03131,-0.03784,-0.04413,-0.05023,-0.05616,-0.06183,-0.06733,-0.07264,-0.07770,-0.08265,-0.08735,-0.09186,-0.09620,-0.10029,-0.10425,-0.10798,-0.11158,-0.11494,-0.11817,-0.12116,-0.12403,-0.12672,-0.12922,-0.13154,-0.13368,-0.13563,-0.13746,-0.13911,-0.14057,-0.14192,-0.14308,-0.14411,-0.14497,-0.14570,-0.14631,-0.14674,-0.14698,-0.14716,-0.14716,-0.14704,-0.14680,-0.14643,-0.14594,-0.14533,-0.14460,-0.14375,-0.14283,-0.14173,-0.14057,-0.13929,-0.13795,-0.13648,-0.13490,-0.13325,-0.13154,-0.12971,-0.12782,-0.12586,-0.12385,-0.12171,-0.11958,-0.11732,-0.11500,-0.11268,-0.11024,-0.10779,-0.10529,-0.10273,-0.10016,-0.09754,-0.09485,-0.09217,-0.08948,-0.08674,-0.08399,-0.08118,-0.07837,-0.07557,-0.07276,-0.06989,-0.06708,-0.06421,-0.06141,-0.05854,-0.05573,-0.05292,-0.05011,-0.04731,-0.04456,-0.04181,-0.03906,-0.03632,-0.03363,-0.03101,-0.02838,-0.02576,-0.02319,-0.02069,-0.01819,-0.01575,-0.01337,-0.01099,-0.00867,-0.00641,-0.00421,-0.00201,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ref_fse1601 = {KS_RF_ROLE_REF,173.916,800,0,1,1600,1600,-1,"GE RF pulse: rffse1601.rho",{((void *)0),((void *)0),0.2918,0.2026,0.2636,0.5423,0.5423,0,0.13494,0.0116042,0.0602188,173.916,((void *)0),3200,800,0,0,1600,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},320,3200,{0,0.04499,0.03577,0.02954,0.02484,0.02106,0.01770,0.01471,0.01190,0.00934,0.00678,0.00439,0.00201,-0.00018,-0.00250,-0.00488,-0.00708,-0.00940,-0.01172,-0.01392,-0.01618,-0.01837,-0.02057,-0.02283,-0.02503,-0.02710,-0.02924,-0.03137,-0.03345,-0.03546,-0.03742,-0.03937,-0.04126,-0.04309,-0.04474,-0.04651,-0.04804,-0.04962,-0.05097,-0.05231,-0.05359,-0.05463,-0.05567,-0.05658,-0.05732,-0.05793,-0.05841,-0.05878,-0.05890,-0.05896,-0.05884,-0.05854,-0.05805,-0.05738,-0.05652,-0.05548,-0.05420,-0.05280,-0.05109,-0.04920,-0.04706,-0.04468,-0.04218,-0.03937,-0.03626,-0.03296,-0.02942,-0.02558,-0.02149,-0.01709,-0.01257,-0.00763,-0.00244,0.00281,0.00861,0.01459,0.02088,0.02747,0.03443,0.04157,0.04908,0.05689,0.06488,0.07337,0.08204,0.09107,0.10029,0.10987,0.11976,0.12995,0.14045,0.15119,0.16230,0.17366,0.18531,0.19716,0.20942,0.22200,0.23463,0.24770,0.26100,0.27455,0.28829,0.30239,0.31661,0.33120,0.34585,0.36080,0.37588,0.39126,0.40670,0.42245,0.43820,0.45419,0.47024,0.48648,0.50278,0.51914,0.53556,0.55222,0.56870,0.58524,0.60190,0.61832,0.63487,0.65128,0.66764,0.68388,0.69999,0.71593,0.73167,0.74724,0.76256,0.77770,0.79247,0.80693,0.82110,0.83489,0.84832,0.86126,0.87389,0.88604,0.89752,0.90862,0.91925,0.92919,0.93859,0.94751,0.95562,0.96319,0.97003,0.97626,0.98181,0.98657,0.99066,0.99402,0.99664,0.99854,0.99963,1,0.99969,0.99847,0.99664,0.99402,0.99066,0.98657,0.98175,0.97626,0.97009,0.96319,0.95562,0.94745,0.93859,0.92919,0.91918,0.90869,0.89752,0.88592,0.87383,0.86126,0.84832,0.83483,0.82103,0.80693,0.79241,0.77757,0.76250,0.74718,0.73161,0.71586,0.69993,0.68382,0.66758,0.65122,0.63480,0.61832,0.60172,0.58518,0.56864,0.55210,0.53556,0.51914,0.50272,0.48642,0.47018,0.45413,0.43820,0.42233,0.40670,0.39114,0.37588,0.36074,0.34579,0.33107,0.31655,0.30233,0.28829,0.27449,0.26094,0.24763,0.23463,0.22188,0.20936,0.19716,0.18519,0.17359,0.16218,0.15113,0.14039,0.12995,0.11970,0.10981,0.10023,0.09095,0.08198,0.07325,0.06488,0.05683,0.04901,0.04151,0.03430,0.02741,0.02081,0.01453,0.00855,0.00275,-0.00256,-0.00769,-0.01257,-0.01721,-0.02155,-0.02564,-0.02948,-0.03302,-0.03638,-0.03943,-0.04218,-0.04480,-0.04718,-0.04926,-0.05115,-0.05280,-0.05426,-0.05555,-0.05658,-0.05744,-0.05811,-0.05860,-0.05890,-0.05902,-0.05902,-0.05884,-0.05848,-0.05799,-0.05738,-0.05664,-0.05573,-0.05475,-0.05365,-0.05243,-0.05109,-0.04969,-0.04816,-0.04657,-0.04486,-0.04315,-0.04132,-0.03943,-0.03754,-0.03559,-0.03351,-0.03144,-0.02936,-0.02722,-0.02509,-0.02289,-0.02069,-0.01849,-0.01624,-0.01398,-0.01172,-0.00946,-0.00720,-0.00488,-0.00262,-0.00031,0.00189,0.00427,0.00671,0.00922,0.01184,0.01465,0.01758,0.02094,0.02478,0.02948,0.03565,0.04486,0.06250,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ref_fse1602 = {KS_RF_ROLE_REF,158.341,800,0,1,1600,1600,-1,"GE RF pulse: rffse1602.rho",{((void *)0),((void *)0),0.3713,0.2617,0.3713,1,1,0,0.08724,0.00630358,0.0443832,158.341,((void *)0),3200,800,0,0,1600,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},320,3200,{0,0.05390,0.04517,0.03980,0.03614,0.03345,0.03131,0.02960,0.02820,0.02704,0.02600,0.02515,0.02435,0.02368,0.02313,0.02258,0.02216,0.02179,0.02149,0.02124,0.02112,0.02100,0.02094,0.02100,0.02112,0.02130,0.02155,0.02185,0.02228,0.02283,0.02338,0.02411,0.02484,0.02576,0.02674,0.02783,0.02905,0.03034,0.03180,0.03333,0.03504,0.03687,0.03882,0.04090,0.04309,0.04547,0.04798,0.05066,0.05353,0.05652,0.05963,0.06299,0.06647,0.07013,0.07398,0.07801,0.08216,0.08655,0.09113,0.09589,0.10084,0.10596,0.11133,0.11683,0.12257,0.12849,0.13465,0.14094,0.14747,0.15425,0.16120,0.16835,0.17567,0.18324,0.19099,0.19899,0.20717,0.21553,0.22407,0.23286,0.24184,0.25099,0.26033,0.26991,0.27962,0.28957,0.29964,0.30996,0.32039,0.33101,0.34182,0.35274,0.36391,0.37514,0.38656,0.39816,0.40982,0.42166,0.43356,0.44564,0.45779,0.47006,0.48245,0.49490,0.50742,0.52005,0.53269,0.54538,0.55814,0.57090,0.58371,0.59653,0.60935,0.62217,0.63499,0.64774,0.66044,0.67314,0.68571,0.69822,0.71068,0.72301,0.73521,0.74736,0.75932,0.77110,0.78276,0.79424,0.80553,0.81658,0.82744,0.83812,0.84850,0.85869,0.86858,0.87817,0.88751,0.89654,0.90527,0.91363,0.92169,0.92944,0.93676,0.94378,0.95038,0.95666,0.96252,0.96795,0.97296,0.97760,0.98181,0.98559,0.98895,0.99188,0.99438,0.99640,0.99799,0.99908,0.99976,1,0.99976,0.99908,0.99799,0.99640,0.99438,0.99188,0.98895,0.98559,0.98181,0.97760,0.97296,0.96795,0.96246,0.95666,0.95038,0.94378,0.93676,0.92938,0.92169,0.91363,0.90527,0.89654,0.88751,0.87817,0.86858,0.85869,0.84850,0.83812,0.82744,0.81658,0.80553,0.79424,0.78276,0.77110,0.75932,0.74736,0.73521,0.72301,0.71068,0.69822,0.68571,0.67314,0.66044,0.64774,0.63499,0.62217,0.60935,0.59653,0.58371,0.57090,0.55814,0.54538,0.53269,0.51999,0.50742,0.49490,0.48245,0.47006,0.45779,0.44564,0.43356,0.42166,0.40982,0.39810,0.38656,0.37514,0.36385,0.35274,0.34182,0.33101,0.32039,0.30989,0.29964,0.28951,0.27962,0.26985,0.26033,0.25099,0.24184,0.23286,0.22407,0.21553,0.20710,0.19899,0.19099,0.18324,0.17567,0.16835,0.16120,0.15425,0.14747,0.14094,0.13465,0.12849,0.12257,0.11683,0.11127,0.10596,0.10084,0.09589,0.09113,0.08655,0.08216,0.07801,0.07398,0.07013,0.06647,0.06299,0.05963,0.05652,0.05353,0.05066,0.04798,0.04547,0.04309,0.04090,0.03876,0.03681,0.03504,0.03333,0.03180,0.03034,0.02899,0.02783,0.02674,0.02576,0.02484,0.02405,0.02338,0.02277,0.02228,0.02185,0.02155,0.02130,0.02112,0.02100,0.02094,0.02100,0.02112,0.02124,0.02149,0.02179,0.02216,0.02258,0.02313,0.02368,0.02435,0.02515,0.02600,0.02704,0.02820,0.02960,0.03131,0.03345,0.03614,0.03980,0.04517,0.05384,0.07178,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ref_fse160n = {KS_RF_ROLE_REF,160.145,800,0,1,1600,1600,-1,"GE RF pulse: rffse160n.rho",{((void *)0),((void *)0),0.4224,0.3018,0.4224,1,1,0,0.07755,0.0057596,0.0424249,160.145,((void *)0),3200,800,0,0,1600,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},320,3200,{0,0.00800,0.00775,0.00787,0.00824,0.00873,0.00934,0.01007,0.01080,0.01166,0.01264,0.01361,0.01471,0.01587,0.01709,0.01837,0.01978,0.02124,0.02277,0.02442,0.02612,0.02796,0.02985,0.03180,0.03388,0.03607,0.03833,0.04065,0.04315,0.04572,0.04840,0.05121,0.05408,0.05713,0.06025,0.06348,0.06684,0.07032,0.07392,0.07764,0.08149,0.08552,0.08961,0.09388,0.09821,0.10273,0.10737,0.11219,0.11707,0.12214,0.12733,0.13270,0.13813,0.14375,0.14955,0.15547,0.16151,0.16767,0.17402,0.18055,0.18715,0.19392,0.20088,0.20796,0.21516,0.22249,0.22999,0.23769,0.24544,0.25337,0.26143,0.26967,0.27797,0.28646,0.29506,0.30385,0.31270,0.32167,0.33083,0.34005,0.34945,0.35891,0.36855,0.37826,0.38809,0.39797,0.40804,0.41818,0.42837,0.43869,0.44906,0.45956,0.47012,0.48074,0.49142,0.50217,0.51297,0.52384,0.53476,0.54569,0.55667,0.56766,0.57871,0.58976,0.60081,0.61185,0.62290,0.63389,0.64494,0.65592,0.66685,0.67778,0.68864,0.69944,0.71019,0.72087,0.73149,0.74199,0.75237,0.76268,0.77287,0.78295,0.79290,0.80272,0.81237,0.82183,0.83117,0.84032,0.84936,0.85815,0.86675,0.87511,0.88329,0.89129,0.89904,0.90655,0.91381,0.92077,0.92755,0.93402,0.94024,0.94622,0.95184,0.95721,0.96228,0.96704,0.97156,0.97571,0.97955,0.98303,0.98627,0.98914,0.99164,0.99384,0.99573,0.99725,0.99847,0.99933,0.99982,1,0.99982,0.99933,0.99847,0.99725,0.99573,0.99384,0.99164,0.98914,0.98627,0.98303,0.97949,0.97571,0.97149,0.96704,0.96228,0.95721,0.95184,0.94616,0.94024,0.93402,0.92755,0.92077,0.91375,0.90649,0.89904,0.89129,0.88329,0.87511,0.86675,0.85815,0.84930,0.84032,0.83117,0.82183,0.81231,0.80266,0.79290,0.78295,0.77287,0.76268,0.75237,0.74199,0.73143,0.72087,0.71019,0.69944,0.68864,0.67778,0.66685,0.65592,0.64494,0.63389,0.62284,0.61179,0.60074,0.58970,0.57865,0.56766,0.55661,0.54563,0.53470,0.52377,0.51297,0.50211,0.49136,0.48068,0.47006,0.45950,0.44906,0.43863,0.42831,0.41812,0.40798,0.39797,0.38802,0.37820,0.36849,0.35891,0.34939,0.34005,0.33077,0.32167,0.31264,0.30379,0.29506,0.28646,0.27797,0.26961,0.26143,0.25337,0.24544,0.23762,0.22999,0.22249,0.21510,0.20790,0.20082,0.19392,0.18715,0.18049,0.17402,0.16767,0.16145,0.15540,0.14948,0.14375,0.13813,0.13264,0.12733,0.12208,0.11707,0.11213,0.10737,0.10273,0.09821,0.09382,0.08961,0.08545,0.08149,0.07764,0.07392,0.07032,0.06684,0.06342,0.06018,0.05707,0.05408,0.05115,0.04834,0.04572,0.04309,0.04065,0.03827,0.03601,0.03382,0.03174,0.02979,0.02789,0.02612,0.02435,0.02277,0.02124,0.01978,0.01837,0.01703,0.01581,0.01465,0.01361,0.01257,0.01166,0.01080,0.01001,0.00934,0.00873,0.00818,0.00787,0.00769,0.00800,0.00928,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF ref_ssfse155 = {KS_RF_ROLE_REF,155,1280,0,1,600,600,-1,"GE RF pulse: rfssfse155.rho",{((void *)0),((void *)0),0.4009,0.2809,0.3507,0.7333,0.7333,0,0.24,0.0194606,0.127347,155,((void *)0),1200,1280,0,0,600,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},120,1200,{0,-0.00708,-0.03308,-0.09119,-0.17573,-0.25197,-0.28163,-0.24574,-0.17286,-0.09955,-0.05451,-0.03382,-0.02570,-0.01923,-0.01160,-0.00269,0.00739,0.01880,0.03144,0.04529,0.06031,0.07660,0.09418,0.11311,0.13319,0.15455,0.17701,0.20063,0.22542,0.25130,0.27822,0.30605,0.33486,0.36446,0.39480,0.42581,0.45736,0.48935,0.52170,0.55429,0.58689,0.61942,0.65165,0.68351,0.71489,0.74553,0.77532,0.80400,0.83135,0.85717,0.88146,0.90399,0.92462,0.94323,0.95971,0.97375,0.98492,0.99286,0.99774,1,1,0.99774,0.99286,0.98492,0.97375,0.95971,0.94323,0.92462,0.90399,0.88146,0.85717,0.83135,0.80400,0.77532,0.74553,0.71489,0.68351,0.65165,0.61942,0.58689,0.55429,0.52170,0.48935,0.45736,0.42581,0.39480,0.36446,0.33486,0.30605,0.27822,0.25130,0.22542,0.20063,0.17701,0.15455,0.13319,0.11311,0.09418,0.07660,0.06031,0.04529,0.03144,0.01880,0.00739,-0.00269,-0.01160,-0.01923,-0.02570,-0.03382,-0.05451,-0.09955,-0.17286,-0.24574,-0.28163,-0.25197,-0.17573,-0.09119,-0.03308,-0.00708,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF refnonsel_fermi124 = {KS_RF_ROLE_REF,90,4032.3,0,1,124,124,-1,"GE RF pulse: fermi124.rho",{((void *)0),((void *)0),0.929,0.9026,0.929,0.9839,0.9839,0,0.254896,0.0145434,0.242163,90,((void *)0),248,4032.3,0,0,124,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},124,248,{0,0.22267,0.32082,0.43780,0.56217,0.67915,0.77730,0.85195,0.90463,0.93991,0.96264,0.97702,0.98593,0.99139,0.99475,0.99683,0.99805,0.99881,0.99927,0.99954,0.99973,0.99982,0.99988,0.99994,0.99994,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,1,1,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99997,0.99994,0.99994,0.99988,0.99982,0.99973,0.99954,0.99927,0.99881,0.99805,0.99683,0.99475,0.99139,0.98593,0.97702,0.96264,0.93991,0.90463,0.85195,0.77730,0.67915,0.56217,0.43780,0.32082,0.22267,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF adinv_shNvrg5b = {KS_RF_ROLE_INV,43.82,1185.18,0,1,4320,4320,-1,"GE RF pulse: shNvrg5b.rho",{((void *)0),((void *)0),0.4634,0.3099,0.4634,1,1,0,0.02934,0.00230333,0.0163276,43.82,((void *)0),8640,1185.18,0,0,4320,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},432,8640,{0,0.08121,0.08243,0.08365,0.08491,0.08619,0.08747,0.08878,0.09012,0.09147,0.09281,0.09421,0.09562,0.09705,0.09849,0.09995,0.10145,0.10297,0.10450,0.10606,0.10764,0.10926,0.11088,0.11253,0.11420,0.11591,0.11765,0.11939,0.12116,0.12299,0.12482,0.12666,0.12855,0.13047,0.13239,0.13438,0.13636,0.13841,0.14045,0.14256,0.14466,0.14680,0.14900,0.15119,0.15342,0.15571,0.15803,0.16035,0.16273,0.16514,0.16758,0.17005,0.17259,0.17512,0.17771,0.18034,0.18299,0.18568,0.18843,0.19120,0.19401,0.19688,0.19978,0.20271,0.20567,0.20869,0.21177,0.21486,0.21803,0.22120,0.22444,0.22774,0.23103,0.23442,0.23784,0.24129,0.24480,0.24837,0.25197,0.25563,0.25932,0.26311,0.26689,0.27077,0.27467,0.27861,0.28264,0.28670,0.29082,0.29500,0.29921,0.30349,0.30782,0.31221,0.31667,0.32116,0.32573,0.33034,0.33501,0.33974,0.34453,0.34939,0.35427,0.35924,0.36425,0.36935,0.37447,0.37969,0.38494,0.39028,0.39565,0.40109,0.40661,0.41217,0.41778,0.42346,0.42923,0.43502,0.44088,0.44680,0.45279,0.45883,0.46493,0.47110,0.47729,0.48358,0.48990,0.49631,0.50275,0.50925,0.51581,0.52240,0.52905,0.53577,0.54254,0.54935,0.55622,0.56311,0.57007,0.57706,0.58411,0.59119,0.59833,0.60548,0.61268,0.61991,0.62717,0.63444,0.64176,0.64912,0.65647,0.66386,0.67128,0.67869,0.68611,0.69355,0.70100,0.70845,0.71589,0.72331,0.73076,0.73817,0.74559,0.75298,0.76036,0.76769,0.77501,0.78227,0.78951,0.79671,0.80385,0.81096,0.81798,0.82497,0.83187,0.83870,0.84548,0.85216,0.85876,0.86526,0.87167,0.87798,0.88421,0.89028,0.89626,0.90212,0.90786,0.91348,0.91894,0.92425,0.92944,0.93447,0.93936,0.94406,0.94864,0.95300,0.95721,0.96127,0.96512,0.96878,0.97226,0.97555,0.97864,0.98154,0.98425,0.98672,0.98901,0.99109,0.99295,0.99460,0.99603,0.99722,0.99823,0.99899,0.99954,0.99988,1,0.99988,0.99954,0.99899,0.99823,0.99722,0.99603,0.99460,0.99295,0.99109,0.98901,0.98672,0.98425,0.98154,0.97864,0.97555,0.97226,0.96878,0.96512,0.96127,0.95721,0.95300,0.94864,0.94406,0.93936,0.93447,0.92944,0.92425,0.91894,0.91348,0.90786,0.90212,0.89626,0.89028,0.88421,0.87798,0.87167,0.86526,0.85876,0.85216,0.84548,0.83870,0.83187,0.82497,0.81798,0.81096,0.80385,0.79671,0.78951,0.78227,0.77501,0.76769,0.76036,0.75298,0.74559,0.73817,0.73076,0.72331,0.71589,0.70845,0.70100,0.69355,0.68611,0.67869,0.67128,0.66386,0.65647,0.64912,0.64176,0.63444,0.62717,0.61991,0.61268,0.60548,0.59833,0.59119,0.58411,0.57706,0.57007,0.56311,0.55622,0.54935,0.54254,0.53577,0.52905,0.52240,0.51581,0.50925,0.50275,0.49631,0.48990,0.48358,0.47729,0.47110,0.46493,0.45883,0.45279,0.44680,0.44088,0.43502,0.42923,0.42346,0.41778,0.41217,0.40661,0.40109,0.39565,0.39028,0.38494,0.37969,0.37447,0.36935,0.36425,0.35924,0.35427,0.34939,0.34453,0.33974,0.33501,0.33034,0.32573,0.32116,0.31667,0.31221,0.30782,0.30349,0.29921,0.29500,0.29082,0.28670,0.28264,0.27861,0.27467,0.27077,0.26689,0.26311,0.25932,0.25563,0.25197,0.24837,0.24480,0.24129,0.23784,0.23442,0.23103,0.22774,0.22444,0.22120,0.21803,0.21486,0.21177,0.20869,0.20567,0.20271,0.19978,0.19688,0.19401,0.19120,0.18843,0.18568,0.18299,0.18034,0.17771,0.17512,0.17259,0.17005,0.16758,0.16514,0.16273,0.16035,0.15803,0.15571,0.15342,0.15119,0.14900,0.14680,0.14466,0.14256,0.14045,0.13841,0.13636,0.13438,0.13239,0.13047,0.12855,0.12666,0.12482,0.12299,0.12116,0.11939,0.11765,0.11591,0.11420,0.11253,0.11088,0.10926,0.10764,0.10606,0.10450,0.10297,0.10145,0.09995,0.09849,0.09705,0.09562,0.09421,0.09281,0.09147,0.09012,0.08878,0.08747,0.08619,0.08491,0.08365,0.08243,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},432,8640,{-3.510,0.769,5.054,9.333,13.613,17.892,22.172,26.451,30.731,35.005,39.284,43.563,47.837,52.111,56.385,60.665,64.939,69.207,73.481,77.755,82.023,86.297,90.566,94.834,99.103,103.366,107.634,111.897,116.166,120.428,124.691,128.949,133.212,137.469,141.732,145.984,150.242,154.499,158.751,163.003,167.255,171.507,175.754,180.000,-178.198,-173.952,-169.711,-165.470,-161.229,-156.993,-152.758,-148.522,-144.292,-140.062,-135.832,-131.608,-127.383,-123.159,-118.940,-114.721,-110.507,-106.294,-102.086,-97.878,-93.670,-89.467,-85.270,-81.073,-76.882,-72.690,-68.498,-64.318,-60.137,-55.957,-51.782,-47.612,-43.448,-39.284,-35.125,-30.967,-26.819,-22.672,-18.530,-14.393,-10.262,-6.131,-2.011,2.110,6.224,10.328,14.431,18.524,22.617,26.698,30.780,34.851,38.916,42.970,47.024,51.068,55.105,59.132,63.153,67.164,71.168,75.168,79.156,83.133,87.105,91.060,95.010,98.954,102.882,106.799,110.710,114.605,118.489,122.368,126.230,130.075,133.915,137.739,141.546,145.342,149.127,152.895,156.647,160.383,164.102,167.810,171.496,175.166,178.824,-179.984,-176.363,-172.765,-169.189,-165.629,-162.086,-158.570,-155.070,-151.599,-148.143,-144.710,-141.304,-137.925,-134.563,-131.229,-127.922,-124.642,-121.390,-118.160,-114.962,-111.793,-108.656,-105.547,-102.465,-99.416,-96.400,-93.417,-90.472,-87.555,-84.677,-81.831,-79.024,-76.250,-73.514,-70.822,-68.163,-65.548,-62.972,-60.439,-57.945,-55.495,-53.089,-50.727,-48.414,-46.140,-43.915,-41.740,-39.608,-37.532,-35.499,-33.516,-31.588,-29.709,-27.880,-26.105,-24.386,-22.716,-21.106,-19.546,-18.046,-16.601,-15.211,-13.882,-12.613,-11.399,-10.240,-9.147,-8.114,-7.136,-6.224,-5.373,-4.582,-3.851,-3.186,-2.582,-2.044,-1.566,-1.148,-0.797,-0.511,-0.286,-0.126,-0.033,0.000,-0.033,-0.126,-0.286,-0.511,-0.797,-1.148,-1.566,-2.044,-2.582,-3.186,-3.851,-4.582,-5.373,-6.224,-7.136,-8.114,-9.147,-10.240,-11.399,-12.613,-13.882,-15.211,-16.601,-18.046,-19.546,-21.106,-22.716,-24.386,-26.105,-27.880,-29.709,-31.588,-33.516,-35.499,-37.532,-39.608,-41.740,-43.915,-46.140,-48.414,-50.727,-53.089,-55.495,-57.945,-60.439,-62.972,-65.548,-68.163,-70.822,-73.514,-76.250,-79.024,-81.831,-84.677,-87.555,-90.472,-93.417,-96.400,-99.416,-102.465,-105.547,-108.656,-111.793,-114.962,-118.160,-121.390,-124.642,-127.922,-131.229,-134.563,-137.925,-141.304,-144.710,-148.143,-151.599,-155.070,-158.570,-162.086,-165.629,-169.189,-172.765,-176.363,-179.984,178.824,175.166,171.496,167.810,164.102,160.383,156.647,152.895,149.127,145.342,141.546,137.739,133.915,130.075,126.230,122.368,118.489,114.605,110.710,106.799,102.882,98.954,95.010,91.060,87.105,83.133,79.156,75.168,71.168,67.164,63.153,59.132,55.105,51.068,47.024,42.970,38.916,34.851,30.780,26.698,22.617,18.524,14.431,10.328,6.224,2.110,-2.011,-6.131,-10.262,-14.393,-18.530,-22.672,-26.819,-30.967,-35.125,-39.284,-43.448,-47.612,-51.782,-55.957,-60.137,-64.318,-68.498,-72.690,-76.882,-81.073,-85.270,-89.467,-93.670,-97.878,-102.086,-106.294,-110.507,-114.721,-118.940,-123.159,-127.383,-131.608,-135.832,-140.062,-144.292,-148.522,-152.758,-156.993,-161.229,-165.470,-169.711,-173.952,-178.198,180.000,175.754,171.507,167.255,163.003,158.751,154.499,150.242,145.984,141.732,137.469,133.212,128.949,124.691,120.428,116.166,111.897,107.634,103.366,99.103,94.834,90.566,86.297,82.023,77.755,73.481,69.207,64.939,60.665,56.385,52.111,47.837,43.563,39.284,35.005,30.731,26.451,22.172,17.892,13.613,9.333,5.054,0.764},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)}};
const KS_RF adinv_sh3t2 = {KS_RF_ROLE_INV,250,1500,0,1,8000,8000,-1,"GE RF pulse: sh3t2.rho",{((void *)0),((void *)0),0.539,0.3732,0.539,1,1,0,0.125,0.00110705,0.0130766,250,((void *)0),16000,1500,0,0,8000,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,16000,{0,0.14197,0.14386,0.14579,0.14771,0.14966,0.15168,0.15366,0.15571,0.15778,0.15986,0.16199,0.16413,0.16630,0.16849,0.17072,0.17298,0.17527,0.17759,0.17994,0.18232,0.18473,0.18717,0.18961,0.19211,0.19465,0.19721,0.19980,0.20243,0.20508,0.20780,0.21052,0.21326,0.21607,0.21891,0.22178,0.22468,0.22761,0.23057,0.23359,0.23664,0.23972,0.24284,0.24601,0.24921,0.25245,0.25571,0.25904,0.26240,0.26579,0.26923,0.27271,0.27622,0.27979,0.28339,0.28703,0.29072,0.29444,0.29823,0.30204,0.30589,0.30979,0.31376,0.31776,0.32179,0.32588,0.33000,0.33418,0.33842,0.34266,0.34700,0.35136,0.35575,0.36021,0.36473,0.36927,0.37388,0.37852,0.38322,0.38795,0.39274,0.39760,0.40248,0.40742,0.41240,0.41743,0.42253,0.42766,0.43284,0.43806,0.44334,0.44865,0.45402,0.45946,0.46492,0.47041,0.47597,0.48158,0.48723,0.49293,0.49867,0.50444,0.51027,0.51616,0.52208,0.52803,0.53404,0.54009,0.54616,0.55226,0.55843,0.56462,0.57085,0.57714,0.58342,0.58977,0.59612,0.60253,0.60894,0.61541,0.62188,0.62838,0.63491,0.64147,0.64803,0.65462,0.66124,0.66787,0.67449,0.68114,0.68780,0.69445,0.70110,0.70779,0.71444,0.72112,0.72777,0.73443,0.74105,0.74767,0.75430,0.76089,0.76745,0.77401,0.78054,0.78701,0.79348,0.79989,0.80627,0.81262,0.81890,0.82516,0.83132,0.83746,0.84353,0.84954,0.85549,0.86135,0.86715,0.87286,0.87851,0.88406,0.88952,0.89489,0.90017,0.90536,0.91043,0.91540,0.92026,0.92499,0.92962,0.93414,0.93851,0.94278,0.94690,0.95090,0.95474,0.95846,0.96203,0.96545,0.96872,0.97186,0.97482,0.97766,0.98032,0.98282,0.98514,0.98733,0.98932,0.99115,0.99283,0.99432,0.99564,0.99680,0.99777,0.99857,0.99918,0.99963,0.99991,1,0.99991,0.99963,0.99918,0.99857,0.99777,0.99680,0.99564,0.99432,0.99283,0.99115,0.98932,0.98733,0.98514,0.98282,0.98032,0.97766,0.97482,0.97186,0.96872,0.96545,0.96203,0.95846,0.95474,0.95090,0.94690,0.94278,0.93851,0.93414,0.92962,0.92499,0.92026,0.91540,0.91043,0.90536,0.90017,0.89489,0.88952,0.88406,0.87851,0.87286,0.86715,0.86135,0.85549,0.84954,0.84353,0.83746,0.83132,0.82516,0.81890,0.81262,0.80627,0.79989,0.79348,0.78701,0.78054,0.77401,0.76745,0.76089,0.75430,0.74767,0.74105,0.73443,0.72777,0.72112,0.71444,0.70779,0.70110,0.69445,0.68780,0.68114,0.67449,0.66787,0.66124,0.65462,0.64803,0.64147,0.63491,0.62838,0.62188,0.61541,0.60894,0.60253,0.59612,0.58977,0.58342,0.57714,0.57085,0.56462,0.55843,0.55226,0.54616,0.54009,0.53404,0.52803,0.52208,0.51616,0.51027,0.50444,0.49867,0.49293,0.48723,0.48158,0.47597,0.47041,0.46492,0.45946,0.45402,0.44865,0.44334,0.43806,0.43284,0.42766,0.42253,0.41743,0.41240,0.40742,0.40248,0.39760,0.39274,0.38795,0.38322,0.37852,0.37388,0.36927,0.36473,0.36021,0.35575,0.35136,0.34700,0.34266,0.33842,0.33418,0.33000,0.32588,0.32179,0.31776,0.31376,0.30979,0.30589,0.30204,0.29823,0.29444,0.29072,0.28703,0.28339,0.27979,0.27622,0.27271,0.26923,0.26579,0.26240,0.25904,0.25571,0.25245,0.24921,0.24601,0.24284,0.23972,0.23664,0.23359,0.23057,0.22761,0.22468,0.22178,0.21891,0.21607,0.21326,0.21052,0.20780,0.20508,0.20243,0.19980,0.19721,0.19465,0.19211,0.18961,0.18717,0.18473,0.18232,0.17994,0.17759,0.17527,0.17298,0.17072,0.16849,0.16630,0.16413,0.16199,0.15986,0.15778,0.15571,0.15366,0.15168,0.14966,0.14771,0.14579,0.14386,0.14197,0.14011,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,16000,{142.342,128.086,113.836,99.586,85.342,71.102,56.869,42.635,28.407,14.184,-0.027,-14.239,-28.445,-42.652,-56.847,-71.036,-85.226,-99.405,-113.578,-127.746,-141.908,-156.065,-170.216,175.649,161.509,147.385,133.261,119.149,105.041,90.945,76.854,62.769,48.700,34.631,20.579,6.532,-7.499,-21.529,-35.543,-49.551,-63.549,-77.535,-91.511,-105.475,-119.423,-133.366,-147.292,-161.207,-175.111,171.007,157.131,143.270,129.421,115.589,101.773,87.967,74.184,60.412,46.656,32.923,19.200,5.499,-8.174,-21.837,-35.483,-49.106,-62.714,-76.294,-89.857,-103.399,-116.913,-130.410,-143.880,-157.323,-170.743,175.863,162.498,149.154,135.838,122.549,109.293,96.065,82.869,69.702,56.567,43.465,30.396,17.359,4.362,-8.597,-21.524,-34.411,-47.261,-60.071,-72.844,-85.572,-98.257,-110.903,-123.499,-136.052,-148.555,-161.014,-173.424,174.221,161.915,149.659,137.458,125.312,113.221,101.185,89.209,77.294,65.439,53.650,41.921,30.258,18.661,7.136,-4.318,-15.706,-27.017,-38.257,-49.425,-60.511,-71.514,-82.441,-93.285,-104.047,-114.721,-125.312,-135.810,-146.215,-156.532,-166.750,-176.874,173.106,163.179,153.351,143.633,134.014,124.505,115.105,105.821,96.647,87.583,78.639,69.817,61.115,52.534,44.080,35.752,27.550,19.480,11.547,3.741,-3.917,-11.443,-18.826,-26.072,-33.170,-40.125,-46.931,-53.584,-60.088,-66.433,-72.630,-78.667,-84.539,-90.258,-95.812,-101.201,-106.420,-111.480,-116.363,-121.082,-125.625,-129.993,-134.190,-138.205,-142.051,-145.710,-149.192,-152.494,-155.609,-158.542,-161.295,-163.860,-166.239,-168.425,-170.430,-172.243,-173.869,-175.303,-176.550,-177.605,-178.467,-179.138,-179.621,-179.907,-180.005,-179.907,-179.621,-179.138,-178.467,-177.605,-176.550,-175.303,-173.869,-172.243,-170.430,-168.425,-166.239,-163.860,-161.295,-158.542,-155.609,-152.494,-149.192,-145.710,-142.051,-138.205,-134.190,-129.993,-125.625,-121.082,-116.363,-111.480,-106.420,-101.201,-95.812,-90.258,-84.539,-78.667,-72.630,-66.433,-60.088,-53.584,-46.931,-40.125,-33.170,-26.072,-18.826,-11.443,-3.917,3.741,11.547,19.480,27.550,35.752,44.080,52.534,61.115,69.817,78.639,87.583,96.647,105.821,115.105,124.505,134.014,143.633,153.351,163.179,173.106,-176.874,-166.750,-156.532,-146.215,-135.810,-125.312,-114.721,-104.047,-93.285,-82.441,-71.514,-60.511,-49.425,-38.257,-27.017,-15.706,-4.318,7.136,18.661,30.258,41.921,53.650,65.439,77.294,89.209,101.185,113.221,125.312,137.458,149.659,161.915,174.221,-173.424,-161.014,-148.555,-136.052,-123.499,-110.903,-98.257,-85.572,-72.844,-60.071,-47.261,-34.411,-21.524,-8.597,4.362,17.359,30.396,43.465,56.567,69.702,82.869,96.065,109.293,122.549,135.838,149.154,162.498,175.863,-170.743,-157.323,-143.880,-130.410,-116.913,-103.399,-89.857,-76.294,-62.714,-49.106,-35.483,-21.837,-8.174,5.499,19.200,32.923,46.656,60.412,74.184,87.967,101.773,115.589,129.421,143.270,157.131,171.007,-175.111,-161.207,-147.292,-133.366,-119.423,-105.475,-91.511,-77.535,-63.549,-49.551,-35.543,-21.529,-7.499,6.532,20.579,34.631,48.700,62.769,76.854,90.945,105.041,119.149,133.261,147.385,161.509,175.649,-170.216,-156.065,-141.908,-127.746,-113.578,-99.405,-85.226,-71.036,-56.847,-42.652,-28.445,-14.239,-0.027,14.184,28.407,42.635,56.869,71.102,85.342,99.586,113.836,128.086,142.342,156.603},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)}};
const KS_RF inv_invI0 = {KS_RF_ROLE_INV,178,777.8,0,1,2500,2500,-1,"GE RF pulse: rfinvI0.rho",{((void *)0),((void *)0),0.2172,0.127,0.1312,0.3133,0.3133,0,0.1791,0.02037,0.0638,178,((void *)0),5000,777.8,0,0,2500,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},250,5000,{0,0.00098,0.00476,0.01325,0.02863,0.05109,0.07612,0.09815,0.11140,0.11085,0.09864,0.07984,0.05970,0.04383,0.03400,0.02875,0.02643,0.02527,0.02405,0.02258,0.02088,0.01898,0.01685,0.01453,0.01196,0.00922,0.00623,0.00299,-0.00043,-0.00409,-0.00800,-0.01209,-0.01636,-0.02075,-0.02539,-0.03015,-0.03510,-0.04016,-0.04535,-0.05060,-0.05603,-0.06147,-0.06696,-0.07251,-0.07813,-0.08368,-0.08924,-0.09479,-0.10023,-0.10554,-0.11079,-0.11585,-0.12080,-0.12550,-0.12995,-0.13422,-0.13813,-0.14173,-0.14497,-0.14790,-0.15034,-0.15241,-0.15406,-0.15516,-0.15577,-0.15577,-0.15516,-0.15400,-0.15217,-0.14973,-0.14655,-0.14271,-0.13807,-0.13264,-0.12635,-0.11921,-0.11121,-0.10236,-0.09272,-0.08216,-0.07074,-0.05841,-0.04523,-0.03119,-0.01618,-0.00012,0.01685,0.03491,0.05414,0.07435,0.09553,0.11774,0.14100,0.16523,0.19050,0.21681,0.24416,0.27242,0.30165,0.33169,0.36257,0.39419,0.42654,0.45956,0.49319,0.52725,0.56162,0.59623,0.63078,0.66514,0.69914,0.73259,0.76518,0.79674,0.82695,0.85564,0.88238,0.90704,0.92919,0.94879,0.96545,0.97906,0.98944,0.99646,1,1,0.99646,0.98944,0.97906,0.96545,0.94879,0.92919,0.90704,0.88238,0.85564,0.82695,0.79674,0.76518,0.73253,0.69914,0.66514,0.63078,0.59623,0.56162,0.52725,0.49319,0.45956,0.42654,0.39419,0.36257,0.33169,0.30165,0.27242,0.24416,0.21681,0.19050,0.16523,0.14100,0.11774,0.09553,0.07428,0.05408,0.03491,0.01679,-0.00018,-0.01618,-0.03119,-0.04529,-0.05848,-0.07074,-0.08216,-0.09272,-0.10242,-0.11127,-0.11927,-0.12641,-0.13270,-0.13813,-0.14271,-0.14662,-0.14973,-0.15223,-0.15400,-0.15522,-0.15577,-0.15577,-0.15522,-0.15406,-0.15248,-0.15040,-0.14790,-0.14503,-0.14173,-0.13813,-0.13422,-0.13001,-0.12550,-0.12080,-0.11591,-0.11079,-0.10560,-0.10023,-0.09479,-0.08930,-0.08375,-0.07813,-0.07258,-0.06702,-0.06147,-0.05603,-0.05066,-0.04535,-0.04016,-0.03510,-0.03021,-0.02545,-0.02081,-0.01636,-0.01209,-0.00800,-0.00415,-0.00043,0.00293,0.00616,0.00916,0.01196,0.01453,0.01685,0.01898,0.02088,0.02252,0.02399,0.02521,0.02637,0.02869,0.03394,0.04383,0.05970,0.07978,0.09858,0.11079,0.11133,0.09815,0.07605,0.05109,0.02863,0.01325,0.00470,0.00098,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF spsp_ss1528822 = {KS_RF_ROLE_EXC,90,2571,0,1,7200,7200,576,"GE RF pulse: ss1528822.rho",{((void *)0),((void *)0),0.128,0.0636,0.1071,0.1828,0.0757,0,0.03807,0.00133,0.0096,90,((void *)0),14400,2571,0,0,7200,1,((void *)0),1,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},3600,14400,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00003,0.00003,0.00003,0.00003,0.00003,0.00006,0.00006,0.00006,0.00009,0.00009,0.00012,0.00012,0.00015,0.00015,0.00018,0.00021,0.00024,0.00027,0.00031,0.00037,0.00040,0.00046,0.00052,0.00055,0.00061,0.00067,0.00076,0.00082,0.00092,0.00101,0.00110,0.00119,0.00131,0.00140,0.00153,0.00165,0.00180,0.00195,0.00211,0.00226,0.00244,0.00259,0.00281,0.00299,0.00320,0.00342,0.00363,0.00388,0.00409,0.00436,0.00461,0.00488,0.00516,0.00546,0.00574,0.00604,0.00638,0.00668,0.00702,0.00735,0.00769,0.00806,0.00842,0.00879,0.00916,0.00952,0.00989,0.01028,0.01065,0.01105,0.01141,0.01181,0.01221,0.01260,0.01300,0.01340,0.01382,0.01422,0.01462,0.01498,0.01538,0.01575,0.01611,0.01648,0.01682,0.01715,0.01749,0.01782,0.01813,0.01843,0.01874,0.01904,0.01929,0.01956,0.01981,0.02002,0.02023,0.02042,0.02060,0.02075,0.02091,0.02103,0.02115,0.02124,0.02133,0.02139,0.02145,0.02149,0.02149,0.02152,0.02149,0.02149,0.02142,0.02139,0.02130,0.02121,0.02112,0.02097,0.02084,0.02066,0.02051,0.02033,0.02014,0.01993,0.01971,0.01947,0.01923,0.01898,0.01871,0.01843,0.01816,0.01785,0.01758,0.01727,0.01694,0.01663,0.01630,0.01596,0.01563,0.01529,0.01495,0.01462,0.01425,0.01392,0.01355,0.01321,0.01285,0.01251,0.01215,0.01181,0.01144,0.01111,0.01074,0.01041,0.01004,0.00970,0.00937,0.00903,0.00873,0.00839,0.00809,0.00775,0.00745,0.00714,0.00687,0.00656,0.00626,0.00598,0.00571,0.00543,0.00519,0.00494,0.00470,0.00446,0.00421,0.00400,0.00378,0.00357,0.00330,0.00308,0.00287,0.00266,0.00247,0.00229,0.00211,0.00195,0.00180,0.00168,0.00153,0.00143,0.00131,0.00122,0.00110,0.00104,0.00095,0.00085,0.00079,0.00073,0.00067,0.00061,0.00055,0.00052,0.00046,0.00043,0.00040,0.00037,0.00034,0.00031,0.00027,0.00024,0.00024,0.00021,0.00021,0.00018,0.00018,0.00015,0.00015,0.00012,0.00012,0.00009,0.00009,0.00006,0.00006,0.00003,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00003,0.00006,0.00006,0.00009,0.00009,0.00012,0.00015,0.00015,0.00018,0.00021,0.00024,0.00027,0.00027,0.00031,0.00034,0.00037,0.00040,0.00043,0.00049,0.00052,0.00058,0.00064,0.00073,0.00079,0.00089,0.00098,0.00107,0.00119,0.00128,0.00143,0.00156,0.00171,0.00189,0.00208,0.00229,0.00250,0.00275,0.00299,0.00330,0.00360,0.00391,0.00427,0.00467,0.00510,0.00552,0.00604,0.00656,0.00711,0.00772,0.00827,0.00882,0.00940,0.01004,0.01068,0.01132,0.01202,0.01276,0.01349,0.01428,0.01508,0.01593,0.01679,0.01767,0.01859,0.01953,0.02051,0.02149,0.02252,0.02356,0.02466,0.02576,0.02689,0.02805,0.02921,0.03043,0.03165,0.03290,0.03418,0.03546,0.03677,0.03809,0.03943,0.04080,0.04218,0.04355,0.04495,0.04636,0.04776,0.04920,0.05063,0.05206,0.05350,0.05493,0.05637,0.05783,0.05927,0.06070,0.06211,0.06351,0.06491,0.06632,0.06766,0.06900,0.07035,0.07166,0.07294,0.07419,0.07541,0.07660,0.07776,0.07889,0.07999,0.08106,0.08209,0.08307,0.08402,0.08493,0.08579,0.08661,0.08741,0.08811,0.08881,0.08942,0.09000,0.09052,0.09098,0.09137,0.09171,0.09201,0.09223,0.09241,0.09253,0.09259,0.09259,0.09256,0.09244,0.09226,0.09204,0.09177,0.09140,0.09101,0.09055,0.09006,0.08948,0.08884,0.08817,0.08744,0.08667,0.08585,0.08499,0.08408,0.08310,0.08209,0.08106,0.07996,0.07883,0.07767,0.07648,0.07523,0.07398,0.07270,0.07138,0.07004,0.06867,0.06726,0.06586,0.06442,0.06299,0.06153,0.06006,0.05860,0.05710,0.05564,0.05414,0.05264,0.05115,0.04965,0.04816,0.04666,0.04520,0.04370,0.04227,0.04080,0.03940,0.03797,0.03659,0.03519,0.03385,0.03250,0.03119,0.02988,0.02863,0.02738,0.02615,0.02496,0.02380,0.02268,0.02158,0.02048,0.01944,0.01843,0.01743,0.01648,0.01553,0.01462,0.01358,0.01260,0.01169,0.01083,0.01001,0.00928,0.00858,0.00790,0.00729,0.00674,0.00623,0.00571,0.00528,0.00485,0.00446,0.00409,0.00375,0.00345,0.00314,0.00290,0.00266,0.00241,0.00223,0.00201,0.00186,0.00168,0.00153,0.00140,0.00128,0.00119,0.00110,0.00101,0.00095,0.00085,0.00079,0.00073,0.00067,0.00061,0.00055,0.00049,0.00043,0.00037,0.00031,0.00024,0.00021,0.00015,0.00012,0.00009,0.00006,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00006,0.00009,0.00012,0.00018,0.00021,0.00027,0.00034,0.00040,0.00049,0.00055,0.00064,0.00073,0.00079,0.00089,0.00098,0.00107,0.00116,0.00125,0.00134,0.00146,0.00162,0.00177,0.00195,0.00217,0.00238,0.00262,0.00290,0.00317,0.00351,0.00385,0.00424,0.00467,0.00510,0.00562,0.00616,0.00674,0.00739,0.00809,0.00882,0.00964,0.01056,0.01151,0.01254,0.01367,0.01489,0.01621,0.01761,0.01914,0.02078,0.02252,0.02435,0.02600,0.02774,0.02954,0.03140,0.03336,0.03537,0.03748,0.03967,0.04193,0.04425,0.04666,0.04917,0.05173,0.05435,0.05707,0.05988,0.06275,0.06571,0.06870,0.07181,0.07495,0.07819,0.08148,0.08484,0.08826,0.09174,0.09531,0.09891,0.10254,0.10623,0.10999,0.11374,0.11756,0.12140,0.12531,0.12922,0.13318,0.13712,0.14109,0.14505,0.14905,0.15302,0.15699,0.16095,0.16492,0.16886,0.17277,0.17664,0.18052,0.18430,0.18806,0.19175,0.19538,0.19895,0.20249,0.20594,0.20930,0.21256,0.21577,0.21888,0.22187,0.22477,0.22755,0.23023,0.23280,0.23527,0.23759,0.23978,0.24183,0.24378,0.24555,0.24720,0.24870,0.25007,0.25126,0.25233,0.25324,0.25398,0.25459,0.25501,0.25529,0.25541,0.25535,0.25513,0.25480,0.25428,0.25361,0.25278,0.25178,0.25062,0.24934,0.24787,0.24625,0.24451,0.24265,0.24064,0.23847,0.23618,0.23377,0.23121,0.22855,0.22575,0.22285,0.21982,0.21671,0.21351,0.21021,0.20682,0.20334,0.19980,0.19617,0.19248,0.18873,0.18491,0.18107,0.17713,0.17319,0.16919,0.16520,0.16114,0.15708,0.15299,0.14893,0.14484,0.14075,0.13666,0.13260,0.12857,0.12452,0.12052,0.11655,0.11261,0.10874,0.10486,0.10105,0.09729,0.09360,0.08994,0.08634,0.08280,0.07935,0.07596,0.07263,0.06937,0.06619,0.06311,0.06009,0.05713,0.05426,0.05148,0.04880,0.04617,0.04361,0.04117,0.03882,0.03641,0.03378,0.03131,0.02896,0.02680,0.02478,0.02289,0.02115,0.01950,0.01798,0.01657,0.01526,0.01404,0.01288,0.01184,0.01090,0.00998,0.00916,0.00839,0.00766,0.00702,0.00644,0.00586,0.00537,0.00488,0.00446,0.00406,0.00369,0.00339,0.00308,0.00284,0.00259,0.00241,0.00223,0.00208,0.00192,0.00177,0.00162,0.00146,0.00131,0.00116,0.00101,0.00089,0.00073,0.00061,0.00049,0.00040,0.00031,0.00024,0.00018,0.00012,0.00009,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00009,0.00012,0.00015,0.00021,0.00031,0.00040,0.00049,0.00061,0.00076,0.00092,0.00107,0.00125,0.00143,0.00162,0.00180,0.00198,0.00217,0.00235,0.00256,0.00278,0.00299,0.00327,0.00357,0.00394,0.00433,0.00476,0.00525,0.00580,0.00638,0.00702,0.00772,0.00848,0.00931,0.01019,0.01120,0.01227,0.01346,0.01471,0.01608,0.01758,0.01923,0.02100,0.02289,0.02493,0.02716,0.02957,0.03217,0.03497,0.03797,0.04123,0.04471,0.04843,0.05228,0.05573,0.05936,0.06314,0.06708,0.07117,0.07538,0.07978,0.08432,0.08902,0.09387,0.09885,0.10404,0.10935,0.11481,0.12043,0.12619,0.13211,0.13816,0.14435,0.15067,0.15717,0.16376,0.17048,0.17731,0.18427,0.19135,0.19852,0.20582,0.21317,0.22062,0.22816,0.23576,0.24342,0.25114,0.25889,0.26670,0.27454,0.28239,0.29026,0.29814,0.30604,0.31388,0.32173,0.32951,0.33726,0.34495,0.35255,0.36012,0.36756,0.37492,0.38218,0.38929,0.39631,0.40318,0.40989,0.41646,0.42283,0.42903,0.43507,0.44087,0.44649,0.45186,0.45705,0.46193,0.46663,0.47105,0.47523,0.47914,0.48280,0.48616,0.48924,0.49208,0.49458,0.49681,0.49870,0.50029,0.50160,0.50258,0.50325,0.50359,0.50365,0.50340,0.50282,0.50194,0.50072,0.49922,0.49739,0.49528,0.49287,0.49016,0.48714,0.48384,0.48027,0.47642,0.47230,0.46791,0.46324,0.45836,0.45323,0.44783,0.44224,0.43641,0.43040,0.42421,0.41780,0.41124,0.40446,0.39753,0.39048,0.38331,0.37599,0.36857,0.36103,0.35340,0.34568,0.33787,0.33003,0.32212,0.31419,0.30619,0.29817,0.29017,0.28217,0.27418,0.26618,0.25822,0.25031,0.24241,0.23457,0.22684,0.21915,0.21155,0.20405,0.19660,0.18928,0.18207,0.17499,0.16797,0.16114,0.15439,0.14780,0.14133,0.13501,0.12882,0.12284,0.11695,0.11127,0.10569,0.10031,0.09507,0.09000,0.08509,0.08032,0.07575,0.07132,0.06677,0.06189,0.05728,0.05298,0.04898,0.04523,0.04175,0.03851,0.03549,0.03272,0.03012,0.02768,0.02542,0.02338,0.02145,0.01968,0.01804,0.01651,0.01511,0.01382,0.01263,0.01157,0.01056,0.00964,0.00879,0.00800,0.00729,0.00662,0.00604,0.00552,0.00507,0.00464,0.00430,0.00397,0.00369,0.00342,0.00314,0.00287,0.00262,0.00235,0.00208,0.00180,0.00153,0.00128,0.00107,0.00085,0.00067,0.00052,0.00040,0.00031,0.00021,0.00015,0.00009,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00009,0.00015,0.00021,0.00027,0.00040,0.00052,0.00067,0.00085,0.00107,0.00131,0.00159,0.00186,0.00217,0.00247,0.00278,0.00308,0.00339,0.00369,0.00400,0.00433,0.00470,0.00510,0.00552,0.00604,0.00665,0.00732,0.00806,0.00888,0.00977,0.01074,0.01181,0.01297,0.01425,0.01563,0.01712,0.01877,0.02057,0.02252,0.02463,0.02689,0.02939,0.03207,0.03500,0.03815,0.04154,0.04520,0.04917,0.05341,0.05802,0.06296,0.06827,0.07398,0.08011,0.08625,0.09186,0.09775,0.10392,0.11029,0.11689,0.12372,0.13083,0.13816,0.14573,0.15351,0.16156,0.16987,0.17838,0.18714,0.19614,0.20536,0.21479,0.22446,0.23432,0.24439,0.25468,0.26514,0.27580,0.28663,0.29762,0.30876,0.32008,0.33155,0.34312,0.35484,0.36665,0.37855,0.39051,0.40257,0.41469,0.42686,0.43907,0.45125,0.46342,0.47563,0.48781,0.49989,0.51195,0.52391,0.53581,0.54759,0.55922,0.57076,0.58211,0.59328,0.60427,0.61504,0.62557,0.63591,0.64595,0.65578,0.66530,0.67449,0.68340,0.69201,0.70025,0.70809,0.71563,0.72274,0.72951,0.73586,0.74181,0.74731,0.75243,0.75707,0.76125,0.76501,0.76830,0.77111,0.77346,0.77532,0.77673,0.77764,0.77807,0.77801,0.77749,0.77645,0.77493,0.77291,0.77047,0.76754,0.76412,0.76028,0.75597,0.75118,0.74599,0.74038,0.73431,0.72787,0.72100,0.71371,0.70605,0.69805,0.68969,0.68096,0.67193,0.66256,0.65291,0.64299,0.63277,0.62236,0.61165,0.60073,0.58962,0.57830,0.56682,0.55516,0.54338,0.53148,0.51946,0.50734,0.49516,0.48292,0.47066,0.45833,0.44597,0.43364,0.42137,0.40910,0.39686,0.38466,0.37260,0.36058,0.34864,0.33686,0.32521,0.31367,0.30229,0.29106,0.27998,0.26908,0.25840,0.24787,0.23756,0.22742,0.21754,0.20786,0.19843,0.18918,0.18021,0.17148,0.16297,0.15470,0.14667,0.13892,0.13141,0.12412,0.11707,0.11029,0.10379,0.09699,0.08979,0.08307,0.07675,0.07089,0.06543,0.06037,0.05564,0.05124,0.04718,0.04340,0.03986,0.03659,0.03360,0.03082,0.02826,0.02585,0.02365,0.02164,0.01978,0.01810,0.01651,0.01508,0.01373,0.01251,0.01141,0.01038,0.00943,0.00861,0.00784,0.00717,0.00659,0.00610,0.00565,0.00522,0.00482,0.00443,0.00406,0.00369,0.00330,0.00290,0.00250,0.00214,0.00180,0.00146,0.00119,0.00095,0.00073,0.00055,0.00040,0.00031,0.00021,0.00015,0.00009,0.00006,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00009,0.00012,0.00018,0.00027,0.00040,0.00055,0.00073,0.00095,0.00119,0.00146,0.00180,0.00217,0.00256,0.00299,0.00339,0.00381,0.00421,0.00461,0.00504,0.00546,0.00589,0.00638,0.00693,0.00754,0.00824,0.00903,0.00992,0.01093,0.01202,0.01325,0.01456,0.01599,0.01755,0.01926,0.02109,0.02310,0.02530,0.02768,0.03030,0.03311,0.03616,0.03946,0.04303,0.04694,0.05112,0.05560,0.06046,0.06574,0.07135,0.07743,0.08396,0.09101,0.09854,0.10660,0.11457,0.12195,0.12967,0.13770,0.14606,0.15464,0.16358,0.17283,0.18238,0.19221,0.20234,0.21278,0.22355,0.23457,0.24589,0.25748,0.26942,0.28156,0.29402,0.30668,0.31962,0.33283,0.34623,0.35987,0.37370,0.38777,0.40199,0.41639,0.43101,0.44572,0.46059,0.47557,0.49062,0.50575,0.52098,0.53627,0.55159,0.56694,0.58223,0.59752,0.61278,0.62801,0.64309,0.65813,0.67302,0.68780,0.70238,0.71679,0.73101,0.74502,0.75872,0.77221,0.78539,0.79827,0.81088,0.82311,0.83502,0.84649,0.85757,0.86828,0.87857,0.88836,0.89770,0.90658,0.91494,0.92282,0.93017,0.93698,0.94324,0.94897,0.95413,0.95871,0.96274,0.96619,0.96905,0.97125,0.97293,0.97394,0.97439,0.97421,0.97342,0.97208,0.97006,0.96747,0.96426,0.96051,0.95618,0.95120,0.94574,0.93970,0.93307,0.92593,0.91830,0.91012,0.90149,0.89233,0.88269,0.87259,0.86206,0.85116,0.83975,0.82800,0.81585,0.80337,0.79061,0.77746,0.76409,0.75039,0.73644,0.72228,0.70791,0.69335,0.67861,0.66372,0.64873,0.63356,0.61834,0.60305,0.58776,0.57234,0.55696,0.54155,0.52620,0.51091,0.49565,0.48048,0.46538,0.45045,0.43559,0.42088,0.40635,0.39198,0.37782,0.36384,0.35005,0.33650,0.32316,0.31010,0.29722,0.28468,0.27232,0.26029,0.24851,0.23707,0.22584,0.21497,0.20438,0.19410,0.18412,0.17444,0.16507,0.15604,0.14728,0.13880,0.13065,0.12287,0.11457,0.10602,0.09799,0.09049,0.08353,0.07703,0.07102,0.06540,0.06018,0.05536,0.05087,0.04672,0.04285,0.03931,0.03604,0.03302,0.03018,0.02762,0.02524,0.02304,0.02106,0.01923,0.01752,0.01596,0.01453,0.01321,0.01202,0.01093,0.00995,0.00906,0.00830,0.00763,0.00705,0.00653,0.00604,0.00555,0.00510,0.00467,0.00424,0.00378,0.00333,0.00287,0.00244,0.00204,0.00168,0.00134,0.00107,0.00082,0.00061,0.00046,0.00034,0.00021,0.00015,0.00009,0.00006,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00009,0.00015,0.00021,0.00034,0.00046,0.00061,0.00082,0.00107,0.00134,0.00168,0.00204,0.00244,0.00290,0.00336,0.00381,0.00427,0.00470,0.00513,0.00558,0.00607,0.00656,0.00708,0.00769,0.00836,0.00916,0.01004,0.01102,0.01212,0.01334,0.01465,0.01611,0.01767,0.01941,0.02124,0.02326,0.02548,0.02786,0.03049,0.03333,0.03641,0.03970,0.04331,0.04721,0.05142,0.05597,0.06085,0.06613,0.07184,0.07791,0.08451,0.09159,0.09919,0.10733,0.11600,0.12442,0.13236,0.14060,0.14920,0.15815,0.16730,0.17685,0.18668,0.19687,0.20731,0.21809,0.22913,0.24058,0.25224,0.26423,0.27650,0.28907,0.30189,0.31501,0.32835,0.34196,0.35578,0.36985,0.38417,0.39863,0.41331,0.42814,0.44319,0.45842,0.47368,0.48912,0.50468,0.52028,0.53594,0.55168,0.56746,0.58327,0.59905,0.61476,0.63045,0.64611,0.66167,0.67708,0.69240,0.70757,0.72256,0.73736,0.75192,0.76629,0.78042,0.79421,0.80776,0.82095,0.83383,0.84640,0.85855,0.87036,0.88168,0.89261,0.90310,0.91311,0.92264,0.93167,0.94018,0.94815,0.95563,0.96255,0.96893,0.97470,0.97995,0.98456,0.98859,0.99203,0.99487,0.99707,0.99863,0.99966,1,0.99976,0.99887,0.99734,0.99524,0.99249,0.98914,0.98517,0.98062,0.97546,0.96973,0.96344,0.95660,0.94919,0.94125,0.93283,0.92386,0.91443,0.90451,0.89410,0.88321,0.87194,0.86029,0.84817,0.83572,0.82287,0.80972,0.79626,0.78249,0.76849,0.75414,0.73962,0.72488,0.70995,0.69481,0.67956,0.66414,0.64870,0.63305,0.61739,0.60170,0.58599,0.57024,0.55449,0.53877,0.52312,0.50755,0.49208,0.47664,0.46135,0.44621,0.43117,0.41627,0.40162,0.38713,0.37288,0.35881,0.34495,0.33134,0.31797,0.30491,0.29203,0.27949,0.26716,0.25517,0.24345,0.23206,0.22089,0.21012,0.19962,0.18946,0.17957,0.16999,0.16074,0.15183,0.14316,0.13483,0.12683,0.11917,0.11093,0.10254,0.09473,0.08741,0.08063,0.07431,0.06845,0.06299,0.05792,0.05325,0.04892,0.04486,0.04114,0.03769,0.03455,0.03162,0.02890,0.02640,0.02411,0.02200,0.02011,0.01834,0.01669,0.01520,0.01382,0.01257,0.01141,0.01038,0.00946,0.00861,0.00787,0.00723,0.00668,0.00616,0.00571,0.00525,0.00482,0.00439,0.00400,0.00357,0.00311,0.00269,0.00229,0.00189,0.00156,0.00125,0.00098,0.00076,0.00058,0.00043,0.00031,0.00021,0.00015,0.00009,0.00006,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00009,0.00015,0.00021,0.00031,0.00043,0.00058,0.00076,0.00101,0.00125,0.00156,0.00189,0.00226,0.00266,0.00308,0.00351,0.00391,0.00430,0.00470,0.00513,0.00552,0.00598,0.00647,0.00699,0.00760,0.00833,0.00913,0.01001,0.01102,0.01212,0.01331,0.01459,0.01602,0.01755,0.01923,0.02103,0.02301,0.02515,0.02750,0.03006,0.03281,0.03574,0.03894,0.04242,0.04621,0.05023,0.05457,0.05927,0.06433,0.06973,0.07556,0.08185,0.08856,0.09577,0.10346,0.11072,0.11768,0.12494,0.13248,0.14029,0.14832,0.15665,0.16526,0.17411,0.18320,0.19260,0.20222,0.21213,0.22227,0.23264,0.24326,0.25413,0.26521,0.27650,0.28800,0.29969,0.31162,0.32371,0.33595,0.34837,0.36091,0.37361,0.38646,0.39940,0.41243,0.42555,0.43873,0.45198,0.46525,0.47856,0.49190,0.50523,0.51851,0.53169,0.54488,0.55797,0.57100,0.58388,0.59664,0.60927,0.62172,0.63399,0.64608,0.65795,0.66961,0.68093,0.69207,0.70284,0.71337,0.72356,0.73342,0.74294,0.75207,0.76083,0.76922,0.77718,0.78469,0.79180,0.79849,0.80468,0.81045,0.81573,0.82052,0.82482,0.82867,0.83197,0.83477,0.83709,0.83886,0.84011,0.84082,0.84106,0.84072,0.83990,0.83853,0.83663,0.83425,0.83135,0.82794,0.82400,0.81964,0.81472,0.80935,0.80352,0.79724,0.79046,0.78329,0.77572,0.76766,0.75930,0.75048,0.74133,0.73177,0.72192,0.71172,0.70119,0.69039,0.67928,0.66796,0.65636,0.64455,0.63253,0.62026,0.60787,0.59529,0.58260,0.56978,0.55684,0.54384,0.53078,0.51759,0.50441,0.49123,0.47807,0.46489,0.45170,0.43858,0.42552,0.41255,0.39967,0.38685,0.37416,0.36161,0.34913,0.33686,0.32475,0.31278,0.30103,0.28947,0.27808,0.26691,0.25596,0.24525,0.23472,0.22446,0.21439,0.20460,0.19507,0.18580,0.17673,0.16797,0.15946,0.15122,0.14319,0.13544,0.12799,0.12079,0.11383,0.10712,0.10068,0.09452,0.08780,0.08112,0.07486,0.06903,0.06363,0.05860,0.05396,0.04959,0.04559,0.04187,0.03842,0.03522,0.03226,0.02957,0.02707,0.02475,0.02261,0.02063,0.01883,0.01718,0.01569,0.01428,0.01300,0.01184,0.01077,0.00977,0.00885,0.00806,0.00732,0.00668,0.00610,0.00562,0.00516,0.00479,0.00443,0.00406,0.00372,0.00339,0.00308,0.00272,0.00238,0.00204,0.00174,0.00143,0.00119,0.00095,0.00073,0.00058,0.00043,0.00031,0.00021,0.00015,0.00009,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00006,0.00012,0.00015,0.00024,0.00034,0.00043,0.00058,0.00076,0.00095,0.00119,0.00143,0.00171,0.00201,0.00232,0.00262,0.00293,0.00320,0.00351,0.00381,0.00412,0.00446,0.00479,0.00519,0.00565,0.00616,0.00678,0.00742,0.00815,0.00897,0.00983,0.01077,0.01181,0.01297,0.01416,0.01550,0.01694,0.01849,0.02020,0.02206,0.02405,0.02622,0.02853,0.03107,0.03378,0.03671,0.03986,0.04324,0.04691,0.05081,0.05502,0.05954,0.06439,0.06955,0.07508,0.08020,0.08518,0.09037,0.09574,0.10129,0.10700,0.11292,0.11902,0.12531,0.13175,0.13837,0.14518,0.15220,0.15931,0.16663,0.17411,0.18174,0.18949,0.19742,0.20545,0.21363,0.22193,0.23038,0.23890,0.24754,0.25626,0.26505,0.27396,0.28294,0.29191,0.30097,0.31007,0.31916,0.32829,0.33741,0.34654,0.35563,0.36470,0.37370,0.38267,0.39158,0.40040,0.40910,0.41774,0.42622,0.43461,0.44282,0.45088,0.45882,0.46657,0.47407,0.48146,0.48857,0.49553,0.50221,0.50868,0.51488,0.52080,0.52644,0.53185,0.53691,0.54170,0.54619,0.55037,0.55422,0.55776,0.56096,0.56380,0.56630,0.56850,0.57030,0.57176,0.57289,0.57366,0.57405,0.57408,0.57378,0.57311,0.57210,0.57076,0.56902,0.56697,0.56453,0.56178,0.55867,0.55525,0.55150,0.54744,0.54308,0.53841,0.53343,0.52818,0.52266,0.51680,0.51076,0.50444,0.49785,0.49107,0.48405,0.47685,0.46944,0.46184,0.45402,0.44609,0.43800,0.42976,0.42140,0.41292,0.40434,0.39567,0.38694,0.37812,0.36924,0.36033,0.35139,0.34239,0.33341,0.32444,0.31550,0.30653,0.29762,0.28871,0.27989,0.27113,0.26243,0.25379,0.24528,0.23685,0.22852,0.22028,0.21223,0.20423,0.19642,0.18870,0.18113,0.17371,0.16645,0.15934,0.15235,0.14557,0.13895,0.13248,0.12619,0.12009,0.11414,0.10840,0.10282,0.09742,0.09217,0.08710,0.08225,0.07755,0.07300,0.06864,0.06446,0.06046,0.05606,0.05176,0.04773,0.04398,0.04050,0.03726,0.03427,0.03150,0.02890,0.02655,0.02432,0.02228,0.02039,0.01868,0.01709,0.01559,0.01425,0.01300,0.01184,0.01080,0.00986,0.00897,0.00815,0.00742,0.00674,0.00610,0.00555,0.00504,0.00458,0.00415,0.00381,0.00348,0.00323,0.00296,0.00275,0.00253,0.00232,0.00211,0.00189,0.00168,0.00146,0.00125,0.00107,0.00089,0.00073,0.00058,0.00046,0.00034,0.00024,0.00018,0.00012,0.00009,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00006,0.00009,0.00015,0.00021,0.00027,0.00037,0.00046,0.00058,0.00070,0.00085,0.00104,0.00119,0.00137,0.00156,0.00174,0.00192,0.00208,0.00226,0.00244,0.00262,0.00284,0.00308,0.00336,0.00366,0.00400,0.00439,0.00482,0.00528,0.00580,0.00635,0.00696,0.00763,0.00833,0.00909,0.00992,0.01083,0.01184,0.01291,0.01407,0.01529,0.01663,0.01810,0.01968,0.02136,0.02316,0.02512,0.02722,0.02945,0.03186,0.03446,0.03723,0.04016,0.04334,0.04617,0.04901,0.05194,0.05496,0.05811,0.06131,0.06464,0.06809,0.07160,0.07520,0.07892,0.08271,0.08661,0.09061,0.09467,0.09882,0.10306,0.10736,0.11176,0.11618,0.12070,0.12528,0.12992,0.13462,0.13935,0.14411,0.14893,0.15378,0.15867,0.16355,0.16849,0.17341,0.17832,0.18323,0.18815,0.19306,0.19794,0.20280,0.20762,0.21241,0.21714,0.22184,0.22645,0.23099,0.23548,0.23988,0.24421,0.24842,0.25257,0.25660,0.26051,0.26432,0.26795,0.27152,0.27494,0.27821,0.28132,0.28428,0.28712,0.28977,0.29228,0.29460,0.29673,0.29875,0.30055,0.30216,0.30363,0.30488,0.30595,0.30686,0.30754,0.30802,0.30836,0.30845,0.30839,0.30811,0.30766,0.30699,0.30616,0.30515,0.30393,0.30256,0.30097,0.29920,0.29728,0.29518,0.29289,0.29044,0.28788,0.28513,0.28220,0.27918,0.27598,0.27265,0.26920,0.26560,0.26191,0.25806,0.25413,0.25010,0.24598,0.24174,0.23743,0.23307,0.22861,0.22410,0.21955,0.21491,0.21024,0.20551,0.20078,0.19602,0.19123,0.18641,0.18162,0.17676,0.17197,0.16715,0.16239,0.15763,0.15287,0.14817,0.14350,0.13886,0.13428,0.12973,0.12525,0.12082,0.11646,0.11216,0.10791,0.10376,0.09967,0.09568,0.09174,0.08789,0.08411,0.08045,0.07685,0.07334,0.06992,0.06662,0.06339,0.06024,0.05719,0.05426,0.05142,0.04868,0.04599,0.04343,0.04096,0.03858,0.03629,0.03406,0.03195,0.02994,0.02771,0.02554,0.02353,0.02167,0.01993,0.01831,0.01685,0.01544,0.01416,0.01300,0.01190,0.01090,0.00995,0.00909,0.00833,0.00760,0.00693,0.00632,0.00574,0.00522,0.00476,0.00433,0.00394,0.00357,0.00323,0.00293,0.00266,0.00241,0.00220,0.00198,0.00183,0.00168,0.00156,0.00143,0.00131,0.00119,0.00110,0.00101,0.00092,0.00079,0.00070,0.00058,0.00049,0.00043,0.00034,0.00027,0.00021,0.00015,0.00012,0.00009,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00006,0.00006,0.00009,0.00012,0.00015,0.00021,0.00027,0.00034,0.00040,0.00046,0.00055,0.00061,0.00070,0.00079,0.00085,0.00095,0.00101,0.00110,0.00119,0.00128,0.00137,0.00150,0.00162,0.00177,0.00195,0.00214,0.00235,0.00256,0.00281,0.00308,0.00336,0.00366,0.00400,0.00436,0.00476,0.00519,0.00565,0.00613,0.00668,0.00726,0.00787,0.00855,0.00928,0.01004,0.01090,0.01178,0.01273,0.01376,0.01486,0.01602,0.01727,0.01862,0.01978,0.02097,0.02219,0.02347,0.02478,0.02609,0.02750,0.02890,0.03037,0.03186,0.03339,0.03494,0.03656,0.03818,0.03983,0.04154,0.04324,0.04501,0.04678,0.04859,0.05039,0.05225,0.05411,0.05597,0.05789,0.05979,0.06171,0.06363,0.06555,0.06751,0.06943,0.07138,0.07331,0.07523,0.07715,0.07907,0.08097,0.08283,0.08469,0.08652,0.08835,0.09012,0.09186,0.09360,0.09528,0.09693,0.09854,0.10010,0.10166,0.10312,0.10456,0.10596,0.10730,0.10855,0.10978,0.11093,0.11200,0.11304,0.11402,0.11490,0.11576,0.11649,0.11719,0.11780,0.11835,0.11884,0.11924,0.11957,0.11982,0.12000,0.12012,0.12015,0.12009,0.11997,0.11979,0.11951,0.11914,0.11875,0.11826,0.11768,0.11707,0.11637,0.11560,0.11475,0.11386,0.11289,0.11185,0.11075,0.10962,0.10843,0.10718,0.10587,0.10453,0.10309,0.10166,0.10013,0.09861,0.09702,0.09540,0.09375,0.09204,0.09033,0.08860,0.08683,0.08506,0.08325,0.08142,0.07959,0.07773,0.07590,0.07401,0.07215,0.07028,0.06842,0.06656,0.06470,0.06284,0.06098,0.05914,0.05734,0.05551,0.05371,0.05194,0.05020,0.04846,0.04675,0.04508,0.04343,0.04178,0.04016,0.03861,0.03705,0.03552,0.03406,0.03259,0.03116,0.02979,0.02844,0.02713,0.02585,0.02460,0.02341,0.02225,0.02109,0.01999,0.01895,0.01791,0.01694,0.01596,0.01505,0.01419,0.01334,0.01251,0.01175,0.01099,0.01028,0.00949,0.00873,0.00803,0.00739,0.00678,0.00623,0.00571,0.00522,0.00479,0.00439,0.00400,0.00366,0.00333,0.00305,0.00278,0.00253,0.00232,0.00211,0.00192,0.00174,0.00159,0.00143,0.00131,0.00119,0.00107,0.00098,0.00089,0.00079,0.00070,0.00064,0.00058,0.00055,0.00049,0.00046,0.00043,0.00040,0.00037,0.00034,0.00027,0.00024,0.00021,0.00018,0.00015,0.00012,0.00009,0.00009,0.00006,0.00006,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00003,0.00003,0.00003,0.00006,0.00006,0.00009,0.00009,0.00012,0.00012,0.00015,0.00018,0.00021,0.00021,0.00024,0.00027,0.00027,0.00031,0.00034,0.00037,0.00040,0.00043,0.00046,0.00049,0.00055,0.00061,0.00067,0.00073,0.00079,0.00085,0.00095,0.00101,0.00110,0.00122,0.00131,0.00143,0.00156,0.00168,0.00183,0.00198,0.00217,0.00235,0.00253,0.00275,0.00296,0.00320,0.00345,0.00372,0.00403,0.00433,0.00467,0.00504,0.00534,0.00565,0.00598,0.00632,0.00665,0.00699,0.00735,0.00775,0.00812,0.00851,0.00891,0.00934,0.00977,0.01019,0.01065,0.01111,0.01157,0.01202,0.01251,0.01300,0.01349,0.01398,0.01450,0.01498,0.01550,0.01602,0.01654,0.01706,0.01761,0.01813,0.01865,0.01920,0.01971,0.02026,0.02078,0.02130,0.02185,0.02237,0.02289,0.02341,0.02393,0.02441,0.02493,0.02542,0.02588,0.02634,0.02680,0.02725,0.02768,0.02808,0.02847,0.02884,0.02921,0.02957,0.02991,0.03024,0.03055,0.03082,0.03107,0.03131,0.03150,0.03171,0.03186,0.03201,0.03217,0.03226,0.03235,0.03241,0.03244,0.03241,0.03238,0.03232,0.03226,0.03217,0.03204,0.03189,0.03171,0.03153,0.03128,0.03104,0.03079,0.03049,0.03018,0.02982,0.02945,0.02905,0.02866,0.02823,0.02777,0.02731,0.02683,0.02634,0.02582,0.02527,0.02472,0.02417,0.02359,0.02301,0.02243,0.02185,0.02127,0.02066,0.02008,0.01947,0.01889,0.01828,0.01770,0.01709,0.01651,0.01590,0.01532,0.01474,0.01419,0.01361,0.01306,0.01251,0.01196,0.01144,0.01093,0.01041,0.00992,0.00943,0.00894,0.00848,0.00806,0.00763,0.00720,0.00681,0.00641,0.00604,0.00571,0.00534,0.00501,0.00470,0.00439,0.00409,0.00381,0.00357,0.00330,0.00308,0.00284,0.00262,0.00244,0.00226,0.00208,0.00189,0.00174,0.00159,0.00146,0.00131,0.00119,0.00110,0.00098,0.00089,0.00079,0.00073,0.00064,0.00058,0.00052,0.00046,0.00040,0.00034,0.00031,0.00027,0.00024,0.00021,0.00018,0.00015,0.00012,0.00012,0.00009,0.00009,0.00006,0.00006,0.00006,0.00006,0.00003,0.00003,0.00003,0.00003,0.00003,0.00003,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},3600,14400,{0,-0.01389,-0.02780,-0.04169,-0.05558,-0.06946,-0.08335,-0.09727,-0.11115,-0.12504,-0.13892,-0.15281,-0.16673,-0.18061,-0.19450,-0.20839,-0.22230,-0.23619,-0.25008,-0.26396,-0.27788,-0.29177,-0.30565,-0.31954,-0.33342,-0.34734,-0.36123,-0.37511,-0.38900,-0.40289,-0.41680,-0.43069,-0.44458,-0.45846,-0.47238,-0.48627,-0.50015,-0.51404,-0.52796,-0.54184,-0.55573,-0.56961,-0.58350,-0.59742,-0.61130,-0.62519,-0.63908,-0.65299,-0.66688,-0.68077,-0.69465,-0.70854,-0.72246,-0.73634,-0.75023,-0.76412,-0.77803,-0.79192,-0.80580,-0.81969,-0.83358,-0.84749,-0.86138,-0.87527,-0.88915,-0.90307,-0.91696,-0.93084,-0.94473,-0.95862,-0.97253,-0.98642,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99915,-0.98526,-0.97137,-0.95749,-0.94357,-0.92968,-0.91580,-0.90191,-0.88799,-0.87411,-0.86022,-0.84633,-0.83242,-0.81853,-0.80465,-0.79076,-0.77684,-0.76296,-0.74907,-0.73518,-0.72130,-0.70738,-0.69349,-0.67961,-0.66572,-0.65183,-0.63792,-0.62403,-0.61014,-0.59626,-0.58234,-0.56846,-0.55457,-0.54068,-0.52680,-0.51288,-0.49899,-0.48511,-0.47122,-0.45730,-0.44342,-0.42953,-0.41564,-0.40176,-0.38784,-0.37395,-0.36007,-0.34618,-0.33227,-0.31838,-0.30449,-0.29061,-0.27669,-0.26280,-0.24892,-0.23503,-0.22114,-0.20723,-0.19334,-0.17945,-0.16557,-0.15165,-0.13776,-0.12388,-0.10999,-0.09611,-0.08219,-0.06830,-0.05442,-0.04053,-0.02661,-0.01273,0.00116,0.01505,0.02893,0.04285,0.05674,0.07062,0.08451,0.09843,0.11231,0.12620,0.14008,0.15397,0.16789,0.18177,0.19566,0.20955,0.22346,0.23735,0.25124,0.26512,0.27901,0.29293,0.30681,0.32070,0.33458,0.34850,0.36239,0.37627,0.39016,0.40408,0.41796,0.43185,0.44574,0.45962,0.47354,0.48743,0.50131,0.51520,0.52912,0.54300,0.55689,0.57077,0.58466,0.59858,0.61246,0.62635,0.64024,0.65415,0.66804,0.68193,0.69581,0.70970,0.72362,0.73750,0.75139,0.76527,0.77916,0.79308,0.80696,0.82085,0.83474,0.84865,0.86254,0.87643,0.89031,0.90420,0.91812,0.93200,0.94589,0.95981,0.97369,0.98758,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99799,0.98410,0.97021,0.95633,0.94241,0.92852,0.91464,0.90075,0.88683,0.87295,0.85906,0.84517,0.83126,0.81737,0.80349,0.78960,0.77571,0.76180,0.74791,0.73402,0.72014,0.70622,0.69233,0.67845,0.66456,0.65067,0.63676,0.62287,0.60898,0.59510,0.58118,0.56730,0.55341,0.53952,0.52564,0.51172,0.49783,0.48395,0.47006,0.45614,0.44226,0.42837,0.41448,0.40060,0.38668,0.37279,0.35891,0.34502,0.33111,0.31722,0.30333,0.28945,0.27556,0.26164,0.24776,0.23387,0.21998,0.20607,0.19218,0.17829,0.16441,0.15049,0.13661,0.12272,0.10883,0.09495,0.08103,0.06714,0.05326,0.03937,0.02548,0.01157,-0.00232,-0.01621,-0.03009,-0.04401,-0.05790,-0.07178,-0.08567,-0.09955,-0.11347,-0.12736,-0.14124,-0.15513,-0.16905,-0.18293,-0.19682,-0.21071,-0.22459,-0.23851,-0.25240,-0.26628,-0.28017,-0.29409,-0.30797,-0.32186,-0.33574,-0.34966,-0.36355,-0.37743,-0.39132,-0.40521,-0.41912,-0.43301,-0.44690,-0.46078,-0.47470,-0.48859,-0.50247,-0.51636,-0.53024,-0.54416,-0.55805,-0.57193,-0.58582,-0.59974,-0.61362,-0.62751,-0.64140,-0.65528,-0.66920,-0.68309,-0.69697,-0.71086,-0.72478,-0.73866,-0.75255,-0.76643,-0.78032,-0.79424,-0.80812,-0.82201,-0.83590,-0.84981,-0.86370,-0.87759,-0.89147,-0.90536,-0.91928,-0.93316,-0.94705,-0.96094,-0.97485,-0.98874,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99683,-0.98294,-0.96905,-0.95517,-0.94125,-0.92736,-0.91348,-0.89959,-0.88570,-0.87179,-0.85790,-0.84402,-0.83013,-0.81621,-0.80233,-0.78844,-0.77455,-0.76064,-0.74675,-0.73286,-0.71898,-0.70509,-0.69117,-0.67729,-0.66340,-0.64951,-0.63560,-0.62171,-0.60783,-0.59394,-0.58005,-0.56614,-0.55225,-0.53836,-0.52448,-0.51056,-0.49667,-0.48279,-0.46890,-0.45501,-0.44110,-0.42721,-0.41332,-0.39944,-0.38552,-0.37164,-0.35775,-0.34386,-0.32998,-0.31606,-0.30217,-0.28829,-0.27440,-0.26048,-0.24660,-0.23271,-0.21882,-0.20491,-0.19102,-0.17713,-0.16325,-0.14936,-0.13545,-0.12156,-0.10767,-0.09379,-0.07987,-0.06598,-0.05210,-0.03821,-0.02432,-0.01041,0.00348,0.01737,0.03125,0.04517,0.05906,0.07294,0.08683,0.10071,0.11463,0.12852,0.14240,0.15629,0.17021,0.18409,0.19798,0.21187,0.22575,0.23967,0.25356,0.26744,0.28133,0.29525,0.30913,0.32302,0.33690,0.35079,0.36471,0.37859,0.39248,0.40637,0.42028,0.43417,0.44806,0.46194,0.47586,0.48975,0.50363,0.51752,0.53140,0.54532,0.55921,0.57309,0.58698,0.60090,0.61478,0.62867,0.64256,0.65644,0.67036,0.68425,0.69813,0.71202,0.72590,0.73982,0.75371,0.76759,0.78148,0.79540,0.80928,0.82317,0.83706,0.85094,0.86486,0.87875,0.89263,0.90652,0.92044,0.93432,0.94821,0.96209,0.97598,0.98990,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99567,0.98178,0.96789,0.95401,0.94009,0.92620,0.91232,0.89843,0.88454,0.87063,0.85674,0.84286,0.82897,0.81505,0.80117,0.78728,0.77339,0.75948,0.74559,0.73170,0.71782,0.70393,0.69001,0.67613,0.66224,0.64836,0.63444,0.62055,0.60667,0.59278,0.57889,0.56498,0.55109,0.53720,0.52332,0.50940,0.49551,0.48163,0.46774,0.45385,0.43994,0.42605,0.41217,0.39828,0.38436,0.37048,0.35659,0.34270,0.32882,0.31490,0.30101,0.28713,0.27324,0.25935,0.24544,0.23155,0.21766,0.20378,0.18986,0.17598,0.16209,0.14820,0.13429,0.12040,0.10651,0.09263,0.07874,0.06482,0.05094,0.03705,0.02316,0.00925,-0.00464,-0.01853,-0.03241,-0.04630,-0.06021,-0.07410,-0.08799,-0.10187,-0.11579,-0.12968,-0.14356,-0.15745,-0.17134,-0.18525,-0.19914,-0.21303,-0.22691,-0.24083,-0.25472,-0.26860,-0.28249,-0.29637,-0.31029,-0.32418,-0.33806,-0.35195,-0.36587,-0.37975,-0.39364,-0.40753,-0.42144,-0.43533,-0.44922,-0.46310,-0.47699,-0.49091,-0.50479,-0.51868,-0.53256,-0.54648,-0.56037,-0.57425,-0.58814,-0.60203,-0.61594,-0.62983,-0.64372,-0.65760,-0.67152,-0.68541,-0.69929,-0.71318,-0.72706,-0.74098,-0.75487,-0.76875,-0.78264,-0.79656,-0.81044,-0.82433,-0.83822,-0.85210,-0.86602,-0.87991,-0.89379,-0.90768,-0.92160,-0.93548,-0.94937,-0.96325,-0.97714,-0.99106,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99451,-0.98062,-0.96673,-0.95285,-0.93893,-0.92504,-0.91116,-0.89727,-0.88339,-0.86947,-0.85558,-0.84170,-0.82781,-0.81389,-0.80001,-0.78612,-0.77223,-0.75835,-0.74443,-0.73054,-0.71666,-0.70277,-0.68885,-0.67497,-0.66108,-0.64720,-0.63331,-0.61939,-0.60551,-0.59162,-0.57773,-0.56382,-0.54993,-0.53604,-0.52216,-0.50827,-0.49435,-0.48047,-0.46658,-0.45269,-0.43878,-0.42489,-0.41101,-0.39712,-0.38323,-0.36932,-0.35543,-0.34154,-0.32766,-0.31374,-0.29985,-0.28597,-0.27208,-0.25819,-0.24428,-0.23039,-0.21650,-0.20262,-0.18870,-0.17482,-0.16093,-0.14704,-0.13313,-0.11924,-0.10535,-0.09147,-0.07758,-0.06366,-0.04978,-0.03589,-0.02200,-0.00809,0.00580,0.01969,0.03357,0.04746,0.06137,0.07526,0.08915,0.10303,0.11695,0.13084,0.14472,0.15861,0.17250,0.18641,0.20030,0.21419,0.22807,0.24196,0.25587,0.26976,0.28365,0.29753,0.31145,0.32534,0.33922,0.35311,0.36703,0.38091,0.39480,0.40869,0.42257,0.43649,0.45038,0.46426,0.47815,0.49206,0.50595,0.51984,0.53372,0.54761,0.56153,0.57541,0.58930,0.60319,0.61710,0.63099,0.64488,0.65876,0.67265,0.68657,0.70045,0.71434,0.72822,0.74214,0.75603,0.76991,0.78380,0.79769,0.81160,0.82549,0.83938,0.85326,0.86718,0.88107,0.89495,0.90884,0.92272,0.93664,0.95053,0.96441,0.97830,0.99222,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99335,0.97946,0.96557,0.95169,0.93780,0.92388,0.91000,0.89611,0.88223,0.86831,0.85442,0.84054,0.82665,0.81276,0.79885,0.78496,0.77107,0.75719,0.74327,0.72938,0.71550,0.70161,0.68773,0.67381,0.65992,0.64604,0.63215,0.61823,0.60435,0.59046,0.57657,0.56269,0.54877,0.53488,0.52100,0.50711,0.49319,0.47931,0.46542,0.45154,0.43762,0.42373,0.40985,0.39596,0.38207,0.36816,0.35427,0.34038,0.32650,0.31258,0.29869,0.28481,0.27092,0.25703,0.24312,0.22923,0.21535,0.20146,0.18754,0.17366,0.15977,0.14588,0.13200,0.11808,0.10419,0.09031,0.07642,0.06250,0.04862,0.03473,0.02084,0.00696,-0.00696,-0.02084,-0.03473,-0.04862,-0.06253,-0.07642,-0.09031,-0.10419,-0.11808,-0.13200,-0.14588,-0.15977,-0.17366,-0.18757,-0.20146,-0.21535,-0.22923,-0.24315,-0.25703,-0.27092,-0.28481,-0.29869,-0.31261,-0.32650,-0.34038,-0.35427,-0.36816,-0.38207,-0.39596,-0.40985,-0.42373,-0.43765,-0.45154,-0.46542,-0.47931,-0.49322,-0.50711,-0.52100,-0.53488,-0.54877,-0.56269,-0.57657,-0.59046,-0.60435,-0.61823,-0.63215,-0.64604,-0.65992,-0.67381,-0.68773,-0.70161,-0.71550,-0.72938,-0.74330,-0.75719,-0.77107,-0.78496,-0.79885,-0.81276,-0.82665,-0.84054,-0.85442,-0.86834,-0.88223,-0.89611,-0.91000,-0.92388,-0.93780,-0.95169,-0.96557,-0.97946,-0.99335,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99219,-0.97830,-0.96441,-0.95053,-0.93664,-0.92272,-0.90884,-0.89495,-0.88107,-0.86718,-0.85326,-0.83938,-0.82549,-0.81160,-0.79769,-0.78380,-0.76991,-0.75603,-0.74214,-0.72822,-0.71434,-0.70045,-0.68657,-0.67265,-0.65876,-0.64488,-0.63099,-0.61710,-0.60319,-0.58930,-0.57541,-0.56153,-0.54761,-0.53372,-0.51984,-0.50595,-0.49206,-0.47815,-0.46426,-0.45038,-0.43649,-0.42257,-0.40869,-0.39480,-0.38091,-0.36700,-0.35311,-0.33922,-0.32534,-0.31145,-0.29753,-0.28365,-0.26976,-0.25587,-0.24199,-0.22807,-0.21419,-0.20030,-0.18641,-0.17250,-0.15861,-0.14472,-0.13084,-0.11692,-0.10303,-0.08915,-0.07526,-0.06137,-0.04746,-0.03357,-0.01969,-0.00580,0.00812,0.02200,0.03589,0.04978,0.06366,0.07758,0.09147,0.10535,0.11924,0.13316,0.14704,0.16093,0.17482,0.18870,0.20262,0.21650,0.23039,0.24428,0.25819,0.27208,0.28597,0.29985,0.31377,0.32766,0.34154,0.35543,0.36932,0.38323,0.39712,0.41101,0.42489,0.43878,0.45269,0.46658,0.48047,0.49435,0.50827,0.52216,0.53604,0.54993,0.56385,0.57773,0.59162,0.60551,0.61939,0.63331,0.64720,0.66108,0.67497,0.68888,0.70277,0.71666,0.73054,0.74443,0.75835,0.77223,0.78612,0.80001,0.81389,0.82781,0.84170,0.85558,0.86947,0.88339,0.89727,0.91116,0.92504,0.93896,0.95285,0.96673,0.98062,0.99451,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99106,0.97714,0.96325,0.94937,0.93548,0.92157,0.90768,0.89379,0.87991,0.86602,0.85210,0.83822,0.82433,0.81044,0.79656,0.78264,0.76875,0.75487,0.74098,0.72706,0.71318,0.69929,0.68541,0.67149,0.65760,0.64372,0.62983,0.61594,0.60203,0.58814,0.57425,0.56037,0.54645,0.53256,0.51868,0.50479,0.49087,0.47699,0.46310,0.44922,0.43533,0.42141,0.40753,0.39364,0.37975,0.36587,0.35195,0.33806,0.32418,0.31029,0.29637,0.28249,0.26860,0.25472,0.24080,0.22691,0.21303,0.19914,0.18525,0.17134,0.15745,0.14356,0.12968,0.11579,0.10187,0.08799,0.07410,0.06021,0.04630,0.03241,0.01853,0.00464,-0.00925,-0.02316,-0.03705,-0.05094,-0.06482,-0.07874,-0.09263,-0.10651,-0.12040,-0.13432,-0.14820,-0.16209,-0.17598,-0.18986,-0.20378,-0.21766,-0.23155,-0.24544,-0.25932,-0.27324,-0.28713,-0.30101,-0.31490,-0.32882,-0.34270,-0.35659,-0.37048,-0.38439,-0.39828,-0.41217,-0.42605,-0.43994,-0.45385,-0.46774,-0.48163,-0.49551,-0.50940,-0.52332,-0.53720,-0.55109,-0.56498,-0.57889,-0.59278,-0.60667,-0.62055,-0.63447,-0.64836,-0.66224,-0.67613,-0.69001,-0.70393,-0.71782,-0.73170,-0.74559,-0.75951,-0.77339,-0.78728,-0.80117,-0.81508,-0.82897,-0.84286,-0.85674,-0.87063,-0.88454,-0.89843,-0.91232,-0.92620,-0.94009,-0.95401,-0.96789,-0.98178,-0.99567,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98990,-0.97601,-0.96209,-0.94821,-0.93432,-0.92044,-0.90652,-0.89263,-0.87875,-0.86486,-0.85094,-0.83706,-0.82317,-0.80928,-0.79540,-0.78148,-0.76759,-0.75371,-0.73982,-0.72590,-0.71202,-0.69813,-0.68425,-0.67036,-0.65644,-0.64256,-0.62867,-0.61478,-0.60087,-0.58698,-0.57309,-0.55921,-0.54532,-0.53140,-0.51752,-0.50363,-0.48975,-0.47583,-0.46194,-0.44806,-0.43417,-0.42028,-0.40637,-0.39248,-0.37859,-0.36471,-0.35079,-0.33690,-0.32302,-0.30913,-0.29525,-0.28133,-0.26744,-0.25356,-0.23967,-0.22575,-0.21187,-0.19798,-0.18409,-0.17018,-0.15629,-0.14240,-0.12852,-0.11463,-0.10071,-0.08683,-0.07294,-0.05906,-0.04514,-0.03125,-0.01737,-0.00348,0.01041,0.02432,0.03821,0.05210,0.06598,0.07990,0.09379,0.10767,0.12156,0.13545,0.14936,0.16325,0.17713,0.19102,0.20494,0.21882,0.23271,0.24660,0.26048,0.27440,0.28829,0.30217,0.31606,0.32998,0.34386,0.35775,0.37164,0.38552,0.39944,0.41332,0.42721,0.44110,0.45501,0.46890,0.48279,0.49667,0.51056,0.52448,0.53836,0.55225,0.56614,0.58005,0.59394,0.60783,0.62171,0.63560,0.64951,0.66340,0.67729,0.69117,0.70509,0.71898,0.73286,0.74675,0.76064,0.77455,0.78844,0.80233,0.81621,0.83013,0.84402,0.85790,0.87179,0.88570,0.89959,0.91348,0.92736,0.94125,0.95517,0.96905,0.98294,0.99683,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98874,0.97482,0.96094,0.94705,0.93316,0.91928,0.90536,0.89147,0.87759,0.86370,0.84981,0.83590,0.82201,0.80812,0.79424,0.78032,0.76643,0.75255,0.73866,0.72475,0.71086,0.69697,0.68309,0.66920,0.65528,0.64140,0.62751,0.61362,0.59971,0.58582,0.57193,0.55805,0.54416,0.53024,0.51636,0.50247,0.48859,0.47470,0.46078,0.44690,0.43301,0.41912,0.40521,0.39132,0.37743,0.36355,0.34963,0.33574,0.32186,0.30797,0.29409,0.28017,0.26628,0.25240,0.23851,0.22459,0.21071,0.19682,0.18293,0.16905,0.15513,0.14124,0.12736,0.11347,0.09955,0.08567,0.07178,0.05790,0.04401,0.03009,0.01621,0.00232,-0.01157,-0.02548,-0.03937,-0.05326,-0.06714,-0.08106,-0.09495,-0.10883,-0.12272,-0.13661,-0.15052,-0.16441,-0.17829,-0.19218,-0.20610,-0.21998,-0.23387,-0.24776,-0.26164,-0.27556,-0.28945,-0.30333,-0.31722,-0.33114,-0.34502,-0.35891,-0.37279,-0.38668,-0.40060,-0.41448,-0.42837,-0.44226,-0.45617,-0.47006,-0.48395,-0.49783,-0.51175,-0.52564,-0.53952,-0.55341,-0.56730,-0.58121,-0.59510,-0.60898,-0.62287,-0.63676,-0.65067,-0.66456,-0.67845,-0.69233,-0.70625,-0.72014,-0.73402,-0.74791,-0.76180,-0.77571,-0.78960,-0.80349,-0.81737,-0.83129,-0.84517,-0.85906,-0.87295,-0.88683,-0.90075,-0.91464,-0.92852,-0.94241,-0.95633,-0.97021,-0.98410,-0.99799,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98758,-0.97369,-0.95978,-0.94589,-0.93200,-0.91812,-0.90420,-0.89031,-0.87643,-0.86254,-0.84865,-0.83474,-0.82085,-0.80696,-0.79308,-0.77916,-0.76527,-0.75139,-0.73750,-0.72359,-0.70970,-0.69581,-0.68193,-0.66804,-0.65412,-0.64024,-0.62635,-0.61246,-0.59855,-0.58466,-0.57077,-0.55689,-0.54300,-0.52909,-0.51520,-0.50131,-0.48743,-0.47354,-0.45962,-0.44574,-0.43185,-0.41796,-0.40405,-0.39016,-0.37627,-0.36239,-0.34850,-0.33458,-0.32070,-0.30681,-0.29293,-0.27901,-0.26512,-0.25124,-0.23735,-0.22343,-0.20955,-0.19566,-0.18177,-0.16789,-0.15397,-0.14008,-0.12620,-0.11231,-0.09839,-0.08451,-0.07062,-0.05674,-0.04285,-0.02893,-0.01505,-0.00116,0.01273,0.02664,0.04053,0.05442,0.06830,0.08219,0.09611,0.10999,0.12388,0.13776,0.15168,0.16557,0.17945,0.19334,0.20723,0.22114,0.23503,0.24892,0.26280,0.27672,0.29061,0.30449,0.31838,0.33227,0.34618,0.36007,0.37395,0.38784,0.40176,0.41564,0.42953,0.44342,0.45733,0.47122,0.48511,0.49899,0.51288,0.52680,0.54068,0.55457,0.56846,0.58237,0.59626,0.61014,0.62403,0.63792,0.65183,0.66572,0.67961,0.69349,0.70741,0.72130,0.73518,0.74907,0.76296,0.77687,0.79076,0.80465,0.81853,0.83245,0.84633,0.86022,0.87411,0.88799,0.90191,0.91580,0.92968,0.94357,0.95746,0.97137,0.98526,0.99915,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98642,0.97253,0.95862,0.94473,0.93084,0.91696,0.90307,0.88915,0.87527,0.86138,0.84749,0.83358,0.81969,0.80580,0.79192,0.77800,0.76412,0.75023,0.73634,0.72246,0.70854,0.69465,0.68077,0.66688,0.65296,0.63908,0.62519,0.61130,0.59742,0.58350,0.56961,0.55573,0.54184,0.52793,0.51404,0.50015,0.48627,0.47238,0.45846,0.44458,0.43069,0.41680,0.40289,0.38900,0.37511,0.36123,0.34734,0.33342,0.31954,0.30565,0.29177,0.27785,0.26396,0.25008,0.23619,0.22230,0.20839,0.19450,0.18061,0.16673,0.15281,0.13892,0.12504,0.11115,0.09723,0.08335,0.06946,0.05558,0.04169,0.02777,0.01389,0},{0,0,0},KS_GRADWAVE_RELATIVE,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_WAVE spsp_ss1528822_gz = {{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},3600,14400,{0,-0.01389,-0.02780,-0.04169,-0.05558,-0.06946,-0.08335,-0.09727,-0.11115,-0.12504,-0.13892,-0.15281,-0.16673,-0.18061,-0.19450,-0.20839,-0.22230,-0.23619,-0.25008,-0.26396,-0.27788,-0.29177,-0.30565,-0.31954,-0.33342,-0.34734,-0.36123,-0.37511,-0.38900,-0.40289,-0.41680,-0.43069,-0.44458,-0.45846,-0.47238,-0.48627,-0.50015,-0.51404,-0.52796,-0.54184,-0.55573,-0.56961,-0.58350,-0.59742,-0.61130,-0.62519,-0.63908,-0.65299,-0.66688,-0.68077,-0.69465,-0.70854,-0.72246,-0.73634,-0.75023,-0.76412,-0.77803,-0.79192,-0.80580,-0.81969,-0.83358,-0.84749,-0.86138,-0.87527,-0.88915,-0.90307,-0.91696,-0.93084,-0.94473,-0.95862,-0.97253,-0.98642,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99915,-0.98526,-0.97137,-0.95749,-0.94357,-0.92968,-0.91580,-0.90191,-0.88799,-0.87411,-0.86022,-0.84633,-0.83242,-0.81853,-0.80465,-0.79076,-0.77684,-0.76296,-0.74907,-0.73518,-0.72130,-0.70738,-0.69349,-0.67961,-0.66572,-0.65183,-0.63792,-0.62403,-0.61014,-0.59626,-0.58234,-0.56846,-0.55457,-0.54068,-0.52680,-0.51288,-0.49899,-0.48511,-0.47122,-0.45730,-0.44342,-0.42953,-0.41564,-0.40176,-0.38784,-0.37395,-0.36007,-0.34618,-0.33227,-0.31838,-0.30449,-0.29061,-0.27669,-0.26280,-0.24892,-0.23503,-0.22114,-0.20723,-0.19334,-0.17945,-0.16557,-0.15165,-0.13776,-0.12388,-0.10999,-0.09611,-0.08219,-0.06830,-0.05442,-0.04053,-0.02661,-0.01273,0.00116,0.01505,0.02893,0.04285,0.05674,0.07062,0.08451,0.09843,0.11231,0.12620,0.14008,0.15397,0.16789,0.18177,0.19566,0.20955,0.22346,0.23735,0.25124,0.26512,0.27901,0.29293,0.30681,0.32070,0.33458,0.34850,0.36239,0.37627,0.39016,0.40408,0.41796,0.43185,0.44574,0.45962,0.47354,0.48743,0.50131,0.51520,0.52912,0.54300,0.55689,0.57077,0.58466,0.59858,0.61246,0.62635,0.64024,0.65415,0.66804,0.68193,0.69581,0.70970,0.72362,0.73750,0.75139,0.76527,0.77916,0.79308,0.80696,0.82085,0.83474,0.84865,0.86254,0.87643,0.89031,0.90420,0.91812,0.93200,0.94589,0.95981,0.97369,0.98758,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99799,0.98410,0.97021,0.95633,0.94241,0.92852,0.91464,0.90075,0.88683,0.87295,0.85906,0.84517,0.83126,0.81737,0.80349,0.78960,0.77571,0.76180,0.74791,0.73402,0.72014,0.70622,0.69233,0.67845,0.66456,0.65067,0.63676,0.62287,0.60898,0.59510,0.58118,0.56730,0.55341,0.53952,0.52564,0.51172,0.49783,0.48395,0.47006,0.45614,0.44226,0.42837,0.41448,0.40060,0.38668,0.37279,0.35891,0.34502,0.33111,0.31722,0.30333,0.28945,0.27556,0.26164,0.24776,0.23387,0.21998,0.20607,0.19218,0.17829,0.16441,0.15049,0.13661,0.12272,0.10883,0.09495,0.08103,0.06714,0.05326,0.03937,0.02548,0.01157,-0.00232,-0.01621,-0.03009,-0.04401,-0.05790,-0.07178,-0.08567,-0.09955,-0.11347,-0.12736,-0.14124,-0.15513,-0.16905,-0.18293,-0.19682,-0.21071,-0.22459,-0.23851,-0.25240,-0.26628,-0.28017,-0.29409,-0.30797,-0.32186,-0.33574,-0.34966,-0.36355,-0.37743,-0.39132,-0.40521,-0.41912,-0.43301,-0.44690,-0.46078,-0.47470,-0.48859,-0.50247,-0.51636,-0.53024,-0.54416,-0.55805,-0.57193,-0.58582,-0.59974,-0.61362,-0.62751,-0.64140,-0.65528,-0.66920,-0.68309,-0.69697,-0.71086,-0.72478,-0.73866,-0.75255,-0.76643,-0.78032,-0.79424,-0.80812,-0.82201,-0.83590,-0.84981,-0.86370,-0.87759,-0.89147,-0.90536,-0.91928,-0.93316,-0.94705,-0.96094,-0.97485,-0.98874,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99683,-0.98294,-0.96905,-0.95517,-0.94125,-0.92736,-0.91348,-0.89959,-0.88570,-0.87179,-0.85790,-0.84402,-0.83013,-0.81621,-0.80233,-0.78844,-0.77455,-0.76064,-0.74675,-0.73286,-0.71898,-0.70509,-0.69117,-0.67729,-0.66340,-0.64951,-0.63560,-0.62171,-0.60783,-0.59394,-0.58005,-0.56614,-0.55225,-0.53836,-0.52448,-0.51056,-0.49667,-0.48279,-0.46890,-0.45501,-0.44110,-0.42721,-0.41332,-0.39944,-0.38552,-0.37164,-0.35775,-0.34386,-0.32998,-0.31606,-0.30217,-0.28829,-0.27440,-0.26048,-0.24660,-0.23271,-0.21882,-0.20491,-0.19102,-0.17713,-0.16325,-0.14936,-0.13545,-0.12156,-0.10767,-0.09379,-0.07987,-0.06598,-0.05210,-0.03821,-0.02432,-0.01041,0.00348,0.01737,0.03125,0.04517,0.05906,0.07294,0.08683,0.10071,0.11463,0.12852,0.14240,0.15629,0.17021,0.18409,0.19798,0.21187,0.22575,0.23967,0.25356,0.26744,0.28133,0.29525,0.30913,0.32302,0.33690,0.35079,0.36471,0.37859,0.39248,0.40637,0.42028,0.43417,0.44806,0.46194,0.47586,0.48975,0.50363,0.51752,0.53140,0.54532,0.55921,0.57309,0.58698,0.60090,0.61478,0.62867,0.64256,0.65644,0.67036,0.68425,0.69813,0.71202,0.72590,0.73982,0.75371,0.76759,0.78148,0.79540,0.80928,0.82317,0.83706,0.85094,0.86486,0.87875,0.89263,0.90652,0.92044,0.93432,0.94821,0.96209,0.97598,0.98990,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99567,0.98178,0.96789,0.95401,0.94009,0.92620,0.91232,0.89843,0.88454,0.87063,0.85674,0.84286,0.82897,0.81505,0.80117,0.78728,0.77339,0.75948,0.74559,0.73170,0.71782,0.70393,0.69001,0.67613,0.66224,0.64836,0.63444,0.62055,0.60667,0.59278,0.57889,0.56498,0.55109,0.53720,0.52332,0.50940,0.49551,0.48163,0.46774,0.45385,0.43994,0.42605,0.41217,0.39828,0.38436,0.37048,0.35659,0.34270,0.32882,0.31490,0.30101,0.28713,0.27324,0.25935,0.24544,0.23155,0.21766,0.20378,0.18986,0.17598,0.16209,0.14820,0.13429,0.12040,0.10651,0.09263,0.07874,0.06482,0.05094,0.03705,0.02316,0.00925,-0.00464,-0.01853,-0.03241,-0.04630,-0.06021,-0.07410,-0.08799,-0.10187,-0.11579,-0.12968,-0.14356,-0.15745,-0.17134,-0.18525,-0.19914,-0.21303,-0.22691,-0.24083,-0.25472,-0.26860,-0.28249,-0.29637,-0.31029,-0.32418,-0.33806,-0.35195,-0.36587,-0.37975,-0.39364,-0.40753,-0.42144,-0.43533,-0.44922,-0.46310,-0.47699,-0.49091,-0.50479,-0.51868,-0.53256,-0.54648,-0.56037,-0.57425,-0.58814,-0.60203,-0.61594,-0.62983,-0.64372,-0.65760,-0.67152,-0.68541,-0.69929,-0.71318,-0.72706,-0.74098,-0.75487,-0.76875,-0.78264,-0.79656,-0.81044,-0.82433,-0.83822,-0.85210,-0.86602,-0.87991,-0.89379,-0.90768,-0.92160,-0.93548,-0.94937,-0.96325,-0.97714,-0.99106,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99451,-0.98062,-0.96673,-0.95285,-0.93893,-0.92504,-0.91116,-0.89727,-0.88339,-0.86947,-0.85558,-0.84170,-0.82781,-0.81389,-0.80001,-0.78612,-0.77223,-0.75835,-0.74443,-0.73054,-0.71666,-0.70277,-0.68885,-0.67497,-0.66108,-0.64720,-0.63331,-0.61939,-0.60551,-0.59162,-0.57773,-0.56382,-0.54993,-0.53604,-0.52216,-0.50827,-0.49435,-0.48047,-0.46658,-0.45269,-0.43878,-0.42489,-0.41101,-0.39712,-0.38323,-0.36932,-0.35543,-0.34154,-0.32766,-0.31374,-0.29985,-0.28597,-0.27208,-0.25819,-0.24428,-0.23039,-0.21650,-0.20262,-0.18870,-0.17482,-0.16093,-0.14704,-0.13313,-0.11924,-0.10535,-0.09147,-0.07758,-0.06366,-0.04978,-0.03589,-0.02200,-0.00809,0.00580,0.01969,0.03357,0.04746,0.06137,0.07526,0.08915,0.10303,0.11695,0.13084,0.14472,0.15861,0.17250,0.18641,0.20030,0.21419,0.22807,0.24196,0.25587,0.26976,0.28365,0.29753,0.31145,0.32534,0.33922,0.35311,0.36703,0.38091,0.39480,0.40869,0.42257,0.43649,0.45038,0.46426,0.47815,0.49206,0.50595,0.51984,0.53372,0.54761,0.56153,0.57541,0.58930,0.60319,0.61710,0.63099,0.64488,0.65876,0.67265,0.68657,0.70045,0.71434,0.72822,0.74214,0.75603,0.76991,0.78380,0.79769,0.81160,0.82549,0.83938,0.85326,0.86718,0.88107,0.89495,0.90884,0.92272,0.93664,0.95053,0.96441,0.97830,0.99222,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99335,0.97946,0.96557,0.95169,0.93780,0.92388,0.91000,0.89611,0.88223,0.86831,0.85442,0.84054,0.82665,0.81276,0.79885,0.78496,0.77107,0.75719,0.74327,0.72938,0.71550,0.70161,0.68773,0.67381,0.65992,0.64604,0.63215,0.61823,0.60435,0.59046,0.57657,0.56269,0.54877,0.53488,0.52100,0.50711,0.49319,0.47931,0.46542,0.45154,0.43762,0.42373,0.40985,0.39596,0.38207,0.36816,0.35427,0.34038,0.32650,0.31258,0.29869,0.28481,0.27092,0.25703,0.24312,0.22923,0.21535,0.20146,0.18754,0.17366,0.15977,0.14588,0.13200,0.11808,0.10419,0.09031,0.07642,0.06250,0.04862,0.03473,0.02084,0.00696,-0.00696,-0.02084,-0.03473,-0.04862,-0.06253,-0.07642,-0.09031,-0.10419,-0.11808,-0.13200,-0.14588,-0.15977,-0.17366,-0.18757,-0.20146,-0.21535,-0.22923,-0.24315,-0.25703,-0.27092,-0.28481,-0.29869,-0.31261,-0.32650,-0.34038,-0.35427,-0.36816,-0.38207,-0.39596,-0.40985,-0.42373,-0.43765,-0.45154,-0.46542,-0.47931,-0.49322,-0.50711,-0.52100,-0.53488,-0.54877,-0.56269,-0.57657,-0.59046,-0.60435,-0.61823,-0.63215,-0.64604,-0.65992,-0.67381,-0.68773,-0.70161,-0.71550,-0.72938,-0.74330,-0.75719,-0.77107,-0.78496,-0.79885,-0.81276,-0.82665,-0.84054,-0.85442,-0.86834,-0.88223,-0.89611,-0.91000,-0.92388,-0.93780,-0.95169,-0.96557,-0.97946,-0.99335,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.99219,-0.97830,-0.96441,-0.95053,-0.93664,-0.92272,-0.90884,-0.89495,-0.88107,-0.86718,-0.85326,-0.83938,-0.82549,-0.81160,-0.79769,-0.78380,-0.76991,-0.75603,-0.74214,-0.72822,-0.71434,-0.70045,-0.68657,-0.67265,-0.65876,-0.64488,-0.63099,-0.61710,-0.60319,-0.58930,-0.57541,-0.56153,-0.54761,-0.53372,-0.51984,-0.50595,-0.49206,-0.47815,-0.46426,-0.45038,-0.43649,-0.42257,-0.40869,-0.39480,-0.38091,-0.36700,-0.35311,-0.33922,-0.32534,-0.31145,-0.29753,-0.28365,-0.26976,-0.25587,-0.24199,-0.22807,-0.21419,-0.20030,-0.18641,-0.17250,-0.15861,-0.14472,-0.13084,-0.11692,-0.10303,-0.08915,-0.07526,-0.06137,-0.04746,-0.03357,-0.01969,-0.00580,0.00812,0.02200,0.03589,0.04978,0.06366,0.07758,0.09147,0.10535,0.11924,0.13316,0.14704,0.16093,0.17482,0.18870,0.20262,0.21650,0.23039,0.24428,0.25819,0.27208,0.28597,0.29985,0.31377,0.32766,0.34154,0.35543,0.36932,0.38323,0.39712,0.41101,0.42489,0.43878,0.45269,0.46658,0.48047,0.49435,0.50827,0.52216,0.53604,0.54993,0.56385,0.57773,0.59162,0.60551,0.61939,0.63331,0.64720,0.66108,0.67497,0.68888,0.70277,0.71666,0.73054,0.74443,0.75835,0.77223,0.78612,0.80001,0.81389,0.82781,0.84170,0.85558,0.86947,0.88339,0.89727,0.91116,0.92504,0.93896,0.95285,0.96673,0.98062,0.99451,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.99106,0.97714,0.96325,0.94937,0.93548,0.92157,0.90768,0.89379,0.87991,0.86602,0.85210,0.83822,0.82433,0.81044,0.79656,0.78264,0.76875,0.75487,0.74098,0.72706,0.71318,0.69929,0.68541,0.67149,0.65760,0.64372,0.62983,0.61594,0.60203,0.58814,0.57425,0.56037,0.54645,0.53256,0.51868,0.50479,0.49087,0.47699,0.46310,0.44922,0.43533,0.42141,0.40753,0.39364,0.37975,0.36587,0.35195,0.33806,0.32418,0.31029,0.29637,0.28249,0.26860,0.25472,0.24080,0.22691,0.21303,0.19914,0.18525,0.17134,0.15745,0.14356,0.12968,0.11579,0.10187,0.08799,0.07410,0.06021,0.04630,0.03241,0.01853,0.00464,-0.00925,-0.02316,-0.03705,-0.05094,-0.06482,-0.07874,-0.09263,-0.10651,-0.12040,-0.13432,-0.14820,-0.16209,-0.17598,-0.18986,-0.20378,-0.21766,-0.23155,-0.24544,-0.25932,-0.27324,-0.28713,-0.30101,-0.31490,-0.32882,-0.34270,-0.35659,-0.37048,-0.38439,-0.39828,-0.41217,-0.42605,-0.43994,-0.45385,-0.46774,-0.48163,-0.49551,-0.50940,-0.52332,-0.53720,-0.55109,-0.56498,-0.57889,-0.59278,-0.60667,-0.62055,-0.63447,-0.64836,-0.66224,-0.67613,-0.69001,-0.70393,-0.71782,-0.73170,-0.74559,-0.75951,-0.77339,-0.78728,-0.80117,-0.81508,-0.82897,-0.84286,-0.85674,-0.87063,-0.88454,-0.89843,-0.91232,-0.92620,-0.94009,-0.95401,-0.96789,-0.98178,-0.99567,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98990,-0.97601,-0.96209,-0.94821,-0.93432,-0.92044,-0.90652,-0.89263,-0.87875,-0.86486,-0.85094,-0.83706,-0.82317,-0.80928,-0.79540,-0.78148,-0.76759,-0.75371,-0.73982,-0.72590,-0.71202,-0.69813,-0.68425,-0.67036,-0.65644,-0.64256,-0.62867,-0.61478,-0.60087,-0.58698,-0.57309,-0.55921,-0.54532,-0.53140,-0.51752,-0.50363,-0.48975,-0.47583,-0.46194,-0.44806,-0.43417,-0.42028,-0.40637,-0.39248,-0.37859,-0.36471,-0.35079,-0.33690,-0.32302,-0.30913,-0.29525,-0.28133,-0.26744,-0.25356,-0.23967,-0.22575,-0.21187,-0.19798,-0.18409,-0.17018,-0.15629,-0.14240,-0.12852,-0.11463,-0.10071,-0.08683,-0.07294,-0.05906,-0.04514,-0.03125,-0.01737,-0.00348,0.01041,0.02432,0.03821,0.05210,0.06598,0.07990,0.09379,0.10767,0.12156,0.13545,0.14936,0.16325,0.17713,0.19102,0.20494,0.21882,0.23271,0.24660,0.26048,0.27440,0.28829,0.30217,0.31606,0.32998,0.34386,0.35775,0.37164,0.38552,0.39944,0.41332,0.42721,0.44110,0.45501,0.46890,0.48279,0.49667,0.51056,0.52448,0.53836,0.55225,0.56614,0.58005,0.59394,0.60783,0.62171,0.63560,0.64951,0.66340,0.67729,0.69117,0.70509,0.71898,0.73286,0.74675,0.76064,0.77455,0.78844,0.80233,0.81621,0.83013,0.84402,0.85790,0.87179,0.88570,0.89959,0.91348,0.92736,0.94125,0.95517,0.96905,0.98294,0.99683,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98874,0.97482,0.96094,0.94705,0.93316,0.91928,0.90536,0.89147,0.87759,0.86370,0.84981,0.83590,0.82201,0.80812,0.79424,0.78032,0.76643,0.75255,0.73866,0.72475,0.71086,0.69697,0.68309,0.66920,0.65528,0.64140,0.62751,0.61362,0.59971,0.58582,0.57193,0.55805,0.54416,0.53024,0.51636,0.50247,0.48859,0.47470,0.46078,0.44690,0.43301,0.41912,0.40521,0.39132,0.37743,0.36355,0.34963,0.33574,0.32186,0.30797,0.29409,0.28017,0.26628,0.25240,0.23851,0.22459,0.21071,0.19682,0.18293,0.16905,0.15513,0.14124,0.12736,0.11347,0.09955,0.08567,0.07178,0.05790,0.04401,0.03009,0.01621,0.00232,-0.01157,-0.02548,-0.03937,-0.05326,-0.06714,-0.08106,-0.09495,-0.10883,-0.12272,-0.13661,-0.15052,-0.16441,-0.17829,-0.19218,-0.20610,-0.21998,-0.23387,-0.24776,-0.26164,-0.27556,-0.28945,-0.30333,-0.31722,-0.33114,-0.34502,-0.35891,-0.37279,-0.38668,-0.40060,-0.41448,-0.42837,-0.44226,-0.45617,-0.47006,-0.48395,-0.49783,-0.51175,-0.52564,-0.53952,-0.55341,-0.56730,-0.58121,-0.59510,-0.60898,-0.62287,-0.63676,-0.65067,-0.66456,-0.67845,-0.69233,-0.70625,-0.72014,-0.73402,-0.74791,-0.76180,-0.77571,-0.78960,-0.80349,-0.81737,-0.83129,-0.84517,-0.85906,-0.87295,-0.88683,-0.90075,-0.91464,-0.92852,-0.94241,-0.95633,-0.97021,-0.98410,-0.99799,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98758,-0.97369,-0.95978,-0.94589,-0.93200,-0.91812,-0.90420,-0.89031,-0.87643,-0.86254,-0.84865,-0.83474,-0.82085,-0.80696,-0.79308,-0.77916,-0.76527,-0.75139,-0.73750,-0.72359,-0.70970,-0.69581,-0.68193,-0.66804,-0.65412,-0.64024,-0.62635,-0.61246,-0.59855,-0.58466,-0.57077,-0.55689,-0.54300,-0.52909,-0.51520,-0.50131,-0.48743,-0.47354,-0.45962,-0.44574,-0.43185,-0.41796,-0.40405,-0.39016,-0.37627,-0.36239,-0.34850,-0.33458,-0.32070,-0.30681,-0.29293,-0.27901,-0.26512,-0.25124,-0.23735,-0.22343,-0.20955,-0.19566,-0.18177,-0.16789,-0.15397,-0.14008,-0.12620,-0.11231,-0.09839,-0.08451,-0.07062,-0.05674,-0.04285,-0.02893,-0.01505,-0.00116,0.01273,0.02664,0.04053,0.05442,0.06830,0.08219,0.09611,0.10999,0.12388,0.13776,0.15168,0.16557,0.17945,0.19334,0.20723,0.22114,0.23503,0.24892,0.26280,0.27672,0.29061,0.30449,0.31838,0.33227,0.34618,0.36007,0.37395,0.38784,0.40176,0.41564,0.42953,0.44342,0.45733,0.47122,0.48511,0.49899,0.51288,0.52680,0.54068,0.55457,0.56846,0.58237,0.59626,0.61014,0.62403,0.63792,0.65183,0.66572,0.67961,0.69349,0.70741,0.72130,0.73518,0.74907,0.76296,0.77687,0.79076,0.80465,0.81853,0.83245,0.84633,0.86022,0.87411,0.88799,0.90191,0.91580,0.92968,0.94357,0.95746,0.97137,0.98526,0.99915,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98642,0.97253,0.95862,0.94473,0.93084,0.91696,0.90307,0.88915,0.87527,0.86138,0.84749,0.83358,0.81969,0.80580,0.79192,0.77800,0.76412,0.75023,0.73634,0.72246,0.70854,0.69465,0.68077,0.66688,0.65296,0.63908,0.62519,0.61130,0.59742,0.58350,0.56961,0.55573,0.54184,0.52793,0.51404,0.50015,0.48627,0.47238,0.45846,0.44458,0.43069,0.41680,0.40289,0.38900,0.37511,0.36123,0.34734,0.33342,0.31954,0.30565,0.29177,0.27785,0.26396,0.25008,0.23619,0.22230,0.20839,0.19450,0.18061,0.16673,0.15281,0.13892,0.12504,0.11115,0.09723,0.08335,0.06946,0.05558,0.04169,0.02777,0.01389,0},{0,0,0},KS_GRADWAVE_RELATIVE,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)};
const KS_RF spsp_ss30260334 = {KS_RF_ROLE_EXC,90,4040,0,1,4860,4860,324,"GE RF pulse: ss30260334.rho",{((void *)0),((void *)0),0.0819,0.0429,0.0614,0.1171,0.0652,0,0.12788,0.00403,0.0203736,90,((void *)0),9720,4040,0,0,4860,1,((void *)0),1,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},2430,9720,{0,0,0,0,-0.00006,-0.00006,-0.00012,-0.00024,-0.00037,-0.00055,-0.00079,-0.00116,-0.00153,-0.00195,-0.00244,-0.00293,-0.00348,-0.00409,-0.00482,-0.00562,-0.00653,-0.00745,-0.00836,-0.00934,-0.01032,-0.01135,-0.01245,-0.01343,-0.01434,-0.01526,-0.01624,-0.01709,-0.01782,-0.01849,-0.01917,-0.01972,-0.02020,-0.02075,-0.02124,-0.02173,-0.02234,-0.02301,-0.02381,-0.02472,-0.02582,-0.02710,-0.02851,-0.03021,-0.03205,-0.03406,-0.03620,-0.03845,-0.04090,-0.04328,-0.04578,-0.04828,-0.05078,-0.05329,-0.05579,-0.05823,-0.06067,-0.06318,-0.06568,-0.06818,-0.06958,-0.07093,-0.07227,-0.07355,-0.07477,-0.07593,-0.07703,-0.07801,-0.07892,-0.07978,-0.08051,-0.08112,-0.08167,-0.08210,-0.08240,-0.08259,-0.08271,-0.08271,-0.08259,-0.08240,-0.08204,-0.08167,-0.08112,-0.08051,-0.07978,-0.07892,-0.07801,-0.07703,-0.07593,-0.07477,-0.07355,-0.07227,-0.07099,-0.06958,-0.06818,-0.06568,-0.06318,-0.06067,-0.05823,-0.05573,-0.05323,-0.05066,-0.04816,-0.04566,-0.04315,-0.04077,-0.03839,-0.03620,-0.03406,-0.03211,-0.03034,-0.02869,-0.02728,-0.02606,-0.02496,-0.02411,-0.02332,-0.02265,-0.02204,-0.02149,-0.02094,-0.02033,-0.01978,-0.01911,-0.01831,-0.01758,-0.01672,-0.01581,-0.01477,-0.01379,-0.01282,-0.01184,-0.01074,-0.00971,-0.00867,-0.00775,-0.00690,-0.00598,-0.00513,-0.00439,-0.00372,-0.00311,-0.00262,-0.00220,-0.00177,-0.00140,-0.00104,-0.00073,-0.00049,-0.00031,-0.00018,-0.00012,-0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.00006,-0.00012,-0.00018,-0.00031,-0.00049,-0.00073,-0.00110,-0.00153,-0.00208,-0.00262,-0.00330,-0.00397,-0.00470,-0.00549,-0.00647,-0.00757,-0.00879,-0.01001,-0.01129,-0.01251,-0.01386,-0.01532,-0.01672,-0.01807,-0.01929,-0.02057,-0.02179,-0.02295,-0.02393,-0.02484,-0.02576,-0.02655,-0.02716,-0.02789,-0.02857,-0.02924,-0.03003,-0.03095,-0.03198,-0.03321,-0.03473,-0.03644,-0.03839,-0.04065,-0.04309,-0.04578,-0.04871,-0.05176,-0.05500,-0.05823,-0.06159,-0.06495,-0.06830,-0.07166,-0.07502,-0.07831,-0.08161,-0.08497,-0.08826,-0.09168,-0.09351,-0.09540,-0.09717,-0.09888,-0.10053,-0.10212,-0.10358,-0.10493,-0.10615,-0.10731,-0.10828,-0.10914,-0.10981,-0.11036,-0.11079,-0.11109,-0.11121,-0.11121,-0.11109,-0.11079,-0.11036,-0.10981,-0.10908,-0.10822,-0.10725,-0.10615,-0.10493,-0.10358,-0.10212,-0.10053,-0.09894,-0.09717,-0.09546,-0.09357,-0.09174,-0.08832,-0.08497,-0.08161,-0.07831,-0.07489,-0.07160,-0.06818,-0.06476,-0.06141,-0.05805,-0.05481,-0.05164,-0.04865,-0.04578,-0.04315,-0.04077,-0.03858,-0.03668,-0.03510,-0.03363,-0.03241,-0.03137,-0.03046,-0.02966,-0.02893,-0.02814,-0.02735,-0.02655,-0.02570,-0.02466,-0.02362,-0.02252,-0.02124,-0.01990,-0.01856,-0.01727,-0.01587,-0.01447,-0.01300,-0.01166,-0.01044,-0.00922,-0.00806,-0.00690,-0.00586,-0.00501,-0.00421,-0.00354,-0.00293,-0.00238,-0.00183,-0.00140,-0.00098,-0.00067,-0.00043,-0.00031,-0.00018,-0.00006,-0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00006,0.00012,0.00031,0.00055,0.00098,0.00159,0.00244,0.00354,0.00488,0.00653,0.00842,0.01044,0.01257,0.01495,0.01764,0.02069,0.02423,0.02802,0.03198,0.03595,0.03998,0.04431,0.04883,0.05341,0.05762,0.06159,0.06556,0.06958,0.07319,0.07636,0.07929,0.08216,0.08466,0.08674,0.08893,0.09119,0.09333,0.09577,0.09876,0.10206,0.10596,0.11079,0.11616,0.12238,0.12965,0.13740,0.14613,0.15534,0.16505,0.17536,0.18574,0.19642,0.20717,0.21785,0.22865,0.23921,0.24989,0.26039,0.27107,0.28163,0.29244,0.29842,0.30434,0.30996,0.31551,0.32070,0.32576,0.33040,0.33474,0.33870,0.34225,0.34536,0.34810,0.35030,0.35213,0.35342,0.35433,0.35476,0.35476,0.35433,0.35342,0.35207,0.35024,0.34804,0.34530,0.34225,0.33864,0.33474,0.33034,0.32576,0.32076,0.31557,0.31008,0.30446,0.29854,0.29256,0.28176,0.27113,0.26039,0.24983,0.23903,0.22835,0.21748,0.20668,0.19593,0.18525,0.17494,0.16468,0.15516,0.14607,0.13764,0.13007,0.12312,0.11707,0.11188,0.10718,0.10340,0.10016,0.09711,0.09455,0.09223,0.08973,0.08722,0.08478,0.08191,0.07862,0.07526,0.07178,0.06781,0.06348,0.05927,0.05512,0.05072,0.04608,0.04151,0.03729,0.03333,0.02948,0.02570,0.02204,0.01874,0.01593,0.01349,0.01135,0.00940,0.00757,0.00592,0.00446,0.00317,0.00220,0.00140,0.00085,0.00049,0.00024,0.00012,0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00006,0.00018,0.00037,0.00085,0.00159,0.00275,0.00446,0.00678,0.00995,0.01386,0.01849,0.02368,0.02942,0.03546,0.04212,0.04962,0.05835,0.06824,0.07905,0.09022,0.10139,0.11274,0.12482,0.13764,0.15046,0.16242,0.17359,0.18483,0.19612,0.20637,0.21516,0.22346,0.23164,0.23866,0.24452,0.25069,0.25710,0.26308,0.26991,0.27840,0.28762,0.29860,0.31227,0.32741,0.34505,0.36544,0.38729,0.41183,0.43795,0.46524,0.49429,0.52347,0.55374,0.58390,0.61411,0.64451,0.67430,0.70445,0.73405,0.76415,0.79387,0.82433,0.84112,0.85784,0.87365,0.88934,0.90399,0.91821,0.93127,0.94360,0.95465,0.96478,0.97351,0.98120,0.98743,0.99249,0.99622,0.99878,1,1,0.99872,0.99622,0.99243,0.98730,0.98102,0.97339,0.96466,0.95459,0.94354,0.93121,0.91821,0.90411,0.88952,0.87402,0.85821,0.84154,0.82470,0.79424,0.76427,0.73399,0.70414,0.67375,0.64359,0.61301,0.58256,0.55228,0.52213,0.49301,0.46426,0.43740,0.41177,0.38790,0.36666,0.34701,0.32998,0.31539,0.30220,0.29146,0.28230,0.27370,0.26650,0.26003,0.25288,0.24586,0.23897,0.23085,0.22163,0.21223,0.20234,0.19111,0.17903,0.16706,0.15528,0.14295,0.12989,0.11707,0.10505,0.09394,0.08307,0.07239,0.06220,0.05292,0.04486,0.03797,0.03198,0.02649,0.02142,0.01672,0.01257,0.00903,0.00616,0.00403,0.00250,0.00146,0.00079,0.00037,0.00012,0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00006,0.00018,0.00037,0.00085,0.00159,0.00275,0.00446,0.00678,0.00995,0.01386,0.01849,0.02368,0.02942,0.03546,0.04212,0.04962,0.05835,0.06824,0.07905,0.09022,0.10139,0.11274,0.12482,0.13764,0.15046,0.16242,0.17359,0.18483,0.19612,0.20637,0.21516,0.22346,0.23164,0.23866,0.24452,0.25069,0.25710,0.26308,0.26991,0.27840,0.28762,0.29860,0.31227,0.32741,0.34505,0.36544,0.38729,0.41183,0.43795,0.46524,0.49429,0.52347,0.55374,0.58390,0.61411,0.64451,0.67430,0.70445,0.73405,0.76415,0.79387,0.82433,0.84112,0.85784,0.87365,0.88934,0.90399,0.91821,0.93127,0.94360,0.95465,0.96478,0.97351,0.98120,0.98743,0.99249,0.99622,0.99878,1,1,0.99872,0.99622,0.99243,0.98730,0.98102,0.97339,0.96466,0.95459,0.94354,0.93121,0.91821,0.90411,0.88952,0.87402,0.85821,0.84154,0.82470,0.79424,0.76427,0.73399,0.70414,0.67375,0.64359,0.61301,0.58256,0.55228,0.52213,0.49301,0.46426,0.43740,0.41177,0.38790,0.36666,0.34701,0.32998,0.31539,0.30220,0.29146,0.28230,0.27370,0.26650,0.26003,0.25288,0.24586,0.23897,0.23085,0.22163,0.21223,0.20234,0.19111,0.17903,0.16706,0.15528,0.14295,0.12989,0.11707,0.10505,0.09394,0.08307,0.07239,0.06220,0.05292,0.04486,0.03797,0.03198,0.02649,0.02142,0.01672,0.01257,0.00903,0.00616,0.00403,0.00250,0.00146,0.00079,0.00037,0.00012,0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00006,0.00012,0.00031,0.00055,0.00098,0.00159,0.00244,0.00354,0.00488,0.00653,0.00842,0.01044,0.01257,0.01495,0.01764,0.02069,0.02423,0.02802,0.03198,0.03595,0.03998,0.04431,0.04883,0.05341,0.05762,0.06159,0.06556,0.06958,0.07319,0.07636,0.07929,0.08216,0.08466,0.08674,0.08893,0.09119,0.09333,0.09577,0.09876,0.10206,0.10596,0.11079,0.11616,0.12238,0.12965,0.13740,0.14613,0.15534,0.16505,0.17536,0.18574,0.19642,0.20717,0.21785,0.22865,0.23921,0.24989,0.26039,0.27107,0.28163,0.29244,0.29842,0.30434,0.30996,0.31551,0.32070,0.32576,0.33040,0.33474,0.33870,0.34225,0.34536,0.34810,0.35030,0.35213,0.35342,0.35433,0.35476,0.35476,0.35433,0.35342,0.35207,0.35024,0.34804,0.34530,0.34225,0.33864,0.33474,0.33034,0.32576,0.32076,0.31557,0.31008,0.30446,0.29854,0.29256,0.28176,0.27113,0.26039,0.24983,0.23903,0.22835,0.21748,0.20668,0.19593,0.18525,0.17494,0.16468,0.15516,0.14607,0.13764,0.13007,0.12312,0.11707,0.11188,0.10718,0.10340,0.10016,0.09711,0.09455,0.09223,0.08973,0.08722,0.08478,0.08191,0.07862,0.07526,0.07178,0.06781,0.06348,0.05927,0.05512,0.05072,0.04608,0.04151,0.03729,0.03333,0.02948,0.02570,0.02204,0.01874,0.01593,0.01349,0.01135,0.00940,0.00757,0.00592,0.00446,0.00317,0.00220,0.00140,0.00085,0.00049,0.00024,0.00012,0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.00006,-0.00012,-0.00018,-0.00031,-0.00049,-0.00073,-0.00110,-0.00153,-0.00208,-0.00262,-0.00330,-0.00397,-0.00470,-0.00549,-0.00647,-0.00757,-0.00879,-0.01001,-0.01129,-0.01251,-0.01386,-0.01532,-0.01672,-0.01807,-0.01929,-0.02057,-0.02179,-0.02295,-0.02393,-0.02484,-0.02576,-0.02655,-0.02716,-0.02789,-0.02857,-0.02924,-0.03003,-0.03095,-0.03198,-0.03321,-0.03473,-0.03644,-0.03839,-0.04065,-0.04309,-0.04578,-0.04871,-0.05176,-0.05500,-0.05823,-0.06159,-0.06495,-0.06830,-0.07166,-0.07502,-0.07831,-0.08161,-0.08497,-0.08826,-0.09168,-0.09351,-0.09540,-0.09717,-0.09888,-0.10053,-0.10212,-0.10358,-0.10493,-0.10615,-0.10731,-0.10828,-0.10914,-0.10981,-0.11036,-0.11079,-0.11109,-0.11121,-0.11121,-0.11109,-0.11079,-0.11036,-0.10981,-0.10908,-0.10822,-0.10725,-0.10615,-0.10493,-0.10358,-0.10212,-0.10053,-0.09894,-0.09717,-0.09546,-0.09357,-0.09174,-0.08832,-0.08497,-0.08161,-0.07831,-0.07489,-0.07160,-0.06818,-0.06476,-0.06141,-0.05805,-0.05481,-0.05164,-0.04865,-0.04578,-0.04315,-0.04077,-0.03858,-0.03668,-0.03510,-0.03363,-0.03241,-0.03137,-0.03046,-0.02966,-0.02893,-0.02814,-0.02735,-0.02655,-0.02570,-0.02466,-0.02362,-0.02252,-0.02124,-0.01990,-0.01856,-0.01727,-0.01587,-0.01447,-0.01300,-0.01166,-0.01044,-0.00922,-0.00806,-0.00690,-0.00586,-0.00501,-0.00421,-0.00354,-0.00293,-0.00238,-0.00183,-0.00140,-0.00098,-0.00067,-0.00043,-0.00031,-0.00018,-0.00006,-0.00006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.00006,-0.00006,-0.00012,-0.00024,-0.00037,-0.00055,-0.00079,-0.00116,-0.00153,-0.00195,-0.00244,-0.00293,-0.00348,-0.00409,-0.00482,-0.00562,-0.00653,-0.00745,-0.00836,-0.00934,-0.01032,-0.01135,-0.01245,-0.01343,-0.01434,-0.01526,-0.01624,-0.01709,-0.01782,-0.01849,-0.01917,-0.01972,-0.02020,-0.02075,-0.02124,-0.02173,-0.02234,-0.02301,-0.02381,-0.02472,-0.02582,-0.02710,-0.02851,-0.03021,-0.03205,-0.03406,-0.03620,-0.03845,-0.04090,-0.04328,-0.04578,-0.04828,-0.05078,-0.05329,-0.05579,-0.05823,-0.06067,-0.06318,-0.06568,-0.06818,-0.06958,-0.07093,-0.07227,-0.07355,-0.07477,-0.07593,-0.07703,-0.07801,-0.07892,-0.07978,-0.08051,-0.08112,-0.08167,-0.08210,-0.08240,-0.08259,-0.08271,-0.08271,-0.08259,-0.08240,-0.08204,-0.08167,-0.08112,-0.08051,-0.07978,-0.07892,-0.07801,-0.07703,-0.07593,-0.07477,-0.07355,-0.07227,-0.07099,-0.06958,-0.06818,-0.06568,-0.06318,-0.06067,-0.05823,-0.05573,-0.05323,-0.05066,-0.04816,-0.04566,-0.04315,-0.04077,-0.03839,-0.03620,-0.03406,-0.03211,-0.03034,-0.02869,-0.02728,-0.02606,-0.02496,-0.02411,-0.02332,-0.02265,-0.02204,-0.02149,-0.02094,-0.02033,-0.01978,-0.01911,-0.01831,-0.01758,-0.01672,-0.01581,-0.01477,-0.01379,-0.01282,-0.01184,-0.01074,-0.00971,-0.00867,-0.00775,-0.00690,-0.00598,-0.00513,-0.00439,-0.00372,-0.00311,-0.00262,-0.00220,-0.00177,-0.00140,-0.00104,-0.00073,-0.00049,-0.00031,-0.00018,-0.00012,-0.00006,0,0,0,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},2430,9720,{0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0},{0,0,0},KS_GRADWAVE_RELATIVE,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_WAVE spsp_ss30260334_gz = {{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},2430,9720,{0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0,0,-0.01587,-0.03174,-0.04761,-0.06348,-0.07935,-0.09522,-0.11109,-0.12696,-0.14283,-0.15870,-0.17463,-0.19050,-0.20637,-0.22224,-0.23811,-0.25398,-0.26985,-0.28572,-0.30159,-0.31746,-0.33333,-0.34920,-0.36507,-0.38094,-0.39681,-0.41268,-0.42855,-0.44442,-0.46029,-0.47616,-0.49203,-0.50797,-0.52384,-0.53971,-0.55558,-0.57145,-0.58732,-0.60319,-0.61906,-0.63493,-0.65080,-0.66667,-0.68254,-0.69841,-0.71428,-0.73015,-0.74602,-0.76189,-0.77776,-0.79363,-0.80950,-0.82537,-0.84130,-0.85717,-0.87304,-0.88891,-0.90478,-0.92065,-0.93652,-0.95239,-0.96826,-0.98413,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-0.98413,-0.96826,-0.95239,-0.93652,-0.92065,-0.90478,-0.88891,-0.87304,-0.85717,-0.84130,-0.82537,-0.80950,-0.79363,-0.77776,-0.76189,-0.74602,-0.73015,-0.71428,-0.69841,-0.68254,-0.66667,-0.65080,-0.63493,-0.61906,-0.60319,-0.58732,-0.57145,-0.55558,-0.53971,-0.52384,-0.50797,-0.49203,-0.47616,-0.46029,-0.44442,-0.42855,-0.41268,-0.39681,-0.38094,-0.36507,-0.34920,-0.33333,-0.31746,-0.30159,-0.28572,-0.26985,-0.25398,-0.23811,-0.22224,-0.20637,-0.19050,-0.17463,-0.15870,-0.14283,-0.12696,-0.11109,-0.09522,-0.07935,-0.06348,-0.04761,-0.03174,-0.01587,0,0,0.01587,0.03174,0.04761,0.06348,0.07935,0.09522,0.11109,0.12696,0.14283,0.15870,0.17463,0.19050,0.20637,0.22224,0.23811,0.25398,0.26985,0.28572,0.30159,0.31746,0.33333,0.34920,0.36507,0.38094,0.39681,0.41268,0.42855,0.44442,0.46029,0.47616,0.49203,0.50797,0.52384,0.53971,0.55558,0.57145,0.58732,0.60319,0.61906,0.63493,0.65080,0.66667,0.68254,0.69841,0.71428,0.73015,0.74602,0.76189,0.77776,0.79363,0.80950,0.82537,0.84130,0.85717,0.87304,0.88891,0.90478,0.92065,0.93652,0.95239,0.96826,0.98413,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.98413,0.96826,0.95239,0.93652,0.92065,0.90478,0.88891,0.87304,0.85717,0.84130,0.82537,0.80950,0.79363,0.77776,0.76189,0.74602,0.73015,0.71428,0.69841,0.68254,0.66667,0.65080,0.63493,0.61906,0.60319,0.58732,0.57145,0.55558,0.53971,0.52384,0.50797,0.49203,0.47616,0.46029,0.44442,0.42855,0.41268,0.39681,0.38094,0.36507,0.34920,0.33333,0.31746,0.30159,0.28572,0.26985,0.25398,0.23811,0.22224,0.20637,0.19050,0.17463,0.15870,0.14283,0.12696,0.11109,0.09522,0.07935,0.06348,0.04761,0.03174,0.01587,0},{0,0,0},KS_GRADWAVE_RELATIVE,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)};
const KS_RF spsat_dblsatl0 = {KS_RF_ROLE_SPSAT,90,1267,0,1,4000,0,-1,"GE RF pulse: rfdblsatl0.rho",{((void *)0),((void *)0),0.1641,0.1468,0.1641,0.5723,0.5723,0,0.0894,0.0047,0.0343,90,((void *)0),4000,1267,0,0,0,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},400,4000,{0,-0.00040,-0.00217,-0.00610,-0.01309,-0.02402,-0.03876,-0.05472,-0.06885,-0.07810,-0.07944,-0.07038,-0.05264,-0.02969,-0.00501,0.01776,0.03549,0.04694,0.05329,0.05591,0.05612,0.05530,0.05448,0.05377,0.05313,0.05261,0.05216,0.05179,0.05145,0.05118,0.05090,0.05066,0.05039,0.05011,0.04981,0.04947,0.04910,0.04868,0.04825,0.04773,0.04715,0.04651,0.04575,0.04486,0.04389,0.04282,0.04163,0.04031,0.03894,0.03745,0.03583,0.03406,0.03217,0.03012,0.02789,0.02551,0.02301,0.02036,0.01761,0.01474,0.01178,0.00873,0.00552,0.00220,-0.00107,-0.00464,-0.00839,-0.01224,-0.01627,-0.02039,-0.02469,-0.02905,-0.03351,-0.03803,-0.04257,-0.04709,-0.05164,-0.05615,-0.06070,-0.06525,-0.06983,-0.07440,-0.07898,-0.08353,-0.08805,-0.09253,-0.09693,-0.10126,-0.10550,-0.10965,-0.11371,-0.11765,-0.12143,-0.12506,-0.12854,-0.13181,-0.13489,-0.13773,-0.14032,-0.14267,-0.14475,-0.14658,-0.14811,-0.14933,-0.15021,-0.15079,-0.15104,-0.15091,-0.15040,-0.14954,-0.14826,-0.14661,-0.14451,-0.14200,-0.13904,-0.13565,-0.13184,-0.12760,-0.12287,-0.11771,-0.11206,-0.10596,-0.09937,-0.09226,-0.08466,-0.07657,-0.06800,-0.05890,-0.04932,-0.03925,-0.02872,-0.01767,-0.00620,0.00558,0.01801,0.03088,0.04425,0.05802,0.07227,0.08695,0.10205,0.11759,0.13355,0.14988,0.16657,0.18366,0.20106,0.21882,0.23688,0.25526,0.27390,0.29283,0.31196,0.33134,0.35090,0.37062,0.39048,0.41047,0.43056,0.45073,0.47096,0.49123,0.51149,0.53175,0.55196,0.57207,0.59206,0.61193,0.63161,0.65108,0.67034,0.68932,0.70803,0.72640,0.74444,0.76208,0.77932,0.79611,0.81243,0.82827,0.84353,0.85824,0.87237,0.88586,0.89868,0.91086,0.92233,0.93310,0.94311,0.95239,0.96091,0.96860,0.97549,0.98157,0.98682,0.99118,0.99469,0.99734,0.99911,1,0.99997,0.99911,0.99734,0.99469,0.99118,0.98682,0.98157,0.97549,0.96860,0.96091,0.95239,0.94311,0.93310,0.92233,0.91086,0.89868,0.88586,0.87237,0.85824,0.84353,0.82827,0.81243,0.79611,0.77932,0.76208,0.74444,0.72640,0.70803,0.68932,0.67034,0.65108,0.63161,0.61193,0.59206,0.57207,0.55196,0.53175,0.51149,0.49123,0.47096,0.45073,0.43056,0.41047,0.39048,0.37062,0.35090,0.33134,0.31196,0.29283,0.27390,0.25526,0.23688,0.21882,0.20106,0.18366,0.16657,0.14988,0.13355,0.11759,0.10205,0.08695,0.07227,0.05802,0.04425,0.03088,0.01801,0.00558,-0.00620,-0.01767,-0.02872,-0.03925,-0.04932,-0.05890,-0.06800,-0.07657,-0.08466,-0.09226,-0.09937,-0.10596,-0.11206,-0.11771,-0.12287,-0.12760,-0.13184,-0.13565,-0.13904,-0.14200,-0.14451,-0.14661,-0.14826,-0.14954,-0.15040,-0.15091,-0.15104,-0.15079,-0.15021,-0.14933,-0.14811,-0.14658,-0.14475,-0.14267,-0.14032,-0.13773,-0.13489,-0.13181,-0.12854,-0.12506,-0.12143,-0.11765,-0.11371,-0.10965,-0.10550,-0.10126,-0.09693,-0.09253,-0.08805,-0.08353,-0.07898,-0.07440,-0.06983,-0.06525,-0.06070,-0.05615,-0.05164,-0.04709,-0.04257,-0.03803,-0.03351,-0.02905,-0.02469,-0.02039,-0.01627,-0.01224,-0.00839,-0.00464,-0.00107,0.00220,0.00552,0.00873,0.01178,0.01474,0.01761,0.02036,0.02301,0.02551,0.02789,0.03012,0.03217,0.03406,0.03583,0.03745,0.03894,0.04031,0.04163,0.04282,0.04389,0.04486,0.04575,0.04651,0.04715,0.04773,0.04825,0.04868,0.04910,0.04947,0.04981,0.05011,0.05039,0.05066,0.05090,0.05118,0.05145,0.05179,0.05216,0.05261,0.05313,0.05377,0.05448,0.05530,0.05612,0.05591,0.05329,0.04694,0.03549,0.01776,-0.00501,-0.02969,-0.05264,-0.07038,-0.07944,-0.07810,-0.06885,-0.05472,-0.03876,-0.02402,-0.01309,-0.00610,-0.00217,-0.00040,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF spsatc_satqptbw12 = {KS_RF_ROLE_SPSAT,90,3000,0,1,4000,0,-1,"GE RF pulse: satqptbw12.rho",{((void *)0),((void *)0),0.3472,0.2506,0.3472,0.996,0.996,0,0.105,0.00179175,0.0211646,90,((void *)0),4000,3000,0,0,0,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},1000,4000,{0,0,0.00003,0.00009,0.00015,0.00021,0.00027,0.00027,0.00034,0.00034,0.00027,0.00027,0.00018,0.00006,0.00003,0.00021,0.00040,0.00058,0.00076,0.00092,0.00104,0.00110,0.00116,0.00107,0.00089,0.00058,0.00024,0.00021,0.00079,0.00140,0.00204,0.00262,0.00317,0.00357,0.00372,0.00366,0.00320,0.00244,0.00125,0.00052,0.00250,0.00491,0.00769,0.01062,0.01367,0.01676,0.01975,0.02249,0.02494,0.02689,0.02832,0.02915,0.02939,0.02909,0.02832,0.02710,0.02555,0.02378,0.02185,0.01993,0.01813,0.01648,0.01505,0.01389,0.01306,0.01245,0.01212,0.01193,0.01190,0.01203,0.01218,0.01236,0.01260,0.01273,0.01288,0.01297,0.01294,0.01288,0.01279,0.01260,0.01239,0.01218,0.01203,0.01187,0.01172,0.01172,0.01178,0.01193,0.01221,0.01251,0.01297,0.01346,0.01401,0.01471,0.01544,0.01618,0.01697,0.01782,0.01877,0.01972,0.02075,0.02182,0.02292,0.02402,0.02521,0.02640,0.02762,0.02884,0.03015,0.03141,0.03266,0.03394,0.03525,0.03656,0.03781,0.03910,0.04038,0.04160,0.04285,0.04407,0.04523,0.04639,0.04752,0.04865,0.04975,0.05079,0.05179,0.05274,0.05365,0.05460,0.05539,0.05619,0.05692,0.05762,0.05829,0.05884,0.05936,0.05982,0.06022,0.06055,0.06086,0.06107,0.06119,0.06128,0.06132,0.06125,0.06113,0.06095,0.06071,0.06040,0.06000,0.05961,0.05906,0.05851,0.05790,0.05729,0.05655,0.05582,0.05506,0.05423,0.05344,0.05262,0.05179,0.05094,0.05014,0.04938,0.04865,0.04801,0.04743,0.04697,0.04664,0.04642,0.04630,0.04639,0.04670,0.04712,0.04776,0.04859,0.04963,0.05085,0.05225,0.05387,0.05567,0.05759,0.05970,0.06193,0.06434,0.06681,0.06937,0.07209,0.07487,0.07767,0.08060,0.08356,0.08656,0.08961,0.09263,0.09574,0.09879,0.10188,0.10487,0.10795,0.11094,0.11396,0.11686,0.11982,0.12263,0.12544,0.12816,0.13087,0.13344,0.13594,0.13832,0.14064,0.14290,0.14500,0.14708,0.14894,0.15077,0.15248,0.15401,0.15547,0.15678,0.15800,0.15904,0.15999,0.16078,0.16142,0.16200,0.16243,0.16267,0.16283,0.16286,0.16277,0.16252,0.16222,0.16182,0.16124,0.16063,0.15990,0.15907,0.15822,0.15727,0.15629,0.15532,0.15434,0.15327,0.15230,0.15135,0.15037,0.14958,0.14888,0.14824,0.14778,0.14750,0.14738,0.14750,0.14784,0.14842,0.14934,0.15053,0.15196,0.15376,0.15584,0.15831,0.16103,0.16414,0.16750,0.17116,0.17519,0.17946,0.18404,0.18880,0.19390,0.19911,0.20467,0.21029,0.21618,0.22216,0.22835,0.23461,0.24099,0.24746,0.25399,0.26058,0.26724,0.27386,0.28051,0.28717,0.29385,0.30044,0.30700,0.31351,0.31995,0.32626,0.33252,0.33865,0.34473,0.35059,0.35636,0.36200,0.36743,0.37268,0.37781,0.38276,0.38755,0.39206,0.39646,0.40061,0.40458,0.40833,0.41187,0.41520,0.41831,0.42121,0.42390,0.42637,0.42863,0.43064,0.43250,0.43415,0.43562,0.43687,0.43794,0.43885,0.43965,0.44026,0.44071,0.44108,0.44129,0.44142,0.44151,0.44154,0.44151,0.44148,0.44151,0.44148,0.44154,0.44172,0.44200,0.44239,0.44291,0.44364,0.44456,0.44575,0.44712,0.44883,0.45085,0.45317,0.45588,0.45893,0.46235,0.46617,0.47041,0.47508,0.48015,0.48564,0.49156,0.49791,0.50465,0.51183,0.51940,0.52736,0.53572,0.54445,0.55352,0.56289,0.57262,0.58260,0.59286,0.60339,0.61410,0.62509,0.63617,0.64740,0.65884,0.67032,0.68195,0.69358,0.70523,0.71695,0.72867,0.74027,0.75190,0.76344,0.77485,0.78617,0.79734,0.80839,0.81920,0.82991,0.84029,0.85054,0.86055,0.87023,0.87963,0.88881,0.89767,0.90624,0.91442,0.92223,0.92977,0.93694,0.94378,0.95019,0.95629,0.96191,0.96722,0.97207,0.97656,0.98068,0.98437,0.98770,0.99054,0.99304,0.99518,0.99689,0.99823,0.99918,0.99979,1,0.99991,0.99942,0.99860,0.99750,0.99609,0.99432,0.99234,0.99011,0.98761,0.98483,0.98187,0.97876,0.97540,0.97189,0.96829,0.96454,0.96072,0.95684,0.95285,0.94888,0.94488,0.94091,0.93701,0.93307,0.92925,0.92553,0.92190,0.91848,0.91512,0.91198,0.90905,0.90621,0.90365,0.90133,0.89925,0.89742,0.89577,0.89443,0.89333,0.89251,0.89193,0.89162,0.89159,0.89177,0.89223,0.89293,0.89385,0.89498,0.89626,0.89779,0.89953,0.90139,0.90337,0.90548,0.90774,0.91009,0.91247,0.91497,0.91750,0.92001,0.92254,0.92504,0.92751,0.92996,0.93234,0.93463,0.93679,0.93884,0.94082,0.94265,0.94430,0.94583,0.94717,0.94830,0.94931,0.95010,0.95068,0.95114,0.95135,0.95135,0.95114,0.95068,0.95010,0.94931,0.94830,0.94717,0.94583,0.94430,0.94265,0.94082,0.93884,0.93679,0.93463,0.93234,0.92996,0.92751,0.92504,0.92254,0.92001,0.91750,0.91497,0.91247,0.91009,0.90774,0.90548,0.90337,0.90139,0.89953,0.89779,0.89626,0.89498,0.89385,0.89293,0.89223,0.89177,0.89159,0.89162,0.89193,0.89251,0.89333,0.89443,0.89577,0.89742,0.89925,0.90133,0.90365,0.90621,0.90905,0.91198,0.91512,0.91848,0.92190,0.92553,0.92925,0.93307,0.93701,0.94091,0.94488,0.94888,0.95285,0.95684,0.96072,0.96454,0.96829,0.97189,0.97540,0.97876,0.98187,0.98483,0.98761,0.99011,0.99234,0.99432,0.99609,0.99750,0.99860,0.99942,0.99991,1,0.99979,0.99918,0.99823,0.99689,0.99518,0.99304,0.99054,0.98770,0.98437,0.98068,0.97656,0.97207,0.96722,0.96191,0.95629,0.95019,0.94378,0.93694,0.92977,0.92223,0.91442,0.90624,0.89767,0.88881,0.87963,0.87023,0.86055,0.85054,0.84029,0.82991,0.81920,0.80839,0.79734,0.78617,0.77485,0.76344,0.75190,0.74027,0.72867,0.71695,0.70523,0.69358,0.68195,0.67032,0.65884,0.64740,0.63617,0.62509,0.61410,0.60339,0.59286,0.58260,0.57262,0.56289,0.55352,0.54445,0.53572,0.52736,0.51940,0.51183,0.50465,0.49791,0.49156,0.48564,0.48015,0.47508,0.47041,0.46617,0.46235,0.45893,0.45588,0.45317,0.45085,0.44883,0.44712,0.44575,0.44456,0.44364,0.44291,0.44239,0.44200,0.44172,0.44154,0.44148,0.44151,0.44148,0.44151,0.44154,0.44151,0.44142,0.44129,0.44108,0.44071,0.44026,0.43965,0.43885,0.43794,0.43687,0.43562,0.43415,0.43250,0.43064,0.42863,0.42637,0.42390,0.42121,0.41831,0.41520,0.41187,0.40833,0.40458,0.40061,0.39646,0.39206,0.38755,0.38276,0.37781,0.37268,0.36743,0.36200,0.35636,0.35059,0.34473,0.33865,0.33252,0.32626,0.31995,0.31351,0.30700,0.30044,0.29385,0.28717,0.28051,0.27386,0.26724,0.26058,0.25399,0.24746,0.24099,0.23461,0.22835,0.22216,0.21618,0.21029,0.20467,0.19911,0.19390,0.18880,0.18404,0.17946,0.17519,0.17116,0.16750,0.16414,0.16103,0.15831,0.15584,0.15376,0.15196,0.15053,0.14934,0.14842,0.14784,0.14750,0.14738,0.14750,0.14778,0.14824,0.14888,0.14958,0.15037,0.15135,0.15230,0.15327,0.15434,0.15532,0.15629,0.15727,0.15822,0.15907,0.15990,0.16063,0.16124,0.16182,0.16222,0.16252,0.16277,0.16286,0.16283,0.16267,0.16243,0.16200,0.16142,0.16078,0.15999,0.15904,0.15800,0.15678,0.15547,0.15401,0.15248,0.15077,0.14894,0.14708,0.14500,0.14290,0.14064,0.13832,0.13594,0.13344,0.13087,0.12816,0.12544,0.12263,0.11982,0.11686,0.11396,0.11094,0.10795,0.10487,0.10188,0.09879,0.09574,0.09263,0.08961,0.08656,0.08356,0.08060,0.07767,0.07487,0.07209,0.06937,0.06681,0.06434,0.06193,0.05970,0.05759,0.05567,0.05387,0.05225,0.05085,0.04963,0.04859,0.04776,0.04712,0.04670,0.04639,0.04630,0.04642,0.04664,0.04697,0.04743,0.04801,0.04865,0.04938,0.05014,0.05094,0.05179,0.05262,0.05344,0.05423,0.05506,0.05582,0.05655,0.05729,0.05790,0.05851,0.05906,0.05961,0.06000,0.06040,0.06071,0.06095,0.06113,0.06125,0.06132,0.06128,0.06119,0.06107,0.06086,0.06055,0.06022,0.05982,0.05936,0.05884,0.05829,0.05762,0.05692,0.05619,0.05539,0.05460,0.05365,0.05274,0.05179,0.05079,0.04975,0.04865,0.04752,0.04639,0.04523,0.04407,0.04285,0.04160,0.04038,0.03910,0.03781,0.03656,0.03525,0.03394,0.03266,0.03141,0.03015,0.02884,0.02762,0.02640,0.02521,0.02402,0.02292,0.02182,0.02075,0.01972,0.01877,0.01782,0.01697,0.01618,0.01544,0.01471,0.01401,0.01346,0.01297,0.01251,0.01221,0.01193,0.01178,0.01172,0.01172,0.01187,0.01203,0.01218,0.01239,0.01260,0.01279,0.01288,0.01294,0.01297,0.01288,0.01273,0.01260,0.01236,0.01218,0.01203,0.01190,0.01193,0.01212,0.01245,0.01306,0.01389,0.01505,0.01648,0.01813,0.01993,0.02185,0.02378,0.02555,0.02710,0.02832,0.02909,0.02939,0.02915,0.02832,0.02689,0.02494,0.02249,0.01975,0.01676,0.01367,0.01062,0.00769,0.00491,0.00250,0.00052,0.00125,0.00244,0.00320,0.00366,0.00372,0.00357,0.00317,0.00262,0.00204,0.00140,0.00079,0.00021,0.00024,0.00058,0.00089,0.00107,0.00116,0.00110,0.00104,0.00092,0.00076,0.00058,0.00040,0.00021,0.00003,0.00006,0.00018,0.00027,0.00027,0.00034,0.00034,0.00027,0.00027,0.00021,0.00015,0.00009,0.00003,0,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},1000,4000,{0.000,0.000,180.000,180.000,180.000,180.000,168.689,168.689,170.535,170.535,168.689,168.689,161.564,134.997,0.000,0.000,0.000,-5.708,-8.746,-7.120,-9.460,-8.971,-8.526,-12.525,-11.306,-16.695,-26.561,-165.959,180.000,175.232,173.479,173.655,172.611,171.606,170.980,169.936,168.486,166.288,158.196,26.561,-1.329,-4.763,-6.532,-7.240,-8.092,-8.806,-9.350,-9.850,-10.520,-11.135,-11.773,-12.476,-13.316,-14.283,-15.409,-16.640,-18.227,-19.947,-22.111,-24.539,-27.385,-30.648,-33.933,-37.493,-41.014,-43.860,-46.557,-48.365,-49.760,-50.513,-51.210,-51.886,-52.331,-52.815,-53.644,-54.880,-56.380,-58.324,-60.511,-63.313,-66.691,-70.438,-74.816,-79.518,-84.572,-90.000,-95.395,-100.701,-106.090,-111.304,-116.446,-121.005,-125.340,-129.366,-133.157,-136.750,-140.013,-142.979,-145.765,-148.423,-150.912,-153.159,-155.323,-157.422,-159.257,-161.042,-162.789,-164.387,-165.882,-167.332,-168.667,-170.002,-171.238,-172.474,-173.617,-174.688,-175.770,-176.781,-177.814,-178.786,-179.703,179.346,178.451,177.522,176.632,175.781,174.891,174.029,173.188,172.320,171.518,170.612,169.782,168.903,168.035,167.162,166.288,165.365,164.426,163.481,162.536,161.564,160.559,159.542,158.438,157.367,156.246,155.076,153.873,152.615,151.291,149.918,148.489,147.006,145.424,143.781,142.040,140.216,138.260,136.217,134.069,131.806,129.372,126.801,124.038,121.170,118.132,114.940,111.578,108.096,104.349,100.575,96.658,92.664,88.566,84.457,80.364,76.310,72.267,68.378,64.604,60.961,57.457,54.067,50.908,47.859,44.959,42.272,39.674,37.202,34.900,32.697,30.648,28.621,26.770,24.962,23.265,21.606,20.040,18.508,17.052,15.651,14.283,12.959,11.668,10.410,9.202,7.993,6.823,5.680,4.538,3.417,2.296,1.209,0.115,-0.967,-2.044,-3.142,-4.214,-5.312,-6.394,-7.504,-8.603,-9.740,-10.872,-12.020,-13.195,-14.382,-15.613,-16.854,-18.118,-19.425,-20.760,-22.139,-23.534,-24.984,-26.495,-28.044,-29.637,-31.291,-33.016,-34.796,-36.636,-38.553,-40.548,-42.608,-44.750,-46.953,-49.266,-51.666,-54.144,-56.704,-59.341,-62.066,-64.873,-67.751,-70.679,-73.673,-76.722,-79.777,-82.891,-85.990,-89.105,-92.186,-95.241,-98.273,-101.256,-104.179,-107.030,-109.804,-112.523,-115.149,-117.687,-120.159,-122.538,-124.834,-127.054,-129.202,-131.256,-133.256,-135.179,-137.030,-138.821,-140.562,-142.249,-143.875,-145.462,-146.990,-148.478,-149.934,-151.346,-152.725,-154.087,-155.406,-156.708,-157.977,-159.235,-160.471,-161.685,-162.899,-164.085,-165.272,-166.448,-167.612,-168.777,-169.936,-171.090,-172.249,-173.402,-174.567,-175.726,-176.902,-178.077,-179.269,179.522,178.319,177.088,175.852,174.594,173.314,172.023,170.705,169.365,168.002,166.607,165.195,163.750,162.278,160.773,159.235,157.663,156.059,154.417,152.741,151.027,149.275,147.484,145.660,143.792,141.892,139.952,137.980,135.975,133.926,131.860,129.762,127.636,125.493,123.340,121.165,118.973,116.781,114.583,112.392,110.200,108.024,105.860,103.717,101.591,99.493,97.416,95.373,93.368,91.395,89.456,87.555,85.699,83.875,82.095,80.353,78.661,77.002,75.382,73.805,72.267,70.762,69.295,67.867,66.471,65.114,63.780,62.483,61.214,59.973,58.764,57.577,56.413,55.276,54.160,53.062,51.985,50.930,49.892,48.870,47.865,46.876,45.893,44.931,43.975,43.031,42.097,41.168,40.251,39.339,38.433,37.532,36.636,35.746,34.856,33.966,33.076,32.186,31.302,30.412,29.522,28.627,27.731,26.836,25.929,25.012,24.100,23.177,22.243,21.304,20.353,19.403,18.431,17.453,16.470,15.470,14.459,13.437,12.399,11.350,10.289,9.213,8.125,7.021,5.906,4.774,3.631,2.478,1.307,0.126,-1.066,-2.269,-3.488,-4.713,-5.949,-7.196,-8.449,-9.707,-10.971,-12.240,-13.503,-14.772,-16.041,-17.305,-18.563,-19.821,-21.062,-22.298,-23.523,-24.732,-25.929,-27.105,-28.264,-29.401,-30.516,-31.610,-32.675,-33.714,-34.724,-35.708,-36.664,-37.581,-38.471,-39.328,-40.152,-40.938,-41.696,-42.410,-43.091,-43.739,-44.344,-44.915,-45.448,-45.948,-46.404,-46.827,-47.206,-47.557,-47.859,-48.129,-48.359,-48.552,-48.705,-48.821,-48.892,-48.931,-48.931,-48.892,-48.821,-48.705,-48.552,-48.359,-48.129,-47.859,-47.557,-47.206,-46.827,-46.404,-45.948,-45.448,-44.915,-44.344,-43.739,-43.091,-42.410,-41.696,-40.938,-40.152,-39.328,-38.471,-37.581,-36.664,-35.708,-34.724,-33.714,-32.675,-31.610,-30.516,-29.401,-28.264,-27.105,-25.929,-24.732,-23.523,-22.298,-21.062,-19.821,-18.563,-17.305,-16.041,-14.772,-13.503,-12.240,-10.971,-9.707,-8.449,-7.196,-5.949,-4.713,-3.488,-2.269,-1.066,0.126,1.307,2.478,3.631,4.774,5.906,7.021,8.125,9.213,10.289,11.350,12.399,13.437,14.459,15.470,16.470,17.453,18.431,19.403,20.353,21.304,22.243,23.177,24.100,25.012,25.929,26.836,27.731,28.627,29.522,30.412,31.302,32.186,33.076,33.966,34.856,35.746,36.636,37.532,38.433,39.339,40.251,41.168,42.097,43.031,43.975,44.931,45.893,46.876,47.865,48.870,49.892,50.930,51.985,53.062,54.160,55.276,56.413,57.577,58.764,59.973,61.214,62.483,63.780,65.114,66.471,67.867,69.295,70.762,72.267,73.805,75.382,77.002,78.661,80.353,82.095,83.875,85.699,87.555,89.456,91.395,93.368,95.373,97.416,99.493,101.591,103.717,105.860,108.024,110.200,112.392,114.583,116.781,118.973,121.165,123.340,125.493,127.636,129.762,131.860,133.926,135.975,137.980,139.952,141.892,143.792,145.660,147.484,149.275,151.027,152.741,154.417,156.059,157.663,159.235,160.773,162.278,163.750,165.195,166.607,168.002,169.365,170.705,172.023,173.314,174.594,175.852,177.088,178.319,179.522,-179.269,-178.077,-176.902,-175.726,-174.567,-173.402,-172.249,-171.090,-169.936,-168.777,-167.612,-166.448,-165.272,-164.085,-162.899,-161.685,-160.471,-159.235,-157.977,-156.708,-155.406,-154.087,-152.725,-151.346,-149.934,-148.478,-146.990,-145.462,-143.875,-142.249,-140.562,-138.821,-137.030,-135.179,-133.256,-131.256,-129.202,-127.054,-124.834,-122.538,-120.159,-117.687,-115.149,-112.523,-109.804,-107.030,-104.179,-101.256,-98.273,-95.241,-92.186,-89.105,-85.990,-82.891,-79.777,-76.722,-73.673,-70.679,-67.751,-64.873,-62.066,-59.341,-56.704,-54.144,-51.666,-49.266,-46.953,-44.750,-42.608,-40.548,-38.553,-36.636,-34.796,-33.016,-31.291,-29.637,-28.044,-26.495,-24.984,-23.534,-22.139,-20.760,-19.425,-18.118,-16.854,-15.613,-14.382,-13.195,-12.020,-10.872,-9.740,-8.603,-7.504,-6.394,-5.312,-4.214,-3.142,-2.044,-0.967,0.115,1.209,2.296,3.417,4.538,5.680,6.823,7.993,9.202,10.410,11.668,12.959,14.283,15.651,17.052,18.508,20.040,21.606,23.265,24.962,26.770,28.621,30.648,32.697,34.900,37.202,39.674,42.272,44.959,47.859,50.908,54.067,57.457,60.961,64.604,68.378,72.267,76.310,80.364,84.457,88.566,92.664,96.658,100.575,104.349,108.096,111.578,114.940,118.132,121.170,124.038,126.801,129.372,131.806,134.069,136.217,138.260,140.216,142.040,143.781,145.424,147.006,148.489,149.918,151.291,152.615,153.873,155.076,156.246,157.367,158.438,159.542,160.559,161.564,162.536,163.481,164.426,165.365,166.288,167.162,168.035,168.903,169.782,170.612,171.518,172.320,173.188,174.029,174.891,175.781,176.632,177.522,178.451,179.346,-179.703,-178.786,-177.814,-176.781,-175.770,-174.688,-173.617,-172.474,-171.238,-170.002,-168.667,-167.332,-165.882,-164.387,-162.789,-161.042,-159.257,-157.422,-155.323,-153.159,-150.912,-148.423,-145.765,-142.979,-140.013,-136.750,-133.157,-129.366,-125.340,-121.005,-116.446,-111.304,-106.090,-100.701,-95.395,-90.000,-84.572,-79.518,-74.816,-70.438,-66.691,-63.313,-60.511,-58.324,-56.380,-54.880,-53.644,-52.815,-52.331,-51.886,-51.210,-50.513,-49.760,-48.365,-46.557,-43.860,-41.014,-37.493,-33.933,-30.648,-27.385,-24.539,-22.111,-19.947,-18.227,-16.640,-15.409,-14.283,-13.316,-12.476,-11.773,-11.135,-10.520,-9.850,-9.350,-8.806,-8.092,-7.240,-6.532,-4.763,-1.329,26.561,158.196,166.288,168.486,169.936,170.980,171.606,172.611,173.655,173.479,175.232,180.000,-165.959,-26.561,-16.695,-11.306,-12.525,-8.526,-8.971,-9.460,-7.120,-8.746,-5.708,0.000,0.000,0.000,134.997,161.564,168.689,168.689,170.535,170.535,168.689,168.689,180.000,180.000,180.000,180.000,0.000,0.000},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)}};
const KS_RF chemsat_csm = {KS_RF_ROLE_CHEMSAT,90,0,0,1,16000,0,-1,"GE RF pulse: rfcsm.rho",{((void *)0),((void *)0),0.3652,0.2468,0.2734,0.5329,0.5329,0,0.01342,0.000712,0.00667,90,((void *)0),16000,0,0,0,0,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},320,16000,{0,0,0.00009,0.00043,0.00098,0.00189,0.00320,0.00501,0.00739,0.01035,0.01404,0.01852,0.02387,0.03015,0.03742,0.04563,0.05454,0.06394,0.07361,0.08335,0.09293,0.10208,0.11066,0.11838,0.12503,0.13041,0.13425,0.13633,0.13645,0.13465,0.13111,0.12601,0.11960,0.11206,0.10361,0.09442,0.08469,0.07465,0.06452,0.05451,0.04477,0.03558,0.02710,0.01938,0.01233,0.00589,0.00006,-0.00513,-0.01007,-0.01465,-0.01892,-0.02298,-0.02686,-0.03064,-0.03436,-0.03812,-0.04196,-0.04590,-0.04993,-0.05405,-0.05823,-0.06250,-0.06687,-0.07126,-0.07575,-0.08026,-0.08484,-0.08948,-0.09412,-0.09879,-0.10352,-0.10825,-0.11298,-0.11771,-0.12247,-0.12720,-0.13193,-0.13663,-0.14133,-0.14597,-0.15061,-0.15519,-0.15970,-0.16416,-0.16855,-0.17289,-0.17716,-0.18131,-0.18540,-0.18937,-0.19321,-0.19697,-0.20057,-0.20405,-0.20740,-0.21058,-0.21363,-0.21650,-0.21918,-0.22169,-0.22404,-0.22614,-0.22806,-0.22977,-0.23127,-0.23252,-0.23356,-0.23432,-0.23484,-0.23511,-0.23508,-0.23481,-0.23423,-0.23338,-0.23225,-0.23081,-0.22907,-0.22703,-0.22468,-0.22202,-0.21903,-0.21577,-0.21216,-0.20823,-0.20399,-0.19941,-0.19449,-0.18925,-0.18366,-0.17777,-0.17151,-0.16495,-0.15806,-0.15082,-0.14325,-0.13535,-0.12711,-0.11856,-0.10965,-0.10044,-0.09088,-0.08103,-0.07083,-0.06034,-0.04953,-0.03842,-0.02704,-0.01538,-0.00342,0.00855,0.02100,0.03375,0.04672,0.05994,0.07340,0.08710,0.10102,0.11515,0.12949,0.14405,0.15879,0.17374,0.18888,0.20420,0.21970,0.23536,0.25120,0.26719,0.28330,0.29957,0.31596,0.33244,0.34904,0.36567,0.38240,0.39915,0.41594,0.43275,0.44954,0.46632,0.48308,0.49977,0.51640,0.53298,0.54946,0.56581,0.58208,0.59822,0.61425,0.63012,0.64580,0.66134,0.67666,0.69179,0.70672,0.72143,0.73586,0.75005,0.76400,0.77764,0.79101,0.80404,0.81677,0.82916,0.84121,0.85287,0.86419,0.87509,0.88562,0.89569,0.90536,0.91461,0.92343,0.93176,0.93966,0.94711,0.95410,0.96060,0.96661,0.97214,0.97720,0.98175,0.98581,0.98935,0.99240,0.99493,0.99695,0.99847,0.99948,1,0.99997,0.99948,0.99847,0.99695,0.99496,0.99246,0.98944,0.98596,0.98199,0.97757,0.97266,0.96728,0.96146,0.95517,0.94845,0.94131,0.93377,0.92581,0.91742,0.90866,0.89953,0.89001,0.88012,0.86990,0.85934,0.84848,0.83731,0.82586,0.81411,0.80212,0.78991,0.77743,0.76476,0.75188,0.73882,0.72558,0.71230,0.69900,0.68578,0.67272,0.65993,0.64745,0.63540,0.62383,0.61281,0.60244,0.59279,0.58394,0.57595,0.56880,0.56227,0.55605,0.54991,0.54360,0.53682,0.52934,0.52089,0.51122,0.50008,0.48720,0.47237,0.45528,0.43574,0.41371,0.38957,0.36375,0.33662,0.30854,0.27998,0.25126,0.22282,0.19498,0.16819,0.14280,0.11914,0.09766,0.07868,0.06235,0.04843,0.03677,0.02716,0.01938,0.01328,0.00858,0.00513,0.00275,0.00122,0.00040,0.00003,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
const KS_RF chemsat_cs3t = {KS_RF_ROLE_CHEMSAT,95,0,0,1,8000,0,-1,"GE RF pulse: rfcs3t.rho",{((void *)0),((void *)0),0.3208,0.2021,0.2103,0.455,0.395,0,0.03684,0.002194,0.01656,95,((void *)0),8000,0,0,0,0,1,((void *)0),0,((void *)0) },{{0,0,((void *)0),sizeof(KS_WAVE)},{[0 ... (128 -1)] = 0},200,8000,{0,-0.00336,-0.01581,-0.04364,-0.09174,-0.15022,-0.20088,-0.22511,-0.20918,-0.16383,-0.10700,-0.05707,-0.02606,-0.01050,-0.00439,-0.00171,0.00092,0.00397,0.00732,0.01105,0.01514,0.01947,0.02411,0.02887,0.03382,0.03900,0.04431,0.04987,0.05561,0.06134,0.06714,0.07282,0.07843,0.08399,0.08936,0.09461,0.09968,0.10438,0.10877,0.11286,0.11658,0.12000,0.12305,0.12580,0.12818,0.13001,0.13142,0.13233,0.13288,0.13300,0.13276,0.13191,0.13032,0.12775,0.12434,0.12012,0.11524,0.10975,0.10377,0.09730,0.09040,0.08307,0.07526,0.06678,0.05750,0.04749,0.03681,0.02558,0.01404,0.00220,-0.00989,-0.02246,-0.03546,-0.04877,-0.06238,-0.07618,-0.09009,-0.10407,-0.11811,-0.13203,-0.14582,-0.15949,-0.17286,-0.18599,-0.19868,-0.21101,-0.22285,-0.23415,-0.24489,-0.25496,-0.26430,-0.27272,-0.28035,-0.28700,-0.29274,-0.29756,-0.30129,-0.30385,-0.30526,-0.30538,-0.30422,-0.30172,-0.29787,-0.29268,-0.28621,-0.27840,-0.26930,-0.25893,-0.24721,-0.23408,-0.21950,-0.20350,-0.18617,-0.16755,-0.14771,-0.12666,-0.10438,-0.08094,-0.05634,-0.03064,-0.00391,0.02381,0.05249,0.08216,0.11256,0.14375,0.17555,0.20796,0.24086,0.27419,0.30788,0.34188,0.37618,0.41067,0.44516,0.47952,0.51358,0.54721,0.58048,0.61326,0.64555,0.67723,0.70817,0.73814,0.76714,0.79479,0.82110,0.84575,0.86877,0.89007,0.90966,0.92755,0.94372,0.95807,0.97034,0.98059,0.98865,0.99457,0.99835,1,0.99945,0.99683,0.99200,0.98511,0.97619,0.96527,0.95251,0.93792,0.92163,0.90374,0.88439,0.86370,0.84185,0.81884,0.79491,0.77013,0.74461,0.71837,0.69157,0.66435,0.63676,0.60905,0.58121,0.55338,0.52561,0.49820,0.47555,0.46499,0.47378,0.50595,0.54404,0.56186,0.53379,0.44558,0.32137,0.19307,0.09168,0.03321,0.00708,0},{0,0,0},-1,{[0 ... (500 -1)] = {-1, -1, 1.0}},((void *)0),((void *)0),((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)},{{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}};
long _firstcv = 0;
int psd_annefact_level = 0
;
int rhpsd_annefact_level = 0
;
float psd_relative_excited_volume_freq = -1.0
;
float psd_relative_excited_volume_phase = -1.0
;
float psd_relative_excited_volume_slice = 1.0
;
float psd_relative_encoded_volume_freq = -1.0
;
float psd_relative_encoded_volume_phase = 1.0
;
float psd_relative_encoded_volume_slice = 1.0
;
int opresearch = 0
;
float opweight = 50
;
int oplandmark = 0
;
int optabent = 0
;
int opentry = 1
;
int oppos = 1
;
int opplane = 1
;
int opphysplane = 1
;
int opobplane = 1
;
int opimode = 1
;
int oppseq = 1
;
int opgradmode = 0
;
int opanatomy = 0
;
int piimgoptlist = 0
;
int opcgate = 0
;
int opexor = 0
;
int opcmon = 0
;
int opfcomp = 0
;
int opgrx = 0
;
int opgrxroi = 0
;
int opnopwrap = 0
;
int opptsize = 2
;
int oppomp = 0
;
int opscic = 0
;
int oprect = 0
;
int opsquare = 0
;
int opvbw = 0
;
int opblim = 0
;
int opfast = 0
;
int opcs = 0
;
int opdeprep = 0
;
int opirprep = 0
;
int opsrprep = 0
;
int opmph = 0
;
int opdynaplan = 0
;
int opdynaplan_mask_phase = 0
;
int opbsp = 0
;
int oprealtime = 0
;
int opfluorotrigger = 0
;
int opET = 0
;
int opmultistation = 0
;
int opepi = 0
;
int opflair = 0
;
int opt1flair = 0
;
int opt2flair = 0
;
int opdoubleir = 0
;
int optissuet1 = 0
;
int opautotissuet1 = 0
;
int optlrdrf = 0
;
int opfulltrain = 0
;
int opirmode = 1
;
int opmt = 0
;
int opzip512 = 0
;
int opzip1024 = 0
;
int opslzip2 = 0
;
int opslzip4 = 0
;
int opsmartprep = 0
;
int opssrf = 0
;
int opt2prep = 0
;
int opspiral = 0
;
int opnav = 0
;
int opfmri = 0
;
int opectricks = 0
;
int optricksdel = 1000000
;
int optrickspause = 1
;
int opfr = 0
;
int opcube = 0
;
int ophydro = 0
;
int opphasecycle = 0
;
int oplava = 0
;
int op3dcine_fiesta = 0
;
int op3dcine_spgr = 0
;
int op4dflow = 0
;
int opbrava = 0
;
int opcosmic = 0
;
int opvibrant = 0
;
int opbravo = 0
;
int opdisco = 0
;
int opmprage = 0
;
int oppromo = 0
;
int opprop = 0
;
int opdwprop = 0
;
int opdwpropduo = 0
;
int opmuse = 0
;
int opallowedrescantime = 0
;
int opbreastmrs = 0
;
int opjrmode = 0
;
int opssfse = 0
;
int t1flair_flag = 0
;
int opphsen = 0
;
int opbc = 0
;
int opfatwater = 0
;
int oprtbc = 0
;
int opnseg = 1
;
int opnnex = 0
;
int opsilent = 0
;
int opsilentlevel = 1
;
int opmerge = 0
;
int opswan = 0
;
int opphaseimage = 0
;
int opdixon = 0
;
int opdixproc = 0
;
int opmedal = 0
;
int opquickstep = 0
;
int opidealiq = 0
;
int opsilentmr = 0
;
int opmagic = 0
;
float opzoom_fov_xy = 440.0
;
float opzoom_fov_z = 350.0
;
float opzoom_dist_ax = 120.0
;
float opzoom_dist_cor = 120.0
;
float opzoom_dist_sag = 150.0
;
int app_grad_type = 0
;
int opzoom_coil_ind = 0
;
int pizoom_index = 0
;
int opsat = 0
;
int opsatx = 0
;
int opsaty = 0
;
int opsatz = 0
;
float opsatxloc1 = 9999
;
float opsatxloc2 = 9999
;
float opsatyloc1 = 9999
;
float opsatyloc2 = 9999
;
float opsatzloc1 = 9999
;
float opsatzloc2 = 9999
;
float opsatxthick = 40.0
;
float opsatythick = 40.0
;
float opsatzthick = 40.0
;
int opsatmask = 0
;
int opfat = 0
;
int opwater = 0
;
int opccsat = 0
;
int opfatcl = 0
;
int opspecir = 0
;
int opexsatmask = 0
;
float opexsathick1 = 40.0
;
float opexsathick2 = 40.0
;
float opexsathick3 = 40.0
;
float opexsathick4 = 40.0
;
float opexsathick5 = 40.0
;
float opexsathick6 = 40.0
;
float opexsatloc1 = 9999
;
float opexsatloc2 = 9999
;
float opexsatloc3 = 9999
;
float opexsatloc4 = 9999
;
float opexsatloc5 = 9999
;
float opexsatloc6 = 9999
;
int opexsatparal = 0
;
int opexsatoff1 = 0
;
int opexsatoff2 = 0
;
int opexsatoff3 = 0
;
int opexsatoff4 = 0
;
int opexsatoff5 = 0
;
int opexsatoff6 = 0
;
int opexsatlen1 = 480
;
int opexsatlen2 = 480
;
int opexsatlen3 = 480
;
int opexsatlen4 = 480
;
int opexsatlen5 = 480
;
int opexsatlen6 = 480
;
float opdfsathick1 = 40.0
;
float opdfsathick2 = 40.0
;
float opdfsathick3 = 40.0
;
float opdfsathick4 = 40.0
;
float opdfsathick5 = 40.0
;
float opdfsathick6 = 40.0
;
float exsat1_normth_R = 0;
float exsat1_normth_A = 0;
float exsat1_normth_S = 0;
float exsat2_normth_R = 0;
float exsat2_normth_A = 0;
float exsat2_normth_S = 0;
float exsat3_normth_R = 0;
float exsat3_normth_A = 0;
float exsat3_normth_S = 0;
float exsat4_normth_R = 0;
float exsat4_normth_A = 0;
float exsat4_normth_S = 0;
float exsat5_normth_R = 0;
float exsat5_normth_A = 0;
float exsat5_normth_S = 0;
float exsat6_normth_R = 0;
float exsat6_normth_A = 0;
float exsat6_normth_S = 0;
float exsat1_dist = 0;
float exsat2_dist = 0;
float exsat3_dist = 0;
float exsat4_dist = 0;
float exsat5_dist = 0;
float exsat6_dist = 0;
int pigirscrn = 0;
int piautoirbands = 0;
float pigirdefthick = 200.0;
int pinumgir = 2
;
int opnumgir = 0
;
int pigirmode = 3
;
int opgirmode = 0
;
int optagging = 0
;
int optagspc = 7
;
float optagangle = 45.0
;
float opvenc = 50.0
;
int opflaxx = 0
;
int opflaxy = 0
;
int opflaxz = 0
;
int opflaxall = 0
;
int opproject = 0
;
int opcollapse = 1
;
int oprlflow = 0
;
int opapflow = 0
;
int opsiflow = 0
;
int opmagc = 1
;
int opflrecon = 0
;
int oprampdir = 0
;
int project = 0
;
int vas_ovrhd = 0
;
int slice_col = 1
;
int phase_col = 0
;
int read_col = 0
;
int mag_mask = 1
;
int phase_cor = 1
;
int extras = 0
;
int mag_create = 1
;
int rl_flow = 0
;
int ap_flow = 0
;
int si_flow = 0
;
int imagenum = 1
;
int motsa_ovrhd = 0
;
int opslinky = 0
;
int opinhance = 0
;
int opmavric = 0
;
int opinhsflow = 0
;
int opmsde = 0
;
float opvest = 50.0
;
int opmsdeaxx = 0
;
int opmsdeaxy = 0
;
int opmsdeaxz = 0
;
int opbreathhold= 0
;
int opautosubtract = 0
;
int opsepseries = 0
;
int pititle = 0 ;
float opuser0 = 0 ;
float opuser1 = 0 ;
float opuser2 = 0 ;
float opuser3 = 0 ;
float opuser4 = 0 ;
float opuser5 = 0 ;
float opuser6 = 0 ;
float opuser7 = 0 ;
float opuser8 = 0 ;
float opuser9 = 0 ;
float opuser10 = 0 ;
float opuser11 = 0 ;
float opuser12 = 0 ;
float opuser13 = 0 ;
float opuser14 = 0 ;
float opuser15 = 0 ;
float opuser16 = 0 ;
float opuser17 = 0 ;
float opuser18 = 0 ;
float opuser19 = 0 ;
float opuser20 = 0 ;
float opuser21 = 0 ;
float opuser22 = 0 ;
float opuser23 = 0 ;
float opuser24 = 0 ;
float opuser25 = 0 ;
float opuser26 = 0 ;
float opuser27 = 0 ;
float opuser28 = 0 ;
float opuser29 = 0 ;
float opuser30 = 0 ;
float opuser31 = 0 ;
float opuser32 = 0 ;
float opuser33 = 0 ;
float opuser34 = 0 ;
float opuser35 = 0 ;
float opuser36 = 0 ;
float opuser37 = 0 ;
float opuser38 = 0 ;
float opuser39 = 0 ;
float opuser40 = 0 ;
float opuser41 = 0 ;
float opuser42 = 0 ;
float opuser43 = 0 ;
float opuser44 = 0 ;
float opuser45 = 0 ;
float opuser46 = 0 ;
float opuser47 = 0 ;
float opuser48 = 0 ;
int opnostations = 1
;
int opstation = 1
;
int oploadprotocol = 0
;
int opmask = 0
;
int opvenous = 0
;
int opprotRxMode = 0
;
int opacqo = 1
;
int opfphases = 1
;
int opsldelay = 50000
;
int avminsldelay = 50000
;
int optphases = 1
;
int opdynaplan_nphases = 1
;
int opvsphases = 1
;
int opdiffuse = 0
;
int opsavedf = 0
;
int opmintedif = 1
;
int opseparatesynb = 1
;
int opdfaxx = 0;
int opdfaxy = 0;
int opdfaxz = 0;
int opdfaxall = 0;
int opdfaxtetra = 0;
int opdfax3in1 = 0;
int opbval = 0
;
int opnumbvals = 1
;
int opautonumbvals = 0
;
int opnumsynbvals = 0
;
float opdifnext2 = 1
;
int opautodifnext2 = 0
;
int optensor = 0
;
int opdifnumdirs = 1
;
int opdifnumt2 = 1
;
int opautodifnumt2 = 0
;
int opdualspinecho = 0
;
int opdifproctype = 0
;
int opdifnumbvalues = 1
;
int dti_plus_flag = 0
;
int optouch = 0
;
int optouchfreq = 60
;
int optouchmegfreq = 60
;
int optouchamp = 30
;
int optouchtphases = 4
;
int optouchcyc = 3
;
int optouchax = 4
;
int opaslprep = 0
;
int opasl = 0
;
float oppostlabeldelay = 1525.0
;
int rhchannel_combine_method = 0
;
int rhasl_perf_weighted_scale = 32
;
float cfslew_artmedium = 2.0
;
float cfgmax_artmedium = 3.3
;
float cfslew_arthigh = 2.0
;
float cfgmax_arthigh = 3.3
;
int cfnumartlevels = 0
;
int pinumartlevels = 0
;
float cfslew_artmediumopt = 5.0
;
float cfgmax_artmediumopt = 2.2
;
int oprep_active = 1
;
int oprep_rest = 1
;
int opdda = 0
;
int opinit_state = 0
;
int opfMRIPDTYPE = 0
;
int opview_order = 1
;
int opslice_order = 0
;
int oppsd_trig = 0
;
int oppdgm_str = -1
;
int opbwrt = 0
;
int cont_flag = 0
;
int opautonecho = 1
;
int opnecho = 1
;
int opnshots = 1
;
int opautote = 0
;
int opte = 25000
;
int opte2 = 50000
;
int optefw = 0
;
int opti = 50000
;
int opbspti = 50000
;
int opautoti = 0
;
int opautobti = 0
;
int optrecovery = 0
;
int optlabel = 2000000
;
int opt2prepte = 25000
;
int opautotr = 0
;
int opnspokes = 128
;
float opoversamplingfactor = 1.0
;
int opacs = 4
;
int opharmonize = 0
;
int pieffbladewidth = 1
;
int opinrangetr = 0
;
int opinrangetrmin = 160000
;
int opinrangetrmax = 10000000
;
int optr = 400000
;
float opflip = 90
;
int opautoflip = 0
;
int opautoetl = 0
;
int opetl = 8
;
int opautorbw = 0
;
float oprbw = 16.0
;
float oprbw2 = 16.0
;
float opfov = 500
;
float opphasefov = 1
;
float opnpwfactor = 1.0
;
float opfreqfov = 1
;
int opautoslquant = 0
;
int opslquant = 1
;
int opsllocs = 1
;
float opslthick = 5
;
float opslspace = 10
;
int opileave = 0
;
int opcoax = 1
;
float opvthick = 320
;
int opvquant = 1
;
int opovl = 0
;
float oplenrl = 0
;
float oplenap = 0
;
float oplensi = 0
;
float oplocrl = 0
;
float oplocap = 0
;
float oplocsi = 0
;
float oprlcsiis = 1
;
float opapcsiis = 2
;
float opsicsiis = 3
;
float opmonfov = 200
;
float opmonthick = 20
;
float opinittrigdelay = 1000000
;
int opxres = 256
;
int opyres = 128
;
int opautonex = 0
;
float opnex = 1
;
int opslicecnt = 0
;
int opnbh = 0
;
int opspf = 0
;
int opcfsel = 2
;
int opfcaxis = 0
;
int opphcor = 0
;
float opdose = 0
;
int opcontrast = 0
;
int opchrate = 100
;
int opcphases = 1
;
int opaphases = 1
;
int opclocs = 1
;
int ophrate = 60
;
int oparr = 10
;
int ophrep = 1
;
int opautotdel1 = 0
;
int optdel1 = 20000
;
int optseq = 1
;
int opphases = 1
;
int opcardseq = 0
;
int opmphases = 0
;
int oparrmon = 1
;
int opvps = 8
;
int opautovps = 0
;
int opcgatetype = CARDIAC_GATE_TYPE_NONE
;
int opadvgate = 0
;
int opfcine = 0
;
int opcineir = 0
;
int opstress = 0
;
int opnrr = 0
;
int opnrr_dda = 8
;
int oprtcgate = 0
;
int oprtrate = 12
;
int oprtrep = 1
;
int oprttdel1 = 20000
;
int oprttseq = 1
;
int oprtcardseq = 0
;
int oprtarr = 10
;
int oprtpoint= 10
;
int opnavrrmeas = 0
;
int opnavrrmeastime = 20
;
int opnavrrmeasrr = 12
;
int opnavsltrack = 0
;
int opnavautoaccwin = 0
;
float opnavaccwin = 2.0
;
int opnavautotrigtime = 10
;
int opnavpsctime = 10
;
int opnavmaxinterval = 200
;
int opnavtype = PSD_NAV_TYPE_90_180
;
int opnavpscpause = 0
;
int opnavsigenhance = 0
;
int opasset = 0
;
int opassetcal = 0
;
int opassetscan = 0
;
int rhcoilno = 0
;
int rhcal_options = 0
;
int rhasset = 0
;
int rhasset_calthresh = 10000
;
float rhasset_R = 0.5
;
int rhasset_phases = 1
;
float rhscancent = 0.0
;
int rhasset_alt_cal = 0
;
int rhasset_torso = 0
;
int rhasset_localTx = 0
;
float rhasset_TuningFactor = 15.0
;
float rhasset_SnrMin = 15.0
;
float rhasset_SnrMax = 75.0
;
float rhasset_SnrScalar = 1.0
;
int oppure = 0
;
int rhpure = 0
;
int oppurecal = 0
;
int rhpurechannel = 0
;
int rhpurefilter= 0
;
float rhpure_scale_factor = 1.0
;
int cfpure_filtering_mode = 1
;
int rhpure_filtering_mode = 1
;
float rhpure_lambda = 10.0
;
float rhpure_tuning_factor_surface = 0.0
;
float rhpure_tuning_factor_body = 1.0
;
float rhpure_derived_cal_fraction = 0.0
;
float rhpure_cal_reapodization = 12.0
;
int opcalrequired = 0
;
int rhpure_blur_enable = 0
;
float rhpure_blur = 0.0
;
float rhpure_mix_lambda = 10.0
;
float rhpure_mix_tuning_factor_surface = 0.0
;
float rhpure_mix_tuning_factor_body = 1.0
;
int rhpure_mix_blur_enable = 0
;
float rhpure_mix_blur = 0.0
;
float rhpure_mix_alpha = 0.0
;
int rhpure_mix_otsu_class_qty = 2
;
float rhpure_mix_exp_wt = 0.0
;
int rhpure_mix_erode_dist = 0
;
int rhpure_mix_dilate_dist = 0
;
int rhpure_mix_aniso_blur = 0
;
int rhpure_mix_aniso_erode_dist = 0
;
int rhpure_mix_aniso_dilate_dist = 0
;
int opcalmode = CAL_MODE_STANDARD
;
int rhcalmode = 0
;
int opcaldelay = 5000000
;
int rhcal_pass_set_vector = 12
;
int rhcal_nex_vector = 101
;
int rhcal_weight_vector = 101
;
int sifsetwokey = 0
;
int opautosldelay = 0
;
int specnuc = 1
;
int specpts = 256
;
int specwidth = 2000
;
int specnavs = 1
;
int specnex = 2
;
int specdwells = 1
;
int acquire_type = 0
;
int pixmtband = 1
;
int pibbandfilt = 0
;
int opwarmup = 0
;
int pscahead = 0
;
int opprescanopt = 0
;
int autoadvtoscn = 0
;
int opapa = 0
;
int oppscapa = 0
;
int PSslice_ind = 0
;
int oppscshimtg = 0
;
int opdyntg = 0
;
float dynTG_fov = 500
;
int dynTG_slquant = 1
;
float dynTG_flipangle = 60.0
;
float dynTG_slthick = 10.0
;
int dynTG_xres = 64
;
int dynTG_yres = 64
;
int dynTG_baseline = 0
;
int dynTG_ptsize = 4
;
float dynTG_b1factor = 1.0
;
float rfshim_fov = 500
;
int rfshim_slquant = 1
;
float rfshim_flipangle = 60.0
;
float rfshim_slthick = 10.0
;
int rfshim_xres = 64
;
int rfshim_yres = 64
;
int rfshim_baseline = 0
;
int rfshim_ptsize = 4
;
float rfshim_b1factor = 1.0
;
int cal_xres = 32
;
int cal_yres = 32
;
int cal_slq = 36
;
int cal_nex = 2
;
int cal_interleave = 0
;
float cal_fov = 500
;
float cal_slthick = 15
;
int cal_pass = 2
;
int coil_xres = 32
;
int coil_yres = 32
;
int coil_slq = 36
;
int coil_nex = 2
;
float coil_fov = 500
;
float coil_slthick = 15
;
int coil_pass = 1
;
int coil_interleave = 0
;
float asfov = 500
;
int asslquant = 1
;
float asflip = 20
;
float asslthick = 10
;
int asxres = 256
;
int asyres = 128
;
int asbaseline = 8
;
int asrhblank = 4
;
int asptsize = 4
;
int opascalcfov = 0
;
float tgfov = 500
;
int tgcap = 200
;
int tgwindow = 200
;
int oppscvquant = 0
;
int opdrivemode = 1
;
int pidrivemodenub = 7
;
int opexcitemode = 0
;
float lp_stretch = 2.0
;
int lp_mode = 0
;
float derateb1_body_factor = 1.0
;
float SAR_bodyNV_weight_lim = 110.0
;
float derateb1_NV_factor = 1.0
;
float jstd_multiplier_body = 0.145
;
float jstd_multiplier_NV = 0.0137
;
float jstd_exponent_body = 0.763
;
float jstd_exponent_NV = 1.154
;
int pidiffmode = 0;
int pifmriscrn = 0;
int piresol = 0
;
int pioverlap = 0
;
int piforkvrgf = 0;
int pinofreqoffset = 0;
int pirepactivenub = 0;
int pireprestnub = 0;
int piddanub = 0;
int piinitstatnub = 0;
int piviewordernub = 0;
int pisliceordnub = 0;
int pipsdtrignub = 0;
int pispssupnub = 1;
int pi_neg_sp = 0
;
float piisvaldef = 2.0
;
int pi2dmde = 0
;
int pidmode = 0
;
int piviews = 0
;
int piclckcnt = 1
;
float avmintscan = 0.0
;
float pitslice = 0.0
;
float pitscan = 0.0
;
float pimscan = 0.0
;
float pivsscan = 0.0
;
float pireconlag = -3.0
;
float pitres = 0.0
;
float pitres2 = 0.0
;
int pisaveinter = 0
;
int pivextras = 0
;
int pinecho = 0
;
float piscancenter = 0.0
;
float pilandmark = 0.0
;
float pitableposition = 0.0
;
int pismode = 0
;
int pishldctrl = 0
;
int pinolr = 1
;
int pinoadc = 0
;
int pimixtime = 0
;
int pishim2 = 0
;
int pi1stshimb = 0
;
float pifractecho = 1.0
;
int nope = 0
;
int opuser_usage_tag = 0x00000000
;
int rhuser_usage_tag = 0x00000000
;
int rhFillMapMSW = 0x00000000
;
int rhFillMapLSW = 0x00000000
;
int rhbline = 0
;
int rhblank = 4
;
int rhnex = 1
;
int rhnavs = 1
;
int rhnslices = 1
;
int rhnrefslices = 0
;
int rhnframes = 256
;
int rhfrsize = 256
;
int rhnecho = 1
;
int rhnphases = 1
;
int rhmphasetype = 0
;
int rhtrickstype = 0
;
int rhtype = 0
;
int rhtype1 = 0
;
int rhformat = 0
;
int rhptsize = 2
;
int rhnpomp = 1
;
int rhrcctrl = 1
;
int rhdacqctrl = 2
;
int rhexecctrl = (0x0001 | 0x0008)
;
int rhfdctrl = 0
;
float rhxoff = 0.0
;
float rhyoff = 0.0
;
int rhrecon = 0
;
int rhdatacq = 0
;
int rhvquant = 0
;
int rhslblank = 2
;
int rhhnover = 0
;
int rhfeextra = 0
;
int rhheover = 0
;
int rhoscans = 0
;
int rhddaover = 0
;
float rhzeroph = 128.5
;
float rhalpha = 0.46
;
float rhnwin = 0.0
;
float rhntran = 2.0
;
int rhherawflt = 0
;
float rhherawflt_befnwin = 1.0
;
float rhherawflt_befntran = 2.0
;
float rhherawflt_befamp = 1.0
;
float rhherawflt_hpfamp = 1.0
;
float rhfermw = 10.0
;
float rhfermr = 128.0
;
float rhferme = 1.0
;
float rhclipmin = 0.0
;
float rhclipmax = 16383.0
;
float rhdoffset = 0.0
;
int rhudasave = 0
;
int rhsspsave = 0
;
float rh2dscale = 1.0
;
float rh3dscale = 1.0
;
int rhnpasses = 1
;
int rhincrpass = 1
;
int rhinitpass = 1
;
int rhmethod = 0
;
int rhdaxres = 256
;
int rhdayres = 256
;
int rhrcxres = 256
;
int rhrcyres = 256
;
int rhimsize = 256
;
int rhnoncart_dual_traj = 0
;
int rhnoncart_traj_kmax_ratio = 8
;
int rhnspokes_lowres = 8192
;
int rhnspokes_highres = 8192
;
int rhnoncart_traj_merge_start = 3
;
int rhnoncart_traj_merge_end = 5
;
float rhoversamplingfactor = 1.0
;
float rhnoncart_grid_factor = 2.0
;
int rhnoncart_traj_mode = 0x00
;
int rhviewSharing3D = 0
;
int rhdaviewsPerBlade = 24
;
float rhrotationThreshold = 2.0
;
float rhshiftThreshold = 0.01
;
float rhcorrelationThreshold = 0.50
;
float rhphaseCorrFiltFreqRadius = 1.0
;
float rhphaseCorrFiltPhaseRadius = 1.0
;
float rhnpwfactor = 1.0
;
float rhuser0 = 0 ;
float rhuser1 = 0 ;
float rhuser2 = 0 ;
float rhuser3 = 0 ;
float rhuser4 = 0 ;
float rhuser5 = 0 ;
float rhuser6 = 0 ;
float rhuser7 = 0 ;
float rhuser8 = 0 ;
float rhuser9 = 0 ;
float rhuser10 = 0 ;
float rhuser11 = 0 ;
float rhuser12 = 0 ;
float rhuser13 = 0 ;
float rhuser14 = 0 ;
float rhuser15 = 0 ;
float rhuser16 = 0 ;
float rhuser17 = 0 ;
float rhuser18 = 0 ;
float rhuser19 = 0 ;
float rhuser20 = 0 ;
float rhuser21 = 0 ;
float rhuser22 = 0 ;
float rhuser23 = 0 ;
float rhuser24 = 0 ;
float rhuser25 = 0 ;
float rhuser26 = 0 ;
float rhuser27 = 0 ;
float rhuser28 = 0 ;
float rhuser29 = 0 ;
float rhuser30 = 0 ;
float rhuser31 = 0 ;
float rhuser32 = 0 ;
float rhuser33 = 0 ;
float rhuser34 = 0 ;
float rhuser35 = 0 ;
float rhuser36 = 0 ;
float rhuser37 = 0 ;
float rhuser38 = 0 ;
float rhuser39 = 0 ;
float rhuser40 = 0 ;
float rhuser41 = 0 ;
float rhuser42 = 0 ;
float rhuser43 = 0 ;
float rhuser44 = 0 ;
float rhuser45 = 0 ;
float rhuser46 = 0 ;
float rhuser47 = 0 ;
float rhuser48 = 0 ;
int rhdab0s = 0
;
int rhdab0e = 0
;
float rhctr = 1.0
;
float rhcrrtime = 1.0
;
int rhcphases = 1
;
int rhaphases = 1
;
int rhovl = 0
;
int rhvtype = 0
;
float rhvenc = 0.0
;
float rhvcoefxa = 0.0
;
float rhvcoefxb = 0.0
;
float rhvcoefxc = 0.0
;
float rhvcoefxd = 0.0
;
float rhvcoefya = 0.0
;
float rhvcoefyb = 0.0
;
float rhvcoefyc = 0.0
;
float rhvcoefyd = 0.0
;
float rhvcoefza = 0.0
;
float rhvcoefzb = 0.0
;
float rhvcoefzc = 0.0
;
float rhvcoefzd = 0.0
;
float rhvmcoef1 = 0.0
;
float rhvmcoef2 = 0.0
;
float rhvmcoef3 = 0.0
;
float rhvmcoef4 = 0.0
;
float rhphasescale = 1.0
;
float rhfreqscale = 1.0
;
int rawmode = 0
;
int rhileaves = 1
;
int rhkydir = 0
;
int rhalt = 0
;
int rhreps = 1
;
int rhref = 1
;
int rhpcthrespts = 2
;
int rhpcthrespct = 15
;
int rhpcdiscbeg = 0
;
int rhpcdiscmid = 0
;
int rhpcdiscend = 0
;
int rhpcileave = 0
;
int rhpcextcorr = 0
;
int rhrefframes = 0
;
int rhpcsnore = 0
;
int rhpcspacial = 0
;
int rhpctemporal = 0
;
float rhpcbestky = 64.0
;
int rhhdbestky = 0
;
int rhpcinvft = 0
;
int rhpcctrl = 0
;
int rhpctest = 0
;
int rhpcgraph = 0
;
int rhpclin = 0
;
int rhpclinnorm = 0
;
int rhpclinnpts = 0
;
int rhpclinorder = 2
;
int rhpclinfitwt = 0
;
int rhpclinavg = 0
;
int rhpccon = 0
;
int rhpcconnorm = 0
;
int rhpcconnpts = 2
;
int rhpcconorder = 2
;
int rhpcconfitwt = 0
;
int rhvrgfxres = 128
;
int rhvrgf = 0
;
int rhbp_corr = 0
;
float rhrecv_freq_s = 0.0
;
float rhrecv_freq_e = 0.0
;
int rhhniter = 0
;
int rhfast_rec = 0
;
int rhgridcontrol = 0
;
int rhb0map = 0
;
int rhtediff = 0
;
float rhradiusa = 0
;
float rhradiusb = 0
;
float rhmaxgrad = 0.0
;
float rhslewmax = 0.0
;
float rhscanfov = 0.0
;
float rhtsamp = 0.0
;
float rhdensityfactor = 0.0
;
float rhdispfov = 0.0
;
int rhmotioncomp = 0
;
int grid_fov_factor = 2
;
int rhte = 25000
;
int rhte2 = 50000
;
int rhdfm = 0
;
int rhdfmnavsperpass = 1
;
int rhdfmnavsperview = 1
;
float rhdfmrbw = 4.0
;
int rhdfmptsize = 2
;
int rhdfmxres = 32
;
int rhdfmdebug = 0
;
float rhdfmthreshold = 0.0
;
int rh_rc_enhance_enable = 0
;
int rh_ime_scic_enable = 0
;
float rh_ime_scic_edge = 0.0
;
float rh_ime_scic_smooth = 0.0
;
float rh_ime_scic_focus = 0.0
;
int rh_ime_clariview_type = 0
;
float rh_ime_clariview_edge = 0.0
;
float rh_ime_clariview_smooth = 0.0
;
float rh_ime_clariview_focus = 0.0
;
int rh_ime_definefilter_nr = 0
;
int rh_ime_definefilter_sh = 0
;
float rh_ime_scic_reduction = 0.0
;
float rh_ime_scic_gauss = 0.0
;
float rh_ime_scic_threshold = 0.0
;
float rh_ime_scic_contrast = 0.0
;
int cfscic_allowed = 1
;
float cfscic_edge = 0.0
;
float cfscic_smooth = 0.0
;
float cfscic_focus = 0.0
;
float cfscic_reduction = 0.0
;
float cfscic_gauss = 0.0
;
float cfscic_threshold = 0.0
;
float cfscic_contrast = 0.0
;
int piscic = 0
;
int cfscenic = 0
;
int piscenic = 0
;
int opscenic = 0
;
int rhscenic_type = 0
;
int cfn4_allowed = 1
;
float cfn4_slice_down_sample_rate = 1.0
;
float cfn4_inplane_down_sample_rate = 0.15
;
int cfn4_num_levels_max = 4
;
int cfn4_num_iterations_max = 50
;
float cfn4_convergence_threshold = 0.001
;
int cfn4_gain_clamp_mode = 0
;
float cfn4_gain_clamp_value = 5.0
;
float rhn4_slice_down_sample_rate = 1.0
;
float rhn4_inplane_down_sample_rate = 0.15
;
int rhn4_num_levels_max = 4
;
int rhn4_num_iterations_max = 50
;
float rhn4_convergence_threshold = 0.002
;
int rhn4_gain_clamp_mode = 0
;
float rhn4_gain_clamp_value = 5.0
;
int rhpure_gain_clamp_mode = 0
;
float rhpure_gain_clamp_value = 5.0
;
int rhphsen_pixel_offset = 0
;
int rhapp = 0
;
int rhapp_option = 0
;
int rhncoilsel = 0
;
int rhncoillimit = 45
;
int rhrefframep = 0
;
int rhscnframe = 0
;
int rhpasframe = 0
;
int rhpcfitorig = 1
;
int rhpcshotfirst = 0
;
int rhpcshotlast = 0
;
int rhpcmultegrp = 0
;
int rhpclinfix = 1
;
float rhpclinslope = 0.0
;
int rhpcconfix = 1
;
float rhpcconslope = 0.0
;
int rhpccoil = 1
;
float rhmaxcoef1a = 0
;
float rhmaxcoef1b = 0
;
float rhmaxcoef1c = 0
;
float rhmaxcoef1d = 0
;
float rhmaxcoef2a = 0
;
float rhmaxcoef2b = 0
;
float rhmaxcoef2c = 0
;
float rhmaxcoef2d = 0
;
float rhmaxcoef3a = 0
;
float rhmaxcoef3b = 0
;
float rhmaxcoef3c = 0
;
float rhmaxcoef3d = 0
;
int rhdptype = 0
;
int rhnumbvals = 1
;
int rhdifnext2 = 1
;
int rhnumdifdirs = 1
;
int rhutctrl = 0
;
float rhzipfact = 0
;
int rhfcinemode = 0
;
int rhfcinearw = 10
;
int rhvps = 8
;
int rhvvsaimgs = 1
;
int rhvvstr = 0
;
int rhvvsgender = 0
;
int rhgradmode = 0;
int rhfatwater = 0
;
int rhfiesta = 0
;
int rhlcfiesta = 0
;
float rhlcfiesta_phase = 0.0
;
int rhdwnavview = 0
;
int rhdwnavcorecho = 2
;
int rhdwnavsview = 1
;
int rhdwnaveview = 1
;
int rhdwnavsshot = 1
;
int rhdwnaveshot = 2
;
float rhdwnavcoeff = 0.5
;
int rhdwnavcor = 0
;
float rhassetsl_R = 1.0
;
float rhasset_slwrap = 0.0
;
int rh3dwintype = 0
;
float rh3dwina = 0.1
;
float rh3dwinq = 0.0
;
int rhectricks_num_regions = 0;
int rhectricks_input_regions = 0;
int rhretro_control = 0
;
int rhetl = 0
;
int rhleft_blank = 0
;
int rhright_blank = 0
;
float rhspecwidth = 0.0
;
int rhspeccsidims = 0
;
int rhspecrescsix = 0
;
int rhspecrescsiy = 0
;
int rhspecrescsiz = 0
;
float rhspecroilenx = 0.0
;
float rhspecroileny = 0.0
;
float rhspecroilenz = 0.0
;
float rhspecroilocx = 0.0
;
float rhspecroilocy = 0.0
;
float rhspecroilocz = 0.0
;
int rhexciterusage = 1
;
int rhexciterfreqs = 1
;
int rhwiener = 0
;
float rhwienera = 0.0
;
float rhwienerb = 0.0
;
float rhwienert2 = 0.0
;
float rhwieneresp = 0.0
;
int rhflipfilter = 0
;
int rhdbgrecon = 0
;
int rhech2skip = 0
;
int rhrcideal = 0
;
int rhrcdixproc = 0
;
int rhrcidealctrl = 0
;
int rhdf = 210
;
int rhmedal_mode = 0
;
int rhmedal_nstack_size = 54
;
int rhmedal_echo_order = 0
;
int rhmedal_up_kernel_size = 15
;
int rhmedal_down_kernel_size = 8
;
int rhmedal_smooth_kernel_size = 8
;
int rhmedal_starting_slice = 0
;
int rhmedal_ending_slice = 10
;
float rhmedal_param = 3.0
;
int rhvibrant = 0
;
int rhkacq_uid = 0
;
int rhnex_unacquired = 1
;
int rhdiskacqctrl = 0
;
int rhechopc_extra_bot = 0
;
int rhechopc_ylines = 0
;
int rhechopc_primary_yfirst = 0
;
int rhechopc_reverse_yfirst = 0
;
int rhechopc_zlines = 0
;
int rhechopc_yxfitorder = 1
;
int rhechopc_ctrl = 0
;
int rhchannel_combine_filter_type = 0
;
float rhchannel_combine_filter_width = 0.3
;
float rhchannel_combine_filter_beta = 2
;
float rh_low_pass_nex_filter_width = 8.0
;
int rh3dgw_interptype = 0
;
int rhrc3dcinectrl = 0
;
int rhncycles_cine = 0
;
int rhnvircchannel = 0
;
int rhrc_cardt1map_ctrl = 0
;
int rhrc_moco_ctrl = 0
;
int rhrc_algorithm_ctrl = 0
;
int ihtr = 100
;
int ihti = 0
;
int ihtdel1 = 10
;
float ihnex = 1
;
float ihflip = 90
;
int ihte1 = 0
;
int ihte2 = 0
;
int ihte3 = 0
;
int ihte4 = 0
;
int ihte5 = 0
;
int ihte6 = 0
;
int ihte7 = 0
;
int ihte8 = 0
;
int ihte9 = 0
;
int ihte10 = 0
;
int ihte11 = 0
;
int ihte12 = 0
;
int ihte13 = 0
;
int ihte14 = 0
;
int ihte15 = 0
;
int ihte16 = 0
;
int ihdixonte = 0
;
int ihdixonipte = 0
;
int ihdixonoopte = 0
;
float ihvbw1 = 16.0
;
float ihvbw2 = 16.0
;
float ihvbw3 = 16.0
;
float ihvbw4 = 16.0
;
float ihvbw5 = 16.0
;
float ihvbw6 = 16.0
;
float ihvbw7 = 16.0
;
float ihvbw8 = 16.0
;
float ihvbw9 = 16.0
;
float ihvbw10 = 16.0
;
float ihvbw11 = 16.0
;
float ihvbw12 = 16.0
;
float ihvbw13 = 16.0
;
float ihvbw14 = 16.0
;
float ihvbw15 = 16.0
;
float ihvbw16 = 16.0
;
int ihnegscanspacing = 0
;
int ihoffsetfreq = 1200
;
int ihbsoffsetfreq = 4000
;
int iheesp = 0
;
int ihfcineim = 0
;
int ihfcinent = 0
;
int ihbspti = 50000
;
float ihtagfa = 180.0
;
float ihtagor = 45.0
;
float ih_idealdbg_cv1 = 0 ;
float ih_idealdbg_cv2 = 0 ;
float ih_idealdbg_cv3 = 0 ;
float ih_idealdbg_cv4 = 0 ;
float ih_idealdbg_cv5 = 0 ;
float ih_idealdbg_cv6 = 0 ;
float ih_idealdbg_cv7 = 0 ;
float ih_idealdbg_cv8 = 0 ;
float ih_idealdbg_cv9 = 0 ;
float ih_idealdbg_cv10 = 0 ;
float ih_idealdbg_cv11 = 0 ;
float ih_idealdbg_cv12 = 0 ;
float ih_idealdbg_cv13 = 0 ;
float ih_idealdbg_cv14 = 0 ;
float ih_idealdbg_cv15 = 0 ;
float ih_idealdbg_cv16 = 0 ;
float ih_idealdbg_cv17 = 0 ;
float ih_idealdbg_cv18 = 0 ;
float ih_idealdbg_cv19 = 0 ;
float ih_idealdbg_cv20 = 0 ;
float ih_idealdbg_cv21 = 0 ;
float ih_idealdbg_cv22 = 0 ;
float ih_idealdbg_cv23 = 0 ;
float ih_idealdbg_cv24 = 0 ;
float ih_idealdbg_cv25 = 0 ;
float ih_idealdbg_cv26 = 0 ;
float ih_idealdbg_cv27 = 0 ;
float ih_idealdbg_cv28 = 0 ;
float ih_idealdbg_cv29 = 0 ;
float ih_idealdbg_cv30 = 0 ;
float ih_idealdbg_cv31 = 0 ;
float ih_idealdbg_cv32 = 0 ;
int ihlabeltime = 0
;
int ihpostlabeldelay = 0
;
int ihnew_series = 0
;
int ihcardt1map_hb_pattern = 0
;
int dbdt_option_key_status = 0
;
int dbdt_mode = 0
;
int opsarmode = 0
;
int cfdbdttype = 0
;
float cfrinf = 23.4
;
int cfrfact = 334
;
float cfdbdtper_norm = 80.0
;
float cfdbdtper_cont = 100.0
;
float cfdbdtper_max = 200.0
;
int cfnumicn = 1
;
int cfdppericn = 4
;
int cfgradcoil = 2;
int cfswgut = 4;
int cfswrfut = 2;
int cfswssput = 1;
int cfhwgut = 4;
int cfhwrfut = 2;
int cfhwssput = 1;
int cfoption = -1
;
int cfrfboardtype = 0
;
int psd_board_type = PSDDVMR
;
int opdfm = 0
;
int opdfmprescan = 0
;
int cfdfm = 0
;
int cfdfmTG = 70
;
int cfdfmR1 = 13
;
int cfdfmDX = 0
;
int derate_ACGD = 0
;
int rhextra_frames_top = 0
;
int rhextra_frames_bot = 0
;
int rhpc_ref_start = 0
;
int rhpc_ref_stop = 0
;
int rhpc_ref_skip = 0
;
int opaxial_slice=0
;
int opsagittal_slice =0
;
int opcoronal_slice=0
;
int opvrg = 0
;
int opmart = 0
;
int piassetscrn = 0
;
int opseriessave = 0
;
int opt1map = 0
;
int opt2map = 0
;
int opmer2 = 0
;
int rhnew_wnd_level_flag = 1
;
int rhwnd_image_hist_area = 60
;
float rhwnd_high_hist = 1.0
;
float rhwnd_lower_hist = 1.0
;
int rhrcmavric_control = 0
;
int rhrcmavric_image = 0
;
int rhrcmavric_bin_separation = 1000
;
int cfrfupa = -50
;
int cfrfupd = 50
;
int cfrfminblank = 200
;
int cfrfminunblk = 200
;
int cfrfminblanktorcv = 50
;
float cfrfampftconst = 0.784
;
float cfrfampftlinear = 0.0
;
float cfrfampftquadratic = 15.125
;
int opradialrx = 0
;
int cfsupportreceivefreqbands = 0
;
float cfcntfreefreqlow = 0.0
;
float cfcntfreefreqhigh = 10000.0
;
int optracq = 0
;
int opswift = 0
;
int rhswiftenable = 0
;
int rhnumCoilConfigs = 0
;
int rhnumslabs = 1
;
int opncoils = 1
;
int rtsar_first_series_flag = 0
;
int rtsar_enable_flag = 0
;
int measured_TG = -1
;
int predicted_TG = -1
;
float sar_correction_factor = 1.0
;
int gradHeatMethod = 0
;
int gradHeatFile = 0
;
int gradCoilMethod = GRADIENT_COIL_METHOD_AUTO
;
int gradHeatFlag = 0
;
int xgd_optimization = 1
;
int gradChokeFlag = 0
;
int piburstmode = 0
;
int opburstmode = 0
;
int burstreps = 1
;
float piburstcooltime = 0.0
;
float opaccel_ph_stride = 1.0
;
float opaccel_sl_stride = 1.0
;
float opaccel_t_stride = 1.0
;
int opaccel_mb_stride = 2
;
int opmb = 0
;
int rhmb_factor = 1
;
int rhmb_slice_fov_shift_factor = 1
;
int rhmb_slice_order_sign = 1
;
int rhmuse = 0
;
int rhmuse_nav = 0
;
int rhmuse_nav_accel = 1
;
int rhmuse_nav_hnover = 16
;
int rhmuse_nav_yres = 96
;
float opaccel_cs_stride = 1.0
;
int opcompressedsensing = 0
;
float rhcs_factor = 1.0
;
int rhcs_flag = 0
;
int rhcs_maxiter = 3
;
float rhcs_consistency = 0
;
int rhcs_ph_stride = 1
;
int rhcs_sl_stride = 1
;
int oparc = 0
;
int opaccel_kt_stride = 8
;
int rhkt_factor = 1
;
int rhkt_cal_factor = 1
;
int rhkt_calwidth_ph = 0
;
int rhkt_calwidth_sl = 0
;
int opab1 = 0
;
int op3dgradwarp = 0
;
int opauto3dgradwarp = 1
;
int cfmaxtransmitoffsetfreq = 650000
;
int cfreceiveroffsetfreq = 0
;
int cfcoilswitchmethod = 0x0004
;
int TG_record = 0
;
int ab1_enable = 0
;
int cfreceivertype = CFG_VAL_RECEIVER_RRX
;
int cfreceiverswitchtype = CFG_VAL_RCV_SWITCH_RF_HUB
;
int cfEllipticDriveEnable = 0
;
int pi3dgradwarpnub = 1
;
int cfDualDriveCapable = 0
;
int optrip = 0
;
int oprtb0 = 0
;
int pirtb0vis = 0
;
int pirtb0nub = 0
;
int ophoecc = 0
;
int rhhoecc = 0
;
int rhhoec_fit_order = 3
;
int opdistcorr = 0
;
int pidistcorrnub = 0
;
int pidistcorrdefval = 0
;
int rhdistcorr_ctrl = 0
;
int rhdistcorr_B0_filter_size = 5
;
float rhdistcorr_B0_filter_std_dev = 1.5
;
int ihdistcorr = 0
;
int rhtensor_file_number = 0
;
int ihpepolar = 0
;

int rhesp = 500






;


int viewshd_num = 0






;


float grad_intensity_thres = 3.0






;

int anne_mask_dilation_length = 2






;

float anne_intensity_thres = 0.0






;

float anne_channel_percentage = 0.4






;

int ec3_iterations = 1






;

float combined_coil_map_thres = 0.15






;

float coil_map_smooth_factor = 0.02






;

float coil_map_2_filter_width = 0.02






;

int ec3_iteration_method = 0






;


int edr_support = 0






;

float recon_bandwidth_factor = 1.0






;



int dacq_data_type = 0






;

int rawmode_scaling = 0






;

float rawmode_scaling_factor = 1.0






;


int oprgcalmode = RG_CAL_MODE_MEASURED






;


int opnumgroups = 0






;


int opsarburst = 0






;

int opheadscout = 0






;

int rhposition_detection = 0






;


int opfus = 0






;

int opexamnum = 0






;

int opseriesnum = 0






;



int vol_shift_type = 0






;

int vol_shift_constraint_type = 0






;


int vol_scale_type = 0






;

int vol_scale_constraint_type = 0






;


int rhsnrnoise = 0






;

int rhvircpolicy = 0






;

int rhvirsenstype = 1






;

int rhvircoiltype = 1






;

int rhvircoilunif = 0






;

int rhvircoilchannels = 1






;

int cffield = 15000






;

float act_field_strength = 30000.0






;

int enableReceiveFreqBands = 0






;

int offsetReceiveFreqLower = 0






;

int offsetReceiveFreqHigher = 0






;

int cfrfamptyp = 0






;

int cfssctype = 0






;

int cfbodycoiltype = PSD_15_XRM_BODY_COIL






;

int cfptxcapable = 0






;


int cfbdcabletglimit = 1






;


int cfcablefreq = 226






;


int cfcabletg = 175






;


int cfcablebw = 500






;

int opgradshim = 2






;

int track_flag = 0






;



int prevent_scan_under_emul = 0






;


int acqs = 1






;

int avround = 1






;

int baseline = 0






;


int nex = 1






;

float trunex = 1.0






;

int isOddNexGreaterThanOne = 0






;

int isNonIntNexGreaterThanOne = 0






;






float fn = 1.0






;

int enablfracdec = 1






;

int npw_flag = 0






;

float nop = 1.0






;

int acq_type = 0






;

int seq_type = TYPNCAT






;

int num_images = 1






;


int recon_mag_image = 1






;

int recon_pha_image = 0






;

int recon_imag_image = 0






;

int recon_qmag_image = 0






;


int slquant1 = 1






;

int psd_grd_wait = 56






;

int psd_rf_wait = 0






;




int pos_moment_start = 0






;






int mps1rf1_inst = 0






;

int scanrf1_inst = 0






;


int cfcarddelay = 10






;


int psd_card_hdwr_delay = 0






;


float GAM = 4257.59






;

int off90 = 80






;

int TR_SLOP = 2000






;

int TR_PASS = 50000






;

int TR_PASS3D = 550000






;

int csweight= 100






;



int exnex = 1






;

float truenex = 0.0






;

int eg_phaseres = 128






;

int sp_satcard_loc = 0






;

int min_rfdycc = 0;

int min_rfavgpow = 0;

int min_rfrmsb1 = 0;

int coll_prefls = 1






;


int maxGradRes = 1






;

float dfg = 2






;

float pg_beta = 1.0






;

int split_dab = 0






;

float freq_scale = 1.0






;

int numrecv = 1






;


int pe_on = 1






;

float psd_targetscale = 1.0;

float psd_zero = 0.0






;


int lx_pwmtime = 0;
int ly_pwmtime = 0;
int lz_pwmtime = 0;


int px_pwmtime = 0;
int py_pwmtime = 0;
int pz_pwmtime = 0;

int min_seqgrad = 0;
int min_seqrfamp = 0;


float xa2s = 0;
float ya2s = 0;
float za2s = 0;

int minseqcoil_t = 0;
int minseqcoilx_t = 0;
int minseqcoily_t = 0;
int minseqcoilz_t = 0;
int minseqcoilburst_t = 0;
int minseqcoilvrms_t = 0;
int minseqgram_t = 0;
int minseqchoke_t = 0;
int minseqcable_t = 0;
int minseqcable_maxpow_t = 0;
int minseqcableburst_t = 0;
int minseqbusbar_t = 0;
int minseqps_t = 0;
int minseqpdu_t = 0;
int minseqpdubreaker_t = 0;
int minseqcoilcool_t = 0;
int minseqsyscool_t = 0;
int minseqccucool_t = 0;
int minseqxfmr_t = 0;
int minseqresist_t = 0;


int minseqgrddrv_t = 0;
int minseqgrddrv_case_t = 0;
int minseqgrddrvx_t = 0;
int minseqgrddrvy_t = 0;
int minseqgrddrvz_t = 0;
float powerx = 0;
float powery = 0;
float powerz = 0;
float pospowerx = 0;
float pospowery = 0;
float pospowerz = 0;
float negpowerx = 0;
float negpowery = 0;
float negpowerz = 0;
float amptrans_lx = 0;
float amptrans_ly = 0;
float amptrans_lz = 0;
float amptrans_px = 0;
float amptrans_py = 0;
float amptrans_pz = 0;
float abspower_lx = 0;
float abspower_ly = 0;
float abspower_lz = 0;
float abspower_px = 0;
float abspower_py = 0;
float abspower_pz = 0;


int minseqpwm_x = 0;
int minseqpwm_y = 0;
int minseqpwm_z = 0;
int minseqgpm_t = 0;
int minseqgpm_maxpow_t = 0;


float vol_ratio_est_req = 2.0;


int skip_waveform_rotmat_check = 0;


int set_realtime_rotmat = 0;


int skip_rotmat_search = 0;


int enforce_minseqseg = 0;


int enforce_dbdtopt = 0;


int skip_minseqseg = 0;


int skip_initialize_dbdtopt = 0;

int time_pgen = 0;

int cont_debug = 0






;


int maxpc_cor = 0






;

int maxpc_debug = 0






;

int maxpc_points = 500






;


int pass_thru_mode = 0






;


int tmin = 0






;

int tmin_total = 0






;

int psd_tol_value = 0






;


int bd_index = 1






;


int use_ermes = 0






;


float fieldstrength = 15000;

int asymmatrix = 0






;

int psddebugcode = 0






;

int psddebugcode2 = 0






;

int serviceMode = 0






;


int upmxdisable = 16






;






int tsamp = 4






;

int seg_debug = 0






;

int CompositeRMS_method = 0






;

int gradDriverMethod = 0






;



int gradDCsafeMethod = 1






;


int stopwatchFlag = 0






;

int seqEntryIndex = 0






;


int dbdt_debug = 0






;

int reilly_mode = 0






;



int dbdt_disable = 0






;




int use_dbdt_opt = 1






;

float srderate = 1.0






;

int config_update_mode = 0






;

int phys_record_flag = 0






;

int phys_rec_resolution = 25






;
int phys_record_channelsel = 15
;
int rotateflag = 0
;
int rhpcspacial_dynamic = 0
;
int rhpc_rationalscale = 0
;
int rhpcmag = 0
;
int mild_note_support = 0
;
int save_grad_spec_flag = 0
;
int grad_spec_change_flag = 0
;
int value_system_flag = 0
;
int rectfov_npw_support = 0
;
int pigeosrot = 0
;
int minseqrf_cal = 1
;
int min_rfampcpblty = 0
;
int b1derate_flag = 0
;
int oblmethod_dbdt_flag = 0
;
int minseqcoil_esp = 1000
;
int aspir_flag = 0
;
int rhrawsizeview = 0
;
int chksum_scaninfo_view = 0
;
int chksum_rhdacqctrl_view = 0
;
float fnecho_lim = 1.0
;
int psdcrucial_debug = 0
;
float b1max_scale = 1.0
;
int disable_exciter_unblank = 0
;
int TGlimit = 200;
int sat_TGlimit = 200;
int autoparams_debug = 0
;
int num_autotr_cveval_iter = 1
;
int apx_cveval_counter = 0
;
int enforce_inrangetr = 0
;
int passtime = 0
;
int retropc_extra = 0
;
int esp = 10000
;
int echoint = 1
;
int arc_flag = 0
;
int arc_ph_calwidth = 24
;
int arc_sl_calwidth = 24
;
int vrgfsamp = 0
;
float srate_x = 15.0
;
float glimit_x = 3.6
;
float srate_y = 15.0
;
float glimit_y = 3.6
;
float srate_z = 15.0
;
float glimit_z = 3.6
;
float act_srate_x = 10.0
;
float act_srate_y = 10.0
;
float act_srate_z = 10.0
;
int mkgspec_x_sr_flag = 0
;
int mkgspec_x_gmax_flag = 0
;
int mkgspec_y_sr_flag = 0
;
int mkgspec_y_gmax_flag = 0
;
int mkgspec_z_sr_flag = 0
;
int mkgspec_z_gmax_flag = 0
;
int mkgspec_flag = 0
;
int mkgspec_epi2_flag = 0
;
int pfkz_total = 32
;
float fov_freq_scale = 1.0
;
float fov_phase_scale = 1.0
;
float slthick_scale = 1.0
;
int silent_mode = 0
;
float silent_slew_rate = 3.0
;
int rhpropellerCtrl = 0
;
float prop_act_npwfactor = 1.0
;
float prop_act_oversamplingfactor = 1.0
;
int navtrig_wait_before_imaging = 200000
;
int xtg_volRecCoil = 0
;
int minseqseg_max_full = 0
;
int sphericalGradient = 0
;
int minseqcoil_option = 0
;
int minseqgrad_option = 0
;
int rtp_bodyCoilCombine = 1
;
int ntxchannels = 1
;
int napptxchannels = 1
;
int seqcfgdebug = 0
;
int enable_acoustic_model = 0
;
int acoustic_seq_repeat_time = 4
;
float avgSPL_non_weighted = -1
;
int noisecal_in_scan_flag = 1
;
int autolock = 0
;
int blank = 4
;
int nograd = 0
;
int nofermi = 0
;
int rawdata = 0
;
int saveinter = 0
;
int zchop = 1
;
int eepf = 0
;
int oepf = 0
;
int eeff = 0
;
int oeff = 0
;
int cine_choplet = 0
;
float fermi_rc = 0.5
;
float fermi_wc = 1.0
;
int apodize_level_flag = 0
;
float fermi_r_factor = 1.0
;
float fermi_w_factor = 1.0
;
float pure_mix_tx_scale = 1.0
;
int channel_compression = 0
;
int optimal_channel_combine = 0
;
int enforce_cal_for_channel_combine = 0
;
int override_opcalrequired = 0
;
int dump_channel_comp_optimal_recon = 0
;
int dump_scenic_parameters = 0
;
 int cv_rfupa = -600 ;
 int system_type = 0 ;
 int cvlock = 1 ;
 int psd_taps = -1
;
 int fix_fermi = 0
;
 int grad_spec_ctrl = 0
  ;
 float srate = 1.651 ;
 float glimit = 1.0 ;
 float save_gmax = 1.0;
 float save_srate = 2.551;
 int save_cfxfull = 32752;
 int save_cfyfull = 32752;
 int save_cfzfull = 32752;
 float save_cfxipeak = 194.0;
 float save_cfyipeak = 194.0;
 float save_cfzipeak = 194.0;
 int save_ramptime = 600;
 int debug_grad_spec = 0 ;
 float act_srate=1.651;
 int val15_lock = 0
  ;
 int avecrushpepowscale_for_SBM_XFD = 0;
float PSsr_derate_factor = 1.0 ;
float PSamp_derate_factor = 1.0 ;
float PSassr_derate_factor = 1.0 ;
float PSasamp_derate_factor = 1.0 ;
int PSTR_PASS = 20000;
float mpsfov = 100 ;
int fastprescan = 0 ;
int pre_slice = 0 ;
int PSslice_num = 0;
float xmtaddAPS1 = 0, xmtaddCFL = 0, xmtaddCFH = 0, xmtaddFTG = 0, xmtadd = 0, xmtaddRCVN = 0;
float ps1scale = 0, cflscale = 0, cfhscale = 0, ftgscale = 0;
float extraScale = 0;
int PSdebugstate = 0 ;
int PSfield_strength = 5000 ;
int PScs_sat = 1 ;
int PSir = 1 ;
int PSmt = 1 ;
int ps1_rxcoil = 0 ;
int ps_seed = 21001;
int tg_1_2_pw = 1 ;
int tg_axial = 1 ;
float coeff_pw_tg = 1.0;
float fov_lim_mps = 350.0 ;
int TGspf = 0 ;
float flip_rf2cfh = 0;
float flip_rf3cfh = 0;
float flip_rf4cfh = 0;
int ps1_tr=2000000;
int cfl_tr=398000;
int cfh_tr=398000;
int rcvn_tr=398000;
float cfh_ec_position = (16.0/256.0) ;
int cfl_dda = 4 ;
int cfl_nex = 2 ;
int cfh_dda = 4 ;
int cfh_nex = 2 ;
int rcvn_dda = 0 ;
int rcvn_nex = 1 ;
int local_tg = 0 ;
float fov_scaling = 0.8 ;
float flip_rf1xtg = 90.0;
float gscale_rf1xtg = 1.0;
int init_xtg_deadtime = 0;
float flip_rf1mps1 = 90.0;
float gscale_rf1mps1 = 1.0;
int presscfh_override = 0 ;
int presscfh = PRESSCFH_NONE ;
int presscfh_ctrl = PRESSCFH_NONE ;
int presscfh_outrange = 0;
int presscfh_cgate = 0;
int presscfh_debug = 0 ;
int presscfh_wait_rf12 = 0;
int presscfh_wait_rf23 = 0;
int presscfh_wait_rf34 = 0;
int presscfh_minte = 20000;
float presscfh_fov = 0.0;
float presscfh_fov_ratio = 1.0;
float presscfh_pfov_ratio = 1.0;
float presscfh_slab_ratio = 1.0;
float presscfh_pfov = 0.0;
float presscfh_slthick = 10.0;
float presscfh_slice = 10.0;
float presscfh_ir_slthick = 10.0;
int presscfh_ir_noselect = 1;
float presscfh_minfov_ratio = 0.3;
int cfh_steam_flag = 0;
int steam_pg_gap = 8;
float area_gykcfl = 0;
float area_gykcfh = 0;
float area_xtgzkiller = 0;
float area_xtgykiller = 0;
int PSoff90=80 ;
int dummy_pw = 0;
int min180te = 0;
float PStloc = 0;
float PSrloc = 0;
float PSphasoff = 0;
int PStrigger = 0;
float PStloc_mod = 0;
float PSrloc_mod = 0;
float PSphasoff_mod = 0;
float thickPS_mod = 0;
float asx_killer_area = 840.0;
float asz_killer_area = 840.0;
float cfhir_killer_area = 4086.0;
float ps_crusher_area = 714.0;
float cfh_crusher_area = 4000.0;
float target_cfh_crusher = 0;
float target_cfh_crusher2 = 0;
int cfh_newmode = 1;
float cfh_rf1freq = 0 ;
float cfh_rf2freq = 0 ;
float cfh_rf3freq = 0 ;
float cfh_rf4freq = 0 ;
float cfh_fov = 0 ;
int cfh_ti = 120000;
int eff_cfh_te = 50000;
int PScfh_shimvol_debug = 0 ;
int debug_shimvol_slice = 0;
int wg_cfh_rf3 = 0;
int wg_cfh_rf4 = 0;
float FTGslthk = 20 ;
float FTGopslthickz1=80 ;
float FTGopslthickz2=80 ;
float FTGopslthickz3=20 ;
int ftgtr = 2000000 ;
float FTGfov = 480.0 ;
float FTGau = 4 ;
float FTGtecho = 4 ;
int FTGtau1 = 8192 ;
int FTGtau2 = 32768 ;
int FTGacq1 = 0 ;
int FTGacq2 = 1 ;
int epi_ir_on = 0 ;
int ssfse_ir_on = 0 ;
int ftg_dda = 0 ;
float FTGecho1bw = 3.90625 ;
int FTGtestpulse = 0 ;
int FTGxres = 256 ;
float FTGxmtadd = 0;
int pw_gxw2ftgleft = 4096;
int xtgtr = 200000 ;
int XTGtau1 = 8192 ;
float XTGfov = 480.0 ;
int pw_bsrf = 4000;
int xtg_offres_freq = 2000;
float XTGecho1bw = 15.625 ;
int XTGxres = 256 ;
float xmtaddXTG = 0, xtgscale = 0;
int xtg_dda = 0 ;
int XTGacq1 = 0 ;
float TGopslthick = 10.0 ;
float TGopslthickx = 30.0 ;
float TGopslthicky = 30.0 ;
int XTG_minimizeYKillerGap = 0 ;
int dynTG_etl = 2 ;
int dtg_iso_delay = 1280 ;
int dtg_off90 = 80;
int dtg_dda = 4 ;
int rf1dtg_type = 1 ;
float echo1bwdtg = 15.625 ;
int dtgt_exa = 0, dtgt_exb = 0, tleaddtg = 0, td0dtg = 0;
int dtgphorder = 1;
int dtgspgr_flag = 0 ;
int pw_rf1dtg = 0;
float a_rf1dtg = 0;
int min_dtgte = 0, dtg_esp = 0;
int tr_dtg = 20000;
int time_ssidtg = 400;
int rsaxial_flag = 1 ;
int rsspgr_flag = 1 ;
int multi_channel = 1 ;
int minph_iso_delay = 1280 ;
int rs_off90 = 80;
int rs_iso_delay = 1280 ;
float echo1bwrs = 15.625 ;
int rsphorder = 1;
int rs_dda = 4 ;
int rst_exa = 0, rst_exb = 0, tleadrs = 0, td0rs = 0;
int pw_rf1rs = 0;
int ia_rf1rs = 0;
float a_rf1rs = 0;
int rf1rs_type = 1 ;
float gscale_rf1rs = 0;
float flip_rf1rs = 0, flip_rfbrs = 0, cyc_rf1rs = 0;
float flip_rf1dtg = 0, flip_rfbdtg = 0, cyc_rf1dtg = 0, gscale_rf1dtg = 0;
int ia_rf1dtg = 0;
float rf1rs_scale = 0, rf1dtg_scale = 0;
float xmtaddrs = 0, xmtadddtg = 0;
int pw_acqrs1 = 0, pw_acqdtg1 = 0;
int min_rste = 0, rs_esp = 0;
int tr_rs = 0, tr_prep_rs = 0;
int rd_ext_rs = 0, rd_ext_dtg = 0;
int fast_xtr = 50;
int attenlen = 6;
int tns_len = 4;
int e2_delay_rs = 4;
int e2_delay_dtg = 4;
int time_ssirs = 400;
int rfshim_etl = 2;
int B1Cal_mode = 0 ;
int DD_delay = 2000 ;
int DD_channels = 2 ;
int DD_nCh = 1;
int DD_debug = 0 ;
int endview_iamprs = 0, endview_iampdtg = 0;
float endview_scalers = 0, endview_scaledtg = 0;
float echo1bwcal = 62.5 ;
int cal_dda = 128 ;
int cal_delay = 4000000 ;
int cal_delay_dda = 0;
int calspgr_flag = 1 ;
int cal_tr_interleave = 0;
int cal_nex_interleave = 0;
float cal_xfov = 100.0;
float cal_yfov = 100.0;
float cal_vthick = 10.0;
int cal_btw_rf_rba_ssp = 0;
int cal_grd_rf_delays = 0;
int tleadcal = 0;
int td0cal = 0;
int calt_exa = 4;
int calt_exb = 4;
int tacq_cal = 4;
int te_cal = 4;
int tr_cal = 4;
float flip_rf1cal = 0.0;
int cal_iso_delay = 0;
int endview_iampcal = 0;
int endviewz_iampcal = 0;
float endview_scalecal = 1.0;
float endviewz_scalecal = 1.0;
float a_combcal = 1.0;
float a_endcal = 1.0;
float a_combcal2 = 1.0;
float a_endcal2 = 1.0;
int time_ssical = 160;
float xmtaddcal = 0.0;
float cal_amplimit = 0.0;
float cal_slewrate = 100.0;
float cal_freq_scale = 1.0;
float cal_phase_scale = 1.0;
float area_gzkcal = 300.0;
float cal_ampscale = 1.05;
int cal_pfkr_flag = 1;
float cal_pfkr_fraction = 1.0;
int cal_sampledPts = 0;
float echo1bwcoil = 62.5 ;
int coil_dda = 4 ;
int coilspgr_flag = 1 ;
int coil_nex_interleave = 0;
float coil_xfov = 100.0;
float coil_yfov = 100.0;
float coil_vthick = 10.0;
int tleadcoil = 0;
int td0coil = 0;
int coilt_exa = 4;
int coilt_exb = 4;
int tacq_coil = 4;
int te_coil = 4;
int tr_coil = 4;
float flip_rf1coil = 0.0;
int coil_iso_delay = 0;
int endview_iampcoil = 0;
int endviewz_iampcoil = 0;
float endview_scalecoil = 1.0;
float endviewz_scalecoil = 1.0;
float a_combcoil = 1.0;
float a_endcoil = 1.0;
float a_combcoil2 = 1.0;
float a_endcoil2 = 1.0;
int time_ssicoil = 160;
float xmtaddcoil = 0.0;
float coil_amplimit = 0.0;
float coil_slewrate = 100.0;
float coil_freq_scale = 1.0;
float coil_phase_scale = 1.0;
int coil_pfkr_flag = 1;
float coil_pfkr_fraction = 1.0;
int coil_sampledPts = 0;
int CFLxres = 256 ;
int CFHxres = 256 ;
float echo1bwcfl = 2.016129 ;
float echo1bwcfh = 0.50 ;
float echo1bwrcvn = 15.625 ;
int rcvn_xres = 4096 ;
int rcvn_loops = 10;
int pw_grdtrig= 8 ;
int wait_time_before_cfh = 1000000 ;
float echo1bwas = 15.625 ;
int off90as = 80 ;
int td0as = 4 ;
int t_exaas = 0 ;
int time_ssias = 400 ;
int tleadas = 25 ;
int te_as = 0;
int tr_as = 0;
int as_dda = 4 ;
int pw_isislice= 200 ;
int pw_rotslice= 12 ;
int isi_sliceextra = 32 ;
int rgfeature_enable = 0 ;
int enableMapTg = 0 ;
float aslenap = 200 ;
float aslenrl = 200 ;
float aslensi = 200 ;
float aslocap = 0 ;
float aslocrl = 0 ;
float aslocsi = 0 ;
float area_gxwas = 0;
float area_gz1as = 0;
float area_readrampas = 0;
int avail_pwgx1as = 0;
int avail_pwgz1as = 0;
int bw_rf1as = 0;
float flip_pctas=1.0;
int dix_timeas = 0;
float xmtaddas = 0,xmtlogas = 0;
int ps1obl_debug = 0
;
int asobl_debug = 0
;
int ps1_newgeo = 1;
int as_newgeo = 1;
int pw_gy1as_tot = 0;
int endview_iampas = 0;
float endview_scaleas = 0;
int cfh_newgeo = 1;
int cfhobl_debug = 0
;
float deltf = 1.0 ;
int IRinCFH = 0 ;
int cfh_each = 0 ;
int cfh_slquant = 0 ;
int noswitch_slab_psc = 0 ;
int noswitch_coil_psc = 0 ;
int PStest_slab = 1 ;
int pimrsapsflg = 0 ;
int pimrsaps1 = 1
;
int pimrsaps2 = 104
;
int pimrsaps3 = 103
;
int pimrsaps4 = 4
;
int pimrsaps5 = 12
;
int pimrsaps6 = 3
;
int pimrsaps7 = 0
;
int pimrsaps8 = 0
;
int pimrsaps9 = 0
;
int pimrsaps10 = 0
;
int pimrsaps11 = 0
;
int pimrsaps12 = 0
;
int pimrsaps13 = 0
;
int pimrsaps14 = 0
;
int pimrsaps15 = 0
;
int pw_contrfhubsel = 4 ;
int delay_rfhubsel = 20;
int pw_contrfsel = 4 ;
int csw_tr = 0 ;
int csw_wait_sethubindeximm = 250000
;
int csw_wait_setrcvportimm = 100000
;
int csw_wait_before = 10000 ;
int csw_time_ssi = 50
;
float area_gxkrcvn = 10000;
float area_gykrcvn = 10000;
float area_gzkrcvn = 10000;
int pre_rcvn_tr = 20000 ;
int rcvn_flag = 1 ;
int psd_startta_override = 0 ;
int psd_psctg = APS_CONTROL_PSC
;
int psd_pscshim = APS_CONTROL_PSC
;
int psd_pscall = APS_CONTROL_PSC
;
int bw_rf1cal = 0, bw_rf1coil = 0;
int obl_debug = 0 ;
int obl_method = 1 ;
int filter_echo1 = 0 ;
int pw_passpacket = 50000 ;
int ks_rfconf = 1 + 4 + 8 + 128;
int ks_simscan = 1 ;
float ks_srfact = 1.0 ;
float ks_qfact = 1.0 ;
float ks_gheatfact = 1.0 ;
int ks_plot_filefmt = KS_PLOT_MAKEPNG ;
int ks_plot_kstmp = (0) ;
float ksgre_gscalerfexc = 0.9;
float ksgre_spoilerarea = 2000.0 ;
int ksgre_ssi_time = 500 ;
int ksgre_dda = 2 ;
float ksgre_spoilreadarea = 603.0 ;
  float a_rf1mps1 = 0;
  int ia_rf1mps1 = 0;
  int pw_rf1mps1 = 0;
  int res_rf1mps1 = 0;
  float cyc_rf1mps1 = 0;
  int off_rf1mps1 = 0;
  float alpha_rf1mps1 = 0;
  int wg_rf1mps1 = 0;
  float a_gyrf1mps1 = 0;
  int ia_gyrf1mps1 = 0;
  int pw_gyrf1mps1a = 0;
  int pw_gyrf1mps1d = 0;
  int pw_gyrf1mps1 = 0;
  int wg_gyrf1mps1 = 0;
  float a_gy1mps1 = 0;
  int ia_gy1mps1 = 0;
  int pw_gy1mps1a = 0;
  int pw_gy1mps1d = 0;
  int pw_gy1mps1 = 0;
  int wg_gy1mps1 = 0;
  float a_gzrf1mps1 = 0;
  int ia_gzrf1mps1 = 0;
  int pw_gzrf1mps1a = 0;
  int pw_gzrf1mps1d = 0;
  int pw_gzrf1mps1 = 0;
  int wg_gzrf1mps1 = 0;
  float a_gz1mps1 = 0;
  int ia_gz1mps1 = 0;
  int pw_gz1mps1a = 0;
  int pw_gz1mps1d = 0;
  int pw_gz1mps1 = 0;
  int wg_gz1mps1 = 0;
  float a_gx1mps1 = 0;
  int ia_gx1mps1 = 0;
  int pw_gx1mps1a = 0;
  int pw_gx1mps1d = 0;
  int pw_gx1mps1 = 0;
  int wg_gx1mps1 = 0;
  float a_gzrf2mps1 = 0;
  int ia_gzrf2mps1 = 0;
  int pw_gzrf2mps1a = 0;
  int pw_gzrf2mps1d = 0;
  int pw_gzrf2mps1 = 0;
  float a_rf2mps1 = 0;
  int ia_rf2mps1 = 0;
  int pw_rf2mps1 = 0;
  int res_rf2mps1 = 0;
  int temp_res_rf2mps1 = 0;
  float cyc_rf2mps1 = 0;
  int off_rf2mps1 = 0;
  float alpha_rf2mps1 = 0.46;
  float thk_rf2mps1 = 0;
  float gscale_rf2mps1 = 1.0;
  float flip_rf2mps1 = 0;
  int wg_rf2mps1 = TYPRHO1
;
  float a_gzrf2lmps1 = 0;
  int ia_gzrf2lmps1 = 0;
  int pw_gzrf2lmps1a = 0;
  int pw_gzrf2lmps1d = 0;
  int pw_gzrf2lmps1 = 0;
  int wg_gzrf2lmps1 = 0;
  float a_gzrf2rmps1 = 0;
  int ia_gzrf2rmps1 = 0;
  int pw_gzrf2rmps1a = 0;
  int pw_gzrf2rmps1d = 0;
  int pw_gzrf2rmps1 = 0;
  int wg_gzrf2rmps1 = 0;
  float a_gxwmps1 = 0;
  int ia_gxwmps1 = 0;
  int pw_gxwmps1a = 0;
  int pw_gxwmps1d = 0;
  int pw_gxwmps1 = 0;
  int wg_gxwmps1 = 0;
  int filter_echo1mps1 = 0;
  float a_gzrf1cfl = 0;
  int ia_gzrf1cfl = 0;
  int pw_gzrf1cfla = 0;
  int pw_gzrf1cfld = 0;
  int pw_gzrf1cfl = 0;
  float a_rf1cfl = 0;
  int ia_rf1cfl = 0;
  int pw_rf1cfl = 0;
  int res_rf1cfl = 0;
  int temp_res_rf1cfl = 0;
  float cyc_rf1cfl = 0;
  int off_rf1cfl = 0;
  float alpha_rf1cfl = 0.46;
  float thk_rf1cfl = 0;
  float gscale_rf1cfl = 1.0;
  float flip_rf1cfl = 0;
  int wg_rf1cfl = TYPRHO1
;
  float a_gz1cfl = 0;
  int ia_gz1cfl = 0;
  int pw_gz1cfla = 0;
  int pw_gz1cfld = 0;
  int pw_gz1cfl = 0;
  int wg_gz1cfl = 0;
  int filter_cfl_fid = 0;
  float a_gykcfl = 0;
  int ia_gykcfl = 0;
  int pw_gykcfla = 0;
  int pw_gykcfld = 0;
  int pw_gykcfl = 0;
  int wg_gykcfl = 0;
  float a_gxkrcvn = 0;
  int ia_gxkrcvn = 0;
  int pw_gxkrcvna = 0;
  int pw_gxkrcvnd = 0;
  int pw_gxkrcvn = 0;
  int wg_gxkrcvn = 0;
  float a_gykrcvn = 0;
  int ia_gykrcvn = 0;
  int pw_gykrcvna = 0;
  int pw_gykrcvnd = 0;
  int pw_gykrcvn = 0;
  int wg_gykrcvn = 0;
  float a_gzkrcvn = 0;
  int ia_gzkrcvn = 0;
  int pw_gzkrcvna = 0;
  int pw_gzkrcvnd = 0;
  int pw_gzkrcvn = 0;
  int wg_gzkrcvn = 0;
  int pw_grd_trig = 0;
  int wg_grd_trig = 0;
  float a_gxk2rcvn = 0;
  int ia_gxk2rcvn = 0;
  int pw_gxk2rcvna = 0;
  int pw_gxk2rcvnd = 0;
  int pw_gxk2rcvn = 0;
  int wg_gxk2rcvn = 0;
  float a_gyk2rcvn = 0;
  int ia_gyk2rcvn = 0;
  int pw_gyk2rcvna = 0;
  int pw_gyk2rcvnd = 0;
  int pw_gyk2rcvn = 0;
  int wg_gyk2rcvn = 0;
  float a_gzk2rcvn = 0;
  int ia_gzk2rcvn = 0;
  int pw_gzk2rcvna = 0;
  int pw_gzk2rcvnd = 0;
  int pw_gzk2rcvn = 0;
  int wg_gzk2rcvn = 0;
  int pw_rcvn_wait = 0;
  int wg_rcvn_wait = 0;
  int ia_rcvrbl = 0;
  int filter_rcvn_fid = 0;
  int ia_rcvrbl2 = 0;
  float a_gzrf0cfh = 0;
  int ia_gzrf0cfh = 0;
  int pw_gzrf0cfha = 0;
  int pw_gzrf0cfhd = 0;
  int pw_gzrf0cfh = 0;
  int res_gzrf0cfh = 0;
  float a_rf0cfh = 0;
  int ia_rf0cfh = 0;
  int pw_rf0cfh = 0;
  int res_rf0cfh = 0;
  float cyc_rf0cfh = 0;
  int off_rf0cfh = 0;
  float alpha_rf0cfh = 0.46;
  float thk_rf0cfh = 0;
  float gscale_rf0cfh = 1.0;
  float flip_rf0cfh = 0;
  int wg_rf0cfh = TYPRHO1
;
  float a_omegarf0cfh = 0;
  int ia_omegarf0cfh = 0;
  int pw_omegarf0cfh = 0;
  int res_omegarf0cfh = 0;
  int off_omegarf0cfh = 0;
  int rfslot_omegarf0cfh = 0;
  float gscale_omegarf0cfh = 1.0;
  int n_omegarf0cfh = 0;
  int wg_omegarf0cfh = 0;
  float a_gyrf0kcfh = 0;
  int ia_gyrf0kcfh = 0;
  int pw_gyrf0kcfha = 0;
  int pw_gyrf0kcfhd = 0;
  int pw_gyrf0kcfh = 0;
  int wg_gyrf0kcfh = 0;
  int pw_zticfh = 0;
  int wg_zticfh = 0;
  int pw_rticfh = 0;
  int wg_rticfh = 0;
  int pw_xticfh = 0;
  int wg_xticfh = 0;
  int pw_yticfh = 0;
  int wg_yticfh = 0;
  int pw_sticfh = 0;
  int wg_sticfh = 0;
  float a_gzrf1cfh = 0;
  int ia_gzrf1cfh = 0;
  int pw_gzrf1cfha = 0;
  int pw_gzrf1cfhd = 0;
  int pw_gzrf1cfh = 0;
  float a_rf1cfh = 0;
  int ia_rf1cfh = 0;
  int pw_rf1cfh = 0;
  int res_rf1cfh = 0;
  int temp_res_rf1cfh = 0;
  float cyc_rf1cfh = 0;
  int off_rf1cfh = 0;
  float alpha_rf1cfh = 0.46;
  float thk_rf1cfh = 0;
  float gscale_rf1cfh = 1.0;
  float flip_rf1cfh = 0;
  int wg_rf1cfh = TYPRHO1
;
  float a_rf2cfh = 0;
  int ia_rf2cfh = 0;
  int pw_rf2cfh = 0;
  int res_rf2cfh = 0;
  float cyc_rf2cfh = 0;
  int off_rf2cfh = 0;
  float alpha_rf2cfh = 0;
  int wg_rf2cfh = 0;
  float a_rf3cfh = 0;
  int ia_rf3cfh = 0;
  int pw_rf3cfh = 0;
  int res_rf3cfh = 0;
  float cyc_rf3cfh = 0;
  int off_rf3cfh = 0;
  float alpha_rf3cfh = 0;
  int wg_rf3cfh = 0;
  float a_rf4cfh = 0;
  int ia_rf4cfh = 0;
  int pw_rf4cfh = 0;
  int res_rf4cfh = 0;
  float cyc_rf4cfh = 0;
  int off_rf4cfh = 0;
  float alpha_rf4cfh = 0;
  int wg_rf4cfh = 0;
  float a_gxrf2cfh = 0;
  int ia_gxrf2cfh = 0;
  int pw_gxrf2cfha = 0;
  int pw_gxrf2cfhd = 0;
  int pw_gxrf2cfh = 0;
  int wg_gxrf2cfh = 0;
  float a_gyrf2cfh = 0;
  int ia_gyrf2cfh = 0;
  int pw_gyrf2cfha = 0;
  int pw_gyrf2cfhd = 0;
  int pw_gyrf2cfh = 0;
  int wg_gyrf2cfh = 0;
  float a_gzrf2lcfh = 0;
  int ia_gzrf2lcfh = 0;
  int pw_gzrf2lcfha = 0;
  int pw_gzrf2lcfhd = 0;
  int pw_gzrf2lcfh = 0;
  int wg_gzrf2lcfh = 0;
  float a_gzrf2rcfh = 0;
  int ia_gzrf2rcfh = 0;
  int pw_gzrf2rcfha = 0;
  int pw_gzrf2rcfhd = 0;
  int pw_gzrf2rcfh = 0;
  int wg_gzrf2rcfh = 0;
  float a_gyrf3cfh = 0;
  int ia_gyrf3cfh = 0;
  int pw_gyrf3cfha = 0;
  int pw_gyrf3cfhd = 0;
  int pw_gyrf3cfh = 0;
  int wg_gyrf3cfh = 0;
  float a_gzrf3lcfh = 0;
  int ia_gzrf3lcfh = 0;
  int pw_gzrf3lcfha = 0;
  int pw_gzrf3lcfhd = 0;
  int pw_gzrf3lcfh = 0;
  int wg_gzrf3lcfh = 0;
  float a_gzrf3rcfh = 0;
  int ia_gzrf3rcfh = 0;
  int pw_gzrf3rcfha = 0;
  int pw_gzrf3rcfhd = 0;
  int pw_gzrf3rcfh = 0;
  int wg_gzrf3rcfh = 0;
  float a_gy1cfh = 0;
  int ia_gy1cfh = 0;
  int pw_gy1cfha = 0;
  int pw_gy1cfhd = 0;
  int pw_gy1cfh = 0;
  int wg_gy1cfh = 0;
  float a_gx1cfh = 0;
  int ia_gx1cfh = 0;
  int pw_gx1cfha = 0;
  int pw_gx1cfhd = 0;
  int pw_gx1cfh = 0;
  int wg_gx1cfh = 0;
  float a_gzrf4cfh = 0;
  int ia_gzrf4cfh = 0;
  int pw_gzrf4cfha = 0;
  int pw_gzrf4cfhd = 0;
  int pw_gzrf4cfh = 0;
  int wg_gzrf4cfh = 0;
  int pw_isi_slice1 = 0;
  int wg_isi_slice1 = 0;
  int pw_rot_slice1 = 0;
  int wg_rot_slice1 = 0;
  int pw_isi_slice2 = 0;
  int wg_isi_slice2 = 0;
  int pw_rot_slice2 = 0;
  int wg_rot_slice2 = 0;
  float a_gzrf4lcfh = 0;
  int ia_gzrf4lcfh = 0;
  int pw_gzrf4lcfha = 0;
  int pw_gzrf4lcfhd = 0;
  int pw_gzrf4lcfh = 0;
  int wg_gzrf4lcfh = 0;
  float a_gzrf4rcfh = 0;
  int ia_gzrf4rcfh = 0;
  int pw_gzrf4rcfha = 0;
  int pw_gzrf4rcfhd = 0;
  int pw_gzrf4rcfh = 0;
  int wg_gzrf4rcfh = 0;
  int filter_cfh_fid = 0;
  float a_gykcfh = 0;
  int ia_gykcfh = 0;
  int pw_gykcfha = 0;
  int pw_gykcfhd = 0;
  int pw_gykcfh = 0;
  int wg_gykcfh = 0;
  int ia_contrfhubsel = 0;
  int ia_contrfsel = 0;
  int pw_csw_wait = 0;
  int wg_csw_wait = 0;
  float a_gzrf1ftg = 0;
  int ia_gzrf1ftg = 0;
  int pw_gzrf1ftga = 0;
  int pw_gzrf1ftgd = 0;
  int pw_gzrf1ftg = 0;
  float a_rf1ftg = 0;
  int ia_rf1ftg = 0;
  int pw_rf1ftg = 0;
  int res_rf1ftg = 0;
  int temp_res_rf1ftg = 0;
  float cyc_rf1ftg = 0;
  int off_rf1ftg = 0;
  float alpha_rf1ftg = 0.46;
  float thk_rf1ftg = 0;
  float gscale_rf1ftg = 1.0;
  float flip_rf1ftg = 0;
  int wg_rf1ftg = TYPRHO1
;
  float a_gz1ftg = 0;
  int ia_gz1ftg = 0;
  int pw_gz1ftga = 0;
  int pw_gz1ftgd = 0;
  int pw_gz1ftg = 0;
  int wg_gz1ftg = 0;
  float a_gzrf2ftg = 0;
  int ia_gzrf2ftg = 0;
  int pw_gzrf2ftga = 0;
  int pw_gzrf2ftgd = 0;
  int pw_gzrf2ftg = 0;
  float a_rf2ftg = 0;
  int ia_rf2ftg = 0;
  int pw_rf2ftg = 0;
  int res_rf2ftg = 0;
  int temp_res_rf2ftg = 0;
  float cyc_rf2ftg = 0;
  int off_rf2ftg = 0;
  float alpha_rf2ftg = 0.46;
  float thk_rf2ftg = 0;
  float gscale_rf2ftg = 1.0;
  float flip_rf2ftg = 0;
  int wg_rf2ftg = TYPRHO1
;
  float a_gz2ftg = 0;
  int ia_gz2ftg = 0;
  int pw_gz2ftga = 0;
  int pw_gz2ftgd = 0;
  int pw_gz2ftg = 0;
  int wg_gz2ftg = 0;
  float a_gzrf3ftg = 0;
  int ia_gzrf3ftg = 0;
  int pw_gzrf3ftga = 0;
  int pw_gzrf3ftgd = 0;
  int pw_gzrf3ftg = 0;
  float a_rf3ftg = 0;
  int ia_rf3ftg = 0;
  int pw_rf3ftg = 0;
  int res_rf3ftg = 0;
  int temp_res_rf3ftg = 0;
  float cyc_rf3ftg = 0;
  int off_rf3ftg = 0;
  float alpha_rf3ftg = 0.46;
  float thk_rf3ftg = 0;
  float gscale_rf3ftg = 1.0;
  float flip_rf3ftg = 0;
  int wg_rf3ftg = TYPRHO1
;
  float a_gz3ftg = 0;
  int ia_gz3ftg = 0;
  int pw_gz3ftga = 0;
  int pw_gz3ftgd = 0;
  int pw_gz3ftg = 0;
  int wg_gz3ftg = 0;
  float a_gx1ftg = 0;
  int ia_gx1ftg = 0;
  int pw_gx1ftga = 0;
  int pw_gx1ftgd = 0;
  int pw_gx1ftg = 0;
  int wg_gx1ftg = 0;
  float a_gx1bftg = 0;
  int ia_gx1bftg = 0;
  int pw_gx1bftga = 0;
  int pw_gx1bftgd = 0;
  int pw_gx1bftg = 0;
  int wg_gx1bftg = 0;
  float a_gxw1ftg = 0;
  int ia_gxw1ftg = 0;
  int pw_gxw1ftga = 0;
  int pw_gxw1ftgd = 0;
  int pw_gxw1ftg = 0;
  int wg_gxw1ftg = 0;
  float a_postgxw1ftg = 0;
  int ia_postgxw1ftg = 0;
  int pw_postgxw1ftga = 0;
  int pw_postgxw1ftgd = 0;
  int pw_postgxw1ftg = 0;
  int wg_postgxw1ftg = 0;
  int filter_echo1ftg = 0;
  float a_gz2bftg = 0;
  int ia_gz2bftg = 0;
  int pw_gz2bftga = 0;
  int pw_gz2bftgd = 0;
  int pw_gz2bftg = 0;
  int wg_gz2bftg = 0;
  float a_gx2ftg = 0;
  int ia_gx2ftg = 0;
  int pw_gx2ftga = 0;
  int pw_gx2ftgd = 0;
  int pw_gx2ftg = 0;
  int wg_gx2ftg = 0;
  float a_gxw2ftg = 0;
  int ia_gxw2ftg = 0;
  int pw_gxw2ftga = 0;
  int pw_gxw2ftgd = 0;
  int pw_gxw2ftg = 0;
  int wg_gxw2ftg = 0;
  float a_gx2test = 0;
  int ia_gx2test = 0;
  int pw_gx2testa = 0;
  int pw_gx2testd = 0;
  int pw_gx2test = 0;
  int wg_gx2test = 0;
  int filter_echo2ftg = 0;
  float a_rf1xtg = 0;
  int ia_rf1xtg = 0;
  int pw_rf1xtg = 0;
  int res_rf1xtg = 0;
  float cyc_rf1xtg = 0;
  int off_rf1xtg = 0;
  float alpha_rf1xtg = 0;
  int wg_rf1xtg = 0;
  float a_gyrf1xtg = 0;
  int ia_gyrf1xtg = 0;
  int pw_gyrf1xtga = 0;
  int pw_gyrf1xtgd = 0;
  int pw_gyrf1xtg = 0;
  int wg_gyrf1xtg = 0;
  float a_gzrf1xtg = 0;
  int ia_gzrf1xtg = 0;
  int pw_gzrf1xtga = 0;
  int pw_gzrf1xtgd = 0;
  int pw_gzrf1xtg = 0;
  int wg_gzrf1xtg = 0;
  float a_gykxtgl = 0;
  int ia_gykxtgl = 0;
  int pw_gykxtgla = 0;
  int pw_gykxtgld = 0;
  int pw_gykxtgl = 0;
  int wg_gykxtgl = 0;
       float a_rf3xtg = 0;
       int ia_rf3xtg = 0;
       int pw_rf3xtg = 0;
       int res_rf3xtg = 0;
       int off_rf3xtg = 0;
       float alpha_rf3xtg = 0.46;
       float gscale_rf3xtg = 1.0;
       float flip_rf3xtg = 0;
       int ia_phs_rf3xtg = 0;
       int wg_rf3xtg = TYPRHO1
;
  float a_gz1xtg = 0;
  int ia_gz1xtg = 0;
  int pw_gz1xtga = 0;
  int pw_gz1xtgd = 0;
  int pw_gz1xtg = 0;
  int wg_gz1xtg = 0;
  float a_gzrf2xtg = 0;
  int ia_gzrf2xtg = 0;
  int pw_gzrf2xtga = 0;
  int pw_gzrf2xtgd = 0;
  int pw_gzrf2xtg = 0;
  float a_rf2xtg = 0;
  int ia_rf2xtg = 0;
  int pw_rf2xtg = 0;
  int res_rf2xtg = 0;
  int temp_res_rf2xtg = 0;
  float cyc_rf2xtg = 0;
  int off_rf2xtg = 0;
  float alpha_rf2xtg = 0.46;
  float thk_rf2xtg = 0;
  float gscale_rf2xtg = 1.0;
  float flip_rf2xtg = 0;
  int wg_rf2xtg = TYPRHO1
;
  float a_gz2xtg = 0;
  int ia_gz2xtg = 0;
  int pw_gz2xtga = 0;
  int pw_gz2xtgd = 0;
  int pw_gz2xtg = 0;
  int wg_gz2xtg = 0;
       float a_rf4xtg = 0;
       int ia_rf4xtg = 0;
       int pw_rf4xtg = 0;
       int res_rf4xtg = 0;
       int off_rf4xtg = 0;
       float alpha_rf4xtg = 0.46;
       float gscale_rf4xtg = 1.0;
       float flip_rf4xtg = 0;
       int ia_phs_rf4xtg = 0;
       int wg_rf4xtg = TYPRHO1
;
  float a_gykxtgr = 0;
  int ia_gykxtgr = 0;
  int pw_gykxtgra = 0;
  int pw_gykxtgrd = 0;
  int pw_gykxtgr = 0;
  int wg_gykxtgr = 0;
  float a_gx1bxtg = 0;
  int ia_gx1bxtg = 0;
  int pw_gx1bxtga = 0;
  int pw_gx1bxtgd = 0;
  int pw_gx1bxtg = 0;
  int wg_gx1bxtg = 0;
  float a_gxw1xtg = 0;
  int ia_gxw1xtg = 0;
  int pw_gxw1xtga = 0;
  int pw_gxw1xtgd = 0;
  int pw_gxw1xtg = 0;
  int wg_gxw1xtg = 0;
  int filter_echo1xtg = 0;
  float a_gzrf1as = 0;
  int ia_gzrf1as = 0;
  int pw_gzrf1asa = 0;
  int pw_gzrf1asd = 0;
  int pw_gzrf1as = 0;
  float a_rf1as = 0;
  int ia_rf1as = 0;
  int pw_rf1as = 0;
  int res_rf1as = 0;
  int temp_res_rf1as = 0;
  float cyc_rf1as = 0;
  int off_rf1as = 0;
  float alpha_rf1as = 0.46;
  float thk_rf1as = 0;
  float gscale_rf1as = 1.0;
  float flip_rf1as = 0;
  int wg_rf1as = TYPRHO1
;
  float a_gz1as = 0;
  int ia_gz1as = 0;
  int pw_gz1asa = 0;
  int pw_gz1asd = 0;
  int pw_gz1as = 0;
  int wg_gz1as = 0;
  float a_gxwas = 0;
  int ia_gxwas = 0;
  int pw_gxwasa = 0;
  int pw_gxwasd = 0;
  int pw_gxwas = 0;
  int wg_gxwas = 0;
  int filter_echo1as = 0;
  float a_gx1as = 0;
  int ia_gx1as = 0;
  int pw_gx1asa = 0;
  int pw_gx1asd = 0;
  int pw_gx1as = 0;
  int wg_gx1as = 0;
  float a_gy1as = 0;
  float a_gy1asa = 0;
  float a_gy1asb = 0;
  int ia_gy1as = 0;
  int ia_gy1aswa = 0;
  int ia_gy1aswb = 0;
  int pw_gy1asa = 0;
  int pw_gy1asd = 0;
  int pw_gy1as = 0;
  int wg_gy1as = 0;
  float a_gy1ras = 0;
  float a_gy1rasa = 0;
  float a_gy1rasb = 0;
  int ia_gy1ras = 0;
  int ia_gy1raswa = 0;
  int ia_gy1raswb = 0;
  int pw_gy1rasa = 0;
  int pw_gy1rasd = 0;
  int pw_gy1ras = 0;
  int wg_gy1ras = 0;
  float a_gxkas = 0;
  int ia_gxkas = 0;
  int pw_gxkasa = 0;
  int pw_gxkasd = 0;
  int pw_gxkas = 0;
  int wg_gxkas = 0;
  float a_gzkas = 0;
  int ia_gzkas = 0;
  int pw_gzkasa = 0;
  int pw_gzkasd = 0;
  int pw_gzkas = 0;
  int wg_gzkas = 0;
  float a_xdixon = 0;
  int ia_xdixon = 0;
  int pw_xdixon = 0;
  int wg_xdixon = 0;
  float a_ydixon = 0;
  int ia_ydixon = 0;
  int pw_ydixon = 0;
  int wg_ydixon = 0;
  float a_zdixon = 0;
  int ia_zdixon = 0;
  int pw_zdixon = 0;
  int wg_zdixon = 0;
  float a_sdixon = 0;
  int ia_sdixon = 0;
  int pw_sdixon = 0;
  int wg_sdixon = 0;
  float a_sdixon2 = 0;
  int ia_sdixon2 = 0;
  int pw_sdixon2 = 0;
  int wg_sdixon2 = 0;
  int ia_dDDIQ = 0;
  int res_rf1rs = 0;
  int wg_rf1rs = 0;
  float a_gzrf1rs = 0;
  int ia_gzrf1rs = 0;
  int pw_gzrf1rsa = 0;
  int pw_gzrf1rsd = 0;
  int pw_gzrf1rs = 0;
  int wg_gzrf1rs = 0;
  float a_gxkbsrs = 0;
  int ia_gxkbsrs = 0;
  int pw_gxkbsrsa = 0;
  int pw_gxkbsrsd = 0;
  int pw_gxkbsrs = 0;
  int wg_gxkbsrs = 0;
  float a_gz1rs = 0;
  int ia_gz1rs = 0;
  int pw_gz1rsa = 0;
  int pw_gz1rsd = 0;
  int pw_gz1rs = 0;
  int wg_gz1rs = 0;
  float a_rfbrs = 0;
  int ia_rfbrs = 0;
  int pw_rfbrs = 0;
  int res_rfbrs = 0;
  int off_rfbrs = 0;
  int rfslot_rfbrs = 0;
  float gscale_rfbrs = 1.0;
  int n_rfbrs = 0;
  int wg_rfbrs = 0;
  float a_thetarfbrs = 0;
  int ia_thetarfbrs = 0;
  int pw_thetarfbrs = 0;
  int res_thetarfbrs = 0;
  int off_thetarfbrs = 0;
  int rfslot_thetarfbrs = 0;
  float gscale_thetarfbrs = 1.0;
  int n_thetarfbrs = 0;
  int wg_thetarfbrs = 0;
  float a_gzkbsrs = 0;
  int ia_gzkbsrs = 0;
  int pw_gzkbsrsa = 0;
  int pw_gzkbsrsd = 0;
  int pw_gzkbsrs = 0;
  int wg_gzkbsrs = 0;
  float a_gxwrs = 0;
  int ia_gxwrs = 0;
  int pw_gxwrsa = 0;
  int pw_gxwrsd = 0;
  int pw_gxwrs = 0;
  int wg_gxwrs = 0;
  int filter_echo1rs = 0;
  float a_gx2rs = 0;
  int ia_gx2rs = 0;
  int pw_gx2rsa = 0;
  int pw_gx2rsd = 0;
  int pw_gx2rs = 0;
  int wg_gx2rs = 0;
  float a_gy2rs = 0;
  float a_gy2rsa = 0;
  float a_gy2rsb = 0;
  int ia_gy2rs = 0;
  int ia_gy2rswa = 0;
  int ia_gy2rswb = 0;
  int pw_gy2rsa = 0;
  int pw_gy2rsd = 0;
  int pw_gy2rs = 0;
  int wg_gy2rs = 0;
  float a_gxw2rs = 0;
  int ia_gxw2rs = 0;
  int pw_gxw2rsa = 0;
  int pw_gxw2rsd = 0;
  int pw_gxw2rs = 0;
  int wg_gxw2rs = 0;
  float a_gx1rs = 0;
  int ia_gx1rs = 0;
  int pw_gx1rsa = 0;
  int pw_gx1rsd = 0;
  int pw_gx1rs = 0;
  int wg_gx1rs = 0;
  float a_gy1rrs = 0;
  float a_gy1rrsa = 0;
  float a_gy1rrsb = 0;
  int ia_gy1rrs = 0;
  int ia_gy1rrswa = 0;
  int ia_gy1rrswb = 0;
  int pw_gy1rrsa = 0;
  int pw_gy1rrsd = 0;
  int pw_gy1rrs = 0;
  int wg_gy1rrs = 0;
  float a_gy1rs = 0;
  float a_gy1rsa = 0;
  float a_gy1rsb = 0;
  int ia_gy1rs = 0;
  int ia_gy1rswa = 0;
  int ia_gy1rswb = 0;
  int pw_gy1rsa = 0;
  int pw_gy1rsd = 0;
  int pw_gy1rs = 0;
  int wg_gy1rs = 0;
  float a_gzkrs = 0;
  int ia_gzkrs = 0;
  int pw_gzkrsa = 0;
  int pw_gzkrsd = 0;
  int pw_gzkrs = 0;
  int wg_gzkrs = 0;
  float a_gxkrs = 0;
  int ia_gxkrs = 0;
  int pw_gxkrsa = 0;
  int pw_gxkrsd = 0;
  int pw_gxkrs = 0;
  int wg_gxkrs = 0;
  int res_rf1dtg = 0;
  int wg_rf1dtg = 0;
  float a_gzrf1dtg = 0;
  int ia_gzrf1dtg = 0;
  int pw_gzrf1dtga = 0;
  int pw_gzrf1dtgd = 0;
  int pw_gzrf1dtg = 0;
  int wg_gzrf1dtg = 0;
  float a_gxkbsdtg = 0;
  int ia_gxkbsdtg = 0;
  int pw_gxkbsdtga = 0;
  int pw_gxkbsdtgd = 0;
  int pw_gxkbsdtg = 0;
  int wg_gxkbsdtg = 0;
  float a_gz1dtg = 0;
  int ia_gz1dtg = 0;
  int pw_gz1dtga = 0;
  int pw_gz1dtgd = 0;
  int pw_gz1dtg = 0;
  int wg_gz1dtg = 0;
  float a_rfbdtg = 0;
  int ia_rfbdtg = 0;
  int pw_rfbdtg = 0;
  int res_rfbdtg = 0;
  int off_rfbdtg = 0;
  int rfslot_rfbdtg = 0;
  float gscale_rfbdtg = 1.0;
  int n_rfbdtg = 0;
  int wg_rfbdtg = 0;
  float a_thetarfbdtg = 0;
  int ia_thetarfbdtg = 0;
  int pw_thetarfbdtg = 0;
  int res_thetarfbdtg = 0;
  int off_thetarfbdtg = 0;
  int rfslot_thetarfbdtg = 0;
  float gscale_thetarfbdtg = 1.0;
  int n_thetarfbdtg = 0;
  int wg_thetarfbdtg = 0;
  float a_gzkbsdtg = 0;
  int ia_gzkbsdtg = 0;
  int pw_gzkbsdtga = 0;
  int pw_gzkbsdtgd = 0;
  int pw_gzkbsdtg = 0;
  int wg_gzkbsdtg = 0;
  float a_gxwdtg = 0;
  int ia_gxwdtg = 0;
  int pw_gxwdtga = 0;
  int pw_gxwdtgd = 0;
  int pw_gxwdtg = 0;
  int wg_gxwdtg = 0;
  int filter_echo1dtg = 0;
  float a_gx2dtg = 0;
  int ia_gx2dtg = 0;
  int pw_gx2dtga = 0;
  int pw_gx2dtgd = 0;
  int pw_gx2dtg = 0;
  int wg_gx2dtg = 0;
  float a_gy2dtg = 0;
  float a_gy2dtga = 0;
  float a_gy2dtgb = 0;
  int ia_gy2dtg = 0;
  int ia_gy2dtgwa = 0;
  int ia_gy2dtgwb = 0;
  int pw_gy2dtga = 0;
  int pw_gy2dtgd = 0;
  int pw_gy2dtg = 0;
  int wg_gy2dtg = 0;
  float a_gxw2dtg = 0;
  int ia_gxw2dtg = 0;
  int pw_gxw2dtga = 0;
  int pw_gxw2dtgd = 0;
  int pw_gxw2dtg = 0;
  int wg_gxw2dtg = 0;
  float a_gx1dtg = 0;
  int ia_gx1dtg = 0;
  int pw_gx1dtga = 0;
  int pw_gx1dtgd = 0;
  int pw_gx1dtg = 0;
  int wg_gx1dtg = 0;
  float a_gy1rdtg = 0;
  float a_gy1rdtga = 0;
  float a_gy1rdtgb = 0;
  int ia_gy1rdtg = 0;
  int ia_gy1rdtgwa = 0;
  int ia_gy1rdtgwb = 0;
  int pw_gy1rdtga = 0;
  int pw_gy1rdtgd = 0;
  int pw_gy1rdtg = 0;
  int wg_gy1rdtg = 0;
  float a_gy1dtg = 0;
  float a_gy1dtga = 0;
  float a_gy1dtgb = 0;
  int ia_gy1dtg = 0;
  int ia_gy1dtgwa = 0;
  int ia_gy1dtgwb = 0;
  int pw_gy1dtga = 0;
  int pw_gy1dtgd = 0;
  int pw_gy1dtg = 0;
  int wg_gy1dtg = 0;
  float a_gzkdtg = 0;
  int ia_gzkdtg = 0;
  int pw_gzkdtga = 0;
  int pw_gzkdtgd = 0;
  int pw_gzkdtg = 0;
  int wg_gzkdtg = 0;
  float a_gxkdtg = 0;
  int ia_gxkdtg = 0;
  int pw_gxkdtga = 0;
  int pw_gxkdtgd = 0;
  int pw_gxkdtg = 0;
  int wg_gxkdtg = 0;
  float a_rf1cal = 0;
  int ia_rf1cal = 0;
  int pw_rf1cal = 0;
  int res_rf1cal = 0;
  int off_rf1cal = 0;
  int rfslot_rf1cal = 0;
  float gscale_rf1cal = 1.0;
  int n_rf1cal = 0;
  int wg_rf1cal = 0;
  float a_gzrf1cal = 0;
  int ia_gzrf1cal = 0;
  int pw_gzrf1cala = 0;
  int pw_gzrf1cald = 0;
  int pw_gzrf1cal = 0;
  int wg_gzrf1cal = 0;
  float a_gzcombcal = 0;
  float a_gzcombcala = 0;
  float a_gzcombcalb = 0;
  int ia_gzcombcal = 0;
  int ia_gzcombcalwa = 0;
  int ia_gzcombcalwb = 0;
  int pw_gzcombcala = 0;
  int pw_gzcombcald = 0;
  int pw_gzcombcalf = 0;
  int pw_gzcombcal = 0;
  int res_gzcombcal = 0;
  int per_gzcombcal = 0;
  int wg_gzcombcal = 0;
  float a_gzprcal = 0;
  float a_gzprcala = 0;
  float a_gzprcalb = 0;
  int ia_gzprcal = 0;
  int ia_gzprcalwa = 0;
  int ia_gzprcalwb = 0;
  int pw_gzprcala = 0;
  int pw_gzprcald = 0;
  int pw_gzprcalf = 0;
  int pw_gzprcal = 0;
  int res_gzprcal = 0;
  int per_gzprcal = 0;
  int wg_gzprcal = 0;
  float a_gxwcal = 0;
  int ia_gxwcal = 0;
  int pw_gxwcala = 0;
  int pw_gxwcald = 0;
  int pw_gxwcal = 0;
  int wg_gxwcal = 0;
  int filter_echo1cal = 0;
  float a_gx1cal = 0;
  float a_gx1cala = 0;
  float a_gx1calb = 0;
  int ia_gx1cal = 0;
  int ia_gx1calwa = 0;
  int ia_gx1calwb = 0;
  int pw_gx1cala = 0;
  int pw_gx1cald = 0;
  int pw_gx1calf = 0;
  int pw_gx1cal = 0;
  int res_gx1cal = 0;
  int per_gx1cal = 0;
  int wg_gx1cal = 0;
  float a_gy1cal = 0;
  float a_gy1cala = 0;
  float a_gy1calb = 0;
  int ia_gy1cal = 0;
  int ia_gy1calwa = 0;
  int ia_gy1calwb = 0;
  int pw_gy1cala = 0;
  int pw_gy1cald = 0;
  int pw_gy1calf = 0;
  int pw_gy1cal = 0;
  int res_gy1cal = 0;
  int per_gy1cal = 0;
  int wg_gy1cal = 0;
  float a_gy1rcal = 0;
  float a_gy1rcala = 0;
  float a_gy1rcalb = 0;
  int ia_gy1rcal = 0;
  int ia_gy1rcalwa = 0;
  int ia_gy1rcalwb = 0;
  int pw_gy1rcala = 0;
  int pw_gy1rcald = 0;
  int pw_gy1rcalf = 0;
  int pw_gy1rcal = 0;
  int res_gy1rcal = 0;
  int per_gy1rcal = 0;
  int wg_gy1rcal = 0;
  float a_rf1coil = 0;
  int ia_rf1coil = 0;
  int pw_rf1coil = 0;
  int res_rf1coil = 0;
  int off_rf1coil = 0;
  int rfslot_rf1coil = 0;
  float gscale_rf1coil = 1.0;
  int n_rf1coil = 0;
  int wg_rf1coil = 0;
  float a_gzrf1coil = 0;
  int ia_gzrf1coil = 0;
  int pw_gzrf1coila = 0;
  int pw_gzrf1coild = 0;
  int pw_gzrf1coil = 0;
  int wg_gzrf1coil = 0;
  float a_gzcombcoil = 0;
  float a_gzcombcoila = 0;
  float a_gzcombcoilb = 0;
  int ia_gzcombcoil = 0;
  int ia_gzcombcoilwa = 0;
  int ia_gzcombcoilwb = 0;
  int pw_gzcombcoila = 0;
  int pw_gzcombcoild = 0;
  int pw_gzcombcoilf = 0;
  int pw_gzcombcoil = 0;
  int res_gzcombcoil = 0;
  int per_gzcombcoil = 0;
  int wg_gzcombcoil = 0;
  float a_gzprcoil = 0;
  float a_gzprcoila = 0;
  float a_gzprcoilb = 0;
  int ia_gzprcoil = 0;
  int ia_gzprcoilwa = 0;
  int ia_gzprcoilwb = 0;
  int pw_gzprcoila = 0;
  int pw_gzprcoild = 0;
  int pw_gzprcoilf = 0;
  int pw_gzprcoil = 0;
  int res_gzprcoil = 0;
  int per_gzprcoil = 0;
  int wg_gzprcoil = 0;
  float a_gxwcoil = 0;
  int ia_gxwcoil = 0;
  int pw_gxwcoila = 0;
  int pw_gxwcoild = 0;
  int pw_gxwcoil = 0;
  int wg_gxwcoil = 0;
  int filter_echo1coil = 0;
  float a_gx1coil = 0;
  float a_gx1coila = 0;
  float a_gx1coilb = 0;
  int ia_gx1coil = 0;
  int ia_gx1coilwa = 0;
  int ia_gx1coilwb = 0;
  int pw_gx1coila = 0;
  int pw_gx1coild = 0;
  int pw_gx1coilf = 0;
  int pw_gx1coil = 0;
  int res_gx1coil = 0;
  int per_gx1coil = 0;
  int wg_gx1coil = 0;
  float a_gy1coil = 0;
  float a_gy1coila = 0;
  float a_gy1coilb = 0;
  int ia_gy1coil = 0;
  int ia_gy1coilwa = 0;
  int ia_gy1coilwb = 0;
  int pw_gy1coila = 0;
  int pw_gy1coild = 0;
  int pw_gy1coilf = 0;
  int pw_gy1coil = 0;
  int res_gy1coil = 0;
  int per_gy1coil = 0;
  int wg_gy1coil = 0;
  float a_gy1rcoil = 0;
  float a_gy1rcoila = 0;
  float a_gy1rcoilb = 0;
  int ia_gy1rcoil = 0;
  int ia_gy1rcoilwa = 0;
  int ia_gy1rcoilwb = 0;
  int pw_gy1rcoila = 0;
  int pw_gy1rcoild = 0;
  int pw_gy1rcoilf = 0;
  int pw_gy1rcoil = 0;
  int res_gy1rcoil = 0;
  int per_gy1rcoil = 0;
  int wg_gy1rcoil = 0;
long _lastcv = 0;
RSP_INFO rsp_info[(2048)] = { {0,0,0,0} };
long rsprot[2*(2048)][9]= {{0}};
long rsptrigger[2*(2048)]= {0};
long ipg_alloc_instr[9] = {
4096,
4096,
4096,
4096,
4096,
4096,
4096,
8192,
64};
RSP_INFO asrsp_info[3] = { {0,0,0,0} };
long sat_rot_matrices[14][9]= {{0}};
int sat_rot_ex_indices[7]= {0};
PHYS_GRAD phygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD satloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD asloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
SCAN_INFO asscan_info[3] = { {0,0,0,0,0,0,0,0,0,{0}} };
long PSrot[1][9]= {{0}};
long PSrot_mod[1][9]= {{0}};
PHASE_OFF phase_off[(2048)] = { {0,0} };
int yres_phase= {0};
int yoffs1= {0};
int off_rfcsz_base[(2048)]= {0};
SCAN_INFO scan_info_base[1] = { {0,0,0,0,0,0,0,0,0,{0}} };
float xyz_base[(2048)][3]= {{0}};
long rsprot_base[2*(2048)][9]= {{0}};
int rtia_first_scan_flag = 1 ;
RSP_PSC_INFO rsp_psc_info[5] = { {0,0,0,{0},0,0,0} };
COIL_INFO coilInfo_tgt[10] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };
COIL_INFO volRecCoilInfo_tgt[10] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };
COIL_INFO fullRecCoilInfo_tgt[10] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };
TX_COIL_INFO txCoilInfo_tgt[5] = { { 0,0,0,0,0,0,0,0,0,{0},0,0,{0},{0},{0},{0},0 } };
int cframpdir_tgt = 1;
int chksum_rampdir_tgt = 1447292810UL;
SeqCfgInfo seqcfginfo = {0,0,0,0,0,0,{0,0,0,0,0},{{0,0,0,0,0,0,{0,0,0,0}}},{{0,0,{0},0,{0}}},{{0,0,0,0,0,0,0,0}}};
int PSfreq_offset[20]= {0};
int cfl_tdaq= {0};
int cfh_tdaq= {0};
int rcvn_tdaq= {0};
long rsp_PSrot[5] [9]= {{0}};
long rsp_rcvnrot[1][9]= {{0}};
long rsrsprot[1][9] = {{0}};
long dtgrsprot[5][9] = {{0}};
long calrsprot[64 + 1][9] = {{0}};
long coilrsprot[64 + 1][9] = {{0}};
int min_ssp= {0};
RSP_INFO rsrsp_info[1] = { {0,0,0,0} };
RSP_INFO dtgrsp_info[5] = { {0,0,0,0} };
RSP_INFO calrsp_info[64] = { {0,0,0,0} };
RSP_INFO coilrsp_info[64] = { {0,0,0,0} };
ZY_INDEX cal_zyindex[64*64] = { {0,0,0} };
ZY_INDEX coil_zyindex[64*64] = { {0,0,0} };
PSC_INFO presscfh_info[5]={ {0,0,0,{0},0,0,0} };
LOG_GRAD cflloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD ps1loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD cfhloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD rcvnloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD rsloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD dtgloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD calloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD coilloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
LOG_GRAD maptgloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0 };
PHYS_GRAD original_pgrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
WF_PROCESSOR read_axis = TYPXGRAD;
WF_PROCESSOR killer_axis = TYPYGRAD;
WF_PROCESSOR tg_killer_axis = TYPYGRAD;
WF_PROCESSOR tg_read_axis = TYPXGRAD;
RF_PULSE_INFO rfpulseInfo[(20 +24)] = { {0, 0} };
int avail_image_time= {0};
int act_tr= {0};
SCAN_INFO ks_scan_info[(2048)] = {{ .optloc = 0.0, .oprloc = 0.0, .opphasoff = 0.0, .oprot = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0}}};
KS_SLICE_PLAN ks_slice_plan = {0,0,0,{{0,0,0}}};;
int ks_sarcheckdone = (0);
char ks_psdname[256]= {0};
int ks_perform_slicetimeplot = (0);
KSGRE_SEQUENCE ksgre = {{0, 0, 1000, 0, -1, (0), {[0 ... (128 -1)] = 0}, {((void *)0), 0, ((void *)0)}, {{[0 ... (20 -1)] = 0}, 0, {[0 ... (200 -1)] = 0}, 0, {[0 ... (200 -1)] = 0}, 0, {[0 ... (500 -1)] = 0}, 0, (0) }}, {{{0,0,((void *)0),sizeof(KS_READ)}, {[0 ... (128 -1)] = 0}, 0, -1, {0.0, 0, 0.0, 0.0, -1, 0, 0, 0}, {[0 ... (500 -1)] = -1}, ((void *)0)}, 240.0, 256, 0, 0, 0, 0.0, 0.0, 0.0, 0, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}}, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, 240.0, -1, 0, 1, 0, 0.0, 0, {[0 ... (1025 -1)] = 0}}, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{KS_RF_ROLE_NOTSET, -1, -1, 0.0, 0.0, -1, -1, -1, {[0 ... (128 -1)] = 0}, {((void *)0), ((void *)0), 0.0,0.0,0.0,0.0,0.0,0,0.0,0.0,0.0,0.0,((void *)0),0.0,0.0,0,0,-1,0.0,((void *)0),0,((void *)0) }, {{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}}, -1, 1.0, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_TRAP)}, {[0 ... (128 -1)] = 0}, 0.0, 0.0, 0, 0, 0, {0, 0, 0}, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {{0,0,((void *)0),sizeof(KS_WAVE)}, {[0 ... (128 -1)] = 0}, 0, 0, {[0 ... (10000 -1)] = 0}, {0,0,0}, -1, {[0 ... (500 -1)] = {-1, -1, 1.0}}, ((void *)0), ((void *)0), ((void *)0)}, {1, 0, 0}}};;
long _lasttgtex = 0;
