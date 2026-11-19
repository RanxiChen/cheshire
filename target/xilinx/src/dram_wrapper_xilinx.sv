// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Cyril Koenig <cykoenig@iis.ee.ethz.ch>
// Paul Scheffler <paulsc@iis.ee.ethz.ch>
// Yvan Tortorella <yvan.tortorella@gmail.com>
//
// Resize AXI AW, IW, and DW before connecting to a Xilinx DRAM controller.

`include "cheshire/typedef.svh"
`include "phy_definitions.svh"
`include "common_cells/registers.svh"

`ifdef TARGET_KCU105
module dram_wrapper_xilinx #(
  parameter type axi_soc_aw_chan_t = logic,
  parameter type axi_soc_w_chan_t  = logic,
  parameter type axi_soc_b_chan_t  = logic,
  parameter type axi_soc_ar_chan_t = logic,
  parameter type axi_soc_r_chan_t  = logic,
  parameter type axi_soc_req_t     = logic,
  parameter type axi_soc_resp_t    = logic,
  parameter int unsigned Ddr4CsNWidth = 1,
  parameter int unsigned Ddr4DmDbiNWidth = 8,
  parameter int unsigned Ddr4DqWidth = 64,
  parameter int unsigned Ddr4DqsWidth = 8
) (
  // System reset
  input  logic  sys_rst_i,
`ifdef TARGET_KCU105
  input  logic  dram_clk_p_i,
  input  logic  dram_clk_n_i,
  output logic  dram_calib_complete_o,
`else
  input  logic  dram_clk_i,
`endif
  // Controller reset
  input  logic  soc_resetn_i,
  input  logic  soc_clk_i,
  // PHY interfaces
`ifdef USE_DDR4
  `DDR4_INTF(Ddr4CsNWidth, Ddr4DmDbiNWidth, Ddr4DqWidth, Ddr4DqsWidth)
`endif
`ifdef USE_DDR3
  `DDR3_INTF
`endif
  // DRAM AXI interface
  input  axi_soc_req_t  soc_req_i,
  output axi_soc_resp_t soc_rsp_o
);
  // CPU physical [0x80000000, 0x100000000) maps to DDR offsets [0, 2 GiB).
  wire [30:0] aw_offset = 31'(soc_req_i.aw.addr - 48'h80000000);
  wire [30:0] ar_offset = 31'(soc_req_i.ar.addr - 48'h80000000);
  // SmartConnect rejects FIXED bursts, including len=0 from AXI-Lite bridges.
  // For a single beat FIXED and INCR address semantics are identical.
  // Preserve multi-beat FIXED requests so unsupported semantics are not changed.
  wire [1:0] aw_burst = (soc_req_i.aw.len == 0 && soc_req_i.aw.burst == 2'b00)
                      ? 2'b01 : soc_req_i.aw.burst;
  wire [1:0] ar_burst = (soc_req_i.ar.len == 0 && soc_req_i.ar.burst == 2'b00)
                      ? 2'b01 : soc_req_i.ar.burst;
  assign soc_rsp_o.b.user = '0;
  assign soc_rsp_o.r.user = '0;

  initial begin
    if ($bits(soc_req_i.w.data) != 64 || $bits(soc_req_i.aw.id) != 4)
      $error("KCU105 DDR boundary requires DATA_WIDTH=64, ID_WIDTH=4");
  end

  kcu105_ddr_wrapper i_board_ddr (
    .axi_clock                       ( soc_clk_i ),
    .axi_resetn                      ( soc_resetn_i ),
    .sys_reset                       ( sys_rst_i ),
    .init_calib_complete             ( dram_calib_complete_o ),
    .default_sysclk_300_clk_p        ( dram_clk_p_i ),
    .default_sysclk_300_clk_n        ( dram_clk_n_i ),
    .ddr4_sdram_reset_n              ( c0_ddr4_reset_n ),
    .ddr4_sdram_ck_t                 ( c0_ddr4_ck_t ),
    .ddr4_sdram_ck_c                 ( c0_ddr4_ck_c ),
    .ddr4_sdram_act_n                ( c0_ddr4_act_n ),
    .ddr4_sdram_adr                  ( c0_ddr4_adr ),
    .ddr4_sdram_ba                   ( c0_ddr4_ba ),
    .ddr4_sdram_bg                   ( c0_ddr4_bg ),
    .ddr4_sdram_cke                  ( c0_ddr4_cke ),
    .ddr4_sdram_odt                  ( c0_ddr4_odt ),
    .ddr4_sdram_cs_n                 ( c0_ddr4_cs_n ),
    .ddr4_sdram_dm_n                 ( c0_ddr4_dm_dbi_n ),
    .ddr4_sdram_dq                   ( c0_ddr4_dq ),
    .ddr4_sdram_dqs_c                ( c0_ddr4_dqs_c ),
    .ddr4_sdram_dqs_t                ( c0_ddr4_dqs_t ),
    .S_AXI_awid                      ( soc_req_i.aw.id ),
    .S_AXI_awaddr                    ( aw_offset ),
    .S_AXI_awlen                     ( soc_req_i.aw.len ),
    .S_AXI_awsize                    ( soc_req_i.aw.size ),
    .S_AXI_awburst                   ( aw_burst ),
    .S_AXI_awlock                    ( soc_req_i.aw.lock ),
    .S_AXI_awcache                   ( soc_req_i.aw.cache ),
    .S_AXI_awprot                    ( soc_req_i.aw.prot ),
    .S_AXI_awqos                     ( soc_req_i.aw.qos ),
    .S_AXI_arid                      ( soc_req_i.ar.id ),
    .S_AXI_araddr                    ( ar_offset ),
    .S_AXI_arlen                     ( soc_req_i.ar.len ),
    .S_AXI_arsize                    ( soc_req_i.ar.size ),
    .S_AXI_arburst                   ( ar_burst ),
    .S_AXI_arlock                    ( soc_req_i.ar.lock ),
    .S_AXI_arcache                   ( soc_req_i.ar.cache ),
    .S_AXI_arprot                    ( soc_req_i.ar.prot ),
    .S_AXI_arqos                     ( soc_req_i.ar.qos ),
    .S_AXI_wdata                     ( soc_req_i.w.data ),
    .S_AXI_wstrb                     ( soc_req_i.w.strb ),
    .S_AXI_wlast                     ( soc_req_i.w.last ),
    .S_AXI_bid                       ( soc_rsp_o.b.id ),
    .S_AXI_bresp                     ( soc_rsp_o.b.resp ),
    .S_AXI_rid                       ( soc_rsp_o.r.id ),
    .S_AXI_rdata                     ( soc_rsp_o.r.data ),
    .S_AXI_rresp                     ( soc_rsp_o.r.resp ),
    .S_AXI_rlast                     ( soc_rsp_o.r.last ),
    .S_AXI_awvalid                   ( soc_req_i.aw_valid ),
    .S_AXI_awready                   ( soc_rsp_o.aw_ready ),
    .S_AXI_arvalid                   ( soc_req_i.ar_valid ),
    .S_AXI_arready                   ( soc_rsp_o.ar_ready ),
    .S_AXI_wvalid                    ( soc_req_i.w_valid ),
    .S_AXI_wready                    ( soc_rsp_o.w_ready ),
    .S_AXI_bvalid                    ( soc_rsp_o.b_valid ),
    .S_AXI_bready                    ( soc_req_i.b_ready ),
    .S_AXI_rvalid                    ( soc_rsp_o.r_valid ),
    .S_AXI_rready                    ( soc_req_i.r_ready )
  );
endmodule

`else
// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Cyril Koenig <cykoenig@iis.ee.ethz.ch>
// Paul Scheffler <paulsc@iis.ee.ethz.ch>
// Yvan Tortorella <yvan.tortorella@gmail.com>
//
// Resize AXI AW, IW, and DW before connecting to a Xilinx DRAM controller.

`include "cheshire/typedef.svh"
`include "phy_definitions.svh"
`include "common_cells/registers.svh"

module dram_wrapper_xilinx #(
  parameter type axi_soc_aw_chan_t = logic,
  parameter type axi_soc_w_chan_t  = logic,
  parameter type axi_soc_b_chan_t  = logic,
  parameter type axi_soc_ar_chan_t = logic,
  parameter type axi_soc_r_chan_t  = logic,
  parameter type axi_soc_req_t     = logic,
  parameter type axi_soc_resp_t    = logic,
  parameter int unsigned Ddr4CsNWidth = 1,
  parameter int unsigned Ddr4DmDbiNWidth = 8,
  parameter int unsigned Ddr4DqWidth = 64,
  parameter int unsigned Ddr4DqsWidth = 8
) (
  // System reset
  input  logic  sys_rst_i,
`ifdef TARGET_KCU105
  input  logic  dram_clk_p_i,
  input  logic  dram_clk_n_i,
  output logic  dram_calib_complete_o,
`else
  input  logic  dram_clk_i,
`endif
  // Controller reset
  input  logic  soc_resetn_i,
  input  logic  soc_clk_i,
  // PHY interfaces
`ifdef USE_DDR4
  `DDR4_INTF(Ddr4CsNWidth, Ddr4DmDbiNWidth, Ddr4DqWidth, Ddr4DqsWidth)
`endif
`ifdef USE_DDR3
  `DDR3_INTF
`endif
  // DRAM AXI interface
  input  axi_soc_req_t  soc_req_i,
  output axi_soc_resp_t soc_rsp_o
);

  //////////////////////////////////////
  //  Configurations and definitions  //
  //////////////////////////////////////

  typedef struct packed {
    bit     EnCdc;
    integer CdcLogDepth;
    integer IdWidth;
    integer AddrWidth;
    integer DataWidth;
    integer StrobeWidth;
    integer MaxUniqIds;
    integer MaxTxns;
  } dram_cfg_t;

