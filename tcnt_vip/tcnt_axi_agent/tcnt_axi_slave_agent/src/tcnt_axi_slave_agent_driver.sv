`ifndef TCNT_AXI_SLAVE_AGENT_DRIVER__SV
`define TCNT_AXI_SLAVE_AGENT_DRIVER__SV

class tcnt_axi_slave_agent_driver  extends tcnt_driver_base#(virtual tcnt_axi_interface,tcnt_axi_cfg,tcnt_axi_xaction);
    `uvm_component_utils(tcnt_axi_slave_agent_driver)
    `uvm_register_cb(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback) 

    typedef tcnt_axi_xaction tcnt_axi_xaction_queue[$];
    typedef logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] tcnt_axi_id_queue[$];
    
    protected mailbox#(integer)                     resp_mbx[tcnt_axi_dec::xact_type_enum];
    protected tcnt_axi_xaction_queue                xaction_aa[tcnt_axi_dec::xact_type_enum];
    protected int                                   write_outstanding_cnt,read_outstanding_cnt;
    protected tcnt_axi_id_queue                     reordering_id_queue[tcnt_axi_dec::xact_type_enum];
    protected longint                               cur_timestamp = 0;
    string m_tname = "";

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task wait_reset_deasserted();
    extern task run_phase(uvm_phase phase);
    extern task drive_idle(tcnt_dec_base::drv_mode_e drv_mode);
    extern virtual task get_axi_xaction();
    extern virtual task drive_axi_resp();
    extern virtual task drive_awready();
    extern virtual task drive_arready();
    extern virtual task drive_wready();
    extern virtual task drive_axi_wr_resp();
    extern virtual task drive_axi_rd_resp();
    extern virtual task drive_reset();
    extern virtual task drive_reset_value();
    extern virtual task drive_aw_reset_value();
    extern virtual task drive_ar_reset_value();
    extern virtual task drive_w_reset_value();
    extern virtual task drive_r_reset_value();
    extern virtual task drive_b_reset_value();
    extern virtual task run_timestamp();
    extern virtual function void clear_counter_and_buffer();
    extern virtual task put_seq_resp(tcnt_axi_xaction tr);
    extern virtual function int calc_act_bvalid_delay(tcnt_axi_xaction tr);
    extern virtual function int calc_act_rvalid_delay(tcnt_axi_xaction tr);
    extern virtual function int get_xact_idx_of_unique_id(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid);
    extern virtual task update_addr_status(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid,tcnt_axi_dec::status_enum addr_status);
    extern virtual task update_data_status(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid,tcnt_axi_dec::status_enum data_status);
    extern virtual function void update_reordering_id_queue(input tcnt_axi_dec::xact_type_enum xtype);
    extern virtual function bit is_xact_ready_to_get_response(input tcnt_axi_dec::xact_type_enum tr_type,input int idx);
    extern virtual function int get_idx_of_first_accepted_tr_of_id(input tcnt_axi_dec::xact_type_enum tr_type,input logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] id);
    extern function int get_idx_of_first_unaccepted_data_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    extern function int get_idx_of_first_unaccepted_addr_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    extern virtual function logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] m_get_reordering_result_xact_id(input tcnt_axi_dec::xact_type_enum xtype);
endclass:tcnt_axi_slave_agent_driver

function tcnt_axi_slave_agent_driver::new(string name, uvm_component parent);
    super.new(name,parent);
    m_tname = get_name();
    resp_mbx[tcnt_axi_dec::WRITE] = new();
    resp_mbx[tcnt_axi_dec::READ] = new();
endfunction:new

function void tcnt_axi_slave_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase 

task tcnt_axi_slave_agent_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
endtask

task tcnt_axi_slave_agent_driver::run_timestamp();
    while(1)begin
        @(negedge vif.aclk);
        cur_timestamp++;
    end
endtask

function void tcnt_axi_slave_agent_driver::clear_counter_and_buffer();
    resp_mbx[tcnt_axi_dec::WRITE] = new();
    resp_mbx[tcnt_axi_dec::READ] = new();
    xaction_aa.delete();
    write_outstanding_cnt = 0;
    read_outstanding_cnt = 0;
    reordering_id_queue.delete();
endfunction

task tcnt_axi_slave_agent_driver::drive_aw_reset_value();
    vif.awready    <= cfg.default_awready;
    vif.axi_slave_cb.awready    <= cfg.default_awready;
endtask

