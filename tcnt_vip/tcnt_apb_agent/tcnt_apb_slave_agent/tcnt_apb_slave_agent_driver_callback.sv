`ifndef TCNT_APB_SLAVE_AGENT_DRIVER_CALLBACK__SV
`define TCNT_APB_SLAVE_AGENT_DRIVER_CALLBACK__SV

class tcnt_apb_slave_agent_driver_callback extends uvm_callback;
    function new(string name = "tcnt_apb_master_driver_callback");
        super.new(name);
    endfunction

    virtual task pre_send(tcnt_apb_slave_agent_transaction tr);
    endtask
endclass

`endif
