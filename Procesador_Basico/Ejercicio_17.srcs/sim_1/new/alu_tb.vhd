library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_tb is
    Generic ( DATA_BITS: integer:= 5 );
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is
--------- signlas ---------------------------------------------------
signal clk:    std_logic ;
signal rst:    std_logic := '0';
signal ena:    std_logic := '1';
signal code:   std_logic_vector (4-1 downto 0) := "0000";
signal op:     std_logic_vector (DATA_BITS-1 downto 0) := "00000";
signal acc:    std_logic_vector (DATA_BITS-1 downto 0) ;
signal zero:   std_logic ;
signal overflow:    std_logic ;
signal carryBorrow: std_logic ;
signal negative:    std_logic ;
---------------------------------------------------------------------
------ seteo del clock -------------
constant clkp : time := 10 ns;

constant c_and :	std_logic_vector (4-1 downto 0) := "0000";
constant c_or :		std_logic_vector (4-1 downto 0) := "0001";
constant c_xor :	std_logic_vector (4-1 downto 0) := "0010";
constant c_suma :	std_logic_vector (4-1 downto 0) := "0011";
constant c_resta :	std_logic_vector (4-1 downto 0) := "0100";
constant c_rot :	std_logic_vector (4-1 downto 0) := "0101";
constant c_acc :	std_logic_vector (4-1 downto 0) := "0110";
constant c_carry :	std_logic_vector (4-1 downto 0) := "0111";
constant c_sat :	std_logic_vector (4-1 downto 0) := "1000";

begin
uub: entity work.alu
Generic map ( DATA_BITS=>DATA_BITS )
Port map (clk=>clk , rst=>rst , ena=>ena , 
            code=>code , op=>op , acc=>acc , 
            zero=>zero , overflow=>overflow , carryBorrow=>carryBorrow , negative=>negative );

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
    
	--- val inicial ---
	code <= c_acc; 
	op <= "00101";
	wait for clkp;
	report "Finalizo acc acc=>5 " severity note; --t=25 ns
	
	--- suma ----------
	code <= c_suma;
	op <= "00111";	-- +7
	wait for clkp;
	
	code <= c_carry;
	op <= "00001";	-- seteo carry
	wait for clkp;
	code <= c_suma;
	op <= "11010";	-- +(-6) +Cin
	wait for clkp;
	code <= c_carry;
	op <= "00000";	-- des seteo carry
	wait for clkp;
	
	code <= c_suma;
	op <= "01111";	-- +15 (verifico overflow)
	wait for clkp;
	op <= "11000";	-- +(-8)
	report "Finalizo suma acc=>-10 " severity note; --t=75 ns

	--- resta ---------
    code <= c_resta; 
    op <= "00101";  
    wait for clkp;  
    op <= "11101";  
    wait for clkp;  
    op <= "10001";  
    wait for clkp;  
	report "Finalizo resta acc=>3 " severity note; --t=105 ns
    
	--- and -----------
 	code <= c_and; 
 	op <= "11111";  
 	wait for clkp;  
 	op <= "10010";  
 	wait for clkp;  
	report "Finalizo and acc=>2 " severity note; --t=125 ns

	--- or ------------
 	code <= c_or; 
 	op <= "00000";  
 	wait for clkp;  
 	op <= "10000";  
 	wait for clkp;  
	report "Finalizo or acc=>-14 " severity note; --t=145 ns
    
 	--- xor -----------
 	code <= c_xor; 
 	op <= "11100";  
 	wait for clkp;  
	report "Finalizo xor acc=>-10 " severity note; --t=155 ns
    
 	--- sat -----------
 	code <= c_sat; 
 	op <= "00001";  
 	wait for clkp;
 	code <= c_suma; 
 	op <= "00111";  
 	wait for clkp;
	report "Finalizo sat acc=>15 " severity note; --t=175 ns

 	--- rot -----------
 	code <= c_rot; 
 	op <= "00001"; --rot izq de a uno 
 	wait for 5*clkp;	
 	
 	op <= "11110"; --rot der de a dos 
 	wait;
end process;
-----------------------------------------------------------
end Behavioral;

--	ACC		OP		operacion
--	XX		5		acc carga

--	5		7		suma
--	12		1		cin
--	12		-6		suma
--	7		15		suma (ov)

--	-10		5		resta
--	-15		-3		resta
--	-12		-15		resta (ov)

--	00011	11111	and
--	00011	10010	and

--	10010	00000	or
--	10010	10000	or

--	10000	11100	xor

--	01100	1		sat
--	12		7		suma

--	15		1		rot izq
--	... ...