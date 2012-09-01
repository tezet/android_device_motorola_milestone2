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
	device/motorola/milestone2/prebuilt/usr/qwerty.kl:system/usr/keylayout/qwerty.kl \
	device/motorola/milestone2/prebuilt/usr/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
	device/motorola/milestone2/prebuilt/usr/umts_milestone2-keypad-azerty.kl:system/usr/keylayout/umts_milestone2-keypad-azerty.kl \
	device/motorola/milestone2/prebuilt/usr/umts_milestone2-keypad-qwerty.kl:system/usr/keylayout/umts_milestone2-keypad-qwerty.kl \
	device/motorola/milestone2/prebuilt/usr/umts_milestone2-keypad-qwertz.kl:system/usr/keylayout/umts_milestone2-keypad-qwertz.kl

#etc
PRODUCT_COPY_FILES += \
	device/motorola/milestone2/bootmenu/recovery/recovery.fstab:system/etc/recovery.fstab \
	device/motorola/milestone2/prebuilt/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
	device/motorola/milestone2/prebuilt/etc/init.d/02qwerty:system/etc/init.d/02qwerty \
	device/motorola/milestone2/prebuilt/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
	device/motorola/milestone2/prebuilt/etc/init.d/04mmcfix:system/etc/init.d/04mmcfix \
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
	device/motorola/milestone2/bootmenu/binary/lsof.static:system/bootmenu/binary/lsof \
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
	device/motorola/milestone2/bootmenu/script/2nd-init.sh:system/bootmenu/script/2nd-init.sh \
	device/motorola/milestone2/bootmenu/script/2nd-boot.sh:system/bootmenu/script/2nd-boot.sh \
	device/motorola/milestone2/bootmenu/script/adbd.sh:system/bootmenu/script/adbd.sh \
	device/motorola/milestone2/bootmenu/script/bootmode_clean.sh:system/bootmenu/script/bootmode_clean.sh \
	device/motorola/milestone2/bootmenu/script/cdrom.sh:system/bootmenu/script/cdrom.sh \
	device/motorola/milestone2/bootmenu/script/data.sh:system/bootmenu/script/data.sh \
	device/motorola/milestone2/bootmenu/script/overclock.sh:system/bootmenu/script/overclock.sh \
	device/motorola/milestone2/bootmenu/script/post_bootmenu.sh:system/bootmenu/script/post_bootmenu.sh \
	device/motorola/milestone2/bootmenu/script/pre_bootmenu.sh:system/bootmenu/script/pre_bootmenu.sh \
	device/motorola/milestone2/bootmenu/script/recovery.sh:system/bootmenu/script/recovery.sh \
	device/motorola/milestone2/bootmenu/script/recovery_stable.sh:system/bootmenu/script/recovery_stable.sh \
	device/motorola/milestone2/bootmenu/script/recoveryexit.sh:system/bootmenu/script/recoveryexit.sh \
	device/motorola/milestone2/bootmenu/script/sdcard.sh:system/bootmenu/script/sdcard.sh \
	device/motorola/milestone2/bootmenu/script/system.sh:system/bootmenu/script/system.sh \
	device/motorola/milestone2/bootmenu/modules/cpufreq_ondemand.ko:system/bootmenu/ext/modules/cpufreq_ondemand.ko \
	device/motorola/milestone2/bootmenu/modules/cpufreq_performance.ko:system/bootmenu/ext/modules/cpufreq_performance.ko \
	device/motorola/milestone2/bootmenu/modules/cpufreq_userspace.ko:system/bootmenu/ext/modules/cpufreq_userspace.ko \
	device/motorola/milestone2/bootmenu/modules/overclock_milestone2.ko:system/bootmenu/ext/modules/overclock_milestone2.ko \
	device/motorola/milestone2/modules/cpufreq_conservative.ko:system/bootmenu/ext/modules/cpufreq_conservative.ko \
	device/motorola/milestone2/modules/cpufreq_interactive.ko:system/bootmenu/ext/modules/cpufreq_interactive.ko \
	device/motorola/milestone2/modules/cpufreq_powersave.ko:system/bootmenu/ext/modules/cpufreq_powersave.ko \
	device/motorola/milestone2/modules/cpufreq_smartass.ko:system/bootmenu/ext/modules/cpufreq_smartass.ko \
	device/motorola/milestone2/modules/cpufreq_stats.ko:system/bootmenu/ext/modules/cpufreq_stats.ko \
	device/motorola/milestone2/modules/symsearch.ko:system/bootmenu/ext/modules/symsearch.ko
	
# Copy prebuilt apps
PRODUCT_COPY_FILES += \
	device/motorola/milestone2/prebuilt/app/OTAUpdater.apk:system/app/OTAUpdater.apk

