#!/bin/bash
#==============================================================================
# Title: install.sh (Colab/Ubuntu 22.04 compatible)
# Description: Install dependencies and build OpenFace
# Author: Modified for 2025 by ChatGPT
#==============================================================================

set -e
set -o pipefail

echo "Updating system..."
sudo apt-get -y update
sudo apt-get -y upgrade

echo "Installing essential dependencies..."
sudo apt-get -y install build-essential cmake pkg-config \
    libopenblas-dev liblapack-dev \
    libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev \
    libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-dev \
    git unzip wget

echo "Installing OpenCV (system package)..."
sudo apt-get -y install libopencv-dev python3-opencv

echo "Installing dlib (modern build)..."
# Remove old dlib if exists
pip uninstall -y dlib || true
# Build from source (Colab needs this for OpenFace compatibility)
wget http://dlib.net/files/dlib-19.24.tar.bz2
tar xf dlib-19.24.tar.bz2
cd dlib-19.24
mkdir build && cd build
cmake .. -DDLIB_USE_CUDA=0 -DUSE_AVX_INSTRUCTIONS=1
cmake --build . --config Release -j4
sudo make install
sudo ldconfig
cd ../..
rm -rf dlib-19.24 dlib-19.24.tar.bz2

echo "Building OpenFace..."
mkdir -p build
cd build
cmake -D CMAKE_BUILD_TYPE=Release ..
make -j4
cd ..

echo "✅ OpenFace installation complete!"
