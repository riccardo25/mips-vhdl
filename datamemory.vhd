-- Written by Riccardo Fontanini
-- 19/10/2017
-- Take the input and shif it left by 2 units
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity datamemory is
	port
	(
		address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
		data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
		memWrite: in std_logic; --HIGH FOR WRITING 
		memRead: in std_logic; --HIGH FOR READING
		--clk: in std_logic; -- CLOCK
		data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
	);
end datamemory;

architecture arc_datamemory of datamemory is
	
	--TYPE of memory section
	type MEMORY_ARRAY is array (0 to 31) of std_logic_vector (31 downto 0);
	
	-- MEMORY
	signal data: MEMORY_ARRAY := (
X"00000789", 
X"00000111", 
X"00000123",
X"00000456", 
X"00000000", 
X"00000000",
X"00000000", 
X"00000000", 
X"00009999",
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
X"00000000", 
X"00000000",
X"00000000",
X"00000000");


	signal fakeaddress: std_logic_vector(31 downto 0):= (others => '0');
	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
		
	
	begin
		process (address, memRead, data_write, memWrite) 
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
	
end arc_datamemory;