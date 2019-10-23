#!/bin/bash

# this script is meant to be used with 'datalad run'
# and executed after ./transcode.sh

pip install -r scripts/requirements_concat.txt --upgrade
if [ $? -ne 0 ]; then
   echo "Failed to install requirements: pip install: $?"
   return $?
fi

cd tmp_processing/

python -m pyheifconcat.create_container ilsvrc2012.bzna

python -m pyheifconcat concat . ilsvrc2012.bzna

mv ilsvrc2012.bzna ../

