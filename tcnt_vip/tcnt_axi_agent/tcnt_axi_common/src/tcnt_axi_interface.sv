`ifndef TCNT_AXI_INTERFACE__SV
`define TCNT_AXI_INTERFACE__SV

interface tcnt_axi_interface (input logic aclk,input logic aresetn);
    //-----------------------------------------------------------------------
    // AXI3 Interface Write Address Channel Signals
    //-----------------------------------------------------------------------
    logic                                           awvalid;
    logic [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]            awaddr;
    logic [`TCNT_AXI_MAX_BURST_LENGTH_WIDTH-1:0]    awlen;
    logic [`TCNT_AXI_SIZE_WIDTH-1:0]                awsize;
    logic [`TCNT_AXI_BURST_WIDTH-1:0]               awburst;
    logic [`TCNT_AXI_LOCK_WIDTH-1:0]                awlock;
    logic [`TCNT_AXI_CACHE_WIDTH-1:0]               awcache;
    logic [`TCNT_AXI_PROT_WIDTH-1:0]                awprot;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]              awid;
    logic                                           awready;

    //-----------------------------------------------------------------------
    // AXI Interface Read Address Channel Signals
    //-----------------------------------------------------------------------
    logic                                           arvalid;
    logic [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]            araddr;
    logic [`TCNT_AXI_MAX_BURST_LENGTH_WIDTH-1:0]    arlen;
    logic [`TCNT_AXI_SIZE_WIDTH-1:0]                arsize;
    logic [`TCNT_AXI_BURST_WIDTH-1:0]               arburst;
    logic [`TCNT_AXI_LOCK_WIDTH-1:0]                arlock;
    logic [`TCNT_AXI_CACHE_WIDTH-1:0]               arcache;
    logic [`TCNT_AXI_PROT_WIDTH-1:0]                arprot;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]              arid;
    logic                                           arready;

    //-----------------------------------------------------------------------
    // AXI Interface Read Channel Signals
    //-----------------------------------------------------------------------
    logic [`TCNT_AXI_RD_MAX_REGSLICE_SIZE-2:0]      non_rvalid; //only for non-normal axi useing
    logic                                           rvalid;
    logic                                           rlast;
    logic [`TCNT_AXI_MAX_DATA_WIDTH-1:0]            rdata;
    logic [`TCNT_AXI_RESP_WIDTH-1:0]                rresp;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]              rid;
    logic                                           rready;
    logic [`TCNT_AXI_RD_MAX_REGSLICE_SIZE-2:0]      non_rready; //only for non-normal axi useing

    //-----------------------------------------------------------------------
    // AXI Interface Write Channel Signals
    //-----------------------------------------------------------------------
    logic [`TCNT_AXI_WR_MAX_REGSLICE_SIZE-2:0]      non_wvalid;
    logic                                           wvalid;
    logic                                           wlast;
    logic [`TCNT_AXI_MAX_DATA_WIDTH-1:0]            wdata;
    logic [`TCNT_AXI_MAX_DATA_WIDTH/8-1:0]          wstrb;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]              wid;
    logic                                           wready;
    logic [`TCNT_AXI_WR_MAX_REGSLICE_SIZE-2:0]      non_wready; //only for non-normal axi useing

    //-----------------------------------------------------------------------
    // AXI Interface Write Response Channel Signals
    //-----------------------------------------------------------------------
    logic                                           bvalid;
    logic [`TCNT_AXI_RESP_WIDTH-1:0]                 bresp;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]               bid;
    logic                                           bready;

    //-----------------------------------------------------------------------
    // AXI4 Interface Signals
    //-----------------------------------------------------------------------
    logic [`TCNT_AXI_REGION_WIDTH-1:0]               awregion;
    logic [`TCNT_AXI_QOS_WIDTH-1:0]                  awqos;
    logic [`TCNT_AXI_MAX_ADDR_USER_WIDTH-1:0]        awuser;
    
    logic [`TCNT_AXI_REGION_WIDTH-1:0]               arregion;
    logic [`TCNT_AXI_QOS_WIDTH-1:0]                  arqos;
    logic [`TCNT_AXI_MAX_ADDR_USER_WIDTH-1:0]        aruser;

    logic [`TCNT_AXI_MAX_DATA_USER_WIDTH-1:0]        wuser;
    logic [`TCNT_AXI_MAX_DATA_USER_WIDTH-1:0]        ruser;
    logic [`TCNT_AXI_MAX_BRESP_USER_WIDTH-1:0]       buser;

  // AXI Clocking blocks
  //-----------------------------------------------------------------------
  /**
   * Clocking block that defines VIP AXI Master Interface
   * signal synchronization and directionality.
   */
  clocking axi_master_cb @(posedge aclk);
    default input #`TCNT_AXI_MASTER_IF_SETUP_TIME output #`TCNT_AXI_MASTER_IF_HOLD_TIME;

    input   aresetn ;

    output  awid ;
    output  awaddr ;
    output  awregion ;
    output  awlen ;
    output  awsize ;
    output  awburst ;
    output  awlock ;
    output  awcache ;
    output  awprot ;
    output  awqos ;
    output  awvalid ;
    output  awuser ;
    input   awready ;

    output  wid ;  
    output  wdata ;
    output  wstrb ;
    output  wlast ;
    output  wvalid ;
    output  wuser ;
    input   wready ;
    output  non_wvalid ;
    input   non_wready ;
 
    input   bid ;
    input   bresp ;
    input   bvalid ;
    input   buser ;
    output  bready ;
    
    output  arid ; 
    output  araddr ;
    output  arregion ;
    output  arlen ;
    output  arsize ;
    output  arburst ;
    output  arlock ;
    output  arcache ;
    output  arprot ;
    output  arqos ;
    output  arvalid ;
    output  aruser ;
    input   arready ;

    input   rid ;
    input   rdata ;
    input   rresp ;
    input   rlast ;
    input   rvalid ;
    input   ruser ;
    output  rready ;
    input   non_rvalid ;
    output  non_rready ;

  endclocking : axi_master_cb
  //-----------------------------------------------------------------------
  /**
   * Clocking block that defines the AXI Monitor Interface
   * signal synchronization and directionality.
   */
  clocking axi_monitor_cb @(posedge aclk);
    default input #`TCNT_AXI_MONITOR_IF_SETUP_TIME output #`TCNT_AXI_MONITOR_IF_HOLD_TIME;
    input  aresetn ;

    input  awid ;
    input  awaddr ;
    input  awregion ;
    input  awlen ;
    input  awsize ;
    input  awburst ;
    input  awlock ;
    input  awcache ;
    input  awprot ;
    input  awqos ;
    input  awvalid ;
    input  awuser ;
    input  awready ;

    input  wid ;  
    input  wdata ;
    input  wstrb ;
    input  wlast ;
    input  wvalid ;
    input  wuser ;
    input  wready ;
    input  non_wvalid ;
    input  non_wready ;
 
    input  bid ;
    input  bresp ;
    input  bvalid ;
    input  buser ;
    input  bready ;
    
    input  arid ; 
    input  araddr ;
    input  arregion ;
    input  arlen ;
    input  arsize ;
    input  arburst ;
    input  arlock ;
    input  arcache ;
    input  arprot ;
    input  arqos ;
    input  arvalid ;
    input  aruser ;
    input  arready ;

    input  rid ;
    input  rdata ;
    input  rresp ;
    input  rlast ;
    input  rvalid ;
    input  ruser ;
    input  rready ;
    input  non_rvalid ;
    input  non_rready ;

  endclocking : axi_monitor_cb

  /**
   * Clocking block that defines the VIP AXI slave Interface
   * signal synchronization and directionality.
   */
  clocking axi_slave_cb @(posedge aclk);
    default input #`TCNT_AXI_SLAVE_IF_SETUP_TIME output #`TCNT_AXI_SLAVE_IF_HOLD_TIME;
    input   aresetn ;

    input   awid ;
    input   awaddr ;
    input   awregion ;
    input   awlen ;
    input   awsize ;
    input   awburst ;
    input   awlock ;
    input   awcache ;
    input   awprot ;
    input   awqos ;
    input   awvalid ;
    input   awuser ;
    output  awready ;

    input   wid ;  
    input   wdata ;
    input   wstrb ;
    input   wlast ;
    input   wvalid ;
    input   wuser ;
    output  wready ;
    input   non_wvalid ;
    output  non_wready ;
 
    output  bid ;
    output  bresp ;
    output  bvalid ;
    output  buser ;
    input   bready ;
    
    input   arid ; 
    input   araddr ;
    input   arregion ;
    input   arlen ;
    input   arsize ;
    input   arburst ;
    input   arlock ;
    input   arcache ;
    input   arprot ;
    input   arqos ;
    input   arvalid ;
    input   aruser ;
    output  arready ;

    output  rid ;
    output  rdata ;
    output  rresp ;
    output  rlast ;
    output  rvalid ;
    output  ruser ;
    input   rready ;
    output  non_rvalid ;
    input   non_rready ;

  endclocking : axi_slave_cb
endinterface:tcnt_axi_interface

`endif
