`ifndef TCNT_APB_AGENT_PKG__SV
`define TCNT_APB_AGENT_PKG__SV

`include "tcnt_apb_common_pkg.sv"
`include "tcnt_apb_master_pkg.sv"
`include "tcnt_apb_slave_pkg.sv"

package tcnt_apb_agent_pkg;
    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;

    import tcnt_apb_dec::*;
    import tcnt_apb_common_pkg::*;
    import tcnt_apb_master_pkg::*;
    import tcnt_apb_slave_pkg::*;
endpackage
import tcnt_apb_agent_pkg::*;
`endif
