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
	cd $current_path
    tar xjf $nasm_pkg && \
    cd nasm-2.14.02 && \
    ./autogen.sh && \
    ./configure --prefix="$release_path/nasm" --bindir="$release_path/nasm/bin" && \
    make && \
    make install
}

build_yasm() {
	cd $current_path
    tar xzf $yasm_pkg && \
    cd yasm-1.3.0 && \
    ./configure --prefix="$release_path/yasm" --bindir="$release_path/yasm/bin" && \
    make && \
    make install
}

build_x264() {
	cd $current_path
    tar xjf $x264_pkg && \
    cd x264-snapshot-20191217-2245 && \
    PATH="$release_path/nasm/bin:$release_path/yasm/bin:$PATH" && \
    ./configure --prefix="$release_path/x264" --bindir="$release_path/x264/bin" --enable-static --enable-pic && \
    make && \
    make install
}

build_x265() {
	cd $current_path
    tar xzf $x265_pkg && \
    cd x265_3.2 && \
    cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$release_path/x265" -DENABLE_SHARED=off ./source && \
    make && \
    make install
}

build_aac() {
	cd $current_path
    tar xzf $aac_pkg && \
    cd fdk-aac-2.0.2 && \
    autoreconf -fiv && \
    ./configure --prefix="$release_path/fdk-aac" --disable-shared && \
    make && \
    make install
}

build_opus() {
	cd $current_path
    tar xzf $opus_pkg && \
    cd opus-1.3.1 && \
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
	cd $current_path
    #tar xjf $ffmpeg_pkg
    cd ffmpeg-4.4.3
	echo $PATH
    PATH="$release_path/nasm/bin:$release_path/yasm/bin:$PATH"
	PKG_CONFIG_PATH="$release_path/opus/lib/pkgconfig:$release_path/x265/lib/pkgconfig"
	./configure \
    --prefix="$release_path/ffmpeg" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$release_path/fdk-aac/include -I$release_path/opus/include" \
    --extra-cflags="-I$release_path/x264/include -I$release_path/x265/include" \
    --extra-ldflags="-L$release_path/fdk-aac/lib -L$release_path/opus/lib" \
    --extra-ldflags="-L$release_path/x264/lib -L$release_path/x265/lib" \
    --extra-libs="-lpthread -lm -ldl" \
    --bindir="$release_path/ffmpeg/bin" \
    --enable-gpl \
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
