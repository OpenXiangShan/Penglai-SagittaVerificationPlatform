`ifndef TCNT_APB_MASTER_AGENT_SEQUENCE__SV
`define TCNT_APB_MASTER_AGENT_SEQUENCE__SV

class tcnt_apb_master_agent_sequence extends tcnt_default_sequence_base #(tcnt_apb_master_agent_transaction);
	tcnt_apb_master_agent_transaction  trans;
    bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0]  addr;
    bit[`TCNT_APB_MAX_DATA_WIDTH-1:0]  data;
    bit[`TCNT_APB_MAX_STRB_WIDTH-1:0]  pstrb;
    tcnt_apb_dec::pprot0_enum          pprot0;
    tcnt_apb_dec::pprot1_enum          pprot1;
    tcnt_apb_dec::pprot2_enum          pprot2;
    tcnt_apb_dec::xact_type_e          xact_type;
    bit[`TCNT_APB_USER_REQ_WIDTH-1:0]  auser;
    bit[`TCNT_APB_USER_DATA_WIDTH-1:0] wuser;

	`uvm_object_utils(tcnt_apb_master_agent_sequence)

	function new(string name = "tcnt_apb_master_agent_sequence");
		super.new(name);
	endfunction

	virtual task body();
        `uvm_create(trans)
        assert(trans.randomize());
        trans.addr = this.addr;
        trans.data = this.data;
        trans.pstrb = this.pstrb;
        trans.pprot0 = this.pprot0;
        trans.pprot1 = this.pprot1;
        trans.pprot2 = this.pprot2;
        trans.xact_type = this.xact_type;
        trans.auser = this.auser;
        trans.wuser = this.wuser;
        `uvm_send(trans)

        if(xact_type==tcnt_apb_dec::READ)begin
            get_response(rsp);
            data = rsp.data;
        end
	endtask
endclass

`endif
