module pc (
    input  logic        clk,    // Clock do sistema
    input  logic        rst_n,  // Reset assíncrono (ativo em nível baixo)
    input  logic [31:0] pc_in,  // Endereço calculado pela lógica de próxima instrução
    output logic [31:0] pc_out  // Endereço atual enviado para a memória de instruções
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            pc_out <= 32'h0000_0000;
        end else begin

            // No ciclo único, o PC recebe um novo valor a cada ciclo de clock
            pc_out <= pc_in;
        end
    end

endmodule
