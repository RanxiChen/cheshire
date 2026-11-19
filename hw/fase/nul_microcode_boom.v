module Queue_91(
  input   clock,
  input   reset,
  output  io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input   io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input   io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output  io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output  io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  ram [0:1]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire  ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire  ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire  ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:8]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 57:35]
  reg  enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 283:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 284:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 285:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  assign ram_io_deq_bits_MPORT_en = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  assign ram_MPORT_data = 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_addr = enq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:8]
  assign ram_MPORT_mask = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_en = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 309:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 308:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 316:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 1'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 292:16]
      enq_ptr_value <= enq_ptr_value + 1'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 1'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 296:16]
      deq_ptr_value <= deq_ptr_value + 1'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 299:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 300:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 2; initvar = initvar+1)
    ram[initvar] = _RAND_0[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

module NulCPUCtrlMPMicrocode(
  input         clock,
  input         reset,
  input         io_cpu_0_inited, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input  [1:0]  io_cpu_0_priv, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_cpu_0_ext_itr, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_cpu_0_stop_fetch, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_cpu_0_regacc_rd, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_cpu_0_regacc_wt, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output [4:0]  io_cpu_0_regacc_idx, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output [63:0] io_cpu_0_regacc_wdata, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input  [63:0] io_cpu_0_regacc_rdata, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input         io_cpu_0_regacc_busy, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_cpu_0_inst64, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output [31:0] io_cpu_0_inst64_raw, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input         io_cpu_0_inst64_ready, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input         io_cpu_0_inst64_busy, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input         io_tx_ready, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_tx_valid, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output [7:0]  io_tx_bits, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output        io_rx_ready, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input         io_rx_valid, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  input  [7:0]  io_rx_bits, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
  output [7:0]  io_dbg_sta // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 76:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_15;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [63:0] _RAND_61;
  reg [63:0] _RAND_62;
  reg [63:0] _RAND_63;
  reg [63:0] _RAND_64;
  reg [63:0] _RAND_65;
  reg [63:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [63:0] _RAND_70;
  reg [63:0] _RAND_71;
  reg [63:0] _RAND_72;
  reg [63:0] _RAND_73;
  reg [63:0] _RAND_74;
  reg [63:0] _RAND_75;
  reg [63:0] _RAND_76;
  reg [63:0] _RAND_77;
  reg [63:0] _RAND_78;
  reg [31:0] _RAND_79;
`endif // RANDOMIZE_REG_INIT
  wire  event_queue_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_io_enq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_io_enq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_io_deq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_io_deq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  wire  event_queue_io_deq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
  reg [38:0] ctrl_rom [0:255]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:29]
  wire  ctrl_rom_ctrl_content_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:{29,29} 162:{35,35}]
  reg [7:0] ctrl_rom_ctrl_content_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:29]
  wire [38:0] ctrl_rom_ctrl_content_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:29]
  reg [7:0] page_mem_0 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_0_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_0_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_0_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_0_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_0_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_0_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_0_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_1 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_1_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_1_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_1_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_1_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_1_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_1_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_1_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_2 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_2_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_2_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_2_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_2_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_2_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_2_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_2_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_3 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_3_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_3_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_3_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_3_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_3_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_3_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_3_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_4 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_4_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_4_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_4_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_4_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_4_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_4_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_4_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_5 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_5_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_5_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_5_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_5_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_5_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_5_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_5_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_6 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_6_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_6_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_6_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_6_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_6_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_6_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_6_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [7:0] page_mem_7 [0:63]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire  page_mem_7_pageReadData_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 815:21 816:20]
  reg [5:0] page_mem_7_pageReadData_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_7_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  wire [7:0] page_mem_7_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 310:19]
  wire [5:0] page_mem_7_MPORT_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 309:22]
  wire  page_mem_7_MPORT_mask; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 311:19]
  wire  page_mem_7_MPORT_en; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29 308:27]
  reg [1:0] cpu_state_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 106:26]
  reg [63:0] global_clk; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 108:27]
  reg [63:0] user_clk_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 109:25]
  wire [63:0] _global_clk_T_1 = global_clk + 64'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 111:28]
  wire [63:0] _user_clk_0_T_1 = user_clk_0 + 64'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 114:34]
  reg  cpu_raised_itr_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 118:31]
  reg [1:0] last_priv_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 119:26]
  wire  _T_3 = last_priv_0 == 2'h0 & io_cpu_0_priv != 2'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 122:33]
  wire  _GEN_1 = last_priv_0 == 2'h0 & io_cpu_0_priv != 2'h0 & cpu_state_0 == 2'h3 | cpu_raised_itr_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 122:106 123:25 118:31]
  wire [1:0] _GEN_2 = last_priv_0 == 2'h0 & io_cpu_0_priv != 2'h0 & cpu_state_0 == 2'h3 ? 2'h2 : cpu_state_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 122:106 124:20 106:26]
  wire  _io_cpu_0_stop_fetch_T = cpu_state_0 == 2'h2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 126:43]
  wire  _io_cpu_0_stop_fetch_T_1 = cpu_state_0 == 2'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 126:86]
  reg [4:0] state; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 139:22]
  reg [4:0] trans_bytes; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 140:28]
  reg [3:0] trans_pos; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 141:26]
  reg [4:0] state_register; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 145:31]
  reg [5:0] errno; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22]
  reg  initialized; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 147:28]
  wire  errored = state == 5'hb; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 148:24]
  wire [1:0] io_dbg_sta_hi = {initialized,errored}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 149:20]
  reg [4:0] opcode; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 150:23]
  reg [2:0] opoff; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 151:22]
  reg [7:0] oparg_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_14; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] oparg_15; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
  reg [7:0] retarg_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  reg [7:0] retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
  wire  _T_141 = state == 5'h8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 683:14]
  wire  _T_140 = state == 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 679:14]
  wire  _T_127 = state == 5'h5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:14]
  wire  ctrl_regacc_wt = ctrl_rom_ctrl_content_data[36]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 168:36]
  wire  ctrl_regacc_rd = ctrl_rom_ctrl_content_data[37]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 167:36]
  wire  _will_next_T = ~io_cpu_0_regacc_busy; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 629:20]
  wire  ctrl_inst64 = ctrl_rom_ctrl_content_data[35]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 169:33]
  wire  ctrl_inst64_flush = ctrl_rom_ctrl_content_data[33]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 171:39]
  reg [5:0] cnt_run; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 185:24]
  wire  _postMret_T_3 = state_register == 5'h11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 552:21]
  wire  _postMret_T_5 = state_register == 5'h11 & cnt_run == 6'h11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 552:47]
  wire  postMret = state_register == 5'h4 & cnt_run == 6'h10 | _postMret_T_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 551:80]
  wire  _GEN_873 = ctrl_inst64_flush ? ~io_cpu_0_inst64_busy | postMret : 1'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 632:34 633:17 635:17]
  wire  _GEN_874 = ctrl_inst64 ? io_cpu_0_inst64_ready : _GEN_873; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 630:28 631:17]
  wire  _GEN_875 = ctrl_regacc_wt | ctrl_regacc_rd ? ~io_cpu_0_regacc_busy : _GEN_874; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 628:43 629:17]
  wire  will_next = _T_127 & _GEN_875; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 250:30 627:42]
  wire  _jump_tap_T_2 = cnt_run == 6'h1d; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 566:29]
  wire  _GEN_803 = 5'h11 == state_register & cnt_run == 6'h2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 575:18 546:29]
  wire  _GEN_807 = 5'hd == state_register ? _jump_tap_T_2 : _GEN_803; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 571:18]
  wire  _GEN_810 = 5'hb == state_register ? cnt_run == 6'h1d : _GEN_807; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 566:18]
  wire  _GEN_813 = 5'he == state_register ? cnt_run == 6'h1f : _GEN_810; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 561:18]
  wire  jump_tap = 5'hc == state_register ? cnt_run == 6'he : _GEN_813; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 556:18]
  reg [7:0] pg_loop_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 198:28]
  wire  _jump_condition_T = pg_loop_cnt != 8'h3f; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 557:39]
  reg [6:0] page_ptr_in_rw; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 204:31]
  wire  _jump_condition_T_2 = page_ptr_in_rw != 7'h40; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 567:42]
  reg [63:0] regback_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [47:0] hfutex_match_reg; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 188:33]
  reg [47:0] hfutex_masks_0_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
  reg [47:0] hfutex_masks_0_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
  reg [47:0] hfutex_masks_0_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
  reg [47:0] hfutex_masks_0_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
  wire  hfutex_hit = hfutex_masks_0_0 == hfutex_match_reg | hfutex_masks_0_1 == hfutex_match_reg | hfutex_masks_0_2 ==
    hfutex_match_reg | hfutex_masks_0_3 == hfutex_match_reg; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 190:77]
  wire  no_jump_should = regback_1[6:0] == 7'h1 & hfutex_match_reg != 48'h0 & hfutex_hit; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 576:82]
  wire  _GEN_804 = 5'h11 == state_register & ~no_jump_should; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 577:24 547:35]
  wire  _GEN_808 = 5'hd == state_register ? _jump_condition_T_2 : _GEN_804; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 572:24]
  wire  _GEN_811 = 5'hb == state_register ? page_ptr_in_rw != 7'h40 : _GEN_808; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 567:24]
  wire  _GEN_814 = 5'he == state_register ? _jump_condition_T : _GEN_811; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 562:24]
  wire  jump_condition = 5'hc == state_register ? pg_loop_cnt != 8'h3f : _GEN_814; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 557:24]
  reg [7:0] ctrl_base_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 163:31]
  wire [5:0] _GEN_806 = 5'hd == state_register ? 6'ha : 6'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 570:19]
  wire [5:0] _GEN_809 = 5'hb == state_register ? 6'hb : _GEN_806; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 565:19]
  wire [5:0] _GEN_812 = 5'he == state_register ? 6'hc : _GEN_809; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 560:19]
  wire [5:0] cnt_rerun = 5'hc == state_register ? 6'h4 : _GEN_812; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 553:27 555:19]
  wire [7:0] _GEN_1074 = {{2'd0}, cnt_rerun}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 644:38]
  wire [7:0] _ctrl_ptr_T_5 = ctrl_base_addr + _GEN_1074; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 644:38]
  wire [7:0] _GEN_1075 = {{2'd0}, cnt_run}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 655:38]
  wire [7:0] _ctrl_ptr_T_7 = ctrl_base_addr + _GEN_1075; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 655:38]
  wire [7:0] _ctrl_ptr_T_9 = _ctrl_ptr_T_7 + 8'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 655:48]
  wire [7:0] _GEN_1077 = {{7'd0}, will_next}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 639:42]
  wire [7:0] _ctrl_ptr_T_3 = _ctrl_ptr_T_7 + _GEN_1077; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 639:42]
  wire [7:0] _GEN_882 = ~jump_condition ? _ctrl_ptr_T_9 : _ctrl_ptr_T_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 639:14 653:36 655:20]
  wire [7:0] _GEN_886 = jump_condition ? _ctrl_ptr_T_5 : _GEN_882; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 643:29 644:20]
  wire [7:0] _GEN_891 = jump_tap ? _GEN_886 : _ctrl_ptr_T_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 639:14 642:21]
  wire [7:0] _GEN_897 = will_next ? _GEN_891 : _ctrl_ptr_T_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 639:14 640:20]
  wire  _T_68 = state == 5'h3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:14]
  wire [7:0] _GEN_20 = _T_141 & event_queue_io_deq_valid ? 8'h8 : 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 226:14 161:29]
  wire [7:0] _GEN_205 = _io_cpu_0_stop_fetch_T_1 | _io_cpu_0_stop_fetch_T ? 8'h4b : _GEN_20; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 357:103 362:20]
  wire [6:0] _GEN_206 = oparg_2[5] ? 7'h40 : 7'h3f; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 390:27 391:26 394:26]
  wire [6:0] _GEN_207 = oparg_2[5] ? 7'h46 : 7'h45; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 402:27 403:26 406:26]
  wire [7:0] _GEN_221 = 5'hf == opcode ? 8'h81 : _GEN_20; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 490:18]
  wire [7:0] _GEN_226 = 5'he == opcode ? 8'hd6 : _GEN_221; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 482:18]
  wire [7:0] _GEN_232 = 5'h14 == opcode ? 8'h6e : _GEN_226; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 472:18]
  wire [7:0] _GEN_246 = 5'hd == opcode ? 8'h6e : _GEN_232; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 465:18]
  wire [7:0] _GEN_260 = 5'hc == opcode ? 8'had : _GEN_246; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 457:18]
  wire [7:0] _GEN_274 = 5'h1e == opcode ? 8'h30 : _GEN_260; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 450:18]
  wire [7:0] _GEN_292 = 5'h13 == opcode ? _GEN_20 : _GEN_274; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_311 = 5'h12 == opcode ? _GEN_20 : _GEN_292; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_338 = 5'h11 == opcode ? _GEN_20 : _GEN_311; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_365 = 5'h10 == opcode ? _GEN_20 : _GEN_338; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_379 = 5'hb == opcode ? 8'h65 : _GEN_365; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 422:18]
  wire [7:0] _GEN_406 = 5'ha == opcode ? 8'h5c : _GEN_379; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 415:18]
  wire [7:0] _GEN_433 = 5'h9 == opcode ? {{1'd0}, _GEN_207} : _GEN_406; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_460 = 5'h8 == opcode ? {{1'd0}, _GEN_206} : _GEN_433; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_487 = 5'h7 == opcode ? 8'h3d : _GEN_460; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 384:18]
  wire [7:0] _GEN_513 = 5'h6 == opcode ? 8'h34 : _GEN_487; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 376:18]
  wire [7:0] _GEN_541 = 5'h5 == opcode ? 8'h32 : _GEN_513; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 370:18]
  wire [7:0] _GEN_568 = 5'h4 == opcode ? _GEN_205 : _GEN_541; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_594 = 5'h3 == opcode ? 8'h2b : _GEN_568; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 353:18]
  wire [7:0] _GEN_622 = 5'h2 == opcode ? _GEN_20 : _GEN_594; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_651 = 5'h1 == opcode ? _GEN_20 : _GEN_622; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_680 = 5'h0 == opcode ? _GEN_20 : _GEN_651; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_711 = state == 5'h3 ? _GEN_680 : _GEN_20; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire [7:0] _GEN_872 = state == 5'h4 ? 8'h17 : _GEN_711; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 618:50 623:14]
  wire [7:0] _GEN_901 = state == 5'h5 ? _GEN_897 : _GEN_872; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:42]
  wire [7:0] _GEN_915 = state == 5'h0 ? 8'h0 : _GEN_901; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 679:48 681:14]
  wire [31:0] ctrl_misc = ctrl_rom_ctrl_content_data[31:0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 164:31]
  wire  ctrl_itr = ctrl_rom_ctrl_content_data[38]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 166:30]
  wire  ctrl_inst64_nowait = ctrl_rom_ctrl_content_data[34]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 170:40]
  wire  ctrl_last = ctrl_rom_ctrl_content_data[32]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 172:31]
  wire [4:0] ctrl_idx = ctrl_rom_ctrl_content_data[31:27]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 173:30]
  wire [3:0] ctrl_header = ctrl_rom_ctrl_content_data[26:23]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 174:33]
  wire [3:0] ctrl_loc_idx = ctrl_rom_ctrl_content_data[22:19]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 175:34]
  reg [8:0] inited_num; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 184:27]
  reg [1:0] hfutex_pos_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 187:27]
  wire [47:0] hfutex_set_value = {oparg_7,oparg_6,oparg_5,oparg_4,oparg_3,oparg_2}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 189:29]
  wire  hfutex_hit_set = hfutex_masks_0_0 == hfutex_set_value | hfutex_masks_0_1 == hfutex_set_value | hfutex_masks_0_2
     == hfutex_set_value | hfutex_masks_0_3 == hfutex_set_value; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 191:81]
  reg [63:0] regback_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  reg [63:0] regback_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
  wire [63:0] pg_base_addr2 = {12'h0,oparg_6,oparg_5,oparg_4,oparg_3,oparg_2,12'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 194:26]
  wire [63:0] pg_base_addr7 = {12'h0,oparg_11,oparg_10,oparg_9,oparg_8,oparg_7,12'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 196:26]
  wire [11:0] _pg_addr2_plus_T = {opoff, 9'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 200:48]
  wire [63:0] _GEN_1078 = {{52'd0}, _pg_addr2_plus_T}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 200:39]
  wire [63:0] pg_addr2_plus = pg_base_addr2 | _GEN_1078; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 200:39]
  reg [8:0] byte_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 206:25]
  wire  _writingPage_T_1 = state_register == 5'hd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 809:20]
  wire  writingPage = _T_127 & _writingPage_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 808:55]
  wire  _T_179 = opcode == 5'he; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 812:54]
  wire  _T_97 = state == 5'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:14]
  wire  _T_106 = opcode == 5'hc; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 505:25]
  wire  _GEN_742 = opcode == 5'h8 | opcode == 5'ha | opcode == 5'h10 | opcode == 5'h11 ? 1'h0 : _T_106; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 502:158 212:35]
  wire  _GEN_746 = opcode == 5'h0 ? 1'h0 : _GEN_742; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 212:35 499:45]
  wire  _GEN_750 = io_tx_ready & _GEN_746; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 498:23 212:35]
  wire  _GEN_757 = state == 5'h6 & _GEN_750; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 212:35 494:49]
  wire  _GEN_798 = state == 5'ha | _GEN_757; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49 531:20]
  wire  _GEN_1069 = _T_68 & opcode == 5'he | _GEN_798; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 812:80 813:20]
  wire  _consumePageWord_T_1 = ctrl_header == 4'ha; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 811:17]
  wire  _consumePageWord_T_2 = writingPage & ctrl_regacc_wt & _consumePageWord_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 810:55]
  wire  consumePageWord = _consumePageWord_T_2 & _will_next_T; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 811:31]
  wire [6:0] _GEN_1079 = {{6'd0}, consumePageWord}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 817:40]
  wire [6:0] _pageReadAddress_T_5 = page_ptr_in_rw + _GEN_1079; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 817:40]
  wire  _pageReadAddress_T = io_tx_ready & io_tx_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [8:0] _GEN_1080 = {{8'd0}, _pageReadAddress_T}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 534:34]
  wire [8:0] _pageReadAddress_T_2 = byte_cnt + _GEN_1080; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 534:34]
  wire [5:0] _GEN_799 = state == 5'ha ? _pageReadAddress_T_2[8:3] : 6'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49 534:21 213:36]
  wire [7:0] pending_next_idx = {{7'd0}, event_queue_io_deq_bits}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 219:55]
  wire [7:0] _GEN_12 = _T_141 & _io_cpu_0_stop_fetch_T_1 ? 8'hff : retarg_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 227:69 228:15 153:23]
  wire [4:0] _GEN_13 = _T_141 & _io_cpu_0_stop_fetch_T_1 ? 5'h6 : state; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 227:69 229:11 139:22]
  wire [7:0] _GEN_15 = _T_141 & event_queue_io_deq_valid ? pending_next_idx : _GEN_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 221:15]
  wire [4:0] _GEN_16 = _T_141 & event_queue_io_deq_valid ? 5'h2 : state_register; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 222:20 145:31]
  wire [4:0] _GEN_17 = _T_141 & event_queue_io_deq_valid ? 5'h5 : _GEN_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 223:11]
  wire [5:0] _GEN_18 = _T_141 & event_queue_io_deq_valid ? 6'h0 : cnt_run; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 224:13 185:24]
  wire [7:0] _GEN_19 = _T_141 & event_queue_io_deq_valid ? 8'h8 : ctrl_base_addr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 218:77 225:20 163:31]
  wire  _GEN_21 = inited_num == 9'h1 | initialized; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 244:43 245:21 147:28]
  wire [4:0] _GEN_22 = inited_num == 9'h1 ? 5'h1 : _GEN_17; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 244:43 246:15]
  wire [4:0] _GEN_23 = inited_num < 9'h1 ? 5'h0 : _GEN_16; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 236:34 237:24]
  wire [4:0] _GEN_25 = inited_num < 9'h1 ? 5'h5 : _GEN_22; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 236:34 239:15]
  wire [5:0] _GEN_26 = inited_num < 9'h1 ? 6'h0 : _GEN_18; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 236:34 240:17]
  wire [1:0] _GEN_27 = inited_num < 9'h1 ? 2'h1 : _GEN_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 236:34 242:28]
  wire [4:0] _GEN_29 = io_cpu_0_inited ? _GEN_23 : _GEN_16; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 235:21]
  wire [4:0] _GEN_31 = io_cpu_0_inited ? _GEN_25 : _GEN_17; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 235:21]
  wire [5:0] _GEN_32 = io_cpu_0_inited ? _GEN_26 : _GEN_18; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 235:21]
  wire [1:0] _GEN_33 = io_cpu_0_inited ? _GEN_27 : _GEN_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 235:21]
  wire [4:0] _GEN_35 = _T_140 ? _GEN_29 : _GEN_16; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 234:48]
  wire [4:0] _GEN_37 = _T_140 ? _GEN_31 : _GEN_17; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 234:48]
  wire [5:0] _GEN_38 = _T_140 ? _GEN_32 : _GEN_18; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 234:48]
  wire [1:0] _GEN_39 = _T_140 ? _GEN_33 : _GEN_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 234:48]
  wire  _T_14 = state == 5'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 252:14]
  wire [4:0] rxop = io_rx_bits[4:0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 255:28]
  wire [2:0] rxoff = io_rx_bits[7:5]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 256:29]
  wire [3:0] _GEN_41 = rxop == 5'h0 | rxop == 5'h10 ? 4'h3 : 4'hb; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 280:81 281:15 284:15]
  wire [4:0] _GEN_42 = rxop == 5'h0 | rxop == 5'h10 ? 5'h1 : trans_bytes; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 280:81 282:21 140:28]
  wire [5:0] _GEN_43 = rxop == 5'h0 | rxop == 5'h10 ? errno : {{1'd0}, rxop}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 280:81 285:15]
  wire [4:0] _GEN_44 = rxop == 5'hb ? 5'h10 : _GEN_42; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 278:50 279:21]
  wire [3:0] _GEN_45 = rxop == 5'hb ? 4'h2 : _GEN_41; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 278:50]
  wire [5:0] _GEN_46 = rxop == 5'hb ? errno : _GEN_43; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 278:50]
  wire [4:0] _GEN_47 = rxop == 5'hd ? 5'hf : _GEN_44; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 276:49 277:21]
  wire [3:0] _GEN_48 = rxop == 5'hd ? 4'h2 : _GEN_45; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 276:49]
  wire [5:0] _GEN_49 = rxop == 5'hd ? errno : _GEN_46; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 276:49]
  wire [4:0] _GEN_50 = rxop == 5'h9 | rxop == 5'hf ? 5'hc : _GEN_47; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 274:83 275:21]
  wire [3:0] _GEN_51 = rxop == 5'h9 | rxop == 5'hf ? 4'h2 : _GEN_48; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 274:83]
  wire [5:0] _GEN_52 = rxop == 5'h9 | rxop == 5'hf ? errno : _GEN_49; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 274:83]
  wire [4:0] _GEN_53 = rxop == 5'h3 | rxop == 5'h6 ? 5'h9 : _GEN_50; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 272:82 273:21]
  wire [3:0] _GEN_54 = rxop == 5'h3 | rxop == 5'h6 ? 4'h2 : _GEN_51; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 272:82]
  wire [5:0] _GEN_55 = rxop == 5'h3 | rxop == 5'h6 ? errno : _GEN_52; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 272:82]
  wire [4:0] _GEN_56 = rxop == 5'h4 | rxop == 5'ha | rxop == 5'h12 ? 5'h8 : _GEN_53; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 270:118 271:21]
  wire [3:0] _GEN_57 = rxop == 5'h4 | rxop == 5'ha | rxop == 5'h12 ? 4'h2 : _GEN_54; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 270:118 260:13]
  wire [5:0] _GEN_58 = rxop == 5'h4 | rxop == 5'ha | rxop == 5'h12 ? errno : _GEN_55; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 270:118 146:22]
  wire [4:0] _GEN_59 = rxop == 5'hc | rxop == 5'he | rxop == 5'h14 ? 5'h7 : _GEN_56; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 268:117 269:21]
  wire [3:0] _GEN_60 = rxop == 5'hc | rxop == 5'he | rxop == 5'h14 ? 4'h2 : _GEN_57; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 268:117 260:13]
  wire [5:0] _GEN_61 = rxop == 5'hc | rxop == 5'he | rxop == 5'h14 ? errno : _GEN_58; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 268:117 146:22]
  wire [4:0] _GEN_62 = rxop == 5'h1e ? 5'h6 : _GEN_59; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 266:49 267:21]
  wire [3:0] _GEN_63 = rxop == 5'h1e ? 4'h2 : _GEN_60; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 266:49]
  wire [5:0] _GEN_64 = rxop == 5'h1e ? errno : _GEN_61; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 266:49]
  wire [4:0] _GEN_65 = rxop == 5'h8 ? 5'h4 : _GEN_62; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 264:50 265:21]
  wire [3:0] _GEN_66 = rxop == 5'h8 ? 4'h2 : _GEN_63; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 264:50]
  wire [5:0] _GEN_67 = rxop == 5'h8 ? errno : _GEN_64; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22 264:50]
  wire [4:0] _GEN_68 = rxop == 5'h1 | rxop == 5'h2 | rxop == 5'h5 | rxop == 5'h7 | rxop == 5'h11 | rxop == 5'h13 ? 5'h2
     : _GEN_65; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 262:209 263:21]
  wire [3:0] _GEN_69 = rxop == 5'h1 | rxop == 5'h2 | rxop == 5'h5 | rxop == 5'h7 | rxop == 5'h11 | rxop == 5'h13 ? 4'h2
     : _GEN_66; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 260:13 262:209]
  wire [3:0] _GEN_73 = io_rx_valid ? 4'h1 : trans_pos; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23 259:17 141:26]
  wire [4:0] _GEN_74 = io_rx_valid ? {{1'd0}, _GEN_69} : _GEN_37; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23]
  wire [4:0] _GEN_75 = io_rx_valid ? _GEN_68 : trans_bytes; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23 140:28]
  wire [3:0] _GEN_80 = state == 5'h1 ? _GEN_73 : trans_pos; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 141:26 252:49]
  wire [4:0] _GEN_81 = state == 5'h1 ? _GEN_74 : _GEN_37; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 252:49]
  wire [4:0] _GEN_82 = state == 5'h1 ? _GEN_75 : trans_bytes; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 140:28 252:49]
  wire [2:0] shiftAmount = byte_cnt[2:0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 296:41]
  wire [7:0] _T_51 = 8'h1 << shiftAmount; // @[src/main/scala/chisel3/util/OneHot.scala 65:12]
  wire  _T_61 = io_rx_ready & io_rx_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  _T_62 = byte_cnt == 9'h1ff; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 299:21]
  wire [8:0] _byte_cnt_T_1 = byte_cnt + 9'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 303:30]
  wire [8:0] _GEN_84 = byte_cnt == 9'h1ff ? 9'h0 : _byte_cnt_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 299:31 300:18 303:18]
  wire [4:0] _GEN_85 = byte_cnt == 9'h1ff ? 5'h3 : _GEN_81; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 299:31 301:15]
  wire [8:0] _GEN_87 = _T_61 ? _GEN_84 : byte_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 297:21 206:25]
  wire [4:0] _GEN_88 = _T_61 ? _GEN_85 : _GEN_81; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 297:21]
  wire  _GEN_89 = state == 5'h9 | _T_14; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 291:17]
  wire [7:0] page_word_content_0 = state == 5'h9 ? io_rx_bits : 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 210:30 290:48 293:32]
  wire [5:0] page_ptr = state == 5'h9 ? byte_cnt[8:3] : 6'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 295:14 203:29]
  wire  page_write_mask_0 = state == 5'h9 & _T_51[0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_1 = state == 5'h9 & _T_51[1]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_2 = state == 5'h9 & _T_51[2]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_3 = state == 5'h9 & _T_51[3]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_4 = state == 5'h9 & _T_51[4]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_5 = state == 5'h9 & _T_51[5]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_6 = state == 5'h9 & _T_51[6]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_write_mask_7 = state == 5'h9 & _T_51[7]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48 296:21 209:29]
  wire  page_mem_can_write = state == 5'h9 & _T_61; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 289:39 290:48]
  wire [8:0] _GEN_101 = state == 5'h9 ? _GEN_87 : byte_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 206:25 290:48]
  wire [4:0] _GEN_102 = state == 5'h9 ? _GEN_88 : _GEN_81; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 290:48]
  wire  _capturePageWord_T_1 = _T_127 & ctrl_regacc_rd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 799:56]
  wire  _capturePageWord_T_2 = ctrl_header == 4'h7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 800:17]
  wire  _capturePageWord_T_3 = _T_127 & ctrl_regacc_rd & _capturePageWord_T_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 799:74]
  wire  capturePageWord = _capturePageWord_T_3 & will_next; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 800:31]
  wire [7:0] _GEN_145 = 4'h7 == trans_pos ? io_rx_bits : oparg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_146 = 4'h8 == trans_pos ? io_rx_bits : oparg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_147 = 4'h9 == trans_pos ? io_rx_bits : oparg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_148 = 4'ha == trans_pos ? io_rx_bits : oparg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_149 = 4'hb == trans_pos ? io_rx_bits : oparg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_150 = 4'hc == trans_pos ? io_rx_bits : oparg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_151 = 4'hd == trans_pos ? io_rx_bits : oparg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [7:0] _GEN_152 = 4'he == trans_pos ? io_rx_bits : oparg_14; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 319:{24,24}]
  wire [4:0] _T_65 = trans_pos + 4'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:22]
  wire  _T_66 = _T_65 == trans_bytes; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:29]
  wire [3:0] _GEN_154 = _T_179 ? 4'h9 : 4'h3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 323:15 324:46 325:17]
  wire [8:0] _GEN_155 = _T_179 ? 9'h0 : _GEN_101; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 324:46 326:20]
  wire [3:0] _trans_pos_T_1 = trans_pos + 4'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 329:32]
  wire [3:0] _GEN_156 = _T_65 == trans_bytes ? 4'h0 : _trans_pos_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:46 321:19 329:19]
  wire [4:0] _GEN_157 = _T_65 == trans_bytes ? 5'h0 : _GEN_82; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:46 322:21]
  wire [4:0] _GEN_158 = _T_65 == trans_bytes ? {{1'd0}, _GEN_154} : _GEN_102; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:46]
  wire [8:0] _GEN_159 = _T_65 == trans_bytes ? _GEN_155 : _GEN_101; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:46]
  wire [7:0] _GEN_167 = io_rx_valid ? _GEN_145 : oparg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_168 = io_rx_valid ? _GEN_146 : oparg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_169 = io_rx_valid ? _GEN_147 : oparg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_170 = io_rx_valid ? _GEN_148 : oparg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_171 = io_rx_valid ? _GEN_149 : oparg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_172 = io_rx_valid ? _GEN_150 : oparg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_173 = io_rx_valid ? _GEN_151 : oparg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [7:0] _GEN_174 = io_rx_valid ? _GEN_152 : oparg_14; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 318:23]
  wire [3:0] _GEN_176 = io_rx_valid ? _GEN_156 : _GEN_80; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
  wire [4:0] _GEN_177 = io_rx_valid ? _GEN_157 : _GEN_82; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
  wire [4:0] _GEN_178 = io_rx_valid ? _GEN_158 : _GEN_102; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
  wire [8:0] _GEN_179 = io_rx_valid ? _GEN_159 : _GEN_101; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
  wire [7:0] _GEN_188 = state == 5'h2 ? _GEN_167 : oparg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_189 = state == 5'h2 ? _GEN_168 : oparg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_190 = state == 5'h2 ? _GEN_169 : oparg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_191 = state == 5'h2 ? _GEN_170 : oparg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_192 = state == 5'h2 ? _GEN_171 : oparg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_193 = state == 5'h2 ? _GEN_172 : oparg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_194 = state == 5'h2 ? _GEN_173 : oparg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [7:0] _GEN_195 = state == 5'h2 ? _GEN_174 : oparg_14; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22 316:48]
  wire [3:0] _GEN_197 = state == 5'h2 ? _GEN_176 : _GEN_80; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
  wire [4:0] _GEN_198 = state == 5'h2 ? _GEN_177 : _GEN_82; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
  wire [4:0] _GEN_199 = state == 5'h2 ? _GEN_178 : _GEN_102; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
  wire [8:0] _GEN_200 = state == 5'h2 ? _GEN_179 : _GEN_101; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
  wire [2:0] _GEN_201 = _io_cpu_0_stop_fetch_T_1 | _io_cpu_0_stop_fetch_T ? 3'h5 : 3'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 357:103 337:11 358:17]
  wire [5:0] _GEN_202 = _io_cpu_0_stop_fetch_T_1 | _io_cpu_0_stop_fetch_T ? 6'h0 : _GEN_38; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 357:103 359:19]
  wire [4:0] _GEN_203 = _io_cpu_0_stop_fetch_T_1 | _io_cpu_0_stop_fetch_T ? 5'h4 : _GEN_35; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 357:103 360:26]
  wire [7:0] _GEN_204 = _io_cpu_0_stop_fetch_T_1 | _io_cpu_0_stop_fetch_T ? 8'h4b : _GEN_19; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 357:103 361:26]
  wire [47:0] _GEN_208 = 2'h0 == hfutex_pos_0 ? hfutex_set_value : hfutex_masks_0_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 436:{50,50}]
  wire [47:0] _GEN_209 = 2'h1 == hfutex_pos_0 ? hfutex_set_value : hfutex_masks_0_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 436:{50,50}]
  wire [47:0] _GEN_210 = 2'h2 == hfutex_pos_0 ? hfutex_set_value : hfutex_masks_0_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 436:{50,50}]
  wire [47:0] _GEN_211 = 2'h3 == hfutex_pos_0 ? hfutex_set_value : hfutex_masks_0_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 436:{50,50}]
  wire [1:0] _hfutex_pos_0_T_2 = hfutex_pos_0 + 2'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 437:86]
  wire [1:0] _hfutex_pos_0_T_3 = hfutex_pos_0 == 2'h3 ? 2'h0 : _hfutex_pos_0_T_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 437:35]
  wire [47:0] _GEN_212 = ~hfutex_hit_set ? _GEN_208 : hfutex_masks_0_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 435:31]
  wire [47:0] _GEN_213 = ~hfutex_hit_set ? _GEN_209 : hfutex_masks_0_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 435:31]
  wire [47:0] _GEN_214 = ~hfutex_hit_set ? _GEN_210 : hfutex_masks_0_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 435:31]
  wire [47:0] _GEN_215 = ~hfutex_hit_set ? _GEN_211 : hfutex_masks_0_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29 435:31]
  wire [1:0] _GEN_216 = ~hfutex_hit_set ? _hfutex_pos_0_T_3 : hfutex_pos_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 187:27 435:31 437:29]
  wire [2:0] _GEN_217 = 5'hf == opcode ? 3'h5 : 3'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20 486:15]
  wire [4:0] _GEN_218 = 5'hf == opcode ? 5'he : _GEN_35; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 487:24]
  wire [5:0] _GEN_219 = 5'hf == opcode ? 6'h0 : _GEN_38; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 488:17]
  wire [7:0] _GEN_220 = 5'hf == opcode ? 8'h81 : _GEN_19; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 489:24]
  wire [2:0] _GEN_222 = 5'he == opcode ? 3'h5 : _GEN_217; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 478:15]
  wire [4:0] _GEN_223 = 5'he == opcode ? 5'hd : _GEN_218; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 479:24]
  wire [5:0] _GEN_224 = 5'he == opcode ? 6'h0 : _GEN_219; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 480:17]
  wire [7:0] _GEN_225 = 5'he == opcode ? 8'hd6 : _GEN_220; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 481:24]
  wire [6:0] _GEN_227 = 5'he == opcode ? 7'h0 : page_ptr_in_rw; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 483:24 204:31]
  wire [2:0] _GEN_228 = 5'h14 == opcode ? 3'h5 : _GEN_222; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 468:15]
  wire [4:0] _GEN_229 = 5'h14 == opcode ? 5'hc : _GEN_223; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 469:24]
  wire [5:0] _GEN_230 = 5'h14 == opcode ? 6'h0 : _GEN_224; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 470:17]
  wire [7:0] _GEN_231 = 5'h14 == opcode ? 8'h6e : _GEN_225; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 471:24]
  wire [7:0] _GEN_233 = 5'h14 == opcode ? 8'h0 : _GEN_188; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_234 = 5'h14 == opcode ? 8'h0 : _GEN_189; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_235 = 5'h14 == opcode ? 8'h0 : _GEN_190; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_236 = 5'h14 == opcode ? 8'h0 : _GEN_191; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_237 = 5'h14 == opcode ? 8'h0 : _GEN_192; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_238 = 5'h14 == opcode ? 8'h0 : _GEN_193; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_239 = 5'h14 == opcode ? 8'h0 : _GEN_194; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [7:0] _GEN_240 = 5'h14 == opcode ? 8'h0 : _GEN_195; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 474:28]
  wire [6:0] _GEN_241 = 5'h14 == opcode ? page_ptr_in_rw : _GEN_227; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [2:0] _GEN_242 = 5'hd == opcode ? 3'h5 : _GEN_228; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 461:15]
  wire [4:0] _GEN_243 = 5'hd == opcode ? 5'hc : _GEN_229; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 462:24]
  wire [5:0] _GEN_244 = 5'hd == opcode ? 6'h0 : _GEN_230; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 463:17]
  wire [7:0] _GEN_245 = 5'hd == opcode ? 8'h6e : _GEN_231; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 464:24]
  wire [7:0] _GEN_247 = 5'hd == opcode ? _GEN_188 : _GEN_233; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_248 = 5'hd == opcode ? _GEN_189 : _GEN_234; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_249 = 5'hd == opcode ? _GEN_190 : _GEN_235; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_250 = 5'hd == opcode ? _GEN_191 : _GEN_236; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_251 = 5'hd == opcode ? _GEN_192 : _GEN_237; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_252 = 5'hd == opcode ? _GEN_193 : _GEN_238; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_253 = 5'hd == opcode ? _GEN_194 : _GEN_239; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_254 = 5'hd == opcode ? _GEN_195 : _GEN_240; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [6:0] _GEN_255 = 5'hd == opcode ? page_ptr_in_rw : _GEN_241; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [2:0] _GEN_256 = 5'hc == opcode ? 3'h5 : _GEN_242; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 453:15]
  wire [4:0] _GEN_257 = 5'hc == opcode ? 5'hb : _GEN_243; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 454:24]
  wire [5:0] _GEN_258 = 5'hc == opcode ? 6'h0 : _GEN_244; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 455:17]
  wire [7:0] _GEN_259 = 5'hc == opcode ? 8'had : _GEN_245; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 456:24]
  wire [6:0] _GEN_261 = 5'hc == opcode ? 7'h0 : _GEN_255; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 458:24]
  wire [7:0] _GEN_262 = 5'hc == opcode ? _GEN_188 : _GEN_247; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_263 = 5'hc == opcode ? _GEN_189 : _GEN_248; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_264 = 5'hc == opcode ? _GEN_190 : _GEN_249; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_265 = 5'hc == opcode ? _GEN_191 : _GEN_250; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_266 = 5'hc == opcode ? _GEN_192 : _GEN_251; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_267 = 5'hc == opcode ? _GEN_193 : _GEN_252; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_268 = 5'hc == opcode ? _GEN_194 : _GEN_253; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_269 = 5'hc == opcode ? _GEN_195 : _GEN_254; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_270 = 5'h1e == opcode ? 3'h5 : _GEN_256; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 446:15]
  wire [4:0] _GEN_271 = 5'h1e == opcode ? 5'h10 : _GEN_257; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 447:24]
  wire [5:0] _GEN_272 = 5'h1e == opcode ? 6'h0 : _GEN_258; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 448:17]
  wire [7:0] _GEN_273 = 5'h1e == opcode ? 8'h30 : _GEN_259; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 449:24]
  wire [6:0] _GEN_275 = 5'h1e == opcode ? page_ptr_in_rw : _GEN_261; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_276 = 5'h1e == opcode ? _GEN_188 : _GEN_262; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_277 = 5'h1e == opcode ? _GEN_189 : _GEN_263; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_278 = 5'h1e == opcode ? _GEN_190 : _GEN_264; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_279 = 5'h1e == opcode ? _GEN_191 : _GEN_265; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_280 = 5'h1e == opcode ? _GEN_192 : _GEN_266; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_281 = 5'h1e == opcode ? _GEN_193 : _GEN_267; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_282 = 5'h1e == opcode ? _GEN_194 : _GEN_268; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_283 = 5'h1e == opcode ? _GEN_195 : _GEN_269; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [47:0] _GEN_284 = 5'h13 == opcode ? 48'h0 : hfutex_masks_0_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29 442:34]
  wire [47:0] _GEN_285 = 5'h13 == opcode ? 48'h0 : hfutex_masks_0_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29 442:34]
  wire [47:0] _GEN_286 = 5'h13 == opcode ? 48'h0 : hfutex_masks_0_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29 442:34]
  wire [47:0] _GEN_287 = 5'h13 == opcode ? 48'h0 : hfutex_masks_0_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29 442:34]
  wire [2:0] _GEN_288 = 5'h13 == opcode ? 3'h6 : _GEN_270; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_289 = 5'h13 == opcode ? _GEN_35 : _GEN_271; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_290 = 5'h13 == opcode ? _GEN_38 : _GEN_272; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_291 = 5'h13 == opcode ? _GEN_19 : _GEN_273; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [6:0] _GEN_293 = 5'h13 == opcode ? page_ptr_in_rw : _GEN_275; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_294 = 5'h13 == opcode ? _GEN_188 : _GEN_276; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_295 = 5'h13 == opcode ? _GEN_189 : _GEN_277; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_296 = 5'h13 == opcode ? _GEN_190 : _GEN_278; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_297 = 5'h13 == opcode ? _GEN_191 : _GEN_279; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_298 = 5'h13 == opcode ? _GEN_192 : _GEN_280; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_299 = 5'h13 == opcode ? _GEN_193 : _GEN_281; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_300 = 5'h13 == opcode ? _GEN_194 : _GEN_282; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_301 = 5'h13 == opcode ? _GEN_195 : _GEN_283; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [47:0] _GEN_302 = 5'h12 == opcode ? _GEN_212 : _GEN_284; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [47:0] _GEN_303 = 5'h12 == opcode ? _GEN_213 : _GEN_285; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [47:0] _GEN_304 = 5'h12 == opcode ? _GEN_214 : _GEN_286; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [47:0] _GEN_305 = 5'h12 == opcode ? _GEN_215 : _GEN_287; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [1:0] _GEN_306 = 5'h12 == opcode ? _GEN_216 : hfutex_pos_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [2:0] _GEN_307 = 5'h12 == opcode ? 3'h6 : _GEN_288; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_308 = 5'h12 == opcode ? _GEN_35 : _GEN_289; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_309 = 5'h12 == opcode ? _GEN_38 : _GEN_290; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_310 = 5'h12 == opcode ? _GEN_19 : _GEN_291; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [6:0] _GEN_312 = 5'h12 == opcode ? page_ptr_in_rw : _GEN_293; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_313 = 5'h12 == opcode ? _GEN_188 : _GEN_294; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_314 = 5'h12 == opcode ? _GEN_189 : _GEN_295; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_315 = 5'h12 == opcode ? _GEN_190 : _GEN_296; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_316 = 5'h12 == opcode ? _GEN_191 : _GEN_297; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_317 = 5'h12 == opcode ? _GEN_192 : _GEN_298; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_318 = 5'h12 == opcode ? _GEN_193 : _GEN_299; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_319 = 5'h12 == opcode ? _GEN_194 : _GEN_300; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_320 = 5'h12 == opcode ? _GEN_195 : _GEN_301; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_321 = 5'h11 == opcode ? user_clk_0[7:0] : _GEN_15; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21]
  wire [7:0] _GEN_322 = 5'h11 == opcode ? user_clk_0[15:8] : retarg_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_323 = 5'h11 == opcode ? user_clk_0[23:16] : retarg_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_324 = 5'h11 == opcode ? user_clk_0[31:24] : retarg_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_325 = 5'h11 == opcode ? user_clk_0[39:32] : retarg_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_326 = 5'h11 == opcode ? user_clk_0[47:40] : retarg_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_327 = 5'h11 == opcode ? user_clk_0[55:48] : retarg_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [7:0] _GEN_328 = 5'h11 == opcode ? user_clk_0[63:56] : retarg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 431:21 153:23]
  wire [47:0] _GEN_329 = 5'h11 == opcode ? hfutex_masks_0_0 : _GEN_302; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_330 = 5'h11 == opcode ? hfutex_masks_0_1 : _GEN_303; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_331 = 5'h11 == opcode ? hfutex_masks_0_2 : _GEN_304; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_332 = 5'h11 == opcode ? hfutex_masks_0_3 : _GEN_305; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_333 = 5'h11 == opcode ? hfutex_pos_0 : _GEN_306; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [2:0] _GEN_334 = 5'h11 == opcode ? 3'h6 : _GEN_307; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_335 = 5'h11 == opcode ? _GEN_35 : _GEN_308; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_336 = 5'h11 == opcode ? _GEN_38 : _GEN_309; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_337 = 5'h11 == opcode ? _GEN_19 : _GEN_310; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [6:0] _GEN_339 = 5'h11 == opcode ? page_ptr_in_rw : _GEN_312; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_340 = 5'h11 == opcode ? _GEN_188 : _GEN_313; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_341 = 5'h11 == opcode ? _GEN_189 : _GEN_314; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_342 = 5'h11 == opcode ? _GEN_190 : _GEN_315; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_343 = 5'h11 == opcode ? _GEN_191 : _GEN_316; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_344 = 5'h11 == opcode ? _GEN_192 : _GEN_317; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_345 = 5'h11 == opcode ? _GEN_193 : _GEN_318; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_346 = 5'h11 == opcode ? _GEN_194 : _GEN_319; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_347 = 5'h11 == opcode ? _GEN_195 : _GEN_320; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_348 = 5'h10 == opcode ? global_clk[7:0] : _GEN_321; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_349 = 5'h10 == opcode ? global_clk[15:8] : _GEN_322; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_350 = 5'h10 == opcode ? global_clk[23:16] : _GEN_323; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_351 = 5'h10 == opcode ? global_clk[31:24] : _GEN_324; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_352 = 5'h10 == opcode ? global_clk[39:32] : _GEN_325; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_353 = 5'h10 == opcode ? global_clk[47:40] : _GEN_326; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_354 = 5'h10 == opcode ? global_clk[55:48] : _GEN_327; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [7:0] _GEN_355 = 5'h10 == opcode ? global_clk[63:56] : _GEN_328; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 426:21]
  wire [47:0] _GEN_356 = 5'h10 == opcode ? hfutex_masks_0_0 : _GEN_329; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_357 = 5'h10 == opcode ? hfutex_masks_0_1 : _GEN_330; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_358 = 5'h10 == opcode ? hfutex_masks_0_2 : _GEN_331; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_359 = 5'h10 == opcode ? hfutex_masks_0_3 : _GEN_332; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_360 = 5'h10 == opcode ? hfutex_pos_0 : _GEN_333; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [2:0] _GEN_361 = 5'h10 == opcode ? 3'h6 : _GEN_334; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_362 = 5'h10 == opcode ? _GEN_35 : _GEN_335; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_363 = 5'h10 == opcode ? _GEN_38 : _GEN_336; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_364 = 5'h10 == opcode ? _GEN_19 : _GEN_337; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [6:0] _GEN_366 = 5'h10 == opcode ? page_ptr_in_rw : _GEN_339; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_367 = 5'h10 == opcode ? _GEN_188 : _GEN_340; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_368 = 5'h10 == opcode ? _GEN_189 : _GEN_341; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_369 = 5'h10 == opcode ? _GEN_190 : _GEN_342; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_370 = 5'h10 == opcode ? _GEN_191 : _GEN_343; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_371 = 5'h10 == opcode ? _GEN_192 : _GEN_344; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_372 = 5'h10 == opcode ? _GEN_193 : _GEN_345; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_373 = 5'h10 == opcode ? _GEN_194 : _GEN_346; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_374 = 5'h10 == opcode ? _GEN_195 : _GEN_347; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_375 = 5'hb == opcode ? 3'h5 : _GEN_361; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 418:15]
  wire [4:0] _GEN_376 = 5'hb == opcode ? 5'ha : _GEN_362; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 419:24]
  wire [5:0] _GEN_377 = 5'hb == opcode ? 6'h0 : _GEN_363; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 420:17]
  wire [7:0] _GEN_378 = 5'hb == opcode ? 8'h65 : _GEN_364; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 421:24]
  wire [7:0] _GEN_380 = 5'hb == opcode ? _GEN_15 : _GEN_348; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_381 = 5'hb == opcode ? retarg_1 : _GEN_349; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_382 = 5'hb == opcode ? retarg_2 : _GEN_350; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_383 = 5'hb == opcode ? retarg_3 : _GEN_351; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_384 = 5'hb == opcode ? retarg_4 : _GEN_352; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_385 = 5'hb == opcode ? retarg_5 : _GEN_353; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_386 = 5'hb == opcode ? retarg_6 : _GEN_354; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_387 = 5'hb == opcode ? retarg_7 : _GEN_355; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_388 = 5'hb == opcode ? hfutex_masks_0_0 : _GEN_356; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_389 = 5'hb == opcode ? hfutex_masks_0_1 : _GEN_357; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_390 = 5'hb == opcode ? hfutex_masks_0_2 : _GEN_358; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_391 = 5'hb == opcode ? hfutex_masks_0_3 : _GEN_359; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_392 = 5'hb == opcode ? hfutex_pos_0 : _GEN_360; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_393 = 5'hb == opcode ? page_ptr_in_rw : _GEN_366; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_394 = 5'hb == opcode ? _GEN_188 : _GEN_367; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_395 = 5'hb == opcode ? _GEN_189 : _GEN_368; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_396 = 5'hb == opcode ? _GEN_190 : _GEN_369; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_397 = 5'hb == opcode ? _GEN_191 : _GEN_370; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_398 = 5'hb == opcode ? _GEN_192 : _GEN_371; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_399 = 5'hb == opcode ? _GEN_193 : _GEN_372; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_400 = 5'hb == opcode ? _GEN_194 : _GEN_373; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_401 = 5'hb == opcode ? _GEN_195 : _GEN_374; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_402 = 5'ha == opcode ? 3'h5 : _GEN_375; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 411:15]
  wire [4:0] _GEN_403 = 5'ha == opcode ? 5'h9 : _GEN_376; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 412:24]
  wire [5:0] _GEN_404 = 5'ha == opcode ? 6'h0 : _GEN_377; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 413:17]
  wire [7:0] _GEN_405 = 5'ha == opcode ? 8'h5c : _GEN_378; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 414:24]
  wire [7:0] _GEN_407 = 5'ha == opcode ? _GEN_15 : _GEN_380; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_408 = 5'ha == opcode ? retarg_1 : _GEN_381; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_409 = 5'ha == opcode ? retarg_2 : _GEN_382; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_410 = 5'ha == opcode ? retarg_3 : _GEN_383; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_411 = 5'ha == opcode ? retarg_4 : _GEN_384; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_412 = 5'ha == opcode ? retarg_5 : _GEN_385; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_413 = 5'ha == opcode ? retarg_6 : _GEN_386; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_414 = 5'ha == opcode ? retarg_7 : _GEN_387; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_415 = 5'ha == opcode ? hfutex_masks_0_0 : _GEN_388; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_416 = 5'ha == opcode ? hfutex_masks_0_1 : _GEN_389; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_417 = 5'ha == opcode ? hfutex_masks_0_2 : _GEN_390; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_418 = 5'ha == opcode ? hfutex_masks_0_3 : _GEN_391; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_419 = 5'ha == opcode ? hfutex_pos_0 : _GEN_392; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_420 = 5'ha == opcode ? page_ptr_in_rw : _GEN_393; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_421 = 5'ha == opcode ? _GEN_188 : _GEN_394; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_422 = 5'ha == opcode ? _GEN_189 : _GEN_395; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_423 = 5'ha == opcode ? _GEN_190 : _GEN_396; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_424 = 5'ha == opcode ? _GEN_191 : _GEN_397; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_425 = 5'ha == opcode ? _GEN_192 : _GEN_398; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_426 = 5'ha == opcode ? _GEN_193 : _GEN_399; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_427 = 5'ha == opcode ? _GEN_194 : _GEN_400; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_428 = 5'ha == opcode ? _GEN_195 : _GEN_401; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_429 = 5'h9 == opcode ? 3'h5 : _GEN_402; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 399:15]
  wire [4:0] _GEN_430 = 5'h9 == opcode ? 5'h8 : _GEN_403; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 400:24]
  wire [5:0] _GEN_431 = 5'h9 == opcode ? 6'h0 : _GEN_404; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 401:17]
  wire [7:0] _GEN_432 = 5'h9 == opcode ? {{1'd0}, _GEN_207} : _GEN_405; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_434 = 5'h9 == opcode ? _GEN_15 : _GEN_407; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_435 = 5'h9 == opcode ? retarg_1 : _GEN_408; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_436 = 5'h9 == opcode ? retarg_2 : _GEN_409; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_437 = 5'h9 == opcode ? retarg_3 : _GEN_410; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_438 = 5'h9 == opcode ? retarg_4 : _GEN_411; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_439 = 5'h9 == opcode ? retarg_5 : _GEN_412; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_440 = 5'h9 == opcode ? retarg_6 : _GEN_413; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_441 = 5'h9 == opcode ? retarg_7 : _GEN_414; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_442 = 5'h9 == opcode ? hfutex_masks_0_0 : _GEN_415; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_443 = 5'h9 == opcode ? hfutex_masks_0_1 : _GEN_416; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_444 = 5'h9 == opcode ? hfutex_masks_0_2 : _GEN_417; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_445 = 5'h9 == opcode ? hfutex_masks_0_3 : _GEN_418; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_446 = 5'h9 == opcode ? hfutex_pos_0 : _GEN_419; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_447 = 5'h9 == opcode ? page_ptr_in_rw : _GEN_420; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_448 = 5'h9 == opcode ? _GEN_188 : _GEN_421; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_449 = 5'h9 == opcode ? _GEN_189 : _GEN_422; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_450 = 5'h9 == opcode ? _GEN_190 : _GEN_423; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_451 = 5'h9 == opcode ? _GEN_191 : _GEN_424; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_452 = 5'h9 == opcode ? _GEN_192 : _GEN_425; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_453 = 5'h9 == opcode ? _GEN_193 : _GEN_426; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_454 = 5'h9 == opcode ? _GEN_194 : _GEN_427; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_455 = 5'h9 == opcode ? _GEN_195 : _GEN_428; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_456 = 5'h8 == opcode ? 3'h5 : _GEN_429; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 387:15]
  wire [4:0] _GEN_457 = 5'h8 == opcode ? 5'h7 : _GEN_430; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 388:24]
  wire [5:0] _GEN_458 = 5'h8 == opcode ? 6'h0 : _GEN_431; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 389:17]
  wire [7:0] _GEN_459 = 5'h8 == opcode ? {{1'd0}, _GEN_206} : _GEN_432; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_461 = 5'h8 == opcode ? _GEN_15 : _GEN_434; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_462 = 5'h8 == opcode ? retarg_1 : _GEN_435; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_463 = 5'h8 == opcode ? retarg_2 : _GEN_436; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_464 = 5'h8 == opcode ? retarg_3 : _GEN_437; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_465 = 5'h8 == opcode ? retarg_4 : _GEN_438; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_466 = 5'h8 == opcode ? retarg_5 : _GEN_439; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_467 = 5'h8 == opcode ? retarg_6 : _GEN_440; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_468 = 5'h8 == opcode ? retarg_7 : _GEN_441; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_469 = 5'h8 == opcode ? hfutex_masks_0_0 : _GEN_442; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_470 = 5'h8 == opcode ? hfutex_masks_0_1 : _GEN_443; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_471 = 5'h8 == opcode ? hfutex_masks_0_2 : _GEN_444; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_472 = 5'h8 == opcode ? hfutex_masks_0_3 : _GEN_445; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_473 = 5'h8 == opcode ? hfutex_pos_0 : _GEN_446; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_474 = 5'h8 == opcode ? page_ptr_in_rw : _GEN_447; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_475 = 5'h8 == opcode ? _GEN_188 : _GEN_448; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_476 = 5'h8 == opcode ? _GEN_189 : _GEN_449; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_477 = 5'h8 == opcode ? _GEN_190 : _GEN_450; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_478 = 5'h8 == opcode ? _GEN_191 : _GEN_451; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_479 = 5'h8 == opcode ? _GEN_192 : _GEN_452; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_480 = 5'h8 == opcode ? _GEN_193 : _GEN_453; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_481 = 5'h8 == opcode ? _GEN_194 : _GEN_454; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_482 = 5'h8 == opcode ? _GEN_195 : _GEN_455; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_483 = 5'h7 == opcode ? 3'h5 : _GEN_456; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 380:15]
  wire [4:0] _GEN_484 = 5'h7 == opcode ? 5'hf : _GEN_457; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 381:24]
  wire [5:0] _GEN_485 = 5'h7 == opcode ? 6'h0 : _GEN_458; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 382:17]
  wire [7:0] _GEN_486 = 5'h7 == opcode ? 8'h3d : _GEN_459; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 383:24]
  wire [7:0] _GEN_488 = 5'h7 == opcode ? _GEN_15 : _GEN_461; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_489 = 5'h7 == opcode ? retarg_1 : _GEN_462; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_490 = 5'h7 == opcode ? retarg_2 : _GEN_463; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_491 = 5'h7 == opcode ? retarg_3 : _GEN_464; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_492 = 5'h7 == opcode ? retarg_4 : _GEN_465; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_493 = 5'h7 == opcode ? retarg_5 : _GEN_466; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_494 = 5'h7 == opcode ? retarg_6 : _GEN_467; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_495 = 5'h7 == opcode ? retarg_7 : _GEN_468; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_496 = 5'h7 == opcode ? hfutex_masks_0_0 : _GEN_469; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_497 = 5'h7 == opcode ? hfutex_masks_0_1 : _GEN_470; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_498 = 5'h7 == opcode ? hfutex_masks_0_2 : _GEN_471; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_499 = 5'h7 == opcode ? hfutex_masks_0_3 : _GEN_472; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_500 = 5'h7 == opcode ? hfutex_pos_0 : _GEN_473; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_501 = 5'h7 == opcode ? page_ptr_in_rw : _GEN_474; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_502 = 5'h7 == opcode ? _GEN_188 : _GEN_475; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_503 = 5'h7 == opcode ? _GEN_189 : _GEN_476; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_504 = 5'h7 == opcode ? _GEN_190 : _GEN_477; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_505 = 5'h7 == opcode ? _GEN_191 : _GEN_478; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_506 = 5'h7 == opcode ? _GEN_192 : _GEN_479; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_507 = 5'h7 == opcode ? _GEN_193 : _GEN_480; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_508 = 5'h7 == opcode ? _GEN_194 : _GEN_481; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_509 = 5'h7 == opcode ? _GEN_195 : _GEN_482; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_510 = 5'h6 == opcode ? 3'h5 : _GEN_483; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 373:15]
  wire [4:0] _GEN_511 = 5'h6 == opcode ? 5'h6 : _GEN_484; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 374:24]
  wire [7:0] _GEN_512 = 5'h6 == opcode ? 8'h34 : _GEN_486; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 375:24]
  wire [5:0] _GEN_514 = 5'h6 == opcode ? 6'h0 : _GEN_485; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 377:17]
  wire [7:0] _GEN_515 = 5'h6 == opcode ? _GEN_15 : _GEN_488; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_516 = 5'h6 == opcode ? retarg_1 : _GEN_489; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_517 = 5'h6 == opcode ? retarg_2 : _GEN_490; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_518 = 5'h6 == opcode ? retarg_3 : _GEN_491; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_519 = 5'h6 == opcode ? retarg_4 : _GEN_492; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_520 = 5'h6 == opcode ? retarg_5 : _GEN_493; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_521 = 5'h6 == opcode ? retarg_6 : _GEN_494; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_522 = 5'h6 == opcode ? retarg_7 : _GEN_495; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_523 = 5'h6 == opcode ? hfutex_masks_0_0 : _GEN_496; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_524 = 5'h6 == opcode ? hfutex_masks_0_1 : _GEN_497; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_525 = 5'h6 == opcode ? hfutex_masks_0_2 : _GEN_498; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_526 = 5'h6 == opcode ? hfutex_masks_0_3 : _GEN_499; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_527 = 5'h6 == opcode ? hfutex_pos_0 : _GEN_500; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_528 = 5'h6 == opcode ? page_ptr_in_rw : _GEN_501; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_529 = 5'h6 == opcode ? _GEN_188 : _GEN_502; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_530 = 5'h6 == opcode ? _GEN_189 : _GEN_503; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_531 = 5'h6 == opcode ? _GEN_190 : _GEN_504; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_532 = 5'h6 == opcode ? _GEN_191 : _GEN_505; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_533 = 5'h6 == opcode ? _GEN_192 : _GEN_506; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_534 = 5'h6 == opcode ? _GEN_193 : _GEN_507; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_535 = 5'h6 == opcode ? _GEN_194 : _GEN_508; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_536 = 5'h6 == opcode ? _GEN_195 : _GEN_509; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_537 = 5'h5 == opcode ? 3'h5 : _GEN_510; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 366:15]
  wire [4:0] _GEN_538 = 5'h5 == opcode ? 5'h5 : _GEN_511; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 367:24]
  wire [5:0] _GEN_539 = 5'h5 == opcode ? 6'h0 : _GEN_514; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 368:17]
  wire [7:0] _GEN_540 = 5'h5 == opcode ? 8'h32 : _GEN_512; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 369:24]
  wire [7:0] _GEN_542 = 5'h5 == opcode ? _GEN_15 : _GEN_515; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_543 = 5'h5 == opcode ? retarg_1 : _GEN_516; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_544 = 5'h5 == opcode ? retarg_2 : _GEN_517; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_545 = 5'h5 == opcode ? retarg_3 : _GEN_518; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_546 = 5'h5 == opcode ? retarg_4 : _GEN_519; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_547 = 5'h5 == opcode ? retarg_5 : _GEN_520; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_548 = 5'h5 == opcode ? retarg_6 : _GEN_521; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_549 = 5'h5 == opcode ? retarg_7 : _GEN_522; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_550 = 5'h5 == opcode ? hfutex_masks_0_0 : _GEN_523; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_551 = 5'h5 == opcode ? hfutex_masks_0_1 : _GEN_524; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_552 = 5'h5 == opcode ? hfutex_masks_0_2 : _GEN_525; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_553 = 5'h5 == opcode ? hfutex_masks_0_3 : _GEN_526; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_554 = 5'h5 == opcode ? hfutex_pos_0 : _GEN_527; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_555 = 5'h5 == opcode ? page_ptr_in_rw : _GEN_528; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_556 = 5'h5 == opcode ? _GEN_188 : _GEN_529; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_557 = 5'h5 == opcode ? _GEN_189 : _GEN_530; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_558 = 5'h5 == opcode ? _GEN_190 : _GEN_531; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_559 = 5'h5 == opcode ? _GEN_191 : _GEN_532; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_560 = 5'h5 == opcode ? _GEN_192 : _GEN_533; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_561 = 5'h5 == opcode ? _GEN_193 : _GEN_534; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_562 = 5'h5 == opcode ? _GEN_194 : _GEN_535; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_563 = 5'h5 == opcode ? _GEN_195 : _GEN_536; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_564 = 5'h4 == opcode ? _GEN_201 : _GEN_537; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_565 = 5'h4 == opcode ? _GEN_202 : _GEN_539; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [4:0] _GEN_566 = 5'h4 == opcode ? _GEN_203 : _GEN_538; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_567 = 5'h4 == opcode ? _GEN_204 : _GEN_540; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_569 = 5'h4 == opcode ? _GEN_15 : _GEN_542; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_570 = 5'h4 == opcode ? retarg_1 : _GEN_543; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_571 = 5'h4 == opcode ? retarg_2 : _GEN_544; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_572 = 5'h4 == opcode ? retarg_3 : _GEN_545; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_573 = 5'h4 == opcode ? retarg_4 : _GEN_546; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_574 = 5'h4 == opcode ? retarg_5 : _GEN_547; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_575 = 5'h4 == opcode ? retarg_6 : _GEN_548; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_576 = 5'h4 == opcode ? retarg_7 : _GEN_549; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_577 = 5'h4 == opcode ? hfutex_masks_0_0 : _GEN_550; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_578 = 5'h4 == opcode ? hfutex_masks_0_1 : _GEN_551; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_579 = 5'h4 == opcode ? hfutex_masks_0_2 : _GEN_552; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_580 = 5'h4 == opcode ? hfutex_masks_0_3 : _GEN_553; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_581 = 5'h4 == opcode ? hfutex_pos_0 : _GEN_554; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_582 = 5'h4 == opcode ? page_ptr_in_rw : _GEN_555; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_583 = 5'h4 == opcode ? _GEN_188 : _GEN_556; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_584 = 5'h4 == opcode ? _GEN_189 : _GEN_557; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_585 = 5'h4 == opcode ? _GEN_190 : _GEN_558; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_586 = 5'h4 == opcode ? _GEN_191 : _GEN_559; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_587 = 5'h4 == opcode ? _GEN_192 : _GEN_560; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_588 = 5'h4 == opcode ? _GEN_193 : _GEN_561; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_589 = 5'h4 == opcode ? _GEN_194 : _GEN_562; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_590 = 5'h4 == opcode ? _GEN_195 : _GEN_563; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_591 = 5'h3 == opcode ? 3'h5 : _GEN_564; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 350:15]
  wire [4:0] _GEN_592 = 5'h3 == opcode ? 5'h3 : _GEN_566; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 351:24]
  wire [7:0] _GEN_593 = 5'h3 == opcode ? 8'h2b : _GEN_567; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 352:24]
  wire [5:0] _GEN_595 = 5'h3 == opcode ? 6'h0 : _GEN_565; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 354:17]
  wire [7:0] _GEN_596 = 5'h3 == opcode ? _GEN_15 : _GEN_569; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_597 = 5'h3 == opcode ? retarg_1 : _GEN_570; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_598 = 5'h3 == opcode ? retarg_2 : _GEN_571; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_599 = 5'h3 == opcode ? retarg_3 : _GEN_572; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_600 = 5'h3 == opcode ? retarg_4 : _GEN_573; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_601 = 5'h3 == opcode ? retarg_5 : _GEN_574; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_602 = 5'h3 == opcode ? retarg_6 : _GEN_575; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_603 = 5'h3 == opcode ? retarg_7 : _GEN_576; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_604 = 5'h3 == opcode ? hfutex_masks_0_0 : _GEN_577; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_605 = 5'h3 == opcode ? hfutex_masks_0_1 : _GEN_578; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_606 = 5'h3 == opcode ? hfutex_masks_0_2 : _GEN_579; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_607 = 5'h3 == opcode ? hfutex_masks_0_3 : _GEN_580; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_608 = 5'h3 == opcode ? hfutex_pos_0 : _GEN_581; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_609 = 5'h3 == opcode ? page_ptr_in_rw : _GEN_582; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_610 = 5'h3 == opcode ? _GEN_188 : _GEN_583; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_611 = 5'h3 == opcode ? _GEN_189 : _GEN_584; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_612 = 5'h3 == opcode ? _GEN_190 : _GEN_585; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_613 = 5'h3 == opcode ? _GEN_191 : _GEN_586; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_614 = 5'h3 == opcode ? _GEN_192 : _GEN_587; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_615 = 5'h3 == opcode ? _GEN_193 : _GEN_588; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_616 = 5'h3 == opcode ? _GEN_194 : _GEN_589; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_617 = 5'h3 == opcode ? _GEN_195 : _GEN_590; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [2:0] _GEN_619 = 5'h2 == opcode ? 3'h6 : _GEN_591; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_620 = 5'h2 == opcode ? _GEN_35 : _GEN_592; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_621 = 5'h2 == opcode ? _GEN_19 : _GEN_593; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_623 = 5'h2 == opcode ? _GEN_38 : _GEN_595; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_624 = 5'h2 == opcode ? _GEN_15 : _GEN_596; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_625 = 5'h2 == opcode ? retarg_1 : _GEN_597; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_626 = 5'h2 == opcode ? retarg_2 : _GEN_598; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_627 = 5'h2 == opcode ? retarg_3 : _GEN_599; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_628 = 5'h2 == opcode ? retarg_4 : _GEN_600; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_629 = 5'h2 == opcode ? retarg_5 : _GEN_601; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_630 = 5'h2 == opcode ? retarg_6 : _GEN_602; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_631 = 5'h2 == opcode ? retarg_7 : _GEN_603; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [47:0] _GEN_632 = 5'h2 == opcode ? hfutex_masks_0_0 : _GEN_604; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_633 = 5'h2 == opcode ? hfutex_masks_0_1 : _GEN_605; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_634 = 5'h2 == opcode ? hfutex_masks_0_2 : _GEN_606; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [47:0] _GEN_635 = 5'h2 == opcode ? hfutex_masks_0_3 : _GEN_607; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 186:29]
  wire [1:0] _GEN_636 = 5'h2 == opcode ? hfutex_pos_0 : _GEN_608; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 187:27]
  wire [6:0] _GEN_637 = 5'h2 == opcode ? page_ptr_in_rw : _GEN_609; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [7:0] _GEN_638 = 5'h2 == opcode ? _GEN_188 : _GEN_610; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_639 = 5'h2 == opcode ? _GEN_189 : _GEN_611; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_640 = 5'h2 == opcode ? _GEN_190 : _GEN_612; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_641 = 5'h2 == opcode ? _GEN_191 : _GEN_613; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_642 = 5'h2 == opcode ? _GEN_192 : _GEN_614; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_643 = 5'h2 == opcode ? _GEN_193 : _GEN_615; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_644 = 5'h2 == opcode ? _GEN_194 : _GEN_616; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_645 = 5'h2 == opcode ? _GEN_195 : _GEN_617; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire  _GEN_646 = 5'h1 == opcode | 5'h2 == opcode; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 343:31]
  wire [1:0] _GEN_647 = 5'h1 == opcode ? 2'h1 : _GEN_39; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 344:26]
  wire [2:0] _GEN_648 = 5'h1 == opcode ? 3'h6 : _GEN_619; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 337:11 338:20]
  wire [4:0] _GEN_649 = 5'h1 == opcode ? _GEN_35 : _GEN_620; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_650 = 5'h1 == opcode ? _GEN_19 : _GEN_621; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_652 = 5'h1 == opcode ? _GEN_38 : _GEN_623; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_653 = 5'h1 == opcode ? _GEN_15 : _GEN_624; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_654 = 5'h1 == opcode ? retarg_1 : _GEN_625; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_655 = 5'h1 == opcode ? retarg_2 : _GEN_626; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_656 = 5'h1 == opcode ? retarg_3 : _GEN_627; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_657 = 5'h1 == opcode ? retarg_4 : _GEN_628; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_658 = 5'h1 == opcode ? retarg_5 : _GEN_629; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_659 = 5'h1 == opcode ? retarg_6 : _GEN_630; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_660 = 5'h1 == opcode ? retarg_7 : _GEN_631; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [6:0] _GEN_666 = 5'h1 == opcode ? page_ptr_in_rw : _GEN_637; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [3:0] _GEN_675 = 5'h0 == opcode ? 4'h8 : {{1'd0}, _GEN_648}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 340:15]
  wire  _GEN_676 = 5'h0 == opcode ? 1'h0 : _GEN_646; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 95:23]
  wire [1:0] _GEN_677 = 5'h0 == opcode ? _GEN_39 : _GEN_647; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_679 = 5'h0 == opcode ? _GEN_19 : _GEN_650; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [5:0] _GEN_681 = 5'h0 == opcode ? _GEN_38 : _GEN_652; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_682 = 5'h0 == opcode ? _GEN_15 : _GEN_653; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
  wire [7:0] _GEN_683 = 5'h0 == opcode ? retarg_1 : _GEN_654; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_684 = 5'h0 == opcode ? retarg_2 : _GEN_655; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_685 = 5'h0 == opcode ? retarg_3 : _GEN_656; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_686 = 5'h0 == opcode ? retarg_4 : _GEN_657; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_687 = 5'h0 == opcode ? retarg_5 : _GEN_658; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_688 = 5'h0 == opcode ? retarg_6 : _GEN_659; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [7:0] _GEN_689 = 5'h0 == opcode ? retarg_7 : _GEN_660; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 153:23]
  wire [6:0] _GEN_695 = 5'h0 == opcode ? page_ptr_in_rw : _GEN_666; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20 204:31]
  wire [4:0] _GEN_704 = state == 5'h3 ? 5'h1 : _GEN_198; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45 335:17]
  wire [3:0] _GEN_705 = state == 5'h3 ? 4'h1 : _GEN_197; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45 336:15]
  wire [4:0] _GEN_706 = state == 5'h3 ? {{1'd0}, _GEN_675} : _GEN_199; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire  _GEN_707 = state == 5'h3 & _GEN_676; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45 95:23]
  wire [1:0] _GEN_708 = state == 5'h3 ? _GEN_677 : _GEN_39; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire [7:0] _GEN_710 = state == 5'h3 ? _GEN_679 : _GEN_19; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire [5:0] _GEN_712 = state == 5'h3 ? _GEN_681 : _GEN_38; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire [7:0] _GEN_713 = state == 5'h3 ? _GEN_682 : _GEN_15; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
  wire [7:0] _GEN_714 = state == 5'h3 ? _GEN_683 : retarg_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_715 = state == 5'h3 ? _GEN_684 : retarg_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_716 = state == 5'h3 ? _GEN_685 : retarg_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_717 = state == 5'h3 ? _GEN_686 : retarg_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_718 = state == 5'h3 ? _GEN_687 : retarg_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_719 = state == 5'h3 ? _GEN_688 : retarg_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [7:0] _GEN_720 = state == 5'h3 ? _GEN_689 : retarg_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 334:45]
  wire [6:0] _GEN_726 = state == 5'h3 ? _GEN_695 : page_ptr_in_rw; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 204:31 334:45]
  wire [7:0] _io_tx_bits_T = {opoff,opcode}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 496:22]
  wire [3:0] _GEN_735 = opcode == 5'hc ? 4'ha : 4'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 505:50 506:15 511:15]
  wire [8:0] _GEN_736 = opcode == 5'hc ? 9'h0 : _GEN_200; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 505:50 507:18]
  wire [4:0] _GEN_738 = opcode == 5'hc ? _GEN_704 : 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 505:50 510:21]
  wire [4:0] _GEN_739 = opcode == 5'h8 | opcode == 5'ha | opcode == 5'h10 | opcode == 5'h11 ? 5'h8 : _GEN_738; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 502:158 503:21]
  wire [3:0] _GEN_740 = opcode == 5'h8 | opcode == 5'ha | opcode == 5'h10 | opcode == 5'h11 ? 4'h7 : _GEN_735; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 502:158 504:15]
  wire [8:0] _GEN_741 = opcode == 5'h8 | opcode == 5'ha | opcode == 5'h10 | opcode == 5'h11 ? _GEN_200 : _GEN_736; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 502:158]
  wire [4:0] _GEN_743 = opcode == 5'h0 ? 5'he : _GEN_739; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 499:45 500:21]
  wire [3:0] _GEN_744 = opcode == 5'h0 ? 4'h7 : _GEN_740; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 499:45 501:15]
  wire [8:0] _GEN_745 = opcode == 5'h0 ? _GEN_200 : _GEN_741; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 499:45]
  wire [4:0] _GEN_747 = io_tx_ready ? _GEN_743 : _GEN_704; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 498:23]
  wire [4:0] _GEN_748 = io_tx_ready ? {{1'd0}, _GEN_744} : _GEN_706; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 498:23]
  wire [8:0] _GEN_749 = io_tx_ready ? _GEN_745 : _GEN_200; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 498:23]
  wire [7:0] _GEN_752 = state == 5'h6 ? _io_tx_bits_T : 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:49 496:16 92:14]
  wire [3:0] _GEN_753 = state == 5'h6 ? 4'h0 : _GEN_705; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:49 497:15]
  wire [4:0] _GEN_754 = state == 5'h6 ? _GEN_747 : _GEN_704; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:49]
  wire [4:0] _GEN_755 = state == 5'h6 ? _GEN_748 : _GEN_706; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:49]
  wire [8:0] _GEN_756 = state == 5'h6 ? _GEN_749 : _GEN_200; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 494:49]
  wire [7:0] _GEN_759 = 4'h1 == trans_pos ? retarg_1 : retarg_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_760 = 4'h2 == trans_pos ? retarg_2 : _GEN_759; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_761 = 4'h3 == trans_pos ? retarg_3 : _GEN_760; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_762 = 4'h4 == trans_pos ? retarg_4 : _GEN_761; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_763 = 4'h5 == trans_pos ? retarg_5 : _GEN_762; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_764 = 4'h6 == trans_pos ? retarg_6 : _GEN_763; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_765 = 4'h7 == trans_pos ? retarg_7 : _GEN_764; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_766 = 4'h8 == trans_pos ? retarg_8 : _GEN_765; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_767 = 4'h9 == trans_pos ? retarg_9 : _GEN_766; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_768 = 4'ha == trans_pos ? retarg_10 : _GEN_767; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_769 = 4'hb == trans_pos ? retarg_11 : _GEN_768; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_770 = 4'hc == trans_pos ? retarg_12 : _GEN_769; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_771 = 4'hd == trans_pos ? retarg_13 : _GEN_770; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_772 = 4'he == trans_pos ? 8'h0 : _GEN_771; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [7:0] _GEN_773 = 4'hf == trans_pos ? 8'h0 : _GEN_772; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 518:{16,16}]
  wire [4:0] _GEN_776 = _T_66 ? 5'h1 : _GEN_755; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 520:46 523:15]
  wire [4:0] _GEN_779 = io_tx_ready ? _GEN_776 : _GEN_755; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 519:23]
  wire  _GEN_780 = state == 5'h7 | _T_97; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 516:48 517:17]
  wire [7:0] _GEN_781 = state == 5'h7 ? _GEN_773 : _GEN_752; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 516:48 518:16]
  wire [4:0] _GEN_784 = state == 5'h7 ? _GEN_779 : _GEN_755; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 516:48]
  wire [7:0] _GEN_785 = page_mem_0_pageReadData_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_786 = 3'h1 == shiftAmount ? page_mem_1_pageReadData_data : _GEN_785; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_787 = 3'h2 == shiftAmount ? page_mem_2_pageReadData_data : _GEN_786; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_788 = 3'h3 == shiftAmount ? page_mem_3_pageReadData_data : _GEN_787; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_789 = 3'h4 == shiftAmount ? page_mem_4_pageReadData_data : _GEN_788; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_790 = 3'h5 == shiftAmount ? page_mem_5_pageReadData_data : _GEN_789; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_791 = 3'h6 == shiftAmount ? page_mem_6_pageReadData_data : _GEN_790; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [7:0] _GEN_792 = 3'h7 == shiftAmount ? page_mem_7_pageReadData_data : _GEN_791; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 535:{16,16}]
  wire [4:0] _GEN_794 = _T_62 ? 5'h1 : _GEN_784; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 537:31 539:15]
  wire [4:0] _GEN_796 = _pageReadAddress_T ? _GEN_794 : _GEN_784; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 536:21]
  wire [4:0] _GEN_802 = state == 5'ha ? _GEN_796 : _GEN_784; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49]
  wire  no_wait_tap = _T_127 & ctrl_inst64_nowait & ctrl_inst64; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 549:77]
  wire [8:0] _inited_num_T_1 = inited_num + 9'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 596:38]
  wire [2:0] _GEN_820 = regback_0 == 64'h62 ? 3'h4 : 3'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 602:47 603:23 605:23]
  wire [7:0] _GEN_821 = retarg_1 == 8'h8 ? regback_0[7:0] : retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [7:0] _GEN_822 = retarg_1 == 8'h8 ? regback_0[15:8] : retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [7:0] _GEN_823 = retarg_1 == 8'h8 ? regback_0[23:16] : retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [7:0] _GEN_824 = retarg_1 == 8'h8 ? regback_0[31:24] : retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [7:0] _GEN_825 = retarg_1 == 8'h8 ? regback_0[39:32] : retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [7:0] _GEN_826 = retarg_1 == 8'h8 ? regback_0[47:40] : retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 598:46 600:34]
  wire [2:0] _GEN_827 = retarg_1 == 8'h8 ? _GEN_820 : 3'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 598:46 608:21]
  wire [3:0] _GEN_828 = _postMret_T_3 ? 4'h8 : 4'h6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 610:63 611:19 613:19]
  wire [7:0] _GEN_829 = state_register == 5'h2 ? _GEN_821 : retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [7:0] _GEN_830 = state_register == 5'h2 ? _GEN_822 : retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [7:0] _GEN_831 = state_register == 5'h2 ? _GEN_823 : retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [7:0] _GEN_832 = state_register == 5'h2 ? _GEN_824 : retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [7:0] _GEN_833 = state_register == 5'h2 ? _GEN_825 : retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [7:0] _GEN_834 = state_register == 5'h2 ? _GEN_826 : retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 597:61]
  wire [3:0] _GEN_835 = state_register == 5'h2 ? {{1'd0}, _GEN_827} : _GEN_828; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 597:61]
  wire [3:0] _GEN_836 = state_register == 5'h0 ? 4'h0 : _GEN_835; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 594:59 595:19]
  wire [8:0] _GEN_837 = state_register == 5'h0 ? _inited_num_T_1 : inited_num; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 594:59 596:24 184:27]
  wire [7:0] _GEN_838 = state_register == 5'h0 ? retarg_8 : _GEN_829; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [7:0] _GEN_839 = state_register == 5'h0 ? retarg_9 : _GEN_830; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [7:0] _GEN_840 = state_register == 5'h0 ? retarg_10 : _GEN_831; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [7:0] _GEN_841 = state_register == 5'h0 ? retarg_11 : _GEN_832; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [7:0] _GEN_842 = state_register == 5'h0 ? retarg_12 : _GEN_833; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [7:0] _GEN_843 = state_register == 5'h0 ? retarg_13 : _GEN_834; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 594:59]
  wire [4:0] _GEN_844 = ctrl_last ? {{1'd0}, _GEN_836} : _GEN_802; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 593:25]
  wire [7:0] _GEN_846 = ctrl_last ? _GEN_838 : retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [7:0] _GEN_847 = ctrl_last ? _GEN_839 : retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [7:0] _GEN_848 = ctrl_last ? _GEN_840 : retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [7:0] _GEN_849 = ctrl_last ? _GEN_841 : retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [7:0] _GEN_850 = ctrl_last ? _GEN_842 : retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [7:0] _GEN_851 = ctrl_last ? _GEN_843 : retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 593:25]
  wire [4:0] _GEN_852 = will_next ? _GEN_844 : _GEN_802; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 592:23]
  wire [7:0] _GEN_854 = will_next ? _GEN_846 : retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [7:0] _GEN_855 = will_next ? _GEN_847 : retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [7:0] _GEN_856 = will_next ? _GEN_848 : retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [7:0] _GEN_857 = will_next ? _GEN_849 : retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [7:0] _GEN_858 = will_next ? _GEN_850 : retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [7:0] _GEN_859 = will_next ? _GEN_851 : retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 592:23]
  wire [4:0] _GEN_860 = _T_127 ? _GEN_852 : _GEN_802; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 589:44]
  wire [7:0] _GEN_862 = _T_127 ? _GEN_854 : retarg_8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [7:0] _GEN_863 = _T_127 ? _GEN_855 : retarg_9; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [7:0] _GEN_864 = _T_127 ? _GEN_856 : retarg_10; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [7:0] _GEN_865 = _T_127 ? _GEN_857 : retarg_11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [7:0] _GEN_866 = _T_127 ? _GEN_858 : retarg_12; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [7:0] _GEN_867 = _T_127 ? _GEN_859 : retarg_13; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23 589:44]
  wire [4:0] _GEN_869 = state == 5'h4 ? 5'h5 : _GEN_860; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 618:50 620:11]
  wire [5:0] _GEN_870 = state == 5'h4 ? 6'h0 : _GEN_712; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 618:50 621:13]
  wire [5:0] _cnt_run_T_1 = cnt_run + 6'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 641:26]
  wire  _T_130 = state_register == 5'hc | state_register == 5'he; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 646:55]
  wire [7:0] _pg_loop_cnt_T_1 = pg_loop_cnt + 8'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 647:40]
  wire [7:0] _GEN_877 = state_register == 5'hc | state_register == 5'he ? _pg_loop_cnt_T_1 : pg_loop_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 646:98 647:25 198:28]
  wire [4:0] _GEN_878 = _postMret_T_3 ? 5'h6 : _GEN_869; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 649:57 651:19]
  wire [6:0] _GEN_879 = state_register == 5'hb | _writingPage_T_1 ? 7'h0 : _GEN_726; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 659:108 660:28]
  wire [7:0] _GEN_880 = _T_130 ? 8'h0 : pg_loop_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 657:98 658:25 198:28]
  wire [6:0] _GEN_881 = _T_130 ? _GEN_726 : _GEN_879; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 657:98]
  wire [5:0] _GEN_883 = ~jump_condition ? _cnt_run_T_1 : _cnt_run_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 641:15 653:36 656:19]
  wire [7:0] _GEN_884 = ~jump_condition ? _GEN_880 : pg_loop_cnt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 198:28 653:36]
  wire [6:0] _GEN_885 = ~jump_condition ? _GEN_881 : _GEN_726; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 653:36]
  wire [5:0] _GEN_887 = jump_condition ? cnt_rerun : _GEN_883; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 643:29 645:19]
  wire [7:0] _GEN_888 = jump_condition ? _GEN_877 : _GEN_884; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 643:29]
  wire [4:0] _GEN_889 = jump_condition ? _GEN_878 : _GEN_869; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 643:29]
  wire [6:0] _GEN_890 = jump_condition ? _GEN_726 : _GEN_885; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 643:29]
  wire [6:0] _GEN_895 = jump_tap ? _GEN_890 : _GEN_726; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 642:21]
  wire [6:0] _GEN_900 = will_next ? _GEN_895 : _GEN_726; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 640:20]
  wire [6:0] _GEN_905 = state == 5'h5 ? _GEN_900 : _GEN_726; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:42]
  wire  _T_169 = state_register == 5'h7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 783:24]
  wire  _T_170 = state_register == 5'h8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 783:66]
  wire [4:0] regacc_idx_wire = (state_register == 5'h7 | state_register == 5'h8) & ~oparg_2[5] ? oparg_2[4:0] : ctrl_idx
    ; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 783:109 784:21 786:21]
  wire [11:0] _ctrl_inst_raw_T_1 = {oparg_2[4:0], 7'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 790:50]
  wire [31:0] _GEN_1081 = {{20'd0}, _ctrl_inst_raw_T_1}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 790:33]
  wire [31:0] _ctrl_inst_raw_T_2 = ctrl_misc | _GEN_1081; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 790:33]
  wire [19:0] _ctrl_inst_raw_T_4 = {oparg_2[4:0], 15'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 792:50]
  wire [31:0] _GEN_1082 = {{12'd0}, _ctrl_inst_raw_T_4}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 792:33]
  wire [31:0] _ctrl_inst_raw_T_5 = ctrl_misc | _GEN_1082; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 792:33]
  wire [31:0] _ctrl_inst_raw_T_6 = {oparg_5,oparg_4,oparg_3,oparg_2}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 794:25]
  wire [31:0] _GEN_1065 = state_register == 5'h10 ? _ctrl_inst_raw_T_6 : ctrl_misc; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 793:53 794:19 796:19]
  wire [31:0] _GEN_1066 = _T_169 ? _ctrl_inst_raw_T_5 : _GEN_1065; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 791:54 792:19]
  wire [31:0] ctrl_inst_raw = _T_170 ? _ctrl_inst_raw_T_2 : _GEN_1066; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 789:48 790:19]
  wire [63:0] satp_value = {4'h8,oparg_3,oparg_2,4'h0,oparg_8,oparg_7,oparg_6,oparg_5,oparg_4}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 692:23]
  wire [63:0] flush_tlb_address = {12'h0,oparg_8,oparg_7,oparg_6,oparg_5,oparg_4,12'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 703:30]
  wire [16:0] flush_asid = {1'h0,oparg_3,oparg_2}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 704:23]
  wire  _T_146 = 4'h0 == ctrl_header; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire  _T_147 = 4'h1 == ctrl_header; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire  _T_148 = 4'h4 == ctrl_header; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire  _T_149 = 4'h5 == ctrl_header; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_928 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[7:0] : _GEN_715; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_929 = ctrl_loc_idx == 4'h2 ? _GEN_862 : io_cpu_0_regacc_rdata[7:0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire [7:0] _GEN_930 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[15:8] : _GEN_716; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_931 = ctrl_loc_idx == 4'h2 ? _GEN_863 : io_cpu_0_regacc_rdata[15:8]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire [7:0] _GEN_932 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[23:16] : _GEN_717; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_933 = ctrl_loc_idx == 4'h2 ? _GEN_864 : io_cpu_0_regacc_rdata[23:16]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire [7:0] _GEN_934 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[31:24] : _GEN_718; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_935 = ctrl_loc_idx == 4'h2 ? _GEN_865 : io_cpu_0_regacc_rdata[31:24]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire [7:0] _GEN_936 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[39:32] : _GEN_719; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_937 = ctrl_loc_idx == 4'h2 ? _GEN_866 : io_cpu_0_regacc_rdata[39:32]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire [7:0] _GEN_938 = ctrl_loc_idx == 4'h2 ? io_cpu_0_regacc_rdata[47:40] : _GEN_720; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 724:31]
  wire [7:0] _GEN_939 = ctrl_loc_idx == 4'h2 ? _GEN_867 : io_cpu_0_regacc_rdata[47:40]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 723:38 726:31]
  wire  _T_156 = 4'h6 == ctrl_header; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_940 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[7:0] : _GEN_713; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_941 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[15:8] : _GEN_714; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_942 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[23:16] : _GEN_715; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_943 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[31:24] : _GEN_716; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_944 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[39:32] : _GEN_717; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_945 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[47:40] : _GEN_718; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_946 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[55:48] : _GEN_719; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_947 = 4'h6 == ctrl_header ? io_cpu_0_regacc_rdata[63:56] : _GEN_720; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 732:25]
  wire [7:0] _GEN_948 = 4'h5 == ctrl_header ? _GEN_928 : _GEN_942; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_949 = 4'h5 == ctrl_header ? _GEN_929 : _GEN_862; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_950 = 4'h5 == ctrl_header ? _GEN_930 : _GEN_943; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_951 = 4'h5 == ctrl_header ? _GEN_931 : _GEN_863; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_952 = 4'h5 == ctrl_header ? _GEN_932 : _GEN_944; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_953 = 4'h5 == ctrl_header ? _GEN_933 : _GEN_864; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_954 = 4'h5 == ctrl_header ? _GEN_934 : _GEN_945; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_955 = 4'h5 == ctrl_header ? _GEN_935 : _GEN_865; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_956 = 4'h5 == ctrl_header ? _GEN_936 : _GEN_946; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_957 = 4'h5 == ctrl_header ? _GEN_937 : _GEN_866; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_958 = 4'h5 == ctrl_header ? _GEN_938 : _GEN_947; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_959 = 4'h5 == ctrl_header ? _GEN_939 : _GEN_867; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_960 = 4'h5 == ctrl_header ? _GEN_713 : _GEN_940; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_961 = 4'h5 == ctrl_header ? _GEN_714 : _GEN_941; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_962 = 4'h4 == ctrl_header ? io_cpu_0_regacc_rdata[7:0] : _GEN_961; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 718:19]
  wire [7:0] _GEN_963 = 4'h4 == ctrl_header ? _GEN_715 : _GEN_948; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_964 = 4'h4 == ctrl_header ? _GEN_862 : _GEN_949; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_965 = 4'h4 == ctrl_header ? _GEN_716 : _GEN_950; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_966 = 4'h4 == ctrl_header ? _GEN_863 : _GEN_951; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_967 = 4'h4 == ctrl_header ? _GEN_717 : _GEN_952; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_968 = 4'h4 == ctrl_header ? _GEN_864 : _GEN_953; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_969 = 4'h4 == ctrl_header ? _GEN_718 : _GEN_954; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_970 = 4'h4 == ctrl_header ? _GEN_865 : _GEN_955; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_971 = 4'h4 == ctrl_header ? _GEN_719 : _GEN_956; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_972 = 4'h4 == ctrl_header ? _GEN_866 : _GEN_957; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_973 = 4'h4 == ctrl_header ? _GEN_720 : _GEN_958; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_974 = 4'h4 == ctrl_header ? _GEN_867 : _GEN_959; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [7:0] _GEN_975 = 4'h4 == ctrl_header ? _GEN_713 : _GEN_960; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
  wire [63:0] _GEN_976 = 4'h1 == ctrl_header ? io_cpu_0_regacc_rdata : {{16'd0}, hfutex_match_reg}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 715:26 188:33]
  wire [63:0] _GEN_1001 = 4'h0 == ctrl_header ? {{16'd0}, hfutex_match_reg} : _GEN_976; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24 188:33]
  wire [63:0] _GEN_1026 = _capturePageWord_T_1 & _will_next_T ? _GEN_1001 : {{16'd0}, hfutex_match_reg}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 188:33 709:81]
  wire [63:0] _GEN_1042 = 4'h1 == ctrl_loc_idx ? regback_1 : regback_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1043 = 4'h2 == ctrl_loc_idx ? regback_2 : _GEN_1042; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1044 = 4'h3 == ctrl_loc_idx ? regback_3 : _GEN_1043; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1045 = 4'h4 == ctrl_loc_idx ? regback_4 : _GEN_1044; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1046 = 4'h5 == ctrl_loc_idx ? regback_5 : _GEN_1045; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1047 = 4'h6 == ctrl_loc_idx ? regback_6 : _GEN_1046; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1048 = 4'h7 == ctrl_loc_idx ? regback_7 : _GEN_1047; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1049 = 4'h8 == ctrl_loc_idx ? regback_8 : _GEN_1048; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] _GEN_1050 = 4'h9 == ctrl_loc_idx ? regback_9 : _GEN_1049; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 746:{26,26}]
  wire [63:0] regValue = {oparg_11,oparg_10,oparg_9,oparg_8,oparg_7,oparg_6,oparg_5,oparg_4}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 759:27]
  wire [63:0] fillValue = {oparg_14,oparg_13,oparg_12,oparg_11,oparg_10,oparg_9,oparg_8,oparg_7}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 760:28]
  wire [63:0] memValue = {oparg_15,oparg_14,oparg_13,oparg_12,oparg_11,oparg_10,oparg_9,oparg_8}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 761:27]
  wire [63:0] _io_cpu_0_regacc_wdata_T_2 = ctrl_loc_idx == 4'h7 ? fillValue : memValue; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 763:14]
  wire [63:0] _io_cpu_0_regacc_wdata_T_3 = ctrl_loc_idx == 4'h4 ? regValue : _io_cpu_0_regacc_wdata_T_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 762:32]
  wire [63:0] _io_cpu_0_regacc_wdata_T_5 = {16'h0,oparg_7,oparg_6,oparg_5,oparg_4,oparg_3,oparg_2}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 766:32]
  wire [63:0] _io_cpu_0_regacc_wdata_T_6 = {page_mem_7_pageReadData_data,page_mem_6_pageReadData_data,
    page_mem_5_pageReadData_data,page_mem_4_pageReadData_data,page_mem_3_pageReadData_data,page_mem_2_pageReadData_data,
    page_mem_1_pageReadData_data,page_mem_0_pageReadData_data}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 775:42]
  wire [63:0] _GEN_1051 = 4'hb == ctrl_header ? pg_addr2_plus : 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 778:26 99:28]
  wire [63:0] _GEN_1052 = 4'ha == ctrl_header ? _io_cpu_0_regacc_wdata_T_6 : _GEN_1051; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 775:26]
  wire [63:0] _GEN_1053 = 4'h9 == ctrl_header ? pg_base_addr7 : _GEN_1052; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 772:26]
  wire [63:0] _GEN_1054 = 4'h8 == ctrl_header ? pg_base_addr2 : _GEN_1053; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 769:26]
  wire [63:0] _GEN_1055 = 4'h7 == ctrl_header ? _io_cpu_0_regacc_wdata_T_5 : _GEN_1054; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 766:26]
  wire [63:0] _GEN_1056 = _T_156 ? _io_cpu_0_regacc_wdata_T_3 : _GEN_1055; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 762:26]
  wire [63:0] _GEN_1057 = _T_149 ? {{47'd0}, flush_asid} : _GEN_1056; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 755:26]
  wire [63:0] _GEN_1058 = _T_148 ? flush_tlb_address : _GEN_1057; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 752:26]
  wire [63:0] _GEN_1059 = 4'h3 == ctrl_header ? satp_value : _GEN_1058; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 749:26]
  wire [63:0] _GEN_1060 = 4'h2 == ctrl_header ? _GEN_1050 : _GEN_1059; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 746:26]
  wire [63:0] _GEN_1061 = _T_147 ? 64'h7fffffffff : _GEN_1060; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 743:26]
  wire [63:0] _GEN_1062 = _T_146 ? 64'h1f : _GEN_1061; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 738:24 740:26]
  wire [6:0] _page_ptr_in_rw_T_1 = page_ptr_in_rw + 7'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 802:38]
  wire [6:0] _GEN_1068 = capturePageWord ? _page_ptr_in_rw_T_1 : _GEN_905; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 801:25 802:20]
  wire [63:0] _GEN_1083 = reset ? 64'h0 : _GEN_1026; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 188:{33,33}]
  Queue_91 event_queue ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 128:27]
    .clock(event_queue_clock),
    .reset(event_queue_reset),
    .io_enq_ready(event_queue_io_enq_ready),
    .io_enq_valid(event_queue_io_enq_valid),
    .io_deq_ready(event_queue_io_deq_ready),
    .io_deq_valid(event_queue_io_deq_valid),
    .io_deq_bits(event_queue_io_deq_bits)
  );
  assign ctrl_rom_ctrl_content_en = 1'h1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:29 162:{35,35}]
  assign ctrl_rom_ctrl_content_data = ctrl_rom[ctrl_rom_ctrl_content_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 156:29]
  assign page_mem_0_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_0_pageReadData_data = page_mem_0[page_mem_0_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_0_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[7:0] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_0_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_0_MPORT_mask = capturePageWord | page_write_mask_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_0_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_1_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_1_pageReadData_data = page_mem_1[page_mem_1_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_1_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[15:8] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_1_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_1_MPORT_mask = capturePageWord | page_write_mask_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_1_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_2_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_2_pageReadData_data = page_mem_2[page_mem_2_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_2_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[23:16] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_2_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_2_MPORT_mask = capturePageWord | page_write_mask_2; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_2_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_3_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_3_pageReadData_data = page_mem_3[page_mem_3_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_3_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[31:24] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_3_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_3_MPORT_mask = capturePageWord | page_write_mask_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_3_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_4_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_4_pageReadData_data = page_mem_4[page_mem_4_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_4_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[39:32] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_4_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_4_MPORT_mask = capturePageWord | page_write_mask_4; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_4_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_5_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_5_pageReadData_data = page_mem_5[page_mem_5_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_5_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[47:40] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_5_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_5_MPORT_mask = capturePageWord | page_write_mask_5; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_5_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_6_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_6_pageReadData_data = page_mem_6[page_mem_6_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_6_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[55:48] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_6_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_6_MPORT_mask = capturePageWord | page_write_mask_6; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_6_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign page_mem_7_pageReadData_en = writingPage | _GEN_1069; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 816:20]
  assign page_mem_7_pageReadData_data = page_mem_7[page_mem_7_pageReadData_addr]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
  assign page_mem_7_MPORT_data = capturePageWord ? io_cpu_0_regacc_rdata[63:56] : page_word_content_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 310:19]
  assign page_mem_7_MPORT_addr = capturePageWord ? page_ptr_in_rw[5:0] : page_ptr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 309:22]
  assign page_mem_7_MPORT_mask = capturePageWord | page_write_mask_7; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 311:19]
  assign page_mem_7_MPORT_en = page_mem_can_write | capturePageWord; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 308:27]
  assign io_cpu_0_ext_itr = _T_127 ? ctrl_itr : _GEN_707; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 668:43 669:27]
  assign io_cpu_0_stop_fetch = cpu_state_0 == 2'h2 | cpu_state_0 == 2'h1 | _T_3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 126:113]
  assign io_cpu_0_regacc_rd = _T_127 & ctrl_regacc_rd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 668:43 670:29 96:25]
  assign io_cpu_0_regacc_wt = _T_127 & ctrl_regacc_wt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 668:43 671:29 97:25]
  assign io_cpu_0_regacc_idx = _T_127 ? regacc_idx_wire : 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 668:43 672:30 98:26]
  assign io_cpu_0_regacc_wdata = ctrl_regacc_wt ? _GEN_1062 : 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 737:23 99:28]
  assign io_cpu_0_inst64 = _T_127 & ctrl_inst64; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 100:22 668:43 673:26]
  assign io_cpu_0_inst64_raw = _T_127 ? ctrl_inst_raw : 32'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 101:26 668:43 676:30]
  assign io_tx_valid = state == 5'ha | _GEN_780; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49 530:17]
  assign io_tx_bits = state == 5'ha ? _GEN_792 : _GEN_781; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49 535:16]
  assign io_rx_ready = state == 5'h2 | _GEN_89; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48 317:17]
  assign io_dbg_sta = {io_dbg_sta_hi,errno}; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 149:20]
  assign event_queue_clock = clock;
  assign event_queue_reset = reset;
  assign event_queue_io_enq_valid = cpu_raised_itr_0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 131:28]
  assign event_queue_io_deq_ready = state == 5'h8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 217:38]
  always @(posedge clock) begin
    if (ctrl_rom_ctrl_content_en) begin
      ctrl_rom_ctrl_content_addr <= state == 5'h8 ? 8'h8 : _GEN_915; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 683:48 685:14]
    end
    if (page_mem_0_pageReadData_en) begin
      page_mem_0_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_0_MPORT_en & page_mem_0_MPORT_mask) begin
      page_mem_0[page_mem_0_MPORT_addr] <= page_mem_0_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_1_pageReadData_en) begin
      page_mem_1_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_1_MPORT_en & page_mem_1_MPORT_mask) begin
      page_mem_1[page_mem_1_MPORT_addr] <= page_mem_1_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_2_pageReadData_en) begin
      page_mem_2_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_2_MPORT_en & page_mem_2_MPORT_mask) begin
      page_mem_2[page_mem_2_MPORT_addr] <= page_mem_2_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_3_pageReadData_en) begin
      page_mem_3_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_3_MPORT_en & page_mem_3_MPORT_mask) begin
      page_mem_3[page_mem_3_MPORT_addr] <= page_mem_3_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_4_pageReadData_en) begin
      page_mem_4_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_4_MPORT_en & page_mem_4_MPORT_mask) begin
      page_mem_4[page_mem_4_MPORT_addr] <= page_mem_4_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_5_pageReadData_en) begin
      page_mem_5_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_5_MPORT_en & page_mem_5_MPORT_mask) begin
      page_mem_5[page_mem_5_MPORT_addr] <= page_mem_5_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_6_pageReadData_en) begin
      page_mem_6_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_6_MPORT_en & page_mem_6_MPORT_mask) begin
      page_mem_6[page_mem_6_MPORT_addr] <= page_mem_6_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (page_mem_7_pageReadData_en) begin
      page_mem_7_pageReadData_addr <= writingPage ? _pageReadAddress_T_5[5:0] : _GEN_799; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21 817:21]
    end
    if (page_mem_7_MPORT_en & page_mem_7_MPORT_mask) begin
      page_mem_7[page_mem_7_MPORT_addr] <= page_mem_7_MPORT_data; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 202:29]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 106:26]
      cpu_state_0 <= 2'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 106:26]
    end else if (no_wait_tap) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 581:20]
      if (io_cpu_0_inst64_ready) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 582:27]
        cpu_state_0 <= 2'h3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 583:24]
      end else begin
        cpu_state_0 <= _GEN_708;
      end
    end else begin
      cpu_state_0 <= _GEN_708;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 108:27]
      global_clk <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 108:27]
    end else begin
      global_clk <= _global_clk_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 111:14]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 109:25]
      user_clk_0 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 109:25]
    end else if (io_cpu_0_priv == 2'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 113:34]
      user_clk_0 <= _user_clk_0_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 114:19]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 118:31]
      cpu_raised_itr_0 <= 1'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 118:31]
    end else if (cpu_raised_itr_0 & event_queue_io_enq_ready) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 133:45]
      cpu_raised_itr_0 <= 1'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 134:31]
    end else begin
      cpu_raised_itr_0 <= _GEN_1;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 119:26]
      last_priv_0 <= 2'h3; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 119:26]
    end else begin
      last_priv_0 <= io_cpu_0_priv; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 121:18]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 139:22]
      state <= 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 139:22]
    end else if (state == 5'h5) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:42]
      if (will_next) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 640:20]
        if (jump_tap) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 642:21]
          state <= _GEN_889;
        end else begin
          state <= _GEN_869;
        end
      end else begin
        state <= _GEN_869;
      end
    end else begin
      state <= _GEN_869;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 140:28]
      trans_bytes <= 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 140:28]
    end else if (state == 5'h7) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 516:48]
      if (io_tx_ready) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 519:23]
        if (_T_66) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 520:46]
          trans_bytes <= 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 522:21]
        end else begin
          trans_bytes <= _GEN_754;
        end
      end else begin
        trans_bytes <= _GEN_754;
      end
    end else begin
      trans_bytes <= _GEN_754;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 141:26]
      trans_pos <= 4'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 141:26]
    end else if (state == 5'h7) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 516:48]
      if (io_tx_ready) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 519:23]
        if (_T_65 == trans_bytes) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 320:46]
          trans_pos <= 4'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 321:19]
        end else begin
          trans_pos <= _trans_pos_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 329:19]
        end
      end else begin
        trans_pos <= _GEN_753;
      end
    end else begin
      trans_pos <= _GEN_753;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 145:31]
      state_register <= 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 145:31]
    end else if (state == 5'h4) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 618:50]
      state_register <= 5'h11; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 619:20]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        state_register <= _GEN_35;
      end else begin
        state_register <= _GEN_649;
      end
    end else begin
      state_register <= _GEN_35;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22]
      errno <= 6'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 146:22]
    end else if (state == 5'h1) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 252:49]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23]
        if (!(rxop == 5'h1 | rxop == 5'h2 | rxop == 5'h5 | rxop == 5'h7 | rxop == 5'h11 | rxop == 5'h13)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 262:209]
          errno <= _GEN_67;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 147:28]
      initialized <= 1'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 147:28]
    end else if (_T_140) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 234:48]
      if (io_cpu_0_inited) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 235:21]
        if (!(inited_num < 9'h1)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 236:34]
          initialized <= _GEN_21;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 150:23]
      opcode <= 5'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 150:23]
    end else if (state == 5'h1) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 252:49]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23]
        opcode <= rxop; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 257:14]
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 151:22]
      opoff <= 3'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 151:22]
    end else if (state == 5'h1) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 252:49]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 254:23]
        opoff <= rxoff; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 258:13]
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_2 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'h2 == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_2 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_3 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'h3 == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_3 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_4 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'h4 == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_4 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_5 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'h5 == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_5 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_6 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'h6 == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_6 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_7 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_7 <= _GEN_188;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_7 <= _GEN_188;
      end else begin
        oparg_7 <= _GEN_638;
      end
    end else begin
      oparg_7 <= _GEN_188;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_8 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_8 <= _GEN_189;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_8 <= _GEN_189;
      end else begin
        oparg_8 <= _GEN_639;
      end
    end else begin
      oparg_8 <= _GEN_189;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_9 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_9 <= _GEN_190;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_9 <= _GEN_190;
      end else begin
        oparg_9 <= _GEN_640;
      end
    end else begin
      oparg_9 <= _GEN_190;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_10 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_10 <= _GEN_191;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_10 <= _GEN_191;
      end else begin
        oparg_10 <= _GEN_641;
      end
    end else begin
      oparg_10 <= _GEN_191;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_11 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_11 <= _GEN_192;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_11 <= _GEN_192;
      end else begin
        oparg_11 <= _GEN_642;
      end
    end else begin
      oparg_11 <= _GEN_192;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_12 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_12 <= _GEN_193;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_12 <= _GEN_193;
      end else begin
        oparg_12 <= _GEN_643;
      end
    end else begin
      oparg_12 <= _GEN_193;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_13 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_13 <= _GEN_194;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_13 <= _GEN_194;
      end else begin
        oparg_13 <= _GEN_644;
      end
    end else begin
      oparg_13 <= _GEN_194;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_14 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (5'h0 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_14 <= _GEN_195;
      end else if (5'h1 == opcode) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        oparg_14 <= _GEN_195;
      end else begin
        oparg_14 <= _GEN_645;
      end
    end else begin
      oparg_14 <= _GEN_195;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
      oparg_15 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 152:22]
    end else if (state == 5'h2) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 316:48]
      if (io_rx_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 318:23]
        if (4'hf == trans_pos) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
          oparg_15 <= io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 319:24]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_0 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_0 <= _GEN_713;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_0 <= _GEN_713;
      end else begin
        retarg_0 <= _GEN_975;
      end
    end else begin
      retarg_0 <= _GEN_713;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_1 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_1 <= _GEN_714;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_1 <= _GEN_714;
      end else begin
        retarg_1 <= _GEN_962;
      end
    end else begin
      retarg_1 <= _GEN_714;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_2 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_2 <= _GEN_715;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_2 <= _GEN_715;
      end else begin
        retarg_2 <= _GEN_963;
      end
    end else begin
      retarg_2 <= _GEN_715;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_3 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_3 <= _GEN_716;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_3 <= _GEN_716;
      end else begin
        retarg_3 <= _GEN_965;
      end
    end else begin
      retarg_3 <= _GEN_716;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_4 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_4 <= _GEN_717;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_4 <= _GEN_717;
      end else begin
        retarg_4 <= _GEN_967;
      end
    end else begin
      retarg_4 <= _GEN_717;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_5 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_5 <= _GEN_718;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_5 <= _GEN_718;
      end else begin
        retarg_5 <= _GEN_969;
      end
    end else begin
      retarg_5 <= _GEN_718;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_6 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_6 <= _GEN_719;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_6 <= _GEN_719;
      end else begin
        retarg_6 <= _GEN_971;
      end
    end else begin
      retarg_6 <= _GEN_719;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_7 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_7 <= _GEN_720;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_7 <= _GEN_720;
      end else begin
        retarg_7 <= _GEN_973;
      end
    end else begin
      retarg_7 <= _GEN_720;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_8 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_8 <= _GEN_862;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_8 <= _GEN_862;
      end else begin
        retarg_8 <= _GEN_964;
      end
    end else begin
      retarg_8 <= _GEN_862;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_9 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_9 <= _GEN_863;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_9 <= _GEN_863;
      end else begin
        retarg_9 <= _GEN_966;
      end
    end else begin
      retarg_9 <= _GEN_863;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_10 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_10 <= _GEN_864;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_10 <= _GEN_864;
      end else begin
        retarg_10 <= _GEN_968;
      end
    end else begin
      retarg_10 <= _GEN_864;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_11 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_11 <= _GEN_865;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_11 <= _GEN_865;
      end else begin
        retarg_11 <= _GEN_970;
      end
    end else begin
      retarg_11 <= _GEN_865;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_12 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_12 <= _GEN_866;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_12 <= _GEN_866;
      end else begin
        retarg_12 <= _GEN_972;
      end
    end else begin
      retarg_12 <= _GEN_866;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
      retarg_13 <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 153:23]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_13 <= _GEN_867;
      end else if (4'h1 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        retarg_13 <= _GEN_867;
      end else begin
        retarg_13 <= _GEN_974;
      end
    end else begin
      retarg_13 <= _GEN_867;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 185:24]
      cnt_run <= 6'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 185:24]
    end else if (state == 5'h5) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:42]
      if (will_next) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 640:20]
        if (jump_tap) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 642:21]
          cnt_run <= _GEN_887;
        end else begin
          cnt_run <= _cnt_run_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 641:15]
        end
      end else begin
        cnt_run <= _GEN_870;
      end
    end else begin
      cnt_run <= _GEN_870;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 198:28]
      pg_loop_cnt <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 198:28]
    end else if (state == 5'h5) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 638:42]
      if (will_next) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 640:20]
        if (jump_tap) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 642:21]
          pg_loop_cnt <= _GEN_888;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 204:31]
      page_ptr_in_rw <= 7'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 204:31]
    end else if (writingPage) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 815:21]
      if (consumePageWord) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 818:27]
        page_ptr_in_rw <= _page_ptr_in_rw_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 819:22]
      end else begin
        page_ptr_in_rw <= _GEN_1068;
      end
    end else begin
      page_ptr_in_rw <= _GEN_1068;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_1 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h1 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_1 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    hfutex_match_reg <= _GEN_1083[47:0]; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 188:{33,33}]
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
      hfutex_masks_0_0 <= 48'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (!(5'h0 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        if (!(5'h1 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
          hfutex_masks_0_0 <= _GEN_632;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
      hfutex_masks_0_1 <= 48'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (!(5'h0 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        if (!(5'h1 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
          hfutex_masks_0_1 <= _GEN_633;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
      hfutex_masks_0_2 <= 48'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (!(5'h0 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        if (!(5'h1 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
          hfutex_masks_0_2 <= _GEN_634;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
      hfutex_masks_0_3 <= 48'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 186:29]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (!(5'h0 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        if (!(5'h1 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
          hfutex_masks_0_3 <= _GEN_635;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 163:31]
      ctrl_base_addr <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 163:31]
    end else if (state == 5'h8) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 683:48]
      ctrl_base_addr <= 8'h8; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 684:20]
    end else if (state == 5'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 679:48]
      ctrl_base_addr <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 680:20]
    end else if (state == 5'h4) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 618:50]
      ctrl_base_addr <= 8'h17; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 622:20]
    end else begin
      ctrl_base_addr <= _GEN_710;
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 184:27]
      inited_num <= 9'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 184:27]
    end else if (_T_127) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 589:44]
      if (will_next) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 592:23]
        if (ctrl_last) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 593:25]
          inited_num <= _GEN_837;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 187:27]
      hfutex_pos_0 <= 2'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 187:27]
    end else if (state == 5'h3) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 334:45]
      if (!(5'h0 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
        if (!(5'h1 == opcode)) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 338:20]
          hfutex_pos_0 <= _GEN_636;
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_0 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h0 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_0 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_2 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h2 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_2 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_3 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h3 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_3 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_4 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h4 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_4 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_5 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h5 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_5 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_6 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h6 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_6 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_7 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h7 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_7 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_8 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h8 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_8 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
      regback_9 <= 64'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 193:24]
    end else if (_capturePageWord_T_1 & _will_next_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 709:81]
      if (4'h0 == ctrl_header) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 710:24]
        if (4'h9 == ctrl_loc_idx) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
          regback_9 <= io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 712:31]
        end
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 206:25]
      byte_cnt <= 9'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 206:25]
    end else if (state == 5'ha) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 529:49]
      if (_pageReadAddress_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 536:21]
        if (byte_cnt == 9'h1ff) begin // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 299:31]
          byte_cnt <= 9'h0; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 300:18]
        end else begin
          byte_cnt <= _byte_cnt_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMPMicrocode.scala 303:18]
        end
      end else begin
        byte_cnt <= _GEN_756;
      end
    end else begin
      byte_cnt <= _GEN_756;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
  integer initvar;
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_0[initvar] = _RAND_1[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_1[initvar] = _RAND_3[7:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_2[initvar] = _RAND_5[7:0];
  _RAND_7 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_3[initvar] = _RAND_7[7:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_4[initvar] = _RAND_9[7:0];
  _RAND_11 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_5[initvar] = _RAND_11[7:0];
  _RAND_13 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_6[initvar] = _RAND_13[7:0];
  _RAND_15 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    page_mem_7[initvar] = _RAND_15[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ctrl_rom_ctrl_content_addr = _RAND_0[7:0];
  _RAND_2 = {1{`RANDOM}};
  page_mem_0_pageReadData_addr = _RAND_2[5:0];
  _RAND_4 = {1{`RANDOM}};
  page_mem_1_pageReadData_addr = _RAND_4[5:0];
  _RAND_6 = {1{`RANDOM}};
  page_mem_2_pageReadData_addr = _RAND_6[5:0];
  _RAND_8 = {1{`RANDOM}};
  page_mem_3_pageReadData_addr = _RAND_8[5:0];
  _RAND_10 = {1{`RANDOM}};
  page_mem_4_pageReadData_addr = _RAND_10[5:0];
  _RAND_12 = {1{`RANDOM}};
  page_mem_5_pageReadData_addr = _RAND_12[5:0];
  _RAND_14 = {1{`RANDOM}};
  page_mem_6_pageReadData_addr = _RAND_14[5:0];
  _RAND_16 = {1{`RANDOM}};
  page_mem_7_pageReadData_addr = _RAND_16[5:0];
  _RAND_17 = {1{`RANDOM}};
  cpu_state_0 = _RAND_17[1:0];
  _RAND_18 = {2{`RANDOM}};
  global_clk = _RAND_18[63:0];
  _RAND_19 = {2{`RANDOM}};
  user_clk_0 = _RAND_19[63:0];
  _RAND_20 = {1{`RANDOM}};
  cpu_raised_itr_0 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  last_priv_0 = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  state = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  trans_bytes = _RAND_23[4:0];
  _RAND_24 = {1{`RANDOM}};
  trans_pos = _RAND_24[3:0];
  _RAND_25 = {1{`RANDOM}};
  state_register = _RAND_25[4:0];
  _RAND_26 = {1{`RANDOM}};
  errno = _RAND_26[5:0];
  _RAND_27 = {1{`RANDOM}};
  initialized = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  opcode = _RAND_28[4:0];
  _RAND_29 = {1{`RANDOM}};
  opoff = _RAND_29[2:0];
  _RAND_30 = {1{`RANDOM}};
  oparg_2 = _RAND_30[7:0];
  _RAND_31 = {1{`RANDOM}};
  oparg_3 = _RAND_31[7:0];
  _RAND_32 = {1{`RANDOM}};
  oparg_4 = _RAND_32[7:0];
  _RAND_33 = {1{`RANDOM}};
  oparg_5 = _RAND_33[7:0];
  _RAND_34 = {1{`RANDOM}};
  oparg_6 = _RAND_34[7:0];
  _RAND_35 = {1{`RANDOM}};
  oparg_7 = _RAND_35[7:0];
  _RAND_36 = {1{`RANDOM}};
  oparg_8 = _RAND_36[7:0];
  _RAND_37 = {1{`RANDOM}};
  oparg_9 = _RAND_37[7:0];
  _RAND_38 = {1{`RANDOM}};
  oparg_10 = _RAND_38[7:0];
  _RAND_39 = {1{`RANDOM}};
  oparg_11 = _RAND_39[7:0];
  _RAND_40 = {1{`RANDOM}};
  oparg_12 = _RAND_40[7:0];
  _RAND_41 = {1{`RANDOM}};
  oparg_13 = _RAND_41[7:0];
  _RAND_42 = {1{`RANDOM}};
  oparg_14 = _RAND_42[7:0];
  _RAND_43 = {1{`RANDOM}};
  oparg_15 = _RAND_43[7:0];
  _RAND_44 = {1{`RANDOM}};
  retarg_0 = _RAND_44[7:0];
  _RAND_45 = {1{`RANDOM}};
  retarg_1 = _RAND_45[7:0];
  _RAND_46 = {1{`RANDOM}};
  retarg_2 = _RAND_46[7:0];
  _RAND_47 = {1{`RANDOM}};
  retarg_3 = _RAND_47[7:0];
  _RAND_48 = {1{`RANDOM}};
  retarg_4 = _RAND_48[7:0];
  _RAND_49 = {1{`RANDOM}};
  retarg_5 = _RAND_49[7:0];
  _RAND_50 = {1{`RANDOM}};
  retarg_6 = _RAND_50[7:0];
  _RAND_51 = {1{`RANDOM}};
  retarg_7 = _RAND_51[7:0];
  _RAND_52 = {1{`RANDOM}};
  retarg_8 = _RAND_52[7:0];
  _RAND_53 = {1{`RANDOM}};
  retarg_9 = _RAND_53[7:0];
  _RAND_54 = {1{`RANDOM}};
  retarg_10 = _RAND_54[7:0];
  _RAND_55 = {1{`RANDOM}};
  retarg_11 = _RAND_55[7:0];
  _RAND_56 = {1{`RANDOM}};
  retarg_12 = _RAND_56[7:0];
  _RAND_57 = {1{`RANDOM}};
  retarg_13 = _RAND_57[7:0];
  _RAND_58 = {1{`RANDOM}};
  cnt_run = _RAND_58[5:0];
  _RAND_59 = {1{`RANDOM}};
  pg_loop_cnt = _RAND_59[7:0];
  _RAND_60 = {1{`RANDOM}};
  page_ptr_in_rw = _RAND_60[6:0];
  _RAND_61 = {2{`RANDOM}};
  regback_1 = _RAND_61[63:0];
  _RAND_62 = {2{`RANDOM}};
  hfutex_match_reg = _RAND_62[47:0];
  _RAND_63 = {2{`RANDOM}};
  hfutex_masks_0_0 = _RAND_63[47:0];
  _RAND_64 = {2{`RANDOM}};
  hfutex_masks_0_1 = _RAND_64[47:0];
  _RAND_65 = {2{`RANDOM}};
  hfutex_masks_0_2 = _RAND_65[47:0];
  _RAND_66 = {2{`RANDOM}};
  hfutex_masks_0_3 = _RAND_66[47:0];
  _RAND_67 = {1{`RANDOM}};
  ctrl_base_addr = _RAND_67[7:0];
  _RAND_68 = {1{`RANDOM}};
  inited_num = _RAND_68[8:0];
  _RAND_69 = {1{`RANDOM}};
  hfutex_pos_0 = _RAND_69[1:0];
  _RAND_70 = {2{`RANDOM}};
  regback_0 = _RAND_70[63:0];
  _RAND_71 = {2{`RANDOM}};
  regback_2 = _RAND_71[63:0];
  _RAND_72 = {2{`RANDOM}};
  regback_3 = _RAND_72[63:0];
  _RAND_73 = {2{`RANDOM}};
  regback_4 = _RAND_73[63:0];
  _RAND_74 = {2{`RANDOM}};
  regback_5 = _RAND_74[63:0];
  _RAND_75 = {2{`RANDOM}};
  regback_6 = _RAND_75[63:0];
  _RAND_76 = {2{`RANDOM}};
  regback_7 = _RAND_76[63:0];
  _RAND_77 = {2{`RANDOM}};
  regback_8 = _RAND_77[63:0];
  _RAND_78 = {2{`RANDOM}};
  regback_9 = _RAND_78[63:0];
  _RAND_79 = {1{`RANDOM}};
  byte_cnt = _RAND_79[8:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
initial begin

    $readmemh("fase_ctrl_microcode.mem", ctrl_rom);
end
endmodule

module Tx(
  input        clock,
  input        reset,
  output       io_txd, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 31:16]
  output       io_channel_ready, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 31:16]
  input        io_channel_valid, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 31:16]
  input  [7:0] io_channel_bits // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 31:16]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 39:27]
  reg [19:0] cntReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 40:25]
  reg [3:0] bitsReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 41:26]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 43:33]
  wire [9:0] shift = shiftReg[10:1]; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 50:34]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 51:29]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 52:32]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 56:52]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 64:26]
  assign io_txd = shiftReg[0]; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 44:23]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 43:42]
  always @(posedge clock) begin
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 39:27]
      shiftReg <= 11'h7ff; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 39:27]
    end else if (_io_channel_ready_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 46:26]
      if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 49:31]
        shiftReg <= _shiftReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 51:22]
      end else if (io_channel_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 54:36]
        shiftReg <= _shiftReg_T_3; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 56:26]
      end else begin
        shiftReg <= 11'h7ff; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 59:26]
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 40:25]
      cntReg <= 20'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 40:25]
    end else if (_io_channel_ready_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 46:26]
      cntReg <= 20'h6c; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 48:16]
    end else begin
      cntReg <= _cntReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 64:16]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 41:26]
      bitsReg <= 4'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 41:26]
    end else if (_io_channel_ready_T) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 46:26]
      if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 49:31]
        bitsReg <= _bitsReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 52:21]
      end else if (io_channel_valid) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 54:36]
        bitsReg <= 4'hb; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 57:25]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

