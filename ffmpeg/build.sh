#!/bin/bash

current_path=`pwd`
release_path=${current_path}/release

nasm_pkg=nasm-2.14.02.tar.bz2
yasm_pkg=yasm-1.3.0.tar.gz
x264_pkg=x264-snapshot-20191217-2245.tar.bz2
x265_pkg=x265_3.2.tar.gz
aac_pkg=fdk-aac-2.0.2.tar.gz
opus_pkg=opus-1.3.1.tar.gz
ffmpeg_pkg=ffmpeg-4.4.3.tar.bz2

build_nasm() {
    tar xjf $nasm_pkg
    cd nasm-2.14.02
    ./autogen.sh
    ./configure --prefix="$release_path/nasm" --bindir="$release_path/nasm/bin"
    make &&
    make install
}

build_yasm() {
    tar xzf $nasm_pkg
    cd yasm-1.3.0
    ./configure --prefix="$release_path/yasm" --bindir="$release_path/yasm/bin"
    make
    make install
}

build_x264() {
    tar xjf $x264_pkg
    cd x264-snapshot-20191217-2245
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" 
    ./configure --prefix="$release_path/x264" --bindir="$release_path/x264/bin" --enable-static --enable-pic
    make
    make install
}

build_x265() {
    tar xzf $x265_pkg
    cd x265_3.2
    PATH="$HOME/bin:$PATH" 
    cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$release_path/x265" -DENABLE_SHARED=off ./source
    make
    make install
}

build_aac() {
    tar xzf $aac_pkg
    cd fdk-aac-2.0.2
    autoreconf -fiv
    ./configure --prefix="$release_path/aac" --disable-shared
    make
    make install
}

build_opus() {
    tar xzf $opus_pkg && \
    cd opus-1.3.1 && \
    # ./autogen.sh && \
    ./configure --prefix="$release_path/opus" --disable-shared && \
    make && \
    make install
}

build_nasm
build_yasm
build_x264
build_x265
build_aac
build_opus

build_ffmpeg() {
    tar xjf $ffmpeg_pkg && \
    cd ffmpeg-4.4.3 && \
    ./configure \
    --prefix="$release_path/ffmpeg" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$release_path/*/include" \
    --extra-ldflags="-L$release_path/*/lib" \
    --extra-libs="-lpthread -lm" \
    --bindir="$release_path/ffmpeg/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree && \
    make && \
    make install
}

build_ffmpeg