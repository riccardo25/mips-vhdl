-- Written by Riccardo Fontanini
-- 19/10/2017
-- Take the input and shif it left by 2 units
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity memory is
	port
	(
		address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
		data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
		memWrite: in std_logic; --HIGH FOR WRITING 
		memRead: in std_logic; --HIGH FOR READING
		--clk: in std_logic; -- CLOCK
		data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
	);
end memory;

architecture memory1 of memory is
	
	--TYPE of memory section
	type MEMORY_ARRAY is array (0 to 31) of std_logic_vector (31 downto 0);
	
	-- MEMORY
	signal data: MEMORY_ARRAY := (
X"ACC7001C", 	--SW MEM[$s + offset] = $t; $s = 6, $t = 7  	101011 00110 00111 0000000000000111
X"8D010000",	--LW $t = MEM[$s + offset]; $s = 16, $t = 1  100011 01000 00001 0000000000000000
X"00000000",
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00221820",
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000",
X"00000000");


	signal fakeaddress: std_logic_vector(31 downto 0):= (others => '0');
	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
		
	
	begin
		process (address, memRead, data_write) 
		begin
				if( address(0) /= '0' and address(0) /= '1')then
					data_read <= CONST_ZERO;
				elsif(memRead = '1' AND memWrite = '1') then -- if both memREAD and memWRITE are ON, there is a problem, so I put 0 in OUTPUT
					data_read <= CONST_ZERO;
				elsif( memRead = '1') then	 --if I want to read data										
					data_read <= data( conv_integer( unsigned( address ) )/4 );
				elsif (memWrite = '1') then -- if I want to write data					
					data( conv_integer( unsigned( address ) )/4 )<= data_write;
			
				end if;

		end process;
	
end memory1;