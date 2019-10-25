#!/bin/bash

# this script is meant to be used with 'datalad run'

pip install -r scripts/requirements_transcode_remainings.txt --upgrade
if [ $? -ne 0 ]; then
   echo "Failed to install requirements: pip install: $?"
   return $?
fi

cd tmp_processing/

export PATH="${PATH}:../bin"

python -m pyheifconcat \
       extract_archive hdf5 ilsvrc2012.hdf5 . \
       --number 1431167 \
       --transcode --mp4 --excludes ../excludes_transcode \
       --tmp extract/ \
&> transcode_remainings.out

git rm ../excludes_transcode

