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
package spi_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

//import spi_register_pkg::*;

`include "spi_seq_item.svh"
`include "spi_agent_config.svh"
`include "spi_driver.svh"
`include "spi_monitor.svh"
`include "spi_sequencer.svh"
`include "spi_agent.svh"

// Utility Sequences
`include "spi_seq.svh"

endpackage: spi_agent_pkg
