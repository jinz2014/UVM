#!/bin/sh -f
#/*-------------------------------------------------------------------------
# File name   :  run_com.sh
# Title       :  Cluster apb_subsystem environment compilation script
# Project     :  Cluster apb_subsystem environment
# Developers  : 
# Created     :
# Description : script to compile apb_subsystem cluster.

# Notes       : 
#-------------------------------------------------------------------------*/
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
#-------------------------------------------------------------------------

irun -verbose -errormax 1 -sncompargs "-enable_DAC" -c -run -exit -F $UVM_REF_HOME/designs/socv/rtl/rtl_lpw/apb_subsystem/rtl/apb_subsystem.irunargs -F $UVM_REF_HOME/soc_verification_lib/uvm_e_ex_lib/apb_subsystem/sve/apb_subsystem_tb_only.irunargs -top tb_apb_subsystem


