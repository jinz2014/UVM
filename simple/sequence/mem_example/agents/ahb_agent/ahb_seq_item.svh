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
class ahb_seq_item extends uvm_sequence_item;

// UVM Factory Registration Macro
//
`uvm_object_utils(ahb_seq_item)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand bit[31:0] HADDR;
rand bit[31:0] DATA;
rand ahb_rw_e HWRITE;

ahb_resp_e HRESP;
//------------------------------------------
// Constraints
//------------------------------------------
constraint addr_align {HADDR[1:0] == 0;}

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass:ahb_seq_item

function ahb_seq_item::new(string name = "ahb_seq_item");
  super.new(name);
endfunction

function void ahb_seq_item::do_copy(uvm_object rhs);
  ahb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  // <var_name> = rhs_.<var_name>;
  HADDR = rhs_.HADDR;
  DATA = rhs_.DATA;
  HWRITE = rhs_.HWRITE;
  HRESP = rhs_.HRESP;
endfunction:do_copy

function bit ahb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  ahb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         // <var_name> == rhs_.<var_name> &&
    HADDR == rhs_.HADDR &&
    DATA == rhs_.DATA &&
    HWRITE == rhs_.HWRITE &&
    HRESP == rhs_.HRESP;
         // <var_name> == rhs_.<var_name>;
endfunction:do_compare

function string ahb_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  // $sformat(s, "%s <var_name>\t%0h\n", s, <var_name>);
  $sformat(s, "%s HADDR\t%0h\n DATA\t%0h\n HWRITE\t%s\n HRESP\t%s", s, HADDR, DATA, HWRITE.name(), HRESP.name());
  return s;

endfunction:convert2string

function void ahb_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void ahb_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  //`uvm_record_field("<var_name>", <var_name>)
  `uvm_record_field("HADDR", HADDR)
  `uvm_record_field("DATA", DATA)
  `uvm_record_field("HWRITE", HWRITE)
  `uvm_record_field("HRESP", HRESP)
endfunction:do_record

