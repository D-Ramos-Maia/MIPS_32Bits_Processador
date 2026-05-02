`timescale 1ns / 1ps

module mips_top_tb;

    // Sinais para conectar ao Top Level
    logic clk;
    logic rst_n;

    // Instanciação do Processador Completo
    mips_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Geração do Clock (100MHz -> período de 10ns)
    always #5 clk = ~clk;

    // Procedimento de Teste
    initial begin

        //Esse script gera um arquivo .vcd, remova o comentario caso queira essa função
        $dumpfile("mips_top_tb.vcd"); // O arquivo nasce aqui
        $dumpvars(0, mips_top_tb);   // Aqui ele começa a gravar

        // --- Configurações Iniciais ---
        $display("Iniciando Simulação do Processador MIPS...");
        clk = 0;
        rst_n = 0; // Ativa o reset (ativo em baixo)

        // Aguarda 2 ciclos e solta o reset
        #20;
        rst_n = 1;
        $display("Reset liberado. Executando programa...");

        // Monitoramento de sinais importantes
        // Você pode adicionar os sinais que quer observar aqui
        $monitor("Tempo: %0t | PC: %h | Instrução: %h | ALU Res: %h", 
                 $time, dut.pc_out, dut.instr, dut.alu_result);

        // Deixa o processador rodar por um tempo
        // Ajuste o tempo conforme o tamanho do seu programa .mem
        #500; 

        $display("----------------------------------------------");
        $display("Simulação finalizada.");
        $finish;
    end

    // Opcional: Gerar arquivo para ver as ondas (Waveform) no GTKWave ou ModelSim
    initial begin
        $dumpfile("mips_simulation.vcd");
        $dumpvars(0, mips_top_tb);
    end

endmodule
