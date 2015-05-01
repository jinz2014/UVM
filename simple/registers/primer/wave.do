onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/apb0/pclk
add wave -noupdate -radix hexadecimal /tb_top/apb0/paddr
add wave -noupdate -radix hexadecimal /tb_top/apb0/psel
add wave -noupdate -radix hexadecimal /tb_top/apb0/penable
add wave -noupdate -radix hexadecimal /tb_top/apb0/pwrite
add wave -noupdate -radix hexadecimal /tb_top/apb0/prdata
add wave -noupdate -radix hexadecimal /tb_top/apb0/pwdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {500 ns}
