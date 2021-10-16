#! /bin/sh

DDWRT_PATCHES_DIR=$HOME/Dokumente/Artix_dd-wrt
export DDWRT_REPO_DIR=$HOME/dd-wrt
export PATH="$HOME/usr/local/bin:$HOME/dd-wrt_toolchains/toolchain-arm_cortex-a9_gcc-8.2.0_musl_eabi/bin:$PATH"

cd $DDWRT_REPO_DIR
git clean -dxf 
git reset --hard
#git pull.ff-only
#git checkout master
clear

# clean ccache
rm -rf $HOME/.cache

# directories with wrong position in sources
ln -s $DDWRT_REPO_DIR/opt $DDWRT_REPO_DIR/src/router/opt

# not needed but useful for debugging
ln -s $HOME/dd-wrt_toolchains/toolchain-arm_cortex-a9_gcc-8.2.0_musl_eabi $DDWRT_REPO_DIR/toolchain

# clean sources from disturbing files
rm -f $DDWRT_REPO_DIR/src/router/minidlna/ffmpeg-3.1/config.mak
rm -rf $DDWRT_REPO_DIR/src/router/libmcrypt/autom4te

patch -i $DDWRT_PATCHES_DIR/Makefile.northstar.patch $DDWRT_REPO_DIR/src/router/Makefile.northstar
cp -vf $DDWRT_REPO_DIR/src/router/Makefile.northstar $DDWRT_REPO_DIR/src/router/Makefile 

patch -i $DDWRT_PATCHES_DIR/.config_northstar.patch $DDWRT_REPO_DIR/src/router/configs/northstar/.config_northstar
cp -vf $DDWRT_REPO_DIR/src/router/configs/northstar/.config_northstar $DDWRT_REPO_DIR/src/router/.config

cp -vf $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/.config_northstar $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/.config

# src/router/config dir has to be patched for gcc-10
patch -p1 -d $DDWRT_REPO_DIR/src/router/config < $DDWRT_PATCHES_DIR/config_gcc10.patch

patch -i $DDWRT_PATCHES_DIR/configs.mk.patch $DDWRT_REPO_DIR/src/router/rules/configs.mk

## wrong flag for AR of toolchain
patch -i $DDWRT_PATCHES_DIR/common.mk.patch $DDWRT_REPO_DIR/src/router/common.mk

# deactivate this Makefile because blob will be installed (if any by mips - or arm-architecture 
mv -vf $DDWRT_REPO_DIR/src/router/sputnik/Makefile $DDWRT_REPO_DIR/src/router/sputnik/Makefile_sputnik

## Comment out Ralink drivers not used by mipsel-router
patch -i $DDWRT_PATCHES_DIR/Kconfig.patch $DDWRT_REPO_DIR/src/linux/universal/linux-4.4/drivers/net/wireless/Kconfig

#  jansson-configure added
patch -i $DDWRT_PATCHES_DIR/jansson.mk.patch $DDWRT_REPO_DIR/src/router/rules/jansson.mk
##several code changed
patch -i $DDWRT_PATCHES_DIR/ntfs-3g.mk.patch $DDWRT_REPO_DIR/src/router/rules/ntfs-3g.mk

