//------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
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
//
// Class Description:
//
//
class ahb_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_agent)

//------------------------------------------
// Data Members
//------------------------------------------
ahb_agent_config m_cfg;
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(ahb_seq_item) ap;
ahb_monitor   m_monitor;
ahb_sequencer m_sequencer;
ahb_driver    m_driver;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: ahb_agent


function ahb_agent::new(string name = "ahb_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void ahb_agent::build_phase(uvm_phase phase);
  uvm_object tmp;

  // Get the agent configuration object
  if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg)) begin
    `uvm_error("build:", "get config for \"ahb_agent_config\" failed - check lookup string or set_config")
  end

  // Monitor is always present
  m_monitor = ahb_monitor::type_id::create("m_monitor", this);
  // Only build the driver and sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver = ahb_driver::type_id::create("m_driver", this);
    m_sequencer = ahb_sequencer::type_id::create("m_sequencer", this);
  end
endfunction: build_phase

function void ahb_agent::connect_phase(uvm_phase phase);
  m_monitor.AHB = m_cfg.AHB;
  ap = m_monitor.ap;
  // Only connect the driver and the sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.AHB = m_cfg.AHB;
  end
endfunction: connect_phase

