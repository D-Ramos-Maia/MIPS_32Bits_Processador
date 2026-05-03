#1. What are they?

What each component does.

## Processing and Memory Units

- `alu.sv` *(ALU)*: This is the Arithmetic Logic Unit. It performs the mathematical operations (such as addition and subtraction) and logical operations (such as AND and OR) requested by the instruction.

- `register_file.sv` *(Register Bank)*: Stores the 32 general-purpose registers. It allows the processor to read two values ​​simultaneously and write a result back.

- `instruction_mem.sv` *(Instruction Memory)*: Functions as a read memory that delivers the 32-bit instruction corresponding to the address provided by the PC.

- `data_mem.sv` *(Data Memory)*: This is where the processor stores temporary information during execution (used by the `lw` instruction to load and `sw` instructions to save data).

## Control and Flow

- `pc.sv` *(Program Counter)*: This register holds the address of the current instruction. It indicates to the system which instruction will be fetched from memory next.

- `control_unit.sv` *(Control Unit)*: This is the "brain" of the processor. It decodes the instruction code (opcode) and generates the electrical signals that activate or deactivate the other components.

- `sign_extend.sv` *(Sign Extender)*: Takes "immediate" 16-bit values ​​(small numbers embedded in the instruction) and transforms them into 32 bits so they can be processed by the ALU.

## Integration and Configuration
- `mips_top.sv`: This is the top-level module. It serves as the "envelope" that connects all the components listed above to form the complete processor.

- `programa_mips.mem`: Contains the machine code (in hexadecimal or binary) that will be loaded into the instruction memory to be executed by the processor.

- `config.yaml`: Configuration file, probably used by synthesis tools or the OpenROAD flow to define chip production parameters.

# 2. Prerequisites for running the flowchart

The tools used to create the flowchart are open-source tools that are geared towards the `Linux` operating system; therefore, to run it, we need a `Linux` operating system.

If you are in a Windows environment, simply install Ubuntu via WSL in PowerShell or the Command Prompt as Administrator. Run the command:

```Bash
wsl --install
```

Once you have a Linux operating system, follow the steps described in (https://unic-cass.github.io/training/2.0-env-setup-prerequisites.html), completing steps 2.0 to 2.3, so that we have the environment to fully implement the workflow.

# 3. Running the Flowchart

Once the Docker `UNIC-CASS` is installed, run it:

```Bash
$ cd $HOME/projects/uniccass-design-tools
$ make start
```

Once done, run the following commands in sequence:

```Bash
# Enters the shared folder; everything done there is permanent. cd shared

# Downloads the repository from GitHub. git clone https://github.com/D-Ramos-Maia/MIPS_32Bits_Processador.git

# Enters the component folder. cd MIPS_32Bits_Processador
cd componente

# Views the design. librelane --pdk ihp-sg13g2 config.yaml --last-run --flow OpenInOpenROAD
```

This is explained much better in (https://unic-cass.github.io/training/4.2-implementation-using-librelane.html).

---
---
---

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
- `mips_top.sv`: É o módulo de nível superior (Top Level). Ele serve como o "envelope" que conecta todos os componentes listados acima para formar o processador completo.
- `programa_mips.mem`: Contém o código de máquina (em hexadecimal ou binário) que será carregado na memória de instruções para ser executado pelo processador.
- `config.yaml`: Arquivo de configuração, provavelmente utilizado pelas ferramentas de síntese ou pelo fluxo OpenROAD para definir parâmetros de produção do chip.

# 2. Pré-requisitos para executar o fluxograma

As ferramentas usadas para fazermos o fluxograma são ferramentas de código aberto que são voltadas para o sistema operacional `Linux`, portanto para podermos executar ele precisamos de um sistema operacional `Linux`.


Caso esteja em um ambiente `Windows`, basta instalar o `Ubutu` via `wsl`, no `PowerShell` ou o `Prompt de Comando` como Administrador, execute o comando:

```Bash 
wsl --install
``` 

Uma vez que tenha um sistema operacional `Linux`, siga os passos descritos em (https://unic-cass.github.io/training/2.0-env-setup-prerequisites.html), execute os passos 2.0 a 2.3 por completo, para que tenhamos o ambiente para podermos implementar o fluxo por completo. 

# 3. Executando o fluxograma

Uma vez com o Docker `UNIC-CASS` estiver instalado, o execute:

```Bash
$ cd $HOME/projects/uniccass-design-tools
$ make start
```

Uma vez feito execute os seguintes comando em sequência:

```Bash
# Entra na pasta shared, tudo o que é feito nela é permanente
cd shared

# Baixar o repositório do github
git clone https://github.com/D-Ramos-Maia/MIPS_32Bits_Processador.git

# Entra na pasta componente
cd MIPS_32Bits_Processador
cd componente

# Ver o design
librelane --pdk ihp-sg13g2 config.yaml --last-run --flow OpenInOpenROAD
```

Isso é explicado bem melhor em (https://unic-cass.github.io/training/4.2-implementation-using-librelane.html).







