/*-------------------------------------------------------------------------
File name   : uart_ctrl_reg.e
Title       : UART register 
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the registers for UART 

Notes       : Uart register declartion with vr_ad macro 
            :
-------------------------------------------------------------------------*/
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
// 
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
// ----------------------------------------------------------------------

<'


package uart_ctrl_pkg;


// Adding the address map, register files, and the registers.



// Extend the register file kind and add UART_CORE
extend vr_ad_reg_file_kind : [UART_CORE];


extend UART_CORE vr_ad_reg_file {

  // Each address in the register file contains 1 byte
  keep addressing_width_in_bytes == 1;
  keep size == 32'h0000_00FF;
  keep packing_mode ==packing.low;
   
  run() is {
    reset();
  };
   
};

reg_def  UART_FIFO_DIV_REG  UART_CORE  0x0000_0000 { 
  reg_fld data : uint(bits:8) : RW : 0x0;
};

reg_def  UART_INTR_ENABLE_REG  UART_CORE  0x0000_0001 { 
  // Custom Fields
  reg_fld rcv_data_available          : uint(bits:1) : RW : 0x0 : cov;
  reg_fld transmit_empty              : uint(bits:1) : RW : 0x0 : cov;
  reg_fld rcv_line_status             : uint(bits:1) : RW : 0x0 : cov;
  reg_fld modem_status                : uint(bits:1) : RW : 0x0 : cov;
  reg_fld rsvd                        : uint(bits:4) : R : 0x0;
};

reg_def  UART_FIFO_CONTROL_REG  UART_CORE  0x0000_0002 { 
  // Custom Fields
  reg_fld fifo_mode                   : uint(bits:1) : W : 0x0 : cov;
  reg_fld rcv_fifo_clear              : uint(bits:1) : W : 0x0 : cov;
  reg_fld transmit_fifo_clear         : uint(bits:1) : W : 0x0 : cov;
  reg_fld ignore                      : uint(bits:3) : W : 0x0;
  reg_fld trigger_level               : uint(bits:2) : W : 0x3 : cov;
};

reg_def  UART_LINE_CONTROL_REG  UART_CORE  0x0000_0003 { 
  // Custom Fields
  reg_fld num_of_bits                 : uint(bits:2) : RW : 0x3 : cov;
  reg_fld num_of_stop_bits            : uint(bits:1) : RW : 0x0 : cov;
  reg_fld parity_enable               : uint(bits:1) : RW : 0x0 : cov;
  reg_fld even_parity                 : uint(bits:1) : RW : 0x0 : cov;
  reg_fld sticky_parity               : uint(bits:1) : RW : 0x0 : cov;
  reg_fld break_control               : uint(bits:1) : RW : 0x0 : cov;
  reg_fld div_reg_access              : uint(bits:1) : RW : 0x0 : cov;
};

reg_def  UART_MODEM_CONTROL_REG  UART_CORE  0x0000_0004 { 
  // Custom Fields
  reg_fld dtr_control                 : uint(bits:1) : W : 0x0 : cov;
  reg_fld rts_control                 : uint(bits:1) : W : 0x0 : cov;
  reg_fld out1_loopback_mode          : uint(bits:1) : W : 0x0 : cov;
  reg_fld out2_loopback_mode          : uint(bits:1) : W : 0x0 : cov;
  reg_fld loopback_mode               : uint(bits:1) : W : 0x0 : cov;
  reg_fld reserved                    : uint(bits:3) : R : 0x0;
};

reg_def  UART_LINE_STATUS_REG  UART_CORE  0x0000_0005 { 
  // Custom Fields
  reg_fld data_ready                  : uint(bits:1) : R : 0x0 : cov;
  reg_fld overrun_err                 : uint(bits:1) : R : 0x0 : cov;
  reg_fld parity_err                  : uint(bits:1) : R : 0x0 : cov;
  reg_fld framing_err                 : uint(bits:1) : R : 0x0 : cov;
  reg_fld break_intr                  : uint(bits:1) : R : 0x0 : cov;
  reg_fld trnasmit_fifo_empty         : uint(bits:1) : R : 0x0 : cov;
  reg_fld tramsnitter_empty           : uint(bits:1) : R : 0x0 : cov;
  reg_fld error                       : uint(bits:1) : R : 0x0 : cov;
};

reg_def  UART_MODEM_STATUS_REG  UART_CORE  0x0000_0006 { 
  // Custom Fields
  reg_fld delta_cts                   : uint(bits:1) : R : 0x0 : cov;
  reg_fld delta_dsr                   : uint(bits:1) : R : 0x0 : cov;
  reg_fld raise_ri                    : uint(bits:1) : R : 0x0 : cov;
  reg_fld delta_dcd                   : uint(bits:1) : R : 0x0 : cov;
  reg_fld complement_cts              : uint(bits:1) : R : 0x0 : cov;
  reg_fld complement_dsr              : uint(bits:1) : R : 0x0 : cov;
  reg_fld complement_ri               : uint(bits:1) : R : 0x0 : cov;
  reg_fld complement_dcd              : uint(bits:1) : R : 0x0 : cov;
};


extend  vr_ad_reg_file {

  run() is also {
    var  reg_list : list of vr_ad_reg;
    if reg_list is empty {
      reg_list = get_all_regs();
    };
    for each (r) in reg_list {
      if r.kind == UART_FIFO_DIV_REG {
        r.static_info.compare_mask = 0;
      };
    }; // for ..
  };  // run()..
}; // extend  vr_ad_reg_file..



extend UART_INTR_ENABLE_REG  vr_ad_reg {
  post_access(direction : vr_ad_rw_t) is {
    var p_reg_file := get_parents()[0].as_a(UART_CORE vr_ad_reg_file);
    if (p_reg_file.uart_line_control_reg.div_reg_access == 1) {
      write_reg_val(static_info.prev_value);
    };
  };
};


'>
