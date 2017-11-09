-- Written by Riccardo Fontanini
-- 19/10/2017
-- Take a and put it in z if selector is 0, else put b in z
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------- ENTITY --------------------------------------------
entity multiplexer is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	generic (n_in_out: integer := 1);
	
	--port description
	port (
		in_0: in std_logic_vector(n_in_out-1 downto 0);
		in_1: in std_logic_vector(n_in_out-1 downto 0);
		selector: in std_logic;
		z: out std_logic_vector(n_in_out-1 downto 0)
	);
end multiplexer;

architecture arc_multiplexer of multiplexer is
begin
	
	z <= in_0 when (selector = '0') else in_1;

end arc_multiplexer;