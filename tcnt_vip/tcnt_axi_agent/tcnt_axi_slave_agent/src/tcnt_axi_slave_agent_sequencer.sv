`ifndef TCNT_AXI_SLAVE_AGENT_SEQUENCER__SV
`define TCNT_AXI_SLAVE_AGENT_SEQUENCER__SV
typedef tcnt_axi_slave_agent ;
class tcnt_axi_slave_agent_sequencer extends tcnt_sequencer_base #(tcnt_axi_xaction);
    `uvm_component_utils(tcnt_axi_slave_agent_sequencer)

    uvm_analysis_imp#(tcnt_axi_xaction,tcnt_axi_slave_agent_sequencer)  response_request_port;
    tcnt_axi_mem mem_handle;
    tcnt_axi_xaction xact_from_monitor_q[$];
    int unique_id_q[$];
    virtual tcnt_axi_interface vif;
    string tname;

    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern virtual function void get_cfg(output tcnt_axi_cfg cfg);
    extern virtual function void write(tcnt_axi_xaction xact);
    extern virtual task get_xact(output tcnt_axi_xaction xact);
    extern virtual function void do_reset_clear();
endclass:tcnt_axi_slave_agent_sequencer

function tcnt_axi_slave_agent_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
    tname = get_name();
endfunction:new

function void tcnt_axi_slave_agent_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
    response_request_port = new("response_request_port",this);
endfunction

function void tcnt_axi_slave_agent_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction

function void tcnt_axi_slave_agent_sequencer::do_reset_clear();
    // no need to reset mem, keep init_value set before. by yohjiwang 2022/6/16
    //mem_handle.delete_mem();
    `uvm_info(tname,"got reset and do reset clear.",UVM_LOW)
    xact_from_monitor_q.delete();
    unique_id_q.delete();
endfunction

function void tcnt_axi_slave_agent_sequencer::write(tcnt_axi_xaction xact);
    tcnt_axi_xaction tr;
    `uvm_info(tname,{"Get xact in axi slave sequencer:\n",xact.sprint()},UVM_DEBUG)
    if($cast(tr,xact.clone()))begin
        xact_from_monitor_q.push_back(tr);
        `uvm_info(tname,$sformatf("tr of unique_id[0x%0h] push_back",tr.unique_id),UVM_DEBUG)
    end else
        `uvm_fatal(tname,"cast tcnt_axi_xaction xact failed.")
endfunction

// can not use function
// Inappropriate prefix for the specified built-in task/function.
`define SET_XACT_RAND_MODE(XACT)        \
begin                                   \
    XACT.rand_mode(0);                  \
    XACT.wready_delay.rand_mode(1);     \
    XACT.rvalid_delay.rand_mode(1);     \
    XACT.addr_ready_delay.rand_mode(1); \
    XACT.bvalid_delay.rand_mode(1);     \
    XACT.bresp.rand_mode(1);            \
    XACT.rresp.rand_mode(1);            \
    XACT.interleave_enable.rand_mode(1);\
    XACT.burst_length.rand_mode(0);     \
    XACT.data_size_cons.constraint_mode(0); \
    XACT.addr_range_cons.constraint_mode(0);\
end

task tcnt_axi_slave_agent_sequencer::get_xact(output tcnt_axi_xaction xact);
    wait(xact_from_monitor_q.size() > 0);
    xact = xact_from_monitor_q.pop_front();
    `SET_XACT_RAND_MODE(xact);
endtask

function void tcnt_axi_slave_agent_sequencer::get_cfg(output tcnt_axi_cfg cfg);
    tcnt_axi_slave_agent slv_agt;
    if(!$cast(slv_agt,this.get_parent()))
        `uvm_fatal(tname,"Failed to cast axi slave sequencer's parent to axi_slave_agent type.")
    cfg = slv_agt.cfg;
endfunction

task tcnt_axi_slave_agent_sequencer::main_phase(uvm_phase phase);
    tcnt_axi_slave_agent_default_sequence seq;
    super.main_phase(phase);
    phase.raise_objection(this);
    seq = tcnt_axi_slave_agent_default_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this);
    phase.drop_objection(this);
endtask:main_phase

task tcnt_axi_slave_agent_sequencer::run_phase(uvm_phase phase);
    fork
        super.run_phase(phase);
        while(1)begin
            wait(vif.aresetn === 1'b0);
            do_reset_clear();
            wait(vif.aresetn === 1'b1);
        end
    join
    
endtask
`endif

