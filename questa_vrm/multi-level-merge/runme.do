#
# This directory demonstrates how multi-level auto-merge could work
# under the Verification Run Manager. The test design consists of a
# Hamming parity generator block on which two unit-level tests and
# three system-level tests are performed. The unit-level tests are
# configured under the "unittest" Runnable and the coverage results
# merged into "unittest.ucdb". The system-level tests are configured
# under the "systemtest" Runnable and the coverage results merged
# into "systemtest.ucdb".
#
# A second-level merge of the two lower-level files is automatically
# written to the file "merge.ucdb" in the directory "DATADIR/nightly".
# Except for the strip/install step, all merge Actions are generated
# within the "vrun" application itself.
#
# The "default.rmdb" RMDB file contains the regression configuration.
# Execution of the regression suite will generate a working directory
# called DATADIR, under which the various scripts and log files are
# generated. See the Verification Run Manager documentation for details.
#
# The "file delete" command cleans up any leftover DATADIR area.
#
file delete -force DATADIR
#
# The "vrun" command executes the regression suite.
#
vrun -verbose nightly
