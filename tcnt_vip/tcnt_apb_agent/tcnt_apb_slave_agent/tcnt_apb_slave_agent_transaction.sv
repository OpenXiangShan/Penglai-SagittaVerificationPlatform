`ifndef TCNT_APB_SLAVE_AGENT_TRANSACTION__SV
`define TCNT_APB_SLAVE_AGENT_TRANSACTION__SV

class tcnt_apb_slave_agent_transaction extends tcnt_apb_transaction;
    tcnt_apb_slave_agent_cfg cfg;
    rand int num_wait_cycles;

    `uvm_object_utils_begin(tcnt_apb_slave_agent_transaction)
        `uvm_field_object(cfg, UVM_ALL_ON)
        `uvm_field_int(num_wait_cycles, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "tcnt_apb_slave_agent_transaction");
        super.new(name);
    endfunction

    extern constraint resonable_num_wait_cycles;
endclass

constraint tcnt_apb_slave_agent_transaction::resonable_num_wait_cycles{
    num_wait_cycles dist {0:/7, [1:4]:/2, [5:10]:/1};    
}
`endif
