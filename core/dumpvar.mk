# ---------------------------------------------------------------
# the setpath shell function in envsetup.sh uses this to figure out
# what to add to the path given the config we have chosen.

ifneq ($(BUILD_WITH_COLORS),0)
  CL_RED="\033[31m"
  CL_GRN="\033[32m"
  CL_YLW="\033[33m"
  CL_BLU="\033[34m"
  CL_MAG="\033[35m"
  CL_CYN="\033[36m"
  CL_RST="\033[0m"
endif

ifeq ($(CALLED_FROM_SETUP),true)

ABP:=$(PWD)/$(HOST_OUT_EXECUTABLES)

ifeq ($(TARGET_SIMULATOR),true)
	ABP:=$(ABP):$(TARGET_OUT_EXECUTABLES)
else
	# this should be copied to HOST_OUT_EXECUTABLES instead
	ABP:=$(ABP):$(PWD)/prebuilt/$(HOST_PREBUILT_TAG)/toolchain/arm-eabi-4.4.3/bin
endif
ANDROID_BUILD_PATHS := $(ABP)
ANDROID_PREBUILTS := prebuilt/$(HOST_PREBUILT_TAG)

# The "dumpvar" stuff lets you say something like
#
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-TARGET_OUT
# or
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-abs-HOST_OUT_EXECUTABLES
#
# The plain (non-abs) version just dumps the value of the named variable.
# The "abs" version will treat the variable as a path, and dumps an
# absolute path to it.
#
dumpvar_goals := \
	$(strip $(patsubst dumpvar-%,%,$(filter dumpvar-%,$(MAKECMDGOALS))))
ifdef dumpvar_goals

  ifneq ($(words $(dumpvar_goals)),1)
    $(error Only one "dumpvar-" goal allowed. Saw "$(MAKECMDGOALS)")
  endif

  # If the goal is of the form "dumpvar-abs-VARNAME", then
  # treat VARNAME as a path and return the absolute path to it.
  absolute_dumpvar := $(strip $(filter abs-%,$(dumpvar_goals)))
  ifdef absolute_dumpvar
    dumpvar_goals := $(patsubst abs-%,%,$(dumpvar_goals))
    DUMPVAR_VALUE := $(PWD)/$($(dumpvar_goals))
    dumpvar_target := dumpvar-abs-$(dumpvar_goals)
  else
    DUMPVAR_VALUE := $($(dumpvar_goals))
    dumpvar_target := dumpvar-$(dumpvar_goals)
  endif

.PHONY: $(dumpvar_target)
$(dumpvar_target):
	@echo $(DUMPVAR_VALUE)

endif # dumpvar_goals

ifneq ($(dumpvar_goals),report_config)
PRINT_BUILD_CONFIG:=
endif

endif # CALLED_FROM_SETUP


ifneq ($(PRINT_BUILD_CONFIG),)

$(info $(shell clear))
$(info $(shell echo -e ${CL_CYN}======================${CL_RST}))
$(info $(shell echo -e ${CL_CYN}Welcome to Steel Droid${CL_RST}))
$(info $(shell echo -e ${CL_CYN}======================${CL_RST}))
$(info $(shell echo ))
$(info $(shell echo -e ${CL_CYN}"============================================"${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"BUILD_ID=                    "${CL_RST})$(shell echo -e ${CL_GRN}$(BUILD_ID)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"PLATFORM_VERSION=            "${CL_RST})$(shell echo -e ${CL_GRN}$(PLATFORM_VERSION)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_BUILD_TYPE=           "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_BUILD_TYPE)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_PRODUCT=              "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_PRODUCT)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_BUILD_VARIANT=        "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_BUILD_VARIANT)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_SIMULATOR=            "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_SIMULATOR)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_BUILD_APPS=           "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_BUILD_APPS)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_ARCH=                 "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_ARCH)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"TARGET_ARCH_VARIANT=         "${CL_RST})$(shell echo -e ${CL_GRN}$(TARGET_ARCH_VARIANT)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"HOST_ARCH=                   "${CL_RST})$(shell echo -e ${CL_GRN}$(HOST_ARCH)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"HOST_OS=                     "${CL_RST})$(shell echo -e ${CL_GRN}$(HOST_OS)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"HOST_BUILD_TYPE=             "${CL_RST})$(shell echo -e ${CL_GRN}$(HOST_BUILD_TYPE)${CL_RST}))
$(info $(shell echo -e ${CL_CYN}"============================================"${CL_RST}))

endif
