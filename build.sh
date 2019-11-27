#!/bin/bash

cd /opt/libuv

arches=(arm arm64 x86 x86_64)

for arch in "${arches[@]}";
do
    source ./android-configure-$arch $ANDROID_NDK_HOME gyp $ANDROID_API_LEVEL
    BUILDTYPE=Release make -C out
    mkdir -p /opt/out/$arch
    cp out/Release/libuv.a /opt/out/$arch
done