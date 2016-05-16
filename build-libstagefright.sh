#!/bin/bash  
export NDK=/Users/ChauyanWang/Library/Android/sdk/ndk-bundle
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/
export PLATFORM=$NDK/platforms/android-9/arch-arm
export PREFIX=$(pwd)/android/

if [ "$NDK" = "" ]; then  
    echo NDK variable not set, assuming Users/ChauyanWang/Library/Android/sdk/ndk-bundle
    export NDK=Users/ChauyanWang/Library/Android/sdk/ndk-bundle
fi  

#echo "Fetching Android system headers"  
git clone --depth=1 --branch gingerbread-release git://github.com/CyanogenMod/android_frameworks_base.git ../android-source/frameworks/base  
git clone --depth=1 --branch gingerbread-release git://github.com/CyanogenMod/android_system_core.git ../android-source/system/core  
  
#echo "Fetching Android libraries for linking"  
# Libraries from any froyo/gingerbread device/emulator should work  
# fine, since the symbols used should be available on most of them.  
#if [ ! -d "../android-libs" ]; then  
#    if [ ! -f "../update-cm-7.0.3-N1-signed.zip" ]; then  
#        wget http://download.cyanogenmod.com/get/update-cm-7.0.3-N1-signed.zip -P../  
#    fi  
#    unzip ../update-cm-7.0.3-N1-signed.zip system/lib/* -d../  
#    mv ../system/lib ../android-libs  
#    rmdir ../system  
#fi  
  
    
# Expand the prebuilt/* path into the correct one  
export PATH=$PREBUILT/bin:$PATH  
ANDROID_SOURCE=../android-source  
ANDROID_LIBS=../android-libs  
ABI="armeabi-v7a"  
  
rm -rf ../build/stagefright  
mkdir -p ../build/stagefright  
  
DEST=../build/stagefright  
FLAGS="--target-os=linux --cross-prefix=arm-linux-androideabi- --arch=arm --cpu=armv7-a"  
FLAGS="$FLAGS --sysroot=$PLATFORM"  
FLAGS="$FLAGS --enable-shared --disable-demuxers --disable-muxers --disable-parsers --disable-avdevice --disable-filters --disable-programs --disable-encoders --disable-decoders --disable-decoder=h264 --disable-decoder=h264_vdpau --enable-decoder=libstagefright_h264 --enable-libstagefright-h264"  
  
EXTRA_CFLAGS="-I$ANDROID_SOURCE/frameworks/base/include -I$ANDROID_SOURCE/system/core/include"  
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/media/libstagefright"  
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include/media/stagefright/openmax"  
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK/sources/cxx-stl/gnu-libstdc++/4.6/include -I$NDK/sources/cxx-stl/gnu-libstdc++/4.6/libs/$ABI/include"  
  
EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"  
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS -L$NDK/sources/cxx-stl/gnu-libstdc++/4.6/libs/$ABI"  
EXTRA_CXXFLAGS="-Wno-multichar -fno-exceptions -fno-rtti"  
DEST="$DEST/$ABI"  
FLAGS="$FLAGS --prefix=$DEST"  
  
mkdir -p $DEST  
  
echo $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" > $DEST/info.txt  
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" | tee $DEST/configuration.txt  
[ $PIPESTATUS == 0 ] || exit 1  
make clean  
make -j4  
make install|| exit 1 
