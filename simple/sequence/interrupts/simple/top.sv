//
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
//
// This example illustrates a simple interrupt service routine sequence
//
// It has an interface with 4 interrupts, when one of those
// interrupts occurs the ISR sequence then resets the interrupt
// source
//
// The ISR does a grab to gain exclusive access to the
// sequencer
//
// The other sequence running is setting interrupts randomly
// via a GPIO interface
//

//
// A set of interrupt request lines and a clock
//
interface int_if;

logic[3:0] irq;
logic clk;

endinterface: int_if

// Need something to drive the bus interface that
// can be interrupted ...

package int_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import bidirect_bus_pkg::*;

class int_config extends uvm_object;

`uvm_object_utils(int_config)

virtual int_if INT;

function new(string name = "int_config");
  super.new(name);
endfunction

//
// Task: wait_for_clock
//
// This method waits for n clock cycles. This technique can be used for clocks,
// resets and any other signals.
//
task wait_for_clock( int n = 1 );
  repeat( n ) begin
    @( posedge INT.clk );
  end
endtask

//
// Task: wait_for_IRQ0
//
// This method waits for a rising edge on IRQ0
//
task wait_for_IRQ0();
  @(posedge INT.irq[0]);
endtask: wait_for_IRQ0

//
// Task: wait_for_IRQ1
//
// This method waits for a rising edge on IRQ0
//
task wait_for_IRQ1();
  @(posedge INT.irq[1]);
endtask: wait_for_IRQ1

//
// Task: wait_for_IRQ2
//
// This method waits for a rising edge on IRQ0
//
task wait_for_IRQ2();
  @(posedge INT.irq[2]);
endtask: wait_for_IRQ2

//
// Task: wait_for_IRQ0
//
// This method waits for a rising edge on IRQ0
//
task wait_for_IRQ3();
  @(posedge INT.irq[3]);
endtask: wait_for_IRQ3

endclass: int_config

//
// Interrupt service routine
//
// Looks at the interrupt sources to determine what to do
//
class isr extends uvm_sequence #(bus_seq_item);

`uvm_object_utils(isr)

function new (string name = "isr");
  super.new(name);
endfunction

rand logic[31:0] addr;
rand logic[31:0] write_data;
rand bit read_not_write;
rand int delay;

bit error;
logic[31:0] read_data;



