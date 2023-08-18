`ifndef TCNT_APB_CFG__SV
`define TCNT_APB_CFG__SV

class tcnt_apb_cfg extends tcnt_agent_cfg_base;
    paddr_width_enum paddr_width = PADDR_WIDTH_32;
    pdata_width_enum pdata_width = PDATA_WIDTH_32;
    bit apb4_enable = 1'b0;
    bit apb5_enable = 1'b0;
    bit apb_cov_enable = 1'b0;
    bit addr_unalign_check = 1'b1;

    bit apb_protocol_check_enable = 1'b1;
    bit pprot_changed_during_transfer_en = 1'b1;
    bit pstrb_changed_during_transfer_en = 1'b1;
    bit pwdata_changed_during_transfer_en = 1'b1;
    bit pwrite_changed_during_transfer_en = 1'b1;
    bit paddr_changed_during_transfer_en = 1'b1;
	bit pstrb_low_for_read_en = 1'b1;
	bit signal_valid_pprot_check_en = 1'b1;
	bit signal_valid_pstrb_check_en = 1'b1;
	bit signal_valid_pslverr_check_en = 1'b1;
	bit signal_valid_pready_check_en = 1'b1;
	bit signal_valid_prdata_check_en = 1'b1;
	bit signal_valid_pwdata_check_en = 1'b1;
	bit signal_valid_penable_check_en = 1'b1;
	bit signal_valid_pwrite_check_en = 1'b1;
	bit signal_valid_paddr_check_en = 1'b1;
	bit signal_valid_psel_check_en = 1'b1;
	bit setup_to_setup_en = 1'b1;
	bit setup_to_idle_en = 1'b1;
	bit idle_to_access_en = 1'b1;
	bit initial_bus_state_after_reset_en = 1'b1;
  	bit penable_after_psel_en = 1'b1;

	`uvm_object_utils_begin(tcnt_apb_cfg)
		`uvm_field_enum(paddr_width_enum, paddr_width, UVM_ALL_ON)
		`uvm_field_enum(pdata_width_enum, pdata_width, UVM_ALL_ON)
        `uvm_field_int(apb4_enable, UVM_ALL_ON)
        `uvm_field_int(apb5_enable, UVM_ALL_ON)
        `uvm_field_int(apb_cov_enable, UVM_ALL_ON)
        `uvm_field_int(addr_unalign_check, UVM_ALL_ON)
        `uvm_field_int(apb_protocol_check_enable, UVM_ALL_ON)
        `uvm_field_int(pprot_changed_during_transfer_en, UVM_ALL_ON)
        `uvm_field_int(pstrb_changed_during_transfer_en, UVM_ALL_ON)
        `uvm_field_int(pwdata_changed_during_transfer_en, UVM_ALL_ON)
        `uvm_field_int(pwrite_changed_during_transfer_en, UVM_ALL_ON)
        `uvm_field_int(paddr_changed_during_transfer_en, UVM_ALL_ON)
	    `uvm_field_int(pstrb_low_for_read_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pprot_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pstrb_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pslverr_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pready_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_prdata_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pwdata_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_penable_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_pwrite_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_paddr_check_en, UVM_ALL_ON)
	    `uvm_field_int(signal_valid_psel_check_en, UVM_ALL_ON)
	    `uvm_field_int(setup_to_setup_en, UVM_ALL_ON)
	    `uvm_field_int(setup_to_idle_en, UVM_ALL_ON)
	    `uvm_field_int(idle_to_access_en, UVM_ALL_ON)
	    `uvm_field_int(initial_bus_state_after_reset_en, UVM_ALL_ON)
  	    `uvm_field_int(penable_after_psel_en, UVM_ALL_ON)
	`uvm_object_utils_end

    extern constraint default_drv_mode_cons;

	function new(string name="tcnt_apb_cfg");
		super.new(name);
	endfunction:new
endclass:tcnt_apb_cfg

/*
default drv_mode is drive 0
**/
constraint tcnt_apb_cfg::default_drv_mode_cons{
    this.drv_mode inside {tcnt_dec_base::DRV_0,
                          tcnt_dec_base::DRV_X,
                          tcnt_dec_base::DRV_RAND,
                          tcnt_dec_base::DRV_LST};    
}

`endif
