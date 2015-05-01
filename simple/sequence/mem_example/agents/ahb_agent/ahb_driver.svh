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
// A very simple AHB driver only capable of single reads and writes
//
//
class ahb_driver extends uvm_driver #(ahb_seq_item, ahb_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_driver)

// Virtual Interface
virtual ahb_if AHB;

//------------------------------------------
// Data Members
//------------------------------------------

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_driver", uvm_component parent = null);
extern task run_phase(uvm_phase phase);

endclass: ahb_driver

function ahb_driver::new(string name = "ahb_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

task ahb_driver::run_phase(uvm_phase phase);
  ahb_seq_item req;

    logic [31:0]  HADDR;
    logic [1:0] HTRANS;
    logic HWRITE;
    logic [2:0] HSIZE;
    logic [2:0] HBURST;
    logic [3:0] HPROT;
    logic [31:0]  HWDATA;
    logic [31:0]  HRDATA;
    logic [1:0] HRESP;
    logic HREADY;
    logic HSEL;

  AHB.HADDR <= 0;
  AHB.HTRANS <= 0;
  AHB.HWRITE <= 0;
  AHB.HSIZE <= 2;
  AHB.HBURST <= AHB_SINGLE;
  AHB.HPROT <= 0;
  AHB.HWDATA <= 0;
  AHB.HSEL <= 0;

  @(posedge AHB.HRESETn);
  forever begin
    seq_item_port.get_next_item(req);
    @(posedge AHB.HCLK);
    AHB.HADDR <= req.HADDR;
    AHB.HWRITE <= req.HWRITE;
    AHB.HTRANS <= AHB_NON_SEQ;
    @(posedge AHB.HCLK iff(AHB.HREADY == 1));
    AHB.HADDR <= 0;
    AHB.HWRITE <= 0;
    AHB.HTRANS <= AHB_IDLE;
    if(req.HWRITE == AHB_WRITE) begin
      AHB.HWDATA <= req.DATA;
    end
    @(posedge AHB.HCLK iff(AHB.HREADY == 1));
    if(req.HWRITE == AHB_READ) begin
      req.DATA = AHB.HRDATA;
    end
    seq_item_port.item_done();
  end

endtask: run_phase

