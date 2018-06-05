"""
from math import log
import numpy as np
N = 32
t = np.linspace(0, 1, N, endpoint=False)

square = list(range(8))
print(square)

def permute(data, N):
    out = np.zeros(N)
    width = int(log(N) / log(2))
    for n in range(0, N):
        b = '{:0{width}b}'.format(n, width=width)
        bit_reversed_index = int(b[::-1], 2)
        out[n] = data[bit_reversed_index]
    
    return out


#Danielson-Lanzcos routine
def danielsonlanzcos(x, w, N):
    M=1;
    while (N > M):
        istep = M << 1

        for m in range(1, M):
            for i in range(m, N, istep):
                j = i + M
                print m
                
                temp = w[m] * x[j]
                x[j] = x[i] - temp
                x[i] = x[i] + temp

        M = istep

    return x
permuted = permute(square, len(square))
#print(permuted)
twiddles = np.zeros(len(square))
for N in range(len(square)/2):
    twiddles[N
out = danielsonlanzcos(permuted, twiddles, len(square))

print(out)

"""
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
N = 32
t = np.linspace(0, 1, N, endpoint=False)
square = signal.square(2 * np.pi * 2 * t)

def DFT_slow(x):
    """Compute the discrete Fourier Transform of the 1D array x"""
    x = np.asarray(x, dtype=float)
    N = x.shape[0]
    n = np.arange(N)
    k = n.reshape((N, 1))
    M = np.exp(-2j * np.pi * k * n / N)
    return np.dot(M, x)

x = np.random.random(32)
print(DFT_slow(square))
print(np.allclose(DFT_slow(square), np.fft.fft(square)))

#plt.plot(range(N), DFT_slow(square))
#plt.show()
#plt.ylim(-2, 2)
