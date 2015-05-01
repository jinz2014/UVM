---------------------------------------------------------------
File name   :  apb_top.e
Title       :  APB UVC top file
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file imports all the files of the UVC.
Notes       :  This file contains import of all files of APB UVC
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

// Import the UVM 'e' Top File
import uvm_e/e/uvm_e_top.e;

// The following import is not needed if the eRM lib is compiled on top of Specman
import vr_ad/e/vr_ad_top;

// Header files
import apb/e/apb_types_h;
import apb/e/apb_smp_h;
import apb/e/apb_transaction_h;
import apb/e/apb_monitor_h;
import apb/e/apb_master_sequence_h; 
import apb/e/apb_slave_sequence_h; 
import apb/e/apb_bfm_h;
import apb/e/apb_agent_h;
import apb/e/apb_env_h;

// Implementation files
#ifndef SPECMAN_ADVANCED_LABS {
  import apb/e/apb_master_bfm;
} #else { 
  import $UVM_REF_HOME/kit_labs/spmn_adv_option/lab4/pkg_lib/apb/e/apb_master_bfm;
};
import apb/e/apb_slave_bfm; 
import apb/e/apb_monitor;   
import apb/e/apb_master;
import apb/e/apb_slave;
import apb/e/apb_env; 
import apb/e/apb_protocol_checker; 

import apb/e/apb_bus_coverage; 
import apb/e/apb_end_test; 
import apb/e/apb_tf_config; 


'>
