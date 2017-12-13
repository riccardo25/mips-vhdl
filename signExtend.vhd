-- Written by Riccardo Fontanini
-- 19/10/2017
-- Take the input and shif extends its own bit (this program use generics to manipulate input and output
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------- ENTITY --------------------------------------------
entity signExtend is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	generic (	n_in: integer := 15; --number of bit input
					n_out: integer := 32 -- number of bit in output
				); 

	--port description
	port (
		input: in std_logic_vector(n_in-1 downto 0);
		z: out std_logic_vector(n_out-1 downto 0)
	);
end signExtend;

architecture arc_signExtend of signExtend is



constant CONST_ZERO: std_logic_vector(n_out-1 downto 0):= (others => '0');

constant toappend_0: std_logic_vector (n_out-n_in-1 downto 0) := (others => '0');

constant toappend_1: std_logic_vector (n_out-n_in-1 downto 0) := (others => '1');

begin
	--this process control data input make conversion
	process (input)
	begin
		if (n_out < n_in or (input(0) /= '0' and input(0) /= '1') ) then
			z <= CONST_ZERO;
		elsif input( n_in - 1 ) = '0' then
			-- set append vector to 00000...
			z <= toappend_0 & input;
		elsif input( n_in - 1 ) = '1' then
			-- set append vector to 111111...
			z <= toappend_1 & input;
		end if;
	end process;
end arc_signExtend;