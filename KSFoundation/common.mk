GITREV = 0000aaa
CLINICAL_MODE = 0
-include ../psd_config.mk
-include psd_config.mk

TMP01 = $(patsubst /ESE_HD%_V01,%,        $(TOP))
TMP02 = $(patsubst /ESE_DV%_VO1,%,        $(TMP01))
TMP03 = $(patsubst /ESE_DV%_VO2,%,        $(TMP02))
TMP04 = $(patsubst /ESE_DV%_0_V01,%,      $(TMP03))
TMP05 = $(patsubst /ESE_DV%.0_V01,%,      $(TMP04))
TMP06 = $(patsubst /ESE_DV%_1_V02,%,      $(TMP05))
TMP07 = $(patsubst /ESE_DV%.0_EA,%,       $(TMP06))
TMP08 = $(patsubst /ESE_DV%.0_EB,%,       $(TMP07))
TMP09 = $(patsubst /ESE_DV%.0_R01,%,      $(TMP08))
TMP10 = $(patsubst /ESE_DV%.0_R02,%,      $(TMP09))
TMP11 = $(patsubst /ESE_DV%.1_R01,%,      $(TMP10))
TMP12 = $(patsubst /ESE_DV%.1_R02,%,      $(TMP11))
TMP13 = $(patsubst /ESE_MP%.0_EA,%,       $(TMP12))
TMP14 = $(patsubst /ESE_MP%.0_R01,%,      $(TMP13))	
TMP15 = $(patsubst /ESE_MP%.0_R02,%,      $(TMP14))
TMP16 = $(patsubst /ESE_RX%.0_EB,%,       $(TMP15))
TMP17 = $(patsubst /ESE_PX%.1_R01,%,      $(TMP16))
TMP18 = $(patsubst /ESE_RX%.0_R01,%,      $(TMP17))
TMP19 = $(patsubst /ESE_RX%.0_R02,%,      $(TMP18))
RELEASE_NUM = $(patsubst /ESE_RX%.0_R03,%, $(TMP19))

/* since RX27, we need to know the patch number (R0x) too */
PATCHTMP01 = $(patsubst /ESE_DV24_0_V0%,%, $(TOP))
PATCHTMP02 = $(patsubst /ESE_DV24.0_R0%,%, $(PATCHTMP01))
PATCHTMP03 = $(patsubst /ESE_DV25.0_R0%,%, $(PATCHTMP02))
PATCHTMP04 = $(patsubst /ESE_DV25.1_R0%,%, $(PATCHTMP03))
PATCHTMP05 = $(patsubst /ESE_DV26.0_R0%,%, $(PATCHTMP04))
PATCHTMP06 = $(patsubst /ESE_MP24.0_R0%,%, $(PATCHTMP05))
PATCHTMP07 = $(patsubst /ESE_MP26.0_R0%,%, $(PATCHTMP06))	
PATCHTMP08 = $(patsubst /ESE_PX26.1_R0%,%, $(PATCHTMP07))	
PATCH_NUM = $(patsubst /ESE_RX27.0_R0%,%,  $(PATCHTMP08))

ifeq ($(TOOLSET), PSD_TGT_ICE)
TGT_DIR = tgt_ice
endif
ifeq ($(TOOLSET), PSD_TGT_MGD)
TGT_DIR = tgt_mgd
endif
ifeq ($(TOOLSET), PSD_TGT_C)
TGT_DIR = tgt
endif

ifndef ENDIAN_CONVERTER
PARENT_DIR = ../..
else
PARENT_DIR = ..
endif

/* Skip building the MGD target for RX27*/
SKIP_BUILD = FALSE

ifeq ($(TOOLSET), PSD_TGT_MGD)
ifeq ($(RELEASE_NUM), 27)

SKIP_BUILD = TRUE

endif
endif
