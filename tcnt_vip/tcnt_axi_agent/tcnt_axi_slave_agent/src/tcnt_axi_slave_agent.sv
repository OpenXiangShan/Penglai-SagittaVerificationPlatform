`ifndef TCNT_AXI_SLAVE_AGENT__SV
`define TCNT_AXI_SLAVE_AGENT__SV

class tcnt_axi_slave_agent  extends tcnt_agent_base#(
                                        .VIF_BUS(virtual tcnt_axi_interface),
                                        .cfg_t(tcnt_axi_cfg),
                                        .seq_t(tcnt_axi_xaction),
                                        .sqr_t(tcnt_axi_slave_agent_sequencer),
                                        .drv_t(tcnt_axi_slave_agent_driver),
                                        .mon_t(tcnt_axi_monitor));

    `uvm_component_utils(tcnt_axi_slave_agent)
    
    tcnt_axi_protocol_checker axi_prot_checker;
    tcnt_axi_mem axi_slave_mem;

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass:tcnt_axi_slave_agent

function tcnt_axi_slave_agent::new(string name,uvm_component parent);
    super.new(name,parent);
endfunction:new

function void tcnt_axi_slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(uvm_config_db#(tcnt_axi_mem)::get(this,"","axi_slave_mem",this.axi_slave_mem)) begin
        //`uvm_info(get_type_name(),$sformatf("get axi_slave_mem from config_db."));
        `uvm_info(get_type_name(),"get axi_slave_mem from config_db.", UVM_LOW);
    end else begin
        axi_slave_mem = tcnt_axi_mem::type_id::create("axi_slave_mem");
    end
    axi_prot_checker = tcnt_axi_protocol_checker::type_id::create("axi_prot_checker",this);
    uvm_config_db#(tcnt_axi_cfg)::set(this,"axi_prot_checker","cfg",cfg);
    uvm_config_db#(virtual tcnt_axi_interface)::set(this,"axi_prot_checker","vif",vif);
endfunction:build_phase

function void tcnt_axi_slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("","in axi slave agent connect phase",UVM_DEBUG)
    mon.to_slave_sequencer_port.connect(sqr.response_request_port); 
    sqr.mem_handle       = this.axi_slave_mem; 
    sqr.vif              = this.vif;
    `uvm_info("","get out of axi slave agent connect phase",UVM_DEBUG)
    if(cfg.system_coverage_enable)
        this.mon_item_port.connect(axi_prot_checker.get_item_port);
endfunction:connect_phase

`endif

