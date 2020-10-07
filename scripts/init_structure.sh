#!/bin/bash

function exit_on_error_code {
	err=$?
	if [ $err -ne 0 ]
	then
		>&2 echo "$(tput setaf 1)error$(tput sgr0): $1: $err"
		exit $err
	fi
}

if [[ ! -d "tmp_processing/venv/bzna/" ]]
then
	mkdir -p tmp_processing/venv/
	virtualenv --no-download tmp_processing/venv/bzna/
fi

(source tmp_processing/venv/bzna/bin/activate && \
 pip install --no-index --upgrade pip && \
 python -m pip install -r scripts/requirements_pybenzinaconcat.txt --upgrade)
exit_on_error_code "Failed to install requirements: pip install"

# Initialize the directory structure
(source tmp_processing/venv/bzna/bin/activate && \
 cd tmp_processing/ && \
 python -m pybenzinaconcat -- concat ./ ilsvrc2012.mp4)
exit_on_error_code "Failed to initialize the directory structure"

ln -fs $(realpath imagenet_hdf5/ilsvrc2012.hdf5) tmp_processing/ilsvrc2012.hdf5
