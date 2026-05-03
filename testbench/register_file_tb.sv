`timescale 1ns/1ps

module register_file_tb;

    // Sinais
    logic clk;
    logic we;
    logic [4:0] ra1, ra2, wa;
    logic [31:0] wd;
    logic [31:0] rd1, rd2;

    // Instância do DUT (Device Under Test)
    register_file uut (
        .clk(clk),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Geração de clock (período = 10ns)
    always #5 clk = ~clk;

    // Testes
    initial begin
        // Inicialização
        clk = 0;
        we  = 0;
        ra1 = 0;
        ra2 = 0;
        wa  = 0;
        wd  = 0;

        // Espera inicial
        #10;

        // =========================
        // Teste 1: Escrita no registrador 5
        // =========================
        we = 1;
        wa = 5;
        wd = 32'hA5A5A5A5;
        #10;

        // Leitura
        we = 0;
        ra1 = 5;
        #10;
        $display("Reg[5] = %h (esperado A5A5A5A5)", rd1);

        // =========================
        // Teste 2: Escrita em outro registrador
        // =========================
        we = 1;
        wa = 10;
        wd = 32'h12345678;
        #10;

        we = 0;
        ra2 = 10;
        #10;
        $display("Reg[10] = %h (esperado 12345678)", rd2);

        // =========================
        // Teste 3: Registrador zero (não deve mudar)
        // =========================
        we = 1;
        wa = 0;
        wd = 32'hFFFFFFFF;
        #10;

        we = 0;
        ra1 = 0;
        #10;
        $display("Reg[0] = %h (esperado 00000000)", rd1);

        // =========================
        // Teste 4: Leitura simultânea
        // =========================
        ra1 = 5;
        ra2 = 10;
        #10;
        $display("Reg[5] = %h | Reg[10] = %h", rd1, rd2);

        // Fim da simulação
        #20;
        $finish;
    end

endmodule
