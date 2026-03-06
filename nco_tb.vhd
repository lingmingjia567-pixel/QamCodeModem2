--	Copyright (C) 1988-2013 Altera Corporation

--	Any megafunction design, and related net list (encrypted or decrypted),
--	support information, device programming or simulation file, and any other
--	associated documentation or information provided by Altera or a partner
--	under Altera's Megafunction Partnership Program may be used only to
--	program PLD devices (but not masked PLD devices) from Altera.  Any other
--	use of such megafunction design, net list, support information, device
--	programming or simulation file, or any other related documentation or
--	information is prohibited for any other purpose, including, but not
--	limited to modification, reverse engineering, de-compiling, or use with
--	any other silicon devices, unless such use is explicitly licensed under
--	a separate agreement with Altera or a megafunction partner.  Title to
--	the intellectual property, including patents, copyrights, trademarks,
--	trade secrets, or maskworks, embodied in any such megafunction design,
--	net list, support information, device programming or simulation file, or
--	any other related documentation or information provided by Altera or a
--	megafunction partner, remains with Altera, the megafunction partner, or
--	their respective licensors.  No other licenses, including any licenses
--	needed under any third party's intellectual property, are provided herein.

--NCO ver 13.1 VHDL TESTBENCH

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use std.textio.all;

entity nco_tb is   
  generic(
		APR	:	INTEGER:=32;
		MPR	:	INTEGER:=18
        );
 
end nco_tb;


architecture tb of nco_tb is

--Convert integer to unsigned std_logicvector function
function int2ustd(value : integer; width : integer) return std_logic_vector is 
-- convert integer to unsigned std_logicvector 
variable temp :   std_logic_vector(width-1 downto 0);
begin
	if (width>0) then
		temp:=conv_std_logic_vector(conv_unsigned(value, width ), width);
	end if ;
	return temp;
end int2ustd;


component nco

port(
       phi_inc_i    : IN STD_LOGIC_VECTOR (APR-1 DOWNTO 0);
       clk		    : IN STD_LOGIC ;
       clken		: IN STD_LOGIC ;
       reset_n		: IN STD_LOGIC ;
       fsin_o		: OUT STD_LOGIC_VECTOR (MPR-1 DOWNTO 0);
       fcos_o		: OUT STD_LOGIC_VECTOR (MPR-1 DOWNTO 0);
       out_valid    : OUT STD_LOGIC
		);
end component;

signal clk          : std_logic;
signal reset_n      : std_logic;
signal clken        : std_logic;
signal sin_val	    : std_logic_vector (MPR-1 downto 0);
signal cos_val      : std_logic_vector (MPR-1 downto 0);
signal phi          : std_logic_vector (APR-1 downto 0);
signal phi_ch0         : std_logic_vector (APR-1 downto 0);
signal phi_ch1         : std_logic_vector (APR-1 downto 0);
signal sin_val_ch0         : std_logic_vector (MPR-1 downto 0);
signal cos_val_ch0         : std_logic_vector (MPR-1 downto 0);
signal sin_val_ch1         : std_logic_vector (MPR-1 downto 0);
signal cos_val_ch1         : std_logic_vector (MPR-1 downto 0);
signal sel_phi      : std_logic;
signal sel_output   : std_logic;
signal out_valid    : std_logic;
constant HALF_CYCLE  : time := 5000 ps;
constant CYCLE       : time := 2*HALF_CYCLE;


begin

-- NCO component instantiation

u1: nco

port map(  clk=>clk,
           reset_n=>reset_n,
           clken=>clken,
           phi_inc_i=>phi,
           fsin_o=>sin_val,
           fcos_o=>cos_val,
           out_valid=>out_valid
 );
 
reset_n <= '0',
           '1' after 14*HALF_CYCLE ;
clken   <= '1';

phi_ch0<="00000010100011110101110000101001";
phi_ch1<="00000001010001111010111000010100";

-----------------------------------------------------------------------------------------------
-- Testbench Clock Generation
-----------------------------------------------------------------------------------------------
clk_gen : process
begin
   loop
       clk<='0' ,
     	     '1'  after HALF_CYCLE;
       wait for HALF_CYCLE*2;
   end loop;
end process;

-----------------------------------------------------------------------------------------------
-- Output Sinusoidal Signals to Text Files 
-----------------------------------------------------------------------------------------------
testbench_o : process(clk) 
file sin_file 		: text open write_mode is "fsin_o_vhdl_nco.txt";
file cos_file 		: text open write_mode is "fcos_o_vhdl_nco.txt";
variable ls			: line;
variable lc			: line;
variable sin_int	: integer ;
variable cos_int	: integer ;

  begin
    if rising_edge(clk) then
      if(reset_n='1' and out_valid='1') then
        sin_int := conv_integer(sin_val);
        cos_int := conv_integer(cos_val);
        write(ls,sin_int);
        writeline(sin_file,ls);
        write(lc,cos_int);
        writeline(cos_file,lc);
     end if;		
	end if;		
end process testbench_o;

-----------------------------------------------------------------------------------------------
-- Input Phase Increment Channel Selector          
-----------------------------------------------------------------------------------------------
input_select : process(clk) is                     
  begin                                            
    if(falling_edge(clk)) then                      
      if(reset_n='0') then                           
        phi  <= (others=>'0');                     
        sel_phi <= '0';                  
      elsif(clken='1') then                        
        sel_phi <= not(sel_phi);                  
        if(sel_phi='0') then                            
          phi <= phi_ch0;                             
        else                             
          phi <= phi_ch1;                             
        end if;                             
      end if;                                      
    end if;                                        
  end process input_select;                        
-----------------------------------------------------------------------------------------------
-- Output Phase Channel Selector                   
-----------------------------------------------------------------------------------------------
output_select : process(clk) is                    
  begin                                            
    if(rising_edge(clk)) then                      
      if(reset_n='0') then                           
        sin_val_ch0 <= (others=>'0');              
        cos_val_ch0 <= (others=>'0');              
        sin_val_ch1 <= (others=>'0');              
        cos_val_ch1 <= (others=>'0');              
        sel_output  <= '0';              
      elsif(out_valid='1' and clken='1') then                   
        sel_output <= not(sel_output);                            
        if(sel_output='0') then                            
          sin_val_ch0 <= sin_val;                             
          cos_val_ch0 <= cos_val;                             
        else                             
          sin_val_ch1 <= sin_val;                             
          cos_val_ch1 <= cos_val;                             
        end if;                             
      end if;                                      
    end if;                                        
  end process output_select;                       
end tb;
