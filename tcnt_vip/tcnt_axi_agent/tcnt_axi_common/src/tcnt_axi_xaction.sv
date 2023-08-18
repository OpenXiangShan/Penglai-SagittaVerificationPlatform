`ifndef TCNT_AXI_XACTION__SV
`define TCNT_AXI_XACTION__SV

class tcnt_axi_xaction  extends tcnt_data_base;
    /**
    * @groupname axi3_protocol
    * Represents the transaction type.
    * Following are the possible transaction types:
    * - WRITE    : Represent a WRITE transaction. 
    * - READ     : Represents a READ transaction.
    * - COHERENT : Represents a COHERENT transaction.
    * .
    *
    * Please note that WRITE and READ transaction type is valid for
    * #TCNT_axi_port_configuration::axi_interface_type is AXI3/AXI4/AXI4_LITE and
    * COHERENT transaction type is valid for
    * #TCNT_axi_port_configuration::axi_interface_type is AXI_ACE.
    */
    rand tcnt_axi_dec::xact_type_enum               xact_type = tcnt_axi_dec::WRITE;

    /**
    * @groupname axi3_protocol
    * The variable represents AWADDR when xact_type is WRITE and  ARADDR when
    * xact_type is READ.<br>
    * The maximum width of this signal is controlled through macro
    * TCNT_AXI_MAX_ADDR_WIDTH. Default value of this macro is 64. To change the
    * maximum width of this variable, user can change the value of this macro.
    * Define the new value for the macro in file TCNT_axi_user_defines.svi, and
    * then specify this file to be compiled by the simulator. Also, specify
    * +define+TCNT_AXI_INCLUDE_USER_DEFINES on the simulator compilation command
    * line. Please consult User Guide for additional information, and consult VIP
    * example for usage demonstration.<br>
    * The TCNT_AXI_MAX_ADDR_WIDTH macro is only used to control the maximum width
    * of the signal. The actual width used by VIP is controlled by configuration
    * parameter TCNT_axi_port_configuration::addr_width.
    */
    rand bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]         addr = 0;

    /**
    * @groupname axi3_protocol
    * MASTER in active mode:
    *
    * For write transactions this variable specifies write data to be driven on the
    * WDATA bus. 
    * 
    * SLAVE in active mode:
    *
    * For read transactions this variable specifies read data to be driven on the
    * RDATA bus.
    *
    * PASSIVE MODE:
    * This variable stores the write or read data as seen on WDATA or RDATA bus.
    *
    * APPLICABLE IN ALL MODES:
    * If TCNT_axi_port_configuration::wysiwyg_enable is set to 0 (default), the
    * data must be stored right-justified by the user. The model will drive the
    * data on the correct lanes.  If TCNT_axi_port_configuration::wysiwyg_enable
    * is set to 1, the data is  transmitted as programmed by user and is
    * reported as seen on bus. No right-justification is used in this case.<br>
    * The maximum width of this signal is controlled through macro
    * TCNT_AXI_MAX_DATA_WIDTH. Default value of this macro is 1024. To change the
    * maximum width of this variable, user can change the value of this macro.
    * Define the new value for the macro in file TCNT_axi_user_defines.svi, and
    * then specify this file to be compiled by the simulator. Also, specify
    * +define+TCNT_AXI_INCLUDE_USER_DEFINES on the simulator compilation command
    * line. Please consult User Guide for additional information, and consult VIP
    * example for usage demonstration.<br>
    * The TCNT_AXI_MAX_DATA_WIDTH macro is only used to control the maximum width
    * of the signal. The actual width used by VIP is controlled by configuration
    * parameter TCNT_axi_port_configuration::data_width.
    */
    `ifdef TCNT_MEM_LOGIC_DATA
    rand logic [`TCNT_AXI_MAX_DATA_WIDTH - 1:0]     data[];
    `else
    rand bit [`TCNT_AXI_MAX_DATA_WIDTH - 1:0]       data[];
    `endif

    /**
    *  @groupname axi3_protocol
    *  The variable represents the actual length of the burst. For eg.
    *  burst_length = 1 means a burst of length 1.
    *
    *  If #TCNT_axi_port_configuration::axi_interface_type is AXI3, burst length
    *  of 1 to 16 is supported.
    *
    *  If #TCNT_axi_port_configuration::axi_interface_type is AXI4, burst length
    *  of 1 to 256 is supported.
    */ 
    rand bit [`TCNT_AXI_MAX_BURST_LENGTH_WIDTH:0]   burst_length = 1;
    
    /**
    *  @groupname axi3_protocol
    *  Represents the burst type of a transaction. The burst type holds the value
    *  for AWBURST/ARBURST. Following are the possible burst types: 
    *  - FIXED
    *  - INCR
    *  - WRAP
    *  .
    */
    rand tcnt_axi_dec::burst_type_enum              burst_type = tcnt_axi_dec::INCR;

    /**
    *  @groupname axi3_protocol
    *  Represents the burst size of a transaction . The variable holds the value
    *  for AWSIZE/ARSIZE. 
    */
    rand tcnt_axi_dec::burst_size_enum              burst_size = tcnt_axi_dec::BURST_SIZE_8BIT;
    
    /**
    *  @groupname axi3_protocol
    *  Array of Write strobes.
    *  If TCNT_axi_port_configuration::wysiwyg_enable is set to 0 (default), the
    *  wstrb must be stored right-justified by the user. The model will drive
    *  these strobes on the correct lanes.
    *  If TCNT_axi_port_configuration::wysiwyg_enable is set to 1, the wstrb is  
    *  transmitted as programmed by user and is reported as seen on bus. 
    *  No right-justification is used in this case.
    */
    rand bit [`TCNT_AXI_WSTRB_WIDTH-1:0]            wstrb[];

    /**
    *  @groupname axi4_protocol
    *  The variable holds the value for AWQOS/ARQOS 
    */
    rand bit [`TCNT_AXI_QOS_WIDTH-1:0]              qos = 0;
    
    /**
    *  @groupname axi3_protocol
    *  Represents the protection support of a transaction. The variable holds the
    *  value for AWPROT/ARPROT. The conventions of the enumeration are:
    *
    *  - NORMAL/PRIVILEGED   : Normal/Priveleged access represented by AWPROT[0]/ARPROT[0]
    *  - SECURE / NON_SECURE : Secure/Non-Secure access represented by AWPROT[1]/ARPROT[1]
    *  - DATA / INSTRUCTION  : Data/Instruction access represented by AWPROT[2]/ARPROT[2]
    *  .
    *
    *  For the above conventions, following are the possible protection types:
    *  - DATA_SECURE_NORMAL                    
    *  - DATA_SECURE_PRIVILEGED                    
    *  - DATA_NON_SECURE_NORMAL                    
    *  - DATA_NON_SECURE_PRIVILEGED                
    *  - INSTRUCTION_SECURE_NORMAL                 
    *  - INSTRUCTION_SECURE_PRIVILEGED              
    *  - INSTRUCTION_NON_SECURE_NORMAL
    *  - INSTRUCTION_NON_SECURE_PRIVILEGED
    *  .
    */
    rand tcnt_axi_dec::prot_type_enum               prot_type = tcnt_axi_dec::DATA_SECURE_NORMAL;
    
    /**
    *  @groupname axi3_protocol
    *  The variable holds the value for signals AWUSER/ARUSER.
    *  Applicable for all interface types. Enabled through port configuration
    *  parameters TCNT_axi_port_configuration::aruser_enable and
    *  TCNT_axi_port_configuration::awuser_enable.
    */
    rand bit [`TCNT_AXI_MAX_ADDR_USER_WIDTH-1:0]    addr_user = 0;
    
    /**
    *  @groupname axi3_protocol
    *  The variable holds the value for signals WUSER/RUSER. Applicable for all
    *  interface types. Enabled through port configuration parameters
    *  TCNT_axi_port_configuration::wuser_enable and
    *  TCNT_axi_port_configuration::ruser_enable.
    */
    rand bit [`TCNT_AXI_MAX_DATA_USER_WIDTH-1:0]    data_user[];
    
    /**
    *  @groupname axi3_protocol
    *  The variable holds the value for signal BUSER. Applicable for all
    *  interface types. Enabled through port configuration parameter
    *  TCNT_axi_port_configuration::buser_enable.
    */
    rand bit [`TCNT_AXI_MAX_BRESP_USER_WIDTH-1:0]   resp_user = 0;
    
    /**
    *  @groupname axi3_protocol
    *  Represents the cache support of a transaction. The variable holds the
    *  value for AWCACHE/ARCACHE.
    *
    *  Following values are supported in AXI3 mode:
    *
    *  - TCNT_AXI_3_NON_CACHEABLE_NON_BUFFERABLE            
    *  - TCNT_AXI_3_BUFFERABLE_OR_MODIFIABLE_ONLY           
    *  - TCNT_AXI_3_CACHEABLE_BUT_NO_ALLOC                  
    *  - TCNT_AXI_3_CACHEABLE_BUFFERABLE_BUT_NO_ALLOC       
    *  - TCNT_AXI_3_CACHEABLE_WR_THRU_ALLOC_ON_RD_ONLY      
    *  - TCNT_AXI_3_CACHEABLE_WR_BACK_ALLOC_ON_RD_ONLY      
    *  - TCNT_AXI_3_CACHEABLE_WR_THRU_ALLOC_ON_WR_ONLY       
    *  - TCNT_AXI_3_CACHEABLE_WR_BACK_ALLOC_ON_WR_ONLY       
    *  - TCNT_AXI_3_CACHEABLE_WR_THRU_ALLOC_ON_BOTH_RD_WR    
    *  - TCNT_AXI_3_CACHEABLE_WR_BACK_ALLOC_ON_BOTH_RD_WR    
    *  .
    *  
    *  Following values for ARCACHE are supported in AXI4 mode:
    *  - TCNT_AXI_4_ARCACHE_DEVICE_NON_BUFFERABLE                  
    *  - TCNT_AXI_4_ARCACHE_DEVICE_BUFFERABLE                     
    *  - TCNT_AXI_4_ARCACHE_NORMAL_NON_CACHABLE_NON_BUFFERABLE    
    *  - TCNT_AXI_4_ARCACHE_NORMAL_NON_CACHABLE_BUFFERABLE         
    *  - TCNT_AXI_4_ARCACHE_WRITE_THROUGH_NO_ALLOCATE                
    *  - TCNT_AXI_4_ARCACHE_WRITE_THROUGH_READ_ALLOCATE           
    *  - TCNT_AXI_4_ARCACHE_WRITE_THROUGH_WRITE_ALLOCATE          
    *  - TCNT_AXI_4_ARCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE 
    *  - TCNT_AXI_4_ARCACHE_WRITE_BACK_NO_ALLOCATE                
    *  - TCNT_AXI_4_ARCACHE_WRITE_BACK_READ_ALLOCATE                
    *  - TCNT_AXI_4_ARCACHE_WRITE_BACK_WRITE_ALLOCATE             
    *  - TCNT_AXI_4_ARCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      
    *  .
    *
    *  Following values for AWCACHE are supported in AXI4 mode:
    *  - TCNT_AXI_4_AWCACHE_DEVICE_NON_BUFFERABLE                  
    *  - TCNT_AXI_4_AWCACHE_DEVICE_BUFFERABLE                     
    *  - TCNT_AXI_4_AWCACHE_NORMAL_NON_CACHABLE_NON_BUFFERABLE    
    *  - TCNT_AXI_4_AWCACHE_NORMAL_NON_CACHABLE_BUFFERABLE         
    *  - TCNT_AXI_4_AWCACHE_WRITE_THROUGH_NO_ALLOCATE                
    *  - TCNT_AXI_4_AWCACHE_WRITE_THROUGH_READ_ALLOCATE           
    *  - TCNT_AXI_4_AWCACHE_WRITE_THROUGH_WRITE_ALLOCATE          
    *  - TCNT_AXI_4_AWCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE 
    *  - TCNT_AXI_4_AWCACHE_WRITE_BACK_NO_ALLOCATE                
    *  - TCNT_AXI_4_AWCACHE_WRITE_BACK_READ_ALLOCATE                
    *  - TCNT_AXI_4_AWCACHE_WRITE_BACK_WRITE_ALLOCATE             
    *  - TCNT_AXI_4_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE    
    *  .
    */
    rand bit [`TCNT_AXI_CACHE_WIDTH-1:0]            cache_type = 0;
    
    /**
    *  @groupname axi3_protocol
    *  This variable specifies the response for write transaction. The variable holds the
    *  value for BRESP. Following are the possible response types:
    *  - OKAY    
    *  - EXOKAY  
    *  - SLVERR 
    *  - DECERR  
    *  .
    *          
    *  MASTER ACTIVE MODE:
    *
    *  Will Store the write response received from the slave.
    *
    *  SLAVE ACTIVE MODE:
    *
    *  The write response programmed by the user.
    *
    *  PASSIVE MODE - MASTER/SLAVE:
    *
    *  Stores the write response seen on the bus.
    */
    rand tcnt_axi_dec::resp_type_enum               bresp = tcnt_axi_dec::OKAY;
    
    /**
    *  @groupname axi3_protocol
    *  This array variable specifies the response for read transaction. The array holds the
    *  value for RRESP. Following are the possible response types:
    *  - OKAY    
    *  - EXOKAY  
    *  - SLVERR 
    *  - DECERR  
    *  .
    *          
    *  MASTER ACTIVE MODE:
    *
    *  Will Store the read responses received from the slave.
    *
    *  SLAVE ACTIVE MODE:
    *
    *  The read responses programmed by the user.
    *
    *  PASSIVE MODE - MASTER/SLAVE:
    *
    *  Stores the read responses seen on the bus.
    */

    rand resp_type_enum rresp[];

    /**
    * @groupname axi3_protocol
    * The variable holds the value of  AWID/WID/BID/ARID/RID signals.<br>
    * The maximum width of this signal is controlled through macro
    * TCNT_AXI_MAX_ID_WIDTH. Default value of this macro is 8. To change the
    * maximum width of this variable, user can change the value of this macro.
    * Define the new value for the macro in file TCNT_axi_user_defines.svi, and
    * then specify this file to be compiled by the simulator. Also, specify
    * +define+TCNT_AXI_INCLUDE_USER_DEFINES on the simulator compilation command
    * line. Please consult User Guide for additional information, and consult VIP
    * example for usage demonstration.<br>
    * The TCNT_AXI_MAX_ID_WIDTH macro is only used to control the maximum width
    * of the signal. The actual width used by VIP is controlled by configuration
    * parameter TCNT_axi_port_configuration::id_width.
    */
    rand bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]           id = 0;
    
    /**
    * @groupname axi3_protocol
    * Represents the atomic access of a transaction.  The variable holds the
    * value for AWLOCK/ARLOCK. Following are the possible atomic types:
    * - NORMAL     
    * - EXCLUSIVE  
    * - LOCKED
    * .
    * Please note that atomic type LOCKED is not yet supported.
    */
    rand tcnt_axi_dec::atomic_type_enum             atomic_type = tcnt_axi_dec::NORMAL;
    
    /**
    *  @groupname axi4_protocol
    *  The variable holds the value for AWREGION/ARREGION
    */
    rand bit [`TCNT_AXI_REGION_WIDTH-1:0]           region = 0;
    
    /**
    *  @groupname axi3_protocol
    *  Indicates that data will start before address for write transactions.
    *  In data_before_addr scenario (i.e., when data_before_addr = '1'), addr and data channel related delay considerations are: 
    *  1) For programming address_channel related delay: awvalid_delay and reference_event_for_addr_valid_delay are used.
    *   (for more information, look for the description of these variables).
    *    reference_event_for_addr_valid_delay should be set FIRST_WVALID_DATA_BEFORE_ADDR. 
    *    In data_before_addr scenarios reference_event_for_addr_delay should be set very carefully to
    *    FIRST_DATA_HANDSHAKE_DATA_BEFORE_ADDR as this may cause 
    *    potential deadlock scenarios in SLAVE DUT where slave DUT waits for awvalid signal
    *    before driving wready signal.
    *  2) For programming data_channel related delay: wvalid_delay[] and reference_event_for_first_wvalid_delay & reference_event_for_next_wvalid_delay are used.
    *    (for more information, look for the description of these variables).
    *      For wvalid_delay[0]        -  #reference_event_for_first_wvalid_delay
    *      For remaining indices of wvalid_delay -  #reference_event_for_next_wvalid_delay
    *    In data_before_addr scenario, reference_event_for_first_wvalid_delay must be PREV_WRITE_DATA_HANDSHAKE, otherwise it will cause failure.
    *  .
    *    
    */
    rand bit                                        data_before_addr = 0;
    //rand bit xact_status ;
    realtime                                        start_time ;
    realtime                                        end_time ;

    /**
     *  @groupname axi3_4_ace_timing
     *  This variable stores the timing information for address ready on read and
     *  write transactions. The simulation time number when the address valid and
     *  ready both are asserted i.e. handshake happens, is captured in this member.
     *  This information can be used for doing performance analysis. VIP updates the
     *  value of this member variable, user does not need to program this variable.
     */

    realtime addr_ready_assertion_time;

    /**
     *  @groupname axi3_4_ace_timing
     *   This variable stores the timing information for address valid on read and
     *   write transactions. The simulation time when the address valid is
     *   asserted, is captured in this member. This information can be used for
     *   doing performance analysis. VIP updates the value of this member
     *   variable, user does not need to program this variable.
     */
    realtime addr_valid_assertion_time;

    /**
     *  @groupname axi3_4_ace_timing
     *  This variable stores the timing information for data valid on read and
     *  write transactions. The simulation time when the data valid is asserted,
     *  is captured in this member. This variable is also applicable for AXI4_STREAM
     *  protocol and it will hold tvalid assertion time. This information can be
     *  used for doing performance analysis. VIP updates the value of this member
     *  variable, user does not need to program this variable.
     */
    realtime data_valid_assertion_time[];

    /**
     *  @groupname axi3_4_ace_timing
     *  This variable stores the timing information for data ready on read and
     *  write transactions. The simulation time when the data valid and ready both are
     *  asserted, is captured in this member. This variable is also applicable for
     *  AXI4_STREAM protocol and it will hold tready assertion time. This information
     *  can be used for doing performance analysis. VIP updates the value of this member
     *  variable, user does not need to program this variable.
     */
    realtime data_ready_assertion_time[];

    /**
     *  @groupname axi3_4_ace_timing
     *  This variable stores the timing information for response valid on  write
     *  transactions. The simulation time when the response valid is
     *  asserted, is captured in this member. This information can be used for
     *  doing performance analysis. VIP updates the value of this member
     *  variable, user does not need to program this variable.
     */
    realtime write_resp_valid_assertion_time;

    /**
     *  @groupname axi3_4_ace_timing
     *  This variable stores the timing information for response ready on  write
     *  transactions. The simulation time when the response valid and ready both are
     *  asserted, is captured in this member. This information can be used for doing
     *  performance analysis. VIP updates the value of this member variable, user
     *  does not need to program this variable.
     */
    realtime write_resp_ready_assertion_time;

    /**
    * @groupname interleaving , out_of_order
    * This variable controls enabling of interleaving for the current transaction.
    * 
    * Example:
    * TCNT_axi_port_configuration::read_data_reordering_depth = 2
    * 
    * Requirement:
    * Unless all beats of transaction 1 are sent out, the beats of 
    * 2nd transactions should not be sent.
    * 
    * Solution:
    * Program the enable_interleave = 0 for both the transaction 1.
    
    */
    rand bit                                        interleave_enable = 0;

    /**
    *  @groupname interleaving
    *  Represents the various interleave pattern for a read and write transaction.
    *  The interleave_pattern gives flexibility to program interleave blocks with
    *  different patterns as mentioned below.
    *
    *  A Block is group of beats within a transaction.
    *
    *  EQUAL_BLOCK         : Drives equal distribution of blocks provided by
    *                        #equal_block_length variable. 
    *
    *  RANDOM_BLOCK        : Drives the blocks programmed in random_interleave_array
    *
    * Please note that currently interleaving based on EQUAL_BLOCK is not
    * supported.
    */
    rand tcnt_axi_dec::interleave_pattern_enum      interleave_pattern = tcnt_axi_dec::RANDOM_BLOCK;

    /**
    * Indicates the endianness of the Outbound Write Data in an Atomic transaction.
    */
    rand tcnt_axi_dec::endian_enum                  endian = tcnt_axi_dec::LITTLE_ENDIAN;
    
    /**
    * @groupname axi3_protocol
    * Represents the maximum byte address of this transaction. 
    * If tagging is enabled, this will be the maximum tagged address 
    *  .
    */
    rand bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]         max_byte_addr =0;
    /**
    * @groupname axi3_protocol
    * Represents the minimum byte address of this transaction. 
    * If tagging is enabled, this will be the minimum tagged address 
    *  .
    */
    rand bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]         min_byte_addr =0;
    
    /**
    * @groupname axi3_4_delays
    * This members applies to AWREADY signal delay for write transactions, and
    * ARREADY signal delay for read transactions.
    *
    * If configuration parameter #TCNT_axi_port_configuration::default_awready
    * or #TCNT_axi_port_configuration::default_arready is FALSE, this member
    * defines the AWREADY or ARREADY signal delay in number of clock cycles.
    * The reference event used for this delay is
    * #reference_event_for_addr_ready_delay. 
    *
    * If configuration parameter #TCNT_axi_port_configuration::default_awready
    * or #TCNT_axi_port_configuration::default_arready is TRUE, this member
    * defines the number of clock cycles for which AWREADY or ARREADY signal
    * should be deasserted after each handshake, before pulling it up again to
    * its default value.
    *
    * Applicable for ACTIVE SLAVE only.
    */
    rand int                                        addr_ready_delay = 0;

    /**
    * @groupname axi3_4_delays
    * This variable defines the number of cycles the AWVALID or ARVALID  signal is
    * delayed. The reference event for this delay is #reference_event_for_addr_valid_delay.
    * Applicable for ACTIVE MASTER only.
    */
    rand int                                        addr_valid_delay = 0;

    /**
    * @groupname axi3_4_delays
    * If configuration parameter #TCNT_axi_port_configuration::default_wready is
    * FALSE, this member defines the WREADY signal delay in number of clock
    * cycles.  The reference event for this delay is
    * #reference_event_for_wready_delay.
    *
    * If configuration parameter #TCNT_axi_port_configuration::default_wready is
    * TRUE, this member defines the number of clock cycles for which WREADY
    * signal should be deasserted after each handshake, before pulling it up
    * again to its default value. 
    *
    * Applicable for ACTIVE SLAVE only.
    */
    rand int                                        wready_delay[];

    /** 
    * @groupname axi3_4_delays
    * Defines the delay in number of cycles for WVALID signal.
    * The reference event for this delay is:
    * - For wvalid_delay[0]        -  #reference_event_for_first_wvalid_delay
    * - For remaining indices of wvalid_delay -  #reference_event_for_next_wvalid_delay
    * .
    * Applicable for ACTIVE MASTER only.
    */
    rand int                                        wvalid_delay[];

    /**
    * @groupname axi3_4_delays
    * If configuration parameter #TCNT_axi_port_configuration::default_rready is
    * FALSE, this member defines the RREADY signal delay in number of clock
    * cycles.  The reference event for this delay is
    * #reference_event_for_rready_delay
    *
    * If configuration parameter #TCNT_axi_port_configuration::default_rready is
    * TRUE, this member defines the number of clock cycles for which RREADY
    * signal should be deasserted after each handshake, before pulling it up
    * again to its default value.
    *
    * Applicable for ACTIVE MASTER only.
    */
    rand int                                        rready_delay[];
    
    /** 
    * @groupname axi3_4_delays
    * Defines RVALID delay, in terms of number of clock cycles.
    * The reference event for this delay is:
    * - For rvalid_delay[0]        -  #reference_event_for_first_rvalid_delay
    * - For remaining indices of rvalid_delay -  #reference_event_for_next_rvalid_delay
    * .
    *
    * Applicable for ACTIVE SLAVE only.
    */
    rand int                                        rvalid_delay[];
    
    /**
    * @groupname axi3_4_delays
    * If configuration parameter #TCNT_axi_port_configuration::default_bready is
    * FALSE, this member defines the BREADY signal delay in number of clock
    * cycles.  The reference event for this delay is
    * #reference_event_for_bready_delay.
    * 
    * If configuration parameter #TCNT_axi_port_configuration::default_bready is
    * TRUE, this member defines the number of clock cycles for which BREADY
    * signal should be deasserted after each handshake, before pulling it up
    * again to its default value.
    *
    * Applicable for ACTIVE MASTER only.
    */
    rand int                                        bready_delay = 0;

    /**
    * @groupname ace5_protocol
    * 
    * Defines the BVALID delay in terms of number of clock cycles. The reference
    * event for the first beat is #reference_event_for_bvalid_delay.
    * The reference event for the second beat is the write response
    * handshake of the first beat
    *
    * Applicable for ACTIVE SLAVE only.
    */
    rand int                                        bvalid_delay = 0;

    /**
    *  @groupname axi3_4_status
    *  Represents the current status of the read or write address.  Following are the
    *  possible status types.

    * - INITIAL               : Address phase has not yet started on the channel
    * - ACTIVE                : Address valid is asserted but ready is not 
    * - ACCEPT                : Address phase is complete 
    * - ABORTED               : Current transaction is aborted
    * .
    */
    status_enum addr_status = INITIAL;

    /**
    *  @groupname axi3_4_status
    *  Represents the status of the read or write data transfer.  Following are
    *  the possible status types.

    *  - INITIAL               : Data has not yet started on the channel
    *  - ACTIVE                : Data valid is asserted but ready is not asserted for the
    *                            current data beat. The current beat is indicated
    *                            by #current_data_beat_num variable
    *  - PARTIAL_ACCEPT        : The current data beat is completed but the next
    *                            data-beat is not started. The next data beat is
    *                            indicated by #current_data_beat_num
    *  - ACCEPT                : Data phase is complete 
    *  - ABORTED               : Current transaction is aborted 
    *  .
    */
    status_enum data_status = INITIAL;
    
    /**
    *  @groupname axi3_4_status
    *  Represents the status of the write response transfer.  Following are
    *  the possible status types.
    *  - INITIAL               : Response has not yet started on the channel
    *  - ACTIVE                : BVALID is asserted, but not BREADY
    *  - ACCEPT                : Write response is complete
    *  - ABORTED               : Current transaction is aborted 
    *  .
    */
    status_enum write_resp_status = INITIAL;

    int ZERO_DELAY_wt  = 100;
    int SHORT_DELAY_wt = 500;
    int LONG_DELAY_wt  = 100;


    /**
    *  counter of valid data beat in transaction, only used by dev
    */
    int data_beat_cnt = 0; 

    /**
    *  unique id of each transaction. 
    */
    bit [63:0] unique_id;
    /**
    *  counter of unique id. add by 1 when new transaction is created. 
    */
    static bit [63:0] unique_id_cnt = 0;
    /**
    *Randomizable variables for constraints
    */
    protected rand bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1 : 0]  addr_mask ;

    protected rand bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1 : 0]  addr_range;

    protected rand bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1 : 0]  burst_addr_mask ;
    
    /**
    * timestamp of transaction. used for delay timer
    **/
    longint timestamp;

    tcnt_axi_cfg cfg;
    
    //------------------------------------------------------------------------------
    //constraints of transaction
    //------------------------------------------------------------------------------
    //extern constraint axi3_4_valid_ranges_cons ;
    extern constraint xact_type_cons ;
    extern constraint burst_type_cons ;
    extern constraint burst_length_cons ;
    extern constraint burst_size_cons ;
    extern constraint addr_range_cons ;
    extern constraint data_size_cons ;
    extern constraint atomic_type_cons;
    extern constraint cache_type_cons;
    extern constraint prot_type_cons;
    extern constraint qos_cons;
    extern constraint region_cons;
    extern constraint data_before_addr_cons;
    extern constraint interleave_cons;
    extern constraint data_endian_cons;
    extern constraint addr_valid_delay_cons ;
    extern constraint addr_ready_delay_cons ;
    extern constraint wvalid_delay_cons ;
    extern constraint wready_delay_cons ;
    extern constraint rvalid_delay_cons ;
    extern constraint rready_delay_cons ;
    extern constraint bvalid_delay_cons ;
    extern constraint bready_delay_cons ;
    extern constraint bresp_cons ;
    extern constraint rresp_cons ;


    //------------------------------------------------------------------------------
    //functions and tasks of transaction
    //------------------------------------------------------------------------------
    extern function new(string name="tcnt_axi_xaction");
    extern function void pack();
    extern function void unpack();
    extern function string psdisplay(string prefix = "");
    extern function bit compare(uvm_object rhs, uvm_comparer comparer=null);

    /**
      * Returns 1 is lid is the same as unique_id in this transaction 
      * @return 1 if lid is the same as unique_id in this transaction 
      */
    extern function bit has_same_unique_id(bit [63:0] lid);    

    /**
      * Returns the channel on which a transaction will be transmitted
      * @return The channel (READ/WRITE) on which this transaction will
      * be transmitted.
      */
    extern function xact_type_enum get_transmitted_channel();

    /**
      * Indicates the unaligned address
      */
    extern function int is_unaligned_address();

    /** returns lowest address of the transaction. For WRAP type of transaction
      * it indicates starting address after transaction statisfies WRAP condition
      * and wraps over to include lower addresses
      */
    extern function bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0] get_wrap_boundary();

    /** returns burst size aligned address */
    extern function bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0] get_burst_boundary();

    /**
      * Returns the byte lanes on which data is driven for a given data width
      */
    extern function void get_byte_lanes_for_data_width(
                  bit[`TCNT_AXI_MAX_ADDR_WIDTH-1:0] beat_addr,
                  int beat_num,
                  int data_width_in_bytes,
                  output int lower_byte_lane,
                  output int upper_byte_lane
            );

    /** Returns the address and lanes corresponding to the beat number */
    extern function void get_beat_addr_and_lane(input int beat_num, 
                                                output bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] beat_addr,
                                                output int lower_byte_lane,
                                                output int upper_byte_lane);

    /** Returns '1' if write strobes are driven correctly otherwise, returns '0' */
    extern virtual function bit check_wstrb(int beat_idx);

    extern function void field_print() ; 

    `uvm_object_utils_begin(tcnt_axi_xaction)
        `uvm_field_int(unique_id                                    ,UVM_ALL_ON)
        `uvm_field_int(addr                                         ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::xact_type_enum,xact_type      ,UVM_ALL_ON)
        `uvm_field_array_int(data                                   ,UVM_ALL_ON)
        `uvm_field_int(burst_length                                 ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::burst_type_enum,burst_type    ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::burst_size_enum,burst_size    ,UVM_ALL_ON)
        `uvm_field_array_int(wstrb                                  ,UVM_ALL_ON)
        `uvm_field_int(qos                                          ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::prot_type_enum,prot_type      ,UVM_ALL_ON)
        `uvm_field_int(addr_user                                    ,UVM_ALL_ON)
        `uvm_field_array_int(data_user                              ,UVM_ALL_ON)
        `uvm_field_int(resp_user                                    ,UVM_ALL_ON)
        `uvm_field_int(cache_type                                   ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::resp_type_enum,bresp          ,UVM_ALL_ON)
        `uvm_field_array_enum(tcnt_axi_dec::resp_type_enum,rresp    ,UVM_ALL_ON)
        `uvm_field_int(id                                           ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::atomic_type_enum,atomic_type  ,UVM_ALL_ON)
        `uvm_field_int(region                                       ,UVM_ALL_ON)
        `uvm_field_int(data_before_addr                             ,UVM_ALL_ON)
        `uvm_field_int(interleave_enable                            ,UVM_ALL_ON)
        `uvm_field_real(start_time                                  ,UVM_ALL_ON)
        `uvm_field_real(end_time                                    ,UVM_ALL_ON)
        `uvm_field_int(timestamp                                    ,UVM_ALL_ON)
        `uvm_field_real(addr_ready_assertion_time                   ,UVM_ALL_ON)
        `uvm_field_real(addr_valid_assertion_time                   ,UVM_ALL_ON)
        //`uvm_field_real(data_ready_assertion_time                   ,UVM_ALL_ON)
        //`uvm_field_real(data_valid_assertion_time                   ,UVM_ALL_ON)
        `uvm_field_real(write_resp_ready_assertion_time             ,UVM_ALL_ON)
        `uvm_field_real(write_resp_valid_assertion_time             ,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::interleave_pattern_enum,interleave_pattern,UVM_ALL_ON)
        `uvm_field_enum(tcnt_axi_dec::endian_enum,endian            ,UVM_ALL_ON)
        `uvm_field_int(max_byte_addr                                ,UVM_ALL_ON)
        `uvm_field_int(min_byte_addr                                ,UVM_ALL_ON)
        `uvm_field_int(addr_ready_delay                             ,UVM_ALL_ON)
        `uvm_field_int(addr_valid_delay                             ,UVM_ALL_ON)
        `uvm_field_array_int(wvalid_delay                           ,UVM_ALL_ON)
        `uvm_field_array_int(wready_delay                           ,UVM_ALL_ON)
        `uvm_field_array_int(rvalid_delay                           ,UVM_ALL_ON)
        `uvm_field_array_int(rready_delay                           ,UVM_ALL_ON)
        `uvm_field_int(bvalid_delay                                 ,UVM_ALL_ON)
        `uvm_field_int(bready_delay                                 ,UVM_ALL_ON)
        `uvm_field_enum(status_enum,addr_status                     ,UVM_ALL_ON)
        `uvm_field_enum(status_enum,data_status                     ,UVM_ALL_ON)
        `uvm_field_enum(status_enum,write_resp_status               ,UVM_ALL_ON)
        `uvm_field_object(cfg                                       ,UVM_ALL_ON)
    `uvm_object_utils_end

