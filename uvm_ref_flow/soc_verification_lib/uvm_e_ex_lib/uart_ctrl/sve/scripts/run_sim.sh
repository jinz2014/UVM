#!/bin/sh -f
#/*-------------------------------------------------------------------------
# File name   : run_sim.sh
# Title       : UART environement
# Project     : Module UART
# Developers  : 
# Created     : November 2010
# Description : Run script to simulate module uart

# Notes       : To run the module level UART Simulations
#             :
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

#---------------------------------------------------------------
#
# Takes these optional parameters as environment variables:
#   SN_SEED
#   SN_TEST
#   SIM_RUN_MODE
#   NCLIBDIRPATH
#
#---------------------------------------------------------------

echo RUNNING SCRIPT $0 ...

# =============================================================================
# Usage
# =============================================================================
script=`basename $0`

usage() {
   echo "Usage: $script -h[elp] [-test <test_name> ]"
   echo "                       [-seed <seed_val> ]"
   echo "                       [-run_mode interactive|interactive_debug|batch_debug|batch]"
   echo "Default IntelliGen Generator will be used for all sims"
   echo "Testcase Names : "
   echo "      1.data_poll.e         -> DataPath testcase implemented using MAIN Sequence";
   echo "      2.data_poll_virtual.e -> DataPath testcase implemented using Virtual Sequence";
   echo "      3.test_uart.e         -> Negative testcase where Parity Error is introduced";
}

nomodeldump () {
   echo "Unicov write model:  DISABLED"
   sn_unicov_options=""
   ius_unicov_options="-covnomodeldump"
}

dve_path=${UVM_REF_HOME}/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve
test_case() {
test_arg="${dve_path}/tests/${test_name}"
}


# =============================================================================
# Get args
# =============================================================================
if [ $# = 0 ]
then
  usage
  exit
fi

my_dve_ve_files="-F ${dve_path}/uart_ctrl.irunargs"
sim_svcf="simvision.svcf"

while [ $# -gt 0 ]; do
   case `echo $1 | tr "[A-Z]" "[a-z]"` in
      -h|-help)
         usage
         exit 1
         ;;
      -nomodeldump)
                        nomodeldump
                        ;;
      -test)
                        shift
                        SN_TEST=$1; export SN_TEST
                        test_name=${SN_TEST}
                        test_case
                        ;;
      -seed)
                        shift
                        SN_SEED=$1; export SN_SEED
                        ;;
      -run_mode)
                        shift
                        SIM_RUN_MODE=$1; export SIM_RUN_MODE
                        ;;
      *)
         usage
         exit 1
         ;;
      esac
      shift       
done

#--------------------------------------------
# Verify we've got the env vars we need
#--------------------------------------------
for env_var in UVM_REF_HOME
do
    res=`set| grep "^$env_var="`
    if [ "$res" = "" ]
    then
      echo ERROR $0 exiting: $env_var not defined
      exit 1
    fi
done


###################################################
# Commandline option to control model dumping
###################################################

sn_unicov_options="config cover -write_model=ucm"
ius_unicov_options=""


###################################################
# Parameters to control the build and run process
###################################################

seed_val=${SN_SEED:="random"}

my_dve_dut_files="-F $UVM_REF_HOME/designs/socv/rtl/rtl_lpw/opencores/oc_uart.irunargs"
my_run_test=""
specman_waves=""

# Determine run_mode
run_mode=${SIM_RUN_MODE:="batch"}
case `echo $run_mode` in
   interactive)
     debug="+gui -input ${dve_path}/scripts/nc_waves.tcl -nosncomp"
     sn_exit_on="command"
     my_run_test="test"
     ;;
   interactive_debug)
     debug="+gui -input ${dve_path}/scripts/nc_waves.tcl -simvisargs '-input ${dve_path}/simvision/$sim_svcf' -nosncomp"
     specman_waves="load ${dve_path}/e/uart_ctrl_waves"
     sn_exit_on="command"
     my_run_test="test"
     ;;
   batch_debug)
     debug="-input ${dve_path}/scripts/nc_waves.tcl -simvisargs '-input ${dve_path}/simvision/$sim_svcf' -nosncomp -input ${dve_path}/scripts/irun_batch.tcl" 
     specman_waves="load ${dve_path}/e/uart_ctrl_waves"
     sn_exit_on="all"
     my_run_test="test"
     ;;
   batch) # run batch
     debug="-input ${dve_path}/scripts/irun_batch.tcl"
     sn_exit_on="all"
     my_run_test="test"
     ;;
   *) # run batch
     debug="-input ${dve_path}/scripts/irun_batch.tcl"
     sn_exit_on="all"
     my_run_test="test"
     ;;
esac


###################################################
# Establish common build dir per testcase
###################################################
snapshot_path=${NCLIBDIRPATH:="."}
if [ ! -d ${snapshot_path} ]; then
    mkdir -p ${snapshot_path}
fi;

if [ ! -d ${snapshot_path} ]; then
    echo "ERROR $0: IES Snapshot directory cannot be created:"
    echo "  $snapshot_path"
    exit 1;
fi;


###################################################
# Build snapshot and run.
###################################################

cat > irun_sn_test.ecom <<EOF
$specman_waves
load $test_arg
files.write_string_list(".log_file",{get_log_name()})
set_config(gen, seed, $seed_val)
set_config(run, exit_on, $sn_exit_on)
EOF

cat > igen_pre_run.ecom <<EOF
set_config(simulation,enable_ports_unification,TRUE)
EOF


# Move Specman-pre_commands for use by irun -snprerun option
SPECMAN_PRE_COMMANDS="$sn_unicov_options; $SPECMAN_PRE_COMMANDS; @irun_sn_test.ecom; $my_run_test "
echo $SPECMAN_PRE_COMMANDS > ./sn_pre_run.ecom
SPECMAN_PRE_COMMANDS=""; export SPECMAN_PRE_COMMANDS;

# build and run
irun_run="irun \
  -verbose \
  -nowarn COVSEC \
  +nowarnENUMERR \
  +define+UART_ABV_ON \
  +define+LITLE_ENDIAN \
  +define+full_modem_support \
  -nclibdirpath ${snapshot_path} \
  -sncompargs -enable_DAC  -errormax 1  -sntimescale 1ns/1ps \
  -covfile ${UVM_REF_HOME}/soc_verification_lib/uvm_e_ex_lib/uart_ctrl/sve/scripts/covfile.cf \
  -coverage all \
  -covtest $test_name \
  -covdut tb_uart \
  $ius_unicov_options -covoverwrite \
  $my_dve_dut_files \
  $my_dve_ve_files \
  -snset @./igen_pre_run.ecom \
  -snprerun @./sn_pre_run.ecom \
  $debug -top tb_uart"

echo "Compiling and Running DVE"
echo Executing: $irun_run
eval ${irun_run}


#--------------------------------------------
#------ Done !
#--------------------------------------------
echo FINISHED $0: exiting normally
exit 0
