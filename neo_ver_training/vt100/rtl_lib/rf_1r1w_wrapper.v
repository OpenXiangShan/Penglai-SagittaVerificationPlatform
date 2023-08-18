///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Date         :  2019-4-16
//  Filename     :  rf_1r1w_wrapper.v
/// Version      :  1.0
/// 
/// Module Name  :  rf_1r1w_wrapper
/// Abstract     :  
/// Called by    :  Memory Wrapper     
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module rf_1r1w_wrapper #
    (
        parameter   READ_DELAY      =   1                   , // support 0/1/2
        parameter   ADDR_WIDTH      =   4                   ,
        parameter   DATA_WIDTH      =   16                  ,
        parameter   RF_DEPTH        =   2**ADDR_WIDTH         // reg_file's depth
    )
    ( 
        input                           rst_n_a             ,//Active low Reset
        input                           clk_a               ,//Clock A domain
        input                           init_start_a        ,//Init start setting All RAM data to Zero,pulse sensitive
        output  reg                     init_done_a         ,//Init done
        input                           we_n_a              ,//Active-low Write enable
        input       [ADDR_WIDTH-1:0]    addr_a              ,//Address Write bus
        input       [DATA_WIDTH-1:0]    data_in_a           ,//Date Input bus
        
        input                           rst_n_b             ,//Active low Reset
        input                           clk_b               ,//Clock B domain
        input                           rd_n_b              ,//Active-low Read enable
        input       [ADDR_WIDTH-1:0]    addr_b              ,//Address Write bus
        output      [DATA_WIDTH-1:0]    data_out_b           //Date Output bus  
    );
    
    localparam [RF_DEPTH*DATA_WIDTH-1:0] INIT_VALUE = {RF_DEPTH*DATA_WIDTH{1'b0}};
    
//***************************************************
// declare
//***************************************************
    
    integer                             i_int               ;
    
    reg                                 init_going          ;
    reg     [ADDR_WIDTH-1:0]            init_cnt            ;
    reg     [DATA_WIDTH-1:0]            regfile[0:RF_DEPTH-1];
    reg                                 wr_enable           ;
    reg     [ADDR_WIDTH-1:0]            wr_addr             ;
    reg     [DATA_WIDTH-1:0]            wr_data             ;
    wire                                rd_enable           ;
    wire    [ADDR_WIDTH-1:0]            rd_addr             ;
    reg     [DATA_WIDTH-1:0]            rdata               ;
    
////////////////////////////////////////////////////////////
// CLK DOMAIN: A 
////////////////////////////////////////////////////////////
    always@(posedge clk_a or negedge rst_n_a) 
    begin
        if(~rst_n_a) 
            init_cnt <= {ADDR_WIDTH{1'b0}};
        else if(init_start_a) 
            init_cnt <= {ADDR_WIDTH{1'b0}};
        else if(init_going) 
            init_cnt <= init_cnt + {{(ADDR_WIDTH-1){1'b0}},1'b1};
        else 
            init_cnt <= init_cnt;
    end
    
    always@(posedge clk_a or negedge rst_n_a) 
    begin
        if(~rst_n_a) 
            init_going <= 1'b0;
        else if(init_start_a) 
            init_going <= 1'b1;
        else if(init_cnt == RF_DEPTH - 1) 
            init_going <= 1'b0;
        else 
            init_going <= init_going;
    end
    
    always@(posedge clk_a or negedge rst_n_a) 
    begin
        if(~rst_n_a) 
            init_done_a <= 1'b0;
        else if(init_going && (init_cnt == RF_DEPTH - 1))
            init_done_a <= 1'b1;
        else 
            init_done_a <= 1'b0;
    end
    
    always@(*)
    begin
        if(init_going) 
        begin
            wr_enable           = 1'b1;
            wr_addr             = init_cnt;
            wr_data             = {DATA_WIDTH{1'b0}};
        end
        else
        begin
            wr_enable           = (addr_a < RF_DEPTH)? ~we_n_a : 1'b0;
            wr_addr             = (addr_a < RF_DEPTH)? addr_a : {ADDR_WIDTH{1'b0}};
            wr_data             = data_in_a;
         end
    end
    
    
    always @(posedge clk_a or negedge rst_n_a)
    begin
        if(!rst_n_a)
            for(i_int=0;i_int<RF_DEPTH;i_int=i_int+1)
                regfile[i_int] <= INIT_VALUE[i_int*DATA_WIDTH +: DATA_WIDTH];
        else if(wr_enable == 1'b1) 
            regfile[wr_addr] <= wr_data;
    end

////////////////////////////////////////////////////////////
// CLK DOMAIN: B
////////////////////////////////////////////////////////////
    assign rd_enable = ~rd_n_b;
    assign rd_addr = (addr_b < RF_DEPTH)? addr_b : {ADDR_WIDTH{1'b0}};
    
    generate
        if(READ_DELAY == 0)
        begin : noreged_read_gen
            wire [DATA_WIDTH-1:0] regfile_out = regfile[rd_addr];
            always @( * ) rdata = regfile_out;
        end
        else
        begin : reged_read_gen
            wire [DATA_WIDTH-1:0] regfile_out = regfile[rd_addr];
            always @(posedge clk_b or negedge rst_n_b)
            begin
                if(~rst_n_b)
                    rdata <= {DATA_WIDTH{1'b0}};
                else if(rd_enable == 1'b1)
                    rdata <= regfile_out;
                else
                    rdata <= rdata;
            end
        end
    endgenerate
    
    generate
        if((READ_DELAY == 1) || (READ_DELAY == 0))
        begin : noreged_out_gen
            assign data_out_b = rdata;
        end
        else if(READ_DELAY == 2)
        begin : reged_out_gen
            reg  [DATA_WIDTH-1:0]   rdata_q1;
    
            always @(posedge clk_b or negedge rst_n_b)
            begin
                if(~rst_n_b) 
                    rdata_q1 <= {DATA_WIDTH{1'b0}};
                else 
                    rdata_q1 <= rdata; 
            end
    
            assign data_out_b = rdata_q1;
        end
        else
        begin
            
        end
    endgenerate
       
endmodule
