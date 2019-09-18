#!/bin/bash

# This script is meant to be used with the command 'datalad run'

datalad download-url --nosave \
	http://www.image-net.org/challenges/LSVRC/2012/nnoupb/ILSVRC2012_img_train.tar \
	http://www.image-net.org/challenges/LSVRC/2012/nnoupb/ILSVRC2012_img_val.tar \
	http://www.image-net.org/challenges/LSVRC/2012/nnoupb/ILSVRC2012_devkit_t12.tar.gz
md5sum -c md5sums

