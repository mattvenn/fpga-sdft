########https://stackoverflow.com/questions/6663222/doing-fft-in-realtime
from cmath import cos, sin, pi
from scipy import signal
import numpy as np
N = 32
coeffs = []
icoeffs = []
freqs = []
in_s = []
newest_data = complex(0,0)
oldest_data = complex(0,0)
idx = 0
sig_counter = 0

def init_coeffs():
    for i in range(N):
        a = -2.0 * pi * i  / N
        coeffs.append(complex(cos(a),sin(a)))
    for i in range(N):
        a = 2.0 * pi * i  / N
        icoeffs.append(complex(cos(a),sin(a)))


def sdft():
    global newest_data, oldest_data, idx
    delta = newest_data - oldest_data
    print(delta)
    ci = 0
    for i in range(N):
        freqs[i] += delta * coeffs[ci]
        ci += idx
        if ci >= N:
            ci -= N

init_coeffs()
print(coeffs, icoeffs)
t = np.linspace(0, 1, N*3, endpoint=False)
sig_in = signal.square(2 * pi * 2 * t)
sig_in = np.sin(12 * pi * 2 * t)
print(sig_in)
for i in range(N):
    freqs.append(complex(0,0))
    in_s.append(complex(0,0))

def add_data():
    global sig_counter, oldest_data, newest_data, idx
    oldest_data = in_s[idx]
    in_s[idx] = complex(sig_in[sig_counter],0)
    newest_data = in_s[idx]
    delta = newest_data - oldest_data
    print(delta)
    sig_counter += 1
    

for i in range(N*2):
    add_data()

    sdft()

    idx += 1
    if idx >= N:
        idx = 0


import matplotlib.pyplot as plt
print(freqs)
plt.plot(range(N), freqs)
#plt.plot(range(N), sig_in[0:N])
plt.show()
#plt.ylim(-2, 2)
