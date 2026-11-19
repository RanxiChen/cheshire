if {$argc != 1} {error "Usage: check_implementation.tcl BUILD_RUN"}
set task_run [file normalize [lindex $argv 0]]
set report_dir $task_run/audit
file mkdir $report_dir
if {[catch {
    open_project $task_run/project/cva6.xpr
    open_run impl_1
    set routes [report_route_status -return_string]
    set f [open $report_dir/route-status.rpt w]; puts $f $routes; close $f
    # Require the implementation's own error count to be present and zero.
    if {![regexp -nocase {# of nets with routing errors[. ]*:\s*([0-9]+)} $routes -> route_errors]} {
        error "Cannot identify routing error count in route-status report"
    }
    if {$route_errors != 0} {error "Routing errors: $route_errors"}
    if {![regexp {# of routable nets[. ]*:\s*([0-9]+)} $routes -> routable] ||
        ![regexp {# of fully routed nets[. ]*:\s*([0-9]+)} $routes -> fully_routed] ||
        $routable != $fully_routed} {error "Not all routable nets are fully routed"}
    set timing_checks [check_timing -verbose -return_string]
    set f [open $report_dir/check-timing.rpt w]; puts $f $timing_checks; close $f
    if {![regexp -nocase {checking no_clock \(([0-9]+)\)} $timing_checks -> no_clock] || $no_clock != 0} {
        error "Missing clocks or unrecognized no_clock check"
    }
    if {![regexp {There are ([0-9]+) pins that are not constrained for maximum delay\.} $timing_checks -> active] || $active != 0} {
        error "Active internal endpoints lack maximum-delay coverage"
    }
    if {![regexp {There are ([0-9]+) pins that are not constrained for maximum delay due to constant clock\.} $timing_checks -> constant]} {
        error "Cannot identify constant-clock endpoints"
    }
    set constant_pins [regexp -all -inline -line {^i_dram_wrapper/[^\r\n]+} $timing_checks]
    if {[llength $constant_pins] != $constant} {error "Constant-clock endpoint list mismatch"}
    set slave 0
    set arbiter 0
    foreach pin $constant_pins {
        if {[string match {*DDR/DDR4/inst/u_ddr4_mem_intfc/u_ddr_cal_top/u_ddr_cal/U_XSDB_SLAVE/*} $pin]} {
            incr slave
        } elseif {[string match {*DDR/DDR4/inst/u_ddr4_mem_intfc/u_ddr_cal_top/u_ddr_cal/u_xsdb_arbiter/*} $pin]} {
            incr arbiter
        } else {error "Unexpected constant-clock endpoint: $pin"}
    }
    if {$constant != 0 && ($constant != 200 || $slave != 161 || $arbiter != 39)} {
        error "DDR XSDB inventory changed: constant=$constant slave=$slave arbiter=$arbiter"
    }
    foreach clock {clk_50_clkwiz mmcm_clkout0 clk_jtag} {
        foreach kind {min max} {
            set paths [get_timing_paths -quiet -from [get_clocks $clock] -to [get_clocks $clock] -delay_type $kind -max_paths 1]
            if {[llength $paths] != 1} {error "Missing $clock $kind timing paths"}
            set slack [get_property SLACK $paths]
            if {![string is double -strict $slack] || $slack < 0} {error "Failing $clock $kind slack: $slack"}
            puts "CVA6_CLOCK_TIMING $clock $kind $slack"
        }
    }
    report_timing_summary -report_unconstrained -file $report_dir/timing-summary.rpt
    set skew [report_bus_skew -return_string]
    set f [open $report_dir/bus-skew.rpt w]; puts $f $skew; close $f
    set skews [regexp -all -inline {Slack \((?:MET|VIOLATED)\)\s*:\s*([-+0-9.]+)ns} $skew]
    set min_skew 1e9
    foreach {description slack} $skews {
        if {$slack < 0} {error "Bus skew violation: $description"}
        if {$slack < $min_skew} {set min_skew $slack}
    }
    foreach violation [get_drc_violations -quiet] {
        if {[string equal -nocase [get_property SEVERITY $violation] Error]} {error "DRC error: $violation"}
    }
    set f [open $report_dir/audit-result.json w]
    puts $f [format {{"audit_pass":true,"routable_nets":%d,"fully_routed_nets":%d,"routing_errors":%d,"no_clock":%d,"active_unconstrained_internal_endpoints":%d,"constant_clock_ddr_debug_endpoints":%d,"bus_skew_path_results":%d,"minimum_bus_skew_slack_ns":%s}} $routable $fully_routed $route_errors $no_clock $active $constant [expr {[llength $skews] / 2}] $min_skew]
    close $f
    close_project
    puts "CVA6_IMPLEMENTATION_AUDIT_PASS"
} message]} {
    puts stderr "CVA6_IMPLEMENTATION_AUDIT_FAIL $message"
    exit 1
}
exit 0
