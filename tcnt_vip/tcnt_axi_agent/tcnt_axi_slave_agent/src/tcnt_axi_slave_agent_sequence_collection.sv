`ifndef TCNT_AXI_SLAVE_AGENT_SEQUENCE_COLLECTION__SV
`define TCNT_AXI_SLAVE_AGENT_SEQUENCE_COLLECTION__SV

class tcnt_axi_slave_mem_response_sequence extends tcnt_axi_slave_agent_default_sequence;
    `uvm_object_utils(tcnt_axi_slave_mem_response_sequence)
    tcnt_axi_xaction req_resp;

    function new(string name="svci_axi_slave_base_seq");
        super.new(name);
    endfunction

    virtual function bit randomize_request_response(); 
        return req_resp.randomize();
    endfunction        

    virtual function void pre_randomize_request_response();

    endfunction

    virtual function void post_randomize_request_response();
        foreach(req_resp.wready_delay[i])
            req_resp.wready_delay[i] = 5; 
        foreach(req_resp.rvalid_delay[i])
            req_resp.rvalid_delay[i] = 4;
        req_resp.addr_ready_delay = 3;    
        req_resp.bvalid_delay = 2;       
        req_resp.bresp = tcnt_axi_dec::OKAY;
        foreach(req_resp.rresp[i])
            req_resp.rresp[i] = tcnt_axi_dec::OKAY;
        //req_resp.interleave_enable = 1;
    endfunction

    virtual task body();
        integer status;
        tcnt_axi_cfg get_cfg;
        `uvm_info("body", "Entered ...", UVM_LOW)
       
        p_sequencer.get_cfg(get_cfg);
        if (!$cast(cfg, get_cfg)) begin
            `uvm_fatal("body", "Unable to $cast the configuration to a tcnt_axi_port_configuration class");
        end
        //sink_responses();
        forever begin
            p_sequencer.get_xact(req_resp);
            `uvm_info("slave seq body",$sformatf("get req_resp:\n%0s",req_resp.sprint()),UVM_DEBUG)
            if(req_resp.get_transmitted_channel() == tcnt_axi_dec::WRITE) begin
                put_write_transaction_data_to_mem(req_resp);
            end else if (req_resp.get_transmitted_channel() == tcnt_axi_dec::READ) begin
                get_read_data_from_mem_to_transaction(req_resp);
            end
            if(is_valid_transaction_need_to_put_response(req_resp))begin
                pre_randomize_request_response();
                status = randomize_request_response();
                if(!status)
                    `uvm_fatal("body","Unable to randomize a response")
                post_randomize_request_response();
            end
            $cast(req,req_resp);
            `uvm_send(req)
            `uvm_info("body",{"send to driver:\n",req.sprint()},UVM_DEBUG)
        end
        `uvm_info("body", "Exiting...", UVM_HIGH)
    endtask: body
endclass
`endif
