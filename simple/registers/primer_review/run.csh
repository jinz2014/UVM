#!/bin/csh -f

./simv +UVM_NO_RELNOTES +UVM_TESTNAME=cmdline_test +UVM_REG_SEQ=uvm_reg_hw_reset_seq -l ru\
n.log

simv  +UVM_TESTNAME=cmdline_test +UVM_REG_SEQ=user_test_seq -l run_cmdline.log
