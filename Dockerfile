FROM phusion/baseimage:latest

# ------------------------------------------------------
# --- Configurable environment variables

# Version of the android NDK to be used
# see https://developer.android.com/ndk/downloads for latest stable version
ENV ANDROID_NDK_VERSION r20
# Branch / Tag / Commit Hash of libuv
ENV LIBUV_VERSION c6331a4
# Android API Level
ENV ANDROID_API_LEVEL 23

# ------------------------------------------------------
# --- Static environment variables
ENV ANDROID_NDK_HOME /opt/android-ndk

# ------------------------------------------------------
# --- Install required tools

RUN apt-get update -qq && \
    apt-get --allow-unauthenticated -y install python git make g++ wget libc6-dev-i386 g++-multilib lbzip2 unzip bzip2 xz-utils pkg-config && apt-get clean && \
    apt-get clean

# ------------------------------------------------------
# --- Android NDK

# download
RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# uncompress
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# move to its final location
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
# remove temp dir
    cd ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

# ------------------------------------------------------
# --- Fetch libuv sources
RUN cd /opt && \
    git clone https://github.com/libuv/libuv.git && \
    cd /opt/libuv && \
    git checkout ${LIBUV_VERSION} && \
    git clone https://chromium.googlesource.com/external/gyp build/gyp

# ------------------------------------------------------
# --- Include build script
ADD build.sh /opt
RUN ["chmod", "+x", "/opt/build.sh"]

# add to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

ENTRYPOINT ["/opt/build.sh"]
