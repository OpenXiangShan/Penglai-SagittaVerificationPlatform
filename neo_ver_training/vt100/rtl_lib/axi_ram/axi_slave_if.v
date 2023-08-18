module axi_slave_if #(
    parameter   C_AW = 32,
    parameter   C_AUW = 16,
    parameter   C_UW = 16,
    parameter   C_ID = 16,
    parameter   C_DW = 128
)(
    /* Outputs */
    awready_s, wready_s, arready_s,
    rid_s, rdata_s, rlast_s,
    rvalid_s, rresp_s, bid_s,
    bresp_s, bvalid_s,
    awch_empty, awch_info_o, wch_info_o,
    arch_info_o, arch_empty, bch_full, wch_empty,
    rch_full,
    /* Inputs */
    aclk_s, rst_n,
    awid_s, awuser_s, awaddr_s,
    awlen_s, awsize_s, awburst_s,
    awqos_s, awvalid_s, awcache_s,
    awprot_s, wdata_s, wlast_s,
    wstrb_s, wvalid_s, arid_s,
    aruser_s, araddr_s, arlen_s,
    arsize_s, arburst_s, arqos_s,
    arvalid_s, arcache_s, arprot_s,
    rready_s, bready_s, awch_pop, wch_pop,
    bch_info_i, bch_push,
    arch_pop, rch_info_i, rch_push
);

    localparam AX_INFO_W = C_ID+C_AW+8+3+2;
    localparam W_INFO_W = C_DW+C_DW/8+1;

    input                   aclk_s;
    input                   rst_n;
    input [C_ID-1:0]        awid_s;
    input [C_AUW-1:0]       awuser_s;
    input [C_AW-1:0]        awaddr_s;
    input [7:0]             awlen_s;
    input [2:0]             awsize_s;
    input [1:0]             awburst_s;
    input [3:0]             awqos_s;
    input                   awvalid_s;
    input [3:0]             awcache_s;
    input [2:0]             awprot_s;
    input [C_DW-1:0]        wdata_s;
    input                   wlast_s;
    input [C_DW/8-1:0]      wstrb_s;
    input                   wvalid_s;
    input [C_ID-1:0]        arid_s;
    input [C_AUW-1:0]       aruser_s;
    input [C_AW-1:0]        araddr_s;
    input [7:0]             arlen_s;
    input [2:0]             arsize_s;
    input [1:0]             arburst_s;
    input [3:0]             arqos_s;
    input                   arvalid_s;
    input [3:0]             arcache_s;
    input [2:0]             arprot_s;
    input                   rready_s;
    input                   bready_s;

    output                  awready_s;
    output                  wready_s;
    output                  arready_s;
    output [C_ID-1:0]       rid_s;
    output [C_DW-1:0]       rdata_s;
    output                  rvalid_s;
    output                  rlast_s;
    output [1:0]            rresp_s;
    output [C_ID-1:0]       bid_s;
    output [1:0]            bresp_s;
    output                  bvalid_s;

    input                   awch_pop;
    output                  awch_empty;
    output [AX_INFO_W-1:0]  awch_info_o;      //id_addr_len_size_burst
    input                   wch_pop;
    output                  wch_empty;
    output [W_INFO_W-1:0]   wch_info_o;
    input [C_ID+2-1:0]      bch_info_i;
    input                   bch_push;
    output                  bch_full;
    input                   arch_pop;
    output                  arch_empty;
    output [AX_INFO_W-1:0]  arch_info_o;      //id_addr_len_size_burst
    input [C_ID+C_DW+2+1-1:0]rch_info_i;
    input                   rch_push;
    output                  rch_full;

    /*---------------------------------------------------*/
    /*  Instance axi awch fifo and generate awch output  */
    /*---------------------------------------------------*/
    wire [AX_INFO_W-1:0]    awch_info_i;
    wire                    awch_push;
    wire                    awch_full;

    assign awch_push = awvalid_s & awready_s;
    assign awready_s = ~awch_full;
    assign awch_info_i = {awid_s, awaddr_s, awlen_s, awsize_s, awburst_s};
    cmm_sfifo #(
        .C_HF       (4),
        .C_HAF      (2),
        .C_AW       (2),
        .C_DW       (AX_INFO_W)
    ) u_awch_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (awch_push),
        .pop                (awch_pop),
        .din                (awch_info_i),
        .dout               (awch_info_o),
        .full               (awch_full),
        .awfull             (),
        .empty              (awch_empty)
    );

    /*---------------------------------------------------*/
    /*  Instance axi wch fifo and generate wch output    */
    /*---------------------------------------------------*/
    wire [W_INFO_W-1:0]     wch_info_i;
    wire                    wch_push;
    wire                    wch_full;

    assign wch_push = wvalid_s & wready_s;
    assign wready_s = ~wch_full;
    assign wch_info_i = {wlast_s, wdata_s, wstrb_s};
    cmm_sfifo #(
        .C_HF       (16),
        .C_HAF      (8),
        .C_AW       (4),
        .C_DW       (W_INFO_W)
    ) u_wch_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (wch_push),
        .pop                (wch_pop),
        .din                (wch_info_i),
        .dout               (wch_info_o),
        .full               (wch_full),
        .awfull             (),
        .empty              (wch_empty)
    );

    /*---------------------------------------------------*/
    /*  Instance axi bch fifo and generate bch output    */
    /*---------------------------------------------------*/
    wire                    bch_pop;
    wire                    bch_empty;
    wire [C_ID+2-1:0]       bch_info_o;

    assign bch_pop = bvalid_s & bready_s;
    assign bvalid_s = ~bch_empty;
    assign {bid_s, bresp_s} = bch_info_o;
    cmm_sfifo #(
        .C_HF       (4),
        .C_HAF      (2),
        .C_AW       (2),
        .C_DW       (C_ID+2)
    ) u_bch_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (bch_push),
        .pop                (bch_pop),
        .din                (bch_info_i),
        .dout               (bch_info_o),
        .full               (bch_full),
        .awfull             (),
        .empty              (bch_empty)
    );

    /*---------------------------------------------------*/
    /*  Instance axi arch fifo and generate arch output  */
    /*---------------------------------------------------*/
    wire [AX_INFO_W-1:0]    arch_info_i;
    wire                    arch_push;
    wire                    arch_full;

    assign arch_push = arvalid_s & arready_s;
    assign arready_s = ~arch_full;
    assign arch_info_i = {arid_s, araddr_s, arlen_s, arsize_s, arburst_s};
    cmm_sfifo #(
        .C_HF       (4),
        .C_HAF      (2),
        .C_AW       (2),
        .C_DW       (AX_INFO_W)
    ) u_arch_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (arch_push),
        .pop                (arch_pop),
        .din                (arch_info_i),
        .dout               (arch_info_o),
        .full               (arch_full),
        .awfull             (),
        .empty              (arch_empty)
    );

    /*---------------------------------------------------*/
    /*  Instance axi rch fifo and generate rch output    */
    /*---------------------------------------------------*/
    wire                    rch_pop;
    wire                    rch_empty;
    wire [C_ID+C_DW+2+1-1:0]  rch_info_o;

    assign rch_pop = rvalid_s & rready_s;
    assign rvalid_s = ~rch_empty;
    assign {rid_s, rdata_s, rresp_s, rlast_s} = rch_info_o;
    cmm_sfifo #(
        .C_HF       (16),
        .C_HAF      (14),
        .C_AW       (4),
        .C_DW       (C_ID+C_DW+2+1)
    ) u_rch_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (rch_push),
        .pop                (rch_pop),
        .din                (rch_info_i),
        .dout               (rch_info_o),
        .full               (),
        .awfull             (rch_full),
        .empty              (rch_empty)
    );

endmodule