task body;
  bus_seq_item req;

  m_sequencer.grab(this); // Grab => Immediate exclusive access to sequencer

  req = bus_seq_item::type_id::create("req");

  // Read from the GPO register to determine the cause of the interrupt
  if(!req.randomize() with {addr == 32'h0100_0000; read_not_write == 1;}) begin
    `uvm_error("body", "randomization failure with req")
  end
  start_item(req);
  finish_item(req);

  // Test the bits and reset if active
  //
  // Note that the order of the tests implements a priority structure
  //
  req.read_not_write = 0;
  if(req.read_data[0] == 1)
    begin
      `uvm_info("ISR:BODY", "IRQ0 detected", UVM_LOW)
      req.write_data[0] = 0;
      start_item(req);
      finish_item(req);
      `uvm_info("ISR:BODY", "IRQ0 cleared", UVM_LOW)
    end
  if(req.read_data[1] == 1)
    begin
      `uvm_info("ISR:BODY", "IRQ1 detected", UVM_LOW)
      req.write_data[1] = 0;
      start_item(req);
      finish_item(req);
      `uvm_info("ISR:BODY", "IRQ1 cleared", UVM_LOW)
    end
  if(req.read_data[2] == 1)
    begin
      `uvm_info("ISR:BODY", "IRQ2 detected", UVM_LOW)
       req.write_data[2] = 0;
      start_item(req);
      finish_item(req);
      `uvm_info("ISR:BODY", "IRQ2 cleared", UVM_LOW)
    end
  if(req.read_data[3] == 1)
    begin
      `uvm_info("ISR:BODY", "IRQ3 detected", UVM_LOW)
      req.write_data[3] = 0;
      start_item(req);
      finish_item(req);
      `uvm_info("ISR:BODY", "IRQ3 cleared", UVM_LOW)
    end
  start_item(req); // Take the interrupt line low
  finish_item(req);

  m_sequencer.ungrab(this); // Ungrab the sequencer, let other sequences in

endtask: body

endclass: isr

class set_ints extends uvm_sequence #(bus_seq_item);

`uvm_object_utils(set_ints)

function new (string name = "set_ints");
  super.new(name);
endfunction

task body;
  bus_seq_item req;

  req = bus_seq_item::type_id::create("req");

  repeat(100) begin
    if(!req.randomize() with {addr inside {[32'h0100_0000:32'h0100_001C]}; read_not_write == 0;}) begin
      `uvm_error("body", "req randomization failure")
    end
    start_item(req);
    finish_item(req);
  end
endtask: body

endclass: set_ints

//
// Sequence runs a bus intensive sequence on one thread
// which is interrupted by one of four interrupts
//
class int_test_seq extends uvm_sequence #(bus_seq_item);

`uvm_object_utils(int_test_seq)

function new (string name = "int_test_seq");
  super.new(name);
endfunction

task body;
  set_ints setup_ints; // Sequence: Main activity on the bus interface
  isr ISR;             // Interrupt service routine
  int_config i_cfg;    // Config containing wait_for_IRQx tasks

  setup_ints = set_ints::type_id::create("setup_ints");
  ISR = isr::type_id::create("ISR");
  if(!uvm_config_db #(int_config)::get(null, get_full_name(), "int_config", i_cfg)) begin
    `uvm_error("body", "failed to get int_config")
  end
  // Forked process - two levels of forking
  fork
    setup_ints.start(m_sequencer); // Main bus activity
    begin
      forever begin
        fork // Waiting for one or more of 4 interrupts
          i_cfg.wait_for_IRQ0();
          i_cfg.wait_for_IRQ1();
          i_cfg.wait_for_IRQ2();
          i_cfg.wait_for_IRQ3();
        join_any
        disable fork;
        ISR.start(m_sequencer); // Start the ISR
      end
    end
  join_any // At the end of the main bus activity sequence
  disable fork;

endtask: body

endclass: int_test_seq

class int_test extends uvm_component;

`uvm_component_utils(int_test)

bidirect_bus_agent m_agent;
bidirect_bus_agent_config m_bus_cfg;
int_config m_int_cfg;

function new(string name = "int_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  m_int_cfg = int_config::type_id::create("m_int_cfg");
  if(!uvm_config_db #(virtual int_if)::get(this, "", "INT_vif", m_int_cfg.INT)) begin
    `uvm_error("build_phase", "Interrupt virtual interface handle not found")
  end
  uvm_config_db #(int_config)::set(this, "*", "int_config", m_int_cfg);
  m_bus_cfg = bidirect_bus_agent_config::type_id::create("m_bus_cfg");
  if(!uvm_config_db #(virtual bus_if)::get(this, "", "BUS_vif", m_bus_cfg.BUS)) begin
    `uvm_error("build_phase", "BUS virtual interface handle not found")
  end
  uvm_config_db #(bidirect_bus_agent_config)::set(this, "*", "direct_bus_agent_config", m_bus_cfg);
  m_agent = bidirect_bus_agent::type_id::create("m_agent", this);
endfunction: build_phase

task run_phase(uvm_phase phase);
  int_test_seq t_seq;

  phase.raise_objection(this, "Starting interrupt sequence");
  t_seq = int_test_seq::type_id::create("t_seq");
  t_seq.start(m_agent.m_sequencer);
  phase.drop_objection(this, "Finishing interrupt sequence");
endtask: run_phase

endclass: int_test

endpackage: int_test_pkg

module top;
import uvm_pkg::*;
import bidirect_bus_pkg::*;
import int_test_pkg::*;

int_if INT();
bus_if BUS();
gpio_if GPIO();
bidirect_bus_slave DUT(.bus(BUS), .gpio(GPIO));

assign INT.irq[3:0] = GPIO.gp_op[3:0];
assign INT.clk = BUS.clk;

// Free running clock
initial
  begin
    BUS.clk = 0;
    forever begin
      #10 BUS.clk = ~BUS.clk;
    end
  end

// Reset
initial
  begin
    BUS.resetn = 0;
    repeat(3) begin
      @(posedge BUS.clk);
    end
    BUS.resetn = 1;
  end

// UVM start up:
initial
  begin
    uvm_config_db #(virtual bus_if)::set(null, "uvm_test_top", "BUS_vif" , BUS);
    uvm_config_db #(virtual int_if)::set(null, "uvm_test_top", "INT_vif" , INT);
    run_test("int_test");
  end
endmodule: top
