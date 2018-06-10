#!/usr/bin/env python3
import math
N = 16
width = 8
max_val = 2 ** width - 1
real_fh = open("twiddle_real.list", 'w')
imag_fh = open("twiddle_imag.list", 'w')


def to_bytes(n, length, endianess='big'):
    h = '%x' % n
    s = ('0'*(len(h) % 2) + h).zfill(length*2).decode('hex')
    return s if endianess == 'big' else s[::-1]

def hex2(n):
    return hex (n & 0xffffffff)[:-1]

def hex3(n):
    return "0x%s"%("0000%x"%(n&0xffff))[-4:]

for i in range(int(N)):
    cos_v = (max_val / 2 * math.cos(2 * math.pi * i / N))
    sin_v = (max_val / 2 * math.sin(2 * math.pi * i / N))
    print("%7.2f %7.2f -> %s %s" % (cos_v, sin_v, hex3(int(cos_v)), hex3(int(sin_v))))
    real_fh.write(hex3(int(cos_v)) + "\n")
    imag_fh.write(hex3(int(sin_v)) + "\n")

