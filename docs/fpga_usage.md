# parallel (current design)

needs 1 complex multiply and 2 adds per bin. Then another complex multiply to
get output (not thinking about sqrt ATM). with 16 bins, design needs 8k logic
cells with complex output. 16k with with squared output.

potentially could run at 100MHz, 50MHz largest freq. Each bin would cover 3MHz.

# parallel w/multiplication lookup tables

8 bit sample and 8 bit coeff means 16bit lookup table

16 bin: 16 * 2 coeffs, 256 sample values = 8192 values in LUT * 16bit == 131k
so could be just possible on ICE40 8k device

8 bin output with multipliers possible on 8k.

still none of these will give modulo output.

# serial processing

another option is to process the bins serially, so only one complex multiply is
needed. Much more likely to be able to fit a 100 bin FFT. However, this quickly
reduces throughput. With 100mhz clock and 100 bin FFT, could theoretically
process a new sample in 100 clocks, so max FFT frequency would be 500kHz, 5khz
bins.

# parallelised serial processing

same idea as the above, but use all the spare logic cells for duplicating the 
complex multiplies. 
1 bin squared output requires 1485 cells, uses 3 BRAMS for 2 * 127 * 8bit table

Each additional complex multiply/accumulate takes around 400 cells
So on an 8k device, reserving 500 cells for the serial logic, there will be
about 6000 cells left, to make 16 MAs in total.

So with 128 bins, we can process all the data in 8 cycles. At 100Mhz, we are
then at about 10MHz throughput, or max frequency bin is 5Mhz, with each bin
representing 40khz.

# post PNR usage figures for parallel design

1k has 1280 logic cells, and 64kbit bram
8k has 7680 locic cells, and 128kbit bram

## serial processing

16 * 20 bit bins
2 * 16 * 16 bit coeffs
16 * 8 bit sample history
8 bit sample width

After packing:
IOs          18 / 206
GBs          0 / 8
  GB_IOs     0 / 8
LCs          4773 / 7680
  DFF        762
  CARRY      444
  CARRY, DFF 42
  DFF PASS   692
  CARRY PASS 41
BRAMs        5 / 32
WARMBOOTs    0 / 1
PLLs         1 / 2

timing estimate 18Mhz

Tried pipelining the multiplies for the bram write in top. Makes no difference to timing estimate.
Tried pipelining the multiplies in the sdft loop, also made no difference to timing estimate.

## complex output

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
output is just 16 * bins.imag (no module)

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          7579 / 1280
  DFF        99
  CARRY      800
  CARRY, DFF 248
  DFF PASS   31
  CARRY PASS 68
BRAMs        1 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

# squared output

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with squared output

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          15646 / 1280
  DFF        100
  CARRY      1027
  CARRY, DFF 265
  DFF PASS   31
  CARRY PASS 65
BRAMs        1 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

# 4 bin squared output

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with squared output but only for 4 bins

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          7579 / 1280
  DFF        99
  CARRY      800
  CARRY, DFF 248
  DFF PASS   31
  CARRY PASS 68
BRAMs        1 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

# 8 bin squared output

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with squared output but only for 8 bins

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          7708 / 1280
  DFF        67
  CARRY      562
  CARRY, DFF 154
  DFF PASS   31
  CARRY PASS 43
BRAMs        1 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

# 1 bin squared output

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with squared output but only for 1 bins

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          1034 / 1280
  DFF        42
  CARRY      150
  CARRY, DFF 42
  DFF PASS   27
  CARRY PASS 23
BRAMs        0 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

# 1 bin squared output

16 * 16 bit bins
2 * 16 * 8 bit coeffs
16 * 8 bit sample history
with squared output but only for 1 bins
bram for coeffs

After packing:
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          1485 / 1280
  DFF        308
  CARRY      141
  CARRY, DFF 26
  DFF PASS   295
  CARRY PASS 23
BRAMs        3 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

## with 2 multiplies for fft and squaring output

IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          2154 / 1280
  DFF        308
  CARRY      174
  CARRY, DFF 26
  DFF PASS   231
  CARRY PASS 25
BRAMs        3 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

## with 4 mulitplies for fft and squaring output
IOs          16 / 96
GBs          0 / 8
  GB_IOs     0 / 8
LCs          3738 / 1280
  DFF        308
  CARRY      262
  CARRY, DFF 26
  DFF PASS   167
  CARRY PASS 28
BRAMs        3 / 16
WARMBOOTs    0 / 1
PLLs         1 / 1

