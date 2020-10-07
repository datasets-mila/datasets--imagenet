#!/bin/bash
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

source scripts/utils.sh echo -n

mkdir -p logs/

[[ -e "bin/ffmpeg" ]] || exit_on_error_code "ffmpeg is not present in $PWD/bin/"

python3 -m pip install -r scripts/requirements_pybenzinaconcat.txt

# Add favored ffmpeg to PATH
export PATH="$(cd bin/; pwd):${PATH}"

# Make extract, transcode dirs
mkdir -p .tmp/extract/
mkdir -p .tmp/queue/
mkdir -p .tmp/upload/

! jug status scripts/extract_transcode.py -- \
	--torchvision imagenet_torchvision/ \
	--hdf5 imagenet_hdf5/ilsvrc2012.hdf5 \
	--tmp .tmp/ \
	--force-bmp \
	1>>logs/extract_transcode.out_$$ 2>>logs/extract_transcode.err_$$
FFREPORT="file=logs/extract_transcode.ffmpeg_$$" jug execute scripts/extract_transcode.py -- \
	--torchvision imagenet_torchvision/ \
	--hdf5 imagenet_hdf5/ilsvrc2012.hdf5 \
	--tmp .tmp/ \
	--force-bmp \
	2>>logs/extract_transcode.err_$$ || \
	exit_on_error_code "Failed to extract and transcode images to H.265"

./scripts/stats.sh bcachefs_content/train/*/ bcachefs_content/val/*/ bcachefs_content/test/
