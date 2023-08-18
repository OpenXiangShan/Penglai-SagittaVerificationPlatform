`ifndef TCNT_AXI_MASTER_AGENT_DEFAULT_SEQUENCE__SV
`define TCNT_AXI_MASTER_AGENT_DEFAULT_SEQUENCE__SV

typedef tcnt_axi_master_agent_sequencer;
class tcnt_axi_master_agent_default_sequence  extends tcnt_default_sequence_base #(tcnt_axi_xaction);
    `uvm_declare_p_sequencer(tcnt_axi_master_agent_sequencer) 
    //variables declare
    rand int unsigned sequence_num ;
    tcnt_axi_cfg cfg;

    `uvm_object_utils(tcnt_axi_master_agent_default_sequence)

    extern function new(string name="tcnt_axi_master_agent_default_sequence");
    extern virtual task pre_body();
    extern virtual task body();
    extern virtual task post_body();

endclass:tcnt_axi_master_agent_default_sequence

function  tcnt_axi_master_agent_default_sequence::new(string name= "tcnt_axi_master_agent_default_sequence");
    super.new(name);
    
    /*
    tcnt_axi_cfg get_cfg;
    `uvm_info("body", "Entered ...", UVM_LOW)
    
    p_sequencer.get_cfg(get_cfg);
    if (!$cast(cfg, get_cfg)) begin
        `uvm_fatal("body", "Unable to $cast the configuration to a tcnt_axi_port_configuration class");
    end
    */
    
    

endfunction:new 

task tcnt_axi_master_agent_default_sequence::pre_body();  
    tcnt_axi_cfg get_cfg;
    
    if(starting_phase != null) 
        starting_phase.raise_objection(this);

    p_sequencer.get_cfg(get_cfg);
    if (!$cast(cfg, get_cfg)) begin
        `uvm_fatal("body", "Unable to $cast the configuration to a tcnt_axi_port_configuration class");
    end

endtask:pre_body

task tcnt_axi_master_agent_default_sequence::body();

    tcnt_axi_xaction    tr ;
    /*
    tcnt_axi_cfg get_cfg;
    `uvm_info("body", "Entered ...", UVM_LOW)
    
    p_sequencer.get_cfg(get_cfg);
    if (!$cast(cfg, get_cfg)) begin
        `uvm_fatal("body", "Unable to $cast the configuration to a tcnt_axi_port_configuration class");
    end
    */

    //repeat (10) begin
    //    `uvm_do(req)
    //end
    for(int k=0; k<sequence_num; k++) begin
        //set up a transaction
        `uvm_create(tr)
        tr.cfg = cfg ;
        assert(tr.randomize());
        `uvm_info("body", "declare a transaction and randomize it", UVM_DEBUG) ;
        /*
        assert(tr.randomize() with {
                                    enable_interleave == 0;
                                    burst_length == tmp_burst_length ;
                                    xact_type    == svt_xact_type ;
                                   });
        */
        `uvm_info("body", "prepare to send the transaction", UVM_DEBUG) ;
        `uvm_send(tr)
        `uvm_info("body", "sending the transaction completes", UVM_DEBUG) ;

    end

    //get response of transaction 
    for(int k=0; k<sequence_num; k++) begin
        get_response(rsp) ;
    end
endtask:body

task tcnt_axi_master_agent_default_sequence::post_body();
    if(starting_phase != null) 
        starting_phase.drop_objection(this);
endtask:post_body

`endif

