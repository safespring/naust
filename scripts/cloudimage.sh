#!/bin/bash

# Checks for (and if found, updates to) latest cloud image in ${basepath}

[ ! -f ${basepath} ] && echo "${basepath} not found" && exit 1

basepath=../base/base.json
httppath=http://cloud.centos.org/centos/7/images/
latestimage=`wget -qO- ${httppath}sha256sum.txt|grep CentOS-7-x86_64-GenericCloud-....\.qcow2$|tail -1|awk '{ print $2 }'`
ourimage=`jq --raw-output .qemu_image ${basepath} |sed 's!.*/!!'`

[ ${latestimage} == ${ourimage} ] && latest=true || latest=false

echo -n "Latest image seems to be ${latestimage}, "
if $latest; then
  echo "which we seem to be running."
else
  echo "while we are running ${ourimage}."
  echo "Updating ${basepath}."
  checksum=`wget -qO- http://cloud.centos.org/centos/7/images/sha256sum.txt|grep CentOS-7-x86_64-GenericCloud-....\.qcow2$|tail -1|awk '{ print $1 }'`
  # Forferdelig griseri
  tfile=$(mktemp)
  jq ".qemu_image = \"${httppath}${latestimage}\"" ${basepath} > ${tfile}
  jq ".qemu_image_checksum = \"${checksum}\"" ${tfile} > ${basepath}
  rm ${tfile}
fi