## amended .mk-files with wrong target-machine-triplet, wrong autoconf-version (-autoreconf) ...
## json to json-c
patch -i $DDWRT_PATCHES_DIR/libubox.mk.patch $DDWRT_REPO_DIR/src/router/rules/libubox.mk
##several code changed
patch -i $DDWRT_PATCHES_DIR/emf.mk.patch $DDWRT_REPO_DIR/src/router/rules/emf.mk
##disable conntrack and iptables-new-clean target
patch -i $DDWRT_PATCHES_DIR/iptables-new.mk.patch $DDWRT_REPO_DIR/src/router/rules/iptables-new.mk
##others: corrected paths to libs, ...
patch -i $DDWRT_PATCHES_DIR/dnscrypt.mk.patch $DDWRT_REPO_DIR/src/router/rules/dnscrypt.mk
patch -i $DDWRT_PATCHES_DIR/util-linux.mk.patch $DDWRT_REPO_DIR/src/router/rules/util-linux.mk
patch -i $DDWRT_PATCHES_DIR/igmp-proxy.mk.patch $DDWRT_REPO_DIR/src/router/rules/igmp-proxy.mk
patch -i $DDWRT_PATCHES_DIR/chillispot.mk.patch $DDWRT_REPO_DIR/src/router/rules/chillispot.mk
patch -i $DDWRT_PATCHES_DIR/libevent.mk.patch $DDWRT_REPO_DIR/src/router/rules/libevent.mk
#patch -i $DDWRT_PATCHES_DIR/glib.mk.patch $DDWRT_REPO_DIR/src/router/rules/glib.mk
patch -i $DDWRT_PATCHES_DIR/tcpdump.mk.patch $DDWRT_REPO_DIR/src/router/rules/tcpdump.mk
patch -i $DDWRT_PATCHES_DIR/sqlite.mk.patch $DDWRT_REPO_DIR/src/router/rules/sqlite.mk
patch -i $DDWRT_PATCHES_DIR/php8.mk.patch $DDWRT_REPO_DIR/src/router/rules/php8.mk
patch -i $DDWRT_PATCHES_DIR/pcre.mk.patch $DDWRT_REPO_DIR/src/router/rules/pcre.mk
patch -i $DDWRT_PATCHES_DIR/libtalloc.mk.patch $DDWRT_REPO_DIR/src/router/rules/libtalloc.mk
patch -i $DDWRT_PATCHES_DIR/transmission.mk.patch $DDWRT_REPO_DIR/src/router/rules/transmission.mk
patch -i $DDWRT_PATCHES_DIR/libzip.mk.patch $DDWRT_REPO_DIR/src/router/rules/libzip.mk 
patch -i $DDWRT_PATCHES_DIR/mc.mk.patch $DDWRT_REPO_DIR/src/router/rules/mc.mk
patch -i $DDWRT_PATCHES_DIR/libpng.mk.patch $DDWRT_REPO_DIR/src/router/rules/libpng.mk
patch -i $DDWRT_PATCHES_DIR/libgd.mk.patch $DDWRT_REPO_DIR/src/router/rules/libgd.mk
patch -i $DDWRT_PATCHES_DIR/libxml2.mk.patch $DDWRT_REPO_DIR/src/router/rules/libxml2.mk
patch -i $DDWRT_PATCHES_DIR/aircrack-ng.mk.patch $DDWRT_REPO_DIR/src/router/rules/aircrack-ng.mk
patch -i $DDWRT_PATCHES_DIR/freeradius3.mk.patch $DDWRT_REPO_DIR/src/router/rules/freeradius3.mk
patch -i $DDWRT_PATCHES_DIR/readline.mk.patch $DDWRT_REPO_DIR/src/router/rules/readline.mk
patch -i $DDWRT_PATCHES_DIR/quagga.mk.patch $DDWRT_REPO_DIR/src/router/rules/quagga.mk
patch -i $DDWRT_PATCHES_DIR/tor.mk.patch $DDWRT_REPO_DIR/src/router/rules/tor.mk
patch -i $DDWRT_PATCHES_DIR/usbip.mk.patch $DDWRT_REPO_DIR/src/router/rules/usbip.mk
patch -i $DDWRT_PATCHES_DIR/ipeth.mk.patch $DDWRT_REPO_DIR/src/router/rules/ipeth.mk
patch -i $DDWRT_PATCHES_DIR/lighttpd.mk.patch $DDWRT_REPO_DIR/src/router/rules/lighttpd.mk
patch -i $DDWRT_PATCHES_DIR/uqmi.mk.patch $DDWRT_REPO_DIR/src/router/rules/uqmi.mk
patch -i $DDWRT_PATCHES_DIR/privoxy.mk.patch $DDWRT_REPO_DIR/src/router/rules/privoxy.mk
patch -i $DDWRT_PATCHES_DIR/json-c.mk.patch $DDWRT_REPO_DIR/src/router/rules/json-c.mk
patch -i $DDWRT_PATCHES_DIR/snort.mk.patch $DDWRT_REPO_DIR/src/router/rules/snort.mk

#whitespace fehlt 
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
patch -i $DDWRT_PATCHES_DIR/Makefile_hostapd2.patch $DDWRT_REPO_DIR/src/router/hostapd2/hostapd/Makefile
patch -i $DDWRT_PATCHES_DIR/Makefile_mactelnet.patch $DDWRT_REPO_DIR/src/router/mactelnet/Makefile
patch -i $DDWRT_PATCHES_DIR/Makefile_rc.patch $DDWRT_REPO_DIR/src/router/rc/Makefile

# patches because of newer gawk
patch -p1 -d $DDWRT_REPO_DIR/src/router/vpnc/libgpg-error < $DDWRT_PATCHES_DIR/libgpg-error.patch
patch -p1 -d $DDWRT_REPO_DIR/src/router/olsrd < $DDWRT_PATCHES_DIR/olsrd.patch 

#has "C11" error; so new daq-source needed and again already patch
cp -rf $DDWRT_PATCHES_DIR/../../daq-2.0.6/* $DDWRT_REPO_DIR/src/router/daq/
patch -p1 -d $DDWRT_REPO_DIR/src/router/daq < $DDWRT_PATCHES_DIR/daq_Fix_musl_lib.patch
patch -i $DDWRT_PATCHES_DIR/daq.mk.patch $DDWRT_REPO_DIR/src/router/rules/daq.mk

#samba3.6 patches
patch -i $DDWRT_PATCHES_DIR/samba36_autogen.sh.patch $DDWRT_REPO_DIR/src/router/samba36/source3/autogen.sh
patch -i $DDWRT_PATCHES_DIR/samba36_libreplace_cc.m4.patch $DDWRT_REPO_DIR/src/router/samba36/lib/replace/libreplace_cc.m4
patch -i $DDWRT_PATCHES_DIR/samba3.mk.patch $DDWRT_REPO_DIR/src/router/rules/samba3.mk   #runter zu samba3

#transmission patches: libsystemd, intltoolize, ...
patch -i $DDWRT_PATCHES_DIR/configure_transmission.ac.patch $DDWRT_REPO_DIR/src/router/transmission/configure.ac
patch -i $DDWRT_PATCHES_DIR/Makefile_transmission_daemon.am.patch $DDWRT_REPO_DIR/src/router/transmission/daemon/Makefile.am

#softether patches
patch -i $DDWRT_PATCHES_DIR/softether.mk.patch $DDWRT_REPO_DIR/src/router/rules/softether.mk
patch -i $DDWRT_PATCHES_DIR/CMakeLists_softether_src.txt.patch $DDWRT_REPO_DIR/src/router/softether/src/CMakeLists.txt

# modified mk-files for make install
patch -i $DDWRT_PATCHES_DIR/minidlna.mk.patch $DDWRT_REPO_DIR/src/router/rules/minidlna.mk

cd $DDWRT_REPO_DIR/src/router

cd $DDWRT_REPO_DIR/src/router
time make kernel clean all install
