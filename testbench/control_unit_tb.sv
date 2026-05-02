`timescale 1ns / 1ps

module control_unit_tb;

    // Sinais de entrada
    logic [5:0] opcode;
    logic [5:0] funct;

    // Sinais de saída
    logic       mem_to_reg;
    logic       mem_write;
    logic       branch;
    logic       alu_src;
    logic       reg_dst;
    logic       reg_write;
    logic       jump;
    logic [2:0] alu_control;

    // Instanciação da Unidade de Controle (DUT)
    control_unit dut (
        .opcode(opcode),
        .funct(funct),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .branch(branch),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .jump(jump),
        .alu_control(alu_control)
    );

    initial begin

        //Esse script gera um arquivo .vcd, remova o comentario caso queira essa função
        $dumpfile("control_unit_tb.vcd"); // O arquivo nasce aqui
        $dumpvars(0, control_unit_tb);   // Aqui ele começa a gravar
        
        $display("Iniciando Teste da Unidade de Controle MIPS");
        $display("-------------------------------------------");

        // --- Teste 1: Instrução Tipo-R (Ex: ADD) ---
        opcode = 6'b000000; funct = 6'b100000;
        #10;
        $display("TIPO-R (ADD) -> RegWrite: %b, RegDst: %b, ALUControl: %b", reg_write, reg_dst, alu_control);

        // --- Teste 2: Instrução LW (Load Word) ---
        opcode = 6'b100011; funct = 6'bxxxxxx; // Funct não importa p/ LW
        #10;
        $display("LW           -> RegWrite: %b, ALUSrc: %b, MemToReg: %b", reg_write, alu_src, mem_to_reg);

        // --- Teste 3: Instrução SW (Store Word) ---
        opcode = 6'b101011;
        #10;
        $display("SW           -> MemWrite: %b, RegWrite: %b, ALUSrc: %b", mem_write, reg_write, alu_src);

        // --- Teste 4: Instrução BEQ (Branch if Equal) ---
        opcode = 6'b000100;
        #10;
        $display("BEQ          -> Branch: %b, RegWrite: %b, ALUControl: %b (SUB)", branch, reg_write, alu_control);

        // --- Teste 5: Instrução JUMP (J) ---
        opcode = 6'b000010;
        #10;
        $display("JUMP         -> Jump: %b, RegWrite: %b", jump, reg_write);

        $display("-------------------------------------------");
        $display("Fim dos testes.");
        $finish;
    end

endmodule
