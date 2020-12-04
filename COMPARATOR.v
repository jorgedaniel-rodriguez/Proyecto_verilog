`include "MUX4x1_Case.v"

module COMPARATOR( input [1:0] s, // Creacion del Bloque COMPARATOR y sus salidas
				   output  K,L);

 parameter a = 1'b1;
 parameter b = 1'b0; // Posiciones de seleccion del primer MUX 4x1
 parameter c = 1'b1;
 parameter d = 1'b1;

 parameter e = 1'b1;
 parameter f = 1'b1;
 parameter g = 1'b0;// Posiciones de seleccion del segundo MUX 4x1
 parameter h = 1'b1;

 MUX4x1_Case MUX4x1_K (.I({a, b, c, d}), .S({s[0], s[1]}), .T(K));  //Instanciacion de los dos MUX4x1 para K y L
 MUX4x1_Case MUX4x1_L (.I({e, f, g, h}), .S({s[0], s[1]}), .T(L));
endmodule 