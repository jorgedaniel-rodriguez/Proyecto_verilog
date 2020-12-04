`timescale 1ns/1ps // Definicion de los periodos de tiempo

module Test_COMP_4;

//******Definicion de data_types*****
//Entradas

reg X0,X1,X2,X3;
reg Y0,Y1,Y2,Y3;

//salidas
wire K_fin;
wire L_fin;

//*** Test_Module: Instanciacion del modulo bajo prueba ****

COMP_4 uut (
	.X({X0,X1,X2,X3}),  
	.Y({Y0,Y1,Y2,Y3}),
	.K_o(K_fin),
	.L_o(L_fin)
	);


//****Stimulus: Definicion de las señales que se aplicaran ****

initial
	begin
	$dumpfile("COMP_4.vcd");  // Volcado de los resultados de la simulación en el archivo COMP_4.vcd
	$dumpvars;
				// Colocacion de las posiciones segun vector X => A  Y => B 
				// Si A < B => K=0 L=1 , si A > B => K=1 L=0 , si A=B => K=L=1
				// casos de ejemplo para comprobar el funcionamiento optimo del sistema.

	     X0 = 0;X1 = 0;X2 = 0;X3 = 0;	Y0 = 0;Y1 = 0;Y2 = 0;Y3 = 0; 	// Xn[0,0,0,0] Yn[0,0,0,0] K = 1 L = 1
	 #15 X0 = 1;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 0;Y2 = 0;Y3 = 0; 	// Xn[1,0,0,1] Yn[1,0,0,0] K = 1 L = 1 
	 #15 X0 = 1;X1 = 0;X2 = 1;X3 = 0; 	Y0 = 1;Y1 = 0;Y2 = 1;Y3 = 0; 	// Xn[1,0,1,0] Yn[1,0,1,0] K = 1 L = 1 
	 #15 X0 = 1;X1 = 1;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 1;Y2 = 1;Y3 = 0; 	// Xn[1,1,0,0] Yn[1,1,1,0] K = 0 L = 1
	 #15 X0 = 0;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 0;Y2 = 0;Y3 = 0; 	// Xn[0,0,0,0] Yn[1,0,0,0] k = 0 L = 1
	 #15 X0 = 1;X1 = 1;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 1;Y2 = 0;Y3 = 0; 	// Xn[1,1,0,0] Yn[1,1,0,0] K = 1 L = 1
	 #15 X0 = 1;X1 = 1;X2 = 0;X3 = 0; 	Y0 = 0;Y1 = 0;Y2 = 1;Y3 = 1; 	// Xn[1,1,0,0] Yn[0,0,1,1] K = 1 L = 0 
	 #15 X0 = 0;X1 = 0;X2 = 1;X3 = 1; 	Y0 = 1;Y1 = 1;Y2 = 0;Y3 = 0; 	// Xn[0,0,1,1] Yn[1,1,0,0] K = 0 L = 1
	 #15 X0 = 1;X1 = 1;X2 = 1;X3 = 1; 	Y0 = 1;Y1 = 1;Y2 = 1;Y3 = 1; 	// Xn[1,1,1,1] Yn[1,1,1,1] K = 1 L = 1
	 #15 X0 = 0;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 1;Y2 = 1;Y3 = 1; 	// Xn[0,0,0,0] Yn[1,1,1,1] K = 0 L = 1
	 #15 X0 = 1;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 0;Y1 = 1;Y2 = 1;Y3 = 1; 	// Xn[1,0,0,0] Yn[0,1,1,1] K = 1 L = 0
	 
	 
	 	end

initial
	begin
		$monitor("X: [%b, %b, %b, %b] Y: [%b, %b, %b, %b] K = %b  L = %b", //Monitoreo de salidas y entradas
		X0,X1,X2,X3,Y0,Y1,Y2,Y3, K_fin, L_fin);
	end

endmodule