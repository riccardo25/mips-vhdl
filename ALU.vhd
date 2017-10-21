-- Written by Riccardo Fontanini
-- 20/10/2017
-- Make math, controlled by 4 bit
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------- ENTITY --------------------------------------------
entity ALU is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	generic (n_in_out: integer := 32 );

	--port description
	port (
		a: in std_logic_vector(n_in_out-1 downto 0);
		b: in std_logic_vector(n_in_out-1 downto 0);
		ALUOp: in std_logic_vector(4-1 downto 0);
		ALUResult: out std_logic_vector(n_in_out-1 downto 0);
		zero: out std_logic
	);
end ALU;

architecture arc_ALU of ALU is
	--CONSTANTS OF OPERATIONS
	constant ADD_op: std_logic_vector(4-1 downto 0):= "0001";
	constant SUB_op: std_logic_vector(4-1 downto 0):= "0010";
	constant AND_op: std_logic_vector(4-1 downto 0):= "0011";
	constant OR_op: std_logic_vector(4-1 downto 0):= "0100";
	constant NOR_op: std_logic_vector(4-1 downto 0):= "0101";
	-- GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(n_in_out-1 downto 0):= (others => '0');
	
	--SIGNALS
	signal exit_operation : std_logic_vector(n_in_out-1 downto 0);

begin
	process (a, b, ALUOp)
	begin
		if(ALUOp = ADD_op) then
			exit_operation <= a + b;
		elsif(ALUOp = SUB_op) then
			exit_operation <= a - b;
		elsif(ALUOp = AND_op) then
			exit_operation <= a AND b;
		elsif(ALUOp = OR_op) then
			exit_operation <= a OR b;
		elsif(ALUOp = NOR_op) then
			exit_operation <= a NOR b;
		end if;

		if( exit_operation = CONST_ZERO) then
			zero <= '1';
		else
			zero <= '0';
		end if;

		ALUResult <= exit_operation;

	end process;


end arc_ALU;