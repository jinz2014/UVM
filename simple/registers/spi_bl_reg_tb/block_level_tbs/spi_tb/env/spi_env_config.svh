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
class spi_env_config extends uvm_object;

// UVM Factory Registration Macro
//
`uvm_object_utils(spi_env_config)

// Interrupt Virtual Interface - used in the wait for interrupt task
//
virtual intr_if INTR;

//------------------------------------------
// Data Members
//------------------------------------------
// Whether env analysis components are used:
bit has_spi_functional_coverage = 1;
bit has_spi_scoreboard = 1;

// Whether the various agents are used:
bit has_apb_agent = 1;
bit has_spi_agent = 1;

// Configurations for the sub_components
apb_agent_config m_apb_agent_cfg;
spi_agent_config m_spi_agent_cfg;

// SPI Register model
spi_reg_block spi_rm;

//------------------------------------------
// Methods
//------------------------------------------
extern task wait_for_interrupt;
extern function bit is_interrupt_cleared;
// Standard UVM Methods:
extern function new(string name = "spi_env_config");

endclass: spi_env_config

function spi_env_config::new(string name = "spi_env_config");
  super.new(name);
endfunction

// This task is a convenience method for sequences waiting for the interrupt
// signal
task spi_env_config::wait_for_interrupt;
  @(posedge INTR.IRQ);
endtask: wait_for_interrupt

// Check that interrupt has cleared:
function bit spi_env_config::is_interrupt_cleared;
  if(INTR.IRQ == 0)
    return 1;
  else
    return 0;
endfunction: is_interrupt_cleared
