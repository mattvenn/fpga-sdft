PACKAGE = ct256
DEVICE = hx8k
SRC_DIR = hdl
TEST_DIR = tests
DOCS_DIR = docs
BUILD_DIR = build
PROJ = $(BUILD_DIR)/fft
PIN_DEF = $(SRC_DIR)/8k.pcf
SHELL := /bin/bash # Use bash syntax
ICESTORM_DIR = ~/.apio/packages/toolchain-icestorm/bin/
ICESTORM_DIR = /usr/bin/

MODULES = sdft.v VgaSyncGen.v twiddle_rom.v  freq_bram.v # complex_mult.v
LIST = twiddle_imag.list twiddle_real.list freq_bram.list
VERILOG = top.v $(MODULES)
SRC = $(addprefix $(SRC_DIR)/, $(VERILOG))
LISTS = $(addprefix $(SRC_DIR)/, $(LIST))

all: $(PROJ).bin $(PROJ).rpt 

# fft configuration in localparams.vh
PARAMS = $(TEST_DIR)/localparams.vh

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites

# rules for building the blif file
$(BUILD_DIR)/%.blif: $(SRC)
	$(ICESTORM_DIR)/yosys -p "synth_ice40 -top top -blif $@" $^ | tee $(BUILD_DIR)/build.log

# asc
$(BUILD_DIR)/%.asc: $(PIN_DEF) $(BUILD_DIR)/%.blif
	arachne-pnr --device 8k --package $(PACKAGE) -p $^ -o $@
	#arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

# bin, for programming
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.asc
	icepack $< $@

# timing
$(BUILD_DIR)/%.rpt: $(BUILD_DIR)/%.asc
	icetime -d $(DEVICE) -mtr $@ $<

# rules for simple tests with one verilog module per test bench
$(BUILD_DIR)/%.out: $(TEST_DIR)/%_tb.v $(SRC)
	iverilog -o $(basename $@).out $^

$(BUILD_DIR)/%.vcd: $(BUILD_DIR)/%.out 
	vvp $< # -fst
	mv test.vcd $@

prog: $(PROJ).bin
	iceprog $<

list:
	cd hdl; ../python/gen_twiddle.py ../$(PARAMS)

debug-%: $(BUILD_DIR)/%.vcd $(TEST_DIR)/gtk-%.gtkw $(PARAMS)
	gtkwave $^

read_sdft_vcd:
	cd python; python read_vcd.py ../build/sdft.vcd ../$(PARAMS)

read_top_vcd:
	cd python; python read_vcd.py ../build/top.vcd ../$(PARAMS)

show-%: $(SRC_DIR)/%.v
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

clean:
	rm -f $(BUILD_DIR)/*
#	rm -f $(SRC_DIR)/*list

#secondary needed or make will remove useful intermediate files
.SECONDARY:
.PHONY: all prog clean 

