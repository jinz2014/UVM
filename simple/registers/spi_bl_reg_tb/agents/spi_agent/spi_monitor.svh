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
class spi_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(spi_monitor);

// Virtual Interface
virtual spi_if SPI;

//------------------------------------------
// Data Members
//------------------------------------------

//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(spi_seq_item) ap;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "spi_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: spi_monitor

function spi_monitor::new(string name = "spi_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task spi_monitor::run_phase(uvm_phase phase);
  spi_seq_item item;
  spi_seq_item cloned_item;
  int n;
  int p;

  item = spi_seq_item::type_id::create("item");

  while(SPI.cs === 8'hxx) begin
    #1;
  end

  forever begin

    while(SPI.cs === 8'hff) begin
      @(SPI.cs);
    end

    n = 0;
    p = 0;
    item.nedge_mosi = 0;
    item.pedge_mosi = 0;
    item.nedge_miso = 0;
    item.pedge_miso = 0;
    item.cs = SPI.cs;

    fork
      begin
        while(SPI.cs != 8'hff) begin
          @(SPI.clk);
          if(SPI.clk == 1) begin
            item.nedge_mosi[p] = SPI.mosi;
            item.nedge_miso[p] = SPI.miso;
            p++;
          end
          else begin
            item.pedge_mosi[n] = SPI.mosi;

            item.pedge_miso[n] = SPI.miso;
    //        $display("%t sample %0h, pedge_mosi[%0d] = %b", $time, item.pedge_mosi, n, SPI.mosi);
            n++;
          end
        end
      end
      begin
        @(SPI.clk);
        @(SPI.cs);
      end
    join_any
    disable fork;

/*
    $display("nedge_mosi: %0h", item.nedge_mosi);
    $display("pedge_mosi: %0h", item.pedge_mosi);
    $display("nedge_miso: %0h", item.nedge_miso);
    $display("pedge_miso: %0h", item.pedge_miso);
*/
    // Clone and publish the cloned item to the subscribers
    $cast(cloned_item, item.clone());
    ap.write(cloned_item);
  end
endtask: run_phase

function void spi_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase
