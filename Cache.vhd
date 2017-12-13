-- Written by Riccardo Fontanini
-- 24/11/2017
-- cache Implementation for MIPS (DIRECT MAPPED)
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity cache is
	
	
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	port
	(
		address_in: in std_logic_vector (31 downto 0); --address to read/write data
		data_from_memory: in std_logic_vector (31 downto 0); -- data from memory
		data_in: in std_logic_vector (31 downto 0); --data to write
		mem_write: in std_logic;
		mem_read: in std_logic;
		
		data_out: out std_logic_vector( 31 downto 0); --data read from cache
		hit: out std_logic
		
		
	);
end cache;

architecture arc_cache of cache is
	
	--TYPE
	type DATA_ARRAY is array (0 to 1023) of std_logic_vector (31 downto 0);
	type TAG_ARRAY is array (0 to 1023) of std_logic_vector (19 downto 0);
	type VALID_ARRAY is array (0 to 1023) of std_logic;

	--CONSTANT

	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(32-1 downto 0):= (others => '0');

	--CACHE
	signal data: DATA_ARRAY := (others => "00000000000000000000000000000000" );
	signal tag: TAG_ARRAY:= (others => "00000000000000000000");
	signal valid: VALID_ARRAY := (others => '0');
	
	--INTERNAL SIGNALS
	signal hit_internal : std_logic := '0'; -- signal HIT to send
 	
	


	begin

		
		--send hit to out
		hit <= hit_internal;
		
		--put data to output
		data_out <= data_from_memory when (hit_internal = '0') else data( conv_integer (unsigned(address_in(11 downto 2))));
	
		--generate internal hit
		hit_internal <= '1' 	when ( tag ( conv_integer (unsigned(address_in(11 downto 2)))) = address_in (31 downto 12) and valid ( conv_integer (unsigned(address_in(11 downto 2))))  = '1')
									else '0';
		--save data to cache
		data (  conv_integer (unsigned(address_in(11 downto 2))) ) <= data_in when (mem_write = '1');
		tag (  conv_integer (unsigned(address_in(11 downto 2))) ) <= address_in (31 downto 12) when (mem_write = '1');
		valid (  conv_integer (unsigned(address_in(11 downto 2))) ) <= '1' when (mem_write = '1');
		
	
end arc_cache;