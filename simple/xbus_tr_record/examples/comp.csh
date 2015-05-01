#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -debug_all +define+UVM_TR_RECORD -ntb_opts uvm-1.1 +incdir+../sv xbus_tb_top.sv -l comp.log -lca
