`timescale 1ns / 1ps

module register_file_tb;

    // Sinais de interface
    logic        clk;
    logic        we;
    logic [4:0]  ra1, ra2, wa;
    logic [31:0] wd;
    logic [31:0] rd1, rd2;

    // Instanciação do Banco de Registradores (DUT)
    register_file dut (
        .clk(clk),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Geração do Clock (período de 10ns)
    always #5 clk = ~clk;

    initial begin
        // --- Inicialização ---
        clk = 0;
        we = 0;
        ra1 = 0; ra2 = 0; wa = 0;
        wd = 0;

        $display("Iniciando Teste do Register File...");
        #10;

        // --- Teste 1: Escrita no Registrador $s0 (endereço 16) ---
        we = 1;
        wa = 5'd16;
        wd = 32'hABCD_1234;
        #10; // Espera a borda de subida do clock
        
        // --- Teste 2: Escrita no Registrador $t0 (endereço 8) ---
        wa = 5'd8;
        wd = 32'h1111_2222;
        #10;
        
        // --- Teste 3: Tentar escrever no Registrador $zero (endereço 0) ---
        // O MIPS deve ignorar isso!
        wa = 5'd0;
        wd = 32'hFFFF_FFFF;
        we = 1;
        #10;

        // --- Teste 4: Leitura Simultânea ---
        we = 0;          // Desativa escrita
        ra1 = 5'd16;     // Deve ler ABCD_1234
        ra2 = 5'd8;      // Deve ler 1111_2222
        #5;              // Leitura é combinacional, não precisa esperar borda completa
        $display("Leitura 1 (reg 16): %h", rd1);
        $display("Leitura 2 (reg 8):  %h", rd2);

        // --- Teste 5: Verificar se o Reg 0 continua sendo ZERO ---
        ra1 = 5'd0;
        #5;
        if (rd1 == 32'd0) 
            $display("Sucesso: Registrador 0 continua sendo zero.");
        else 
            $display("ERRO: Registrador 0 foi modificado!");

        #20;
        $display("Fim da simulação.");
        $finish;
    end

endmodule
