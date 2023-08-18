///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
/// Filename     :  cmm_apb2hst.v
/// Date         :  2019-7-25
/// Version      :  1.0
/// 
/// Module Name  :  cmm_apb2hst
/// Abstract     :  The apb interface to VMM RALF's host interface protocol transform.
/// Called by    :  User Application Logic access ralf register from apb.       
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module cmm_apb2hst #
        (
         parameter                 C_AW            = 32 
        )
        (
         input  wire               apb_pclk        ,
         input  wire               apb_presetn     ,
         input  wire               apb_psel        ,
         input  wire               apb_penable     ,
         input  wire               apb_pwrite      ,
         input  wire [2:0]         apb_pprot       , /// Add in APB4.0 
         input  wire [C_AW-1:0]    apb_paddr       ,
         input  wire [31:0]        apb_pwdata      ,
         input  wire [3:0]         apb_pwstrb      , /// Add in APB4.0
         output reg                apb_pready      ,
         output reg  [31:0]        apb_prdata      ,
         output reg                apb_pslverr     ,
                  
         output reg  [3:0]         hst_sel         ,
         output reg  [C_AW-1:0]    hst_addr        ,
         output reg                hst_wen         ,
         output reg  [31:0]        hst_wdat        ,
         input  wire               hst_rack        ,
         input  wire [31:0]        hst_rdat         /// 1, Address Hit; 0, Address not Hit 
        );

/// --------------------------------------------------------------------------------------
///                              Request Channel
/// --------------------------------------------------------------------------------------

/// Write: SEL = write strobe;
/// Read : SEL = All 1s
always @(*) begin
    hst_sel = 4'b0000;
    if (apb_psel && (!apb_penable)) begin
        hst_sel  = apb_pwstrb | {4{~apb_pwrite}}; 
    end 
end  

assign hst_addr    = apb_paddr ;
assign hst_wdat    = apb_pwdata;
assign hst_wen     = apb_pwrite & apb_psel & (~apb_penable);

/// --------------------------------------------------------------------------------------
///                              Response Channel
/// --------------------------------------------------------------------------------------

assign apb_pslverr = 1'b0;

always @(posedge apb_pclk or negedge apb_presetn)
   if (!apb_presetn)
       apb_pready <= 1'b0;
   else 
       apb_pready <= apb_psel & (~apb_penable);


always @(posedge apb_pclk or negedge apb_presetn)
   if (!apb_presetn)
       apb_prdata <= 32'b0;
   else if (apb_psel && (!apb_penable))
       apb_prdata <= hst_rdat;

endmodule
