`ifndef TCNT_APB_MASTER_AGENT_SEQUENCER__SV
`define TCNT_APB_MASTER_AGENT_SEQUENCER__SV

class tcnt_apb_master_agent_sequencer extends uvm_sequencer #(tcnt_apb_master_agent_transaction);

	`uvm_component_utils(tcnt_apb_master_agent_sequencer)

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction:new
endclass

`endif
