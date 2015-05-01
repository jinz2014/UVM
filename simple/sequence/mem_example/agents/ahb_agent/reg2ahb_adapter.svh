//
// -------------------------------------------------------------
//    Copyright 2010 Mentor Graphics Corp.
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//


class reg2ahb_adapter extends uvm_reg_adapter;

  `uvm_object_utils(reg2ahb_adapter)

   function new(string name = "reg2ahb_adapter");
      super.new(name);
   endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_seq_item ahb = ahb_seq_item::type_id::create("ahb");
    ahb.HWRITE = (rw.kind == UVM_READ) ? AHB_READ : AHB_WRITE;
    ahb.HADDR = rw.addr;
    ahb.DATA = rw.data;
    return ahb;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    ahb_seq_item ahb;
    if (!$cast(ahb, bus_item)) begin
      `uvm_fatal("NOT_AHB_TYPE","Provided bus_item is not of the correct type")
      return;
    end
    rw.kind = (ahb.HWRITE == AHB_READ) ? UVM_READ : UVM_WRITE;
    rw.addr = ahb.HADDR;
    rw.data = ahb.DATA;
    rw.status = UVM_IS_OK;
  endfunction

endclass

