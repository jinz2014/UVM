//------------------------------------------------------------
//   Copyright 2010-2011 Mentor Graphics Corporation
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
//------------------------------------------------------------

class mem_ss_test extends uvm_test;

`uvm_component_utils(mem_ss_test)

// mem_ss register/memory model
mem_ss_reg_block mem_ss_rm;
// mem_ss env and config object
mem_ss_env_config m_cfg;
mem_ss_env m_env;
// AHB agent config object
ahb_agent_config m_ahb_cfg;

extern function new(string name = "mem_ss_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: mem_ss_test

function mem_ss_test::new(string name = "mem_ss_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void mem_ss_test::build_phase(uvm_phase phase);
  // Register/memory model build
  uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
  mem_ss_rm = mem_ss_reg_block::type_id::create("mem_ss_rm");
  mem_ss_rm.build();
  m_cfg = mem_ss_env_config::type_id::create("m_cfg");
  m_cfg.mem_ss_rm = mem_ss_rm;
  m_ahb_cfg = ahb_agent_config::type_id::create("m_ahb_cfg");
  if(!uvm_config_db #(virtual ahb_if)::get(this, "", "AHB_if", m_ahb_cfg.AHB)) begin
    `uvm_error("RESOURCE_ERROR", "AHB virtual interface not found")
  end
  m_cfg.m_ahb_agent_cfg = m_ahb_cfg;
  uvm_config_db #(mem_ss_env_config)::set(this, "m_env*", "mem_ss_env_config", m_cfg);
  m_env = mem_ss_env::type_id::create("m_env", this);
endfunction: build_phase

task mem_ss_test::run_phase(uvm_phase phase);
  auto_tests auto_seq = auto_tests::type_id::create("auto_tests");
  mem_setup_seq setup = mem_setup_seq::type_id::create("setup");
  mem_1_test_seq mem_1_test = mem_1_test_seq::type_id::create("m_1_test");

  phase.raise_objection(this, "Starting memory sub-system test");
  auto_seq.start(m_env.m_ahb_agent.m_sequencer);
  setup.start(m_env.m_ahb_agent.m_sequencer);
  mem_1_test.start(m_env.m_ahb_agent.m_sequencer);
  phase.drop_objection(this, "Ending memory sub-system test");
endtask: run_phase

function void mem_ss_test::report_phase(uvm_phase phase);
  `uvm_info("** UVM TEST PASSED **", "Memory controller test completed OK", UVM_LOW)
endfunction: report_phase
