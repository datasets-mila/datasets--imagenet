#####################
IMAGENET - TENSORFLOW
#####################

`<http://www.image-net.org/challenges/LSVRC/2012/>`_
`<https://www.tensorflow.org/datasets/catalog/imagenet2012>`_

************
Introduction
************

The goal of this competition is to estimate the content of photographs for the
purpose of retrieval and automatic annotation using a subset of the large
hand-labeled `ImageNet <http://www.image-net.org/>`_ dataset (10,000,000 labeled
images depicting 10,000+ object categories) as training. Test images will be
presented with no initial annotation -- no segmentation or labels -- and
algorithms will have to produce labelings specifying what objects are present
in the images. New test images will be collected and labeled especially for
this competition and are not part of the previously published ImageNet dataset.
The general goal is to identify the main objects present in images. This year,
we also have a detection task of specifying the location of objects.

More information is available on the webpage for last year's competition here:

    `ILSVRC 2011 <http://www.image-net.org/challenges/LSVRC/2011/index>`_.

****
Data
****

The validation and test data for this competition will consist of 150,000
photographs, collected from flickr and other search engines, hand labeled with
the presence or absence of `1000 object categories
<http://image-net.org/challenges/LSVRC/2012/browse-synsets>`_. The 1000 object
categories contain both internal nodes and leaf nodes of ImageNet, but do not
overlap with each other. A random subset of 50,000 of the images with labels
will be released as validation data included in the development kit along with
a list of the 1000 categories. The remaining images will be used for evaluation
and will be released without labels at test time.

The training data, the subset of ImageNet containing the 1000 categories and
1.2 million images, will be packaged for easy downloading. The validation and
test data for this competition are not contained in the ImageNet training data
(we will remove any duplicates).

    `Browse the training images of the 1000 categories here
    <http://image-net.org/challenges/LSVRC/2012/browse-synsets>`_

********
Citation
********

::

    @article{ILSVRC15,
    Author = {Olga Russakovsky and Jia Deng and Hao Su and Jonathan Krause and Sanjeev Satheesh and Sean Ma and Zhiheng Huang and Andrej Karpathy and Aditya Khosla and Michael Bernstein and Alexander C. Berg and Li Fei-Fei},
    Title = {{ImageNet Large Scale Visual Recognition Challenge}},
    Year = {2015},
    journal   = {International Journal of Computer Vision (IJCV)},
    doi = {10.1007/s11263-015-0816-y},
    volume={115},
    number={3},
    pages={211-252}
    }

*********
TFRecords
*********

The dataset has been formated using `tfds.load
<https://www.tensorflow.org/datasets/api_docs/python/tfds/load>_`. It currently
does not include the *test* split.
