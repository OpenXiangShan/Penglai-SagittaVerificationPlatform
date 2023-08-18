//****************************************************************************************
//
// copyright 2017,Tencent Verification Team
// All rights reserved
//
// Project Name :   Sagitta_Neo VT100
// Filename     :   cmm_bsc_sfifo_ctl.v
// Date         :   2017.11.11
// Version      :   1.0
// 
// Module Name  :   cmm_bsc_sfifo_ctl
//
//                                   
// Modification History
// ---------------------------------------------------------------------------------------
// $Log$
//
//****************************************************************************************    
module cmm_bsc_sfifo_ctl #
        (
         parameter                  C_HF             = 64      , // Height to assert full, it is must no more than 2**C_AW
         parameter                  C_HAF            = 32      , // Height to assert almost full
         parameter                  C_HAE            = 2       , // Height to assert almost empty
         parameter                  C_AW             = 6       , // Address Width of the FIFO, it is must no less than log2(HF)
         parameter                  C_OFP            = 1'b1    ,
         parameter                  C_UFP            = 1'b1 
        )                           
        (
         input     wire             clk              , // clock
         input     wire             rst_n            , // Reset, active high
         input     wire             we               , // Write enable
         output    reg   [C_AW-1:0] waddr            , // Write address
         output    wire  [C_AW:0]   wleft            , // Data left in write port
         output    reg              wfull            , // Full
         output    reg              awfull           , // Almost full  
         output    reg              oflw             ,
         input     wire             re               , // Read enable
         output    reg   [C_AW-1:0] raddr            , // Read address
         output    wire  [C_AW:0]   rleft            , // Data left in read port
         output    reg              rempty           , // Empty
         output    reg              arempty          , // Almost empty
         output    reg              uflw       
        ); 
        
// ------------------------------------------------------------------         
//              Parameter Declaration                        
// ------------------------------------------------------------------         
        
localparam        C_LW         = C_AW + 1;      
localparam        C_HE         = 0;
        
// ------------------------------------------------------------------
//              Internal Variables Declaration        
// ------------------------------------------------------------------ 

wire              winc        ; 
wire              rinc        ; 

reg    [C_LW-1:0] data_left   ;

// ------------------------------------------------------------------
//                    RAM address generation      
// ------------------------------------------------------------------ 

// Read and Write Protection Circuit 
assign winc      = (C_OFP) ?  (we & (~wfull )) : we;
assign rinc      = (C_UFP) ?  (re & (~rempty)) : re;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        waddr <= {C_AW{1'b0}};
    else if(winc)
        waddr <= (waddr == C_HF-1) ? {C_AW{1'b0}} : waddr + 1'b1;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        raddr <= {C_AW{1'b0}};
    else if(rinc)
        raddr <= (raddr == C_HF-1) ? {C_AW{1'b0}} : raddr + 1'b1;
        
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        data_left<= {C_LW{1'b0}};
    else 
        case ({winc,rinc   })
            2'b10  : data_left<= data_left+ 1'b1;
            2'b01  : data_left<= data_left- 1'b1;
            default: data_left<= data_left;
        endcase        
        
        
        
// ------------------------------------------------------------------
//                     FIFO Write Operation       
// ------------------------------------------------------------------ 

assign wleft = data_left;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        wfull  <= 1'b0;
    else
        case ({winc,rinc   })
            2'b10  : wfull     <= (wleft== (C_HF-1)) ? 1'b1 : wfull;
            2'b01  : wfull     <= (wleft== (C_HF  )) ? 1'b0 : wfull;
            default: wfull     <= wfull;
        endcase
        
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        awfull  <= 1'b0;
    else
        case ({winc,rinc   })
            2'b10  : awfull    <= (wleft== (C_HAF-1)) ? 1'b1 : awfull;
            2'b01  : awfull    <= (wleft== (C_HAF  )) ? 1'b0 : awfull;
            default: awfull    <= awfull;
        endcase
        
always @(posedge clk or negedge rst_n)
    if (!rst_n)   
        oflw   <= 1'b0;
    else
        oflw   <= wfull & we;  

// ------------------------------------------------------------------
//                     FIFO Read Operation       
// ------------------------------------------------------------------  

assign rleft = data_left; 
       
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        rempty <= 1'b1;
    else 
        case ({winc   ,rinc})
            2'b10  : rempty    <= (rleft == (C_HE  ))  ? 1'b0 : rempty;
            2'b01  : rempty    <= (rleft == (C_HE+1))  ? 1'b1 : rempty;
            default: rempty    <= rempty ;
        endcase
        
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        arempty <= 1'b1;
    else 
        case ({winc   ,rinc})
            2'b10  : arempty   <= (rleft == (C_HAE  )) ? 1'b0 : arempty;
            2'b01  : arempty   <= (rleft == (C_HAE+1)) ? 1'b1 : arempty;
            default: arempty   <= arempty ;
        endcase        

always @(posedge clk or negedge rst_n)
    if (!rst_n)   
        uflw   <= 1'b0;
    else
        uflw   <= rempty & re;              
                
endmodule
