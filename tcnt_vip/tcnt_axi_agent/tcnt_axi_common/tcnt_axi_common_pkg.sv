`ifndef TCNT_AXI_COMMON_PKG__SV
`define TCNT_AXI_COMMON_PKG__SV

`ifndef HAD_INCLUDE_UVM_MACROS
`define HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

`include "tcnt_axi_dec.sv"
`include "tcnt_axi_macro_define.sv"
`include "tcnt_axi_interface.sv"
package tcnt_axi_common_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;

    import tcnt_axi_dec::*;

    `include "tcnt_axi_cfg.sv"
    `include "tcnt_axi_xaction.sv"
    `include "tcnt_axi_mem.sv"
    `include "tcnt_axi_monitor.sv"
    `include "tcnt_axi_cov.sv"
    `include "tcnt_axi_protocol_checker.sv"
endpackage

import tcnt_axi_common_pkg::*;

`endif

