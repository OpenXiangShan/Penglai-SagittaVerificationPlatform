module ram_rw_arb(/*autoarg*/
    //Outputs
    ram_wr_ack, ram_rd_ack,
    //Inputs
    aclk_s, rst_n, ram_wr_req, ram_wdata_ready,
    ram_rd_req
);

    input                   aclk_s;
    input                   rst_n;
    input                   ram_wr_req;
    input                   ram_wdata_ready;
    input                   ram_rd_req;
    output                  ram_wr_ack;
    output                  ram_rd_ack;

    reg                     ram_wr_rd_same_time;
    reg                     ram_wr_mask;
    reg                     ram_rd_mask;
    reg                     rw_mask_toggle;

    assign ram_wr_ack = ram_wr_req & ram_wdata_ready & ram_wr_mask;
    assign ram_rd_ack = ram_rd_req & ram_rd_mask;

    always @(*) begin
        ram_wr_rd_same_time = ram_wr_req & ram_rd_req;
        ram_wr_mask = 1'b1;
        ram_rd_mask = 1'b1;
        if(ram_wr_rd_same_time) begin
            ram_rd_mask = rw_mask_toggle;
            ram_wr_mask = ~rw_mask_toggle;
        end
    end

    always @(posedge aclk_s or negedge rst_n) begin
        if(~rst_n) begin
            rw_mask_toggle <= 1'b0;
        end
        else if(ram_wr_rd_same_time) begin
            rw_mask_toggle <= ~rw_mask_toggle;
        end
    end


endmodule
