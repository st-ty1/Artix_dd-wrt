# Artix_dd-wrt

HowTo: Build dd-wrt (arm/mipsel) on Artix host system 
(test with state of dd-wrt repo: commit e3a6d6c3032d; 06/03/21)

WARNING: Don't start, if you are not familiar with both - Arch Linux/Artix and the standard building process of dd-wrt!!

1. The packages needed for the building process of dd-wrt on Artix are listed in "needed_packages_on_Artix.txt".

2. Also some of the files of dd-wrt-repo need some small minor modifications. These mods are included in separate patches located in this repo.
   These modifications are needed as, e.g.:
   - Arch Linux/Artix use more recent versions of applications which are needed for building process. (acuatlly challenging: update to autoconf-2.70)
   - Arch Linux/Artix based systems depends much more on shared libraries than Debian/Ubuntu systems does, so building tools
     like libtool and pkgconfig are more likely misdirected by presence of shared libs of host-OS and will fail.

3. Best practice: (detailed description for VM or wsl2 in separate files)
   - Copy or clone this repo into a first subfolder of your home directory. 
   - Download dd-wrt toolchains from https://download1.dd-wrt.com/dd-wrtv2/downloads/toolchains/toolchains.tar.xz and install it into a second subfolder of your home directory.
   - Download source code of daq-2.0.6 from https://www.snort.org/downloads/archive/snort/daq-2.0.6.tar.gz and install it into a third subfolder of your home directory
   - Make one of the two shell scripts (build_dd-wrt_arm.sh/build_dd-wrt_mipsel.sh) executable you need for your router model (depending on architecture of CPU of router) .
   - Please have a look into the shell script, as the path to your local dd-wrt repo is defined in DDWRT_REPO_DIR and the path to your local copy/repo of Artix_dd-wrt is defined in DDWRT_PATCHES_DIR. You should change them to your own needs.
   - Start the shell script (build_dd-wrt_arm.sh/build_dd-wrt_mipsel.sh). 

(Still have some trouble with "trx_asus" in Makefile: The "trx-asus"-file in dd-wrt-repo doesn't work as expected yet, so you have to use appropriate austrx files of Freshtomato- or auswrt-Merlin(John's fork)-repos, located in their ctools folder. 
Too, tools/bufenc/makefw.sh for buffalo routers and tools/ubnt/src/mkfwimage for UBIQUITI? routers don't exist, so really last step in building their firmware cannot be finished.)

BR

st-ty1/\_st_ty/st_ty_
