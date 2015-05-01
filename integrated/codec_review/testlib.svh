// 
// -------------------------------------------------------------
//    Copyright 2011 Synopsys, Inc.
//    Copyright 2010-2011 Mentor Graphics Corporation
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

class run_uvm_reg_seq extends test;
   `uvm_component_utils(run_uvm_reg_seq)

   class null_task_phase extends uvm_configure_phase;
      function new(string name);
         super.new(name);
      endfunction
      virtual task exec_task(uvm_component comp, uvm_phase phase);
         // Do nothing
      endtask
   endclass

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

   task pre_configure_phase(uvm_phase phase);
      null_task_phase ph = new("null_task_phase");
      env.set_phase_imp(uvm_configure_phase::get(), ph);
   endtask
   
   task configure_phase(uvm_phase phase);
      string seqname;
      uvm_reg_sequence seq;

      begin
         uvm_cmdline_processor cmd = uvm_cmdline_processor::get_inst();
         if (cmd.get_arg_value("+uvm_reg_seq=", seqname) == 0) begin
            `uvm_fatal("NOSEQ", "No pre-defined UVM register sequence specified using the +uvm_reg_seq= command-line option");
         end
      end
      begin
         uvm_object obj;
         obj = create_object(seqname, "seq");
         if (obj == null) begin
            `uvm_fatal("UNKNSEQ", {"Unknown pre-defined UVM register sequence \"",
                                   seqname, "\"."})
         end
         if (!$cast(seq, obj)) begin
            `uvm_fatal("BADSEQ", {"Invalid pre-defined UVM register sequence \"",
                                  seqname, "\"."})
         end
      end
      seq.model = env.regmodel;

      uvm_resource_db#(bit)::set({"REG::", env.regmodel.TxRx.get_full_name()},
                                 "NO_REG_BIT_BASH_TEST", 1, this);

      phase.raise_objection(this, "Running pre-defined register sequence");
      seq.start(null);
      phase.drop_objection(this);

      phase.jump(uvm_report_phase::get());
   endtask
   
endclass


class hw_reset_test extends test;

   `uvm_component_utils(hw_reset_test)

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

   local bit once = 1;
   task main_phase(uvm_phase phase);
      if (once) begin
         once = 0;
         phase.raise_objection(this);
         repeat (100 * 8) @(posedge env.vif.sclk);
         // This will clear the objection
         `uvm_info("TEST", "Jumping back to reset phase", UVM_NONE);
         phase.jump(uvm_reset_phase::get());
      end
   endtask
   
endclass
