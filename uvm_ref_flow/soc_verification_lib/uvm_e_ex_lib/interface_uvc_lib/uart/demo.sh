#! /bin/sh
RUN_DIR_NAME=`dirname $0`
SPECMAN_PATH="$RUN_DIR_NAME/../:${SPECMAN_PATH}"
export SPECMAN_PATH
DIR_NAME=`sn_which.sh uart`
gui="-gui"

while [ "$#" -gt 0 ]; do
   case $1 in
      -h|help)
           echo "usage: demo [-batch] [-h|help]"
           exit 0
       ;;
      -batch)
         gui=""
      ;;
   esac
   shift
done

irun -nosncomp -access c $gui $DIR_NAME/e/uart_top.e $DIR_NAME/examples/test.e $DIR_NAME/examples/tb_top.v

