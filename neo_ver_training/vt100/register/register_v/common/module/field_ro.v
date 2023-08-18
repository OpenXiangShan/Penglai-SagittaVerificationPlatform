///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  field_ro.v
/// Date         :  2023-07-03
/// Version      :  1.0
/// 
/// Module Name  :  field_ro
/// Abstract     :  field description  
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
`ifndef FIELD_RO__SV
`define FIELD_RO__SV

module field_ro 
    #(
        parameter FIELD_WIDTH = 1
     )
    (
        input       [FIELD_WIDTH-1:0] field_up     ,
        output wire [FIELD_WIDTH-1:0] field_out ,        
        output wire [FIELD_WIDTH-1:0] field_rd_out 
    );

wire [FIELD_WIDTH-1:0] field;

assign field = field_up;
assign field_rd_out = field;
assign field_out = field;

endmodule

`endif
