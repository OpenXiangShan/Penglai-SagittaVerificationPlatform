///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Filename     :  codec_cmm_abs_sub.v
/// Date         :  2021-12-28
/// Version      :  1.0
/// 
/// Module Name  :  codec_cmm_abs_sub
/// Abstract     :           
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module codec_cmm_abs_sub#(
    parameter   DW = 8
) 
(
    input                   clk       ,   
    input                   rst_n     ,

    input                   input_vld ,
    input       [DW-1:0]    a         ,
    input       [DW-1:0]    b         ,
    output reg              output_vld,
    output reg  [DW-1:0]    c 
);

    wire [DW:0]  big,little ;

    assign big    = (a > b) ? a : b;
    assign little = (a < b) ? a : b;
    
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            c <= {DW{1'b0}};
        else if(input_vld)
            c <= big - little;
    end 

    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            output_vld <= 1'b0;
        else
            output_vld <= input_vld;
    end
              
endmodule