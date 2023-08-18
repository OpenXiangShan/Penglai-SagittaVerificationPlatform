`ifndef TCNT_APB_SLAVE_AGENT_DRIVER__SV
`define TCNT_APB_SLAVE_AGENT_DRIVER__SV

class tcnt_apb_slave_agent_driver extends tcnt_driver_base#(virtual tcnt_apb_interface, tcnt_apb_slave_agent_cfg, tcnt_apb_slave_agent_transaction);
    uvm_tlm_analysis_fifo #(tcnt_apb_slave_agent_transaction) mon2drv_analysis_fifo;
    uvm_analysis_export   #(tcnt_apb_slave_agent_transaction) mon2drv_analysis_export;
    tcnt_apb_mem slave_mem;

    `uvm_component_utils(tcnt_apb_slave_agent_driver)
    `uvm_register_cb(tcnt_apb_slave_agent_driver,tcnt_apb_slave_agent_driver_callback)

    extern function new(string name="tcnt_apb_slave_agent_driver", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task write(ref tcnt_apb_slave_agent_transaction tr);
    extern virtual task read(ref tcnt_apb_slave_agent_transaction tr);
    extern task wait_cycles(ref tcnt_apb_slave_agent_transaction tr);
endclass

function tcnt_apb_slave_agent_driver::new(string name="tcnt_apb_slave_agent_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction:new

function void tcnt_apb_slave_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    this.mon2drv_analysis_fifo  = new("mon2drv_analysis_fifo",  this);
    this.mon2drv_analysis_export= new("mon2drv_analysis_export",this);
endfunction:build_phase

function void tcnt_apb_slave_agent_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    this.mon2drv_analysis_export.connect(this.mon2drv_analysis_fifo.analysis_export);
endfunction:connect_phase

task tcnt_apb_slave_agent_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(phase);

    // add by vicentcai 2022-5-7
    this.slave_mem.delete_mem();

    phase.drop_objection(phase);
endtask:reset_phase

task tcnt_apb_slave_agent_driver::run_phase(uvm_phase phase);
    tcnt_apb_slave_agent_transaction tr;
    tcnt_apb_slave_agent_transaction tr_lst;
    tcnt_apb_slave_agent_transaction tr_clone;

    super.run_phase(phase);

    this.vif.slave_cb.prdata <= 'h0; 
    this.vif.slave_cb.pready <= 'h0;
    this.vif.slave_cb.pslverr <= 'h0;
    @(posedge this.vif.prstn);

    while(1)begin
        fork
            begin
                void'(this.mon2drv_analysis_fifo.try_get(tr));
                if(tr != null)begin
                    case(tr.xact_type)
                        tcnt_apb_dec::READ:begin
                            this.read(tr);
                            $cast(tr_lst,tr.clone());
                        end
                        tcnt_apb_dec::WRITE:begin
                            this.write(tr);
                        end
                    endcase
                    $cast(tr_clone,tr.clone());
                    this.drv_item_port.write(tr_clone);
                end
                else begin
                    @(this.vif.slave_cb);
                    this.vif.slave_cb.pready <= 'h0;
                    case(this.cfg.drv_mode)
                        tcnt_dec_base::DRV_0:begin
                            this.vif.slave_cb.prdata <= 'h0; 
                            this.vif.slave_cb.pslverr <= 1'b0;
                            this.vif.slave_cb.pready <= 1'b0;
                        end
                        tcnt_dec_base::DRV_X:begin
                            this.vif.slave_cb.prdata <= 'hx; 
                            this.vif.slave_cb.pslverr <= 1'bx;
                            this.vif.slave_cb.pready <= 1'bx;
                        end
                        tcnt_dec_base::DRV_RAND:begin
                            this.vif.slave_cb.prdata <= $urandom; 
                            this.vif.slave_cb.pslverr <= $urandom;
                            this.vif.slave_cb.pready <= $urandom;
                        end
                        tcnt_dec_base::DRV_LST:begin
                            if(tr_lst != null)begin
                                this.vif.slave_cb.prdata <= tr_lst.data; 
                            end
                            else begin
                                this.vif.slave_cb.prdata <= 'h0; 
                            end
                            this.vif.slave_cb.pslverr <= 1'b0;
                            this.vif.slave_cb.pready <= 1'b0;
                        end
                        default:begin
                            this.vif.slave_cb.prdata <= 'h0; 
                            this.vif.slave_cb.pslverr <= 1'b0;
                            this.vif.slave_cb.pready <= 1'b0;
                        end
                    endcase
                end
            end
            begin
                @(negedge this.vif.prstn);
            end
        join_any
        disable fork;

        if(this.vif.prstn==1'b0)begin
            this.slave_mem.delete_mem();
            this.vif.slave_cb.prdata <= 'h0; 
            this.vif.slave_cb.pready <= 'h0;
            this.vif.slave_cb.pslverr <= 'h0;
        end

        while(1)begin
            if(this.vif.prstn==1'b1)begin
                break;
            end
            @(this.vif.slave_cb);
        end
    end
endtask:run_phase


task tcnt_apb_slave_agent_driver::read(ref tcnt_apb_slave_agent_transaction tr);
    bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data;

    if(this.vif.slave_cb.psel==1'b1)begin
        this.slave_mem.read_reg(tr.addr, data);
        for(int i=this.cfg.pdata_width;i<`TCNT_APB_MAX_DATA_WIDTH;i=i+8)begin
            data[i+:8]=8'h0;
        end
        tr.data = data;

        `uvm_do_callbacks(tcnt_apb_slave_agent_driver,tcnt_apb_slave_agent_driver_callback,pre_send(tr))

        if(this.cfg.disable_wait_cycles==1'b0)begin
            this.wait_cycles(tr);
        end

        //@(this.vif.slave_cb);
        this.vif.slave_cb.prdata <= tr.data;//data;
        this.vif.slave_cb.pready <= 1'b1;
        this.vif.slave_cb.pslverr <= 1'b0;
    end
    else begin
        this.vif.slave_cb.prdata <= 'h0;
        this.vif.slave_cb.pready <= 1'b0;
        this.vif.slave_cb.pslverr <= 1'b0;
    end
endtask:read


task tcnt_apb_slave_agent_driver::write(ref tcnt_apb_slave_agent_transaction tr);
    //change by vicentcai, 2022-5-5
    ////Write Data width is controlled by master
    //if(this.cfg.apb4_enable==1'b1)begin
    //    for(int i=0;i<`TCNT_APB_MAX_STRB_WIDTH;i++)begin
    //        if(tr.pstrb[i]==1'b0)begin
    //            tr.data[i*8+:8]=8'h0;
    //        end
    //    end
    //end

    if(this.vif.slave_cb.psel==1'b1)begin
        `uvm_do_callbacks(tcnt_apb_slave_agent_driver,tcnt_apb_slave_agent_driver_callback,pre_send(tr))

        //change by vicentcai, 2022-5-5
        //this.slave_mem.write_reg(tr.addr, tr.data);
        this.slave_mem.write_reg(tr.addr, tr.data, tr.pstrb, this.cfg.apb4_enable);

        if(this.cfg.disable_wait_cycles==1'b0)begin
            this.wait_cycles(tr);
        end

        //@(this.vif.slave_cb);
        this.vif.slave_cb.pready <= 1'b1;
        this.vif.slave_cb.pslverr <= 1'b0;
    end
    else begin
        this.vif.slave_cb.pready <= 1'b0;
        this.vif.slave_cb.pslverr <= 1'b0;
    end
endtask:write


task tcnt_apb_slave_agent_driver::wait_cycles(ref tcnt_apb_slave_agent_transaction tr);
    repeat(tr.num_wait_cycles)begin
        if(this.vif.slave_cb.psel==1'b1)begin
            this.vif.slave_cb.pready <= 1'b0;
            @(this.vif.slave_cb);
        end
        else begin
            break;
        end
    end
endtask:wait_cycles
`endif
