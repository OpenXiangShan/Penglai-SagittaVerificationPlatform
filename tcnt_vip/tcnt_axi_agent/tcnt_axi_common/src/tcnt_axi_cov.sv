`ifndef TCNT_AXI_COV_SV
`define TCNT_AXI_COV_SV

//class tcnt_axi_cov extends uvm_component;
class tcnt_axi_cov;
    
    //uvm_analysis_imp#(tcnt_axi_xaction,tcnt_axi_cov)  get_item_port;
    tcnt_axi_cfg                cfg;
    string                      tname;

    //virtual function void write(tcnt_axi_xaction tr);
    //    run_cov_sampling(tr); 
    //endfunction
    
    function void run_cov_sampling(tcnt_axi_xaction tr);
        if(cfg.state_coverage_enable)
            run_state_cov_sampling(tr);
        if(cfg.toggle_coverage_enable)
            run_toggle_cov_sampling(tr);
        if(cfg.transaction_coverage_enable)
            run_trans_cov_sampling(tr);
    endfunction
    
    function void run_state_cov_sampling(tcnt_axi_xaction tr);
		signal_state_araddr.sample(tr);
		signal_state_arburst.sample(tr);
		signal_state_arcache.sample(tr);
		signal_state_arcache_axi4.sample(tr);
		signal_state_arid.sample(tr);
		signal_state_arlen.sample(tr);
		signal_state_arlock_axi4_exclusive.sample(tr);
		signal_state_arlock_axi4_no_exclusive.sample(tr);
		signal_state_arlock_exclusive.sample(tr);
		signal_state_arlock_no_exclusive.sample(tr);
		signal_state_arprot.sample(tr);
		signal_state_arqos.sample(tr);
		signal_state_arregion.sample(tr);
		signal_state_arsize.sample(tr);
		signal_state_aruser.sample(tr);
		signal_state_awburst.sample(tr);
		signal_state_awcache.sample(tr);
		signal_state_awcache_axi4.sample(tr);
		signal_state_awid.sample(tr);
		signal_state_awlock_axi4_exclusive.sample(tr);
		signal_state_awlock_axi4_no_exclusive.sample(tr);
		signal_state_awlock_exclusive.sample(tr);
		signal_state_awlock_no_exclusive.sample(tr);
		signal_state_awprot.sample(tr);
		signal_state_awqos.sample(tr);
		signal_state_awsize.sample(tr);
		signal_state_awuser.sample(tr);
		signal_state_bid.sample(tr);
		signal_state_bresp.sample(tr);
		signal_state_bresp_ex_access.sample(tr);
		signal_state_buser.sample(tr);
        foreach(tr.data[i])
		    signal_state_rdata.sample(tr,i);
		signal_state_rid.sample(tr);
        foreach(tr.rresp[i])
		    signal_state_rresp.sample(tr,i);
        foreach(tr.rresp[i])
		    signal_state_rresp_ex_access.sample(tr,i);
        foreach(tr.data_user[i])
		    signal_state_ruser.sample(tr,i);
        foreach(tr.data[i])
		    signal_state_wdata.sample(tr,i);
		signal_state_wid.sample(tr);
        foreach(tr.wstrb[i])
            signal_state_wstrb.sample(tr,i);
        foreach(tr.data_user[i])
            signal_state_wuser.sample(tr,i);
    endfunction

    function void run_toggle_cov_sampling(tcnt_axi_xaction tr);

    endfunction

    function void run_trans_cov_sampling(tcnt_axi_xaction tr);
		trans_cross_axi_arburst_arlen_araddr_arsize_ace.sample(tr);
		trans_cross_axi_arburst_arlen_araddr_arsize_axi3.sample(tr);
        trans_cross_axi_arburst_arlen_araddr_arsize_axi4.sample(tr);
		trans_cross_axi_arburst_arlen_araddr_arsize_axi4_lite.sample(tr);
		trans_cross_axi_arburst_arlen_arcache_ace.sample(tr);
		trans_cross_axi_arburst_arlen_arcache_axi4.sample(tr);
		trans_cross_axi_arburst_arlen_arcache_axi4_lite.sample(tr);
		trans_cross_axi_arburst_arlen_arprot_axi3.sample(tr);
		trans_cross_axi_arburst_arlen_arprot_axi4.sample(tr);
		trans_cross_axi_arburst_arlen_arprot_axi4_lite.sample(tr);
		trans_cross_axi_arburst_arlen_arsize_axi3.sample(tr);
		trans_cross_axi_arburst_arlen_arsize_axi4.sample(tr);
		trans_cross_axi_arburst_arlen_arsize_axi4_lite.sample(tr);
		trans_cross_axi_arburst_arlen_ace.sample(tr);
        trans_cross_axi_arburst_arlen_axi3.sample(tr); 
        trans_cross_axi_arburst_arlen_axi4.sample(tr); 
		trans_cross_axi_arburst_arlen_axi4_lite.sample(tr);
		trans_cross_axi_arburst_arqos_ace.sample(tr);
		trans_cross_axi_arburst_arqos_axi4.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_ace_araddr_ace.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_exclusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_all.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_no_exclusive.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_exclusive_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_exclusive_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_locked_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_rresp_all.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_araddr_axi3_axi4.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_exlusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_all.sample(tr);
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_no_exclusive.sample(tr);
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_araddr_axi3_axi4.sample(tr);
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_exclusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_all.sample(tr);
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_no_exclusive.sample(tr);
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_ace.sample(tr);
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi3.sample(tr);
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi4.sample(tr);
		trans_cross_axi_atomictype_bresp_exclusive_ace.sample(tr);
		trans_cross_axi_atomictype_bresp_exclusive_axi3_axi4.sample(tr);
		trans_cross_axi_atomictype_bresp_exclusive_axi4lite.sample(tr);
		trans_cross_axi_atomictype_bresp_locked_axi3.sample(tr);
		trans_cross_axi_atomictype_bresp_locked_exclusive_axi3.sample(tr);
		trans_cross_axi_atomictype_bresp_normal_ace.sample(tr);
		trans_cross_axi_atomictype_bresp_normal_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_exclusive_ace.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_exclusive_axi3_axi4.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_locked_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_locked_exclusive_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_normal_ace.sample(tr);
		trans_cross_axi_atomictype_exclusive_arcache_normal_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_exclusive_ace.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_exclusive_axi3_axi4.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_locked_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_locked_exclusive_axi3.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_normal_ace.sample(tr);
		trans_cross_axi_atomictype_exclusive_awcache_normal_axi3.sample(tr);
		trans_cross_axi_atomictype_rresp_exclusive_ace.sample(tr);
		trans_cross_axi_atomictype_rresp_exclusive_axi3_axi4.sample(tr);
		trans_cross_axi_atomictype_rresp_exclusive_axi4lite.sample(tr);
		trans_cross_axi_atomictype_rresp_locked_axi3.sample(tr);
		trans_cross_axi_atomictype_rresp_locked_exclusive_axi3.sample(tr);
		trans_cross_axi_atomictype_rresp_normal_ace.sample(tr);
		trans_cross_axi_atomictype_rresp_normal_axi3.sample(tr);
		trans_cross_axi_awburst_awlen_ace.sample(tr);
		trans_cross_axi_awburst_awlen_awaddr_awsize_ace.sample(tr);
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi3.sample(tr);
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi4.sample(tr);
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi4_lite.sample(tr);
		trans_cross_axi_awburst_awlen_awcache_ace.sample(tr);
		trans_cross_axi_awburst_awlen_awcache_axi4.sample(tr);
		trans_cross_axi_awburst_awlen_awcache_axi4_lite.sample(tr);
		trans_cross_axi_awburst_awlen_awprot_ace.sample(tr);
		trans_cross_axi_awburst_awlen_awprot_axi4.sample(tr);
		trans_cross_axi_awburst_awlen_awprot_axi4_lite.sample(tr);
		trans_cross_axi_awburst_awlen_awsize_ace.sample(tr);
		trans_cross_axi_awburst_awlen_awsize_axi3.sample(tr);
		trans_cross_axi_awburst_awlen_awsize_axi4.sample(tr);
		trans_cross_axi_awburst_awlen_awsize_axi4_lite.sample(tr);
		trans_cross_axi_awburst_awlen_axi4.sample(tr);
		trans_cross_axi_awburst_awlen_axi4_lite.sample(tr);
		trans_cross_axi_awburst_awqos_ace.sample(tr);
		trans_cross_axi_awburst_awqos_axi4.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awaddr_ace.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_exclusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_all.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_no_exclusive.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_exclusive_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_exclusive_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_locked_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_bresp_all.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awaddr_axi3_axi4.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_exlusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_all.sample(tr);
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_no_exclusive.sample(tr);
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awaddr_axi3_axi4.sample(tr);
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_exclusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_no_exclusive_not_axi3.sample(tr);
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_all.sample(tr);
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_no_exclusive.sample(tr);
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_ace.sample(tr);
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi3.sample(tr);
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi4.sample(tr);
		trans_cross_axi_read_narrow_transfer_arlen_araddr_ace.sample(tr);
		trans_cross_axi_read_narrow_transfer_arlen_araddr_axi3.sample(tr);
		trans_cross_axi_read_narrow_transfer_arlen_araddr_axi4.sample(tr);
		trans_cross_axi_read_unaligned_transfer_ace.sample(tr);
		trans_cross_axi_read_unaligned_transfer_axi3.sample(tr);
		trans_cross_axi_read_unaligned_transfer_axi4.sample(tr);
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_ace.sample(tr);
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi3.sample(tr);
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi4.sample(tr);
		trans_cross_axi_write_strobes.sample(tr);
		trans_cross_axi_write_unaligned_transfer_ace.sample(tr);
		trans_cross_axi_write_unaligned_transfer_axi3.sample(tr);
		trans_cross_axi_write_unaligned_transfer_axi4.sample(tr);
		trans_cross_master_to_slave_path_access_axi3.sample(tr);
		trans_cross_master_to_slave_path_access_axi4.sample(tr);
    endfunction

    covergroup signal_state_araddr(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        araddr_min_mid_max : coverpoint cov_item.addr & ((1024'b1<<(cfg.addr_width)) -1) iff(cov_item.xact_type == tcnt_axi_dec::READ){
            bins araddr_range_min = {0};
            bins araddr_range_mid = {[1:(((1024'b1<<((cfg.addr_width)-1)) + (1024'b1<<((cfg.addr_width)-1)) - 1)-1)]};
            bins araddr_range_max = {((1024'b1<<((cfg.addr_width)-1)) + (1024'b1<<((cfg.addr_width)-1)) -1)};
        }     
    endgroup

	covergroup signal_state_arburst(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arburst : coverpoint cov_item.burst_type iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins tcnt_axi_dec_burst_fixed = {0};
            bins tcnt_axi_dec_burst_incr = {1};
            bins tcnt_axi_dec_burst_wrap = {2};
            ignore_bins resvd = {3};
        }     
    endgroup

	covergroup signal_state_arcache(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arcache : coverpoint cov_item.cache_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_3_non_cacheable_non_bufferable = {0};
            bins tcnt_axi_3_bufferable_or_modifiable_only = {1};
            bins tcnt_axi_3_cacheable_but_no_alloc = {2};
            bins tcnt_axi_3_cacheable_bufferable_but_no_alloc = {3};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_rd_only = {6};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_rd_only = {7};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_wr_only = {10};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_wr_only = {11};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_both_rd_wr = {14};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_both_rd_wr = {15};
           ignore_bins resvd = {4,5,8,9,12,13};
        }     
    endgroup

	covergroup signal_state_arcache_axi4 (string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arcache : coverpoint cov_item.cache_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_4_arcache_device_non_bufferable = {0};
            bins tcnt_axi_4_arcache_device_bufferable = {1};
            bins tcnt_axi_4_arcache_normal_non_cachable_non_bufferable = {2};
            bins tcnt_axi_4_arcache_normal_non_cachable_bufferable = {3};
            bins tcnt_axi_4_arcache_write_through_no_allocate = {10};
            bins tcnt_axi_4_arcache_write_through_read_allocate = {14,5};
            bins tcnt_axi_4_arcache_write_through_write_allocate = {10};
            bins tcnt_axi_4_arcache_write_through_read_and_write_allocate = {14};
            bins tcnt_axi_4_arcache_write_back_no_allocate = {11};
            bins tcnt_axi_4_arcache_write_back_read_allocate = {15,7};
            bins tcnt_axi_4_arcache_write_back_write_allocate = {11};
            bins tcnt_axi_4_arcache_write_back_read_and_write_allocate = {15};
           ignore_bins resvd = {4,5,8,9,12,13};
        }     
    endgroup

	covergroup signal_state_arid(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arid_min_mid_max : coverpoint cov_item.id & ((1024'b1<<(cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins arid_range_min = {0};
            bins arid_range_mid = {[1:(( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) - 1)-1)]};
            bins arid_range_max = {( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) -1)};
        }     
    endgroup

	covergroup signal_state_arlen(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arlen_min_mid_max : coverpoint cov_item.burst_length & ((1024'b1<<(10)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins arlen_range_min = {0};
            bins arlen_range_mid = {[1:(( (1024'b1<<((10)-1)) + (1024'b1<<((10)-1)) - 1)-1)]};
            bins arlen_range_max = {( (1024'b1<<((10)-1)) + (1024'b1<<((10)-1)) -1)};
        }     
    endgroup

	covergroup signal_state_arlock_axi4_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cfg.exclusive_access_enable  == 1) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_exclusive = {2'd1};
            ignore_bins ignore_locked = {2'd2};
            ignore_bins resvd = {2'd3};
        } 
	endgroup

	covergroup signal_state_arlock_axi4_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cfg.exclusive_access_enable  == 0) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            ignore_bins ignore_locked = {2'd2};
            ignore_bins resvd = {2'd3};
        } 
	endgroup

	covergroup signal_state_arlock_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cfg.exclusive_access_enable  == 1) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_exclusive = {2'd1};
            bins tcnt_axi_dec_locked = {2'd2};
        } 
	endgroup

	covergroup signal_state_arlock_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cfg.exclusive_access_enable  == 0) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_locked = {2'd2};
        } 
	endgroup

	covergroup signal_state_arprot(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arprot : coverpoint cov_item.prot_type iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins tcnt_axi_data_secure_normal = {3'b000};
            bins tcnt_axi_data_secure_privileged = {3'b001};
            bins tcnt_axi_data_non_secure_normal = {3'b010};
            bins tcnt_axi_data_non_secure_privileged = {3'b011};
            bins tcnt_axi_instruction_secure_normal = {3'b100};
            bins tcnt_axi_instruction_secure_privileged = {3'b101};
            bins tcnt_axi_instruction_non_secure_normal = {3'b110};
            bins tcnt_axi_instruction_non_secure_privileged = {3'b111};
        } 
	endgroup

	covergroup signal_state_arqos(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arqos_min_mid_max : coverpoint cov_item.qos & ((1024'b1<<(4)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins arqos_range_min = {0};
            bins arqos_range_mid = {[1:(( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) - 1)-1)]};
            bins arqos_range_max = {( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_arregion(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arregion_min_mid_max : coverpoint cov_item.region & ((1024'b1<<(4)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins arregion_range_min = {0};
            bins arregion_range_mid = {[1:(( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) - 1)-1)]};
            bins arregion_range_max = {( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_arsize(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        arsize : coverpoint cov_item.burst_size iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins tcnt_axi_dec_burst_size_8 = {0};
            bins tcnt_axi_dec_burst_size_16 = {1};
            bins tcnt_axi_dec_burst_size_32 = {2};
            bins tcnt_axi_dec_burst_size_64 = {3};
            bins tcnt_axi_dec_burst_size_128 = {4};
            bins tcnt_axi_dec_burst_size_256 = {5};
            bins tcnt_axi_dec_burst_size_512 = {6};
            bins tcnt_axi_dec_burst_size_1024 = {7};
            bins tcnt_axi_dec_burst_size_2048 = {8};
        } 
	endgroup

    covergroup signal_state_aruser(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        aruser_min_mid_max : coverpoint cov_item.addr_user & ((1024'b1<<(cfg.addr_user_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins aruser_range_min = {0};
            bins aruser_range_mid = {[1:(( (1024'b1<<((cfg.addr_user_width)-1)) + (1024'b1<<((cfg.addr_user_width)-1)) - 1)-1)]};
            bins aruser_range_max = {( (1024'b1<<((cfg.addr_user_width)-1)) + (1024'b1<<((cfg.addr_user_width)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_awburst(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awburst : coverpoint cov_item.burst_type iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins tcnt_axi_dec_burst_fixed = {0};
            bins tcnt_axi_dec_burst_incr = {1};
            bins tcnt_axi_dec_burst_wrap = {2};
            ignore_bins resvd = {3};
        }     
	endgroup

	covergroup signal_state_awcache(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awcache : coverpoint cov_item.cache_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_3_non_cacheable_non_bufferable = {0};
            bins tcnt_axi_3_bufferable_or_modifiable_only = {1};
            bins tcnt_axi_3_cacheable_but_no_alloc = {2};
            bins tcnt_axi_3_cacheable_bufferable_but_no_alloc = {3};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_rd_only = {6};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_rd_only = {7};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_wr_only = {10};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_wr_only = {11};
            bins tcnt_axi_3_cacheable_wr_thru_alloc_on_both_rd_wr = {14};
            bins tcnt_axi_3_cacheable_wr_back_alloc_on_both_rd_wr = {15};
           ignore_bins resvd = {4,5,8,9,12,13};
        }
	endgroup

	covergroup signal_state_awcache_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awcache : coverpoint cov_item.cache_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_4_awcache_device_non_bufferable = {0};
            bins tcnt_axi_4_awcache_device_bufferable = {1};
            bins tcnt_axi_4_awcache_normal_non_cachable_non_bufferable = {2};
            bins tcnt_axi_4_awcache_normal_non_cachable_bufferable = {3};
            bins tcnt_axi_4_awcache_write_through_no_allocate = {10};
            bins tcnt_axi_4_awcache_write_through_read_allocate = {14,5};
            bins tcnt_axi_4_awcache_write_through_write_allocate = {10};
            bins tcnt_axi_4_awcache_write_through_read_and_write_allocate = {14};
            bins tcnt_axi_4_awcache_write_back_no_allocate = {11};
            bins tcnt_axi_4_awcache_write_back_read_allocate = {15,7};
            bins tcnt_axi_4_awcache_write_back_write_allocate = {11};
            bins tcnt_axi_4_awcache_write_back_read_and_write_allocate = {15};
           ignore_bins resvd = {4,5,8,9,12,13};
        } 
	endgroup

	covergroup signal_state_awid(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awid_min_mid_max : coverpoint cov_item.id & ((1024'b1<<(cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins awid_range_min = {0};
            bins awid_range_mid = {[1:(((1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) +
                                    (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) - 1)-1)]};
            bins awid_range_max = {((1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width
                                    ? cfg.write_chan_id_width:cfg.id_width)-1)) -1)};
        }
	endgroup

	covergroup signal_state_awlock_axi4_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cfg.exclusive_access_enable  == 1) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_exclusive = {2'd1};
            ignore_bins ignore_locked = {2'd2};
            ignore_bins resvd = {2'd3};
        } 
	endgroup

	covergroup signal_state_awlock_axi4_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI4) && (cfg.exclusive_access_enable  == 0) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            ignore_bins ignore_locked = {2'd2};
            ignore_bins resvd = {2'd3};
        }
	endgroup

	covergroup signal_state_awlock_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cfg.exclusive_access_enable  == 1) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_exclusive = {2'd1};
            bins tcnt_axi_dec_locked = {2'd2};
        } 
	endgroup

	covergroup signal_state_awlock_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awlock : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cfg.exclusive_access_enable  == 0) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_dec_normal = {2'd0};
            bins tcnt_axi_dec_locked = {2'd2};
        } 
	endgroup

	covergroup signal_state_awprot(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awprot : coverpoint cov_item.prot_type iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins tcnt_axi_data_secure_normal = {3'b000};
            bins tcnt_axi_data_secure_privileged = {3'b001};
            bins tcnt_axi_data_non_secure_normal = {3'b010};
            bins tcnt_axi_data_non_secure_privileged = {3'b011};
            bins tcnt_axi_instruction_secure_normal = {3'b100};
            bins tcnt_axi_instruction_secure_privileged = {3'b101};
            bins tcnt_axi_instruction_non_secure_normal = {3'b110};
            bins tcnt_axi_instruction_non_secure_privileged = {3'b111};
        }
	endgroup

	covergroup signal_state_awqos(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awqos_min_mid_max : coverpoint cov_item.qos & ((1024'b1<<(4)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins awqos_range_min = {0};
            bins awqos_range_mid = {[1:(( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) - 1)-1)]};
            bins awqos_range_max = {( (1024'b1<<((4)-1)) + (1024'b1<<((4)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_awsize(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awsize : coverpoint cov_item.burst_size iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins tcnt_axi_dec_burst_size_8 = {0};
            bins tcnt_axi_dec_burst_size_16 = {1};
            bins tcnt_axi_dec_burst_size_32 = {2};
            bins tcnt_axi_dec_burst_size_64 = {3};
            bins tcnt_axi_dec_burst_size_128 = {4};
            bins tcnt_axi_dec_burst_size_256 = {5};
            bins tcnt_axi_dec_burst_size_512 = {6};
            bins tcnt_axi_dec_burst_size_1024 = {7};
            bins tcnt_axi_dec_burst_size_2048 = {8};
        }
	endgroup

    covergroup signal_state_awuser(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        awuser_min_mid_max : coverpoint cov_item.addr_user & ((1024'b1<<(cfg.addr_user_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins awuser_range_min = {0};
            bins awuser_range_mid = {[1:(( (1024'b1<<((cfg.addr_user_width)-1)) + (1024'b1<<((cfg.addr_user_width)-1)) - 1)-1)]};
            bins awuser_range_max = {( (1024'b1<<((cfg.addr_user_width)-1)) + (1024'b1<<((cfg.addr_user_width)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_bid(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        bid_min_mid_max : coverpoint cov_item.id & ((1024'b1<<(cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins bid_range_min = {0};
            bins bid_range_mid = {[1:(( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) - 1)-1)]};
            bins bid_range_max = {( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) -1)};
        } 
	endgroup

    covergroup signal_state_bresp(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        bresp : coverpoint cov_item.bresp[1:0] iff((!cfg.exclusive_access_enable) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_okay_response = {2'b00};
            bins tcnt_axi_slverr_response = {2'b10};
            bins tcnt_axi_decerr_response = {2'b11};
        } 
	endgroup

	covergroup signal_state_bresp_ex_access(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        bresp : coverpoint cov_item.bresp[1:0] iff((cfg.exclusive_access_enable) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins tcnt_axi_okay_response = {2'b00};
            bins tcnt_axi_exokay_response = {2'b01};
            bins tcnt_axi_slverr_response = {2'b10};
            bins tcnt_axi_decerr_response = {2'b11};
        } 
	endgroup

	covergroup signal_state_buser(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        buser_min_mid_max : coverpoint cov_item.resp_user & ((1024'b1<<(cfg.resp_user_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins buser_range_min = {0};
            bins buser_range_mid = {[1:(( (1024'b1<<((cfg.resp_user_width)-1)) + (1024'b1<<((cfg.resp_user_width)-1)) - 1)-1)]};
            bins buser_range_max = {( (1024'b1<<((cfg.resp_user_width)-1)) + (1024'b1<<((cfg.resp_user_width)-1)) -1)};
        } 
	endgroup

    covergroup signal_state_rdata(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        rdata_min_mid_max : coverpoint cov_item.data[idx] & ((2048'b1<<(cfg.data_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins rdata_range_min = {0};
            bins rdata_range_mid = {[1:(( (2048'b1<<((cfg.data_width)-1)) + (2048'b1<<((cfg.data_width)-1)) - 1)-1)]};
            bins rdata_range_max = {( (2048'b1<<((cfg.data_width)-1)) + (2048'b1<<((cfg.data_width)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_rid(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        rid_min_mid_max : coverpoint cov_item.id & ((1024'b1<<(cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins rid_range_min = {0};
            bins rid_range_mid = {[1:(( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) - 1)-1)]};
            bins rid_range_max = {( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.read_chan_id_width:cfg.id_width)-1)) -1)};
        }
	endgroup

	covergroup signal_state_rresp(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        rresp : coverpoint cov_item.rresp[idx][1:0] iff(!cfg.exclusive_access_enable &&(cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_okay_response = {2'b00};
            bins tcnt_axi_slverr_response = {2'b10};
            bins tcnt_axi_decerr_response = {2'b11};
        } 
	endgroup

	covergroup signal_state_rresp_ex_access(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        rresp : coverpoint cov_item.rresp[idx][1:0] iff((cfg.exclusive_access_enable) && (cov_item.xact_type == tcnt_axi_dec::READ))
        {
            bins tcnt_axi_okay_response = {2'b00};
            bins tcnt_axi_exokay_response = {2'b01};
            bins tcnt_axi_slverr_response = {2'b10};
            bins tcnt_axi_decerr_response = {2'b11};
        } 
	endgroup

    covergroup signal_state_ruser(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        ruser_min_mid_max : coverpoint cov_item.data_user[idx] & ((1024'b1<<(cfg.data_user_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::READ)
        {
            bins ruser_range_min = {0};
            bins ruser_range_mid = {[1:(( (1024'b1<<((cfg.data_user_width)-1)) + (1024'b1<<((cfg.data_user_width)-1)) - 1)-1)]};
            bins ruser_range_max = {( (1024'b1<<((cfg.data_user_width)-1)) + (1024'b1<<((cfg.data_user_width)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_wdata(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        wdata_min_mid_max : coverpoint cov_item.data[idx] & ((1024'b1<<(cfg.data_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins wdata_range_min = {0};
            bins wdata_range_mid = {[1:(( (1024'b1<<((cfg.data_width)-1)) + (1024'b1<<((cfg.data_width)-1)) - 1)-1)]};
            bins wdata_range_max = {( (1024'b1<<((cfg.data_width)-1)) + (1024'b1<<((cfg.data_width)-1)) -1)};
        } 
	endgroup

    covergroup signal_state_wid(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        wid_min_mid_max : coverpoint cov_item.id & ((1024'b1<<(cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width))-1) iff((cfg.axi_interface_type == tcnt_axi_dec::AXI3) && (cov_item.xact_type == tcnt_axi_dec::WRITE))
        {
            bins wid_range_min = {0};
            bins wid_range_mid = {[1:(( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) - 1)-1)]};
            bins wid_range_max = {( (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) + (1024'b1<<((cfg.use_separate_rd_wr_chan_id_width ? cfg.write_chan_id_width:cfg.id_width)-1)) -1)};
        }
    endgroup

	covergroup signal_state_wstrb(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        wstrb_min_mid_max : coverpoint cov_item.wstrb[idx] & ((2048'b1<<(cfg.data_width/8)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins wstrb_range_min = {0};
            bins wstrb_range_mid = {[1:(( (2048'b1<<((cfg.data_width/8)-1)) + (2048'b1<<((cfg.data_width/8)-1)) - 1)-1)]};
            bins wstrb_range_max = {( (2048'b1<<((cfg.data_width/8)-1)) + (2048'b1<<((cfg.data_width/8)-1)) -1)};
        } 
	endgroup

	covergroup signal_state_wuser(string name) with function sample(tcnt_axi_xaction cov_item, int idx);
        option.per_instance = 1;
        option.goal = 100;
		option.name = name;

        wuser_min_mid_max : coverpoint cov_item.data_user[idx] & ((1024'b1<<(cfg.data_user_width)) -1 ) iff(cov_item.xact_type == tcnt_axi_dec::WRITE)
        {
            bins wuser_range_min = {0};
            bins wuser_range_mid = {[1:(( (1024'b1<<((cfg.data_user_width)-1)) + (1024'b1<<((cfg.data_user_width)-1)) - 1)-1)]};
            bins wuser_range_max = {( (1024'b1<<((cfg.data_user_width)-1)) + (1024'b1<<((cfg.data_user_width)-1)) -1)};
        } 
	endgroup
    
    /*********************************************************************
    * toggle coverage
    *********************************************************************/
    covergroup toggle_cov(string name);
        option.per_instance = 1;
		option.name = name;
	endgroup

    /*********************************************************************
    * trans cross coverage
    *********************************************************************/
	covergroup trans_cross_axi_arburst_arlen_araddr_arsize_ace(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
		option.name = name;
	endgroup

    covergroup trans_cross_axi_arburst_arlen_araddr_arsize_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }        
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi3 = {[16+1:((1<<10))]};
            option.weight = 1;
        }
        addr : coverpoint cov_item.addr iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            option.weight = 1;
           bins addr_range_min = {0} ;
           bins addr_range_mid = {[1:(64'd2**(cfg.addr_width)-2)]};
           bins addr_range_max = {((64'd2**(cfg.addr_width))-1)};
        }
        burst_size : coverpoint cov_item.burst_size iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_size_8bit = {tcnt_axi_dec::BURST_SIZE_8BIT};
            bins burst_size_16bit = {tcnt_axi_dec::BURST_SIZE_16BIT};
            bins burst_size_32bit = {tcnt_axi_dec::BURST_SIZE_32BIT};
            bins burst_size_64bit = {tcnt_axi_dec::BURST_SIZE_64BIT};
            bins burst_size_128bit = {tcnt_axi_dec::BURST_SIZE_128BIT};
            bins burst_size_256bit = {tcnt_axi_dec::BURST_SIZE_256BIT};
            bins burst_size_512bit = {tcnt_axi_dec::BURST_SIZE_512BIT};
            bins burst_size_1024bit = {tcnt_axi_dec::BURST_SIZE_1024BIT};
            bins burst_size_2048bit = {tcnt_axi_dec::BURST_SIZE_2048BIT};
            option.weight = 1;
        }
        axi_arburst_arlen_araddr_arsize : cross read_xact_type, burst_type, burst_length, addr, burst_size {
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            ignore_bins Ignore_invalid_max_addr_incr_burst_length = binsof(addr.addr_range_max) && binsof(burst_type.incr_burst) && !binsof(burst_length) intersect {1};
            ignore_bins Ignore_invalid_max_addr_incr_burst_size = binsof(addr.addr_range_max) && binsof(burst_type.incr_burst) && !binsof(burst_size) intersect { 0};
            ignore_bins Ignore_invalid_max_addr_wrap_burst = binsof(addr.addr_range_max) && binsof(burst_type.wrap_burst);
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_araddr_arsize_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }         
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi4 = {[256+1:((1<<10))]};
            option.weight = 1;
        }
        addr : coverpoint cov_item.addr iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            option.weight = 1;
            bins addr_range_min = {0} ;
            bins addr_range_mid = {[1:(64'd2**(cfg.addr_width)-2)]};
            bins addr_range_max = {((64'd2**(cfg.addr_width))-1)};
        }
        burst_size : coverpoint cov_item.burst_size iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_size_8bit = {tcnt_axi_dec::BURST_SIZE_8BIT};
            bins burst_size_16bit = {tcnt_axi_dec::BURST_SIZE_16BIT};
            bins burst_size_32bit = {tcnt_axi_dec::BURST_SIZE_32BIT};
            bins burst_size_64bit = {tcnt_axi_dec::BURST_SIZE_64BIT};
            bins burst_size_128bit = {tcnt_axi_dec::BURST_SIZE_128BIT};
            bins burst_size_256bit = {tcnt_axi_dec::BURST_SIZE_256BIT};
            bins burst_size_512bit = {tcnt_axi_dec::BURST_SIZE_512BIT};
            bins burst_size_1024bit = {tcnt_axi_dec::BURST_SIZE_1024BIT};
            bins burst_size_2048bit = {tcnt_axi_dec::BURST_SIZE_2048BIT};
            option.weight = 1;
        }
        axi_arburst_arlen_araddr_arsize : cross read_xact_type,burst_type, burst_length, addr, burst_size {
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            ignore_bins Ignore_invalid_max_addr_incr_burst_length = binsof(addr.addr_range_max) && binsof(burst_type.incr_burst) && !binsof(burst_length) intersect {1};
            ignore_bins Ignore_invalid_max_addr_incr_burst_size = binsof(addr.addr_range_max) && binsof(burst_type.incr_burst) && !binsof(burst_size) intersect { 0};
            ignore_bins Ignore_invalid_max_addr_wrap_burst = binsof(addr.addr_range_max) && binsof(burst_type.wrap_burst);
            option.weight = 1;
        }
        option.per_instance = 1;
		option.name = name;
    endgroup 

	covergroup trans_cross_axi_arburst_arlen_araddr_arsize_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
		option.name = name;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arcache_ace(string name) with function sample(tcnt_axi_xaction cov_item);
        option.per_instance = 1;
		option.name = name;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arcache_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }        
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi4 = {[256+1:((1<<10))]};
            option.weight = 1;
        }
        cache_type : coverpoint cov_item.cache_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins device_non_bufferable = {0};
            bins device_bufferable = {1};
            bins normal_non_cacheable_non_bufferable = {2};
            bins normal_non_cacheable_bufferable = {3};
            bins write_through_no_allocate = {10};
            bins write_through_read_allocate = {14};
            bins write_through_write_allocate = {10};
            bins write_through_read_and_write_allocate = {14};
            bins write_back_no_allocate = {11};
            bins write_back_read_allocate = {15};
            bins write_back_write_allocate = {11};
            bins write_back_read_and_write_allocate = {15};
            ignore_bins ignore_rsvd = {4,5,8,9,12,13};
            option.weight = 1;
        }
        axi_arburst_arlen_arcache : cross read_xact_type, burst_type, burst_length, cache_type{
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arcache_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arprot_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }         
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi3 = {[16+1:((1<<10))]};
            option.weight = 1;
        }
        prot_type : coverpoint cov_item.prot_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins data_secure_normal = {tcnt_axi_dec::DATA_SECURE_NORMAL};
            bins data_secure_privileged = {tcnt_axi_dec::DATA_SECURE_PRIVILEGED};
            bins data_non_secure_normal = {tcnt_axi_dec::DATA_NON_SECURE_NORMAL};
            bins data_non_secure_privileged = {tcnt_axi_dec::DATA_NON_SECURE_PRIVILEGED};
            bins instruction_secure_normal = {tcnt_axi_dec::INSTRUCTION_SECURE_NORMAL};
            bins instruction_secure_privileged = {tcnt_axi_dec::INSTRUCTION_SECURE_PRIVILEGED};
            bins instruction_non_secure_normal = {tcnt_axi_dec::INSTRUCTION_NON_SECURE_NORMAL};
            bins instruction_non_secure_privileged = {tcnt_axi_dec::INSTRUCTION_NON_SECURE_PRIVILEGED};
            option.weight = 1;
        }
        axi_arburst_arlen_arprot : cross read_xact_type,burst_type, burst_length, prot_type{
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arprot_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }         
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi4 = {[256+1:((1<<10))]};
            option.weight = 1;
        }
        prot_type : coverpoint cov_item.prot_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins data_secure_normal = {tcnt_axi_dec::DATA_SECURE_NORMAL};
            bins data_secure_privileged = {tcnt_axi_dec::DATA_SECURE_PRIVILEGED};
            bins data_non_secure_normal = {tcnt_axi_dec::DATA_NON_SECURE_NORMAL};
            bins data_non_secure_privileged = {tcnt_axi_dec::DATA_NON_SECURE_PRIVILEGED};
            bins instruction_secure_normal = {tcnt_axi_dec::INSTRUCTION_SECURE_NORMAL};
            bins instruction_secure_privileged = {tcnt_axi_dec::INSTRUCTION_SECURE_PRIVILEGED};
            bins instruction_non_secure_normal = {tcnt_axi_dec::INSTRUCTION_NON_SECURE_NORMAL};
            bins instruction_non_secure_privileged = {tcnt_axi_dec::INSTRUCTION_NON_SECURE_PRIVILEGED};
            option.weight = 1;
        }
        axi_arburst_arlen_arprot : cross read_xact_type, burst_type, burst_length, prot_type{
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arprot_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arsize_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }        
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi3 = {[16+1:((1<<10))]};
            option.weight = 1;
        }
        burst_size : coverpoint cov_item.burst_size iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_size_8bit = {tcnt_axi_dec::BURST_SIZE_8BIT};
            bins burst_size_16bit = {tcnt_axi_dec::BURST_SIZE_16BIT};
            bins burst_size_32bit = {tcnt_axi_dec::BURST_SIZE_32BIT};
            bins burst_size_64bit = {tcnt_axi_dec::BURST_SIZE_64BIT};
            bins burst_size_128bit = {tcnt_axi_dec::BURST_SIZE_128BIT};
            bins burst_size_256bit = {tcnt_axi_dec::BURST_SIZE_256BIT};
            bins burst_size_512bit = {tcnt_axi_dec::BURST_SIZE_512BIT};
            bins burst_size_1024bit = {tcnt_axi_dec::BURST_SIZE_1024BIT};
            bins burst_size_2048bit = {tcnt_axi_dec::BURST_SIZE_2048BIT};
            option.weight = 1;
        }
        axi_arburst_arlen_arsize : cross read_xact_type, burst_type, burst_length, burst_size{
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arsize_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }        
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi4 = {[256+1:((1<<10))]};
            option.weight = 1;
        }
        burst_size : coverpoint cov_item.burst_size iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_size_8bit = {tcnt_axi_dec::BURST_SIZE_8BIT};
            bins burst_size_16bit = {tcnt_axi_dec::BURST_SIZE_16BIT};
            bins burst_size_32bit = {tcnt_axi_dec::BURST_SIZE_32BIT};
            bins burst_size_64bit = {tcnt_axi_dec::BURST_SIZE_64BIT};
            bins burst_size_128bit = {tcnt_axi_dec::BURST_SIZE_128BIT};
            bins burst_size_256bit = {tcnt_axi_dec::BURST_SIZE_256BIT};
            bins burst_size_512bit = {tcnt_axi_dec::BURST_SIZE_512BIT};
            bins burst_size_1024bit = {tcnt_axi_dec::BURST_SIZE_1024BIT};
            bins burst_size_2048bit = {tcnt_axi_dec::BURST_SIZE_2048BIT};
            option.weight = 1;
        }
        axi_arburst_arlen_arsize : cross read_xact_type, burst_type, burst_length, burst_size{
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_arsize_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arlen_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

    covergroup trans_cross_axi_arburst_arlen_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }        
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi3 = {[16+1:((1<<10))]};
            option.weight = 1;
        }
        axi_arburst_arlen : cross read_xact_type, burst_type, burst_length {
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup
 
    covergroup trans_cross_axi_arburst_arlen_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }         
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        burst_length : coverpoint cov_item.burst_length iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins burst_length[] = {[1:((1<<10)-1)]};
            ignore_bins ignore_unsupported_burst_length_axi4 = {[256+1:((1<<10))]};
            option.weight = 1;
        }
        axi_arburst_arlen : cross read_xact_type, burst_type, burst_length {
            ignore_bins Ignore_invalid_wrap = binsof(burst_type.wrap_burst) && !binsof(burst_length) intersect { 2,4,8,16};
            ignore_bins Ignore_invalid_fixed = binsof(burst_type.fixed_burst) && binsof(burst_length) intersect {[ 17: ((1<<10))]};
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup
 
	covergroup trans_cross_axi_arburst_arlen_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arqos_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_arqos_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        } 
        burst_type : coverpoint cov_item.burst_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins fixed_burst = {tcnt_axi_dec::FIXED};
            bins incr_burst = {tcnt_axi_dec::INCR};
            bins wrap_burst = {tcnt_axi_dec::WRAP};
            option.weight = 1;
        }
        qos : coverpoint cov_item.qos iff(cfg.axi_interface_type == tcnt_axi_dec::AXI4){
            bins qos_range_0_1 = {[0:1]};
            bins qos_range_2_3 = {[2:3]};
            bins qos_range_4_7 = {[4:7]};
            bins qos_range_8_15 = {[8:15]};
            option.weight = 1;
        }
        axi_arburst_arqos : cross burst_type, qos {
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_ace_araddr_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi3_rresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi4_araddr_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_exlusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_araddr_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_bresp_exclusive_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_bresp_exclusive_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        atomic_type : coverpoint cov_item.atomic_type iff((cfg.axi_interface_type inside {tcnt_axi_dec::AXI3,tcnt_axi_dec::AXI4}) && (cov_item.xact_type == tcnt_axi_dec::WRITE)){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins exclusive = {tcnt_axi_dec::EXCLUSIVE};
            option.weight = 1;
        }
        bresp : coverpoint cov_item.bresp iff((cfg.axi_interface_type inside {tcnt_axi_dec::AXI3,tcnt_axi_dec::AXI4}) && (cov_item.xact_type == tcnt_axi_dec::WRITE)){
            bins okay_resp = {tcnt_axi_dec::OKAY};
            bins exokay_resp = {tcnt_axi_dec::EXOKAY};
            bins slverr_resp = {tcnt_axi_dec::SLVERR};
            bins decerr_resp = {tcnt_axi_dec::DECERR};
            option.weight = 1;
        }
        axi_atomictype_bresp : cross atomic_type,bresp{
           option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_bresp_exclusive_axi4lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_bresp_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        write_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins write_xact = {tcnt_axi_dec::WRITE};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins locked = {tcnt_axi_dec::LOCKED};
            option.weight = 1;
        }
        bresp : coverpoint cov_item.bresp iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins okay_resp = {tcnt_axi_dec::OKAY};
            bins slverr_resp = {tcnt_axi_dec::SLVERR};
            bins decerr_resp = {tcnt_axi_dec::DECERR};
            option.weight = 1;
        }
        axi_atomictype_bresp : cross write_xact_type, atomic_type,bresp{
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_bresp_locked_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        write_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins write_xact = {tcnt_axi_dec::WRITE};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins exclusive = {tcnt_axi_dec::EXCLUSIVE};
            bins locked = {tcnt_axi_dec::LOCKED};
            option.weight = 1;
        }
        bresp : coverpoint cov_item.bresp iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins okay_resp = {tcnt_axi_dec::OKAY};
            bins exokay_resp = {tcnt_axi_dec::EXOKAY};
            bins slverr_resp = {tcnt_axi_dec::SLVERR};
            bins decerr_resp = {tcnt_axi_dec::DECERR};
            option.weight = 1;
        }
        axi_atomictype_bresp : cross write_xact_type, atomic_type,bresp{
           option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_bresp_normal_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_bresp_normal_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        write_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins write_xact = {tcnt_axi_dec::WRITE};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins normal = {tcnt_axi_dec::NORMAL};
            option.weight = 1;
        }
        bresp : coverpoint cov_item.bresp iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins okay_resp = {tcnt_axi_dec::OKAY};
            bins slverr_resp = {tcnt_axi_dec::SLVERR};
            bins decerr_resp = {tcnt_axi_dec::DECERR};
            option.weight = 1;
        }
        axi_atomictype_bresp : cross write_xact_type, atomic_type,bresp{
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_exclusive_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;

        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_exclusive_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type inside {tcnt_axi_dec::AXI3,tcnt_axi_dec::AXI4}){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type inside {tcnt_axi_dec::AXI3,tcnt_axi_dec::AXI4}){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins exclusive = {tcnt_axi_dec::EXCLUSIVE};
            option.weight = 1;
        }
        cache_type : coverpoint cov_item.cache_type iff(cfg.axi_interface_type inside {tcnt_axi_dec::AXI3,tcnt_axi_dec::AXI4}){
            bins device_non_bufferable = {0};
            bins device_bufferable = {1};
            bins normal_non_cacheable_non_bufferable = {2};
            bins normal_non_cacheable_bufferable = {3};
        }
        axi_atomictype_exclusive_arcache : cross read_xact_type, atomic_type,cache_type{
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins locked = {tcnt_axi_dec::LOCKED};
            option.weight = 1;
        }
        cache_type : coverpoint cov_item.cache_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins device_non_bufferable = {0};
            bins device_bufferable = {1};
            bins normal_non_cacheable_non_bufferable = {2};
            bins normal_non_cacheable_bufferable = {3};
        }
        axi_atomictype_exclusive_arcache : cross read_xact_type, atomic_type,cache_type{
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_locked_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        read_xact_type : coverpoint cov_item.xact_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins read_xact = {tcnt_axi_dec::READ};
            option.weight = 1;
        }
        atomic_type : coverpoint cov_item.atomic_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins normal = {tcnt_axi_dec::NORMAL};
            bins exclusive = {tcnt_axi_dec::EXCLUSIVE};
            bins locked = {tcnt_axi_dec::LOCKED};
            option.weight = 1;
        }
        cache_type : coverpoint cov_item.cache_type iff(cfg.axi_interface_type == tcnt_axi_dec::AXI3){
            bins device_non_bufferable = {0};
            bins device_bufferable = {1};
            bins normal_non_cacheable_non_bufferable = {2};
            bins normal_non_cacheable_bufferable = {3};
        }
        axi_atomictype_exclusive_arcache : cross read_xact_type, atomic_type,cache_type{
            option.weight = 1;
        }
        option.per_instance = 1;
	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_normal_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_arcache_normal_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_exclusive_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_exclusive_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_locked_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_normal_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_exclusive_awcache_normal_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_exclusive_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_exclusive_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_exclusive_axi4lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_locked_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_normal_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_atomictype_rresp_normal_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awaddr_awsize_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awaddr_awsize_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awaddr_awsize_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awaddr_awsize_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awcache_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awcache_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awcache_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awprot_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awprot_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awprot_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awsize_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awsize_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awsize_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_awsize_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awlen_axi4_lite(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awqos_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_awqos_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_ace_awaddr_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_exclusive_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_locked_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi3_bresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi4_awaddr_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_exlusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awaddr_axi3_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_no_exclusive_not_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_all(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_no_exclusive(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_narrow_transfer_arlen_araddr_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_narrow_transfer_arlen_araddr_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_narrow_transfer_arlen_araddr_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_unaligned_transfer_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_unaligned_transfer_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_read_unaligned_transfer_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_narrow_transfer_awlen_awaddr_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_strobes(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_unaligned_transfer_ace(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_unaligned_transfer_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_axi_write_unaligned_transfer_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

	covergroup trans_cross_master_to_slave_path_access_axi3(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup

    covergroup trans_cross_master_to_slave_path_access_axi4(string name) with function sample(tcnt_axi_xaction cov_item);
		option.name = name;
        option.per_instance = 1;

	endgroup


    function new(string name="",tcnt_axi_cfg axi_cfg);
        tname = name;
        this.cfg = axi_cfg;
        //get_item_port = new("get_item_port",this);

        signal_state_araddr                                                                       = new({tname,"signal_state_araddr"});
		signal_state_arburst                                                                      = new({tname,"signal_state_arburst"});
		signal_state_arcache                                                                      = new({tname,"signal_state_arcache"});
		signal_state_arcache_axi4                                                                 = new({tname,"signal_state_arcache_axi4"});
		signal_state_arid                                                                         = new({tname,"signal_state_arid"});
		signal_state_arlen                                                                        = new({tname,"signal_state_arlen"});
		signal_state_arlock_axi4_exclusive                                                        = new({tname,"signal_state_arlock_axi4_exclusive"});
		signal_state_arlock_axi4_no_exclusive                                                     = new({tname,"signal_state_arlock_axi4_no_exclusive"});
		signal_state_arlock_exclusive                                                             = new({tname,"signal_state_arlock_exclusive"});
		signal_state_arlock_no_exclusive                                                          = new({tname,"signal_state_arlock_no_exclusive"});
		signal_state_arprot                                                                       = new({tname,"signal_state_arprot"});
		signal_state_arqos                                                                        = new({tname,"signal_state_arqos"});
		signal_state_arregion                                                                     = new({tname,"signal_state_arregion"});
		signal_state_arsize                                                                       = new({tname,"signal_state_arsize"});
		signal_state_aruser                                                                       = new({tname,"signal_state_aruser"});
		signal_state_awburst                                                                      = new({tname,"signal_state_awburst"});
		signal_state_awcache                                                                      = new({tname,"signal_state_awcache"});
		signal_state_awcache_axi4                                                                 = new({tname,"signal_state_awcache_axi4"});
		signal_state_awid                                                                         = new({tname,"signal_state_awid"});
		signal_state_awlock_axi4_exclusive                                                        = new({tname,"signal_state_awlock_axi4_exclusive"});
		signal_state_awlock_axi4_no_exclusive                                                     = new({tname,"signal_state_awlock_axi4_no_exclusive"});
		signal_state_awlock_exclusive                                                             = new({tname,"signal_state_awlock_exclusive"});
		signal_state_awlock_no_exclusive                                                          = new({tname,"signal_state_awlock_no_exclusive"});
		signal_state_awprot                                                                       = new({tname,"signal_state_awprot"});
		signal_state_awqos                                                                        = new({tname,"signal_state_awqos"});
		signal_state_awsize                                                                       = new({tname,"signal_state_awsize"});
		signal_state_awuser                                                                       = new({tname,"signal_state_awuser"});
		signal_state_bid                                                                          = new({tname,"signal_state_bid"});
		signal_state_bresp                                                                        = new({tname,"signal_state_bresp"});
		signal_state_bresp_ex_access                                                              = new({tname,"signal_state_bresp_ex_access"});
		signal_state_buser                                                                        = new({tname,"signal_state_buser"});
		signal_state_rdata                                                                        = new({tname,"signal_state_rdata"});
		signal_state_rid                                                                          = new({tname,"signal_state_rid"});
		signal_state_rresp                                                                        = new({tname,"signal_state_rresp"});
		signal_state_rresp_ex_access                                                              = new({tname,"signal_state_rresp_ex_access"});
		signal_state_ruser                                                                        = new({tname,"signal_state_ruser"});
		signal_state_wdata                                                                        = new({tname,"signal_state_wdata"});
		signal_state_wid                                                                          = new({tname,"signal_state_wid"});
		signal_state_wstrb                                                                        = new({tname,"signal_state_wstrb"});
		signal_state_wuser                                                                        = new({tname,"signal_state_wuser"});
		toggle_cov                                                                                = new({tname,"toggle_cov"});
		trans_cross_axi_arburst_arlen_araddr_arsize_ace                                           = new({tname,"trans_cross_axi_arburst_arlen_araddr_arsize_ace"});
		trans_cross_axi_arburst_arlen_araddr_arsize_axi3                                          = new({tname,"trans_cross_axi_arburst_arlen_araddr_arsize_axi3"});
		trans_cross_axi_arburst_arlen_araddr_arsize_axi4                                          = new({tname,"trans_cross_axi_arburst_arlen_araddr_arsize_axi4"});
		trans_cross_axi_arburst_arlen_araddr_arsize_axi4_lite                                     = new({tname,"trans_cross_axi_arburst_arlen_araddr_arsize_axi4_lite"});
		trans_cross_axi_arburst_arlen_arcache_ace                                                 = new({tname,"trans_cross_axi_arburst_arlen_arcache_ace"});
		trans_cross_axi_arburst_arlen_arcache_axi4                                                = new({tname,"trans_cross_axi_arburst_arlen_arcache_axi4"});
		trans_cross_axi_arburst_arlen_arcache_axi4_lite                                           = new({tname,"trans_cross_axi_arburst_arlen_arcache_axi4_lite"});
		trans_cross_axi_arburst_arlen_arprot_axi3                                                 = new({tname,"trans_cross_axi_arburst_arlen_arprot_axi3"});
		trans_cross_axi_arburst_arlen_arprot_axi4                                                 = new({tname,"trans_cross_axi_arburst_arlen_arprot_axi4"});
		trans_cross_axi_arburst_arlen_arprot_axi4_lite                                            = new({tname,"trans_cross_axi_arburst_arlen_arprot_axi4_lite"});
		trans_cross_axi_arburst_arlen_arsize_axi3                                                 = new({tname,"trans_cross_axi_arburst_arlen_arsize_axi3"});
		trans_cross_axi_arburst_arlen_arsize_axi4                                                 = new({tname,"trans_cross_axi_arburst_arlen_arsize_axi4"});
		trans_cross_axi_arburst_arlen_arsize_axi4_lite                                            = new({tname,"trans_cross_axi_arburst_arlen_arsize_axi4_lite"});
		trans_cross_axi_arburst_arlen_ace                                                         = new({tname,"trans_cross_axi_arburst_arlen_ace"});
        trans_cross_axi_arburst_arlen_axi3                                                        = new({tname,"trans_cross_axi_arburst_arlen_axi3 "});
        trans_cross_axi_arburst_arlen_axi4                                                        = new({tname,"trans_cross_axi_arburst_arlen_axi4 "});
		trans_cross_axi_arburst_arlen_axi4_lite                                                   = new({tname,"trans_cross_axi_arburst_arlen_axi4_lite"});
		trans_cross_axi_arburst_arqos_ace                                                         = new({tname,"trans_cross_axi_arburst_arqos_ace"});
		trans_cross_axi_arburst_arqos_axi4                                                        = new({tname,"trans_cross_axi_arburst_arqos_axi4"});
		trans_cross_axi_arburst_axi3_ace_arlen_ace_araddr_ace                                     = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_ace_araddr_ace"});
		trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_exclusive_not_axi3                      = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_exclusive_not_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_no_exclusive_not_axi3                   = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_ace_arlock_no_exclusive_not_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_all                                      = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_all"});
		trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_no_exclusive                             = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_ace_rresp_no_exclusive"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_exclusive_axi3                         = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_exclusive_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_exclusive_axi3                      = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_exclusive_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_locked_axi3                         = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi3_arlock_no_locked_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi3_rresp_all                                     = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi3_rresp_all"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_araddr_axi3_axi4                              = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi4_araddr_axi3_axi4"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_exlusive_not_axi3                      = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_exlusive_not_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_no_exclusive_not_axi3                  = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi4_arlock_no_exclusive_not_axi3"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_all                                     = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_all"});
		trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_no_exclusive                            = new({tname,"trans_cross_axi_arburst_axi3_ace_arlen_axi4_rresp_no_exclusive"});
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_araddr_axi3_axi4                        = new({tname,"trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_araddr_axi3_axi4"});
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_exclusive_not_axi3               = new({tname,"trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_exclusive_not_axi3"});
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_no_exclusive_not_axi3            = new({tname,"trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_arlock_no_exclusive_not_axi3"});
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_all                               = new({tname,"trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_all"});
		trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_no_exclusive                      = new({tname,"trans_cross_axi_arburst_axi4_lite_arlen_axi4_lite_rresp_no_exclusive"});
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_ace                        = new({tname,"trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_ace"});
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi3                       = new({tname,"trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi3"});
		trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi4                       = new({tname,"trans_cross_axi_arcache_modifiable_bit_read_unaligned_transfer_axi4"});
		trans_cross_axi_atomictype_bresp_exclusive_ace                                            = new({tname,"trans_cross_axi_atomictype_bresp_exclusive_ace"});
		trans_cross_axi_atomictype_bresp_exclusive_axi3_axi4                                      = new({tname,"trans_cross_axi_atomictype_bresp_exclusive_axi3_axi4"});
		trans_cross_axi_atomictype_bresp_exclusive_axi4lite                                       = new({tname,"trans_cross_axi_atomictype_bresp_exclusive_axi4lite"});
		trans_cross_axi_atomictype_bresp_locked_axi3                                              = new({tname,"trans_cross_axi_atomictype_bresp_locked_axi3"});
		trans_cross_axi_atomictype_bresp_locked_exclusive_axi3                                    = new({tname,"trans_cross_axi_atomictype_bresp_locked_exclusive_axi3"});
		trans_cross_axi_atomictype_bresp_normal_ace                                               = new({tname,"trans_cross_axi_atomictype_bresp_normal_ace"});
		trans_cross_axi_atomictype_bresp_normal_axi3                                              = new({tname,"trans_cross_axi_atomictype_bresp_normal_axi3"});
		trans_cross_axi_atomictype_exclusive_arcache_exclusive_ace                                = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_exclusive_ace"});
		trans_cross_axi_atomictype_exclusive_arcache_exclusive_axi3_axi4                          = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_exclusive_axi3_axi4"});
		trans_cross_axi_atomictype_exclusive_arcache_locked_axi3                                  = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_locked_axi3"});
		trans_cross_axi_atomictype_exclusive_arcache_locked_exclusive_axi3                        = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_locked_exclusive_axi3"});
		trans_cross_axi_atomictype_exclusive_arcache_normal_ace                                   = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_normal_ace"});
		trans_cross_axi_atomictype_exclusive_arcache_normal_axi3                                  = new({tname,"trans_cross_axi_atomictype_exclusive_arcache_normal_axi3"});
		trans_cross_axi_atomictype_exclusive_awcache_exclusive_ace                                = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_exclusive_ace"});
		trans_cross_axi_atomictype_exclusive_awcache_exclusive_axi3_axi4                          = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_exclusive_axi3_axi4"});
		trans_cross_axi_atomictype_exclusive_awcache_locked_axi3                                  = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_locked_axi3"});
		trans_cross_axi_atomictype_exclusive_awcache_locked_exclusive_axi3                        = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_locked_exclusive_axi3"});
		trans_cross_axi_atomictype_exclusive_awcache_normal_ace                                   = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_normal_ace"});
		trans_cross_axi_atomictype_exclusive_awcache_normal_axi3                                  = new({tname,"trans_cross_axi_atomictype_exclusive_awcache_normal_axi3"});
		trans_cross_axi_atomictype_rresp_exclusive_ace                                            = new({tname,"trans_cross_axi_atomictype_rresp_exclusive_ace"});
		trans_cross_axi_atomictype_rresp_exclusive_axi3_axi4                                      = new({tname,"trans_cross_axi_atomictype_rresp_exclusive_axi3_axi4"});
		trans_cross_axi_atomictype_rresp_exclusive_axi4lite                                       = new({tname,"trans_cross_axi_atomictype_rresp_exclusive_axi4lite"});
		trans_cross_axi_atomictype_rresp_locked_axi3                                              = new({tname,"trans_cross_axi_atomictype_rresp_locked_axi3"});
		trans_cross_axi_atomictype_rresp_locked_exclusive_axi3                                    = new({tname,"trans_cross_axi_atomictype_rresp_locked_exclusive_axi3"});
		trans_cross_axi_atomictype_rresp_normal_ace                                               = new({tname,"trans_cross_axi_atomictype_rresp_normal_ace"});
		trans_cross_axi_atomictype_rresp_normal_axi3                                              = new({tname,"trans_cross_axi_atomictype_rresp_normal_axi3"});
		trans_cross_axi_awburst_awlen_ace                                                         = new({tname,"trans_cross_axi_awburst_awlen_ace"});
		trans_cross_axi_awburst_awlen_awaddr_awsize_ace                                           = new({tname,"trans_cross_axi_awburst_awlen_awaddr_awsize_ace"});
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi3                                          = new({tname,"trans_cross_axi_awburst_awlen_awaddr_awsize_axi3"});
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi4                                          = new({tname,"trans_cross_axi_awburst_awlen_awaddr_awsize_axi4"});
		trans_cross_axi_awburst_awlen_awaddr_awsize_axi4_lite                                     = new({tname,"trans_cross_axi_awburst_awlen_awaddr_awsize_axi4_lite"});
		trans_cross_axi_awburst_awlen_awcache_ace                                                 = new({tname,"trans_cross_axi_awburst_awlen_awcache_ace"});
		trans_cross_axi_awburst_awlen_awcache_axi4                                                = new({tname,"trans_cross_axi_awburst_awlen_awcache_axi4"});
		trans_cross_axi_awburst_awlen_awcache_axi4_lite                                           = new({tname,"trans_cross_axi_awburst_awlen_awcache_axi4_lite"});
		trans_cross_axi_awburst_awlen_awprot_ace                                                  = new({tname,"trans_cross_axi_awburst_awlen_awprot_ace"});
		trans_cross_axi_awburst_awlen_awprot_axi4                                                 = new({tname,"trans_cross_axi_awburst_awlen_awprot_axi4"});
		trans_cross_axi_awburst_awlen_awprot_axi4_lite                                            = new({tname,"trans_cross_axi_awburst_awlen_awprot_axi4_lite"});
		trans_cross_axi_awburst_awlen_awsize_ace                                                  = new({tname,"trans_cross_axi_awburst_awlen_awsize_ace"});
		trans_cross_axi_awburst_awlen_awsize_axi3                                                 = new({tname,"trans_cross_axi_awburst_awlen_awsize_axi3"});
		trans_cross_axi_awburst_awlen_awsize_axi4                                                 = new({tname,"trans_cross_axi_awburst_awlen_awsize_axi4"});
		trans_cross_axi_awburst_awlen_awsize_axi4_lite                                            = new({tname,"trans_cross_axi_awburst_awlen_awsize_axi4_lite"});
		trans_cross_axi_awburst_awlen_axi4                                                        = new({tname,"trans_cross_axi_awburst_awlen_axi4"});
        trans_cross_axi_awburst_awlen_axi4_lite                                                   = new({tname,"trans_cross_axi_awburst_awlen_axi4_lite"});
		trans_cross_axi_awburst_awqos_ace                                                         = new({tname,"trans_cross_axi_awburst_awqos_ace"});
		trans_cross_axi_awburst_awqos_axi4                                                        = new({tname,"trans_cross_axi_awburst_awqos_axi4"});
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awaddr_ace                                     = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_ace_awaddr_ace"});
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_exclusive_not_axi3                      = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_exclusive_not_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_no_exclusive_not_axi3                   = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_ace_awlock_no_exclusive_not_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_all                                      = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_all"});
		trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_no_exclusive                             = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_ace_bresp_no_exclusive"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_exclusive_axi3                         = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_exclusive_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_exclusive_axi3                      = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_exclusive_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_locked_axi3                         = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi3_awlock_no_locked_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi3_bresp_all                                     = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi3_bresp_all"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awaddr_axi3_axi4                              = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi4_awaddr_axi3_axi4"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_exlusive_not_axi3                      = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_exlusive_not_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_no_exclusive_not_axi3                  = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi4_awlock_no_exclusive_not_axi3"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_all                                     = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_all"});
		trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_no_exclusive                            = new({tname,"trans_cross_axi_awburst_axi3_ace_awlen_axi4_bresp_no_exclusive"});
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awaddr_axi3_axi4                        = new({tname,"trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awaddr_axi3_axi4"});
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_exclusive_not_axi3               = new({tname,"trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_exclusive_not_axi3"});
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_no_exclusive_not_axi3            = new({tname,"trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_awlock_no_exclusive_not_axi3"});
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_all                               = new({tname,"trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_all"});
		trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_no_exclusive                      = new({tname,"trans_cross_axi_awburst_axi4_lite_awlen_axi4_lite_bresp_no_exclusive"});
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_ace                       = new({tname,"trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_ace"});
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi3                      = new({tname,"trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi3"});
		trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi4                      = new({tname,"trans_cross_axi_awcache_modifiable_bit_write_unaligned_transfer_axi4"});
		trans_cross_axi_read_narrow_transfer_arlen_araddr_ace                                     = new({tname,"trans_cross_axi_read_narrow_transfer_arlen_araddr_ace"});
		trans_cross_axi_read_narrow_transfer_arlen_araddr_axi3                                    = new({tname,"trans_cross_axi_read_narrow_transfer_arlen_araddr_axi3"});
		trans_cross_axi_read_narrow_transfer_arlen_araddr_axi4                                    = new({tname,"trans_cross_axi_read_narrow_transfer_arlen_araddr_axi4"});
		trans_cross_axi_read_unaligned_transfer_ace                                               = new({tname,"trans_cross_axi_read_unaligned_transfer_ace"});
		trans_cross_axi_read_unaligned_transfer_axi3                                              = new({tname,"trans_cross_axi_read_unaligned_transfer_axi3"});
		trans_cross_axi_read_unaligned_transfer_axi4                                              = new({tname,"trans_cross_axi_read_unaligned_transfer_axi4"});
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_ace                                    = new({tname,"trans_cross_axi_write_narrow_transfer_awlen_awaddr_ace"});
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi3                                   = new({tname,"trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi3"});
		trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi4                                   = new({tname,"trans_cross_axi_write_narrow_transfer_awlen_awaddr_axi4"});
		trans_cross_axi_write_strobes                                                             = new({tname,"trans_cross_axi_write_strobes"});
		trans_cross_axi_write_unaligned_transfer_ace                                              = new({tname,"trans_cross_axi_write_unaligned_transfer_ace"});
		trans_cross_axi_write_unaligned_transfer_axi3                                             = new({tname,"trans_cross_axi_write_unaligned_transfer_axi3"});
		trans_cross_axi_write_unaligned_transfer_axi4                                             = new({tname,"trans_cross_axi_write_unaligned_transfer_axi4"});
		trans_cross_master_to_slave_path_access_axi3                                              = new({tname,"trans_cross_master_to_slave_path_access_axi3"});
		trans_cross_master_to_slave_path_access_axi4                                              = new({tname,"trans_cross_master_to_slave_path_access_axi4"});
    endfunction

    //function void build_phase(uvm_phase phase);
    //    super.build_phase(phase);
    //    if(!uvm_config_db#(tcnt_axi_cfg)::get(this,"","cfg",cfg))
    //        `uvm_fatal(tname,"failed to get cfg through uvm_config_db")        
    //endfunction    
endclass


`endif
