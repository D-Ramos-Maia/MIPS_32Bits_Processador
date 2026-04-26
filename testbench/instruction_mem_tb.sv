`timescale 1ns / 1ps

module instruction_mem_tb;

    // Sinais de teste
    logic [31:0] addr;
    logic [31:0] instr;

    // Instanciação do Módulo (DUT - Device Under Test)
    instruction_mem dut (
        .addr(addr),
        .instr(instr)
    );

    // Bloco de estímulos
    initial begin
        $display("Iniciando teste da Memória de Instruções MIPS...");
        $display("----------------------------------------------");

        // Teste 1: Endereço 0
        addr = 32'h0000_0000;
        #10;
        $display("Endereço: %h | Instrução: %h", addr, instr);

        // Teste 2: Próxima instrução (Endereço 4)
        addr = 32'h0000_0004;
        #10;
        $display("Endereço: %h | Instrução: %h", addr, instr);

        // Teste 3: Endereço 8
        addr = 32'h0000_0008;
        #10;
        $display("Endereço: %h | Instrução: %h", addr, instr);

        // Teste 4: Salto para um endereço distante
        addr = 32'h0000_0020; // (Seria a 9ª instrução, pois 32/4 = 8)
        #10;
        $display("Endereço: %h | Instrução: %h", addr, instr);

        $display("----------------------------------------------");
        $display("Fim da simulação.");
        $finish;
    end

endmodule
