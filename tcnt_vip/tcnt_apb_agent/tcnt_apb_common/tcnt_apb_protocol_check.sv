`ifndef TCNT_APB_PROTOCOL_CHECK__SV
`define TCNT_APB_PROTOCOL_CHECK__SV

class tcnt_apb_protocol_check extends uvm_component;
    tcnt_apb_cfg cfg;
    virtual tcnt_apb_interface vif;
	logic [`TCNT_APB_MAX_ADDR_WIDTH-1:0] his_paddr  ;
	logic                                his_psel   ;
	logic                                his_penable;
	logic                                his_pwrite ;
    logic [2:0]                          his_pprot  ;
    logic [`TCNT_APB_MAX_STRB_WIDTH-1:0] his_pstrb  ;
	logic [`TCNT_APB_MAX_DATA_WIDTH-1:0] his_pwdata ;
	logic [`TCNT_APB_MAX_DATA_WIDTH-1:0] his_prdata ;
	logic                                his_pready ;
    logic                                his_pslverr;

    `uvm_component_utils_begin(tcnt_apb_protocol_check)
        `uvm_field_object(cfg, UVM_ALL_ON)
	    `uvm_field_int(his_paddr, UVM_ALL_ON)
	    `uvm_field_int(his_psel, UVM_ALL_ON)
	    `uvm_field_int(his_penable, UVM_ALL_ON)
	    `uvm_field_int(his_pwrite, UVM_ALL_ON)
        `uvm_field_int(his_pprot, UVM_ALL_ON)
        `uvm_field_int(his_pstrb, UVM_ALL_ON)
	    `uvm_field_int(his_pwdata, UVM_ALL_ON)
	    `uvm_field_int(his_prdata, UVM_ALL_ON)
	    `uvm_field_int(his_pready, UVM_ALL_ON)
        `uvm_field_int(his_pslverr, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task store_previous_cycle_value();
    extern task pprot_changed_during_transfer();
    extern task pstrb_changed_during_transfer();
    extern task pwdata_changed_during_transfer();
    extern task pwrite_changed_during_transfer();
    extern task paddr_changed_during_transfer();
	extern task pstrb_low_for_read();
	extern task signal_valid_pprot_check();
	extern task signal_valid_pstrb_check();
	extern task signal_valid_pslverr_check();
	extern task signal_valid_pready_check();
	extern task signal_valid_prdata_check();
	extern task signal_valid_pwdata_check();
	extern task signal_valid_penable_check();
	extern task signal_valid_pwrite_check();
	extern task signal_valid_paddr_check();
	extern task signal_valid_psel_check();
	extern task setup_to_setup();
	extern task setup_to_idle();
	extern task idle_to_access();
	extern task initial_bus_state_after_reset();
  	extern task penable_after_psel();
endclass

function tcnt_apb_protocol_check::new(string name, uvm_component parent);
    super.new(name, parent);

    this.his_paddr   = 'h0;
	this.his_psel    = 'h0;
	this.his_penable = 'h0;
	this.his_pwrite  = 'h0;
    this.his_pprot   = 'h0;
    this.his_pstrb   = 'h0;
	this.his_pwdata  = 'h0;
	this.his_prdata  = 'h0;
	this.his_pready  = 'h0;
    this.his_pslverr = 'h0;
endfunction

function void tcnt_apb_protocol_check::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(tcnt_apb_cfg)::get(this,"","cfg",this.cfg)) begin
        `uvm_fatal(get_type_name(),$psprintf("Can't get cfg in %0s",get_type_name()));
    end
    else begin
        `uvm_info(get_type_name(),$psprintf("get cfg in %0s",get_type_name()),UVM_DEBUG);
    end

    if(!uvm_config_db#(virtual tcnt_apb_interface)::get(this,"","vif",this.vif)) begin
        `uvm_fatal(get_type_name(),$psprintf("Can't get vif in %0s",get_type_name()));
    end
    else begin
        `uvm_info(get_type_name(),$psprintf("get vif in %0s",get_type_name()),UVM_DEBUG);
    end
endfunction

task tcnt_apb_protocol_check::run_phase(uvm_phase phase);
    super.run_phase(phase);

    @(posedge this.vif.prstn);
    @(posedge this.vif.pclk);
	this.initial_bus_state_after_reset();

    while(1)begin
        fork
            begin
                @(posedge this.vif.pclk);
                fork
                    this.pprot_changed_during_transfer();
                    this.pstrb_changed_during_transfer();
                    this.pwdata_changed_during_transfer();
                    this.pwrite_changed_during_transfer();
                    this.paddr_changed_during_transfer();
	                this.pstrb_low_for_read();
	                this.signal_valid_pprot_check();
	                this.signal_valid_pstrb_check();
	                this.signal_valid_pslverr_check();
	                this.signal_valid_pready_check();
	                this.signal_valid_prdata_check();
	                this.signal_valid_pwdata_check();
	                this.signal_valid_penable_check();
	                this.signal_valid_pwrite_check();
	                this.signal_valid_paddr_check();
	                this.signal_valid_psel_check();
	                this.setup_to_setup();
	                this.setup_to_idle();
	                this.idle_to_access();
  	                this.penable_after_psel();
                join
                this.store_previous_cycle_value();
            end
            begin
                @(negedge this.vif.prstn);
            end
        join_any
        disable fork;

        if(this.vif.prstn==1'b0)begin
            this.his_paddr   = 'h0;
	        this.his_psel    = 'h0;
	        this.his_penable = 'h0;
	        this.his_pwrite  = 'h0;
            this.his_pprot   = 'h0;
            this.his_pstrb   = 'h0;
	        this.his_pwdata  = 'h0;
	        this.his_prdata  = 'h0;
	        this.his_pready  = 'h0;
            this.his_pslverr = 'h0;
        end

        while(1)begin
            if(this.vif.prstn==1'b1)begin
                break;
            end
            @(posedge this.vif.pclk);
        end
    end
endtask:run_phase

task tcnt_apb_protocol_check::pprot_changed_during_transfer();
    if(this.cfg.apb4_enable == 1'b1 && this.cfg.pprot_changed_during_transfer_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            if(this.vif.monitor_cb.pprot !== this.his_pprot)begin
                `uvm_error("pprot_changed_during_transfer",$psprintf("pprot changed during transfer"));
            end
        end
    end
endtask:pprot_changed_during_transfer

task tcnt_apb_protocol_check::pstrb_changed_during_transfer();
    if(this.cfg.apb4_enable == 1'b1 && this.cfg.pstrb_changed_during_transfer_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            if(this.vif.monitor_cb.pstrb !== this.his_pstrb)begin
                `uvm_error("pstrb_changed_during_transfer",$psprintf("pstrb changed during transfer"));
            end
        end
    end
endtask:pstrb_changed_during_transfer

task tcnt_apb_protocol_check::pwdata_changed_during_transfer();
    if(this.cfg.pwdata_changed_during_transfer_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            if(this.vif.monitor_cb.pwdata !== this.his_pwdata)begin
                `uvm_error("pwdata_changed_during_transfer",$psprintf("pwdata changed during transfer"));
            end
        end
    end
endtask:pwdata_changed_during_transfer

task tcnt_apb_protocol_check::pwrite_changed_during_transfer();
    if(this.cfg.pwrite_changed_during_transfer_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            if(this.vif.monitor_cb.pwrite !== this.his_pwrite)begin
                `uvm_error("pwrite_changed_during_transfer",$psprintf("pwrite changed during transfer"));
            end
        end
    end
endtask:pwrite_changed_during_transfer

task tcnt_apb_protocol_check::paddr_changed_during_transfer();
    if(this.cfg.paddr_changed_during_transfer_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            if(this.vif.monitor_cb.paddr !== this.his_paddr)begin
                `uvm_error("paddr_changed_during_transfer",$psprintf("paddr changed during transfer"));
            end
        end
    end
endtask:paddr_changed_during_transfer

task tcnt_apb_protocol_check::pstrb_low_for_read();
    if(this.cfg.apb4_enable == 1'b1 && this.cfg.pstrb_low_for_read_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1 && this.vif.monitor_cb.pwrite == 1'b0)begin
            if(this.vif.monitor_cb.pstrb !== 0)begin
                `uvm_error("pstrb_low_for_read",$psprintf("pstrb should be low during read transfer"));
            end
        end
    end
endtask:pstrb_low_for_read

task tcnt_apb_protocol_check::signal_valid_pprot_check();
    if(this.cfg.apb4_enable == 1'b1 && this.cfg.signal_valid_pprot_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.pprot))begin
            `uvm_error("signal_valid_pprot_check",$psprintf("monitor X or Z on pprot"));
        end
    end
endtask:signal_valid_pprot_check

task tcnt_apb_protocol_check::signal_valid_pstrb_check();
    if(this.cfg.apb4_enable == 1'b1 && this.cfg.signal_valid_pstrb_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.pstrb))begin
            `uvm_error("signal_valid_pstrb_check",$psprintf("monitor X or Z on pstrb"));
        end
    end
endtask:signal_valid_pstrb_check

task tcnt_apb_protocol_check::signal_valid_pslverr_check();
    if(this.cfg.signal_valid_pslverr_check_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1 && this.vif.monitor_cb.pready == 1'b1)begin
            if($isunknown(this.vif.monitor_cb.pslverr))begin
                `uvm_error("signal_valid_pslverr_check",$psprintf("monitor X or Z on pslverr"));
            end
        end
    end
endtask:signal_valid_pslverr_check

task tcnt_apb_protocol_check::signal_valid_pready_check();
    if(this.cfg.signal_valid_pready_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.pready))begin
            `uvm_error("signal_valid_pready_check",$psprintf("monitor X or Z on pready"));
        end
    end
endtask:signal_valid_pready_check

task tcnt_apb_protocol_check::signal_valid_prdata_check();
    if(this.cfg.signal_valid_prdata_check_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1 && this.vif.monitor_cb.pwrite == 1'b0 && this.vif.monitor_cb.pready == 1'b1)begin
            if($isunknown(this.vif.monitor_cb.prdata))begin
                `uvm_error("signal_valid_prdata_check",$psprintf("monitor X or Z on prdata"));
            end
        end
    end
endtask:signal_valid_prdata_check

task tcnt_apb_protocol_check::signal_valid_pwdata_check();
    if(this.cfg.signal_valid_pwdata_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.pwrite == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.pwdata))begin
            `uvm_error("signal_valid_pwdata_check",$psprintf("monitor X or Z on pwdata"));
        end
    end
endtask:signal_valid_pwdata_check

task tcnt_apb_protocol_check::signal_valid_penable_check();
    if(this.cfg.signal_valid_penable_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.penable))begin
            `uvm_error("signal_valid_penable_check",$psprintf("monitor X or Z on penable"));
        end
    end
endtask:signal_valid_penable_check

task tcnt_apb_protocol_check::signal_valid_pwrite_check();
    if(this.cfg.signal_valid_pwrite_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.pwrite))begin
            `uvm_error("signal_valid_pwrite_check",$psprintf("monitor X or Z on pwrite"));
        end
    end
endtask:signal_valid_pwrite_check

task tcnt_apb_protocol_check::signal_valid_paddr_check();
    if(this.cfg.signal_valid_paddr_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.paddr))begin
            `uvm_error("signal_valid_paddr_check",$psprintf("monitor X or Z on paddr"));
        end
    end
endtask:signal_valid_paddr_check

task tcnt_apb_protocol_check::signal_valid_psel_check();
    if(this.cfg.signal_valid_psel_check_en == 1'b1 && this.vif.monitor_cb.psel == 1'b1)begin
        if($isunknown(this.vif.monitor_cb.psel))begin
            `uvm_error("signal_valid_psel_check",$psprintf("monitor X or Z on psel"));
        end
    end
endtask:signal_valid_psel_check

task tcnt_apb_protocol_check::setup_to_setup();
    if(this.cfg.setup_to_setup_en == 1'b1)begin
        if(this.vif.monitor_cb.psel === 1'b1 && this.vif.monitor_cb.penable === 1'b0)begin
            if(this.his_psel === 1'b1 && this.his_penable === 1'b0)begin
                `uvm_error("setup_to_setup",$psprintf("illegal state transition occured from setup to setup"));
            end
        end
    end
endtask:setup_to_setup

task tcnt_apb_protocol_check::setup_to_idle();
    if(this.cfg.setup_to_idle_en == 1'b1)begin
        if(this.vif.monitor_cb.psel === 1'b0)begin
            if(this.his_psel === 1'b1 && this.his_penable === 1'b0)begin
                `uvm_error("setup_to_idle",$psprintf("illegal state transition occured from setup to idle"));
            end
        end
    end
endtask:setup_to_idle

task tcnt_apb_protocol_check::idle_to_access();
    if(this.cfg.idle_to_access_en == 1'b1)begin
        if(this.vif.monitor_cb.psel === 1'b1 && this.vif.monitor_cb.penable === 1'b1)begin
            if(this.his_psel === 1'b0 && this.his_penable === 1'b0)begin
                `uvm_error("idle_to_access",$psprintf("illegal state transition occured from idle to access"));
            end
        end
    end
endtask:idle_to_access

task tcnt_apb_protocol_check::initial_bus_state_after_reset();
    if(this.cfg.initial_bus_state_after_reset_en == 1'b1)begin
        if(this.vif.monitor_cb.psel == 1'b1 && this.vif.monitor_cb.penable == 1'b1)begin
            `uvm_error("initial_bus_state_after_reset",$psprintf("apb bus is in access state after reset deassertion"));
        end
    end
endtask:initial_bus_state_after_reset

task tcnt_apb_protocol_check::penable_after_psel();
    if(this.cfg.penable_after_psel_en == 1'b1)begin
        if(this.vif.monitor_cb.psel === 1'b1 && this.his_psel === 1'b1 && this.his_pready === 1'b0)begin
            if(this.vif.monitor_cb.penable === 1'b0)begin
                `uvm_error("penable_after_psel",$psprintf("penable should asserted after psel is asserted"));
            end
        end
    end
endtask:penable_after_psel

task tcnt_apb_protocol_check::store_previous_cycle_value();
	his_paddr   = this.vif.monitor_cb.paddr;
	his_psel    = this.vif.monitor_cb.psel;
	his_penable = this.vif.monitor_cb.penable;
	his_pwrite  = this.vif.monitor_cb.pwrite;
    his_pprot   = this.vif.monitor_cb.pprot;
    his_pstrb   = this.vif.monitor_cb.pstrb;
	his_pwdata  = this.vif.monitor_cb.pwdata;
	his_prdata  = this.vif.monitor_cb.prdata;
	his_pready  = this.vif.monitor_cb.pready;
    his_pslverr = this.vif.monitor_cb.pslverr;
endtask:store_previous_cycle_value
`endif