`ifdef TARGET_KCU105
  localparam dram_cfg_t cfg = '{1, 5, 8, 31, 512, 64, 8, 24};
`elsif TARGET_VCU118
  localparam dram_cfg_t cfg = '{
    EnCdc         : 1,    // 333 MHz AXI (cf. CdcLogDepth)
    CdcLogDepth   : 5,
    IdWidth       : 8,
    AddrWidth     : 31,
    DataWidth     : 512,
    StrobeWidth   : 64,
    MaxUniqIds    : 8,    // TODO: suboptimal, but limited by CVA6/LLC
    MaxTxns       : 24    // TODO: suboptimal, but limited by CVA6/LLC
  };
`endif

`ifdef TARGET_VCU128
  localparam dram_cfg_t cfg = '{
    EnCdc         : 1,    // 333 MHz AXI (cf. CdcLogDepth)
    CdcLogDepth   : 5,
    IdWidth       : 8,
    AddrWidth     : 32,
    DataWidth     : 512,
    StrobeWidth   : 64,
    MaxUniqIds    : 8,    // TODO: suboptimal, but limited by CVA6/LLC
    MaxTxns       : 24    // TODO: suboptimal, but limited by CVA6/LLC
  };
`endif

`ifdef TARGET_GENESYS2
  localparam dram_cfg_t cfg = '{
    EnCdc         : 1,    // 200 MHz AXI (cf. CCdcLogDepth)
    CdcLogDepth   : 5,
    IdWidth       : 4,    // Fixed
    AddrWidth     : 30,
    DataWidth     : 64,
    StrobeWidth   : 8,
    MaxUniqIds    : 8,    // TODO: suboptimal, but limited by CVA6/LLC
    MaxTxns       : 24    // TODO: suboptimal, but limited by CVA6/LLC
  };