module Rx(
  input        clock,
  input        reset,
  input        io_rxd, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 69:16]
  input        io_channel_ready, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 69:16]
  output       io_channel_valid, // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 69:16]
  output [7:0] io_channel_bits // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 69:16]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg  rxReg_REG; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 80:32]
  reg  rxReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 80:24]
  reg [7:0] shiftReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 82:27]
  reg [19:0] cntReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 83:25]
  reg [3:0] bitsReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 84:26]
  reg  validReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 85:27]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 88:26]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 91:27]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 92:28]
  wire  _GEN_0 = bitsReg == 4'h1 | validReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 94:31 95:18 85:27]
  assign io_channel_valid = validReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 108:22]
  assign io_channel_bits = shiftReg; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 107:21]
  always @(posedge clock) begin
    rxReg_REG <= reset | io_rxd; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 80:{32,32,32}]
    rxReg <= reset | rxReg_REG; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 80:{24,24,24}]
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 82:27]
      shiftReg <= 8'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 82:27]
    end else if (!(cntReg != 20'h0)) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 87:26]
      if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 89:34]
        shiftReg <= _shiftReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 91:18]
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 83:25]
      cntReg <= 20'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 83:25]
    end else if (cntReg != 20'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 87:26]
      cntReg <= _cntReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 88:16]
    end else if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 89:34]
      cntReg <= 20'h6c; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 90:16]
    end else if (~rxReg) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 97:32]
      cntReg <= 20'ha2; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 99:16]
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 84:26]
      bitsReg <= 4'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 84:26]
    end else if (!(cntReg != 20'h0)) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 87:26]
      if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 89:34]
        bitsReg <= _bitsReg_T_1; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 92:17]
      end else if (~rxReg) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 97:32]
        bitsReg <= 4'h8; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 100:17]
      end
    end
    if (reset) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 85:27]
      validReg <= 1'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 85:27]
    end else if (validReg & io_channel_ready) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 103:40]
      validReg <= 1'h0; // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 104:18]
    end else if (!(cntReg != 20'h0)) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 87:26]
      if (bitsReg != 4'h0) begin // @[generators/riscv-boom/src/main/scala/v3/common/FasePorts.scala 89:34]
        validReg <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rxReg_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rxReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  shiftReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  cntReg = _RAND_3[19:0];
  _RAND_4 = {1{`RANDOM}};
  bitsReg = _RAND_4[3:0];
  _RAND_5 = {1{`RANDOM}};
  validReg = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

module Queue_92(
  input        clock,
  input        reset,
  output       io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input  [7:0] io_enq_bits, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output       io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output [7:0] io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] ram [0:511]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire [8:0] ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire [7:0] ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire [8:0] ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:8]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 57:35]
  reg [8:0] enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [8:0] deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 283:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 284:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 285:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [8:0] _value_T_1 = enq_ptr_value + 9'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [8:0] _value_T_3 = deq_ptr_value + 9'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  assign ram_MPORT_data = io_enq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_addr = enq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:8]
  assign ram_MPORT_mask = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_en = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 309:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 308:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 316:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 9'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 292:16]
      enq_ptr_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 9'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 296:16]
      deq_ptr_value <= _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 299:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 300:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[8:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[8:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

module Queue_93(
  input        clock,
  input        reset,
  output       io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input  [7:0] io_enq_bits, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  input        io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output       io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
  output [7:0] io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 278:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] ram [0:63]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire [5:0] ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 316:23]
  wire [7:0] ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  wire [7:0] ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire [5:0] ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:8]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 292:16 293:24]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95 57:35]
  reg [5:0] enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [5:0] deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 283:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 284:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 285:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  wire [5:0] _value_T_1 = enq_ptr_value + 6'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [5:0] _value_T_3 = deq_ptr_value + 6'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 316:23]
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
  assign ram_MPORT_data = io_enq_bits; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_addr = enq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:8]
  assign ram_MPORT_mask = 1'h1; // @[src/main/scala/chisel3/util/Decoupled.scala 292:16 293:24]
  assign ram_MPORT_en = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 57:35]
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 309:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 308:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 316:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 279:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 6'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 292:16]
      enq_ptr_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 6'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 296:16]
      deq_ptr_value <= _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 282:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 299:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 300:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 64; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[5:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[5:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

module NulCPUCtrlMPWithUart(
  input         clock,
  input         reset,
  input         io_cpu_0_inited, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input  [1:0]  io_cpu_0_priv, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_cpu_0_ext_itr, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_cpu_0_stop_fetch, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_cpu_0_regacc_rd, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_cpu_0_regacc_wt, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output [4:0]  io_cpu_0_regacc_idx, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output [63:0] io_cpu_0_regacc_wdata, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input  [63:0] io_cpu_0_regacc_rdata, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input         io_cpu_0_regacc_busy, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_cpu_0_inst64, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output [31:0] io_cpu_0_inst64_raw, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input         io_cpu_0_inst64_ready, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input         io_cpu_0_inst64_busy, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output        io_txd, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  input         io_rxd, // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
  output [7:0]  io_dbg_sta // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 924:16]
);
  wire  controller_ctrl_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_inited; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [1:0] controller_ctrl_io_cpu_0_priv; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_ext_itr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_stop_fetch; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_regacc_rd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_regacc_wt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [4:0] controller_ctrl_io_cpu_0_regacc_idx; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [63:0] controller_ctrl_io_cpu_0_regacc_wdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [63:0] controller_ctrl_io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_regacc_busy; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_inst64; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [31:0] controller_ctrl_io_cpu_0_inst64_raw; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_inst64_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_cpu_0_inst64_busy; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_tx_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_tx_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [7:0] controller_ctrl_io_tx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_rx_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  controller_ctrl_io_rx_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [7:0] controller_ctrl_io_rx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire [7:0] controller_ctrl_io_dbg_sta; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
  wire  tx_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire  tx_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire  tx_io_txd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire  tx_io_channel_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire  tx_io_channel_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire [7:0] tx_io_channel_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
  wire  rx_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire  rx_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire  rx_io_rxd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire  rx_io_channel_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire  rx_io_channel_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire [7:0] rx_io_channel_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
  wire  rxbuffer_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  rxbuffer_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  rxbuffer_io_enq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  rxbuffer_io_enq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire [7:0] rxbuffer_io_enq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  rxbuffer_io_deq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  rxbuffer_io_deq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire [7:0] rxbuffer_io_deq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
  wire  txbuffer_clock; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire  txbuffer_reset; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire  txbuffer_io_enq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire  txbuffer_io_enq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire [7:0] txbuffer_io_enq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire  txbuffer_io_deq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire  txbuffer_io_deq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  wire [7:0] txbuffer_io_deq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
  NulCPUCtrlMPMicrocode controller_ctrl ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 932:15]
    .clock(controller_ctrl_clock),
    .reset(controller_ctrl_reset),
    .io_cpu_0_inited(controller_ctrl_io_cpu_0_inited),
    .io_cpu_0_priv(controller_ctrl_io_cpu_0_priv),
    .io_cpu_0_ext_itr(controller_ctrl_io_cpu_0_ext_itr),
    .io_cpu_0_stop_fetch(controller_ctrl_io_cpu_0_stop_fetch),
    .io_cpu_0_regacc_rd(controller_ctrl_io_cpu_0_regacc_rd),
    .io_cpu_0_regacc_wt(controller_ctrl_io_cpu_0_regacc_wt),
    .io_cpu_0_regacc_idx(controller_ctrl_io_cpu_0_regacc_idx),
    .io_cpu_0_regacc_wdata(controller_ctrl_io_cpu_0_regacc_wdata),
    .io_cpu_0_regacc_rdata(controller_ctrl_io_cpu_0_regacc_rdata),
    .io_cpu_0_regacc_busy(controller_ctrl_io_cpu_0_regacc_busy),
    .io_cpu_0_inst64(controller_ctrl_io_cpu_0_inst64),
    .io_cpu_0_inst64_raw(controller_ctrl_io_cpu_0_inst64_raw),
    .io_cpu_0_inst64_ready(controller_ctrl_io_cpu_0_inst64_ready),
    .io_cpu_0_inst64_busy(controller_ctrl_io_cpu_0_inst64_busy),
    .io_tx_ready(controller_ctrl_io_tx_ready),
    .io_tx_valid(controller_ctrl_io_tx_valid),
    .io_tx_bits(controller_ctrl_io_tx_bits),
    .io_rx_ready(controller_ctrl_io_rx_ready),
    .io_rx_valid(controller_ctrl_io_rx_valid),
    .io_rx_bits(controller_ctrl_io_rx_bits),
    .io_dbg_sta(controller_ctrl_io_dbg_sta)
  );
  Tx tx ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 936:20]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 937:20]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  Queue_92 rxbuffer ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 938:26]
    .clock(rxbuffer_clock),
    .reset(rxbuffer_reset),
    .io_enq_ready(rxbuffer_io_enq_ready),
    .io_enq_valid(rxbuffer_io_enq_valid),
    .io_enq_bits(rxbuffer_io_enq_bits),
    .io_deq_ready(rxbuffer_io_deq_ready),
    .io_deq_valid(rxbuffer_io_deq_valid),
    .io_deq_bits(rxbuffer_io_deq_bits)
  );
  Queue_93 txbuffer ( // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 939:26]
    .clock(txbuffer_clock),
    .reset(txbuffer_reset),
    .io_enq_ready(txbuffer_io_enq_ready),
    .io_enq_valid(txbuffer_io_enq_valid),
    .io_enq_bits(txbuffer_io_enq_bits),
    .io_deq_ready(txbuffer_io_deq_ready),
    .io_deq_valid(txbuffer_io_deq_valid),
    .io_deq_bits(txbuffer_io_deq_bits)
  );
  assign io_cpu_0_ext_itr = controller_ctrl_io_cpu_0_ext_itr; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_stop_fetch = controller_ctrl_io_cpu_0_stop_fetch; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_regacc_rd = controller_ctrl_io_cpu_0_regacc_rd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_regacc_wt = controller_ctrl_io_cpu_0_regacc_wt; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_regacc_idx = controller_ctrl_io_cpu_0_regacc_idx; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_regacc_wdata = controller_ctrl_io_cpu_0_regacc_wdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_inst64 = controller_ctrl_io_cpu_0_inst64; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_cpu_0_inst64_raw = controller_ctrl_io_cpu_0_inst64_raw; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign io_txd = tx_io_txd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 944:12]
  assign io_dbg_sta = controller_ctrl_io_dbg_sta; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 941:16]
  assign controller_ctrl_clock = clock;
  assign controller_ctrl_reset = reset;
  assign controller_ctrl_io_cpu_0_inited = io_cpu_0_inited; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_cpu_0_priv = io_cpu_0_priv; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_cpu_0_regacc_rdata = io_cpu_0_regacc_rdata; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_cpu_0_regacc_busy = io_cpu_0_regacc_busy; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_cpu_0_inst64_ready = io_cpu_0_inst64_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_cpu_0_inst64_busy = io_cpu_0_inst64_busy; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 943:12]
  assign controller_ctrl_io_tx_ready = txbuffer_io_enq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 946:19]
  assign controller_ctrl_io_rx_valid = rxbuffer_io_deq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 947:19]
  assign controller_ctrl_io_rx_bits = rxbuffer_io_deq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 947:19]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = txbuffer_io_deq_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 949:21]
  assign tx_io_channel_bits = txbuffer_io_deq_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 949:21]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 945:15]
  assign rx_io_channel_ready = rxbuffer_io_enq_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 948:21]
  assign rxbuffer_clock = clock;
  assign rxbuffer_reset = reset;
  assign rxbuffer_io_enq_valid = rx_io_channel_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 948:21]
  assign rxbuffer_io_enq_bits = rx_io_channel_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 948:21]
  assign rxbuffer_io_deq_ready = controller_ctrl_io_rx_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 947:19]
  assign txbuffer_clock = clock;
  assign txbuffer_reset = reset;
  assign txbuffer_io_enq_valid = controller_ctrl_io_tx_valid; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 946:19]
  assign txbuffer_io_enq_bits = controller_ctrl_io_tx_bits; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 946:19]
  assign txbuffer_io_deq_ready = tx_io_channel_ready; // @[generators/riscv-boom/src/main/scala/v3/common/NulCtrlMP.scala 949:21]
endmodule
