-----------------------------------------------------------------
File name     : spi_coverage.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares monitor coverage.
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

extend has_coverage spi_monitor_u  {

  // Observe clock phase (CPHA) and polarity (CPOL) 
  // in slave and master modes with TX and RX traffic.   
  // This should be polled from the CS & SCL lines.
  cover frame_ended_cover using per_unit_instance is {
    item clock_phase : spi_clock_phase_t = monitor_frame.clock_phase;
    item clock_polarity : spi_clock_polarity_t = monitor_frame.clock_polarity;
    item driving_mode : spi_driving_mode_t = monitor_frame.driving_mode;
    cross clock_phase, clock_polarity, driving_mode;
  }; // cover frame_end...

};

//  cover_sequence spi_sequence;
extend has_coverage spi_monitor_u  {

  event frame_ended_cover;
  
  !monitor_frame : spi_item_s;
  
  collect_frame(frame:spi_item_s ) is {
    monitor_frame=frame.copy();
    emit frame_ended_cover;
  };   
   
}; // extend spi_m...

extend spi_sequence_driver_u {

  on item_done{
    my_agent.monitor.as_a(has_coverage spi_monitor_u).collect_frame(last(0));
  }; // on item_done
};

'>
