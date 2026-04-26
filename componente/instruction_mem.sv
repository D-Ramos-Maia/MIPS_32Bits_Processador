module instruction_mem (
    input  logic [31:0] addr,   // Endereço vindo do PC
    output logic [31:0] instr   // Instrução de 32 bits (MIPS)
);

    // Memória de 256 palavras (1KB de memória de instrução)
    // Você pode aumentar conforme o tamanho do seu programa
    logic [31:0] rom [0:255];

    // Inicialização da memória com o programa em Assembly (binário ou hex)
    initial begin
        // O arquivo deve conter o código de máquina do MIPS
        $readmemh("programa_mips.mem", rom);
    end

    // Lógica de Endereçamento MIPS:
    // Como cada instrução tem 4 bytes, o PC pula de 4 em 4.
    // Para acessar o índice do array [0, 1, 2...], dividimos por 4
    // Isso é feito ignorando os dois bits menos significativos (addr / 4)
    assign instr = rom[addr[31:2]];

endmodule
