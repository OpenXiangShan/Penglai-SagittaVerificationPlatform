`ifndef TCNT_APB_TRANSACTION__SV
`define TCNT_APB_TRANSACTION__SV

class tcnt_apb_transaction extends tcnt_data_base;
    rand bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0]  addr;
    rand bit[`TCNT_APB_MAX_DATA_WIDTH-1:0]  data;
    rand bit[`TCNT_APB_MAX_STRB_WIDTH-1:0]  pstrb;
    rand tcnt_apb_dec::pprot0_enum          pprot0;
    rand tcnt_apb_dec::pprot1_enum          pprot1;
    rand tcnt_apb_dec::pprot2_enum          pprot2;
    rand tcnt_apb_dec::xact_type_e          xact_type;
    rand bit[`TCNT_APB_USER_REQ_WIDTH-1:0]  auser;
    rand bit[`TCNT_APB_USER_DATA_WIDTH-1:0] wuser;
    bit pslverr;

	`uvm_object_utils_begin(tcnt_apb_transaction)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(pstrb,UVM_ALL_ON)
        `uvm_field_enum(tcnt_apb_dec::pprot0_enum,pprot0, UVM_ALL_ON)
        `uvm_field_enum(tcnt_apb_dec::pprot1_enum,pprot1, UVM_ALL_ON)
        `uvm_field_enum(tcnt_apb_dec::pprot2_enum,pprot2, UVM_ALL_ON)
        `uvm_field_enum(tcnt_apb_dec::xact_type_e,xact_type, UVM_ALL_ON)
        `uvm_field_int(auser, UVM_ALL_ON)
        `uvm_field_int(wuser, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "tcnt_apb_transaction");
		super.new(name);
	endfunction

endclass

`endif
