/*-------------------------------------------------------------------------
File name   : apb_subsystem_uart_seq_lib.e
Title       : Sequence library 
Project     :
Created     : November 2010
Description : UART test to transmit and receive packets

Notes       : Limitations - Start bit errors not introduced as scoreboard not
                            sensitive to it.
                            
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


<'

package apb_subsystem_pkg;

// UART Config Sequence
extend UART_CONFIG'kind ahb::ahb_master_seq {

  base_address : uint; 

  !div_lsb     : WRITE ahb::ahb_master_driven_burst;
  !lcr_div     : WRITE ahb::ahb_master_driven_burst;
  !div_msb     : WRITE ahb::ahb_master_driven_burst;
  !intr_en     : WRITE ahb::ahb_master_driven_burst;
  !lcr         : WRITE ahb::ahb_master_driven_burst;

  uart_config  : uart_env_config;

  !parity_sel  : uint(bits:1);
  !parity_val  : uint(bits:1);
  !stopbit_val : uint(bits:1);
  !datalen_val : uint(bits:2);
  !data_value  : uint(bits:8);

  body() @driver.clock is only {

    wait [400] * cycle;

    var temp_data     : uint(bits:32);
    temp_data = 32'h0;

    case UART_INTR_EN_REG {
      0 : { temp_data = 32'h00_00_00_11; };
      1 : { temp_data = 32'h00_00_11_00; }; 
      2 : { temp_data = 32'h00_11_00_00; };
      3 : { temp_data = 32'h11_00_00_00; };
    };

    messagef(LOW,"Data Written into the UART_INTR_EN_REG is %x ",temp_data);
    do intr_en keeping {
      it.first_address == base_address + UART_INTR_EN_REG;
      it.data[0]       == temp_data;
      it.size          == BYTE;
      it.kind          == SINGLE;
      it.direction     == WRITE;
    };

    temp_data = 32'h0;

    wait [10] * cycle;

    case UART_LINE_CNTRL_REG {
      0 : { temp_data = 32'h00_00_00_83; };
      1 : { temp_data = 32'h00_00_83_00; }; 
      2 : { temp_data = 32'h00_83_00_00; };
      3 : { temp_data = 32'h83_00_00_00; };
    };

    messagef(LOW,"Data Written into the UART_LINE_CNTRL_REG is %x ",temp_data);
    do lcr_div keeping {
      it.first_address == base_address + UART_LINE_CNTRL_REG;
      it.size          == BYTE;
      it.data[0]       == temp_data;
      it.kind          == SINGLE;
      it.direction     == WRITE;
    };

    wait [10] * cycle;

    temp_data = 32'h0;

    messagef(LOW,"Data Written into the UART_DIVISOR_MSB_REG is %x ",temp_data);
    do div_msb keeping {
      it.first_address == base_address + UART_DIVISOR_MSB_REG;
      it.size          == BYTE;
      it.kind          == SINGLE;
      it.data[0]       == temp_data;
    };

    wait [10] * cycle;

    temp_data = 32'h0;

    case UART_DIVISOR_LSB_REG {
      0 : { temp_data = 32'h00_00_00_01; };
      1 : { temp_data = 32'h00_00_01_00; }; 
      2 : { temp_data = 32'h00_01_00_00; };
      3 : { temp_data = 32'h01_00_00_00; };
    };

    messagef(LOW,"Data Written into the UART_DIVISOR_LSB_REG is %x ",temp_data);
    do div_lsb keeping {
      it.first_address == base_address + UART_DIVISOR_LSB_REG;
      it.data.size()   == 1;
      it.size          == BYTE;
      it.kind          == SINGLE;
      it.data[0]       == temp_data;
    };
     
    var stop_bits := uart_config.stopbit_type;
    var parity    := uart_config.parity_type;
    var data_len  := uart_config.databit_type; 

    case (parity) {
 
      EVEN  : { parity_sel = 1'b1; parity_val = 1;};
      ODD   : { parity_sel = 1'b1; parity_val = 0;};
      SPACE : { parity_sel = 1'b0; parity_val = 0;dut_error("UNSUPPORTED PARITY");};
      NONE  : { parity_sel = 1'b0; parity_val = 0;};
 
    };

    case (stop_bits) {
      ONE      : { stopbit_val  = 0};
      TWO      : { stopbit_val  = 1};
      default  : { };  
    };

    case (data_len) {
      SIX   : { datalen_val = 1};
      SEVEN : { datalen_val = 2};
      EIGHT : { datalen_val = 3};  
    };

    data_value = %{parity_val, parity_sel,stopbit_val,datalen_val};

    wait [10] * cycle;

    do lcr keeping {
      it.first_address == base_address + UART_LINE_CNTRL_REG;
      it.size          == BYTE;
      it.data[0]       == %{data_value,24'h0};
      it.data.size()   == 1;
      it.kind          == SINGLE;
    };

    wait [100] * cycle;

  }; //body()..
};// extend UART_CONFIG..

extend ahb_master_seq_kind : [UART_POLL];

extend UART_POLL'kind ahb::ahb_master_seq {

  !tx_fifo_wr   : WRITE        ahb::ahb_master_driven_burst;
  !rxfifo_read  : UART_DR_READ ahb::ahb_master_seq;

  base_address : uint(bits:32);
  keep rxfifo_read.base_address == read_only(base_address);

  rx_pkt_max   : uint(bits:8);
  keep soft rx_pkt_max == 9;

  body() @driver.clock is only {

    //-------------------------------------------
    // Transmit packets from DUT
    //-------------------------------------------
    for i from 0 to rx_pkt_max {

      do tx_fifo_wr keeping {
        it.first_address == base_address + UART_FIFO_REG;
        it.size          == BYTE;
        it.kind          == SINGLE;
      };

      wait [9] * cycle;

    };

    for i from 0 to rx_pkt_max {
      do rxfifo_read;
      wait [9] * cycle;
    };

  };// body()..
}; // extend UART_POLL..

'>

