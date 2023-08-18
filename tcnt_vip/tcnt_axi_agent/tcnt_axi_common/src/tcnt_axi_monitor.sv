`ifndef TCNT_AXI_MONITOR__SV
`define TCNT_AXI_MONITOR__SV

`define     TCNT_AXI_MON_CB vif.axi_monitor_cb

class tcnt_axi_monitor  extends tcnt_monitor_base#(virtual tcnt_axi_interface,tcnt_axi_cfg,tcnt_axi_xaction);

    `uvm_component_utils(tcnt_axi_monitor)
    uvm_analysis_port #(tcnt_axi_xaction)  to_slave_sequencer_port;
    typedef tcnt_axi_xaction tcnt_axi_xaction_queue[$];
    //protected tcnt_axi_xaction_queue m_xaction_realtime_q[tcnt_axi_dec::xact_type_enum];
    tcnt_axi_xaction_queue m_xaction_realtime_q[tcnt_axi_dec::xact_type_enum];
    int  wdata_handshake_cnt = 0;

    string tname = "";

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    //extern virtual task main_phase(uvm_phase phase);
    extern virtual task monitor_transaction();
    extern virtual task monitor_awvalid();
    extern virtual task monitor_wvalid();
    extern virtual task monitor_non_wvalid();
    extern virtual task monitor_bvalid();
    extern virtual task monitor_arvalid();
    extern virtual task monitor_rvalid();
    extern virtual task monitor_non_rvalid();
    extern virtual task monitor_wr_transaction();
    extern virtual task monitor_rd_transaction();
    extern virtual function void clear_counter_and_buffer();
    extern virtual task monitor_reset_handle();
    extern virtual task send_to_slave_sequencer_port(ref tcnt_axi_xaction xact);
    extern virtual function int get_idx_of_first_accepted_tr_of_id(input tcnt_axi_dec::xact_type_enum tr_type,input logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] id);
    extern virtual function int get_idx_of_first_unaccepted_addr_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    extern virtual function int get_idx_of_first_unaccepted_data_tr(input tcnt_axi_dec::xact_type_enum tr_type);
endclass:tcnt_axi_monitor

function tcnt_axi_monitor::new(string name, uvm_component parent);
    super.new(name,parent);
    tname = get_name();
endfunction:new 

function void tcnt_axi_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    to_slave_sequencer_port = new("to_slave_sequencer_port",this);
endfunction:build_phase
/*
task tcnt_axi_monitor::main_phase(uvm_phase phase);
    super.main_phase(phase);
    //this.monitor_transaction();
endtask
*/
task tcnt_axi_monitor::run_phase(uvm_phase phase);

    fork
        super.run_phase(phase);
        this.monitor_transaction();
    join

endtask:run_phase

