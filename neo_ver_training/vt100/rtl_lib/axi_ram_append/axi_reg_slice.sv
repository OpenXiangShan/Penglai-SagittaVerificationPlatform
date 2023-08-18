///******************************************************************
///
/// copyright 2022, Tencent Verification Team
/// All rights reserved
///
/// Project Name :  Sagitta_Neo VT100
//  File name    :  axi_reg_slice.sv
/// Version      :  1.0
/// 
/// Module Name  :  axi_reg_slice
/// Abstract     :  Register slice for axi five channels
///
/// Modification History
/// -----------------------------------------------------------------
/// $Log$  V0.1 first created
///******************************************************************
module axi_reg_slice #(
	parameter	DW				= 32,	// data width
	parameter	AW				= 32,	// address width
	parameter	SW				= 4,	// byte enable: SW = DW/8
	parameter	LW				= 4,	// burst length
	parameter	IDW				= 6,	// id
    parameter   AWUW            = 16,   // AWUSER
    parameter   ARUW            = 16,   // ARUSER
	parameter	RUW				= 8,	// RUSER
	parameter	WUW				= 4,	// WUSER
	parameter	BUW				= 4,	// BUSER
	parameter	AW_TMO			= 2,	// 0-pass through mode, 1-forward timing mode, 2-full timing mode, 3-backward timing mode
	parameter	AR_TMO			= 2,	// 0-pass through mode, 1-forward timing mode, 2-full timing mode, 3-backward timing mode 
	parameter	R_TMO			= 2,	// 0-pass through mode, 1-forward timing mode, 2-full timing mode, 3-backward timing mode
	parameter	W_TMO			= 2,	// 0-pass through mode, 1-forward timing mode, 2-full timing mode, 3-backward timing mode
	parameter	B_TMO			= 2,	// 0-pass through mode, 1-forward timing mode, 2-full timing mode, 3-backward timing mode

    parameter   DFX_AC          = 0,    // 1:for dfx ac coverage; 0:normal 2-slots;

	//localparam	RS_LTW			= 1,	// AWLOCK/ARLOCK
	parameter	RS_LTW			= 1,	// AWLOCK/ARLOCK
	localparam	RS_QOS_W		= 4,	// QOS
	localparam	RS_BRESPW		= 2,	// write response
	localparam	RS_RRESPW		= 2		// read response
)(
	// Write address channel
	input	[IDW-1:0]		awid_m,
	input	[AW-1:0]		awaddr_m,
	input	[LW-1:0]		awlen_m,
	input	[2:0]			awsize_m,
	input	[1:0]			awburst_m,
	input	[RS_LTW-1:0]	awlock_m,
	input	[3:0]			awcache_m,
	input	[2:0]			awprot_m,
	input					awvalid_m,
	input					awready_s,
    input   [AWUW-1:0]      awuser_m,
	input	[RS_QOS_W-1:0]	awqos_m,
	
	output	[IDW-1:0]		awid_s,
	output	[AW-1:0]		awaddr_s,
	output	[LW-1:0]		awlen_s,
	output	[2:0]			awsize_s,
	output	[1:0]			awburst_s,
	output	[RS_LTW-1:0]	awlock_s,
	output	[3:0]			awcache_s,
	output	[2:0]			awprot_s,
	output					awvalid_s,
	output					awready_m,
    output  [AWUW-1:0]      awuser_s,
	output	[RS_QOS_W-1:0]	awqos_s,

	// Read address channel
	input	[IDW-1:0]		arid_m,
	input	[AW-1:0]		araddr_m,
	input	[LW-1:0]		arlen_m,
	input	[2:0]			arsize_m,
	input	[1:0]			arburst_m,
	input	[RS_LTW-1:0]	arlock_m,
	input	[3:0]			arcache_m,
	input	[2:0]			arprot_m,
	input					arvalid_m,
	input					arready_s,
    input   [ARUW-1:0]      aruser_m,
	input	[RS_QOS_W-1:0]	arqos_m,
	
	output	[IDW-1:0]		arid_s,
	output	[AW-1:0]		araddr_s,
	output	[LW-1:0]		arlen_s,
	output	[2:0]			arsize_s,
	output	[1:0]			arburst_s,
	output	[RS_LTW-1:0]	arlock_s,
	output	[3:0]			arcache_s,
	output	[2:0]			arprot_s,
	output					arvalid_s,
	output					arready_m,
    output  [ARUW-1:0]      aruser_s,
	output	[RS_QOS_W-1:0]	arqos_s,

	// Write data channel
	input	[IDW-1:0]		wid_m,
	input	[DW-1:0]		wdata_m,
	input	[SW-1:0]		wstrb_m,
	input					wlast_m,
	input					wvalid_m,
	input					wready_s,
	input	[WUW-1:0]		wuser_m,
	
	output	[IDW-1:0]		wid_s,
	output	[DW-1:0]		wdata_s,
	output	[SW-1:0]		wstrb_s,
	output					wlast_s,
	output					wvalid_s,
	output					wready_m,
	output	[WUW-1:0]		wuser_s,

	// Write response channel
	input	[IDW-1:0]		bid_s,
	input	[1:0]			bresp_s,
	input					bvalid_s,
	input					bready_m,
	input	[BUW-1:0]		buser_s,

	output	[IDW-1:0]		bid_m,
	output	[1:0]			bresp_m,
	output					bvalid_m,
	output					bready_s,
	output	[BUW-1:0]		buser_m,

	// Read data channel
	input	[IDW-1:0]		rid_s,	
	input	[DW-1:0]		rdata_s,
	input	[1:0]			rresp_s,
	input					rlast_s,
	input					rvalid_s,
	input					rready_m,
	input	[RUW-1:0]		ruser_s,

	output	[IDW-1:0]		rid_m,	
	output	[DW-1:0]		rdata_m,
	output	[1:0]			rresp_m,
	output					rlast_m,
	output					rvalid_m,
	output					rready_s,
	output	[RUW-1:0]		ruser_m,

	// Global
	input	aclk,
	input	aresetn
);
// Local parameter declaration
localparam  RS_AW_PLD_W = IDW + AW + LW + 3 + 2 + RS_LTW + 4 + AWUW + RS_QOS_W + 3;
localparam  RS_AR_PLD_W = IDW + AW + LW + 3 + 2 + RS_LTW + 4 + ARUW + RS_QOS_W + 3; 
localparam	RS_W_PLD_W	= IDW + WUW + DW + SW + 1;
localparam	RS_B_PLD_W	= BUW + IDW + RS_BRESPW;
localparam	RS_R_PLD_W	= RUW + IDW + DW + RS_RRESPW + 1;

