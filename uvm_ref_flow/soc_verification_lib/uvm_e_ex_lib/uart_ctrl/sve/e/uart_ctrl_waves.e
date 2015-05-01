---------------------------------------------------------------
File name   :  uart_ctrl_waves.e
Title       :  Send trace sequence command to specman
Project     :  Module UART
Developers  :  
Created     :  November 2010

---------------------------------------------------------------
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
// ----------------------------------------------------------------------

<'

extend sys {

// Some code to trace sequences the waveform viewer after the env is 
// generated (gets the Specman objects in as well)

// NOTE that there seems to be a limitation: if the simulation is restarted
// (and e files reloaded and test command issued again, 
//  the Specman objects are not traced

// Fix: Enter "trace seq" after reset+reload in the specman tab before or after the test is issued

  run() is also {
    specman("trace seq");
  };

};

'>
