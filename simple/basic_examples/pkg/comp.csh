#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +incdir+. test.sv -ntb_opts uvm-1.1 -l comp.log
