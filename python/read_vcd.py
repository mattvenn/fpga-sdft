from __future__ import print_function
from pprint import pprint;
from Verilog_VCD import parse_vcd
import struct
import sys
from parse_verilog_header import ParseParams

if len(sys.argv) != 3:
    exit("give vcd as first arg, params as 2nd")

params = ParseParams(sys.argv[2]).parse()

N = params['freq_bins']
data_width = params['data_width']
freq_d_width = params['freq_data_w']


print("N: %d, data width: %d, freq width %d" % (N, data_width, freq_d_width))

vcd = parse_vcd(sys.argv[1])

def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val                         # return positive value as is


def fetch_data(name, bitlength = freq_d_width):
    for key in vcd.keys():
        if name in vcd[key]['nets'][0]['name']:
            data = (vcd[key]['tv'])
            ints = []
            for d in data:
                ints.append(twos_comp(int(d[1],2), freq_d_width))
            return ints
    

reals = []
imags = []
ram = []
for i in range(N):
    real_name = 'frequency_bins_real[%d]' % i
    imag_name = 'frequency_bins_imag[%d]' % i
    ram_name = 'ram[%d]' % i
    reals.append(fetch_data(real_name))
    imags.append(fetch_data(imag_name))
    ram.append(fetch_data(ram_name))

# find longest set (these are VCD, so some may only have a limited number of entries
hist_len = 0
for i in range(N):
    if len(reals[i]) > hist_len:
        hist_len = len(reals[i])
    if len(imags[i]) > hist_len:
        hist_len = len(imags[i])

# pad with last value if necessary 
for i in range(N):
    for p in range(hist_len-len(reals[i])):
        reals[i].append(reals[i][len(reals[i])-1])
    for p in range(hist_len-len(imags[i])):
        imags[i].append(reals[i][len(imags[i])-1])


print("recovered %d sets of freq history" % hist_len)
print("last set of bins:")
for n in range(N):
    print("%3d: (%8d, %8dj), |%8d| %8d^2" % ( n, reals[n][hist_len-1], imags[n][hist_len-1], abs(complex(reals[n][hist_len-1], imags[n][hist_len-1])), pow(reals[n][hist_len-1],2) + pow(imags[n][hist_len-1],2) ))

plot_last = True
plot_all = False
if plot_all or plot_last:
    import matplotlib.pyplot as plt
    fig = plt.figure()


if plot_all:
    color = 0.0
    MAX_HIST = 20
    jumps = hist_len / MAX_HIST
    plot_num = 1
    # show the last MAX_HIST freq plots
    for h in range(0, MAX_HIST * jumps, jumps):
        print(h, plot_num)
        points = []
        for n in range(N):
            points.append(abs(complex(reals[n][h], imags[n][h])))
        print(points)
        ax = fig.add_subplot(MAX_HIST+1,1,plot_num)
        #    ax.set_ylim([0,500])
        ax.plot(range(N), points)
        plot_num += 1

if plot_last:
    points = []
    for n in range(N):
        points.append(abs(complex(reals[n][hist_len-1], imags[n][hist_len-1])))
    plt.plot(range(N), points)

    # bram
    if ram[0] is not None:
        ram_len = len(ram[0])
        points = []
        for n in range(N):
            points.append(ram[n][ram_len-1])
        plt.plot(range(N), points)

if plot_all or plot_last:
    #ax.legend()
    plt.show()
