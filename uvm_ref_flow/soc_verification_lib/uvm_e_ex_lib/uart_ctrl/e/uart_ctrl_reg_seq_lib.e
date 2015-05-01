/*-------------------------------------------------------------------------
File name   : uart_ctrl_reg_seq_lib.e
Title       : Sequence library
Project     : Module UART
Developers  : 
Created     : November 2010
Description : This file contains the library of sequence for UART registers using vr_ad 
            : relevant to Module uart environment

Notes       : Library of sequence for uart and apb evc
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

extend vr_ad_sequence_kind : [UART_CONFIG];

// UART Config sequence
extend UART_CONFIG'kind vr_ad_sequence {

  !line_ctrl_reg   : UART_LINE_CONTROL_REG vr_ad_reg;
  !div_ctrl_reg    : UART_FIFO_DIV_REG vr_ad_reg;
  !intr_enable_reg : UART_INTR_ENABLE_REG  vr_ad_reg;

  uart_config      : uart_env_config;

  !parity_sel      : uint(bits:1);
  !parity_val      : uint(bits:1);
  !stopbit_val     : uint(bits:1);
  !datalen_val     : uint(bits:2);
  !data_value      : uint(bits:32);

  div_val          : uint(bits:8);
  keep soft div_val == 8'h1;

  line_ctrl_val    : uint(bits:8);
  keep soft line_ctrl_val == 8'h83;

  intr_en_val      : uint(bits:8);
  keep soft intr_en_val == 8'h11;

  // UART_CORE Register File
  reg_file         : UART_CORE vr_ad_reg_file;

  body() @driver.clock is only {

    // Writing into the interrupt enable register
    write_reg {.static_item == reg_file} intr_enable_reg value intr_en_val;

    // Writing into the line control register
    write_reg {.static_item == reg_file} line_ctrl_reg  value line_ctrl_val;

    intr_en_val = 0; // Below is for div registers

    write_reg {.static_item == reg_file}  div_ctrl_reg  value div_val;

    // WRITING MSB OF DIV REGISTER
    write_reg  {.static_item == reg_file} intr_enable_reg value intr_en_val;
    
    var stop_bits := uart_config.stopbit_type;
    var parity    := uart_config.parity_type;
    var data_len  := uart_config.databit_type; 

    case (parity) {
 
      EVEN : { parity_sel = 1'b1; parity_val = 1;};
      ODD  : { parity_sel = 1'b1; parity_val = 0;};
      SPACE: { parity_sel = 1'b0; parity_val = 0;dut_error("UNSUPPORTED PARITY");};
      NONE : { parity_sel = 1'b0; parity_val = 0;};
 
    };

    case (stop_bits) {

      ONE   : { stopbit_val  = 0};
      TWO   : { stopbit_val  = 1};
      default  : { };  

    };

    case (data_len) {

      SIX   : { datalen_val = 1};
      SEVEN : { datalen_val = 2};
      EIGHT : { datalen_val = 3};  

    };

    line_ctrl_val = pack(packing.high, 3'b0, parity_val , parity_sel, stopbit_val, datalen_val );
    write_reg  {.static_item == reg_file} line_ctrl_reg  value line_ctrl_val;

 }; // body()..
}; // extend UART_CONFIG'kind..

// Common configuration sequence (just a mock example ... does not really do anything
// other than write/read from a single register)
extend vr_ad_sequence_kind : [CONFIG_COMMON];
extend CONFIG_COMMON vr_ad_sequence {
   
   !intr_enable_reg : UART_INTR_ENABLE_REG  vr_ad_reg;
   
   intr_en_val      : uint(bits:8);
   
   // UART_CORE Register File
   reg_file         : UART_CORE vr_ad_reg_file;
   
   config_count: uint;
   keep soft config_count == 400;

   body() @driver.clock is only {
      for i from 1 to config_count do {
         gen intr_en_val;

         // Writing into the interrupt enable register
         write_reg {.static_item == reg_file} intr_enable_reg value intr_en_val;
         
         // Reading the interrupt enable register
         read_reg intr_enable_reg;
      };
   };
};

'>
