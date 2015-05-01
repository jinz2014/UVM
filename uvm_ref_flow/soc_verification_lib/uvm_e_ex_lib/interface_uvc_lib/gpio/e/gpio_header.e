-----------------------------------------------------------------
File name     : gpio_header.e
Created       : Tue Jun 17 13:52:04 2008
Description   : Gpio env header file , contains the logger instances
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

// GPIO environment unit containing the message and file logger instance
unit gpio_env_u like uvm_env {
  logger : message_logger is instance;
  file_logger: message_logger is instance;
  keep soft file_logger.to_screen == FALSE;
  keep soft file_logger.to_file == "gpio";
};

'>
