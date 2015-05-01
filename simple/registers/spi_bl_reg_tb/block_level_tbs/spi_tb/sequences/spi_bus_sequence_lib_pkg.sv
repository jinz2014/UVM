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
// This package contains the sequences targetting the bus
// interface of the SPI block - Not all are used by the test cases
//
// It uses the UVM register model
//
package spi_bus_sequence_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import spi_env_pkg::*;
import spi_reg_pkg::*;

// Base class that used by all the other sequences in the
// package:
//
// Gets the handle to the register model - spi_rm
//
// Contains the data and status fields used by most register
// access methods
//
class spi_bus_base_seq extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(spi_bus_base_seq)

// SPI Register model:
spi_reg_block spi_rm;

// SPI env configuration object (containing a register model handle)
spi_env_config m_cfg;

// Properties used by the various register access methods:
rand  uvm_reg_data_t data; // For passing data
uvm_status_e status;       // Returning access status

function new(string name = "spi_bus_base_seq");
  super.new(name);
endfunction

// Common functionality:
// Getting a handle to the register model
task body;
  if(!uvm_config_db #(spi_env_config)::get(null, get_full_name(), "spi_env_config", m_cfg)) begin
    `uvm_error("body", "Could not find spi_env_config")
  end
  spi_rm = m_cfg.spi_rm;
endtask: body

endclass: spi_bus_base_seq

//
// Data load sequence:
//
// load all rxtx locations with
// random data in a random order
//
class data_load_seq extends spi_bus_base_seq;

`uvm_object_utils(data_load_seq)

function new(string name = "data_load_seq");
  super.new(name);
endfunction

uvm_reg data_regs[]; // Array of registers


task body;
  super.body;
  // Set up the data register handle array
  data_regs = '{spi_rm.rxtx0_reg, spi_rm.rxtx1_reg, spi_rm.rxtx2_reg, spi_rm.rxtx3_reg};
  // Randomize order
  data_regs.shuffle();
  foreach(data_regs[i]) begin
    // Randomize register content and then update
    if(!data_regs[i].randomize()) begin
      `uvm_error("body", $sformatf("Randomization error for data_regs[%0d]", i))
    end
    data_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
  end

endtask: body

endclass: data_load_seq

//
// Data unload sequence - reads back the data rx registers
// all of them in a random order
//
class data_unload_seq extends spi_bus_base_seq;

`uvm_object_utils(data_unload_seq)

uvm_reg data_regs[];

function new(string name = "data_unload_seq");
  super.new(name);
endfunction

task body;
  super.body;
  // Set up the data register handle array
  data_regs = '{spi_rm.rxtx0_reg, spi_rm.rxtx1_reg, spi_rm.rxtx2_reg, spi_rm.rxtx3_reg};
  // Randomize access order
  data_regs.shuffle();
  // Use mirror in order to check that the value read back is as expected
  foreach(data_regs[i]) begin
    data_regs[i].mirror(status, UVM_CHECK, .parent(this));
  end
endtask: body

endclass: data_unload_seq

//
// Div load sequence - loads one of the target
//                     divisor values
//
class div_load_seq extends spi_bus_base_seq;

`uvm_object_utils(div_load_seq)

function new(string name = "div_load_seq");
  super.new(name);
endfunction

// Interesting divisor values:
constraint div_values {data[15:0] inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};}

task body;
  super.body;
  // Randomize the local data value
  if(!this.randomize()) begin
    `uvm_error("body", "Randomization error for this")
  end
  // Write to the divider register
  spi_rm.divider_reg.write(status, data, .parent(this));
endtask: body

endclass: div_load_seq

//
// Ctrl set sequence - loads one control params
//                     but does not set the go bit
//
class ctrl_set_seq extends spi_bus_base_seq;

`uvm_object_utils(ctrl_set_seq)

function new(string name = "ctrl_set_seq");
  super.new(name);
endfunction

// Controls whether interrupts are enabled or not
bit int_enable = 0;

task body;
  super.body;
  // Constrain to interesting data length values
  if(!spi_rm.ctrl_reg.randomize() with {char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};}) begin
    `uvm_error("body", "Control register randomization failed")
  end
  // Set up interrupt enable
  spi_rm.ctrl_reg.ie.set(int_enable);
  // Don't set the go_bsy bit
  spi_rm.ctrl_reg.go_bsy.set(0);
  // Write the new value to the control register
  spi_rm.ctrl_reg.update(status, .path(UVM_FRONTDOOR), .parent(this));
  // Get a copy of the register value for the SPI agent
  data = spi_rm.ctrl_reg.get();
endtask: body

endclass: ctrl_set_seq

//
// Ctrl go sequence - sets the transfer in motion
//                    uses previously set control value
//
class ctrl_go_seq extends spi_bus_base_seq;

`uvm_object_utils(ctrl_go_seq)

function new(string name = "ctrl_go_seq");
  super.new(name);
endfunction

task body;
  super.body;
  // Set the go_bsy bit and go!
  spi_rm.ctrl_reg.go_bsy.set(1);
  spi_rm.ctrl_reg.update(status, .path(UVM_FRONTDOOR), .parent(this));
endtask: body

endclass: ctrl_go_seq

// Slave Select setup sequence
//
// Random values set for slave select
//
class slave_select_seq extends spi_bus_base_seq;

`uvm_object_utils(slave_select_seq)

function new(string name = "slave_select_seq");
  super.new(name);
endfunction

task body;
  super.body;
  if(!spi_rm.ss_reg.randomize() with {cs.value != 8'h0;}) begin
    `uvm_error("body", "Randomization failure for ss_reg")
  end
  spi_rm.update(status, .path(UVM_FRONTDOOR), .parent(this));
endtask: body

endclass: slave_select_seq

// Slave Unselect setup sequence
//
// Writes 0 to the slave select register
//
class slave_unselect_seq extends spi_bus_base_seq;

`uvm_object_utils(slave_unselect_seq)

function new(string name = "slave_unselect_seq");
  super.new(name);
endfunction

task body;
  super.body;
  spi_rm.ss_reg.write(status, 32'h0, .parent(this));
endtask: body

endclass: slave_unselect_seq

//
// Transfer complete by polling sequence
//
// Does successive reads from the control register
// to determine when the transfer has completed
//
class tfer_over_by_poll_seq extends spi_bus_base_seq;


`uvm_object_utils(tfer_over_by_poll_seq)

function new(string name = "tfer_over_by_poll_seq");
  super.new(name);
endfunction

task body;
  data_unload_seq empty_buffer;
  slave_unselect_seq ss_deselect;

  super.body;

  // Poll the GO_BSY bit in the control register
  while(spi_rm.ctrl_reg.go_bsy.value[0] == 1) begin
    spi_rm.ctrl_reg.read(status, data, .parent(this));
  end
  ss_deselect = slave_unselect_seq::type_id::create("ss_deselect");
  ss_deselect.start(m_sequencer);
  empty_buffer = data_unload_seq::type_id::create("empty_buffer");
  empty_buffer.start(m_sequencer);
endtask: body

endclass: tfer_over_by_poll_seq

//
// Sequence to configure the SPI randomly
//
class SPI_config_seq extends spi_bus_base_seq;

`uvm_object_utils(SPI_config_seq)

function new(string name = "SPI_config_seq");
  super.new(name);
endfunction

bit interrupt_enable;

task body;
  super.body;

  // Randomize the register model to get a new config
  // Constraining the generated value within ranges
  if(!spi_rm.randomize() with {spi_rm.ctrl_reg.go_bsy.value == 0;
                           spi_rm.ctrl_reg.ie.value == interrupt_enable;
                           spi_rm.ss_reg.cs.value != 0;
                           spi_rm.ctrl_reg.char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};
                           spi_rm.divider_reg.ratio.value inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};
                          }) begin
    `uvm_error("body", "spi_rm randomization failure")
  end
  // This will write the generated values to the HW registers
  spi_rm.update(status, .path(UVM_FRONTDOOR), .parent(this));
  data = spi_rm.ctrl_reg.get();
endtask: body

endclass: SPI_config_seq

//
// Sequence to configure the SPI randomly
// writing configuration values in a random order
//
class SPI_config_rand_order_seq extends spi_bus_base_seq;

`uvm_object_utils(SPI_config_rand_order_seq)

function new(string name = "SPI_config_rand_order_seq");
  super.new(name);
endfunction

bit interrupt_enable;
uvm_reg spi_regs[$];

task body;
  super.body;

  spi_rm.get_registers(spi_regs);
  // Randomize the register model to get a new config
  // Constraining the generated value within ranges
  if(!spi_rm.randomize() with {spi_rm.ctrl_reg.go_bsy.value == 0;
                           spi_rm.ctrl_reg.ie.value == interrupt_enable;
                           spi_rm.ss_reg.cs.value != 0;
                           spi_rm.ctrl_reg.char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};
                           spi_rm.divider_reg.ratio.value inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};
                          }) begin
    `uvm_error("body", "spi_rm randomization failure")
  end
  // This will write the generated values to the HW registers
  // in a random order
  spi_regs.shuffle();
  foreach(spi_regs[i]) begin
    spi_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
  end
  // Get the configured version of the control register
  data = spi_rm.ctrl_reg.get();
endtask: body

endclass: SPI_config_rand_order_seq


//
// This is a register check sequence
//
// It checks the reset values
//
// Then it writes random data to each of the registers
// and reads back to check that it matches
//
class check_regs_seq extends spi_bus_base_seq;

`uvm_object_utils(check_regs_seq)