`endif

  localparam SocDataWidth = $bits(soc_req_i.w.data);
  localparam SocIdWidth   = $bits(soc_req_i.ar.id);
  localparam SocUserWidth = $bits(soc_req_i.ar.user);
  localparam SocAddrWidth = $bits(soc_req_i.ar.addr);

  // Define type after data width and address resizer
  `AXI_TYPEDEF_ALL(axi_dw, logic[SocAddrWidth-1:0], logic[SocIdWidth-1:0],
                   logic[cfg.DataWidth-1:0], logic[cfg.StrobeWidth-1:0],
                   logic[SocUserWidth-1:0])

  // Define type after data & id width resizers
  `AXI_TYPEDEF_ALL(axi_dw_iw, logic[SocAddrWidth-1:0], logic[cfg.IdWidth-1:0],
                   logic[cfg.DataWidth-1:0], logic[cfg.StrobeWidth-1:0],
                   logic[SocUserWidth-1:0])

  // Clock on which is clocked the DRAM AXI
  logic dram_axi_clk;
  logic dram_rst_o;
`ifdef TARGET_KCU105
  logic dram_axi_resetn;

  // Assert from the DDR controller and release in the DDR UI clock domain.
  rstgen i_rstgen_ddr_ui (
    .clk_i       ( dram_axi_clk ),
    .rst_ni      ( ~dram_rst_o ),
    .test_mode_i ( 1'b0 ),
    .rst_no      ( dram_axi_resetn ),
    .init_no     ( )
  );
`else
  wire dram_axi_resetn = ~dram_rst_o;
`endif

  // Signals before resizing
  axi_soc_req_t  soc_dresizer_req;
  axi_soc_resp_t soc_dresizer_rsp;

  // Signals after data width resizing
  axi_dw_req_t  dresizer_iresizer_req;
  axi_dw_resp_t dresizer_iresizer_rsp;

  // Signals after id width resizing
  axi_dw_iw_req_t  iresizer_cdc_req, cdc_dram_req;
  axi_dw_iw_resp_t iresizer_cdc_rsp, cdc_dram_rsp;

  // Entry signals
  assign soc_dresizer_req = soc_req_i;
  assign soc_rsp_o = soc_dresizer_rsp;

  ////////////////////
  //  DW converter  //
  ////////////////////

  axi_dw_converter #(
    .AxiMaxReads          ( cfg.MaxTxns   ),
    .AxiSlvPortDataWidth  ( SocDataWidth  ),
    .AxiMstPortDataWidth  ( cfg.DataWidth ),
    .AxiAddrWidth         ( SocAddrWidth  ),
    .AxiIdWidth           ( SocIdWidth    ),
    // Common AW, AR, B
    .aw_chan_t            ( axi_soc_aw_chan_t ),
    .b_chan_t             ( axi_soc_b_chan_t  ),
    .ar_chan_t            ( axi_soc_ar_chan_t ),
    // Manager W, R
    .mst_w_chan_t         ( axi_dw_w_chan_t ),
    .mst_r_chan_t         ( axi_dw_r_chan_t ),
    .axi_mst_req_t        ( axi_dw_req_t    ),
    .axi_mst_resp_t       ( axi_dw_resp_t   ),
    // Subordinate W, R
    .slv_w_chan_t         ( axi_soc_w_chan_t ),
    .slv_r_chan_t         ( axi_soc_r_chan_t ),
    .axi_slv_req_t        ( axi_soc_req_t  ),
    .axi_slv_resp_t       ( axi_soc_resp_t )
  ) i_axi_dw_converter (
    .clk_i      ( soc_clk_i    ),
    .rst_ni     ( soc_resetn_i ),
    .slv_req_i  ( soc_dresizer_req ),
    .slv_resp_o ( soc_dresizer_rsp ),
    .mst_req_o  ( dresizer_iresizer_req ),
    .mst_resp_i ( dresizer_iresizer_rsp )
  );

  //////////////////
  //  ID resizer  //
  //////////////////

  // TODO: Implement simpler solutions
  axi_iw_converter #(
    .AxiAddrWidth           ( SocAddrWidth  ),
    .AxiDataWidth           ( cfg.DataWidth ),
    .AxiUserWidth           ( SocUserWidth  ),
    .AxiSlvPortIdWidth      ( SocIdWidth    ),
    .AxiSlvPortMaxUniqIds   ( cfg.MaxUniqIds ),
    .AxiSlvPortMaxTxnsPerId ( cfg.MaxTxns    ),
    .AxiSlvPortMaxTxns      ( cfg.MaxTxns    ),
    .AxiMstPortIdWidth      ( cfg.IdWidth    ),
    .AxiMstPortMaxUniqIds   ( cfg.MaxUniqIds ),
    .AxiMstPortMaxTxnsPerId ( cfg.MaxTxns    ),
    .slv_req_t              ( axi_dw_req_t     ),
    .slv_resp_t             ( axi_dw_resp_t    ),
    .mst_req_t              ( axi_dw_iw_req_t  ),
    .mst_resp_t             ( axi_dw_iw_resp_t )
  ) i_axi_iw_converter (
    .clk_i      ( soc_clk_i    ),
    .rst_ni     ( soc_resetn_i ),
    .slv_req_i  ( dresizer_iresizer_req ),
    .slv_resp_o ( dresizer_iresizer_rsp ),
    .mst_req_o  ( iresizer_cdc_req ),
    .mst_resp_i ( iresizer_cdc_rsp )
  );

  ////////////////////////
  //  Instiantiate CDC  //
  ////////////////////////

  if (cfg.EnCdc) begin : gen_cdc
    axi_cdc #(
      .aw_chan_t  ( axi_dw_iw_aw_chan_t),
      .w_chan_t   ( axi_dw_iw_w_chan_t),
      .b_chan_t   ( axi_dw_iw_b_chan_t),
      .ar_chan_t  ( axi_dw_iw_ar_chan_t),
      .r_chan_t   ( axi_dw_iw_r_chan_t),
      .axi_req_t  ( axi_dw_iw_req_t),
      .axi_resp_t ( axi_dw_iw_resp_t),
      .LogDepth   ( cfg.CdcLogDepth )
    ) i_axi_cdc_mig (
      .src_clk_i  ( soc_clk_i    ),
      .src_rst_ni ( soc_resetn_i ),
      .src_req_i  ( iresizer_cdc_req ),
      .src_resp_o ( iresizer_cdc_rsp ),
      .dst_clk_i  ( dram_axi_clk ),
      .dst_rst_ni ( dram_axi_resetn ),
      .dst_req_o  ( cdc_dram_req ),
      .dst_resp_i ( cdc_dram_rsp )
    );
  end else begin : gen_no_cdc
    assign cdc_dram_req     = iresizer_cdc_req;
    assign iresizer_cdc_rsp = cdc_dram_rsp;
  end

  ////////////////////////////////
  //  Map User, Resize Address  //
  ////////////////////////////////

  assign cdc_dram_rsp.b.user = '0;
  assign cdc_dram_rsp.r.user = '0;

  logic [cfg.AddrWidth-1:0] cdc_dram_req_aw_addr;
  logic [cfg.AddrWidth-1:0] cdc_dram_req_ar_addr;

  assign cdc_dram_req_aw_addr = cdc_dram_req.aw.addr[cfg.AddrWidth-1:0];
  assign cdc_dram_req_ar_addr = cdc_dram_req.ar.addr[cfg.AddrWidth-1:0];

  /////////////////////////
  //  Instiantiate DDR4  //
  /////////////////////////

