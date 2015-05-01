-----------------------------------------------------------------
File name     : tc_demo.e
Developers    : vishwana
Created       : Tue Jul 27 13:52:04 2008
Description   : This is the demo testcase
-------------------------------------------------------------------
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

import spi/examples/spi_demo_config;

extend DEMO_INST1 MAIN spi_sequence {

  !sensor_seq : SIMPLE spi_sequence;
 
  body() @driver.clock is only {
    do sensor_seq;
  };
};


extend DEMO_INST2 MAIN spi_sequence {

  !sensor_seq : SIMPLE spi_sequence;
 
  body() @driver.clock is only {
    do sensor_seq;
  };
};


'>
