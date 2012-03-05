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

$(call inherit-product, device/motorola/milestone2/full_milestone2.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/gsm.mk)

PRODUCT_NAME := cm_milestone2
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := milestone2
PRODUCT_MODEL := MotoA953
PRODUCT_MANUFACTURER := motorola
PRODUCT_SBF := 4.1-22
PRODUCT_SFX := MILS2_U6

# Release name and versioning
PRODUCT_RELEASE_NAME := Milestone2

UTC_DATE := $(shell date +%s)
DATE     := $(shell date +%Y%m%d)

PRODUCT_BUILD_PROP_OVERRIDES := \
PRODUCT_NAME=${PRODUCT_MODEL}_${PRODUCT_SFX} \
TARGET_DEVICE=milestone2 \
BUILD_FINGERPRINT=motorola/RTGB/umts_milestone2:2.3.4/MILS2_U6_4.1-22/1317097892:user/release-keys \
PRODUCT_BRAND=MOTO \
PRIVATE_BUILD_DESC="umts_milestone2-user 2.3.4 MILS2_U6_4.1-22 1317097892 release-keys" \
BUILD_NUMBER=${DATE} \
BUILD_VERSION_TAGS=release-keys \
TARGET_BUILD_TYPE=user \
USER=kxcr46


