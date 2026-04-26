module data_mem (
    input  logic        clk,
    input  logic        we,          // Write Enable (vem da Unidade de Controle)
    input  logic [31:0] addr,        // Endereço (vem do resultado da ULA)
    input  logic [31:0] wd,          // Write Data (vem do registrador RT)
    output logic [31:0] rd           // Read Data (vai para o registrador de destino)
);

    // Memória de 64 palavras de 32 bits (Pode ser aumentada conforme necessário)
    logic [31:0] ram [0:63];

    // Escrita Síncrona: ocorre na borda de subida do clock
    always_ff @(posedge clk) begin
        if (we) begin
            // Alinhamento: dividimos o endereço por 4 (addr[31:2])
            // para acessar o índice correto do array
            ram[addr[31:2]] <= wd;
        end
    end

    // Leitura Combinacional: o dado fica disponível assim que o endereço chega
    assign rd = ram[addr[31:2]];

endmodule
