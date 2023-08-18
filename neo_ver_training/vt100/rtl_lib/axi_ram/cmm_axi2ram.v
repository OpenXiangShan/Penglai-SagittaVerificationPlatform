module cmm_axi2ram #(
    parameter   RS_TMO  = 2,        //add full regslice on axi port
    parameter   C_ID    = 16,
    parameter   C_AW    = 32,
    parameter   C_DW    = 128,
    parameter   C_AUW   = 16,
    parameter   C_UW    = 16,
    parameter   C_RAW   = 14        //for single bank
)(
    /* Outputs */
    awready_s, wready_s, arready_s, rid_s,
    rdata_s, rlast_s, rvalid_s, rresp_s,
    bid_s, bresp_s, bvalid_s,
    r_addr, r_cs_n, r_we_n, r_bwe, r_din,
    /* Inputs */
    aclk_s, rst_n, awid_s, awuser_s,
    awaddr_s, awlen_s, awsize_s, awburst_s,
    awqos_s, awvalid_s, awcache_s, awprot_s,
    wdata_s, wlast_s, wstrb_s, wvalid_s,
    arid_s, aruser_s, araddr_s, arlen_s,
    arsize_s, arburst_s, arqos_s, arvalid_s,
    arcache_s, arprot_s, rready_s, bready_s,
    r_dout, r_rvld
);

    localparam AX_INFO_W = C_ID+C_AW+8+3+2;
    localparam W_INFO_W = C_DW+C_DW/8+1;
    localparam CMD_INFO_W = C_ID+C_RAW+1+1;
    localparam C_RDW = C_DW;
    localparam C_RDWE = C_RDW/8;
    localparam C_RCSW = 1;

    input                       aclk_s;
    input                       rst_n;
    input  [C_ID-1:0]           awid_s;
    input  [C_AUW-1:0]          awuser_s;
    input  [C_AW-1:0]           awaddr_s;
    input  [7:0]                awlen_s;
    input  [2:0]                awsize_s;
    input  [1:0]                awburst_s;
    input  [3:0]                awqos_s;
    input                       awvalid_s;
    input  [3:0]                awcache_s;
    input  [2:0]                awprot_s;
    input  [C_DW-1:0]           wdata_s;
    input                       wlast_s;
    input  [C_DW/8-1:0]         wstrb_s;
    input                       wvalid_s;
    input  [C_ID-1:0]           arid_s;
    input  [C_AUW-1:0]          aruser_s;
    input  [C_AW-1:0]           araddr_s;
    input  [7:0]                arlen_s;
    input  [2:0]                arsize_s;
    input  [1:0]                arburst_s;
    input  [3:0]                arqos_s;
    input                       arvalid_s;
    input  [3:0]                arcache_s;
    input  [2:0]                arprot_s;
    input                       rready_s;
    input                       bready_s;

    output                      awready_s;
    output                      wready_s;
    output                      arready_s;
    output [C_ID-1:0]           rid_s;
    output [C_DW-1:0]           rdata_s;
    output                      rlast_s;
    output                      rvalid_s;
    output [1:0]                rresp_s;
    output [C_ID-1:0]           bid_s;
    output [1:0]                bresp_s;
    output                      bvalid_s;

    output [C_RAW*C_RCSW-1:0]   r_addr;
    output [C_RCSW-1:0]         r_cs_n;
    output [C_RDW*C_RCSW/8-1:0] r_bwe;
    output [C_RCSW-1:0]         r_we_n;
    input  [C_RDW*C_RCSW-1:0]   r_dout;
    input  [C_RCSW-1:0]         r_rvld;
    output [C_RDW*C_RCSW-1:0]   r_din;

    wire                        arch_empty;
    wire                        arch_pop;
    wire                        awch_empty;
    wire                        awch_pop;
    wire                        bch_full;
    wire                        bch_push;
    wire                        rch_full;
    wire                        rch_push;
    wire                        wch_empty;
    wire                        wch_pop;
    wire [AX_INFO_W-1:0]        awch_info;
    wire [W_INFO_W-1:0]         wch_info;
    wire [C_ID+2-1:0]           bch_info;
    wire [AX_INFO_W-1:0]        arch_info;
    wire [C_ID+C_DW+2+1-1:0]    rch_info;
    wire                        wr_ram_cmd_full;
    wire                        wr_ram_cmd_push;
    wire [CMD_INFO_W-1:0]       wr_ram_cmd_info;
    wire                        rd_ram_cmd_full;
    wire                        rd_ram_cmd_push;
    wire [CMD_INFO_W-1:0]       rd_ram_cmd_info;
    wire                        wr_ram_wr_ack;
    wire                        wr_ram_wr_req;
    wire [C_RAW:0]              wr_ram_addr;    //actual width is C_RAW+1, bit0 use to interleave
    wire [C_ID-1:0]             wr_axi_id;
    wire                        rd_ram_rd_ack;
    wire                        rd_ram_rd_req;
    wire [C_RAW:0]              rd_ram_addr;    //actual width is C_RAW+1, bit0 use to interleave
    wire [C_ID-1:0]             rd_axi_id;
    wire                        rd_axi_last;
    wire                        ram0_wr_req;
    wire                        ram0_rd_req;
    wire                        ram0_wr_ack;
    wire                        ram0_rd_ack;
    wire                        ram1_wr_req;
    wire                        ram1_rd_req;
    wire                        ram1_wr_ack;
    wire                        ram1_rd_ack;

    wire [C_ID-1:0]             awid_s_inner;
    wire [C_AUW-1:0]            awuser_s_inner;
    wire [C_AW-1:0]             awaddr_s_inner;
    wire [7:0]                  awlen_s_inner;
    wire [2:0]                  awsize_s_inner;
    wire [1:0]                  awburst_s_inner;
    wire [3:0]                  awqos_s_inner;
    wire                        awvalid_s_inner;
    wire [3:0]                  awcache_s_inner;
    wire [2:0]                  awprot_s_inner;
    wire [C_DW-1:0]             wdata_s_inner;
    wire                        wlast_s_inner;
    wire [C_DW/8-1:0]           wstrb_s_inner;
    wire                        wvalid_s_inner;
    wire [C_ID-1:0]             arid_s_inner;
    wire [C_AUW-1:0]            aruser_s_inner;
    wire [C_AW-1:0]             araddr_s_inner;
    wire [7:0]                  arlen_s_inner;
    wire [2:0]                  arsize_s_inner;
    wire [1:0]                  arburst_s_inner;
    wire [3:0]                  arqos_s_inner;
    wire                        arvalid_s_inner;
    wire [3:0]                  arcache_s_inner;
    wire [2:0]                  arprot_s_inner;
    wire                        rready_s_inner;
    wire                        bready_s_inner;
    wire                        awready_s_inner;
    wire                        wready_s_inner;
    wire                        arready_s_inner;
    wire [C_ID-1:0]             rid_s_inner;
    wire [C_DW-1:0]             rdata_s_inner;
    wire                        rlast_s_inner;
    wire                        rvalid_s_inner;
    wire [1:0]                  rresp_s_inner;
    wire [C_ID-1:0]             bid_s_inner;
    wire [1:0]                  bresp_s_inner;
    wire                        bvalid_s_inner;
    /*------------------------------------------------*/
    /*  Instance of AXI Regslice                      */
    /*------------------------------------------------*/
    axi_reg_slice #(
	    .AW_TMO     (RS_TMO),
	    .AR_TMO     (RS_TMO),
	    .R_TMO      (RS_TMO),
	    .W_TMO      (RS_TMO),
	    .B_TMO      (RS_TMO),
    	.DW			(C_DW),
    	.AW			(C_AW),
    	.SW			(C_DW/8),
    	.LW			(8),
    	.IDW		(C_ID),
        .AWUW		(C_AUW),
        .ARUW		(C_AUW),
    	.RUW		(C_UW),
    	.WUW		(C_UW),
    	.BUW		(C_UW)
    ) u_axi_reg_slice_i (
    	// Write address channel
    	.awid_m						        (awid_s),
    	.awaddr_m						    (awaddr_s),
    	.awlen_m						    (awlen_s),
    	.awsize_m						    (awsize_s),
    	.awburst_m						    (awburst_s),
    	.awlock_m						    (1'b0),
    	.awcache_m						    (awcache_s),
    	.awprot_m						    (awprot_s),
    	.awvalid_m						    (awvalid_s),
    	.awready_s						    (awready_s_inner),
        .awuser_m						    (awuser_s),
    	.awqos_m						    (awqos_s),
    	.awid_s						        (awid_s_inner),
    	.awaddr_s						    (awaddr_s_inner),
    	.awlen_s						    (awlen_s_inner),
    	.awsize_s						    (awsize_s_inner),
    	.awburst_s						    (awburst_s_inner),
    	.awlock_s						    (),
    	.awcache_s						    (awcache_s_inner),
    	.awprot_s						    (awprot_s_inner),
    	.awvalid_s						    (awvalid_s_inner),
    	.awready_m						    (awready_s),
        .awuser_s						    (awuser_s_inner),
    	.awqos_s						    (awqos_s_inner),
    	// Read address channel
    	.arid_m						        (arid_s),
    	.araddr_m						    (araddr_s),
    	.arlen_m						    (arlen_s),
    	.arsize_m						    (arsize_s),
    	.arburst_m						    (arburst_s),
    	.arlock_m						    (1'b0),
    	.arcache_m						    (arcache_s),
    	.arprot_m						    (arprot_s),
    	.arvalid_m						    (arvalid_s),
    	.arready_s						    (arready_s_inner),
        .aruser_m						    (aruser_s),
    	.arqos_m						    (arqos_s),
    	.arid_s						        (arid_s_inner),
    	.araddr_s						    (araddr_s_inner),
    	.arlen_s						    (arlen_s_inner),
    	.arsize_s						    (arsize_s_inner),
    	.arburst_s						    (arburst_s_inner),
    	.arlock_s						    (),
    	.arcache_s						    (arcache_s_inner),
    	.arprot_s						    (arprot_s_inner),
    	.arvalid_s						    (arvalid_s_inner),
    	.arready_m						    (arready_s),
        .aruser_s						    (aruser_s_inner),
    	.arqos_s						    (arqos_s_inner),
    	.wid_m						        ({C_ID{1'b0}}),
    	.wdata_m						    (wdata_s),
    	.wstrb_m						    (wstrb_s),
    	.wlast_m						    (wlast_s),
    	.wvalid_m						    (wvalid_s),
    	.wready_s						    (wready_s_inner),
    	.wuser_m						    ({C_UW{1'b0}}),
    	.wid_s						        (),
    	.wdata_s						    (wdata_s_inner),
    	.wstrb_s						    (wstrb_s_inner),
    	.wlast_s						    (wlast_s_inner),
    	.wvalid_s						    (wvalid_s_inner),
    	.wready_m						    (wready_s),
    	.wuser_s						    (),
    	.bid_s						        (bid_s_inner),
    	.bresp_s						    (bresp_s_inner),
    	.bvalid_s						    (bvalid_s_inner),
    	.bready_m						    (bready_s),
    	.buser_s						    ({C_UW{1'b0}}),
    	.bid_m						        (bid_s),
    	.bresp_m						    (bresp_s),
    	.bvalid_m						    (bvalid_s),
    	.bready_s						    (bready_s_inner),
    	.buser_m						    (),
    	.rid_s						        (rid_s_inner),
    	.rdata_s						    (rdata_s_inner),
    	.rresp_s						    (rresp_s_inner),
    	.rlast_s						    (rlast_s_inner),
    	.rvalid_s						    (rvalid_s_inner),
    	.rready_m						    (rready_s),
    	.ruser_s						    ({C_UW{1'b0}}),
    	.rid_m						        (rid_s),
    	.rdata_m						    (rdata_s),
    	.rresp_m						    (rresp_s),
    	.rlast_m						    (rlast_s),
    	.rvalid_m						    (rvalid_s),
    	.rready_s						    (rready_s_inner),
    	.ruser_m						    (),
    	.aclk                               (aclk_s),
    	.aresetn                            (rst_n));

    /*------------------------------------------------*/
    /*  Top connect logic and 2 banks interleave      */
    /*------------------------------------------------*/
    /*  ram rw arbitor  */
    assign ram0_wr_req = wr_ram_wr_req & ~wr_ram_addr[0];
    assign ram0_rd_req = rd_ram_rd_req & ~rd_ram_addr[0];
    assign ram1_wr_req = wr_ram_wr_req & wr_ram_addr[0];
    assign ram1_rd_req = rd_ram_rd_req & rd_ram_addr[0];
    assign wr_ram_wr_ack = ram0_wr_ack | ram1_wr_ack;
    assign rd_ram_rd_ack = ram0_rd_ack | ram1_rd_ack;

    /*  ram port  */
    assign r_addr[C_RAW-1:0] = (wr_ram_addr[1+:C_RAW] & {C_RAW{ram0_wr_ack}}) | (rd_ram_addr[1+:C_RAW] & {C_RAW{ram0_rd_ack}});
    //assign r_addr[C_RAW+:C_RAW] = (wr_ram_addr[1+:C_RAW] & {C_RAW{ram1_wr_ack}}) | (rd_ram_addr[1+:C_RAW] & {C_RAW{ram1_rd_ack}});
    assign r_cs_n[0] = ~(ram0_wr_ack | ram0_rd_ack);
    assign r_cs_n[C_RCSW-1] = ~(ram1_wr_ack | ram1_rd_ack);
    assign r_bwe[C_RDWE-1:0] = (wch_info[C_RDWE-1:0] & {(C_RDWE){ram0_wr_ack}});
    //assign r_bwe[C_RDWE+:C_RDWE] = (wch_info[C_RDWE-1:0] & {(C_RDWE){ram1_wr_ack}});
    assign r_we_n[0] = ~ram0_wr_ack;
    assign r_we_n[C_RCSW-1] = ~ram1_wr_ack;
    assign r_din[C_RDW-1:0] = wch_info[C_RDWE+:C_RDW] & {(C_RDW){ram0_wr_ack}};
    //assign r_din[C_RDW+:C_RDW] = wch_info[C_RDWE+:C_RDW] & {(C_RDW){ram1_wr_ack}};

    /*  AXI slave port wch  */
    assign wch_pop = wr_ram_wr_ack;

    /*  AXI slave port rch  */
    wire [C_RDW-1:0]        ram_data;
    assign ram_data = {C_RDW{r_rvld[0]}} & r_dout[C_RDW-1:0] | {C_RDW{r_rvld[1]}} & r_dout[C_RDW+:C_RDW];
    assign rch_info = {rd_axi_id, ram_data, 2'h0, rd_axi_last};
    assign rch_push = |r_rvld;

    /*  AXI slave port bch  */
    assign bch_info = {wr_axi_id, 2'h0};
    assign bch_push = wr_ram_wr_ack & wch_info[W_INFO_W-1];

    /*------------------------------------------------*/
    /*  AXI slave port interface instance             */
    /*------------------------------------------------*/
    axi_slave_if #(
        .C_AW           (C_AW),
        .C_AUW          (C_AUW),
        .C_UW           (C_UW),
        .C_ID           (C_ID),
        .C_DW           (C_DW)
    )u_axi_slave_if(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .awid_s                         (awid_s_inner[C_ID-1:0]                     ), // input
        .awuser_s                       (awuser_s_inner[C_AUW-1:0]                  ), // input
        .awaddr_s                       (awaddr_s_inner[C_AW-1:0]                   ), // input
        .awlen_s                        (awlen_s_inner[7:0]                         ), // input
        .awsize_s                       (awsize_s_inner[2:0]                        ), // input
        .awburst_s                      (awburst_s_inner[1:0]                       ), // input
        .awqos_s                        (awqos_s_inner[3:0]                         ), // input
        .awvalid_s                      (awvalid_s_inner                            ), // input
        .awcache_s                      (awcache_s_inner[3:0]                       ), // input
        .awprot_s                       (awprot_s_inner[2:0]                        ), // input
        .wdata_s                        (wdata_s_inner[C_DW-1:0]                    ), // input
        .wlast_s                        (wlast_s_inner                              ), // input
        .wstrb_s                        (wstrb_s_inner[C_DW/8-1:0]                  ), // input
        .wvalid_s                       (wvalid_s_inner                             ), // input
        .arid_s                         (arid_s_inner[C_ID-1:0]                     ), // input
        .aruser_s                       (aruser_s_inner[C_AUW-1:0]                  ), // input
        .araddr_s                       (araddr_s_inner[C_AW-1:0]                   ), // input
        .arlen_s                        (arlen_s_inner[7:0]                         ), // input
        .arsize_s                       (arsize_s_inner[2:0]                        ), // input
        .arburst_s                      (arburst_s_inner[1:0]                       ), // input
        .arqos_s                        (arqos_s_inner[3:0]                         ), // input
        .arvalid_s                      (arvalid_s_inner                            ), // input
        .arcache_s                      (arcache_s_inner[3:0]                       ), // input
        .arprot_s                       (arprot_s_inner[2:0]                        ), // input
        .rready_s                       (rready_s_inner                             ), // input
        .bready_s                       (bready_s_inner                             ), // input
        .awready_s                      (awready_s_inner                            ), // output
        .wready_s                       (wready_s_inner                             ), // output
        .arready_s                      (arready_s_inner                            ), // output
        .rid_s                          (rid_s_inner[C_ID-1:0]                      ), // output
        .rdata_s                        (rdata_s_inner[C_DW-1:0]                    ), // output
        .rvalid_s                       (rvalid_s_inner                             ), // output
        .rlast_s                        (rlast_s_inner                              ), // output
        .rresp_s                        (rresp_s_inner[1:0]                         ), // output
        .bid_s                          (bid_s_inner[C_ID-1:0]                      ), // output
        .bresp_s                        (bresp_s_inner[1:0]                         ), // output
        .bvalid_s                       (bvalid_s_inner                             ), // output
        .awch_pop                       (awch_pop                                   ), // input
        .awch_empty                     (awch_empty                                 ), // output
        .awch_info_o                    (awch_info[AX_INFO_W-1:0]                   ), // output
        .wch_pop                        (wch_pop                                    ), // input
        .wch_empty                      (wch_empty                                  ), // output
        .wch_info_o                     (wch_info[W_INFO_W-1:0]                     ), // output
        .bch_info_i                     (bch_info[C_ID+2-1:0]                       ), // input
        .bch_push                       (bch_push                                   ), // input
        .bch_full                       (bch_full                                   ), // output
        .arch_pop                       (arch_pop                                   ), // input
        .arch_empty                     (arch_empty                                 ), // output
        .arch_info_o                    (arch_info[AX_INFO_W-1:0]                   ), // output
        .rch_info_i                     (rch_info[C_ID+C_DW+2+1-1:0]                ), // input
        .rch_push                       (rch_push                                   ), // input
        .rch_full                       (rch_full                                   )  // output
    );

    /*------------------------------------------------*/
    /*  AXI write address gen instance                */
    /*------------------------------------------------*/
    axi2ram_addr_gen #(
        .C_AW               (C_AW),
        .C_ID               (C_ID),
        .C_RAM_AW           (C_RAW),
        .C_RDW              (C_RDW)
    )u_wr_axi2ram_addr_gen(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .axch_info                      (awch_info[AX_INFO_W-1:0]                   ), // input
        .axch_empty                     (awch_empty                                 ), // input
        .ram_cmd_full                   (wr_ram_cmd_full                            ), // input
        .axch_pop                       (awch_pop                                   ), // output
        .ram_cmd_push                   (wr_ram_cmd_push                            ), // output
        .ram_cmd_info                   (wr_ram_cmd_info[CMD_INFO_W-1:0]            )  // output
    );

    /*------------------------------------------------*/
    /*  AXI read address gen instance                 */
    /*------------------------------------------------*/
    axi2ram_addr_gen #(
        .C_AW               (C_AW),
        .C_ID               (C_ID),
        .C_RAM_AW           (C_RAW),
        .C_RDW              (C_RDW)
    )u_rd_axi2ram_addr_gen(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .axch_info                      (arch_info[AX_INFO_W-1:0]                   ), // input
        .axch_empty                     (arch_empty                                 ), // input
        .ram_cmd_full                   (rd_ram_cmd_full                            ), // input
        .axch_pop                       (arch_pop                                   ), // output
        .ram_cmd_push                   (rd_ram_cmd_push                            ), // output
        .ram_cmd_info                   (rd_ram_cmd_info[CMD_INFO_W-1:0]            )  // output
    );

    /*------------------------------------------------*/
    /*  ram write cmd fifo instance                   */
    /*------------------------------------------------*/
    ram_wcmd_fifo #(
        .C_ID               (C_ID),
        .C_RAM_AW           (C_RAW)
    )u_ram_wcmd_fifo(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .ram_cmd_info_i                 (wr_ram_cmd_info                            ), // input
        .ram_cmd_push                   (wr_ram_cmd_push                            ), // input
        .ram_wr_ack                     (wr_ram_wr_ack                              ), // input
        .bresp_fifo_full                (bch_full                                   ), // input
        .ram_cmd_full                   (wr_ram_cmd_full                            ), // output
        .ram_wr_req                     (wr_ram_wr_req                              ), // output
        .ram_addr                       (wr_ram_addr                                ), // output
        .axi_id                         (wr_axi_id                                  )  // output
    );

    /*------------------------------------------------*/
    /*  ram read cmd fifo instance                    */
    /*------------------------------------------------*/
    ram_rcmd_fifo #(
        .C_ID               (C_ID),
        .C_RAM_AW           (C_RAW)
    )u_ram_rcmd_fifo(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .ram_cmd_info_i                 (rd_ram_cmd_info                            ), // input
        .ram_cmd_push                   (rd_ram_cmd_push                            ), // input
        .ram_rd_ack                     (rd_ram_rd_ack                              ), // input
        .rdata_fifo_full                (rch_full                                   ), // input
        .ram_vld                        (|r_rvld                                    ), // input
        .ram_cmd_full                   (rd_ram_cmd_full                            ), // output
        .ram_rd_req                     (rd_ram_rd_req                              ), // output
        .ram_addr                       (rd_ram_addr                                ), // output
        .axi_id                         (rd_axi_id                                  ), // output
        .axi_last                       (rd_axi_last                                )  // output
    );

    /*------------------------------------------------*/
    /*  ram bank0 wr/rd arbiter instance              */
    /*------------------------------------------------*/
    ram_rw_arb u_ram0_rw_arb(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .ram_wr_req                     (ram0_wr_req                                ), // input
        .ram_wdata_ready                (~wch_empty                                 ), // input
        .ram_rd_req                     (ram0_rd_req                                ), // input
        .ram_wr_ack                     (ram0_wr_ack                                ), // output
        .ram_rd_ack                     (ram0_rd_ack                                )  // output
    );

    /*------------------------------------------------*/
    /*  ram bank1 wr/rd arbiter instance              */
    /*------------------------------------------------*/
    ram_rw_arb u_ram1_rw_arb(/*autoinst*/
        .aclk_s                         (aclk_s                                     ), // input
        .rst_n                          (rst_n                                      ), // input
        .ram_wr_req                     (ram1_wr_req                                ), // input
        .ram_wdata_ready                (~wch_empty                                 ), // input
        .ram_rd_req                     (ram1_rd_req                                ), // input
        .ram_wr_ack                     (ram1_wr_ack                                ), // output
        .ram_rd_ack                     (ram1_rd_ack                                )  // output
    );


endmodule
