# Makefile
TOP = top
VERILATOR = verilator
UVM_SRC = vendor/uvm/src

VFLAGS = --sv --cc --exe --build --binary --timing -j 0 \
         --top-module $(TOP) \
         -I$(UVM_SRC) \
         -Iverif \
         --converge-limit 1000000 \
         +define+UVM_NO_DPI \
         -Wno-fatal \
         --timescale 1ns/1ps

SRCS = $(UVM_SRC)/uvm_pkg.sv \
       src/4_bit_adder.v \
       verif/uvm_if.sv \
       verif/test_pkg.sv \
       verif/top.sv \

      


all: build run

build: $(SRCS)
	$(VERILATOR) $(VFLAGS) $(SRCS) --main

run:
	./obj_dir/V$(TOP)

# run with random seed:
# 	./obj_dir/V$(TOP) +verilator+seed+$(shell date +%s)

clean:
	rm -rf obj_dir