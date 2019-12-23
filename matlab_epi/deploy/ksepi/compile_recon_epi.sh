#!/bin/bash
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : compile_recon_epi.sh
#
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# Compilation of recon_epi.m for later RPM build using rpmbuild/build_RPM_ksepi.sh
#*******************************************************************************************************
 

platform=`uname -s`

exe_dir=`readlink -f -- ${0}`
exe_dir=`dirname "${exe_dir}"`

cd ${exe_dir}/.. # cd .. to 'deploy' directory

buildpath=${exe_dir}/recon

if [ ${platform} == "Linux" ]; then
  # compile a mkdir binary that should run as root on VRE to create the directory vre:/data/acq/ksepi via setuid
  gcc -o ${buildpath}/mkdir_vre_ksepi ${buildpath}/mkdir_vre_ksepi.c

  suffix="linux"
elif [ ${platform} == "Darwin" ]; then
  suffix="mac"
else
  suffix="win"
fi

dcmdump="../dicom/dcmdump_${suffix}"
dcmodify="../dicom/dcmodify_${suffix}"
hostsjson="../wrappers/dicomutils/hosts.json"

mccpath=`which mcc`
mccpath=`readlink -f -- ${mccpath}`
mccpath=`dirname "${mccpath}"`

matlab_release=`grep "<release>" ${mccpath}/../VersionInfo.xml`
if [[ ${matlab_release} =~ .*\<release\>R(.*)\<\/release\> ]]; then
  matlab_release=${BASH_REMATCH[1]}
else
  echo "error: Matlab version could not be determined"
  exit
fi

mcc -R "-logfile,./recon_epi.log" -d ${buildpath} -m recon_epi.m -a ${dcmdump} -a ${dcmodify} -a ${hostsjson} > /dev/null 2>&1 
status=$?
if [ ${status} -ne 0 ]; then
  echo "${0}: FAIL"
  exit 1
else
  echo "${0}: SUCCESS"
fi
rm -f ${buildpath}/mccExcludedFiles.log
rm -f ${buildpath}/readme.txt
rm -f ${buildpath}/requiredMCRProducts.txt
rm -f ${buildpath}/run_recon_epi.sh

echo "${matlab_release}" > ${buildpath}/runtimeversion.txt
echo "${suffix}" >> ${buildpath}/runtimeversion.txt
