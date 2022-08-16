#! /bin/sh

DDWRT_TC=toolchain-mipsel_74kc_gcc-8.2.0_musl
DDWRT_PATCHES_DIR=$HOME/Artix_dd-wrt
DDWRT_REPO_DIR=$HOME/dd-wrt
export PATH=$HOME/dd-wrt_toolchains/$DDWRT_TC/bin:$PATH

cd $DDWRT_REPO_DIR
git clean -dxf && git reset --hard && git checkout master
#git pull

clear

rm -rf ../.cache/ccache

# directories with wrong position in sources
ln -nsf $DDWRT_REPO_DIR/opt $DDWRT_REPO_DIR/src/router/opt

cd $HOME/dd-wrt_toolchains/$DDWRT_TC/bin
ln -nsf mipsel-openwrt-linux-musl-as mipsel-linux-uclibc-as
ln -nsf mipsel-openwrt-linux-musl-gcc-ar mipsel-linux-uclibc-gcc-ar
ln -nsf mipsel-openwrt-linux-musl-gcc-nm mipsel-linux-uclibc-gcc-nm

cd $HOME/dd-wrt_toolchains/$DDWRT_TC
ln -snf lib lib64
ln -snf lib lib32
ln -snf mipsel-openwrt-linux-musl mipsel-openwrt-linux
cd $HOME/dd-wrt_toolchains/$DDWRT_TC/mipsel-openwrt-linux-musl
ln -snf ../include sys-include
ln -snf ../lib lib
mkdir $HOME/dd-wrt_toolchains/$DDWRT_TC/lib/bfd-plugins
ln -nsf $HOME/dd-wrt_toolchains/$DDWRT_TC/lib/gcc/mipsel-openwrt-linux-musl/*/liblto_plugin.so $HOME/dd-wrt_toolchains/$DDWRT_TC/lib/bfd-plugins/liblto_plugin.so
 
# build missing tools
gcc $DDWRT_REPO_DIR/opt/tools/trx.c -o $DDWRT_REPO_DIR/opt/tools/trx
gcc --std=gnu89 $DDWRT_PATCHES_DIR/trx_asus.c -o $DDWRT_REPO_DIR/src/router/tools/trx_asus

# clean sources from disturbing files
rm -f $DDWRT_REPO_DIR/src/router/minidlna/ffmpeg-3.1/config.mak
rm -rf $DDWRT_REPO_DIR/src/router/libmcrypt/autom4te

patch -i $DDWRT_PATCHES_DIR/Makefile.brcm3x.patch $DDWRT_REPO_DIR/src/router/Makefile.brcm3x 

cp -vf $DDWRT_REPO_DIR/src/router/configs/broadcom_K3x/.config_ac $DDWRT_REPO_DIR/src/router/.config
#cp -vf $DDWRT_REPO_DIR/src/router/configs/broadcom_K3x/.config_mega.v24-K26 $DDWRT_REPO_DIR/src/router/.config
#cp -vf $DDWRT_REPO_DIR/src/router/configs/broadcom_K3x/.config_giga.v24-K26 $DDWRT_REPO_DIR/src/router/.config

# src/router/config dir has to be patched for gcc-10
patch -p1 -d $DDWRT_REPO_DIR/src/router/config < $DDWRT_PATCHES_DIR/config_gcc10.patch		

patch -i $DDWRT_PATCHES_DIR/configs.mk.patch $DDWRT_REPO_DIR/src/router/rules/configs.mk

## for lto working
patch -i $DDWRT_PATCHES_DIR/common.mk.patch $DDWRT_REPO_DIR/src/router/common.mk

## Comment out Ralink drivers not used by mipsel-router
patch -i $DDWRT_PATCHES_DIR/Kconfig.patch $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/drivers/net/wireless/Kconfig

patch -i $DDWRT_PATCHES_DIR/.config_std_noac.patch $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/.config_std_noac
patch -i  $DDWRT_PATCHES_DIR/Makefile_linux-4.4.patch $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/Makefile
	
####new 07/22
patch -i $DDWRT_PATCHES_DIR/nettle.mk.patch $DDWRT_REPO_DIR/src/router/rules/nettle.mk
patch -i $DDWRT_PATCHES_DIR/sodium.mk.patch $DDWRT_REPO_DIR/src/router/rules/sodium.mk
patch -i $DDWRT_PATCHES_DIR/chillispot.mk.patch $DDWRT_REPO_DIR/src/router/rules/chillispot.mk
patch -i $DDWRT_PATCHES_DIR/glib.mk.patch $DDWRT_REPO_DIR/src/router/rules/glib.mk
patch -i $DDWRT_PATCHES_DIR/mtr.mk.patch $DDWRT_REPO_DIR/src/router/rules/mtr.mk
patch -i $DDWRT_PATCHES_DIR/libcares.mk.patch $DDWRT_REPO_DIR/src/router/rules/libcares.mk
patch -i $DDWRT_PATCHES_DIR/krb5.mk.patch $DDWRT_REPO_DIR/src/router/rules/krb5.mk
patch -i $DDWRT_PATCHES_DIR/avahi.mk.patch $DDWRT_REPO_DIR/src/router/rules/avahi.mk
patch -i $DDWRT_PATCHES_DIR/python.mk.patch $DDWRT_REPO_DIR/src/router/rules/python.mk
patch -i $DDWRT_PATCHES_DIR/configure_python.ac.patch $DDWRT_REPO_DIR/src/router/python/configure.ac
patch -i $DDWRT_PATCHES_DIR/Makefile_mactelnet.patch $DDWRT_REPO_DIR/src/router/mactelnet/Makefile
patch -i $DDWRT_PATCHES_DIR/aircrack-ng.mk.patch $DDWRT_REPO_DIR/src/router/rules/aircrack-ng.mk
patch -i $DDWRT_PATCHES_DIR/snort.mk.patch $DDWRT_REPO_DIR/src/router/rules/snort.mk
#patch -i $DDWRT_PATCHES_DIR/btrfsprogs.mk.patch $DDWRT_REPO_DIR/src/router/rules/btrfsprogs.mk
#patch -i $DDWRT_PATCHES_DIR/configure_btrfsprogs.ac.patch $DDWRT_REPO_DIR/src/router/btrfsprogs/configure.ac

patch -i $DDWRT_PATCHES_DIR/ntfs-3g.mk.patch $DDWRT_REPO_DIR/src/router/rules/ntfs-3g.mk

##disable conntrack and iptables-new-clean target
patch -i $DDWRT_PATCHES_DIR/iptables-new.mk.patch $DDWRT_REPO_DIR/src/router/rules/iptables-new.mk
##others: corrected paths to libs, ...
patch -i $DDWRT_PATCHES_DIR/util-linux.mk.patch $DDWRT_REPO_DIR/src/router/rules/util-linux.mk
patch -i $DDWRT_PATCHES_DIR/igmp-proxy.mk.patch $DDWRT_REPO_DIR/src/router/rules/igmp-proxy.mk

patch -i $DDWRT_PATCHES_DIR/sqlite.mk.patch $DDWRT_REPO_DIR/src/router/rules/sqlite.mk

# reconfigure because of automake 1.15
patch -i $DDWRT_PATCHES_DIR/pcre.mk.patch $DDWRT_REPO_DIR/src/router/rules/pcre.mk
patch -i $DDWRT_PATCHES_DIR/libevent.mk.patch $DDWRT_REPO_DIR/src/router/rules/libevent.mk
patch -i $DDWRT_PATCHES_DIR/libtalloc.mk.patch $DDWRT_REPO_DIR/src/router/rules/libtalloc.mk
patch -i $DDWRT_PATCHES_DIR/transmission.mk.patch $DDWRT_REPO_DIR/src/router/rules/transmission.mk

#whitespace missing 
patch -i $DDWRT_PATCHES_DIR/pptpd.mk.patch $DDWRT_REPO_DIR/src/router/rules/pptpd.mk

patch -i $DDWRT_PATCHES_DIR/configure_asterisk.ac.patch $DDWRT_REPO_DIR/src/router/asterisk/configure.ac
patch -i $DDWRT_PATCHES_DIR/asterisk.mk.patch $DDWRT_REPO_DIR/src/router/rules/asterisk.mk

# patch because of interference with libs of host-system
patch -i $DDWRT_PATCHES_DIR/wscript.patch $DDWRT_REPO_DIR/src/router/libtalloc/lib/replace/wscript

# missing files in sources
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/libutils
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/httpd/visuals
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/httpd
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/shared
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/services
cp -vf $DDWRT_PATCHES_DIR/revision.h $DDWRT_REPO_DIR/src/router/rc

# missing folder in sources
mkdir $DDWRT_REPO_DIR/src/router/kromo/dd-wrt/style

# "3com" error
patch -i $DDWRT_PATCHES_DIR/Makefile_kromo.patch $DDWRT_REPO_DIR/src/router/kromo/dd-wrt/Makefile

# div. changes
patch -i $DDWRT_PATCHES_DIR/Makefile_minidlna.patch $DDWRT_REPO_DIR/src/router/minidlna/Makefile
patch -i $DDWRT_PATCHES_DIR/Makefile_minidlna_minidlna.patch $DDWRT_REPO_DIR/src/router/minidlna/minidlna/Makefile
patch -i $DDWRT_PATCHES_DIR/Makefile_rc.patch $DDWRT_REPO_DIR/src/router/rc/Makefile

# patches because of newer gawk
patch -p1 -d $DDWRT_REPO_DIR/src/router/vpnc/libgpg-error < $DDWRT_PATCHES_DIR/libgpg-error.patch

patch -i $DDWRT_PATCHES_DIR/local.mk.patch $DDWRT_REPO_DIR/src/router/olsrd/src/cfgparser/local.mk

#has "C11" error; so new daq-source needed and again already patch
cp -rf $HOME/daq-2.0.7/* $DDWRT_REPO_DIR/src/router/daq/
patch -p1 -d $DDWRT_REPO_DIR/src/router/daq < $DDWRT_PATCHES_DIR/daq_Fix_musl_lib.patch
patch -i $DDWRT_PATCHES_DIR/daq.mk.patch $DDWRT_REPO_DIR/src/router/rules/daq.mk

#samba3.6 patches
patch -i $DDWRT_PATCHES_DIR/samba36_autogen.sh.patch $DDWRT_REPO_DIR/src/router/samba36/source3/autogen.sh
patch -i $DDWRT_PATCHES_DIR/samba36_libreplace_cc.m4.patch $DDWRT_REPO_DIR/src/router/samba36/lib/replace/libreplace_cc.m4
patch -i $DDWRT_PATCHES_DIR/samba3.mk.patch $DDWRT_REPO_DIR/src/router/rules/samba3.mk  

#transmission patches: libsystemd, intltoolize, ...
patch -i $DDWRT_PATCHES_DIR/configure_transmission.ac.patch $DDWRT_REPO_DIR/src/router/transmission/configure.ac
patch -i $DDWRT_PATCHES_DIR/Makefile_transmission_daemon.am.patch $DDWRT_REPO_DIR/src/router/transmission/daemon/Makefile.am

#softether patches
patch -i $DDWRT_PATCHES_DIR/softether.mk.patch $DDWRT_REPO_DIR/src/router/rules/softether.mk
patch -i $DDWRT_PATCHES_DIR/CMakeLists_softether_src.txt.patch $DDWRT_REPO_DIR/src/router/softether/src/CMakeLists.txt

# modified mk-files for make install
patch -i $DDWRT_PATCHES_DIR/minidlna.mk.patch $DDWRT_REPO_DIR/src/router/rules/minidlna.mk

cd $DDWRT_REPO_DIR/src/router

make -f Makefile.brcm3x all install

