module EXTENDER (   input Ki,Li, // Creacion del Bloque EXTENDER y sus entradas y salidas
				   input A,B,
				   output K_n,L_n );

 assign K_n = ((A & !B ) | (!B & Ki) | (Ki & (A)) ); //funcion logica para la salida final K de cada bloque EXTENDER

 assign L_n = ((!A & B ) | (Li & !A) | (B & (Li)) ); //funcion logica para la salida final L de cada bloque EXTENDER

endmodule
