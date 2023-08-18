`ifndef TCNT_APB_SLAVE_AGENT_CFG__SV
`define TCNT_APB_SLAVE_AGENT_CFG__SV

class tcnt_apb_slave_agent_cfg extends tcnt_apb_cfg;
    bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] start_addr=`TCNT_APB_MAX_ADDR_WIDTH'h0;
    bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] end_addr={`TCNT_APB_MAX_ADDR_WIDTH{1'h1}};
    bit disable_wait_cycles;
    read_default_value_e read_default_value = tcnt_apb_dec::ZERO;

    `uvm_object_utils_begin(tcnt_apb_slave_agent_cfg)
        `uvm_field_int(start_addr, UVM_ALL_ON)
        `uvm_field_int(end_addr, UVM_ALL_ON)
        `uvm_field_int(disable_wait_cycles, UVM_ALL_ON)
        `uvm_field_enum(read_default_value_e,read_default_value,UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="tcnt_apb_slave_agent_cfg");
        super.new(name);
    endfunction:new
endclass

`endif
