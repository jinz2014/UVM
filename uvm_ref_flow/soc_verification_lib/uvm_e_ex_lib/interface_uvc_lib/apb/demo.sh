#! /bin/sh
RUN_DIR_NAME=`dirname $0`
SPECMAN_PATH="$RUN_DIR_NAME/../:${SPECMAN_PATH}"
export SPECMAN_PATH
DIR_NAME=`sn_which.sh apb`
gui="-gui"
testname="test"

usage() {
   echo "                                     "
   echo "Usage: ./demo.sh [-h] [-batch] -test <testname>"
   echo "                                     "
   echo "     Available demo test <testname> "
   echo "                                     "
   echo "  1. testname : test               - Simple Demo Test for APB UVC with Single Reset"
   echo "  2. testname : test_multi_reset   - Simple Demo Test for APB UVC with Multiple Reset"
}

while [ "$#" -gt 0 ]; do
   case `echo $1 | tr "[A-Z]" "[a-z]"` in
      -h)
         usage
         exit 1
       ;;
      -batch)
         gui=""
      ;;
      -test)
         shift
         testname=$1
      ;;
   esac
   shift
done

irun -nosncomp -access c $gui $DIR_NAME/e/apb_top.e $DIR_NAME/examples/$testname.e $DIR_NAME/examples/tb.v

