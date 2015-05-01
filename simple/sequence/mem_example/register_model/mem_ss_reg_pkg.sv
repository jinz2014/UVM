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
package mem_ss_reg_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// Offset register
class mem_offset_reg extends uvm_reg;

`uvm_object_utils(mem_offset_reg)

rand uvm_reg_field F;

function new(string name = "mem_offset_reg");
  super.new(name, 31, UVM_NO_COVERAGE);
endfunction

function void build();
  F = uvm_reg_field::type_id::create("F");
  F.configure(this, 31, 0, "RW", 1, 31'h00000000, 1, 1, 0);
endfunction: build

endclass: mem_offset_reg

// Range register
class mem_range_reg extends uvm_reg;

`uvm_object_utils(mem_range_reg)

rand uvm_reg_field F;

function new(string name = "mem_range_reg");
  super.new(name, 16, UVM_NO_COVERAGE);
endfunction

function void build();
  F = uvm_reg_field::type_id::create("F");
  F.configure(this, 16, 0, "RW", 1, 16'h0, 1, 1, 0);
endfunction: build

endclass: mem_range_reg

// Status register
class mem_status_reg extends uvm_reg;

`uvm_object_utils(mem_status_reg)

rand uvm_reg_field F;

function new(string name = "mem_status_reg");
  super.new(name, 3, UVM_NO_COVERAGE);
endfunction

function void build();
  F = uvm_reg_field::type_id::create("F");
  F.configure(this, 3, 0, "RO", 1, 3'h7, 1, 1, 0);
endfunction: build

endclass: mem_status_reg

// Memory array 1 - Size 32'h800;
class mem_1_model extends uvm_mem;

`uvm_object_utils(mem_1_model)

function new(string name = "mem_1_model");
  super.new(name, 32'h800, 32, "RW", UVM_NO_COVERAGE);
endfunction

endclass: mem_1_model

// Memory array 2 - Size 32'h1000;
class mem_2_model extends uvm_mem;

`uvm_object_utils(mem_2_model)

function new(string name = "mem_2_model");
  super.new(name, 32'h1000, 32, "RW", UVM_NO_COVERAGE);
endfunction

endclass: mem_2_model

// Memory array 3 - Size 32'h400;
class mem_3_model extends uvm_mem;

`uvm_object_utils(mem_3_model)

function new(string name = "mem_3_model");
  super.new(name, 32'h400, 32, "RW", UVM_NO_COVERAGE);
endfunction

endclass: mem_3_model

//
// Memory Sub-System (mem_ss) block
//
class mem_ss_reg_block extends uvm_reg_block;

`uvm_object_utils(mem_ss_reg_block)

function new(string name = "mem_ss_reg_block");
  super.new(name, build_coverage(UVM_CVR_ADDR_MAP));
endfunction

// Mem array configuration registers
rand mem_offset_reg mem_1_offset;
rand mem_range_reg mem_1_range;
rand mem_offset_reg mem_2_offset;
rand mem_range_reg mem_2_range;
rand mem_offset_reg mem_3_offset;
rand mem_range_reg mem_3_range;
rand mem_status_reg mem_status;

// Memories
rand mem_1_model mem_1;
rand mem_2_model mem_2;
rand mem_3_model mem_3;

// Maps
uvm_reg_map AHB_map;
uvm_reg_map AHB_2_map;

function void build();
  mem_1_offset = mem_offset_reg::type_id::create("mem_1_offset");
  mem_1_offset.configure(this, null, "");
  mem_1_offset.build();  
  mem_1_range = mem_range_reg::type_id::create("mem_1_range");
  mem_1_range.configure(this, null, "");
  mem_1_range.build();  
  mem_2_offset = mem_offset_reg::type_id::create("mem_2_offset");
  mem_2_offset.configure(this, null, "");
  mem_2_offset.build();  
  mem_2_range = mem_range_reg::type_id::create("mem_2_range");
  mem_2_range.configure(this, null, "");
  mem_2_range.build();  
  mem_3_offset = mem_offset_reg::type_id::create("mem_3_offset");
  mem_3_offset.configure(this, null, "");
  mem_3_offset.build();  
  mem_3_range = mem_range_reg::type_id::create("mem_3_range");
  mem_3_range.configure(this, null, "");
  mem_3_range.build();  
  mem_status = mem_status_reg::type_id::create("mem_status");
  mem_status.configure(this, null, "");
  mem_status.build();  
  mem_1 = mem_1_model::type_id::create("mem_1");
  mem_1.configure(this, "");
  mem_2 = mem_2_model::type_id::create("mem_2");
  mem_2.configure(this, "");
  mem_3 = mem_3_model::type_id::create("mem_3");
  mem_3.configure(this, "");
  // Create maps:
  AHB_map = create_map("AHB_map", 'h0, 4, UVM_LITTLE_ENDIAN, 1);
  AHB_2_map = create_map("AHB_2_map", 'h0, 4, UVM_LITTLE_ENDIAN, 1);
  // Add memories and registers to the AHB_map
  AHB_map.add_reg(mem_1_offset, 32'h00000000, "RW");
  AHB_map.add_reg(mem_1_range, 32'h00000004, "RW");
  AHB_map.add_reg(mem_2_offset, 32'h00000008, "RW");
  AHB_map.add_reg(mem_2_range, 32'h0000000c, "RW");
  AHB_map.add_reg(mem_3_offset, 32'h00000010, "RW");
  AHB_map.add_reg(mem_3_range, 32'h00000014, "RW");
  AHB_map.add_reg(mem_status, 32'h00000018, "RO");
  AHB_map.add_mem(mem_1, 32'hF000_0000, "RW");
  AHB_map.add_mem(mem_2, 32'hA000_0000, "RW");
  AHB_map.add_mem(mem_3, 32'h0001_0000, "RW");
  // Add memories and registers to the AHB_2_map
  AHB_2_map.add_reg(mem_1_offset, 32'h8000_0000, "RW");
  AHB_2_map.add_reg(mem_1_range, 32'h8000_0004, "RW");
  AHB_2_map.add_reg(mem_2_offset, 32'h8000_0008, "RW");
  AHB_2_map.add_reg(mem_2_range, 32'h8000_000c, "RW");
  AHB_2_map.add_reg(mem_3_offset, 32'h8000_0010, "RW");
  AHB_2_map.add_reg(mem_3_range, 32'h8000_0014, "RW");
  AHB_2_map.add_reg(mem_status, 32'h8000_0018, "RO");
  AHB_2_map.add_mem(mem_1, 32'h7000_0000, "RW");
  AHB_2_map.add_mem(mem_2, 32'h2000_0000, "RW");
  AHB_2_map.add_mem(mem_3, 32'h0001_0000, "RW");

  // Example use of "dont_test" attributes:
  // Stops mem_1_offset reset test
  uvm_resource_db #(bit)::set({"REG::", this.mem_1_offset.get_full_name()}, "NO_REG_HW_RESET_TEST", 1);
  // Stops mem_1_offset bit-bash test
  uvm_resource_db #(bit)::set({"REG::", this.mem_1_offset.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1);
  // Stops mem_1 being tested with the walking auto test
  uvm_resource_db #(bit)::set({"REG::", this.mem_1.get_full_name()}, "NO_MEM_WALK_TEST", 1);
  lock_model();
endfunction: build

endclass: mem_ss_reg_block

endpackage: mem_ss_reg_pkg