`ifdef USE_DDR4
  ddr4 i_dram (
    // Reset
    .sys_rst                    ( sys_rst_i    ),  // Active high
`ifdef TARGET_KCU105
    .c0_sys_clk_p               ( dram_clk_p_i ),
    .c0_sys_clk_n               ( dram_clk_n_i ),
    .c0_ddr4_aresetn            ( dram_axi_resetn ),
`else
    .c0_sys_clk_i               ( dram_clk_i   ),
    .c0_ddr4_aresetn            ( soc_resetn_i ),
`endif
    // Clock and reset out
    .c0_ddr4_ui_clk             ( dram_axi_clk ),
    .c0_ddr4_ui_clk_sync_rst    ( dram_rst_o   ),
    // AXI
    .c0_ddr4_s_axi_awid         ( cdc_dram_req.aw.id    ),
    .c0_ddr4_s_axi_awaddr       ( cdc_dram_req_aw_addr  ),
    .c0_ddr4_s_axi_awlen        ( cdc_dram_req.aw.len   ),
    .c0_ddr4_s_axi_awsize       ( cdc_dram_req.aw.size  ),
    .c0_ddr4_s_axi_awburst      ( cdc_dram_req.aw.burst ),
    .c0_ddr4_s_axi_awlock       ( cdc_dram_req.aw.lock  ),
    .c0_ddr4_s_axi_awcache      ( cdc_dram_req.aw.cache ),
    .c0_ddr4_s_axi_awprot       ( cdc_dram_req.aw.prot  ),
    .c0_ddr4_s_axi_awqos        ( cdc_dram_req.aw.qos   ),
    .c0_ddr4_s_axi_awvalid      ( cdc_dram_req.aw_valid ),
    .c0_ddr4_s_axi_awready      ( cdc_dram_rsp.aw_ready ),
    .c0_ddr4_s_axi_wdata        ( cdc_dram_req.w.data   ),
    .c0_ddr4_s_axi_wstrb        ( cdc_dram_req.w.strb   ),
    .c0_ddr4_s_axi_wlast        ( cdc_dram_req.w.last   ),
    .c0_ddr4_s_axi_wvalid       ( cdc_dram_req.w_valid  ),
    .c0_ddr4_s_axi_wready       ( cdc_dram_rsp.w_ready  ),
    .c0_ddr4_s_axi_bready       ( cdc_dram_req.b_ready  ),
    .c0_ddr4_s_axi_bid          ( cdc_dram_rsp.b.id     ),
    .c0_ddr4_s_axi_bresp        ( cdc_dram_rsp.b.resp   ),
    .c0_ddr4_s_axi_bvalid       ( cdc_dram_rsp.b_valid  ),
    .c0_ddr4_s_axi_arid         ( cdc_dram_req.ar.id    ),
    .c0_ddr4_s_axi_araddr       ( cdc_dram_req_ar_addr  ),
    .c0_ddr4_s_axi_arlen        ( cdc_dram_req.ar.len   ),
    .c0_ddr4_s_axi_arsize       ( cdc_dram_req.ar.size  ),
    .c0_ddr4_s_axi_arburst      ( cdc_dram_req.ar.burst ),
    .c0_ddr4_s_axi_arlock       ( cdc_dram_req.ar.lock  ),
    .c0_ddr4_s_axi_arcache      ( cdc_dram_req.ar.cache ),
    .c0_ddr4_s_axi_arprot       ( cdc_dram_req.ar.prot  ),
    .c0_ddr4_s_axi_arqos        ( cdc_dram_req.ar.qos   ),
    .c0_ddr4_s_axi_arvalid      ( cdc_dram_req.ar_valid ),
    .c0_ddr4_s_axi_arready      ( cdc_dram_rsp.ar_ready ),
    .c0_ddr4_s_axi_rready       ( cdc_dram_req.r_ready  ),
    .c0_ddr4_s_axi_rid          ( cdc_dram_rsp.r.id     ),
    .c0_ddr4_s_axi_rdata        ( cdc_dram_rsp.r.data   ),
    .c0_ddr4_s_axi_rresp        ( cdc_dram_rsp.r.resp   ),
    .c0_ddr4_s_axi_rlast        ( cdc_dram_rsp.r.last   ),
    .c0_ddr4_s_axi_rvalid       ( cdc_dram_rsp.r_valid  ),
    // Others
