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
// Note that this agent only deals in 32 bit single transfers
//
//
package ahb_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit {AHB_READ, AHB_WRITE} ahb_rw_e;
typedef enum bit[1:0] {AHB_IDLE = 0, AHB_BUSY = 1, AHB_NON_SEQ = 2, AHB_SEQ = 3} trans_e;
typedef enum bit[2:0] {AHB_SINGLE = 0} ahb_burst_e;
typedef enum bit[1:0] {AHB_OKAY = 0, AHB_ERROR = 1, AHB_RETRY = 2, AHB_SPLIT = 3} ahb_resp_e;

`include "ahb_seq_item.svh"
`include "ahb_agent_config.svh"
`include "ahb_driver.svh"
`include "ahb_monitor.svh"
`include "ahb_sequencer.svh"
`include "ahb_agent.svh"

// UVM Register adapter
`include "reg2ahb_adapter.svh"

// Utility Sequences
`include "ahb_seq.svh"
`include "ahb_write_seq.svh"
`include "ahb_read_seq.svh"

endpackage: ahb_agent_pkg