endclass:tcnt_axi_xaction

constraint tcnt_axi_xaction::xact_type_cons {
    xact_type dist{
        tcnt_axi_dec::WRITE := 50 ,
        tcnt_axi_dec::READ  := 50 
    };
}
constraint tcnt_axi_xaction::burst_type_cons {
    burst_type inside{tcnt_axi_dec::FIXED, tcnt_axi_dec::INCR, tcnt_axi_dec::WRAP} ;
}

constraint tcnt_axi_xaction::burst_length_cons {
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI4_LITE) {  
        burst_length == 1 ;
    }
    else { //AXI3 or AXI4
        if(burst_type == tcnt_axi_dec::WRAP) {
            burst_length dist {2:=25, 4:=25, 8:=25, 16:=25} ;
        }
        else if(burst_type == tcnt_axi_dec::FIXED) {
             burst_length dist {
                1 := 10,
                [2: (`AXI3_MAX_BURST_LENGTH >> 2)] :/50,
                [(`AXI3_MAX_BURST_LENGTH >> 2)+1:`AXI3_MAX_BURST_LENGTH] :/40
            };
        }
        else {//INCR
            if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) {  
                burst_length dist {
                    1 := 10,
                    [2: (`AXI3_MAX_BURST_LENGTH >> 2)] :/50,
                    [(`AXI3_MAX_BURST_LENGTH >> 2)+1:`AXI3_MAX_BURST_LENGTH] :/40
                };
            }
            else if(cfg.axi_interface_type == tcnt_axi_dec::AXI4) {  
                burst_length dist {
                    1 := 10,
                    [2: (`AXI4_MAX_BURST_LENGTH >> 2)] :/50,
                    [(`AXI4_MAX_BURST_LENGTH >> 2)+1:`AXI4_MAX_BURST_LENGTH] :/40
                };
            }
        }
    }
    solve burst_type before burst_length ;
    //if (cfg.axi_interface_type == tcnt_axi_dec::AXI_ACE) {
    //  burst_length dist {
    //    1 :=10,
    //    [2:4] :/50,
    //    [5:16] :/40
    //  };
    //}
}

constraint tcnt_axi_xaction::burst_size_cons {
    if(cfg.data_width == 2048) {  
        burst_size inside{[0:8]} ;
    }
    else if(cfg.data_width == 1024) {  
        burst_size inside{[0:7]} ;
    }
    else if(cfg.data_width == 512) {  
        burst_size inside{[0:6]} ;
    }
    else if(cfg.data_width == 256) {  
        burst_size inside{[0:5]} ;
    }
    else if(cfg.data_width == 128) {  
        burst_size inside{[0:4]} ;
    }
    else if(cfg.data_width == 64) {  
        if(cfg.axi_interface_type == tcnt_axi_dec::AXI4_LITE) { 
            burst_size ==  tcnt_axi_dec::BURST_SIZE_64BIT ;
        }
        else {
            burst_size inside{[0:3]} ;
        }
    }
    else if(cfg.data_width == 32) {  
        if(cfg.axi_interface_type == tcnt_axi_dec::AXI4_LITE) { 
            burst_size ==  tcnt_axi_dec::BURST_SIZE_32BIT ;
        }
        else {
            burst_size inside{[0:2]} ;
        }
    }
    else if(cfg.data_width == 16) {  
        burst_size inside{[0:1]} ;
    }
    else if(cfg.data_width == 8) {  
        burst_size == 0 ;
    }
}

constraint tcnt_axi_xaction::addr_range_cons {
    
    //For INCR transactions address must be aligned to container size
    //if(burst_type == tcnt_axi_dec::INCR){
    //    addr == addr >> (burst_length << burst_size) << (burst_length << burst_size);
    //}
    ////For WRAP transactions address must be aligned to burst_size
    //else if(burst_type == tcnt_axi_dec::WRAP){
    //    addr == addr >> burst_size << burst_size; 
    //}
    if(atomic_type == tcnt_axi_dec::EXCLUSIVE) {
        if(1 << burst_size == 2) {
            addr[0] == 1'b0;
        } 
        else if (1 << burst_size == 4) {
            addr[1:0] == 2'b0;
        } 
        else if (1 << burst_size == 8) {
            addr[2:0] == 3'b0;
        } 
        else if (1 << burst_size == 16) {
            addr[3:0] == 4'b0;
        } 
        else if (1 << burst_size == 32) {
            addr[4:0] == 5'b0;
        } 
        else if (1 << burst_size == 64) {
            addr[5:0] == 6'b0;
        } 
        else if (1 << burst_size == 128) {
            addr[6:0] == 7'b0;
        } 
        else if (1 << burst_size == 256) {
            addr[7:0] == 8'b0;
        } 
        //addr_user == 0 ;
    }

    
    /*
     *  When the burst type is not Fixed, it must be ensured that burst does not
     *  exceed 4k range
     */
   
    if(burst_type != tcnt_axi_dec::FIXED) {
        addr_range == (burst_length * (1 << burst_size));
        //`ifdef MULTI_SIM_CONSTRAINT_SHIFT_CONSTANT_RESULTS_IN_X_OR_Z
        //addr_mask == ( `TCNT_AXI_MAX_ADDR_WIDTH'hffff_ffff_ffff_ffff << burst_size);
        //`else
        addr_mask == ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << burst_size);
        //`endif  
        if (burst_type == tcnt_axi_dec::WRAP) {
            // Make sure that the max address does not cross addr_width.
            // Need to calculate this from wrap boundary (lowest address)
            // Note that the max byte address is:
            // (burst_length-1)*bytes_in_each_transfer + (bytes_in_each_transfer-1)
            if (burst_length == 2)
                //`ifdef MULTI_SIM_CONSTRAINT_SHIFT_CONSTANT_RESULTS_IN_X_OR_Z
                //burst_addr_mask == ( `TCNT_AXI_MAX_ADDR_WIDTH'hffff_ffff_ffff_ffff << (burst_size+1));
                //`else
                burst_addr_mask == ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+1));
                //`endif
            else if (burst_length == 4)
                //`ifdef MULTI_SIM_CONSTRAINT_SHIFT_CONSTANT_RESULTS_IN_X_OR_Z
                //burst_addr_mask == ( `TCNT_AXI_MAX_ADDR_WIDTH'hffff_ffff_ffff_ffff << (burst_size+2));
                //`else
                burst_addr_mask == ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+2));
                //`endif
            else if (burst_length == 8)
                //`ifdef MULTI_SIM_CONSTRAINT_SHIFT_CONSTANT_RESULTS_IN_X_OR_Z
                //burst_addr_mask == ( `TCNT_AXI_MAX_ADDR_WIDTH'hffff_ffff_ffff_ffff << (burst_size+3));
                //`else
                burst_addr_mask == ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+3));
                //`endif
            else if (burst_length == 16)
                //`ifdef MULTI_SIM_CONSTRAINT_SHIFT_CONSTANT_RESULTS_IN_X_OR_Z
                //burst_addr_mask == ( `TCNT_AXI_MAX_ADDR_WIDTH'hffff_ffff_ffff_ffff << (burst_size+4));
                //`else
                burst_addr_mask == ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+4));
                //`endif
            addr == (addr & addr_mask);
            //(addr & burst_addr_mask) + addr_range - 1 <= max_possible_addr; 
            (addr[11:0] & burst_addr_mask) <= (`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range);
        } else {
            // INCR
            (addr[11:0] & addr_mask) <= (`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range);
            // Make sure that the max address does not cross addr_width.
            // Use aligned address
            //((addr >> burst_size) << burst_size) + addr_range - 1 <= max_possible_addr;
        }
    } 
    
    solve burst_length before addr ;
    solve burst_size   before addr ;
    solve atomic_type  before addr ;

}

