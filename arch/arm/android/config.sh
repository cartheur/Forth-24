#Authors: Bernd Paysan, Anton Ertl
#Copyright (C) 2015,2016,2017,2019,2020,2021,2022,2023 Free Software Foundation, Inc.

#This file is part of Gforth.

#Gforth is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation, either version 3
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.#See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program. If not, see http://www.gnu.org/licenses/.

# First create a standalone toolchain directory
#mkdir ~/proj/android-toolchain
#cd  ~/proj/android-toolchain
#~/proj/android-ndk-r10e/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-14 --ndk-dir=/home/bernd/proj/android-ndk-r10e --install-dir=$PWD --toolchain=arm-linux-androideabi-4.8
#configure with
#./configure --host=arm-linux-android --with-cross=android --prefix= --datarootdir=/sdcard --libdir=/sdcard --libexecdir=/lib --enable-lib --with-ditc=gforth-ditc-386
#and finally create an apk in this directory
#./build.sh
echo "config for android-arm"

CC=arm-linux-androideabi-gcc
TOOLCHAIN=$(which $CC | sed -e s,/bin/.*-gcc,,g)

XLIBS="" # "sigaltstack.o __set_errno.o" # sigemptyset.o sigaddset.o termios.o"
(mkdir -p engine/.libs
 cd engine
 for i in $XLIBS
 do
     ar x $TOOLCHAIN/sysroot/usr/lib/libc.a $i
     cp $i .libs/lib$i
     cp $i lib$i
     echo "# lib${i%o}lo - a libtool object file
# Generated by libtool (GNU libtool) 2.4.2
#
# Please DO NOT delete this file!
# It is necessary for linking the library.

# Name of the PIC object.
pic_object='.libs/lib$i'

# Name of the non-PIC object
non_pic_object='lib$i'" >lib${i%o}lo
 done
)
skipcode=".skip 4\n.skip 4\n.skip 4\n.skip 4"
kernel_fi=kernl64l.fi
ac_cv_sizeof_void_p=4
ac_cv_sizeof_char_p=4
ac_cv_sizeof_char=1
ac_cv_sizeof_short=2
ac_cv_sizeof_int=4
ac_cv_sizeof_long=4
ac_cv_sizeof_long_long=8
ac_cv_sizeof_intptr_t=4
ac_cv_sizeof_int128_t=0
ac_cv_c_bigendian=no
ac_cv_func_memcmp_working=yes
ac_cv_func_memmove=yes
ac_cv_func_getpagesize=no
ac_cv_func_wcwidth=no
ac_cv_file___arch_arm_asm_fs=yes
ac_cv_file___arch_arm_disasm_fs=yes
ac_cv_func_dlopen=yes
ac_cv_lib_ltdl_lt_dlinit=no
ac_export_dynamic=no
ac_cv_func_mcheck=no
ac_cv_lib_freetype_FT_Get_Char_Index=yes
ac_cv_lib_harfbuzz_hb_buffer_create=yes
ac_cv_lib_harfbuzz_hb_buffer_get_direction=yes
HOSTCC="gcc -m32 -D__ANDROID_API__=19"
GNU_LIBTOOL="arm-linux-androideabi-libtool --tag=CC"
LIBTOOL="arm-linux-androideabi-libtool --tag=CC"
build_libcc_named=build-libcc-named
#KBOX=/data/data/kevinboone.androidterm/kbox
#mi_prefix=$KBOX
#mi_prefix=/data/data/gnu.gforth/lib
extraccdir=/data/data/gnu.gforth/lib
asm_fs=arch/arm/asm.fs
disasm_fs=arch/arm/disasm.fs
EC_MODE="false"
EXTRAPREFIX="\$(shell which \$(firstword \$(GCC)) | sed -e s,/bin/\$(firstword \$(GCC)),/sysroot/usr,g)"
NO_EC=""
EC=""
engine2='engine2$(OPT).o'
engine_fast2='engine-fast2$(OPT).o'
no_dynamic=""
image_i=""
LIBS="-llog -lz"
signals_o="io.o signals.o $XLIBS androidmain.o zexpand.o"
GFORTH=`which gforth-386`
export PKG_CONFIG_SYSROOT_DIR=$TOOLCHAIN/sysroot
