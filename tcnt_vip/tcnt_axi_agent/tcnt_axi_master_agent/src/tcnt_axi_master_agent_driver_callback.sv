`ifndef TCNT_AXI_MASTER_AGENT_DRIVER_CALLBACK__SV
`define TCNT_AXI_MASTER_AGENT_DRIVER_CALLBACK__SV

typedef class tcnt_axi_master_agent_driver;
class tcnt_axi_master_agent_driver_callback extends uvm_callback;
    `uvm_object_utils(tcnt_axi_master_agent_driver_callback)

    function new(string name = "tcnt_axi_master_agent_driver_callback");
        super.new(name);
    endfunction
    
    virtual task pre_drive_awvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_drive_awvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task pre_drive_wvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_drive_wvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task pre_drive_bready(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_drive_bready(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task pre_drive_arvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_drive_arvalid(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task pre_drive_rready(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_drive_rready(tcnt_axi_master_agent_driver driver,ref tcnt_axi_xaction xact, ref virtual tcnt_axi_interface vif); endtask
    virtual task pre_reset(tcnt_axi_master_agent_driver driver, ref virtual tcnt_axi_interface vif); endtask
    virtual task post_reset(tcnt_axi_master_agent_driver driver, ref virtual tcnt_axi_interface vif); endtask
endclass
`endif
