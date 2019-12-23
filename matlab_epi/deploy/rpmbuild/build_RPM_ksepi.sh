#!/bin/bash
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : build_RPM_ksepi.sh
# 
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# RPM package builder for ksepi psd & recon (KSFoundation)
#*******************************************************************************************************
 

platform=`uname -s`

if [ ${platform} != "Linux" ]; then
  echo "RPM generation on Linux only"
  exit
fi

if [ "$#" -lt 1 ]; then
  echo "Usage:"
  echo "$0 [/path/to/ksepi_psd_dir]"
  exit
fi

echo `date`
echo ""

exe_dir=`readlink -f -- ${0}`
exe_dir=`dirname "${exe_dir}"`

source ${exe_dir}/set_ESE_vars.sh

psddir=${1}
psdname=`basename ${psddir}`

cwd=$(pwd)
ksepi_release_version='1.0'

declare -a ESE_topdir=(
                "/ESE_DV26.0_R01"
                "/ESE_DV26.0_R02"
                "/ESE_PX26.1_R01"
                "/ESE_MP26.0_R01"
                "/ESE_RX27.0_R02"
                "/ESE_RX27.0_R03"
                )    

numReleases=${#ESE_topdir[@]}

# remove old RPM output folders
rm -rf ${exe_dir}/BUILD
rm -rf ${exe_dir}/BUILDROOT
rm -rf ${exe_dir}/SRPMS
rm -rf ${exe_dir}/SOURCES/${psdname}
rm -rf ${exe_dir}/SOURCES/${psdname}*.tar

# Compile recon_epi.m output in deploy/ksepi/recon/
echo "Compiling MATLAB: recon_epi.m"
cmd="${exe_dir}/../ksepi/compile_recon_epi.sh"
echo ${cmd}
${cmd}
status=$?
if [ ${status} -ne 0 ]; then
  exit
fi


## Compile ksepi.e. Loop over ESE releases and build one RPM per release
for  (( i = 0; i < ${numReleases} ; i++ )); do
  echo ""
  echo ${ESE_topdir[$i]}": "

  set_ESE_vars ${ESE_topdir[$i]} # sets: $ESE_version $ESE_major_release $ESE_sub_release $ESE_patchnum

  if [ -e ${ESE_topdir} ]; then

    # Check for 26+ release (so we can use ScanArchives)
    if [ $ESE_major_release -lt 26 ]; then
      echo "$ESE_major_release: Release 26 or later is needed as recon_epi_live.sh relies on ScanArchive data (not Pfiles)"
      exit
    fi

    # compile psd
    echo `date`
    cmd="${exe_dir}/compile_psd.sh ${ESE_topdir} ${psddir}"
    echo ${cmd}
    ${cmd}
    status=$?
    if [ ${status} -ne 0 ]; then
      exit
    fi

    tarfile="${psdname}_${ESE_version}_${ksepi_release_version}.tar"
    
    cmd="${exe_dir}/copy2rpm.sh ${ESE_topdir} ${psddir} ${tarfile}"
    echo ${cmd}
    ${cmd}
    status=$?
    if [ ${status} -ne 0 ]; then
      exit
    fi

    echo `date`
    echo "rpmbuild -bb SPECS/ksepi.spec --define '_topdir '${cwd} --define 'version '${ESE_version} --define 'release_version '${ksepi_release_version} --define 'source_file '${tarfile}"
          rpmbuild -bb SPECS/ksepi.spec --define '_topdir '${cwd} --define 'version '${ESE_version} --define 'release_version '${ksepi_release_version} --define 'source_file '${tarfile} 2> /dev/null # 2>&1

    status=$?
    if [ ${status} -ne 0 ]; then
      exit
    fi

    echo "--------------------------------------------------------------"

  fi
  
done


# remove old RPM output folders
rm -rf ${exe_dir}/BUILD
rm -rf ${exe_dir}/BUILDROOT
rm -rf ${exe_dir}/SRPMS
rm -rf ${exe_dir}/SOURCES/${psdname}
rm -rf ${exe_dir}/SOURCES/${psdname}*.tar

echo `date`
