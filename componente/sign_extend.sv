module sign_extend (
    input  logic [15:0] a, // Entrada de 16 bits (imediato da instrução)
    output logic [31:0] y  // Saída de 32 bits sinalizada
);

    // O operador de concatenação {32{bit}} repete o bit de sinal 16 vezes
    assign y = {{16{a[15]}}, a};

endmodule
