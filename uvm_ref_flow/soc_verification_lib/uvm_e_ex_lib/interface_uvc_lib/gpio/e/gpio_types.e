-----------------------------------------------------------------
File name     : gpio_types.e
Created       : Tue Jun 17 13:52:04 2008
Description   : This file declares common types used throughout the UVC.
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

--=========================================================================
-- General UVC Types
--========================================================================= 

#ifndef GPIO_DATA_WIDTH {
    define GPIO_DATA_WIDTH 16;
};

type gpio_data_t    : uint(bits:GPIO_DATA_WIDTH);

type gpio_env_name_t       : [DEFAULT];

'>
