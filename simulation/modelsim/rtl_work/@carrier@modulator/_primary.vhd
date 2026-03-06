library verilog;
use verilog.vl_types.all;
entity CarrierModulator is
    generic(
        PHI_INC         : integer := 1073741824
    );
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        i               : in     vl_logic_vector(7 downto 0);
        q               : in     vl_logic_vector(7 downto 0);
        mod_out         : out    vl_logic_vector(15 downto 0);
        carrier_real    : out    vl_logic_vector(17 downto 0);
        carrier_imag    : out    vl_logic_vector(17 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PHI_INC : constant is 1;
end CarrierModulator;
