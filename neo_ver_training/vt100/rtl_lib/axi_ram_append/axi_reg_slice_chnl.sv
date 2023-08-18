///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  axi_reg_slice_chnl.sv
/// Version      :  1.0
/// 
/// Module Name  :  axi_reg_slice_chnl
/// Abstract     :  axi register slice channel
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module axi_reg_slice_chnl #(
	parameter	TMO			= 0,	//	0-pass through mode
									//	1-forward timing mode
									//	2-full timing mode
									//	3-backward timing mode
	parameter	PLD_W		= 1,
    parameter   DFX_AC      = 1     // 0:default normal 2-slots; 1:for dfx ac coverage
)(
	// Outputs
	output					ready_o,
	output					valid_o,
	output	[PLD_W-1:0]		payload_o,	// output payload signal 

	// Inputs
	input					ready_i,
	input					valid_i,
	input	[PLD_W-1:0]		payload_i,	// input payload signal

	input	aclk,
	input	aresetn
);
// Local parameter declaration
localparam	RS_PAS_TMO	= 0;	//	0-pass through mode
localparam	RS_FWD_TMO	= 1;    //	1-forward timing mode
localparam	RS_FUL_TMO	= 2;    //	2-full timing mode
localparam	RS_BWD_TMO	= 3;    //	3-backward timing mode
// Internal signals declaration

// *******************************************************************
//	Pass through mode:
//		no registers are added to breake timing paths.
// *******************************************************************
generate if(TMO==RS_PAS_TMO)begin:	PAS_TMO_PROC
//

assign ready_o = ready_i;
assign valid_o = valid_i;
assign payload_o = payload_i;

end
// *******************************************************************
//	Forward timing mode:
//		valid_i && payload_i have to be registered.
// *******************************************************************
else if(TMO==RS_FWD_TMO)begin:	FWD_TMO_PROC
//
    cmm_pip_eb #(
    	.DWIDTH		( PLD_W			)
    )U_fwd_eb(
    	.i_clk		( aclk			),
    	.rst_n		( aresetn		),
    	.i_ready	( ready_i		),
    	.i_valid	( valid_i		),
    	.i_data		( payload_i		),
    	.o_valid	( valid_o		),
    	.o_ready	( ready_o		),
    	.o_data		( payload_o		)
    );

end
// *******************************************************************
//	Full timing mode:
//		both forward control path and backward control path have to be
//		registered.
// *******************************************************************
else if(TMO==RS_FUL_TMO)begin:	FUL_TMO_PROC
//
    if(DFX_AC==0)begin  // normal 2slots eb buffer
        cmm_2slots_eb #(
        	.DWIDTH		( PLD_W			)
        )U_ful_eb(
        	.i_clk		( aclk			),
        	.rst_n		( aresetn		),
        	.i_ready	( ready_i		),
        	.i_valid	( valid_i		),
        	.i_data		( payload_i		),
        	.o_valid	( valid_o		),
        	.o_ready	( ready_o		),
        	.o_data		( payload_o		)
        );
    end else begin              // for dfx ac coverage 2slots eb buffer
        cmm_2slots_eb_dfx #(
        	.DWIDTH		( PLD_W			)
        )U_ful_eb_dfx(
        	.i_clk		( aclk			),
        	.rst_n		( aresetn		),
        	.i_ready	( ready_i		),
        	.i_valid	( valid_i		),
        	.i_data		( payload_i		),
        	.o_valid	( valid_o		),
        	.o_ready	( ready_o		),
        	.o_data		( payload_o		)
        );
    end
end
// *******************************************************************
//	Backward timing mode:
//		only ready_i has to be registered.
// *******************************************************************
else if(TMO==RS_BWD_TMO)begin:	BWD_TMO_PROC
//

    cmm_byp_eb #(
    	.DWIDTH		( PLD_W			)
    )U_byp_eb(
    	.i_clk		( aclk			),
    	.rst_n		( aresetn		),
    	.i_ready	( ready_i		),
    	.i_valid	( valid_i		),
    	.i_data		( payload_i		),
    	.o_valid	( valid_o		),
    	.o_ready	( ready_o		),
    	.o_data		( payload_o		)
    );
    
end

endgenerate

endmodule
