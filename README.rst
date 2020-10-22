=============
ImageNet 2012
=============


`ImageNet 2012 <http://image-net.org/>`_ classification dataset. It contains
two size of the images along with their classification target and filename:

* Resized high resolution images each with a smaller edge of at most 512 while
  preserving the aspect ratio. This set is accessed by referencing the
  *bzna_input* track of the input samples.
* Resized images each  with a longer edge of at most 512 while preserving the
  aspect ratio. This set is accessed by referencing the *bzna_thumb* track of
  the input samples.

The dataset is represented by :py:class:`~benzina.dataset.ImageNet` which
simplifies the iteration of the data as a classification dataset.

.. warning::
   120 images first had to be transcoded to BMP prior to the final H.265
   format. More details can be found in `Important Notes`_.

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

ilsvrc2012.bzna
---------------

:ftyp: Defines the compatibilities of the mp4 container

       :major_brand: isom
       :minor_version: 0
       :compatible_brands: bzna, isom

:mdat: Raw concatenation in 3 blocks of the images, targets and filenames

       * Concatenation of .mp4 files containing a single image, a thumbnail of a
         maximum size of 512 x 512 if the image does not already fit this resolution,
         the image's original filename and the target associated with the image
       * Concatenation of images' targets as little-endian int64
       * Concatenation of images' original filename

:moov: Contains the metadata needed to load and present the raw data of *mdat*

       :mvhd: Defines the *timescale* and the *duration* of the container

              :timescale: 20
              :duration: 20 * 1 431 167
              :next_track_id: The id of the next track that could be appended to *moov*

       :trak: *Benzina input samples track*

              This track references all the images of the dataset

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000000 -- This value informs that the track is not
                                       for display purpose
                     :width: 0.0 -- This value reflects the variance in size of the frames
                     :height: 0.0 -- This value reflects the variance in size of the frames

              :mdia: Contains definitions related to the media type of the data

                     :mdhd: Redefines the *timescale* and the *duration* for the track

                            :timescale: 20
                            :duration: 20 * 1 431 167

                     :hdlr: Defines the media type of the track

                            :handler_type: ``meta``
                            :name: ``bzna_input``

                     :minf: Defines the characteristics of the media in the track

                            :nmhd: No specific media header is identified for the track

                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :mett: Defines the metadata as being text based

                                                 :mime_format: ``application/octet-stream``

                                   :stts: Defines the mapping from decoding time
                                          to sample number

                                          :sample_count: 1 431 167
                                          :sample_delta: 20

                                   :stsz: Defines the size of each samples

                                          :sample_count: 1 431 167
                                          :entry_size: Size of the sample. This field
                                                       is repeated for each sample

                                   :stsc: Defines the chunks splitting the data

                                          :first_chunk: 1
                                          :samples_per_chunk: 1
                                          :sample_description_index: 1

                                          This definition means to consider that
                                          all samples are contained in their own chunk

                                   :stco: Defines the chunks offset

                                          :entry_count: 1 431 167
                                          :chunk_offset: The chunk offset. This field
                                                         is repeated for each chunk,
                                                         i.e. for each sample

       :trak: *Benzina target track*

              This track is roughly the same as the *Benzina input track* with the
              following differences

              :mdia: Contains definitions related to the media type of the data

                     :hdlr: Defines the media type of the track

                            :handler_type: ``meta``
                            :name: ``bzna_target``

       :trak: *Benzina filename track*

              This track is roughly the same as the *Benzina input track* with the
              following differences

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000003 -- This value informs that the track is enabled
                                       and can be used in the presentation
                     :width: 0.0 -- This value informs that no width has be predefined
                                    for this track
                     :height: 0.0 -- This value informs that no height has be predefined
                                     for this track

              :mdia: Contains definitions related to the media type of the data

                     :hdlr: Defines the media type of the track

                            :handler_type: ``meta``
                            :name: ``bzna_fname``

                     :minf: Defines the characteristics of the media in the track

                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :mett: Defines the metadata as being text based

                                                 :mime_format: ``text/plain``

       :trak: *Video track*

              This track allows to play the thumbnails of the dataset's frames

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000003 -- This value informs that the track is enabled
                                       and can be used in the presentation
                     :width: 512.0
                     :height: 512.0

              :mdia: Contains definitions related to the media type of the data

                     :mdhd: Redefines the *timescale* and the *duration* for the track

                            :timescale: 20
                            :duration: 1 431 167

                     :hdlr: Defines the media type of the track

                            :handler_type: ``vide``
                            :name: ``VideoHandler``

                     :minf: Defines the characteristics of the media in the track

                            :vmhd: Video media header is identified for the track

                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :avc1: Defines the AVC coding information

                                                 :width: 512
                                                 :height: 512
                                                 :horizresolution: 72
                                                 :horizresolution: 72

                                   :stts: Defines the mapping from decoding time
                                          to sample number

                                          :sample_count: 1 431 167
                                          :sample_delta: 1

                                   :stsz: Defines the size of each samples

                                          :sample_count: 1 431 167
                                          :entry_size: Size of the sample. This field
                                                       is repeated for each sample

                                   :stsc: Defines the chunks splitting the data

                                          :first_chunk: 1
                                          :samples_per_chunk: 1
                                          :sample_description_index: 1

                                          This definition means to consider that
                                          all samples are contained in their own chunk

                                   :stco: Defines the chunks offset

                                          :entry_count: 1 431 167
                                          :chunk_offset: The chunk offset. This field
                                                         is repeated for each chunk,
                                                         i.e. for each sample

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

       :trak: *Benzina target track*

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000000 -- This value informs that the track is not
                                       for display purpose
                     :width: 0.0 -- This value informs that the width has not been
                                    predefined for this track
                     :height: 0.0 -- This value informs that no height has not been
                                     predefined for this track

              :mdia: Contains definitions related to the media type of the data

                     :mdhd: Redefines the *timescale* and the *duration* for the track

                            :timescale: 20
                            :duration: 20

                     :hdlr: Defines the media type of the track

                            :handler_type: ``meta``
                            :name: ``bzna_target``

                     :minf: Defines the characteristics of the media in the track

                            :nmhd: No specific media header is identified for the track
                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :mett: Defines the metadata as being text based

                                                 :mime_format: ``application/octet-stream``

       :trak: *Benzina filename track*

              This track is roughly the same as the *Benzina target track* with the
              following differences

              :tkhd: Defines the resolution of the video and if the track should
                     be displayed by an mp4 player

                     :flags: 000003 -- This value informs that the track is enabled
                                       and can be used in the presentation
                     :width: 0.0 -- This value informs that no width has be predefined
                                    for this track
                     :height: 0.0 -- This value informs that no height has be predefined
                                     for this track

              :mdia: Contains definitions related to the media type of the data

                     :hdlr: Defines the media type of the track

                            :handler_type: ``meta``
                            :name: ``bzna_fname``

                     :minf: Defines the characteristics of the media in the track

                            :stbl: Defines the data indexing of the media samples
                                   in the track along with coding information, if
                                   needed, to decode them

                                   :stsd: Provides the information needed to decode
                                          the media samples

                                          :mett: Defines the metadata as being text based

                                                 :mime_format: ``text/plain``

