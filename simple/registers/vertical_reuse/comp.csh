#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 +in\
cdir+../../../integrated/apb blk_run.sv -l comp.log
