# DDR hierarchy inherited from the BOOM KCU105 board-tested source.
# Only its SoC-facing AXI contract and exported shell are specific to Cheshire.
create_bd_design kcu105_ddr
set axi [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI]
set_property -dict [list CONFIG.PROTOCOL AXI4 CONFIG.ADDR_WIDTH 31 \
    CONFIG.DATA_WIDTH 64 CONFIG.ID_WIDTH 4 CONFIG.HAS_QOS 1 \
    CONFIG.NUM_READ_OUTSTANDING 16 CONFIG.NUM_WRITE_OUTSTANDING 16] $axi
set refclk [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_300]
set_property CONFIG.FREQ_HZ 300000000 $refclk
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram
create_bd_port -dir I -type clk axi_clock
set_property -dict [list CONFIG.FREQ_HZ 50000000 CONFIG.ASSOCIATED_BUSIF S_AXI CONFIG.ASSOCIATED_RESET axi_resetn] [get_bd_ports axi_clock]
create_bd_port -dir I -type rst axi_resetn
set_property CONFIG.POLARITY ACTIVE_LOW [get_bd_ports axi_resetn]
create_bd_port -dir I -type rst sys_reset
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_reset]
create_bd_port -dir O init_calib_complete
create_bd_cell -type hier DDR
current_bd_instance /DDR
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_300
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram
create_bd_pin -dir I -type clk axi_clock
create_bd_pin -dir I -type rst axi_reset
create_bd_pin -dir I -type rst sys_reset
create_bd_pin -dir I dcm_locked
create_bd_pin -dir I mb_debug_sys_rst
create_bd_pin -dir O init_calib_complete
set ddr [create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 DDR4]
set_property -dict [list \
    CONFIG.C0_DDR4_BOARD_INTERFACE {Custom} \
    CONFIG.C0_CLOCK_BOARD_INTERFACE {Custom} \
    CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-083E} \
    CONFIG.C0.DDR4_DataWidth {64} CONFIG.C0.DDR4_TimePeriod {833} \
    CONFIG.C0.DDR4_InputClockPeriod {3332} \
    CONFIG.C0.DDR4_AxiSelection {true} CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_AxiIDWidth {4} CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {None}] $ddr
connect_bd_intf_net [get_bd_intf_pins ddr4_sdram] [get_bd_intf_pins DDR4/C0_DDR4]
connect_bd_intf_net [get_bd_intf_pins default_sysclk_300] [get_bd_intf_pins DDR4/C0_SYS_CLK]
connect_bd_net [get_bd_pins sys_reset] [get_bd_pins DDR4/sys_rst]
connect_bd_net [get_bd_pins DDR4/c0_init_calib_complete] [get_bd_pins init_calib_complete]

set mem [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 MemAXI]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1} CONFIG.NUM_CLKS {2}] $mem
connect_bd_intf_net [get_bd_intf_pins S00_AXI] [get_bd_intf_pins MemAXI/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins MemAXI/M00_AXI] [get_bd_intf_pins DDR4/C0_DDR4_S_AXI]
connect_bd_net [get_bd_pins axi_clock] [get_bd_pins MemAXI/aclk]
connect_bd_net [get_bd_pins axi_reset] [get_bd_pins MemAXI/aresetn]
connect_bd_net [get_bd_pins DDR4/c0_ddr4_ui_clk] [get_bd_pins MemAXI/aclk1]

# Retain the existing DDR UI-domain reset behavior.
set ddr_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 DDRResetUI]
set_property -dict [list CONFIG.C_EXT_RESET_HIGH {1} CONFIG.C_AUX_RESET_HIGH {0}] $ddr_reset
connect_bd_net [get_bd_pins DDR4/c0_ddr4_ui_clk] [get_bd_pins DDRResetUI/slowest_sync_clk]
connect_bd_net [get_bd_pins DDR4/c0_ddr4_ui_clk_sync_rst] [get_bd_pins DDRResetUI/ext_reset_in]
connect_bd_net [get_bd_pins axi_reset] [get_bd_pins DDRResetUI/aux_reset_in]
connect_bd_net [get_bd_pins dcm_locked] [get_bd_pins DDRResetUI/dcm_locked]
connect_bd_net [get_bd_pins mb_debug_sys_rst] [get_bd_pins DDRResetUI/mb_debug_sys_rst]
connect_bd_net [get_bd_pins DDRResetUI/peripheral_aresetn] [get_bd_pins DDR4/c0_ddr4_aresetn]
current_bd_instance /

connect_bd_intf_net [get_bd_intf_ports S_AXI] [get_bd_intf_pins DDR/S00_AXI]
connect_bd_intf_net [get_bd_intf_ports default_sysclk_300] [get_bd_intf_pins DDR/default_sysclk_300]
connect_bd_intf_net [get_bd_intf_ports ddr4_sdram] [get_bd_intf_pins DDR/ddr4_sdram]
connect_bd_net [get_bd_ports axi_clock] [get_bd_pins DDR/axi_clock]
connect_bd_net [get_bd_ports axi_resetn] [get_bd_pins DDR/axi_reset]
connect_bd_net [get_bd_ports sys_reset] [get_bd_pins DDR/sys_reset]
connect_bd_net [get_bd_ports init_calib_complete] [get_bd_pins DDR/init_calib_complete]
set one [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 One]
set_property CONFIG.CONST_VAL 1 $one
connect_bd_net [get_bd_pins One/dout] [get_bd_pins DDR/dcm_locked]
set zero [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Zero]
set_property CONFIG.CONST_VAL 0 $zero
connect_bd_net [get_bd_pins Zero/dout] [get_bd_pins DDR/mb_debug_sys_rst]
assign_bd_address -offset 0 -range 0x80000000 -target_address_space [get_bd_addr_spaces S_AXI] \
    [get_bd_addr_segs DDR/DDR4/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
validate_bd_design
save_bd_design
set children {}
foreach child [get_bd_cells /DDR/*] {lappend children [file tail $child]}
if {[lsort $children] ne "DDR4 DDRResetUI MemAXI"} {error "Unexpected DDR hierarchy: $children"}
puts "CVA6_DDR_BD_VALIDATED"
