
RTL ?= ../../../rtl
AGENTS ?= ../../../agents
TAR_PATH ?= ../../../../

all: work build run

tarball: clean tar

work:
	vlib work
build:
	vlog +incdir+$(RTL)/spi/rtl/verilog $(RTL)/spi/rtl/verilog/*.v +acc
	vlog +incdir+$(AGENTS)/apb_agent $(AGENTS)/apb_agent/apb_agent_pkg.sv
	vlog +incdir+$(AGENTS)/spi_agent $(AGENTS)/spi_agent/spi_agent_pkg.sv
	vlog +incdir+../uvm_register_model ../uvm_register_model/spi_reg_pkg.sv
	vlog $(AGENTS)/apb_agent/apb_if.sv -timescale 1ns/10ps
	vlog $(AGENTS)/spi_agent/spi_if.sv -timescale 1ns/10ps
	vlog ../tb/intr_if.sv -timescale 1ns/10ps
	vlog +incdir+../env ../env/spi_env_pkg.sv
	vlog +incdir+../sequences ../sequences/spi_bus_sequence_lib_pkg.sv
	vlog +incdir+../sequences ../sequences/spi_sequence_lib_pkg.sv
	vlog +incdir+../sequences ../sequences/spi_virtual_seq_lib_pkg.sv
	vlog +incdir+../test ../test/spi_test_lib_pkg.sv
	vlog -timescale 1ns/10ps +incdir+$(RTL)/spi/rtl/verilog ../tb/top_tb.sv

run:
	vsim -novopt -c -do "run -all" top_tb +UVM_TESTNAME=spi_reg_test 

clean:
	@rm -rf work transcript *~ vsim.wlf *.log *.tgz

tar:
	@(cd $(TAR_PATH);\
	tar -zcf tb_build/block_level_tbs/spi_tb/sim/uvm_spi_bl_reg_tb.tgz\
	tb_build/agents/apb_agent\
	tb_build/agents/spi_agent\
	tb_build/rtl/spi\
	tb_build/block_level_tbs/spi_tb/env\
	tb_build/block_level_tbs/spi_tb/test\
	tb_build/block_level_tbs/spi_tb/sequences\
	tb_build/block_level_tbs/spi_tb/tb\
	tb_build/block_level_tbs/spi_tb/uvm_register_model\
	tb_build/block_level_tbs/spi_tb/sim/Makefile\
	tb_build/block_level_tbs/spi_tb/sim/README.txt)
