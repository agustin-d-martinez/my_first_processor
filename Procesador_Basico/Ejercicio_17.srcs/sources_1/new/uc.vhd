library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity uc is
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
           pcData: in std_logic_vector (31 downto 0) );           
end uc;

architecture Behavioral of uc is
signal operacion: std_logic_vector (2-1 downto 0);
signal codigo_op: std_logic_vector (4-1 downto 0);
signal LIT_sel: std_logic ;
signal DATA: std_logic_vector (16-1 downto 0);


COMPONENT ramMem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

signal wea: STD_LOGIC_VECTOR(0 DOWNTO 0);
signal ramDataRd: std_logic_vector (16-1 downto 0) ;
signal ramDataWr: std_logic_vector (16-1 downto 0) ;

------ SIGNALS ESTADOS ---------------------------------------------------------------------
type state_type is (RESET, SUMO ,IDLE_AUX , IDLE , 
					ALU , 
					MOV_MEM , MOV_PORT , MOV_UART ,
					JUMP , JUMP_COND ,  PROPAGACION_JUMP);
signal state: state_type;
signal nextState: state_type;
--------------------------------------------------------------------------------------------

signal s_uartDataRx :	std_logic_vector (UART_DATA_BITS - 1 downto 0);

signal jumpData:  std_logic_vector (16-1 downto 0) ;
signal jumpCond: std_logic ;

begin

operacion <= pcData(22 downto 21);
codigo_op <= pcData(20 downto 17);
LIT_sel <= pcData(16);
DATA <= pcData(15 downto 0);
------- LOGICA COMBINACIONAL --------------------
aluCode <= codigo_op;

aluOp <= 	DATA when (LIT_sel = '1') else
			ramDataRd;

ramDataWr <= 	portRd 		when (pcData(18 downto 17) = "00") else
				("00000000" & uartDataRx) 	when (pcData(18 downto 17) = "01") else----------------------------------------------------------------
				aluAcc 		when (pcData(18 downto 17) = "10") else
				(others => '0');

portWr  <= 	DATA when (LIT_sel = '1') else
			ramDataRd ;
			
pcPlAddr <= jumpData;
			
uartDataTx <= 	DATA(UART_DATA_BITS-1 downto 0) when (LIT_sel = '1') else
				ramDataRd(UART_DATA_BITS-1 downto 0);
					
jumpCond <= aluZero 		when (codigo_op = "0000") else
			aluOverflow 	when (codigo_op = "0001") else
			aluCarryBorrow 	when (codigo_op = "0010") else
			aluNegative;
--------------------------------------------------

RAM : ramMem
  PORT MAP (
    clka => clk,
    wea => wea,
    addra => DATA(9 downto 0),
    dina => ramDataWr,
    douta => ramDataRd
  );
----- LOGICA ESTADOS -----------------
estadoProc: process(clk)
begin
    if ( rising_edge (clk) ) then
        if ( rst = '1' ) then
            state <= RESET;
        else     
            state <= nextState;
        end if;
    end if;
