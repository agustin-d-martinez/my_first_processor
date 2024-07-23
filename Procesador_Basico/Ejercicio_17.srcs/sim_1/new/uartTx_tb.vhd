library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;

entity uartTx_tb is
	Generic (	baudRate : integer := 100000000;
				sysClk : integer := 300000000;
				dataSize : integer := 8);
--  Port ( );
end uartTx_tb;

architecture Behavioral of uartTx_tb is
	signal clk : std_logic;
	signal rst : std_logic ;
	signal dataWr : std_logic := '0';
	signal dataTx : std_logic_vector (dataSize - 1 downto 0) := (others=> '0');
	signal ready : std_logic;
	signal tx : std_logic;
	
	constant clk_period : time := 10 ns;
	constant clk_bit: time:=  clk_period * (sysClk/baudRate);

begin
----- COMPONENTS ---------------------------------------------
uut: entity work.uartTx
Generic map(baudRate=>baudRate , sysClk=>sysClk , dataSize=>dataSize )
Port map( clk=>clk , rst=>rst , dataWr=>dataWr , dataTx=>dataTx , ready=>ready , tx=>tx );
--------------------------------------------------------------

------------- procesos ------------------------------------
clk_process :process
begin
    clk <= '0';     wait for clk_period/2;
    clk <= '1';     wait for clk_period/2;
end process;

-- Reset process --
resetProc :process
begin      
    rst <= '1';     wait for 2 * clk_period;
    rst <= '0';     wait;
end process;

funcionamiento :process
begin
    wait until falling_edge (rst);
    wait for clk_period/2;
    ---
	dataWr <= '0';
	dataTx <= X"F4";
	dataWr <= '1'; wait for clk_period;
	dataWr <= '0'; wait for 15*clk_bit;
	dataTx <= X"5B";
	dataWr <= '1'; wait for clk_period;
	dataWr <= '0';
    wait;
end process;
-----------------------------------------------------------
end Behavioral;
