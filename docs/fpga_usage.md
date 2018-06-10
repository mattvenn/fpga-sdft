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

===================================

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with modulo output

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

===================================

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with modulo output but only for 4 bins

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

===================================

16 * 16 bit bins,
2 * 16 * 16 bit coeffs
16 * 16 bit sample history
with modulo output but only for 8 bins

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

