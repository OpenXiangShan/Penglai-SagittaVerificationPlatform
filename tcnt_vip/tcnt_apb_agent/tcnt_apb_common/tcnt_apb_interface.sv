`ifndef TCNT_APB_INTERFACE__SV
`define TCNT_APB_INTERFACE__SV

interface tcnt_apb_interface(input logic pclk, input logic prstn);
	wire [`TCNT_APB_MAX_ADDR_WIDTH-1:0] paddr  ;
	wire                                psel   ;
	wire                                pready ;
	wire                                penable;
	wire                                pwrite ;
    wire [2:0]                          pprot  ;
    wire [`TCNT_APB_MAX_STRB_WIDTH-1:0] pstrb  ;
	wire [`TCNT_APB_MAX_DATA_WIDTH-1:0] pwdata ;
	wire [`TCNT_APB_MAX_DATA_WIDTH-1:0] prdata ;
    wire                                pslverr;
    wire [`TCNT_APB_USER_REQ_WIDTH-1:0] pauser ;
    wire [`TCNT_APB_USER_DATA_WIDTH-1:0]pwuser ;
    wire [`TCNT_APB_USER_DATA_WIDTH-1:0]pruser ;
    wire [`TCNT_APB_USER_RESP_WIDTH-1:0]pbuser ;

	clocking master_cb @(posedge pclk or negedge prstn) ;
		default  input  #`TCNT_APB_MASTER_IF_SETUP_TIME;
		default  output #`TCNT_APB_MASTER_IF_HOLD_TIME;
		output paddr, psel, penable, pwrite, pprot, pstrb, pwdata, pauser, pwuser;
		input  prdata, pready, pslverr, pruser, pbuser;
	endclocking:master_cb

    clocking slave_cb @(posedge pclk or negedge prstn);
        default input  #`TCNT_APB_SLAVE_IF_SETUP_TIME;
        default output #`TCNT_APB_SLAVE_IF_HOLD_TIME;
        input  paddr, psel, penable, pwrite, pprot, pstrb, pwdata, pauser, pwuser;
        output prdata, pready, pslverr, pruser, pbuser;
    endclocking:slave_cb

    clocking monitor_cb @(posedge pclk or negedge prstn);
        default input  #`TCNT_APB_SLAVE_IF_SETUP_TIME;
        input  paddr, psel, penable, pwrite, pprot, pstrb, pwdata, prdata, pready, pslverr, pauser, pwuser, pruser, pbuser;
    endclocking:monitor_cb

	modport master(clocking master_cb);
    modport active(clocking slave_cb);
    modport passive(clocking monitor_cb);
endinterface:tcnt_apb_interface

`endif
