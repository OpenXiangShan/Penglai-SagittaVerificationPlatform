module axi2ram_addr_gen #(
    parameter   C_AW = 32,
    parameter   C_ID = 16,
    parameter   C_RAM_AW = 15,
    parameter   C_RDW = 128
)(
    //Outputs
    axch_pop, ram_cmd_push, ram_cmd_info,
    //Inputs
    aclk_s, rst_n, axch_info, axch_empty,
    ram_cmd_full
);

    localparam AX_INFO_W = C_ID+C_AW+8+3+2;
    localparam CMD_INFO_W = C_ID+C_RAM_AW+1+1;
    localparam RAM_BW = $clog2(C_RDW/8);

    input                   aclk_s;
    input                   rst_n;
    input [AX_INFO_W-1:0]   axch_info;
    input                   axch_empty;
    input                   ram_cmd_full;

    output                  axch_pop;
    output                  ram_cmd_push;
    output [CMD_INFO_W-1:0] ram_cmd_info;

    wire [C_ID-1:0]         axi_axid;
    wire [7:0]              axi_axlen;
    wire [C_AW-1:0]         axi_axaddr;
    wire [2:0]              axi_axsize;
    wire [1:0]              axi_axburst;

    reg [7:0]               addr_cnt;
    /*---------------------------------------------------*/
    /*  generate axi_axch_fifo pop and recovery axi info */
    /*---------------------------------------------------*/
    assign axch_pop = ~axch_empty & (addr_cnt == axi_axlen) & ~ram_cmd_full;
    assign {axi_axid, axi_axaddr, axi_axlen, axi_axsize, axi_axburst} = axch_info;

    reg [7:0]               addr_incr_step;
    always @(*) begin
        case(axi_axsize)
            3'h0: addr_incr_step = 8'd1;
            3'h1: addr_incr_step = 8'd2;
            3'h2: addr_incr_step = 8'd4;
            3'h3: addr_incr_step = 8'd8;
            3'h4: addr_incr_step = 8'd16;
            3'h5: addr_incr_step = 8'd32;
            3'h6: addr_incr_step = 8'd64;
            3'h7: addr_incr_step = 8'd128;
        endcase
    end

    /*---------------------------------------------------*/
    /*  generate axi_addr_next and counter number        */
    /*---------------------------------------------------*/
    wire                    addr_cnt_en;
    wire                    addr_cnt_clr;
    wire                    single_access;
    wire                    access_last;
    wire                    access_start;
    wire [C_RAM_AW:0]       ram_addr;
    assign single_access = (axi_axlen == 0);
    assign access_start = (addr_cnt == 0);
    assign access_last = ~axch_empty & (addr_cnt == axi_axlen);
    assign addr_cnt_en = ~axch_empty & ~ram_cmd_full;
    assign addr_cnt_clr = (addr_cnt == axi_axlen) & ~ram_cmd_full;
    always @(posedge aclk_s or negedge rst_n) begin
        if(~rst_n) begin
            addr_cnt <= 8'h0;
        end
        else if(addr_cnt_clr | single_access) begin
            addr_cnt <= 8'h0;
        end
        else if(addr_cnt_en) begin
            addr_cnt <= addr_cnt + 1;
        end
    end

    reg [11:0]              mask_bits;
    reg [11:0]              axi_addr_next;
    always @(posedge aclk_s or negedge rst_n) begin
        if(~rst_n) begin
            axi_addr_next <= 12'h0;
        end
        else if(access_start) begin
            axi_addr_next <= (axi_axaddr[11:0] + addr_incr_step) & ~mask_bits;
        end
        else if(addr_cnt_en) begin
            axi_addr_next <= (axi_addr_next + addr_incr_step) & ~mask_bits;
        end
    end

    /*------------------------------------------------*/
    /*  generate wrap access mask bit(only 128bits)   */
    /*------------------------------------------------*/
    wire                    wrap_flag;
	wire [31:0]             wrap_addr;
	wire [31:0]             wrap_addr_base;
	//wire [11:0]             wrap_addr_offset;

    assign wrap_flag = (axi_axburst == 2'b10);
    assign wrap_addr_base[31:12] = axi_axaddr[31:12];
    assign wrap_addr_base[11:0] = axi_axaddr[11:0] & mask_bits;
    assign wrap_addr = wrap_addr_base | axi_addr_next;

    always @(*) begin
        mask_bits = 12'h0;
        if(wrap_flag) begin
            case(axi_axlen[3:0])
                4'h1:  mask_bits = 12'hFFF << (axi_axsize + 1);
                4'h3:  mask_bits = 12'hFFF << (axi_axsize + 2);
                4'h7:  mask_bits = 12'hFFF << (axi_axsize + 3);
                4'hf:  mask_bits = 12'hFFF << (axi_axsize + 4);
            endcase
        end
    end

    /*------------------------------------------------*/
    /*  generate ram cmd address and id info          */
    /*------------------------------------------------*/
    assign ram_addr = access_start ? axi_axaddr[RAM_BW+:(C_RAM_AW+1)] : wrap_addr[RAM_BW+:(C_RAM_AW+1)];
    assign ram_cmd_info = {access_last, axi_axid, ram_addr};

    /*------------------------------------------------*/
    /*  generate ram cmd fifo push signal             */
    /*------------------------------------------------*/
    assign ram_cmd_push = ~ram_cmd_full & ~axch_empty;


endmodule
