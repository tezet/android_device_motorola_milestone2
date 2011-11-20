#!/sbin/sh

# fast button warning
echo 1 > /sys/class/leds/button-backlight/brightness
usleep 50000
echo 0 > /sys/class/leds/button-backlight/brightness
usleep 50000
echo 1 > /sys/class/leds/button-backlight/brightness
usleep 50000
echo 0 > /sys/class/leds/button-backlight/brightness

mount -t ext3 -o nosuid,nodev,noatime,nodiratime,barrier=1 /dev/block/mmcblk1p24 /cache
mount -t ext3 -o nosuid,nodev,noatime,nodiratime,barrier=1 /dev/block/mmcblk1p21 /system

rm -f /cache/recovery/bootmode.conf
touch /cache/recovery/bootmode.conf
echo "bootmenu" > /cache/recovery/bootmode.conf;
ln -s /system/bin/bootmenu /sbin/bootmenu

sync

/sbin/bootmenu

exit
