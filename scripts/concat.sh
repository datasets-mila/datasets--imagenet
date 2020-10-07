#!/bin/bash

# this script is meant to be used with 'datalad run'
# and executed after extract_transcode.sh

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

# Add favored ffmpeg and jug_exec to PATH
export PATH="$(cd bin/; pwd):${PATH}"

SCRIPTS_DIR=$(cd scripts/; pwd)

# Create container header and concat transcoded images into ilsvrc2012.mp4
# Note: For jug to chain the actions, extract and transcode must use the
# same arguments as in extract_transcode.sh
(source tmp_processing/venv/bzna/bin/activate && \
 cd tmp_processing/ && \
 ${SCRIPTS_DIR}/jug_exec.py --jugdir=jugdir/ -- \
 	python -m pybenzinaconcat.create_container ilsvrc2012.mp4 && \
 python -m pybenzinaconcat -- \
 	extract ilsvrc2012.hdf5 extract/ hdf5 --size 1536000 --batch-size 512 \
 	--transcode ./ --mp4 --tmp tmp/ \
	--concat ilsvrc2012.mp4 \
 	>>logs/extract_transcode_concat.out 2>>logs/extract_transcode_concat.err)
exit_on_error_code "Failed to concat into ilsvrc2012.mp4"

md5sum tmp_processing/ilsvrc2012.mp4 >> md5sums
