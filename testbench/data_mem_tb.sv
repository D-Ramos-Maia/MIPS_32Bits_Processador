`timescale 1ns / 1ps

module data_mem_tb;
    logic        clk;
    logic        we;
    logic [31:0] addr, wd, rd;

    // Instanciação
    data_mem dut (
        .clk(clk), .we(we), .addr(addr), .wd(wd), .rd(rd)
    );

    // Geração de clock
    always #5 clk = ~clk;

    initial begin
        clk = 0; we = 0; addr = 0; wd = 0;
        $display("Iniciando teste da Memória de Dados...");

        // --- Teste 1: Escrita ---
        // Vamos salvar o valor 0xDEADBEEF no endereço 4
        #10;
        we = 1;
        addr = 32'd4;
        wd = 32'hDEADBEEF;
        
        #10; // Borda de subida do clock acontece aqui
        we = 0; // Desativa escrita

        // --- Teste 2: Leitura ---
        // Vamos ler o que está no endereço 4
        addr = 32'd4;
        #5; 
        $display("Endereço %d contém: %h", addr, rd);

        if (rd === 32'hDEADBEEF)
            $display("Sucesso: Escrita e Leitura funcionando!");
        else
            $display("Erro: Valor lido incorreto.");

        #20;
        $finish;
    end
endmodule
