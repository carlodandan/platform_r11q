#!/bin/bash

sudo apt-get install bison flex rsync device-tree-compiler bc cpio lz4 -y

git clone --depth=1 https://github.com/carlodandan/aosp-clang-prebuilt -b clang-r416183b ./kernel_platform/prebuilts-master/clang/host/linux-x86/clang-r416183b
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/build-tools -b master-kernel-build-2021 ./kernel_platform/prebuilts/build-tools
git clone --depth=1 https://android.googlesource.com/kernel/prebuilts/build-tools -b master-kernel-build-2021 ./kernel_platform/prebuilts/kernel-build-tools
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gas/linux-x86 -b master-kernel-build-2021 ./kernel_platform/prebuilts/gas/linux-x86
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8 -b master-kernel-build-2021 ./kernel_platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8

#1. target config
BUILD_TARGET=r11q_chn_hkx
export MODEL=$(echo ${BUILD_TARGET} | cut -d'_' -f1)
export PROJECT_NAME=${MODEL}
export REGION=$(echo ${BUILD_TARGET} | cut -d'_' -f2)
export CARRIER=$(echo ${BUILD_TARGET} | cut -d'_' -f3)
export TARGET_BUILD_VARIANT= user
                        
#2. Chipset common config
CHIPSET_NAME=waipio
export ANDROID_BUILD_TOP=$(pwd)
export TARGET_PRODUCT=gki
export TARGET_BOARD_PLATFORM=gki

mkdir -p out/target/product/${MODEL}

export ANDROID_PRODUCT_OUT=${ANDROID_BUILD_TOP}/out/target/product/${MODEL}
export OUT_DIR=${ANDROID_BUILD_TOP}/out/msm-${CHIPSET_NAME}-${TARGET_PRODUCT}

# for Lcd(techpack) driver build
export KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/vendor/qcom/opensource/mmrm-driver/Module.symvers

# for Audio(techpack) driver build
export MODNAME=audio_dlkm

export KBUILD_EXT_MODULES="../vendor/qcom/opensource/datarmnet-ext/wlan                           ../vendor/qcom/opensource/datarmnet/core                           ../vendor/qcom/opensource/mmrm-driver                           ../vendor/qcom/opensource/audio-kernel                           ../vendor/qcom/opensource/camera-kernel                           ../vendor/qcom/opensource/display-drivers/msm                         "

#3. build kernel
RECOMPILE_KERNEL=1 ./kernel_platform/build/android/prepare_vendor.sh sec ${TARGET_PRODUCT}

