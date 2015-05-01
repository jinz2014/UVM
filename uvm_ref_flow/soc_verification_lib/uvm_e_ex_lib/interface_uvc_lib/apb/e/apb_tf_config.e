/*-------------------------------------------------------------------------  
File name   : apb_tf_config
Title       : Test flow Configurations
Project     : APB UVC
Created     : 2008
Description : Testflow configuration - define clocks for phases
Notes       : 
--------------------------------------------------------------------------- 
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
-------------------------------------------------------------------------*/ 
 

<'

// -------------------------------------------------------------------------------
// Each unit that participates in the testflow uses the clocking event tf_phase_clock. 
// For each unit, this clock can be linked to different events (external or internal), 
// according to the phase the unit is going through. Linking the clock to different events 
// in different phases is called clock switching.
// To automate clock switching , use the macro CLOCK_SWITCH_SCHEME
// -------------------------------------------------------------------------------

extend apb_env {
    CLOCK_SWITCH_SCHEME {ENV_SETUP} 
        {unqualified_clock_rise};
};

extend apb_bus_monitor {
    CLOCK_SWITCH_SCHEME {ENV_SETUP} 
        {p_env.unqualified_clock_rise};
};
    
extend apb_master_driver_u {
    CLOCK_SWITCH_SCHEME {ENV_SETUP;MAIN_TEST} 
        {p_env.unqualified_clock_rise;p_env.clock_rise};
};

extend apb_master_bfm {
    CLOCK_SWITCH_SCHEME {ENV_SETUP;MAIN_TEST} 
        {p_env.unqualified_clock_rise;p_env.clock_rise};
};    

extend apb_agent {
    CLOCK_SWITCH_SCHEME {ENV_SETUP;MAIN_TEST}
        {p_env.unqualified_clock_rise;p_env.clock_rise};
};

'>
