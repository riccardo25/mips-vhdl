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

signal toappend: std_logic_vector (n_out-n_in-1 downto 0);

begin
	--this process control data input make conversion
	process (input)
	begin
		if n_out < n_in then
			for i in 0 to (n_out - 1) loop -- if an error occured, set output to 0
				z(i) <= '0';
			end loop;
		elsif input( n_in - 1 ) = '0' then
			-- set append vector to 00000...
			for i in 0 to (n_out - n_in -1) loop
				toappend(i) <= '0';
			end loop;
			z <= toappend & input;
		elsif input( n_in - 1 ) = '1' then
			-- set append vector to 111111...
			for i in 0 to (n_out - n_in -1) loop
				toappend(i) <= '1';
			end loop;
			z <= toappend & input;
		end if;
	end process;
end arc_signExtend;