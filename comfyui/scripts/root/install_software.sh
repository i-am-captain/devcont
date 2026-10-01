#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

dnf check-update
dnf update -y

dnf install -y \
    gcc \
    gcc-c++ \
    make \
    binutils \
    python3-devel \
    ncurses \
    util-linux \
    glib2 \
    glib2-devel \
    glibc-locale-source \
    bash-completion \
    clang \
    lldb \
    git \
    just \
    kdiff3 \
    dnf-plugins-core \
    pkg-config \
    libX11-devel \
    alsa-lib-devel \
    systemd-devel \
    wayland-devel \
    libxkbcommon-devel \
    vulkan-tools \
    vulkan-loader-devel \
    vulkan-validation-layers-devel \
    mesa-libGL \
    mesa-libEGL \
    libXi \
    libXxf86vm \
    libXfixes \
    libXrender \
    libSM \
    libICE \
    fontconfig \
    freetype \
    uv

# clean dnf cache, to keep image small
dnf clean all

# Some apps need a defined locale. Use english as default.
localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8
echo "LANG=en_US.UTF-8" | tee /etc/locale.conf
