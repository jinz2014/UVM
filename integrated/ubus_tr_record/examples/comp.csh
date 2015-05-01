#!/bin/csh -f

vcs -lca -sverilog -timescale=1ns/1ns +define+UVM_TR_RECORD -debug_all -ntb_opts uvm-1.1 +incdir+../sv ubus_tb_top.sv -l comp.log
