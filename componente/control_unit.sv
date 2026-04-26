module control_unit (
    input  logic [5:0] opcode,      // instr[31:26]
    input  logic [5:0] funct,       // instr[5:0] (usado para Tipo-R)
    output logic       mem_to_reg,  // Seleciona se o dado p/ o reg vem da ULA ou Memória
    output logic       mem_write,   // Habilita escrita na memória de dados (sw)
    output logic       branch,      // Indica uma instrução de desvio (beq)
    output logic       alu_src,     // Seleciona se o 2º operando da ULA é Reg ou Imediato
    output logic       reg_dst,     // Seleciona se o destino é o campo 'rt' ou 'rd'
    output logic       reg_write,   // Habilita a escrita no Banco de Registradores
    output logic       jump,        // Indica uma instrução de salto (j)
    output logic [2:0] alu_control  // Comando para a ULA
);

    logic [1:0] alu_op;

    // --- Main Decoder ---
    always_comb begin
        // Valores padrão (Reset)
        reg_write  = 0; reg_dst = 0; alu_src = 0; branch = 0;
        mem_write  = 0; mem_to_reg = 0; jump = 0; alu_op = 2'b00;

        case (opcode)
            6'b000000: begin // TIPO-R (add, sub, and, or, slt)
                reg_write = 1; reg_dst = 1; alu_op = 2'b10;
            end
            6'b100011: begin // LW (Load Word)
                reg_write = 1; alu_src = 1; mem_to_reg = 1; alu_op = 2'b00;
            end
            6'b101011: begin // SW (Store Word)
                alu_src = 1; mem_write = 1; alu_op = 2'b00;
            end
            6'b000100: begin // BEQ (Branch if Equal)
                branch = 1; alu_op = 2'b01;
            end
            6'b001000: begin // ADDI (Add Immediate)
                reg_write = 1; alu_src = 1; alu_op = 2'b00;
            end
            6'b000010: begin // J (Jump)
                jump = 1;
            end
            default: ; // Opcode desconhecido
        endcase
    end

    // --- ALU Decoder ---
    // Refina o sinal alu_op usando o campo 'funct' para instruções Tipo-R
    always_comb begin
        case (alu_op)
            2'b00: alu_control = 3'b010; // Soma (usado para lw, sw, addi)
            2'b01: alu_control = 3'b110; // Subtração (usado para beq)
            default: case (funct)        // Tipo-R
                6'b100000: alu_control = 3'b010; // add
                6'b100010: alu_control = 3'b110; // sub
                6'b100100: alu_control = 3'b000; // and
                6'b100101: alu_control = 3'b001; // or
                6'b101010: alu_control = 3'b111; // slt
                default:   alu_control = 3'b000;
            endcase
        endcase
    end

endmodule
