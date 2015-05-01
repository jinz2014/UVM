#----------------------------------------------------------------------
# File name   : nc_waves.tcl 
#------------------------------------------------------------------------
# Waveforms will be recorded from module 'tb_uart'
# and stored in 'waves'.
database -open waves -into waves.shm -default
probe -create -shm tb_uart -all -depth all 
probe -create -shm specman_wave -all 
