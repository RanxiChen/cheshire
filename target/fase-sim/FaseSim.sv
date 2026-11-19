module FaseSim
  import cheshire_pkg::*;
(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        memory_ready,
  input  logic        fase_uart_rxd,
  output logic        fase_uart_txd,
  output logic [7:0]  fase_uart_state,
  output logic        fase_fault,
  output logic [15:0] fase_debug,
  output logic        mem_axi4_0_aw_valid,
  output logic [47:0] mem_axi4_0_aw_bits_addr,
  output logic [15:0] mem_axi4_0_aw_bits_id,
  output logic [7:0]  mem_axi4_0_aw_bits_len,
  output logic [2:0]  mem_axi4_0_aw_bits_size,
  output logic [1:0]  mem_axi4_0_aw_bits_burst,
  input  logic        mem_axi4_0_aw_ready,
  output logic        mem_axi4_0_w_valid,
  output logic [63:0] mem_axi4_0_w_bits_data,
  output logic [7:0]  mem_axi4_0_w_bits_strb,
  output logic        mem_axi4_0_w_bits_last,
  input  logic        mem_axi4_0_w_ready,
  input  logic        mem_axi4_0_b_valid,
  input  logic [15:0] mem_axi4_0_b_bits_id,
  input  logic [1:0]  mem_axi4_0_b_bits_resp,
  output logic        mem_axi4_0_b_ready,
  output logic        mem_axi4_0_ar_valid,
  output logic [47:0] mem_axi4_0_ar_bits_addr,
  output logic [15:0] mem_axi4_0_ar_bits_id,
  output logic [7:0]  mem_axi4_0_ar_bits_len,
  output logic [2:0]  mem_axi4_0_ar_bits_size,
  output logic [1:0]  mem_axi4_0_ar_bits_burst,
  input  logic        mem_axi4_0_ar_ready,
  input  logic        mem_axi4_0_r_valid,
  input  logic [63:0] mem_axi4_0_r_bits_data,
  input  logic [15:0] mem_axi4_0_r_bits_id,
  input  logic        mem_axi4_0_r_bits_last,
  input  logic [1:0]  mem_axi4_0_r_bits_resp,
  output logic        mem_axi4_0_r_ready
);

  `include "cheshire/typedef.svh"

  function automatic cheshire_cfg_t make_cfg();
    cheshire_cfg_t cfg = DefaultCfg;
    cfg.RtcFreq = 1000000;
    cfg.SerialLink = 0;
    cfg.I2c = 0;
    cfg.Gpio = 0;
    cfg.Dma = 0;
    cfg.Vga = 0;
    cfg.Usb = 0;
    return cfg;
  endfunction

  localparam cheshire_cfg_t Cfg = make_cfg();
  `CHESHIRE_TYPEDEF_ALL(, Cfg)

  axi_llc_req_t dram_req;
  axi_llc_rsp_t dram_rsp;
  cheshire_soc #(
    .Cfg(Cfg),
    .ExtHartinfo('0),
    .axi_ext_llc_req_t(axi_llc_req_t),
    .axi_ext_llc_rsp_t(axi_llc_rsp_t),
    .axi_ext_mst_req_t(axi_mst_req_t),
    .axi_ext_mst_rsp_t(axi_mst_rsp_t),
    .axi_ext_slv_req_t(axi_slv_req_t),
    .axi_ext_slv_rsp_t(axi_slv_rsp_t),
    .reg_ext_req_t(reg_req_t),
    .reg_ext_rsp_t(reg_rsp_t)
  ) dut (
    .clk_i(clk),
    .rst_ni(rst_n),
    .test_mode_i(1'b0),
    .boot_mode_i('0),
    .rtc_i(1'b0),
    .axi_llc_mst_req_o(dram_req),
    .axi_llc_mst_rsp_i(dram_rsp),
    .axi_ext_mst_req_i('0),
    .axi_ext_slv_rsp_i('0),
    .reg_ext_slv_rsp_i('0),
    .intr_ext_i('0),
    .dbg_ext_unavail_i('0),
    .jtag_tck_i(1'b0),
    .jtag_trst_ni(rst_n),
    .jtag_tms_i(1'b1),
    .jtag_tdi_i(1'b0),
    .uart_rx_i(1'b1),
    .uart_cts_ni(1'b0),
    .uart_dsr_ni(1'b0),
    .uart_dcd_ni(1'b0),
    .uart_rin_ni(1'b0),
    .fase_memory_ready_i(memory_ready),
    .fase_uart_rx_i(fase_uart_rxd),
    .fase_uart_tx_o(fase_uart_txd),
    .i2c_sda_i(1'b1),
    .i2c_scl_i(1'b1),
    .spih_sd_i('1),
    .gpio_i('0),
    .slink_rcv_clk_i('0),
    .slink_i('0),
    .usb_clk_i(1'b0),
    .usb_rst_ni(rst_n),
    .usb_dm_i('0),
    .usb_dp_i('0)
  );

  assign fase_uart_state = dut.gen_cva6_cores[0].gen_fase.i_fase_microcode.io_dbg_sta;
  assign fase_fault = dut.gen_cva6_cores[0].i_core_cva6.fase_fault_q;
  assign fase_debug = {
    dut.gen_cva6_cores[0].fase_inited,
    dut.gen_cva6_cores[0].fase_priv,
    dut.gen_cva6_cores[0].i_core_cva6.fase_block_fetch,
    dut.gen_cva6_cores[0].i_core_cva6.fase_drained,
    dut.gen_cva6_cores[0].i_core_cva6.fase_inflight_q,
    dut.gen_cva6_cores[0].i_core_cva6.fase_retired_q,
    fase_fault,
    dut.gen_cva6_cores[0].i_core_cva6.fase_scoreboard_empty,
    dut.gen_cva6_cores[0].i_core_cva6.fase_units_idle,
    dut.gen_cva6_cores[0].i_core_cva6.busy_cache_ctrl,
    dut.gen_cva6_cores[0].i_core_cva6.halt_ctrl,
    dut.gen_cva6_cores[0].i_core_cva6.halt_frontend,
    dut.gen_cva6_cores[0].i_core_cva6.fase_reg_grant,
    dut.gen_cva6_cores[0].fase_inst_valid,
    dut.gen_cva6_cores[0].fase_inst_ready
  };

  assign {mem_axi4_0_aw_valid, mem_axi4_0_w_valid, mem_axi4_0_ar_valid} =
      {dram_req.aw_valid, dram_req.w_valid, dram_req.ar_valid};
  assign mem_axi4_0_aw_bits_addr  = 48'(dram_req.aw.addr);
  assign mem_axi4_0_aw_bits_id    = 16'(dram_req.aw.id);
  assign mem_axi4_0_aw_bits_len   = dram_req.aw.len;
  assign mem_axi4_0_aw_bits_size  = dram_req.aw.size;
  assign mem_axi4_0_aw_bits_burst = dram_req.aw.burst;
  assign mem_axi4_0_w_bits_data   = dram_req.w.data;
  assign mem_axi4_0_w_bits_strb   = dram_req.w.strb;
  assign mem_axi4_0_w_bits_last   = dram_req.w.last;
  assign mem_axi4_0_b_ready      = dram_req.b_ready;
  assign mem_axi4_0_ar_bits_addr  = 48'(dram_req.ar.addr);
  assign mem_axi4_0_ar_bits_id    = 16'(dram_req.ar.id);
  assign mem_axi4_0_ar_bits_len   = dram_req.ar.len;
  assign mem_axi4_0_ar_bits_size  = dram_req.ar.size;
  assign mem_axi4_0_ar_bits_burst = dram_req.ar.burst;
  assign mem_axi4_0_r_ready      = dram_req.r_ready;

  always_comb begin
    dram_rsp = '0;
    dram_rsp.aw_ready = mem_axi4_0_aw_ready;
    dram_rsp.w_ready  = mem_axi4_0_w_ready;
    dram_rsp.b_valid  = mem_axi4_0_b_valid;
    dram_rsp.b.id     = mem_axi4_0_b_bits_id[$bits(dram_rsp.b.id)-1:0];
    dram_rsp.b.resp   = mem_axi4_0_b_bits_resp;
    dram_rsp.ar_ready = mem_axi4_0_ar_ready;
    dram_rsp.r_valid  = mem_axi4_0_r_valid;
    dram_rsp.r.data   = mem_axi4_0_r_bits_data;
    dram_rsp.r.id     = mem_axi4_0_r_bits_id[$bits(dram_rsp.r.id)-1:0];
    dram_rsp.r.last   = mem_axi4_0_r_bits_last;
    dram_rsp.r.resp   = mem_axi4_0_r_bits_resp;
  end
endmodule
