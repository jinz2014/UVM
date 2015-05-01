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
class ahb_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_monitor);

// Virtual Interface
virtual ahb_if AHB;

//------------------------------------------
// Data Members
//------------------------------------------

//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(ahb_seq_item) ap;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "ahb_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: ahb_monitor

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task ahb_monitor::run_phase(uvm_phase phase);
  ahb_seq_item item;
  ahb_seq_item cloned_item;

  item = ahb_seq_item::type_id::create("item");

  forever begin
    // Detect the protocol event on the TBAI virtual interface
    @(posedge AHB.HCLK iff((AHB.HREADY == 1) && (AHB.HTRANS == AHB_NON_SEQ)));
    item.HADDR = AHB.HADDR;
    item.HWRITE = ahb_rw_e'(AHB.HWRITE);
    @(posedge AHB.HCLK iff(AHB.HREADY == 1));
    if(item.HWRITE == AHB_WRITE) begin
      item.DATA = AHB.HWDATA;
    end
    else begin
      item.DATA = AHB.HRDATA;
    end
    item.HRESP = ahb_resp_e'(AHB.HRESP);
    // Clone and publish the cloned item to the subscribers
    $cast(cloned_item, item.clone());
    ap.write(cloned_item);
  end
endtask: run_phase

function void ahb_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase

