library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity sumadorRestador_tb is
Generic (N: integer:= 5);
--  Port ( );
end sumadorRestador_tb;

architecture Behavioral of sumadorRestador_tb is
component sumadorRestador is
     Generic(N:integer := 4);
    Port (  a   : in std_logic_vector (N-1 downto 0);
            b   : in std_logic_vector (N-1 downto 0);
            carryIn     : in std_logic ;
            carryOut    : out std_logic ;
            sat         : in std_logic ;
            restar      : in std_logic ;
            ov  : out std_logic ;
            res   : out std_logic_vector (N-1 downto 0));
end component;

signal a   : std_logic_vector (N - 1 downto 0);
signal b   : std_logic_vector (N - 1 downto 0);
signal carryIn     : std_logic ;
signal carryOut    : std_logic ;
signal sat         : std_logic ;
signal restar      : std_logic ;
signal ov  : std_logic ;
signal res   : std_logic_vector (N-1 downto 0);

begin
uut: sumadorRestador
    Generic map (N => N)
    Port map ( a=>a , b=>b ,carryIn=>carryIn, carryOut=>carryOut , sat=>sat,restar=>restar,ov=>ov,res=>res );
    
funcionamiento :process
begin      
carryIn <= '0';
restar <= '0';
sat <= '0';

a <= "00110";
b <= "00100"; wait for 10 ns;
carryIn <= '1'; wait for 10 ns;

carryIn <= '0';
restar <= '1';
a <= "00110";
b <= "00010"; wait for 10 ns;
carryIn <= '1'; wait for 10 ns;

carryIn <= '0';
restar <= '0';
----------- termino prueba de carry in-------------
a <= "00110";
b <= "01111"; wait for 10 ns;
sat <= '1'; wait for 10 ns;
sat <= '0';     --pruebo resta

a <= "10001";
b <= "10010"; wait for 10 ns;
sat <= '1'; wait for 10 ns;

sat <= '0';     --pruebo resta
restar <= '1';
a <= "00000";
b <= "00001"; wait for 10 ns;

a <= "10011";
b <= "01000"; wait for 10 ns;
sat <= '1'; wait for 10 ns;

sat <= '0';
a <= "01111";
b <= "11000"; wait for 10 ns;
sat <= '1'; wait for 10 ns;
wait;
end process;
end Behavioral;
