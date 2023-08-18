///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Filename     :  interrupt_ctrl.v
/// Date         :  2022-01-12
/// Version      :  1.0
/// 
/// Module Name  :  interrupt_ctrl
/// Abstract     :  单bit中断控制电路       
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module interrupt_ctrl
(
    input       clk,
    input       rst_n,
    //control
    input       int_set_en,
    input       int_set_value,
    input       int_en,
    input       int_state_rd,
    output wire int_state,
    input       int_mask,
    //interrupt
    input       int_in,
    output wire int_out 
);

    wire int_after_set;
    assign int_after_set = int_set_en==1'b1 ? int_set_value : int_in;

    wire int_after_en;
    assign int_after_en = int_en==1'b1 ? int_after_set : 1'b0;

    wire int_after_mask;
    assign int_after_mask = int_mask==1'b1 ? 1'b0 : int_after_en;

    reg int_state_reg;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            int_state_reg <= 1'b0;
        end
        else if(int_after_en==1'b1) begin
            int_state_reg <= 1'b1;
        end
        else if(int_state_rd==1'b1) begin
            int_state_reg <= 1'b0;
        end
        else begin
            int_state_reg <= int_state_reg;
        end
    end

    //output
    assign int_out = int_after_mask;
    assign int_state = int_state_reg;

endmodule