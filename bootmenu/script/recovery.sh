#!/sbin/sh

######## BootMenu Script
######## Execute [Latest Recovery] Menu


export PATH=/sbin:/system/xbin:/system/bin

######## Main Script

PART_DATA=/dev/block/mmcblk1p26
PART_SYSTEM=/dev/block/mmcblk1p21

# Moto 2.3.3 /tmp is a link to /data/tmp, bad thing ! &&
[ -L /tmp ] && rm /tmp
[ -L /etc ] && rm /etc

mkdir /tmp
mkdir /etc
mkdir /res

# hijack mke2fs & tune2fs CWM3
rm -f /sbin/mke2fs
rm -f /sbin/tune2fs
rm -f /sbin/e2fsck

cp -r -f /system/bootmenu/recovery/res/* /res/
cp -r -f /system/bootmenu/recovery/sbin/* /sbin/
chmod 755 /sbin/*
cp -p -f /system/bootmenu/script/recoveryexit.sh /sbin/
cp /system/bootmenu/recovery/recovery.fstab /etc/recovery.fstab

if [ ! -f /sbin/recovery ]; then
    ln -s /sbin/recovery_stable /sbin/recovery
fi

# for ext3 format
cp /system/etc/mke2fs.conf /etc/

mkdir -p /cache/recovery
touch /cache/recovery/command
touch /cache/recovery/log
touch /cache/recovery/last_log
touch /tmp/recovery.log

# load overclock settings to reduce heat and battery use
/system/bootmenu/script/overclock.sh

#CWM below5.0.3.0 don't need this.
# mount image of pds, for backup purpose (4MB)
#[ ! -d /data/data ] && mount -t ext3 -o rw,noatime,nodiratime,errors=continue $PART_DATA /data
#if [ ! -f /data/pds.img ]; then
#    /system/etc/init.d/02pdsbackup
#    umount /pds
#    losetup -d /dev/block/loop7
#fi
#cp /data/pds.img /tmp/pds.img
#if [ -f /tmp/pds.img ] ; then
#    mkdir -p /pds
#    umount /pds 2>/dev/null
#    losetup -d /dev/block/loop7 2>/dev/null
#    losetup /dev/block/loop7 /tmp/pds.img
#    busybox mount -o rw,nosuid,nodev,noatime,nodiratime,barrier=1 /dev/block/loop7 /pds
#fi

## adbd start

rm -f /sbin/adbd
ps | grep -v grep | grep adbd
ret=$?

if [ ! $ret -eq 0 ]; then
  chmod 755 /system/bootmenu/script/adbd.sh
  /system/bootmenu/script/adbd.sh
fi


#############################
## mount in /sbin/postrecoveryboot.sh
umount /system
umount /data
umount /cache
#############################

# turn on button backlight (back button is used in CWM Recovery 3.x)
echo 1 > /sys/class/leds/button-backlight/brightness

/sbin/recovery

sync

exit