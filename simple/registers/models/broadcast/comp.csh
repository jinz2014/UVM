#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 +incdir+../../../../integrated/apb tb_run.sv -debug_all -l comp.log
