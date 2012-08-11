#
# Copyright (C) 2011 The Android Open-Source Project
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
#

TARGET_BOOTANIMATION_NAME := vertical-480x854

$(call inherit-product-if-exists, vendor/cm/config/common_full_phone.mk)
$(call inherit-product-if-exists, vendor/cm/config/gsm.mk)
$(call inherit-product, device/moto/milestone2/full_milestone2.mk)

DEVICE_PACKAGE_OVERLAYS += device/moto/milestone2/overlay

PRODUCT_NAME := cm_milestone2
PRODUCT_BRAND := MOTO
PRODUCT_DEVICE := milestone2
PRODUCT_MODEL := A953
PRODUCT_MANUFACTURER := Motorola
PRODUCT_SFX := DFP

# Release name and versioning
PRODUCT_RELEASE_NAME := Milestone2

UTC_DATE := $(shell date +%s)
DATE     := $(shell date +%Y%m%d)

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=${PRODUCT_MODEL}_${PRODUCT_SFX} \
    TARGET_DEVICE=milestone2 \
    BUILD_FINGERPRINT=MOTO/A953_O2DE/milestone2:2.3.6/4.5.1-134_DFP-132/1317968148:user/release-keys \
    PRIVATE_BUILD_DESC="milestone2_emara-user 2.3.6 4.5.1-134_DFP-132 1317968148 release-keys" \
    BUILD_NUMBER=${DATE} \
    BUILD_VERSION_TAGS=release-keys \
    TARGET_BUILD_TYPE=user
