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
   81 images are currently missing from the dataset and 111 had to be first
   transcoded to PNG prior to the final H.265 format. More details can be found
   in `Important Notes`_.

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

Missing Images
""""""""""""""

Current transcoding filters failed on 81 images from which 73 come from the
train split, 1 from the validation split and 7 from the test split. Future
development will fix the transcoding filters to add the missing images.

The following images are currently missing from the :ref:`imagenet_2012`
dataset.

==========================================   ==========================================
000000003037.n04418357_29208.JPEG            000000732709.n04141327_1794.JPEG
000000004697.n03876231_734.JPEG              000000743850.n02009912_3798.JPEG
000000047397.n03180011_5728.JPEG             000000764141.n02114548_24739.JPEG
000000061127.n04560804_11350.JPEG            000000769493.n03478589_13931.JPEG
000000077111.n03769881_2894.JPEG             000000773013.n07930864_18388.JPEG
000000110520.n03788195_1190.JPEG             000000840121.n09332890_37212.JPEG
000000113937.n03871628_3433.JPEG             000000854807.n12998815_3043.JPEG
000000116493.n03710637_10556.JPEG            000000857871.n07613480_23556.JPEG
000000129618.n02939185_39807.JPEG            000000876425.n03250847_4132.JPEG
000000143425.n04235860_232.JPEG              000000916160.n02692877_21841.JPEG
000000147583.n04086273_4499.JPEG             000000924998.n04467665_71095.JPEG
000000158650.n03535780_10665.JPEG            000000940786.n01667778_14402.JPEG
000000160461.n02672831_16051.JPEG            000000988466.n03691459_37960.JPEG
000000165331.n02116738_17382.JPEG            000000989062.n03840681_11467.JPEG
000000185131.n01496331_25908.JPEG            000001037497.n04330267_12874.JPEG
000000236992.n02168699_2022.JPEG             000001039839.n02128925_66204.JPEG
000000266412.n02105056_3563.JPEG             000001056990.n04238763_7623.JPEG
000000276316.n02747177_21532.JPEG            000001068407.n03160309_31575.JPEG
000000291869.n03394916_59127.JPEG            000001070947.n02095889_5935.JPEG
000000332111.n02939185_43660.JPEG            000001074851.n03495258_1505.JPEG
000000334412.n03344393_1637.JPEG             000001102986.n04404412_19279.JPEG
000000345384.n02017213_7913.JPEG             000001125300.n02895154_14789.JPEG
000000393334.n02108422_290.JPEG              000001125427.n02281787_120.JPEG
000000398916.n04067472_6106.JPEG             000001166933.n03782006_5219.JPEG
000000413216.n02109525_7117.JPEG             000001169035.n04423845_24697.JPEG
000000419127.n01756291_5655.JPEG             000001229335.n02108422_2239.JPEG
000000430631.n02692877_10145.JPEG            000001235873.n04005630_119507.JPEG
000000436958.n04116512_19239.JPEG            000001251364.n01753488_3577.JPEG
000000470012.n13037406_2678.JPEG             000001260590.n01667778_23017.JPEG
000000509167.n04525038_12107.JPEG            000001265345.n02843684_22216.JPEG
000000527250.n13037406_1268.JPEG             000001272383.n01537544_5303.JPEG
000000533741.n04540053_12755.JPEG            000001277398.n03125729_11512.JPEG
000000538458.n03110669_116190.JPEG           000001322414.ILSVRC2012_val_00041248.JPEG
000000618572.n01694178_2530.JPEG             000001333656.ILSVRC2012_test_00002490.JPEG
000000623682.n02699494_6847.JPEG             000001355529.ILSVRC2012_test_00024363.JPEG
000000629161.n04591157_2155.JPEG             000001357095.ILSVRC2012_test_00025929.JPEG
000000654967.n03841143_1964.JPEG             000001367132.ILSVRC2012_test_00035966.JPEG
000000664699.n02966687_1976.JPEG             000001382367.ILSVRC2012_test_00051201.JPEG
000000710865.n03733805_6637.JPEG             000001388553.ILSVRC2012_test_00057387.JPEG
000000727211.n12998815_15196.JPEG            000001403420.ILSVRC2012_test_00072254.JPEG
000000729182.n02123159_2023.JPEG
==========================================   ==========================================

.. Note::
   Names legend is *index_in_complete_dataset.filename.ext*

Extra Transcoding Images
^^^^^^^^^^^^^^^^^^^^^^^^

Current transcoding filters required 111 images to first be transcoded to PNG
prior to the final H.265 format. 102 images come from the train split, 6 from
the validation split and 3 from the test split.

The following images have currently passed through an extra transcoding to PNG
prior being transcoded to the final H.265 format.

