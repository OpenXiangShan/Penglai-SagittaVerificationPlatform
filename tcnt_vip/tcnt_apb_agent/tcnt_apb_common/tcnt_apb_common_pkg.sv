`ifndef TCNT_APB_COMMON_PKG__SV
`define TCNT_APB_COMMON_PKG__SV

`include "tcnt_apb_macro_define.svh"
`include "tcnt_apb_dec.sv"
`include "tcnt_apb_interface.sv"

package tcnt_apb_common_pkg;
    import uvm_pkg::*;
    import tcnt_apb_dec::*;

    `include "tcnt_apb_cfg.sv"
    `include "tcnt_apb_transaction.sv"
    `include "tcnt_apb_protocol_check.sv"
    `include "tcnt_apb_cov.sv"
endpackage
import tcnt_apb_common_pkg::*;

`endif
