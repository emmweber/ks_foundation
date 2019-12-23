#!/bin/bash

function set_ESE_vars() {

ESE_topdir=$1

ESE_version=`echo $ESE_topdir | sed s/\\\/ESE_//g`

if [[ ${ESE_version} =~ .*[RDMP][XVPX]([0-9]{2}).([0-9])_R0([0-9]).* ]]; then
  ESE_major_release=${BASH_REMATCH[1]}
  ESE_sub_release=${BASH_REMATCH[2]}
  ESE_patchnum=${BASH_REMATCH[3]}
else
  echo "error: release not matched"
  exit
fi

}

