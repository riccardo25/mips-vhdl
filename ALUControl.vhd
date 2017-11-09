-- Written by Riccardo Fontanini
-- 19/10/2017
-- control all operation in
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity ALUController is
	port
	(
		Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
		ALUOp: in std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
		ALUFunction: out std_logic_vector (3 downto 0) --DEFINE THE TYPE OF OPERATION TO DO FOR ALU
	);
end ALUController;

architecture arc_ALUController of ALUController is
	
	--CONSTANT

	--VOCABULARY FOR ALUControl

	constant ALU_NOOP: std_logic_vector(3 downto 0) :="0000"; --ALU NO OPERATION
	
	constant ALU_DK: std_logic_vector(3 downto 0) :="1111"; -- ALU doing something but DONT'T KNOW
	
	constant ALU_ADD: std_logic_vector(3 downto 0) :="0001"; -- ALU ADD

	constant ALU_SUB: std_logic_vector(3 downto 0) :="0010"; --ALU SUBTRACT 

	constant ALU_AND: std_logic_vector(3 downto 0):= "0011"; -- ALU AND

	constant ALU_OR: std_logic_vector(3 downto 0):= "0100"; -- ALU OR

	constant ALU_NOR: std_logic_vector(3 downto 0):= "0101"; -- ALU NOR

	--FUNCTIONS
	constant FUNC_ADD: std_logic_vector(5 downto 0):= "100000"; -- ADD FUNCTION

	constant FUNC_SUB: std_logic_vector(5 downto 0):= "100010"; -- SUB FUNCTION

	constant FUNC_AND: std_logic_vector(5 downto 0):= "100100"; -- AND FUNCTION

	constant FUNC_OR: std_logic_vector(5 downto 0):= "100101"; -- OR FUNCTION

	--constant FUNC_NOR: std_logic_vector(5 downto 0):= "100010"; -- NOR FUNCTION



	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
	
	
	begin
		process (Instruction, ALUOp) 
		begin
			if (ALUOp = ALU_DK and Instruction = FUNC_ADD) then
				ALUFunction <= ALU_ADD;
			elsif (ALUOp = ALU_DK and Instruction = FUNC_SUB) then
				ALUFunction <= ALU_SUB;
			elsif (ALUOp = ALU_DK and Instruction = FUNC_AND) then
				ALUFunction <= ALU_AND;
			elsif (ALUOp = ALU_DK and Instruction = FUNC_OR) then
				ALUFunction <= ALU_OR;
			elsif (ALUOp = ALU_DK ) then
				ALUFunction <= ALU_NOOP; --possibile errors (not implemented or something like that)
			else
				ALUFunction <= ALUOp;
			end if;
		end process;
	
end arc_ALUController;