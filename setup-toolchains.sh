echo "create toolchains directory"
if [ -n "$1" ]; then
	echo "creating $PWD/$1/toolchains"
	mkdir "$PWD"/"$1"/toolchains -p
	cd $1/toolchains
	export TC=$PWD/$1
	sleep 5
else
	echo "no directory specified"
	echo "creating directory at $HOME"
	mkdir $HOME/toolchains
	cd $HOME/toolchains
	export TC=$HOME
fi

echo "clone aarch64 and arm gcc"
git clone https://gitlab.com/UBERTC/arm-eabi-7.0 --depth=1
git clone https://gitlab.com/UBERTC/aarch64-linux-android-7.0-kernel --depth=1 aarch64-linux-android-7.0
echo "clone AOSP clang"
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --depth=1 aosp-clang
echo "add toolchains to $PATH"
export PATH=$PATH:$TC/toolchains/arm-eabi-7.0/bin:$TC/toolchains/aarch64-linux-android-7.0/bin:$TC/toolchains/aosp-clang/clang-r437112b/bin
echo "WARNING you might need to adjust version of clang that you want to use. the repository includes several versions that are stored in separate directories"
echo "currently version clang-r437112b is used"
echo " "
echo "checking if the compilers work"
arm-eabi-gcc -v
aarch64-linux-android-gcc -v
echo "NOTE temporarily removing every other entry besides gcc and clang toolchains from PATH"
export PATHBAK=$PATH
export PATH=$TC/toolchains/arm-eabi-7.0/bin:$TC/toolchains/aarch64-linux-android-7.0/bin:$TC/toolchains/aosp-clang/clang-r437112b/bin
clang -v
echo "restoring original PATH entries"
export PATHCC=$PATH
export PATH=$PATHBAK
echo "if you want to remove all the entries again use export PATH=\$PATHCC and to restore it use PATH=\$PATHBAK. i recommend running build.sh if you have another clang version in your PATH since it handles that by itself"
echo "adding PATHCC and PATHBAK to .bashrc"
cat << EOF >> $HOME/.bashrc
export PATCC=$HOME/toolchains/arm-eabi-7.0/bin:$HOME/toolchains/aarch64-linux-android-7.0/bin:$HOME/toolchains/aosp-clang/clang-r437112b/bin
export PATHBAK=$PATH
EOF

echo "setup complete"

