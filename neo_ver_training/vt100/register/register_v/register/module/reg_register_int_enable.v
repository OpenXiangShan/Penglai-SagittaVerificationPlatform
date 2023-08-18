///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  reg_int_enable.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  reg_register_int_enable
/// Abstract     :  register description 
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef REG_REGISTER_INT_ENABLE__SV
`define REG_REGISTER_INT_ENABLE__SV

module reg_register_int_enable
    #(
        parameter REG_WIDTH = 32
     )
    (
        input                       clk        , 
        input                       rst_n      ,
        
        
        output                      f_enable_out,
        output                      f_enable_rd,
        output                      f_enable_wr,
        
        input                       reg_wr_sel ,
        input                       reg_wr_rd  ,//1: write; 0: read
        input       [REG_WIDTH-1:0] reg_wr_data,
        output wire [REG_WIDTH-1:0] reg_rd_out 
    );

//register declare
wire [REG_WIDTH-1:0] reg_rd_;
wire reg_write;
wire reg_read;
reg r_reg_out_wr;
reg r_reg_out_rd;
//field declare
wire        f_enable;
wire [30:0] rsv_1;

//field read declare
wire        f_rd_enable;


assign reg_write = reg_wr_sel==1'b1 && reg_wr_rd==1'b1;
assign reg_read  = reg_wr_sel==1'b1 && reg_wr_rd==1'b0;

assign f_enable_rd = r_reg_out_rd;
assign f_enable_wr = r_reg_out_wr;


always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        r_reg_out_wr <= 0;
        r_reg_out_rd <= 0;
    end
    else begin
        r_reg_out_wr <= reg_write;
        r_reg_out_rd <= reg_read;
    end
//reserved tie 0
assign rsv_1=31'h0;

//field instance

field_common 
    #(
        .FIELD_ACCESS("RW"), 
        .FIELD_DEFAULT(1'h0)
     ) u_f_enable 
    (
        .clk          ( clk             ), 
        .rst_n        ( rst_n           ),
        .field_up_en  ( 1'b0   ),
        .field_up     ( 1'b0 ),
        .field_wr_en  ( reg_write       ),
        .field_wr     ( reg_wr_data[ 0] ),
        .field_rd_en  ( reg_read        ),
        .field_rd_out ( f_enable    ),
        .field_out    ( f_rd_enable )
    );

//register output
assign f_enable_out = f_enable;

assign reg_rd_[0] = f_rd_enable;
assign reg_rd_[31:1] = rsv_1;

assign reg_rd_out = reg_rd_;

endmodule

`endif