end process;
------ LOGICA SALIDA -----------------
salidaProcess: process(state , LIT_sel , jumpCond , DATA , ramDataRd)
begin
    case (state) is
    	when SUMO =>
    		pcEna <= '1';		--Solo ac? imprimimo 1 intruccion
    		pcPl <= '0';		--Solo se activara en los JUMP
       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '0';
       		jumpData <= (others => '0');
       	when IDLE_AUX =>
			pcEna <= '0';		
       		pcPl <= '0';	
			aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '0';
       		jumpData <= (others => '0');
       		
        when IDLE =>		--La m?quina ira de SUMO a IDLE infinitamente. SUMO agrega uno, IDLE analiza
       		pcEna <= '0';		
       		pcPl <= '0';	

       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '0';
       		jumpData <= (others => '0');
        when ALU =>
       		pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '1';		--Solo aca activo la ALU
       		--					--El codigo de la ALU y su salida estan en logica combinacional
       		wea <= "0";
        	portWrEna <= '0';
       		uartDataWr <= '0';
       		jumpData <= (others => '0');
        when MOV_MEM =>
       		pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '0';
       		wea <= "1";		--Solo aca escribo la RAM
       		--				--El dina de la memoria esta en logica combinacional.
       		portWrEna <= '0';
       		uartDataWr <= '0';----Verificar uart        when MOV_PORT =>
       		jumpData <= (others => '0');
       	when MOV_PORT =>
       		pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '1';		--Solo activo el port
       		--						--El dato a mandar esta en logica combinacional
       		uartDataWr <= '0';----Verificar uart
       		jumpData <= (others => '0');
        when MOV_UART =>
       		pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '1';--VERIFICAR UART
       		jumpData <= (others => '0');
        when JUMP =>
       		pcEna <= '1';
       		pcPl <= '1';
       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '0';
       		
			if ( LIT_sel = '1' ) then
       			jumpData <= DATA;
       		else
       			jumpData <= ramDataRd;
       		end if;
       		
        when JUMP_COND =>
        	if ( LIT_sel = '1' ) then
       			jumpData <= DATA;
       		else
       			jumpData <= ramDataRd;
       		end if;
       		
       		if ( jumpCond = '1' ) then
       			pcPl <= '1';
       			pcEna <= '1';
       		else 
       			pcPl <= '0';
       			pcEna <= '0';
       		end if;
       		
       		aluEna <= '0';
       		wea <= "0";
       		portWrEna <= '0';
       		uartDataWr <= '0';

        when RESET =>
       		pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '0';
       		wea <= "0";
			portWrEna <= '0';
			uartDataWr <= '0';
			jumpData <= (others => '0');
        when OTHERS =>      --Caso de seguridad
        	pcEna <= '0';
       		pcPl <= '0';
       		aluEna <= '0';
       		wea <= "0";
			portWrEna <= '0';
			uartDataWr <= '0';
			jumpData <= (others => '0');
     end case;
end process;
------ LOGICA TRANSICIONES ------------
transicionProcess: process( state , operacion , codigo_op , jumpCond)
begin
    nextState <= state;         --Equivalente a todos los ELSE donde el estado no cambia
    case (state) is
    	when SUMO =>
    		nextState <= IDLE_AUX;
    	when IDLE_AUX =>
    		nextState <= IDLE;
        when IDLE =>
        ----
			if ( operacion = "01" ) then		--CONDICION ALU
				nextState <= ALU;
			elsif ( operacion = "10") then		--CONDICION JUMP
				if( codigo_op = "0000" ) then
					nextState <= JUMP_COND;
				elsif( codigo_op = "0001") then
					nextState <= JUMP_COND;	
				elsif ( codigo_op = "0010" ) then
					nextState <= JUMP_COND;	
				elsif ( codigo_op = "0011" ) then
					nextState <= JUMP_COND;	
				else
					nextState <= JUMP;	
				end if;
			elsif ( operacion = "11") then		--CONDICION MOV
				if( codigo_op = "0100" ) then
					nextState <= MOV_PORT;
				elsif ( codigo_op = "0101" ) then
					nextState <= MOV_UART;
				else
					nextState <= MOV_MEM;
				end if;
			else
				nextState <= SUMO;
			end if;
        when ALU =>
        	nextState <= SUMO;
        when MOV_MEM =>
        	nextState <= SUMO;
        when MOV_PORT =>
        	nextState <= SUMO;
        when MOV_UART =>
        	nextState <= SUMO;
        when JUMP =>
        	nextState <= IDLE_AUX;
        when JUMP_COND =>
        	if (jumpCond = '1') then
        		nextState <= IDLE_AUX;
        	else
        		nextState <= SUMO;
        	end if;

        when RESET =>
        ----
        	nextState <= IDLE;
        when OTHERS =>      --Caso de seguridad
            nextState <= RESET;
        end case;
end process;
---------------------------------------



end Behavioral;