==========================================   ==========================================
000000000255.n07714990_16359.JPEG            000000726149.n03873416_71019.JPEG
000000034506.n04090263_3919.JPEG             000000732372.n04589890_8655.JPEG
000000045763.n02095889_12065.JPEG            000000733303.n02111889_6042.JPEG
000000051357.n03982430_7249.JPEG             000000758325.n04019541_63092.JPEG
000000062160.n03866082_1565.JPEG             000000766892.n02841315_16075.JPEG
000000070397.n02111129_577.JPEG              000000767226.n03887697_9419.JPEG
000000082710.n03376595_3357.JPEG             000000771283.n02536864_6263.JPEG
000000085868.n02138441_2613.JPEG             000000788704.n03314780_10725.JPEG
000000117730.n01773549_3031.JPEG             000000814357.n02138441_7653.JPEG
000000140483.n03938244_17125.JPEG            000000823228.n01667114_4273.JPEG
000000146545.n03494278_11019.JPEG            000000831240.n02783161_5909.JPEG
000000194916.n02086910_5024.JPEG             000000834865.n07590611_2963.JPEG
000000199391.n03146219_6223.JPEG             000000841163.n03876231_7655.JPEG
000000200822.n02909870_4601.JPEG             000000845360.n03014705_2997.JPEG
000000207805.n02086910_2328.JPEG             000000868234.n01729322_16976.JPEG
000000214376.n02097130_4073.JPEG             000000883250.n02769748_43971.JPEG
000000215486.n13133613_31416.JPEG            000000889167.n01601694_11752.JPEG
000000226143.n02074367_5656.JPEG             000000891564.n02606052_1248.JPEG
000000236654.n02356798_5410.JPEG             000000893965.n02093754_5904.JPEG
000000251300.n03956157_21420.JPEG            000000894505.n02111889_2259.JPEG
000000256236.n01773549_6602.JPEG             000000963252.n01675722_271.JPEG
000000267245.n09288635_319.JPEG              000000963717.n01685808_7750.JPEG
000000271587.n01729322_16964.JPEG            000000964101.n01843065_608.JPEG
000000298367.n03133878_5019.JPEG             000000965703.n07697537_3143.JPEG
000000303125.n07892512_30004.JPEG            000000969808.n03884397_16762.JPEG
000000320848.n02089867_1981.JPEG             000001017761.n02699494_4096.JPEG
000000338531.n04380533_1893.JPEG             000001030779.n03967562_46702.JPEG
000000387611.n04467665_67818.JPEG            000001030986.n02088094_5574.JPEG
000000436677.n03255030_3820.JPEG             000001032820.n04131690_7859.JPEG
000000444699.n02091635_5997.JPEG             000001040750.n01440764_7922.JPEG
000000449008.n03259280_667.JPEG              000001043832.n03534580_1079.JPEG
000000452536.n02396427_6910.JPEG             000001059828.n02277742_3152.JPEG
000000474164.n02088466_9898.JPEG             000001066505.n03062245_15855.JPEG
000000475380.n03924679_19589.JPEG            000001090462.n03843555_8369.JPEG
000000490719.n02009229_5694.JPEG             000001115569.n03527444_11416.JPEG
000000491553.n02281406_1126.JPEG             000001119676.n01770081_5607.JPEG
000000510393.n03954731_17927.JPEG            000001159706.n01770393_8931.JPEG
000000572770.n03016953_10611.JPEG            000001162508.n02999410_55165.JPEG
000000573720.n03967562_15447.JPEG            000001207633.n04325704_13495.JPEG
000000584370.n02095570_574.JPEG              000001215956.n02264363_383.JPEG
000000590003.n04069434_3369.JPEG             000001219172.n04409515_16390.JPEG
000000595075.n03532672_11734.JPEG            000001226800.n04550184_41270.JPEG
000000602639.n03016953_2211.JPEG             000001242042.n02086910_9515.JPEG
000000607506.n03742115_8552.JPEG             000001248794.n01773549_2894.JPEG
000000618693.n03866082_10793.JPEG            000001250804.n04209239_1239.JPEG
000000619754.n02777292_24743.JPEG            000001273617.n03954731_53107.JPEG
000000620721.n04404412_12106.JPEG            000001284218.ILSVRC2012_val_00003052.JPEG
000000652113.n09246464_14705.JPEG            000001291191.ILSVRC2012_val_00010025.JPEG
000000658576.n01855032_6075.JPEG             000001303852.ILSVRC2012_val_00022686.JPEG
000000666541.n02105412_243.JPEG              000001316172.ILSVRC2012_val_00035006.JPEG
000000668120.n07717410_3002.JPEG             000001324065.ILSVRC2012_val_00042899.JPEG
000000675162.n10148035_25968.JPEG            000001327463.ILSVRC2012_val_00046297.JPEG
000000678309.n03792972_2040.JPEG             000001332008.ILSVRC2012_test_00000842.JPEG
000000688497.n04254120_2422.JPEG             000001398993.ILSVRC2012_test_00067827.JPEG
000000688637.n03891251_613.JPEG              000001405792.ILSVRC2012_test_00074626.JPEG
000000712106.n03891251_1907.JPEG
==========================================   ==========================================

.. Note::
   Names legend is *index_in_complete_dataset.filename.ext*
