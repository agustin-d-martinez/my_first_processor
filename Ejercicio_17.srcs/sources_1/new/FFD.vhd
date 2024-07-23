library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity FFD is
Port (  clk: in std_logic ;
        rst: in std_logic ;
        ena: in std_logic ;
        d: in std_logic ;
        q: out std_logic);
end FFD;

architecture Behavioral of FFD is
begin

-----PROCESS FLIP FLOP---------------------------------------
process (clk)
begin
    if ( rising_edge(clk) ) then
        if (rst = '1') then
            q <= '0';
        elsif (ena = '1') then
            q <= d;
        end if;
    end if;

end process;
-------------------------------------------------------------

end Behavioral;
