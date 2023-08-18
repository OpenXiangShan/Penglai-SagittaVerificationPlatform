`ifndef TCNT_APB_MASTER_AGENT_CFG__SV
`define TCNT_APB_MASTER_AGENT_CFG__SV

class tcnt_apb_master_agent_cfg extends tcnt_apb_cfg;
    int unsigned slave_pready_timeout = 0;

	`uvm_object_utils_begin(tcnt_apb_master_agent_cfg)
        `uvm_field_int(slave_pready_timeout, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="tcnt_apb_master_agent_cfg");
		super.new(name);
	endfunction:new
endclass:tcnt_apb_master_agent_cfg

`endif
