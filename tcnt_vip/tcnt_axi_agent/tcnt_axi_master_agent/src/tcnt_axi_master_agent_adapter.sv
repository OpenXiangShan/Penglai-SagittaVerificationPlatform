`ifndef TCNT_AXI_MASTER_AGENT_ADAPTER_SVH
`define TCNT_AXI_MASTER_AGENT_ADAPTER_SVH

class tcnt_axi_master_agent_adapter extends uvm_reg_adapter;
    `uvm_object_utils(tcnt_axi_master_agent_adapter)

    tcnt_axi_cfg    cfg;

    function new( string name="");
        super.new(name);
		provides_responses = 1;
        supports_byte_enable = 1;
    endfunction

    extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
endclass

function void tcnt_axi_master_agent_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

    uvm_reg_item rw_access = new();
    int unsigned size_of_value;
    tcnt_axi_xaction xact;
    bit [32:0]      data_temp;
    bit [3:0]       wstrb_temp;
    
    if (!$cast(xact, bus_item)) begin
        `uvm_fatal("tcnt_axi_master_agent_adapter","Provided bus_item is not of the correct type")
        return;
    end

    if (xact.xact_type == tcnt_axi_dec::WRITE ) begin
        if(xact.wstrb[0] & 4'hf != 4'hf) begin
            `uvm_error("tcnt_axi_master_agent_adapter" , $psprintf("wstrb = %h",xact.wstrb[0]))
            return;
        end
        else begin
            rw.kind = UVM_WRITE ;
        end
    end
    else if (xact.xact_type == tcnt_axi_dec::READ ) begin
        rw.kind = UVM_READ ; 
    end
    else 
    begin
        `uvm_error("tcnt_axi_master_agent_adapter" , "transcation is not write or read")
        return;
    end

    if (xact.burst_size != tcnt_axi_dec::BURST_SIZE_32BIT ) begin
        `uvm_error("tcnt_axi_master_agent_adapter" , $psprintf("burst_size = %0d",xact.burst_size))
        return;
    end

    if (xact.burst_length != 1 ) begin
        `uvm_error("tcnt_axi_master_agent_adapter" , $psprintf("burst_length = %0d",xact.burst_length))
        return;
    end


    rw.addr = xact.addr;
    rw.data = xact.data[0];

    rw.status = UVM_IS_OK;

    if (xact.xact_type == tcnt_axi_dec::READ && xact.rresp[0] != tcnt_axi_dec::OKAY ) begin
        rw.status = UVM_NOT_OK;
    end
    if (xact.xact_type == tcnt_axi_dec::WRITE && xact.bresp != tcnt_axi_dec::OKAY ) begin
        rw.status = UVM_NOT_OK;
    end

	//if(rw.kind == UVM_REG) rw_access.element_kind = UVM_REG;
	//if(rw.kind == UVM_MEM) rw_access.element_kind = UVM_MEM;
    //m_set_item(rw_access);

endfunction: bus2reg

function uvm_sequence_item tcnt_axi_master_agent_adapter::reg2bus(const ref uvm_reg_bus_op rw);
    int           byte_num;
    int           byte_unaligned;
    
    uvm_reg_item rw_access;
    tcnt_axi_xaction xact; 
    `uvm_info(get_type_name(),$psprintf ("Inside reg2bus transfer"), UVM_DEBUG);
    
    xact = tcnt_axi_xaction::type_id::create("xact");  
    rw_access = new();
    rw_access = get_item();
    if(rw_access.element_kind == UVM_REG || rw_access.element_kind == UVM_MEM || rw_access.element_kind == UVM_FIELD ) begin
        if(cfg == null) begin
            `uvm_fatal("tcnt_axi_master_agent_adapter",$psprintf ("cfg(#tcnt_axi_cfg) should be instantiation from outside"));
        end
        xact.cfg        = cfg ;
        xact.xact_type       = (rw.kind == UVM_READ) ? tcnt_axi_dec::READ : tcnt_axi_dec::WRITE ;  
        xact.addr            = rw.addr ;    
        xact.burst_type      = tcnt_axi_dec::INCR ;
        xact.burst_size      = tcnt_axi_dec::BURST_SIZE_32BIT;    
        xact.atomic_type     = tcnt_axi_dec::NORMAL ;
        xact.burst_length    = 1 ;
        xact.prot_type       = tcnt_axi_dec::DATA_NON_SECURE_NORMAL ;
        xact.cache_type      = 0 ;
        xact.data            = new[xact.burst_length] ;
        xact.data_user       = new[xact.burst_length] ;
        if(rw.kind == UVM_WRITE)begin
            xact.data_user[0][0] = (^rw.data[7:0])   ;
            xact.data_user[0][1] = (^rw.data[15:8])  ;
            xact.data_user[0][2] = (^rw.data[23:16]) ;
            xact.data_user[0][3] = (^rw.data[31:24]) ;
        end
    
        xact.id              = 0 ;
        xact.data[0]         = rw.data ;
    
        if(xact.xact_type == tcnt_axi_dec::WRITE ) 
        begin
            xact.wstrb           = new[xact.burst_length] ;
            if( (supports_byte_enable == 1) && (rw_access.element_kind == UVM_REG || rw_access.element_kind == UVM_FIELD )) begin
                xact.wstrb[0] = 'h0;
                for( int i=0; i<4; i++ ) begin
                    xact.wstrb[0][i] = rw.byte_en[i];
                end
            end
            else 
                xact.wstrb[0]        = 64'hf;

            xact.wvalid_delay    = new[xact.burst_length] ;
            xact.wvalid_delay[0] = 0;
            xact.bready_delay = $urandom_range(3,0);
            if(rw.status == UVM_IS_OK) begin
                xact.bresp = tcnt_axi_dec::OKAY;
            end
            else begin
                xact.bresp = tcnt_axi_dec::SLVERR;
            end

            if( supports_byte_enable == 1 ) begin
                xact.wstrb[0] = 'h0;
                for( int i=0; i<4; i++ ) begin
                    xact.wstrb[0][i] = rw.byte_en[i];
                end
            end
        end
    
        if(xact.xact_type == tcnt_axi_dec::READ ) begin
            xact.rresp           = new[xact.burst_length] ;
            xact.rready_delay    = new[xact.burst_length] ;
            xact.rready_delay[0] = $urandom_range(3,0);
            if(rw.status == UVM_IS_OK) begin
                xact.rresp[0] = tcnt_axi_dec::OKAY;
            end
            else begin
                xact.rresp[0] = tcnt_axi_dec::SLVERR;
            end
        end
        return xact;
    end
endfunction : reg2bus

`endif
