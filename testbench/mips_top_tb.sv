`timescale 1ns / 1ps

module mips_top_tb;

    // Sinais de controle
    logic clk;
    logic rst_n;

    // Instanciação do Processador (DUT)
    mips_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Geração do Clock (10ns = 100MHz)
    always #5 clk = ~clk;

    // Bloco único de simulação
    initial begin
        // Configuração única de Waveform (Evita os avisos de VCD)
        $dumpfile("mips_top_tb.vcd");
        $dumpvars(0, mips_top_tb);

        // Inicialização
        $display("----------------------------------------------");
        $display("Iniciando Simulação do Processador MIPS...");
        clk = 0;
        rst_n = 0; // Ativa reset

        // Aguarda o sistema estabilizar e solta o reset
        #22;       // Solta um pouco depois da borda para evitar metaestabilidade
        rst_n = 1;
        $display("Reset liberado. Executando programa...");
        $display("----------------------------------------------");

        // Monitoramento no terminal
        // Adicionei os registradores s0 (16) e s1 (17) para vermos a mágica acontecer
        $monitor("Tempo: %0t | PC: %h | Instr: %h | ALU: %h | $s0: %h | $s1: %h", 
                 $time, dut.pc_out, dut.instr, dut.alu_result, 
                 dut.reg_file.regs[16], dut.reg_file.regs[17]);

        // Tempo suficiente para rodar o seu programa .mem e o loop de Jump
        #250; 

        $display("----------------------------------------------");
        $display("Simulação finalizada com sucesso.");
        $finish;
    end

endmodule
