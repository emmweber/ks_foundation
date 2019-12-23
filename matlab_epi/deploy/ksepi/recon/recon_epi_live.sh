#!/bin/bash

#------------------------------------------ Recon config worth changing ------------------------------------------------
# Recon options for recon_epi (the compiled recon_epi.m)
recon_epi_options="tempdata disk parpool 4 moco 1"  # use this to reduce VRE recon time for 2D (recon_epi->recon_2Depi.m).
                                                    # recon_epi->recon_3Depi.m ignores parpool requests for now
                                                    # until a use case is found

# recon_epi_options="tempdata disk parpool 0 moco 1" # use this to reduce stress on the VRE

# Number of previous exams to keep in /export/home/sdc/ksepi/data on the MR Host
# ScanArchive, logs and DICOMs are stored here after recon
number_exams_to_keep=5

# show popup?
show_popup=1

#-------------------------------------------- Input checking -----------------------------------------------------------
exe_dir=`readlink -f -- ${0}`
exe_dir=`dirname "${exe_dir}"`

if [ ! -f /usr/g/bin/whatRev ]; then
  echo " "
  echo "${exe_dir}/${0} must be called on the MR host as a son-of-recon process"
  echo " "
  echo "On MR Host, make link: /usr/g/bin/recon961 -> ${exe_dir}/${0}"
  exit
fi

mrrelease=$(whatRev | head -2 | tail -1 | awk '{print $6}' | cut -d'.' -f 1 | cut -d'V' -f 2 | cut -d'X' -f 2)

runno=${1}
exam=${4}
series=${5}
printf -v exampadded "%05d" ${exam}
printf -v seriespadded "%03d" ${series}

LOG="/export/home/sdc/ksepi/data/recon_epi_live_e${exampadded}s${seriespadded}.log"
rm -f ${LOG}
touch ${LOG}

echo `date` >> ${LOG}
echo "Son of recon command:" >> ${LOG}
echo "${0} ${1} ${2} ${3} ${4} ${5} ${6} " >> ${LOG}
echo "" >> ${LOG}

# Directories
vre_landingdir="/data/arc/Closed/Exam${exam}/Series${series}"
vre_rootdir="/data/acq/ksepi" # Don't change this path. Most disk space and fastest disk. Requires /export/home/sdc/ksepi/recon/mkdir_vre_ksepi to create it (via setuid)
vre_recondir="${vre_rootdir}/e${exampadded}s${seriespadded}"
storerootdir="/export/home/sdc/ksepi/data"
storedir="/export/home/sdc/ksepi/data/e${exampadded}s${seriespadded}"
importdir="/export/home1/sdc_image_pool/import/e${exampadded}s${seriespadded}"
calib_dir="/usr/g/recon_calib/ExamData/${exam}"

echo "Program name: $0" >> ${LOG}
echo "Exe dir: ${exe_dir}" >> ${LOG}
echo "Exam: ${exam} Series: ${series} Runno: ${runno}" >> ${LOG}
echo "MR Release: ${mrrelease}" >> ${LOG}
echo "VRE Landing dir: ${vre_landingdir}" >> ${LOG}
echo "VRE Root dir: ${vre_rootdir}" >> ${LOG}
echo "VRE Recon dir: ${vre_recondir}" >> ${LOG}
echo "Post-recon store dir: ${storedir}" >> ${LOG}
echo "Import dir: ${importdir}" >> ${LOG}
echo "Recon options: ${recon_epi_options}" >> ${LOG}
echo "# Exams to keep: ${number_exams_to_keep}" >> ${LOG}
echo "" >> ${LOG}

#---------------------------- Wait for the scan-type Scan Archive file to be stored on disk (VRE) ----------------------
waiting_time=0
max_waiting_time=30
polling_interval=2

