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
class spi_sequencer extends uvm_sequencer #(spi_seq_item, spi_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(spi_sequencer)

// Standard UVM Methods:
extern function new(string name="spi_sequencer", uvm_component parent = null);

endclass: spi_sequencer

function spi_sequencer::new(string name="spi_sequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction
