#!/bin/csh -f

./simv +UVM_NO_RELNOTES +UVM_TESTNAME=test_read_modify_write +UVM_TR_RECORD +UVM_LOG_RECORD -l run.log
