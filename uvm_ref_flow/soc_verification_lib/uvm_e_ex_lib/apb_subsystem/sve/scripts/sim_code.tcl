#----------------------------------------------------------------------
#File name   : sim_code.tcl 
#------------------------------------------------------------------------
# Generate assertion summary file
assertion -logging -all -error on -state {failed}
assertion -summary -final -redirect assertion.summary
set assert_report_incompletes 0