task tcnt_axi_slave_agent_driver::drive_w_reset_value();
    vif.wready                  <= cfg.default_wready;
    if(cfg.regslice_en == 1'b1) begin
        for(int k=0; k<(cfg.wr_regslice_size-1); k++)begin
            vif.non_wready[k] <= cfg.default_wready   ;
        end
    end
    else begin
         vif.non_wready <= 'h0   ;
    end
    vif.axi_slave_cb.wready     <= cfg.default_wready;
    if(cfg.regslice_en == 1'b1) begin
        for(int k=0; k<(cfg.wr_regslice_size-1); k++)begin
            vif.axi_slave_cb.non_wready[k] <= cfg.default_wready   ;
        end
    end
    else begin
         vif.axi_slave_cb.non_wready <= 'h0   ;
    end

endtask

task tcnt_axi_slave_agent_driver::drive_b_reset_value();
    vif.bid        <= 0;
    vif.bresp      <= 0;
    vif.bvalid     <= 1'b0;
    if(cfg.buser_enable)
        vif.buser  <= 0;

    vif.axi_slave_cb.bid        <= 0;
    vif.axi_slave_cb.bresp      <= 0;
    vif.axi_slave_cb.bvalid     <= 1'b0;
    if(cfg.buser_enable)
        vif.axi_slave_cb.buser  <= 0;

endtask

task tcnt_axi_slave_agent_driver::drive_ar_reset_value();
    vif.arready    <= cfg.default_arready;
    vif.axi_slave_cb.arready    <= cfg.default_arready;
endtask

task tcnt_axi_slave_agent_driver::drive_r_reset_value();
    vif.rid        <= 0;
    vif.rdata      <= 0;
    vif.rresp      <= 0;
    vif.rlast      <= 0;
    vif.rvalid     <= 0;
    vif.non_rvalid <= 'h0 ; 
    if(cfg.ruser_enable)
        vif.ruser  <= 0;

    vif.axi_slave_cb.rid        <= 0;
    vif.axi_slave_cb.rdata      <= 0;
    vif.axi_slave_cb.rresp      <= 0;
    vif.axi_slave_cb.rlast      <= 0;
    vif.axi_slave_cb.rvalid     <= 0;
    vif.axi_slave_cb.non_rvalid <= 'h0 ; 
    if(cfg.ruser_enable)
        vif.axi_slave_cb.ruser  <= 0;

endtask

task tcnt_axi_slave_agent_driver::drive_reset_value();
    drive_aw_reset_value();
    drive_ar_reset_value();
    drive_w_reset_value();
    drive_r_reset_value();
    drive_b_reset_value();
endtask

task tcnt_axi_slave_agent_driver::wait_reset_deasserted();
    `uvm_info(m_tname,"wait reset start.",UVM_LOW)
    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,pre_reset(this,vif))
    while(vif.aresetn === 1'b0)
        @vif.axi_slave_cb;
    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,post_reset(this,vif))
    `uvm_info(m_tname,"wait reset done.",UVM_LOW)
endtask

task tcnt_axi_slave_agent_driver::drive_reset();
    drive_reset_value();
    clear_counter_and_buffer();
    wait_reset_deasserted();
endtask

task tcnt_axi_slave_agent_driver::put_seq_resp(tcnt_axi_xaction tr);
    if(!$cast(rsp,tr))
        `uvm_fatal(m_tname,"Unable to cast tr to rsp in slave driver")
    rsp.set_id_info(tr);
    `uvm_info(m_tname,$sformatf("%0s slave driver put rsp, addr_ready_delay = %0d",rsp.xact_type.name(),rsp.addr_ready_delay),UVM_DEBUG)
    seq_item_port.put(rsp);
endtask

/*
 * The reference event for timer triggering of bvalid_delay is the awvalid-awready handshake.
 * If previous bvalid-bready handshake does not complete before timer expires, the
 * current transfer waits for the previous handshake to complete, and then immediately asserts bvalid.
 */
function int tcnt_axi_slave_agent_driver::calc_act_bvalid_delay(tcnt_axi_xaction tr);
    int act_delay;
    act_delay = cur_timestamp - tr.timestamp > tr.bvalid_delay ? 0 : tr.bvalid_delay - (cur_timestamp - tr.timestamp);
    `uvm_info(m_tname,$sformatf("tr.timestamp = 0x%0h,cur_timestamp = 0x%0h,bvalid_delay= 0x%0h,act_delay = 0x%0h",tr.timestamp,cur_timestamp,tr.bvalid_delay,act_delay),UVM_DEBUG)
    return act_delay;
endfunction

/*
 * The reference event for timer triggering of rvalid_delay[0] is the arvalid-arready handshake.
 * If previous rvalid-rready-rlast handshake does not complete before timer expires, the
 * current transfer waits for the previous handshake to complete, and then immediately asserts rvalid.
 * The reference event for timer triggering of rvalid_delay[next] is the previes rvalid-rready handshake.
 */
function int tcnt_axi_slave_agent_driver::calc_act_rvalid_delay(tcnt_axi_xaction tr);
    int act_delay;
    int beat_cnt = tr.data_beat_cnt;
    act_delay = beat_cnt == 0 ? 
                (cur_timestamp - tr.timestamp > tr.rvalid_delay[beat_cnt] ? 0 : tr.rvalid_delay[beat_cnt]) - (cur_timestamp - tr.timestamp) :
                tr.rvalid_delay[beat_cnt];
    `uvm_info(m_tname,$sformatf("beat_cnt = %0d,tr.timestamp = 0x%0h,cur_timestamp = 0x%0h,rvalid_delay= 0x%0h,act_delay = 0x%0h",
                                 beat_cnt,tr.timestamp,cur_timestamp,tr.rvalid_delay[beat_cnt],act_delay),UVM_DEBUG)
    return act_delay;
endfunction

function int tcnt_axi_slave_agent_driver::get_xact_idx_of_unique_id(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid);
    foreach(xaction_aa[tr_type][i])begin
        if(xaction_aa[tr_type][i].unique_id === uid)
            return i;
    end
    return -1;
endfunction

task tcnt_axi_slave_agent_driver::update_addr_status(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid,tcnt_axi_dec::status_enum addr_status);
    static integer icnt = 0;
    int tr_idx = get_xact_idx_of_unique_id(tr_type,uid);
    if(xaction_aa[tr_type][tr_idx] != null)begin
        xaction_aa[tr_type][tr_idx].addr_status = addr_status;
        if(is_xact_ready_to_get_response(tr_type,tr_idx) == 1)begin
            resp_mbx[tr_type].put(icnt++);
            xaction_aa[tr_type][tr_idx].timestamp = cur_timestamp;
            `uvm_info(m_tname,{tr_type.name(),$sformatf(" put in resp_mbx due to addr_status update.timestamp = 0x%0h",xaction_aa[tr_type][tr_idx].timestamp)},UVM_DEBUG)
        end
    end
endtask

task tcnt_axi_slave_agent_driver::update_data_status(tcnt_axi_dec::xact_type_enum tr_type,bit [63:0] uid,tcnt_axi_dec::status_enum data_status);
    static integer icnt = 0;
    int tr_idx = get_xact_idx_of_unique_id(tr_type,uid);
    if(xaction_aa[tr_type][tr_idx] != null)begin
        xaction_aa[tr_type][tr_idx].data_status = data_status;
        if(is_xact_ready_to_get_response(tr_type,tr_idx) == 1)begin
            resp_mbx[tr_type].put(icnt++);
            xaction_aa[tr_type][tr_idx].timestamp = cur_timestamp;
            `uvm_info(m_tname,{tr_type.name(),$sformatf(" put in resp_mbx due to data_status update..timestamp = 0x%0h",xaction_aa[tr_type][tr_idx].timestamp)},UVM_DEBUG)
        end
    end
endtask

function int tcnt_axi_slave_agent_driver::get_idx_of_first_accepted_tr_of_id(input tcnt_axi_dec::xact_type_enum tr_type,input logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] id);
    if(xaction_aa[tr_type].size() == 0) begin
        return -1;
    end
    else begin
        foreach(xaction_aa[tr_type][idx])begin
            if(((tr_type == tcnt_axi_dec::WRITE) &&
                (xaction_aa[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT) &&
                (xaction_aa[tr_type][idx].data_status == tcnt_axi_dec::ACCEPT) &&
                (xaction_aa[tr_type][idx].id          == id)) || 
               ((tr_type == tcnt_axi_dec::READ) && 
                (xaction_aa[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT) &&
                (xaction_aa[tr_type][idx].id          == id)))begin
                return idx;        
            end
        end
        return -1;
    end
endfunction

function int tcnt_axi_slave_agent_driver::get_idx_of_first_unaccepted_data_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    if(xaction_aa[tr_type].size() == 0)
        return -1;
    else begin
        foreach(xaction_aa[tr_type][idx])begin
            foreach(xaction_aa[tr_type][idx])begin
                if(xaction_aa[tr_type][idx].data_status inside {tcnt_axi_dec::INITIAL,tcnt_axi_dec::ACTIVE,tcnt_axi_dec::PARTIAL_ACCEPT})
                    return idx;
            end
        end
        return -1;
    end
endfunction

function int tcnt_axi_slave_agent_driver::get_idx_of_first_unaccepted_addr_tr(input tcnt_axi_dec::xact_type_enum tr_type);
    if(xaction_aa[tr_type].size() == 0)
        return -1;
    else begin
        foreach(xaction_aa[tr_type][idx])begin
            // data before addr, data_status is not initial,addr_status is initial
            if(xaction_aa[tr_type][idx].addr_status inside {tcnt_axi_dec::INITIAL,tcnt_axi_dec::ACTIVE})
                return idx;
        end
        return -1;
    end
endfunction

function bit tcnt_axi_slave_agent_driver::is_xact_ready_to_get_response(input tcnt_axi_dec::xact_type_enum tr_type,input int idx);
    //foreach(xaction_aa[tr_type][idx])begin
    if(xaction_aa[tr_type].size() > idx)begin
        if(((tr_type == tcnt_axi_dec::WRITE) && 
            (xaction_aa[tr_type][idx].write_resp_status == tcnt_axi_dec::INITIAL) &&
            (xaction_aa[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT) &&
            (xaction_aa[tr_type][idx].data_status == tcnt_axi_dec::ACCEPT)) ||
           (((tr_type == tcnt_axi_dec::READ)) && 
            (xaction_aa[tr_type][idx].data_status == tcnt_axi_dec::INITIAL) &&
            (xaction_aa[tr_type][idx].addr_status == tcnt_axi_dec::ACCEPT)))
            return 1;
    end
    return 0;
endfunction

function void tcnt_axi_slave_agent_driver::update_reordering_id_queue(input tcnt_axi_dec::xact_type_enum xtype);
    int reordering_depth = (xtype == tcnt_axi_dec::WRITE) ? cfg.read_data_reordering_depth : cfg.write_resp_reordering_depth;
    // same id in order
    if((reordering_id_queue[xtype].size() == 0) || (cfg.reordering_window == tcnt_axi_dec::MOVING))begin
        foreach(xaction_aa[xtype][i])begin
            if(reordering_id_queue[xtype].size() < reordering_depth) begin 
                if((!(xaction_aa[xtype][i].id inside {reordering_id_queue[xtype]})) && 
                   (get_idx_of_first_accepted_tr_of_id(xtype,xaction_aa[xtype][i].id) != -1))begin// ensure accepted
                    reordering_id_queue[xtype].push_back(xaction_aa[xtype][i].id); 
                end
            end else
                break;
        end
    end
endfunction

function logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] tcnt_axi_slave_agent_driver::m_get_reordering_result_xact_id(input tcnt_axi_dec::xact_type_enum xtype);
    case(cfg.reordering_algorithm)
        tcnt_axi_dec::ROUND_ROBIN : begin
            ;//return reordering_id_queue[xtype][0]; 
        end
        tcnt_axi_dec::RANDOM : begin
            //int idx = $urandom_range(0,reordering_id_queue[xtype].size()-1);
            //return reordering_id_queue[xtype][idx]; 
            reordering_id_queue[xtype].shuffle();
            //return reordering_id_queue[xtype][0]; 
        end
        tcnt_axi_dec::PRIORITIZED : begin
            //foreach(reordering_id_queue[xtype])begin
            //    reordering_priority
            //end
            // TODO do prioritized funcitons
            //return reordering_id_queue[xtype][0]; 
        end
        default : begin
            //return reordering_id_queue[xtype][0];
        end
    endcase
    return reordering_id_queue[xtype][0];
endfunction

`ifndef TCNT_AXI_SLAVE_WAIT_SIGNAL_FOR_CYCLES
`define TCNT_AXI_SLAVE_WAIT_SIGNAL_FOR_CYCLES(MAX_CYCLE,SIG,VAL) \
    begin                                   \
        int cycle_cnt = 0;                  \
        while(1)begin                       \
            @vif.axi_slave_cb;              \
            if(cycle_cnt >= MAX_CYCLE)      \
                `uvm_error(m_tname,$sformatf("cycles waiting for %0s exceed max timeout cycle %0d",`"SIG`",MAX_CYCLE))\
            if(SIG === VAL)                 \
                break;                      \
            cycle_cnt++;                    \
        end                                 \
    end                                     \
`endif 

task tcnt_axi_slave_agent_driver::drive_axi_wr_resp();
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] wr_do_id;
    tcnt_axi_xaction wr_tr;
    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                int idx = 0;
                integer tmp;
                vif.axi_slave_cb.bvalid <= 1'b0;
                resp_mbx[tcnt_axi_dec::WRITE].get(tmp);
                begin
                    `uvm_info(m_tname,$sformatf("got %0d from resp_mbx write.",tmp),UVM_DEBUG)
                    update_reordering_id_queue(tcnt_axi_dec::WRITE);
                    wr_do_id = m_get_reordering_result_xact_id(tcnt_axi_dec::WRITE);
                    idx = get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::WRITE,wr_do_id);
                    wr_tr = xaction_aa[tcnt_axi_dec::WRITE][idx]; 

                    wr_tr.write_resp_status = ACTIVE;
                    //repeat(wr_tr.bvalid_delay)
                    repeat(calc_act_bvalid_delay(wr_tr))
                        @vif.axi_slave_cb;

                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,pre_drive_bresp(this,wr_tr,vif))
                    vif.axi_slave_cb.bvalid <= 1'b1;
                    vif.axi_slave_cb.bid    <= wr_tr.id;
                    vif.axi_slave_cb.bresp  <= wr_tr.bresp;
                    if(cfg.buser_enable)
                        vif.axi_slave_cb.buser  <= wr_tr.resp_user & ((2048'b1 << cfg.resp_user_width) - 1);
                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,post_drive_bresp(this,wr_tr,vif))

                    //`TCNT_AXI_SLAVE_WAIT_SIGNAL_FOR_CYCLES(cfg.bresp_watchdog_timeout,vif.axi_slave_cb.bready,1'b1)
                    while(1) begin
                        @vif.axi_slave_cb;
                        if(vif.axi_slave_cb.bready == 1'b1) begin
                            break ;
                        end
                    end
                    write_outstanding_cnt--; 
                    wr_tr.write_resp_status = ACCEPT;
                    `uvm_info(m_tname,$sformatf("Got bresp, outstanding = %0d.",write_outstanding_cnt),UVM_DEBUG)
                    void'(reordering_id_queue[tcnt_axi_dec::WRITE].pop_front());
                    xaction_aa[tcnt_axi_dec::WRITE].delete(get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::WRITE,wr_tr.id));
                end 
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            drive_b_reset_value();
            wr_do_id = 0;
            wr_tr = null;
            clear_counter_and_buffer();
            wait_reset_deasserted();            
        end
    end
endtask

task tcnt_axi_slave_agent_driver::drive_axi_rd_resp();
    logic [`TCNT_AXI_MAX_ID_WIDTH-1:0] rd_do_id;
    tcnt_axi_xaction rd_tr;
    bit interleave_size_start = 1'b1;
    bit[`TCNT_AXI_RD_MAX_REGSLICE_SIZE-1:0] regslice_rready ;

    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                int idx = 0;
                integer tmp;
                vif.axi_slave_cb.rvalid <= 1'b0;
                vif.axi_slave_cb.non_rvalid <= 'h0 ; 
                vif.axi_slave_cb.rlast  <= 1'b0;
                //wait(has_xact_ready_to_get_response(tcnt_axi_dec::READ) == 1);
                resp_mbx[tcnt_axi_dec::READ].peek(tmp);
                begin
                    `uvm_info(m_tname,$sformatf("got %0d from resp_mbx read.",tmp),UVM_DEBUG)
                    if(interleave_size_start)begin
                        update_reordering_id_queue(tcnt_axi_dec::READ);
                        rd_do_id = m_get_reordering_result_xact_id(tcnt_axi_dec::READ);
                        // get rd transaction with id
                        idx = get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::READ,rd_do_id);
                        rd_tr = xaction_aa[tcnt_axi_dec::READ][idx]; 
                    end

                    rd_tr.data_status = ACTIVE;

                    //repeat(rd_tr.rvalid_delay[rd_tr.data_beat_cnt])
                    repeat(calc_act_rvalid_delay(rd_tr))
                        @vif.axi_slave_cb;

                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,pre_drive_rresp(this,rd_tr,vif))
                    vif.axi_slave_cb.rvalid <= 1'b1;
                    vif.axi_slave_cb.non_rvalid <= (cfg.regslice_en == 1'b1) ? (cfg.rd_all_one>>1) : 'h0 ;
                    vif.axi_slave_cb.rdata  <= rd_tr.data[rd_tr.data_beat_cnt];
                    vif.axi_slave_cb.rid    <= rd_tr.id;
                    vif.axi_slave_cb.rresp  <= rd_tr.rresp[rd_tr.data_beat_cnt];
                    if(cfg.ruser_enable)
                        vif.axi_slave_cb.ruser  <= rd_tr.data_user[rd_tr.data_beat_cnt] & ((2048'b1 << cfg.data_user_width) - 1);
                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,post_drive_rresp(this,rd_tr,vif))
                    
                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,pre_drive_rlast(this,rd_tr,vif))
                    if(rd_tr.data_beat_cnt == rd_tr.burst_length-1)begin
                        vif.axi_slave_cb.rlast <= 1'b1;
                        resp_mbx[tcnt_axi_dec::READ].get(tmp);
                    end else
                        vif.axi_slave_cb.rlast <= 1'b0;
                    `uvm_do_callbacks(tcnt_axi_slave_agent_driver,tcnt_axi_slave_agent_driver_callback,post_drive_rlast(this,rd_tr,vif))

                    //if(cfg.regslice_en == 1'b0) begin
                    //    `TCNT_AXI_SLAVE_WAIT_SIGNAL_FOR_CYCLES(cfg.rready_watchdog_timeout,vif.axi_slave_cb.rready,1'b1)
                    //end
                    //else begin
                    //    `TCNT_AXI_SLAVE_WAIT_SIGNAL_FOR_CYCLES(cfg.rready_watchdog_timeout,{vif.axi_slave_cb.non_rready, vif.axi_slave_cb.rready}, cfg.rd_all_one)
                    //end
                    while(1) begin
                        @vif.axi_slave_cb;
                        if(cfg.regslice_en == 1'b1) begin
                            for(int i=0; i<cfg.rd_regslice_size; i++) begin
                                if(i == 0) begin
                                    regslice_rready[i] =  vif.axi_slave_cb.rready ;
                                end
                                else begin
                                    regslice_rready[i] =  vif.axi_slave_cb.non_rready[i-1] ;
                                end
                            end
                        end
                        if((vif.axi_slave_cb.rready == 1'b1 && cfg.regslice_en == 1'b0) || (regslice_rready == cfg.rd_all_one && cfg.regslice_en == 1'b1)) begin
                            break ;
                        end
                    end

                    rd_tr.data_beat_cnt++;

                    if((rd_tr.interleave_enable && (cfg.read_data_interleave_size != 0) && 
                        (rd_tr.data_beat_cnt%cfg.read_data_interleave_size == 0)) ||
                       (rd_tr.data_beat_cnt == rd_tr.burst_length))begin
                        interleave_size_start = 1'b1; 
                        //`uvm_info(m_tname,$sformatf("interleave_size_start = %0d,rd_tr.read_data_interleave_size = %0d,rcnt[0x%0h] = %0d",
                        //                             interleave_size_start,cfg.read_data_interleave_size,rd_tr.id,rd_tr.data_beat_cnt),UVM_LOW)
                    end else
                        interleave_size_start = 1'b0;

                    if(rd_tr.data_beat_cnt == rd_tr.burst_length) begin
                        read_outstanding_cnt--;
                        rd_tr.data_status = ACCEPT;
                        void'(reordering_id_queue[tcnt_axi_dec::READ].pop_front());
                        xaction_aa[tcnt_axi_dec::READ].delete(get_idx_of_first_accepted_tr_of_id(tcnt_axi_dec::READ,rd_tr.id));
                    end else begin
                        rd_tr.data_status = PARTIAL_ACCEPT;
                    end
                end 
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            drive_r_reset_value();
            rd_tr = null;
            interleave_size_start = 1;
            rd_do_id = 0;
            clear_counter_and_buffer();
            wait_reset_deasserted();
        end
    end
endtask

task tcnt_axi_slave_agent_driver::drive_arready();
    tcnt_axi_xaction rd_tr;
    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                int idx = -1;
                bit default_arready_tmp;
                default_arready_tmp = (read_outstanding_cnt < cfg.num_read_outstanding_xact) ? cfg.default_arready : 1'b0;
                //default value
                vif.axi_slave_cb.arready <= default_arready_tmp;
                @vif.axi_slave_cb;        
                if(vif.axi_slave_cb.arvalid == 1'b1)begin 
                    `uvm_info(m_tname,"get arvalid == 1",UVM_DEBUG)
                    vif.axi_slave_cb.arready <= (read_outstanding_cnt < cfg.num_read_outstanding_xact)  ? cfg.default_arready : 1'b0;//default value
                    wait(get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::READ) != -1);
                    idx = get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::READ);
                    `uvm_info(m_tname,$sformatf("Got idx = %0d",idx),UVM_DEBUG)
                    if(vif.axi_slave_cb.arvalid == 1'b1)begin// arvalid may change during waiting
                        rd_tr = xaction_aa[tcnt_axi_dec::READ][idx]; 
                        rd_tr.addr_status = tcnt_axi_dec::ACTIVE;
                        if(read_outstanding_cnt < cfg.num_read_outstanding_xact)begin
                            if(cfg.default_arready && ~default_arready_tmp)begin// default arready will be 0 if outstanding ctrl been actived, when recovery, add 1 cycle 
                                vif.axi_slave_cb.arready <= 1'b1;               // to let arready defalut be 1
                                @vif.axi_slave_cb;
                            end

                            if(cfg.default_arready == 0)begin// delay after arvalid asserted
                                repeat(rd_tr.addr_ready_delay)begin
                                    vif.axi_slave_cb.arready <= 1'b0;
                                    @vif.axi_slave_cb;
                                end
                                vif.axi_slave_cb.arready <= 1'b1;
                                @vif.axi_slave_cb;
                                read_outstanding_cnt++;
                                update_addr_status(tcnt_axi_dec::READ,rd_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,$sformatf("update rd_tr addr_status as ACCEPT,outstanding = %0d",read_outstanding_cnt),UVM_DEBUG)
                            end else begin                  // delay after handshake 
                                read_outstanding_cnt++;
                                update_addr_status(tcnt_axi_dec::READ,rd_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,$sformatf("update rd_tr addr_status as ACCEPT,outstanding = %0d",read_outstanding_cnt),UVM_DEBUG)
                                repeat(rd_tr.addr_ready_delay)begin
                                    vif.axi_slave_cb.arready <= 1'b0;
                                    @vif.axi_slave_cb;
                                end
                            end
                        end else begin
                            vif.axi_slave_cb.arready <= 1'b0;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            drive_ar_reset_value();
            rd_tr = null;
            clear_counter_and_buffer();
            wait_reset_deasserted();            
        end
    end
endtask

task tcnt_axi_slave_agent_driver::drive_awready();
    tcnt_axi_xaction wr_tr;
    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin
                int idx = -1;
                bit default_awready_tmp;
                default_awready_tmp = (write_outstanding_cnt < cfg.num_write_outstanding_xact) ? cfg.default_awready : 1'b0;
                //default value
                vif.axi_slave_cb.awready <= default_awready_tmp;
                @vif.axi_slave_cb;
                if(vif.axi_slave_cb.awvalid == 1'b1)begin 
                    `uvm_info(m_tname,"2. get awvalid == 1",UVM_DEBUG)
                    wait(get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::WRITE) != -1);
                    idx = get_idx_of_first_unaccepted_addr_tr(tcnt_axi_dec::WRITE);
                    `uvm_info(m_tname,$sformatf("3. Got idx = %0d",idx),UVM_DEBUG)
                    if(vif.axi_slave_cb.awvalid == 1'b1)begin// awvalid may change during waiting
                        wr_tr = xaction_aa[tcnt_axi_dec::WRITE][idx]; 
                        wr_tr.addr_status = tcnt_axi_dec::ACTIVE;
                        // data before addr, put tr info into wr_tr for bresp use
                        if(wr_tr.data_status != INITIAL)begin
                            wr_tr.addr = vif.axi_slave_cb.awaddr;
                            wr_tr.id = vif.axi_slave_cb.awid;
                        end
                        
                        if(write_outstanding_cnt < cfg.num_write_outstanding_xact)begin
                            if(cfg.default_awready && ~default_awready_tmp)begin// default awready will be 0 if outstanding ctrl been actived, when recovery, add 1 cycle 
                                vif.axi_slave_cb.awready <= 1'b1;               // to let awready defalut be 1
                                @vif.axi_slave_cb;
                            end

                            if(cfg.default_awready == 0)begin// delay after awvalid asserted
                                repeat(wr_tr.addr_ready_delay)begin
                                    vif.axi_slave_cb.awready <= 1'b0;
                                    @vif.axi_slave_cb;
                                end                        
                                vif.axi_slave_cb.awready <= 1'b1;
                                @vif.axi_slave_cb;
                                write_outstanding_cnt++;
                                update_addr_status(tcnt_axi_dec::WRITE,wr_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,$sformatf("4. update wr_tr addr_status as ACCEPT,outstanding = %0d",write_outstanding_cnt),UVM_DEBUG)                        
                            end else begin                   // delay after handshake 
                                write_outstanding_cnt++;
                                update_addr_status(tcnt_axi_dec::WRITE,wr_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,$sformatf("4. update wr_tr addr_status as ACCEPT,outstanding = %0d",write_outstanding_cnt),UVM_DEBUG)

                                repeat(wr_tr.addr_ready_delay)begin
                                    vif.axi_slave_cb.awready <= 1'b0;
                                    @vif.axi_slave_cb;
                                end
                            end
                        end else begin
                            vif.axi_slave_cb.awready <= 1'b0;
                        end
                    end
                end
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            drive_aw_reset_value();
            wr_tr = null;
            clear_counter_and_buffer();
            wait_reset_deasserted();
        end
    end
endtask

task tcnt_axi_slave_agent_driver::drive_wready();
    int wbeat_cnt = 0;
    bit clear_wbeat_cnt = 0;
    int idx = -1;
    tcnt_axi_xaction wr_tr;
    bit[`TCNT_AXI_WR_MAX_REGSLICE_SIZE-1:0] regslice_wvalid ;

    while(1)begin
        fork
            wait(vif.aresetn === 1'b0);
            begin        
                //if(vif.axi_slave_cb.wvalid == 1'b1)begin
                if(cfg.regslice_en == 1'b1) begin
                    for(int i=0; i<cfg.wr_regslice_size; i++) begin
                        if(i == 0) begin
                            regslice_wvalid[i] =  vif.axi_slave_cb.wvalid ;
                        end
                        else begin
                            regslice_wvalid[i] =  vif.axi_slave_cb.non_wvalid[i-1] ;
                        end
                    end
                end

                //if((vif.axi_slave_cb.wvalid == 1'b1 && cfg.regslice_en == 1'b0) || ({vif.axi_slave_cb.non_wvalid, vif.axi_slave_cb.wvalid} == cfg.wr_all_one && cfg.regslice_en == 1'b1))begin
                if((vif.axi_slave_cb.wvalid == 1'b1 && cfg.regslice_en == 1'b0) || (regslice_wvalid == cfg.wr_all_one && cfg.regslice_en == 1'b1))begin
                    vif.axi_slave_cb.wready <= cfg.default_wready;
                    if(cfg.regslice_en == 1'b1) begin
                        for(int k=0; k<(cfg.wr_regslice_size-1); k++)begin
                            vif.non_wready[k] <= cfg.default_wready   ;
                        end
                    end
                    else begin
                         vif.non_wready <= 'h0   ;
                    end
                    wait(get_idx_of_first_unaccepted_data_tr(tcnt_axi_dec::WRITE) != -1);
                    idx = get_idx_of_first_unaccepted_data_tr(tcnt_axi_dec::WRITE);
                    `uvm_info(m_tname,$sformatf("Got wready data idx = %0d",idx),UVM_DEBUG)
                    begin
                        wr_tr = xaction_aa[tcnt_axi_dec::WRITE][idx];
                        
                        if(wbeat_cnt > wr_tr.wready_delay.size())
                            `uvm_fatal(m_tname,$sformatf("axi write beat counter[%0d] exceed wready_delay size[%0d].",wbeat_cnt,wr_tr.wready_delay.size()))
                        
                        if(cfg.default_wready === 1'b0)begin
                            repeat(wr_tr.wready_delay[wbeat_cnt])begin
                                vif.axi_slave_cb.wready <= 1'b0;
                                vif.axi_slave_cb.non_wready <= 'h0 ; 
                                `uvm_info(m_tname,"wready ++",UVM_DEBUG)
                                @vif.axi_slave_cb;
                            end                    

                            vif.axi_slave_cb.wready <= 1'b1;
                            vif.axi_slave_cb.non_wready <= (cfg.regslice_en == 1'b1 ) ? (cfg.wr_all_one>>1) : 'h0 ;
                            @vif.axi_slave_cb;

                            if(vif.axi_slave_cb.wlast)begin
                                update_data_status(tcnt_axi_dec::WRITE,wr_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,"update wr_tr data status to ACCEPT",UVM_DEBUG)
                                clear_wbeat_cnt = 1;
                            end                    
                        end else begin
                            if(vif.axi_slave_cb.wlast)begin
                                update_data_status(tcnt_axi_dec::WRITE,wr_tr.unique_id,tcnt_axi_dec::ACCEPT);
                                `uvm_info(m_tname,"update wr_tr data status to ACCEPT",UVM_DEBUG)
                                clear_wbeat_cnt = 1;
                            end

                            repeat(wr_tr.wready_delay[wbeat_cnt])begin
                                vif.axi_slave_cb.wready <= 1'b0;
                                vif.axi_slave_cb.non_wready <= 'h0 ; 
                                `uvm_info(m_tname,"wready ++",UVM_DEBUG)
                                @vif.axi_slave_cb;
                            end                
                        end
                        vif.axi_slave_cb.wready <= cfg.default_wready;
                        if(cfg.regslice_en == 1'b1) begin
                            for(int k=0; k<(cfg.wr_regslice_size-1); k++)begin
                                vif.non_wready[k] <= cfg.default_wready   ;
                            end
                        end
                        else begin
                             vif.non_wready <= 'h0   ;
                        end

                        wbeat_cnt++;

                        if(clear_wbeat_cnt)begin
                            wbeat_cnt = 0;
                            clear_wbeat_cnt = 0;
                        end
                    end
                end else begin
                    vif.axi_slave_cb.wready <= cfg.default_wready;
                    if(cfg.regslice_en == 1'b1) begin
                        for(int k=0; k<(cfg.wr_regslice_size-1); k++)begin
                            vif.non_wready[k] <= cfg.default_wready   ;
                        end
                    end
                    else begin
                         vif.non_wready <= 'h0   ;
                    end
                end

                @vif.axi_slave_cb;
            end
        join_any
        disable fork;
        if(vif.aresetn === 1'b0)begin
            drive_w_reset_value();
            wbeat_cnt = 0;
            clear_wbeat_cnt = 0;
            idx = -1;
            wr_tr = null;
            clear_counter_and_buffer();
            wait_reset_deasserted();
        end
    end
endtask

task tcnt_axi_slave_agent_driver::drive_axi_resp();
    fork
        drive_axi_wr_resp();
        drive_axi_rd_resp();
    join
endtask

task tcnt_axi_slave_agent_driver::get_axi_xaction();
    tcnt_axi_xaction xact;
    while(1)begin
        if(vif.aresetn === 1'b0)begin
            xact = null;
            clear_counter_and_buffer();
            wait_reset_deasserted();
        end else begin
            seq_item_port.get_next_item(req);
            if((req != null) && ($cast(xact,req)))begin
                bit no_need_to_push = 0;
                `uvm_info(m_tname,{"Got req : \n",xact.sprint()},UVM_DEBUG)
                // update addr/data status, since driver need new status
                if(xact.xact_type == tcnt_axi_dec::READ)
                    xact.addr_status = tcnt_axi_dec::ACTIVE;
                else begin
                    if(xact.addr_status == tcnt_axi_dec::ACCEPT)
                        xact.addr_status = tcnt_axi_dec::ACTIVE;
                    if(xact.data_status inside {PARTIAL_ACCEPT,ACCEPT})
                        xact.data_status = tcnt_axi_dec::ACTIVE;
                end
                foreach(xaction_aa[xact.xact_type][i])begin
                    if(xact.has_same_unique_id(xaction_aa[xact.xact_type][i].unique_id))begin
                        no_need_to_push = 1;
                        `uvm_info(m_tname,$sformatf("unique_id[%0d] found,no need to push back into xaction",xact.unique_id),UVM_DEBUG)
                    end
                end
                if(!no_need_to_push)begin
                    xaction_aa[xact.xact_type].push_back(xact);
                    `uvm_info(m_tname,$sformatf("0. %0s xact addr_ready_delay = %0d",xact.xact_type.name,xact.addr_ready_delay),UVM_DEBUG)
                end
            end
            seq_item_port.item_done();
        end
    end
endtask

task tcnt_axi_slave_agent_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    drive_reset();
    fork
        get_axi_xaction();
        drive_axi_resp();
        drive_awready();
        drive_arready();
        drive_wready();
        run_timestamp();
    join
endtask:run_phase

task tcnt_axi_slave_agent_driver::drive_idle(tcnt_dec_base::drv_mode_e drv_mode);

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
endtask:drive_idle

`endif

