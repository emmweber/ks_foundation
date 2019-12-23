#!/bin/bash
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : build_RPM_matlabruntime.sh
# 
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# RPM package builder for Matlab runtime for linux (MR host)
#*******************************************************************************************************
 

platform=`uname -s`

if [ ${platform} != "Linux" ]; then
  echo "RPM generation on Linux only"
  exit
fi

if [ "$#" -lt 1 ]; then
  echo "Usage:"
  echo "$0 [mcr installer zip file]"
  exit
fi


exe_dir=`readlink -f -- ${0}`
exe_dir=`dirname "${exe_dir}"`

mcrfile=${1}

cwd=$(pwd)
echo "=================================================================================================="
echo "  Expect about one hour for completion (mainly due to rpmbuild)"
echo "=================================================================================================="
echo ""

# remove old RPM output folders

echo `date`" - Removing previous temp files"
rm -rf ${exe_dir}/BUILD
rm -rf ${exe_dir}/BUILDROOT
rm -rf ${exe_dir}/SOURCES
rm -rf ${exe_dir}/SRPMS

mkdir ${exe_dir}/SOURCES

matlabruntime_temproot=${exe_dir}/matlabruntimeForRPM_temp
matlabruntime_temp=${matlabruntime_temproot}/unzipped
matlabruntime=${matlabruntime_temproot}/install
rm -rf ${matlabruntime_temproot}
mkdir -p ${matlabruntime_temp}
mkdir -p ${matlabruntime}

echo `date`" - Unzipping MCR file to ${matlabruntime_temp}"
unzip -qq ${mcrfile} -d ${matlabruntime_temp}

# Determine which Matlab release from MCR file name (also require linux MCR)
if [[ ${mcrfile} =~ .*R(.*)_(.*)_.* ]]; then
  matlab_release=${BASH_REMATCH[1]}
  arch=${BASH_REMATCH[2]}
  echo "Matlab release found via MCR filename: "${matlab_release}
  if [ $arch != 'glnxa64' ]; then
    echo "MCR file must be for the Linux platform"
    exit
  fi
fi

# Backup solution: Find VersionInfo.xml to retrieve the R20xxx tag
if [ ${#matlab_release} -eq 0 ]; then
  matlab_release=`grep "<release>" ${matlabruntime_temp}/VersionInfo.xml`
  if [[ ${matlab_release} =~ .*\<release\>R(.*)\<\/release\> ]]; then
    matlab_release=${BASH_REMATCH[1]}
      echo "Matlab release found via VersionInfo.xml: "${matlab_release}
  else
    echo "error: Matlab release could not be determined. Aborting"
    exit
  fi
fi

echo `date`" - Installing Matlab MCR to temp folder ${matlabruntime}"
echo "${matlabruntime_temp}/install -mode silent -agreeToLicense yes -destinationFolder ${matlabruntime}"
${matlabruntime_temp}/install -mode silent -agreeToLicense yes -destinationFolder ${matlabruntime} # > /dev/null 2>&1

cd ${matlabruntime}/v*

tarfile=${exe_dir}/SOURCES/${matlab_release}.tar
echo `date`" - Tar of ${matlabruntime} to ${tarfile}"
tar cf ${tarfile} .

cd ${matlabruntime_temproot}

echo "=================================================================================================="
echo "  Type in root password to avoid untar issues in rpmbuild. Then come back in an hour..."
echo "=================================================================================================="
echo ""

echo `date`" - RPM building using tar file"
echo "rpmbuild --nocheck --quiet -bb ${exe_dir}/SPECS/matlabruntime.spec --define '_topdir '${cwd} --define 'matlab_release '${matlab_release} --define 'source_file '${tarfile}"
sudo  rpmbuild --nocheck --quiet -bb ${exe_dir}/SPECS/matlabruntime.spec --define '_topdir '${cwd} --define 'matlab_release '${matlab_release} --define 'source_file '${tarfile}  2> /dev/null # 2>&1

cd ${cwd}

rm -rf ${matlabruntime_temproot}
rm -rf ${exe_dir}/BUILD
rm -rf ${exe_dir}/BUILDROOT
rm -rf ${exe_dir}/SOURCES
rm -rf ${exe_dir}/SRPMS
rm -rf /tmp/mathworks_*

echo `date`" - End time"