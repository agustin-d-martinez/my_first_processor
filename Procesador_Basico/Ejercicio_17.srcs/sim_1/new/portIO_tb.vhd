library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity portIO_tb is
	generic ( DATA_BITS: integer:= 8 );
--  Port ( );
end portIO_tb;

architecture Behavioral of portIO_tb is
--------- signlas ---------------------------------------------------
signal clk:    std_logic ;
signal rst:    std_logic := '0';
signal ena:    std_logic := '1';
---------------------------------------------------------------------
------ seteo del clock -------------
constant clkp : time := 10 ns;

begin
uub: entity work.portIO;
--Port map ( );

------------- procesos ------------------------------------
clk_process :process
begin
    clk <= '0';     wait for clkp/2;
    clk <= '1';     wait for clkp/2;
end process;

-- Reset process --
resetProc :process
begin      
    rst <= '1';     wait for clkp;
    rst <= '0';     wait;
end process;

funcionamiento :process
begin
    wait until falling_edge (rst);
    wait for clkp/2;
    ---
	---
 	wait;
end process;
-----------------------------------------------------------
end Behavioral;
