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


En dicha grafica se observa que los datos obtenidos cumplen con valores especificos de cada evento dado que cuando inicia con dos vectores vacios el resultado es K=L=1, en los dos siguientes eventos ambos vectores son iguales y se vuelve a cumplir la condicion, luego la palabra B es mayor que A y el resultado es K=0, L=1, para el evento 7 se cumple lo contrario y el sistema no reporta diferencias de ningun tipo con la condicion inicial de comparacion por tanto la red iterativa funciona perfectamente. 

![bloques](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/diagramabloques.jpg)

## Problema 2

# Diagrama ASM

![asm](https://github.com/jorgedaniel-rodriguez/Proyecto_verilog/blob/main/asm.jpg)


Para la realizacion de esta parte es necesario utilizar siete estados para poder lograr el objetivo de crear un sistema de presion con alternador de bombas, se colocara una tabla adjunta para exponer los estados y su descripcion.

|      Estado     |    ABC   |                      Descripcion                   |
|-----------------|----------|----------------------------------------------------|
|      **a**      |   *100*  |    Presión Alta C1,C2,C3 Apagados sigue C1,C2      |
|      **b**      |   *001*  |   	Presión Baja C1,C2 encendidos		  |
|      **c**      |   *101*  |		  Presión Alta sigue C1,C3                |
|      **d**      |   *110*  | 		Presión Baja C1,C3 encendidos 		  |
|      **e**      |   *010*  |            Presión Alta sigue C2,C3                |	
|      **f**      |   *011*  |		Presión baja C2,C3 Encendidos	          |
|      **g**      |   *111*  |   	Presión Muy Alta C1,C2,C3 Encendidos	  | 



<div class=text-justify>
El diagrama ASM iniciando en el estado pasaria al estado b siempre y cuando exista presion baja, en ese momento se encienden dos compresores C1 y C2 si durante la carga de presion, ambos tanques no son suficientes para restablecer la presion se activa la alerta de presion muy baja provocando que se active el compresor C3 posicionandose en el estado g hasta que se logre alcanzar la presion alta posterior a eso se reinicia los contadores de los compresores, hace el recorrido anterior con la diferencia de que no se activa el sensor de PMB y se estabiliza en el estado c hasta que la presion baje a PB luego procede a llenar el tanque con los compresores alternados C1 C3 si se estabiliza procede al estado d, en caso contrario el sensor PMB se activo y nuevamente se activa el compresor faltante C2 con las mismas condiciones caracteristicas del estado g, nuevamente se realiza el recorrido anterior y hasta llegar a estabilizarse en el e, en caso de existir presion baja se traslada al estado f activando los compresores C2 y C3 con las condiciones de que si el sensor PMB se activa el proximo estado sera G, en caso contrario y se alcance PA, se reinicia al estado a.
</div>

```systemverilog
// Maquina alternadora de compresores

module AltCompr( input Clk, Reset,
				 input PA,PB,PMB,
				 output C1,C2,C3);
reg[2:0] EstPres, ProxEstado;

//Asignación de Estado

parameter a = 3'b100;   //Presión Alta C1,C2,C3 Apagados sigue C1,C2
parameter b = 3'b001;   //Presión Baja C1,C2 encendidos
parameter c = 3'b101;   //Presión Alta sigue C1,C3
parameter d = 3'b110;   //Presión Baja C1,C3 encendidos
parameter e = 3'b010;   //Presión Alta sigue C2,C3
parameter f = 3'b011;   //Presión baja C2,c3 Encendidos
parameter g = 3'b111;   //Presión Muy Alta C1,C2,C3 Encendidos

//Memoria de Estados
always @(posedge Clk, posedge Reset)
    if (Reset) EstPres <= a;
        else EstPres <= ProxEstado;

always @ (*)
    case (EstPres)
    a	:	if(PB)	ProxEstado = b; //si el estado presente es a y PB esta on proximo estado sera b caso contrario a
                else ProxEstado = a;

    b   :   if(PA)   ProxEstado = c;
                else if(PMB) ProxEstado = g; //si el estado presente es b, PA esta on proximo estado es c y ademas si PMB esta on el 
                                            //proximo estado sera g caso contrario b

                        else ProxEstado = b;
    c   :   if(PB)   ProxEstado  = d;       //si el estado presente es c y PB on entonces el proximo estado  es d
                else ProxEstado = c;
    d   :     if(PA)   ProxEstado = e;
                else if(PMB) ProxEstado = g;
                        else ProxEstado = d;
    e   :   if(PB)   ProxEstado  = f;
                else ProxEstado = e;
    f   :   if(PA)   ProxEstado = a;
                else if(PMB) ProxEstado = g;
                        else ProxEstado = f;
    g   :   if(PA)  ProxEstado  = a;
                else    ProxEstado = g;
    endcase

//Lógica de calculo de Salida

assign C1 = (EstPres == b | EstPres == d | EstPres == g | !PA & PMB & EstPres == f); 

assign C2 = (EstPres == b | EstPres == f | EstPres == g |  !PA & PMB & EstPres == d);

assign C3 = (EstPres == d | EstPres == f | EstPres == g |  !PA & PMB & EstPres == b);

endmodule
```

El codigo anterior corresponde a una maquina de estado sincronica de alternador de compresores, la logica de salidas corresponde a los puntos donde las salidas fueron activadas segun el estado presente en que se encuentran excepto las condicionales que existen antes de llegar al estado g dado que toda salida condicional presenta un retraso en su inicio, por lo demas ya fue explicado en detalle con anterioridad.





