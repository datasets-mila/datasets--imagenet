#!/bin/bash

# This script is meant to be used with the command 'datalad run'

git-annex addurl --file=bin/ffmpeg-4.1.4-amd64-static.tar.xz \
        https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.1.4-amd64-static.tar.xz
md5sum -c bin/md5sums

tar -C bin/ -xf bin/ffmpeg-4.1.4-amd64-static.tar.xz

cd bin/
ln -s ffmpeg-4.1.4-amd64-static/ffmpeg .
