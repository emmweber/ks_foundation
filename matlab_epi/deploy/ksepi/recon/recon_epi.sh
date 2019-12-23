#!/bin/bash

#------------------------------------------------- Input checking and config  -------------------------------------------

exe_dir=`dirname "$0"`
exe_dir=`readlink -f -- ${exe_dir}`

if [ "$#" -lt 1 ]; then
  echo "usage:"
  echo "   recon_epi.sh /path/to/pfile/or/scanarchive '[optional recon_epi args]''"
  exit
else
  RAWDATAPATH=${1}
  if [ "$#" -ge 2 ]; then
    RECON_EPI_ARGS=${@:2} # args 2:end
  else
    RECON_EPI_ARGS=""
  fi
fi

if [ -f /home/sdc/vrf_install ]; then
  # VRE: recon_epi.sh should be called on HOST, but recon_epi (binary) is then called via rsh on VRE
  echo "This script should be executed on the MR HOST or a standalone linux workstation (not the VRE)"
  exit
fi

if [ -f /usr/g/bin/whatRev ]; then
  # on a GE MR scanner with connection to the VRE (rsh vre)
  MRSCANNER_HOST=1
  echo "Computer:        MR HOST (will execute recon on VRE)"
  
  if [ ${exe_dir} != "${HOME}/ksepi/recon" ]; then
    errmsg="recon_epi.sh must be located in ${HOME}/ksepi/recon"
    echo $errmsg
    popupmsg $errmsg &
    exit
  fi
else
  echo "Computer:        Standalone linux workstation"
  MRSCANNER_HOST=0
  RAWDATAPATH=`readlink -f -- ${RAWDATAPATH}` # follow symlink on standalone workstation
fi

# Check runtime version
if [ -f ${exe_dir}/runtimeversion.txt ]; then
  matlabver=$(head -1 ${exe_dir}/runtimeversion.txt)
else
  popupmsg "Missing info about Matlab runtime version. Aborting" &
  exit
fi

#------------------------- Search for Matlab${matlabver} runtime ---------------------------
if [ -d "${HOME}/MATLAB/matlab${matlabver}_runtime_linux" ]; then
  MCRROOT="${HOME}/MATLAB/matlab${matlabver}_runtime_linux" # MR HOST or standalone linux worksstation
elif [ -d "${exe_dir}/../../matlab${matlabver}_runtime_linux" ] && [ ${MRSCANNER_HOST} == 0 ]; then
  MCRROOT="${exe_dir}/../../matlab${matlabver}_runtime_linux" # standalone linux worksstation
elif [ -d "${exe_dir}/../../MATLAB/matlab${matlabver}_runtime_linux" ] && [ ${MRSCANNER_HOST} == 0 ]; then
  MCRROOT="${exe_dir}/../../MATLAB/matlab${matlabver}_runtime_linux" # standalone linux worksstation
else
  if [ ${MRSCANNER_HOST} == 1 ]; then
    popupmsg "Could not find Matlab runtime in: ${HOME}/MATLAB/matlab${matlabver}_runtime_linux" &
    exit
  fi
fi

#------------------------------------------------- Set UNIX environment variables ------------------------------------------------

# N.B.: $MCRROOT is the same on MR HOST and VRE since it has to be /export/home/sdc/MATLAB/matlab${matlabver}_runtime_linux
# and mrhost:/export/home/sdc is mounted as vre:/export/home/sdc
echo "Matlab runtime:  $MCRROOT"

# LIBRARY PATH for Matlab executable
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64 ;
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64;
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64;
export LD_LIBRARY_PATH;

# LD_PRELOAD is necessary for VRE
if [ ${MRSCANNER_HOST} == 1 ] ; then
  export LD_PRELOAD=/usr/lib64/libgomp.so.1.0.0
elif [ -f "/usr/lib/x86_64-linux-gnu/libgomp.so.1" ]; then
  export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libgomp.so.1
elif [ -f "/usr/lib64/libgomp.so.1" ]; then
  export LD_PRELOAD=/usr/lib64/libgomp.so.1
fi

# Run recon_epi
echo "Data location:   ${RAWDATAPATH}"
RECON_EPI="${exe_dir}/recon_epi ${RECON_EPI_ARGS}"
echo "Recon file:      ${RECON_EPI}"


#------------------------------------------------- Recon on VRE or Standalone linux -----------------------------------------------
# recon log is: 'recon_epi.log'  (specified in compile_recon_epi.m)

if [ ${MRSCANNER_HOST} == 1 ]; then # MR HOST calling VRE

  # DICOM dictionary
  export DCMDICT=/export/home/sdc/app-defaults/dicom/gems-dicom-dict.txt

  VRE_ENV="export DCMDICT=${DCMDICT}; export LD_PRELOAD=${LD_PRELOAD}; export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
  cmd="${VRE_ENV} ; cd ${RAWDATAPATH}; rm -f recon_epi.log; timeout --signal=SIGKILL 3600s ${RECON_EPI}"
  echo "rsh vre \"${cmd}\""

  # remote exec on VRE
  rsh vre "${cmd}" &> /dev/null
  rsh vre "cat ${RAWDATAPATH}/recon_epi.log"
  rsh vre "rm -f /home/sdc/matlab_crash_dump*"

else # Standalone linux workstation

  cd ${RAWDATAPATH}
  rm -f recon_epi.log
  echo "${RECON_EPI} &> /dev/null"
  ${RECON_EPI} &> /dev/null

  rm -f ${HOME}/matlab_crash_dump*

fi


