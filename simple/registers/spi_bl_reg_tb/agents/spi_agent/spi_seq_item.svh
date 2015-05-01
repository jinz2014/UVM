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
class spi_seq_item extends uvm_sequence_item;

// UVM Factory Registration Macro
//
`uvm_object_utils(spi_seq_item)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic[127:0] spi_data;
rand bit[6:0] no_bits;
rand bit RX_NEG;

// Analysis members:
logic[127:0] nedge_mosi;
logic[127:0] pedge_mosi;
logic[127:0] nedge_miso;
logic[127:0] pedge_miso;
logic[7:0] cs;

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "spi_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass:spi_seq_item

function spi_seq_item::new(string name = "spi_seq_item");
  super.new(name);
endfunction

function void spi_seq_item::do_copy(uvm_object rhs);
  spi_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  spi_data = rhs_.spi_data;
  no_bits = rhs_.no_bits;
  RX_NEG = rhs_.RX_NEG;
  nedge_mosi = rhs_.nedge_mosi;
  pedge_mosi = rhs_.pedge_mosi;
  nedge_miso = rhs_.nedge_miso;
  pedge_miso = rhs_.pedge_miso;
  cs = rhs_.cs;

endfunction:do_copy

function bit spi_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  spi_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         spi_data == rhs_.spi_data &&
         no_bits == rhs_.no_bits &&
         RX_NEG == rhs_.RX_NEG;
endfunction:do_compare

function string spi_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s spi_data\t%0h\n no_bits\t%0b\n RX_NEG\t%0b\n nedge_miso\%0h\n pedge_miso\%0h\n",
           s, spi_data, no_bits, RX_NEG, nedge_miso, pedge_miso);
  return s;

endfunction:convert2string

function void spi_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void spi_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("spi_data", spi_data)
  `uvm_record_field("no_bits", no_bits)
  `uvm_record_field("RX_NEG", RX_NEG)
endfunction:do_record
