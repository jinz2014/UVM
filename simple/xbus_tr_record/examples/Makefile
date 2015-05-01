UVM_TESTNAME = test_read_modify_write
 
all: clean comp run 

clean:
	rm -rf simv* csrc vcdplus.vpd urgReport tr.log ucli.key vc_hdrs.h DVEfiles

comp: clean 
	vcs -lca -sverilog -timescale=1ns/1ns +define+UVM_TR_RECORD -debug_all -ntb_opts uvm-1.1 +incdir+../sv xbus_tb_top.sv  -l comp.log

run:
	simv +UVM_NO_RELNOTES +UVM_TESTNAME=$(UVM_TESTNAME) +UVM_LOG_RECORD +UVM_TR_RECORD  
