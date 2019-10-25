import argparse
from PIL import Image

parser = argparse.ArgumentParser()
parser.add_argument("image")

args = parser.parse_args()

im = Image.open(args.image, 'r')
im.save(args.image, "PNG", compress_level=0)

