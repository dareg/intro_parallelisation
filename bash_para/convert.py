#!/usr/bin/env python3
from PIL import Image

import sys
im = Image.open(sys.argv[1])
rgb_im = im.convert('RGB')
rgb_im.save(sys.argv[2])

