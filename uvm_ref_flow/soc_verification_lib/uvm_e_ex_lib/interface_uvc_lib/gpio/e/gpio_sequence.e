---------------------------------------------------------------
File name   : gpio_sequence_h.e
Created     : Tue Jun 17 13:52:03 2008
Description : This file declares the sequence interface of the Interface.
Notes       :  
---------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
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
---------------------------------------------------------------

<'
package gpio;

-- The generic sequence for the Interface agent sequence
sequence gpio_sequence_q using 
    item = gpio_transfer,
    created_driver = gpio_sequencer_u,
    created_kind = gpio_sequence_kind_t;

extend gpio_sequence_q {

    -- This is a utility field for basic sequences.
    -- This enables "do transfer ...".
    !transfer: gpio_transfer;
}; 

extend MAIN gpio_sequence_q {
    
    -- If this field is true (the default), then an objection to TEST_DONE
    -- is raised for the duration of the MAIN sequence. If this field is false
    -- then the MAIN sequence does not contribute to the determination of
    -- end-of-test.
    prevent_test_done : bool;
        keep soft prevent_test_done == FALSE;
    
   -- This field controls the delay between the end of the MAIN sequence
    -- and the dropping of the objection to TEST_DONE (that is, the time
    -- allowed for the last data to drain through the DUT). This is
    -- measured in clock cycles. The default value is 10 clock cycles.
    drain_time : uint;
        keep soft drain_time == 10;
    
    -- Raise an objection to TEST_DONE whenever a MAIN sequence is started.
    pre_body() @sys.any is first {
        message(LOW, "MAIN sequence started");
        if prevent_test_done {
            driver.raise_objection(TEST_DONE);
        };
    }; -- pre_body()
         
    -- Drop the objection to TEST_DONE 10 clock cycles after the MAIN
    -- sequence ends.
    post_body() @sys.any is also {
        message(LOW, "MAIN sequence finished");
        if prevent_test_done {
           wait [drain_time] * cycle @driver.clock;
           driver.drop_objection(TEST_DONE);
        };
    }; 

}; 

'>
