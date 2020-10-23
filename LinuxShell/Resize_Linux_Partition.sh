#!/bin/bash
set -e

if [[ $# -eq 0 ]] ; then
    echo 'Enter device name to resize (i.e. /dev/sda): '
    exit 1
fi


if [[ $# -eq 1 ]] ; then
    echo 'Enter partition number to resize as the second parameter ( i.e. 2): '
    exit 1
fi

DEVICE=$1
PARTNR=$2
APPLY=$3

fdisk -l $DEVICE$PARTNR >> /dev/null 2>&1 || (echo "Cannot not find device $DEVICE$PARTNR - please enter existing device" && exit 1)

CURRENTSIZEB=`fdisk -l $DEVICE$PARTNR | grep "Disk $DEVICE$PARTNR" | cut -d' ' -f5`
CURRENTSIZE=`expr $CURRENTSIZEB / 1024 / 1024`
MAXSIZEMB=`printf %s\\n 'unit MB print list' | parted | grep "Disk ${DEVICE}" | cut -d' ' -f3 | tr -d MB`

echo "Resizing partition $DEVICE$PARTNR from ${CURRENTSIZE}MB to ${MAXSIZEMB}MB "

if [[ "$APPLY" == "YES" ]] ; then
  echo "[ok] applying resize operation.."
  parted ${DEVICE} resizepart ${PARTNR} ${MAXSIZEMB}
  echo "[done]"
else
  echo "TEST Mode, write 'YES' as third paramater to apply the changes"
fi
