`timescale 1ns / 1ps

module pc_tb;

    // Sinais para conectar ao módulo PC
    logic        clk;
    logic        rst_n;
    logic [31:0] pc_in;
    logic [31:0] pc_out;

    // Instanciação do módulo (Device Under Test - DUT)
    pc dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .pc_in  (pc_in),
        .pc_out (pc_out)
    );

    // Geração do Clock (período de 10ns = 100MHz)
    always #5 clk = ~clk;

    // Bloco de estímulos
    initial begin
        // --- Inicialização ---
        clk = 0;
        rst_n = 0;        // Começa em reset
        pc_in = 32'h0;

        // Espera 15ns para garantir que o reset seja capturado
        #15 rst_n = 1;     
        
        // --- Teste 1: Incremento Simples ---
        #10 pc_in = 32'h0000_0004;
        
        // --- Teste 2: Salto (Jump) ---
        #10 pc_in = 32'h0000_00A0;
        
        // --- Teste 3: Outro incremento ---
        #10 pc_in = 32'h0000_00A4;

        // --- Teste 4: Reset durante a operação ---
        #10 rst_n = 0;    // Ativa o reset novamente
        #10 rst_n = 1;    // Desativa o reset
        pc_in = 32'h0000_1000;

        // Finaliza a simulação após alguns ciclos
        #50;
        $display("Simulação concluída!");
        $finish;
    end

    // Monitor de sinais no terminal
    initial begin
        $monitor("Tempo: %0t | Reset: %b | PC_In: %h | PC_Out: %h", 
                 $time, rst_n, pc_in, pc_out);
    end

endmodule
