`ifndef TCNT_APB_MEM__SV
`define TCNT_APB_MEM__SV

class tcnt_apb_mem extends tcnt_mem #(`TCNT_APB_MAX_ADDR_WIDTH, `TCNT_APB_MAX_DATA_WIDTH);
    `uvm_object_utils(tcnt_apb_mem)

    /**
    * Constructor
    */
    function new(string name="tcnt_apb_mem");
        super.new(name);
    endfunction:new


    /**
    * write_reg()
    * write a `TCNT_APB_MAX_DATA_WIDTH of data into the mem_array
    */
    extern virtual function void write_reg(input bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] addr, input bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data, input bit[`TCNT_APB_MAX_STRB_WIDTH-1:0] strb, input bit apb4_enable);


    /**
    * read_reg()
    * read a `TCNT_APB_MAX_DATA_WIDTH of data from the mem_array
    */
    extern function void read_reg(input bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] addr, output bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data);
endclass


/**
* write_reg()
* write a `TCNT_APB_MAX_DATA_WIDTH of data into the mem_array
*/
function void tcnt_apb_mem::write_reg(input bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] addr, input bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data, input bit[`TCNT_APB_MAX_STRB_WIDTH-1:0] strb, input bit apb4_enable);
    bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data_r;
    bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data_t;

    // add by vicentcai, 2022-5-5
    if(apb4_enable==1'b1)begin
        this.read_mem(addr,data_r);
        for(int i=0;i<`TCNT_APB_MAX_STRB_WIDTH;i++)begin
            if(strb[i]==1'b1)begin
                data_t[i*8+:8]=data[i*8+:8];
            end
            else begin
                data_t[i*8+:8]=data_r[i*8+:8];
            end
        end
    end
    else begin
        data_t=data;
    end
    // end add

    this.write_mem(addr,data_t);
endfunction:write_reg


/**
* read_reg()
* read a `TCNT_APB_MAX_DATA_WIDTH of data from the mem_array
*/
function void tcnt_apb_mem::read_reg(input bit[`TCNT_APB_MAX_ADDR_WIDTH-1:0] addr, output bit[`TCNT_APB_MAX_DATA_WIDTH-1:0] data);
    this.read_mem(addr,data);
endfunction:read_reg

`endif
