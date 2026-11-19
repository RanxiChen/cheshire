# Run with Vivado 2022.2, a fresh output directory, and sources.tcl beside it.
if {[version -short] ne "2022.2"} {error "Vivado 2022.2 required"}
set task_root [file normalize [lindex $argv 0]]
set task_run [file normalize [lindex $argv 1]]
set_param general.maxThreads 8
create_project cva6 $task_run/project -part xcku040-ffva1156-2-e
set_property target_language Verilog [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
source $task_run/sources.tcl
set fase_rom $task_root/hw/fase/fase_ctrl_microcode.mem
add_files -norecurse $fase_rom
set_property file_type {Memory Initialization Files} [get_files $fase_rom]
set_property verilog_define [concat [get_property verilog_define [current_fileset]] {TARGET_KCU105}] [current_fileset]

create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clkwiz
set_property -dict [list CONFIG.PRIM_SOURCE No_buffer CONFIG.PRIM_IN_FREQ 125.000 \
    CONFIG.CLK_OUT1_PORT clk_50 CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 50.000 \
    CONFIG.USE_LOCKED true CONFIG.USE_RESET true] [get_ips clkwiz]
create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name vio
# Passive boot selects the native UART loader; SD remains selectable through VIO.
set_property -dict [list CONFIG.C_NUM_PROBE_OUT 3 CONFIG.C_PROBE_OUT0_INIT_VAL 0x0 \
    CONFIG.C_PROBE_OUT1_INIT_VAL 0x0 CONFIG.C_PROBE_OUT2_INIT_VAL 0x1 \
    CONFIG.C_PROBE_OUT1_WIDTH 2 CONFIG.C_NUM_PROBE_IN 0] [get_ips vio]

source $task_root/target/xilinx/scripts/create_kcu105_ddr.tcl
set bd [get_files -quiet */kcu105_ddr.bd]
generate_target all $bd
set wrapper [make_wrapper -files $bd -top]
add_files -norecurse $wrapper
generate_target all [get_ips {clkwiz vio}]
create_ip_run $bd
foreach ip [get_ips {clkwiz vio}] {create_ip_run $ip}
read_xdc $task_root/target/xilinx/constraints/cheshire.xdc
read_xdc $task_root/target/xilinx/constraints/kcu105.xdc
read_xdc $task_root/target/xilinx/constraints/fase_uart.xdc
set_property top cheshire_top_xilinx [current_fileset]
set_property source_mgmt_mode None [current_project]
update_compile_order -fileset sources_1
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
if {[info exists ::env(CVA6_BD_ONLY)] && $::env(CVA6_BD_ONLY) eq "1"} {
    puts "CVA6_PROJECT_GENERATION_PASS"
    exit
}
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "Synthesis failed"}
open_run synth_1
file mkdir $task_run/reports
report_utilization -hierarchical -file $task_run/reports/utilization-synth.rpt
report_clocks -file $task_run/reports/clocks-synth.rpt
puts "CVA6_SYNTHESIS_PASS"
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Implementation failed"}
open_run impl_1
report_timing_summary -report_unconstrained -file $task_run/reports/timing-summary.rpt
report_timing -delay_type max -max_paths 50 -file $task_run/reports/setup-worst.rpt
report_timing -delay_type min -max_paths 50 -file $task_run/reports/hold-worst.rpt
report_route_status -file $task_run/reports/route-status.rpt
report_drc -file $task_run/reports/drc.rpt
report_cdc -file $task_run/reports/cdc.rpt
report_clock_interaction -file $task_run/reports/clock-interaction.rpt
report_utilization -hierarchical -file $task_run/reports/utilization.rpt
check_timing -verbose -file $task_run/reports/check-timing.rpt
set setup_paths [get_timing_paths -quiet -delay_type max -max_paths 1]
set hold_paths [get_timing_paths -quiet -delay_type min -max_paths 1]
if {[llength $setup_paths] != 1 || [llength $hold_paths] != 1} {error "Missing timing paths"}
set wns [get_property SLACK $setup_paths]
set whs [get_property SLACK $hold_paths]
if {![string is double -strict $wns] || ![string is double -strict $whs] || $wns < 0 || $whs < 0} {
    error "Timing not met: setup=$wns hold=$whs"
}
set errors [get_drc_violations -quiet -filter {SEVERITY == Error}]
if {[llength $errors]} {error "Unresolved DRC errors: $errors"}
set rp [open $task_run/reports/implementation-result.json w]
puts $rp "{\"implementation_pass\":true,\"wns_ns\":$wns,\"whs_ns\":$whs,\"drc_errors\":0}"
close $rp
file copy $task_run/project/cva6.runs/impl_1/cheshire_top_xilinx.bit $task_run/cva6-kcu105-fase-microcode.bit
if {[file exists $task_run/project/cva6.runs/impl_1/cheshire_top_xilinx.ltx]} {
    file copy $task_run/project/cva6.runs/impl_1/cheshire_top_xilinx.ltx $task_run/cva6-kcu105-fase-microcode.ltx
}
puts "CVA6_BOARD_SHELL_IMPLEMENTATION_PASS setup=$wns hold=$whs"
