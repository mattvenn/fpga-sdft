DEVICE = hx1k
SRC_DIR = hdl
TEST_DIR = tests
DOCS_DIR = docs
BUILD_DIR = build
PROJ = $(BUILD_DIR)/fft
PIN_DEF = $(SRC_DIR)/icestick.pcf
SHELL := /bin/bash # Use bash syntax

MODULES = twiddle_rom.v, sdft.v
VERILOG = top.v $(MODULES)
SRC = $(addprefix $(SRC_DIR)/, $(VERILOG))

all: $(PROJ).bin $(PROJ).rpt $(BUILD_DIR)/twiddle_imag.list

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites

# rules for building the blif file
$(BUILD_DIR)/%.blif: $(SRC)
	yosys -p "synth_ice40 -top top -blif $@" $^

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
	vvp $< -fst
	mv test.vcd $@

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

clean:
	rm -f $(BUILD_DIR)/*
	rm -f $(SVG_DIR)/*svg
	rm -f $(SVG_PORT_DIR)/*svg

.SECONDARY:

