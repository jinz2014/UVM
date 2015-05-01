This example shows how to use uvm_mems and uvm_regs and consists of a memory
sub-system DUT which contains memory mapping registers plus 3 zones of memory.

The example uses some of the built-in register and memory test
sequences and it also illustrates how to use multiple uvm_reg_maps.

To compile and run the simulation, please use the make file:

make all - Compile and run
make rtl - Compile the rtl
make tb - Compile the structural level of the test bench
make build - Compile the ovm part of the test bench
make sim  - Run the simulation in command line mode

The Makefile assumes the use of Questa 10.0b or a later version with
built-in support for the UVM

