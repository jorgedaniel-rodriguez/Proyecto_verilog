module MUX4x1_Case ( input [3:0] I,
					 input [1:0] S,
					 output reg T);

always @ (*) //Escoge que valor mostrar en la entrada dependiendo de 2 bits de el vector S
	case (S)
		2'd0 : T = I[0];
		2'd1 : T = I[1];
		2'd2 : T = I[2];
		2'd3 : T = I[3];
	endcase
endmodule
