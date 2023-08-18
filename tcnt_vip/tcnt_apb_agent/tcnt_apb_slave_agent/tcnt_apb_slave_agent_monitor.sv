`ifndef TCNT_APB_SLAVE_AGENT_MONITOR__SV
`define TCNT_APB_SLAVE_AGENT_MONITOR__SV

class tcnt_apb_slave_agent_monitor extends tcnt_monitor_base#(virtual tcnt_apb_interface, tcnt_apb_slave_agent_cfg, tcnt_apb_slave_agent_transaction);
    uvm_analysis_port#(tcnt_apb_slave_agent_transaction) ap2drv;
    `ifdef FCOV
    tcnt_apb_cov cov;
    `endif
    `uvm_component_utils(tcnt_apb_slave_agent_monitor)

    extern function new(string name="tcnt_apb_slave_agent_monitor", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern task sample_item();
    extern function void addr_valid_check(ref tcnt_apb_slave_agent_transaction tr);
endclass

function tcnt_apb_slave_agent_monitor::new(string name="tcnt_apb_slave_agent_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void tcnt_apb_slave_agent_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);

    ap2drv=new("ap2drv",this);
endfunction

task tcnt_apb_slave_agent_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);

    if(this.cfg.paddr_width < tcnt_apb_dec::PADDR_WIDTH_1 || this.cfg.paddr_width > tcnt_apb_dec::PADDR_WIDTH_32)begin
        `uvm_error("get_valid_address_width",$psprintf("Address Wdith is not valid, Address width: %0d",this.cfg.paddr_width));
    end

    @(posedge this.vif.prstn);
    while(1)begin
        fork
            while(1)begin
                this.sample_item();
            end
            while(1)begin
                @(this.vif.monitor_cb);
                `ifdef FCOV
                if(this.cfg.apb_cov_enable == 1'b1)begin
                    this.cov.apb_states.sample(vif.monitor_cb.psel,vif.monitor_cb.penable);
                end
                `endif
            end
            begin
                @(negedge this.vif.prstn);
            end
        join_any
        disable fork;
    end
endtask

task tcnt_apb_slave_agent_monitor::sample_item();
    tcnt_apb_slave_agent_transaction trans;
    tcnt_apb_slave_agent_transaction trans_t;

    @(this.vif.monitor_cb); //SETUP
    if(this.vif.monitor_cb.psel === 1'b1 && this.vif.monitor_cb.penable === 1'b0)begin
        trans = tcnt_apb_slave_agent_transaction::type_id::create("trans");
        assert(trans.randomize());

        //@(this.vif.monitor_cb); //ACCESS
        case(this.vif.monitor_cb.pwrite)
            1'b1:begin
                trans.addr = this.vif.monitor_cb.paddr;
                trans.data = this.vif.monitor_cb.pwdata;
                trans.xact_type = tcnt_apb_dec::WRITE;
                if(this.cfg.apb4_enable==1'b1)begin
                    trans.pstrb = this.vif.monitor_cb.pstrb;
                    case(this.vif.monitor_cb.pprot[2])
                        1'b1:trans.pprot2 = tcnt_apb_dec::INSTRUCTION;
                        1'b0:trans.pprot2 = tcnt_apb_dec::DATA;
                    endcase
                    case(this.vif.monitor_cb.pprot[1])
                        1'b1:trans.pprot1 = tcnt_apb_dec::NON_SECURE;
                        1'b0:trans.pprot1 = tcnt_apb_dec::SECURE;
                    endcase
                    case(this.vif.monitor_cb.pprot[0])
                        1'b1:trans.pprot0 = tcnt_apb_dec::PRIVILEGED;
                        1'b0:trans.pprot0 = tcnt_apb_dec::NORMAL;
                    endcase
                end
            end
            1'b0:begin
                trans.addr = this.vif.monitor_cb.paddr;
                trans.xact_type = tcnt_apb_dec::READ;
                if(this.cfg.apb4_enable==1'b1)begin
                    trans.pstrb = this.vif.monitor_cb.pstrb;
                    case(this.vif.monitor_cb.pprot[2])
                        1'b1:trans.pprot2 = tcnt_apb_dec::INSTRUCTION;
                        1'b0:trans.pprot2 = tcnt_apb_dec::DATA;
                    endcase
                    case(this.vif.monitor_cb.pprot[1])
                        1'b1:trans.pprot1 = tcnt_apb_dec::NON_SECURE;
                        1'b0:trans.pprot1 = tcnt_apb_dec::SECURE;
                    endcase
                    case(this.vif.monitor_cb.pprot[0])
                        1'b1:trans.pprot0 = tcnt_apb_dec::PRIVILEGED;
                        1'b0:trans.pprot0 = tcnt_apb_dec::NORMAL;
                    endcase
                end
            end
            default:begin
                `uvm_error(get_type_name(),"ERROR pwrite signal value");
            end
        endcase

        this.addr_valid_check(trans);
        $cast(trans_t,trans.clone());
        
        if(this.cfg.drv_sw == tcnt_dec_base::ON)begin
            this.ap2drv.write(trans);
        end

        while(1)begin
            @(this.vif.monitor_cb);
            if(this.vif.monitor_cb.pready === 1'b1)begin
                if(this.vif.monitor_cb.pwrite === 1'b0)begin
                    trans_t.data = this.vif.monitor_cb.prdata;
                end
                this.mon_item_port.write(trans_t);
                break;
            end
        end

        `ifdef FCOV
        if(this.cfg.apb_cov_enable == 1'b1)begin
            this.cov.write_pslverr.sample(trans_t.xact_type,trans_t.pslverr);
            this.cov.read_pslverr.sample(trans_t.xact_type,trans_t.pslverr);
        end
        `endif
    end
    //else begin
    //    @(this.vif.monitor_cb); //IDLE
    //end
endtask:sample_item

/**
*monitor addr range
*monitor addr align
*/
function void tcnt_apb_slave_agent_monitor::addr_valid_check( ref tcnt_apb_slave_agent_transaction tr);
    if(tr.addr < this.cfg.start_addr || tr.addr > this.cfg.end_addr)begin
        `uvm_error("get_valid_addr",$psprintf("addr='h%0h is out of slave address range",tr.addr));
    end

    if(this.cfg.addr_unalign_check==1'b1)begin
        case(this.cfg.pdata_width)
            tcnt_apb_dec::PDATA_WIDTH_8:begin
            end
            tcnt_apb_dec::PDATA_WIDTH_16:begin
                if(tr.addr[1] != 1'b0)begin
                    `uvm_error("get_aligned_addr",$psprintf("Address is not aligned. Addr: 'h%0h, Data Width: 16",tr.addr));
                end
            end
            tcnt_apb_dec::PDATA_WIDTH_32:begin
                if(tr.addr[1:0] != 2'h0)begin
                    `uvm_error("get_aligned_addr",$psprintf("Address is not aligned. Addr: 'h%0h, Data Width: 32",tr.addr));
                end
            end
            default:begin
                `uvm_error("get_valid_data_width",$psprintf("Data Wdith is not valid, Data width: %0d",this.cfg.pdata_width));
            end
        endcase
    end
endfunction:addr_valid_check
`endif
