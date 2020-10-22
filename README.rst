########
IMAGENET
########

`<http://www.image-net.org/challenges/LSVRC/2012/>`_

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

********
BCACHEFS
********


`ImageNet 2012 <http://image-net.org/>`_ classification dataset. It contains
two size of the images along with their classification target and filename:

* Resized high resolution images each with a smaller edge of at most 512 while
  preserving the aspect ratio. This set is accessed by referencing the
  *bzna_input* track of the input samples.
* Resized images each  with a longer edge of at most 512 while preserving the
  aspect ratio. This set is accessed by referencing the *bzna_thumb* track of
  the input samples.

.. warning::
   High resolution images stored in the the *bzna_input* track of the input
   samples are currently not available through the
   :py:class:`~benzina.torch.dataloader.DataLoader`. Their widely varying size
   prevent them from being decoded using a single hardware decoder
   configuration. The selected solution is to represent the images in the HEIF
   format which will be completed in future development.

Dataset Composition
===================

The dataset is composed of a train set, followed by a validation set then a
test set for a total of 1 431 167 entries. Targets and filenames are provided
for each sets:

* | **Train set**
  | Entries 1 to 1281167 (1 281 167 entries)
* | **Validation set**
  | Entries 1281168 to 1331167 (50 000 entries)
* | **Test set**
  | Entries 1331168 to 1431167 (100 000 entries)

Dataset Structure
=================

Dataset's Input Samples Structure
---------------------------------

A Benzina ImageNet dataset's input sample is structured using the mp4 format.

:ftyp: Defines the compatibilities of the mp4 container

       :major_brand: isom
       :minor_version: 0
       :compatible_brands: bzna, isom

:mdat: Raw concatenation of the image, thumbnail, target and filename:

       * A single image in H.265 format. The image is put in a frame with a size
         of a product of 512 in the 2 dimensions. The padding to make the image
         fit is filled with a smear of the image's borders
       * A thumbnail in H.265 format. The image is put in a frame of size 512 x 512.
         The image is first resized to have its longest side be of 512. The padding
         to make the thumbnail fit the frame is filled with a smear of the image's
         borders. There will be no explicit thumbnail if the image already fit the
         thumbnail's frame
       * The image's target in a little-endian int64
       * The image's original filename

:moov: Contains the metadata needed to load and present the raw data of *mdat*

       :mvhd: Defines the *timescale* and the *duration* of the container

              :timescale: 20
              :duration: 20
              :next_track_id: The id of the next track that could be appended to *moov*

       :trak: *Benzina input track*

              This track references an image

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000000 -- This value informs that the track is not
                                       for display purpose
                     :width: Width of the image without padding
                     :height: Height of the image without padding

              :mdia: Contains definitions related to the media type of the data

                     :mdhd: Redefines the *timescale* and the *duration* for the track

                            :timescale: 20
                            :duration: 20

                     :hdlr: Defines the media type of the track

                            :handler_type: ``vide``
                            :name: ``bzna_input``

                     :minf: Defines the characteristics of the media in the track

                            :vmhd: Video media header is identified for the track
                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :avc1: Defines the AVC coding information

                                                 :width: Width of the image's frame.
                                                         This is a product of 512
                                                 :height: Height of the image's frame.
                                                          This is a product of 512
                                                 :horizresolution: 72
                                                 :horizresolution: 72

                                                 :clap: Defines the clean aperture
                                                        of the image to remove the
                                                        padding

                                                        :clean_aperture_width_n: Width of the image without padding
                                                        :clean_aperture_width_d: 1
                                                        :clean_aperture_height_n: Height of the image without padding
                                                        :clean_aperture_height_d: 1
                                                        :horiz_off_n: The negative value of the width's padding
                                                        :horiz_off_d: 2
                                                        :vert_off_n: The negative value of the height's padding
                                                        :vert_off_d: 2

                                   :stts: Defines the mapping from decoding time
                                          to sample number

                                          :sample_count: 1
                                          :sample_delta: 20

                                   :stsz: Defines the size of each samples

                                          :sample_count: 1
                                          :entry_size: Size of the input

                                   :stsc: Defines the chunks splitting the data

                                          :first_chunk: 1
                                          :samples_per_chunk: 1
                                          :sample_description_index: 1

                                   :stco: Defines the chunks offset

                                          :entry_count: 1
                                          :chunk_offset: The chunk offset

       :trak: *Benzina thumbnail track*

              This track references an image's thumbnail. If the image already fits
              a thumbnail's frame, then this track will reference the same data as
              in the *Benzina input track*. In any case, it is roughly the same as
              the *Benzina input track* with the following differences

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000003 -- This value informs that the track is enabled
                                       and can be used in the presentation
                     :width: Width of the thumbnail without padding
                     :height: Height of the thumbnail without padding

              :mdia: Contains definitions related to the media type of the data

                     :hdlr: Defines the media type of the track

                            :handler_type: ``vide``
                            :name: ``bzna_thumb``
