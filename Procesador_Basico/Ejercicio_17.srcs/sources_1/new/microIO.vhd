library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity microIO is
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
end microIO;

architecture Behavioral of microIO is
    component pc is
    Generic ( DATA_BITS : integer := 16);
    Port ( clk : in std_logic;
           rst : in std_logic;        
           ena : in std_logic;
           pl : in std_logic;
           plAddr : in std_logic_vector (DATA_BITS - 1 downto 0);
           data: out std_logic_vector (31 downto 0));
    end component;

    signal pcEna : std_logic;
    signal pcPl : std_logic;
    signal pcPlAddr : std_logic_vector (15 downto 0);
    signal pcData: std_logic_vector (31 downto 0);


    component portIO is
    Generic (DATA_BITS    : integer := 16 );
    Port ( clk : in std_logic;
           rst : in std_logic;
           portRd : in std_logic_vector (DATA_BITS - 1 downto 0);
           portRdReg : out std_logic_vector (DATA_BITS - 1 downto 0);
           portWrEna : in std_logic;
           portWr : out std_logic_vector (DATA_BITS - 1 downto 0);
           portWrReg : in std_logic_vector (DATA_BITS - 1 downto 0));

    end component;
                  
    signal portWrEna : std_logic;              
    signal portRdReg : std_logic_vector (DATA_BITS - 1 downto 0);
    signal portWrReg : std_logic_vector (DATA_BITS - 1 downto 0);
    component alu
    generic (DATA_BITS: integer := 16);
    port ( clk : in std_logic;
           rst : in std_logic;         
           ena : in std_logic;        
           code: in std_logic_vector (3 downto 0);           
           op  : in std_logic_vector (DATA_BITS-1 downto 0);
           acc : out std_logic_vector (DATA_BITS-1 downto 0);
           zero : out std_logic;
           overflow : out std_logic;
           carryBorrow : out std_logic;
           negative : out std_logic);
    end component;

    signal aluEna : std_logic;        
    signal aluCode: std_logic_vector (3 downto 0);           
    signal aluOp  : std_logic_vector (DATA_BITS-1 downto 0);
    signal aluAcc : std_logic_vector (DATA_BITS-1 downto 0);
    signal aluZero : std_logic;
    signal aluOverflow : std_logic;
    signal aluCarryBorrow : std_logic;
    signal aluNegative : std_logic;

    component uart is
    Generic (baudRate : integer := 9600;
             sysClk    : integer := 100000000;
             dataSize  :  integer := 8);
    Port ( clk         : in  std_logic;
           rst         : in  std_logic;
           dataWr      : in  std_logic;
           dataTx      : in std_logic_vector (dataSize - 1 downto 0);
           ready       : out std_logic;
           tx          : out std_logic;
           dataRd      : out  std_logic;
           dataRx      : out std_logic_vector (dataSize - 1 downto 0);
           rx          : in std_logic);
    end component;

    signal uartDataWr : std_logic;
    signal uartDataTx : std_logic_vector (UART_DATA_BITS - 1 downto 0);
    signal uartDataRx : std_logic_vector (UART_DATA_BITS - 1 downto 0);

    component uc is
    generic (DATA_BITS: integer := 16;
             UART_DATA_BITS: integer := 8);
    Port ( clk : in std_logic;
           rst : in std_logic;
           portRd : in std_logic_vector (DATA_BITS - 1 downto 0);
           portWr : out std_logic_vector (DATA_BITS - 1 downto 0);
           portWrEna    : out std_logic;                
           uartDataWr   : out  std_logic;
           uartDataTx   : out std_logic_vector (UART_DATA_BITS - 1 downto 0);
           uartDataRx   : in std_logic_vector (UART_DATA_BITS - 1 downto 0);                      
           aluEna : out std_logic;
           aluCode: out std_logic_vector (3 downto 0);           
           aluOp  : out std_logic_vector (DATA_BITS - 1 downto 0);
           aluAcc : in std_logic_vector (DATA_BITS - 1 downto 0);         
           aluZero : in std_logic;
           aluOverflow : in std_logic;
           aluCarryBorrow : in std_logic;
           aluNegative : in std_logic;
           pcEna : out std_logic;
           pcPl : out std_logic;
           pcPlAddr : out std_logic_vector (15 downto 0);
           pcData: in std_logic_vector (31 downto 0));           
    end component;

begin

pcInst: pc
    generic map (DATA_BITS => DATA_BITS)
    port map (
        clk => clk,
        rst => rst,
        ena => pcEna,
        pl => pcPl,
        plAddr => pcPlAddr,
        data => pcData);
        
portIOInst: portIO
    generic map (DATA_BITS => DATA_BITS)
    port map (
        clk => clk,
        rst => rst, 
        portRd => portRd,
        portRdReg => portRdReg,        
        portWrEna => portWrEna,
        portWr => portWr,
        portWrReg => portWrReg                              
        );
        
aluInst: alu
    generic map (DATA_BITS => DATA_BITS)
    port map (
        clk => clk,
        rst => rst,
        ena => aluEna,        
        code => aluCode,           
        op => aluOp,
        acc => aluAcc,
        zero => aluZero,
        overflow => aluOverflow,
        carryBorrow => aluCarryBorrow,
        negative => aluNegative);

uartInst: uart
    Generic map (baudRate => UART_BAUDRATE,
                 sysClk => SYS_CLK,
                 dataSize => UART_DATA_BITS)
    Port map( clk => clk,
              rst => rst,
              dataWr => uartDataWr,
              dataTx => uartDataTx,
              ready => open,
              tx => uartTx,
              dataRd  => open,
              dataRx  => uartDataRx,
              rx  => uartRx);
    
ucInst: uc
    generic map (DATA_BITS => DATA_BITS,
                 UART_DATA_BITS => UART_DATA_BITS)
    port map (
        clk => clk,
        rst => rst,
        portRd => portRdReg,
        portWr => portWrReg,
        portWrEna => portWrEna,        
        uartDataWr => uartDataWr,
        uartDataTx => uartDataTx,
        uartDataRx => uartDataRx,           
        aluEna => aluEna,
        aluCode => aluCode,           
        aluOp => aluOp,
        aluAcc => aluAcc,         
        aluZero => aluZero,
        aluOverflow => aluOverflow,
        aluCarryBorrow => aluCarryBorrow,
        aluNegative => aluNegative,
        pcEna => pcEna,
        pcPl => pcPl,
        pcPlAddr => pcPlAddr,
        pcData => pcData);                   
        
end Behavioral;