// Instantiate axi_slice_chnl for write address channel
axi_reg_slice_chnl #(
	.TMO				(AW_TMO),
	.PLD_W				(RS_AW_PLD_W),
    .DFX_AC             (DFX_AC)    
) u_aw_chnl(
	// Outputs singals
	.ready_o			(	awready_m),
	.valid_o			(	awvalid_s),
	.payload_o			({	awid_s,
							awaddr_s,
							awlen_s,
							awsize_s,
							awburst_s,
							awlock_s,
							awcache_s,
							awprot_s,
							awuser_s,
							awqos_s
						}),
	// Input signals    
	.ready_i			(	awready_s),
	.valid_i			(	awvalid_m),
	.payload_i			({	awid_m,
							awaddr_m,
							awlen_m,
							awsize_m,
							awburst_m,
							awlock_m,
							awcache_m,
							awprot_m,
							awuser_m,
							awqos_m
						}),
	.aclk				(	aclk),
	.aresetn			(	aresetn)
);

// Instantiate axi_slice_chnl for read address channel
axi_reg_slice_chnl #(
	.TMO				(AR_TMO),
	.PLD_W				(RS_AR_PLD_W),
    .DFX_AC             (DFX_AC)    
) u_ar_chnl(
	// Outputs singals
	.ready_o			(	arready_m),
	.valid_o			(	arvalid_s),
	.payload_o			({	arid_s,
							araddr_s,
							arlen_s,
							arsize_s,
							arburst_s,
							arlock_s,
							arcache_s,
							arprot_s,
							aruser_s,
							arqos_s
						}),
	// Input signals    
	.ready_i			(	arready_s),
	.valid_i			(	arvalid_m),
	.payload_i			({	arid_m,
							araddr_m,
							arlen_m,
							arsize_m,
							arburst_m,
							arlock_m,
							arcache_m,
							arprot_m,
							aruser_m,
							arqos_m
						}),
	.aclk				(	aclk),
	.aresetn			(	aresetn)
);

// Instantiate axi_slice_chnl for write data channel
axi_reg_slice_chnl #(
	.TMO				(W_TMO),
	.PLD_W				(RS_W_PLD_W),
    .DFX_AC             (DFX_AC)    
) u_w_chnl(
	// Outputs singals
	.ready_o			(	wready_m),
	.valid_o			(	wvalid_s),
	.payload_o			({	wid_s,
                            wdata_s,
							wstrb_s,
							wlast_s,
							wuser_s
						}),
	// Input signals    
	.ready_i			(	wready_s),
	.valid_i			(	wvalid_m),
	.payload_i			({	wid_m,
                            wdata_m,
							wstrb_m,
							wlast_m,
							wuser_m
						}),
	.aclk				(	aclk),
	.aresetn			(	aresetn)
);

// Instantiate axi_slice_chnl for write response channel
axi_reg_slice_chnl #(
	.TMO				(B_TMO),
	.PLD_W				(RS_B_PLD_W),
    .DFX_AC             (DFX_AC)    
) u_b_chnl(
	// Output signals    
	.ready_o			(	bready_s),
	.valid_o			(	bvalid_m),
	.payload_o			({	bid_m,
							bresp_m,
							buser_m
						}),
	// Inputs singals
	.ready_i			(	bready_m),
	.valid_i			(	bvalid_s),
	.payload_i			({	bid_s,
							bresp_s,
							buser_s
						}),
	.aclk				(	aclk),
	.aresetn			(	aresetn)
);

// Instantiate axi_slice_chnl for read data channel
axi_reg_slice_chnl #(
	.TMO				(R_TMO),
	.PLD_W				(RS_R_PLD_W),
    .DFX_AC             (DFX_AC)    
) u_r_chnl(
	// Output signals    
	.ready_o			(	rready_s),
	.valid_o			(	rvalid_m),
	.payload_o			({	rid_m,
							rdata_m,
							rresp_m,
							rlast_m,
							ruser_m
						}),
	// Inputs singals
	.ready_i			(	rready_m),
	.valid_i			(	rvalid_s),
	.payload_i			({	rid_s,
							rdata_s,
							rresp_s,
							rlast_s,
							ruser_s
						}),
	.aclk				(	aclk),
	.aresetn			(	aresetn)
);

endmodule
