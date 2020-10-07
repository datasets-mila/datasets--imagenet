#!/bin/bash

# this script is meant to be executed after init_structure.sh

function exit_on_error_code {
	err=$?
	if [ $err -ne 0 ]
	then
		>&2 echo "$(tput setaf 1)error$(tput sgr0): $1: $err"
		exit $err
	fi
}

mkdir -p tmp_processing/logs/

if [[ ! -e "bin/ffmpeg" ]]
then
	(exit 1)
	exit_on_error_code "ffmpeg is not present in $PWD/bin/"
fi

# Add favored ffmpeg to PATH
export PATH="$(cd bin/; pwd):${PATH}"

(source tmp_processing/venv/bzna/bin/activate && \
 cd tmp_processing/ && \
 python -m pybenzinaconcat -- \
 	extract ilsvrc2012.hdf5 extract/ hdf5 --size 1536000 --batch-size 512 \
 	--transcode ./ --mp4 --tmp tmp/ \
 	>>logs/extract_transcode.out 2>>logs/extract_transcode.err)
exit_on_error_code "Failed to extract and transcode from ilsvrc2012.hdf5"
