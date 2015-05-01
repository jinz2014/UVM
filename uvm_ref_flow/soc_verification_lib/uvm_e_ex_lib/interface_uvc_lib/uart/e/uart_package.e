/*-----------------------------------------------------------------
File name     : uart_package.e
Title         : uart Package file
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : 
Notes         : 
-------------------------------------------------------------------*/
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
//----------------------------------------------------------------------

<'

package uart;

extend uart_env_u {

  // Print a banner for each eVC instance at the start of the test
  show_banner() is also {
    out("(c) Verisity 2004");
    out("eVC instance : ", evc_name);
  };
    
  // Implement the show_status() method
  show_status() is only {
    out("uart eVC - Template : ", evc_name);
  };
        
}; 

'>