while [ 1 ]; do
  h5file=`rsh vre "ls -1tr ${vre_landingdir}/S*.h5 | tail -1"`
  h5file_typescan=`rsh vre "/usr/g/bin/ArchiveTool --list-info --input-file ${h5file} | grep 'Scan Type: Scan'"`
  if [ $((${#h5file_typescan})) -eq 0 ] && [ $((${waiting_time})) -le $((${max_waiting_time})) ]; then
    sleep ${polling_interval}
    ${waiting_time}=$((${waiting_time} + ${polling_interval}))
  else
    break
  fi
done

echo "Scan archive waiting time: ${waiting_time}" >> ${LOG}
echo `date` >> ${LOG}

#---------------------------------- Copy data to /data/acq -------------------------------------------------------------

if [ $mrrelease -ge "26" ]; then
  # DV26, RX27 or later, uses ScanArchives
  
  # Make sure ${vre_rootdir} exists
  vre_rootdir_test=`rsh vre "test -e ${vre_rootdir} && echo 'yes' || echo 'no'"`
  if [ "${vre_rootdir_test}" == "no" ]; then

    # try to create vre_rootdir as sdc via mkdir_vre_ksepi. Check that the 's' bit is set for /export/home/sdc/ksepi/recon/mkdir_vre_ksepi
    # -rwsr-xr-x 1 root root     12592 Jan 30 16:00 mkdir_vre_ksepi
    # When installed via an RPM build by the ksepi.spec file in the matlab folder deploy/rpmbuild/
    if [ -f "/export/home/sdc/ksepi/recon/mkdir_vre_ksepi" ]; then
      rsh vre "/export/home/sdc/ksepi/recon/mkdir_vre_ksepi"
    fi

    # check again after attempt to create it using 'mkdir_vre_ksepi' (hard coded to vre:/data/acq/ksepi)
    vre_rootdir_test=`rsh vre "test -e ${vre_rootdir} && echo 'yes' || echo 'no'"`
    if [ "${vre_rootdir_test}" == "no" ]; then
      popupmsg "ksepi: To enable VRE recon, open a terminal and type:\nsu [password]\nchown root:root /export/home/sdc/ksepi/recon/mkdir_vre_ksepi\nchmod 4755 /export/home/sdc/ksepi/recon/mkdir_vre_ksepi" &
      exit
    fi
  fi

  # make subdir ${vre_recondir} in ${vre_rootdir} (on VRE). Copy from ${vre_landingdir} to ${vre_recondir}
  cmd="mkdir -p ${vre_recondir} ; rsync -a ${vre_landingdir}/ ${vre_recondir}/"
  echo "rsh vre ${cmd}" >> ${LOG}
  rsh vre "${cmd}"	 >> ${LOG}

  # get the most recent Pure cal
  latestpurefile=`ls -1tr ${calib_dir}/Pure*h5 | tail -1`

  if [ ${#latestpurefile} -gt 0 ]; then
    # copy pure data ${vre_recondir}/calib if present
    cmd="mkdir -p ${vre_recondir}/calib"
    echo "rsh vre ${cmd}" >> ${LOG}
    rsh vre "${cmd}"	 >> ${LOG}

    cmd="rcp ${latestpurefile} vre:${vre_recondir}/calib/"
    echo "${cmd}" >> ${LOG}
    ${cmd} >> ${LOG}
  fi

else
  # DV24, DV25, use Pfiles (work in /usr/g/mrraw) NOT ENABLED

  popupmsg "No support for pre-DV26 (Pfiles) " &
  exit

fi

#---------------------------------------------------- Recon ------------------------------------------------------------
# Actual recon process (recon_epi.sh calls in turn VRE)
# Arg #1 to recon_epi.sh is ${vre_recondir} and is used on VRE, not Host
# Arg #2 (recon_epi_options): Use the common arguments available in recon_2Depi.m and recon_3Depi.m, except for 'sendto'
# since Matlab is called on VRE, not connected to the world and cannot send DICOMs to remote dicom nodes. For DICOM import
# to the MR Host we move the files anyway to ${importdir}, whereby they are automatically imported to the DB
echo `date` >> ${LOG}
cmd="${exe_dir}/recon_epi.sh ${vre_recondir} ${recon_epi_options}"
echo $cmd >> ${LOG}
echo "" >> ${LOG}
$cmd >> ${LOG}

#--------------------------- Move DICOMs and rawdata from vre:/data/acq/ksepi/... to ${storedir} -----------------------
echo `date` >> ${LOG}
mkdir -p ${storerootdir} # same on HOST and VRE
cmd="mv ${vre_recondir} ${storerootdir}"
echo "rsh vre ${cmd}" >> ${LOG}
rsh vre "${cmd}" >> ${LOG}

#---------------------------------------- Import DICOMs to MR Host DB --------------------------------------------------
echo `date` >> ${LOG}
if ls ${storedir}/matlabDicoms/*.dcm 1> /dev/null 2>&1; then
  cmd="cp -r ${storedir}/matlabDicoms ${importdir}"
  echo ${cmd} >> ${LOG}
  ${cmd} >> ${LOG}

  cmd="mv ${importdir} ${importdir}.sdcopen" # extension .sdcopen triggers DICOM import in this folder
  echo ${cmd} >> ${LOG}
  ${cmd} >> ${LOG}

  if [ ${show_popup} ]; then
    logoutput=`cat ${storedir}/recon_epi.log`
    popupmsg "Exam ${exam} Series ${series} complete\n${logoutput}" &
  fi

else
  echo "No DICOM images" >> ${LOG}
fi

#---------------------------------------- Only keep the $number_exams_to_keep last exams -------------------------------
echo `date` >> ${LOG}
cd ${storerootdir}

# extra safety so we don't wipe the wrong dir by a faulty ${storerootdir}
if [ `pwd` == "/export/home/sdc/ksepi/data" ]; then 
  # move recon_epi_live_**.log
  mv ${LOG} ${storedir}

  nexams=`ls -1d e* | wc -l`
  nexams_to_remove=$((${nexams} - ${number_exams_to_keep}))
  if [ ${nexams_to_remove} -ge 1 ]; then
    examdirs_to_remove=`ls -1trd e*s* | head -${nexams_to_remove} | tr '\n' ' '`
    rm -rf ${examdirs_to_remove}
  fi

fi
