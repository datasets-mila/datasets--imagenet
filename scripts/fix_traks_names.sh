#!/bin/bash

# this script is meant to be used with 'datalad run'

pip install -r scripts/requirements_fix_traks_names.txt --upgrade
ERR=$?
if [ $ERR -ne 0 ]; then
   echo "Failed to install requirements: pip install: $ERR"
   exit $ERR
fi

for file in tmp_processing/queue/*.transcoded; do
    echo "Fixing [$file] ..."
    python scripts/fix_traks_names.py $file
    ERR=$?
    if [ $ERR -ne 0 ]; then
        echo "Failed to fix [$file]: $ERR"
        exit $ERR
    fi
done

