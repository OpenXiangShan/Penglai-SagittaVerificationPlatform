`ifndef TCNT_APB_MASTER_DRIVER__SV
`define TCNT_APB_MASTER_DRIVER__SV

class tcnt_apb_master_agent_driver extends tcnt_driver_base#(virtual tcnt_apb_interface, tcnt_apb_master_agent_cfg, tcnt_apb_master_agent_transaction);
    `uvm_component_utils(tcnt_apb_master_agent_driver)
    `uvm_register_cb(tcnt_apb_master_agent_driver,tcnt_apb_master_agent_driver_callback)

    extern function new(string name="tcnt_apb_master_agent_driver", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task write(ref tcnt_apb_master_agent_transaction tr);
    extern virtual task read(ref tcnt_apb_master_agent_transaction tr);
    extern function void wdata_byte_enable(ref tcnt_apb_master_agent_transaction tr);
    extern function void tr_adapter(ref tcnt_apb_master_agent_transaction tr);
endclass

function tcnt_apb_master_agent_driver::new(string name="tcnt_apb_master_agent_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction:new

function void tcnt_apb_master_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task tcnt_apb_master_agent_driver::run_phase(uvm_phase phase);
    tcnt_apb_master_agent_transaction tr;
    tcnt_apb_master_agent_transaction tr_clone;
    tcnt_apb_master_agent_transaction tr_lst;
    bit tr_flag=1'b0;

    super.run_phase(phase);
    
    this.vif.master_cb.paddr  <= 'h0;
    this.vif.master_cb.pwdata <= 'h0;
    this.vif.master_cb.pwrite <= 'h0;
    if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
        this.vif.master_cb.pprot   <= 'h0;
        this.vif.master_cb.pstrb   <= 'h0;
        if(this.cfg.apb5_enable==1'b1)begin
            this.vif.master_cb.pauser <= 'h0;
            this.vif.master_cb.pwuser <= 'h0;
        end
    end
    this.vif.master_cb.psel    <= 1'b0;
    this.vif.master_cb.penable <= 1'b0;
    @(posedge this.vif.prstn);
    @(this.vif.master_cb);

    while(1)begin
        fork
            begin
                if(this.vif.prstn==1'b1)begin
                    seq_item_port.try_next_item(tr);
                    //seq_item_port.get_next_item(tr);
                    if(tr != null)begin
                        tr_flag=1'b1;
                        `uvm_do_callbacks(tcnt_apb_master_agent_driver,tcnt_apb_master_agent_driver_callback,pre_send(tr));
                        case(tr.xact_type)
                            tcnt_apb_dec::READ :begin
                                this.read(tr);
                            end
                            tcnt_apb_dec::WRITE:begin
                                this.write(tr);
                                $cast(tr_lst,tr.clone());
                            end
                        endcase
                        $cast(tr_clone,tr.clone());
                        this.drv_item_port.write(tr_clone);
                        $cast(rsp,tr.clone());
                        rsp.set_id_info(tr);
                        seq_item_port.item_done(rsp);
                        tr.end_tr();
                        //seq_item_port.item_done();
                        tr_flag=1'b0;
                    end
                    else begin
                        @(this.vif.master_cb);
                        //this.vif.master_cb.paddr <= 'h0;
                        case(this.cfg.drv_mode)
                            tcnt_dec_base::DRV_0:begin
                                this.vif.master_cb.pwdata <= 'h0; 
                            end
                            tcnt_dec_base::DRV_X:begin
                                this.vif.master_cb.pwdata <= 'hx; 
                            end
                            tcnt_dec_base::DRV_RAND:begin
                                this.vif.master_cb.pwdata <= $urandom; 
                            end
                            tcnt_dec_base::DRV_LST:begin
                                if(tr_lst != null)begin
                                    this.vif.master_cb.pwdata <= tr_lst.data; 
                                end
                                else begin
                                    this.vif.master_cb.pwdata <= 'h0; 
                                end
                            end
                            default:begin
                                this.vif.master_cb.pwdata <= 'h0; 
                            end
                        endcase
                    end
                end
            end
            begin
                @(negedge this.vif.prstn);
                if(tr_flag==1'b1)begin
                    tr_flag=1'b0;
                    seq_item_port.item_done(tr);
                end
            end
        join_any
        disable fork;

        if(this.vif.prstn==1'b0)begin
            this.vif.master_cb.paddr  <= 'h0;
            this.vif.master_cb.pwdata <= 'h0;
            this.vif.master_cb.pwrite <= 'h0;
            if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
                this.vif.master_cb.pprot   <= 'h0;
                this.vif.master_cb.pstrb   <= 'h0;
                if(this.cfg.apb5_enable==1'b1)begin
                    this.vif.master_cb.pauser <= 'h0;
                    this.vif.master_cb.pwuser <= 'h0;
                end
            end
            this.vif.master_cb.psel    <= 1'b0;
            this.vif.master_cb.penable <= 1'b0;
        end
        while(1)begin
            if(this.vif.prstn==1'b1)begin
                break;
            end
            @(this.vif.master_cb);
        end
    end
endtask:run_phase


task tcnt_apb_master_agent_driver::write(ref tcnt_apb_master_agent_transaction tr);
    int unsigned num_wait_cycles;

    if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
        void'(this.wdata_byte_enable(tr));
    end

    void'(this.tr_adapter(tr));

    //@ (this.vif.master_cb);
    this.vif.master_cb.paddr  <= tr.addr;
    this.vif.master_cb.pwdata <= tr.data;
    this.vif.master_cb.pwrite <= 'h1;
    if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
        this.vif.master_cb.pprot <= {tr.pprot2,tr.pprot1,tr.pprot0};
        this.vif.master_cb.pstrb <= tr.pstrb;
        if(this.cfg.apb5_enable==1'b1)begin
            this.vif.master_cb.pauser <= tr.auser;
            this.vif.master_cb.pwuser <= tr.wuser;
        end
    end
    this.vif.master_cb.psel <= 'h1;

    @ (this.vif.master_cb);
    this.vif.master_cb.penable <= 'h1;

    while(1) begin
        @ (this.vif.master_cb);
        if(this.cfg.slave_pready_timeout>0)begin
            if(num_wait_cycles==this.cfg.slave_pready_timeout)begin
                `uvm_error("wait_slave_pready_during_write",$psprintf("after %0d cycle passed, fail to wait pready",num_wait_cycles));

                this.vif.master_cb.psel    <= 'h0;
                this.vif.master_cb.penable <= 'h0;
                this.vif.master_cb.pwrite  <= 'h0;
                if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
                    this.vif.master_cb.pprot <= 'h0;
                    this.vif.master_cb.pstrb <= 'h0;
                    if(this.cfg.apb5_enable==1'b1)begin
                        this.vif.master_cb.pwuser <= 'h0;
                    end
                end

                case(this.cfg.drv_mode)
                    tcnt_dec_base::DRV_0:begin
                        this.vif.master_cb.pwdata <= 'h0; 
                    end
                    tcnt_dec_base::DRV_X:begin
                        this.vif.master_cb.pwdata <= 'hx; 
                    end
                    tcnt_dec_base::DRV_RAND:begin
                        this.vif.master_cb.pwdata <= $urandom; 
                    end
                    tcnt_dec_base::DRV_LST:begin
                        this.vif.master_cb.pwdata <= tr.data; 
                    end
                    default:begin
                        this.vif.master_cb.pwdata <= 'h0; 
                    end
                endcase

                break;
            end
            else begin
                num_wait_cycles=num_wait_cycles+32'h1;
            end
        end
        else begin
            `uvm_info(get_type_name(),$psprintf("the timeout is not started"),UVM_DEBUG);
        end

        if(this.vif.master_cb.pready==1'b1) begin
            this.vif.master_cb.psel <= 'h0;
            this.vif.master_cb.penable <= 'h0;
            this.vif.master_cb.pwrite <= 'h0;
            if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
                this.vif.master_cb.pprot <= 'h0;
                this.vif.master_cb.pstrb <= 'h0;
                if(this.cfg.apb5_enable==1'b1)begin
                    this.vif.master_cb.pwuser <= 'h0;
                end
            end

            case(this.cfg.drv_mode)
                tcnt_dec_base::DRV_0:begin
                    this.vif.master_cb.pwdata <= 'h0; 
                end
                tcnt_dec_base::DRV_X:begin
                    this.vif.master_cb.pwdata <= 'hx; 
                end
                tcnt_dec_base::DRV_RAND:begin
                    this.vif.master_cb.pwdata <= $urandom; 
                end
                tcnt_dec_base::DRV_LST:begin
                    this.vif.master_cb.pwdata <= tr.data; 
                end
                default:begin
                    this.vif.master_cb.pwdata <= 'h0; 
                end
            endcase

            break;
        end
    end
endtask:write


task tcnt_apb_master_agent_driver::read(ref tcnt_apb_master_agent_transaction tr);
    int unsigned num_wait_cycles;

    void'(this.tr_adapter(tr));

    //@ (this.vif.master_cb);
    this.vif.master_cb.paddr <= tr.addr;
    this.vif.master_cb.pwrite <= 'h0;
    if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
        this.vif.master_cb.pprot <= {tr.pprot2,tr.pprot1,tr.pprot0};
        this.vif.master_cb.pstrb <= 'h0;
    end
    this.vif.master_cb.psel <= 'h1;

    @ (this.vif.master_cb);
    this.vif.master_cb.penable <= 'h1;

    while(1) begin
        @ (this.vif.master_cb);
        if(this.cfg.slave_pready_timeout>0)begin
            if(num_wait_cycles==this.cfg.slave_pready_timeout)begin
                `uvm_error("wait_slave_pready_during_read",$psprintf("after %0d cycle passed, fail to wait pready",num_wait_cycles));

                tr.data = 'h0;
                this.vif.master_cb.psel <= 'h0;             
                this.vif.master_cb.penable <= 'h0;
                if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
                    this.vif.master_cb.pstrb <= 'h0;
                    this.vif.master_cb.pprot <= 'h0;
                end
                this.vif.master_cb.pwrite <= 'h0;             

                break;
            end
            else begin
                num_wait_cycles=num_wait_cycles+32'h1;
            end
        end
        else begin
            `uvm_info(get_type_name(),$psprintf("the timeout is not started"),UVM_DEBUG);
        end

        if(this.vif.master_cb.pready==1'b1) begin
            tr.data = this.vif.master_cb.prdata;
            tr.pslverr = this.vif.master_cb.pslverr;
            this.vif.master_cb.psel <= 'h0;             
            this.vif.master_cb.penable <= 'h0;
            if(this.cfg.apb4_enable==1'b1 || this.cfg.apb5_enable==1'b1)begin
                this.vif.master_cb.pstrb <= 'h0;
                this.vif.master_cb.pprot <= 'h0;
            end
            this.vif.master_cb.pwrite <= 'h0;             

            break;
        end
    end
endtask:read

function void tcnt_apb_master_agent_driver::tr_adapter(ref tcnt_apb_master_agent_transaction tr);
    for(int i=this.cfg.paddr_width;i<`TCNT_APB_MAX_ADDR_WIDTH;i++)begin
        tr.addr[i]=1'b0;
    end

    /**
        Read Data is controlled by slave
    */
    if(tr.xact_type==tcnt_apb_dec::WRITE)begin
        for(int i=this.cfg.pdata_width;i<`TCNT_APB_MAX_DATA_WIDTH;i=i+8)begin
            tr.data[i+:8]=8'h0;
        end
    end
endfunction:tr_adapter

function void tcnt_apb_master_agent_driver::wdata_byte_enable(ref tcnt_apb_master_agent_transaction tr);
    for(int i=0;i<`TCNT_APB_MAX_STRB_WIDTH;i++)begin
        if(tr.pstrb[i]==1'b0)begin
            tr.data[i*8+:8]=8'h0;
        end
    end
endfunction:wdata_byte_enable

`endif
