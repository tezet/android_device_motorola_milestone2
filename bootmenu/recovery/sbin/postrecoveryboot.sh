#!/sbin/sh

PART_DATA=/dev/block/mmcblk1p26
PART_SYSTEM=/dev/block/mmcblk1p21

sleep 5

for i in $(seq 1 10)
do
    TMP=$(mount | grep /tmp)
    if [ -z "$TMP" ]
    then
        break
    fi
    umount -l /tmp
    sleep 1
done

mount -o remount,rw rootfs /
rm -r /tmp
mkdir -p tmp
touch /tmp/recovery.log
rm sdcard
mkdir sdcard



mount -t ext3 -o rw,noatime,nodiratime $PART_SYSTEM /system

# retry without type & options if not mounted
[ ! -f /system/build.prop ] && mount -o rw $PART_SYSTEM /system

# set red led if problem with system
echo 0 > /sys/class/leds/red/brightness
echo 0 > /sys/class/leds/green/brightness
echo 0 > /sys/class/leds/blue/brightness
[ ! -f /system/build.prop ] && echo 1 > /sys/class/leds/red/brightness

#############################

# turn on button backlight (back button is used in CWM Recovery 3.x)
echo 1 > /sys/class/leds/button-backlight/brightness

sync
