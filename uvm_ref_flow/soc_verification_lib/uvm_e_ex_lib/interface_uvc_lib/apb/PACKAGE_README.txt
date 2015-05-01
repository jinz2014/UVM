----------------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
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
----------------------------------------------------------------------
* Title       :     Package for the APB bus protocol.
* Name        :     apb
* Created     :     March 2011
* Version     :     1.02
* Description :
 
This is the APB UVC.
It can support multiple slaves and can drive as well as monitor
transactions at apb interface.The UVC is implemented in Specman 'e' 
and is UVM e compatible.

* Directory structure:

  e/    --- apb interface UVC files 
  examples/ --  Verification Environment examples

* Demo script

  Path : apb/demo.sh

  demo.sh - This script is used to demo the apb UVC. 
  To get the usage details : ./demo.sh -h
