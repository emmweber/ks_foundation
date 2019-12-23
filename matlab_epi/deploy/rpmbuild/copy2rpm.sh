#!/bin/bash
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : copy2rpm.sh
#
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# Script called by build_RPM_ksepi.sh to copy matlab and psd binaries for RPM build
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
tarfile=$3
psdname=`basename ${psddir}`

set_ESE_vars ${ESE_topdir} # sets: $ESE_version $ESE_major_release $ESE_sub_release $ESE_patchnum

# Empty ${exe_dir}/SOURCES directory
rm -rf ${exe_dir}/SOURCES/${psdname}
mkdir -p ${exe_dir}/SOURCES/${psdname}


# Copy psd binaries
psdhostfile=$psddir/host/$psdname
if [ -f $psdhostfile ]; then
    cmd="cp ${psdhostfile} ${exe_dir}/SOURCES/${psdname}/"
    echo ${cmd}
    ${cmd}
else
    echo "$0: Missing host file ($psdname)"
    exit 1
fi


if [ ${ESE_major_release} -ge 26 ]; then
    tgticefile=$psddir/tgt_ice/$psdname.psd.ice
    tgtmgdfile=$psddir/tgt_mgd/$psdname.psd.mgd

    if [ ! -f $tgtmgdfile ] && [ ! -f $tgticefile ]; then
        echo "$0: Missing both tgt_ice ($tgticefile) and tgt_mgd files ($tgtmgdfile)"
        exit 1
    else
        if [ -f $tgtmgdfile ]; then
            cmd="cp ${tgtmgdfile} ${exe_dir}/SOURCES/${psdname}/"
            echo ${cmd}
            ${cmd}
        fi
        if [ -f $tgticefile ]; then
            cmd="cp ${tgticefile} ${exe_dir}/SOURCES/${psdname}/"
            echo ${cmd}
            ${cmd}
        fi
    fi
else
    echo $0": Warning - preDV26 is not supported by recon_epi_live.sh->recon_epi.sh on the MR scanner since it requires ScanArchives"
    tgtfile=$psddir/tgt/$psdname.psd.o
    if [ -f $tgtfile ]; then
        cmd="cp ${tgtfile} ${exe_dir}/SOURCES/${psdname}/"
        echo ${cmd}
        ${cmd}
    else
        echo "$0: Missing tgt file (${tgtfile})"
        exit 1
    fi
fi

# Copy matlab tree
cmd="rsync -a --exclude=*.c --exclude=.DS_Store ${exe_dir}/../${psdname}/recon/ ${exe_dir}/SOURCES/${psdname}/"
echo $cmd
$cmd

# Tar tmp dir
cd ${exe_dir}/SOURCES/${psdname}/
cmd="tar cf ../${tarfile} *"
echo $cmd
$cmd
