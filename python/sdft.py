########https://stackoverflow.com/questions/6663222/doing-fft-in-realtime
from cmath import cos, sin, pi
from scipy import signal
import numpy as np

N = 128
coeffs = []
freqs = []
in_s = []
sig_counter = 0


def init_coeffs():
    for i in range(N):
        a = 2.0 * pi * i  / N
        coeffs.append(complex(cos(a),sin(a)))
    print(coeffs)


def sdft():
    delta = in_s[0] - in_s[N-1]
    for i in range(N):
        freqs[i] =  (freqs[i] + delta) * coeffs[i]


# initialise
init_coeffs()
t = np.linspace(0, 1, N, endpoint=False)
sig_in = signal.square(8 * pi * 2 * t)
#sig_in = np.sin(14 * pi * 2 * t)

for i in range(N):
    freqs.append(complex(0,0))
    in_s.append(complex(0,0))
    

# run the loop
for i in range(N*40):
    # rotate in new sample
    for i in range(N-1, 0, -1):
        in_s[i] = in_s[i-1]
    in_s[0] = complex(sig_in[sig_counter % N],0)

    sig_counter += 1

    # run the sdft
    sdft()

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
ax.plot(range(N), np.fft.fft(sig_in[0:N]))
ax.set_title("numpy fft")

ax = fig.add_subplot(2,2,1)
ax.plot(range(N), sig_in[0:N])
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
