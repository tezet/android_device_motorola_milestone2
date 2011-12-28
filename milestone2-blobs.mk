# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


PRODUCT_COPY_FILES += \
	device/motorola/milestone2/prebuilt/usr/keylayout/umts_milestone2-keypad-qwerty.kl:system/usr/keylayout/qtouch-touchscreen.kl \
	device/motorola/milestone2/prebuilt/usr/keylayout/umts_milestone2-keypad-qwerty.kl:system/usr/keylayout/sholes-keypad.kl \
	device/motorola/milestone2/prebuilt/usr/keychars/umts_milestone2-keypad-qwerty.kcm:system/usr/keychars/sholes-keypad.kcm
		
# copy all idc files
PRODUCT_COPY_FILES += $(shell test -d device/motorola/milestone2/prebuilt/usr/idc/ &&  \
	find device/motorola/milestone2/prebuilt/usr/idc/ -name '*.idc' \
	-printf '%p:system/usr/idc/%f ')
	
# copy all keylayout files
PRODUCT_COPY_FILES += $(shell test -d device/motorola/milestone2/prebuilt/usr/keylayout/ &&  \
	find device/motorola/milestone2/prebuilt/usr/keylayout/ -name '*.kl' \
	-printf '%p:system/usr/keylayout/%f ')
	
# copy all keychars files
PRODUCT_COPY_FILES += $(shell test -d device/motorola/milestone2/prebuilt/usr/keychars/ &&  \
	find device/motorola/milestone2/prebuilt/usr/keychars/ -name '*.kcm' \
	-printf '%p:system/usr/keychars/%f ')

PRODUCT_COPY_FILES += \
	device/motorola/milestone2/prebuilt/bootanimation.zip:system/media/bootanimation.zip \
	device/motorola/milestone2/prebuilt/etc/terminfo/l/linux:system/etc/terminfo/l/linux \
	device/motorola/milestone2/prebuilt/etc/terminfo/x/xterm:system/etc/terminfo/x/xterm \

#temp disabled

	#device/motorola/milestone2/prebuilt/etc/init.d/04mmcfix:system/etc/init.d/04mmcfix \


#etc
PRODUCT_COPY_FILES += \
	device/motorola/milestone2/bootmenu/recovery/recovery.fstab:system/etc/recovery.fstab \
	device/motorola/milestone2/prebuilt/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
	device/motorola/milestone2/prebuilt/etc/init.d/02qwerty:system/etc/init.d/02qwerty \
	device/motorola/milestone2/prebuilt/etc/init.d/02ipv6:system/etc/init.d/02ipv6 \
	device/motorola/milestone2/prebuilt/etc/init.d/03adbd:system/etc/init.d/03adbd \
	device/motorola/milestone2/prebuilt/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
	device/motorola/milestone2/prebuilt/etc/init.d/07camera:system/etc/init.d/07camera \
	device/motorola/milestone2/prebuilt/etc/init.d/90multitouch:system/etc/init.d/90multitouch \
	device/motorola/milestone2/prebuilt/etc/profile:system/etc/profile \
	device/motorola/milestone2/prebuilt/etc/sysctl.conf:system/etc/sysctl.conf \
	device/motorola/milestone2/prebuilt/etc/busybox.fstab:system/etc/fstab \
	device/motorola/milestone2/prebuilt/etc/wifi/dnsmasq.conf:system/etc/wifi/dnsmasq.conf \
	device/motorola/milestone2/prebuilt/etc/wifi/tiwlan.ini:system/etc/wifi/tiwlan.ini \
	device/motorola/milestone2/prebuilt/etc/wifi/tiwlan_ap.ini:system/etc/wifi/tiwlan_ap.ini \
	device/motorola/milestone2/prebuilt/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
	device/motorola/milestone2/prebuilt/etc/gpsconfig.xml:system/etc/gpsconfig.xml \
	device/motorola/milestone2/prebuilt/etc/location.cfg:system/etc/location.cfg \
	device/motorola/milestone2/prebuilt/etc/Droid2Bootstrap.cfg:system/etc/Droid2Bootstrap.cfg \
	device/motorola/milestone2/prebuilt/etc/DroidXBootstrap.cfg:system/etc/DroidXBootstrap.cfg \
	device/motorola/milestone2/media_profiles.xml:system/etc/media_profiles.xml \
	device/motorola/milestone2/modules/modules.alias:system/lib/modules/modules.alias \
	device/motorola/milestone2/modules/modules.dep:system/lib/modules/modules.dep


ifdef CYANOGEN_RELEASE
	PRODUCT_COPY_FILES += device/motorola/milestone2/custom_backup_release.txt:system/etc/custom_backup_list.txt
