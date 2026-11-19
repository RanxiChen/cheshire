if {$argc != 1} {error "Usage: check_fase_uart.tcl BUILD_RUN"}
set task_run [file normalize [lindex $argv 0]]
set report_dir $task_run/audit
file mkdir $report_dir
open_project $task_run/project/cva6.xpr
open_run impl_1

set rx_first [get_cells -quiet -hier -filter {NAME =~ *fase_rx_meta_q_reg}]
set rx_second [get_cells -quiet -hier -filter {NAME =~ *fase_rx_sync_q_reg}]
if {[llength $rx_first] != 1 || [llength $rx_second] != 1} {
    error "Expected one FASE UART synchronizer pair: $rx_first / $rx_second"
}
foreach stage [concat $rx_first $rx_second] {
    if {![get_property ASYNC_REG $stage]} {error "Missing ASYNC_REG on $stage"}
}
set first_d [get_pins -of_objects $rx_first -filter {REF_PIN_NAME == D}]
set first_q [get_pins -of_objects $rx_first -filter {REF_PIN_NAME == Q}]
set second_d [get_pins -of_objects $rx_second -filter {REF_PIN_NAME == D}]
set soc_clock [get_clocks clk_50_clkwiz]
if {[llength $soc_clock] != 1 || abs([get_property PERIOD $soc_clock] - 20.0) > 0.001} {
    error "Expected the board's 50 MHz SoC clock"
}
foreach kind {min max} {
    set paths [get_timing_paths -from $first_q -to $second_d -delay_type $kind -max_paths 1]
    if {[llength $paths] != 1} {error "Missing RX interstage $kind timing path"}
    set slack($kind) [get_property SLACK $paths]
    if {$slack($kind) < 0} {error "Negative RX interstage $kind slack: $slack($kind)"}
    report_timing -from $first_q -to $second_d -delay_type $kind -file $report_dir/fase-rx-$kind.rpt
}
set exceptions [report_exceptions -return_string]
set handle [open $report_dir/exceptions.rpt w]
puts $handle $exceptions
close $handle
set input_path [get_timing_paths -quiet -from [get_ports uart_rx_i] -to $first_d -max_paths 1]
puts "FASE_RX_INPUT_PATHS [llength $input_path]"
foreach path $input_path {
    report_property $path
}
report_timing -from [get_ports uart_rx_i] -to $first_d -max_paths 1 -file $report_dir/fase-rx-input.rpt
if {![regexp {uart_rx_i[^\n]*fase_rx_meta_q_reg/D[^\n]*false[ \t]+false} $exceptions]} {
    error "Missing UART input false-path constraint"
}
set tx [get_timing_paths -from $soc_clock -to [get_ports uart_tx_o] -delay_type max -max_paths 1]
if {[llength $tx] != 1 || [get_property SLACK $tx] < 0} {error "Missing or failing UART TX path"}
set tx_slack [get_property SLACK $tx]
report_timing -from $soc_clock -to [get_ports uart_tx_o] -delay_type max -file $report_dir/fase-tx.rpt
set handle [open $report_dir/fase-uart.json w]
puts $handle [format {{"pass":true,"clock_mhz":50,"baud":460800,"rx_setup_ns":%s,"rx_hold_ns":%s,"tx_setup_ns":%s}} \
    $slack(max) $slack(min) $tx_slack]
close $handle
puts "CVA6_FASE_UART_AUDIT_PASS"
close_project
exit
