import argparse
import glob
import os

import jug
from jug import TaskGenerator

from pybenzinaconcat import benzinaconcat
from pybenzinaconcat.utils import fnutils


def CachedFunction(f, *args, **kwargs):
    from jug import CachedFunction as _CachedFunction
    if isinstance(f, TaskGenerator):
        return _CachedFunction(f.f, *args, **kwargs)
    else:
        return _CachedFunction(f, *args, **kwargs)


@TaskGenerator
def parse_batch(mp4s, refs, refs_root, dest):
    parsed_imgs = []
    for mp4, ref in zip(mp4s, refs):
        assert ref.startswith(refs_root)
        dirname = os.path.join(dest, os.path.dirname(ref[len(refs_root):]))
        fname = fnutils.get_clean_filepath(mp4, basename=True)
        fname = os.path.join(dirname,
                             os.path.splitext(fname)[0] + ".mp4")
        os.makedirs(dirname, exist_ok=True)
        os.rename(mp4, fname)
        parsed_imgs.append(fname)
    return parsed_imgs


def array_split(array, batch_size, max_size=None):
    # split into batches
    splits = [array[:max_size]]
    while splits[0]:
        splits.append(splits[0][:batch_size])
        del splits[0][:batch_size]
    splits.pop(0)
    return splits


@TaskGenerator
def array_flatten(array):
    flatten = array.pop() if len(array) == 1 else []
    for subarr in array:
        flatten.extend(subarr)
    return flatten


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--torchvision", metavar="PATH",
                   help="ImageNet torchvision dataset path")
    p.add_argument("--hdf5", metavar="PATH", default=None,
                   help="ImageNet HDF5 dataset path. Used to get the test set")
    p.add_argument("--tmp", metavar="PATH",
                   help="Path to tmp files")
    p.add_argument("--crf", default="10", type=int,
                   help="constant rate factor to use for the transcoded image")
    p.add_argument("--force-bmp", default=False, action="store_true",
                   help="force transcoding to bmp prior transcoding to h265")
    p.add_argument("--batch-size", default=1024, metavar="NUM", type=int,
                   help="the batch size for a single job")
    args = p.parse_args()

    # list torchvision train, val sets
    train_imgs = CachedFunction(list, glob.glob(
        os.path.join(args.torchvision, "train", "*/*.JPEG")))
    val_imgs = CachedFunction(list, glob.glob(
        os.path.join(args.torchvision, "val", "*/*.JPEG")))

    assert len(train_imgs) == 1281167
    assert len(val_imgs) == 50000

    # transcode train, val sets
    train_imgs = CachedFunction(array_split, train_imgs, args.batch_size)
    train_mp4s = [benzinaconcat.transcode(
        batch, args.tmp, mp4=True, crf=args.crf, force_bmp=args.force_bmp,
        tmp=f"{args.tmp}/extract/")
        for batch in train_imgs]
    val_imgs = CachedFunction(array_split, val_imgs, args.batch_size)
    val_mp4s = [benzinaconcat.transcode(
        batch, args.tmp, mp4=True, crf=args.crf, force_bmp=args.force_bmp,
        tmp=f"{args.tmp}/extract/")
        for batch in val_imgs]

    if args.hdf5:
        # extract test set
        test_imgs = benzinaconcat.extract(
            args.hdf5, f"{args.tmp}/extract/", "imagenet", "hdf5",
            indices=1281167+50000, batch_size=args.batch_size)

        # transcode test set
        test_mp4s = [benzinaconcat.transcode(
            batch, args.tmp, mp4=True, crf=args.crf, force_bmp=args.force_bmp)
            for batch in test_imgs]
    else:
        test_imgs = []
        test_mp4s = []

    train_mp4s = [parse_batch(mp4s, imgs, args.torchvision, "bcachefs_content/")
                  for mp4s, imgs in zip(train_mp4s, train_imgs)]
    val_mp4s = [parse_batch(mp4s, imgs, args.torchvision, "bcachefs_content/")
                for mp4s, imgs in zip(val_mp4s, val_imgs)]
    test_mp4s = [
        parse_batch(mp4s, imgs, f"{args.tmp}/extract/", "bcachefs_content/test")
        for mp4s, imgs in zip(test_mp4s, test_imgs)]
    train_mp4s_flat = array_flatten(train_mp4s)
    val_mp4s_flat = array_flatten(val_mp4s)
    test_mp4s_flat = array_flatten(test_mp4s)

    jug.barrier()

    train_mp4s_set = CachedFunction(set, jug.value(train_mp4s_flat))
    assert len(train_mp4s_set) == 1281167

    val_mp4s_set = CachedFunction(set, jug.value(val_mp4s_flat))
    assert len(val_mp4s_set) == 50000

    if args.hdf5:
        test_mp4s_set = CachedFunction(set, jug.value(test_mp4s_flat))
        assert len(test_mp4s_set) == 100000
        assert len(set().union(train_mp4s_set, val_mp4s_set, test_mp4s_set)) == \
            1281167 + 50000 + 100000
    else:
        assert len(train_mp4s_set + val_mp4s_set) == 1281167 + 50000


main()
