-- 19/10/2017
-- Take the input and shif it left by 2 units
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity registers is
	port
	(
		address_read_register1: in std_logic_vector (4 downto 0); --ADDRESS TO register 1
		address_read_register2: in std_logic_vector (4 downto 0); -- ADDRESS TO register 2
		address_write_register: in std_logic_vector (4 downto 0); -- ADDRESS TO BE WRITTEN in register
		data_to_write: in std_logic_vector (31 downto 0); -- ADDRESS TO BE WRITTEN in register
		is_to_write: in std_logic; --HIGH FOR WRITING
		read_data1: out std_logic_vector (31 downto 0); --DATA FROM ADDRESS 1
		read_data2: out std_logic_vector (31 downto 0)
	);
end registers ;

architecture arc_registers  of registers is
	
	--TYPE of memory section
	type MEMORY_ARRAY is array (0 to 31) of std_logic_vector (31 downto 0); --there are 32 registers
	
	-- MEMORY
	signal data: MEMORY_ARRAY := (
X"00000008", 
X"00000001", 
X"00000014",
X"00000000", 
X"00000000", 
X"00000000",
X"00000000", 
X"09876543", 
X"00000008",
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

	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
	
	
	begin


			read_data1 <= data( conv_integer( unsigned( address_read_register1 ) ) );
			read_data2 <= data( conv_integer( unsigned( address_read_register2 ) ) );

	
		data( conv_integer( unsigned( address_write_register ) ) ) <= data_to_write when (is_to_write = '1');
		
		--process (address_read_register1, address_read_register2, address_write_register, data_to_write, is_to_write) 
		--begin
			--if(is_to_write = '0') then --in reading
				--read_data1 <= data( conv_integer( unsigned( address_read_register1 ) ) );
				--read_data2 <= data( conv_integer( unsigned( address_read_register2 ) ) );
			--else
				--data( conv_integer( unsigned( address_write_register ) ) ) <= data_to_write;
				--read_data1 <= CONST_ZERO;
				--read_data2 <= CONST_ZERO;
			--end if;
		--end process;
	
end arc_registers;