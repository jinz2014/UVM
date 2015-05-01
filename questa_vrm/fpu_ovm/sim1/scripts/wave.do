onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -r /*tream*
add wave -noupdate -group {Internal DUT Signals}
add wave -noupdate -group {Internal DUT Signals} -format Logic /top/fpu_dut/clk_i
add wave -noupdate -group {Internal DUT Signals} -format Logic /top/fpu_dut/start_i
add wave -noupdate -group {Internal DUT Signals} -format Logic /top/fpu_dut/s_start_i
add wave -noupdate -group {Internal DUT Signals} -format Literal /top/fpu_dut/s_state
add wave -noupdate -group {Internal DUT Signals} -format Literal /top/fpu_dut/s_count
add wave -noupdate -group {Internal DUT Signals} -format Logic /top/fpu_dut/ready_o

add wave -noupdate -expand -group {Input Signals}
add wave -noupdate -group {Input Signals} -format Logic   -radix hexadecimal /top/fpu_dut/clk_i
add wave -noupdate -group {Input Signals} -format Literal -radix hexadecimal /top/fpu_dut/opa_i
add wave -noupdate -group {Input Signals} -format Literal -radix hexadecimal /top/fpu_dut/opb_i
add wave -noupdate -group {Input Signals} -format Literal -radix hexadecimal /top/fpu_dut/fpu_op_i
add wave -noupdate -group {Input Signals} -format Literal -radix hexadecimal /top/fpu_dut/rmode_i
add wave -noupdate -group {Input Signals} -format Logic   -radix hexadecimal /top/fpu_dut/start_i

add wave -noupdate -expand -group {Output Signals}
add wave -noupdate -group {Output Signals} -format Literal -radix hexadecimal /top/fpu_dut/output_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/qnan_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/zero_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/inf_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/div_zero_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/underflow_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/overflow_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/ine_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/ready_o
add wave -noupdate -group {Output Signals} -format Logic /top/fpu_dut/snan_o
add wave -noupdate -expand -group Assertions

add wave -noupdate -group Assertions
add wave -noupdate -group Assertions -format Literal /top/fpu_pins/check_add_delay
add wave -noupdate -group Assertions -format Literal /top/fpu_pins/check_sub_delay
add wave -noupdate -group Assertions -format Literal /top/fpu_pins/check_mult_delay
add wave -noupdate -group Assertions -format Literal /top/fpu_pins/check_div_delay
add wave -noupdate -group Assertions -format Literal /top/fpu_pins/check_sqrt_delay


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {414 ns} 0}
configure wave -namecolwidth 212
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0

update
WaveRestoreZoom {0 ns} {945 ns}
