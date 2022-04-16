#!/bin/bash

## Install dependencies
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse"
sudo apt -y update > /dev/null

sudo apt -y install build-essential checkinstall cmake pkg-config yasm \
git gfortran libjpeg8-dev libpng-dev software-properties-common \
libjasper1 libtiff-dev libavcodec-dev libavformat-dev libswscale-dev \
libdc1394-22-dev libxine2-dev libv4l-dev > /dev/null

sudo ln -s -f /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

sudo apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
libgtk2.0-dev libtbb-dev qt5-default libatlas-base-dev libfaac-dev libmp3lame-dev \
libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev \
libavresample-dev x264 v4l-utils libprotobuf-dev protobuf-compiler libgoogle-glog-dev \
libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen > /dev/null

sudo apt -y install python3-dev python3-pip python3-testresources > /dev/null
sudo -H pip3 install -U pip numpy

### Install OpenCV
#install it on /dev/data
cwd="/dev/data/opencv"
opencv_version="4.0.1"

mkdir -p "$cwd"
git clone https://github.com/opencv/opencv.git "$cwd"
cd "$cwd"; git checkout $opencv_version; rm -Rf .git; cd "$HOME"

mkdir -p "${cwd}_contrib"
git clone https://github.com/opencv/opencv_contrib.git "${cwd}_contrib"
cd "${cwd}_contrib"; git checkout $opencv_version; rm -Rf .git; cd "$HOME"

# OpenCV install
cd "$cwd"; mkdir build; cd build
cmake -DBUILD_SHARED_LIBS=OFF ..
make -j8 > /dev/null
make install > /dev/null

