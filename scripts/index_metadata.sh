#!/bin/bash

# this script is meant to be used with 'datalad run'

pip install -r scripts/requirements_index_metadata.txt --upgrade
ERR_CODE=$?
if [ $ERR_CODE -ne 0 ]; then
   echo "Failed to install requirements: pip install: $ERR_CODE"
   exit $ERR_CODE
fi

python -m pyheifconcat.index_metadata ilsvrc2012.bzna

