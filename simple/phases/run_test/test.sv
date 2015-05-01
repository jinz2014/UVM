
//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------



//Begindoc: phases/run_test
//
//This test case will test a hierarchy contains mix of uvm_components,  uvm_threaded_components, and envs.
//
//
//
//
//To get detailed information about the uvm_components, uvm_components, uvm_phases and uvm_env.You may check the following files:
//	- uvm/src/base/uvm_phases.sv
//	- uvm/src/base/uvm_component.sv
//	- uvm/src/base/uvm_component.svh
//	- uvm/src/methodology/uvm_test.svh
//
//
//Walk through the test:
//the main idea is to create a topology of components which had no run phase, and threads which had a run phase, and through the run phase of the top 
//uvm_env ensure phasing is correct.
//
//at the top module level the env will use the run_test mode.
//


//`include "uvm_macros.svh"
import uvm_pkg::*;
`include "top.sv"
`include "env.sv"

module test;

  env t_env = new("env", null);

  initial begin
    //Randomize all of the delays
    void'(t_env.randomize());
    run_test();
  end

endmodule
