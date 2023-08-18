`ifndef TCNT_AXI_MASTER_AGENT_SEQUENCER__SV
`define TCNT_AXI_MASTER_AGENT_SEQUENCER__SV

typedef tcnt_axi_master_agent ;
class tcnt_axi_master_agent_sequencer  extends tcnt_sequencer_base #(tcnt_axi_xaction);
    `uvm_component_utils(tcnt_axi_master_agent_sequencer)
    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
    extern virtual function void get_cfg(output tcnt_axi_cfg cfg);
endclass:tcnt_axi_master_agent_sequencer

function tcnt_axi_master_agent_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction:new

task tcnt_axi_master_agent_sequencer::main_phase(uvm_phase phase);

    tcnt_axi_master_agent_default_sequence seq;

    super.main_phase(phase);
    /*
    phase.raise_objection(this);
    seq = tcnt_axi_master_agent_default_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this);
    phase.drop_objection(this);
    */

endtask:main_phase

function void tcnt_axi_master_agent_sequencer::get_cfg(output tcnt_axi_cfg cfg);
    tcnt_axi_master_agent mst_agt;
    if(!$cast(mst_agt,this.get_parent()))
        `uvm_fatal(get_type_name(),"Failed to cast axi master sequencer's parent to axi_master_agent type.")
    cfg = mst_agt.cfg;
    /*
    if(!uvm_config_db#(tcnt_axi_cfg)::get(this, "", "cfg", cfg))begin
        `uvm_fatal(get_full_name(), "can not get tcnt_axi_cfg") ;
    end
    */


endfunction

`endif

