`ifndef TCNT_APB_SLAVE_PKG__SV
`define TCNT_APB_SLAVE_PKG__SV

package tcnt_apb_slave_pkg;
    import uvm_pkg::*;
    import tcnt_apb_dec::*;

    `include "tcnt_apb_mem.sv"
    `include "tcnt_apb_slave_agent_cfg.sv"
    `include "tcnt_apb_slave_agent_transaction.sv"
    `include "tcnt_apb_slave_agent_sequencer.sv"
    `include "tcnt_apb_slave_agent_driver_callback.sv"
    `include "tcnt_apb_slave_agent_driver.sv"
    `include "tcnt_apb_slave_agent_monitor.sv"
    `include "tcnt_apb_slave_agent.sv"
endpackage:tcnt_apb_slave_pkg
import tcnt_apb_slave_pkg::*;

`endif
