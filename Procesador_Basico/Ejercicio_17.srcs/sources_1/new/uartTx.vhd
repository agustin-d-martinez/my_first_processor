library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity uartTx is
	Generic (	baudRate :	integer := 9600;
				sysClk : 	integer := 100000000;
				dataSize :	integer := 8);
	Port (	clk :	in std_logic;
			rst :	in std_logic;
			dataWr : 	in std_logic;
			dataTx :	in std_logic_vector (dataSize - 1 downto 0);
			ready :		out std_logic;
			tx :	out std_logic);
end uartTx;


architecture Behavioral of uartTx is
constant START: std_logic:= '0'; 
constant STOP: std_logic:= '1';

constant BUADRATE_AUX: integer:=  sysClk/baudRate;
signal data_clk: std_logic ;

signal transmitiendo: std_logic ;

signal mensaje: std_logic_vector ((dataSize + 2)-1 downto 0 );

signal end_com: std_logic ;
signal rst_aux: std_logic ;

begin
rst_aux <= rst or end_com;
----- detecto cuando NO estoy en IDLE -------
FF: entity work.FFD
Port map (clk=>clk , rst=>rst_aux , ena=>dataWr, d=>dataWr , q=> transmitiendo);
---------------------------------------------

---- reloj sincronizado con Buadrate --------
ContBaudios: entity work.myCnt2
Generic map (P=>BUADRATE_AUX-1)
Port map (clk=>clk , rst=>rst_aux , ena=>transmitiendo , salida=>data_clk);
---------------------------------------------

---- envio del mensaje ----------------------
envio_msg: process (clk)
begin
	if (rising_edge(clk)) then
		if(rst = '1') then
			mensaje <= (others=>'1');
		elsif(dataWr = '1' and transmitiendo = '0') then	--Condicion de transmitir para bloquear llamadas en mitad de envio
			mensaje <= (STOP & dataTx & START);		--Seleccion del mensaje actual
		end if;
		
		if (data_clk = '1') then		--Registro de desplazamiento del mensaje
			mensaje <= '1' & mensaje((dataSize+2)-1 downto 1);	
		end if;
	end if;
end process;
tx <= mensaje(0);	--Primero se env?a data(0)
---------------------------------------------

---- fin del mensaje ------------------------
fin_com: entity work.myCnt2
Generic map (P=>(BUADRATE_AUX * (dataSize + 2)))			--Cuando cuento los 8 bits mando a resetear todo
Port map (clk=>clk , rst=>rst , ena=>transmitiendo , salida=>end_com);
ready <= end_com;
---------------------------------------------

end Behavioral;
