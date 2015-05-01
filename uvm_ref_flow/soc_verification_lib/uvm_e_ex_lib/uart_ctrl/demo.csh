#!/bin/csh -f
#---------------------------------------------------------------
# File name   :  demo.csh

# Title       :  Demo script 

# Project     :  Module UART

# Created     :  

# Description :  Demo script for the uart module level  sim

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
irun -verbose +nowarnENUMERR -nowarn COVSEC +define+UART_ABV_ON +define+LITLE_ENDIAN +define+full_modem_support -nclibdirpath .  -sncompargs -enable_DAC -errormax 1 -sntimescale 1ns/1ps -covfile $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/scripts/covfile.cf -coverage all -covtest data_poll -covdut tb_uart -covoverwrite -F $UVM_REF_HOME/designs/socv/rtl/rtl_lpw/opencores/oc_uart.irunargs -F $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/uart_ctrl.irunargs +gui -snprerun @./sn_pre_run.ecom -snprerun "config simulation -enable_ports_unification=TRUE" -input $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/scripts/nc_waves.tcl -simvisargs "-input $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/simvision/simvision.svcf" -nosncomp -top tb_uart -snprerun "load $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/tests/data_poll.e ; test"
