`ifndef TCNT_APB_MACRO_DEFINE__SVH
`define TCNT_APB_MACRO_DEFINE__SVH
/**

@ AMBA APB Macros

*/


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_MASTER_IF_HOLD_TIME
    `define TCNT_APB_MASTER_IF_HOLD_TIME 0.01
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_MASTER_IF_SETUP_TIME
    `define TCNT_APB_MASTER_IF_SETUP_TIME 0.01
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_SLAVE_IF_HOLD_TIME
    `define TCNT_APB_SLAVE_IF_HOLD_TIME 0.01
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_SLAVE_IF_SETUP_TIME
    `define TCNT_APB_SLAVE_IF_SETUP_TIME 0.01
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_MAX_ADDR_WIDTH
    `define TCNT_APB_MAX_ADDR_WIDTH 32

    //`ifndef TCNT_APB_PADDR_WIDTH
    //    `define TCNT_APB_PADDR_WIDTH 32
    //    `define TCNT_APB_MAX_ADDR_WIDTH `TCNT_APB_PADDR_WIDTH
    //`else
    //    `define TCNT_APB_MAX_ADDR_WIDTH `TCNT_APB_PADDR_WIDTH
    //`endif
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_MAX_DATA_WIDTH
    `define TCNT_APB_MAX_DATA_WIDTH 32

    //`ifndef TCNT_APB_PWDATA_WIDTH
    //    `define TCNT_APB_PWDATA_WIDTH 32
    //    `define TCNT_APB_MAX_DATA_WIDTH `TCNT_APB_PWDATA_WIDTH
    //`else
    //    `define TCNT_APB_MAX_DATA_WIDTH `TCNT_APB_PWDATA_WIDTH
    //`endif
`endif


/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_MAX_STRB_WIDTH
    `define TCNT_APB_MAX_STRB_WIDTH `TCNT_APB_MAX_DATA_WIDTH/8
`endif


///**
//  @groupname AMBAUSERMODIFIABLE
//*/
//`ifndef TCNT_APB_PRDATA_WIDTH
//    `define TCNT_APB_PRDATA_WIDTH 32
//`endif


/**
    @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_USER_REQ_WIDTH
    `define TCNT_APB_USER_REQ_WIDTH 32
`endif


/**
    @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_USER_DATA_WIDTH
    `define `TCNT_APB_USER_DATA_WIDTH `TCNT_APB_MAX_DATA_WIDTH/2
`endif


/**
    @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_APB_USER_RESP_WIDTH
    `define TCNT_APB_USER_RESP_WIDTH 8
`endif
`endif //TCNT_APB_MACRO_DEFINE__SVH
