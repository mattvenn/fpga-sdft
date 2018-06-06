# FFT on an FPGA

having a go at some DSP on an FPGA. I'm basing the design on this paper:

http://web.mit.edu/6.111/www/f2017/handouts/FFTtutorial121102.pdf

![overview](docs/overview.png)

# Done

* Read the resources
* Implement HDL twiddle factor ROM
* Implement HDL AGU

# Todo

* Implement an FFT in Python using the same pattern
* Implement HDL butterfly computation
* Implement the 2 memory blocks

# Resources

* great video that explains what the Fourier transform is: https://www.youtube.com/watch?v=spUNpyF58BY
* paper on implementing an FFT on an FPGA http://web.mit.edu/6.111/www/f2017/handouts/FFTtutorial121102.pdf
* using Python to implement FFT: https://jakevdp.github.io/blog/2013/08/28/understanding-the-fft/
* sliding FFT https://www.dsprelated.com/showarticle/776.php
* stackoverflow answer about sdft: https://stackoverflow.com/questions/6663222/doing-fft-in-realtime
* paper on SDFT: http://www.comm.toronto.edu/~dimitris/ece431/slidingdft.pdf
