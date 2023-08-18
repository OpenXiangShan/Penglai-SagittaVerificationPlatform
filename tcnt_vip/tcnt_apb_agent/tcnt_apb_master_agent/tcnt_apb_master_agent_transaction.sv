`ifndef TCNT_APB_MASTER_AGENT_TRANSACTION__SV
`define TCNT_APB_MASTER_AGENT_TRANSACTION__SV

class tcnt_apb_master_agent_transaction extends tcnt_apb_transaction;
    tcnt_apb_master_agent_cfg   cfg;

	`uvm_object_utils_begin(tcnt_apb_master_agent_transaction)
        `uvm_field_object(cfg, UVM_ALL_ON)
    `uvm_object_utils_end

	function new(string name = "tcnt_apb_master_agent_transaction");
		super.new(name);
	endfunction
endclass
`endif
