# O que são

O que cada componente faz.

## Unidades de Processamento e Memória

- `alu.sv` *(ULA)*: É a Unidade Lógica e Aritmética. Ela realiza as operações matemáticas (como soma e subtração) e lógicas (como AND e OR) solicitadas pela instrução.


- `register_file.sv` *(Banco de Registradores)*: Armazena os 32 registradores de uso geral. Ele permite que o processador leia dois valores simultaneamente e escreva um resultado de volta.


- `instruction_mem.sv` *(Memória de Instruções)*: Funciona como uma memória de leitura que entrega a instrução de 32 bits correspondente ao endereço fornecido pelo PC.


- `data_mem.sv` *(Memória de Dados)*: É onde o processador armazena informações temporárias durante a execução (usada pelas instruções `lw` para carregar e `sw` para salvar dados).

## Controle e Fluxo
