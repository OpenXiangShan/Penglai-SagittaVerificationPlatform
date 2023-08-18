`ifndef TCNT_AXI_PROTOCOL_CHECKER__SV
`define TCNT_AXI_PROTOCOL_CHECKER__SV

`define     TCNT_AXI_PROTL_CB this.vif.axi_monitor_cb
class tcnt_axi_protocol_checker extends uvm_component;
    `uvm_component_utils(tcnt_axi_protocol_checker)

    tcnt_axi_cov                axi_cov;
    uvm_analysis_imp#(tcnt_axi_xaction,tcnt_axi_protocol_checker)  get_item_port;
    virtual tcnt_axi_interface  vif;
    tcnt_axi_cfg                cfg;
    string                      tname;

    extern function new(string name="",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern virtual function void write(tcnt_axi_xaction tr);
    extern task run_protocol_check();
    // AXI4
    extern task signal_stable_wuser_when_wvalid_high_check();
    extern task signal_valid_wuser_when_wvalid_high_check();
    extern task signal_stable_awuser_when_awvalid_high_check();
    extern task signal_stable_awregion_when_awvalid_high_check();
    extern task signal_stable_awqos_when_awvalid_high_check();
    extern task signal_stable_buser_when_bvalid_high_check();
    extern task signal_valid_buser_when_bvalid_high_check();
    extern task signal_valid_awuser_when_awvalid_high_check();
    extern task signal_valid_awregion_when_awvalid_high_check();
    extern task signal_valid_awqos_when_awvalid_high_check();
    extern task signal_stable_ruser_when_rvalid_high_check();
    extern task signal_valid_ruser_when_rvalid_high_check();
    extern task signal_stable_aruser_when_arvalid_high_check();
    extern task signal_stable_arregion_when_arvalid_high_check();
    extern task signal_stable_arqos_when_arvalid_high_check();
    extern task signal_valid_aruser_when_arvalid_high_check();
    extern task signal_valid_arregion_when_arvalid_high_check();
    extern task signal_valid_arqos_when_arvalid_high_check();
    extern task max_num_outstanding_xacts_check();
    extern task excl_access_on_write_only_interface_check();
    extern task excl_access_on_read_only_interface_check();
    extern task write_xact_on_write_only_interface_check();
    extern task read_xact_on_read_only_interface_check();
    // AXI3
    extern task write_byte_count_match_across_interconnect();
    extern task eos_unmapped_master_xact();
    extern task eos_unmapped_non_modifiable_xact();
    extern task device_non_bufferable_response_match_check();
    extern task ordering_for_non_modifiable_xact_check();
    extern task cache_type_match_for_non_modifiable_xact_check();
    extern task burst_size_match_for_non_modifiable_xact_check();
    extern task burst_type_match_for_non_modifiable_xact_check();
    extern task burst_length_match_for_non_modifiable_xact_check();
    extern task region_match_for_non_modifiable_xact_check();
    extern task prot_type_match_for_non_modifiable_xact_check();
    extern task atomic_type_match_for_non_modifiable_xact_check();
    extern task master_slave_xact_data_integrity_check();
    extern task data_integrity_check();
    extern task slave_transaction_routing_check();
    extern task awburst_awlen_valid_value_check();
    extern task locked_sequence_to_same_slave_check();
    extern task locked_sequence_length_check();
    extern task no_pending_locked_xacts_before_normal_xacts_check();
    extern task locked_sequeunce_id_check();
    extern task no_pending_xacts_during_locked_xact_sequeunce_check();
    extern task rlast_asserted_for_last_read_data_beat();
    extern task wlast_asserted_for_last_write_data_beat();
    extern task write_resp_follows_last_write_xfer_check();
    extern task read_data_follows_addr_check();
    extern task write_resp_after_write_addr_check();
    extern task write_resp_after_last_wdata_check();
    extern task wdata_awlen_match_for_corresponding_awaddr_check();
    extern task arvalid_arcache_active_check();
    extern task arburst_reserved_val_check();
    extern task arsize_data_width_active_check();
    extern task arlen_wrap_active_check();
    extern task araddr_wrap_aligned_active_check();
    extern task araddr_4k_boundary_cross_active_check();
    extern task awvalid_awcache_active_check();
    extern task awburst_reserved_val_check();
    extern task awsize_data_width_active_check();
    extern task valid_write_strobe_check();
    extern task awlen_wrap_active_check();
    extern task awaddr_wrap_aligned_active_check();
    extern task awaddr_4k_boundary_cross_active_check();
    extern task bvalid_low_when_reset_is_active_check();
    extern task wvalid_low_when_reset_is_active_check();
    extern task awvalid_low_when_reset_is_active_check();
    extern task rvalid_low_when_reset_is_active_check();
    extern task arvalid_low_when_reset_is_active_check();
    extern task bvalid_interrupted_check();
    extern task wvalid_interrupted_check();
    extern task awvalid_interrupted_check();
    extern task rvalid_interrupted_check();
    extern task arvalid_interrupted_check();
    extern task signal_valid_bvalid_check();
    extern task signal_valid_wvalid_check();
    extern task signal_valid_awvalid_check();
    extern task signal_valid_rvalid_check();
    extern task signal_valid_arvalid_check();
    extern task exclusive_read_write_prot_type_check();
    extern task exclusive_read_write_cache_type_check();
    extern task exclusive_read_write_burst_type_check();
    extern task exclusive_read_write_burst_size_check();
    extern task exclusive_read_write_burst_length_check();
    extern task read_data_interleave_check();
    extern task write_data_interleave_order_check();
    extern task write_data_interleave_depth_check();
    extern task exclusive_read_write_addr_check();
    extern task signal_valid_exclusive_write_addr_aligned_check();
    extern task signal_valid_exclusive_awcache_check();
    extern task signal_valid_exclusive_awlen_awsize_check();
    extern task signal_valid_exclusive_read_addr_aligned_check();
    extern task signal_valid_exclusive_arcache_check();
    extern task signal_valid_exclusive_arlen_arsize_check();
    extern task signal_stable_bresp_when_bvalid_high_check();
    extern task signal_stable_bid_when_bvalid_high_check();
    extern task signal_valid_bready_when_bvalid_high_check();
    extern task signal_valid_bresp_when_bvalid_high_check();
    extern task signal_valid_bid_when_bvalid_high_check();
    extern task signal_stable_wlast_when_wvalid_high_check();
    extern task signal_stable_wstrb_when_wvalid_high_check();
    extern task signal_stable_wdata_when_wvalid_high_check();
    extern task signal_stable_wid_when_wvalid_high_check();
    extern task signal_valid_wready_when_wvalid_high_check();
    extern task signal_valid_wlast_when_wvalid_high_check();
    extern task signal_valid_wstrb_when_wvalid_high_check();
    extern task signal_valid_wdata_when_wvalid_high_check();
    extern task signal_valid_wid_when_wvalid_high_check();
    extern task signal_stable_awprot_when_awvalid_high_check();
    extern task signal_stable_awcache_when_awvalid_high_check();
    extern task signal_stable_awlock_when_awvalid_high_check();
    extern task signal_stable_awburst_when_awvalid_high_check();
    extern task signal_stable_awsize_when_awvalid_high_check();
    extern task signal_stable_awlen_when_awvalid_high_check();
    extern task signal_stable_awaddr_when_awvalid_high_check();
    extern task signal_stable_awid_when_awvalid_high_check();
    extern task signal_valid_awready_when_awvalid_high_check();
    extern task signal_valid_awprot_when_awvalid_high_check();
    extern task signal_valid_awcache_when_awvalid_high_check();
    extern task signal_valid_awlock_when_awvalid_high_check();
    extern task signal_valid_awburst_when_awvalid_high_check();
    extern task signal_valid_awsize_when_awvalid_high_check();
    extern task signal_valid_awlen_when_awvalid_high_check();
    extern task signal_valid_awaddr_when_awvalid_high_check();
    extern task signal_valid_awid_when_awvalid_high_check();
    extern task signal_stable_rlast_when_rvalid_high_check();
    extern task signal_stable_rresp_when_rvalid_high_check();
    extern task signal_stable_rdata_when_rvalid_high_check();
    extern task signal_stable_rid_when_rvalid_high_check();
    extern task signal_valid_rready_when_rvalid_high_check();
    extern task signal_valid_rlast_when_rvalid_high_check();
    extern task signal_valid_rresp_when_rvalid_high_check();
    extern task signal_valid_rdata_when_rvalid_high_check();
    extern task signal_valid_rid_when_rvalid_high_check();
    extern task signal_stable_arprot_when_arvalid_high_check();
    extern task signal_stable_arcache_when_arvalid_high_check();
    extern task signal_stable_arlock_when_arvalid_high_check();
    extern task signal_stable_arburst_when_arvalid_high_check();
    extern task signal_stable_arsize_when_arvalid_high_check();
    extern task signal_stable_arlen_when_arvalid_high_check();
    extern task signal_stable_araddr_when_arvalid_high_check();
    extern task signal_stable_arid_when_arvalid_high_check();
    extern task signal_valid_arready_when_arvalid_high_check();
    extern task signal_valid_arprot_when_arvalid_high_check();
    extern task signal_valid_arcache_when_arvalid_high_check();
    extern task signal_valid_arlock_when_arvalid_high_check();
    extern task signal_valid_arburst_when_arvalid_high_check();
    extern task signal_valid_arsize_when_arvalid_high_check();
    extern task signal_valid_arlen_when_arvalid_high_check();
    extern task signal_valid_araddr_when_arvalid_high_check();
    extern task signal_valid_arid_when_arvalid_high_check();
    extern task bresp_id_match_check();
    extern task rresp_id_match_check();
    extern task signal_bvalid_after_wvalid_check();
    extern task signal_rvalid_after_arvalid_check();
    extern task signal_timeout_awready_when_awvalid_high_check();
    extern task signal_timeout_wready_when_wvalid_high_check();
    extern task signal_timeout_bready_when_bvalid_high_check();
    extern task signal_timeout_arready_when_arvalid_high_check();
    extern task signal_timeout_rready_when_rvalid_high_check();
    extern task signal_timeout_awaddr_when_first_wdata_handshake_check();
    extern task signal_timeout_wdata_when_awaddr_handshake_check();
    extern task signal_timeout_bresp_when_last_wdata_handshake_check();
    extern task signal_timeout_rdata_when_araddr_handshake_check();
    extern task write_xact_timeout_check();
    extern task read_xact_timeout_check();
    extern task awaddr_inactive_bit_check();
    extern task araddr_inactive_bit_check();
    extern task wdata_inactive_bit_check();
    extern task rdata_inactive_bit_check();
    extern task wstrb_inactive_bit_check();
    extern task awuser_inactive_bit_check();
    extern task aruser_inactive_bit_check();
    extern task wuser_inactive_bit_check();
    extern task ruser_inactive_bit_check();
    extern task buser_inactive_bit_check();
    extern task awid_inactive_bit_check();        
    extern task wid_inactive_bit_check();        
    extern task bid_inactive_bit_check();        
    extern task arid_inactive_bit_check();        
    extern task rid_inactive_bit_check();        

endclass

function tcnt_axi_protocol_checker::new(string name="",uvm_component parent);
    super.new(name,parent);
    tname = get_name();
    get_item_port = new("get_item_port",this);
endfunction

function void tcnt_axi_protocol_checker::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual tcnt_axi_interface)::get(this,"","vif",vif))
        `uvm_fatal(tname,"failed to get vif through uvm_config_db")
    if(!uvm_config_db#(tcnt_axi_cfg)::get(this,"","cfg",cfg))
        `uvm_fatal(tname,"failed to get cfg through uvm_config_db")        
    if(cfg.system_coverage_enable)
        axi_cov = new({get_full_name(),"axi_cov"},cfg);
endfunction

function void tcnt_axi_protocol_checker::write(tcnt_axi_xaction tr);
    if(cfg.system_coverage_enable)
        axi_cov.run_cov_sampling(tr); 
endfunction
/*
 * Monitor check for X or Z on signal when corresponding valid signal is high
*/
`ifndef TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK
`define TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(SIG,TRIG)                \
    while(1)begin                                                           \
        @`TCNT_AXI_PROTL_CB;                                                \
        if(cfg.signal_valid_checks_enable)begin                             \
            if(`TCNT_AXI_PROTL_CB.TRIG === 1'b1                             \
    `ifndef NOT_USE_CFG_SIG_ENABLE                                          \
            && cfg.SIG``_enable)begin                                       \
    `else                                                                   \
                               )begin                                       \
    `endif                                                                  \
                if($isunknown(`TCNT_AXI_PROTL_CB.SIG))                      \
                    `uvm_error({"SIGNAL_VALID_WHEN_",`"TRIG`","_HIGH_CHECK"},{"Monitor check for X or Z on ", `"SIG`"," when ",`"TRIG`"," is high"})\
            end                                                             \
        end                                                                 \
    end                                                                     \
`endif

