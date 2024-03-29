# Artix_dd-wrt

#### WARNING:

-  Don't start, if you are not familiar with both - Arch Linux/Artix and the standard building process of dd-wrt!!
  
-  Don't build on a full-featured Artix host OS (i.e. omit any desktop environment), otherwise you will face additional break errors you have to solve! Use bare Artix instead: native, as a VM or with wsl2/windows. How-Tos are included in this repo.

#### How to build dd-wrt (for routers with Broadcom arm-/Broadcom mips-cpu) on Artix host-OS:

1. The packages needed for the building process of dd-wrt on Artix are listed in "needed_packages_on_Artix.txt".

2. Also some of the files of dd-wrt-repo need some small minor modifications. These mods are included in separate patches located in this repo.
   These modifications are needed as, e.g.:
   - Arch Linux/Artix use more recent versions of applications which are needed for building process.
   - Arch Linux/Artix based systems depends much more on shared libraries than Debian/Ubuntu systems does, so building tools on host
     like libtool and pkgconfig are more likely misdirected by presence of shared libs of host-OS and will fail.

3. Best practice:
   - Copy or clone this repo into a first subfolder of your home directory. 
   - Download dd-wrt toolchains from https://download1.dd-wrt.com/dd-wrtv2/downloads/toolchains/toolchains.tar.xz, move it to a second subfolder $HOME/dd-wrt_toolchains. Look at the content of this big archive (8GB) by:
     
     `   tar tvfJ toolchains.tar.xz > toolchains_list.txt`

     and extraxt only the toolchain you need by:

       `tar xvf toolchains.tar.xz <folder of needed toolchain> `

   - Download source code of daq-2.0.7 from https://www.snort.org/downloads/archive/snort/daq-2.0.7.tar.gz and install it into a third subfolder of your home directory
   - Please look at the shell scripts, as the path to your local dd-wrt repo is defined in DDWRT_REPO_DIR and the path to your local copy/repo of Artix_dd-wrt is defined in DDWRT_PATCHES_DIR. You should change them to your own needs.
   - Start the shell script (build_dd-wrt_arm.sh or build_dd-wrt_mipsel.sh depending on your router cpu). 

("trx_asus" binary in dd-wrt-repo doesn't work as expected yet, so you have to use appropriate austrx files of Freshtomato- or auswrt-Merlin(John's fork)-repos, located in the ctools folder there. 
Too, tools/bufenc/makefw.sh for buffalo routers and tools/ubnt/src/mkfwimage for UBIQUITI? routers don't exist, so really the last step in building their firmware cannot be done.)

BR

st-ty1/\_st_ty/st_ty_
