PRODUCT_BRAND ?= UltraAOST

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# init.d support
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilts/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/aost/prebuilts/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilts/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# Copy all specific init rc files
#$(foreach f,$(wildcard vendor/aost/prebuilts/common/etc/init/*.rc),\
#	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Extra tools
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank
endif

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


PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0

# Set AOST_BUILDTYPE from the env RELEASE_TYPE

ifndef AOST_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "AOST_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^AOST_||g')
        AOST_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(AOST_BUILDTYPE)),)
    AOST_BUILDTYPE :=
endif

ifdef AOST_BUILDTYPE
    ifneq ($(AOST_BUILDTYPE), SNAPSHOT)
        ifdef AOST_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            AOST_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from AOST_EXTRAVERSION
            AOST_EXTRAVERSION := $(shell echo $(AOST_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to AOST_EXTRAVERSION
            AOST_EXTRAVERSION := -$(AOST_EXTRAVERSION)
        endif
    else
        ifndef AOST_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            AOST_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from AOST_EXTRAVERSION
            AOST_EXTRAVERSION := $(shell echo $(AOST_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to AOST_EXTRAVERSION
            AOST_EXTRAVERSION := -$(AOST_EXTRAVERSION)
        endif
    endif
else
    # If AOST_BUILDTYPE is not defined, set to UNOFFICIAL
    AOST_BUILDTYPE := UNOFFICIAL
    AOST_EXTRAVERSION :=
endif

ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        AOST_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(AOST_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(AOST_BUILDTYPE)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(AOST_VERSION_MAINTENANCE),0)
                AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(AOST_BUILDTYPE)
            else
                AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(AOST_BUILDTYPE)
            endif
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(AOST_BUILDTYPE)
        endif
    endif
else
    ifeq ($(AOST_VERSION_MAINTENANCE),0)
        ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(AOST_BUILDTYPE)
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(AOST_BUILDTYPE)-$(AOST_BUILDTYPE)
        endif
    else
        ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(AOST_BUILDTYPE)
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(AOST_BUILDTYPE)
        endif
    endif
endif

$(call prepend-product-if-exists, vendor/extra/product.mk)
