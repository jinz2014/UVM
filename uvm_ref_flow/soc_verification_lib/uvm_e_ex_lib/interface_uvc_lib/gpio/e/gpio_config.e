---------------------------------------------------------------
File name   : gpio_config.e
Created     : Tue Jun 17 13:52:03 2008
Description : GPIO config file
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
extend gpio_env_u {
  ind: int;
  keep soft ind == 0;
  io_width : int;
  keep soft io_width == GPIO_IO_WIDTH;
  evc_name : string;
  keep soft evc_name == append("gpio ",dec(ind));
    
  short_name(): string is only {
    return append(evc_name);
  };
};

'>

