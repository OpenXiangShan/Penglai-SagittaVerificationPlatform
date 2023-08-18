`ifndef TCNT_APB_DEC__SV
`define TCNT_APB_DEC__SV

package tcnt_apb_dec;

	typedef enum int{
        READ=1, 
        WRITE=2
    } xact_type_e;

    typedef enum {
        PADDR_WIDTH_1 = 1,
        PADDR_WIDTH_2 = 2,
        PADDR_WIDTH_3 = 3,
        PADDR_WIDTH_4 = 4,
        PADDR_WIDTH_5 = 5,
        PADDR_WIDTH_6 = 6,
        PADDR_WIDTH_7 = 7,
        PADDR_WIDTH_8 = 8,
        PADDR_WIDTH_9 = 9,
        PADDR_WIDTH_10 = 10,
        PADDR_WIDTH_11 = 11,
        PADDR_WIDTH_12 = 12,
        PADDR_WIDTH_13 = 13,
        PADDR_WIDTH_14 = 14,
        PADDR_WIDTH_15 = 15,
        PADDR_WIDTH_16 = 16,
        PADDR_WIDTH_17 = 17,
        PADDR_WIDTH_18 = 18,
        PADDR_WIDTH_19 = 19,
        PADDR_WIDTH_20 = 20,
        PADDR_WIDTH_21 = 21,
        PADDR_WIDTH_22 = 22,
        PADDR_WIDTH_23 = 23,
        PADDR_WIDTH_24 = 24,
        PADDR_WIDTH_25 = 25,
        PADDR_WIDTH_26 = 26,
        PADDR_WIDTH_27 = 27,
        PADDR_WIDTH_28 = 28,
        PADDR_WIDTH_29 = 29,
        PADDR_WIDTH_30 = 30,
        PADDR_WIDTH_31 = 31,
        PADDR_WIDTH_32 = 32
    } paddr_width_enum;

    typedef enum {
        PDATA_WIDTH_8 = 8,
        PDATA_WIDTH_16 = 16,
        PDATA_WIDTH_32 = 32
    } pdata_width_enum;

    typedef enum bit{
        NORMAL = 1'b0,
        PRIVILEGED = 1'b1
    } pprot0_enum;

    typedef enum bit{
        SECURE = 1'b0,
        NON_SECURE = 1'b1
    } pprot1_enum;

    typedef enum bit{
        DATA = 1'b0,
        INSTRUCTION = 1'b1
    }pprot2_enum;

    typedef enum int{
        ZERO=0,
        RANDOM=1
    } read_default_value_e;
endpackage:tcnt_apb_dec

`endif
