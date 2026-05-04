![CPU MIPS-32bits](https://github.com/D-Ramos-Maia/Fotos/blob/2bca389f25962b48c523029737afb6121b83fd96/Capturar4.JPG)

This document provides a technical summary of the operation and structure of a 32-bit MIPS processor implemented in a **single-cycle** organization.

---

## 1. What is a Single-Cycle MIPS Processor?

A **single-cycle** processor is an implementation of the MIPS architecture where every instruction is executed entirely within a single clock cycle. This means the clock period must be long enough to accommodate the slowest instruction (usually the memory load instruction, `lw`).

### Key Characteristics:
* **CPI (Cycles Per Instruction) = 1**: Every instruction takes exactly one cycle.
* **Control Simplicity**: The control logic is purely combinational.
* **Limited Performance**: The clock is determined by the "critical path" (the most time-consuming instruction), which limits the operating frequency compared to multi-cycle or pipelined versions.

---

## 2. Main Components (Datapath)

The "datapath" is the set of functional units that operate on data. The primary components are:

1. **Program Counter (PC)**: A 32-bit register that stores the address of the next instruction to be executed.
2. **Instruction Memory**: Stores the program code. Given an address from the PC, it provides the 32-bit instruction.
3. **Register File**: Contains 32 general-purpose registers ($s0, $t0, etc.). It allows reading two registers and writing to one simultaneously.
4. **Arithmetic Logic Unit (ALU)**: Performs mathematical calculations (addition, subtraction) and logical operations (AND, OR).
5. **Data Memory**: Stores the data manipulated by the program (used by `lw` and `sw` instructions).
6. **Sign Extension Unit**: Converts 16-bit immediate values into 32 bits, preserving the sign.

---

## 3. The 5 Execution Stages

Although they occur within a single cycle, the data flow logically passes through five stages:

1. **Instruction Fetch (IF)**: The PC sends the address to the Instruction Memory, which returns the instruction. The PC is updated to `PC + 4`.
2. **Instruction Decode and Register Read (ID)**: The Control Unit analyzes the instruction to determine the required action and reads the necessary values from the Register File.
3. **Execution (EX)**: The ALU performs the operation (e.g., adding two numbers or calculating a memory address).
4. **Memory Access (MEM)**: If it is a load (`lw`) or store (`sw`) instruction, the processor accesses the Data Memory.
5. **Write Back (WB)**: The result from the ALU or the data read from memory is written back to the Register File.

---

## 4. Control Unit

The Control Unit is the "brain" of the processor. It receives the instruction opcodes and generates signals that activate or deactivate components.

| Control Signal | Function |
| :--- | :--- |
| **RegDst** | Determines which instruction field indicates the destination register. |
| **ALUSrc** | Determines if the ALU receives the second input from a register or an immediate value. |
| **MemtoReg** | Determines if the value written to the register comes from the ALU or memory. |
| **RegWrite** | Authorizes writing to the Register File. |
| **MemRead / MemWrite** | Authorizes reading from or writing to the Data Memory. |
| **Branch** | Indicates if the instruction is a conditional branch (e.g., `beq`). |

---

## 5. Operational Summary

1. The cycle begins with the rising edge of the clock.
2. The instruction is fetched and decoded.
3. Control signals configure the multiplexers and functional units.
4. Data flows through the ALU and Memory.
5. At the end of the cycle (falling edge or next rising edge), the result is recorded in the registers or memory, and the PC is updated.

This model is fundamental for teaching computer architecture due to its visual clarity and direct logic, serving as a foundation for studying advanced techniques like **Pipelining**.

---

## 6. Repository Contents

This repository contains all the files necessary for the design, testing, and physical production of the processor.

* **`componente` folder**: Contains the source code for all the fundamental blocks required for processor manufacturing.
* **`testbench` folder**: Includes the test modules that individually validate each component from the previous folder.
* **`Arquivos_.vcd` folder**: Contains waveform files (.vcd) that record the temporal behavior of components during tests.
* **`MIPS_32bits.gds` file**: This is the final physical layout file. It integrates all components and is ready to be sent to production (foundry).

---
---
---

Este documento fornece um resumo técnico sobre o funcionamento e a estrutura de um processador MIPS de 32 bits implementado em uma organização de **ciclo único**.

---

## 1. O que é um Processador MIPS de Ciclo Único?

Um processador de **ciclo único** é uma implementação da arquitetura MIPS onde cada instrução é executada inteiramente em um único ciclo de clock. Isso significa que o período do clock deve ser longo o suficiente para acomodar a instrução mais lenta (geralmente a instrução de leitura da memória, `lw`).

### Características Principais:
- **CPI (Cycles Per Instruction) = 1**: Toda instrução leva exatamente um ciclo.
- **Simplicidade de Controle**: A lógica de controle é puramente combinacional.
- **Desempenho Limitado**: O clock é determinado pelo "caminho crítico" (a instrução mais demorada), o que limita a frequência de operação em comparação com versões multiciclo ou pipelined.

---

## 2. Componentes Principais (Datapath)

O "caminho de dados" (datapath) é o conjunto de unidades funcionais que operam sobre os dados. Os principais componentes são:

1.  **Contador de Programa (PC - Program Counter)**: Um registrador de 32 bits que armazena o endereço da próxima instrução a ser executada.
2.  **Memória de Instruções**: Armazena o código do programa. Dado um endereço do PC, ela fornece a instrução de 32 bits.
3.  **Banco de Registradores (Register File)**: Contém 32 registradores de uso geral ($s0, $t0, etc.). Permite ler dois registradores e escrever em um simultaneamente.
4.  **Unidade Lógica e Aritmética (ULA)**: Realiza cálculos matemáticos (soma, subtração) e operações lógicas (AND, OR).
5.  **Memória de Dados**: Armazena os dados que o programa manipula (usada por instruções `lw` e `sw`).
6.  **Unidade de Extensão de Sinal**: Converte valores imediatos de 16 bits para 32 bits, preservando o sinal.

---

## 3. As 5 Etapas da Execução

Embora ocorram em um único ciclo, o fluxo de dados passa logicamente por cinco etapas:

1.  **Busca da Instrução (Instruction Fetch - IF)**: O PC envia o endereço para a Memória de Instruções, que devolve a instrução. O PC é atualizado para `PC + 4`.
2.  **Decodificação e Leitura de Registradores (ID)**: A Unidade de Controle analisa a instrução para determinar o que fazer e lê os valores dos registradores necessários no Banco de Registradores.
3.  **Execução (EX)**: A ULA realiza a operação (ex: soma dois números ou calcula um endereço de memória).
4.  **Acesso à Memória (MEM)**: Se for uma instrução de carga (`lw`) ou armazenamento (`sw`), o processador acessa a Memória de Dados.
5.  **Escrita de Volta (Write Back - WB)**: O resultado da ULA ou o dado lido da memória é escrito de volta no Banco de Registradores.

---

## 4. Unidade de Controle

A Unidade de Controle é o "cérebro" do processador. Ela recebe os opcodes da instrução e gera sinais que ativam ou desativam componentes.

| Sinal de Controle | Função |
| :--- | :--- |
| **RegDst** | Decide qual campo da instrução indica o registrador de destino. |
| **ALUSrc** | Decide se a ULA recebe o segundo dado de um registrador ou de um valor imediato. |
| **MemtoReg** | Decide se o valor escrito no registrador vem da ULA ou da memória. |
| **RegWrite** | Autoriza a escrita no Banco de Registradores. |
| **MemRead / MemWrite** | Autoriza a leitura ou escrita na Memória de Dados. |
| **Branch** | Indica se a instrução é um desvio condicional (ex: `beq`). |

---

## 5. Resumo de Funcionamento

1. O ciclo começa com a borda de subida do clock.
2. A instrução é buscada e decodificada.
3. Os sinais de controle configuram os multiplexadores e unidades funcionais.
4. Os dados fluem através da ULA e Memória.
5. No final do ciclo (borda de descida ou próxima subida), o resultado é gravado nos registradores ou memória e o PC é atualizado.

Este modelo é fundamental para o ensino de arquitetura de computadores por sua clareza visual e lógica direta, servindo de base para o estudo de técnicas mais avançadas como o **Pipelining**.

## 6. O que há no repositório 

Detalhes do que há nesse repositório. O objetivo final deste repositório é ter os componentes necessários para a produção da mesma. Todos os componentes necessários para tal estão na pasta `componente`.

As outras pastas têm uma função distinta. E o arquivo `MIPS_32bits.gds` já é o resultado final do que esses componentes em conjuntos, já prontos para a produção.

A pasta `testbench` tem componentes que testam todos os componentes da pasta `componente`.

E por fim a pasta `Arquivos_.vcd` tem arquivos .vcd que descrevem formas de onda de cada componente mediante certos estímulos os mesmo que o seu equivalente de mesmo nome gera na pasta `testbench`.
