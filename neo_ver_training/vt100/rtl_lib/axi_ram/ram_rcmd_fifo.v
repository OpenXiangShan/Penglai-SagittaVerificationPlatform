module ram_rcmd_fifo #(
    parameter   C_ID = 16,
    parameter   C_RAM_AW = 15
)(
    //Outputs
    ram_cmd_full, ram_rd_req, ram_addr, axi_id,
    axi_last,
    //Inputs
    aclk_s, rst_n, ram_cmd_info_i, ram_cmd_push,
    ram_rd_ack, rdata_fifo_full, ram_vld
);

    localparam CMD_INFO_W = C_ID+C_RAM_AW+1+1;

    input                       aclk_s;
    input                       rst_n;
    input [CMD_INFO_W-1:0]      ram_cmd_info_i;
    input                       ram_cmd_push;
    input                       ram_rd_ack;
    input                       rdata_fifo_full;
    input                       ram_vld;

    output                      ram_cmd_full;
    output                      ram_rd_req;
    output [C_RAM_AW:0]         ram_addr;
    output [C_ID-1:0]           axi_id;
    output                      axi_last;

    wire [CMD_INFO_W-1:0]       ram_cmd_info_o;
    wire                        ram_cmd_pop;
    wire                        ram_cmd_empty;
    reg [C_ID-1:0]              axi_id;
    reg                         axi_last;

    assign ram_addr = ram_cmd_info_o[C_RAM_AW:0];

    //to match RL=1/2
    wire [C_ID-1:0]              axi_id_fin;
    wire                         axi_last_fin;
    assign axi_id_fin = ram_cmd_info_o[(C_RAM_AW+1)+:C_ID];
    assign axi_last_fin = ram_cmd_info_o[CMD_INFO_W-1];
    cmm_sfifo #(
        .C_HF       (4),
        .C_HAF      (2),
        .C_AW       (2),
        .C_DW       (C_ID+1)
    ) u_rinfo_match_fifo (
        .clk                (aclk_s),
        .rst_n              (rst_n),
        .push               (ram_rd_ack),
        .pop                (ram_vld),
        .din                ({axi_id_fin, axi_last_fin}),
        .dout               ({axi_id, axi_last}),
        .full               (),
        .awfull             (),
        .empty              ());

    //always @(posedge aclk_s or negedge rst_n) begin
    //    if(~rst_n) begin
    //        axi_id <= {C_ID{1'b0}};
    //        axi_last <= 1'b0;
    //    end
    //    else if(ram_rd_ack) begin
    //        axi_id <= ram_cmd_info_o[(C_RAM_AW+1)+:C_ID];
    //        axi_last <= ram_cmd_info_o[CMD_INFO_W-1];
    //    end
    //end

    assign ram_cmd_pop = ram_rd_ack & ~ram_cmd_empty;
    assign ram_rd_req = ~ram_cmd_empty & ~rdata_fifo_full;

    cmm_sfifo #(
        .C_HF       (8),
        .C_HAF      (4),
        .C_AW       (3),
        .C_DW       (CMD_INFO_W)
    ) u_rcmd_fifo (
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
