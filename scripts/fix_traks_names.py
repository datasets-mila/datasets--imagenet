import argparse

from bitstring import BitStream, ConstBitStream

from pybzparse import Parser, boxes as bx_def

parser = argparse.ArgumentParser()
parser.add_argument("input")

args = parser.parse_args()

bstr = ConstBitStream(filename=args.input)
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

with open(args.input, "rb+") as file:
    file.seek(moov.header.start_pos)
    file.write(bytes(moov))

