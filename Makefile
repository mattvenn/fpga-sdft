DEVICE = hx1k
SRC_DIR = hdl
TEST_DIR = tests
DOCS_DIR = docs
BUILD_DIR = build
PROJ = $(BUILD_DIR)/fft
PIN_DEF = $(SRC_DIR)/icestick.pcf
SHELL := /bin/bash # Use bash syntax
ICESTORM_DIR = ~/.apio/packages/toolchain-icestorm/bin/

MODULES = sdft.v VgaSyncGen.v twiddle_rom.v
VERILOG = top.v $(MODULES)
SRC = $(addprefix $(SRC_DIR)/, $(VERILOG))

all: $(BUILD_DIR)/twiddle_imag.list $(PROJ).bin $(PROJ).rpt 

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites

# rules for building the blif file
$(BUILD_DIR)/%.blif: $(SRC)
	$(ICESTORM_DIR)/yosys -p "synth_ice40 -top top -blif $@" $^ | tee $(BUILD_DIR)/build.log

# asc
$(BUILD_DIR)/%.asc: $(PIN_DEF) $(BUILD_DIR)/%.blif
	#arachne-pnr --device 8k --package tq144:4k -o $@ -p $^
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

# bin, for programming
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.asc
	icepack $< $@

# timing
$(BUILD_DIR)/%.rpt: $(BUILD_DIR)/%.asc
	icetime -d $(DEVICE) -mtr $@ $<

# rules for simple tests with one verilog module per test bench
$(BUILD_DIR)/%.out: $(TEST_DIR)/%_tb.v $(SRC_DIR)/twiddle_rom.v $(SRC_DIR)/%.v
	iverilog -o $(basename $@).out $^

$(BUILD_DIR)/%.vcd: $(BUILD_DIR)/%.out 
	vvp $< # -fst
	mv test.vcd $@

prog: $(PROJ).bin
	iceprog $<

$(BUILD_DIR)/twiddle_imag.list: python/gen_twiddle.py
	cd hdl; ../python/gen_twiddle.py

debug-%: $(BUILD_DIR)/%.vcd $(TEST_DIR)/gtk-%.gtkw
	gtkwave $^

debug-complex:
	iverilog -o $(BUILD_DIR)/test $(TEST_DIR)/complex_tb.v
	vvp $(BUILD_DIR)/test -fst
	mv test.vcd $(BUILD_DIR)/
	gtkwave $(BUILD_DIR)/test.vcd $(TEST_DIR)/gtk-complex.gtkw

show-%: $(SRC_DIR)/%.v
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

#clean:
#	rm -f $(BUILD_DIR)/*

.SECONDARY: // needed or make will remove useful intermediate files
.PHONY: all prog clean 