/*
 * Monitor check for signal stability when corresponding valid signal is high
*/
`ifndef TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK
`define TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(SIG,SIG_WIDTH,VALID,READY)      \
    begin                                                                           \
        bit start = 0;                                                              \
        logic [SIG_WIDTH-1:0] sig_tmp;                                              \
        while(1)begin                                                               \
            fork                                                                    \
                wait(vif.aresetn === 1'b0);                                         \
                begin                                                               \
                    @`TCNT_AXI_PROTL_CB;                                            \
                    if(cfg.signal_stable_checks_enable                              \
    `ifndef NOT_USE_CFG_SIG_ENABLE                                                  \
                    && cfg.SIG``_enable)begin                                       \
    `else                                                                           \
                                       )begin                                       \
    `endif                                                                          \
                        if(`TCNT_AXI_PROTL_CB.VALID === 1'b1)begin                  \
                            if(start == 0)begin                                     \
                                start = 1'b1;                                       \
                                sig_tmp = `TCNT_AXI_PROTL_CB.SIG;                   \
                            end else begin                                          \
                                if(sig_tmp !== `TCNT_AXI_PROTL_CB.SIG)              \
                                    `uvm_error({"SIGNAL_STABLE_WHEN_",`"VALID`","_HIGH_CHECK"},{"Monitor check for ", `"SIG`"," stable when ",`"VALID`"," is high"})\
                            end                                                     \
                            if(`TCNT_AXI_PROTL_CB.READY === 1'b1)                   \
                                start = 0;                                          \
                        end else begin                                              \
                            start = 0;                                              \
                        end                                                         \
                    end                                                             \
                end                                                                 \
            join_any                                                                \
            disable fork;                                                           \
            if(vif.aresetn === 1'b0)begin                                           \
                start = 0;                                                          \
                sig_tmp = 0;                                                        \
                wait(vif.aresetn === 1'b1);                                         \
            end                                                                     \
        end                                                                         \
    end                                                                             \
`endif

/**
  *Monitor Check for AWVALID held steady until AWREADY is asserted!
  */
`ifndef TCNT_AXI_VALID_INTERRUPT_CHECK
`define TCNT_AXI_VALID_INTERRUPT_CHECK(VALID,READY)                                 \
    while(1)begin                                                                   \
        fork                                                                        \
            wait(vif.aresetn === 1'b0);                                             \
            begin                                                                   \
                @`TCNT_AXI_PROTL_CB;                                                \
                if(`TCNT_AXI_PROTL_CB.VALID)begin                                   \
                    while(1)begin                                                   \
                        if(`TCNT_AXI_PROTL_CB.VALID === 1'b0)                       \
                            `uvm_error({`"VALID`","_INTERRUPT_CHECK"},{"Monitor Check for ",`"VALID`"," held steady until ",`"READY`"," is asserted!"})\
                        if(`TCNT_AXI_PROTL_CB.READY === 1'b1)                       \
                            break;                                                  \
                        @`TCNT_AXI_PROTL_CB;                                        \
                    end                                                             \
                end                                                                 \
            end                                                                     \
        join_any                                                                    \
        disable fork;                                                               \
        if(vif.aresetn === 1'b0)                                                    \
            wait(vif.aresetn === 1'b1);                                             \
    end                                                                             \
`endif

/**
  * Monitor Check for AWVALID low when reset is active!
  */
