#!/bin/bash

echo "check if dependencies are met"
if [ ID=arch = "$(cat /etc/os-release | grep ID=)" || ID=manjaro = "$(cat /etc/os-release | grep ID=)" || ID=artix = "$(cat /etc/os-release | grep ID=)" ]; then {
	sudo pacman -Syu base base-devel ncurses git fakeroot xz openssl bc flex libelf bison
} else if [ ID=ubuntu "$(cat /etc/os-release | grep ID=)" || ID=debian "$(cat /etc/os-release | grep ID=)" || ID_LIKE=debian "$(cat /etc/os-release | grep ID=)" ]; then {
	sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison
} else {
	echo "unable to check for dependencies because the os isnt known"
	echo "you can manually check for following or similar packages: git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison"
}
echo "create toolchains directory"
if [ -n "$1" ]; then
	echo "creating $HOME/$1/toolchains"
	mkdir "$HOME"/"$1"/toolchains -p
	cd "$1"/toolchains || echo "\e[0;91mcd failed! exiting...\e[0m" && exit
	export TC="$HOME"/"$1"
else
	echo "no directory specified"
	echo "creating directory at $HOME"
	mkdir "$HOME"/toolchains
	cd "$HOME"/toolchains || echo "\e[0;91mcd failed! exiting...\e[0m" && exit
	export TC="$HOME"
fi

echo "clone mkbootimg tools"
git clone https://android.googlesource.com/platform/system/tools/mkbootimg --depth=1 bit

echo "clone aarch64 and arm gcc"
git clone https://gitlab.com/UBERTC/arm-eabi-7.0 --depth=1
git clone https://gitlab.com/UBERTC/aarch64-linux-android-7.0-kernel --depth=1 aarch64-linux-android-7.0

echo "clone AOSP clang"
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --depth=1 aosp-clang

echo "add tools to $PATH"
export PATH="$PATH":"$TC"/toolchains/arm-eabi-7.0/bin:"$TC"/toolchains/aarch64-linux-android-7.0/bin:"$TC"/toolchains/aosp-clang/clang-r437112b/bin:"$TC"/toolchains/bit

echo "WARNING you might need to adjust version of clang that you want to use. the repository includes several versions that are stored in separate directories"
echo ""
echo ""

echo "currently version clang-r437112b is used"
echo " "

echo "checking if the compilers work"
arm-eabi-gcc -v
aarch64-linux-android-gcc -v

echo "NOTE temporarily removing every other entry besides gcc and clang toolchains from PATH"
export PATHBAK="$PATH"
export PATH="$TC"/toolchains/arm-eabi-7.0/bin:"$TC"/toolchains/aarch64-linux-android-7.0/bin:"$TC"/toolchains/aosp-clang/clang-r437112b/bin
clang -v

echo "restoring original PATH entries"
export PATHCC="$PATH"
export PATH="$PATHBAK"

echo "if you want to remove all the entries again use export PATH=\$PATHCC and to restore it use PATH=\$PATHBAK. i recommend running build.sh if you have another clang version in your PATH since it handles that by itself"
echo ""
echo "adding PATHCC and PATHBAK to .bashrc"

cat << EOF >> "$HOME"/.bashrc
export PATHCC="$TC"/toolchains/arm-eabi-7.0/bin:"$TC"/toolchains/aarch64-linux-android-7.0/bin:"$TC"/toolchains/aosp-clang/clang-r437112b/bin:"$TC"/toolchains/bit
export PATHBAK="$PATH"
EOF

echo "setup complete"
