-- Written by Riccardo Fontanini
-- 19/10/2017
-- Take the input and shif it left by 2 units
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity PC is
	port
	(
		address_in: in std_logic_vector (31 downto 0); --ADDRESS TO PASS
		clk: in std_logic; -- CLOCK
		address_out: out std_logic_vector (31 downto 0) --
	);
end PC;

architecture arc_PC of PC is
	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
		
	begin
		process (clk) 
		begin
			if (address_in(0) /= '1' and address_in(0) /='0') then
				address_out <= CONST_ZERO;
			elsif(falling_edge(clk)) then
				address_out <= address_in;
			end if;
		end process;
	
end arc_PC;