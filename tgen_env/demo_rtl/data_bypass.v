module one_data_bypass #(parameter MAY_ERR = 0) (
                     input clk,
                     input rst_n,
                     input        data_in_valid,
                     input [63:0] data_in_data,
                     output wire        data_out_valid,
                     output wire [63:0] data_out_data
                   );

reg [7:0] vld;
reg [63:0] data[0:7];

always @(posedge clk or negedge rst_n) begin
    if(rst_n==1'b0) begin
        vld[0] <= 1'b0;
        data[0] <= 64'h0;
    end
    else begin
        vld[0] <= data_in_valid;
        data[0] <= data_in_data;
    end
end
genvar i;
generate
    for (i=1; i<8; i=i+1) begin
        always @(posedge clk or negedge rst_n) begin
            if(rst_n==1'b0) begin
                vld[i] <= 1'b0;
                data[i] <= 64'h0;
            end
            else begin
                vld[i] <= vld[i-1] ;
                data[i] <= data[i-1];
            end
        end
    end
endgenerate

generate;
    if(MAY_ERR==1) begin
        reg [7:0] make_err;
        always @(posedge clk or negedge rst_n) begin
            if(rst_n==1'b0) begin
                make_err <= 8'b0;
            end
            else begin
                make_err <= $urandom_range(0,10);
            end
        end
        wire is_err;
        assign is_err = (make_err%2)==0;
        assign data_out_data = is_err==1'b1 ? {64{1'b1}} : data[7];
    end
    else begin
        assign data_out_data = data[7];
    end
endgenerate

assign data_out_valid = vld[7];

endmodule

module data_bypass (
                     input clk,
                     input rst_n,
                     //data_in_new
                     input        data_in_valid_new,
                     input [63:0] data_in_data_new,
                     //data_out_new
                     output wire        data_out_valid_new,
                     output wire [63:0] data_out_data_new,
                     //data_in
                     input        data_in_valid,
                     input [63:0] data_in_data,
                     //data_out
                     output wire        data_out_valid,
                     output wire [63:0] data_out_data
                   );

`ifdef DUT_IS_ERR
one_data_bypass #(.MAY_ERR(1)) u_data_bypass (
                     .clk            ( clk            ),
                     .rst_n          ( rst_n          ),
                     .data_in_valid  ( data_in_valid  ),
                     .data_in_data   ( data_in_data   ),
                     .data_out_valid ( data_out_valid ),
                     .data_out_data  ( data_out_data  )
                    );
`else
one_data_bypass #(.MAY_ERR(0)) u_data_bypass (
                     .clk            ( clk            ),
                     .rst_n          ( rst_n          ),
                     .data_in_valid  ( data_in_valid  ),
                     .data_in_data   ( data_in_data   ),
                     .data_out_valid ( data_out_valid ),
                     .data_out_data  ( data_out_data  )
                    );
`endif

one_data_bypass #(.MAY_ERR(0)) u_data_bypass_new (
                     .clk            ( clk                ),
                     .rst_n          ( rst_n              ),
                     .data_in_valid  ( data_in_valid_new  ),
                     .data_in_data   ( data_in_data_new   ),
                     .data_out_valid ( data_out_valid_new ),
                     .data_out_data  ( data_out_data_new  )
                    );

endmodule
