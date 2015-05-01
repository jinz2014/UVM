/*-----------------------------------------------------------------
File name     : uart_monitor_rx.e
Title         : UART RX Monitor
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : 
Notes         : 
                -- Vardit 6  JUN 04 - customer (oPlus)debug and add break phase signal     
-------------------------------------------------------------------*/
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
//----------------------------------------------------------------------

<'

package uart;

// Declare the RX monitor unit 
extend has_checker RX uart_monitor_u  {

  perform_reset_protocol_checking() is {
    check that (ssmp.sig_sec_cdma_rx_data$ == 1 and ssmp.sig_sec_cdma_rfrb$ == 1 ) else 
      dut_error("ERR_SEC_DMA_UART_ON_RESET: RX in env - ",evc_name," drove RX_DATA or RFRB to 0x0 during reset although the expected value is 0x1");
  };
};


extend RX uart_monitor_u  {
   	
  record_data() @p_sync.clk_r is {

    var cnt : uint = 0;
    var cyc : uint = 0;
    -- initial waits
    wait until true((ssmp.sig_sec_cdma_rx_data$) == 0);

    while TRUE {
      if not valid_data_phase and (ssmp.sig_sec_cdma_rx_data$) == 0 then {
        if break_phase { -- cust correct
          cyc =0;
	} else {
	  cyc =1;
	};
        cnt = 0;
        valid_data_phase = TRUE;
      } else if cyc == 15 then {
        cyc = 0;
        emit mon_clk;
      } else {
        cyc += 1;
      };

      if cyc == 15 then {
        data_b = (cnt >= threshold)? 0 : 1;
        cnt = 0;
      } else {
        if (ssmp.sig_sec_cdma_rx_data$ == 0) then {
          cnt += 1;
        };
      };
      wait cycle;
    }; // while TRUE
  }; // record_data()..

  on mon_frame_ended {
    frame_ended$.write(current_frame);
    message(MEDIUM, "UVC received a frame, data to be checked");
  };

}; // extend RX uart_monitor_u..

'>

