#!/bin/bash

# this script is meant to be used with 'datalad run'

pip install -r scripts/requirements_transcode.txt --upgrade
if [ $? -ne 0 ]; then
   echo "Failed to install requirements: pip install: $?"
   return $?
fi

mkdir -p tmp_processing/

ln -Lt tmp_processing/ imagenet_hdf5/ilsvrc2012.hdf5

cd tmp_processing/

export PATH="${PATH}:../bin"

# initialize the directory structure
python -m pyheifconcat concat . ilsvrc2012.bzna
rm ilsvrc2012.bzna

python -m pyheifconcat \
       extract_archive hdf5 ilsvrc2012.hdf5 . \
       --number 1431167 --transcode --mp4 --tmp extract/ \
&> transcode.out

cd ..

datalad remove --nosave -d . imagenet_hdf5/

