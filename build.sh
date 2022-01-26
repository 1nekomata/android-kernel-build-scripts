echo "A script to build with clang"
echo "based on example from here https://github.com/nathanchance/android-kernel-clang#how-to-compile-the-kernel-with-clang-standalone"
sleep 2

if [ -n "$1" ]; then
        echo "cleaning up"
        make clean -j$(nproc --all) && make mrproper -j$(nproc --all) && make O=out clean -j$(nproc --all) && make O=out mrproper -j$(nproc --all)
        echo "creating .config"
        PATH="${PATHCC}:${PATHBAK}" \
                make O=out $1 -j$(nproc --all) \
                ARCH=arm64 \
                CC=clang \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                CROSS_COMPILE=aarch64-linux-android- \
                CROSS_COMPILE_ARM32=arm-eabi-

        echo "starting compilation"
        echo "good luck"
        PATH="${PATHCC}:${PATHBAK}" \
                make O=out -j$(nproc --all) \
                ARCH=arm64 \
                CC=clang \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                CROSS_COMPILE=aarch64-linux-android- \
                CROSS_COMPILE_ARM32=arm-eabi-
else
        echo "\e[0;91mYou didnt specify a device_defconfig as first argument!\e[0m"
fi
