library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_tb IS 
END test_tb;

ARCHITECTURE behavior OF test_tb IS
   -- Component Declaration for the Unit Under Test (UUT)
	COMPONENT multiplexer  
		generic (n_in_out: integer := 1);
		port (
			a: in std_logic_vector(n_in_out-1 downto 0);
			b: in std_logic_vector(n_in_out-1 downto 0);
			selector: in std_logic;
			z: out std_logic_vector(n_in_out-1 downto 0)
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
			addr, data_write: in std_ulogic_vector (31 downto 0);
			W, R, clk: in std_ulogic;
			data_read: out std_ulogic_vector (31 downto 0)
		);
	END COMPONENT;

	-- CONSTANTS
	constant n_wires : integer := 5;
	constant n_EXT_wires : integer := 32;

	-- SIGNALS
	signal a_in : std_logic_vector(n_wires-1 downto 0) := "00010";
	signal b_in : std_logic_vector(n_wires-1 downto 0) := "11111";
	signal sel : std_logic := '0';
	signal exit_mux : std_logic_vector(n_wires-1 downto 0);
	signal exit_shift : std_logic_vector(n_wires-1 downto 0);
	signal exit_adder : std_logic_vector(n_wires-1 downto 0);
	signal exit_sign : std_logic_vector(n_EXT_wires - 1 downto 0);

BEGIN
	-- Multiplexer

   MUX1: multiplexer 
	GENERIC MAP( n_in_out => n_wires )
	PORT MAP(
		a => a_in,
		b => b_in,
		selector => sel,
		z => exit_mux
	);   

   
	-- Shifter
	SHIFT1: shiftleftby2 
	GENERIC MAP( n_in => n_wires, n_out => n_wires)
	PORT MAP(
		input => exit_mux,
		z => exit_shift
	); 
	
	--adder 4 
	ADDER1: adder4 
	GENERIC MAP( n_in_out => n_wires )
	PORT MAP(
		input => exit_shift,
		z => exit_adder
	); 

	--sign Extender 
	SIGN1: signExtend
	GENERIC MAP( n_in => n_wires, n_out => n_EXT_wires )
	PORT MAP(
		input => exit_adder,
		z => exit_sign
	); 


   -- Main process
  main: process
   begin   
		sel <= '0';
		wait for 5 ns;
     	sel <= '1';
		
      wait for 3 ns;
      sel <='0';
		

  end process;

END;