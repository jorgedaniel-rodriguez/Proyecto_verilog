---

## Universidad de Costa Rica
### Escuela de Ingeniería Eléctrica
#### IE0323 - Circuitos Digitales 

Segundo semestre del 2020

---

* Estudiante: **Jorge Daniel Rodríguez Hernández**
* Carné: **A95284**
* Grupo: **2**

# P - *Proyecto Verilog*

## Problema 1

---

<div class=text-justify>
Considere dos circuitos combinacionales denominados COMPARATOR y EXTENDER, 
cuyas  variables  de  entradas  y  salidas  se  muestras  en  los  respectivos  diagramas  de bloque. El  circuito  COMPARATOR  compara  las  magnitudes 
de  dos  bits  A  y  B  y    activa  sus salidas  salidas  K  y  L  de  la  siguiente  manera:  K=1  si    A  >  B,  L=1  si  A  <  B  y  K=L=1     
si A = B. El circuito EXTENDER recibe los bits K y L de un  circuito COMPARATOR y dos bits de entrada adicionales A y B y 
produce las salidas Ko y Lo, con los mismos criterios que el circuito COMPARATOR. Esto con el fin de comparar palabras de más bits.
</div>

Para crear el bloque COMPARATOR se utilizo dos MUX 4x1 donde las dos lineas de seleccion son los primeros bits que se desean comparar, siendo estos A = X[0] y B = Y[0]
```systemverilog
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
```
<div class=text-justify>
La utilizacion de parameter en el codigo anterior responde a que las cuatro entradas para cada 
MUX4x1 estan definidas a partir de la condincion que existe de K y L con A y B y codigo utilizado 
para la realizacion de los MUX4x1 se basa en el uso de case para escoger cual es la linea de seleccion que depende de los valores de A y B; las funciones logicas de K y L para
los MUX4x1 son las siguiuentes:

![KL](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/KL.jpg)

</div>

```systemverilog
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
```

<div class=text-justify>
Para lograr obtener el resultado deseado con el bloque EXTENDER y dado que se solicito como parte del proyecto que se debe realizar un analisis funcinal, se decidio,
implementar redes iterativas para crear una red capaz de comparar y extender bit por bit hasta completar la palabra desea, cabe destacar, que como beneficio de esta implementacion
si se desea extender con mas bits la palabra basta con instanciar mas bloques de EXTENDER y alargar el vector de entradas y salidas.

</div>

![estados](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/estados.jpg)

![estados](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/MK.jpg)

Siendo estas ultimas las funciones logicas asignadas para el bloque EXTENDER con las entradas K,L,A,B y las salidas K_n y L_n

```systemverilog
module EXTENDER (   input Ki,Li, // Creacion del Bloque EXTENDER y sus entradas y salidas
				   input A,B,
				   output K_n,L_n );

 assign K_n = ((A & !B ) | (!B & Ki) | (Ki & (A)) ); //funcion logica para la salida final K de cada bloque EXTENDER

 assign L_n = ((!A & B ) | (Li & !A) | (B & (Li)) ); //funcion logica para la salida final L de cada bloque EXTENDER

endmodule
```

<div class=text-justify>
La union de todos los bloques en forma de red iterativa se representa en el Bloque COMP_4
, ya que este busca entregar dos salidas escalares que responden a la comparacion de dos palabras de cuatro bits. el bloque utliza los wire para interconectar de 
manera interna las salidas de el bloque COMPARATOR y algunas salidas de EXTENDER con las entradas de otros EXTENDER con la intension de resolver la solicitud de manera
interna. la base de esta red iterativa es estructural ya que instancia otros bloques para conseguir la solucion ultima.
</div>

```systemverilog
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
```
Se requiere de un ultimo modulo para lograr realizar pruebas en el sistema, esta prueba constará de 10 procesos escogidos con la intension demostrar su funcionalidad.

```systemverilog
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

	     X0 = 0;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 0;Y1 = 0;Y2 = 0;Y3 = 0; 	// Xn[0,0,0,0] Yn[0,0,0,0] K = 1 L = 1
	 #15 X0 = 1;X1 = 0;X2 = 0;X3 = 0; 	Y0 = 1;Y1 = 0;Y2 = 0;Y3 = 0; 	// Xn[1,0,0,0] Yn[1,0,0,0] K = 1 L = 1 
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
```

El codigo de pruebas se basa en la asignacion de valores cada sierto tiempo de pulsacion simulado para #15 espacios entre cada estimulo,
como se puede comprobar en las salidas del sistema en la proxima imagen.

![salidas](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/salidaaas.png)
![señal](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/señales.png)


En dicha grafica se observa que los datos obtenidos cumplen con las solicitudes de la administracion, dado que lo que se solicitó fue que 
el servidor no estuviera por mas del 10% sin usuarios, con la posible intencion de aprovechar al maximo los recuersos del servidor sin llegar a un 
sobrecargo de trabajo.

![90](https://github.com/jorgedaniel-rodriguez/Tema5/blob/main/ecuacion.png)

Para cumplir con dicha solicitud y dado que el ingreso de clientes al servidor es de aproximadamente 2 usuarios, se utilizo la ecuacion anterior para encontrar el 
parametro del servicio, siendo este de 2.222222 aproximadamente al esperarse que la probabilidad de que 1 o más usuarios en el servicio no disminuya del 90%; como se
puede observar los parametros escogidos cumplen con lo esperado y se concluye que es la cantidad de usuarios que satisfacen el sistema.

