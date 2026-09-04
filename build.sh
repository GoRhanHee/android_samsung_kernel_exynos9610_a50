#!/bin/bash

# Setting toolchain
if [ ! -d "toolchain" ]; then
    # Download Cross Compiler
    git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9  \
     toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9

    # Download clang-4639204
    mkdir -p toolchain/clang/host/linux-x86/clang-4639204
    wget -O clang-4639204.gz \
     https://github.com/GoRhanHee/android_samsung_kernel_exynos9610_a50/releases/download/clang/clang-4639204.gz
    tar -xzf clang-4639204.gz \
     -C toolchain/clang/host/linux-x86/clang-4639204
    rm -rf clang-4639204.gz
fi

# Setting 
export ANDROID_BUILD_TOP=$(pwd)

# Setting toolchain path
CLANG_DIR=${ANDROID_BUILD_TOP}/toolchain/clang/host/linux-x86/clang-4639204
GCC_DIR=${ANDROID_BUILD_TOP}/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9
PATH=$CLANG_DIR/bin:$CLANG_DIR/lib:$GCC_DIR/bin:$GCC_DIR/lib:$PATH

# OEM Setting
export ARCH=arm64
export ANDROID_MAJOR_VERSION=r
export PLATFORM_VERSION=11

# Cooking Kernel Source
mkdir out

MAKE_ARGS="
ARCH=arm64 \
CC=${CLANG_DIR}/bin/clang \
CLANG_TRIPLE=${CLANG_DIR}/bin/aarch64-linux-gnu- \
CROSS_COMPILE=${GCC_DIR}/bin/aarch64-linux-android- \
O=out
"

make ${MAKE_ARGS} exynos9610-a50ks_defconfig || exit 1
make ${MAKE_ARGS} -j16 || exit 1
