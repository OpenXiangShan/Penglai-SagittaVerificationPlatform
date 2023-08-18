///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Filename     :  sad_top.v
/// Date         :  2022-01-12
/// Version      :  1.0
/// 
/// Module Name  :  sad_top
/// Abstract     :  连续sad计算顶层模块      
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module sad_top
(
    input               clk,   
    input               rst_n,
    input               apb_pclk,
    input               aclk_s,
    //apb
    input               apb_psel,
    input               apb_penable,
    input               apb_pwrite,
    input       [  5:0] apb_paddr,
    input       [ 31:0] apb_pwdata,
    output wire         apb_pready,
    output wire [ 31:0] apb_prdata,
    output wire         apb_pslverr,
    //axi
    input       [ 15:0] awid_s,
    input       [ 15:0] awuser_s,
    input       [ 31:0] awaddr_s,
    input       [  7:0] awlen_s,
    input       [  2:0] awsize_s,
    input       [  1:0] awburst_s,
    input       [  3:0] awqos_s,
    input               awvalid_s,
    input       [  3:0] awcache_s,
    input       [  2:0] awprot_s,
    input       [ 63:0] wdata_s,
    input               wlast_s,
    input       [  7:0] wstrb_s,
    input               wvalid_s,
    input       [ 15:0] arid_s,
    input       [ 15:0] aruser_s,
    input       [ 31:0] araddr_s,
    input       [  7:0] arlen_s,
    input       [  2:0] arsize_s,
    input       [  1:0] arburst_s,
    input       [  3:0] arqos_s,
    input               arvalid_s,
    input       [  3:0] arcache_s,
    input       [  2:0] arprot_s,
    input               rready_s,
    input               bready_s,
    output wire         awready_s,
    output wire         wready_s,
    output wire         arready_s,
    output wire [ 15:0] rid_s,
    output wire [ 63:0] rdata_s,
    output wire         rlast_s,
    output wire         rvalid_s,
    output wire [  1:0] rresp_s,
    output wire [ 15:0] bid_s,
    output wire [  1:0] bresp_s,
    output wire         bvalid_s,
    //interrupt
    output wire [15:0] cal_rdata,
    output wire [4:0]  cal_id,
    output wire        cal_valid, 
    output wire         cal_int_out
);
//================================inner module output wire
//----apb2hst
wire [  3:0] hst_sel;
wire [  5:0] hst_addr;
wire         hst_wen;
wire [ 31:0] hst_wdat;
//----register
sub_register_if #(.ADDR_WIDTH(6)) u_register_if(.clk(clk),.rst_n(rst_n));
//----axi2ram
wire [ 10:0] r_addr;
wire         r_cs_n;
wire         r_we_n;
wire [ 63:0] r_din;
//----cal_ctrl
wire         cal_busy_state;
wire         int_state;
wire [ 15:0] total_cnt;
wire         sad_vld_in;
wire [127:0] sad_din1;
wire [127:0] sad_din2;
wire         inner_sram_we_n;
wire [ 10:0] inner_sram_waddr;
wire [ 63:0] inner_sram_wdata;
wire         inner_sram_rd_n;
wire [ 10:0] inner_sram_raddr;
wire         axi2ram_rvld;
wire [ 63:0] axi2ram_rdata;
//wire         cal_int_out;
//----sad core
wire         sad_vld;
wire [ 15:0] sad;
//----inner sram
wire         init_done_a;
wire [ 63:0] data_out_b;


