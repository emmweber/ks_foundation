#!/bin/bash
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : compile_psd.sh
#
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# PSD compilation script, hiding output but reporting SUCCESS/FAIL
#*******************************************************************************************************
 

exe_dir=`readlink -f -- ${0}`
exe_dir=`dirname "${exe_dir}"`

platform=`uname -s`

if [ ${platform} != "Linux" ]; then
  echo "psd compilation on Linux only"
  exit
fi

source ${exe_dir}/set_ESE_vars.sh

ESE_topdir=$1
psddir=$2

set_ESE_vars ${ESE_topdir} # sets: $ESE_version $ESE_major_release $ESE_sub_release $ESE_patchnum

set_ese_command=$ESE_topdir/psd/config/set_ese_vars_bash
source ${set_ese_command}

# Karolinska: If KSFoundation source code is available, compile it
ksflibsource=${psddir}/../KSFoundation/$ESE_major_release
if [ -e ${ksflibsource}/KSFoundation_host.c ]; then
  cd ${ksflibsource};
  psdqmake clean all > /dev/null 2>&1
  status=$?
  if [ ${status} -ne 0 ]; then
    echo "${0}: KSFoundation library FAIL (${ESE_major_release})"
    exit 1
  else
    echo "${0}: KSFoundation library SUCCESS (${ESE_major_release})"
  fi
fi

# Compile PSD
cd ${psddir}
prep_psd_dir > /dev/null 2>&1
psdqmake clean all > /dev/null 2>&1
status=$?
if [ ${status} -ne 0 ]; then
  echo "${0}: PSD FAIL (${ESE_topdir})"
  exit 1
else
  echo "${0}: PSD SUCCESS (${ESE_topdir})"
fi
