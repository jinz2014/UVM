onerror {resume}
onbreak {resume}
onElabError {resume}

#$env(DO_PROFILE)
quietly set DO_PROFILE 0


# Simulation specific setup
set StdArithNoWarnings   1
set NumericStdNoWarnings 1

if {[batch_mode]} {
	 source wave_batch.do
} else {
	 source wave.do
}

# Start the simulation
if {$DO_PROFILE} {
       profile on
       profile option keep_unknown
}

run -a
        

if { $DO_PROFILE } {
      profile report -cutoff 0 -ranked        -file "profile_rank.rpt"
      profile report -cutoff 0 -hierarchical  -file "profile_hierarchical.rpt"
      profile report -cutoff 0 -structural    -file "profile_structural.rpt"
      view profile
}

# Clean up, and prepare for next run...
coverage attr  -name TESTNAME -value [format "%s_%d"   [file rootname $env(UCDBFILE)] $Sv_Seed]
coverage save      [format "%s"       $env(UCDBFILE) ]

#quit -sim

quit