`ifndef TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK
`define TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(VALID)                \
    while(1)begin                                                           \
        @`TCNT_AXI_PROTL_CB;                                                \
        if((`TCNT_AXI_PROTL_CB.aresetn === 1'b0) && (`TCNT_AXI_PROTL_CB.VALID !== 1'b0))\
            `uvm_error({`"VALID`","_LOW_WHEN_RESET_IS_ACTIVE_CHECK"},{"Monitor Check for ",`"VALID`"," low when reset is active!"})\
    end                                                                     \
`endif

/**
  * Monitor Check for X or Z on BVALID!
  */
`ifndef TCNT_AXI_SIGNAL_VALID_CHECK
`define TCNT_AXI_SIGNAL_VALID_CHECK(VALID)                                  \
    while(1)begin                                                           \
        @`TCNT_AXI_PROTL_CB;                                                \
        if((`TCNT_AXI_PROTL_CB.aresetn === 1'b1) && $isunknown(`TCNT_AXI_PROTL_CB.VALID))\
            `uvm_error({"SIGNAL_",`"VALID`","_CHECK"},{"Monitor Check for X or Z on ",`"VALID`","!"})\
    end                                                                     \
`endif
`ifndef TCNT_AXI_SIGNAL_TIMEOUT_CHECK
`define TCNT_AXI_SIGNAL_TIMEOUT_CHECK(MAX_CYCLE,VALID_SIG,TIMEOUT_SIG)         \
    begin                                                                      \
        int cycle_cnt = 0;                                                     \
        while(1)begin                                                          \
            fork                                                               \
                wait(vif.aresetn === 1'b0);                                    \
                begin                                                          \
                    @`TCNT_AXI_PROTL_CB;                                       \
                    if(VALID_SIG == 1'b1) begin                                \
                        if(TIMEOUT_SIG == 1'b0) begin                          \
                            cycle_cnt++;                                       \
                        end                                                    \
                        else if(TIMEOUT_SIG == 1'b1) begin                     \
                            cycle_cnt = 0 ;                                    \
                        end                                                    \
                        if(cycle_cnt >= MAX_CYCLE) begin                       \
                            `uvm_error({`"VALID_SIG`","_SIGNAL_TIMEOUT_CHECK"}, $sformatf("after %0s is high, cycles waiting for %0s exceed max timeout cycle %0d", `"VALID_SIG`", `"TIMEOUT_SIG`", MAX_CYCLE)) \
                        end                                                    \
                    end                                                        \
                end                                                            \
            join_any                                                           \
            disable fork;                                                      \
            if(vif.aresetn === 1'b0)begin                                      \
                cycle_cnt = 0;                                                 \
                wait(vif.aresetn === 1'b1);                                    \
            end                                                                \
        end                                                                    \
    end                                                                        \
`endif 

`ifndef TCNT_AXI_INACTIVE_BIT_VALID_CHECK
`define TCNT_AXI_INACTIVE_BIT_VALID_CHECK(SIG,VALID_SIG,CFG_BITWIDTH,CFG_ENABLE)      \
    begin                                                               \
        while(1)begin                                                   \
            @`TCNT_AXI_PROTL_CB;                                        \
            if(VALID_SIG === 1'b1)begin                                 \
                if(CFG_ENABLE && ($countbits(SIG >> integer'(CFG_BITWIDTH),1'b1) != 0))begin    \
                    `uvm_error({`"SIG`","_INACTIVE_BIT_VALID_CHECK"},$sformatf("%0s[0x%0h] inactive bit[msb:%0d] should not be USED.",`"SIG`",SIG,CFG_BITWIDTH))\
                end                                                     \
            end                                                         \
        end                                                             \
    end                                                                 \
`endif

task tcnt_axi_protocol_checker::signal_stable_wuser_when_wvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(wuser,`TCNT_AXI_MAX_DATA_USER_WIDTH,wvalid,wready)
endtask

task tcnt_axi_protocol_checker::signal_valid_wuser_when_wvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wuser,wvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_awuser_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awuser,`TCNT_AXI_MAX_ADDR_USER_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awregion_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awregion,`TCNT_AXI_REGION_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awqos_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awqos,`TCNT_AXI_QOS_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_buser_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(buser,`TCNT_AXI_MAX_BRESP_USER_WIDTH,bvalid,bready)
endtask

task tcnt_axi_protocol_checker::signal_valid_buser_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(buser,bvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awuser_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awuser,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awregion_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awregion,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awqos_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awqos,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_ruser_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(ruser,`TCNT_AXI_MAX_DATA_USER_WIDTH,rvalid,rready)
endtask

task tcnt_axi_protocol_checker::signal_valid_ruser_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(ruser,rvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_aruser_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(aruser,`TCNT_AXI_MAX_ADDR_USER_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arregion_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arregion,`TCNT_AXI_REGION_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arqos_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arqos,`TCNT_AXI_QOS_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_valid_aruser_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(aruser,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arregion_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arregion,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arqos_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arqos,arvalid)
endtask

/* 
 * Checks that AXI master and AXI slave are not exceeding the user configured maximum number of outstanding transactions
 */
task tcnt_axi_protocol_checker::max_num_outstanding_xacts_check();
    int wr_osd = 0,rd_osd = 0;
    int target_max_wr_outstanding_num = cfg.num_outstanding_xact == -1 ? cfg.num_write_outstanding_xact : cfg.num_outstanding_xact;
    int target_max_rd_outstanding_num = cfg.num_outstanding_xact == -1 ? cfg.num_read_outstanding_xact  : cfg.num_outstanding_xact;
    fork
        while(1)begin
            if(vif.aresetn === 1'b0)
                wr_osd = 0;
            else if(`TCNT_AXI_PROTL_CB.awvalid && `TCNT_AXI_PROTL_CB.awready)begin
                wr_osd++;
                if(wr_osd > target_max_wr_outstanding_num)
                    `uvm_error("WRITE_OUSTANDING_EXCEED_CHECK",$sformatf("axi write oustanding[%0d] > cfg.max_outstanding_num[%0d].",wr_osd,target_max_wr_outstanding_num))
            end
            @`TCNT_AXI_PROTL_CB;
        end
        while(1)begin
            if(vif.aresetn === 1'b0)
                wr_osd = 0;
            else if(`TCNT_AXI_PROTL_CB.bvalid && `TCNT_AXI_PROTL_CB.bready)begin
                wr_osd--;
                if(wr_osd < 0)
                    `uvm_error("WRITE_OUTSTANDING_LESS_THAN_0_CHECK",$sformatf("axi write oustanding[%0d] < 0.",wr_osd))
            end
            @`TCNT_AXI_PROTL_CB;                
        end
        while(1)begin
            if(vif.aresetn === 1'b0)
                rd_osd = 0;
            else if(`TCNT_AXI_PROTL_CB.arvalid && `TCNT_AXI_PROTL_CB.arready)begin
                rd_osd++;
                if(rd_osd > target_max_rd_outstanding_num)
                    `uvm_error("READ_OUSTANDING_EXCEED_CHECK",$sformatf("axi read oustanding[%0d] > cfg.max_outstanding_num[%0d].",rd_osd,target_max_rd_outstanding_num))
            end
            @`TCNT_AXI_PROTL_CB;
        end
        while(1)begin
            if(vif.aresetn === 1'b0)
                rd_osd = 0;
            else if(`TCNT_AXI_PROTL_CB.rvalid && `TCNT_AXI_PROTL_CB.rready && `TCNT_AXI_PROTL_CB.rlast)begin
                rd_osd--;
                if(rd_osd < 0)
                    `uvm_error("READ_OUTSTANDING_LESS_THAN_0_CHECK",$sformatf("axi read oustanding[%0d] < 0.",rd_osd))
            end
            @`TCNT_AXI_PROTL_CB;                
        end        
        while(1)begin
            wait(vif.aresetn === 1'b0);
            // reset and handshake may come at the same time 
            //wr_osd = 0;
            //rd_osd = 0;
            target_max_wr_outstanding_num = cfg.num_outstanding_xact == -1 ? cfg.num_write_outstanding_xact : cfg.num_outstanding_xact;
            target_max_rd_outstanding_num = cfg.num_outstanding_xact == -1 ? cfg.num_read_outstanding_xact  : cfg.num_outstanding_xact;
            wait(vif.aresetn === 1'b1);
        end
    join
endtask

task tcnt_axi_protocol_checker::excl_access_on_write_only_interface_check();
	// TODO
endtask

task tcnt_axi_protocol_checker::excl_access_on_read_only_interface_check();
	// TODO
endtask

task tcnt_axi_protocol_checker::write_xact_on_write_only_interface_check();
	// TODO
endtask

task tcnt_axi_protocol_checker::read_xact_on_read_only_interface_check();
	// TODO
endtask

task tcnt_axi_protocol_checker::write_byte_count_match_across_interconnect();
// TODO
endtask

task tcnt_axi_protocol_checker::eos_unmapped_master_xact();
// TODO
endtask

task tcnt_axi_protocol_checker::eos_unmapped_non_modifiable_xact();
// TODO
endtask

task tcnt_axi_protocol_checker::device_non_bufferable_response_match_check();
// TODO
endtask

/** 
  * AMBA AXI and ACE Protocol Specification: ARM IHI 0022E ID022613; Section A4.3.2
  * Monitor check that for non-modifiable transactions, transactions with the same ID to the same slave must be ordered
  */
task tcnt_axi_protocol_checker::ordering_for_non_modifiable_xact_check();   
// TODO
endtask

task tcnt_axi_protocol_checker::cache_type_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::burst_size_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::burst_type_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::burst_length_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::region_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::prot_type_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::atomic_type_match_for_non_modifiable_xact_check();
// TODO
endtask

task tcnt_axi_protocol_checker::master_slave_xact_data_integrity_check();
// TODO
endtask

task tcnt_axi_protocol_checker::data_integrity_check();
// TODO
endtask

task tcnt_axi_protocol_checker::slave_transaction_routing_check();
// TODO
endtask

task tcnt_axi_protocol_checker::awburst_awlen_valid_value_check();
// TODO
endtask

task tcnt_axi_protocol_checker::locked_sequence_to_same_slave_check();
// TODO
endtask

task tcnt_axi_protocol_checker::locked_sequence_length_check();
// TODO
endtask

task tcnt_axi_protocol_checker::no_pending_locked_xacts_before_normal_xacts_check();
// TODO
endtask

task tcnt_axi_protocol_checker::locked_sequeunce_id_check();
// TODO
endtask

task tcnt_axi_protocol_checker::no_pending_xacts_during_locked_xact_sequeunce_check();
// TODO
endtask

/** 
  * Monitor Check that RLAST is HIGH only for the last beat of READ burst !
  * support for reorder resp
  * support for read data interleave
  */
task tcnt_axi_protocol_checker::rlast_asserted_for_last_read_data_beat();
    typedef tcnt_axi_xaction tcnt_axi_xaction_queue[$];
    
    tcnt_axi_xaction_queue xaction_aa[logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]];
    int rbeat_aa[logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]];

    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.arvalid && `TCNT_AXI_PROTL_CB.arready === 1'b1)begin
                    tcnt_axi_xaction tr = tcnt_axi_xaction::type_id::create("tr");
                    tr.burst_length = `TCNT_AXI_PROTL_CB.arlen + 1;
                    tr.id = `TCNT_AXI_PROTL_CB.arid;
                    if(!xaction_aa.exists(tr.id))
                        xaction_aa[tr.id] = {};
                    xaction_aa[tr.id].push_back(tr);
                end
                if(`TCNT_AXI_PROTL_CB.rvalid && `TCNT_AXI_PROTL_CB.rready)begin
                    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] rid = `TCNT_AXI_PROTL_CB.rid;
                    if(!rbeat_aa.exists(rid))begin
                        rbeat_aa[rid] = 0;
                    end
                    rbeat_aa[rid]++; 

                    if(!xaction_aa.exists(rid) || (xaction_aa.exists(rid) && xaction_aa[rid].size() == 0))
                        `uvm_error("RID_NOT_FOUND_CHECK",$sformatf("rid[0x%0h] NOT found in previous transactions!",rid))

                    if(`TCNT_AXI_PROTL_CB.rlast)begin
                        tcnt_axi_xaction tr = xaction_aa[rid].pop_front();
                        int rbeat = rbeat_aa[rid]; 
                        rbeat_aa.delete(rid);
                        if(rbeat != tr.burst_length)begin
                            `uvm_error("RLAST_HIGH_ONLY_FOR_LAST_BEAT_CHECK",$sformatf("Monitor Check that RLAST is HIGH only for the last beat of READ burst[id:0x%0h,bust_length = %0d]!",
                                                                       rid,tr.burst_length))
                        end
                    end else begin
                        tcnt_axi_xaction tr = xaction_aa[rid][0];
                        int rbeat = rbeat_aa[rid];
                        if(rbeat == tr.burst_length)begin
                            `uvm_error("RLAST_HIGH_ONLY_FOR_LAST_BEAT_CHECK",$sformatf("Monitor Check that RLAST shoule be HIGH only for the last beat of READ burst ![id:0x%0h,bust_length = %0d]",
                                                                       rid,tr.burst_length))
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            xaction_aa.delete();
            rbeat_aa.delete();
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

/** 
  * Monitor Check that WLAST is asserted for last beat of write data!
  * support for data_before_address
  * write data interleave not support
  */
task tcnt_axi_protocol_checker::wlast_asserted_for_last_write_data_beat();
    tcnt_axi_xaction xact_q[$];
    int wbeat_q[$];
    int wbeat = 0;
    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.awvalid && `TCNT_AXI_PROTL_CB.awready === 1'b1)begin
                    if(wbeat_q.size() != 0)begin// data before address
                        if(wbeat_q.pop_front() != (`TCNT_AXI_PROTL_CB.awlen + 1))begin
                            `uvm_error("WLAST_ASSERTED_FOR_LAST_BEAT_CHECK",$sformatf("data before address, transaction[id=0x%0h] burst length[%0d] mismatches with WLAST in previous data beats!",
                                                                       `TCNT_AXI_PROTL_CB.awid,`TCNT_AXI_PROTL_CB.awlen+1))
                        end
                    end else begin
                        tcnt_axi_xaction tr = tcnt_axi_xaction::type_id::create("tr");
                        tr.burst_length = `TCNT_AXI_PROTL_CB.awlen + 1;
                        tr.id = `TCNT_AXI_PROTL_CB.awid;
                        xact_q.push_back(tr);
                    end
                end
                if(`TCNT_AXI_PROTL_CB.wvalid && `TCNT_AXI_PROTL_CB.wready)begin
                    wbeat++;
                    if(`TCNT_AXI_PROTL_CB.wlast)begin
                        if(xact_q.size() == 0)
                            wbeat_q.push_back(wbeat);
                        else begin
                            tcnt_axi_xaction tr = xact_q.pop_front();
                            if(wbeat != tr.burst_length)begin
                                `uvm_error("WLAST_ASSERTED_FOR_LAST_BEAT_CHECK",$sformatf("Monitor Check that WLAST is asserted for last beat of write data, transaction id = 0x%0h, burst_length = %0d!",
                                                                           tr.id,tr.burst_length))
                            end
                        end
                        wbeat = 0;
                    end else begin// wlast = 0
                        if((xact_q.size() > 0) && (xact_q[0].burst_length == wbeat))begin// if wlast always be 0
                            `uvm_error("WLAST_ASSERTED_FOR_LAST_BEAT_CHECK",$sformatf("Monitor Check that WLAST should be asserted for last beat of write data, transaction id = 0x%0h, burst_length = %0d!",
                                                                       xact_q[0].id,xact_q[0].burst_length))
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            xact_q.delete();
            wbeat_q.delete();
            wbeat = 0;
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

/*
 * Monitor Check that write response must always follow last write data transfer!
 */
task tcnt_axi_protocol_checker::write_resp_follows_last_write_xfer_check();
    int on_fly_write_xfer = 0;
    fork 
        while(1)begin
            if(vif.aresetn === 1'b0)
                on_fly_write_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.bvalid && `TCNT_AXI_PROTL_CB.bready)begin
                on_fly_write_xfer--;
                if(on_fly_write_xfer < 0)
                    `uvm_error("WRITE_RESP_FOLLOWS_LAST_WRITE_XFER_CHECK",$sformatf("Monitor Check that write response[bid:0x%0h] must always follow last write data transfer!",`TCNT_AXI_PROTL_CB.bid))
            end        
            @`TCNT_AXI_PROTL_CB;
        end
        while(1)begin
            if(vif.aresetn === 1'b0)
                on_fly_write_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.wvalid && `TCNT_AXI_PROTL_CB.wready && `TCNT_AXI_PROTL_CB.wlast)
                on_fly_write_xfer++;        
            @`TCNT_AXI_PROTL_CB;
        end
    join 
endtask

/*
 * Monitor Check that read data must always follow address to which the data relates!
 */
task tcnt_axi_protocol_checker::read_data_follows_addr_check();
    int on_fly_read_xfer = 0;
    fork 
        while(1)begin
            if(vif.aresetn === 1'b0)
                on_fly_read_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.rvalid && `TCNT_AXI_PROTL_CB.rready && `TCNT_AXI_PROTL_CB.rlast)begin
                on_fly_read_xfer--;
                if(on_fly_read_xfer < 0)
                    `uvm_error("READ_DATA_FOLLOWS_ADDR_CHECK",$sformatf("Monitor Check that read data[rid:0x%0h] must always follow address to which the data relates!",`TCNT_AXI_PROTL_CB.rid))
            end        
            @`TCNT_AXI_PROTL_CB;
        end
        while(1)begin
             if(vif.aresetn === 1'b0)
                on_fly_read_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.arvalid && `TCNT_AXI_PROTL_CB.arready)
                on_fly_read_xfer++;        
            @`TCNT_AXI_PROTL_CB;
        end
    join
endtask

task tcnt_axi_protocol_checker::write_resp_after_write_addr_check();
    int on_fly_write_xfer = 0;
    fork 
        while(1)begin
            if(vif.aresetn === 1'b0)
                on_fly_write_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.bvalid && `TCNT_AXI_PROTL_CB.bready)begin
                on_fly_write_xfer--;
                if(on_fly_write_xfer < 0)
                    `uvm_error("WRITE_RESP_AFTER_WRITE_ADDR_CHECK",$sformatf("Monitor Check that a slave must not transmit the write response[bid:0x%0h] before the corresponding address is accepted!",`TCNT_AXI_PROTL_CB.bid))
            end        
            @`TCNT_AXI_PROTL_CB;
        end
        while(1)begin
            if(vif.aresetn === 1'b0)
                on_fly_write_xfer = 0;
            else if(`TCNT_AXI_PROTL_CB.awvalid && `TCNT_AXI_PROTL_CB.awready)
                on_fly_write_xfer++;        
            @`TCNT_AXI_PROTL_CB;
        end
    join
endtask
/*
 * Monitor Check that a slave must only give a write response after the last write data item is transferred !
 */
task tcnt_axi_protocol_checker::write_resp_after_last_wdata_check();
    write_resp_follows_last_write_xfer_check();
endtask

task tcnt_axi_protocol_checker::wdata_awlen_match_for_corresponding_awaddr_check();
// TODO
endtask

/**
  * Monitor Check that ARCACHE[3:2] is 2'b00 when ARVALID is HIGH and ARCACHE[1] is LOW !
  */
task tcnt_axi_protocol_checker::arvalid_arcache_active_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(cfg.arcache_enable && (`TCNT_AXI_PROTL_CB.arvalid === 1'b1) && (`TCNT_AXI_PROTL_CB.arcache[1] === 1'b0))begin
            if(`TCNT_AXI_PROTL_CB.arcache[3:2] !== 2'b00)begin
                `uvm_error("ARVALID_ARCACHE_ACTIVE_CHECK",$sformatf("Monitor Check that ARCACHE[3:2] is 2'b00(act:0x%0h) when ARVALID is HIGH and ARCACHE[1] is LOW !",
                            `TCNT_AXI_PROTL_CB.arcache[3:2]))
            end
        end
    end
endtask

/**
  * Monitor Check that a value of 2'b11 on ARBURST is not permitted when ARVALID is HIGH !
  */
task tcnt_axi_protocol_checker::arburst_reserved_val_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if((`TCNT_AXI_PROTL_CB.arvalid === 1'b1) && (`TCNT_AXI_PROTL_CB.arburst === 2'b11))
            `uvm_error("ARBURST_RESERVED_VAL_CHECK","Monitor Check that a value of 2'b11 on ARBURST is not permitted when ARVALID is HIGH !")
    end
endtask

/**
  * Monitor Check that a Read transfer does not exceed the width of the data interface!
  */
task tcnt_axi_protocol_checker::arsize_data_width_active_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if((`TCNT_AXI_PROTL_CB.arvalid === 1'b1) && ((1 << `TCNT_AXI_PROTL_CB.arsize)*8 > cfg.data_width))begin
            `uvm_error("ARSIZE_DATA_WIDTH_ACTIVE_CHECK",$sformatf("Monitor Check that a Read transfer[arsize:%0d] does not exceed the width of the cfg data interface[%0d]!",
                                                       (1 << `TCNT_AXI_PROTL_CB.arsize)*8,cfg.data_width))
        end
    end
endtask

/** 
  * Monitor Check that arlen is 2, 4, 8 or 16 when burst_type is WRAP !
  */
task tcnt_axi_protocol_checker::arlen_wrap_active_check();
    tcnt_axi_xaction    tr ;

    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.arvalid === 1'b1 && `TCNT_AXI_PROTL_CB.arready === 1'b1) begin
            tr = tcnt_axi_xaction::type_id::create("tr");
            tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.arburst);
            tr.burst_length = `TCNT_AXI_PROTL_CB.arlen + 1 ;
            tr.addr = `TCNT_AXI_PROTL_CB.araddr  ;
            if(tr.burst_type == tcnt_axi_dec::WRAP) begin
                if(!(tr.burst_length inside {2, 4, 8, 16})) begin
                    `uvm_error("ARLEN_WRAP_ACTIVE_CHECK", $sformatf("transaction(araddr = 0x%0h) has an error burst length(arlen = 0x%0h) in wrapping burst(protocal:the length of the burst must be 2, 4, 8, or 16 transfers)", tr.addr, tr.burst_length)) ;
                end
            end
        end
    end

endtask

task tcnt_axi_protocol_checker::araddr_wrap_aligned_active_check();
    tcnt_axi_xaction    tr ;
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]          aligned_addr;
    int                                         bytes_size ;

    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.arvalid === 1'b1 && `TCNT_AXI_PROTL_CB.arready === 1'b1) begin
            tr = tcnt_axi_xaction::type_id::create("tr");
            tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.arburst);
            tr.burst_size  = tcnt_axi_dec::burst_size_enum'(`TCNT_AXI_MON_CB.arsize);
            tr.addr = `TCNT_AXI_PROTL_CB.araddr  ;
            if(tr.burst_type == tcnt_axi_dec::WRAP) begin
                bytes_size = 1 << tr.burst_size ;
                aligned_addr = (tr.addr/bytes_size)*bytes_size ;
                if(aligned_addr != tr.addr) begin
                    `uvm_error("ARADDR_WRAP_ALIGNED_ACTIVE_CHECK", $sformatf("transaction(araddr = 0x%0h) does not match aligned address(0x%0h) in wrapping burst(protocol:the start address must be aligned to the size of each transfer)", tr.addr, aligned_addr)) ;
                end
            end
        end
    end

endtask

/** 
  * Monitor Check that a Read burst cannot cross a 4K boundary!
  */
task tcnt_axi_protocol_checker::araddr_4k_boundary_cross_active_check();
/*
 *  When the burst type is not Fixed, it must be ensured that burst does not
 *  exceed 4k range
 */
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.arvalid === 1'b1)begin
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr_range;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        max_possible_addr;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr_mask;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr = `TCNT_AXI_PROTL_CB.araddr;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        burst_addr_mask;
            bit [`TCNT_AXI_MAX_BURST_LENGTH_WIDTH : 0]  burst_length = `TCNT_AXI_PROTL_CB.arlen + 1;
            bit [1:0]                                   burst_type = `TCNT_AXI_PROTL_CB.arburst;
            bit [3:0]                                   burst_size = `TCNT_AXI_PROTL_CB.arsize;
            max_possible_addr = (2048'b1 << cfg.addr_width) - 1;
            if(burst_type != FIXED)begin 
                addr_range = (burst_length * (1 << burst_size));
                addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << burst_size);
                if(burst_type == WRAP)begin
                    // Make sure that the max address does not cross addr_width.
                    // Need to calculate this from wrap boundary (lowest address)
                    // Note that the max byte address is:
                    // (burst_length-1)*bytes_in_each_transfer + (bytes_in_each_transfer-1)
                    if (burst_length == 2)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+1));
                    else if (burst_length == 4)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+2));
                    else if (burst_length == 8)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+3));
                    else if (burst_length == 16)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+4));
            
                    addr = (addr & addr_mask);
                    if((addr & burst_addr_mask) + addr_range - 1 > max_possible_addr)
                        `uvm_error("ARADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Read burst[addr:0x%0h,WRAP] exceed max_possible_addr[0x%0h]!",`TCNT_AXI_PROTL_CB.araddr,max_possible_addr))
                    if(longint'(addr[11:0] & burst_addr_mask) > longint'(`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range))
                        `uvm_error("ARADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Read burst[addr:0x%0h,WRAP] cannot cross a 4K boundary!",`TCNT_AXI_PROTL_CB.araddr))
                end else begin
                    // INCR
                    if(longint'(addr[11:0] & addr_mask) > longint'(`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range))
                        `uvm_error("ARADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Read burst[addr:0x%0h,INCR] cannot cross a 4K boundary!",`TCNT_AXI_PROTL_CB.araddr))
                    // Make sure that the max address does not cross addr_width.
                    // Use aligned address
                    if(((addr >> burst_size) << burst_size) + addr_range - 1 > max_possible_addr)
                        `uvm_error("ARADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Read burst[addr:0x%0h,WRAP] exceed max_possible_addr[0x%0h]!",`TCNT_AXI_PROTL_CB.araddr,max_possible_addr))
                end 
            end 
        end
    end
endtask

/**
  *	Monitor Check that AWCACHE[3:2] is 2'b00 when AWVALID is HIGH and AWCACHE[1] is LOW !
  */
task tcnt_axi_protocol_checker::awvalid_awcache_active_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(cfg.awcache_enable && (`TCNT_AXI_PROTL_CB.awvalid === 1'b1) && (`TCNT_AXI_PROTL_CB.awcache[1] === 0))begin
            if(`TCNT_AXI_PROTL_CB.awcache[3:2] !== 0)begin
                `uvm_error("AWVALID_AWCACHE_ACTIVE_CHECK",$sformatf("Monitor Check that AWCACHE[3:2] is 2'b00(act:0x%0h) when AWVALID is HIGH and AWCACHE[1] is LOW !",
                            `TCNT_AXI_PROTL_CB.awcache[3:2]))
            end                
        end
    end     
endtask

/**
  * Monitor Check that a value of 2'b11 on AWBURST is not permitted when AWVALID is HIGH !
  */
task tcnt_axi_protocol_checker::awburst_reserved_val_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if((`TCNT_AXI_PROTL_CB.awvalid === 1'b1) && (`TCNT_AXI_PROTL_CB.awburst === 2'b11))
            `uvm_error("AWBURST_RESERVED_VAL_CHECK","Monitor Check that a value of 2'b11 on AWBURST is not permitted when AWVALID is HIGH !")
    end    
endtask

/**
  * Monitor Check that a Write transfer does not exceed the width of the data interface!
  */
task tcnt_axi_protocol_checker::awsize_data_width_active_check();
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if((`TCNT_AXI_PROTL_CB.awvalid === 1'b1) && ((1 << `TCNT_AXI_PROTL_CB.awsize)*8 > cfg.data_width))begin
                `uvm_error("AWSIZE_DATA_WIDTH_ACTIVE_CHECK",$sformatf("Monitor Check that a Write transfer[awsize:%0d] does not exceed the cfg width of the data interface[%0d]!",
                                                           (1 << `TCNT_AXI_PROTL_CB.arsize)*8,cfg.data_width))
        end
    end    
endtask

/**
  * Monitor Check that valid Write Strobes are driven for each data beat!
  */
task tcnt_axi_protocol_checker::valid_write_strobe_check();
/* MOVE THIS CHECK INTO MONITOR
    tcnt_axi_xaction tr_q[$]; 
    tcnt_axi_xaction tr;
    int data_before_addr_cnt = 0;
    bit first_beat = 1;
    while(1)begin
        fork
            wait(vif.aresetn == 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.awvalid && `TCNT_AXI_PROTL_CB.awready)begin
                    if(data_before_addr_cnt <= 0)begin
                        tr = tcnt_axi_xaction::type_id::create("tr");
                        tr.cfg              = this.cfg;
                        tr.burst_type       = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.awburst);
                        tr.burst_length     = `TCNT_AXI_PROTL_CB.awlen + 1;
                        tr.burst_size       = `TCNT_AXI_PROTL_CB.awsize;
                        tr.addr             = `TCNT_AXI_PROTL_CB.awaddr;
                        tr.wstrb            = new[tr.burst_length];
                        tr.addr_status      = tcnt_axi_dec::ACCEPT;
                        tr_q.push_back(tr);                
                    end else begin
                        tr = tr_q[tr_q.size()-1];
                        tr.burst_type       = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.awburst);
                        tr.burst_length     = `TCNT_AXI_PROTL_CB.awlen + 1;
                        tr.burst_size       = `TCNT_AXI_PROTL_CB.awsize;
                        tr.addr             = `TCNT_AXI_PROTL_CB.awaddr;                
                        tr.wstrb            = new[tr.burst_length](tr.wstrb);
                        tr.addr_status      = tcnt_axi_dec::ACCEPT;
                        if(tr.data_status == tcnt_axi_dec::ACCEPT)begin
                            foreach(tr.wstrb[i])
                                void'(tr.check_wstrb(i));
                            void'(tr_q.pop_front());
                            `uvm_info("VALID_WRITE_STROBE_CHECK","1049 tr_q.pop_front()",UVM_LOW)
                        end
                    end

                    data_before_addr_cnt--;
                end
                if(`TCNT_AXI_PROTL_CB.wvalid && `TCNT_AXI_PROTL_CB.wready)begin
                    if(data_before_addr_cnt >= 0)begin
                        if(first_beat)begin
                            tr = tcnt_axi_xaction::type_id::create("tr");
                            tr.cfg   = this.cfg;
                            tr.wstrb = new[256];
                            tr_q.push_back(tr);
                        end 
                    end
                    tr = tr_q[0];
                    tr.wstrb[tr.data_beat_cnt] = `TCNT_AXI_PROTL_CB.wstrb;
                    if(data_before_addr_cnt <= 0)begin
                        if(tr.addr_status == tcnt_axi_dec::ACCEPT)begin
                            void'(tr.check_wstrb(tr.data_beat_cnt));
                            if(`TCNT_AXI_PROTL_CB.wlast)begin
                                void'(tr_q.pop_front()); 
                                `uvm_info("VALID_WRITE_STROBE_CHECK","1071 tr_q.pop_front()",UVM_LOW)
                            end
                        end
                    end
                    tr.data_beat_cnt++;
                    if(first_beat)begin
                        first_beat = 0;
                        data_before_addr_cnt++;
                    end
                    if(`TCNT_AXI_PROTL_CB.wlast)begin
                        tr.data_status = tcnt_axi_dec::ACCEPT;
                        first_beat = 1;
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn == 1'b0)begin
            tr_q.delete(); 
            tr = null;
            data_before_addr_cnt = 0;
            first_beat = 1;            
            wait(vif.aresetn === 1'b1);
        end
    end
    */
endtask

task tcnt_axi_protocol_checker::awlen_wrap_active_check();
    tcnt_axi_xaction    tr ;

    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.awvalid === 1'b1 && `TCNT_AXI_PROTL_CB.awready === 1'b1) begin
            tr = tcnt_axi_xaction::type_id::create("tr");
            tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.awburst);
            tr.burst_length = `TCNT_AXI_PROTL_CB.awlen + 1 ;
            tr.addr = `TCNT_AXI_PROTL_CB.awaddr  ;
            if(tr.burst_type == tcnt_axi_dec::WRAP) begin
                if(!(tr.burst_length inside {2, 4, 8, 16})) begin
                    `uvm_error("AWLEN_WRAP_ACTIVE_CHECK", $sformatf("transaction(awaddr = 0x%0h) has a error burst length(awlen = 0x%0h) \
in wrapping burst(protocol:the length of the burst must be 2, 4, 8, or 16 transfers)", tr.addr, tr.burst_length)) ;
                end
            end
        end
    end

endtask

task tcnt_axi_protocol_checker::awaddr_wrap_aligned_active_check();

    tcnt_axi_xaction    tr ;
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]          aligned_addr;
    int                                         bytes_size ;

    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.awvalid === 1'b1 && `TCNT_AXI_PROTL_CB.awready === 1'b1) begin
            tr = tcnt_axi_xaction::type_id::create("tr");
            tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.awburst);
            tr.burst_size  = tcnt_axi_dec::burst_size_enum'(`TCNT_AXI_MON_CB.awsize);
            tr.addr = `TCNT_AXI_PROTL_CB.awaddr  ;
            if(tr.burst_type == tcnt_axi_dec::WRAP) begin
                bytes_size = 1 << tr.burst_size ;
                aligned_addr = (tr.addr/bytes_size)*bytes_size ;
                if(aligned_addr != tr.addr) begin
                    `uvm_error("AWADDR_WRAP_ALIGNED_ACTIVE_CHECK", $sformatf("transaction(awaddr = 0x%0h) does not match aligned address(0x%0h) in wrapping burst(protocol:the start address must be aligned to the size of each transfer)", tr.addr, aligned_addr)) ;
                end
            end
        end
    end

