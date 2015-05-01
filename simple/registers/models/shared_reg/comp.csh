#!/bin/csh -f
ralgen -uvm -t B shared.ralf
vcs -sverilog -timescale=1ns/1ns +incdir+../../common -ntb_opts uvm-1.1 blk_run.sv -l comp.log +define+RALGEN
