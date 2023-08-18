///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Date         :  2021-12-28
/// Version      :  1.0
/// 
/// Module Name  :  codec_cmm_sad
/// Abstract     :  calculate WxN matrix SAD value
/// Called by    :           
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module codec_cmm_sad#(
    parameter   DW  =  8 ,
    parameter   W   =  8 , //only support 4/8/16/32/64/128
    parameter   H   =  8   //only support 1/2/4/8/16/32/64/128
) 
(
    input                               clk         ,   
    input                               rst_n       ,

    input                               input_vld   ,
    input      [DW*W-1          :0]     input_data1 ,//unsigned data
    input      [DW*W-1          :0]     input_data2 ,//unsigned data

    output reg                          sad_vld     ,
    output reg [DW+$clog2(W*H)-1:0]     sad 
);

    wire [W-1             :0] ad_vld       ;
    wire [DW*W-1          :0] ad           ;
    wire                      line_sad_vld ;
    wire [DW+$clog2(W)-1  :0] line_sad     ;
    reg  [DW+$clog2(W*H)-1:0] tmp_sad      ;
    reg  [$clog2(H)-1     :0] acc_count    ;

    genvar i;
    generate
        for(i = 0; i < W; i = i + 1)
        begin:abs_sub_inst
            codec_cmm_abs_sub #(
                .DW     (DW)
            ) u_codec_cmm_abs_sub (
                .clk        ( clk                    ), 
                .rst_n      ( rst_n                  ), 
                .input_vld  ( input_vld              ),
                .a          ( input_data1[i*DW+:DW]  ), 
                .b          ( input_data2[i*DW+:DW]  ), 
                .output_vld ( ad_vld[i]              ),
                .c          ( ad[i*DW+:DW]           )
            );
        end
    endgenerate

    //row acc
    codec_cmm_adder_tree #(
        .N     ( W   ),
        .DW    ( DW  )
    ) u_codec_cmm_adder_tree (
        .clk        ( clk          ),
        .rst_n      ( rst_n        ),
        .input_vld  ( ad_vld[0]    ),
        .input_data ( ad           ),
        .output_vld ( line_sad_vld ),
        .output_sum ( line_sad     )
    );

    //column acc
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            acc_count <= 'd0;
        else if(line_sad_vld)
        begin
            if(acc_count == H-1)
                acc_count <= 'd0;
            else 
                acc_count <= acc_count + 1;
        end
    end

    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            tmp_sad <= 'd0;
        else if(line_sad_vld)
        begin
            if(acc_count == H-1)
                tmp_sad <= 'd0;
            else 
                tmp_sad <= tmp_sad + line_sad;
        end
        else 
            tmp_sad <= tmp_sad;
    end

    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            sad <= 'd0 ;
        else if(line_sad_vld && acc_count == H-1)
            sad <= tmp_sad + line_sad;
        else 
            sad <= sad;
    end

    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            sad_vld <= 1'b0;
        else if(line_sad_vld && acc_count == H-1)
            sad_vld <= 1'b1;
        else 
            sad_vld <= 1'b0;
    end
           
endmodule