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
		a: in std_logic_vector(n_in_out-1 downto 0);
		b: in std_logic_vector(n_in_out-1 downto 0);
		selector: in std_logic;
		z: out std_logic_vector(n_in_out-1 downto 0)
	);
end multiplexer;

architecture arc_multiplexer of multiplexer is
begin
	
	z <= a when (selector = '0') else b;

end arc_multiplexer;