cmm_apb2hst #(
    .C_AW(6)
) u_apb2reg (
    .apb_pclk (clk),
    .apb_presetn (rst_n),
    .apb_psel (apb_psel),
    .apb_penable (apb_penable),
    .apb_pwrite (apb_pwrite),
    .apb_pprot (3'b000),
    .apb_paddr (apb_paddr),
    .apb_pwdata (apb_pwdata),
    .apb_pwstrb (4'b0000),
    .apb_pready (apb_pready),
    .apb_prdata (apb_prdata),
    .apb_pslverr (apb_pslverr),
    .hst_sel (hst_sel),
    .hst_addr (hst_addr),
    .hst_wen (hst_wen),
    .hst_wdat (hst_wdat),
    .hst_rack (1'b0),
    .hst_rdat (u_register_if.rd_data) 
);

assign u_register_if.wr_sel = hst_sel;
assign u_register_if.wr_rd = hst_wen;
assign u_register_if.wr_addr = hst_addr;
assign u_register_if.wr_data = hst_wdat;
assign u_register_if.f_cal_state_is_busy_in = cal_busy_state;
assign u_register_if.f_int_status_status_in = int_state;
assign u_register_if.f_total_cnt_counter_in = total_cnt;
sub_register_reg #(
    .REG_WIDTH(32),
    .ADDR_WIDTH(6)
) u_reg (  
    .register_if_slave (u_register_if.SLAVE),
    .register_if_regs (u_register_if.REGS)        
);

cmm_axi2ram #(
    .C_DW (64),
    .C_RAW (11)
) u_axi2ram (
    .aclk_s (aclk_s),
    .rst_n (rst_n),
    .awid_s (awid_s),
    .awuser_s (awuser_s),
    .awaddr_s (awaddr_s),
    .awlen_s (awlen_s),
    .awsize_s (awsize_s),
    .awburst_s (awburst_s),
    .awqos_s (awqos_s),
    .awvalid_s (awvalid_s),
    .awcache_s (awcache_s),
    .awprot_s (awprot_s),
    .wdata_s (wdata_s),
    .wlast_s (wlast_s),
    .wstrb_s (wstrb_s),
    .wvalid_s (wvalid_s),
    .arid_s (arid_s),
    .aruser_s (aruser_s),
    .araddr_s (araddr_s),
    .arlen_s (arlen_s),
    .arsize_s (arsize_s),
    .arburst_s (arburst_s),
    .arqos_s (arqos_s),
    .arvalid_s (arvalid_s),
    .arcache_s (arcache_s),
    .arprot_s (arprot_s),
    .rready_s (rready_s),
    .bready_s (bready_s),
    .awready_s (awready_s),
    .wready_s (wready_s),
    .arready_s (arready_s),
    .rid_s (rid_s),
    .rdata_s (rdata_s),
    .rlast_s (rlast_s),
    .rvalid_s (rvalid_s),
    .rresp_s (rresp_s),
    .bid_s (bid_s),
    .bresp_s (bresp_s),
    .bvalid_s (bvalid_s),
    .r_addr (r_addr),
    .r_cs_n (r_cs_n),
    .r_bwe (),//float
    .r_we_n (r_we_n),
    .r_dout (axi2ram_rdata),
    .r_rvld (axi2ram_rvld),
    .r_din (r_din) 
);

cal_ctrl u_cal_ctrl (
    .clk (clk),
    .rst_n (rst_n),
    .cal_start (u_register_if.f_cal_start_start_en_out),
    .cal_num (u_register_if.f_cal_num_quantity_out),
    .cal_busy_state (cal_busy_state),
    .int_set_en (u_register_if.f_int_enable_enable_out),
    .int_set_value (u_register_if.f_int_set_set_value_out),
    .int_en (u_register_if.f_int_set_set_enable_out),
    .int_state_rd (u_register_if.f_int_status_status_rd),
    .int_state( int_state),
    .int_mask (u_register_if.f_int_mask_mask_out),
    .total_cnt_flag (u_register_if.f_total_cnt_flag_flag_out),
    .total_cnt_rd (u_register_if.f_total_cnt_counter_rd),
    .cal_ready(u_register_if.f_cal_ready_ready_out),
    .total_cnt (total_cnt),
    .sad_vld_in (sad_vld_in),
    .sad_din1 (sad_din1),
    .sad_din2 (sad_din2),
    .sad_vld_out (sad_vld),
    .sad_dout (sad),
    .inner_sram_we_n (inner_sram_we_n),
    .inner_sram_waddr (inner_sram_waddr),
    .inner_sram_wdata (inner_sram_wdata),
    .inner_sram_rd_n (inner_sram_rd_n),
    .inner_sram_raddr (inner_sram_raddr),
    .inner_sram_rdata (data_out_b),
    .axi2ram_cs_n (r_cs_n),
    .axi2ram_we_n (r_we_n),
    .axi2ram_addr (r_addr),
    .axi2ram_wdata (r_din),
    .axi2ram_rvld(axi2ram_rvld),
    .axi2ram_rdata (axi2ram_rdata),
    .cal_rdata(cal_rdata),
    .cal_id(cal_id),
    .cal_valid(cal_valid),
    .cal_int_out (cal_int_out) 
);

codec_cmm_sad #(
    .DW(8),
    .W(16),
    .H(16)
) u_sad (
    .clk (clk),
    .rst_n (rst_n),
    .input_vld (sad_vld_in),
    .input_data1 (sad_din1),
    .input_data2 (sad_din2),
    .sad_vld (sad_vld),
    .sad (sad) 
);

rf_1r1w_wrapper #(
    .READ_DELAY (1),
    .ADDR_WIDTH (11),
    .DATA_WIDTH (64) 
) u_inner_sram ( 
    .rst_n_a (rst_n),
    .clk_a (apb_pclk),
    .init_start_a (1'b0),
    .init_done_a (init_done_a),
    .we_n_a (inner_sram_we_n),
    .addr_a (inner_sram_waddr),
    .data_in_a (inner_sram_wdata),
    .rst_n_b (rst_n),
    .clk_b (clk),
    .rd_n_b (inner_sram_rd_n),
    .addr_b (inner_sram_raddr),
    .data_out_b (data_out_b) 
);

endmodule