endtask

/** 
  * Monitor Check that a Read burst cannot cross a 4K boundary!
  */
task tcnt_axi_protocol_checker::awaddr_4k_boundary_cross_active_check();
/*
 *  When the burst type is not Fixed, it must be ensured that burst does not
 *  exceed 4k range
 */
    while(1)begin
        @`TCNT_AXI_PROTL_CB;
        if(`TCNT_AXI_PROTL_CB.awvalid === 1'b1)begin
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr_range;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr_mask;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        max_possible_addr;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        addr = `TCNT_AXI_PROTL_CB.awaddr;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH - 1:0]        burst_addr_mask;
            bit [`TCNT_AXI_MAX_BURST_LENGTH_WIDTH : 0]  burst_length = `TCNT_AXI_PROTL_CB.awlen + 1;
            bit [1:0]                                   burst_type = `TCNT_AXI_PROTL_CB.awburst;
            bit [3:0]                                   burst_size = `TCNT_AXI_PROTL_CB.awsize;
            max_possible_addr = (2048'b1 << cfg.addr_width) - 1;
            if(burst_type != FIXED)begin 
                addr_range = (burst_length * (1 << burst_size));
                addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << burst_size);
                if(burst_type == WRAP)begin
                    // Make sure that the max address does not cross addr_width.
                    // Need to calculate this from wrap boundary (lowest address)
                    // Note that the max byte address is:
                    // (burst_length-1)*bytes_in_each_transfer + (bytes_in_each_transfer-1)
                    if (burst_length == 2)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+1));
                    else if (burst_length == 4)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+2));
                    else if (burst_length == 8)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+3));
                    else if (burst_length == 16)
                        burst_addr_mask = ( {`TCNT_AXI_MAX_ADDR_WIDTH{1'b1}} << (burst_size+4));
            
                    addr = (addr & addr_mask);
                    if((addr & burst_addr_mask) + addr_range - 1 > max_possible_addr)
                        `uvm_error("AWADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Write burst[addr:0x%0h,WRAP] exceed max_possible_addr[0x%0h]!",`TCNT_AXI_PROTL_CB.awaddr,max_possible_addr))
                    if(longint'(addr[11:0] & burst_addr_mask) > longint'(`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range))
                        `uvm_error("AWADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Write burst[addr:0x%0h,WRAP] cannot cross a 4K boundary!",`TCNT_AXI_PROTL_CB.awaddr))
                end else begin
                    // INCR
                    if(longint'(addr[11:0] & addr_mask) > longint'(`TCNT_AXI_TRANSACTION_4K_ADDR_RANGE - addr_range))
                        `uvm_error("AWADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Write burst[addr:0x%0h,INCR] cannot cross a 4K boundary!",`TCNT_AXI_PROTL_CB.awaddr))
                    // Make sure that the max address does not cross addr_width.
                    // Use aligned address
                    if(((addr >> burst_size) << burst_size) + addr_range - 1 > max_possible_addr)
                        `uvm_error("AWADDR_4K_BOUNDARY_CROSS_ACTIVE_CHECK",$sformatf("Monitor Check that a Write burst[addr:0x%0h,WRAP] exceed max_possible_addr[0x%0h]!",`TCNT_AXI_PROTL_CB.awaddr,max_possible_addr))
                end 
            end 
        end
    end
