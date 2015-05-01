all: work build sim

tarball: clean tar

work:
	vlib work

build:
	vlog ../bidirect_bus_agent_pkg.sv
	vlog top.sv

sim:
	vsim -c -do "run -all" top

clean:
	rm -rf work transcript *~ vsim.wlf *.log

tar:
	@(cd ../.. ;\
	tar -zcf interrupts/simple/uvm_interrupts_simple.tgz\
	interrupts/bidirect_bus_agent_pkg.sv\
	interrupts/simple/top.sv\
	interrupts/simple/Makefile\
	interrupts/simple/README.txt;\
	cd interrupts/simple)
