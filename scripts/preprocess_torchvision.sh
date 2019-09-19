#!/bin/bash

python scripts/preprocess_torchvision.py

rm files_count.stats
for dir in train/* val/*
do
	echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

du -s train/* val/* > disk_usage.stats

rm ILSVRC2012_*
