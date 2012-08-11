#!/sbin/busybox ash

######## BootMenu Script
######## Execute [2nd-boot] Menu

source /system/bootmenu/script/_config.sh

######## Main Script

toolbox mount -o remount,rw rootfs /
rm -f /*.rc
rm -f /*.sh
rm -f /osh
rm -rf /preinstall
cp -f /system/bootmenu/2nd-boot/* /
chmod 640 /*.rc
chmod 750 /init
rm -f /sbin/ueventd
ln -s /init /sbin/ueventd
cp -f /system/bootmenu/binary/adbd /sbin/adbd
killall ueventd

ADBD_RUNNING=`ps | grep adbd | grep -v grep`
if [ -z "$ADB_RUNNING" ]; then
    rm -f /tmp/usbd_current_state
fi

# original /tmp data symlink
if [ -L /tmp.bak ]; then
    rm /tmp.bak
fi

if [ -L /sdcard-ext ]; then
    rm /sdcard-ext
    mkdir -p /sd-ext
fi

busybox mkdir -p /storage
ln -s /mnt/sdcard /storage/sdcard0

## unmount devices
sync
umount /acct
umount /dev/cpuctl
umount /dev/pts
umount /mnt/asec
umount /mnt/obb
umount /cache
umount /data

## adbd shell
ln -s /system/xbin/bash /sbin/sh

######## Cleanup

rm -f /sbin/lsof

## busybox cleanup..
if [ -f /sbin/busybox ]; then
    for cmd in $(/sbin/busybox --list); do
        [ -L "/sbin/$cmd" ] && rm "/sbin/$cmd"
    done

    rm -f /sbin/busybox
fi

## reduce lcd backlight to save battery
echo 18 > /sys/class/leds/lcd-backlight/brightness

######## Let's go

/system/bootmenu/binary/2nd-boot

