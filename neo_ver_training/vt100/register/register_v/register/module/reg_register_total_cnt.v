///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  reg_total_cnt.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  reg_register_total_cnt
/// Abstract     :  register description 
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef REG_REGISTER_TOTAL_CNT__SV
`define REG_REGISTER_TOTAL_CNT__SV

module reg_register_total_cnt
    #(
        parameter REG_WIDTH = 32
     )
    (
        input                       clk        , 
        input                       rst_n      ,
        
        input[15:0]                 f_counter_up_data,
        
        output                    f_counter_rd,
        
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
wire [15:0] f_counter;
wire [15:0] rsv_1;

//field read declare
wire [15:0] f_rd_counter;


assign reg_write = reg_wr_sel==1'b1 && reg_wr_rd==1'b1;
assign reg_read  = reg_wr_sel==1'b1 && reg_wr_rd==1'b0;

assign f_counter_rd = r_reg_out_rd;


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
assign rsv_1=16'h0;

//field instance

field_ro 
    #(
        .FIELD_WIDTH(16) 
     ) u_f_counter 
    (
        .field_up     ( f_counter_up_data ),
        .field_rd_out ( f_counter    ),
        .field_out    ( f_rd_counter )
    );

//register output

assign reg_rd_[15:0] = f_rd_counter;
assign reg_rd_[31:16] = rsv_1;

assign reg_rd_out = reg_rd_;

endmodule

`endif
