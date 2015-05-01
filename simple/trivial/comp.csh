#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +incdir+. -ntb_opts uvm-1.1 component.sv  -l comp.log
