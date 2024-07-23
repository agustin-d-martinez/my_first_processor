library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity myCntBinarioPl is
Generic (N:integer :=4);
Port (  clk:    in std_logic ;
        rst:    in std_logic ;
        ena:    in std_logic ;
        dl:     in std_logic ;
        d:      in std_logic_vector (N-1 downto 0);
        q:      out std_logic_vector (N-1 downto 0));
end myCntBinarioPl;

architecture Behavioral of myCntBinarioPl is
signal q_aux : unsigned (N-1 downto 0);
begin

q <= std_logic_vector ( q_aux );

process ( clk )
begin
    if ( rising_edge( clk ) ) then
        if ( rst = '1' ) then
            q_aux <= (others => '0');
        elsif ( ena = '1' ) then
            if ( dl = '1' ) then 
                q_aux <= unsigned (d);
            else
                q_aux <= q_aux + 1;
            end if;
        end if;
        
    end if;
end process;
end Behavioral;
