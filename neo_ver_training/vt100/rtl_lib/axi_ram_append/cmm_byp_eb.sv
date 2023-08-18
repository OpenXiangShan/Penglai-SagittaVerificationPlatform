///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  cmm_byp_eb.sv
/// Version      :  1.0
/// 
/// Module Name  :  cmm_byp_eb
/// Abstract     :  Pipelined Elastic Buffer
//                  full throughput
//                  direct comb path between o_valid and i_valid
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module cmm_byp_eb #(
    parameter   DWIDTH = 16 
) (                            
    input                   i_clk,   
    input                   rst_n,
    input                   i_ready, 
    input                   i_valid,   
    input  [DWIDTH-1:0]     i_data,
    output reg              o_valid,   
    output reg              o_ready,   
    output reg [DWIDTH-1:0] o_data
);

reg full;
reg full_b; // eb_fifo not full
reg [DWIDTH-1:0]    r_data;

always_comb begin
    o_valid = full || i_valid;
    //o_ready = !full;
    o_ready = full_b;
    if (full)
        o_data = r_data; 
    else
        o_data = i_data; 
end
//
always @(posedge i_clk or negedge rst_n)begin
	if(!rst_n)begin
		full <= 1'b0;
        full_b <= 1'b1;
	end else if(i_ready)begin
		full <= 1'b0;
        full_b <= 1'b1;
	end else if(i_valid)begin
		full <= 1'b1;
        full_b <= 1'b0;
	end
	//end else begin
	//	case ({i_ready, i_valid})
	//		2'b10:   full <= 1'b0;
	//		2'b01:   full <= 1'b1;
	//		default: full <= full;
	//	endcase
	//end
end
//
always @(posedge i_clk or negedge rst_n)begin
	if(!rst_n)begin
		r_data <= {DWIDTH{1'b0}};
	end else if (!full && i_valid) begin
		r_data <= i_data;
	end
end
//

endmodule
