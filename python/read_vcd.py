from __future__ import print_function
from Verilog_VCD import parse_vcd
import struct
vcd = parse_vcd('../build/sdft.vcd')
def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val                         # return positive value as is


def fetch_data(name):
    for key in vcd.keys():
        if name in vcd[key]['nets'][0]['name']:
            data = (vcd[key]['tv'])
            ints = []
            for d in data:
                ints.append(twos_comp(int(d[1],2), 16))
            return ints
    
for i in range(16):
    real_name = 'frequency_bins_real[%d]' % i
    imag_name = 'frequency_bins_imag[%d]' % i
    reals = fetch_data(real_name)
    imags = fetch_data(imag_name)

    print("%2d: " % i, end='')
    count = 0
    for i, j in zip(reals, imags):
        if count > 180:
            print("%6.1f " % abs(complex(i,j)), end='')
        count +=1
    print()
