library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity uartRx is
	Generic (	baudRate :	integer := 9600;
				sysClk : 	integer := 100000000;
				dataSize :	integer := 8);
	Port ( 	clk : in std_logic;
			rst : in std_logic;
			dataRd : out std_logic;
			dataRx : out std_logic_vector (dataSize - 1 downto 0);
			rx : in std_logic);
end uartRx;

architecture Behavioral of uartRx is
constant BUADRATE_AUX: integer:=  sysClk/baudRate;
signal data_clk: std_logic ;

signal recibiendo: std_logic ;
signal cont_bits: unsigned(dataSize-1 downto 0);

signal ena_aux: std_logic ;
signal rst_aux: std_logic ;

signal end_rx: std_logic ;

signal mensaje: std_logic_vector ((dataSize+1)-1 downto 0);	--El bit de start lo detecto pero no lo guardo
begin
	----- detecto cuando NO estoy en IDLE -------
	ena_aux <= not(rx);		--Se activa con el bit de start
	rst_aux <= rst or end_rx;
	FF: entity work.FFD
	Port map (clk=>clk , rst=>rst_aux , ena=>ena_aux, d=>ena_aux , q=> recibiendo);
	---------------------------------------------

	---- reloj sincronizado con Buadrate --------
	ContBaudios: entity work.myCnt2
	Generic map (P=>BUADRATE_AUX-1)
	Port map (clk=>clk , rst=>rst_aux , ena=>recibiendo , salida=>data_clk);
	---------------------------------------------
	
	dataRd <= end_rx;
	
	process (clk)
	begin
	if(rising_edge(clk)) then
		if ( rst = '1' ) then		--Caso reset
			dataRx <= (others=> '1');
			mensaje <= (others=> '1');
			cont_bits <= (others=>'0');
			end_rx <= '0';
			
		elsif(data_clk = '1') then	--Caso recibiendo
			if (cont_bits = (dataSize+1)-1 ) then		--Cuento que llegaron los 8 bits + stop
				dataRx <= mensaje ((dataSize+1)-1 downto 1);
				mensaje <= (others=>'1');
				cont_bits <= (others=>'0');
				end_rx <= '1';				--Activo el flag de "recepcion terminada"
			else
				mensaje <= rx & mensaje((dataSize+1)-1 downto 1) ;
				cont_bits <= cont_bits + 1;
			end if;
		else	--Caso iddle
			end_rx <= '0';		--En iddle,no hubo comunicacion terminada
		end if;
		
		
	end if;
	end process;
end Behavioral;
