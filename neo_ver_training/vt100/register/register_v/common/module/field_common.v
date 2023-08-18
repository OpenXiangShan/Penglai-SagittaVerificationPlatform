///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  field_common.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  field_common
/// Abstract     :  field description  
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef FIELD_COMMON__SV
`define FIELD_COMMON__SV

module field_common 
    #(
        parameter FIELD_WIDTH = 1,
        parameter FIELD_ACCESS = "RW",
        parameter FIELD_DEFAULT = 1'b0
     )
    (
        input                         clk          , 
        input                         rst_n        ,
        input                         field_up_en  ,
        input       [FIELD_WIDTH-1:0] field_up     ,
        input                         field_wr_en  ,
        input       [FIELD_WIDTH-1:0] field_wr     ,
        input                         field_rd_en  ,
        output wire [FIELD_WIDTH-1:0] field_rd_out ,
        output wire [FIELD_WIDTH-1:0] field_out    
    );

reg [FIELD_WIDTH-1:0] field;
wire [FIELD_WIDTH-1:0] field_din;
wire [FIELD_WIDTH-1:0] field_after_up;
always @(posedge clk or negedge rst_n) begin
    if(rst_n==1'b0) begin
        field <= FIELD_DEFAULT;
    end
    else begin
        field <= field_din;
    end
end

assign field_after_up = field_up;

generate
    case(FIELD_ACCESS)
        "RW" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;
        end
        "RWHW" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;
        end        
        "WRC" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_rd_en==1'b1 ? field_up_en==1'b1 ? field_after_up : {FIELD_WIDTH{1'b0}} : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;
        end
        "W1C" : begin
            if(FIELD_WIDTH==1) begin
                assign field_din = field_wr_en==1'b1 & field_wr==1'b1 ? {FIELD_WIDTH{1'b0}} : field_up_en==1'b1 ? field_after_up : field;
            end
            else begin
                assign field_din = field_wr_en==1'b1 & field_wr=={{(FIELD_WIDTH-1){1'b0}},1'b1} ? {FIELD_WIDTH{1'b0}} : field_up_en==1'b1 ? field_after_up : field;
            end
            assign field_rd_out = field;
        end
        "W1S" : begin
            if(FIELD_WIDTH==1) begin
                assign field_din = field_wr_en==1'b1 & field_wr==1'b1 ? {FIELD_WIDTH{1'b1}} : field_up_en==1'b1 ? field_after_up : field;
            end
            else begin
                assign field_din = field_wr_en==1'b1 & field_wr=={{(FIELD_WIDTH-1){1'b0}},1'b1} ? {FIELD_WIDTH{1'b1}} : field_up_en==1'b1 ? field_after_up : field;
            end
            assign field_rd_out = field;
        end
        "WO" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = {FIELD_WIDTH{1'b0}};
        end
        default : begin : DAFULT_GEN
            not_exit next_exit();
        end
    endcase
endgenerate

assign field_out = field;

endmodule

`endif
