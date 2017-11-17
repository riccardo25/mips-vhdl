
-- Written by Riccardo Fontanini
-- 19/10/2017
-- pipeline register to put instructionfetch - instruction decode
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity REG_PIPE is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	port
	(
		clk: in std_logic; -- clock
		--zero ALU
		zero_IN : in std_logic;
		-- controller IN
		controller_IN: in std_logic_vector (12-1 downto 0);

		--port of 32 bits IN
		port32_1_IN: in std_logic_vector (32-1 downto 0);
		port32_2_IN: in std_logic_vector (32-1 downto 0); 
		port32_3_IN: in std_logic_vector (32-1 downto 0); 
		port32_4_IN: in std_logic_vector (32-1 downto 0); 

		--port of 5 bits IN
		port5_1_IN: in std_logic_vector (5-1 downto 0);
		port5_2_IN: in std_logic_vector (5-1 downto 0);

		--port of 5 bits OUT
		port5_1_OUT: out std_logic_vector (5-1 downto 0);
		port5_2_OUT: out std_logic_vector (5-1 downto 0);

		--port of 32 bits OUT
		port32_1_OUT: out std_logic_vector (32-1 downto 0);
		port32_2_OUT: out std_logic_vector (32-1 downto 0);
		port32_3_OUT: out std_logic_vector (32-1 downto 0);
		port32_4_OUT: out std_logic_vector (32-1 downto 0);

		--ZERO ALU OUT
		zero_OUT: out std_logic;

		-- controller OUT
		controller_OUT: out std_logic_vector (12-1 downto 0)
	);
end REG_PIPE;

architecture arc_REG_PIPE of REG_PIPE is
	
	--CONSTANT

	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(32-1 downto 0):= (others => '0');
	
	begin
		
		process(clk)

		--port of 5 bits OUT
		variable port5_1: std_logic_vector (5-1 downto 0):= (others => '0');
		variable port5_2: std_logic_vector (5-1 downto 0):= (others => '0');

		--port of 32 bits OUT
		variable port32_1: std_logic_vector (32-1 downto 0):= (others => '0');
		variable port32_2: std_logic_vector (32-1 downto 0):= (others => '0');
		variable port32_3: std_logic_vector (32-1 downto 0):= (others => '0');
		variable port32_4: std_logic_vector (32-1 downto 0):= (others => '0');

		-- controller
		variable controller: std_logic_vector (12-1 downto 0):= (others => '0');

		variable zero : std_logic:= '0';
	
		begin
			if(falling_edge(clk)) then

				-- variable to OUT
				port5_1_OUT <= port5_1;
				port5_2_OUT <= port5_2;

				port32_1_OUT <= port32_1;
				port32_2_OUT <= port32_2;
				port32_3_OUT <= port32_3;
				port32_4_OUT <= port32_4;

				controller_OUT <= controller;

				zero_OUT <= zero;

				-- IN to variable
				port5_1 := port5_1_IN;
				port5_2 := port5_2_IN;

				port32_1 := port32_1_IN;
				port32_2 := port32_2_IN;
				port32_3 := port32_3_IN;
				port32_4 := port32_4_IN;

				controller := controller_IN;

				zero := zero_IN;
			end if;
		end process;
	
end arc_REG_PIPE;