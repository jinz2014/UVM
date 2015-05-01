#!/bin/csh -f

simv +UVM_NO_RELNOTES -l simv_uvm-1.1_reg_h_reset.log +UVM_TESTNAME=run_uvm-1.1_reg_seq +uvm-1.1_reg_seq=uvm-1.1_reg_hw_reset_seq |  sed 's/UVM-[1-9].*/UVM/g'

simv +UVM_NO_RELNOTES -l simv_uvm-1.1_reg_bit_bash.log +UVM_TESTNAME=run_uvm-1.1_reg_seq +uvm-1.1_reg_seq=uvm-1.1_reg_bit_bash_seq |   sed 's/UVM-[1-9].*/UVM/g'

simv +UVM_NO_RELNOTES -l simv_hw_reset_test.log +UVM_TESTNAME=hw_reset_test | sed 's/UVM-[1-9].*/UVM/g'

simv +UVM_NO_RELNOTES -l simv.log | sed 's/UVM-[1-9].*/UVM/g'
