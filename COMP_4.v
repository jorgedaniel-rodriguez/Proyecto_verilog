`include "COMPARATOR.v"
`include "EXTENDER.v"
module COMP_4(input [3:0] X, //Creacion del bloque COMP_4
			  input [3:0] Y,
			  output K_o, L_o
			  );
	wire wk0, wk1, wk2;  //conexiones internas del sistema a simular
	wire wl0, wl1, wl2;

	COMPARATOR Comp_1 (.s({X[0],Y[0]}), .K(wk0), .L(wl0));  // instanciacion de todos los bloques 
	EXTENDER Ext_1 (.Ki(wk0),.Li(wl0),.A(X[1]),.B(Y[1]),.K_n(wk1),.L_n(wl1)); // necesarios para la estructura
	EXTENDER Ext_2 (.Ki(wk1),.Li(wl1),.A(X[2]),.B(Y[2]),.K_n(wk2),.L_n(wl2));
	EXTENDER Ext_3 (.Ki(wk2),.Li(wl2),.A(X[3]),.B(Y[3]),.K_n(K_o),.L_n(L_o));

endmodule