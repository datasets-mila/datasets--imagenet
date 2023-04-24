#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

_SNAME=$(basename "$0")

mkdir -p logs/

# Transform dataset
python3 -m pip install -r scripts/requirements_torchvision.txt || \
	exit_on_error_code "Failed to install requirements: pip install"

python3 scripts/preprocess_torchvision.py \
	1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$

# Compile stats
# this is to have an idea of the internal state of the dataset
for d in train/ val/
do
	printf "%s\n" "${d}"
done | sort -u | ./scripts/stats.sh

git-annex add --fast -c annex.largefiles=nothing *.stats

rm ILSVRC2012_*
