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

device_path = device/moto/milestone2

PRODUCT_COPY_FILES += \
	$(device_path)/etc/terminfo/l/linux:system/etc/terminfo/l/linux \
	$(device_path)/etc/terminfo/x/xterm:system/etc/terminfo/x/xterm \
	
# Key layouts, names must fit the ones in /proc/bus/input/devices, qwerty.kl is the fallback one.
PRODUCT_COPY_FILES += \
	$(device_path)/usr/keylayout/umts_milestone2-keypad-qwerty.kl:system/usr/keylayout/qtouch-touchscreen.kl \
	$(device_path)/usr/keylayout/umts_milestone2-keypad-qwerty.kl:system/usr/keylayout/sholes-keypad.kl \
	$(device_path)/usr/keychars/umts_milestone2-keypad-qwerty.kcm:system/usr/keychars/sholes-keypad.kcm
		
# copy all idc files
PRODUCT_COPY_FILES += $(shell test -d device/moto/milestone2/usr/idc/ &&  \
	find $(device_path)/usr/idc/ -name '*.idc' \
	-printf '%p:system/usr/idc/%f ')
	
# copy all keylayout files
PRODUCT_COPY_FILES += $(shell test -d device/moto/milestone2/usr/keylayout/ &&  \
	find $(device_path)/usr/keylayout/ -name '*.kl' \
	-printf '%p:system/usr/keylayout/%f ')
	
# copy all keychars files
PRODUCT_COPY_FILES += $(shell test -d device/moto/milestone2/usr/keychars/ &&  \
	find $(device_path)/usr/keychars/ -name '*.kcm' \
	-printf '%p:system/usr/keychars/%f ')

PRODUCT_COPY_FILES += \
	${device_path}/vold.fstab:system/etc/vold.fstab \
	${device_path}/media_profiles.xml:system/etc/media_profiles.xml \
	${device_path}/modules/modules.alias:system/lib/modules/modules.alias \
	${device_path}/modules/modules.dep:system/lib/modules/modules.dep \
	$(device_path)/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
	$(device_path)/etc/init.d/02qwerty:system/etc/init.d/02qwerty \
	$(device_path)/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
	$(device_path)/etc/init.d/04filesystems:system/etc/init.d/04filesystems \
	$(device_path)/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
	$(device_path)/etc/init.d/10gpiofix:system/etc/init.d/10gpiofix \
	$(device_path)/etc/init.d/90multitouch:system/etc/init.d/90multitouch \
	$(device_path)/etc/profile:system/etc/profile \
	$(device_path)/etc/sysctl.conf:system/etc/sysctl.conf \
	$(device_path)/etc/busybox.fstab:system/etc/fstab \
	$(device_path)/etc/wifi/dnsmasq.conf:system/etc/wifi/dnsmasq.conf \
	$(device_path)/etc/wifi/tiwlan.ini:system/etc/wifi/tiwlan.ini \
	$(device_path)/etc/wifi/tiwlan_ap.ini:system/etc/wifi/tiwlan_ap.ini \
	$(device_path)/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
	$(device_path)/etc/gpsconfig.xml:system/etc/gpsconfig.xml \
	$(device_path)/etc/location.cfg:system/etc/location.cfg \
	$(device_path)/etc/media_codecs.xml:system/etc/media_codecs.xml \
	$(device_path)/etc/audio_policy.conf:system/etc/audio_policy.conf \

# New CM9 backup list system (addon.d)
PRODUCT_COPY_FILES += \
	${device_path}/releasetools/addon.d/70-gapps.sh:system/addon.d/70-gapps.sh \

# Backup kernel modules and bootmenu overclock config
ifndef CM_RELEASE
PRODUCT_COPY_FILES += \
	${device_path}/releasetools/addon.d/70-bootmenu.sh:system/addon.d/70-bootmenu.sh \

endif

# Copy prebuilt apps
PRODUCT_COPY_FILES += \
	${device_path}/app/OTAUpdater.apk:system/app/OTAUpdater.apk

#end of milestone2-blobs.mk
