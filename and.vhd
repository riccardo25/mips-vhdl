
-- Written by Riccardo Fontanini
-- 31/10/2017
-- AND 2 signals
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------- ENTITY --------------------------------------------
entity and_port is
	--port description
	port (
		a: in std_logic;
		b: in std_logic;
		z: out std_logic
	);
end and_port;

architecture arc_and_port of and_port is

begin

	z <= a and b;


end arc_and_port;