endtask

task tcnt_axi_protocol_checker::bvalid_low_when_reset_is_active_check();
    `TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(bvalid)
endtask

task tcnt_axi_protocol_checker::wvalid_low_when_reset_is_active_check();
    `TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(wvalid)
endtask

task tcnt_axi_protocol_checker::awvalid_low_when_reset_is_active_check();
    `TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(awvalid)
endtask

task tcnt_axi_protocol_checker::rvalid_low_when_reset_is_active_check();
    `TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(rvalid)
endtask

task tcnt_axi_protocol_checker::arvalid_low_when_reset_is_active_check();
    `TCNT_AXI_VALID_LOW_WHEN_RESET_IS_ACTIVE_CHECK(arvalid)
endtask

task tcnt_axi_protocol_checker::bvalid_interrupted_check();
    `TCNT_AXI_VALID_INTERRUPT_CHECK(bvalid,bready)
endtask

task tcnt_axi_protocol_checker::wvalid_interrupted_check();
    `TCNT_AXI_VALID_INTERRUPT_CHECK(wvalid,wready)
endtask

task tcnt_axi_protocol_checker::awvalid_interrupted_check();
    `TCNT_AXI_VALID_INTERRUPT_CHECK(awvalid,awready)
endtask

task tcnt_axi_protocol_checker::rvalid_interrupted_check();
    `TCNT_AXI_VALID_INTERRUPT_CHECK(rvalid,rready)
endtask

task tcnt_axi_protocol_checker::arvalid_interrupted_check();
    `TCNT_AXI_VALID_INTERRUPT_CHECK(arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_valid_bvalid_check();
    `TCNT_AXI_SIGNAL_VALID_CHECK(bvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_wvalid_check();
    `TCNT_AXI_SIGNAL_VALID_CHECK(wvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awvalid_check();
    `TCNT_AXI_SIGNAL_VALID_CHECK(awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_rvalid_check();
    `TCNT_AXI_SIGNAL_VALID_CHECK(rvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arvalid_check();
    `TCNT_AXI_SIGNAL_VALID_CHECK(arvalid)
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_prot_type_check();
// TODO
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_cache_type_check();
// TODO
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_burst_type_check();
// TODO
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_burst_size_check();
// TODO
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_burst_length_check();
// TODO
endtask

task tcnt_axi_protocol_checker::read_data_interleave_check();
    // only check master
    if((cfg.axi_port_kind == tcnt_axi_dec::AXI_MASTER && cfg.drv_sw == tcnt_dec_base::ON))begin
        bit slave_interleave_enabled = 0;
        tcnt_axi_xaction xact_q[$];
        while(1)begin
            fork 
                wait(vif.aresetn === 1'b0);
                begin
                    @`TCNT_AXI_PROTL_CB;
                    if(`TCNT_AXI_PROTL_CB.arvalid && `TCNT_AXI_PROTL_CB.arready)begin
                        tcnt_axi_xaction tr = tcnt_axi_xaction::type_id::create("tr");
                        tr.id = `TCNT_AXI_PROTL_CB.arid;
                        tr.burst_length = `TCNT_AXI_PROTL_CB.arlen + 1;
                        tr.data_status = tcnt_axi_dec::INITIAL;
                        xact_q.push_back(tr);
                    end

                    if(`TCNT_AXI_PROTL_CB.rvalid && `TCNT_AXI_PROTL_CB.rready)begin
                        int idx = -1;
                        foreach(xact_q[i])begin
                            if(xact_q[i].id === `TCNT_AXI_PROTL_CB.rid)begin
                                if(`TCNT_AXI_PROTL_CB.rlast)begin
                                    xact_q[i].data_status = tcnt_axi_dec::ACCEPT;
                                    idx = i;
                                end else begin
                                    xact_q[i].data_status = tcnt_axi_dec::PARTIAL_ACCEPT;
                                end
                            end else if(xact_q[i].data_status == tcnt_axi_dec::PARTIAL_ACCEPT)begin
                                slave_interleave_enabled = 1;
                                break;
                            end
                        end
                        if((idx != -1) && `TCNT_AXI_PROTL_CB.rlast)
                            xact_q.delete(idx);
                        // slave enable interleave but master doesn't support
                        if(slave_interleave_enabled && cfg.read_interleaving_disabled)
                            `uvm_error("READ_DATA_INTERLEAVE_CHECK",$sformatf("Monitor check that Active Master has received interleaved read data[rid:0x%0h], though that read_interleaving_disabled is set to 1",`TCNT_AXI_PROTL_CB.rid))
                    end
                end
            join_any
            disable fork;
            if(vif.aresetn === 1'b0)begin
                slave_interleave_enabled = 0;
                xact_q.delete();
                wait(vif.aresetn === 1'b1);
            end
        end
    end
endtask

/**
  * Monitor check that the order in which a slave receives the first data item of each transaction 
  * must be the same as the order in which it receives the addresses for the transactions for Write
  * Data Interleaving
  */
task tcnt_axi_protocol_checker::write_data_interleave_order_check();
// TODO
// for axi4 write interleaving - not supported
// for axi3 write interleaving - first data item order same as address order
endtask

task tcnt_axi_protocol_checker::write_data_interleave_depth_check();
// TODO
endtask

task tcnt_axi_protocol_checker::exclusive_read_write_addr_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_write_addr_aligned_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_awcache_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_awlen_awsize_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_read_addr_aligned_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_arcache_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_valid_exclusive_arlen_arsize_check();
// TODO
endtask

task tcnt_axi_protocol_checker::signal_stable_bresp_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(bresp,`TCNT_AXI_BRESP_WIDTH,bvalid,bready)
endtask

task tcnt_axi_protocol_checker::signal_stable_bid_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(bid,`TCNT_AXI_MAX_ID_WIDTH,bvalid,bready)
endtask

task tcnt_axi_protocol_checker::signal_valid_bready_when_bvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(bready,bvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_bresp_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(bresp,bvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_bid_when_bvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(bid,bvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_wlast_when_wvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(wlast,1,wvalid,wready)
endtask

task tcnt_axi_protocol_checker::signal_stable_wstrb_when_wvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(wstrb,`TCNT_AXI_WSTRB_WIDTH,wvalid,wready)
endtask

task tcnt_axi_protocol_checker::signal_stable_wdata_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(wdata,`TCNT_AXI_MAX_DATA_WIDTH,wvalid,wready)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_stable_wid_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3)
        `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(wid,`TCNT_AXI_MAX_ID_WIDTH,wvalid,wready)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_wready_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wready,wvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_wlast_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wlast,wvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_wstrb_when_wvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wstrb,wvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_wdata_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wdata,wvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_wid_when_wvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3)
        `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(wid,wvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_stable_awprot_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awprot,`TCNT_AXI_PROT_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awcache_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awcache,`TCNT_AXI_CACHE_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awlock_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awlock,`TCNT_AXI_LOCK_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awburst_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awburst,`TCNT_AXI_BURST_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awsize_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awsize,`TCNT_AXI_SIZE_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awlen_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awlen,`TCNT_AXI_MAX_BURST_LENGTH_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_stable_awaddr_when_awvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awaddr,`TCNT_AXI_MAX_ADDR_WIDTH,awvalid,awready)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_stable_awid_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(awid,`TCNT_AXI_MAX_ID_WIDTH,awvalid,awready)
endtask

task tcnt_axi_protocol_checker::signal_valid_awready_when_awvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awready,awvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_awprot_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awprot,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awcache_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awcache,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awlock_when_awvalid_high_check();
    while(1)begin                                                           
        @`TCNT_AXI_PROTL_CB;                                                
        if(cfg.signal_valid_checks_enable)begin                             
            if(`TCNT_AXI_PROTL_CB.awvalid === 1'b1)begin                   
                if(cfg.axi_interface_type == tcnt_axi_dec::AXI3)begin
                    if($isunknown(`TCNT_AXI_PROTL_CB.awlock))                      
                        `uvm_error("SIGNAL_VALID_AWLOCK_WHEN_AWVALID_HIGH_CHECK",{"Monitor check for X or Z on ", "awlock"," when ","awvalid"," is high"})
                end else begin
                    if($isunknown(`TCNT_AXI_PROTL_CB.awlock[0]))                      
                        `uvm_error("SIGNAL_VALID_AWLOCK_WHEN_AWVALID_HIGH_CHECK",{"Monitor check for X or Z on ", "awlock"," when ","awvalid"," is high"})                    
                end
            end                                                             
        end                                                                
    end     
endtask

task tcnt_axi_protocol_checker::signal_valid_awburst_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awburst,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awsize_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awsize,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awlen_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awlen,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_awaddr_when_awvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awaddr,awvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_awid_when_awvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(awid,awvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_rlast_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(rlast,1,rvalid,rready)
endtask

task tcnt_axi_protocol_checker::signal_stable_rresp_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(rresp,`TCNT_AXI_RESP_WIDTH,rvalid,rready)
endtask

task tcnt_axi_protocol_checker::signal_stable_rdata_when_rvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(rdata,`TCNT_AXI_MAX_DATA_WIDTH,rvalid,rready)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_stable_rid_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(rid,`TCNT_AXI_MAX_ID_WIDTH,rvalid,rready)
endtask

task tcnt_axi_protocol_checker::signal_valid_rready_when_rvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(rready,rvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_rlast_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(rlast,rvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_rresp_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(rresp,rvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_rdata_when_rvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(rdata,rvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_rid_when_rvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(rid,rvalid)
endtask

task tcnt_axi_protocol_checker::signal_stable_arprot_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arprot,`TCNT_AXI_PROT_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arcache_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arcache,`TCNT_AXI_CACHE_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arlock_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arlock,`TCNT_AXI_LOCK_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arburst_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arburst,`TCNT_AXI_BURST_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arsize_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arsize,`TCNT_AXI_SIZE_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_arlen_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arlen,`TCNT_AXI_MAX_BURST_LENGTH_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_stable_araddr_when_arvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(araddr,`TCNT_AXI_MAX_ADDR_WIDTH,arvalid,arready)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_stable_arid_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_STABLE_WHEN_TRIG_HIGH_CHECK(arid,`TCNT_AXI_MAX_ID_WIDTH,arvalid,arready)
endtask

task tcnt_axi_protocol_checker::signal_valid_arready_when_arvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arready,arvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_arprot_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arprot,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arcache_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arcache,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arlock_when_arvalid_high_check();
    while(1)begin                                                           
        @`TCNT_AXI_PROTL_CB;                                                
        if(cfg.signal_valid_checks_enable)begin                             
            if(`TCNT_AXI_PROTL_CB.arvalid === 1'b1)begin                   
                if(cfg.axi_interface_type == tcnt_axi_dec::AXI3)begin
                    if($isunknown(`TCNT_AXI_PROTL_CB.arlock))                      
                        `uvm_error("SIGNAL_VALID_ARLOCK_WHEN_ARVALID_HIGH_CHECK",{"Monitor check for X or Z on ", "arlock"," when ","arvalid"," is high"})
                end else begin
                    if($isunknown(`TCNT_AXI_PROTL_CB.arlock[0]))                      
                        `uvm_error("SIGNAL_VALID_ARLOCK_WHEN_ARVALID_HIGH_CHECK",{"Monitor check for X or Z on ", "arlock"," when ","arvalid"," is high"})                    
                end
            end                                                             
        end                                                                
    end     
endtask

task tcnt_axi_protocol_checker::signal_valid_arburst_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arburst,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arsize_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arsize,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_arlen_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arlen,arvalid)
endtask

task tcnt_axi_protocol_checker::signal_valid_araddr_when_arvalid_high_check();
`define NOT_USE_CFG_SIG_ENABLE
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(araddr,arvalid)
`undef NOT_USE_CFG_SIG_ENABLE
endtask

task tcnt_axi_protocol_checker::signal_valid_arid_when_arvalid_high_check();
    `TCNT_AXI_SIGNAL_VALID_WHTN_TRIG_HIGH_CHECK(arid,arvalid)
endtask

task tcnt_axi_protocol_checker::bresp_id_match_check();
    tcnt_axi_xaction aw_tr_q[$];
    tcnt_axi_xaction aw_tr;
    tcnt_axi_xaction b_tr;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]               bid;
    bit                 match_en ;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.awvalid == 1'b1 && `TCNT_AXI_PROTL_CB.awready == 1'b1) begin
                    aw_tr = tcnt_axi_xaction::type_id::create("aw_tr");
                    aw_tr.id = `TCNT_AXI_PROTL_CB.awid ;
                    aw_tr.addr = `TCNT_AXI_PROTL_CB.awaddr ;
                    aw_tr_q.push_back(aw_tr) ;
                end
                if(`TCNT_AXI_PROTL_CB.bvalid == 1'b1 && `TCNT_AXI_PROTL_CB.bready == 1'b1) begin
                    //b_tr = tcnt_axi_xaction::type_id::create("b_tr");
                    bid = `TCNT_AXI_PROTL_CB.bid ;
                    foreach(aw_tr_q[i]) begin
                        if(bid == aw_tr_q[i].id) begin
                            match_en = 1'b1 ;
                            aw_tr_q.delete(i) ;
                            break ;
                        end
                    end
                    if(match_en == 1'b1) begin
                        match_en = 1'b0 ;
                    end
                    else begin
                        if(aw_tr_q.size() == 0) begin
                            `uvm_error("BRESP_ID_MATCH_CHECK", $sformatf("there is a bid(0x%0h), but there is not awaid ", bid)) ;
                        end
                        else if(aw_tr_q.size() == 1) begin
                            `uvm_error("BRESP_ID_MATCH_CHECK", $sformatf("transaction(awaddr = 0x%0h, awid = 0x%0h) receive a non-match bid(0x%0h)", aw_tr_q[0].addr, aw_tr_q[0].id, bid)) ;
                        end
                        else begin
                            `uvm_error("BRESP_ID_MATCH_CHECK", $sformatf("transaction receive an error bid(0x%0h) that does not match all AWID", bid)) ;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            aw_tr_q.delete();
            aw_tr = null;
            b_tr = null;
            bid = 0;
            match_en = 0;
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

task tcnt_axi_protocol_checker::rresp_id_match_check();
    tcnt_axi_xaction ar_tr_q[$];
    tcnt_axi_xaction ar_tr;
    tcnt_axi_xaction r_tr;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]               rid;
    bit                 match_en ;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.arvalid == 1'b1 && `TCNT_AXI_PROTL_CB.arready == 1'b1) begin
                    ar_tr = tcnt_axi_xaction::type_id::create("ar_tr");
                    ar_tr.id = `TCNT_AXI_PROTL_CB.arid ;
                    ar_tr.addr = `TCNT_AXI_PROTL_CB.araddr ;
                    ar_tr_q.push_back(ar_tr) ;
                end
                if(`TCNT_AXI_PROTL_CB.rvalid == 1'b1 && `TCNT_AXI_PROTL_CB.rready == 1'b1 && `TCNT_AXI_PROTL_CB.rlast == 1'b1) begin
                    rid = `TCNT_AXI_PROTL_CB.rid ;
                    foreach(ar_tr_q[i]) begin
                        if(rid == ar_tr_q[i].id) begin
                            match_en = 1'b1 ;
                            ar_tr_q.delete(i) ;
                            break ;
                        end
                    end
                    if(match_en == 1'b1) begin
                        match_en = 1'b0 ;
                    end
                    else begin
                        if(ar_tr_q.size() == 0) begin
                            `uvm_error("RRESP_ID_MATCH_CHECK", $sformatf("there is a  rid(0x%0h), but there is not araid ", rid)) ;
                        end
                        else if(ar_tr_q.size() == 1) begin
                            `uvm_error("RRESP_ID_MATCH_CHECK", $sformatf("transaction(araddr = 0x%0h, arid = 0x%0h) receive a non-match rid(0x%0h)", ar_tr_q[0].addr, ar_tr_q[0].id, rid)) ;
                        end
                        else begin
                            `uvm_error("RRESP_ID_MATCH_CHECK", $sformatf("transaction receive a error rid(0x%0h) that does not match all ARID", rid)) ;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            ar_tr_q.delete();
            ar_tr = null;
            r_tr = null;
            rid = 0;
            match_en = 0;
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

task tcnt_axi_protocol_checker::signal_bvalid_after_wvalid_check();
    int     awvalid_cnt ;
    int     last_wvalid_cnt ;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]               bid;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(cfg.axi_interface_type != tcnt_axi_dec::AXI3) begin
                    if(`TCNT_AXI_PROTL_CB.awready == 1'b1 && `TCNT_AXI_PROTL_CB.awvalid == 1'b1) begin
                        awvalid_cnt ++ ;
                    end
                end
                if(`TCNT_AXI_PROTL_CB.wready == 1'b1 && `TCNT_AXI_PROTL_CB.wvalid == 1'b1 && `TCNT_AXI_PROTL_CB.wlast == 1'b1) begin
                    last_wvalid_cnt ++ ;
                end
                if(`TCNT_AXI_PROTL_CB.bready == 1'b1 && `TCNT_AXI_PROTL_CB.bvalid == 1'b1) begin
                    bid = `TCNT_AXI_PROTL_CB.bid ;
                    //a write resp must always follow the last write transfer in the write transaction
                    if(cfg.axi_interface_type != tcnt_axi_dec::AXI3) begin
                        if(last_wvalid_cnt != 0 && awvalid_cnt != 0) begin
                            awvalid_cnt -- ;
                            last_wvalid_cnt -- ;
                        end
                        else begin
                            `uvm_error("SIGNAL_BVALID_AFTER_WVALID_CHECK", $sformatf("a write resp(bid:0x%0h) channel is generated before the write data channel", bid)) ;
                        end
                    end
                    else begin
                        if(last_wvalid_cnt != 0) begin
                            last_wvalid_cnt -- ;
                        end
                        //a write resp is generated before the write transfer
                        else begin
                            `uvm_error("SIGNAL_BVALID_AFTER_WVALID_CHECK", $sformatf("a write resp(bid:0x%0h) channel is generated before the write data channel", bid)) ;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            awvalid_cnt = 0;
            last_wvalid_cnt = 0;
            bid = 0;
            wait(vif.aresetn === 1'b1);
        end        
    end

endtask

task tcnt_axi_protocol_checker::signal_rvalid_after_arvalid_check();
    int                                         arvalid_cnt ;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]            rid;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]            rid_q[$];
    bit                                         rid_first_beat = 1 ;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.arready == 1'b1 && `TCNT_AXI_PROTL_CB.arvalid == 1'b1) begin
                    arvalid_cnt ++ ;
                end
                if(`TCNT_AXI_PROTL_CB.rready == 1'b1 && `TCNT_AXI_PROTL_CB.rvalid == 1'b1) begin
                    foreach(rid_q[i]) begin
                        if(`TCNT_AXI_PROTL_CB.rid == rid_q[i]) begin
                            rid_first_beat = 1'b0 ;
                            break ;
                        end
                    end
                    if(rid_first_beat == 1'b1) begin
                        rid = `TCNT_AXI_PROTL_CB.rid ;
                        rid_q.push_back(rid) ;
                        //a read data must always follow the address to which data relates
                        if(arvalid_cnt != 0) begin
                            arvalid_cnt -- ;
                        end
                        //a read data channel is generated before the address to which data relates
                        else begin
                            `uvm_fatal("SIGNAL_RVALID_AFTER_ARVALID_CHECK", $sformatf("a read resp(rid:0x%0h) channel is generated before the read address channel", rid)) ;
                        end
                    end
                    if(`TCNT_AXI_PROTL_CB.rlast == 1'b1) begin
                        foreach(rid_q[i]) begin
                            if(`TCNT_AXI_PROTL_CB.rid == rid_q[i]) begin
                                rid_q.delete(i) ;
                                break ;
                            end
                        end
                    end
                    rid_first_beat = 1'b1 ;
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            arvalid_cnt = 0;
            rid = 0;
            rid_q.delete();
            rid_first_beat = 1;
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

task tcnt_axi_protocol_checker::signal_timeout_awready_when_awvalid_high_check();

    `TCNT_AXI_SIGNAL_TIMEOUT_CHECK(cfg.awready_watchdog_timeout, `TCNT_AXI_PROTL_CB.awvalid, `TCNT_AXI_PROTL_CB.awready)

endtask

task tcnt_axi_protocol_checker::signal_timeout_wready_when_wvalid_high_check();

    `TCNT_AXI_SIGNAL_TIMEOUT_CHECK(cfg.wready_watchdog_timeout, `TCNT_AXI_PROTL_CB.wvalid, `TCNT_AXI_PROTL_CB.wready)

endtask

task tcnt_axi_protocol_checker::signal_timeout_bready_when_bvalid_high_check();

    `TCNT_AXI_SIGNAL_TIMEOUT_CHECK(cfg.bready_watchdog_timeout, `TCNT_AXI_PROTL_CB.bvalid, `TCNT_AXI_PROTL_CB.bready)

endtask

task tcnt_axi_protocol_checker::signal_timeout_arready_when_arvalid_high_check();

    `TCNT_AXI_SIGNAL_TIMEOUT_CHECK(cfg.arready_watchdog_timeout, `TCNT_AXI_PROTL_CB.arvalid, `TCNT_AXI_PROTL_CB.arready)

endtask

task tcnt_axi_protocol_checker::signal_timeout_rready_when_rvalid_high_check();

    `TCNT_AXI_SIGNAL_TIMEOUT_CHECK(cfg.rready_watchdog_timeout, `TCNT_AXI_PROTL_CB.rvalid, `TCNT_AXI_PROTL_CB.rready)

endtask

/* wdata_watchdog_timeout
 * When write address handshake happens (data after address scenario), this watchdog 
 * timer monitors assertion of WVALID signal. When WVALID is low, the timer starts. 
 * The timer is incremented by 1 every clock and is reset when WVALID is asserted. If
 * the number of clock cycles exceeds this value, an error is reported. If this value 
 * is set to 0 the timer is not started.  
*/
task tcnt_axi_protocol_checker::signal_timeout_awaddr_when_first_wdata_handshake_check();
    tcnt_axi_xaction wxact_q[$];
    int data_before_addr_cnt = 0;
    longint cycle_cnt = 0;
    bit first_wbeat = 1;
    while(cfg.wdata_watchdog_timeout != 0)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                cycle_cnt++;
                if(`TCNT_AXI_PROTL_CB.awready && `TCNT_AXI_PROTL_CB.awvalid)begin
                    tcnt_axi_xaction wtr;
                    wtr = tcnt_axi_xaction::type_id::create("wtr");
                    wtr.id = `TCNT_AXI_PROTL_CB.awid;
                    wtr.addr = `TCNT_AXI_PROTL_CB.awaddr;
                    wtr.start_time = realtime'(cycle_cnt);
                    wxact_q.push_back(wtr);
                    // discard transactions before addr, since no need to check
                    if(data_before_addr_cnt > 0)begin
                        data_before_addr_cnt--;
                        void'(wxact_q.pop_front());
                    end
                end

                if(`TCNT_AXI_PROTL_CB.wvalid && first_wbeat)begin
                    if(wxact_q.size() > 0)begin
                        tcnt_axi_xaction tr;
                        tr = wxact_q.pop_front();
                        if(cycle_cnt - longint'(tr.start_time) > cfg.wdata_watchdog_timeout)begin
                            `uvm_error("SIGNAL_TIMEOUT_AWADDR_WHEN_FIRST_WDATA_HANDSHAKE_CHECK",$sformatf("awaddr[0x%0h], id[0x%0h] waiting for wdata timeout. cfg.wdata_watchdog_timeout[%0d]",
                                                                       tr.addr,tr.id,cfg.wdata_watchdog_timeout))
                        end
                    end else if(`TCNT_AXI_PROTL_CB.wready)begin
                        data_before_addr_cnt++;
                    end
                    if(`TCNT_AXI_PROTL_CB.wready && `TCNT_AXI_PROTL_CB.wlast)begin
                        first_wbeat = 1;
                    end else begin
                        first_wbeat = 0;
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            wxact_q.delete();
            data_before_addr_cnt = 0;
            cycle_cnt = 0;
            first_wbeat = 1;
            wait(vif.aresetn === 1'b1);
        end        
    end
endtask

/* awaddr_watchdog_timeout
 * When first write data handshake happens (data before address scenario), this watchdog
 * timer monitors assertion of AWVALID signal. When AWVALID is low, the timer starts. The
 * timer is incremented by 1 every clock and is reset when AWVALID is asserted. If the 
 * number of clock cycles exceeds this value, an error is reported. If this value is set 
 * to 0 the timer is not started.  
 */
task tcnt_axi_protocol_checker::signal_timeout_wdata_when_awaddr_handshake_check();
    longint wbeat_cycle_cnt_q[$];
    longint cycle_cnt = 0;
    int addr_before_data_cnt = 0;
    bit first_wbeat = 1;
    while(cfg.awaddr_watchdog_timeout != 0)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                @`TCNT_AXI_PROTL_CB;
                cycle_cnt++;
                if(`TCNT_AXI_PROTL_CB.awvalid)begin
                    if(wbeat_cycle_cnt_q.size() > 0)begin
                        longint cnt_tmp = wbeat_cycle_cnt_q.pop_front(); 
                        if(cycle_cnt - cnt_tmp > cfg.awaddr_watchdog_timeout)
                            `uvm_error("SIGNAL_TIMEOUT_WDATA_WHEN_AWADDR_HANDSHAKE_CHECK",$sformatf("wdata waiting for awaddr timeout. cfg.awaddr_watchdog_timeout[%0d]",cfg.awaddr_watchdog_timeout))
                    end else if(`TCNT_AXI_PROTL_CB.awready)
                        addr_before_data_cnt++;
                end

                if(`TCNT_AXI_PROTL_CB.wready && `TCNT_AXI_PROTL_CB.wvalid && first_wbeat)begin
                    wbeat_cycle_cnt_q.push_back(cycle_cnt);
                    if(`TCNT_AXI_PROTL_CB.wlast)begin
                        first_wbeat = 1;
                    end else begin
                        first_wbeat = 0;
                    end            
                    if(addr_before_data_cnt > 0)begin
                        void'(wbeat_cycle_cnt_q.pop_front());
                        addr_before_data_cnt--;
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            wbeat_cycle_cnt_q.delete();
            cycle_cnt = 0;
            addr_before_data_cnt = 0;
            first_wbeat = 1;
            wait(vif.aresetn === 1'b1);
        end
    end
endtask

task tcnt_axi_protocol_checker::signal_timeout_bresp_when_last_wdata_handshake_check();

    bit     wdata_handshake_en ;
    int     cycle_cnt ;
    bit [`TCNT_AXI_MAX_DATA_WIDTH-1:0]             wdata;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.wready == 1'b1 && `TCNT_AXI_PROTL_CB.wvalid == 1'b1 && `TCNT_AXI_PROTL_CB.wlast == 1'b1) begin
                    wdata_handshake_en = 1'b1 ;
                    wdata = `TCNT_AXI_PROTL_CB.wdata ;
                end
                if(wdata_handshake_en == 1) begin
                    if(`TCNT_AXI_PROTL_CB.bvalid == 1'b0) begin
                        cycle_cnt ++ ;
                    end
                    else if(`TCNT_AXI_PROTL_CB.bvalid == 1'b1) begin
                        cycle_cnt = 0 ;
                        if(`TCNT_AXI_PROTL_CB.bready == 1'b1) begin
                            wdata_handshake_en = 1'b0 ;
                        end
                    end
                    if(cycle_cnt > cfg.bresp_watchdog_timeout) begin
                        `uvm_error("SIGNAL_TIMEOUT_BRESP_WHEN_LAST_WDATA_HANDSHAKE_CHECK", $sformatf("after last wdata(0x%0h) handshake, cycles waiting for bresp exceed max timeout cycle[%0d]", wdata, cfg.bresp_watchdog_timeout)) ;
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            wdata_handshake_en = 0;
            cycle_cnt = 0;
            wdata = 0;
            wait(vif.aresetn === 1'b1);
        end
    end

endtask

task tcnt_axi_protocol_checker::signal_timeout_rdata_when_araddr_handshake_check();

    bit     araddr_handshake_en ;
    int     cycle_cnt ;
    tcnt_axi_xaction tr ;

    while(1) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.arready == 1'b1 && `TCNT_AXI_PROTL_CB.arvalid == 1'b1) begin
                    araddr_handshake_en = 1'b1 ;
                    tr = tcnt_axi_xaction::type_id::create("tr");
                    tr.addr = `TCNT_AXI_PROTL_CB.araddr ;
                end
                if(araddr_handshake_en == 1) begin
                    if(`TCNT_AXI_PROTL_CB.rvalid == 1'b0) begin
                        cycle_cnt ++ ;
                    end
                    else if(`TCNT_AXI_PROTL_CB.rvalid == 1'b1) begin
                        cycle_cnt = 0 ;
                        if(`TCNT_AXI_PROTL_CB.rready == 1'b1) begin
                            araddr_handshake_en = 1'b0 ;
                        end
                    end
                    if(cycle_cnt > cfg.rdata_watchdog_timeout) begin
                        `uvm_error("SIGNAL_TIMEOUT_RDATA_WHEN_ARADDR_HANDSHAKE_CHECK", $sformatf("after araddr(0x%0h) handshake, cycles waiting for rvalid exceed max timeout cycle[%0d]", tr.addr, cfg.rdata_watchdog_timeout)) ;
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            araddr_handshake_en = 0;
            cycle_cnt = 0;
            tr = null;            
            wait(vif.aresetn === 1'b1);
        end                
    end

endtask

task tcnt_axi_protocol_checker::write_xact_timeout_check();
    
    tcnt_axi_xaction        tr_q[$] ;
    tcnt_axi_xaction        tr      ;
    int                     xact_cycle_cnt[$] ;
    int                     cycle_cnt ;

    while(cfg.xact_watchdog_timeout > 0) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.awready == 1'b1 && `TCNT_AXI_PROTL_CB.awvalid == 1'b1) begin
                    tr = tcnt_axi_xaction::type_id::create("tr");
                    tr.id = `TCNT_AXI_PROTL_CB.awid ;
                    tr.addr = `TCNT_AXI_PROTL_CB.awaddr ;
                    tr_q.push_back(tr) ;
                    //--------------------------------------------------------------------------------
                    //pushing cycle_cnt into xact_cycle_cnt means:
                    //1):make the size of xact_cycle_cnt the same as the size of tr_q
                    //2):intial every couter to 0 in xact_cycle_cnt
                    //--------------------------------------------------------------------------------
                    cycle_cnt = 0 ;
                    xact_cycle_cnt.push_back(cycle_cnt) ;  
                end
                if(`TCNT_AXI_PROTL_CB.bready == 1'b1 && `TCNT_AXI_PROTL_CB.bvalid == 1'b1) begin
                    foreach(tr_q[i]) begin
                        if(tr_q[i].id == `TCNT_AXI_PROTL_CB.bid) begin
                            tr_q.delete(i) ;
                            xact_cycle_cnt.delete(i) ;
                            break ;
                        end
                    end
                end
                if(tr_q.size() != 0) begin
                    foreach(tr_q[i]) begin
                        xact_cycle_cnt[i] ++ ;
                        if(xact_cycle_cnt[i] > cfg.xact_watchdog_timeout) begin
                            `uvm_error("WRITE_XACT_TIMEOUT_CHECK", $sformatf("the write transaction(awaddr = 0x%0h, awid = 0x%0h) does not complete by the set time[%0d], an error is repoted.",
                                                                   tr_q[i].addr, tr_q[i].id, cfg.xact_watchdog_timeout)) ;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            tr_q.delete();
            tr = null;
            xact_cycle_cnt.delete();
            cycle_cnt = 0;
            wait(vif.aresetn === 1'b1);
        end                
    end

endtask

task tcnt_axi_protocol_checker::read_xact_timeout_check();
    
    tcnt_axi_xaction        tr_q[$] ;
    tcnt_axi_xaction        tr      ;
    int                     xact_cycle_cnt[$] ;
    int                     cycle_cnt ;

    while(cfg.xact_watchdog_timeout > 0) begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                @`TCNT_AXI_PROTL_CB;
                if(`TCNT_AXI_PROTL_CB.arready == 1'b1 && `TCNT_AXI_PROTL_CB.arvalid == 1'b1) begin
                    tr = tcnt_axi_xaction::type_id::create("tr");
                    tr.id = `TCNT_AXI_PROTL_CB.arid ;
                    tr.addr = `TCNT_AXI_PROTL_CB.araddr ;
                    tr_q.push_back(tr) ;
                    //--------------------------------------------------------------------------------
                    //pushing cycle_cnt into xact_cycle_cnt means:
                    //1):make the size of xact_cycle_cnt the same as the size of tr_q
                    //2):intial every couter to 0 in xact_cycle_cnt
                    //--------------------------------------------------------------------------------
                    cycle_cnt = 0 ;
                    xact_cycle_cnt.push_back(cycle_cnt) ; 
                end
                if(`TCNT_AXI_PROTL_CB.rready == 1'b1 && `TCNT_AXI_PROTL_CB.rvalid == 1'b1) begin
                    foreach(tr_q[i]) begin
                        if(tr_q[i].id == `TCNT_AXI_PROTL_CB.rid) begin
                            tr_q.delete(i) ;
                            xact_cycle_cnt.delete(i) ;
                            break ;
                        end
                    end
                end
                if(tr_q.size() != 0) begin
                    foreach(tr_q[i]) begin
                        xact_cycle_cnt[i] ++ ;
                        if(xact_cycle_cnt[i] > cfg.xact_watchdog_timeout) begin
                            `uvm_error("READ_XACT_TIMEOUT_CHECK", $sformatf("the read transaction(araddr = 0x%0h, arid = 0x%0h) does not complete by the set time[%0d], an error is repoted.",
                                                                    tr_q[i].addr, tr_q[i].id, cfg.xact_watchdog_timeout)) ;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            tr_q.delete();
            tr = null;
            xact_cycle_cnt.delete();
            cycle_cnt = 0;
            wait(vif.aresetn === 1'b1);
        end
    end

endtask

task tcnt_axi_protocol_checker::awaddr_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.awaddr,`TCNT_AXI_PROTL_CB.awvalid,cfg.addr_width,1)
endtask

task tcnt_axi_protocol_checker::araddr_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.araddr,`TCNT_AXI_PROTL_CB.arvalid,cfg.addr_width,1)
endtask

task tcnt_axi_protocol_checker::wdata_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.wdata,`TCNT_AXI_PROTL_CB.wvalid,cfg.data_width,1)
endtask

task tcnt_axi_protocol_checker::rdata_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.rdata,`TCNT_AXI_PROTL_CB.rvalid,cfg.data_width,1)
endtask

task tcnt_axi_protocol_checker::wstrb_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.wstrb,`TCNT_AXI_PROTL_CB.wvalid,cfg.data_width/8,cfg.wstrb_enable)
endtask

task tcnt_axi_protocol_checker::awuser_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.awuser,`TCNT_AXI_PROTL_CB.awvalid,cfg.addr_user_width,cfg.awuser_enable)
endtask

task tcnt_axi_protocol_checker::aruser_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.aruser,`TCNT_AXI_PROTL_CB.arvalid,cfg.addr_user_width,cfg.aruser_enable)
endtask

task tcnt_axi_protocol_checker::wuser_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.wuser,`TCNT_AXI_PROTL_CB.wvalid,cfg.data_user_width,cfg.wuser_enable)
endtask

task tcnt_axi_protocol_checker::ruser_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.ruser,`TCNT_AXI_PROTL_CB.rvalid,cfg.data_user_width,cfg.ruser_enable)
endtask

task tcnt_axi_protocol_checker::buser_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.buser,`TCNT_AXI_PROTL_CB.bvalid,cfg.resp_user_width,cfg.buser_enable)
endtask

task tcnt_axi_protocol_checker::awid_inactive_bit_check();        
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.awid,`TCNT_AXI_PROTL_CB.awvalid,cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width : cfg.id_width,cfg.awid_enable)
endtask

task tcnt_axi_protocol_checker::wid_inactive_bit_check();        
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.wid,`TCNT_AXI_PROTL_CB.wvalid,
                                        cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width : cfg.id_width,cfg.axi_interface_type == tcnt_axi_dec::AXI3)
endtask

task tcnt_axi_protocol_checker::bid_inactive_bit_check();        
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.bid,`TCNT_AXI_PROTL_CB.bvalid,cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width : cfg.id_width,cfg.bid_enable)
endtask

task tcnt_axi_protocol_checker::arid_inactive_bit_check();        
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.arid,`TCNT_AXI_PROTL_CB.arvalid,cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width : cfg.id_width,cfg.arid_enable)
endtask

task tcnt_axi_protocol_checker::rid_inactive_bit_check();
    `TCNT_AXI_INACTIVE_BIT_VALID_CHECK(`TCNT_AXI_PROTL_CB.rid,`TCNT_AXI_PROTL_CB.rvalid,cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width : cfg.id_width,cfg.rid_enable)
endtask

task tcnt_axi_protocol_checker::run_protocol_check();
    fork
        // AXI4
        signal_stable_wuser_when_wvalid_high_check();
        signal_valid_wuser_when_wvalid_high_check();
        signal_stable_awuser_when_awvalid_high_check();
        signal_stable_awregion_when_awvalid_high_check();
        signal_stable_awqos_when_awvalid_high_check();
        signal_stable_buser_when_bvalid_high_check();
        signal_valid_buser_when_bvalid_high_check();
        signal_valid_awuser_when_awvalid_high_check();
        signal_valid_awregion_when_awvalid_high_check();
        signal_valid_awqos_when_awvalid_high_check();
        signal_stable_ruser_when_rvalid_high_check();
        signal_valid_ruser_when_rvalid_high_check();
        signal_stable_aruser_when_arvalid_high_check();
        signal_stable_arregion_when_arvalid_high_check();
        signal_stable_arqos_when_arvalid_high_check();
        signal_valid_aruser_when_arvalid_high_check();
        signal_valid_arregion_when_arvalid_high_check();
        signal_valid_arqos_when_arvalid_high_check();
        max_num_outstanding_xacts_check();
        excl_access_on_write_only_interface_check();
        excl_access_on_read_only_interface_check();
        write_xact_on_write_only_interface_check();
        read_xact_on_read_only_interface_check();        
        // AXI3
        write_byte_count_match_across_interconnect();
        eos_unmapped_master_xact();
        eos_unmapped_non_modifiable_xact();
        device_non_bufferable_response_match_check();
        ordering_for_non_modifiable_xact_check();
        cache_type_match_for_non_modifiable_xact_check();
        burst_size_match_for_non_modifiable_xact_check();
        burst_type_match_for_non_modifiable_xact_check();
        burst_length_match_for_non_modifiable_xact_check();
        region_match_for_non_modifiable_xact_check();
        prot_type_match_for_non_modifiable_xact_check();
        atomic_type_match_for_non_modifiable_xact_check();
        master_slave_xact_data_integrity_check();
        data_integrity_check();
        slave_transaction_routing_check();
        awburst_awlen_valid_value_check();
        locked_sequence_to_same_slave_check();
        locked_sequence_length_check();
        no_pending_locked_xacts_before_normal_xacts_check();
        locked_sequeunce_id_check();
        no_pending_xacts_during_locked_xact_sequeunce_check();
        rlast_asserted_for_last_read_data_beat();
        wlast_asserted_for_last_write_data_beat();
        write_resp_follows_last_write_xfer_check();
        read_data_follows_addr_check();
        write_resp_after_write_addr_check();
        write_resp_after_last_wdata_check();
        wdata_awlen_match_for_corresponding_awaddr_check();
        arvalid_arcache_active_check();
        arburst_reserved_val_check();
        arsize_data_width_active_check();
        arlen_wrap_active_check();
        araddr_wrap_aligned_active_check();
        araddr_4k_boundary_cross_active_check();
        awvalid_awcache_active_check();
        awburst_reserved_val_check();
        awsize_data_width_active_check();
        valid_write_strobe_check();
        awlen_wrap_active_check();
        awaddr_wrap_aligned_active_check();
        awaddr_4k_boundary_cross_active_check();
        bvalid_low_when_reset_is_active_check();
        wvalid_low_when_reset_is_active_check();
        awvalid_low_when_reset_is_active_check();
        rvalid_low_when_reset_is_active_check();
        arvalid_low_when_reset_is_active_check();
        bvalid_interrupted_check();
        wvalid_interrupted_check();
        awvalid_interrupted_check();
        rvalid_interrupted_check();
        arvalid_interrupted_check();
        signal_valid_bvalid_check();
        signal_valid_wvalid_check();
        signal_valid_awvalid_check();
        signal_valid_rvalid_check();
        signal_valid_arvalid_check();
        exclusive_read_write_prot_type_check();
        exclusive_read_write_cache_type_check();
        exclusive_read_write_burst_type_check();
        exclusive_read_write_burst_size_check();
        exclusive_read_write_burst_length_check();
        read_data_interleave_check();
        write_data_interleave_order_check();
        write_data_interleave_depth_check();
        exclusive_read_write_addr_check();
        signal_valid_exclusive_write_addr_aligned_check();
        signal_valid_exclusive_awcache_check();
        signal_valid_exclusive_awlen_awsize_check();
        signal_valid_exclusive_read_addr_aligned_check();
        signal_valid_exclusive_arcache_check();
        signal_valid_exclusive_arlen_arsize_check();
        signal_stable_bresp_when_bvalid_high_check();
        signal_stable_bid_when_bvalid_high_check();
        signal_valid_bready_when_bvalid_high_check();
        signal_valid_bresp_when_bvalid_high_check();
        signal_valid_bid_when_bvalid_high_check();
        signal_stable_wlast_when_wvalid_high_check();
        signal_stable_wstrb_when_wvalid_high_check();
        signal_stable_wdata_when_wvalid_high_check();
        signal_stable_wid_when_wvalid_high_check();
        signal_valid_wready_when_wvalid_high_check();
        signal_valid_wlast_when_wvalid_high_check();
        signal_valid_wstrb_when_wvalid_high_check();
        signal_valid_wdata_when_wvalid_high_check();
        signal_valid_wid_when_wvalid_high_check();
        signal_stable_awprot_when_awvalid_high_check();
        signal_stable_awcache_when_awvalid_high_check();
        signal_stable_awlock_when_awvalid_high_check();
        signal_stable_awburst_when_awvalid_high_check();
        signal_stable_awsize_when_awvalid_high_check();
        signal_stable_awlen_when_awvalid_high_check();
        signal_stable_awaddr_when_awvalid_high_check();
        signal_stable_awid_when_awvalid_high_check();
        signal_valid_awready_when_awvalid_high_check();
        signal_valid_awprot_when_awvalid_high_check();
        signal_valid_awcache_when_awvalid_high_check();
        signal_valid_awlock_when_awvalid_high_check();
        signal_valid_awburst_when_awvalid_high_check();
        signal_valid_awsize_when_awvalid_high_check();
        signal_valid_awlen_when_awvalid_high_check();
        signal_valid_awaddr_when_awvalid_high_check();
        signal_valid_awid_when_awvalid_high_check();
        signal_stable_rlast_when_rvalid_high_check();
        signal_stable_rresp_when_rvalid_high_check();
        signal_stable_rdata_when_rvalid_high_check();
        signal_stable_rid_when_rvalid_high_check();
        signal_valid_rready_when_rvalid_high_check();
        signal_valid_rlast_when_rvalid_high_check();
        signal_valid_rresp_when_rvalid_high_check();
        signal_valid_rdata_when_rvalid_high_check();
        signal_valid_rid_when_rvalid_high_check();
        signal_stable_arprot_when_arvalid_high_check();
        signal_stable_arcache_when_arvalid_high_check();
        signal_stable_arlock_when_arvalid_high_check();
        signal_stable_arburst_when_arvalid_high_check();
        signal_stable_arsize_when_arvalid_high_check();
        signal_stable_arlen_when_arvalid_high_check();
        signal_stable_araddr_when_arvalid_high_check();
        signal_stable_arid_when_arvalid_high_check();
        signal_valid_arready_when_arvalid_high_check();
        signal_valid_arprot_when_arvalid_high_check();
        signal_valid_arcache_when_arvalid_high_check();
        signal_valid_arlock_when_arvalid_high_check();
        signal_valid_arburst_when_arvalid_high_check();
        signal_valid_arsize_when_arvalid_high_check();
        signal_valid_arlen_when_arvalid_high_check();
        signal_valid_araddr_when_arvalid_high_check();
        signal_valid_arid_when_arvalid_high_check();
        bresp_id_match_check();
        rresp_id_match_check();
        signal_bvalid_after_wvalid_check();
        signal_rvalid_after_arvalid_check();
        signal_timeout_awready_when_awvalid_high_check();
        signal_timeout_wready_when_wvalid_high_check();
        signal_timeout_bready_when_bvalid_high_check();
        signal_timeout_arready_when_arvalid_high_check();
        signal_timeout_rready_when_rvalid_high_check();
        signal_timeout_awaddr_when_first_wdata_handshake_check();
        signal_timeout_wdata_when_awaddr_handshake_check();
        signal_timeout_bresp_when_last_wdata_handshake_check();
        signal_timeout_rdata_when_araddr_handshake_check();
        write_xact_timeout_check();
        read_xact_timeout_check();
        awaddr_inactive_bit_check();
        araddr_inactive_bit_check();
        wdata_inactive_bit_check();
        rdata_inactive_bit_check();
        wstrb_inactive_bit_check();
        awuser_inactive_bit_check();
        aruser_inactive_bit_check();
        wuser_inactive_bit_check();
        ruser_inactive_bit_check();
        buser_inactive_bit_check();        
        awid_inactive_bit_check();        
        wid_inactive_bit_check();        
        bid_inactive_bit_check();        
        arid_inactive_bit_check();        
        rid_inactive_bit_check();        
    join
endtask

task tcnt_axi_protocol_checker::run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(cfg.protocol_checks_enable)
        run_protocol_check();
endtask
`endif