function void tcnt_axi_monitor::clear_counter_and_buffer();
    `uvm_info(tname,"clear counters and buffers in monitor",UVM_LOW)
    m_xaction_realtime_q.delete();
    wdata_handshake_cnt = 0;
endfunction

task tcnt_axi_monitor::monitor_reset_handle();
    //wait(vif.aresetn === 1'b0);
    `uvm_info(tname,"got reset...",UVM_LOW)
    clear_counter_and_buffer();
    wait(vif.aresetn === 1'b1);
    `uvm_info(tname,"reset deasserted...",UVM_LOW)
    @vif.axi_monitor_cb;
endtask

task tcnt_axi_monitor::send_to_slave_sequencer_port(ref tcnt_axi_xaction xact);
    if(cfg.axi_port_kind == tcnt_axi_dec::AXI_SLAVE)begin
        to_slave_sequencer_port.write(xact);// send for driving
        `uvm_info(tname,{"send to slave sequencer:\n",xact.sprint()},UVM_DEBUG)
    end
endtask

function int tcnt_axi_monitor::get_idx_of_first_accepted_tr_of_id(input tcnt_axi_dec::xact_type_enum tr_type,input logic[`TCNT_AXI_MAX_ID_WIDTH-1:0] id);
    if(m_xaction_realtime_q[tr_type].size() == 0)
        return -1;
    else begin
        if(tr_type == tcnt_axi_dec::WRITE) begin
            foreach(m_xaction_realtime_q[tr_type][idx])begin
                // data before addr, data_status is not initial,addr_status is initial
                if((m_xaction_realtime_q[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT) &&
                   (m_xaction_realtime_q[tr_type][idx].data_status == tcnt_axi_dec::ACCEPT) &&
                   (m_xaction_realtime_q[tr_type][idx].id          == id))
                    return idx;
            end
        end
        else if(tr_type == tcnt_axi_dec::READ) begin
            foreach(m_xaction_realtime_q[tr_type][idx])begin
                // data before addr, data_status is not initial,addr_status is initial
                if((m_xaction_realtime_q[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT) &&
                   (m_xaction_realtime_q[tr_type][idx].id          == id)) begin
                    return idx;
                end
            end
        end

        return -1;
    end
endfunction

function int tcnt_axi_monitor::get_idx_of_first_unaccepted_data_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    if(m_xaction_realtime_q[tr_type].size() == 0)
        return -1;
    else begin
        foreach(m_xaction_realtime_q[tr_type][idx])begin
            //foreach(m_xaction_realtime_q[tr_type][idx].data_status)begin
                if(m_xaction_realtime_q[tr_type][idx].data_status inside {tcnt_axi_dec::INITIAL,tcnt_axi_dec::ACTIVE,tcnt_axi_dec::PARTIAL_ACCEPT})
                    return idx;
            //end
        end
        return -1;
    end
endfunction

function int tcnt_axi_monitor::get_idx_of_first_unaccepted_addr_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    if(m_xaction_realtime_q[tr_type].size() == 0)
        return -1;
    else begin
        foreach(m_xaction_realtime_q[tr_type][idx])begin
            // data before addr, data_status is not initial,addr_status is initial
            if(m_xaction_realtime_q[tr_type][idx].addr_status inside {tcnt_axi_dec::INITIAL,tcnt_axi_dec::ACTIVE})
                return idx;
        end
        return -1;
    end
endfunction

task tcnt_axi_monitor::monitor_awvalid();
    if(`TCNT_AXI_MON_CB.awvalid == 1'b1)begin
        tcnt_axi_xaction wr_tr;
        int idx = get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::WRITE);
        if(idx == -1) begin
            wr_tr = tcnt_axi_xaction::type_id::create("wr_tr", this);
            `uvm_info(tname,"create wr_tr by awvalid",UVM_DEBUG)
        end else begin
            wr_tr = m_xaction_realtime_q[tcnt_axi_dec::WRITE][idx];
            `uvm_info(tname,"update wr_tr by awvalid",UVM_DEBUG)
        end
        if(wr_tr.addr_status == INITIAL)begin// first time to create by awvalid
            tcnt_axi_cfg port_cfg;
            void'($cast(port_cfg,cfg.clone()));
            wr_tr.xact_type     = tcnt_axi_dec::WRITE;
            wr_tr.cfg           = port_cfg;
            wr_tr.addr          = `TCNT_AXI_MON_CB.awaddr;
            wr_tr.id            = `TCNT_AXI_MON_CB.awid;
            wr_tr.burst_length  = `TCNT_AXI_MON_CB.awlen + 1;
            wr_tr.burst_size    = tcnt_axi_dec::burst_size_enum'(`TCNT_AXI_MON_CB.awsize);
            wr_tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.awburst);
            //wr_tr.addr_valid_assertion_time = $realtime;
            //if(wr_tr.data_status inside {INITIAL,ACTIVE})begin//there's no data_before_addr reveived till now
            if(wr_tr.data.size() == 0)begin
                wr_tr.data          = new[wr_tr.burst_length];
                wr_tr.wstrb         = new[wr_tr.burst_length];
                wr_tr.wready_delay  = new[wr_tr.burst_length];            
                wr_tr.data_user     = new[wr_tr.burst_length];
                wr_tr.data_ready_assertion_time = new[wr_tr.burst_length];            
            end else begin//some data has been reveived before address coming
                wr_tr.data          = new[wr_tr.burst_length](wr_tr.data);
                wr_tr.wstrb         = new[wr_tr.burst_length](wr_tr.wstrb);
                wr_tr.wready_delay  = new[wr_tr.burst_length](wr_tr.wready_delay);                    
                wr_tr.data_user     = new[wr_tr.burst_length](wr_tr.data_user);
                wr_tr.data_ready_assertion_time = new[wr_tr.burst_length](wr_tr.data_ready_assertion_time);            
            end
            if(cfg.awqos_enable)
                wr_tr.qos       = `TCNT_AXI_MON_CB.awqos;
            if(cfg.awuser_enable)
                wr_tr.addr_user = `TCNT_AXI_MON_CB.awuser;
            if(cfg.awlock_enable)
                wr_tr.atomic_type = `TCNT_AXI_MON_CB.awlock;
            if(cfg.awcache_enable)
                wr_tr.cache_type = `TCNT_AXI_MON_CB.awcache;
            if(cfg.awprot_enable)
                wr_tr.prot_type = `TCNT_AXI_MON_CB.awprot;
        end

        if(`TCNT_AXI_MON_CB.awready == 1'b1)begin
            wr_tr.addr_status = tcnt_axi_dec::ACCEPT;
            wr_tr.addr_ready_assertion_time = $realtime;
        end else begin
            wr_tr.addr_status = tcnt_axi_dec::ACTIVE;
        end
        send_to_slave_sequencer_port(wr_tr);
        if(idx == -1)begin
            m_xaction_realtime_q[tcnt_axi_dec::WRITE].push_back(wr_tr);
        end
    end
