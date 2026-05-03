`timescale 1ns / 1ps

module mips_top_tb;

    // -------------------------------------------------------
    // Sinais de controle
    // -------------------------------------------------------
    logic        clk;
    logic        rst_n;

    logic [31:0] pc_out;
    logic [31:0] alu_result;
    logic        mem_write;

    // -------------------------------------------------------
    // Instanciação do Processador (DUT)
    // -------------------------------------------------------
    mips_top dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .pc_out    (pc_out),
        .alu_result(alu_result),
        .mem_write (mem_write)
    );

    // -------------------------------------------------------
    // Geração do Clock: período de 10ns (100 MHz)
    // -------------------------------------------------------
    always #5 clk = ~clk;

    // -------------------------------------------------------
    // Bloco principal de simulação
    // -------------------------------------------------------
    initial begin
        // Waveform dump
        $dumpfile("mips_top_tb.vcd");
        $dumpvars(0, mips_top_tb);

        $display("==============================================");
        $display("  Simulação do Processador MIPS 32-bit");
        $display("==============================================");

        // Inicialização
        clk   = 0;
        rst_n = 0;  // Ativa reset

        // Mantém reset por 2 ciclos completos e solta após borda
        #22;
        rst_n = 1;

        $display("Reset liberado. Executando programa...");
        $display("----------------------------------------------");

        // -------------------------------------------------------
        // Monitor contínuo:
        //   - Usa as PORTAS de saída para pc_out e alu_result
        //   - Acessa internos para instr e registradores
        // -------------------------------------------------------
        $monitor("t=%0t | PC=%h | Instr=%h | ALU=%h | MEM_WE=%b | $s0=%h | $s1=%h | $s2=%h",
                 $time,
                 pc_out,                       // porta de saída
                 dut.instr,                    // sinal interno
                 alu_result,                   // porta de saída
                 mem_write,                    // porta de saída
                 dut.reg_file.registers[16],   // $s0
                 dut.reg_file.registers[17],   // $s1
                 dut.reg_file.registers[18]);  // $s2

        // Tempo para executar o programa .mem (ajuste conforme necessário)
        #250;

        // -------------------------------------------------------
        // Verificação final dos registradores
        // -------------------------------------------------------
        $display("----------------------------------------------");
        $display("=== Resultado Final dos Registradores ===");
        $display("  $s0 (reg[16]) = %0d (esperado: 5)",  dut.reg_file.registers[16]);
        $display("  $s1 (reg[17]) = %0d (esperado: 10)", dut.reg_file.registers[17]);
        $display("  $s2 (reg[18]) = %0d (esperado: 15)", dut.reg_file.registers[18]);
        $display("----------------------------------------------");

        // Verificação automática com pass/fail
        if (dut.reg_file.registers[16] === 32'd5  &&
            dut.reg_file.registers[17] === 32'd10 &&
            dut.reg_file.registers[18] === 32'd15)
            $display("  *** RESULTADO: PASS ✔ ***");
        else
            $display("  *** RESULTADO: FAIL ✘ ***");

        $display("==============================================");
        $display("Simulação finalizada.");
        $finish;
    end

endmodule
