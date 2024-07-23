library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;
library work;
--library UNISIM;
--use UNISIM.VComponents.all;

entity myCnt2 is
Generic (P:integer := 4 );
Port (  clk:    in std_logic ;
        rst:    in std_logic ;
        ena:    in std_logic ;
        salida:    out std_logic);
end myCnt2;

architecture Behavioral of myCnt2 is
constant N: integer:= integer( ceil(log2(real(P))) )+1;

----- SIGNALS -----------------------------------------------
signal rst_aux : std_logic ;
signal cont_aux: std_logic_vector (N-1 downto 0);
signal salida_aux : std_logic ;
-------------------------------------------------------------
begin

rst_aux <= rst or salida_aux;

----- COMPONENTS ---------------------------------------------
CONTADOR: entity work.myCntBinarioPl
Generic map(N=>N)
Port map(clk=>clk, rst=>rst_aux, ena=>ena, dl=>'0', d=>(others=>'0') , q=>cont_aux);
--------------------------------------------------------------
salida <= salida_aux;
salida_aux <= '1' when (cont_aux = std_logic_vector(TO_UNSIGNED(P,N)) ) else '0';

end Behavioral;
