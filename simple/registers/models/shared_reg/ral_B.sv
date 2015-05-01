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
	rand uvm_reg_field F;

	function new(string name = "R");
		super.new(name, 8,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.F = uvm_reg_field::type_id::create("F");
      this.F.configure(this, 8, 0, "RW", 0, 8'h0, 0, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_R)

endclass : ral_reg_R


class ral_block_B extends uvm_reg_block;
	uvm_reg_map APB;
	rand ral_reg_R A;
	rand ral_reg_R X;
	uvm_reg_map WSH;
	rand ral_reg_R W;
	rand uvm_reg_field A_F;
	rand uvm_reg_field X_F;
	rand uvm_reg_field W_F;

	function new(string name = "B");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.APB = create_map("APB", 0, 1, UVM_LITTLE_ENDIAN);
      this.default_map = this.APB;
      this.WSH = create_map("WSH", 0, 1, UVM_LITTLE_ENDIAN);
      this.A = ral_reg_R::type_id::create("A");
      this.A.build();
      this.A.configure(this, null, "");
      this.APB.add_reg(this.A, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.A_F = this.A.F;
      this.X = ral_reg_R::type_id::create("X");
      this.X.build();
      this.X.configure(this, null, "");
      this.APB.add_reg(this.X, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.X_F = this.X.F;
      this.WSH.add_reg(this.X, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
      this.W = ral_reg_R::type_id::create("W");
      this.W.build();
      this.W.configure(this, null, "");
      this.WSH.add_reg(this.W, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.W_F = this.W.F;
   endfunction : build

	`uvm_object_utils(ral_block_B)

endclass : ral_block_B



`endif
