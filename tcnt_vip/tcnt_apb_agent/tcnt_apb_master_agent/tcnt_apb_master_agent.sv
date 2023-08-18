`ifndef TCNT_APB_MASTER_AGENT__SV
`define TCNT_APB_MASTER_AGENT__SV

class tcnt_apb_master_agent extends tcnt_agent_base#(
                                            .VIF_BUS(virtual tcnt_apb_interface),
                                            .cfg_t(tcnt_apb_master_agent_cfg),
                                            .seq_t(tcnt_apb_master_agent_transaction),
                                            .sqr_t(tcnt_apb_master_agent_sequencer),
                                            .drv_t(tcnt_apb_master_agent_driver),
                                            .mon_t(tcnt_apb_master_agent_monitor));

    tcnt_apb_protocol_check protocol_check;
    `ifdef FCOV
    tcnt_apb_cov cov;
    `endif
	`uvm_component_utils_begin(tcnt_apb_master_agent)
        `uvm_field_object(protocol_check,UVM_ALL_ON)
        `ifdef FCOV
        `uvm_field_object(cov,UVM_ALL_ON)
        `endif
    `uvm_component_utils_end

	extern function new(string name, uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass

function tcnt_apb_master_agent::new(string name, uvm_component parent=null);
	super.new(name, parent);
endfunction

function void tcnt_apb_master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

    if(this.cfg.apb_protocol_check_enable == 1'b1)begin
        protocol_check = tcnt_apb_protocol_check::type_id::create("protocol_check",this);
        uvm_config_db#(tcnt_apb_cfg)::set(this,"*protocol_check*","cfg",this.cfg);
        uvm_config_db#(virtual tcnt_apb_interface)::set(this,"*protocol_check*","vif",this.vif);
    end

    `ifdef FCOV
    if(this.cfg.apb_cov_enable == 1'b1)begin
        cov = tcnt_apb_cov::type_id::create("cov",this);
    end
    `endif
endfunction

function void tcnt_apb_master_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

    `ifdef FCOV
    if(this.cfg.apb_cov_enable == 1'b1)begin
        this.mon.cov = this.cov;
    end
    `endif
endfunction

`endif
