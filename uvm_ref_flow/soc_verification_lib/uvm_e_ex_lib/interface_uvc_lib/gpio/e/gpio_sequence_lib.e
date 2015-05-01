-----------------------------------------------------------------
File name     : gpio_sequence_lib.e
Created       : Mar 28,2007
Description   : Gpio env header file
Notes         :
-------------------------------------------------------------------
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
-------------------------------------------------------------------

<'

package gpio;

extend gpio_sequence_q_kind : [BASIC];

extend BASIC gpio_sequence_q {
  !lg: gpio_sequence_q;
  body() @driver.clock is only {
    do lg;
  };
};


'>
