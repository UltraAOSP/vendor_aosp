# Copyright (C) 2017 The Pure Nexus Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

AOST_Version := 1.0

# Prebuilt Packages
PRODUCT_PACKAGES += \
    SoundPickerPrebuilt \
    TimeZo \
    MarkupGoogle

# Bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
     PRODUCT_COPY_FILES += vendor/aost/prebuilts/media/bootanimation_720.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
     PRODUCT_COPY_FILES += vendor/aost/prebuilts/media/bootanimation_1080.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
     PRODUCT_COPY_FILES += vendor/aost/prebuilts/media/bootanimation_1440.zip:system/media/bootanimation.zip
else
    $(error " TARGET_BOOT_ANIMATION_RES is undefined")
endif

# Fonts
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilts/fonts/GoogleSans-Regular.ttf:system/fonts/GoogleSans-Regular.ttf \
    vendor/aost/prebuilts/fonts/GoogleSans-Medium.ttf:system/fonts/GoogleSans-Medium.ttf \
    vendor/aost/prebuilts/fonts/GoogleSans-MediumItalic.ttf:system/fonts/GoogleSans-MediumItalic.ttf \
    vendor/aost/prebuilts/fonts/GoogleSans-Italic.ttf:system/fonts/GoogleSans-Italic.ttf \
    vendor/aost/prebuilts/fonts/GoogleSans-Bold.ttf:system/fonts/GoogleSans-Bold.ttf \
    vendor/aost/prebuilts/fonts/GoogleSans-BoldItalic.ttf:system/fonts/GoogleSans-BoldItalic.ttf

# Markup libs
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilts/lib/libsketchology_native.so:system/lib/libsketchology_native.so \
    vendor/aost/prebuilts/lib64/libsketchology_native.so:system/lib64/libsketchology_native.so

# Include package overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/aost/overlay/common/
