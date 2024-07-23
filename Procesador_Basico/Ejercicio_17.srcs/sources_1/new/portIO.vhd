library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity portIO is
    Generic (DATA_BITS    : integer := 16 );
    Port ( clk : in std_logic;
           rst : in std_logic;
           portRd : in std_logic_vector (DATA_BITS - 1 downto 0);
           portRdReg : out std_logic_vector (DATA_BITS - 1 downto 0);
           portWrEna : in std_logic;
           portWr : out std_logic_vector (DATA_BITS - 1 downto 0);
           portWrReg : in std_logic_vector (DATA_BITS - 1 downto 0));
end portIO;

architecture Behavioral of portIO is
	signal s_portRdReg: std_logic_vector (DATA_BITS-1 downto 0);
	signal s_portWr: std_logic_vector (DATA_BITS-1 downto 0);

begin

process (clk , rst , portWrEna )
begin
	if (rising_edge(clk)) then
		if (rst = '1') then
			s_portRdReg <= (others =>'0');
			s_portWr <= (others =>'0');
		else
			s_portRdReg <= portRd;
			if ( portWrEna = '1' ) then
				s_portWr <= portWrReg;
			end if;
		end if;
	end if;
end process;

portRdReg <= s_portRdReg;
portWr <= s_portWr;

end Behavioral;
