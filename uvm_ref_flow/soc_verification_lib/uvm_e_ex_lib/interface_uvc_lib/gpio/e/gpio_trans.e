-----------------------------------------------------------------
File name     : gpio_trans.e
Created       : Mar 28, 2007 
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
-- pin val is always randomized
-- if rtl is driving data to pad, the data gets collected in pin_val
-- if model is driving pad the pin_val is driven to the pad. 
struct gpio_trans_s like any_sequence_item {
  pin_val: list of bit;
  keep pin_val.size() == GPIO_IO_WIDTH;
};
'>