constraint tcnt_axi_xaction::data_size_cons {
    data.size()      == burst_length ;
    data_user.size() == burst_length ;
    if(xact_type == tcnt_axi_dec::WRITE) {
        wstrb.size()     == burst_length ;
        wvalid_delay.size() == burst_length ;
        wready_delay.size() == burst_length ;
        rvalid_delay.size() == 0 ;
        rready_delay.size() == 0 ;
        foreach(wstrb[i]) {
            if(burst_size == 0) { //1 byte
                wstrb[i] == 'h1 ;
            }
            else if(burst_size == 1) { //2 byte
                wstrb[i] == 'h3 ;
            }
            else if(burst_size == 2) { //4 byte
                wstrb[i] == 'hF ;
            }
            else if(burst_size == 3) { //8 byte
                wstrb[i] == 'hFF ;
            }
            else if(burst_size == 4) { //16 byte
                wstrb[i] == 'hFFFF ;
            }
            else if(burst_size == 5) { //32 byte
                wstrb[i] == 'hFFFF_FFFF ;
            }
            else if(burst_size == 6) { //64 byte
                wstrb[i] == {2{32'hFFFF_FFFF}}; //'hFFFF_FFFF_FFFF_FFFF ;
            }
            else if(burst_size == 7) { //128 byte
                wstrb[i] == {4{32'hFFFF_FFFF}}; //'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF ;
            }
            else if(burst_size == 8) { //256 byte
                wstrb[i] == {8{32'hFFFF_FFFF}}; //'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF ;
            }
        }
        foreach(data[i]) {
            //if(cfg.wysiwyg_enable ==1'b1){
                data[i] == data[i] & ((1<<(cfg.data_width))-1);
            //}
        }
        //foreach(data_user[i]) {
        //    data_user[i] == 0 ;
        //}
    }
    else if(xact_type == tcnt_axi_dec::READ) {
        rvalid_delay.size() == burst_length ;
        rready_delay.size() == burst_length ;
        wvalid_delay.size() == 0 ;
        wready_delay.size() == 0 ;
        wstrb.size()        == 0 ;
    }

}

constraint tcnt_axi_xaction::atomic_type_cons {
    /*
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI4) {  
        atomic_type dist{tcnt_axi_dec::NORMAL:=50, tcnt_axi_dec::EXCLUSIVE:=50};
    }
    else if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) {  
        atomic_type dist{tcnt_axi_dec::NORMAL:=50, tcnt_axi_dec::EXCLUSIVE:=50, tcnt_axi_dec::LOCKED:=50};
    }
    */
    soft atomic_type == tcnt_axi_dec::NORMAL;
}

constraint tcnt_axi_xaction::cache_type_cons {
    //cache_type inside{['h0:'hF]} ;
    soft cache_type == 'h0 ;
}

constraint tcnt_axi_xaction::prot_type_cons {
    soft prot_type == tcnt_axi_dec::DATA_SECURE_NORMAL ;
}

constraint tcnt_axi_xaction::qos_cons {
    soft qos == 0 ;
}

constraint tcnt_axi_xaction::region_cons {
    soft region == 0;
}

constraint tcnt_axi_xaction::data_before_addr_cons {
    data_before_addr dist{0:=50, 1:=50} ;
}

constraint tcnt_axi_xaction::interleave_cons {
    interleave_enable dist{0:=50, 1:=50}  ;
    soft interleave_pattern == tcnt_axi_dec::RANDOM_BLOCK;
}

constraint tcnt_axi_xaction::data_endian_cons {
    soft endian == tcnt_axi_dec::LITTLE_ENDIAN;

}

constraint tcnt_axi_xaction::addr_valid_delay_cons {
    soft addr_valid_delay dist {
                                0 := ZERO_DELAY_wt, 
                                [1:(`TCNT_AXI_MAX_ADDR_VALID_DELAY >> 2)] :/ SHORT_DELAY_wt,
                                [((`TCNT_AXI_MAX_ADDR_VALID_DELAY >> 2)+1):`TCNT_AXI_MAX_ADDR_VALID_DELAY] :/ LONG_DELAY_wt
                               };
}

constraint tcnt_axi_xaction::addr_ready_delay_cons {
    soft addr_ready_delay dist {
                                0 := ZERO_DELAY_wt, 
                                [1:(`TCNT_AXI_MAX_ADDR_READY_DELAY >> 2)] :/ SHORT_DELAY_wt,
                                [((`TCNT_AXI_MAX_ADDR_READY_DELAY >> 2)+1):`TCNT_AXI_MAX_ADDR_READY_DELAY] :/ LONG_DELAY_wt
                               };
}

constraint tcnt_axi_xaction::wvalid_delay_cons {
    foreach (wvalid_delay[i]) {
        soft wvalid_delay[i] dist {
                                   0 := ZERO_DELAY_wt, 
                                   [1:(`TCNT_AXI_MAX_WVALID_DELAY >> 2)] :/ SHORT_DELAY_wt,
                                   [((`TCNT_AXI_MAX_WVALID_DELAY >> 2)+1):`TCNT_AXI_MAX_WVALID_DELAY] :/ LONG_DELAY_wt
                                  };
    }
}

constraint tcnt_axi_xaction::wready_delay_cons {
    foreach (wready_delay[i]) {
        soft wready_delay[i] dist {
                                   0 := ZERO_DELAY_wt,
                                   [1:(`TCNT_AXI_MAX_WREADY_DELAY >> 2)] :/ SHORT_DELAY_wt >> 1,
                                   [((`TCNT_AXI_MAX_WREADY_DELAY >> 2)+1):`TCNT_AXI_MAX_WREADY_DELAY] :/ LONG_DELAY_wt
                                  };
    }
}

constraint tcnt_axi_xaction::rvalid_delay_cons {
    foreach (rvalid_delay[i]) {
        soft rvalid_delay[i] dist {
                                   0 := ZERO_DELAY_wt, 
                                   [1:(`TCNT_AXI_MAX_RVALID_DELAY >> 2)] :/ SHORT_DELAY_wt,
                                   [((`TCNT_AXI_MAX_RVALID_DELAY >> 2)+1):`TCNT_AXI_MAX_RVALID_DELAY] :/ LONG_DELAY_wt
                                  };
    }
}

constraint tcnt_axi_xaction::rready_delay_cons {
    foreach (rready_delay[i]) {
        soft rready_delay[i] dist {
                                   0 := ZERO_DELAY_wt,
                                   [1:(`TCNT_AXI_MAX_RREADY_DELAY >> 2)] :/ SHORT_DELAY_wt >> 1,
                                   [((`TCNT_AXI_MAX_RREADY_DELAY >> 2)+1):`TCNT_AXI_MAX_RREADY_DELAY] :/ LONG_DELAY_wt
                                  };
    }
}

constraint tcnt_axi_xaction::bvalid_delay_cons {
    soft bvalid_delay dist {
                            //`TCNT_AXI_MIN_WRITE_RESP_DELAY := ZERO_DELAY_wt, 
                            0:= ZERO_DELAY_wt, 
                            //[(`TCNT_AXI_MIN_WRITE_RESP_DELAY + 1):(`TCNT_AXI_MAX_BVALID_DELAY >> 2)] :/ SHORT_DELAY_wt,
                            [1:(`TCNT_AXI_MAX_BVALID_DELAY >> 2)] :/ SHORT_DELAY_wt,
                            [((`TCNT_AXI_MAX_BVALID_DELAY >> 2)+1):`TCNT_AXI_MAX_BVALID_DELAY] :/ LONG_DELAY_wt
                           };
}

constraint tcnt_axi_xaction::bready_delay_cons {
    soft bready_delay dist {
                            //`TCNT_AXI_MIN_WRITE_RESP_DELAY := ZERO_DELAY_wt, 
                            0:= ZERO_DELAY_wt, 
                            //[(`TCNT_AXI_MIN_WRITE_RESP_DELAY + 1):(`TCNT_AXI_MAX_BREADY_DELAY >> 2)] :/ SHORT_DELAY_wt,
                            [1:(`TCNT_AXI_MAX_BREADY_DELAY >> 2)] :/ SHORT_DELAY_wt >> 1,
                            [((`TCNT_AXI_MAX_BREADY_DELAY >> 2)+1):`TCNT_AXI_MAX_BREADY_DELAY] :/ LONG_DELAY_wt
                           };
}

constraint tcnt_axi_xaction::bresp_cons {
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI4_LITE) { 
        bresp != tcnt_axi_dec::EXOKAY ;
    }
}

constraint tcnt_axi_xaction::rresp_cons {
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI4_LITE) { 
        foreach(rresp[i]) {
            rresp[i] != tcnt_axi_dec::EXOKAY ;
        }
    }
}

function tcnt_axi_xaction::new(string name = "tcnt_axi_xaction");
    super.new();
    unique_id = unique_id_cnt;
    unique_id_cnt++;
endfunction:new
/**
  * Returns 1 is lid is the same as unique_id in this transaction 
  * @return 1 if lid is the same as unique_id in this transaction 
  */
function bit tcnt_axi_xaction::has_same_unique_id(bit [63:0] lid);
    return (lid == this.unique_id);
endfunction

/**
  * Returns the channel on which a transaction will be transmitted
  * @return The channel (READ/WRITE) on which this transaction will
  * be transmitted.
  */
function xact_type_enum tcnt_axi_xaction::get_transmitted_channel();
    return xact_type;
endfunction

/** returns burst size aligned address */
function bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0] tcnt_axi_xaction::get_burst_boundary();
    return (addr >> burst_size) << burst_size;
endfunction
/**
  * Indicates the unaligned address
  */
function int tcnt_axi_xaction::is_unaligned_address();
    return addr == get_burst_boundary();
endfunction

/** returns lowest address of the transaction. For WRAP type of transaction
  * it indicates starting address after transaction statisfies WRAP condition
  * and wraps over to include lower addresses
  */
function bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0] tcnt_axi_xaction::get_wrap_boundary();
    return (addr/(burst_length << burst_size))*(burst_length << burst_size);
endfunction

/**
  * Returns the byte lanes on which data is driven for a given data width
  */
function void tcnt_axi_xaction::get_byte_lanes_for_data_width(
              bit[`TCNT_AXI_MAX_ADDR_WIDTH-1:0] beat_addr,
              int beat_num,
              int data_width_in_bytes,
              output int lower_byte_lane,
              output int upper_byte_lane
        );
    if(beat_num == 0)begin
        lower_byte_lane = beat_addr - addr/data_width_in_bytes*data_width_in_bytes;
        upper_byte_lane = get_burst_boundary() + (1<<burst_size)-1 - (addr/data_width_in_bytes)*data_width_in_bytes;
    end else begin
        lower_byte_lane = beat_addr - (beat_addr/data_width_in_bytes)*data_width_in_bytes;
        upper_byte_lane = lower_byte_lane + (1<<burst_size) - 1;
    end
endfunction

/** Returns the address and lanes corresponding to the beat number */
function void tcnt_axi_xaction::get_beat_addr_and_lane(input int beat_num, 
                                                       output bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] beat_addr,
                                                       output int lower_byte_lane,
                                                       output int upper_byte_lane);
    case(burst_type)
        tcnt_axi_dec::INCR : begin
            beat_addr = get_burst_boundary() + (beat_num<<burst_size);
        end
        tcnt_axi_dec::WRAP : begin
            beat_addr = get_burst_boundary() + (beat_num<<burst_size);
            if(beat_addr == get_wrap_boundary() + (burst_length << burst_size))
                beat_addr = get_wrap_boundary();
            if(beat_addr > get_wrap_boundary() + (burst_length << burst_size))
                beat_addr = addr + (beat_num << burst_size) - (burst_length << burst_size);
        end
        tcnt_axi_dec::FIXED: begin
            beat_addr = get_burst_boundary();
        end
    endcase
    `uvm_info("tcnt_axi_xact",$sformatf("beat_addr = %0h,burst_boundary = %0h,beat_num=%0h,burst_size=%0d",beat_addr,get_burst_boundary(),beat_num,burst_size),UVM_DEBUG)
    get_byte_lanes_for_data_width(beat_addr,beat_num,cfg.data_width/8,lower_byte_lane,upper_byte_lane);
endfunction

/** Returns '1' if write strobes are driven correctly otherwise, returns '0' */
function bit tcnt_axi_xaction::check_wstrb(int beat_idx);
    int lbt_lane,ubt_lane;
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] byte_addr;
    //bit [`TCNT_AXI_WSTRB_WIDTH-1:0] valid_wstrb;
    get_beat_addr_and_lane(beat_idx,byte_addr,lbt_lane,ubt_lane);
    // wstrb can be allowed to be all 0s
    //valid_wstrb = (wstrb[beat_idx] >> lbt_lane) & ((1024'b1 << (ubt_lane - lbt_lane + 1))-1);
    //if(valid_wstrb == 0)begin
    //    `uvm_error("AXI_PROTOCOL_CHECK",$sformatf("addr[0x%0h],burst_size[%0s],burst_type[%0s],wstrb[%0d]=0x%0h in valid byte lanes[%0d-%0d] should not be 0",
    //                                               addr,burst_size.name(),burst_type.name(),beat_idx,wstrb[beat_idx],lbt_lane,ubt_lane))
    //end
    for(int l=0;l < (1 << burst_size);l++)begin
        if(!(l inside {[lbt_lane:ubt_lane]}))begin
            if(((wstrb[beat_idx] >> l) & 1'b1) == 1'b1)begin
                `uvm_error("AXI_PROTOCOL_CHECK",$sformatf("addr[0x%0h],burst_size[%0s],burst_type[%0s],wstrb[%0d]=0x%0h for byte_lane[%0d] that is not in valid byte_lanes[%0d-%0d] in beat should not be 1.",addr,burst_size.name(),burst_type.name(),beat_idx,wstrb[beat_idx],l,lbt_lane,ubt_lane))
            end
        end
    end
    return 1;
endfunction

function void tcnt_axi_xaction::pack();
    super.pack();
endfunction:pack

function void tcnt_axi_xaction::unpack();
    super.unpack();
endfunction:unpack

function string tcnt_axi_xaction::psdisplay(string prefix = "");
    string pkt_str;
    pkt_str = $sformatf("%s for packet[%0d] >>>>",prefix,this.pkt_index);
    pkt_str = $sformatf("%schannel_id=%0d ",pkt_str,this.channel_id);
    pkt_str = $sformatf("%sstart=%0f finish=%0f >>>>\n",pkt_str,this.start,this.finish);
    //foreach(this.pload_q[i]) begin
    //    pkt_str = $sformatf("%spload_q[%0d]=0x%2h  ",pkt_str,i,this.pload_q[i]);
    //end
    //pkt_str = $sformatf("%sdata_in_valid = 0x%0h ",pkt_str,this.data_in_valid);
    //pkt_str = $sformatf("%sdata_in_data = 0x%0h ",pkt_str,this.data_in_data);

    return pkt_str;
endfunction:psdisplay

function bit tcnt_axi_xaction::compare(uvm_object rhs, uvm_comparer comparer=null);
    bit super_result;
    tcnt_axi_xaction  rhs_;
    if(!$cast(rhs_, rhs)) begin
        `uvm_fatal(get_type_name(),$sformatf("rhs is not a tcnt_axi_xaction or its extend"))
    end
    super_result = super.compare(rhs_,comparer);
    if(super_result==0) begin
        super_result = 1;
        //foreach(this.pload_q[i]) begin
        //    if(this.pload_q[i]!=rhs_.pload_q[i]) begin
        //        super_result = 0;
        //        `uvm_info(get_type_name(),$sformatf("compare fail for this.pload[%0d]=0x%2h while the rhs_.pload[%0d]=0x%2h",i,this.pload_q[i],i,rhs_.pload_q[i]),UVM_NONE)
        //    end
        //end
        /*
        if(this.data_in_valid!=rhs_.data_in_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.data_in_valid=0x%0h while the rhs_.data_in_valid=0x%0h",this.data_in_valid,rhs_.data_in_valid),UVM_NONE)
        end

        if(this.data_in_data!=rhs_.data_in_data) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.data_in_data=0x%0h while the rhs_.data_in_data=0x%0h",this.data_in_data,rhs_.data_in_data),UVM_NONE)
        end
        */

    end
    return super_result;
endfunction:compare

function void tcnt_axi_xaction::field_print() ;
    
    `uvm_info(get_type_name(), "axi transaction fields show", UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("xact_type     = %s", xact_type.name()), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("addr          = 0x%0h", addr), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("burst_type    = %s", burst_type.name()), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("burst_length  = 0x%0h", burst_length), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("burst_size    = %s", burst_size.name()), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("data_size     = 0x%0h", data.size()), UVM_DEBUG) ;
    for(int i=0; i<data.size(); i++) begin
        `uvm_info(get_type_name(), $sformatf("data[%0d] = 0x%0h", i, data[i]), UVM_DEBUG) ;
    end
    `uvm_info(get_type_name(), $sformatf("addr_valid_delay = 0x%0h", addr_valid_delay), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("addr_ready_delay = 0x%0h", addr_ready_delay), UVM_DEBUG) ;
    foreach(wvalid_delay[i])begin
        `uvm_info(get_type_name(), $sformatf("wvalid_delay[%0d] = 0x%0h", i, wvalid_delay[i]), UVM_DEBUG) ;
    end
    foreach(wready_delay[i])begin
        `uvm_info(get_type_name(), $sformatf("wready_delay[%0d] = 0x%0h", i, wready_delay[i]), UVM_DEBUG) ;
    end
    `uvm_info(get_type_name(), $sformatf("bvalid_delay = 0x%0h", bvalid_delay), UVM_DEBUG) ;
    `uvm_info(get_type_name(), $sformatf("bready_delay = 0x%0h", bready_delay), UVM_DEBUG) ;
    foreach(rvalid_delay[i])begin
        `uvm_info(get_type_name(), $sformatf("rvalid_delay[%0d] = 0x%0h", i, rvalid_delay[i]), UVM_DEBUG) ;
    end
    foreach(rready_delay[i])begin
        `uvm_info(get_type_name(), $sformatf("rready_delay[%0d] = 0x%0h", i, rready_delay[i]), UVM_DEBUG) ;
    end

endfunction:field_print

`endif

