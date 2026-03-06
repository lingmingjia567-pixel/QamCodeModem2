library verilog;
use verilog.vl_types.all;
entity FilterWrapper is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        i_in            : in     vl_logic_vector(2 downto 0);
        q_in            : in     vl_logic_vector(2 downto 0);
        i_out           : out    vl_logic_vector(7 downto 0);
        q_out           : out    vl_logic_vector(7 downto 0)
    );
end FilterWrapper;
