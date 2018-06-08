#!/usr/bin/env python3
import math
N = 16
width = 8
max_val = 2 ** width - 1
real_fh = open("twiddle_real.list", 'w')
imag_fh = open("twiddle_imag.list", 'w')
for i in range(int(N)):
    cos_v = (max_val / 2 * math.cos(2 * math.pi * i / N))
    sin_v = (max_val / 2 * math.sin(2 * math.pi * i / N))
    print("%7.2f %7.2f" % (cos_v, sin_v))
    real_fh.write(int(max_val / 2 * math.cos(2 * math.pi * i / N)).to_bytes(length=2, byteorder='big', signed=True).hex() + "\n")
    imag_fh.write(int(max_val / 2 * math.sin(2 * math.pi * i / N)).to_bytes(length=2, byteorder='big', signed=True).hex() + "\n")

