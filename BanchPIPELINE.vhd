-- Written by Riccardo Fontanini
-- 19/10/2017
-- control all operation in
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- entity declaration for your testbench.Dont declare any ports here
ENTITY PIPELINEtest_tb IS 
END PIPELINEtest_tb;

ARCHITECTURE behavior OF PIPELINEtest_tb IS
   -- Component Declaration for the Unit Under Test (UUT)

	COMPONENT REG_PIPE
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
	END COMPONENT;

	COMPONENT registers
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
	END COMPONENT;




	COMPONENT multiplexer  
		generic (n_in_out: integer := 1);
		port (
			in_0: in std_logic_vector(n_in_out-1 downto 0);
			in_1: in std_logic_vector(n_in_out-1 downto 0);
			selector: in std_logic;
			z: out std_logic_vector(n_in_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT controller 
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
	END COMPONENT;

	COMPONENT shiftleftby2
		generic (n_in: integer := 32; 
					n_out: integer := 32 
					);
		port (
			input: in std_logic_vector(n_in-1 downto 0);
			z: out std_logic_vector(n_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT adder4
		generic (n_in_out: integer := 32);
		port (
			input: in std_logic_vector(n_in_out-1 downto 0);
			z: out std_logic_vector(n_in_out-1 downto 0)
		);
	END COMPONENT;


	COMPONENT signExtend 
		generic (	n_in: integer := 5; 
						n_out: integer := 32 
					); 
		port (
			input: in std_logic_vector(n_in-1 downto 0);
			z: out std_logic_vector(n_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT memory 
		port
		(
			address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
			data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
			memWrite: in std_logic; --HIGH FOR WRITING 
			memRead: in std_logic; --HIGH FOR READING
			--clk: in std_logic; -- CLOCK
			data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
		);
	END COMPONENT;

	COMPONENT PC 
	port
	(
		address_in: in std_logic_vector (31 downto 0); --ADDRESS TO PASS
		clk: in std_logic; -- CLOCK
		address_out: out std_logic_vector (31 downto 0) --
	);
	END COMPONENT;

	
	COMPONENT ALU 
	generic (n_in_out: integer := 32 );

	port (
		a: in std_logic_vector(n_in_out-1 downto 0);
		b: in std_logic_vector(n_in_out-1 downto 0);
		ALUOp: in std_logic_vector(4-1 downto 0);
		ALUResult: out std_logic_vector(n_in_out-1 downto 0);
		zero: out std_logic
	);
	END COMPONENT;

	COMPONENT ALUController
		port
		(
			Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
			ALUOp: in std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
			ALUFunction: out std_logic_vector (3 downto 0) --DEFINE THE TYPE OF OPERATION TO DO FOR ALU
		);
	END COMPONENT;

	COMPONENT and_port
		
		port (
			a: in std_logic;
			b: in std_logic;
			z: out std_logic
		);
	END COMPONENT;

	COMPONENT datamemory
		port
		(
			address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
			data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
			memWrite: in std_logic; --HIGH FOR WRITING 
			memRead: in std_logic; --HIGH FOR READING
			--clk: in std_logic; -- CLOCK
			data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
		);
	END COMPONENT;


	
	-- CONSTANTS
	constant n_wires : integer := 5;
	constant n_EXT_wires : integer := 32;
	constant n_bit: integer := 32;
	constant ALU_ADD: std_logic_vector(3 downto 0) :="0001"; -- ALU ADD
	constant zero : std_logic := '0';
	constant one : std_logic := '1';
	constant nullIN : std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	constant nullIN_12: std_logic_vector(12-1 downto 0):= ( others => '0');
	constant nullIN_5: std_logic_vector(5-1 downto 0):= ( others => '0');
	-- SIGNALS
	--signal a_in : std_logic_vector(n_wires-1 downto 0) := "00010";
	
	signal clock : std_logic := '0';
	signal instruction_IF: std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	signal instruction_ID: std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	signal PC_in_IF: std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	signal PC_out_IF: std_logic_vector(n_bit-1 downto 0) ;
	signal add4_exit_IF : std_logic_vector(n_bit-1 downto 0) ;
	signal add4_exit_ID : std_logic_vector(n_bit-1 downto 0) ;
	signal add4_exit_EX : std_logic_vector(n_bit-1 downto 0) ;
	signal MUX3_exit_EX : std_logic_vector(n_bit-1 downto 0) ;
	signal ALU1_exit_EX: std_logic_vector(n_bit-1 downto 0);
	signal ALU1_exit_MEM: std_logic_vector(n_bit-1 downto 0);
	signal shifted_before_ALU1_EX: std_logic_vector(n_bit-1 downto 0);
	signal extended_ID: std_logic_vector(n_bit-1 downto 0);
	signal extended_EX: std_logic_vector(n_bit-1 downto 0);
	signal MUX2_exit_EX: std_logic_vector(5-1 downto 0);
	signal MUX2_exit_MEM: std_logic_vector(5-1 downto 0);
	signal MUX2_exit_WB: std_logic_vector(5-1 downto 0);
	signal data1REG_ID: std_logic_vector(n_bit-1 downto 0);
	signal data1REG_EX: std_logic_vector(n_bit-1 downto 0);
	signal data2REG_ID: std_logic_vector(n_bit-1 downto 0);
	signal data2REG_EX: std_logic_vector(n_bit-1 downto 0);
	signal data2REG_MEM: std_logic_vector(n_bit-1 downto 0);
	signal ALU_function_EX:  std_logic_vector(4-1 downto 0);
	signal ALU_result_EX: std_logic_vector(n_bit-1 downto 0);
	signal ALU_result_MEM: std_logic_vector(n_bit-1 downto 0);
	signal ALU_result_WB: std_logic_vector(n_bit-1 downto 0);
	signal zero_ALU_result_EX : std_logic;
	signal zero_ALU_result_MEM : std_logic;
	signal END_exit_MEM : std_logic;
	signal MEMORY_exit_MEM: std_logic_vector(n_bit-1 downto 0);
	signal MEMORY_exit_WB: std_logic_vector(n_bit-1 downto 0);
	signal MUX4_exit_WB: std_logic_vector(n_bit-1 downto 0);
	signal instruction_2016_EX: std_logic_vector(5-1 downto 0);
	signal instruction_1511_EX: std_logic_vector(5-1 downto 0);
	


	--CONTROLLER SIGNALS
	--signal RegDest:std_logic; --SELECTOR FOR MUX 
	--signal Jump: std_logic; -- IS JUMP INSTRUCTION
	--signal Branch: std_logic;  -- IS BRANCH INSTRUCTION
	--signal MemRead: std_logic; -- IS MEMORY READING instruction
	--signal MemtoReg: std_logic; -- LOAD MEMORY to REGISTER
	--signal ALUOp: std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibilitysignal MemWrite: std_logic; --Define write in memory instruction
	--signal ALUSrc: std_logic; -- Select source (MUX) for ALU
	--signal RegWrite: std_logic; -- Write in Register


	-- now all signals become an array  (more flexy) ->
	-- [0] RegDest
	-- [1] JUMP
	-- [2] branch
	-- [3] MemRead
	-- [4] MemtoReg
	-- [5-8] Aluop
	-- [9] MemWrite
	-- [10] ALUSRC
	-- [11] REGWrite
	signal control_signal_ID: std_logic_vector (12-1 downto 0);
	signal control_signal_EX: std_logic_vector (12-1 downto 0);
	signal control_signal_MEM: std_logic_vector (12-1 downto 0);
	signal control_signal_WB: std_logic_vector (12-1 downto 0);
	

BEGIN

	--INSTRUCTION FETCH

	MUX1_IF: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>add4_exit_IF, in_1 => ALU1_exit_MEM, selector => END_exit_MEM, z=>PC_in_IF);

	ProgramCounter_IF: PC PORT MAP ( address_in => PC_in_IF, address_out => PC_out_IF, clk => clock);
	
	InstrMemory_IF : memory  PORT MAP(	address => PC_out_IF, 
												data_write => nullIN, 
												memWrite => zero, 
												memRead => one, 
												--clk => clock, 
												data_read => instruction_IF); 

	ADDER_IF: adder4 GENERIC MAP( n_in_out => n_bit ) PORT MAP( input => PC_out_IF, z => add4_exit_IF);


	REG_IFID: REG_PIPE PORT MAP(
											clk => clock,

											zero_IN => '0',
											-- controller IN
											controller_IN => nullIN_12,
											--port of 32 bits IN
											port32_1_IN => add4_exit_IF,
											port32_2_IN => instruction_IF,
											port32_3_IN => nullIN,
											port32_4_IN => nullIN, 
											--port of 5 bits IN
											port5_1_IN => nullIN_5,
											port5_2_IN => nullIN_5,
											--port of 5 bits OUT (not connected)
											--port5_1_OUT: ;
											--port5_2_OUT: ;
											--port of 32 bits OUT
											port32_1_OUT => add4_exit_ID,
											port32_2_OUT => instruction_ID
											--port32_3_OUT: ;
											--port32_4_OUT: ;
											-- controller IN
											--controller_OUT: out std_logic_vector (12-1 downto 0)
	);

	--INSTRUCTION DECODE

	--controller takes more space 
	CTRL_ID : controller PORT MAP (	Instruction => instruction_ID( 31 downto 26),
											RegDest => control_signal_ID(0),
											Jump => control_signal_ID(1),
											Branch => control_signal_ID(2),
											MemRead => control_signal_ID(3),
											MemtoReg => control_signal_ID(4),
											ALUOp => control_signal_ID(8 downto 5),
											MemWrite => control_signal_ID(9),
											ALUSrc => control_signal_ID(10),
											RegWrite => control_signal_ID(11));

	REGI_ID: registers PORT MAP(	address_read_register1 => instruction_ID(25 downto 21),
										address_read_register2 => instruction_ID(20 downto 16), 
										address_write_register => MUX2_exit_WB, 
										data_to_write => MUX4_exit_WB, 
										is_to_write => control_signal_WB(11),
										read_data1 => data1REG_ID,
										read_data2 => data2REG_ID);

	sign1_ID: signExtend GENERIC MAP( n_in => 16, n_out => n_bit ) PORT MAP( input => instruction_ID (15 downto 0), z => extended_ID ); 

	REG_IDEX: REG_PIPE PORT MAP(
											clk => clock,
											zero_IN => '0',
											-- controller IN
											controller_IN => control_signal_ID,
											--port of 32 bits IN
											port32_1_IN => add4_exit_ID,
											port32_2_IN => data1REG_ID,
											port32_3_IN => data2REG_ID,
											port32_4_IN => extended_ID,
											--port of 5 bits IN
											port5_1_IN => instruction_ID(20 downto 16),
											port5_2_IN => instruction_ID(15 downto 11),
											--port of 5 bits OUT 
											port5_1_OUT => instruction_2016_EX,
											port5_2_OUT => instruction_1511_EX,
											--port of 32 bits OUT
											port32_1_OUT => add4_exit_EX,
											port32_2_OUT => data1REG_EX,
											port32_3_OUT => data2REG_EX,
											port32_4_OUT => extended_EX,

											-- controller IN
											controller_OUT => control_signal_EX
	);

	-- EXECUTION
	

	shifter_EX: shiftleftby2 GENERIC MAP( n_in => n_bit, n_out=>n_bit) PORT MAP(input => extended_EX, z => shifted_before_ALU1_EX);

	MUX3_EX: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>data2REG_EX, in_1 => extended_EX, selector => control_signal_EX(10), z=>MUX3_exit_EX);

	MUX2_EX: multiplexer GENERIC MAP (5) PORT MAP(in_0 => instruction_2016_EX, in_1 => instruction_1511_EX, selector => control_signal_EX(0), z=>MUX2_exit_EX);
	
	ALU1_EX: alu GENERIC MAP (n_bit) PORT MAP(a => add4_exit_EX, b => shifted_before_ALU1_EX, ALUOp => ALU_ADD, ALUResult => ALU1_exit_EX );

	ALUCTRL_EX: ALUController PORT MAP( Instruction => extended_EX(5 downto 0), ALUOp => control_signal_EX(8 downto 5), ALUFunction => ALU_function_EX);

	ALUPOWER_EX: ALU GENERIC MAP(n_bit) PORT MAP(	a => data1REG_EX, 
																b => MUX3_exit_EX, 
																ALUOp => ALU_function_EX, 
																ALUResult => ALU_result_EX, 
																zero => zero_ALU_result_EX  );

	REG_EXMEM: REG_PIPE PORT MAP(
											clk => clock,
											--zero IN
											zero_IN => zero_ALU_result_EX,
											-- controller IN
											controller_IN => control_signal_EX,
											--port of 32 bits IN
											port32_1_IN => ALU1_exit_EX,
											port32_2_IN => ALU_result_EX,
											port32_3_IN => data2REG_EX,
											port32_4_IN => nullIN,
											--port of 5 bits IN
											port5_1_IN => MUX2_exit_EX,
											port5_2_IN => nullIN_5,
											--port of 5 bits OUT 
											port5_1_OUT => MUX2_exit_MEM,
											--port5_2_OUT: ;
											--port of 32 bits OUT
											port32_1_OUT => ALU1_exit_MEM,
											port32_2_OUT => ALU_result_MEM,
											port32_3_OUT => data2REG_MEM,
											--port32_4_OUT: ;

											-- controller IN
											controller_OUT => control_signal_MEM,
											-- zero OUT
											zero_OUT => zero_ALU_result_MEM
	);

	-- MEMORY
	
	
	and1_MEM: and_port PORT MAP(a =>zero_ALU_result_MEM, b => control_signal_MEM(2), z => END_exit_MEM );


	DATMemory_MEM: datamemory PORT MAP (	address => ALU_result_MEM, 
												data_write => data2REG_MEM, 
												memWrite => control_signal_MEM(9), 
												memRead => control_signal_MEM(3), 
												--clk => clock, 
												data_read => MEMORY_exit_MEM);


	REG_MEMWB: REG_PIPE PORT MAP(
											clk => clock,
											--zero IN
											zero_IN => '0',
											-- controller IN
											controller_IN => control_signal_MEM,
											--port of 32 bits IN
											port32_1_IN => MEMORY_exit_MEM,
											port32_2_IN => ALU_result_MEM, 
											port32_3_IN => nullIN,
											port32_4_IN => nullIN, 
											--port of 5 bits IN
											port5_1_IN => MUX2_exit_MEM,
											port5_2_IN => nullIN_5,
											--port of 5 bits OUT 
											port5_1_OUT => MUX2_exit_WB,
											--port5_2_OUT: ;
											--port of 32 bits OUT
											port32_1_OUT => MEMORY_exit_WB,
											port32_2_OUT => ALU_result_WB,
											--port32_3_OUT => ;
											--port32_4_OUT: ;

											-- controller IN
											controller_OUT => control_signal_WB
											-- zero OUT
											--zero_OUT => ;
	);


	-- WRITE BACK
	
	MUX4_WB: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>ALU_result_WB, in_1 => MEMORY_exit_WB, selector => control_signal_WB(4), z=>MUX4_exit_WB);




	--PROCESS

	clock_process: process
		begin
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
	end process;

	-- Main process
  main: process
   begin   
	wait for 2 ns;
  end process;

END;