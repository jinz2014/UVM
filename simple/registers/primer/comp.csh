#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 +in\
cdir+../../../integrated/apb tb_top.sv test.sv -l comp.log
