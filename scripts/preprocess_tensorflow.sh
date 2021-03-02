#!/bin/bash

# this script is meant to be used with 'datalad run'

source scripts/utils.sh echo -n

python3 -m pip install -r scripts/requirements_tensorflow.txt
exit_on_error_code "Failed to install requirements: pip install"

mkdir -p logs/
python3 scripts/preprocess_tensorflow.py 1>logs/preprocess_tensorflow.out 2>logs/preprocess_tensorflow.err

rm files_count.stats
for dir in imagenet2012/5.1.0/
do
       echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

du -s imagenet2012/5.1.0/ > disk_usage.stats

rm ILSVRC2012_*
rm md5sums
