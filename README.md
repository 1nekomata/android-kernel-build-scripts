# **A collection of scripts to compile android kernels with clang (WIP)**

# build.sh
Needs to be put inside the kernel source tree. Only works properly after `setup-toolchains.sh hs been ran and the` ``<device>_`defconfig`` has bee changed to the name of the defconfig of your device

# setup-toolchains.sh

Downloads prenuilt UBERTC arm and arm64 gcc 7.0 and AOSP clang toolchains and sets environment variables that work with `build.sh`. PATHCC points towards the toolchains and PATHBAK is a backup of the PATH variable.
