library verilog;
use verilog.vl_types.all;
entity QamCodeModem_vlg_tst is
    generic(
        clk_period      : integer := 125;
        cycles_per_data : integer := 8;
        data_num        : integer := 50000;
        time_sim        : vl_notype;
        clk_half_period : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of clk_period : constant is 1;
    attribute mti_svvh_generic_type of cycles_per_data : constant is 1;
    attribute mti_svvh_generic_type of data_num : constant is 1;
    attribute mti_svvh_generic_type of time_sim : constant is 3;
    attribute mti_svvh_generic_type of clk_half_period : constant is 3;
end QamCodeModem_vlg_tst;
