`ifndef TCNT_APB_COV__SV
`define TCNT_APB_COV__SV
`ifdef FCOV

class tcnt_apb_cov extends uvm_component;
    `uvm_component_utils(tcnt_apb_cov)

    covergroup apb_states with function sample(bit psel, bit penable);
        apb_state:coverpoint {psel,penable}{
            bins idle = {2'b00};    
            bins setup = {2'b10};
            bins access = {2'b11};
        }
        option.name = "apb_states";
        option.per_instance = 1;
    endgroup

    covergroup write_pslverr with function sample(tcnt_apb_dec::xact_type_e xact_type, bit pslverr);
        write_xact_type:coverpoint xact_type{
            bins write_xact = {tcnt_apb_dec::WRITE};
        }

        coverpoint pslverr{
            bins no_error = {1'b0};
            bins error= {1'b1};
        }

        apb_write_pslverr:cross xact_type,pslverr;

        option.name = "write_pslverr";
        option.per_instance = 1;
    endgroup

    /**
    * master coverage
    */
    covergroup write_wait with function sample(tcnt_apb_dec::xact_type_e xact_type, int wait_cycles);
        write_xact_type:coverpoint xact_type{
            bins write_xact = {tcnt_apb_dec::WRITE};
        }

        cov_wait:coverpoint wait_cycles{
            bins wait_zero= {0};    
            bins wait_non_zero = {[1:$]};
        }

        apb_write_wait:cross write_xact_type,cov_wait;

        option.name = "write_wait";
        option.per_instance = 1;
    endgroup

    covergroup read_pslverr with function sample(tcnt_apb_dec::xact_type_e xact_type, bit pslverr);
        read_xact_type:coverpoint xact_type{
            bins read_xact = {tcnt_apb_dec::READ};
        }

        coverpoint pslverr{
            bins no_error = {1'b0};
            bins error= {1'b1};
        }

        apb_read_pslverr:cross xact_type,pslverr;

        option.name = "read_pslverr";
        option.per_instance = 1;
    endgroup

    /**
    * master coverage
    */
    covergroup read_wait with function sample(tcnt_apb_dec::xact_type_e xact_type, int wait_cycles);
        read_xact_type:coverpoint xact_type{
            bins read_xact = {tcnt_apb_dec::WRITE};
        }

        cov_wait:coverpoint wait_cycles{
            bins wait_zero= {0};    
            bins wait_non_zero = {[1:$]};
        }

        apb_read_wait:cross read_xact_type,cov_wait;

        option.name = "read_wait";
        option.per_instance = 1;
    endgroup

    function new(string name = "tcnt_apb_cov", uvm_component parent = null);
        string instName;

        super.new(name, parent);
        instName = get_full_name();

        apb_states=new();
        apb_states.set_inst_name({instName,".","apb_states"});

        write_pslverr=new();
        write_pslverr.set_inst_name({instName,".","write_pslverr"});

        write_wait=new();
        write_wait.set_inst_name({instName,".","write_wait"});

        read_pslverr=new();
        read_pslverr.set_inst_name({instName,".","read_pslverr"});

        read_wait=new();
        read_wait.set_inst_name({instName,".","read_wait"});
    endfunction:new
endclass

`endif
`endif
