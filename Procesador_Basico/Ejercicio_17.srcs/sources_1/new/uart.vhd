library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart is
	Generic (baudRate :	integer := 9600;
			sysClk :	integer := 100000000;
			dataSize :	integer := 8);
	Port ( 	clk :	in std_logic;
			rst :	in std_logic;
			dataWr :	in std_logic;
			dataTx :	in std_logic_vector (dataSize - 1 downto 0);
			ready :	out std_logic;
			tx :	out std_logic;
			dataRd :	out std_logic;
			dataRx :	out std_logic_vector (dataSize - 1 downto 0);
			rx :	in std_logic);
end uart;

architecture Behavioral of uart is

begin
----- COMPONENTS ---------------------------------------------
c_tx: entity work.uartTx
Generic map(baudRate=>baudRate, sysClk=>sysClk , dataSize=>dataSize )
Port map( clk=>clk , rst=>rst , dataWr=>dataWr , dataTx=>dataTx , ready=>ready , tx=>tx );
--------------------------------------------------------------
c_rx: entity work.uartRx
Generic map(baudRate=>baudRate, sysClk=>sysClk , dataSize=>dataSize )
Port map( clk=>clk , rst=>rst , dataRd=>dataRd , dataRx=>dataRx, rx=>rx );
--------------------------------------------------------------
end Behavioral;
