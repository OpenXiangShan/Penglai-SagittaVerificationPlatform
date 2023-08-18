//apb
../rtl_lib/cmm_apb2hst.v
//register
-F ../register_1/register_v/common/field_common.f
-F ../register_1/register_v/register/sub_register_reg.f
//axi
-F ../rtl_lib/axi_ram_append/axi_ram_append.f
-F ../rtl_lib/axi_ram/cmm_axi2ram.f
//sad
../rtl_lib/sad/codec_cmm_abs_sub.v
../rtl_lib/sad/codec_cmm_adder_tree.v
../rtl_lib/sad/codec_cmm_sad.v
//sram
../rtl_lib/rf_1r1w_wrapper.v
//control
./interrupt_ctrl.v
./cal_ctrl.v
//top
./sad_top.v
