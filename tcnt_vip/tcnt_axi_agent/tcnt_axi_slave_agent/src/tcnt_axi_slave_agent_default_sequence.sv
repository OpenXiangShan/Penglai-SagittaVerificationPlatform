`ifndef TCNT_AXI_SLAVE_AGENT_DEFAULT_SEQUENCE__SV
`define TCNT_AXI_SLAVE_AGENT_DEFAULT_SEQUENCE__SV
typedef tcnt_axi_slave_agent_sequencer;
class tcnt_axi_slave_agent_default_sequence  extends tcnt_default_sequence_base #(tcnt_axi_xaction);
   
    `uvm_declare_p_sequencer(tcnt_axi_slave_agent_sequencer) 
    `uvm_object_utils(tcnt_axi_slave_agent_default_sequence)
    tcnt_axi_cfg cfg;
    string tname = "";

    extern function new(string name="tcnt_axi_slave_agent_default_sequence");
    extern virtual task pre_body();
    extern virtual task body();
    extern virtual task post_body();
    extern virtual function bit  is_valid_transaction_need_to_put_response(tcnt_axi_xaction xact);
    extern virtual function void put_write_transaction_data_to_mem(tcnt_axi_xaction xact);
    extern virtual function void get_read_data_from_mem_to_transaction(ref tcnt_axi_xaction xact);
    //extern virtual function void post_read_mem_access(ref tcnt_axi_xaction xact);
endclass:tcnt_axi_slave_agent_default_sequence

function  tcnt_axi_slave_agent_default_sequence::new(string name= "tcnt_axi_slave_agent_default_sequence");
    super.new(name);
    tname = get_name();
endfunction:new

function bit tcnt_axi_slave_agent_default_sequence::is_valid_transaction_need_to_put_response(tcnt_axi_xaction xact);
    if(xact.unique_id inside {p_sequencer.unique_id_q})
        return 0;
    else begin
        p_sequencer.unique_id_q.push_back(xact.unique_id);
        return 1;
    end
endfunction

function void tcnt_axi_slave_agent_default_sequence::put_write_transaction_data_to_mem(tcnt_axi_xaction xact);
    if((xact.xact_type   == tcnt_axi_dec::WRITE)  &&
       (xact.addr_status == tcnt_axi_dec::ACCEPT) &&
       (xact.data_status == tcnt_axi_dec::ACCEPT))begin
        `uvm_info(tname,"ready to write xact into mem.",UVM_DEBUG)
        foreach(xact.data[i])begin
            int lbt_lane,ubt_lane;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] byte_addr;
            xact.get_beat_addr_and_lane(i,byte_addr,lbt_lane,ubt_lane);
            for(int l=lbt_lane;l<=ubt_lane;l++)begin
                if(((xact.wstrb[i] >> l) & 1'b1))begin
                    logic [7:0] byte_data = ((xact.data[i] >> (l*8)) & 'hff);
                    p_sequencer.mem_handle.write_byte(byte_addr+l-lbt_lane,byte_data);
                end
            end
        end
    end
endfunction

function void tcnt_axi_slave_agent_default_sequence::get_read_data_from_mem_to_transaction(ref tcnt_axi_xaction xact);
    if((xact.xact_type   == tcnt_axi_dec::READ) &&
       (xact.addr_status inside {tcnt_axi_dec::ACTIVE,tcnt_axi_dec::ACCEPT}))begin
        `uvm_info(tname,"ready to read data from mem.",UVM_DEBUG)
        if(xact.data.size() == 0)
            xact.data = new[xact.burst_length];
        foreach(xact.data[i])begin
            int lbt_lane,ubt_lane;
            bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] byte_addr;
            xact.get_beat_addr_and_lane(i,byte_addr,lbt_lane,ubt_lane);
            `uvm_info(tname,$sformatf("i = %0d;byte_addr=%0h;lbt_lane=%0d;ubt_lane=%0d",i,byte_addr,lbt_lane,ubt_lane),UVM_DEBUG)
            for(int l=lbt_lane;l<=ubt_lane;l++)begin
                bit [7:0] byte_data;
                p_sequencer.mem_handle.read_byte(byte_addr+l-lbt_lane,byte_data);
                xact.data[i] |= (byte_data << (l*8));
            end
        end
        //post_read_mem_access(xact);
        `uvm_info(tname,{"xact after reading data from mem:\n",xact.sprint()},UVM_DEBUG)
    end
endfunction

//function void tcnt_axi_slave_agent_default_sequence::post_read_mem_access(ref tcnt_axi_xaction xact);
    /* can do data access, or generate parity related to data
       Example below : 
    */

    //foreach(xact.data[i])begin
    //    xact.data_user[i] = xact.data[i];
    //    `uvm_info(tname,$sformatf("post_read_mem_access : data[%0d] =0x%0h",i,xact.data[i]),UVM_LOW)
    //end
//endfunction

task tcnt_axi_slave_agent_default_sequence::pre_body();  
    //if(starting_phase != null) 
    //    starting_phase.raise_objection(this);
endtask:pre_body

task tcnt_axi_slave_agent_default_sequence::body();
    //repeat (10) begin
    //    `uvm_do(req)
    //end
endtask:body

task tcnt_axi_slave_agent_default_sequence::post_body();
    //if(starting_phase != null) 
    //    starting_phase.drop_objection(this);
endtask:post_body

`endif

