-----------------------------------------------------------------
File name     : spi_agent.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares item matching function.
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


extend spi_item_s {

  op_mode        : spi_op_mode_t;
  driving_mode   : spi_driving_mode_t;

  clock_polarity : spi_clock_polarity_t;
  clock_phase    : spi_clock_phase_t;

  data_out: list of bit;
  !data_in: list of bit;
  
  nice_string() :string is only {
    var t1: uint;
    var t2: uint;

    t1 = pack(packing.high,data_out);
    t2 = pack(packing.high,data_in);

     result =  appendf("%s-%s-%s-%s(%x-%x)",op_mode,
     driving_mode,clock_polarity,clock_phase,t1,t2);
  };


  // This method compares this frame with a frame supplied as a parameter.
  // If the compare_dest field is false, then differences in the payload
  // destination fields are ignored. It returns a list of strings that
  // contains all detected differences.
  compare_frames(exp_frame : spi_item_s, 
                compare_dest : bool) : list of string is {

    if exp_frame.data_out != data_out {
      result.add(append("Expected data_out bits: ", 
       exp_frame.data_out,
       ", Actual data_out bits: ", 
       data_out));
    }; // if exp_frame.da...

    if exp_frame.data_in != data_in {
      result.add(append("Expected data_in bits: ", 
       exp_frame.data_in,
       ", Actual data_in bits: ", 
       data_in));
    }; // if exp_frame.da...

    return result;

  }; -- compare_frames()
};

  
'>
