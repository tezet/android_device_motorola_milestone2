#!/sbin/sh

######## BootMenu Script
######## Execute [Stable Recovery] Menu


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

if [ ! -f /sbin/recovery_stable ]; then
    ln -s /sbin/recovery /sbin/recovery_stable
fi

# for ext3 format
cp /system/etc/mke2fs.conf /etc/

mkdir -p /cache/recovery
touch /cache/recovery/command
touch /cache/recovery/log
touch /cache/recovery/last_log
touch /tmp/recovery.log

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
umount -l /system
umount -l /data
umount -l /cache
#############################

# turn on button backlight (back button is used in CWM Recovery 3.x)
echo 1 > /sys/class/leds/button-backlight/brightness

/sbin/recovery_stable

exit
