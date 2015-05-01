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

`ifndef REG_B
`define REG_B

// uvm_reg_data_t: 2-state data value with `UVM_REG_DATA_WIDTH bits
// uvm_reg_data_logic_t: 4-state data value with `UVM_REG_DATA_WIDTH bits
// `UVM_REG _DATA_WIDTH : Maximum data width in bits
// Default value is 64. Used to define the uvm_reg_data_t type.
class reg_R extends uvm_reg;
   rand uvm_reg_data_t value;
   local rand uvm_reg_field _dummy;

   // uvm_reg_field.value
   // Mirrored field value. This value can be sampled in a functional coverage model or
   // constrained when randomized.
   constraint _dummy_is_reg {
      _dummy.value == value;
   }

   function new(string name = "R");
      super.new(name, 8, UVM_NO_COVERAGE);
   endfunction: new
   
   virtual function void build();
      this._dummy = uvm_reg_field::type_id::create("value");
      /*
      function void configure( 
        uvm_reg parent,
        int unsigned size,
        int unsigned lsb_pos,
        string access,
        bit volatile,
        uvm_reg_data_t reset,
        bit has_reset,
        bit is_rand,
        bit individually_accessible)

        Specify the parent register of this field, its size in bits, the position of its least-significant
        bit within the register relative to the least-significant bit of the register, its access policy,
        volatility, “HARD” reset value, whether the field value is actually reset (the reset value is
        ignored if FALSE), whether the field value may be randomized and whether the field is the only 
        one to occupy a byte lane in the register.
      */
      this._dummy.configure(this, 8, 0, "RW", 0, 8'h0, 1, 1, 1);
   endfunction: build

   `uvm_object_utils(reg_R)
   
endclass : reg_R


class block_B extends uvm_reg_block;
   rand reg_R R;

   function new(string name = "B");
      super.new(name,UVM_NO_COVERAGE);
   endfunction: new
   
   virtual function void build();

     /*
     virtual function uvm_reg_map create_map( 
       string name,              // address map name
       uvm_reg_addr_t base_addr, // the base addr for the map
       int unsigned n_bytes,     // the byte-width of the bus on which the map is used
       uvm_endianness_e endian,  // endian format
       bit byte_addressing       // specifies whether consecutive addresses refer are 1 byte
                                 // apart (TRUE) or n_bytes apart (FALSE). Default is TRUE.
     )
     */
      default_map = create_map("", 0, 4, UVM_BIG_ENDIAN);

      this.R = reg_R::type_id::create("R");
      this.R.configure(this, null);
      this.R.build();


      /*
      virtual function void add_reg (uvm_reg rg,
      uvm_reg_addr_t offset,
      string rights = "RW",  // access rights
      bit unmapped = 0,
      uvm_reg_frontdoor frontdoor = null )

      Add a register
      Add the specified register instance to this address map. The register is located at the
      specified base address and has the specified access rights (“RW”, “RO” or “WO”). The
      number of consecutive physical addresses occupied by the register depends on the width 
      of the register and the number of bytes in the physical interface corresponding to this
      address map.
      If unmapped is TRUE, the register does not occupy any physical addresses and the base
      address is ignored. Unmapped registers require a user-defined frontdoor to be specified.
      A register may be added to multiple address maps if it is accessible from multiple
      physical interfaces. A register may only be added to an address map whose parent block
      is the same as the register’s parent block.
      */

      default_map.add_reg(R, 'h0,  "RW");
   endfunction : build
   
   `uvm_object_utils(block_B)
   
endclass : block_B



`endif
