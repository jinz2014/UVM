#! /bin/sh
RUN_DIR_NAME=`dirname $0`
SPECMAN_PATH="$RUN_DIR_NAME/../:${SPECMAN_PATH}"
export SPECMAN_PATH
DIR_NAME=`sn_which.sh gpio`
gui="-gui -input $DIR_NAME/examples/single_channel/sim_command.tcl"

while [ "$#" -gt 0 ]; do
   case $1 in
      -h)
           echo "usage: demo [-batch] [-h]"
           exit 0
       ;;
      -batch)
         gui=""
      ;;
   esac
   shift
done

irun -nosncomp -access c $gui $DIR_NAME/e/gpio_top.e $DIR_NAME/examples/single_channel/test.e $DIR_NAME/examples/single_channel/dut_dummy.v
