RTL ?= ../dut
AGENTS ?= ../agents
TAR_PATH ?= ../../

all: work build sim

tarball: clean tar

work:
	vlib work

build:
	vlog +incdir+$(RTL) $(RTL)/*.sv +acc
	vlog +incdir+$(AGENTS)/ahb_agent $(AGENTS)/ahb_agent/ahb_agent_pkg.sv
	vlog +incdir+../register_model ../register_model/mem_ss_reg_pkg.sv
	vlog $(AGENTS)/ahb_agent/ahb_if.sv -timescale 1ns/10ps
	vlog +incdir+../env ../env/mem_ss_env_pkg.sv
	vlog +incdir+../sequences ../sequences/mem_ss_seq_lib_pkg.sv
	vlog +incdir+../test ../test/mem_ss_test_lib_pkg.sv
	vlog -timescale 1ns/10ps ../tb/top_tb.sv

sim:
	vsim -c -do "run -all" top_tb +UVM_TESTNAME=mem_ss_test

clean:
	@rm -rf work transcript *~ vsim.wlf *.log *.tgz

tar:
	@(cd $(TAR_PATH);\
	tar zcf mem_example/sim/uvm_mem_example.tgz\
	mem_example/dut\
	mem_example/agents\
	mem_example/env\
	mem_example/test\
	mem_example/sequences\
	mem_example/tb\
	mem_example/register_model\
	mem_example/sim/Makefile\
	mem_example/sim/README.txt)
