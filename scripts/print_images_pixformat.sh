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
 python -m pip install -r scripts/requirements_print_images_pixformat.txt --upgrade)
exit_on_error_code "Failed to install requirements: pip install"

(source tmp_processing/venv/bzna/bin/activate && \
 jug execute --jugdir=tmp_processing/print_images_pixformat.jugdir/ -- \
 	scripts/print_images_pixformat.py $(cd tmp_processing/extract/ && pwd) \
 	>>tmp_processing/logs/print_images_pixformat.out \
 	2>>tmp_processing/logs/print_images_pixformat.err)
