module cmm_sfifo #(
    parameter   C_HF = 8,
    parameter   C_HAF = 4,
    parameter   C_AW = 3,
    parameter   C_DW = 32
)(
    //Outputs
    dout, full, empty, awfull,
    //Inputs
    clk, rst_n, push, pop, din
);

    input                   clk;
    input                   rst_n;
    input                   push;
    input                   pop;
    input [C_DW-1:0]        din;
    output [C_DW-1:0]       dout;
    output                  full;
    output                  empty;
    output                  awfull;

    wire [C_AW-1:0]         waddr;
    wire [C_AW-1:0]         raddr;
    wire                    we;
    wire                    re;
    assign we = push;
    assign re = pop;
    cmm_bsc_sfifo_ctl #(
        .C_HF       (C_HF),
        .C_HAF      (C_HAF),
        .C_AW       (C_AW)
    ) u_sfifo_ctl (
        .clk					(clk),
        .rst_n					(rst_n),
        .we					    (we),
        .waddr					(waddr),
        .wleft					(),
        .wfull					(full),
        .awfull					(awfull),
        .oflw					(),
        .re					    (re),
        .raddr					(raddr),
        .rleft					(),
        .rempty					(empty),
        .arempty				(),
        .uflw                   ()
    );

    rf_1r1w_wrapper #(
        .READ_DELAY     (0),
        .ADDR_WIDTH     (C_AW),
        .DATA_WIDTH     (C_DW),
        .RF_DEPTH       (2**C_AW)
    ) u_rf_ram (
        .rst_n_a             (rst_n),
        .clk_a               (clk),
        .init_start_a        (1'b0),
        .init_done_a         (),
        .we_n_a              (~we),
        .addr_a              (waddr),
        .data_in_a           (din),
        .rst_n_b             (rst_n),
        .clk_b               (clk),
        .rd_n_b              (~re),
        .addr_b              (raddr),
        .data_out_b          (dout)
        );

endmodule
