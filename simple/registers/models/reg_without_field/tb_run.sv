// 
// -------------------------------------------------------------
//    Copyright 2004-2011 Synopsys, Inc.
//    Copyright 2010 Mentor Graphics Corporation
//    Copyright 2010-2011 Cadence Design Systems, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 

`include "uvm_pkg.sv"

program tb;

import uvm_pkg::*;

`include "regmodel.sv"
`include "tb_env.sv"


class tb_test extends uvm_test;

   function new(string name = "tb_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   
   virtual task run_phase(uvm_phase phase);
      tb_env env;
      uvm_status_e status;
      uvm_reg_data_t dat;

      phase.raise_objection(this);
      
      if (!$cast(env, uvm_top.find("env")) || env == null) begin
         `uvm_fatal("test", "Cannot find tb_env");
      end

      // reset test
      env.regmodel.R.reset();
      env.regmodel.R.read(status, dat);
      if (dat != 8'h00) `uvm_error("Test", $sformatf("R is not as expected after reset: 'h%0h instead of 'h00", dat));

      // write-then-read test
      `uvm_info("Test", "write(status, 8'hFF");
      env.regmodel.R.write(status, 8'hFF);

      env.regmodel.R.read(status, dat);
      if (dat != 8'hFF) `uvm_error("Test", $sformatf("R is not as expected (R.read) after write: 'h%0h instead of 'hFF", dat));

      dat = env.regmodel.R.get();
      if (dat != 8'hFF) `uvm_error("Test", $sformatf("R is not as expected (R.get) after write: 'h%0h instead of 'hFF", dat));

      /* randomize test
      A register model can specify constraints on field values. You can add
      additional constraints by extending the field, register, register file, or block abstraction class and
      substituting it in the register model using the factory or by using randomize() with {} when randomizing a field,
      register, register file, or block.
      When constraining a field value, the class property to be constrained is
      named value. This is not the class property that is eventually mirrored or updated and used by the get()
      and set() methods; it cannot be used for purposes other than random constraints.
      ok = regmodel.r1.randomize() with { f1.value <=‘hF; };
      Once randomized, the selected field values in a register or block may
      be automatically uploaded to the DUT
      by using the uvm_reg::update() or uvm_reg_block::update() method. This
      will upload any randomized value that is different from the current mirrored value to
      the DUT. If you override the post_randomize() method of a field abstraction class, you must call
      super.post_randomize() to ensure the randomized value is properly set into the mirror.
      You can relax constraints specified in a register model by turning the corresponding constraint block OFF.
      regmodel.r1.consistency.constraint_mode(0); */

     // set desired value
      void'(env.regmodel.randomize() with { R.value == 8'hA5; });

      // get desired value
      dat = env.regmodel.R.get();
      if (dat != 8'hA5) `uvm_error("Test", $sformatf("R is not as expected after randomize: 'h%0h instead of 'hA5", dat));

      // read mirrored value (8'hFF)
      env.regmodel.R.read(status, dat);
      if (dat != 8'hA5) `uvm_error("Test", $sformatf("R is not as expected after randomize: 'h%0h instead of 'hA5", dat));
            
      phase.drop_objection(this);
   endtask
endclass


initial begin
   static tb_env env = new("env");
   static tb_test test = new("test");
   
   uvm_report_server svr;
   svr = _global_reporter.get_report_server();
   svr.set_max_quit_count(10);
   run_test();
end

endprogram
