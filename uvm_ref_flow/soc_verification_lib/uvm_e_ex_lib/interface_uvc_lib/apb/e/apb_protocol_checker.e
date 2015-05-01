---------------------------------------------------------------
File name   :  apb_protocol_checker.e
Title       :  Protocol checker
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements the optional protocol checker.

Notes       :  Protocol checker functionality is an extension of the
            :  bus and agent monitor units. It is not included in the
	       code at present
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

extend has_checks apb_env {}; 

extend has_checks apb_bus_monitor {};

'>
