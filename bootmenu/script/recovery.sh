#!/sbin/sh

######## BootMenu Script
######## Execute [Latest Recovery] Menu


export PATH=/sbin:/system/xbin:/system/bin

######## Main Script

PART_DATA=/dev/block/mmcblk1p26
PART_SYSTEM=/dev/block/mmcblk1p21

## /tmp folder can be a link to /data/tmp, bad thing !
[ -L /tmp ] && rm /tmp
mkdir -p /tmp
mkdir -p /res

rm -f /etc
mkdir /etc

# hijack mke2fs & tune2fs CWM3
rm -f /sbin/mke2fs
rm -f /sbin/tune2fs
rm -f /sbin/e2fsck

rm -f /sdcard
mkdir /sdcard

chmod 755 /sbin
chmod 755 /res

cp -r -f /system/bootmenu/recovery/res/* /res/
cp -p -f /system/bootmenu/recovery/sbin/* /sbin/
cp -p -f /system/bootmenu/script/recoveryexit.sh /sbin/

if [ ! -f /sbin/recovery ]; then
    ln -s /sbin/recovery_stable /sbin/recovery
fi

chmod +rx /sbin/*

# rm -f /sbin/postrecoveryboot.sh

if [ ! -e /etc/recovery.fstab ]; then
    cp /system/bootmenu/recovery/recovery.fstab /etc/recovery.fstab
fi

# for ext3 format
cp /system/etc/mke2fs.conf /etc/

mkdir -p /cache/recovery
touch /cache/recovery/command
touch /cache/recovery/log
touch /cache/recovery/last_log
touch /tmp/recovery.log

killall adbd

# load overclock settings to reduce heat and battery use
/system/bootmenu/script/overclock.sh


ps | grep -v grep | grep adbd
ret=$?

if [ ! $ret -eq 0 ]; then
   # chmod 755 /system/bootmenu/script/adbd.sh
   # /system/bootmenu/script/adbd.sh

   # don't use adbd here, will load many android process which locks /system
   killall adbd
   killall adbd.root
fi

#############################
## mount in /sbin/postrecoveryboot.sh
umount -l /system
umount -l /data
umount -l /cache
#############################

# turn on button backlight (back button is used in CWM Recovery 3.x)
echo 1 > /sys/class/leds/button-backlight/brightness

/sbin/recovery &

exit