# 1. O que são

O que cada componente faz.

## Unidades de Processamento e Memória

- `alu.sv` *(ULA)*: É a Unidade Lógica e Aritmética. Ela realiza as operações matemáticas (como soma e subtração) e lógicas (como AND e OR) solicitadas pela instrução.


- `register_file.sv` *(Banco de Registradores)*: Armazena os 32 registradores de uso geral. Ele permite que o processador leia dois valores simultaneamente e escreva um resultado de volta.


- `instruction_mem.sv` *(Memória de Instruções)*: Funciona como uma memória de leitura que entrega a instrução de 32 bits correspondente ao endereço fornecido pelo PC.


- `data_mem.sv` *(Memória de Dados)*: É onde o processador armazena informações temporárias durante a execução (usada pelas instruções `lw` para carregar e `sw` para salvar dados).

## Controle e Fluxo

- `pc.sv` *(Program Counter)*: É o registrador que mantém o endereço da instrução atual. Ele indica ao sistema qual será a próxima instrução a ser buscada na memória.


- `control_unit.sv` *(Unidade de Controle)*: É o "cérebro" do processador. Ela decodifica o código da instrução (opcode) e gera os sinais elétricos que ativam ou desativam os outros componentes.


- `sign_extend.sv` *(Extensor de Sinal)*: Pega valores "imediatos" de 16 bits (números pequenos embutidos na instrução) e os transforma em 32 bits para que possam ser processados pela ULA.

## Integração e Configuração
- ´mips_top.sv`: É o módulo de nível superior (Top Level). Ele serve como o "envelope" que conecta todos os componentes listados acima para formar o processador completo.
- `programa_mips.mem`: Contém o código de máquina (em hexadecimal ou binário) que será carregado na memória de instruções para ser executado pelo processador.
- `config.yaml`: Arquivo de configuração, provavelmente utilizado pelas ferramentas de síntese ou pelo fluxo OpenROAD para definir parâmetros de produção do chip.
