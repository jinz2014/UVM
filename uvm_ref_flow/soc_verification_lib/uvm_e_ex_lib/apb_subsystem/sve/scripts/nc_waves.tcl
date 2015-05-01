#----------------------------------------------------------------------
#File name   : nc_waves.tcl 
#------------------------------------------------------------------------

database -open waves -into waves.shm -default
probe -create -shm tb_apb_subsystem -all -depth all 
probe -create -shm specman_wave -all 
