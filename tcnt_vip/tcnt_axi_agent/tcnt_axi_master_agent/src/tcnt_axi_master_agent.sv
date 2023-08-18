`ifndef TCNT_AXI_MASTER_AGENT__SV
`define TCNT_AXI_MASTER_AGENT__SV

class tcnt_axi_master_agent  extends tcnt_agent_base#(
                                        .VIF_BUS(virtual tcnt_axi_interface),
                                        .cfg_t(tcnt_axi_cfg),
                                        .seq_t(tcnt_axi_xaction),
                                        .sqr_t(tcnt_axi_master_agent_sequencer),
                                        .drv_t(tcnt_axi_master_agent_driver),
                                        .mon_t(tcnt_axi_monitor));

    `uvm_component_utils(tcnt_axi_master_agent)

    tcnt_axi_protocol_checker           axi_prot_checker;
    tcnt_axi_master_agent_adapter       adapter;
    uvm_reg_block                       regmodel ;
    uvm_reg_map                         maps[$];

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass:tcnt_axi_master_agent

function tcnt_axi_master_agent::new(string name,uvm_component parent);
    super.new(name,parent);
endfunction:new

function void tcnt_axi_master_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    axi_prot_checker = tcnt_axi_protocol_checker::type_id::create("axi_prot_checker",this);
    uvm_config_db#(tcnt_axi_cfg)::set(this,"axi_prot_checker","cfg",cfg);
    uvm_config_db#(virtual tcnt_axi_interface)::set(this,"axi_prot_checker","vif",vif);    

    if(cfg.regmodel_sw == tcnt_dec_base::ON) begin
        adapter = tcnt_axi_master_agent_adapter::type_id::create("adapter", this);
        if(!uvm_config_db#(uvm_reg_block)::get(this, "", "regmodel", regmodel))begin
            `uvm_fatal(get_full_name(), "can not get regmodel") ;
        end
    end

endfunction:build_phase

function void tcnt_axi_master_agent::connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    
    if(cfg.system_coverage_enable) begin
        this.mon_item_port.connect(axi_prot_checker.get_item_port);
    end

    if(cfg.regmodel_sw == tcnt_dec_base::ON) begin
        regmodel.get_maps(maps) ;
        adapter.cfg = cfg ;
        foreach(maps[i]) begin
            maps[i].set_sequencer(sqr, adapter);
            maps[i].set_auto_predict(1);
        end
    end

endfunction:connect_phase

`endif

