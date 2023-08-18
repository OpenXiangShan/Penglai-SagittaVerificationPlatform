///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Date         :  2021-12-17 16:40:58
/// Version      :  1.0
/// 
/// Module Name  :  codec_cmm_adder_tree
/// Abstract     :  
/// Called by    :           
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************

module codec_cmm_adder_tree #(
    parameter     N  = 16, //must be a power base 2
    parameter     DW = 16  //input data width
)
(
    input                            clk         ,
    input                            rst_n       ,

    input                            input_vld   ,
    input  [DW*N-1        :0]        input_data  ,

    output                           output_vld  ,
    output [DW+$clog2(N)-1:0]        output_sum
);
    
    genvar i, j;

    reg [$clog2(N)-1    :0] pipeline_vld;
    reg [DW+$clog2(N)-1 :0] pipeline [$clog2(N)-1:0][N/2-1:0];   // Pipeline array


    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n) 
            pipeline_vld <= 'd0;
        else
            pipeline_vld <= {pipeline_vld[$clog2(N)-2:0],input_vld};
    end
        
    generate
        for (i = 0; i < $clog2(N); i = i + 1) begin
            for (j = 0; j < (2**($clog2(N)-i))/2; j = j + 1) begin
                if(i == 0)
                begin 
                    always @(posedge clk or negedge rst_n) 
                    begin
                        if(!rst_n)
                            pipeline[0][j] <= 'd0;
                        else if(input_vld)
                            pipeline[0][j] <= input_data[j*DW +: DW] + input_data[(N/2+j)*DW +: DW];
                    end
                end 
                else 
                begin
                    always @(posedge clk or negedge rst_n) 
                    begin
                        if(!rst_n)
                            pipeline[i][j] <= 'd0;
                        else if(pipeline_vld[i-1])
                            pipeline[i][j] <= pipeline[i-1][j] + pipeline[i-1][((2**($clog2(N)-i))/2+j)];
                    end
                end
            end
        end
    endgenerate

    assign output_vld = pipeline_vld[$clog2(N)-1];
    assign output_sum = pipeline[$clog2(N)-1][0];
endmodule
    