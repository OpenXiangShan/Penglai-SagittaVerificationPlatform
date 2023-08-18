`ifndef TCNT_AXI_AGENT_PKG__SV
`define TCNT_AXI_AGENT_PKG__SV

`ifndef HAD_INCLUDE_UVM_MACROS
`define HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

package tcnt_axi_agent_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;
    //import tcnt_axi_master_agent_dec::*;
    import tcnt_axi_master_agent_pkg::*;
    //import tcnt_axi_slave_agent_dec::*;
    import tcnt_axi_slave_agent_pkg::*;


    import tcnt_axi_dec::*;
    import tcnt_axi_common_pkg::*;

    //`include "tcnt_axi_env_cfg.sv"
    //`include "tcnt_axi_rm.sv"
    //`include "tcnt_axi_env.sv"

endpackage

import tcnt_axi_agent_pkg::*;

`endif

