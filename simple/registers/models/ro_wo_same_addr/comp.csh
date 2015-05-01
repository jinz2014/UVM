#!/bin/csh -f
ralgen -uvm -t B ro_wo.ralf
vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 +incdir+../../common tb_run.sv -l comp.log +define+RALGEN
