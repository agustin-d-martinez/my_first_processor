library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity uc_tb is
	generic (	DATA_BITS: integer := 16;
				UART_DATA_BITS: integer := 8);

--  Port ( );
end uc_tb;

architecture Behavioral of uc_tb is
--------- signlas ---------------------------------------------------
signal clk:    std_logic ;
signal rst:    std_logic := '0';
signal ena:    std_logic := '1';
---------------------------------------------------------------------
------ seteo del clock -------------
constant clkp : time := 100 ns;

signal		portRd :	 std_logic_vector (DATA_BITS - 1 downto 0);	
signal		portWr :	 std_logic_vector (DATA_BITS - 1 downto 0);
signal		portWrEna :	 std_logic;
		
signal		uartDataWr :	 std_logic;
signal		uartDataTx :	 std_logic_vector (UART_DATA_BITS - 1 downto 0);
signal		uartDataRx :	 std_logic_vector (UART_DATA_BITS - 1 downto 0);
		
signal		aluEna :	 std_logic;
signal		aluCode:	 std_logic_vector (3 downto 0);		--CODIGO ALU
signal		aluOp :		 std_logic_vector (DATA_BITS - 1 downto 0);	--ENTRADA ALU
signal		aluAcc :	 std_logic_vector (DATA_BITS - 1 downto 0);		--Salida ALU
signal		aluZero :	 std_logic;
signal		aluOverflow :	 std_logic;
signal		aluCarryBorrow :	 std_logic;
signal		aluNegative :	 std_logic;
		
signal		pcEna :	 std_logic;
signal		pcPl :	 std_logic;
signal		pcPlAddr :	 std_logic_vector (15 downto 0);		--PC entrada.
signal		pcData :	 std_logic_vector (31 downto 0);		--PC salida

    component pc is
    Generic ( DATA_BITS : integer := 16);
    Port ( clk : in std_logic;
           rst : in std_logic;        
           ena : in std_logic;
           pl : in std_logic;
           plAddr : in std_logic_vector (DATA_BITS - 1 downto 0);
           data: out std_logic_vector (31 downto 0));
    end component;

begin

uub: entity work.uc
generic map (DATA_BITS=>DATA_BITS , UART_DATA_BITS=>UART_DATA_BITS )

Port map ( clk=>clk , rst=>rst , portRd=>portRd , portWr=>portWr , portWrEna=>portWrEna , 
		 uartDataWr=>uartDataWr , uartDataTx=>uartDataTx , uartDataRx=>uartDataRx ,
		 aluEna=>aluEna , aluCode=>aluCode , aluOp=>aluOp , aluAcc=>aluAcc , aluZero=>aluZero , aluOverflow=>aluOverflow , aluCarryBorrow=>aluCarryBorrow , aluNegative=>aluNegative ,
		 pcEna=>pcEna , pcPl=>pcPl , pcPlAddr=>pcPlAddr , pcData=>pcData );
		 
pcInst: pc
    generic map (DATA_BITS => DATA_BITS)
    port map (
        clk => clk,
        rst => rst,
        ena => pcEna,
        pl => pcPl,
        plAddr => pcPlAddr,
        data => pcData);
------------- procesos ------------------------------------
clk_process :process
begin
    clk <= '1';     wait for clkp/2;
    clk <= '0';     wait for clkp/2;
end process;

-- Reset process --
resetProc :process
begin      
    rst <= '1';     wait for 2*clkp;
    rst <= '0';     wait;
end process;

funcionamiento :process
begin
	uartDataRx <= (others => '0');
	
	aluZero <= '0';
	aluAcc <= (others => '0');
	aluOverflow <= '0';
	aluCarryBorrow <= '0';
	aluNegative <= '1';
	
	portRd <= (others => '0');
	
    --wait until falling_edge (rst);
    --wait for clkp;
    ---
	---
	
	
 	wait;
end process;
-----------------------------------------------------------

end Behavioral;
