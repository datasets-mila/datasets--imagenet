import argparse
import glob
import os
import sys

from bitstring import BitStream, ConstBitStream
from jug import TaskGenerator

from pybzparse import Parser, boxes as bx_def


def fix_traks_names(filename):
    bstr = ConstBitStream(filename=filename)
    _, _, moov = Parser.parse(bstr, recursive=False)
    moov.parse_boxes(bstr, recursive=False)
    
    for moov_subbox in moov.boxes:
        if moov_subbox.header.type != b"trak":
            if isinstance(moov_subbox, bx_def.ContainerBox):
                moov_subbox.parse_boxes(bstr)
            moov_subbox.load(bstr)
            continue
    
        trak = moov_subbox
    
        trak.parse_boxes(bstr, recursive=False)
    
        mdia = None
    
        for trak_subbox in trak.boxes:
            if trak_subbox.header.type == b"mdia":
                mdia = trak_subbox
            else:
                if isinstance(trak_subbox, bx_def.ContainerBox):
                    trak_subbox.parse_boxes(bstr)
                trak_subbox.load(bstr)
    
        # MOOV.TRAK.MDIA
        mdia_boxes_end = mdia.header.start_pos + mdia.header.box_size
        bstr.bytepos = mdia.boxes_start_pos
    
        for box_header in Parser.parse(bstr, headers_only=True):
            if bstr.bytepos >= mdia_boxes_end:
                break
    
            if box_header.type != b"hdlr":
                box = Parser.parse_box(bstr, box_header)
                box.load(bstr)
    
            else:
                # hdlr.name should finish with a b'\0'. If it doesn't, add one
                # Add a b'\0' for safety
                hdlr_bstr = BitStream(bytes(box_header))
                hdlr_header = Parser.parse_header(hdlr_bstr)
                hdlr_header.box_size += 1
                hdlr_bstr.overwrite(bytes(hdlr_header), 0)
                hdlr_bstr.append(bstr.read("bytes:{}".format(box_header.box_size -
                                                             box_header.header_size)) +
                                 b'\0')
                box = Parser.parse_box(hdlr_bstr, hdlr_header)
                box.load(hdlr_bstr)
    
                # Prevent adding one too many b'\0'
                if box.padding.startswith(b'\0'):
                    box.padding = box.padding[1:]
    
            mdia.append(box)
    
    del bstr
    
    moov.refresh_box_size()
    
    # Validate the moov box by parsing
    bstr = ConstBitStream(bytes(moov))
    for box in Parser.parse(bstr):
        box.load(bstr)
    
    with open(filename, "rb+") as file:
        file.seek(moov.header.start_pos)
        file.write(bytes(moov))


@TaskGenerator
def fix_files_traks_names(filenames):
    for filename in filenames:
        print("Fixing [{}] ...".format(filename))
        try:
            fix_traks_names(filename)
        except Exception as exception:
            print("Failed to fix [{}]: {}".format(filename, exception), file=sys.stderr)


parser = argparse.ArgumentParser()
parser.add_argument("dir")

args = parser.parse_args()

filenames = glob.glob(os.path.join(args.dir, '*'))
filenames.sort()

for index in range(0, len(filenames), 1000):
    fix_files_traks_names(filenames[index:index+1000])

