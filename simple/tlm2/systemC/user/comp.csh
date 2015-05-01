#!/bin/csh -f


syscan -tli payload.tli \
        -cflags -I $VCS_HOME/etc/systemc/tlm/include/tlm payload.h
syscan -tlm2 -cflags -DUSER_PAYLOAD -cflags -g target.cpp
syscan -tlm2 -cflags -DUSER_PAYLOAD -cflags -g initiator.cpp
syscan -tlm2 -cflags -DUSER_PAYLOAD -cflags -g tli_packunpack_my_payload.cpp
syscan -tlm2 -cflags -DUSER_PAYLOAD -cflags -g payload_conv.cpp
syscan -tlm2 -cflags -DUSER_PAYLOAD -cflags -g sc_top.cpp:sc_top     
vcs  -cpp g++ -cc gcc -timescale=1ns/1ps -l vcs.log -V -cm_xmldb -sverilog -gen_obj -sysc +incdir+.. +incdir+$VCS_HOME/etc/systemc/tlm/tli -ntb_opts uvm top.v
