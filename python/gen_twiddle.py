#!/usr/bin/env python3
import sys
from parse_verilog_header import ParseParams
import math

if len(sys.argv) != 2:
    exit("give params file as first arg")

params = ParseParams(sys.argv[1]).parse()
N = params['freq_bins']
width = params['data_width']

max_val = (2 ** width - 1)/2


def to_bytes(n, length, endianess='big'):
    h = '%x' % n
    s = ('0'*(len(h) % 2) + h).zfill(length*2).decode('hex')
    return s if endianess == 'big' else s[::-1]

def hex2(n):
    return hex (n & 0xffffffff)[:-1]

def hex3(n):
    return "0x%s"%("00000000%x"%(n&0xffffffff))[-8:]

def gen_twiddle():
    real_fh = open("twiddle_real.list", 'w')
    imag_fh = open("twiddle_imag.list", 'w')
    coeffs = []
    for i in range(int(N)):
        cos_v = (max_val * math.cos(2 * math.pi * i / N))
        sin_v = (max_val * math.sin(2 * math.pi * i / N))
        coeffs.append(complex(cos_v, sin_v))
        print("%7.2f %7.2f -> %s %s" % (cos_v, sin_v, hex3(int(cos_v)), hex3(int(sin_v))))
        real_fh.write(hex3(int(cos_v)) + "\n")
        imag_fh.write(hex3(int(sin_v)) + "\n")
    return coeffs

def gen_freq_bram():
    bram_fh = open("freq_bram.list", 'w')
    for i in range(int(N)):
        bram_fh.write(hex3(i) + "\n")

if __name__ == '__main__':
    print("N: %d, width: %d, max (signed) %d" % (N, width, max_val))
    gen_twiddle()
    gen_freq_bram()

