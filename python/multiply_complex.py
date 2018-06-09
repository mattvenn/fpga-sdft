#!/usr/bin/env python3
from cmath import cos, sin, pi
from scipy import signal
import numpy as np

N = 16
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

init_coeffs()
import matplotlib.pyplot as plt

fig, ax = plt.subplots(nrows=4, ncols=4) #subplot_kw=dict(projection='polar'))
plot_num = 0
for row in ax:
    for col in row:
        print(coeffs[plot_num])
        x = [coeffs[plot_num].real, (coeffs[plot_num] * coeffs[plot_num]).real]  
        y = [coeffs[plot_num].imag, (coeffs[plot_num] * coeffs[plot_num]).imag]  
        col.plot(x, y, marker='o', markersize=2)
        col.set_ylim([-2,2])
        col.set_xlim([-2,2])
        plot_num += 1

plt.show()
