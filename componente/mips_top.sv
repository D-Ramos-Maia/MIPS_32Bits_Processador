module mips_top (
    input  logic clk,
    input  logic rst_n
);

    // --- Sinais de Interconexão (Fios) ---
    logic [31:0] pc_out, pc_in, pc_plus_4, pc_branch;
    logic [31:0] instr;
    logic [31:0] rd1, rd2, wd_rf;
    logic [31:0] sign_imm, sign_imm_shl2;
    logic [31:0] alu_src_b, alu_result;
    logic [31:0] read_data;
    logic [4:0]  write_reg;
    logic        zero;

    // --- Sinais de Controle ---
    logic reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg, jump;
    logic [2:0] alu_control;

    // --- 1. Busca da Instrução (Fetch) ---
    pc p_counter (
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    instruction_mem i_mem (
        .addr(pc_out),
        .instr(instr)
    );

    // Somador PC + 4
    assign pc_plus_4 = pc_out + 4;

    // --- 2. Decodificação e Banco de Registradores ---
    control_unit c_unit (
        .opcode(instr[31:26]),
        .funct(instr[5:0]),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .branch(branch),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .jump(jump),
        .alu_control(alu_control)
    );

    // Mux para decidir o registrador de destino (Tipo-R usa RD, Tipo-I usa RT)
    assign write_reg = reg_dst ? instr[15:11] : instr[20:16];

    register_file reg_file (
        .clk(clk),
        .we(reg_write),
        .ra1(instr[25:21]),
        .ra2(instr[20:16]),
        .wa(write_reg),
        .wd(wd_rf),
        .rd1(rd1),
        .rd2(rd2)
    );

    sign_extend s_ext (
        .a(instr[15:0]),
        .y(sign_imm)
    );

    // --- 3. Execução (ULA) ---
    // Mux para a entrada B da ULA (Registrador ou Imediato)
    assign alu_src_b = alu_src ? sign_imm : rd2;

    alu main_alu (
        .a(rd1),
        .b(alu_src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // --- 4. Memória de Dados e Escrita (Write Back) ---
    data_mem d_mem (
        .clk(clk),
        .we(mem_write),
        .addr(alu_result),
        .wd(rd2),
        .rd(read_data)
    );

    // Mux final: O que volta para o registrador? (Dado da RAM ou resultado da ULA)
    assign wd_rf = mem_to_reg ? read_data : alu_result;

    // --- 5. Lógica de Próximo PC (Branch e Jump) ---
    // Cálculo do endereço de Branch
    assign sign_imm_shl2 = {sign_imm[29:0], 2'b00};
    assign pc_branch = pc_plus_4 + sign_imm_shl2;

    // Mux para decidir entre PC+4 ou Branch
    logic [31:0] pc_next_branch;
    assign pc_next_branch = (branch & zero) ? pc_branch : pc_plus_4;

    // Mux para decidir entre o anterior ou Jump direto
    // Endereço de Jump: (PC+4)[31:28] concatenado com instr[25:0] << 2
    logic [31:0] pc_jump;
    assign pc_jump = {pc_plus_4[31:28], instr[25:0], 2'b00};

    assign pc_in = jump ? pc_jump : pc_next_branch;

endmodule
