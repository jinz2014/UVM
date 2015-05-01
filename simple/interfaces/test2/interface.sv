//
//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010-2011 Synopsys, Inc.
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
//----------------------------------------------------------------------


/*
About: uvm_exmples/mechanism/interfaces

This example will illustrate how to create a pin interface and mod port interfaces for a simple dut.

Connect a component "driver" to the pin interfaces, then to the dut.
*/

/* get_full_name() returns the current scope of the class */

//----------------------------------------------------------------------
// interface mem_pins_if
//----------------------------------------------------------------------
interface pin_if (input clk);
  bit [15:0] address;
  bit [7:0]  wr_data;
  bit [7:0]  rd_data;
  bit        rst;
  bit        rw;
  bit        req;
  bit        ack;
  bit        err;

  modport master_mp(             
   input  clk,
   input  rst,          
   output address,
   output wr_data,  
   input  rd_data,            
   output req,
   output rw,           
   input  ack,
   input  err );         
                                 
  modport slave_mp(              
   input  clk,
   input  rst,          
   input  address,
   input  wr_data,  
   output rd_data,            
   input  req,
   input  rw,           
   output ack,
   output err );         
                                 
  modport monitor_mp(            
   input  clk,
   input  rst,          
   input  address,
   input  wr_data,  
   input  rd_data,            
   input  req,
   input  rw ,
   input  ack,
   input  err );
endinterface

import uvm_pkg::*;

package top_pkg;
   typedef virtual pin_if pin_vif;
endpackage


`include "uvm_macros.svh"

package user_pkg;
import uvm_pkg::*;
import top_pkg::*;

//---------------------------------------------------------------------
// component driver
//----------------------------------------------------------------------
class driver extends uvm_component;

  pin_vif pif, vif;

  // default
  int v = 5;
  string str = "safe";

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    // method 1
     assert(uvm_resource_db#(pin_vif)::read_by_name(get_full_name(),  "pif", pif));

     // size is the name of the resource "v"
     assert(uvm_resource_db#(int)::read_by_name(get_full_name(), "size", v));

     assert(uvm_resource_db#(string)::read_by_name(get_full_name(), "label", str));

    // method 2
    //assert(uvm_resource_db#(pin_vif)::read_by_type(get_full_name(), pif));
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge pif.clk);
      `uvm_info("driver", "posedge clk", UVM_NONE);
      //...
    end
  endtask

endclass

//----------------------------------------------------------------------
// environment env
//----------------------------------------------------------------------
class env extends uvm_env;

  pin_vif pif;
  driver d;
  int runtime = 100; // by default

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    d = new("driver", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("env", "build_phase", UVM_LOW);
    assert(uvm_resource_db#(int)::read_by_name(get_full_name(), "runtime", runtime));
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
     #(runtime);
    phase.drop_objection(this);
  endtask

endclass

endpackage

import user_pkg::*;

//----------------------------------------------------------------------
// module dut
//----------------------------------------------------------------------
module dut(pin_if pif);

  always @(posedge pif.clk) begin
    `uvm_info("dut", "posedge clk", UVM_NONE);
    //...
  end
endmodule

//----------------------------------------------------------------------
// module clkgen
//----------------------------------------------------------------------
module clkgen(output bit clk);

  initial begin
    forever begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end

endmodule

//----------------------------------------------------------------------
// module top
//----------------------------------------------------------------------
module top;

  import top_pkg::*;

  bit clk;
  clkgen ck(clk);
  pin_if pif(clk);

  env e;
  dut d(pif.slave_mp);

  initial begin
    e = new("env");
    // method 1  

    // note the scope is different from the "instance_name.field_name".
    // The instance name and field name are "e" and "g" respectively.
    `uvm_info("top", "*** resource configuration *** ", UVM_LOW);
    uvm_resource_db#(pin_vif)::set("env.driver", "pif", pif);
    uvm_resource_db#(int)::set("env.driver", "size", 8);
    uvm_resource_db#(string)::set("env.driver", "label", "insecure");
    uvm_resource_db#(int)::set("env", "runtime", 100);

    // method 2
    //uvm_resource_db#(pin_vif)::set_anonymous("env.driver", pif);

    uvm_resource_db#(pin_vif)::dump();

    run_test();
  end
 
endmodule
