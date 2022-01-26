echo "A script to build with clang"
echo "based on example from here https://github.com/nathanchance/android-kernel-clang#how-to-compile-the-kernel-with-clang-standalone"
sleep 2

echo "cleaning up"
make clean -j$(nproc --all) && make mrproper -j$(nproc --all) && make O=out clean -j$(nproc --all) && make O=out mrproper -j$(nproc --all)

echo "creating .config"

echo "please EDIT THIS SCRIPT and replace <device>_defconfig with the name of your defconfig"
sleep 10 #you can remove this line after editing too

PATH="${PATHCC}:${PATHBAK}" \
make O=out <device>_defconfig -j$(nproc --all) \
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
