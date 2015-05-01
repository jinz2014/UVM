#! /bin/sh
RUN_DIR_NAME=`dirname $0`
SPECMAN_PATH="$RUN_DIR_NAME/../:${SPECMAN_PATH}"
export SPECMAN_PATH
DIR_NAME=`sn_which.sh spi`
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
cat > pre_run.ecom <<EOF
set_config(simulation,enable_ports_unification,TRUE);
set_config(run,exit_on,normal_stop);
set message -replace MEDIUM;
test;
trace seq;
EOF

irun -snprerun @./pre_run.ecom -access c -nosncomp $gui $DIR_NAME/e/spi_top.e $DIR_NAME/examples/tc_demo.e $DIR_NAME/examples/tb.v

