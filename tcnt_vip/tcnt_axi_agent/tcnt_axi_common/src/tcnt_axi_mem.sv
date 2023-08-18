`ifndef TCNT_AXI_MEM__SV
`define TCNT_AXI_MEM__SV
class tcnt_axi_mem extends tcnt_mem#(`TCNT_AXI_MAX_ADDR_WIDTH,`TCNT_AXI_MAX_DATA_WIDTH);

    `uvm_object_param_utils(tcnt_axi_mem)

    /**
    * Constructor
    */
    function new(string name="tcnt_axi_mem");
        super.new(name);
        //addr_width=DATA_WIDTH/8;
        //`uvm_info(get_type_name(),$psprintf("ADDR_WIDTH=%0d, DATA_WIDTH=%0d",ADDR_WIDTH,DATA_WIDTH),UVM_DEBUG);        
    endfunction:new
    
    function void write_4byte(bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] addr,bit [31:0] data_4byte);
        for(int i = 0;i<4;i++)begin
            write_byte(addr+i,(data_4byte >> (i*8)) & 'hff);
        end
    endfunction

    function void read_4byte(bit [`TCNT_AXI_MAX_ADDR_WIDTH-1:0] addr,output bit [31:0] data_4byte);
        for(int i = 0;i<4;i++)begin
            bit [7:0] data_byte;
            read_byte(addr+i,data_byte);
            data_4byte[i*8+:8] = data_byte;
        end
    endfunction    
endclass
`endif
