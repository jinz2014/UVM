#!/bin/csh -f
vcs -sverilog -timescale=1ns/1ns +acc +vpi +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm.sv ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS +incdir+../sv \
	ubus_tb_top.sv
