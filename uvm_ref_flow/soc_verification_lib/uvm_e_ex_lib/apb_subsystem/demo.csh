#!/bin/csh -f
#---------------------------------------------------------------
# File name   :  demo.csh

# Title       :  Demo script

# Project     :  APB-Subsystem


# Created     :  

# Description :  Demo script for the APB subsystem level sim

# Notes       :  
#--------------------------------------------------------------------*/
# Copyright 1999-2010 Cadence Design Systems, Inc.
# All Rights Reserved Worldwide
#
# Licensed under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in
# writing, software distributed under the License is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See
# the License for the specific language governing
# permissions and limitations under the License.
# ----------------------------------------------------------------------


\rm -rf worklib
mkdir worklib

# Specifies the format for the extracted coverage model
set sn_unicov_options="config cover -write_model=ucm"
set SPECMAN_PRE_COMMANDS="$sn_unicov_options"
echo $SPECMAN_PRE_COMMANDS > ./sn_pre_run.ecom

#irun command to run the demo sim
irun -verbose -sv -assert -assert_count_traces -define UART_ABV_ON +define+LITLE_ENDIAN +nowarnENUMERR -nowarn ZROMCV -nclibdirpath . -sncomparg -enable_DAC -errormax 1 -sntimescale 1ns/1ps -covfile $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/scripts/covfile.cf -coverage all -covtest apb_subsystem_data_poll -covdut tb_apb_subsystem -covoverwrite -F $UVM_REF_HOME/designs/socv/rtl/rtl_lpw/apb_subsystem/rtl/apb_subsystem.irunargs -F $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/apb_subsystem.irunargs +gui -snprerun @./sn_pre_run.ecom -snprerun "config simulation -enable_ports_unification=TRUE" -input $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/scripts/nc_waves.tcl -simvisargs "-input $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/simvision/simvision.svcf" -nosncomp -top tb_apb_subsystem -snprerun "load $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/tests/apb_subsystem_data_poll.e ; test"
