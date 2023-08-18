module ram_wcmd_fifo #(
    parameter   C_ID = 16,
    parameter   C_RAM_AW = 15
)(
    //Outputs
    ram_cmd_full, ram_wr_req, ram_addr, axi_id,
    //Inputs
    aclk_s, rst_n, ram_cmd_info_i, ram_cmd_push,
    ram_wr_ack, bresp_fifo_full
);

    localparam CMD_INFO_W = C_ID+C_RAM_AW+1+1;

    input                       aclk_s;
    input                       rst_n;
    input [CMD_INFO_W-1:0]      ram_cmd_info_i;
    input                       ram_cmd_push;
    input                       ram_wr_ack;
    input                       bresp_fifo_full;

    output                      ram_cmd_full;
    output                      ram_wr_req;
    output [C_RAM_AW:0]         ram_addr;
    output [C_ID-1:0]           axi_id;

    wire [CMD_INFO_W-1:0]       ram_cmd_info_o;
    wire                        ram_cmd_pop;
    wire                        ram_cmd_empty;
    wire                        axi_last;
    wire                        bresp_fifo_push;

    assign ram_addr = ram_cmd_info_o[C_RAM_AW:0];
    assign axi_id = ram_cmd_info_o[(C_RAM_AW+1)+:C_ID];
    assign axi_last = ram_cmd_info_o[CMD_INFO_W-1];

    assign ram_cmd_pop = ram_wr_ack & ~ram_cmd_empty;
    assign ram_wr_req = ~ram_cmd_empty & (axi_last ? ~bresp_fifo_full : 1'b1);
    assign bresp_fifo_push = ram_wr_ack & axi_last;

    cmm_sfifo #(
        .C_HF       (8),
        .C_HAF      (4),
        .C_AW       (3),
        .C_DW       (CMD_INFO_W)
    ) u_wcmd_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (ram_cmd_push),
        .pop                (ram_cmd_pop),
        .din                (ram_cmd_info_i),
        .dout               (ram_cmd_info_o),
        .full               (ram_cmd_full),
        .awfull             (),
        .empty              (ram_cmd_empty));

endmodule
