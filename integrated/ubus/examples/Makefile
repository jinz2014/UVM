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

	vcs -sverilog -timescale=1ns/1ns +acc +vpi -ntb_opts uvm-1.1 +incdir+../sv ubus_tb_top.sv -l comp.log

run:
	./simv +UVM_NO_RELNOTES -l simv.log +UVM_TESTNAME=test_2m_4s 

clean: 
	rm -rf csrc simv* vc_hdrs.h ucli.key urg* *.log
