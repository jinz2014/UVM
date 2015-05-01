-----------------------------------------------------------------
File name     : spi_bfm.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file extnds the bfm to add functionality.
Notes         :
-----------------------------------------------------------------
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
-------------------------------------------------------------------

<'

package spi;

extend spi_bfm_u {

  // Event declarations
  event drive_clock_ev;
  event sample_clock_ev;
  event start_of_frame_ev;
  event end_of_frame_ev;
  
  event clock_change_ev is change(my_agent.clk_p$) @sim;
 
  !transaction : spi_item_s ;

  // This TCM continuously gets transactions from the driver and passes 
  // them to the BFM for driving.
  main_loop() @clk_e is {
    while TRUE {
      transaction = my_driver.get_next_item();
      drive(transaction);
      emit my_driver.item_done;
    }; 
  };

  run() is also {
    start main_loop();
  };	   

  // Drive method of the BFM
  drive(data : spi_item_s) @clk_e is {

    all of {

      { 
        generate_clock(data,data.data_out.size()); 
      };

      { 
        drive_data(data);
      };

      { 
        receive_data(data); 
      };

    };  // end all of
  };
    
  generate_clock(data : spi_item_s, cnt: uint) @sys.any is {

    if data is a MASTER spi_item_s {
      if (my_agent.clk_p$ == 0 and (
        (data is a NEGEDGE ALIGNED spi_item_s) or
        (data is a POSEDGE BEFORE spi_item_s))) 
        or
        (my_agent.clk_p$ == 1 and (
        (data is a NEGEDGE BEFORE spi_item_s) or
        (data is a POSEDGE ALIGNED spi_item_s))) {
           
          // delay by half cycle if initial edge cannot be detected
          my_agent.clk_p$ = (my_agent.clk_p$ == 1) ? 0 : 1;
          wait delay(my_agent.cfg.half_clock_period);
        }; 
        
        emit start_of_frame_ev;

        for i from 1 to cnt {
          my_agent.clk_p$ = (my_agent.clk_p$ == 1) ? 0 : 1;
          emit drive_clock_ev;
          wait delay(my_agent.cfg.half_clock_period);
          my_agent.clk_p$ = (my_agent.clk_p$ == 1) ? 0 : 1;
          emit sample_clock_ev;
          wait delay(my_agent.cfg.half_clock_period);
        };

    } else {

      wait true( my_agent.spi_cs_p.get_mvl() == MVL_0 ) @sys.any;
      message(MEDIUM, "Starting to process frame");
      // sync to start edge
      if (data is a NEGEDGE ALIGNED spi_item_s) or 
      (data is a POSEDGE BEFORE spi_item_s) {
        sync true(my_agent.clk_p$ == 0) @clock_change_ev;
      } else {
        sync true(my_agent.clk_p$ == 1) @clock_change_ev;
      }; // ! if (data is a...
      
      // create drive&sample events
      emit start_of_frame_ev;

      for i from 1 to cnt-1 {
        if data is a MASTER spi_item_s {
          my_agent.spi_cs_p$ = 0x0;
        }; // if data is a MA...
        emit drive_clock_ev;
        emit sample_clock_ev;
        wait @clock_change_ev;
        wait @clock_change_ev;
      }; // for i from 1 to...

      emit drive_clock_ev;
      emit sample_clock_ev;
      wait @clock_change_ev;

    };
    emit end_of_frame_ev;
  };   
   

  // TCM to drive the data
  drive_data(data : spi_item_s) @drive_clock_ev is {
    for each in reverse data.data_out {
      if data is a MASTER spi_item_s {
        my_agent.spi_cs_p$ = 0x0;
        my_agent.spi_simo_p$ = it;
      } else {
        if (my_agent.spi_cs_p$ == 0x0) {
          my_agent.spi_somi_p$ = it;
        }; // if (my_agent.sp...
      };
      
      if index != 0 {
        wait cycle;  
        if data is a MASTER spi_item_s {
          my_agent.spi_cs_p$ = 0x1;
        }; // if data is a MA...
      }; // if index != (da...
    };
  }; // drive_data()..
   
  // TCM to collect the received data
  receive_data(data : spi_item_s) @sample_clock_ev is {
    data.data_in.clear();
    for i from 1 to data.data_out.size() {
      if data is a MASTER spi_item_s {
        my_agent.spi_cs_p$ = 0x0;
        data.data_in.add(my_agent.spi_somi_p$);
      } else {
        if (my_agent.spi_cs_p$ == 0x0) {
          data.data_in.add(my_agent.spi_simo_p$);
        }; // if (my_agent.sp...
      };
      
      if i != data.data_out.size() {
        wait cycle;
        if data is a MASTER spi_item_s {
          my_agent.spi_cs_p$ = 0x1;
        }; // if data is a MA...
      };
    }; // for i from ..
    data.data_in = data.data_in.reverse();
  }; // receive_data()..

};


'>

