echo "create $HOME/toolchains directory"
mkdir $HOME/toolchains
cd $HOME/toolchains
echo "clone gcc aarch64 and arm64"
git clone https://gitlab.com/UBERTC/arm-eabi-7.0 --depth=1
git clone https://gitlab.com/UBERTC/aarch64-linux-android-7.0-kernel --depth=1 aarch64-linux-android-7.0
echo "clone aosp clang"
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --depth=1 clang-aosp
echo "add toolchains to $PATH"
export PATH=$PATH:$HOME/toolchains/arm-eabi-7.0/bin:$HOME/toolchains/aarch64-linux-android-7.0/bin:$HOME/toolchains/clang-aosp/clang-r437112b/bin
echo "WARNING you might need to adjust version of clang that you want to use as the clang repo includes several version at a time"
echo "currently version clang-r437112b is used"
echo " "
echo "checking if the compilers work"
arm-eabi-gcc -v
aarch64-linux-android-gcc -v
echo "NOTE temporarily moving away every other entry besides gcc and clang toolchains from PATH"
export PATHBAK=$PATH
export PATH=$HOME/toolchains/arm-eabi-7.0/bin:$HOME/toolchains/aarch64-linux-android-7.0/bin:$HOME/toolchains/clang-aosp/clang-r437112b/bin
clang -v
echo "restoring original PATH entries"
export PATHCC=$PATH
export PATH=$PATHBAK
echo "if you want to remove all the entries again use export PATH=$PATHCC and to restore it use PATH=$PATHBAK. it is recommended to do that while running make by adding PATH=$PATHCC to the make command or use build.sh script"
echo "adding PATHCC and PATHBAK to .bashrc"
cat << EOF >> ~/.bashrc
export PATCC=$HOME/toolchains/arm-eabi-7.0/bin:$HOME/toolchains/aarch64-linux-android-7.0/bin:$HOME/toolchains/clang-aosp/clang-r437112b/bin
export PATHBAK=$PATH
EOF
echo "setup complete"
