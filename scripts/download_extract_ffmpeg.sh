#!/bin/bash

# This script is meant to be used with the command 'datalad run'

git-annex addurl --file=bin/ffmpeg-release-amd64-static.tar.xz \
        https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
md5sum -c bin/md5sums

tar -C bin/ -xf bin/ffmpeg-release-amd64-static.tar.xz

cd bin/
ln -s ffmpeg-4.2.1-amd64-static/ffmpeg .

