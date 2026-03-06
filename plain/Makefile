# Makefile
TOP =  top
VERILATOR = verilator 
VFLAGS = --sv --cc --exe --build --binary --timing -j 0 --top-module $(TOP) -Iverif --converge-limit 1000000 -DVL_DEBUG 
SRCS = src/4_bit_adder.v \
       verif/Interface.sv \
       verif/Transaction.sv \
       verif/Generator.sv \
       verif/Driver.sv \
       verif/Monitor.sv \
       verif/ScoreBoard.sv \
       verif/Environment.sv \
       verif/tb_main.sv \
       verif/top.sv \

      


all: $(TOP)
	./obj_dir/V$(TOP)

# all: $(TOP)
# 	./obj_dir/V$(TOP) +verilator+seed+$(shell date +%s)

$(TOP): $(SRCS)
	$(VERILATOR) $(VFLAGS) $(SRCS) --main

clean:
	rm -rf obj_dir