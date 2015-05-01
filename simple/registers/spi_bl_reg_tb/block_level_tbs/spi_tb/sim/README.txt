This example shows how to use a register model in a block level environment.

To compile and run the simulation, please use the make file:

make all - Compile and run
make rtl - Compile the rtl
make tb - Compile the structural level of the test bench
make build - Compile the ovm part of the test bench
make sim  - Run the simulation in command line mode

The Makefile assumes the use of Questa 10.0b or a later version with
built-in support for the UVM.

By default, the make file runs the spi_reg_test, but the package also
contains:

spi_interrupt_test
spi_poll_test

The tests are defined in the test directory.
