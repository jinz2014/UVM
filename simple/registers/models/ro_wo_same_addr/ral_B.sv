//
//------------------------------------------------------------------------------
//   Copyright 2011 Mentor Graphics Corporation
//   Copyright 2011 Cadence Design Systems, Inc. 
//   Copyright 2011 Synopsys, Inc.
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


`ifndef RAL_B
`define RAL_B

import uvm_pkg::*;

class ral_reg_R extends uvm_reg;
	uvm_reg_field F1;
	rand uvm_reg_field F2;

	function new(string name = "R");
		super.new(name, 24,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.F1 = uvm_reg_field::type_id::create("F1");
      this.F1.configure(this, 8, 0, "RO", 0, 8'h0, 1, 0, 1);
      this.F2 = uvm_reg_field::type_id::create("F2");
      this.F2.configure(this, 8, 16, "RC", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_R)

endclass : ral_reg_R


class ral_reg_W extends uvm_reg;
	rand uvm_reg_field F1;
	rand uvm_reg_field F2;

	function new(string name = "W");
		super.new(name, 24,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.F1 = uvm_reg_field::type_id::create("F1");
      this.F1.configure(this, 8, 4, "WO", 0, 8'haa, 1, 0, 1);
      this.F2 = uvm_reg_field::type_id::create("F2");
      this.F2.configure(this, 8, 12, "WO", 0, 8'hcc, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_W)

endclass : ral_reg_W


class ral_block_B extends uvm_reg_block;
	rand ral_reg_R R;
	rand ral_reg_W W;
	uvm_reg_field R_F1;
	rand uvm_reg_field R_F2;
	rand uvm_reg_field W_F1;
	rand uvm_reg_field W_F2;

	function new(string name = "B");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_BIG_ENDIAN);
      this.R = ral_reg_R::type_id::create("R");
      this.R.build();
      this.R.configure(this, null, "");
      this.default_map.add_reg(this.R, `UVM_REG_ADDR_WIDTH'h100, "RW", 0);
		this.R_F1 = this.R.F1;
		this.R_F2 = this.R.F2;
      this.W = ral_reg_W::type_id::create("W");
      this.W.build();
      this.W.configure(this, null, "");
      this.default_map.add_reg(this.W, `UVM_REG_ADDR_WIDTH'h100, "RW", 0);
		this.W_F1 = this.W.F1;
		this.W_F2 = this.W.F2;
   endfunction : build

	`uvm_object_utils(ral_block_B)

endclass : ral_block_B



`endif
