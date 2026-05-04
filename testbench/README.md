# How to use

To use any element, use the Docker tools `UNIC-CASS` (https://unic-cass.github.io/training/2.0-env-setup-prerequisites.html), run versions 2.0 to 2.3.

Once installed, use the tools demonstrated in (https://unic-cass.github.io/training/4.1-create-design-and-simulate.html) to generate `.vcd` files, which in practice are used to test the components in the `componente` folder, using the elements from that folder.

# Note
Do not use `iverilog -o`, use `iverilog -g2012 -o`. The `iverilog -o` command only executes Verilog code, whereas the codes provided are written in SystemVerilog.

---
---
---

# Como usar

Para usar qualquer elemento se usa as ferramentas do Docker `UNIC-CASS` (https://unic-cass.github.io/training/2.0-env-setup-prerequisites.html), execute de 2.0 a 2.3. 

Uma vez instalado, usamos as ferramentas demostradas em (https://unic-cass.github.io/training/4.1-create-design-and-simulate.html), para gerar arquivos `.vcd`, que na pratica servem para testas os componentes na pasta `componente`, usando os elementos dessa pasta.

#Observação

Não use `iverilog -o`, use `iverilog -g2012 -o`. `iverilog -o` executa apenas código Verilog. Os códigos apresentados são em SystemVerilog.
