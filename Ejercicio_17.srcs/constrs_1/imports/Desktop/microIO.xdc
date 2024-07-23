#Basado en https://github.com/Digilent/digilent-xdc/blob/master/Zybo-Master.xdc

#-- Creo el clock --
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 22.000 -name sys_clk_pin -waveform {0.000 11.000} -add [get_ports clk]

#-- Restricciones de los I/O --
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { rst }]; 
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { uartTx }];  
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {uartRx }]; 

#-- Port Rd --
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { portRd[0] }]; 
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { portRd[1] }]; 
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { portRd[2] }]; 
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { portRd[3] }]; 
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { portRd[4] }]; 
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { portRd[5] }]; 
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { portRd[6] }]; 
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { portRd[7] }]; 
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { portRd[8] }];
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { portRd[9] }];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { portRd[10] }];
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { portRd[11] }];
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { portRd[12] }];
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { portRd[13] }];
set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { portRd[14] }];
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { portRd[15] }];

#-- Port Wr --
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { portWr[0] }]; 
set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { portWr[1] }]; 
set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { portWr[2] }]; 
set_property -dict { PACKAGE_PIN W20   IOSTANDARD LVCMOS33 } [get_ports { portWr[3] }]; 
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { portWr[4] }]; 
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { portWr[5] }]; 
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { portWr[6] }]; 
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { portWr[7] }]; 
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { portWr[8] }];
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { portWr[9] }];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { portWr[10] }];
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { portWr[11] }];
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { portWr[12] }];
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { portWr[13] }];
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { portWr[14] }];
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { portWr[15] }];
