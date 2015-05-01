---------------------------------------------------------------
File name   :  apb_env.e
Title       :  Env unit implementation
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file adds implements the env unit.
Notes       :  This file containsthe env unit of APB UVC
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

package apb;

import apb_memory_map.e;

// APB Environment Unit
extend apb_env {
  
  // This field holds the logical name of this env. 
  // This field must be constrained by the user in the config file.
  name  : apb_env_name_t;

  reserved_space : apb_reserved_space_s; // for user memory map
  keep soft reserved_space.name == read_only(name);

  p_memory_map : apb_memory_map_u;
  post_generate() is also {
    p_memory_map.name = value(name); 
  };

  // Report the final status at the end of the test.
  finalize() is also {
    message(LOW, "Test done:");
    show_status();
  }; 
};


'>
