content = """# Arquitetura MIPS 32-bit: Processador de Ciclo Único

Este documento fornece um resumo técnico sobre o funcionamento e a estrutura de um processador MIPS (Microprocessor without Interlocked Pipeline Stages) de 32 bits implementado em uma organização de **ciclo único**.

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
"""

with open("resumo_mips_32bit_ciclo_unico.md", "w", encoding="utf-8") as f:
    f.write(content)
