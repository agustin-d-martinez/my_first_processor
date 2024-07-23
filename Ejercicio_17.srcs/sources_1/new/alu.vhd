library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
library work;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Generic ( DATA_BITS: integer:= 16 );
    Port(   clk:    in std_logic ;
            rst:    in std_logic ;
            ena:    in std_logic ;
            code:   in std_logic_vector (4-1 downto 0) ;
            op:     in std_logic_vector (DATA_BITS-1 downto 0) ;
            acc:    out std_logic_vector (DATA_BITS-1 downto 0) ;
            zero:   out std_logic ;
            overflow:       out std_logic ;
            carryBorrow:    out std_logic ;
            negative:       out std_logic);
end alu;

architecture Behavioral of alu is
------- signals --------------------------------------
signal acc_nuevo: std_logic_vector (DATA_BITS-1 downto 0) ;     --acc_d
signal acc_viejo: std_logic_vector (DATA_BITS-1 downto 0) ;     --acc_q

signal suma:    std_logic_vector (DATA_BITS-1 downto 0) ;
signal resta:   std_logic_vector (DATA_BITS-1 downto 0) ;
signal carrySuma:   std_logic ;
signal carryResta:  std_logic ;
signal ovSuma:  std_logic ;
signal ovResta: std_logic ;

signal Rot_aux:	std_logic_vector ((DATA_BITS+1)-1 downto 0) ;
signal accRot:	std_logic_vector (DATA_BITS-1 downto 0) ;

--signal carryIn_d:   std_logic ;
signal sat_d:   std_logic ;
signal sat_q:   std_logic ;

signal zero_d:  std_logic ;
signal zero_q:  std_logic ;
signal overflow_d:  std_logic;
signal overflow_q:  std_logic;
signal negative_d:  std_logic;
signal negative_q:  std_logic;
signal carryBorrow_d:   std_logic;
signal carryBorrow_q:   std_logic;
------------------------------------------------------

begin
---------- Sumador y Restador ------------------------
sumador: entity work.sumadorRestador
Generic map (N=>DATA_BITS)
Port map ( a=>acc_viejo , b=>op , carryIn=>carryBorrow_q , carryOut=>carrySuma , sat=>sat_d , restar=>'0' , ov=>ovSuma , res=>suma );
restador: entity work.sumadorRestador
Generic map (N=>DATA_BITS)
Port map ( a=>acc_viejo , b=>op , carryIn=>carryBorrow_q , carryOut=>carryResta , sat=>sat_d , restar=>'1' , ov=>ovResta , res=>resta );
------------------------------------------------------


Rot_aux <= std_logic_vector ( rotate_left( unsigned(carryBorrow_q & acc_viejo) , to_integer(signed(op)) ) ) when (op(DATA_BITS-1) = '0') else
            std_logic_vector ( rotate_right( unsigned(carryBorrow_q & acc_viejo) , to_integer(signed(op)*(-1)) ) ) when (op(DATA_BITS-1) = '1') else
            (others=>'0');  --Condicion innecesaria
accRot <= Rot_aux(DATA_BITS-1 downto 0);
------- logica code ----------------------------------
with code select
    acc_nuevo <=    acc_viejo and op 	when "0000",
                    acc_viejo or op		when "0001",
                    acc_viejo xor op	when "0010",
                    suma				when "0011",
                    resta				when "0100",   
                    accRot     			when "0101",          
                    op     				when "0110",
                    acc_viejo			when OTHERS;

--carryIn_d <= carryBorrow_q;
sat_d <=    op(0) when (code = "1000") else sat_q;      -- El reset lo generan los FFD

------- logica salidas extra -------------------------
zero_d <= not( or_reduce(acc_nuevo) );          
overflow_d <=   ovSuma when (code = "0011") else ovResta when (code = "0100") else overflow_q;
carryBorrow_d <=carrySuma when (code = "0011") else 
				carryResta when (code = "0100") else
                Rot_aux(DATA_BITS) when (code = "0101") else
                op(0) when (code = "0111") else
                carryBorrow_q;
negative_d <= acc_nuevo(DATA_BITS-1);

---------- registros ---------------------------------
registro_acc: entity work.N_FFD
Generic map (N=>DATA_BITS)
Port map ( clk=>clk , rst=>rst , ena=>ena ,  d=>acc_nuevo , q=>acc_viejo );
registro_zero: entity work.FFD
Port map ( clk=>clk , rst=>rst , ena=>ena , d=>zero_d , q=>zero_q );
registro_overf: entity work.FFD
Port map ( clk=>clk , rst=>rst , ena=>ena , d=>overflow_d , q=>overflow_q );
registro_carryB: entity work.FFD
Port map ( clk=>clk , rst=>rst , ena=>ena , d=>carryBorrow_d , q=>carryBorrow_q );
registro_neg: entity work.FFD
Port map ( clk=>clk , rst=>rst , ena=>ena , d=>negative_d , q=>negative_q );
registro_sat: entity work.FFD
Port map ( clk=>clk , rst=>rst , ena=>ena , d=>sat_d , q=>sat_q );
------------------------------------------------------

---- asignacion salidas -------
acc <= acc_viejo; 
zero <= zero_q;
overflow <= overflow_q;
carryBorrow <= carryBorrow_q;
negative <= negative_q;

end Behavioral;

