library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity N_FFD is
Generic (N: integer:= 4 );
Port (  clk: in std_logic ;
        rst: in std_logic ;
        ena: in std_logic ;
        d: in std_logic_vector (N-1 downto 0) ;
        q: out std_logic_vector (N-1 downto 0));
end N_FFD;

architecture Behavioral of N_FFD is
begin

-----PROCESS FLIP FLOP---------------------------------------
process (clk)
begin
    if ( rising_edge(clk) ) then
        if (rst = '1') then
            q <= (others=>'0');
        elsif (ena = '1') then
            q <= d;
        end if;
    end if;

end process;
-------------------------------------------------------------

end Behavioral;
