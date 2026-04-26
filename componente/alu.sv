module alu (
    input  logic [31:0] a,           // Operando A (geralmente RS)
    input  logic [31:0] b,           // Operando B (geralmente RT ou Imediato)
    input  logic [2:0]  alu_control, // Seletor de operação
    output logic [31:0] result,      // Resultado da operação
    output logic        zero         // Flag que indica se o resultado é zero
);

    always_comb begin
        case (alu_control)
            3'b000: result = a & b;          // AND
            3'b001: result = a | b;          // OR
            3'b010: result = a + b;          // ADD (Soma)
            3'b110: result = a - b;          // SUB (Subtração)
            3'b111: result = (a < b) ? 1 : 0; // SLT (Set on Less Than)
            default: result = 32'b0;
        endcase
    end

    // A flag zero é fundamental para instruções de desvio (branch) como o BEQ
    assign zero = (result == 32'b0);

endmodule
