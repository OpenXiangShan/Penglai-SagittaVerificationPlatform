`ifndef TCNT_APB_MASTER_MONITOR__SV
`define TCNT_APB_MASTER_MONITOR__SV

class tcnt_apb_master_agent_monitor extends tcnt_monitor_base#(virtual tcnt_apb_interface, tcnt_apb_master_agent_cfg, tcnt_apb_master_agent_transaction);
    `ifdef FCOV
    tcnt_apb_cov cov;
    `endif
	`uvm_component_utils(tcnt_apb_master_agent_monitor)

	extern function new(string name="tcnt_apb_master_agent_monitor", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern task sample_item();
    extern function void addr_valid_check(ref tcnt_apb_master_agent_transaction tr);
endclass

function tcnt_apb_master_agent_monitor::new(string name="tcnt_apb_master_agent_monitor", uvm_component parent=null);
	super.new(name, parent);
endfunction

function void tcnt_apb_master_agent_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task tcnt_apb_master_agent_monitor::run_phase(uvm_phase phase);

	super.run_phase(phase);

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

task tcnt_apb_master_agent_monitor::sample_item();
	tcnt_apb_master_agent_transaction tr;
    int unsigned num_wait_cycles;

    @(this.vif.monitor_cb);
    if(this.vif.monitor_cb.psel === 1'b1 && this.vif.monitor_cb.penable === 1'b0)begin
        tr = tcnt_apb_master_agent_transaction::type_id::create("tr");

        tr.addr = this.vif.monitor_cb.paddr;
        if(this.cfg.apb5_enable==1'b1)begin
            tr.auser = this.vif.monitor_cb.pauser;
        end
        if(this.vif.monitor_cb.pwrite==1'b1)begin
            tr.xact_type = tcnt_apb_dec::WRITE;
            tr.data = this.vif.monitor_cb.pwdata;
        end
        else begin
            tr.xact_type = tcnt_apb_dec::READ;
        end

        if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
            tr.pstrb = this.vif.monitor_cb.pstrb;
            case(this.vif.monitor_cb.pprot[2])
                1'b1:tr.pprot2 = tcnt_apb_dec::INSTRUCTION;
                1'b0:tr.pprot2 = tcnt_apb_dec::DATA;
            endcase
            case(this.vif.monitor_cb.pprot[1])
                1'b1:tr.pprot1 = tcnt_apb_dec::NON_SECURE;
                1'b0:tr.pprot1 = tcnt_apb_dec::SECURE;
            endcase
            case(this.vif.monitor_cb.pprot[0])
                1'b1:tr.pprot0 = tcnt_apb_dec::PRIVILEGED;
                1'b0:tr.pprot0 = tcnt_apb_dec::NORMAL;
            endcase
            if(this.cfg.apb5_enable==1'b1)begin
                tr.wuser = this.vif.monitor_cb.pwuser;
            end
        end

        while(1)begin
            @(this.vif.monitor_cb);

            if(this.cfg.slave_pready_timeout>0)begin
                if(num_wait_cycles==this.cfg.slave_pready_timeout)begin
                    num_wait_cycles = 0;
                    tr.pslverr = this.vif.monitor_cb.pslverr;
                    if(this.vif.monitor_cb.pwrite==1'b0)begin
                        tr.data = 'h0;
                    end

                    this.mon_item_port.write(tr);
                    break;
                end
                else begin
                    num_wait_cycles=num_wait_cycles+32'h1;
                end
            end

            if(this.vif.monitor_cb.pready === 1'b1)begin
                tr.pslverr = this.vif.monitor_cb.pslverr;
                if(tr.xact_type == tcnt_apb_dec::READ)begin
                    tr.data = this.vif.monitor_cb.prdata;
                end

                this.mon_item_port.write(tr);
                break;
            end
        end
        this.addr_valid_check(tr);

        `ifdef FCOV
        if(this.cfg.apb_cov_enable == 1'b1)begin
            this.cov.write_pslverr.sample(tr.xact_type,tr.pslverr);
            this.cov.write_wait.sample(tr.xact_type,num_wait_cycles);
            this.cov.read_pslverr.sample(tr.xact_type,tr.pslverr);
            this.cov.read_wait.sample(tr.xact_type,num_wait_cycles);
        end
        `endif
    end
endtask:sample_item

/**
*monitor addr align
*/
function void tcnt_apb_master_agent_monitor::addr_valid_check( ref tcnt_apb_master_agent_transaction tr);
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
