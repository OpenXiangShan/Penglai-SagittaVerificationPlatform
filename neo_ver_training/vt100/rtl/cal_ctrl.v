///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Filename     :  cal_ctrl.v
/// Date         :  2022-01-12
/// Version      :  1.0
/// 
/// Module Name  :  cal_ctrl
/// Abstract     :  连续sad计算控制  
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module cal_ctrl
(
    input               clk,
    input               rst_n,

    //register.cal_config
    input               cal_start,
    input      [  3:0]  cal_num,
    output wire         cal_busy_state,
    //register.interrupt
    input               int_set_en,
    input               int_set_value,
    input               int_en,
    input               int_state_rd,
    output wire         int_state,
    input               int_mask,
    //register.statistics
    input               total_cnt_flag,
    input               total_cnt_rd,
    output wire [ 15:0] total_cnt,

    //sad_cal
    output wire         sad_vld_in,
    output wire [127:0] sad_din1,
    output wire [127:0] sad_din2,
    input               sad_vld_out,
    input       [ 15:0] sad_dout,

    //inner_sram
    output wire         inner_sram_we_n,
    output wire [ 10:0] inner_sram_waddr,
    output wire [ 63:0] inner_sram_wdata,
    output wire         inner_sram_rd_n,
    output wire [ 10:0] inner_sram_raddr,
    input       [ 63:0] inner_sram_rdata,

    //axi2ram
    input               axi2ram_cs_n,
    input               axi2ram_we_n,
    input       [ 10:0] axi2ram_addr,
    input       [ 63:0] axi2ram_wdata,
    output wire         axi2ram_rvld,
    output wire [ 63:0] axi2ram_rdata,
    
    //interrupt
    input               cal_ready,
    output wire [15:0]   cal_rdata,
    output wire [4:0]   cal_id,
    output wire         cal_valid,
    output wire         cal_int_out
);
    parameter IDLE = 2'd0;
    parameter RD_DIN = 2'd1;
    parameter DO_CAL = 2'd2;
    parameter RW_DOUT = 2'd3;

    reg [1:0] curr_sta;
    reg [1:0] next_sta;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            curr_sta <= IDLE;
        end
        else begin
            curr_sta <= next_sta;
        end
    end

    //--------------------------状态机跳转控制
    //----curr_sta==RD_DIN
    reg [6:0] read_din_cnt;
    localparam RD_DIN_CNT_MAX = 7'd65;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            read_din_cnt <= 7'd0;
        end
        else if(read_din_cnt==RD_DIN_CNT_MAX) begin
            read_din_cnt <= read_din_cnt;
        end
        else if(curr_sta==RD_DIN) begin
            read_din_cnt <= read_din_cnt + 7'd1;
        end
        else begin
            read_din_cnt <= 7'd0;
        end
    end
    reg send_one_line_sad_din;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            send_one_line_sad_din <= 1'b0;
        end
        else if(curr_sta==RD_DIN) begin
            if(read_din_cnt[1:0]==2'd0 & read_din_cnt[6:2]!=0) begin
                send_one_line_sad_din <= 1'b1;
            end
            else begin
                send_one_line_sad_din <= 1'b0;
            end
        end
        else begin
            send_one_line_sad_din <= 1'b0;
        end
    end
    //----curr_sta==RW_DOUT
    reg [1:0] rewrite_cnt;
    localparam REWRITE_CNT_MAX = 2'd3;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            rewrite_cnt <= 2'd0;
        end
        else if(rewrite_cnt==REWRITE_CNT_MAX) begin
            rewrite_cnt <= rewrite_cnt;
        end
        else if(curr_sta==RW_DOUT) begin
            rewrite_cnt <= rewrite_cnt + 2'd1;
        end
        else begin
            rewrite_cnt <= 2'd0;
        end
    end
    reg [3:0] cal_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            cal_cnt <= 4'd0;
        end
        else if(curr_sta==IDLE) begin
            cal_cnt <= 4'd0;
        end
        else if(sad_vld_out==1'b1) begin
            cal_cnt <= cal_cnt + 4'd1;
        end
        else begin
            cal_cnt <= cal_cnt;
        end
    end
    //----状态跳转
    always @(*) begin
        case(curr_sta)
            IDLE : begin
                if(cal_start==1'b1) begin
                    next_sta = RD_DIN;
                end
                else begin
                    next_sta = IDLE;
                end
            end
            RD_DIN : begin
                if(read_din_cnt>=RD_DIN_CNT_MAX) begin
                    next_sta = DO_CAL;
                end
                else begin
                    next_sta = RD_DIN;
                end
            end
            DO_CAL : begin
                if(sad_vld_out==1'b1) begin
                    next_sta = RW_DOUT;
                end
                else begin
                    next_sta = DO_CAL;
                end
            end
            RW_DOUT : begin
                if(rewrite_cnt>=REWRITE_CNT_MAX) begin
                    if(cal_cnt>=cal_num) begin
                        next_sta = IDLE;
                    end
                    else begin
                        next_sta = RD_DIN;
                    end
                end
                else begin
                    next_sta = RW_DOUT;
                end
            end
            default : begin
                next_sta = IDLE;
            end
        endcase
    end

    //--------------------------状态机输出控制
    //SAD 计算操作sram的信号
    wire        sad_cal_sram_we_n;
    wire [10:0] sad_cal_sram_waddr;
    reg  [63:0] sad_cal_sram_wdata;
    wire        sad_cal_sram_rd_n;
    wire [10:0] sad_cal_sram_raddr;
    //----curr_sta==RD_DIN
    //缓存从sram中读取的计算系数
    reg [127:0] temp_din1;
    reg [127:0] temp_din2;
    assign sad_cal_sram_rd_n = (curr_sta==RD_DIN && read_din_cnt<=7'd63) ? 1'b0 : (curr_sta==RW_DOUT && rewrite_cnt==2'd0) ? 1'b0 : 1'b1;
    assign sad_cal_sram_raddr = curr_sta==RW_DOUT ? {1'b1, 8'h0, cal_cnt[3:2]} : {1'b0,read_din_cnt[1],cal_cnt,read_din_cnt[5:2],read_din_cnt[0]};
    reg [2:0] read_din_cnt_buf;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            read_din_cnt_buf <= 2'd0;
        end
        else begin
            read_din_cnt_buf <= read_din_cnt[1:0];
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            temp_din1 <= 128'h0;
        end
        else if(read_din_cnt_buf==2'd0) begin
            temp_din1 <= {temp_din1[127:64],inner_sram_rdata};
        end
        else if(read_din_cnt_buf==2'd1) begin
            temp_din1 <= {inner_sram_rdata,temp_din1[63:0]};
        end
        else begin
            temp_din1 <= temp_din1;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            temp_din2 <= 128'h0;
        end
        else if(read_din_cnt_buf==2'd2) begin
            temp_din2 <= {temp_din2[127:64],inner_sram_rdata};
        end
        else if(read_din_cnt_buf==2'd3) begin
            temp_din2 <= {inner_sram_rdata,temp_din2[63:0]};
        end
        else begin
            temp_din2 <= temp_din2;
        end
    end
    //----curr_sta==DO_CAL
    reg [15:0] sad_dout_lock;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            sad_dout_lock <= 16'd0;
        end
        else if(curr_sta==DO_CAL && sad_vld_out==1'b1) begin
            sad_dout_lock <= sad_dout;
        end
        else begin
            sad_dout_lock <= sad_dout_lock;
        end
    end
    //----curr_sta==RW_DOUT
    reg [63:0] rewrite_rdata_lock;
    always @(posedge clk or negedge rst_n) begin
        if (rst_n==1'b0) begin
            rewrite_rdata_lock <= 64'h0;
        end
        else if(curr_sta==RW_DOUT && rewrite_cnt==2'd1) begin
            rewrite_rdata_lock <= inner_sram_rdata;
        end
        else begin
            rewrite_rdata_lock <= rewrite_rdata_lock;
        end
    end
    assign sad_cal_sram_we_n = (curr_sta==RW_DOUT && rewrite_cnt==2'd2) ? 1'b0 : 1'b1;
    assign sad_cal_sram_waddr = 7'h40 + {5'd0,cal_cnt[3:2]};
    always @(*) begin
        case(cal_cnt[1:0])
            //2'b00 : sad_cal_sram_wdata = {rewrite_rdata_lock[63:16],sad_dout_lock};
            2'b01 : sad_cal_sram_wdata = {rewrite_rdata_lock[63:32],sad_dout_lock,rewrite_rdata_lock[15:0]};
            2'b10 : sad_cal_sram_wdata = {rewrite_rdata_lock[63:48],sad_dout_lock,rewrite_rdata_lock[31:0]};
            2'b11 : sad_cal_sram_wdata = {sad_dout_lock,rewrite_rdata_lock[55:0]};
            default : sad_cal_sram_wdata = {rewrite_rdata_lock[63:16],sad_dout_lock};
        endcase
    end

    //--------------------------计算结束中断
    reg cal_finish_plus;
    always @(posedge clk or negedge rst_n) begin
        if (rst_n==1'b0) begin
            cal_finish_plus <= 1'b0;
        end
        else begin
            cal_finish_plus <= curr_sta==RW_DOUT && next_sta==IDLE;
        end
    end

    //--------------------------计算结束中断
    reg [15:0] total_cal_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            total_cal_cnt <= 16'd0;
        end
        else if(total_cnt_rd==1'b1) begin
            if(cal_finish_plus==1'b1) begin
                total_cal_cnt <= 16'd1;
            end
            else begin
                total_cal_cnt <= 16'd0;
            end
        end
        else if(cal_finish_plus==1'b1) begin
            if(total_cal_cnt==16'hffff) begin
                total_cal_cnt <= total_cnt_flag==1'b1 ? 16'hffff : 16'd0;
            end
            else begin
                total_cal_cnt <= total_cal_cnt + 16'd1;
            end
        end
        else begin
            total_cal_cnt <= total_cal_cnt;
        end
    end


    //--------------------------axi2ram读写控制sram
    wire        axi2ram_sram_we_n;
    wire [10:0] axi2ram_sram_waddr;
    reg  [63:0] axi2ram_sram_wdata;
    wire        axi2ram_sram_rd_n;
    wire [10:0] axi2ram_sram_raddr;
    assign axi2ram_sram_we_n = (axi2ram_cs_n==1'b0 && axi2ram_we_n==1'b0) ? 1'b0 : 1'b1;
    assign axi2ram_sram_waddr = axi2ram_addr;
    assign axi2ram_sram_wdata = axi2ram_wdata;
    assign axi2ram_sram_rd_n = (axi2ram_cs_n==1'b0 && axi2ram_we_n==1'b1) ? 1'b0 : 1'b1;
    assign axi2ram_sram_raddr = axi2ram_addr;
    reg axi2ram_sram_rvld;
    always @(posedge clk or negedge rst_n) begin
        if (rst_n==1'b0) begin
            axi2ram_sram_rvld <= 1'b0;
        end
        else begin
            axi2ram_sram_rvld <= axi2ram_sram_rd_n==1'b0 ? 1'b1 : 1'b0;
        end
    end

    //--------------------------模块输出
    //register.cal_config
    assign cal_busy_state = curr_sta==IDLE ? 1'b0 : 1'b1;
    //register.interrupt
    interrupt_ctrl u_int_ctrl
    (
        .clk (clk),
        .rst_n (rst_n),
        .int_set_en (int_set_en),
        .int_set_value (int_set_value),
        .int_en (int_en),
        .int_state_rd (int_state_rd),
        .int_state (int_state),
        .int_mask (int_mask),
        .int_in (cal_finish_plus),
        .int_out (cal_int_out) 
    );
    //register.statistics
    assign total_cnt = total_cal_cnt;
    //sad_cal
    assign sad_vld_in = curr_sta==RD_DIN && send_one_line_sad_din==1'b1;
    assign sad_din1 = temp_din1;
    assign sad_din2 = temp_din2;

    //inner_sram
    assign inner_sram_we_n = curr_sta==IDLE ? axi2ram_sram_we_n : sad_cal_sram_we_n;
    assign inner_sram_waddr = curr_sta==IDLE ? axi2ram_sram_waddr : sad_cal_sram_waddr;
    assign inner_sram_wdata = curr_sta==IDLE ? axi2ram_sram_wdata : sad_cal_sram_wdata;
    assign inner_sram_rd_n = curr_sta==IDLE ? axi2ram_sram_rd_n : sad_cal_sram_rd_n;
    assign inner_sram_raddr = curr_sta==IDLE ? axi2ram_sram_raddr : sad_cal_sram_raddr;

    //axi2ram
    assign axi2ram_rvld = axi2ram_sram_rvld;
    assign axi2ram_rdata = curr_sta==IDLE ? inner_sram_rdata : 64'h0;



    reg [63:0] result_mem[4];
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            for(int i=0; i<4; i++)
                result_mem[i] <= 0;
        end else if(sad_cal_sram_we_n == 0)begin
            result_mem[ sad_cal_sram_waddr[1:0]] = sad_cal_sram_wdata;
        end
    end

// output result
    reg [3:0] idx;
    integer seed = 0;
    reg [63:0] id;
    reg [47:0] delay_cnt;

    function reg [63:0] ini_and_shuffle_id_array;
        input [3:0] cal_num;
        reg [3:0] id_array[16];
        integer seed = 0;
        begin
        integer i;
        //ini_and_shuffle_id_array = 0;
        for(i = 0; i < cal_num; i = i+1)begin
            id_array[i] = i;
        end
        ini_and_shuffle_id_array = 0;
        for(i = cal_num-1; i>0; i = i-1)begin
            reg [3:0] j;
            j = ($random(seed)%(i+1)) & 7'hf;
            {id_array[i], id_array[j]} = {id_array[j], id_array[i]};
            seed = seed + j;
        end

        for(i = 0; i<cal_num; i++)begin
            ini_and_shuffle_id_array =  (ini_and_shuffle_id_array << 4) + id_array[i];
        end
        end
    endfunction

    reg [3:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n==1'b0) begin
            delay_cnt <= 0;
            cnt <= 0;
        end
        else if(cal_finish_plus == 1)begin
            delay_cnt <= $random(seed);
            seed <= seed + 1;
            cnt <= cal_num;
        end
        else if(delay_cnt[2:0] == 0 & cnt != 0)begin
            delay_cnt <= delay_cnt >> 3;
            cnt <= cnt - 1;
        end
        else if(cal_ready == 1 & delay_cnt != 0)begin 
            delay_cnt <= delay_cnt - 1;
        end
        else begin
            delay_cnt <= delay_cnt;
        end
    end
    
    reg [3:0] reg_cal_id;
    reg [14:0] reg_cal_rdata;
    reg [0:0] reg_cal_valid;

    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            reg_cal_valid <= 0;
        end
        else if(cnt != 0 && delay_cnt[2:0] == 0)begin
            reg_cal_valid <= 1;
        end
        else begin
            reg_cal_valid <= 0;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            reg_cal_id<= 0;
            reg_cal_rdata <= 0;
        end else if(idx != 0  & cal_ready == 1 & (cnt != 0 & delay_cnt[2:0] == 0))begin
            reg_cal_id<= id[idx*4 -1 -: 4];
            reg_cal_rdata <= result_mem[ id[idx*4 -1 -: 4]/4 ][ (id[idx*4 - 1 -:4]%4 *16) +:16];
            idx <= idx - 1;
        end else begin
            reg_cal_id <= 0;
            reg_cal_rdata <= 0;
        end
    end

    assign cal_id = reg_cal_id;
    assign cal_rdata = reg_cal_rdata;
    assign cal_valid = reg_cal_valid;

endmodule