endtask

task tcnt_axi_monitor::monitor_wvalid();
    //bit last_data_accepted = 1;
    if(`TCNT_AXI_MON_CB.wvalid == 1'b1)begin
        tcnt_axi_xaction wr_tr;
        int idx = get_idx_of_first_unaccepted_data_tr(tcnt_axi_dec::WRITE);
        if(idx == -1) begin
            wr_tr = tcnt_axi_xaction::type_id::create("wr_tr", this);
            wr_tr.data                      = new[`TCNT_AXI_MAX_BURST_LENGTH];
            wr_tr.wstrb                     = new[`TCNT_AXI_MAX_BURST_LENGTH];
            wr_tr.wready_delay              = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            wr_tr.data_user                 = new[`TCNT_AXI_MAX_BURST_LENGTH];
            //wr_tr.data_valid_assertion_time = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            wr_tr.data_ready_assertion_time = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            `uvm_info(tname,"create wr_tr by wvalid",UVM_DEBUG)
        end else begin
            wr_tr = m_xaction_realtime_q[tcnt_axi_dec::WRITE][idx];
            `uvm_info(tname,"update wr_tr by wvalid",UVM_DEBUG)
        end
        
        //if(last_data_accepted)
        //    wr_tr.data_valid_assertion_time[wdata_handshake_cnt] = $realtime;

        if(`TCNT_AXI_MON_CB.wready)begin
            wr_tr.data_status = `TCNT_AXI_MON_CB.wlast == 1'b1 ? tcnt_axi_dec::ACCEPT : tcnt_axi_dec::PARTIAL_ACCEPT;
            wr_tr.data[wdata_handshake_cnt]                      = `TCNT_AXI_MON_CB.wdata;
            wr_tr.data_user[wdata_handshake_cnt]                 = `TCNT_AXI_MON_CB.wuser;
            wr_tr.wstrb[wdata_handshake_cnt]                     = `TCNT_AXI_MON_CB.wstrb;
            wr_tr.data_ready_assertion_time[wdata_handshake_cnt] = $realtime;
            wdata_handshake_cnt++;
            //last_data_accepted = 1;
            if(`TCNT_AXI_MON_CB.wlast)begin
                // delete extra data and data_status when burst length can be guarenteed
                if(wr_tr.addr_status == tcnt_axi_dec::INITIAL)begin
                    wr_tr.wready_delay = new[wdata_handshake_cnt](wr_tr.wready_delay);
                    wr_tr.data         = new[wdata_handshake_cnt](wr_tr.data);
                    wr_tr.wstrb        = new[wdata_handshake_cnt](wr_tr.wstrb);
                    wr_tr.data_user    = new[wdata_handshake_cnt](wr_tr.data_user);
                    //wr_tr.data_valid_assertion_time = new[wdata_handshake_cnt](wr_tr.data_valid_assertion_time);            
                    wr_tr.data_ready_assertion_time = new[wdata_handshake_cnt](wr_tr.data_ready_assertion_time);                    
                end
                send_to_slave_sequencer_port(wr_tr);
                wdata_handshake_cnt = 0;
            end
        end else begin
            //last_data_accepted = 0;
            wr_tr.data_status = tcnt_axi_dec::ACTIVE;
        end

        if(idx == -1)begin
            m_xaction_realtime_q[tcnt_axi_dec::WRITE].push_back(wr_tr);
            send_to_slave_sequencer_port(wr_tr);
        end        
    end
endtask

task tcnt_axi_monitor::monitor_non_wvalid();
    int non_wvalid_size ;
    int non_wready_size ;
    bit[`TCNT_AXI_WR_MAX_REGSLICE_SIZE-1:0] regslice_wready ;
    bit[`TCNT_AXI_WR_MAX_REGSLICE_SIZE-1:0] regslice_wvalid ;

    for(int i=0; i<cfg.wr_regslice_size; i++) begin
        if(i == 0) begin
            regslice_wready[i] =  `TCNT_AXI_MON_CB.wready ;
            regslice_wvalid[i] =  `TCNT_AXI_MON_CB.wvalid ;
        end
        else begin
            regslice_wready[i] =  `TCNT_AXI_MON_CB.non_wready[i-1] ;
            regslice_wvalid[i] =  `TCNT_AXI_MON_CB.non_wvalid[i-1];
        end
    end
    //if({`TCNT_AXI_MON_CB.non_wvalid, `TCNT_AXI_MON_CB.wvalid} == cfg.wr_all_one) begin
    if(regslice_wvalid == cfg.wr_all_one) begin
        tcnt_axi_xaction wr_tr;
        int idx = get_idx_of_first_unaccepted_data_tr(tcnt_axi_dec::WRITE);
        if(idx == -1) begin
            wr_tr = tcnt_axi_xaction::type_id::create("wr_tr", this);
            wr_tr.data                      = new[`TCNT_AXI_MAX_BURST_LENGTH];
            wr_tr.wstrb                     = new[`TCNT_AXI_MAX_BURST_LENGTH];
            wr_tr.wready_delay              = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            wr_tr.data_user                 = new[`TCNT_AXI_MAX_BURST_LENGTH];
            //wr_tr.data_valid_assertion_time = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            wr_tr.data_ready_assertion_time = new[`TCNT_AXI_MAX_BURST_LENGTH];            
            `uvm_info(tname,"create wr_tr by wvalid",UVM_DEBUG)
        end else begin
            wr_tr = m_xaction_realtime_q[tcnt_axi_dec::WRITE][idx];
            `uvm_info(tname,"update wr_tr by wvalid",UVM_DEBUG)
        end
        //if({`TCNT_AXI_MON_CB.non_wready, `TCNT_AXI_MON_CB.wready} == cfg.wr_all_one) begin
        if(regslice_wready == cfg.wr_all_one) begin
            wr_tr.data_status = `TCNT_AXI_MON_CB.wlast == 1'b1 ? tcnt_axi_dec::ACCEPT : tcnt_axi_dec::PARTIAL_ACCEPT;
            wr_tr.data[wdata_handshake_cnt]                      = `TCNT_AXI_MON_CB.wdata;
            wr_tr.data_user[wdata_handshake_cnt]                 = `TCNT_AXI_MON_CB.wuser;
            wr_tr.wstrb[wdata_handshake_cnt]                     = `TCNT_AXI_MON_CB.wstrb;
            wr_tr.data_ready_assertion_time[wdata_handshake_cnt] = $realtime;
            wdata_handshake_cnt++;
            //last_data_accepted = 1;
            if(`TCNT_AXI_MON_CB.wlast)begin
                // delete extra data and data_status when burst length can be guarenteed
                if(wr_tr.addr_status == tcnt_axi_dec::INITIAL)begin
                    wr_tr.wready_delay = new[wdata_handshake_cnt](wr_tr.wready_delay);
                    wr_tr.data         = new[wdata_handshake_cnt](wr_tr.data);
                    wr_tr.wstrb        = new[wdata_handshake_cnt](wr_tr.wstrb);
                    wr_tr.data_user    = new[wdata_handshake_cnt](wr_tr.data_user);
                    //wr_tr.data_valid_assertion_time = new[wdata_handshake_cnt](wr_tr.data_valid_assertion_time);            
                    wr_tr.data_ready_assertion_time = new[wdata_handshake_cnt](wr_tr.data_ready_assertion_time);                    
                end
                send_to_slave_sequencer_port(wr_tr);
                wdata_handshake_cnt = 0;
            end
        end else begin
            //last_data_accepted = 0;
            wr_tr.data_status = tcnt_axi_dec::ACTIVE;
        end

        if(idx == -1)begin
            m_xaction_realtime_q[tcnt_axi_dec::WRITE].push_back(wr_tr);
            send_to_slave_sequencer_port(wr_tr);
        end        
    end

endtask

task tcnt_axi_monitor::monitor_bvalid();
    if(`TCNT_AXI_MON_CB.bvalid)begin
        tcnt_axi_xaction wr_tr;
        logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] bid = `TCNT_AXI_MON_CB.bid;
        int idx = get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::WRITE,bid); 
        if(idx == -1)
            `uvm_error(get_type_name(),$sformatf("bid[0x%0h] not found in front requests.",bid))
        else begin
            wr_tr = m_xaction_realtime_q[tcnt_axi_dec::WRITE][idx];
            //wr_tr.write_resp_valid_assertion_time = $realtime;
            if(`TCNT_AXI_MON_CB.bready == 1'b1)begin
                wr_tr.write_resp_status = tcnt_axi_dec::ACCEPT;
                wr_tr.write_resp_ready_assertion_time = $realtime;
                if(cfg.buser_enable)
                    wr_tr.resp_user = `TCNT_AXI_MON_CB.buser;
                wr_tr.bresp = `TCNT_AXI_MON_CB.bresp;
                foreach(wr_tr.wstrb[i])
                    void'(wr_tr.check_wstrb(i));
            end else begin
                wr_tr.write_resp_status = tcnt_axi_dec::INITIAL;
            end
            if(wr_tr.write_resp_status == tcnt_axi_dec::ACCEPT)begin
                mon_item_port.write(wr_tr);
                `uvm_info(get_type_name(),{"monitor tr : ",wr_tr.sprint()},UVM_DEBUG)
                m_xaction_realtime_q[tcnt_axi_dec::WRITE].delete(idx);
            end
        end
    end
endtask

task tcnt_axi_monitor::monitor_wr_transaction();
    while(1)begin
        fork
            begin
                monitor_awvalid();
                if(cfg.regslice_en == 1'b1) begin
                    monitor_non_wvalid();
                end
                else begin
                    monitor_wvalid();
                end
                monitor_bvalid();
                @`TCNT_AXI_MON_CB;
            end
            wait(vif.aresetn === 1'b0);
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)
            monitor_reset_handle();
    end
endtask

task tcnt_axi_monitor::monitor_rd_transaction();
    while(1)begin
        fork
            begin
                monitor_arvalid();
                if(cfg.regslice_en == 1'b1) begin
                    monitor_non_rvalid();
                end
                else begin
                    monitor_rvalid();
                end
                @`TCNT_AXI_MON_CB;
            end
            wait(vif.aresetn === 1'b0);
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)
            monitor_reset_handle();            
    end
endtask

task tcnt_axi_monitor::monitor_arvalid();

    tcnt_axi_xaction rd_tr;
    int              idx  ;

    if(`TCNT_AXI_MON_CB.arvalid == 1'b1)begin
        idx = get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::READ);
        if(idx == -1) begin
            rd_tr = tcnt_axi_xaction::type_id::create("rd_tr", this);
        end else begin
            rd_tr = m_xaction_realtime_q[tcnt_axi_dec::READ][idx];
        end
        if(rd_tr.addr_status == INITIAL)begin// first time to create by arvalid
            tcnt_axi_cfg port_cfg;
            void'($cast(port_cfg,cfg.clone()));
            rd_tr.xact_type     = tcnt_axi_dec::READ;
            rd_tr.cfg           = port_cfg;
            rd_tr.addr          = `TCNT_AXI_MON_CB.araddr;
            rd_tr.id            = `TCNT_AXI_MON_CB.arid;
            rd_tr.burst_length  = `TCNT_AXI_MON_CB.arlen + 1;
            rd_tr.burst_size    = tcnt_axi_dec::burst_size_enum'(`TCNT_AXI_MON_CB.arsize);
            rd_tr.burst_type    = tcnt_axi_dec::burst_type_enum'(`TCNT_AXI_MON_CB.arburst);
            rd_tr.data          = new[rd_tr.burst_length];
            rd_tr.data_user     = new[rd_tr.burst_length];
            rd_tr.rresp         = new[rd_tr.burst_length];
            rd_tr.rvalid_delay  = new[rd_tr.burst_length];            
            rd_tr.data_ready_assertion_time = new[rd_tr.burst_length];            
            //rd_tr.data_valid_assertion_time = new[rd_tr.burst_length];            
            //rd_tr.addr_valid_assertion_time = $realtime;
            if(cfg.arqos_enable) begin
                rd_tr.qos       = `TCNT_AXI_MON_CB.arqos;
            end
            if(cfg.aruser_enable)
                rd_tr.addr_user = `TCNT_AXI_MON_CB.aruser;
            if(cfg.arlock_enable)
                rd_tr.atomic_type = `TCNT_AXI_MON_CB.arlock;
            if(cfg.arcache_enable)
                rd_tr.cache_type = `TCNT_AXI_MON_CB.arcache;
            if(cfg.arprot_enable)
                rd_tr.prot_type = `TCNT_AXI_MON_CB.arprot;            
        end
        
        if(`TCNT_AXI_MON_CB.arready == 1'b1)begin
            rd_tr.addr_status = tcnt_axi_dec::ACCEPT;
            rd_tr.addr_ready_assertion_time = $realtime;
        end else begin
            rd_tr.addr_status = tcnt_axi_dec::ACTIVE;
        end

        send_to_slave_sequencer_port(rd_tr);
        if(idx == -1)begin
            m_xaction_realtime_q[tcnt_axi_dec::READ].push_back(rd_tr);
        end
    end
endtask

task tcnt_axi_monitor::monitor_rvalid();

    tcnt_axi_xaction rd_tr;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]  rid      ;
    int                                 data_cnt ;
    int                                 idx      ;
    bit                                 last_data_accepted = 1;

    if(`TCNT_AXI_MON_CB.rvalid)begin
        //rd_tr.data_valid_assertion_time[data_cnt] = $realtime;
        if(`TCNT_AXI_MON_CB.rready == 1'b1)begin
            rid = `TCNT_AXI_MON_CB.rid;
            idx = get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::READ,rid); 
            if(idx == -1)
                `uvm_error(get_type_name(),$sformatf("rid[0x%0h] not found in front requests.",rid))
            else begin
                rd_tr = m_xaction_realtime_q[tcnt_axi_dec::READ][idx];
                data_cnt = m_xaction_realtime_q[tcnt_axi_dec::READ][idx].data_beat_cnt;
                rd_tr.data[data_cnt]      = `TCNT_AXI_MON_CB.rdata ;
                rd_tr.data_user[data_cnt] = `TCNT_AXI_MON_CB.ruser ;
                rd_tr.rresp[data_cnt]     = tcnt_axi_dec::resp_type_enum'(`TCNT_AXI_MON_CB.rresp);
                rd_tr.data_ready_assertion_time[data_cnt] = $realtime;
                m_xaction_realtime_q[tcnt_axi_dec::READ][idx].data_beat_cnt++ ;
                last_data_accepted = 1;
                if(`TCNT_AXI_MON_CB.rlast == 1'b1)begin
                    if(data_cnt != (m_xaction_realtime_q[tcnt_axi_dec::READ][idx].burst_length -1)) begin
                        `uvm_error(get_type_name(), $sformatf("there is a error: transaction's burst_length is not match its data size with ID(%0d)", idx)) ;
                    end
                    mon_item_port.write(rd_tr);
                    `uvm_info(get_type_name(),{"monitor tr : ",rd_tr.sprint()},UVM_DEBUG)
                    m_xaction_realtime_q[tcnt_axi_dec::READ].delete(idx);
                end
            end
        end
    end
endtask

task tcnt_axi_monitor::monitor_non_rvalid();

    tcnt_axi_xaction rd_tr;
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0]  rid      ;
    int                                 data_cnt ;
    int                                 idx      ;
    bit                                 last_data_accepted = 1;
    int non_rvalid_size ;
    int non_rready_size ;
    bit[`TCNT_AXI_RD_MAX_REGSLICE_SIZE-1:0] regslice_rready ;
    bit[`TCNT_AXI_RD_MAX_REGSLICE_SIZE-1:0] regslice_rvalid ;

    for(int i=0; i<cfg.rd_regslice_size; i++) begin
        if(i == 0) begin
            regslice_rready[i] =  `TCNT_AXI_MON_CB.rready ;
            regslice_rvalid[i] =  `TCNT_AXI_MON_CB.rvalid ;
        end
        else begin
            regslice_rready[i] =  `TCNT_AXI_MON_CB.non_rready[i-1] ;
            regslice_rvalid[i] =  `TCNT_AXI_MON_CB.non_rvalid[i-1];
        end
    end


    //if({`TCNT_AXI_MON_CB.non_rvalid, `TCNT_AXI_MON_CB.rvalid} == cfg.rd_all_one) begin
    if(regslice_rvalid == cfg.rd_all_one) begin
        //rd_tr.data_valid_assertion_time[data_cnt] = $realtime;
        //if({`TCNT_AXI_MON_CB.non_rready, `TCNT_AXI_MON_CB.rready} == cfg.rd_all_one) begin
        if(regslice_rready == cfg.rd_all_one) begin
            rid = `TCNT_AXI_MON_CB.rid;
            idx = get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::READ,rid); 
            if(idx == -1)
                `uvm_error(get_type_name(),$sformatf("rid[0x%0h] not found in front requests.",rid))
            else begin
                rd_tr = m_xaction_realtime_q[tcnt_axi_dec::READ][idx];
                data_cnt = m_xaction_realtime_q[tcnt_axi_dec::READ][idx].data_beat_cnt;
                rd_tr.data[data_cnt]      = `TCNT_AXI_MON_CB.rdata ;
                rd_tr.data_user[data_cnt] = `TCNT_AXI_MON_CB.ruser ;
                rd_tr.rresp[data_cnt]     = tcnt_axi_dec::resp_type_enum'(`TCNT_AXI_MON_CB.rresp);
                rd_tr.data_ready_assertion_time[data_cnt] = $realtime;
                m_xaction_realtime_q[tcnt_axi_dec::READ][idx].data_beat_cnt++ ;
                last_data_accepted = 1;
                if(`TCNT_AXI_MON_CB.rlast == 1'b1)begin
                    if(data_cnt != (m_xaction_realtime_q[tcnt_axi_dec::READ][idx].burst_length -1)) begin
                        `uvm_error(get_type_name(), $sformatf("there is a error: transaction's burst_length is not match its data size with ID(%0d)", idx)) ;
                    end
                    mon_item_port.write(rd_tr);
                    `uvm_info(get_type_name(),{"monitor tr : ",rd_tr.sprint()},UVM_DEBUG)
                    m_xaction_realtime_q[tcnt_axi_dec::READ].delete(idx);
                end
            end
        end
    end

endtask

task tcnt_axi_monitor::monitor_transaction();
    fork
        monitor_wr_transaction();
        monitor_rd_transaction();
    join
endtask:monitor_transaction

`endif

