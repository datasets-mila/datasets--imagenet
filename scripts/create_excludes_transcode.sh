#!/bin/bash

# this script is meant to be used with 'datalad run' and executed after scripts/transcode.sh

cd tmp_processing/

python ../scripts/list_transcoded_files.py queue/ > ../excludes_transcode

git -c annex.largefiles=nothing add ../excludes_transcode

