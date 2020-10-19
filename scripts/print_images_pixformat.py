import argparse
import glob
import os
import subprocess

from jug import TaskGenerator, mapreduce, bvalue


@TaskGenerator
def glob_extracted_images(extract_dir):
    images_fn = glob.glob(os.path.join(extract_dir, "*.JPEG"))
    images_fn.sort()
    return images_fn


@TaskGenerator
def print_image_pixformat(image_fn):
    return subprocess.run(["ffmpeg", "-nostdin", "-hide_banner", "-i", image_fn],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)


parser = argparse.ArgumentParser()
parser.add_argument("extract_dir")
args = parser.parse_args()

images_fn = glob_extracted_images(args.extract_dir)

images_pixformat = mapreduce.map(print_image_pixformat, bvalue(images_fn), map_step=32)

for out in bvalue(images_pixformat):
    print(out.stdout.decode('utf-8'))
    print(out.stderr.decode('utf-8'))