Important Notes
^^^^^^^^^^^^^^^

Extra Transcoding Images
^^^^^^^^^^^^^^^^^^^^^^^^

Current transcoding filters required 120 images to first be losslessly
transcoded to BMP prior to the final H.265 format. 109 images come from the
train split, 5 from the validation split and 6 from the test split.

The following images have currently passed through an extra transcoding to BMP
prior being transcoded to the final H.265 format.

==========================================   ==========================================
000000024058.n03534580_296.JPEG              000000733303.n02111889_6042.JPEG
000000027544.n04487394_27552.JPEG            000000745556.n07590611_14981.JPEG
000000029851.n03476684_24033.JPEG            000000745868.n02110063_8519.JPEG
000000034506.n04090263_3919.JPEG             000000758208.n04252077_2514.JPEG
000000045763.n02095889_12065.JPEG            000000758325.n04019541_63092.JPEG
000000051357.n03982430_7249.JPEG             000000762884.n03045698_10.JPEG
000000059196.n04229816_453.JPEG              000000788704.n03314780_10725.JPEG
000000070397.n02111129_577.JPEG              000000831240.n02783161_5909.JPEG
000000082710.n03376595_3357.JPEG             000000837233.n04597913_9295.JPEG
000000117999.n02089973_957.JPEG              000000842377.n02699494_3667.JPEG
000000150904.n02168699_11446.JPEG            000000861717.n03534580_11867.JPEG
000000194916.n02086910_5024.JPEG             000000879391.n04152593_2568.JPEG
000000199391.n03146219_6223.JPEG             000000883250.n02769748_43971.JPEG
000000207680.n01955084_6395.JPEG             000000889167.n01601694_11752.JPEG
000000208315.n02037110_22005.JPEG            000000894505.n02111889_2259.JPEG
000000253149.n03000684_3392.JPEG             000000906069.n04487394_2630.JPEG
000000256236.n01773549_6602.JPEG             000000937668.n01532829_34094.JPEG
000000258833.n03026506_845.JPEG              000000952824.n03110669_41191.JPEG
000000267245.n09288635_319.JPEG              000000963252.n01675722_271.JPEG
000000275346.n02092002_2663.JPEG             000000963717.n01685808_7750.JPEG
000000282904.n02089973_2925.JPEG             000000965703.n07697537_3143.JPEG
000000291692.n04442312_2067.JPEG             000000983759.n01728572_18902.JPEG
000000298367.n03133878_5019.JPEG             000001019425.n01945685_1792.JPEG
000000300303.n03840681_3351.JPEG             000001053093.n04584207_7380.JPEG
000000306736.n02906734_1444.JPEG             000001059567.n03785016_20945.JPEG
000000316170.n02086910_8683.JPEG             000001059828.n02277742_3152.JPEG
000000332360.n03372029_58252.JPEG            000001065640.n13044778_4708.JPEG
000000339530.n02107142_10521.JPEG            000001083249.n13052670_4305.JPEG
000000366297.n07583066_16773.JPEG            000001090733.n01491361_12958.JPEG
000000370889.n03045698_5561.JPEG             000001096481.n02799071_57191.JPEG
000000381685.n02074367_7576.JPEG             000001114723.n02112706_3789.JPEG
000000429163.n04542943_3795.JPEG             000001133026.n03666591_26882.JPEG
000000442461.n01729322_14149.JPEG            000001140503.n07760859_2398.JPEG
000000444699.n02091635_5997.JPEG             000001146137.n02106030_12674.JPEG
000000475405.n02116738_1107.JPEG             000001159706.n01770393_8931.JPEG
000000484570.n03857828_7582.JPEG             000001167639.n04049303_4688.JPEG
000000491553.n02281406_1126.JPEG             000001168352.n03733805_26.JPEG
000000498644.n07753592_76.JPEG               000001175671.n02013706_1188.JPEG
000000510393.n03954731_17927.JPEG            000001181059.n04550184_41933.JPEG
000000511065.n02607072_10131.JPEG            000001205624.n07717556_2408.JPEG
000000521498.n02086910_9723.JPEG             000001205923.n03838899_47111.JPEG
000000532501.n03065424_11072.JPEG            000001207633.n04325704_13495.JPEG
000000543474.n03602883_2504.JPEG             000001215956.n02264363_383.JPEG
000000572770.n03016953_10611.JPEG            000001216548.n03062245_15319.JPEG
000000581208.n02389026_292.JPEG              000001217959.n04371430_7236.JPEG
000000581260.n02099267_6961.JPEG             000001222769.n12267677_1987.JPEG
000000581849.n01729322_17541.JPEG            000001236856.n02790996_4206.JPEG
000000584370.n02095570_574.JPEG              000001248794.n01773549_2894.JPEG
000000585513.n02865351_2036.JPEG             000001273617.n03954731_53107.JPEG
000000590003.n04069434_3369.JPEG             000001284218.ILSVRC2012_val_00003052.JPEG
000000614426.n02916936_876.JPEG              000001292621.ILSVRC2012_val_00011455.JPEG
000000627643.n03599486_7962.JPEG             000001321644.ILSVRC2012_val_00040478.JPEG
000000649716.n02281406_15049.JPEG            000001326146.ILSVRC2012_val_00044980.JPEG
000000655319.n03240683_12389.JPEG            000001327255.ILSVRC2012_val_00046089.JPEG
000000668120.n07717410_3002.JPEG             000001349916.ILSVRC2012_test_00018750.JPEG
000000684882.n02095570_414.JPEG              000001359379.ILSVRC2012_test_00028213.JPEG
000000688497.n04254120_2422.JPEG             000001381705.ILSVRC2012_test_00050539.JPEG
000000704361.n04251144_4546.JPEG             000001398993.ILSVRC2012_test_00067827.JPEG
000000712106.n03891251_1907.JPEG             000001405792.ILSVRC2012_test_00074626.JPEG
000000732372.n04589890_8655.JPEG             000001425367.ILSVRC2012_test_00094201.JPEG
==========================================   ==========================================

.. Note::
   Names legend is *index_in_complete_dataset.filename.ext*
