`timescale 1ns / 1ps

module sign_extend_tb;
    logic [15:0] a;
    logic [31:0] y;

    sign_extend dut (.a(a), .y(y));

    initial begin

        //Esse script gera um arquivo .vcd, remova o comentario caso queira essa função
        $dumpfile("sign_extend_tb.vcd"); // O arquivo nasce aqui
        $dumpvars(0, sign_extend_tb);   // Aqui ele começa a gravar
        
        // Teste valor positivo (5)
        a = 16'h0005;
        #10 $display("In: %h | Out: %h", a, y); // Deve sair 00000005

        // Teste valor negativo (-1 em complemento de 2)
        a = 16'hFFFF;
        #10 $display("In: %h | Out: %h", a, y); // Deve sair FFFFFFFF
        
        $finish;
    end
endmodule
