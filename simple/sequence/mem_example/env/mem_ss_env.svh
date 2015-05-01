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

class mem_ss_env extends uvm_env;

`uvm_component_utils(mem_ss_env)

// AHB agent
ahb_agent m_ahb_agent;
// Register layering adapter:
reg2ahb_adapter reg2ahb;
// Register predictor:
uvm_reg_predictor #(ahb_seq_item) ahb2reg_predictor;
uvm_reg_predictor #(ahb_seq_item) ahb2reg_predictor_2;


// mem_ss_env configuration
mem_ss_env_config m_cfg;

extern function new(string name = "mem_ss_env", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: mem_ss_env

function mem_ss_env::new(string name = "mem_ss_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void mem_ss_env::build_phase(uvm_phase phase);
  if(!uvm_config_db #(mem_ss_env_config)::get(this, "", "mem_ss_env_config", m_cfg)) begin
    `uvm_error("build_phase", "unable to get mem_ss_env_config")
  end
  if(m_cfg.has_ahb_agent == 1) begin
    uvm_config_db #(ahb_agent_config)::set(this, "m_ahb_agent*", "ahb_agent_config", m_cfg.m_ahb_agent_cfg);
    m_ahb_agent = ahb_agent::type_id::create("m_ahb_agent", this);
    ahb2reg_predictor = uvm_reg_predictor #(ahb_seq_item)::type_id::create("ahb2reg_predictor", this);
    ahb2reg_predictor_2 = uvm_reg_predictor#(ahb_seq_item)::type_id::create("ahb2reg_predictor_2", this);
    reg2ahb = reg2ahb_adapter::type_id::create("reg2ahb");
  end
endfunction: build_phase

function void mem_ss_env::connect_phase(uvm_phase phase);
  if(m_cfg.has_ahb_agent == 1) begin
    uvm_resource_db #(ahb_sequencer)::set("*", "AHB", m_ahb_agent.m_sequencer);
    if(m_cfg.mem_ss_rm.get_parent() == null) begin
      m_cfg.mem_ss_rm.AHB_map.set_sequencer(m_ahb_agent.m_sequencer, reg2ahb);
      m_cfg.mem_ss_rm.AHB_2_map.set_sequencer(m_ahb_agent.m_sequencer, reg2ahb);
    end
    ahb2reg_predictor.map = m_cfg.mem_ss_rm.AHB_map;
    ahb2reg_predictor.adapter = reg2ahb;
    m_cfg.mem_ss_rm.AHB_map.set_auto_predict(0);
    m_ahb_agent.ap.connect(ahb2reg_predictor.bus_in);
    // Predictor for the second map:
    ahb2reg_predictor_2.map = m_cfg.mem_ss_rm.AHB_2_map;
    ahb2reg_predictor_2.adapter = reg2ahb;
    m_cfg.mem_ss_rm.AHB_2_map.set_auto_predict(0);
    m_ahb_agent.ap.connect(ahb2reg_predictor_2.bus_in);
  end
endfunction: connect_phase
