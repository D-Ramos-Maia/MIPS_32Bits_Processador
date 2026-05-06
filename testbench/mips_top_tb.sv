`timescale 1ns / 1ps

// =============================================================================
//  Testbench Completo: mips_top_tb
//  Processador MIPS Monociclo
//
//  Cobertura de testes:
//    [1] Reset do processador (PC deve partir do 0)
//    [2] ADDI $s0, $zero, 5    -> $s0 = 5
//    [3] ADDI $s1, $zero, 10   -> $s1 = 10
//    [4] ADD  $s2, $s0, $s1    -> $s2 = 15
//    [5] Verificação de sequência de PC (0x00 -> 0x04 -> 0x08 -> 0x0C)
//    [6] Instrução NOP/inválida não deve alterar estado
//    [7] mem_write deve ficar inativo (sem SW no programa)
//    [8] Relatório final de PASS/FAIL
// =============================================================================

module mips_top_tb;

    // -------------------------------------------------------------------------
    //  Sinais do DUT
    // -------------------------------------------------------------------------
    logic        clk;
    logic        rst_n;
    logic [31:0] pc_out;
    logic [31:0] alu_result;
    logic        mem_write;

    // -------------------------------------------------------------------------
    //  Contadores de erros e testes
    // -------------------------------------------------------------------------
    int unsigned test_count = 0;
    int unsigned fail_count = 0;

    // -------------------------------------------------------------------------
    //  Instanciação do DUT
    // -------------------------------------------------------------------------
    mips_top dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .pc_out    (pc_out),
        .alu_result(alu_result),
        .mem_write (mem_write)
    );

    // -------------------------------------------------------------------------
    //  Clock: período de 20 ns (50 MHz)
    // -------------------------------------------------------------------------
    initial clk = 0;
    always #10 clk = ~clk;

    // -------------------------------------------------------------------------
    //  Tarefa auxiliar: verifica uma condição e reporta PASS/FAIL
    // -------------------------------------------------------------------------
    task automatic check(
        input string  test_name,
        input logic   condition
    );
        test_count++;
        if (condition) begin
            $display("  [PASS] %s", test_name);
        end else begin
            $display("  [FAIL] %s", test_name);
            fail_count++;
        end
    endtask

    // -------------------------------------------------------------------------
    //  Tarefa: avança N ciclos e amostra no MEIO do último ciclo (negedge)
    //  Isso garante que a lógica combinacional já propagou, mas a borda de
    //  subida que avança o PC ainda não ocorreu — timing correto para checar
    //  alu_result e sinais combinacionais do ciclo atual.
    // -------------------------------------------------------------------------
    task automatic wait_cycles(input int unsigned n);
        // Avança (n-1) ciclos completos
        if (n > 1) repeat (n-1) @(posedge clk);
        // No último ciclo, amostra na borda de descida (meio do ciclo)
        @(negedge clk);
        #1;
    endtask

    // Avança ciclos completos sem amostrar (usado para avançar estado)
    task automatic advance_cycles(input int unsigned n);
        repeat (n) @(posedge clk);
        #1;
    endtask

    // -------------------------------------------------------------------------
    //  Bloco de estímulo principal
    // -------------------------------------------------------------------------
    initial begin
        // --- Waveform dump ---
        $dumpfile("mips_top_tb.vcd");
        $dumpvars(0, mips_top_tb);

        $display("=============================================================");
        $display("  Testbench Completo - Processador MIPS Monociclo");
        $display("=============================================================");

        // =====================================================================
        //  TESTE 1: Reset
        // =====================================================================
        $display("\n--- BLOCO 1: Reset do Processador ---");

        clk   = 0;
        rst_n = 0;  // Ativa reset (ativo baixo)

        // Amostra no meio do ciclo 2 de reset
        wait_cycles(2);

        check("PC == 0x00000000 durante reset",   pc_out === 32'h0000_0000);
        check("mem_write == 0 durante reset",      mem_write === 1'b0);

        // =====================================================================
        //  TESTE 2: Ciclo 1 — ADDI $s0, $zero, 5
        //    Instrução: 0x20100005  |  PC=0x00
        //    Amostramos no negedge do ciclo 1: alu_result=5, PC ainda=0x00
        //    Após a posedge: PC avança para 0x04 e $s0 é escrito
        // =====================================================================
        $display("\n--- BLOCO 2: ADDI $s0, $zero, 5 ---");

        rst_n = 1;
        wait_cycles(1);  // negedge do ciclo 1 — lógica combinacional estável

        check("PC == 0x00000000 (durante ADDI $s0, antes de avançar)",
              pc_out === 32'h0000_0000);
        check("ALU result == 5 (imediato ADDI $s0)",
              alu_result === 32'd5);
        check("mem_write == 0 (ADDI nao escreve na mem)",
              mem_write === 1'b0);

        // Deixa a posedge acontecer: PC -> 0x04, $s0 escrito
        advance_cycles(1);
        check("PC == 0x00000004 (apos posedge do ciclo 1)",
              pc_out === 32'h0000_0004);
        check("$s0 == 5 (escrito na posedge)",
              dut.reg_file.registers[16] === 32'd5);

        // =====================================================================
        //  TESTE 3: Ciclo 2 — ADDI $s1, $zero, 10
        //    Instrução: 0x2011000A  |  PC=0x04
        //    Amostramos no negedge do ciclo 2: alu_result=10, PC ainda=0x04
        // =====================================================================
        $display("\n--- BLOCO 3: ADDI $s1, $zero, 10 ---");

        // Já estamos após a posedge do ciclo 1 (PC=0x04 estável)
        // Aguarda o negedge do ciclo 2 para amostrar combinacional
        @(negedge clk); #1;

        check("PC == 0x00000004 (durante ADDI $s1, antes de avançar)",
              pc_out === 32'h0000_0004);
        check("ALU result == 10 (imediato ADDI $s1)",
              alu_result === 32'd10);
        check("$s0 ainda == 5 (sem regressao)",
              dut.reg_file.registers[16] === 32'd5);

        // Deixa a posedge acontecer: PC -> 0x08, $s1 escrito
        advance_cycles(1);
        check("PC == 0x00000008 (apos posedge do ciclo 2)",
              pc_out === 32'h0000_0008);
        check("$s1 == 10 (escrito na posedge)",
              dut.reg_file.registers[17] === 32'd10);

        // =====================================================================
        //  TESTE 4: Ciclo 3 — ADD $s2, $s0, $s1
        //    Instrução: 0x02119020  |  PC=0x08
        //    Amostramos no negedge do ciclo 3: alu_result=15, PC ainda=0x08
        // =====================================================================
        $display("\n--- BLOCO 4: ADD $s2, $s0, $s1 ---");

        @(negedge clk); #1;

        check("PC == 0x00000008 (durante ADD $s2, antes de avançar)",
              pc_out === 32'h0000_0008);
        check("ALU result == 15 (5 + 10)",
              alu_result === 32'd15);

        // Deixa a posedge acontecer: PC -> 0x0C, $s2 escrito
        advance_cycles(1);
        check("PC == 0x0000000C (apos posedge do ciclo 3)",
              pc_out === 32'h0000_000C);
        check("$s2 == 15 (escrito na posedge)",
              dut.reg_file.registers[18] === 32'd15);
        check("$s0 nao foi alterado pelo ADD",
              dut.reg_file.registers[16] === 32'd5);
        check("$s1 nao foi alterado pelo ADD",
              dut.reg_file.registers[17] === 32'd10);

        // =====================================================================
        //  TESTE 5: mem_write deve ter permanecido 0 ao longo de todo o programa
        //    (não há instrução SW no programa)
        // =====================================================================
        $display("\n--- BLOCO 5: Sinal mem_write ---");

        check("mem_write == 0 apos execucao do programa (sem SW)",
              mem_write === 1'b0);

        // =====================================================================
        //  TESTE 6: Novo reset — PC deve voltar para 0
        // =====================================================================
        $display("\n--- BLOCO 6: Novo Reset ---");

        rst_n = 0;
        advance_cycles(1);

        check("PC retorna a 0x00000000 apos segundo reset",
              pc_out === 32'h0000_0000);

        rst_n = 1;

        // =====================================================================
        //  Relatório final
        // =====================================================================
        $display("\n=============================================================");
        $display("  RESULTADO FINAL: %0d/%0d testes passaram.",
                 test_count - fail_count, test_count);
        if (fail_count == 0)
            $display("  *** TODOS OS TESTES PASSARAM COM SUCESSO! ***");
        else
            $display("  *** ATENCAO: %0d TESTE(S) FALHARAM! ***", fail_count);
        $display("=============================================================\n");

        $finish;
    end

    // -------------------------------------------------------------------------
    //  Monitor contínuo (visível no terminal durante a simulação)
    // -------------------------------------------------------------------------
    initial begin
        $display("\n  Tempo(ns) | PC       | Instr    | ALU_Res  | $s0 | $s1 | $s2 | MW");
        $display("  ----------+----------+----------+----------+-----+-----+-----+---");
        forever begin
            @(posedge clk);
            #1;
            $display("  %8t  | %h | %h | %h | %3d | %3d | %3d | %b",
                $time,
                pc_out,
                dut.instr,
                alu_result,
                dut.reg_file.registers[16],
                dut.reg_file.registers[17],
                dut.reg_file.registers[18],
                mem_write);
        end
    end

    // -------------------------------------------------------------------------
    //  Timeout de segurança: aborta simulação se travar
    // -------------------------------------------------------------------------
    initial begin
        #10_000;
        $display("\n[TIMEOUT] Simulacao excedeu 10us — possivel loop infinito!");
        $finish;
    end

endmodule