function new(string name = "check_regs_seq");
  super.new(name);
endfunction

uvm_reg spi_regs[$];
uvm_reg_data_t ref_data;

task body;

  int errors;

  super.body;
  spi_rm.get_registers(spi_regs);

  // Set errors to 0
  errors = 0;

  // Read back reset values in random order
  spi_regs.shuffle();
  foreach(spi_regs[i]) begin
    ref_data = spi_regs[i].get_reset();
    spi_regs[i].read(status, data, .parent(this));
    if(ref_data != data) begin
      `uvm_error("REG_TEST_SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
      errors++;
    end
  end

  // Write random data and check read back (10 times)
  repeat(10) begin

    spi_regs.shuffle();
    foreach(spi_regs[i]) begin
      if(!this.randomize()) begin
        `uvm_error("body", "randomization error")
      end
      if(spi_regs[i].get_name() == "ctrl") begin
        data[8] = 0;
      end
      spi_regs[i].write(status, data, .parent(this));
    end
    spi_regs.shuffle();
    foreach(spi_regs[i]) begin
      ref_data = spi_regs[i].get();
      spi_regs[i].read(status, data, .parent(this));
      if(ref_data != data) begin
        `uvm_error("REG_TEST_SEQ:", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
	errors++;
      end

    end
  end

  // Repeat with back door accesses
  repeat(10) begin
    spi_regs.shuffle();
    foreach(spi_regs[i]) begin
      if(!this.randomize()) begin
        `uvm_error("body", "randomization error")
      end
      if(spi_regs[i].get_name() == "ctrl") begin
        data[8] = 0;
      end
      spi_regs[i].poke(status, data, .parent(this));
    end
    spi_regs.shuffle();
    foreach(spi_regs[i]) begin
      ref_data = spi_regs[i].get();
      spi_regs[i].peek(status, data, .parent(this));
      if(ref_data[31:0] != data[31:0]) begin
        `uvm_error("REG_TEST_SEQ:", $sformatf("poke/peek: Read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
	errors++;
      end
      spi_regs[i].read(status, data, .parent(this));
    end

  end
  
  if(errors == 0) begin
    `uvm_info("** UVM TEST PASSED **", "Register read-back path OK - no errors", UVM_LOW)
  end 

endtask: body

endclass: check_regs_seq

endpackage: spi_bus_sequence_lib_pkg
