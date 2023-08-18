///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  sub_register_reg.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  sub_register_reg
/// Abstract     :  sub-block register description
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef SUB_REGISTER_REG__SV
`define SUB_REGISTER_REG__SV

module sub_register_reg
    #(
        parameter REG_WIDTH = 32,
        parameter ADDR_WIDTH = 6
     )
    (  
        sub_register_if.SLAVE register_if_slave,
        sub_register_if.REGS register_if_regs        
    );

//reg_xx_sel declare
wire reg_cal_start_sel             ;
wire reg_cal_num_sel               ;
wire reg_cal_state_sel             ;
wire reg_int_set_sel               ;
wire reg_int_enable_sel            ;
wire reg_int_status_sel            ;
wire reg_int_mask_sel              ;
wire reg_total_cnt_flag_sel        ;
wire reg_total_cnt_sel             ;
wire reg_cal_ready_sel             ;

//reg_xx_rd declare
wire[REG_WIDTH-1:0] reg_cal_start_rd_out          ;
wire[REG_WIDTH-1:0] reg_cal_num_rd_out            ;
wire[REG_WIDTH-1:0] reg_cal_state_rd_out          ;
wire[REG_WIDTH-1:0] reg_int_set_rd_out            ;
wire[REG_WIDTH-1:0] reg_int_enable_rd_out         ;
wire[REG_WIDTH-1:0] reg_int_status_rd_out         ;
wire[REG_WIDTH-1:0] reg_int_mask_rd_out           ;
wire[REG_WIDTH-1:0] reg_total_cnt_flag_rd_out     ;
wire[REG_WIDTH-1:0] reg_total_cnt_rd_out          ;
wire[REG_WIDTH-1:0] reg_cal_ready_rd_out          ;


reg [REG_WIDTH-1:0] rd_data_reg;

//reg_xx_sel assignment
assign reg_cal_start_sel              = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h0;
assign reg_cal_num_sel                = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h4;
assign reg_cal_state_sel              = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h8;
assign reg_int_set_sel                = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='hc;
assign reg_int_enable_sel             = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h10;
assign reg_int_status_sel             = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h14;
assign reg_int_mask_sel               = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h18;
assign reg_total_cnt_flag_sel         = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h1c;
assign reg_total_cnt_sel              = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h20;
assign reg_cal_ready_sel              = register_if_slave.wr_sel==1'b1 && register_if_slave.wr_addr=='h24;


//reg instance
reg_register_cal_start
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_cal_start
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_start_en_out(register_if_regs.f_cal_start_start_en_out),
        .f_start_en_wr(register_if_regs.f_cal_start_start_en_wr),
        .f_start_en_rd(register_if_regs.f_cal_start_start_en_rd),

        .reg_wr_sel  ( reg_cal_start_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_cal_start_rd_out )             
    );
reg_register_cal_num
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_cal_num
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_quantity_out(register_if_regs.f_cal_num_quantity_out),
        .f_quantity_wr(register_if_regs.f_cal_num_quantity_wr),
        .f_quantity_rd(register_if_regs.f_cal_num_quantity_rd),

        .reg_wr_sel  ( reg_cal_num_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_cal_num_rd_out )             
    );
reg_register_cal_state
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_cal_state
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_is_busy_up_data(register_if_regs.f_cal_state_is_busy_in),
        .f_is_busy_rd(register_if_regs.f_cal_state_is_busy_rd),

        .reg_wr_sel  ( reg_cal_state_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_cal_state_rd_out )             
    );
reg_register_int_set
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_int_set
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_set_enable_out(register_if_regs.f_int_set_set_enable_out),
        .f_set_enable_wr(register_if_regs.f_int_set_set_enable_wr),
        .f_set_enable_rd(register_if_regs.f_int_set_set_enable_rd),
        .f_set_value_out(register_if_regs.f_int_set_set_value_out),
        .f_set_value_wr(register_if_regs.f_int_set_set_value_wr),
        .f_set_value_rd(register_if_regs.f_int_set_set_value_rd),

        .reg_wr_sel  ( reg_int_set_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_int_set_rd_out )             
    );
reg_register_int_enable
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_int_enable
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_enable_out(register_if_regs.f_int_enable_enable_out),
        .f_enable_wr(register_if_regs.f_int_enable_enable_wr),
        .f_enable_rd(register_if_regs.f_int_enable_enable_rd),

        .reg_wr_sel  ( reg_int_enable_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_int_enable_rd_out )             
    );
reg_register_int_status
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_int_status
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_status_up_data(register_if_regs.f_int_status_status_in),
        .f_status_rd(register_if_regs.f_int_status_status_rd),

        .reg_wr_sel  ( reg_int_status_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_int_status_rd_out )             
    );
reg_register_int_mask
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_int_mask
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_mask_out(register_if_regs.f_int_mask_mask_out),
        .f_mask_wr(register_if_regs.f_int_mask_mask_wr),
        .f_mask_rd(register_if_regs.f_int_mask_mask_rd),

        .reg_wr_sel  ( reg_int_mask_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_int_mask_rd_out )             
    );
reg_register_total_cnt_flag
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_total_cnt_flag
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_flag_out(register_if_regs.f_total_cnt_flag_flag_out),
        .f_flag_wr(register_if_regs.f_total_cnt_flag_flag_wr),
        .f_flag_rd(register_if_regs.f_total_cnt_flag_flag_rd),

        .reg_wr_sel  ( reg_total_cnt_flag_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_total_cnt_flag_rd_out )             
    );
reg_register_total_cnt
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_total_cnt
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_counter_up_data(register_if_regs.f_total_cnt_counter_in),
        .f_counter_rd(register_if_regs.f_total_cnt_counter_rd),

        .reg_wr_sel  ( reg_total_cnt_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_total_cnt_rd_out )             
    );
reg_register_cal_ready
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_cal_ready
    (
        .clk         ( register_if_slave.clk   ), 
        .rst_n       ( register_if_slave.rst_n ),
        .f_ready_out(register_if_regs.f_cal_ready_ready_out),
        .f_ready_wr(register_if_regs.f_cal_ready_ready_wr),
        .f_ready_rd(register_if_regs.f_cal_ready_ready_rd),

        .reg_wr_sel  ( reg_cal_ready_sel ),
        .reg_wr_rd   ( register_if_slave.wr_rd   ),
        .reg_wr_data ( register_if_slave.wr_data ),
        .reg_rd_out  ( reg_cal_ready_rd_out )             
    );


//rd_data case
//always @(posedge register_if_slave.clk or register_if_slave.rst_n) begin
//    if(register_if_slave.rst_n==1'b0) begin
//        rd_data_reg = {REG_WIDTH{1'b0}};
//    end
//    else if(register_if_slave.wr_sel==1'b1 && register_if_slave.wr_rd==1'b0) begin
//    end
//end
always @(*) begin
    if(register_if_slave.wr_sel==1'b1 && register_if_slave.wr_rd==1'b0) begin
        case(register_if_slave.wr_addr)
            'h0 : rd_data_reg = reg_cal_start_rd_out          ;
            'h4 : rd_data_reg = reg_cal_num_rd_out            ;
            'h8 : rd_data_reg = reg_cal_state_rd_out          ;
            'hc : rd_data_reg = reg_int_set_rd_out            ;
            'h10 : rd_data_reg = reg_int_enable_rd_out         ;
            'h14 : rd_data_reg = reg_int_status_rd_out         ;
            'h18 : rd_data_reg = reg_int_mask_rd_out           ;
            'h1c : rd_data_reg = reg_total_cnt_flag_rd_out     ;
            'h20 : rd_data_reg = reg_total_cnt_rd_out          ;
            'h24 : rd_data_reg = reg_cal_ready_rd_out          ;

            default : rd_data_reg = 'habadbeef;
        endcase
    end
    else begin
        rd_data_reg = {REG_WIDTH{1'b0}};
    end
end
assign register_if_slave.rd_data = rd_data_reg;

endmodule

`endif
