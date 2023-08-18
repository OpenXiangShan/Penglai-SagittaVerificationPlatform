`ifndef TCNT_AXI_MASTER_AGENT_DRIVER__SV
`define TCNT_AXI_MASTER_AGENT_DRIVER__SV

`define     TCNT_AXI_DRV_CB this.vif.axi_master_cb
class tcnt_axi_master_agent_driver  extends tcnt_driver_base#(virtual tcnt_axi_interface,tcnt_axi_cfg,tcnt_axi_xaction);
    
    tcnt_axi_xaction        awaddr_tr_q[$] ;
    tcnt_axi_xaction        wdata_tr_q[$] ;
    tcnt_axi_xaction        araddr_tr_q[$] ;
    tcnt_axi_xaction        write_outstanding_tr_q[$] ;
    tcnt_axi_xaction        read_outstanding_tr_q[$] ;
    
    int                     read_outstanding_xact_cnt ;
    int                     write_outstanding_xact_cnt ;
    bit                     max_write_outstanding_xact_status ;
    bit                     max_read_outstanding_xact_status ;
    bit                     rready_status ;
    bit                     bready_status ;
    mailbox                 data_before_addr_mbx ;
    mailbox                 data_after_addr_mbx ;

    `uvm_component_utils(tcnt_axi_master_agent_driver)
    `uvm_register_cb(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback) 

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    //extern task main_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_pkt(tcnt_axi_xaction tr);
    extern task get_cmd();
    extern task send_cmd();
    extern task send_awaddr_valid();
    extern task send_wdata_valid();
    extern task send_bready_rec_bresp();
    extern task send_araddr_valid();
    extern task send_rready_rec_rresp();
    extern task drive_idle(tcnt_dec_base::drv_mode_e drv_mode);
    extern virtual task bus_width_proc(ref tcnt_axi_xaction xact);
    extern task awaddr_single_reset_proc();
    extern task wdata_single_reset_proc();
    extern task bready_single_reset_proc();
    extern task araddr_single_reset_proc();
    extern task rready_single_reset_proc();
    extern task wait_syn_dereset_proc();
endclass:tcnt_axi_master_agent_driver

function tcnt_axi_master_agent_driver::new(string name, uvm_component parent);
    super.new(name,parent);

    data_before_addr_mbx = new() ;
    data_after_addr_mbx = new() ;

endfunction:new

function void tcnt_axi_master_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase 

task tcnt_axi_master_agent_driver::run_phase(uvm_phase phase);

    super.run_phase(phase);

    `uvm_info(get_type_name(), $sformatf("default_rready = %0d, default_bready = %0d, num_write_outstanding_xact = %0d", cfg.default_rready, cfg.default_bready, cfg.num_write_outstanding_xact),UVM_LOW)
    //reset
    this.drive_idle(this.cfg.drv_mode);
    `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_reset(this, vif))
    wait(vif.aresetn == 1'b1);
    `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_reset(this, vif))
    `uvm_info(get_type_name(), "reset_phase done.",UVM_DEBUG)
    
    //driving
    fork
        get_cmd() ;
        send_cmd() ;
    join


endtask:run_phase 

task tcnt_axi_master_agent_driver::reset_phase(uvm_phase phase);

    super.reset_phase(phase);

endtask:reset_phase 
/*
task tcnt_axi_master_agent_driver::main_phase(uvm_phase phase);

    tcnt_axi_xaction    drv_tr ;

    super.main_phase(phase);

    //fork
    //    get_cmd() ;
    //    send_cmd() ;
    //join
endtask:main_phase 
*/

task tcnt_axi_master_agent_driver::get_cmd();
    
    tcnt_axi_xaction tr ;
    
    while(1) begin
        fork
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                seq_item_port.get_next_item(req);

                if(!$cast(tr, req))begin
                    `uvm_fatal("tcnt driver", "Unable to $cast req to drv_tr") ;
                end
                tr.field_print() ;
                bus_width_proc(tr) ;
                if(tr.xact_type == tcnt_axi_dec::WRITE)begin

                    awaddr_tr_q.push_back(tr) ;
                    wdata_tr_q.push_back(tr) ;
                end
                else if(tr.xact_type == tcnt_axi_dec::READ)begin
                    araddr_tr_q.push_back(tr) ;
                end
                //`uvm_info(get_type_name(), $sformatf("awaddr_tr_q.size = 0x%0h, wdata_tr_q.size = 0x%0h, araddr_tr_q.size = 0x%0h", awaddr_tr_q.size(),wdata_tr_q.size(),araddr_tr_q.size()), UVM_LOW) ;
                seq_item_port.item_done();
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            awaddr_tr_q.delete() ;
            wdata_tr_q.delete() ;
            araddr_tr_q.delete() ;
            data_before_addr_mbx = new() ;
            data_after_addr_mbx = new() ;
        end
        wait_syn_dereset_proc() ;
    end

endtask:get_cmd

task tcnt_axi_master_agent_driver::send_cmd();

    fork
        send_awaddr_valid() ; 
        send_wdata_valid() ; 
        send_bready_rec_bresp() ;
        send_araddr_valid() ; 
        send_rready_rec_rresp() ;
    join

endtask:send_cmd

task tcnt_axi_master_agent_driver::send_pkt(tcnt_axi_xaction tr);

endtask:send_pkt

