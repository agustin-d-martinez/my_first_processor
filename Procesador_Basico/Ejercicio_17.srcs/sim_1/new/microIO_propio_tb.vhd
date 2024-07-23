library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity microIO_propio_tb is
    Generic ( DATA_BITS : integer := 16;
	          SYS_CLK:  integer := 100000000;
              UART_BAUDRATE: integer := 1000000;
              UART_DATA_BITS: integer := 8);
end microIO_propio_tb;

architecture Behavioral of microIO_propio_tb is

    component microIO is
    Generic ( DATA_BITS : integer := 16;
              SYS_CLK:  integer := 100000000;
              UART_BAUDRATE: integer := 1000000;
              UART_DATA_BITS: integer := 8);    
    Port ( clk    : in std_logic;
           rst    : in std_logic;
           portRd : in std_logic_vector (DATA_BITS - 1 downto 0);           
           portWr : out std_logic_vector (DATA_BITS - 1 downto 0);
           uartTx : out std_logic;
           uartRx : in std_logic);
    end component;

    signal clk      : std_logic := '0';
    constant clk_period : time := 10 ns;
    
    signal rst      : std_logic;
    signal portRd : std_logic_vector (DATA_BITS - 1 downto 0);
    signal portWr : std_logic_vector (DATA_BITS - 1 downto 0);
    signal uartTx : std_logic;
    signal uartRx : std_logic;

begin

uut: microIO
    
   Generic map ( DATA_BITS => DATA_BITS,
              SYS_CLK => SYS_CLK,
              UART_BAUDRATE => UART_BAUDRATE,
              UART_DATA_BITS => UART_DATA_BITS)

    Port map ( clk => clk,
               rst => rst,
               portRd => portRd,
               portWr => portWr,
	           uartTx => uartTx,
	           uartRx => uartRx
               );

-- Clock process --
clk_process :process
begin
    clk <= '0';     wait for clk_period/2;
    clk <= '1';     wait for clk_period/2;
end process;

-- Reset process --
resetProc :process
begin      
    rst <= '1';     wait for 50 ns;
    rst <= '0';     wait;
end process;

-- Loop UART --
uartRx <= uartTx;

-- Stimulus process, para test00.coe --
stimProc :process
begin      
    portRd <= (others => '0');
    wait until falling_edge (rst); 
    wait until rising_edge (clk);
    
end process;

end Behavioral;

