`timescale 1ns / 1ps

module alu_tb;
    logic [31:0] a, b, result;
    logic [2:0]  alu_control;
    logic        zero;

    alu dut (
        .a(a), .b(b), 
        .alu_control(alu_control), 
        .result(result), .zero(zero)
    );

    initial begin
        $display("Iniciando teste da ULA...");

        // Teste SOMA: 10 + 5 = 15
        a = 32'd10; b = 32'd5; alu_control = 3'b010;
        #10 $display("Soma: %d + %d = %d (Zero: %b)", a, b, result, zero);

        // Teste SUBTRAÇÃO (Igualdade): 10 - 10 = 0
        a = 32'd10; b = 32'd10; alu_control = 3'b110;
        #10 $display("Sub:  %d - %d = %d (Zero: %b)", a, b, result, zero);

        // Teste SLT: 10 < 20 ? Sim (1)
        a = 32'd10; b = 32'd20; alu_control = 3'b111;
        #10 $display("SLT:  %d < %d = %d", a, b, result);

        // Teste AND: 1010 & 1100 = 1000 (8)
        a = 32'b1010; b = 32'b1100; alu_control = 3'b000;
        #10 $display("AND:  %b & %b = %b", a[3:0], b[3:0], result[3:0]);

        #10 $finish;
    end
endmodule
