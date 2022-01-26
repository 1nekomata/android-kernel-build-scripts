# **A collection of scripts to compile Android Kernels with clang**

# build.sh

Used as a sorts of Wrapper to compile a kernel with clang.
Needs to be put inside the Kernel source tree. 
Only works properly after `setup-toolchains.sh` has been ran

# setup-toolchains.sh

Downloads prebuilt UBERTC arm and arm64 gcc 7.0 and AOSP clang toolchains
and sets environment variables that work with `build.sh`.
PATHCC points towards the toolchains and PATHBAK is a backup of the PATH variable.
