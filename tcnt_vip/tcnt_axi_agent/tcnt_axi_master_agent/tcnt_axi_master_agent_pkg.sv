`ifndef TCNT_AXI_MASTER_AGENT_PKG__SV
`define TCNT_AXI_MASTER_AGENT_PKG__SV

`ifndef HAD_INCLUDE_UVM_MACROS
`define HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

package tcnt_axi_master_agent_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;

    import tcnt_axi_dec::*;
    import tcnt_axi_common_pkg::*;

    `include "tcnt_axi_master_agent_default_sequence.sv"
    `include "tcnt_axi_master_agent_driver_callback.sv"
    `include "tcnt_axi_master_agent_driver.sv"
    `include "tcnt_axi_master_agent_sequencer.sv"
    `include "tcnt_axi_master_agent_adapter.sv"
    `include "tcnt_axi_master_agent.sv"

endpackage

import tcnt_axi_master_agent_pkg::*;

`endif

