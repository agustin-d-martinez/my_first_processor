library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity sumadorRestador is
    Generic(N:integer := 4);
    Port (  a   : in std_logic_vector (N-1 downto 0);
            b   : in std_logic_vector (N-1 downto 0);
            carryIn     : in std_logic ;
            carryOut    : out std_logic ;
            sat         : in std_logic ;
            restar      : in std_logic ;
            ov  : out std_logic ;
            res   : out std_logic_vector (N-1 downto 0));
end sumadorRestador;

architecture Behavioral of sumadorRestador is
--------- signals ----------------------------------------
signal suma: std_logic_vector ((N+2)-1 downto 0);
signal resta: std_logic_vector ((N+2)-1 downto 0);
signal suma_sat: std_logic_vector (N-1 downto 0);
signal resta_sat: std_logic_vector (N-1 downto 0);

signal ov_suma: std_logic ;
signal ov_resta: std_logic ;

signal MAX: std_logic_vector (N-1 downto 0);
signal MIN: std_logic_vector (N-1 downto 0);
----------------------------------------------------------
begin
ov_suma  <= ( not(suma(N)) and b(N-1) and a(N-1) ) or ( suma(N) and not(b(N-1)) and not(a(N-1)) );       --Overflow suma
ov_resta <= ( a(N-1) and not (resta(N)) and not (b(N-1)) ) or ( not(a(N-1)) and b(N-1) and resta(N) );      --Overflow resta

suma  <= std_logic_vector (('0' & signed(a) & carryIn) + ('0' & signed(b) & carryIn));
resta <= std_logic_vector (('0' & signed(a) & not(carryIn)) - ('0' & signed(b) & carryIn));

suma_sat <=     suma((N+1)-1 downto 1) when ( ov_suma = '0' ) else
                MAX when ( suma(N) = '1' ) else
                MIN;
resta_sat <=    resta((N+1)-1 downto 1) when ( ov_resta = '0' ) else
                MAX when ( resta(N) = '1' ) else
                MIN;

res <=  suma((N+1)-1 downto 1)  when (restar = '0' and sat = '0') else
        suma_sat                when (restar = '0' and sat = '1') else
        resta((N+1)-1 downto 1) when (restar = '1' and sat = '0') else
        resta_sat               when (restar = '1' and sat = '1') else
        (others =>'0');

ov <= ov_suma when ( restar = '0' ) else ov_resta;
carryOut <= suma(N+1) when ( restar = '0' ) else resta(N+1);

MAX(N-1)<= '0';
MAX(N-2 downto 0) <= (others=>'1');            
MIN <= not(MAX);
end Behavioral;
