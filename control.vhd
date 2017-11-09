-- Written by Riccardo Fontanini
-- 19/10/2017
-- control all operation in
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity controller is
	port
	(
		Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
		RegDest: out std_logic; --SELECTOR FOR MUX 
		Jump: out std_logic; -- IS JUMP INSTRUCTION
		Branch: out std_logic;  -- IS BRANCH INSTRUCTION
		MemRead: out std_logic; -- IS MEMORY READING instruction
		MemtoReg: out std_logic; -- LOAD MEMORY to REGISTER
		ALUOp: out std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
		MemWrite: out std_logic; --Define write in memory instruction
		ALUSrc: out std_logic; -- Select source (MUX) for ALU
		RegWrite: out std_logic -- Write in Register
	);
end controller;

architecture arc_controller of controller is
	
	--CONSTANT

	--TYPE OF OPERATION
	constant OP_JMP: std_logic_vector(5 downto 0):= "000010"; --JUMP

	constant OP_ALU_OP: std_logic_vector(5 downto 0):= "000000"; -- ALU OPERATION, like ADD, DIVIDE...

	constant OP_BEQ: std_logic_vector(5 downto 0) :="000100"; -- BRANCH IF IS EQAUL

	constant OP_LW: std_logic_vector(5 downto 0) :="100011"; --LOAD WORD from memory into the specified register

	constant OP_SW: std_logic_vector(5 downto 0) :="101011"; --STORE WORD from register to the specified location in memory

	--VOCABULARY FOR ALUControl

	constant ALU_NOOP: std_logic_vector(3 downto 0) :="0000"; --ALU NO OPERATION
	
	constant ALU_DK: std_logic_vector(3 downto 0) :="1111"; -- ALU doing something but DONT'T KNOW
	
	constant ALU_ADD: std_logic_vector(3 downto 0) :="0001"; -- ALU ADD

	constant ALU_SUB: std_logic_vector(3 downto 0) :="0010"; --ALU SUBTRACT 

	constant ALU_AND: std_logic_vector(3 downto 0):= "0011"; -- ALU AND

	constant ALU_OR: std_logic_vector(3 downto 0):= "0100"; -- ALU OR

	constant ALU_NOR: std_logic_vector(3 downto 0):= "0101"; -- ALU NOR

	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
	

	begin
		process 
		
		begin
		wait for 1 ns;
			if (Instruction = OP_JMP) then
				RegDest <= '0'; 
				Jump <= '1';
				Branch <= '0'; 
				MemRead <= '0'; 
				MemtoReg <= '0'; 
				ALUOp <= ALU_ADD; 				
				MemWrite <= '0'; 
				ALUSrc <= '0'; 
				RegWrite <= '0'; 
				
			elsif(Instruction = OP_ALU_OP) then
				RegDest <= '1'; 
				Jump <= '0';
				Branch <= '0'; 
				MemRead <= '0'; 
				MemtoReg <= '0'; 
				ALUOp <= ALU_DK; -- say to alu "Hi I'm Riccardo and need YOU, but I don't know why!"
				MemWrite <= '0'; 
				ALUSrc <= '0'; 
				wait for 3 ns;
				RegWrite <= '1'; 
			elsif(Instruction = OP_BEQ) then
				RegDest <= '0'; 
				Jump <= '0';
				Branch <= '1'; 
				MemRead <= '0'; 
				MemtoReg <= '0'; 
				ALUOp <= ALU_SUB; --say to alu "You have to compare (substract and if the result is 0, BRANCH)
				MemWrite <= '0'; 
				ALUSrc <= '0'; 
				RegWrite <= '0'; 
			elsif(Instruction = OP_LW) then
				RegDest <= '0'; 
				Jump <= '0';
				Branch <= '0'; 
				MemRead <= '1'; 
				MemtoReg <= '1'; 
				ALUOp <= ALU_ADD; --say you have to add! because you catch the s register and add 15-0 offset... (offset can be null)
				MemWrite <= '0'; 
				ALUSrc <= '1'; 
				RegWrite <= '1'; 
			elsif(Instruction = OP_SW) then
				RegDest <= '0'; 
				Jump <= '0';
				Branch <= '0'; 
				MemRead <= '0'; 
				MemtoReg <= '0'; 
				ALUOp <= ALU_ADD; --say you have to add! because you catch the s register and add 15-0 offset... (offset can be null)
				MemWrite <= '1'; 
				ALUSrc <= '1'; 
				RegWrite <= '0'; 
			else
				RegDest <= '0'; 
				Jump <= '0';
				Branch <= '0'; 
				MemRead <= '0'; 
				MemtoReg <= '0'; 
				ALUOp <= ALU_NOOP; 				
				MemWrite <= '0'; 
				ALUSrc <= '0'; 
				RegWrite <= '0'; 
			end if;
		end process;
	
end arc_controller;