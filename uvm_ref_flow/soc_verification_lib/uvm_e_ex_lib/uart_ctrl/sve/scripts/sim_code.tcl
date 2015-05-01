#sn trace sequence transactions on 
#sn trace sequence on 
if {[string first No [assertion -summary]] != 2 } { 
  assertion -logging -all -error on -state {failed}
  assertion -summary -final -redirect assertion.summary
  set assert_report_incompletes 0
}
