module register_file (
    input  logic        clk,
    input  logic        we,          // Write Enable (vem da Unidade de Controle)
    input  logic [4:0]  ra1,         // Endereço de leitura 1 (rs)
    input  logic [4:0]  ra2,         // Endereço de leitura 2 (rt)
    input  logic [4:0]  wa,          // Endereço de escrita (rd ou rt)
    input  logic [31:0] wd,          // Dados a serem escritos (vêm da ULA ou Memória)
    output logic [31:0] rd1,         // Saída de dados 1
    output logic [31:0] rd2          // Saída de dados 2
);

    // Array de 32 registradores de 32 bits cada
    logic [31:0] registers [0:31];

    // Lógica de Escrita (Síncrona)
    always_ff @(posedge clk) begin
        if (we && wa != 5'd0) begin
            registers[wa] <= wd;
        end
    end

    // Lógica de Leitura (Combinacional)
    // No MIPS, o registrador 0 ($zero) é sempre 0.
    assign rd1 = (ra1 == 5'd0) ? 32'd0 : registers[ra1];
    assign rd2 = (ra2 == 5'd0) ? 32'd0 : registers[ra2];

endmodule
