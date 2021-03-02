import tensorflow_datasets as tfds

download_config = tfds.download.DownloadConfig(manual_dir='.')
builder = tfds.builder("imagenet2012", data_dir='.', version="5.1.0")
builder.download_and_prepare(download_config=download_config)
