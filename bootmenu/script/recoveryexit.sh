#!/system/bin/sh

# fast button warning
echo 1 > /sys/class/leds/red/brightness
usleep 50000
echo 0 > /sys/class/leds/red/brightness
usleep 50000
echo 1 > /sys/class/leds/red/brightness
usleep 50000
echo 0 > /sys/class/leds/red/brightness


rm -f /cache/recovery/bootmode.conf
touch /cache/recovery/bootmode.conf
echo "bootmenu" > /cache/recovery/bootmode.conf;

killall recovery
killall recovery_stable

/system/bin/bootmenu &

exit
