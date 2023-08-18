///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  sub_register_if.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  sub_register_if
/// Abstract     :  sub-block reg-interface description
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef SUB_REGISTER_IF__SV
`define SUB_REGISTER_IF__SV

interface sub_register_if
    #(
        parameter REG_WIDTH = 32,
        parameter ADDR_WIDTH = 6
     )
    (
        input bit clk,
        input bit rst_n
    );

        logic                       wr_sel  ;
        logic                       wr_rd   ;//1: write; 0: read
        logic      [ADDR_WIDTH-1:0] wr_addr ;
        logic       [REG_WIDTH-1:0] wr_data ;
        logic       [REG_WIDTH-1:0] rd_data ;

//reg_xx_inner declare
logic             f_cal_state_is_busy_in;
logic             f_int_status_status_in;
logic[15:0]         f_total_cnt_counter_in;

//reg_xx_inner_output declare
logic             f_cal_start_start_en_rd;
logic             f_cal_start_start_en_wr;
logic             f_cal_start_start_en_out;
logic             f_cal_num_quantity_rd;
logic             f_cal_num_quantity_wr;
logic[ 3:0]       f_cal_num_quantity_out;
logic             f_cal_state_is_busy_rd;
logic             f_int_set_set_enable_rd;
logic             f_int_set_set_enable_wr;
logic             f_int_set_set_enable_out;
logic             f_int_set_set_value_rd;
logic             f_int_set_set_value_wr;
logic             f_int_set_set_value_out;
logic             f_int_enable_enable_rd;
logic             f_int_enable_enable_wr;
logic             f_int_enable_enable_out;
logic             f_int_status_status_rd;
logic             f_int_mask_mask_rd;
logic             f_int_mask_mask_wr;
logic             f_int_mask_mask_out;
logic             f_total_cnt_flag_flag_rd;
logic             f_total_cnt_flag_flag_wr;
logic             f_total_cnt_flag_flag_out;
logic             f_total_cnt_counter_rd;
logic             f_cal_ready_ready_rd;
logic             f_cal_ready_ready_wr;
logic             f_cal_ready_ready_out;


        modport MASTER(
                        input clk,
                        input rst_n,
                        output wr_sel,
                        output wr_rd,
                        output wr_addr,
                        output wr_data,
                        input rd_data
                        );

        modport SLAVE(
                        input clk,
                        input rst_n,
                        input wr_sel,
                        input wr_rd,
                        input wr_addr,
                        input wr_data,
                        output rd_data
                        );
                                                
        modport USER(
                     output f_cal_state_is_busy_in,
                     output f_int_status_status_in,
                     output f_total_cnt_counter_in,

                        input f_cal_start_start_en_rd,
                        input f_cal_start_start_en_wr,
                        input f_cal_start_start_en_out,
                        input f_cal_num_quantity_rd,
                        input f_cal_num_quantity_wr,
                        input f_cal_num_quantity_out,
                        input f_cal_state_is_busy_rd,
                        input f_int_set_set_enable_rd,
                        input f_int_set_set_enable_wr,
                        input f_int_set_set_enable_out,
                        input f_int_set_set_value_rd,
                        input f_int_set_set_value_wr,
                        input f_int_set_set_value_out,
                        input f_int_enable_enable_rd,
                        input f_int_enable_enable_wr,
                        input f_int_enable_enable_out,
                        input f_int_status_status_rd,
                        input f_int_mask_mask_rd,
                        input f_int_mask_mask_wr,
                        input f_int_mask_mask_out,
                        input f_total_cnt_flag_flag_rd,
                        input f_total_cnt_flag_flag_wr,
                        input f_total_cnt_flag_flag_out,
                        input f_total_cnt_counter_rd,
                        input f_cal_ready_ready_rd,
                        input f_cal_ready_ready_wr,
                        input f_cal_ready_ready_out
                            );
                            
        modport REGS(
                     input f_cal_state_is_busy_in,
                     input f_int_status_status_in,
                     input f_total_cnt_counter_in,

                        output f_cal_start_start_en_rd,
                        output f_cal_start_start_en_wr,
                        output f_cal_start_start_en_out,
                        output f_cal_num_quantity_rd,
                        output f_cal_num_quantity_wr,
                        output f_cal_num_quantity_out,
                        output f_cal_state_is_busy_rd,
                        output f_int_set_set_enable_rd,
                        output f_int_set_set_enable_wr,
                        output f_int_set_set_enable_out,
                        output f_int_set_set_value_rd,
                        output f_int_set_set_value_wr,
                        output f_int_set_set_value_out,
                        output f_int_enable_enable_rd,
                        output f_int_enable_enable_wr,
                        output f_int_enable_enable_out,
                        output f_int_status_status_rd,
                        output f_int_mask_mask_rd,
                        output f_int_mask_mask_wr,
                        output f_int_mask_mask_out,
                        output f_total_cnt_flag_flag_rd,
                        output f_total_cnt_flag_flag_wr,
                        output f_total_cnt_flag_flag_out,
                        output f_total_cnt_counter_rd,
                        output f_cal_ready_ready_rd,
                        output f_cal_ready_ready_wr,
                        output f_cal_ready_ready_out
                            );
                            
endinterface

`endif
