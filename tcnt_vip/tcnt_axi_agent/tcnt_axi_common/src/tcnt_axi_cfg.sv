`ifndef TCNT_AXI_CFG__SV
`define TCNT_AXI_CFG__SV

class tcnt_axi_cfg extends tcnt_agent_cfg_base ;

    /** 
      * @groupname axi_generic_config
      * The AXI interface type that is being modelled. Please note that interface
      * type AXI_STREAM is not yet supported.
      * Configuration type: Static
      */
    rand axi_interface_type_enum axi_interface_type = tcnt_axi_dec::AXI4;

    /**
      * @groupname axi_generic_config
      * Indicates whether this port is a master or a slave. User does not need to
      * configure this parameter. It is set by the VIP to reflect whether the port
      * represented by this configuration is of kind master or slave.
      */    
    axi_port_kind_enum     axi_port_kind = tcnt_axi_dec::AXI_MASTER;

    /** 
      * @groupname axi4_signal_width
      * Address user width of this port in bits.
      *
      * Configuratio/n type: Static
      */             
    rand int addr_width = `TCNT_AXI_MAX_ADDR_WIDTH;
                     
    /**              
      * @groupname a xi4_signal_width
      * Address user width of this port in bits.
      *
      * Configuration type: Static
      */
    rand int addr_user_width = `TCNT_AXI_MAX_ADDR_USER_WIDTH;

    /** 
      * @groupname axi3_signal_width
      * Data width of this port in bits.
      *
      * Configuration type: Static
      */
    rand int data_width = `TCNT_AXI_MAX_DATA_WIDTH;

    /** 
      * @groupname axi4_signal_width
      * Data user width of this port in bits.
      *
      * Configuration type: Static
      */
    rand int data_user_width = `TCNT_AXI_MAX_DATA_USER_WIDTH;
 
    /** 
      * @groupname axi4_signal_width
      * Response user width of this port in bits.
      *
      * Configuration type: Static
      */
    rand int resp_user_width = `TCNT_AXI_MAX_BRESP_USER_WIDTH;

    /**
      * @groupname axi3_signal_width
      * Indicates if separate widths are required for ID  of write channel 
      * (AWID,WID and BID) and for ID of read channel(ARID and RID).
      * If set to 1, read_chan_id_width and write_chan_id_width are used
      * for setting the widths of the ID signals of corresponding channels.
      * If set to 0, id_width is used for setting the widths of all
      * ID signals.
      * This value must be consistent across all the ports in the system.
      *
      * Configuration type: Static
      */
    rand bit use_separate_rd_wr_chan_id_width = 0;

    /**
      * @groupname axi3_signal_width
      * If port is of kind MASTER:
      * This parameter defines the ID width of the master.
      * <br>
      * If port is of kind SLAVE:
      * This parameter defines the ID width of the slave. If an
      * interconnect is present, the ID width of the slave should
      * consider the maximum ID width of the masters in the system
      * and also consider additional bits required to represent
      * each master in the system.
      * <br>
      * Valid only when use_separate_rd_wr_chan_id_width is set to 0.
      *
      * Configuration type: Static
      */
    rand int id_width  = `TCNT_AXI_MAX_ID_WIDTH;

    /**
      * @groupname axi3_signal_width
      * Represents the width of ARID and RID.  
      * Valid only when use_separate_rd_wr_chan_id_width is set to 1.
      * For slaves, the same considerations given for id_width are applicable.
      *
      * Configuration type: Static
      */
    rand int read_chan_id_width = `TCNT_AXI_MAX_ID_WIDTH;

    /**
      * @groupname axi3_signal_width
      * Represents the width of AWID, WID and BID.  
      * Valid only when use_separate_rd_wr_chan_id_width is set to 1.
      * For slaves, the same considerations given for id_width are applicable.
      *
      * Configuration type: Static
      */
    rand int write_chan_id_width = `TCNT_AXI_MAX_ID_WIDTH;

    /** 
      * @groupname axi3_4_config
      * The number of addresses pending in the slave that can be 
      * reordered. A slave that processes all transactions in  
      * order has a read ordering depth of one.
      * This parameter’s max value is defined by macro TCNT_AXI_MAX_READ_DATA_REORDERING_DEPTH. 
      * The default value of this macro is 8, and is user configurable. 
      * Refer section 3.3.7 of AXI user manual for more info on System Constants.
      * <b>min val:</b> 1
      * <b>max val:</b> \`TCNT_AXI_MAX_READ_DATA_REORDERING_DEPTH (Value defined by macro TCNT_AXI_MAX_READ_DATA_REORDERING_DEPTH. Default value is 8.)
      * <b>type:</b> Static 
      */
    rand int read_data_reordering_depth = 1;

    /** 
     * @groupname axi3_4_config
     * The number of responses pending in the slave that can be 
     * reordered. A slave that processes all transactions in  
     * order has a write resp ordering depth of one.
     * This parameter’s max value is defined by macro TCNT_AXI_MAX_WRITE_RESP_REORDERING_DEPTH. 
     * The default value of this macro is 8, and is user configurable. 
     * Refer section 3.3.7 of AXI user manual for more info on System Constants.
     * <b>min val:</b> 1
     * <b>max val:</b> \`TCNT_AXI_MAX_WRITE_RESP_REORDERING_DEPTH (Value defined by macro TCNT_AXI_MAX_WRITE_RESP_REORDERING_DEPTH. Default value is 8.)
     * <b>type:</b> Static 
     */
    rand int write_resp_reordering_depth = 1;

    /**
     * @groupname axi3_4_config
     * Specifies how the reordering depth of transactions moves.
     * 
     * Applicable only to the READ data and WRITE resp transactions processed by ACTIVE Slave.
     */
    rand reordering_window_enum reordering_window = MOVING;

    /**
      * @groupname axi3_4_config
      * Specifies the number of beats of read data that must stay 
      * together before it can be interleaved with read data from a
      * different transaction.
      * When set to 0, interleaving is not allowed.
      * When set to 1, there is no restriction on interleaving.
      * <b>min val:</b> 0
      * <b>max val:</b> \`TCNT_AXI_MAX_READ_DATA_INTERLEAVE_SIZE 
      * <b>type:</b> Static 
      */
    rand int read_data_interleave_size = 0;

    /**
     * @groupname axi3_4_config
     * Specifies the reordering algorithm used for reordering the 
     * transactions or responses.
     * 
     * Applicable only to the READ data and WRITE resp transactions processed by ACTIVE Slave.
     */
    rand reordering_algorithm_enum reordering_algorithm = ROUND_ROBIN;

    /** 
      * @groupname axi3_4_config
      * Specifies the number of outstanding transactions a master/slave
      * can support.
      * num_outstanding_xact = -1 is not supported for AXI4_STREAM
      * <br>
      * MASTER:
      * If the number of outstanding transactions is equal to this
      * number, the master will refrain from initiating any new 
      * transactions until the number of outstanding transactions
      * is less than this parameter.
      * <br>
      * SLAVE:
      * If the number of outstanding transactions is equal to 
      * this number, the slave will not assert ARREADY/AWREADY
      * until the number of outstanding transactions becomes less
      * than this parameter. 
      * <br>
      * If #num_outstanding_xact = -1 then #num_outstanding_xact will not 
      * be considered , instead #num_read_outstanding_xact and 
      * #num_write_outstanding_xact have an effect.
      * - <b>min val:</b> 1
      * - <b>max val:</b> Value defined by macro TCNT_AXI_MAX_NUM_OUTSTANDING_XACT. Default value is 4.
      * - <b>type:</b> Static
      * .
      */ 
    rand int num_outstanding_xact = 4;

    /**
      * @groupname axi3_4_config
      * Specifies the number of READ outstanding transactions a master/slave
      * can support.
      * <br>
      * MASTER:
      * If the number of outstanding transactions is equal to this
      * number, the master will refrain from initiating any new 
      * transactions until the number of outstanding transactions
      * is less than this parameter.
      * <br>
      * SLAVE:
      * If the number of outstanding transactions is equal to 
      * this number, the slave will not assert ARREADY
      * until the number of outstanding transactions becomes less
      * than this parameter. 
      * <br>
      * This parameter will have an effect only if #num_outstanding_xact = -1.
      * - <b>min val:</b> 1
      * - <b>max val:</b> Value defined by macro TCNT_AXI_MAX_NUM_OUTSTANDING_XACT. Default value is 4.
      * - <b>type:</b> Static
      * .
      */ 
    rand int num_read_outstanding_xact = 4;

    /** 
      * @groupname axi3_4_config
      * Specifies the number of WRITE outstanding transactions a master/slave
      * can support.
      * <br>
      * MASTER:
      * If the number of outstanding transactions is equal to this
      * number, the master will refrain from initiating any new 
      * transactions until the number of outstanding transactions
      * is less than this parameter.
      * <br>
      * SLAVE:
      * If the number of outstanding transactions is equal to 
      * this number, the slave will not assert AWREADY
      * until the number of outstanding transactions becomes less
      * than this parameter. 
      * <br>
      * This parameter will have an effect only if #num_outstanding_xact = -1.
      * - <b>min val:</b> 1
      * - <b>max val:</b> Value defined by macro TCNT_AXI_MAX_NUM_OUTSTANDING_XACT. Default value is 4.
      * - <b>type:</b> Static
      * .
      */ 
    rand int num_write_outstanding_xact = 4;
    /** 
      * @groupname default_ready
      * Default value of AWREADY signal. 
      * <b>type:</b> Dynamic
      */
    rand bit default_awready = 1;

    /** 
      * @groupname default_ready
      * Default value of WREADY signal. 
      * <b>type:</b> Dynamic
      */
    rand bit default_wready = 1; 

    /** 
      * @groupname default_ready
      * Default value of ARREADY signal. 
      * <b>type:</b> Dynamic
      */
    rand bit default_arready = 1;

    /** 
     * @groupname default_ready
     * Default value of RREADY signal. 
     * <b>type:</b> Dynamic 
     */
    rand bit default_rready = 1;

    /** 
      * @groupname default_ready
      * Default value of BREADY signal. 
      * <b>type:</b> Dynamic 
      */
    rand bit default_bready = 1;
    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWREGION signal in the VIP 
      * <b>type:</b> Static
      */

    rand bit awregion_enable   = 0;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARREGION signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arregion_enable   = 0;
 
    /** @cond PRIVATE */
    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWID signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awid_enable       = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWLEN signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awlen_enable   = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWSIZE signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awsize_enable     = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWBURST signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awburst_enable    = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWLOCK signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awlock_enable     = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWCACHE signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awcache_enable    = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWPROT signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awprot_enable     = 1;
    /** @endcond */

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the AWQOS signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit awqos_enable      = 0;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the WLAST signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit wlast_enable      = 1;

    /** @cond PRIVATE */
    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the WSTRB signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit wstrb_enable      = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the BID signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit bid_enable        = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the BRESP signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit bresp_enable      = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARID signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arid_enable       = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARLEN signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arlen_enable   = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARSIZE signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arsize_enable     = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARBURST signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arburst_enable    = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARLOCK signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arlock_enable     = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARCACHE signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arcache_enable    = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARPROT signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arprot_enable     = 1;
    /** @endcond */

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the ARQOS signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit arqos_enable      = 0;

    /** @cond PRIVATE */
    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the RID signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit rid_enable        = 1;

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the RRESP signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit rresp_enable      = 1;
    /** @endcond */

    /** 
      * @groupname axi4_signal_enable
      * Signifies the presence of the RLAST signal in the VIP 
      * <b>type:</b> Static
      */
    rand bit rlast_enable      = 1;

    /** 
      * @groupname axi3_4_config
      * Enables AWUSER sideband signal in the VIP. AWUSER signal can be used when 
      * tcnt_axi_cfg::axi_interface_type is set to
      * AXI3/AXI4/AXI4_LITE/AXI_ACE/ACE_LITE. 
      * <b>type:</b> Static
      */
    rand bit awuser_enable      = 0;

    /** 
      * @groupname axi3_4_config
      * Enables WUSER sideband signal in the VIP. WUSER signal can be used when 
      * tcnt_axi_cfg::axi_interface_type is set to
      * AXI3/AXI4/AXI4_LITE/AXI_ACE/ACE_LITE. 
      * <b>type:</b> Static
      */
    rand bit wuser_enable      = 0;

    /** 
      * @groupname axi3_4_config
      * Enables BUSER sideband signal in the VIP. BUSER signal can be used when 
      * tcnt_axi_cfg::axi_interface_type is set to
      * AXI3/AXI4/AXI4_LITE/AXI_ACE/ACE_LITE. 
      * <b>type:</b> Static
      */
    rand bit buser_enable      = 0;

    /** 
      * @groupname axi3_4_config
      * Enables ARUSER sideband signal in the VIP. ARUSER signal can be used when
      * tcnt_axi_cfg::axi_interface_type is set to
      * AXI3/AXI4/AXI4_LITE/AXI_ACE/ACE_LITE. 
      * <b>type:</b> Static
      */
    rand bit aruser_enable      = 0;

    /** 
      * @groupname axi3_4_config
      * Enables RUSER sideband signal in the VIP. RUSER signal can be used when 
      * tcnt_axi_cfg::axi_interface_type is set to
      * AXI3/AXI4/AXI4_LITE/AXI_ACE/ACE_LITE. 
      * <b>type:</b> Static
      */
    rand bit ruser_enable      = 0;

    /**
     * @groupname axi3_4_timeout
     * When the AWVALID signal goes high, this watchdog 
     * timer monitors the AWREADY signal for the channel. If AWREADY is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when AWREADY is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     * 
     * Configuration type: Dynamic 
     */
    int awready_watchdog_timeout = 256000;

    /**
     * @groupname axi3_4_timeout
     * When the WVALID signal goes high, this watchdog 
     * timer monitors the WREADY signal for the channel. If WREADY is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when WREADY is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic  
     */
    int wready_watchdog_timeout = 1000;

    /**
     * @groupname axi3_4_timeout
     * When the ARVALID signal goes high, this watchdog 
     * timer monitors the ARREADY signal for the channel. If ARREADY is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when ARREADY is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic 
     */
    int arready_watchdog_timeout = 256000;

    /**
     * @groupname axi3_4_timeout
     * When the RVALID signal goes high, this watchdog 
     * timer monitors the RREADY signal for the channel. If RREADY is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when RREADY is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic 
     */
    int rready_watchdog_timeout = 1000;

    /**
     * @groupname axi3_4_timeout
     * When the read addr handshake ends this watchdog timer monitors the 
     * assertion of first RVALID signal for the channel. If RVALID is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when RVALID is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic 
     */
    int unsigned rdata_watchdog_timeout = 256000;

    /**
     * @groupname axi3_4_timeout
     * When the BVALID signal goes high, this watchdog 
     * timer monitors the BREADY signal for the channel. If BREADY is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when BREADY is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic  
     */
    int bready_watchdog_timeout = 1000;

    /**
     * @groupname axi3_4_timeout
     * After the last write data beat, this watchdog timer monitors  
     * the write response signals for the channel. If BVALID is low, 
     * then the timer starts. The timer is incremented by 1 every clock and
     * is reset when BVALID is sampled high. If the number of clock cycles 
     * exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic  
     */
    int unsigned bresp_watchdog_timeout = 256*1000;

    /**
     * @groupname axi3_4_timeout
     * When exclusive read request comes, this watchdog timer monitors
     * the exclusive read transaction. If matching exclusive write
     * request doesn't come, then the timer starts.
     * The timer is incremented by 1 every clock and is reset 
     * when matching exclusive write request comes 
     * If the number of clock cycles exceeds this value, an error is reported. 
     * If this value is set to 0 the timer is not started.
     *
     * Configuration type: Dynamic 
     */
    int excl_wr_watchdog_timeout = 0;

    /**
     * @groupname axi3_4_timeout
     * When write address handshake happens (data after address scenario), 
     * this watchdog timer monitors assertion of WVALID signal. When WVALID 
     * is low, the timer starts. The timer is incremented by 1 every clock 
     * and is reset when WVALID is asserted. If the number of clock cycles 
     * exceeds this value, an error is reported. If this value is set to 0 
     * the timer is not started.
     *
     * Configuration type: Dynamic  
     */
    int unsigned wdata_watchdog_timeout = 256000;

    /**
     * @groupname axi3_4_timeout
     * When first write data handshake happens (data before address scenario), 
     * this watchdog timer monitors assertion of AWVALID signal. When AWVALID 
     * is low, the timer starts. The timer is incremented by 1 every clock and 
     * is reset when AWVALID is asserted. If the number of clock cycles exceeds 
     * this value, an error is reported. If this value is set to 0 the timer 
     * is not started.
     *
     * Configuration type: Dynamic  
     */
    int unsigned awaddr_watchdog_timeout = 256000;
    
    /**
    * @groupname axi3_4_timeout_config
    * A timer which is started when a transaction starts. If the transaction
    * does not complete by the set time, an error is repoted. The timer is
    * incremented by 1 every clock and is reset when the transaction ends. 
    * If set to 0, the timer is not started
    */
    int xact_watchdog_timeout = 0;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables protocol checking. In a disabled state, no protocol
      * violation messages (error or warning) are issued.
      * <b>type:</b> Dynamic 
      */
    bit protocol_checks_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables signal valid check during coresponding signal is valid when protocol_checks_enable=1. 
      * When set to '1', enables signal valid check during coresponding signal is valid.
      * When set to '0', disables signal valid check during coresponding signal is valid. In a disabled
      * state, no signal valid check during coresponding signal is valid violation messages (error or warning) are issued.
      * <b>type:</b> Static 
      */
    bit signal_valid_checks_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables signal stable check during coresponding signal is valid when protocol_checks_enable=1. 
      * When set to '1', enables signal stable check during coresponding signal is valid.
      * When set to '0', disables signal stable check during coresponding signal is valid. In a disabled
      * state, no signal stable check during coresponding signal is valid violation messages (error or warning) are issued.
      * <b>type:</b> Static 
      */
    bit signal_stable_checks_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables signal valid check during reset when protocol_checks_enable=1. 
      * When set to '1', enables signal valid check during reset.
      * When set to '0', disables signal valid check during reset. In a disabled
      * state, no signal valid check during reset violation messages (error or warning) are issued.
      * <b>type:</b> Static 
      */
    bit signal_valid_during_reset_checks_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables checking of wdata/tdata only on valid byte lanes based on wstrb/tstrb. 
      * In a disabled state, whole wdata/tdata as seen on the bus will be considered.
      * <b>type:</b> Dynamic 
      */
    bit check_valid_data_bytes_only_enable = 1;

    /**
      * @groupname axi3_4_timeout_config
      * A timer which is started when a transaction starts. If the transaction
      * does not complete by the set time, an error is repoted. The timer is
      * incremented by 1 every clock and is reset when the transaction ends. 
      * If set to 0, the timer is not started
      */
    int xact_inactivity_timeout = 0;

    /**
      @grouphdr axi_performance_analysis Performance Analysis configuration parameters
      This group contains attributes which are used to monitor performance of a
      system based on measurement of latencies, throughput etc. The user sets the
      performance constraints through performance analysis configuration
      parameters and the VIP reports any violations on these constraints. The time
      unit for all these parameters is the simulation time unit. Performance
      metrics that involve aggregation of values over a time period are measured
      over time intervals specified using configuration parameter
      perf_recording_interval. Measurement of other performance parameters that do
      not require aggregation of values over a time period are not affected by
      this configuration parameter. VIP reports statistics for each performance
      metric for each time interval. Each performance parameter can be enabled or
      disabled at any time.  Monitoring of a performance parameter is disabled by
      passing a value of -1 to the parameter. Passing any other value enables the
      performance parameter for measurement. If a value other than -1 is supplied,
      it will take effect at the next time interval. If the performance
      configuration parameter values are changed during simulation, the new
      configuration will need to be passed to the VIP using the #reconfigure()
      method of the top level VIP component, for eg. #reconfigure() method of AXI
      System Env will need to be called if AXI system Env is used as top level
      component.
      */

    /**
      * @groupname axi_performance_analysis 
      * The interval based on which performance parameters are monitored and
      * reported. The simulation time is divided into time intervals specified by this
      * parameter and performance parameters are monitored and reported based on
      * these. Typically, this interval affects measurement of performance
      * parameters that require aggregation of values across several transactions
      * such as the average latency for a transaction to complete. The unit for
      * this parameter is the same as the simulation time unit.
      * When set to 0, the total simulation time is not divided into time intervals.
      * For example, consider that this parameter is set to 1000 and that the
      * simulation time unit is 1ns. Then, all performance metrics that require
      * aggregation will be measured separately for each 1000 ns. Also, min and max
      * performance parameters will be reported separately for each time interval.
      * If this parameter is changed dynamically, the new value will take effect
      * only after the current time interval elapses.
      * <br>
      * When set to -1, tcnt_axi_port_perf_status::start_performance_monitoring() and
      * tcnt_axi_port_perf_status::stop_performance_monitoring() needs to be used to
      * indicate the start and stop events for the performance monitoring. If the
      * start and stop events are not indicated, the performance monitoring will not 
      * be enabled. If the stop event is not indicated after issuing a start event,
      * the port monitor stops the performance monitoring in the extract phase.
      * Note that any constraint checks will be performed only during the monitoring period.
      * <b>type:</b> Dynamic
      */
    real perf_recording_interval = 0;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed duration for a write
      * transaction to complete. The duration is measured as the time when the
      * the transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      */
    real perf_max_write_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum duration for a write transaction to
      * complete. The duration is measured as the time when the the transaction
      * is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_write_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum expected average duration for a write
      * transaction. The average is calculated over a time interval specified by
      * perf_recording_interval. A violation is reported if the computed average
      * duration is more than this parameter. The duration is measured as the time
      * when the the transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_avg_max_write_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected average duration for a write
      * transaction. The average is calculated over a time interval specified by
      * perf_recording_interval. A violation is reported if the computed average
      * duration is less than this parameter. The duration is measured as the time
      * when the the transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_avg_min_write_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed duration for a read
      * transaction to complete. The duration is measured as the time when the the
      * transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_max_read_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum duration for a read transaction to
      * complete. The duration is measured as the time when the the transaction is
      * started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_read_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum expected average duration for a read
      * transaction. The average is calculated over a time interval specified by
      * perf_recording_interval. A violation is reported if the computed average
      * duration is more than this parameter. The duration is measured as the time
      * when the the transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_avg_max_read_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected average duration for a read
      * transaction. The average is calculated over a time interval specified by
      * perf_recording_interval. A violation is reported if the computed average
      * duration is less than this parameter. The duration is measured as the time
      * when the the transaction is started to the time when transaction ends.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_avg_min_read_xact_latency = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed throughput for read
      * transfers in a given time interval. The throughput is measured as 
      * (number of bytes transferred in an interval)/(duration of interval).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a throughput
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_max_read_throughput = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected throughput for read
      * transfers in a given time interval. The throughput is measured as 
      * (number of bytes transferred in an interval)/(duration of interval).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a throughput
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_read_throughput = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed throughput for write
      * transfers in a given time interval. The throughput is measured as 
      * (number of bytes transferred in an interval)/(duration of interval).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a throughput
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_max_write_throughput = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected throughput for write
      * transfers in a given time interval. The throughput is measured as 
      * (number of bytes transferred in an interval)/(duration of interval).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a throughput
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_write_throughput = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed bandwidth for read
      * transfers in a given time interval. The bandwidth is measured as 
      * (number of bytes transferred in an interval)/(latency).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a bandwidth
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_max_read_bandwidth = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected bandwidth for read
      * transfers in a given time interval. The bandwidth is measured as 
      * (number of bytes transferred in an interval)/(latency).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a bandwidth
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_read_bandwidth = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the maximum allowed bandwidth for write
      * transfers in a given time interval. The bandwidth is measured as 
      * (number of bytes transferred in an interval)/(latency).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a bandwidth
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_max_write_bandwidth = -1;

    /**
      * @groupname axi_performance_analysis 
      * Performance constraint on the minimum expected bandwidth for write
      * transfers in a given time interval. The bandwidth is measured as 
      * (number of bytes transferred in an interval)/(latency).
      * The interval is specified in perf_recording_interval.
      * The unit for this is Bytes/Timescale Unit. For example, if a bandwidth
      * of 100 MB/s is to be configured and the timescale is 1ns/1ps, it translates
      * to (100 * 10^6) bytes per 10^9 ns and so this needs to be configured to 0.1.
      * A value of -1 indicates that no performance monitoring is done.
      * <b>type:</b> Dynamic 
      * When #perf_recording_interval is set to -1, check related to this constraint is
      * performed only while the performance monitoring is active.
      */
    real perf_min_write_bandwidth = -1;

    /**
      * @groupname axi_performance_analysis
      * Indicates if periods of transaction inactivity (ie, periods when no
      * transaction is active) must be excluded from the calculation of
      * throughput.  The throughput is measured as (number of bytes transferred
      * in an interval)/(duration of interval). If this bit is set, inactive
      * periods will be deducted from the duration of the interval
      */
    bit perf_exclude_inactive_periods_for_throughput = 0;
    
    /**
      * @groupname axi_performance_analysis
      * Indicates how the transaction inactivity (ie, periods when no
      * transaction is active) must be estimated for the calculation of
      * throughput.  
      * Applicable only when tcnt_axi_cfg::
      * perf_exclude_inactive_periods_for_throughput is set to 1. 
      * EXCLUDE_ALL: Excludes all the inactivity. This is the default value. 
      * EXCLUDE_BEGIN_END: Excludes the inactivity only from time 0 to start of first 
      * transaction, and from end of last transaction to end of simulation. 
      */
    perf_inactivity_algorithm_type_enum perf_inactivity_algorithm_type = EXCLUDE_ALL;
    /** @endcond */
    
    /**
      * @groupname axi_performance_analysis
      * Indicates if axi performance statistical enable
      * 0 : disable statistical axi performance, including latency,bandwidth,throughput.
      *     will not generate performance analysis report
      * 1 : enable statistical axi performance, including latency,bandwidth,throughput.
      *     will generate performance analysis report
      */
    bit axi_performance_statistical_enable = 0;
    
    /**
      * @groupname axi_recording 
      * Indicates if axi transactions will be recorded in a specified file named by tcnt_
      * axi_configuration::axi_recording_file_name in simulation directory.
      */
    bit axi_recording_enable = 0;

    /**
      * @groupname axi_generic_config
      * By default, this implies the master VIP will not consider receiving interleaved read data as an error,
      * and will continue to process such read data. This aligns with the legacy behaviour that is already supported.
      * When set to 1’b1: the master VIP will consider receiving interleaved read data as an error, but will continue to process
      * such read data. 
      * Configuration type: Static
      * Applicable only to MASTER 
      */

    bit  read_interleaving_disabled = 0;    

    /**
      * @groupname axi_recording
      * Indicates axi recording file name, only enabled when tcnt_axi_cfg::axi_
      * recording_enable = 1.
      */
    string axi_recording_file_name = "axi_recording.log";
    
    /** @groupname axi_agent_configuration
      * Indicates if axi transaction will be export from monitor when transaction is not
      * finished.
      */
    bit monitor_trans_in_req_phase_enable = 0;

    /**
      * @groupname axi_coverage_protocol_checks
      * When set to '1', enables system level coverage.All covergroups enabled
      * by system_axi_*_enable or system_ace_*_enable are created only if
      * this bit is set.
      * Applicable if #system_monitor_enable=1
      * <b>type:</b> Static 
      */
    bit system_coverage_enable = 1; 

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables toggle coverage.
      * Toggle Coverage gives us information on whether a bit
      * toggled from 0 to 1 and back from 1 to 0. This does not
      * indicate that every value of a multi-bit vector was seen, but
      * measures if individual bits of a multi-bit vector toggled.
      * This coverage gives information on whether a system is connected
      * properly or not.
      * <b>type:</b> Static 
      */
    bit toggle_coverage_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables state coverage of signals.
      * State Coverage covers all possible states of a signal.
      * <b>type:</b> Static 
      */
    bit state_coverage_enable = 1;

    /**
      * @groupname axi_coverage_protocol_checks
      * Enables transaction level coverage. This parameter also enables delay
      * coverage. Delay coverage is coverage on various delays between valid & ready signals.
      * <b>type:</b> Static 
      */
    bit transaction_coverage_enable = 1;

    /**
      * MASTER: Enables generation of exclusive access transactions.
      * SLAVE: Indicates whether the slave supports exclusive access or not. type: Static 
      */
    bit exclusive_access_enable = 0;

    rand bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] start_addr ;
    rand bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] end_addr ;
    bit silent_mode        = 0 ;
    bit out_of_order_en    = 0 ;
    switch_mode_e regmodel_sw = tcnt_dec_base::OFF ;

    //follow variables only use when regslice_en is valid
    bit regslice_en = 1'b0 ;    //0: normal AXI BUS, 1: non-normal AXI BUS
    int wr_regslice_size ;
    int rd_regslice_size ;
    bit [`TCNT_AXI_RD_MAX_REGSLICE_SIZE-1:0] rd_all_one ; 
    bit [`TCNT_AXI_WR_MAX_REGSLICE_SIZE-1:0] wr_all_one ; 


    `uvm_object_utils_begin(tcnt_axi_cfg)
        `uvm_field_enum(axi_interface_type_enum,axi_interface_type                  ,UVM_ALL_ON)      
        `uvm_field_enum(axi_port_kind_enum,axi_port_kind                            ,UVM_ALL_ON)
        `uvm_field_int(addr_width                                                   ,UVM_ALL_ON)
        `uvm_field_int(addr_user_width                                              ,UVM_ALL_ON)
        `uvm_field_int(data_width                                                   ,UVM_ALL_ON)
        `uvm_field_int(data_user_width                                              ,UVM_ALL_ON)
        `uvm_field_int(resp_user_width                                              ,UVM_ALL_ON)
        `uvm_field_int(use_separate_rd_wr_chan_id_width				                ,UVM_ALL_ON)
        `uvm_field_int(id_width				                                        ,UVM_ALL_ON)
        `uvm_field_int(read_chan_id_width				                            ,UVM_ALL_ON)
        `uvm_field_int(write_chan_id_width				                            ,UVM_ALL_ON)
        `uvm_field_int(read_data_reordering_depth				                    ,UVM_ALL_ON)
        `uvm_field_int(write_resp_reordering_depth				                    ,UVM_ALL_ON)
        `uvm_field_enum(reordering_window_enum,reordering_window	                ,UVM_ALL_ON)
        `uvm_field_int(read_data_interleave_size				                    ,UVM_ALL_ON)
        `uvm_field_int(read_interleaving_disabled                                   ,UVM_ALL_ON)
        `uvm_field_enum(reordering_algorithm_enum,reordering_algorithm				,UVM_ALL_ON)
        `uvm_field_int(num_outstanding_xact				                            ,UVM_ALL_ON)
        `uvm_field_int(num_read_outstanding_xact				                    ,UVM_ALL_ON)
        `uvm_field_int(num_write_outstanding_xact				                    ,UVM_ALL_ON)
        `uvm_field_int(default_awready				                                ,UVM_ALL_ON)
        `uvm_field_int(default_wready				                                ,UVM_ALL_ON)
        `uvm_field_int(default_arready				                                ,UVM_ALL_ON)
        `uvm_field_int(default_rready				                                ,UVM_ALL_ON)
        `uvm_field_int(default_bready				                                ,UVM_ALL_ON)
        `uvm_field_int(awregion_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arregion_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awid_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(awlen_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(awsize_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awburst_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awlock_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awcache_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awprot_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(awqos_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(wlast_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(wstrb_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(bid_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(bresp_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(arid_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(arlen_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(arsize_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arburst_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arlock_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arcache_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arprot_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(arqos_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(rid_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(rresp_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(rlast_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(awuser_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(wuser_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(buser_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(aruser_enable				                                ,UVM_ALL_ON)
        `uvm_field_int(ruser_enable				                                    ,UVM_ALL_ON)
        `uvm_field_int(awready_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(wready_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(arready_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(rready_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(rdata_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(bready_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(bresp_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(excl_wr_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(wdata_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(awaddr_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(protocol_checks_enable				                        ,UVM_ALL_ON)
        `uvm_field_int(signal_valid_during_reset_checks_enable				        ,UVM_ALL_ON)
        `uvm_field_int(check_valid_data_bytes_only_enable				            ,UVM_ALL_ON)
        `uvm_field_int(xact_watchdog_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(xact_inactivity_timeout				                        ,UVM_ALL_ON)
        `uvm_field_int(system_coverage_enable                                       ,UVM_ALL_ON)
        `uvm_field_int(toggle_coverage_enable                                       ,UVM_ALL_ON)
        `uvm_field_int(state_coverage_enable                                        ,UVM_ALL_ON)
        `uvm_field_int(transaction_coverage_enable                                  ,UVM_ALL_ON)
        `uvm_field_int(exclusive_access_enable                                      ,UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint signal_enable_cons {
        if(axi_interface_type == tcnt_axi_dec::AXI4_LITE){
            awregion_enable == 0;	
            arregion_enable	== 0;
            awid_enable		== 0;
            awlen_enable	== 0;
            awsize_enable	== 0; 
            awburst_enable	== 0;
            awlock_enable	== 0;
            awcache_enable	== 0;
            //awprot_enable	== 1;
            awqos_enable	== 0;
            wlast_enable	== 0;	
            //wstrb_enable	== 1;
            bid_enable		== 0;
            //bresp_enable	== 1;
            arid_enable		== 0;
            arlen_enable    == 0;
            arsize_enable	== 0;
            arburst_enable	== 0;
            arlock_enable	== 0;
            arcache_enable	== 0;
            //arprot_enable	== 1;
            arqos_enable	== 0;
            rid_enable		== 0;
            //rresp_enable	== 1;
            rlast_enable    == 0;		
            awuser_enable	== 0;
            wuser_enable	== 0;
            buser_enable	== 0;
            aruser_enable	== 0;
            ruser_enable	== 0;
        } else if(axi_interface_type == tcnt_axi_dec::AXI3){
            awregion_enable == 0;	
            arregion_enable	== 0;
            awqos_enable	== 0;
            arqos_enable	== 0;
            awuser_enable	== 0;
            wuser_enable	== 0;
            buser_enable	== 0;
            aruser_enable	== 0;
            ruser_enable	== 0;        
        }
    }
    
    constraint signal_width_cons {
        data_width[2:0] == 0;
        if(axi_interface_type == tcnt_axi_dec::AXI4_LITE){
            data_width inside {32,64};
        } 
    }

    function new(string name = "tcnt_axi_cfg");
        super.new(name);
    endfunction
endclass

`endif
