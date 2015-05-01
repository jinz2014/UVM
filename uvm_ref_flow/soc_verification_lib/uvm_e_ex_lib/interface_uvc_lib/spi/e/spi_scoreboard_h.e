/*------------------------------------------------------------------------- 
File name   : spi_scoreboard_h.e
Title       : Scoreboard
Project     : SPI eVC
Created     : 01-May-2006
Description : This file provides a generic homogeneous Spi scoreboard.
Notes       : This scoreboard is intended for systems where the order of
            : frames must be preserved. As such, there is no implementation
            : of an 'ID' field in each item in the scoreboard. This means
            : that once one missing or extra frame has been detected, further
            : testing cannot sensibly continue. 
            :
            : More complex scoreboarding techniques can be used, but this
            : example is deliberately kept simple.
            :
            : This scoreboard also contributes to 'end of test'
            : determination. Each time an item is added to the scoreboard,
            : one objection to TEST_DONE is raised. Each time an item is 
            : removed from the scoreboard one objection to TEST_DONE is 
            : dropped. Thus whenever there are pending items in the
            : scoreboard, the scoreboard objects to the end of test.
            : This feature can be disabled by setting the prevent_test_done
            : flag to FALSE.
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
---------------------------------------------------------------------------
 
<'

package spi;

// This unit is a generic homogenous scoreboard for the Spi eVC that can
// be used to check data integrity between the two ends of a data path.
unit spi_scoreboard_u {

  // This field can be used to give each scoreboard a unique name which
  // will be printed with error messages.
  name : string;
  keep soft name == "";
  
  // If this field is TRUE (the default), then each item added to the
  // scoreboard raises an objection to TEST_DONE and each item removed from
  // the scoreboard drops an objection to TEST_DONE. If this field is FALSE
  // then the scoreboard does not contribute to the determination of
  // end-of-test.
  prevent_test_done : bool;
  keep soft prevent_test_done == TRUE;

  // If this field is TRUE (the default), then a check is performed at the
  // end of the test that the scoreboard is empty.  
  check_empty : bool;
  keep soft check_empty == TRUE;

  // If this field is TRUE (the default), then the destination fields are
  // compared when a frame is removed from the scoreboard. If FALSE, then
  // the destination fields are ignored.
  compare_destinations : bool;
  keep soft compare_destinations == TRUE;

  // This is a list of all the frames that have been added to the
  // scoreboard but have yet to be checked off.
  !scoreboard : list of spi_item_s;
  
  // Instantiate an in TLM port for the add() logic
  add : in interface_port of tlm_analysis of spi_item_s using 
                                     prefix=add_ is instance;
  keep bind(add, empty);
  
  // This method should be called to add a frame to the scoreboard. This
  // signifies that the frame has been sent at one end of the system.
  add_write(frame : spi_item_s) is {
    scoreboard.add(frame);        
    if prevent_test_done {
      raise_objection(TEST_DONE);
    };
  }; -- add_write()
  
  // Instantiate an in TLM port for the match() logic
  match : in interface_port of tlm_analysis of spi_item_s
                         using prefix=match_ is instance;
  keep bind(match, empty);

  // This method should be called when a frame is received at the other
  // end of the system. The received frame is then compared with the
  // oldest item on the scoreboard and removed if a match is found. If the
  // oldest item on the scoreboard is not an exact match, an error is
  // produced.
  match_write(frame : spi_item_s) is {        
    check that not scoreboard.is_empty()
      else dut_error("Scoreboard '", name, 
         "': cannot match item as no items are expected");
    if not scoreboard.is_empty() {
      var diff_list : list of string = 
             frame.compare_frames(scoreboard[0], compare_destinations);
      check that diff_list.is_empty()
          else dut_error("Scoreboard '", name, 
               "' - detected frame did not match expected frame\n", 
               diff_list, "\n",
               "detected frame: ", frame, "\n",
               "expected frame: ", scoreboard[0]);
      scoreboard.delete(0);
      if prevent_test_done {
          drop_objection(TEST_DONE);
      };
    };
  }; -- match_write();
  
  // This method can be called by the user to ascertain whether the
  // scoreboard is currently empty.
  is_empty() : bool is {
    result = scoreboard.is_empty()
  }; -- is_empty()
  
  // This method checks that the scoreboard is empty at the end of the test.
  check() is also {
    check that (not check_empty) or scoreboard.is_empty()
      else dut_error("Scoreboard '", name, 
           "' is not empty at end of test");
  }; -- check()
  
  // This method should be called to clear the contents of the scoreboard.
  clear() is {
    if not is_empty() {
      if prevent_test_done {
        for i from 1 to scoreboard.size() {
          drop_objection(TEST_DONE);
        };
      };
      scoreboard.clear();
    };
  }; -- clear()
}; -- unit spi_scoreboard_u 


'>
