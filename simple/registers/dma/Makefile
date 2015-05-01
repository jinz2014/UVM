#IFILES = base_item.sv \
         word_aligned_item.sv \
         base_sequence.sv \
         base_driver.sv \
         base_monitor.sv \
         base_agent.sv \
         base_env.sv \
         base_scoreboard.sv \
         base_tb.sv \
         base_test.sv\
         word_aligned_test.sv\
         word_aligned_error_test.sv\
         word_aligned_medium_test.sv\
         dut_if.sv \
         dut.sv
FILES = lab1.sv 

all: clean comp run

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key

comp:
	vcs -debug_all -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 +incdir+../sv top.sv -l comp.log

run:
	./simv +UVM_NO_RELNOTES +UVM_TESTNAME="base_test" -l run.log

questa: ${FILES} ${IFILES}
	@if [ ! -e ${UVM_HOME}/src/uvm_pkg.sv ];then \
	 echo "*******************************************************";\
	 echo "Environemnt varible UVM_HOME is not set or points to incorrect path"; \
	 echo "*******************************************************";\
	 fi 
	#qverilog ${UVM_FLAGS} +incdir+. ${FILES} -R +UVM_TESTNAME=av_mm_base_test 
	#qverilog ${UVM_FLAGS} +incdir+. ${FILES} -R +UVM_TESTNAME=av_mm_reg_test
	#qverilog ${UVM_FLAGS} +incdir+. ${FILES} -gui -R -do "do wave.do; run -a" +UVM_TESTNAME=av_mm_reg_test
	qverilog ${UVM_FLAGS} +incdir+. ${FILES} -R +UVM_TESTNAME=av_mm_reg_test
