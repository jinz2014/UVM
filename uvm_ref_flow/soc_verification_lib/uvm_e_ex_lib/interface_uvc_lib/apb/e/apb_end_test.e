/*-------------------------------------------------------------------------
File name   : apb_end_test.e
Title       : End of test
Project     : APB UVC
Developers  : 
Created     :
Description : This file handles 'end of test'.

Notes       :  End-of-test handling is managed by the objection
            :  mechanism. Each proactive MAIN sequence raises an
            :  objection to TEST_DONE at the start of the sequence
            :  and drops the objection at the end of the sequence.
            :  A drain time (default: 10 cycles) is used to ensure
            :  that the test has really finished.

---------------------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.

-------------------------------------------------------------------------*/


<'

package apb;

extend MAIN apb_master_sequence {
  
  // If this field is true (the default), then an objection to TEST_DONE
  // is raised for the duration of the MAIN sequence. If this field is false
  // then the MAIN sequence does not contribute to the determination of
  // end-of-test.
  prevent_test_done : bool;
  keep soft prevent_test_done == TRUE;
};

extend MAIN ENV_SETUP apb_master_sequence {

  // Raise an objection to TEST_DONE whenever a MAIN sequence is started.
  pre_body() @sys.any is first {
    message(LOW, "MAIN ENV_SETUP sequence started");

    if prevent_test_done {
      driver.raise_objection(TEST_DONE);
    };
  }; -- pre_body()
};
     
extend MAIN POST_TEST apb_master_sequence {

  // This field controls the delay between the end of the MAIN sequence
  // and the dropping of the objection to TEST_DONE (that is, the time
  // allowed for the last data to drain through the DUT). This is
  // measured in clock cycles. The default value is 10 clock cycles.
  drain_time : uint;
  keep soft drain_time == 10;
    
  // Drop the objection to TEST_DONE after drain time cycles
  // sequence ends.
  post_body() @sys.any is also {
    message(LOW, "MAIN sequence finished");
    if prevent_test_done {
      wait [drain_time] * cycle @driver.clock;
      driver.drop_objection(TEST_DONE);
    };
  }; 
}; 

'>