task tcnt_axi_master_agent_driver::send_awaddr_valid();

    tcnt_axi_xaction tr ;
    tcnt_axi_xaction data_after_addr_tr ;
    tcnt_axi_xaction data_before_addr_tr ;
    int              data_after_addr_tr_cnt ;
    int              data_before_addr_tr_cnt ;
    int              awaddr_tr_cnt ;

    
    while(1) begin
        fork 
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                //`uvm_info(get_type_name(), $sformatf("awaddr_tr_q.size = 0x%0h", awaddr_tr_q.size()), UVM_DEBUG) ;
                if(max_write_outstanding_xact_status == 1'b1) begin 
                    @`TCNT_AXI_DRV_CB;
                end
                else begin
                    if(awaddr_tr_q.size() > 0) begin
                        tr = awaddr_tr_q.pop_front() ;
                        /**
                        * @data_before_addr
                        * when data_before_addr is set to 1, it means that the first data will start before address for a write transactions.
                        * wait data_before_addr_event, if wdata and awaddr are from a transaction with same id, then after delay awvalid_delay, 
                        * driver awvalid of address to 1, or generate a error. get a data_before_addr transaction from data_before_addr_mbx
                        */
                        if(tr.data_before_addr == 1'b1) begin
                            data_before_addr_mbx.get(data_before_addr_tr) ;
                            data_before_addr_tr_cnt ++ ;
                            //`uvm_info(get_type_name(), $sformatf("get NO.%0d data_before_addr_tr into data_before_addr_mbx", data_before_addr_tr_cnt), UVM_LOW) ;
                            if(tr.id != data_before_addr_tr.id) begin
                                `uvm_error(get_type_name(), $sformatf("when data_before_addr is set to 1, current awaddr with id(0x%0h) is not match current wdata with id(0x%0h)", tr.id, data_before_addr_tr.id)) ;
                            end
                        end
                        repeat(tr.addr_valid_delay) @`TCNT_AXI_DRV_CB;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_drive_awvalid(this,tr, vif))
                        `TCNT_AXI_DRV_CB.awvalid  <= 1'b1               ;
                        `TCNT_AXI_DRV_CB.awaddr   <= tr.addr            ;
                        `TCNT_AXI_DRV_CB.awburst  <= tr.burst_type      ;
                        `TCNT_AXI_DRV_CB.awlen    <= tr.burst_length -1 ;
                        `TCNT_AXI_DRV_CB.awsize   <= tr.burst_size      ;
                        `TCNT_AXI_DRV_CB.awid     <= tr.id              ;
                        `TCNT_AXI_DRV_CB.awregion <= tr.region          ;
                        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
                            `TCNT_AXI_DRV_CB.awlock   <= tr.atomic_type     ;
                        end
                        else begin //if(cfg.axi_interface_type == tcnt_axi_dec::AXI4) begin
                            `TCNT_AXI_DRV_CB.awlock[0]   <= tr.atomic_type     ;
                        end
                        `TCNT_AXI_DRV_CB.awcache  <= tr.cache_type      ;
                        `TCNT_AXI_DRV_CB.awprot   <= tr.prot_type       ;
                        `TCNT_AXI_DRV_CB.awqos    <= tr.qos             ;
                        `TCNT_AXI_DRV_CB.awuser   <= tr.addr_user       ;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_drive_awvalid(this,tr, vif))
                        awaddr_tr_cnt ++ ;
                        //`uvm_info(get_type_name(), $sformatf("send NO.%0d awaddr_tr with addr = 0x%0h, awid(0x%0h), len = 0x%0h", awaddr_tr_cnt, tr.addr, tr.id, tr.burst_length), UVM_LOW) ;

                        /**
                        * @data_after_addr
                        * when data_before_addr is set to 0, it means that write data will start after address for a write transactions.
                        * after driver awvalid to 1, put this transaction into mailbox  
                        */
                        if(tr.data_before_addr == 1'b0) begin
                            data_after_addr_tr = tr ;
                            data_after_addr_mbx.put(data_after_addr_tr) ;
                            data_after_addr_tr_cnt ++ ;
                            //`uvm_info(get_type_name(), $sformatf("put NO.%0d data_after_addr_tr into data_after_addr_mbx", data_after_addr_tr_cnt), UVM_LOW) ;
                        end

                        write_outstanding_tr_q.push_back(tr) ;
                        if(write_outstanding_tr_q.size() == cfg.num_write_outstanding_xact) begin
                            max_write_outstanding_xact_status = 1'b1 ;
                        end
                        //`uvm_info(get_type_name(), $sformatf("write_outstanding_tr_q.size = 0x%0h", write_outstanding_tr_q.size()), UVM_DEBUG) ;

                        while(1) begin
                             @`TCNT_AXI_DRV_CB;
                            if(`TCNT_AXI_DRV_CB.awready == 1'b1) begin
                                break ;
                            end
                        end
                        `TCNT_AXI_DRV_CB.awvalid  <= 1'b0            ;
                    end
                    else begin
                        @`TCNT_AXI_DRV_CB;
                    end
                end
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            awaddr_single_reset_proc() ;
            data_after_addr_tr_cnt = 0 ;
            data_before_addr_tr_cnt = 0 ;
            awaddr_tr_cnt = 0 ;
        end
        wait_syn_dereset_proc() ;
    end

endtask:send_awaddr_valid

task tcnt_axi_master_agent_driver::send_wdata_valid();
    
    tcnt_axi_xaction tr ;
    tcnt_axi_xaction data_before_addr_tr ;
    tcnt_axi_xaction data_after_addr_tr ;
    int              data_before_addr_tr_cnt ;
    int              data_after_addr_tr_cnt ;
    int              wdata_tr_cnt ;
    bit[`TCNT_AXI_WR_MAX_REGSLICE_SIZE-1:0] regslice_wready ;

    while(1) begin
        fork
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                //`uvm_info(get_type_name(), $sformatf("wdata_tr_q.size = 0x%0h", wdata_tr_q.size()), UVM_DEBUG) ;
                if(wdata_tr_q.size() > 0) begin
                    tr = wdata_tr_q.pop_front() ;
                    //`uvm_info(get_type_name(), $sformatf("wdata_tr with addr= 0x%0h, awid(0x%0h), len = 0x%0h", tr.addr, tr.id, tr.burst_length), UVM_LOW) ;
                    if(tr.data_before_addr == 1'b1) begin
                        //only parallelly show the condition of data_before_addr with data_after_addr, turn to @data_before_addr in this task
                    end
                    else begin
                        /**
                        * @data_after_addr
                        * when data_before_addr is set to 0, it means that write data will start after address for a write transactions.
                        * it must wait write data handshake of previous transactions, also wait awvalid of awaddr, then driver write data 
                        * with wvalid_delay[] for current transactions. wait for getting a awvalid of transaction with same id from mailbox
                        */
                        data_after_addr_mbx.get(data_after_addr_tr) ;
                        data_after_addr_tr_cnt ++ ;
                        //`uvm_info(get_type_name(), $sformatf("get NO.%0d data_after_addr_tr from data_after_addr_mbx", data_after_addr_tr_cnt), UVM_LOW) ;
                        if(tr.id != data_after_addr_tr.id) begin
                            `uvm_error(get_type_name(), $sformatf("when data_before_addr is set to 0, current awaddr with id(0x%0h) is not match current wdata with id(0x%0h)", tr.id, data_after_addr_tr.id)) ;
                        end
                    end
                    for(int i=0; i<tr.burst_length; i++)begin
                        //`uvm_info(get_type_name(), $sformatf("send NO.%0d wdata_tr with addr= 0x%0h, awid(0x%0h), len = 0x%0h, wdata[%0d] = 0x%0h, wvalid_delay[%0d] = 0x%0h", i, tr.addr, tr.id, tr.burst_length, i, tr.data[i], i, tr.wvalid_delay[i]), UVM_LOW) ;
                        repeat(tr.wvalid_delay[i]) @`TCNT_AXI_DRV_CB;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_drive_wvalid(this,tr, vif))
                        `TCNT_AXI_DRV_CB.wvalid <= 1'b1     ;
                        `TCNT_AXI_DRV_CB.non_wvalid <= (cfg.regslice_en == 1'b1) ? (cfg.wr_all_one>>1) : 'h0 ;
                        `TCNT_AXI_DRV_CB.wdata  <= tr.data[i] ;
                        `TCNT_AXI_DRV_CB.wstrb  <= tr.wstrb[i] ;
                        //`uvm_info(get_type_name(), $sformatf("send NO.%0d wdata_tr with addr= 0x%0h, awid(0x%0h), len = 0x%0h, wdata[%0d] = 0x%0h, wvalid_delay[%0d] = 0x%0h", wdata_tr_cnt, tr.addr, tr.id, tr.burst_length, i, tr.data[i], i, tr.wvalid_delay[i]), UVM_LOW) ;
                        if(i == (tr.burst_length -1))begin
                            `TCNT_AXI_DRV_CB.wlast  <= 1'b1        ;
                            //`uvm_info(get_type_name(), $sformatf("send NO.%0d wdata_tr last with addr= 0x%0h, awid(0x%0h), len = 0x%0h, wdata[%0d] = 0x%0h", wdata_tr_cnt, tr.addr, tr.id, tr.burst_length, i, tr.data[i]), UVM_LOW) ;
                        end
                        else begin
                            `TCNT_AXI_DRV_CB.wlast  <= 1'b0        ;
                        end
                        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
                            `TCNT_AXI_DRV_CB.wid    <= tr.id       ;  
                        end
                        `TCNT_AXI_DRV_CB.wuser  <= tr.data_user[i] ;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_drive_wvalid(this,tr, vif))
                        /**
                        * @data_before_addr
                        * when data_before_addr is set to 1, it means that the first data will start before address for a write transactions.
                        * it must wait wvalid of the first data, then generate a data_before_addr_event of event. awaddr with same transactions must wait this 
                        * data_before_addr_event, then after delay awvalid_delay, driver awvalid of address to 1. put this transaction into mailbox
                        */
                        if(i == 0) begin
                            if(tr.data_before_addr == 1'b1) begin
                                data_before_addr_tr = tr ;
                                data_before_addr_mbx.put(data_before_addr_tr) ;
                                data_before_addr_tr_cnt ++ ;
                                //`uvm_info(get_type_name(), $sformatf("put NO.%0d data_before_addr_tr into data_before_addr_mbx", data_before_addr_tr_cnt), UVM_LOW) ;
                            end
                            wdata_tr_cnt ++ ;
                            //`uvm_info(get_type_name(), $sformatf("send NO.%0d wdata_tr with addr = 0x%0h, awid(0x%0h), len = 0x%0h, wdata[%0d] = 0x%0h", wdata_tr_cnt, tr.addr, tr.id, tr.burst_length, i, tr.data[i]), UVM_LOW) ;
                        end

                        while(1) begin
                            @`TCNT_AXI_DRV_CB;
                            //if(`TCNT_AXI_DRV_CB.wready == 1'b1) begin
                            if(cfg.regslice_en == 1'b1) begin
                                for(int i=0; i<cfg.wr_regslice_size; i++) begin
                                    if(i == 0) begin
                                        regslice_wready[i] =  `TCNT_AXI_DRV_CB.wready ;
                                    end
                                    else begin
                                        regslice_wready[i] =  `TCNT_AXI_DRV_CB.non_wready[i-1] ;
                                    end
                                end
                            end
                            //if((`TCNT_AXI_DRV_CB.wready == 1'b1 && cfg.regslice_en == 1'b0) || ({`TCNT_AXI_DRV_CB.non_wready, `TCNT_AXI_DRV_CB.wready}  == cfg.wr_all_one && cfg.regslice_en == 1'b1)) begin
                            if((`TCNT_AXI_DRV_CB.wready == 1'b1 && cfg.regslice_en == 1'b0) || (regslice_wready == cfg.wr_all_one && cfg.regslice_en == 1'b1)) begin
                                break ;
                            end
                        end
                        `TCNT_AXI_DRV_CB.wvalid <= 1'b0     ;
                        `TCNT_AXI_DRV_CB.non_wvalid <= 'h0 ; 
                        `TCNT_AXI_DRV_CB.wstrb  <= 'h0 ;
                    end
                end
                else begin
                    @`TCNT_AXI_DRV_CB;
                end
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            wdata_single_reset_proc() ;
            data_after_addr_tr_cnt = 0 ;
            data_before_addr_tr_cnt = 0 ;
            wdata_tr_cnt = 0 ;
        end
        wait_syn_dereset_proc() ;
    end

endtask:send_wdata_valid

task tcnt_axi_master_agent_driver::send_bready_rec_bresp();
    
    tcnt_axi_xaction tr ;
    tcnt_axi_xaction bready_tr ;
    bit     match_en ;
    bit     rand_value ;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]    bid ;
    int     idx ;
    
    while(1) begin
        fork
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                /**
                * @groupname axi3_4_delays
                * when default_bready is 0, this member defines the BREADY signal delay in number of clock
                * cycles, bready wait  bvalid to be asserted
                * when default_bready is 1, this member defines the number of clock cycles for which BREADY
                * signal should be deasserted after each handshake, before pulling it up
                * again to its default value.
                */
                
                `TCNT_AXI_DRV_CB.bready <= cfg.default_bready ;
                if(`TCNT_AXI_DRV_CB.bvalid == 1'b1) begin
                    for(int i=0; i<cfg.id_width; i++) begin
                        bid[i]    = `TCNT_AXI_DRV_CB.bid[i] ;
                    end

                    if(write_outstanding_tr_q.size == 0) begin
                        `uvm_error(get_type_name(), "there is a error: bvalid is sent before awaddr or wdata") ;
                    end
                    else begin
                        foreach(write_outstanding_tr_q[i]) begin
                            if(bid == write_outstanding_tr_q[i].id) begin
                                match_en = 1'b1 ;
                                bready_tr = write_outstanding_tr_q[i] ;
                                idx = i ;
                                break ;
                            end
                        end
                        if(match_en == 1'b0) begin
                            `uvm_error(get_type_name(), $sformatf("there is a error: bid(0x%0h) is not match awid", bid)) ;
                        end
                        else begin
                            if(cfg.default_bready == 0) begin
                                `TCNT_AXI_DRV_CB.bready <= 1'b0 ;
                                repeat(bready_tr.bready_delay) @`TCNT_AXI_DRV_CB;
                                `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_drive_bready(this,tr, vif))
                                `TCNT_AXI_DRV_CB.bready <= 1'b1 ;
                                `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_drive_bready(this,tr, vif))
                                //bready_status = 1'b1 ;
                                @`TCNT_AXI_DRV_CB;
                                `TCNT_AXI_DRV_CB.bready <= 1'b0 ;
                                //wait for checking next bvalid by every cycle
                                /**
                                * default_bready = 0
                                *                             |--bready delay--|                              
                                *                                               ___                 ___ 
                                * bready   _____________________________________|  |________________|  |_______________
                                *                          ________________________              ______ 
                                * bvalid   ________________|                       |_____________|     |_______________
                                */
                            end
                            if(bid != `TCNT_AXI_DRV_CB.bid) begin
                                `uvm_error(get_type_name(), $sformatf("this bid(0x%0h) is not keeped as the last bid(0x%0h) before bready asserted", `TCNT_AXI_DRV_CB.bid, bid)) ;
                            end
                            else begin
                                write_outstanding_tr_q[idx].id        = bid ;
                                write_outstanding_tr_q[idx].bresp     = tcnt_axi_dec::resp_type_enum'(`TCNT_AXI_DRV_CB.bresp) ;
                                for(int i=0; i<cfg.resp_user_width; i++) begin
                                    write_outstanding_tr_q[idx].resp_user[i] = `TCNT_AXI_DRV_CB.buser[i] ;
                                end

                                tr = write_outstanding_tr_q[idx] ;
                                write_outstanding_tr_q.delete(idx) ;
                                if(write_outstanding_tr_q.size() < cfg.num_write_outstanding_xact) begin
                                    max_write_outstanding_xact_status = 1'b0 ;
                                end
                                if(!$cast(rsp, tr))begin
                                    `uvm_fatal("tcnt driver", "Unable to $cast tcnt write transaction to rsp") ;
                                end
                                rsp.set_sequence_id(bready_tr.get_sequence_id());
                                seq_item_port.put(rsp) ;
                            end
                            if(cfg.default_bready == 1) begin
                                `TCNT_AXI_DRV_CB.bready <= 1'b0 ;
                                repeat(bready_tr.bready_delay) @`TCNT_AXI_DRV_CB;
                                `TCNT_AXI_DRV_CB.bready <= 1'b1 ;
                                //wait for next handshake with bvalid by every cycle
                                /**
                                * default_bready = 1
                                *                            |---bready delay----|
                                * bready   __________________                    ___                     ___             ____________________ 
                                *                            |___________________|  |____________________|  |____________|  
                                *                          __              _________                     ___ 
                                * bvalid   ________________| |_____________|        |____________________|  |________________________________
                                */
                            end
                            match_en = 1'b0 ;
                        end
                    end
                end
                @`TCNT_AXI_DRV_CB;
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            bready_single_reset_proc() ;
            foreach(write_outstanding_tr_q[i]) begin
                tr = write_outstanding_tr_q[i] ;
                if(!$cast(rsp, tr))begin
                    `uvm_fatal("tcnt driver", "Unable to $cast tcnt write transaction to rsp") ;
                end
                seq_item_port.put(rsp) ;
            end
            write_outstanding_tr_q.delete() ;
            max_write_outstanding_xact_status = 0 ;
            bready_status = 0 ;
        end
        wait_syn_dereset_proc() ;
    end



endtask:send_bready_rec_bresp

task tcnt_axi_master_agent_driver::send_araddr_valid();

    tcnt_axi_xaction tr ;

    
    while(1) begin
        fork
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                //`uvm_info(get_type_name(), $sformatf("araddr_tr_q.size = 0x%0h", araddr_tr_q.size()), UVM_DEBUG) ;
                if(max_read_outstanding_xact_status == 1'b1) begin 
                    @`TCNT_AXI_DRV_CB;
                end
                else begin
                    if(araddr_tr_q.size() > 0) begin
                        tr = araddr_tr_q.pop_front() ;
                        repeat(tr.addr_valid_delay) @`TCNT_AXI_DRV_CB;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_drive_arvalid(this,tr, vif))
                        `TCNT_AXI_DRV_CB.arvalid  <= 1'b1               ;
                        `TCNT_AXI_DRV_CB.araddr   <= tr.addr            ;
                        `TCNT_AXI_DRV_CB.arburst  <= tr.burst_type      ;
                        `TCNT_AXI_DRV_CB.arlen    <= tr.burst_length -1 ;
                        `TCNT_AXI_DRV_CB.arsize   <= tr.burst_size      ;
                        `TCNT_AXI_DRV_CB.arid     <= tr.id              ;
                        `TCNT_AXI_DRV_CB.arregion <= tr.region          ;
                        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
                            `TCNT_AXI_DRV_CB.arlock   <= tr.atomic_type     ;
                        end
                        else begin //if(cfg.axi_interface_type == tcnt_axi_dec::AXI4) begin
                            `TCNT_AXI_DRV_CB.arlock[0]   <= tr.atomic_type     ;
                        end
                        `TCNT_AXI_DRV_CB.arcache  <= tr.cache_type      ;
                        `TCNT_AXI_DRV_CB.arprot   <= tr.prot_type       ;
                        `TCNT_AXI_DRV_CB.arqos    <= tr.qos             ;
                        `TCNT_AXI_DRV_CB.aruser   <= tr.addr_user       ;
                        `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_drive_arvalid(this,tr, vif))
                        
                        tr.data      = new[tr.burst_length] ;
                        tr.data_user = new[tr.burst_length] ;
                        tr.rresp     = new[tr.burst_length] ;
                        read_outstanding_tr_q.push_back(tr) ;
                        if(read_outstanding_tr_q.size() == cfg.num_read_outstanding_xact) begin
                            max_read_outstanding_xact_status = 1'b1 ;
                        end
                        //`uvm_info(get_type_name(), $sformatf("read_outstanding_tr_q.size = 0x%0h", read_outstanding_tr_q.size()), UVM_DEBUG) ;

                        while(1) begin
                             @`TCNT_AXI_DRV_CB;
                            if(`TCNT_AXI_DRV_CB.arready == 1'b1) begin
                                break ;
                            end
                        end
                        `TCNT_AXI_DRV_CB.arvalid  <= 1'b0            ;
                    end
                    else begin
                        @`TCNT_AXI_DRV_CB;
                    end
                end
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            araddr_single_reset_proc() ;
        end
        wait_syn_dereset_proc() ;

    end

endtask:send_araddr_valid

task tcnt_axi_master_agent_driver::send_rready_rec_rresp();
    
    tcnt_axi_xaction                    tr ;
    tcnt_axi_xaction                    rready_tr ;
    bit                                 match_en ;
    bit [`TCNT_AXI_MAX_ID_WIDTH-1:0]    rid ;
    bit                                 rlast ;
    int                                 cnt ; 
    bit                                 rand_value ;
    int                                 idx ;
    bit[`TCNT_AXI_RD_MAX_REGSLICE_SIZE-1:0] regslice_rvalid ;

    while(1) begin
        fork
            begin
                wait(vif.aresetn == 1'b0);
            end
            begin
                /**
                * @groupname axi3_4_delays
                * when default_rready is 0, this member defines the RREADY signal delay in number of clock
                * cycles, rready wait  bvalid to be asserted
                * when default_bready is 1, this member defines the number of clock cycles for which RREADY
                * signal should be deasserted after each handshake, before pulling it up
                * again to its default value.
                */
                
                `TCNT_AXI_DRV_CB.rready <= cfg.default_rready ;
                if(cfg.regslice_en == 1'b1) begin
                    for(int k=0; k<(cfg.rd_regslice_size-1); k++)begin
                        `TCNT_AXI_DRV_CB.non_rready[k] <= cfg.default_rready    ;
                    end
                end
                else begin
                     `TCNT_AXI_DRV_CB.non_rready <= 'h0   ;
                end
                if(cfg.regslice_en == 1'b1) begin
                    for(int i=0; i<cfg.rd_regslice_size; i++) begin
                        if(i == 0) begin
                            regslice_rvalid[i] =  `TCNT_AXI_DRV_CB.rvalid ;
                        end
                        else begin
                            regslice_rvalid[i] =  `TCNT_AXI_DRV_CB.non_rvalid[i-1] ;
                        end
                    end
                end
                //if(`TCNT_AXI_DRV_CB.rvalid == 1'b1) begin
                //if((`TCNT_AXI_DRV_CB.rvalid == 1'b1 && cfg.regslice_en == 1'b0) || ({`TCNT_AXI_DRV_CB.non_rvalid, `TCNT_AXI_DRV_CB.rvalid} == cfg.rd_all_one && cfg.regslice_en == 1'b1)) begin
                if((`TCNT_AXI_DRV_CB.rvalid == 1'b1 && cfg.regslice_en == 1'b0) || (regslice_rvalid == cfg.rd_all_one && cfg.regslice_en == 1'b1)) begin
                    for(int i=0; i<cfg.id_width; i++) begin
                        rid[i]    = `TCNT_AXI_DRV_CB.rid[i] ;
                    end
                    rlast  = `TCNT_AXI_DRV_CB.rlast ;

                    if(read_outstanding_tr_q.size == 0) begin
                        `uvm_error(get_type_name(), "there is a error: rvalid is sent before araddr") ;
                    end
                    else begin
                        foreach(read_outstanding_tr_q[i]) begin
                            if(rid == read_outstanding_tr_q[i].id) begin
                                match_en = 1'b1 ;
                                rready_tr = read_outstanding_tr_q[i] ;
                                read_outstanding_tr_q[i].id = rid ;
                                cnt = read_outstanding_tr_q[i].data_beat_cnt ;
                                idx = i ;
                                //`uvm_info(get_type_name(), $sformatf("read_outstanding_tr_q[%0d].data_beat_cnt = %0d, cnt = %0d rid = %0d", i, read_outstanding_tr_q[i].data_beat_cnt, cnt, rid),UVM_DEBUG);
                                break ;
                            end
                        end
                        if(match_en == 1'b0) begin
                            `uvm_error(get_type_name(), "there is a error: rid is not match arid") ;
                        end
                        else begin
                            if(cfg.default_rready == 0) begin
                                `TCNT_AXI_DRV_CB.rready <= 1'b0 ;
                                `TCNT_AXI_DRV_CB.non_rready <= 'h0 ; 
                                repeat(rready_tr.rready_delay[cnt]) @`TCNT_AXI_DRV_CB;
                                //`uvm_info(get_type_name(), $sformatf("rready_tr.rready_delay[%0d] = 0d%0d, rid = 0x%0h", cnt, rready_tr.rready_delay[cnt] ,rid), UVM_DEBUG);
                                `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,pre_drive_rready(this,tr, vif))
                                `TCNT_AXI_DRV_CB.rready <= 1'b1 ;
                                `TCNT_AXI_DRV_CB.non_rready <= (cfg.regslice_en == 1'b1) ? (cfg.rd_all_one>>1) : 'h0 ;
                                `uvm_do_callbacks(tcnt_axi_master_agent_driver,tcnt_axi_master_agent_driver_callback,post_drive_rready(this,tr, vif))
                                //rready_status = 1'b1 ;
                                @`TCNT_AXI_DRV_CB;
                                `TCNT_AXI_DRV_CB.rready <= 1'b0 ;
                                `TCNT_AXI_DRV_CB.non_rready <= 'h0 ; 
                                //wait for checking next rvalid by every cycle
                                /**
                                * default_rready = 0
                                *                             |--rready delay--|                              
                                *                                               ___                 ___ 
                                * rready   _____________________________________|  |________________|  |_______________
                                *                          ________________________              ______ 
                                * rvalid   ________________|                       |_____________|     |_______________
                                */

                            end
                            if(rid != `TCNT_AXI_DRV_CB.rid) begin
                                `uvm_error(get_type_name(), $sformatf("this rid(0x%0h) is not keeped as the last rid(0x%0h) before rready asserted", `TCNT_AXI_DRV_CB.rid, rid)) ;
                            end
                            else begin
                                //`uvm_info(get_type_name(), $sformatf("read_outstanding_tr_q[%0d].data_beat_cnt = %0d, cnt = %0d rid = %0d", idx, read_outstanding_tr_q[idx].data_beat_cnt, cnt, rid),UVM_DEBUG);
                                for(int i=0; i<cfg.data_width; i++) begin
                                    read_outstanding_tr_q[idx].data[cnt][i]      = `TCNT_AXI_DRV_CB.rdata[i]  ;
                                end
                                for(int i=0; i<cfg.data_user_width; i++) begin
                                    read_outstanding_tr_q[idx].data_user[cnt][i] = `TCNT_AXI_DRV_CB.ruser[i]  ;
                                end
                                read_outstanding_tr_q[idx].rresp[cnt]     = tcnt_axi_dec::resp_type_enum'(`TCNT_AXI_DRV_CB.rresp)  ;
                                read_outstanding_tr_q[idx].data_beat_cnt ++ ;
                                //`uvm_info(get_type_name(), $sformatf("read_outstanding_tr_q[%0d].data_beat_cnt = %0d, rid = %0d", idx, read_outstanding_tr_q[idx].data_beat_cnt, rid),UVM_DEBUG);
                                if(rlast == 1'b1) begin
                                    if(read_outstanding_tr_q[idx].data_beat_cnt != read_outstanding_tr_q[idx].burst_length) begin
                                        `uvm_error(get_type_name(), $sformatf("there is a error: transaction's burst_length(0x%0h) is not match its data size(0x%0h) with ID(0x%0h)", read_outstanding_tr_q[idx].burst_length, read_outstanding_tr_q[idx].data_beat_cnt, rid)) ;
                                    end
                                    tr = read_outstanding_tr_q[idx] ;
                                    read_outstanding_tr_q.delete(idx) ;
                                    if(read_outstanding_tr_q.size() < cfg.num_read_outstanding_xact) begin
                                        max_read_outstanding_xact_status = 1'b0 ;
                                    end
                                    if(!$cast(rsp, tr))begin
                                        `uvm_fatal("tcnt driver", "Unable to $cast tcnt read transaction to rsp") ;
                                    end
                                    seq_item_port.put(rsp) ;
                                end
                            end
                            if(cfg.default_rready == 1) begin
                                `TCNT_AXI_DRV_CB.rready <= 1'b0 ;
                                `TCNT_AXI_DRV_CB.non_rready <= 'h0 ; 
                                repeat(rready_tr.rready_delay[cnt]) @`TCNT_AXI_DRV_CB;
                                `TCNT_AXI_DRV_CB.rready <= 1'b1 ;
                                `TCNT_AXI_DRV_CB.non_rready <= (cfg.regslice_en == 1'b1) ? (cfg.rd_all_one>>1) : 'h0 ;
                                //wait for next handshake with rvalid by every cycle
                                /**
                                * default_rready = 1
                                *                            |---rready delay----|
                                * rready   __________________                    ___                     ___             ____________________ 
                                *                            |___________________|  |____________________|  |____________|  
                                *                          __              _________                     ___ 
                                * rvalid   ________________| |_____________|        |____________________|  |________________________________
                                */

                            end
                            match_en = 1'b0 ;
                        end
                    end
                end
                @`TCNT_AXI_DRV_CB;  
            end
        join_any
        disable fork ;
        if(vif.aresetn == 1'b0) begin
            rready_single_reset_proc() ;
            foreach(read_outstanding_tr_q[i]) begin
            tr = read_outstanding_tr_q[i] ;
            if(!$cast(rsp, tr))begin
                    `uvm_fatal("tcnt driver", "Unable to $cast tcnt write transaction to rsp") ;
                end
                seq_item_port.put(rsp) ;
            end
            read_outstanding_tr_q.delete() ;
            max_read_outstanding_xact_status = 0 ;
            rready_status = 0 ;
        end
        wait_syn_dereset_proc() ;
    end



endtask:send_rready_rec_rresp

task tcnt_axi_master_agent_driver::drive_idle(tcnt_dec_base::drv_mode_e drv_mode);
    
        //awaddr channel
        vif.awvalid  <= 'h0 ;
        vif.awaddr   <= 'h0 ;
        vif.awburst  <= 'h0 ;
        vif.awlen    <= 'h0 ;
        vif.awsize   <= 'h0 ;
        vif.awid     <= 'h0 ;
        vif.awregion <= 'h0 ;
        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
            vif.awlock   <= 'h0 ;
        end
        else begin
            vif.awlock[`TCNT_AXI_LOCK_WIDTH-1:1]   <= 'hz ;
            vif.awlock[0]   <= 'h0 ;
        end
        vif.awcache  <= 'h0 ;
        vif.awprot   <= 'h0 ;
        vif.awqos    <= 'h0 ;
        vif.awuser   <= 'h0 ;

        //wdata channel
        vif.wvalid   <= 'h0 ; 
        vif.non_wvalid <= 'h0 ; 
        vif.wdata    <= 'h0 ; 
        vif.wstrb    <= 'h0 ; 
        vif.wlast    <= 'h0 ; 
        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
            vif.wid      <= 'h0 ; 
        end
        else begin
            vif.wid      <= 'hz ; 
        end
        vif.wuser    <= 'h0 ; 

        //bresp channel
        vif.bready   <= cfg.default_bready ; 
        bready_status = cfg.default_bready ;

        //araddr channel
        //`TCNT_AXI_DRV_CB.arvalid  <= 'h0 ;
        vif.arvalid  <= 'h0 ;
        vif.araddr   <= 'h0 ;
        vif.arburst  <= 'h0 ;
        vif.arlen    <= 'h0 ;
        vif.arsize   <= 'h0 ;
        vif.arid     <= 'h0 ;
        vif.arregion <= 'h0 ;
        if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
            vif.arlock   <= 'h0 ;
        end
        else begin
            vif.arlock[`TCNT_AXI_LOCK_WIDTH-1 :1]   <= 'hz ;
            vif.arlock[0]   <= 'h0 ;
        end
        vif.arcache  <= 'h0 ;
        vif.arprot   <= 'h0 ;
        vif.arqos    <= 'h0 ;
        vif.aruser   <= 'h0 ;

        //rdata channel
        vif.rready   <= cfg.default_rready ; 
        if(cfg.regslice_en == 1'b1) begin
            for(int k=0; k<(cfg.rd_regslice_size-1); k++)begin
                vif.non_rready[k] <= cfg.default_rready   ;
            end
        end
        else begin
             vif.non_rready <= 'h0   ;
        end
        rready_status = cfg.default_rready ;
    /*
    if(drv_mode==tcnt_dec_base::DRV_0) begin
    end
    else if(drv_mode==tcnt_dec_base::DRV_1) begin

    end
    else if(drv_mode==tcnt_dec_base::DRV_X) begin

    end
    else if(drv_mode==tcnt_dec_base::DRV_RAND) begin

    end
    else if(drv_mode==tcnt_dec_base::DRV_LST) begin
    end
    */
    

endtask:drive_idle

task tcnt_axi_master_agent_driver::bus_width_proc(ref tcnt_axi_xaction xact);

    tcnt_axi_xaction                    tr ;
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]  aligned_addr ;
    int                                 burst_bit_size ;
    int                                 burst_byte_size ;
    int                                 unaligned_idx ;
    int                                 beat_narrow_num ;
    int                                 beat_narrow_idx ;
    int                                 beat_narrow_start ;
    int                                 narrow_size ;
    int                                 kk ;
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]  wrap_beat_addr ;  //wrap current address
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]  wrap_max_addr ;  
    bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0]  wrap_boundary ;
    int                                 wrap_boundary_idx ;
    
    tr = tcnt_axi_xaction::type_id::create("tr") ;
    
    for(int i=0; i<cfg.addr_width ; i++) begin
        tr.addr[i] = xact.addr[i] ;                 
    end
    for(int i=0; i<cfg.addr_user_width ; i++) begin
        tr.addr_user[i] = xact.addr_user[i] ;            
    end
    for(int i=0; i<cfg.id_width ; i++) begin
        tr.id[i]   = xact.id[i] ;                   
    end

    if(xact.xact_type == tcnt_axi_dec::WRITE)begin
        tr.data_user = new[xact.burst_length];
        //foreach(tr.data_user[i]) begin
        //    for(int j=0; j<cfg.data_user_width ; j++) begin
        //        tr.data_user[i][j] = xact.data_user[i][j] ;            
        //    end
        //end

        case(xact.burst_size) 
            BURST_SIZE_8BIT     : burst_bit_size = 8 ;
            BURST_SIZE_16BIT    : burst_bit_size = 16 ;
            BURST_SIZE_32BIT    : burst_bit_size = 32 ;
            BURST_SIZE_64BIT    : burst_bit_size = 64 ;
            BURST_SIZE_128BIT   : burst_bit_size = 128 ;
            BURST_SIZE_256BIT   : burst_bit_size = 256 ;
            BURST_SIZE_512BIT   : burst_bit_size = 512 ;
            BURST_SIZE_1024BIT  : burst_bit_size = 1024 ;
            BURST_SIZE_2048BIT  : burst_bit_size = 2048 ;
        endcase
        tr.data  = new[xact.burst_length] ;
        tr.wstrb = new[xact.burst_length] ;
        burst_byte_size = cfg.data_width/8 ;
        unaligned_idx  = tr.addr%burst_byte_size ;   
        aligned_addr    = tr.addr - unaligned_idx ;   

        if(burst_bit_size > cfg.data_width) begin
            `uvm_error(get_type_name(), $sformatf("burst size(%0d) is bigger than data_width(%0d)", burst_bit_size, cfg.data_width)) ;
        end
        else if(burst_bit_size == cfg.data_width) begin
            //`uvm_info(get_type_name(), "equal data width transfer", UVM_LOW) ;
            //burst_byte_size = cfg.data_width/8 ;
            //unaligned_idx  = tr.addr%burst_byte_size ;   
            //aligned_addr    = tr.addr - unaligned_idx ;   
            if(xact.burst_type == tcnt_axi_dec::FIXED)begin
                for(int i=0; i<xact.burst_length; i++) begin
                    //tr.data[i][(burst_bit_size-1):unaligned_idx*8] = xact.data[i][(burst_bit_size-unaligned_idx*8-1):0] ;
                    //tr.wstrb[i][burst_byte_size:unaligned_idx] = {(burst_byte_size-unaligned_idx){1}};
                    for(int j=0; j<(burst_byte_size-unaligned_idx) ; j++) begin
                        kk = j + unaligned_idx ;
                        tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                        tr.wstrb[i][kk] = xact.wstrb[i][j]; //1'b1;
                        tr.data_user[i][kk] = xact.data_user[i][j]; 
                    end
                end
            end
            else begin
                for(int i=0; i<xact.burst_length; i++) begin
                    //tr.data[i][(burst_bit_size-1):unaligned_idx*8] = xact.data[i][(burst_bit_size-unaligned_idx*8-1):0] ;
                    //tr.wstrb[i][burst_byte_size:unaligned_idx] = {(burst_byte_size-unaligned_idx){1}};
                    if(i == 0) begin
                        for(int j=0; j<(burst_byte_size-unaligned_idx) ; j++) begin
                            kk = j + unaligned_idx ;
                            tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                            tr.wstrb[i][kk] = xact.wstrb[i][kk]; //1'b1;
                            tr.data_user[i][kk] = xact.data_user[i][kk]; 
                        end
                    end
                    //tr.data[i][(burst_bit_size-1):0] = xact.data[i][(burst_bit_size-1):0] ;
                    //tr.wstrb[i][burst_byte_size:0] = {(burst_byte_size){1}};
                    else begin
                        for(int j=0; j<burst_byte_size ; j++) begin
                            tr.data[i][8*j+:8] = xact.data[i][8*j+:8] ;
                            tr.wstrb[i][j] = xact.wstrb[i][j]; //1'b1;
                            tr.data_user[i][j] = xact.data_user[i][j]; 
                        end
                    end
                end
            end
        end
        else begin
            //`uvm_info(get_type_name(), "narrow data width transfer", UVM_LOW) ;
            //burst_byte_size = cfg.data_width/8 ;
            //unaligned_idx  = tr.addr%burst_byte_size ;   
            //aligned_addr    = tr.addr - unaligned_idx ;   
            beat_narrow_num = cfg.data_width/burst_bit_size ;
            narrow_size     = burst_bit_size/8 ;
            beat_narrow_idx = unaligned_idx/narrow_size ;
            beat_narrow_start = unaligned_idx%narrow_size ;

            if(xact.burst_type == tcnt_axi_dec::FIXED) begin
                for(int i=0; i<xact.burst_length; i++) begin
                    //tr.data[i][(beat_narrow_idx+1)*narrow_size*8 : (beat_narrow_idx*narrow_size +beat_narrow_start)*8] = xact.data[(burst_bit_size-beat_narrow_start*8-1):0] ;
                    //tr.wstrb[i][(beat_narrow_idx+1)*narrow_size : (beat_narrow_idx*narrow_size +beat_narrow_start)] = {(narrow_size-beat_narrow_start){1}};
                    for(int j=0; j<(narrow_size-beat_narrow_start); j++) begin
                        kk = beat_narrow_idx*narrow_size + beat_narrow_start + j ;
                        tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                        tr.wstrb[i][kk] = xact.wstrb[i][j];//1;
                        tr.data_user[i][kk] = xact.data_user[i][j]; 
                    end
                end
            end
            else if(xact.burst_type == tcnt_axi_dec::INCR)begin
                for(int i=0; i<xact.burst_length; i++) begin
                    if(i == 0) begin
                        //tr.data[i][(beat_narrow_idx+1)*narrow_size*8 : (beat_narrow_idx*narrow_size +beat_narrow_start)*8] = xact.data[(burst_bit_size-beat_narrow_start*8-1):0] ;
                        //tr.wstrb[i][(beat_narrow_idx+1)*narrow_size : (beat_narrow_idx*narrow_size +beat_narrow_start)] = {(narrow_size-beat_narrow_start){1}};
                        for(int j=0; j<(narrow_size-beat_narrow_start); j++) begin
                            kk = beat_narrow_idx*narrow_size + beat_narrow_start + j ;
                            tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                            tr.wstrb[i][kk] = xact.wstrb[i][j] ; //1;
                            tr.data_user[i][kk] = xact.data_user[i][j]; 
                        end
                    end
                    else begin
                        if(beat_narrow_idx == (beat_narrow_num -1)) begin
                            beat_narrow_idx = 0 ;
                        end
                        else begin
                            beat_narrow_idx ++ ;
                        end
                        //tr.data[i][(beat_narrow_idx+1)*narrow_size*8 : (beat_narrow_idx*narrow_size)*8] = xact.data[(burst_bit_size-1):0] ;
                        //tr.wstrb[i][(beat_narrow_idx+1)*narrow_size : (beat_narrow_idx*narrow_size)] = {narrow_size{1}};
                        for(int j=0; j<narrow_size; j++) begin
                            kk = beat_narrow_idx*narrow_size + j ;
                            tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                            tr.wstrb[i][kk] = xact.wstrb[i][j];//1;
                            tr.data_user[i][kk] = xact.data_user[i][j]; 
                        end
                    end
                end
            end
            else if(xact.burst_type == tcnt_axi_dec::WRAP) begin
                //narrow_size is burst size(number bytes)
                //the start address must be aligned to the size of each transfer
                //lowest address(wrap boundary) used by the burst is aligned to the total size of the data to be transferred 
                //wrap_boundary = (Start_Address / (Number_Bytes * Burst_Length))*(Number_Bytes * Burst_Length)
                wrap_boundary = (tr.addr/(xact.burst_length*narrow_size))*(xact.burst_length*narrow_size);
                wrap_boundary_idx = (wrap_boundary%burst_byte_size)/narrow_size ;
                //wrap_start_idx = tr.addr/narrow_size;
                wrap_max_addr = wrap_boundary + (xact.burst_length*narrow_size) ;
                wrap_beat_addr = tr.addr ;
                //`uvm_info(get_type_name(), $sformatf("wrap_boundary = 0x%0h, wrap_boundary_idx = %0d, wrap_max_addr = 0x%0h", wrap_boundary, wrap_boundary_idx, wrap_max_addr), UVM_LOW) ;
                for(int i=0; i<xact.burst_length; i++) begin
                    //tr.data[i][(beat_narrow_idx+1)*narrow_size*8 : (beat_narrow_idx*narrow_size)*8] = xact.data[(burst_bit_size-1):0] ;
                    //tr.wstrb[i][(beat_narrow_idx+1)*narrow_size : (beat_narrow_idx*narrow_size)] = {narrow_size{1}};
                    for(int j=0; j<narrow_size; j++) begin
                        kk = beat_narrow_idx*narrow_size + j ;
                        tr.data[i][8*kk+:8] = xact.data[i][8*j+:8] ;
                        tr.wstrb[i][kk] = xact.wstrb[i][j];//1;
                        tr.data_user[i][kk] = xact.data_user[i][j]; 
                    end
                    //get next address and idx
                    wrap_beat_addr = wrap_beat_addr + narrow_size ;
                    //`uvm_info(get_type_name(), $sformatf("NO.%0d wrap_addr = 0x%0h", i, wrap_beat_addr), UVM_LOW) ;
                    if(wrap_beat_addr == wrap_max_addr) begin
                        wrap_beat_addr = wrap_boundary ;
                        beat_narrow_idx = wrap_boundary_idx ;
                        //`uvm_info(get_type_name(), $sformatf("turn to boundary, wrap_beat_addr  0x%0h, beat_narrow_idx = %0d", wrap_beat_addr, beat_narrow_idx), UVM_LOW) ;
                    end
                    else if(beat_narrow_idx == (beat_narrow_num -1)) begin
                        beat_narrow_idx = 0 ;
                    end
                    else begin
                        beat_narrow_idx ++ ;
                    end
                    //`uvm_info(get_type_name(), $sformatf("next beat_narrow_idx = %0d",beat_narrow_idx), UVM_LOW) ;
                end
            end
        end
        
        foreach(xact.data[i]) begin
            xact.data[i] = tr.data[i] ;
        end
        foreach(xact.wstrb[i]) begin
            xact.wstrb[i] = tr.wstrb[i] ;
        end
        foreach(xact.data_user[i]) begin
            xact.data_user[i] = tr.data_user[i] ;
        end
    end

    xact.addr = tr.addr ;
    xact.addr_user = tr.addr_user ;
    xact.id = tr.id ;

endtask:bus_width_proc

task tcnt_axi_master_agent_driver::awaddr_single_reset_proc();
    
    //awaddr channel
    vif.awvalid  <= 'h0 ;
    vif.awaddr   <= 'h0 ;
    vif.awburst  <= 'h0 ;
    vif.awlen    <= 'h0 ;
    vif.awsize   <= 'h0 ;
    vif.awid     <= 'h0 ;
    vif.awregion <= 'h0 ;
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        vif.awlock   <= 'h0 ;
    end
    else begin
        vif.awlock[`TCNT_AXI_LOCK_WIDTH-1:1]   <= 'hz ;
        vif.awlock[0]   <= 'h0 ;
    end
    vif.awcache  <= 'h0 ;
    vif.awprot   <= 'h0 ;
    vif.awqos    <= 'h0 ;
    vif.awuser   <= 'h0 ;
    
    `TCNT_AXI_DRV_CB.awvalid  <= 'h0 ;
    `TCNT_AXI_DRV_CB.awaddr   <= 'h0 ;
    `TCNT_AXI_DRV_CB.awburst  <= 'h0 ;
    `TCNT_AXI_DRV_CB.awlen    <= 'h0 ;
    `TCNT_AXI_DRV_CB.awsize   <= 'h0 ;
    `TCNT_AXI_DRV_CB.awid     <= 'h0 ;
    `TCNT_AXI_DRV_CB.awregion <= 'h0 ;
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        `TCNT_AXI_DRV_CB.awlock   <= 'h0 ;
    end
    else begin
        `TCNT_AXI_DRV_CB.awlock[`TCNT_AXI_LOCK_WIDTH-1:1]   <= 'hz ;
        `TCNT_AXI_DRV_CB.awlock[0]   <= 'h0 ;
    end
    `TCNT_AXI_DRV_CB.awcache  <= 'h0 ;
    `TCNT_AXI_DRV_CB.awprot   <= 'h0 ;
    `TCNT_AXI_DRV_CB.awqos    <= 'h0 ;
    `TCNT_AXI_DRV_CB.awuser   <= 'h0 ;

endtask:awaddr_single_reset_proc

task tcnt_axi_master_agent_driver::wdata_single_reset_proc();
    
    //wdata channel
    
    vif.wvalid   <= 'h0 ; 
    vif.non_wvalid <= 'h0 ; 
    vif.wdata    <= 'h0 ; 
    vif.wstrb    <= 'h0 ; 
    vif.wlast    <= 'h0 ; 
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        vif.wid      <= 'h0 ; 
    end
    else begin
        vif.wid      <= 'hz ; 
    end
    vif.wuser    <= 'h0 ; 
    
    `TCNT_AXI_DRV_CB.wvalid   <= 'h0 ; 
    `TCNT_AXI_DRV_CB.non_wvalid <= 'h0 ; 
    `TCNT_AXI_DRV_CB.wdata    <= 'h0 ; 
    `TCNT_AXI_DRV_CB.wstrb    <= 'h0 ; 
    `TCNT_AXI_DRV_CB.wlast    <= 'h0 ; 
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        `TCNT_AXI_DRV_CB.wid      <= 'h0 ; 
    end
    else begin
        `TCNT_AXI_DRV_CB.wid      <= 'hz ; 
    end
    `TCNT_AXI_DRV_CB.wuser    <= 'h0 ; 
    
endtask:wdata_single_reset_proc

task tcnt_axi_master_agent_driver::bready_single_reset_proc();
    
    //bresp channel
    vif.bready   <= cfg.default_bready ; 
    bready_status = cfg.default_bready ;

    `TCNT_AXI_DRV_CB.bready   <= cfg.default_bready ; 

endtask:bready_single_reset_proc

task tcnt_axi_master_agent_driver::araddr_single_reset_proc();
    
    //araddr channel
    vif.arvalid  <= 'h0 ;
    vif.araddr   <= 'h0 ;
    vif.arburst  <= 'h0 ;
    vif.arlen    <= 'h0 ;
    vif.arsize   <= 'h0 ;
    vif.arid     <= 'h0 ;
    vif.arregion <= 'h0 ;
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        vif.arlock   <= 'h0 ;
    end
    else begin
        vif.arlock[`TCNT_AXI_LOCK_WIDTH-1 :1]   <= 'hz ;
        vif.arlock[0]   <= 'h0 ;
    end
    vif.arcache  <= 'h0 ;
    vif.arprot   <= 'h0 ;
    vif.arqos    <= 'h0 ;
    vif.aruser   <= 'h0 ;
    
    `TCNT_AXI_DRV_CB.arvalid  <= 'h0 ;
    `TCNT_AXI_DRV_CB.araddr   <= 'h0 ;
    `TCNT_AXI_DRV_CB.arburst  <= 'h0 ;
    `TCNT_AXI_DRV_CB.arlen    <= 'h0 ;
    `TCNT_AXI_DRV_CB.arsize   <= 'h0 ;
    `TCNT_AXI_DRV_CB.arid     <= 'h0 ;
    `TCNT_AXI_DRV_CB.arregion <= 'h0 ;
    if(cfg.axi_interface_type == tcnt_axi_dec::AXI3) begin
        `TCNT_AXI_DRV_CB.arlock   <= 'h0 ;
    end
    else begin
        `TCNT_AXI_DRV_CB.arlock[`TCNT_AXI_LOCK_WIDTH-1 :1]   <= 'hz ;
        `TCNT_AXI_DRV_CB.arlock[0]   <= 'h0 ;
    end
    `TCNT_AXI_DRV_CB.arcache  <= 'h0 ;
    `TCNT_AXI_DRV_CB.arprot   <= 'h0 ;
    `TCNT_AXI_DRV_CB.arqos    <= 'h0 ;
    `TCNT_AXI_DRV_CB.aruser   <= 'h0 ;

endtask:araddr_single_reset_proc

task tcnt_axi_master_agent_driver::rready_single_reset_proc();
    
        //rdata channel
        vif.rready   <= cfg.default_rready ; 
        for(int k=0; k<(cfg.rd_regslice_size-1); k++)begin
            vif.non_rready[k] <= cfg.default_rready   ;
        end
        rready_status = cfg.default_rready ;

        `TCNT_AXI_DRV_CB.rready   <= cfg.default_rready ; 
        for(int k=0; k<(cfg.rd_regslice_size-1); k++)begin
            `TCNT_AXI_DRV_CB.non_rready[k] <= cfg.default_rready   ;
        end


endtask:rready_single_reset_proc

task tcnt_axi_master_agent_driver::wait_syn_dereset_proc();
    
    while(1) begin
        if(vif.aresetn == 1'b1) begin
            break ;
        end
        @`TCNT_AXI_DRV_CB;  
    end

endtask:wait_syn_dereset_proc
`endif

