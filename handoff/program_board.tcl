# Volatile FPGA SRAM configuration, without accessing Flash or SD media.
if {$argc != 2} {error "Usage: program_board.tcl BITSTREAM CABLE_SERIAL"}
if {[catch {
    set bitstream [file normalize [lindex $argv 0]]
    if {![file isfile $bitstream]} {error "Missing bitstream"}
    open_hw_manager
    connect_hw_server -url 127.0.0.1:3121
    set targets [get_hw_targets -quiet *[lindex $argv 1]*]
    if {[llength $targets] != 1} {error "Expected exactly one verified KCU105 cable"}
    current_hw_target [lindex $targets 0]
    set_property PARAM.FREQUENCY 10000000 [current_hw_target]
    open_hw_target
    set candidates {}
    foreach device [get_hw_devices -quiet] {
        puts "CVA6_DEVICE $device PART=[get_property PART $device]"
        if {[string match -nocase xcku040* [get_property PART $device]]} {lappend candidates $device}
    }
    if {[llength $candidates] != 1} {error "Expected one KU040 FPGA"}
    set device [lindex $candidates 0]
    current_hw_device $device
    set_property PROGRAM.FILE $bitstream $device
    set probes [file rootname $bitstream].ltx
    if {[file isfile $probes]} {set_property PROBES.FILE $probes $device}
    program_hw_devices $device
    refresh_hw_device $device
    puts "CVA6_VOLATILE_PROGRAM_COMPLETE"
    close_hw_target
    disconnect_hw_server
    close_hw_manager
} message]} {
    puts stderr "CVA6_PROGRAM_FAIL $message"
    exit 1
}
exit 0
