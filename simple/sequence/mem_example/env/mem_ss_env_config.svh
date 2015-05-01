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
//
class mem_ss_env_config extends uvm_object;

`uvm_object_utils(mem_ss_env_config)

// Register model handle
mem_ss_reg_block mem_ss_rm;

bit has_ahb_agent = 1;

// AHB agent config object handle
ahb_agent_config m_ahb_agent_cfg;

function new(string name = "mem_ss_env_config");
  super.new(name);
endfunction

endclass: mem_ss_env_config