else
	PRODUCT_COPY_FILES += device/motorola/milestone2/custom_backup_list.txt:system/etc/custom_backup_list.txt
endif

#Bootmenu
PRODUCT_COPY_FILES += \
	device/motorola/milestone2/profiles/standard/init.mapphone_umts.rc:system/bootmenu/2nd-init/init.mapphone_umts.rc \
	device/motorola/milestone2/profiles/standard/init.mapphone_umts.usb.rc:system/bootmenu/2nd-init/init.mapphone_umts.usb.rc \
	device/motorola/milestone2/profiles/standard/init.rc:system/bootmenu/2nd-init/init.rc \
	device/motorola/milestone2/profiles/standard/ueventd.rc:system/bootmenu/2nd-init/ueventd.rc \
	device/motorola/milestone2/profiles/backup/init.rc:system/bootmenu/2nd-boot/init.rc \
	device/motorola/milestone2/profiles/backup/init.mapphone_umts.rc:system/bootmenu/2nd-boot/init.mapphone_umts.rc \
	device/motorola/milestone2/profiles/backup/ueventd.rc:system/bootmenu/2nd-boot/ueventd.rc \
	device/motorola/milestone2/profiles/backup/init:system/bootmenu/2nd-boot/init \
	device/motorola/milestone2/profiles/backup/sbin/ueventd:system/bootmenu/2nd-boot/sbin/ueventd \
	device/motorola/milestone2/profiles/froyo/init.rc:system/bootmenu/froyo/init.rc \
	device/motorola/milestone2/profiles/froyo/init.mapphone_umts.rc:system/bootmenu/froyo/init.mapphone_umts.rc \
	device/motorola/milestone2/bootmenu/binary/adbd:system/bootmenu/binary/adbd \
	device/motorola/milestone2/bootmenu/binary/logwrapper.bin:system/bootmenu/binary/logwrapper.bin \
	device/motorola/milestone2/bootmenu/binary/logwrapper.bin:system/bin/logwrapper.bin \
	device/motorola/milestone2/bootmenu/binary/2nd-init:system/bootmenu/binary/2nd-init \
	device/motorola/milestone2/bootmenu/binary/2nd-boot:system/bootmenu/binary/2nd-boot \
	device/motorola/milestone2/bootmenu/binary/su:system/bootmenu/ext/su \
	device/motorola/milestone2/bootmenu/config/bootmenu_bypass:system/bootmenu/config/bootmenu_bypass \
	device/motorola/milestone2/bootmenu/config/default.prop:system/bootmenu/config/default.prop \
	device/motorola/milestone2/bootmenu/config/default_bootmode.conf:system/bootmenu/config/default_bootmode.conf \
	device/motorola/milestone2/bootmenu/config/overclock.conf:system/bootmenu/config/overclock.conf \
	device/motorola/milestone2/bootmenu/images/background.png:system/bootmenu/images/background.png \
	external/bootmenu/images/indeterminate1.png:system/bootmenu/images/indeterminate1.png \
	external/bootmenu/images/indeterminate2.png:system/bootmenu/images/indeterminate2.png \
	external/bootmenu/images/indeterminate3.png:system/bootmenu/images/indeterminate3.png \
	external/bootmenu/images/indeterminate4.png:system/bootmenu/images/indeterminate4.png \
	external/bootmenu/images/indeterminate5.png:system/bootmenu/images/indeterminate5.png \
	external/bootmenu/images/indeterminate6.png:system/bootmenu/images/indeterminate6.png \
	external/bootmenu/images/progress_empty.png:system/bootmenu/images/progress_empty.png \
	external/bootmenu/images/progress_fill.png:system/bootmenu/images/progress_fill.png \
	device/motorola/milestone2/bootmenu/recovery/res/keys:system/bootmenu/recovery/res/keys \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_error.png:system/bootmenu/recovery/res/images/icon_error.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_done.png:system/bootmenu/recovery/res/images/icon_done.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_installing.png:system/bootmenu/recovery/res/images/icon_installing.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_firmware_error.png:system/bootmenu/recovery/res/images/icon_firmware_error.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_firmware_install.png:system/bootmenu/recovery/res/images/icon_firmware_install.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate1.png:system/bootmenu/recovery/res/images/indeterminate1.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate2.png:system/bootmenu/recovery/res/images/indeterminate2.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate3.png:system/bootmenu/recovery/res/images/indeterminate3.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate4.png:system/bootmenu/recovery/res/images/indeterminate4.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate5.png:system/bootmenu/recovery/res/images/indeterminate5.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/indeterminate6.png:system/bootmenu/recovery/res/images/indeterminate6.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/progress_empty.png:system/bootmenu/recovery/res/images/progress_empty.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/progress_fill.png:system/bootmenu/recovery/res/images/progress_fill.png \
	device/motorola/milestone2/bootmenu/recovery/res/images/icon_clockwork.png:system/bootmenu/recovery/res/images/icon_clockwork.png \
	device/motorola/milestone2/bootmenu/recovery/sbin/badblocks:system/bootmenu/recovery/sbin/badblocks \
	device/motorola/milestone2/bootmenu/recovery/sbin/dedupe:system/bootmenu/recovery/sbin/dedupe \
	device/motorola/milestone2/bootmenu/recovery/sbin/dump_image:system/bootmenu/recovery/sbin/dump_image \
	device/motorola/milestone2/bootmenu/recovery/sbin/e2fsck:system/bootmenu/recovery/sbin/e2fsck \
	device/motorola/milestone2/bootmenu/recovery/sbin/fix_permissions:system/bootmenu/recovery/sbin/fix_permissions \
	device/motorola/milestone2/bootmenu/recovery/sbin/killrecovery.sh:system/bootmenu/recovery/sbin/killrecovery.sh \
	device/motorola/milestone2/bootmenu/recovery/sbin/nandroid-md5.sh:system/bootmenu/recovery/sbin/nandroid-md5.sh \
	device/motorola/milestone2/bootmenu/recovery/sbin/parted:system/bootmenu/recovery/sbin/parted \
	device/motorola/milestone2/bootmenu/recovery/sbin/postrecoveryboot.sh:system/bootmenu/recovery/sbin/postrecoveryboot.sh \
	device/motorola/milestone2/bootmenu/recovery/sbin/recovery:system/bootmenu/recovery/sbin/recovery_stable \
	device/motorola/milestone2/bootmenu/recovery/sbin/resize2fs:system/bootmenu/recovery/sbin/resize2fs \
	device/motorola/milestone2/bootmenu/recovery/sbin/sdparted:system/bootmenu/recovery/sbin/sdparted \
	device/motorola/milestone2/bootmenu/recovery/sbin/mke2fs:system/bootmenu/recovery/sbin/mke2fs \
	device/motorola/milestone2/bootmenu/recovery/sbin/mke2fs.bin:system/bootmenu/recovery/sbin/mke2fs.bin \
	device/motorola/milestone2/bootmenu/recovery/sbin/tune2fs.bin:system/bootmenu/recovery/sbin/tune2fs \
	device/motorola/milestone2/bootmenu/recovery/recovery.fstab:system/bootmenu/recovery/recovery.fstab \
	device/motorola/milestone2/bootmenu/script/_config.sh:system/bootmenu/script/_config.sh \
	device/motorola/milestone2/bootmenu/script/2nd-init.sh:system/bootmenu/script/2nd-init.sh \
	device/motorola/milestone2/bootmenu/script/2nd-boot.sh:system/bootmenu/script/2nd-boot.sh \
	device/motorola/milestone2/bootmenu/script/stock.sh:system/bootmenu/script/stock.sh \
	device/motorola/milestone2/bootmenu/script/adbd.sh:system/bootmenu/script/adbd.sh \
	device/motorola/milestone2/bootmenu/script/bootmode_clean.sh:system/bootmenu/script/bootmode_clean.sh \
	device/motorola/milestone2/bootmenu/script/cdrom.sh:system/bootmenu/script/cdrom.sh \
	device/motorola/milestone2/bootmenu/script/data.sh:system/bootmenu/script/data.sh \
	device/motorola/milestone2/bootmenu/script/overclock.sh:system/bootmenu/script/overclock.sh \
	device/motorola/milestone2/bootmenu/script/post_bootmenu.sh:system/bootmenu/script/post_bootmenu.sh \
	device/motorola/milestone2/bootmenu/script/pre_bootmenu.sh:system/bootmenu/script/pre_bootmenu.sh \
	device/motorola/milestone2/bootmenu/script/reboot_command.sh:system/bootmenu/script/reboot_command.sh \
	device/motorola/milestone2/bootmenu/script/recovery.sh:system/bootmenu/script/recovery.sh \
	device/motorola/milestone2/bootmenu/script/recovery_stable.sh:system/bootmenu/script/recovery_stable.sh \
	device/motorola/milestone2/bootmenu/script/recoveryexit.sh:system/bootmenu/script/recoveryexit.sh \
	device/motorola/milestone2/bootmenu/script/sdcard.sh:system/bootmenu/script/sdcard.sh \
	device/motorola/milestone2/bootmenu/script/system.sh:system/bootmenu/script/system.sh \
	device/motorola/milestone2/bootmenu/script/media_fixup.sh:system/bootmenu/script/media_fixup.sh \
