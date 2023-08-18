`ifndef TCNT_AXI_MACRO_DEFINE__SVH
`define TCNT_AXI_MACRO_DEFINE__SVH
/**

@macrogrouphdr AMBAMACROS AMBA User Modifiable and Non-Modifiable Macros
  @groupref AMBAUSERMODIFIABLE 
  @groupref AMBAUSERNONMODIFIABLE 
  
*/
/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MASTER_IF_HOLD_TIME
    `ifdef VCS 
        `define TCNT_AXI_MASTER_IF_HOLD_TIME 1step
    `else  
        `define TCNT_AXI_MASTER_IF_HOLD_TIME 0.2
    `endif  
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MASTER_IF_SETUP_TIME
    `ifdef VCS
        `define TCNT_AXI_MASTER_IF_SETUP_TIME 1step
    `else
        `define TCNT_AXI_MASTER_IF_SETUP_TIME 0.1 
    `endif
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_SLAVE_IF_HOLD_TIME
    `ifdef VCS
        `define TCNT_AXI_SLAVE_IF_HOLD_TIME 1step
    `else  
        `define TCNT_AXI_SLAVE_IF_HOLD_TIME 0.01
    `endif
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_SLAVE_IF_SETUP_TIME
    `ifdef VCS
        `define TCNT_AXI_SLAVE_IF_SETUP_TIME 1step
    `else
        `define TCNT_AXI_SLAVE_IF_SETUP_TIME 0.01
    `endif
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MONITOR_IF_HOLD_TIME
    `ifdef VCS
        `define TCNT_AXI_MONITOR_IF_HOLD_TIME 1step
    `else  
        `define TCNT_AXI_MONITOR_IF_HOLD_TIME 0.01
    `endif  
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MONITOR_IF_SETUP_TIME
    `ifdef VCS 
        `define TCNT_AXI_MONITOR_IF_SETUP_TIME 1step
    `else   
        `define TCNT_AXI_MONITOR_IF_SETUP_TIME 0.01
    `endif   
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_WSTRB_WIDTH
    `define TCNT_AXI_WSTRB_WIDTH             `TCNT_AXI_MAX_DATA_WIDTH/8                       
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_QOS_WIDTH
    `define TCNT_AXI_QOS_WIDTH               4
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_REGION_WIDTH
    `define TCNT_AXI_REGION_WIDTH            4
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_RESP_WIDTH              
    `define TCNT_AXI_RESP_WIDTH              2
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_BRESP_WIDTH              
    `define TCNT_AXI_BRESP_WIDTH             2
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_DATA_WIDTH
    `define TCNT_AXI_DATA_WIDTH              8
`endif

/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_LOCK_WIDTH
    `define TCNT_AXI_LOCK_WIDTH              2
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_ADDR_WIDTH
    `define TCNT_AXI_MAX_ADDR_WIDTH         64
`endif    
/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_DATA_WIDTH
    `define TCNT_AXI_MAX_DATA_WIDTH         1024
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_ATOMIC_DATA_WIDTH
    `define TCNT_AXI_MAX_ATOMIC_DATA_WIDTH 128
`endif
/**
 @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_ATOMIC_WSTRB_WIDTH
    `define TCNT_AXI_ATOMIC_WSTRB_WIDTH             `TCNT_AXI_MAX_ATOMIC_DATA_WIDTH/8                       
`endif
/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_ID_WIDTH
    `define TCNT_AXI_MAX_ID_WIDTH           8 
`endif
/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_ADDR_USER_WIDTH
    `define TCNT_AXI_MAX_ADDR_USER_WIDTH    4
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_DATA_USER_WIDTH
    `define TCNT_AXI_MAX_DATA_USER_WIDTH    8
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_BRESP_USER_WIDTH
    `define TCNT_AXI_MAX_BRESP_USER_WIDTH   4
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_READ_DATA_REORDERING_DEPTH
    `define TCNT_AXI_MAX_READ_DATA_REORDERING_DEPTH             8
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_WRITE_RESP_REORDERING_DEPTH
    `define TCNT_AXI_MAX_WRITE_RESP_REORDERING_DEPTH            8
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
 `ifndef TCNT_AXI_MAX_READ_DATA_INTERLEAVE_SIZE
    `define TCNT_AXI_MAX_READ_DATA_INTERLEAVE_SIZE              0
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_NUM_OUTSTANDING_XACT
    `define TCNT_AXI_MAX_NUM_OUTSTANDING_XACT                   4
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_SIZE_WIDTH
    `define TCNT_AXI_SIZE_WIDTH              3
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_BURST_WIDTH
    `define TCNT_AXI_BURST_WIDTH             2
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_CACHE_WIDTH
    `define TCNT_AXI_CACHE_WIDTH             4
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_PROT_WIDTH
    `define TCNT_AXI_PROT_WIDTH              3
`endif
 
/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_BURST_LENGTH_WIDTH  
    `define TCNT_AXI_MAX_BURST_LENGTH_WIDTH 10
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_MAX_BURST_LENGTH  
    `define TCNT_AXI_MAX_BURST_LENGTH 256
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_TRANSACTION_ADDR_RANGE_NUM_LSB_BITS
    `define TCNT_AXI_TRANSACTION_ADDR_RANGE_NUM_LSB_BITS 12
`endif

`ifndef TCNT_AXI3_MAX_BURST_LENGTH
    `define TCNT_AXI3_MAX_BURST_LENGTH 16
`endif

/**
  @groupname AMBAUSERMODIFIABLE
*/
`ifndef TCNT_AXI_TRANSACTION_4K_ADDR_RANGE 
    `define TCNT_AXI_TRANSACTION_4K_ADDR_RANGE   (1 << `TCNT_AXI_TRANSACTION_ADDR_RANGE_NUM_LSB_BITS)
`endif

`ifndef TCNT_AXI4_MAX_BURST_LENGTH
    `define TCNT_AXI4_MAX_BURST_LENGTH 256
`endif

`ifndef TCNT_AXI_MAX_AXI3_GENERIC_DELAY
    `define TCNT_AXI_MAX_AXI3_GENERIC_DELAY 16 
`endif

`ifndef TCNT_AXI_MAX_ADDR_VALID_DELAY
    `define TCNT_AXI_MAX_ADDR_VALID_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_ADDR_READY_DELAY
    `define TCNT_AXI_MAX_ADDR_READY_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_WVALID_DELAY
    `define TCNT_AXI_MAX_WVALID_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_WREADY_DELAY
    `define TCNT_AXI_MAX_WREADY_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_RVALID_DELAY
    `define TCNT_AXI_MAX_RVALID_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_RREADY_DELAY
    `define TCNT_AXI_MAX_RREADY_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_BVALID_DELAY
    `define TCNT_AXI_MAX_BVALID_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_MAX_BREADY_DELAY
    `define TCNT_AXI_MAX_BREADY_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
`endif

`ifndef TCNT_AXI_WR_MAX_REGSLICE_SIZE
    `define TCNT_AXI_WR_MAX_REGSLICE_SIZE    7
`endif
`ifndef TCNT_AXI_RD_MAX_REGSLICE_SIZE
    `define TCNT_AXI_RD_MAX_REGSLICE_SIZE    6
`endif

//`ifndef TCNT_AXI_MIN_WRITE_RESP_DELAY
// `define TCNT_AXI_MIN_WRITE_RESP_DELAY 0
//`endif
//
//`ifndef TCNT_AXI_MAX_WRITE_RESP_DELAY
// `define TCNT_AXI_MAX_WRITE_RESP_DELAY `TCNT_AXI_MAX_AXI3_GENERIC_DELAY
//`endif

`endif

