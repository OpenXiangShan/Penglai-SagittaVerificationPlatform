///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  reg_cal_num.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  reg_register_cal_num
/// Abstract     :  register description 
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef REG_REGISTER_CAL_NUM__SV
`define REG_REGISTER_CAL_NUM__SV

module reg_register_cal_num
    #(
        parameter REG_WIDTH = 32
     )
    (
        input                       clk        , 
        input                       rst_n      ,
        
        
        output[ 3:0]                f_quantity_out,
        output                      f_quantity_rd,
        output                      f_quantity_wr,
        
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
wire [ 3:0] f_quantity;
wire [27:0] rsv_1;

//field read declare
wire [ 3:0] f_rd_quantity;


assign reg_write = reg_wr_sel==1'b1 && reg_wr_rd==1'b1;
assign reg_read  = reg_wr_sel==1'b1 && reg_wr_rd==1'b0;

assign f_quantity_rd = r_reg_out_rd;
assign f_quantity_wr = r_reg_out_wr;


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
assign rsv_1=28'h0;

//field instance

field_common 
    #(
        .FIELD_WIDTH(4), 
        .FIELD_ACCESS("RW"), 
        .FIELD_DEFAULT(4'h0)
     ) u_f_quantity 
    (
        .clk          ( clk                ), 
        .rst_n        ( rst_n              ),
        .field_up_en  ( 1'b0 ),
        .field_up     ( 4'b0 ),
        .field_wr_en  ( reg_write          ),
        .field_wr     ( reg_wr_data[ 3: 0] ),
        .field_rd_en  ( reg_read           ),
        .field_rd_out ( f_quantity    ),
        .field_out    ( f_rd_quantity )
    );

//register output
assign f_quantity_out = f_quantity;

assign reg_rd_[3:0] = f_rd_quantity;
assign reg_rd_[31:4] = rsv_1;

assign reg_rd_out = reg_rd_;

endmodule

`endif
