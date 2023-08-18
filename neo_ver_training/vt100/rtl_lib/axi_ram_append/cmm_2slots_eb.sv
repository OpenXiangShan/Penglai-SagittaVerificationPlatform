///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  cmm_2slots_eb.sv
/// Version      :  1.0
/// 
/// Module Name  :  cmm_2slots_eb
/// Abstract     :  2 slots buffer
//                  full throughput
//                  register in/out for o_ready and i_ready
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module cmm_2slots_eb #(
    parameter   DWIDTH = 16 
) (                            
    input                   i_clk,   
    input                   rst_n,
    input                   i_ready, 
    input                   i_valid,   
    input  [DWIDTH-1:0]     i_data,
    output                  o_valid,   
    output                  o_ready,   
    output  [DWIDTH-1:0]    o_data
);

wire                  byp_o_valid;
wire                  byp_o_ready;
wire  [DWIDTH-1:0]    byp_o_data;

cmm_byp_eb #(
    .DWIDTH                         ( DWIDTH                        ))
U_cmm_BYP_EB_0(
    .i_clk                          ( i_clk                         ),
    .rst_n                          ( rst_n                         ),
    .i_ready                        ( byp_o_ready                   ),
    .i_valid                        ( i_valid                       ),
    .i_data                         ( i_data                        ),
    .o_valid                        ( byp_o_valid                   ),
    .o_ready                        ( o_ready		                ),
    .o_data                         ( byp_o_data                    )
);

cmm_pip_eb #(
    .DWIDTH                         ( DWIDTH                        ))
U_cmm_PIP_EB_0(
    .i_clk                          ( i_clk                         ),
    .rst_n                          ( rst_n                         ),
    .i_ready                        ( i_ready						),
    .i_valid                        ( byp_o_valid                   ),
    .i_data                         ( byp_o_data                    ),
    .o_valid                        ( o_valid                       ),
    .o_ready                        ( byp_o_ready					),
    .o_data                         ( o_data                        )
);
//
//cmm_byp_eb #(
//    .DWIDTH                         ( DWIDTH                        ))
//U_cmm_BYP_EB_0(
//    .i_clk                          ( i_clk                         ),
//    .rst_n                          ( rst_n                         ),
//    .i_ready                        ( i_ready                       ),
//    .i_valid                        ( i_valid                       ),
//    .i_data                         ( i_data                        ),
//    .o_valid                        ( byp_o_valid                   ),
//    .o_ready                        ( byp_o_ready                   ),
//    .o_data                         ( byp_o_data                    )
//);
//
//cmm_pip_eb #(
//    .DWIDTH                         ( DWIDTH                        ))
//U_cmm_PIP_EB_0(
//    .i_clk                          ( i_clk                         ),
//    .rst_n                          ( rst_n                         ),
//    .i_ready                        ( byp_o_ready                   ),
//    .i_valid                        ( byp_o_valid                   ),
//    .i_data                         ( byp_o_data                    ),
//    .o_valid                        ( o_valid                       ),
//    .o_ready                        ( o_ready                       ),
//    .o_data                         ( o_data                        )
//);

endmodule
