/*-------------------------------------------------------------------------
File name   : data_poll_common.e
Title       : UART functionality 
Project     : Module UART
Created     :
Description : Performs UART configuration through APB Sequence
Notes       :  
//---------------------------------------------------------------------------
// Copyright 1999-2010 Cadence Design Systems, Inc.
// All Rights Reserved Worldwide
//
// Licensed under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of
// the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in
// writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See
// the License for the specific language governing
// permissions and limitations under the License.
//------------------------------------------------------------------------*/
<'

extend sys {

  //---------------------------------------------
  // Create events to signify config & reset done
  //---------------------------------------------
  event VR_SB_uart_config_done;
  event VR_SB_uart_data_done;
  event VR_SB_uart_read_done;
  event VR_SB_uart_div_config_done;
  event reset_done is @uart_ctrl_sve.uart_sync.reset_ended;

  //--------------------------------------------------
  // Setting larger value of tick_max for longer tests
  //--------------------------------------------------
  setup() is also {
    set_config(run, tick_max,MAX_INT);
  };

}; // extend sys

//------------------------------------------------------
// Configuration will be performed through APB Sequence.
// Thus no vr_ad sequence is used.
//------------------------------------------------------
extend MAIN vr_ad_sequence {
  body() @driver.clock is only {
  };
};

// Restrict to ODD and EVEN parity
extend uart_env_config {
  keep parity_type in [ODD, EVEN];
};

//-----------------------------------------------------
// APB Sequence to poll UART registers:
//-----------------------------------------------------
extend MAIN  MAIN_TEST apb_master_sequence {

  !div_lsb  : WRITE apb::apb_master_transaction;
  !div_msb  : WRITE apb::apb_master_transaction;
  !lcr      : WRITE apb::apb_master_transaction;

  config : uart_env_config;
  keep config == get_enclosing_unit(uart_ctrl_sve_u).uart_if.config;

  !parity_sel  : uint(bits:1);
  !parity_val  : uint(bits:1);
  !stopbit_val : uint(bits:1);
  !datalen_val : uint(bits:2);
  !data_value  : uint(bits:32);

  body() @driver.clock is only {

    wait [400] * cycle;
    driver.wait_for_grant(me);

    gen trans keeping {
      it.addr == UART_INTR_EN_REG;
      it.data == 32'h00001100;
      it.direction == WRITE;
    };

    driver.deliver_item(trans);
    driver.wait_for_item_done(me);   

    gen trans keeping {
      it.addr  == UART_LINE_CNTRL_REG;
      it.data  == 32'h83000000;
      it.direction == WRITE;
    };

    driver.wait_for_grant(me);
    driver.deliver_item(trans);
    driver.wait_for_item_done(me);   

    do div_msb keeping {
      it.addr == UART_DIVISOR_MSB_REG;
      it.data == 0;
    };

    do div_lsb keeping {
      it.addr == UART_DIVISOR_LSB_REG;
      it.data == 1;
    };
     
    var stop_bits := config.stopbit_type;
    var parity    := config.parity_type;
    var data_len  := config.databit_type; 

    case (parity) {
      EVEN : { parity_sel = 1'b1; parity_val = 1;};
      ODD  : { parity_sel = 1'b1; parity_val = 0;};
      SPACE: { parity_sel = 1'b0; parity_val = 0;dut_error("UNSUPPORTED PARITY");};
      NONE : { parity_sel = 1'b0; parity_val = 0;};
    };

    case (stop_bits) {
      ONE      : { stopbit_val = 0};
      TWO      : { stopbit_val = 1};
      default  : { };  
    };

    case (data_len) {
      SIX   : { datalen_val = 1};
      SEVEN : { datalen_val = 2};
      EIGHT : { datalen_val = 3};  
    };

    data_value = pack(packing.high, 3'b0, parity_val , parity_sel, stopbit_val, datalen_val , 24'b0);

    do lcr keeping {
      it.addr == UART_LINE_CNTRL_REG;
      it.data == data_value ;
    };

    wait [100] * cycle;
    emit sys.VR_SB_uart_config_done;

  }; // body()..
};

'>

