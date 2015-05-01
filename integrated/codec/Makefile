## 
## -------------------------------------------------------------
##    Copyright 2010-2011 Synopsys, Inc.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
## 



all: clean comp run

comp:
	vcs -sverilog -timescale=1ns/1ns +acc +vpi -ntb_opts uvm-1.1 +incdir+../apb+vip tb_top.sv test.sv -l comp.log

run: uvm_reg_hw_reset uvm_reg_bit_bash \
	test \
	hw_reset_test

test:
	simv +UVM_NO_RELNOTES -l simv.log 

uvm_reg_hw_reset:
	simv +UVM_NO_RELNOTES -l simv_uvm_reg_h_reset.log +UVM_TESTNAME=run_uvm_reg_seq +uvm_reg_seq=uvm_reg_hw_reset_seq 


uvm_reg_bit_bash:
	simv +UVM_NO_RELNOTES -l simv_uvm_reg_bit_bash.log +UVM_TESTNAME=run_uvm_reg_seq +uvm_reg_seq=uvm_reg_bit_bash_seq 


hw_reset hw_reset_test:
	 simv +UVM_NO_RELNOTES -l simv_hw_reset_test.log +UVM_TESTNAME=hw_reset_test 

clean: 
	rm -rf csrc simv* vc_hdrs.h ucli.key urg* *.log
