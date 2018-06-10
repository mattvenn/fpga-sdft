from __future__ import print_function
# https://stackoverflow.com/questions/6663222/doing-fft-in-realtime
from cmath import cos, sin, pi
from scipy import signal
import numpy as np

# sample history needs to be the same as the number of frequency bins
N = 100
samp_hist = N

coeffs = []
freqs = []
in_s = []
sig_counter = 0


def init_coeffs():
    for i in range(N):
        a = 2.0 * pi * i  / N
        coeff = complex(cos(a),sin(a))
        coeffs.append(coeff)
        print(coeff)


def sdft(delta):
    for i in range(N):
        freqs[i] =  (freqs[i] + delta) * coeffs[i]


# initialise
init_coeffs()
t = np.linspace(0, 1, samp_hist, endpoint=False)
sig_in = signal.square(40 * pi * 2 * t)
#sig_in = np.sin(pi * 2 * t)

for i in range(N):
    freqs.append(complex(0,0))
for i in range(samp_hist):
    in_s.append(complex(0,0))
    

# run the loop
freq_hist = []
for i in range(samp_hist*2):
    freq_hist.append(list(freqs))
    # rotate in new sample
    last = in_s[samp_hist-1]
    for i in range(samp_hist-1, 0, -1):
        in_s[i] = in_s[i-1]
    in_s[0] = complex(sig_in[sig_counter % samp_hist],0)

    sig_counter += 1


    # run the sdft
    delta = in_s[0] - last
    sdft(delta)

"""
print("dumping frequency history:")
for f in range(N):
    print("%2d : " % f, end='')
    for i in range(32):
        print("(%4.1f,%4.1f)" % (freq_hist[i][f].real, freq_hist[i][f].imag), end='')
    print()
"""
# plot the results and compare with numpy's fft
import matplotlib.pyplot as plt
fig = plt.figure()
ax = fig.add_subplot(2,2,3)
plot_freqs = []
for i in range(N):
    plot_freqs.append(abs(freqs[i]))
    
ax.plot(range(N), plot_freqs)
ax.set_title("sliding dft")

ax = fig.add_subplot(2,2,4)
ax.plot(range(samp_hist), abs(np.fft.fft(sig_in[0:samp_hist])))
ax.set_title("numpy fft")

ax = fig.add_subplot(2,2,1)
ax.plot(range(samp_hist), sig_in[0:samp_hist])
ax.set_title("input signal")

ax = fig.add_subplot(2,2,2)
coeff_r = []
coeff_i = []

for i in range(N):
    coeff_r.append( coeffs[i].real)
    coeff_i.append( coeffs[i].imag)
ax.plot(coeff_r, coeff_i)
ax.set_title("coeffs/twiddles")

plt.show()
