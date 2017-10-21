--Memoria
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity memory is
	port
	(
		addr, data_write: in std_logic_vector (31 downto 0);
		W, R, clk: in std_logic;
		data_read: out std_logic_vector (31 downto 0)
	);
end memory;

architecture memory1 of memory is
	type memory_array is array (3 downto 0) of std_logic;
	type MEM is array (1 downto 0) of memory_array;

	signal data_mem: MEM := ("0000", "0000");
	
	begin
	process (clk)
	begin
		if(falling_edge(clk)) then
			if( R = '1') then												--Lettura da memoria
				data_read <= data_mem( conv_integer( unsigned( addr(6 downto 2))) );
			elsif (W = '1') then 											--Scrittura in memoria
				data_mem(conv_integer(addr(6 downto 2)))<= data_write;
			end if;
		end if;
	end process;
end memory1;