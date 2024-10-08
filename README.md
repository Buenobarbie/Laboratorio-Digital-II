# Laboratorio-Digital-II

## Configurar Modelsim no Quartus
- Tools -> Options -> EDA Tools Options
	- Verificar se no ModelSim-Altera está o endereço `C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem`;
	- Se não estiver, colocar;
Isso indica para o quartus onde a aplicação Modelsim está.

## Configurar testbench 
- Assignments -> Settings -> EDA Tool Settings -> Simulation
		- Conferir se o tool name é `Modelsim-Altera`;
		- Format for output Netlist deve ser `Verilog HDL`;
		- Compile test bench -> Colocar o nome do testbench -> Testbenchs -> New -> Nome do arquivo, Nome do módulo principal, Procurar o arquivo, -> Add;
		
## Abrir o a simulação com Modelsim pelo Quartus
- Tools -> Run simulation tool -> RTL simulation;
