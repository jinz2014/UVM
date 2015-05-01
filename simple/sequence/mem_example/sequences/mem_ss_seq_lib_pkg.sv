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
package mem_ss_seq_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import mem_ss_reg_pkg::*;
import mem_ss_env_pkg::*;

class mem_ss_base_seq extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(mem_ss_base_seq)

mem_ss_reg_block mem_ss_rm;
mem_ss_env_config m_cfg;

// Properties used by the various register access methods:
rand  uvm_reg_data_t data; // For passing data
uvm_status_e status;       // Returning access status

function new(string name = "mem_ss_base_seq");
  super.new(name);
endfunction

// Common functionality:
// Getting a handle to the register model
task body;
  if(!uvm_config_db #(mem_ss_env_config)::get(null, get_full_name(), "mem_ss_env_config", m_cfg)) begin
    `uvm_error("body", "Failed to get mem_ss_env_config")
  end
  mem_ss_rm = m_cfg.mem_ss_rm;
endtask: body

endclass: mem_ss_base_seq

// This is a directed test since it involves setting
// the memory access up
class mem_setup_seq extends mem_ss_base_seq;

`uvm_object_utils(mem_setup_seq)

function new(string name = "mem_setup_seq");
  super.new(name);
endfunction

task body;
  super.body;
  mem_ss_rm.mem_1_offset.write(status, 32'hF000_0000, .parent(this));
  mem_ss_rm.mem_1_range.write(status, 32'h2000, .parent(this));
  mem_ss_rm.mem_2_offset.write(status, 32'hA000_0000, .parent(this));
  mem_ss_rm.mem_2_range.write(status, 32'h4000, .parent(this));
  mem_ss_rm.mem_3_offset.write(status, 32'h0001_0000, .parent(this));
  mem_ss_rm.mem_3_range.write(status, 32'h1000, .parent(this));
  // Check initialised
  check(3'b000);
endtask

task check(bit[2:0] val);
  mem_ss_rm.mem_status.read(status, data, .parent(this));
  if(data[2:0] != val) begin
    `uvm_error("mem_setup_seq", $sformatf("Status error: Expected %0b, Actual %0b", val, data[2:0]))
  end
endtask:check


endclass: mem_setup_seq

// This is a directed test since it involves setting
// the memory access up
class mem_setup_with_check_seq extends mem_ss_base_seq;

`uvm_object_utils(mem_setup_with_check_seq)

function new(string name = "mem_setup_with_check_seq");
  super.new(name);
endfunction

task body;
  super.body;
  check(3'b111);
  mem_ss_rm.mem_1_offset.write(status, 32'hF000_0000, .parent(this));
  check(3'b111);
  mem_ss_rm.mem_1_range.write(status, 32'h2000, .parent(this));
  check(3'b110);
  mem_ss_rm.mem_2_offset.write(status, 32'hA000_0000, .parent(this));
  check(3'b110);
  mem_ss_rm.mem_2_range.write(status, 32'h4000, .parent(this));
  check(3'b100);
  mem_ss_rm.mem_3_offset.write(status, 32'h0001_0000, .parent(this));
  check(3'b100);
  mem_ss_rm.mem_3_range.write(status, 32'h1000, .parent(this));
  check(3'b000);
endtask

task check(bit[2:0] val);
  mem_ss_rm.mem_status.read(status, data, .parent(this));
  if(data[2:0] != val) begin
    `uvm_error("mem_setup_seq", $sformatf("Status error: Expected %0b, Actual %0b", val, data[2:0]))
  end
endtask:check


endclass: mem_setup_with_check_seq
// This is a directed test since it involves setting
// the memory access up
class mem_setup_map2_seq extends mem_ss_base_seq;

`uvm_object_utils(mem_setup_map2_seq)

function new(string name = "mem_setup_map2_seq");
  super.new(name);
endfunction

task body;
  super.body;
  check(3'b111);
  mem_ss_rm.mem_1_offset.write(status, 32'hF000_0000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b111);
  mem_ss_rm.mem_1_range.write(status, 32'h2000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b110);
  mem_ss_rm.mem_2_offset.write(status, 32'hA000_0000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b110);
  mem_ss_rm.mem_2_range.write(status, 32'h4000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b100);
  mem_ss_rm.mem_3_offset.write(status, 32'h0001_0000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b100);
  mem_ss_rm.mem_3_range.write(status, 32'h1000, .map(mem_ss_rm.AHB_2_map), .parent(this));
  check(3'b000);
endtask

task check(bit[2:0] val);
  mem_ss_rm.mem_status.read(status, data, .map(mem_ss_rm.AHB_2_map), .parent(this));
  if(data[2:0] != val) begin
    `uvm_error("mem_setup_seq", $sformatf("Status error: Expected %0b, Actual %0b", val, data[2:0]))
  end
endtask:check


endclass: mem_setup_map2_seq


//
// Test of memory 1
//
// Write to 10 random locations within the memory storing the data written
// then read back from the same locations checking against
// the original data
//
class mem_1_test_seq extends mem_ss_base_seq;

`uvm_object_utils(mem_1_test_seq)

rand uvm_reg_addr_t addr;

// Buffers for the addresses and the write data
uvm_reg_addr_t addr_array[10];
uvm_reg_data_t data_array[10];

function new(string name = "mem_1_test_seq");
  super.new(name);
endfunction

// The base sequence sets up the register model handle
task body;
  super.body();
  // Write loop
  for(int i = 0; i < 10; i++) begin
    // Constrain address to be within the memory range:
    if(!this.randomize() with {addr <= mem_ss_rm.mem_1.get_size();}) begin
      `uvm_error("body", "Randomization failed")
    end
    mem_ss_rm.mem_1.write(status, addr, data, .parent(this));
    addr_array[i] = addr;
    data_array[i] = data;
  end
  // Read loop
  for(int i = 0; i < 10; i++) begin
    mem_ss_rm.mem_1.read(status, addr_array[i], data, .parent(this));
    if(data_array[i][31:0] != data[31:0]) begin
      `uvm_error("mem_1_test", $sformatf("Memory access error: expected %0h, actual %0h", data_array[i][31:0], data[31:0]))
    end
  end
endtask: body

endclass: mem_1_test_seq

//
// Auto test of the memory sub-system using the built-in
// automatic sequences:
//
class auto_tests extends mem_ss_base_seq;

`uvm_object_utils(auto_tests)

function new(string name = "auto_tests");
  super.new(name);
endfunction

task body;
  // Register reset test sequence
  uvm_reg_hw_reset_seq rst_seq = uvm_reg_hw_reset_seq::type_id::create("rst_seq");
  // Register bit bash test sequence
  uvm_reg_bit_bash_seq reg_bash = uvm_reg_bit_bash_seq::type_id::create("reg_bash");
  // Initialise the memory mapping registers in the sub-system
  mem_setup_seq setup = mem_setup_seq::type_id::create("setup");
  // Memory walk test sequence
  uvm_mem_walk_seq walk = uvm_mem_walk_seq::type_id::create("walk");

  super.body(); // Gets the register model handle
  // Set the register model handle in the built-in sequences
  rst_seq.model = mem_ss_rm;
  walk.model = mem_ss_rm;
  reg_bash.model = mem_ss_rm;

  // Start the test sequences:
  //
  // Register reset:
  rst_seq.start(m_sequencer);
  // Register bit-bash
  reg_bash.start(m_sequencer);
  // Set up the memory sub-system
  setup.start(m_sequencer);
  // Memory walk test
  walk.start(m_sequencer);

endtask: body

endclass: auto_tests

endpackage: mem_ss_seq_lib_pkg