`ifdef TARGET_KCU105
    .c0_init_calib_complete     ( dram_calib_complete_o ),
`else
    .c0_init_calib_complete     ( ),
    .addn_ui_clkout1            ( dram_clk_o ),
`endif
    .dbg_clk                    ( ),
    .dbg_bus                    ( ),
    // PHY
    .*
  );
`endif

  /////////////////////////
  //  Instiantiate DDR3  //
  /////////////////////////

`ifdef USE_DDR3
  mig7s i_dram (
    .sys_rst              ( sys_rst_i    ), // Active high
    .sys_clk_i            ( dram_clk_i   ),
    .ui_clk               ( dram_axi_clk ),
    .ui_clk_sync_rst      ( dram_rst_o ),
    .mmcm_locked          ( ),
    .app_sr_req           ( '0 ),
    .app_ref_req          ( '0 ),
    .app_zq_req           ( '0 ),
    .app_sr_active        ( ),
    .app_ref_ack          ( ),
    .app_zq_ack           ( ),
    .aresetn              ( soc_resetn_i ),
    .s_axi_awid           ( cdc_dram_req.aw.id    ),
    .s_axi_awaddr         ( cdc_dram_req_aw_addr  ),
    .s_axi_awlen          ( cdc_dram_req.aw.len   ),
    .s_axi_awsize         ( cdc_dram_req.aw.size  ),
    .s_axi_awburst        ( cdc_dram_req.aw.burst ),
    .s_axi_awlock         ( cdc_dram_req.aw.lock  ),
    .s_axi_awcache        ( cdc_dram_req.aw.cache ),
    .s_axi_awprot         ( cdc_dram_req.aw.prot  ),
    .s_axi_awqos          ( cdc_dram_req.aw.qos   ),
    .s_axi_awvalid        ( cdc_dram_req.aw_valid ),
    .s_axi_awready        ( cdc_dram_rsp.aw_ready ),
    .s_axi_wdata          ( cdc_dram_req.w.data   ),
    .s_axi_wstrb          ( cdc_dram_req.w.strb   ),
    .s_axi_wlast          ( cdc_dram_req.w.last   ),
    .s_axi_wvalid         ( cdc_dram_req.w_valid  ),
    .s_axi_wready         ( cdc_dram_rsp.w_ready  ),
    .s_axi_bready         ( cdc_dram_req.b_ready  ),
    .s_axi_bid            ( cdc_dram_rsp.b.id     ),
    .s_axi_bresp          ( cdc_dram_rsp.b.resp   ),
    .s_axi_bvalid         ( cdc_dram_rsp.b_valid  ),
    .s_axi_arid           ( cdc_dram_req.ar.id    ),
    .s_axi_araddr         ( cdc_dram_req_ar_addr  ),
    .s_axi_arlen          ( cdc_dram_req.ar.len   ),
    .s_axi_arsize         ( cdc_dram_req.ar.size  ),
    .s_axi_arburst        ( cdc_dram_req.ar.burst ),
    .s_axi_arlock         ( cdc_dram_req.ar.lock  ),
    .s_axi_arcache        ( cdc_dram_req.ar.cache ),
    .s_axi_arprot         ( cdc_dram_req.ar.prot  ),
    .s_axi_arqos          ( cdc_dram_req.ar.qos   ),
    .s_axi_arvalid        ( cdc_dram_req.ar_valid ),
    .s_axi_arready        ( cdc_dram_rsp.ar_ready ),
    .s_axi_rready         ( cdc_dram_req.r_ready  ),
    .s_axi_rid            ( cdc_dram_rsp.r.id     ),
    .s_axi_rdata          ( cdc_dram_rsp.r.data   ),
    .s_axi_rresp          ( cdc_dram_rsp.r.resp   ),
    .s_axi_rlast          ( cdc_dram_rsp.r.last   ),
    .s_axi_rvalid         ( cdc_dram_rsp.r_valid  ),
    .init_calib_complete  ( ),
    .device_temp          ( ),
    // PHY
    .*
  );
`endif  // USE_DDR3

endmodule

`endif
