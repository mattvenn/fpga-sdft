#!/usr/bin/env python3
from cmath import cos, sin, pi
from scipy import signal
import numpy as np

size = 5
rotations = range(5)

N = size * size
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

fig, ax = plt.subplots(nrows=size, ncols=size) #subplot_kw=dict(projection='polar'))
plot_num = 0
for row in ax:
    for col in row:
        points = [coeffs[plot_num]]
        for r in rotations:
            points.append(points[r] * coeffs[plot_num])
        reals = [p.real for p in points]
        imags = [p.imag for p in points]
        col.plot(reals, imags, marker='o', markersize=3)
        col.set_ylim([-1.2,1.2])
        col.set_xlim([-1.2,1.2])
        plot_num += 1

plt.show()
