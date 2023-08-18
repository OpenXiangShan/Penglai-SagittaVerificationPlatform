///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  cmm_pip_eb.sv
/// Version      :  1.0
/// 
/// Module Name  :  cmm_pip_eb
/// Abstract     :  Pipelined Elastic Buffer
//              full throughput
//              direct comb path between o_ready and i_ready
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module cmm_pip_eb #(
    parameter   DWIDTH = 16 
) (                            
    input                   i_clk,   
    input                   rst_n,
    input                   i_ready, 
    input                   i_valid,   
    input  [DWIDTH-1:0]     i_data,
    output                  o_valid,   
    output                  o_ready,   
    output reg [DWIDTH-1:0] o_data
);

reg full;

assign o_valid = full;
assign o_ready = !full || i_ready;
//
always @(posedge i_clk or negedge rst_n)begin
	if(!rst_n)begin
		full <= 1'b0;
	end else if(i_valid)begin
		full <= 1'b1;
	end else if(i_ready)begin
		full <= 1'b0;
	end
end
//
always @(posedge i_clk or negedge rst_n)begin
	if(!rst_n)begin
		o_data <= {DWIDTH{1'b0}};
	end else if(o_ready && i_valid)begin
		o_data <= i_data;
	end
end

endmodule
