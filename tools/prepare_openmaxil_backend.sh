#
# Project: OpenMAXIL QtMultimedia Plugin
# Company: -
# Author:  Luca Carlon (carlon.luca (AT) gmail.com)
# Date:    04.21.2013
#
#!/bin/sh

# This script can be used to prepare everything you need to compile the OpenMAXIL QtMultimedia backend
# into Qt sources. Run this script and PiOmxTextures and ffmpeg libs will be built and placed into
# PiOmxTextures/openmaxil_backend/3rdparty.
# First, remember to run the compile_ffmpeg.sh script to download and build ffmpeg.

echo "This script will automatically download and build the dependencies..."

if [ ! -d ../3rdparty/ffmpeg/lib ] || [ ! -d ../3rdparty/ffmpeg/include ]; then
   echo "It seems you did not compile ffmpeg. Please run compile_ffmpeg.sh first."
   exit
fi

while true; do
    read -p "The openmaxil_backend/3rdparty dir will be cleared. Are you sure you want to go on? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Preparing 3rdparty dir..."
cd ../openmaxil_backend/3rdparty
if [  $? -ne 0 ]; then
   echo "Wrong dir structure. Aborting."
   exit
fi
rm -rf PiOmxTextures
rm -rf ffmpeg

read -p "Please enter the absolute path to the qmake to use... " qmake_bin
echo "Ok, about to compile PiOmxTextures..."
mkdir build-PiOmxTextures
cd build-PiOmxTextures
$qmake_bin ../../..
make -j$1
make install

echo "PiOmxTextures built. Copying libs and headers..."
cd ../
mkdir -p PiOmxTextures/lib
mkdir -p PiOmxTextures/include
mkdir ffmpeg
cp -a build-PiOmxTextures/libPiOmxTextures* PiOmxTextures/lib
cp -a build-PiOmxTextures/piomxtextures/* PiOmxTextures/include
cp -a ../../3rdparty/ffmpeg/include ffmpeg
cp -a ../../3rdparty/ffmpeg/lib ffmpeg

echo "Cleaning up..."
rm -rf build-PiOmxTextures