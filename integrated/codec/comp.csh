#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +acc +vpi -ntb_opts uvm-1.1 +incdir+../apb+vip tb_top.sv test.sv -l comp.log
