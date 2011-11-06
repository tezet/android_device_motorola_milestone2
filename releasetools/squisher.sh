# This script is included in squisher
# It is the final build step (after OTA package)

# Delete unwanted apps
#rm -f $REPACK/ota/system/app/RomManager.apk
rm -f $REPACK/ota/system/xbin/irssi

mkdir -p $REPACK/ota/system/etc/terminfo/x
cp $REPACK/ota/system/etc/terminfo/l/linux $REPACK/ota/system/etc/terminfo/x/xterm

# prebuilt boot, devtree, logo & updater-script
rm -f $REPACK/ota/boot.img
cp -f $ANDROID_BUILD_TOP/device/motorola/milestone2/updater-script $REPACK/ota/META-INF/com/google/android/updater-script
if [ -n "$CYANOGEN_RELEASE" ]; then
  cat $ANDROID_BUILD_TOP/device/motorola/milestone2/updater-script-rel >> $REPACK/ota/META-INF/com/google/android/updater-script
  cp -f $ANDROID_BUILD_TOP/vendor/motorola/milestone2/boot.smg $REPACK/ota/boot.img
  cp -f $ANDROID_BUILD_TOP/vendor/motorola/milestone2/devtree.smg $REPACK/ota/devtree.img
  cp -f $ANDROID_BUILD_TOP/vendor/motorola/milestone2/logo-moto.raw $REPACK/ota/logo.img
fi
cp -f $ANDROID_BUILD_TOP/out/target/product/milestone2/root/init $REPACK/ota/system/bootmenu/2nd-init/init
cp -f $ANDROID_BUILD_TOP/out/target/product/milestone2/root/init.rc $REPACK/ota/system/bootmenu/2nd-init/init.rc

