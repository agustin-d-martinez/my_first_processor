library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc is
Generic (DATA_BITS: integer:= 16);
Port(   clk:    in std_logic ;
        rst:    in std_logic ;
        ena:    in std_logic ;
        pl:     in std_logic ;
        plAddr: in std_logic_vector (DATA_BITS-1 downto 0) ;
        data:   out std_logic_vector(32-1 downto 0));
end pc;

architecture Behavioral of pc is
	-------- signals ------------------------------------------------
	signal salida_cont: std_logic_vector (DATA_BITS-1 downto 0);
	signal Addr_aux: std_logic_vector (10-1 downto 0);
	signal q_aux : unsigned (DATA_BITS-1 downto 0);
	-----------------------------------------------------------------
	COMPONENT pcMem1
	PORT (
		clka : IN STD_LOGIC;
		addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

begin
	blockRam : pcMem1
 	PORT MAP ( clka => clk , addra => Addr_aux , douta => data );

	salida_cont <= std_logic_vector ( q_aux );

process ( clk )
begin
    if ( rising_edge( clk ) ) then
        if ( rst = '1' ) then
            q_aux <= (others => '0');
        elsif ( ena = '1' ) then
            if ( pl = '1' ) then 
                q_aux <= unsigned (plAddr);
            else
                q_aux <= q_aux + 1; --to_unsigned(1,DATA_BITS); --q_aux + 1;
            end if;
        end if;
        
    end if;
end process;
	
	
	Addr_aux <=  salida_cont(10-1 downto 0);
end Behavioral;
