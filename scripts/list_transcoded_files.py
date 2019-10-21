import argparse, glob, os

parser = argparse.ArgumentParser()
parser.add_argument("dir")

args = parser.parse_args()

transcoded_list = glob.glob(os.path.join(args.dir, '*'))
transcoded_list.sort()

for i, filename in enumerate(transcoded_list):
    # Remove ".transcoded" suffix
    filename = filename.split('.')

    print('.'.join(filename[:-1]))

