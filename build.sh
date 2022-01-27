echo "A script to build with clang"
echo "based on example from here https://github.com/nathanchance/android-kernel-clang#how-to-compile-the-kernel-with-clang-standalone"
sleep 1

help() {
	echo "possible options"
	echo ""
	echo "-h                 this help menu"
	echo "-c                 clean the source tree"
	echo "-d [defconfig]     create config from specified defconfig and start compiling"
	echo "-m                 create config using menuconfig and start compiling"
}

cl() {
	echo "cleaning up"
        make clean -j$(nproc --all) && make mrproper -j$(nproc --all) && make clean O=out -j$(nproc --all) && make mrproper O=out -j$(nproc --all)
}

dcon() {
	if [ -n "$1" ]; then
		echo "creating .config"
		PATH="${PATHCC}:${PATHBAK}" \
		make O=out $1 -j$(nproc --all) \
			ARCH=arm64 \
			CC=clang \
			CLANG_TRIPLE=aarch64-linux-gnu- \
			CROSS_COMPILE=aarch64-linux-android- \
			CROSS_COMPILE_ARM32=arm-eabi-
	else
		echo "\e[0;91myou need to enter the name of the defconfig as the first argument!\e[0m"
		dcf=true
	fi
}

mcon() {
	echo "running make menuconfig"
	PATH="${PATHCC}:${PATHBAK}" \
	make O=out menuconfig -j$(nproc --all) \
		ARCH=arm64 \
		CC=clang \
		CLANG_TRIPLE=aarch64-linux-gnu- \
		CROSS_COMPILE=aarch64-linux-android- \
		CROSS_COMPILE_ARM32=arm-eabi-
}

build() {
	if [ -z dcf ]; then
		echo "starting compilation"
		echo "good luck"
		PATH="${PATHCC}:${PATHBAK}" \
		make O=out -j$(nproc --all) \
			ARCH=arm64 \
			CC=clang \
			CLANG_TRIPLE=aarch64-limux-gnu- \
			CROSS_COMPILE=aarch64-linux-android- \
			CROSS_COMPILE_ARM32=arm-eabi-
	fi
}

while getopts "hcd:m" option; do
	case $option in
		h) # help menu
			help
			exit;;
		c) # clean source tree
			cl
			exit;;
		d) # run make defconfig
			export DCON=true;;
		m) # run menuconfig
			export MCON=true;;
		\?) # invalid option
			help
			echo "\e[0;91minvalid option!\e[0m"
			exit;;
	esac
done

if [ "$DCON" = true ]; then
	dcon "$@"
fi

if [ "$MCON" = true ]; then
	mcon
fi

build
