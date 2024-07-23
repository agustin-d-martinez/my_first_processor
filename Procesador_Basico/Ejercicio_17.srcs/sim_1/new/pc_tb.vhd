library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_tb is
Generic (DATA_BITS:integer := 16);
--  Port ( );
end pc_tb;

architecture Behavioral of pc_tb is
component pc is
    Generic (DATA_BITS:integer := 16);
    Port(   clk:    in std_logic ;
            rst:    in std_logic ;
            ena:    in std_logic ;
            pl:     in std_logic ;
            plAddr: in std_logic_vector (DATA_BITS-1 downto 0) ;
            data:   out std_logic_vector(32-1 downto 0));    
     end component;

----- SIGNALS ---------------------------------------------
signal clk :    std_logic;
signal rst :    std_logic;
signal ena :   std_logic := '0';
signal pl:     std_logic := '0';
signal plAddr: std_logic_vector (DATA_BITS-1 downto 0) := (others=> '0');
signal data:   std_logic_vector(32-1 downto 0); 
-----------------------------------------------------------
constant clk_period : time := 100 ns;

begin
------------- componentes ---------------------------------
uut: pc 
    Generic map (DATA_BITS=>DATA_BITS)
    Port map ( clk=>clk, rst=>rst, ena=>ena , pl=>pl ,plAddr=>plAddr , data=>data );
-----------------------------------------------------------

------------- procesos ------------------------------------
clk_process :process
begin
    clk <= '1';     wait for clk_period/2;
    clk <= '0';     wait for clk_period/2;
end process;

-- Reset process --
resetProc :process
begin      
    rst <= '1';     wait for 2*clk_period;
    rst <= '0';     wait;
end process;

funcionamiento: process
begin
    wait until falling_edge (rst);
    wait for clk_period;
    ---
    ---
    ---
    ena <= '1';
    wait for clk_period;
    ena <= '0';
    
    wait for 5*clk_period;
    ena <= '1';
    plAddr <= X"00F0";
    pl <= '1'; wait for clk_period;
    pl <= '0';
    wait for 5 * clk_period;
    ena <= '0';
    wait for 2 * clk_period;
    ena <= '1';
    plAddr <= X"0004";
    pl <= '1'; wait for clk_period;
    pl <= '0';
    wait;
end process;
-----------------------------------------------------------

end Behavioral;