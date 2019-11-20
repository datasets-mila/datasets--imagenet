#!/bin/bash

# this script is meant to be used with 'datalad run'

pip install -r scripts/requirements_fix_traks_names.txt --upgrade
ERR=$?
if [ $ERR -ne 0 ]; then
   echo "Failed to install requirements: pip install: $ERR"
   exit $ERR
fi

jug status scripts/fix_traks_names.py tmp_processing/queue
jug execute scripts/fix_traks_names.py tmp_processing/queue &> tmp_processing/fix_traks_names.out

