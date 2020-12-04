`timescale 1ns/1ps

//*** Testbench para la maquina compresor.

module Test_AltCompr;

//*** Declaracion de Entradas y Salidas.

reg Clk, Reset;
reg PA,PB,PMB;

wire C1,C2,C3;

// Se define los Data_types (array) para almacenar los vectores de prueba.

reg[2:0] testvectors[27:0];// formato testvector PA:PB:PMB
integer vectornum;

//*** Instanciacion de Modulo Bajo Prueba ***

AltCompr uut (
.Clk(Clk), .Reset(Reset),
.PA(PA), .PB(PB), .PMB(PMB),
.C1(C1), .C2(C2), .C3(C3)
);

//**** Generacion de las señales de Prueba****

    initial
        begin
            $dumpfile("AltCompr.vcd");
	        $dumpvars;
// 1. Generación de las señales de entrada
        testvectors[0] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado a)
        testvectors[1] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado b)
        testvectors[2] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado b)
        testvectors[3] = 3'b001; //PA=0,PB=0,PMB=1 (Se pasa al  estado g)
        testvectors[4] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado g)
        testvectors[5] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al estado a)
        testvectors[6] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado b)
        testvectors[7] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado c)
        testvectors[8] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado c)
        testvectors[9] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado d)
        testvectors[10] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado d)
        testvectors[11] = 3'b001; //PA=0,PB=0,PMB=1 (Se pasa al  estado g)
        testvectors[12] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado a)
        testvectors[13] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado b)
        testvectors[14] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado c)
        testvectors[15] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado d)
        testvectors[16] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado e)
        testvectors[17] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado e)
        testvectors[18] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado f)
        testvectors[19] = 3'b000; //PA=0,PB=0,PMB=0 (Se queda en el estado f)
        testvectors[20] = 3'b001; //PA=0,PB=0,PMB=1 (Se pasa al  estado g)
        testvectors[21] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado a)
        testvectors[22] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado b)
        testvectors[23] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado c)
        testvectors[24] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado d)
        testvectors[25] = 3'b100; //PA=1,PB=0,PMB=0 (Se pasa al  estado e)
        testvectors[26] = 3'b010; //PA=0,PB=1,PMB=0 (Se pasa al  estado f)
        testvectors[27] = 3'b100; //PA=0,PB=0,PMB=0 (Se pasa al  estado a)

// 2. Inicia puntero de vectores de pruebas

        vectornum = 0;

// 3. Aplica Reset a los Flip_Flops (Estado de Partida)
        Reset = 1;

        #1 Reset = 0;
        
        end
// 4. Generacion Ciclica del Clk
        always
            begin
            Clk = 1; #5; Clk = 0; #5;
            end
//***** Aplicacion de los vectores de Prueba  *****

always @ (negedge Clk)
    begin
    #1; {PA,PB,PMB} = testvectors[vectornum];
     $display ("Las entradas son PA=%b PB=%b PMB=%b", PA,PB,PMB);
    end
    // Cambio de estado (Flaco activo creciente) y calculos de salida del Moore

    always @(posedge Clk)
        #1 if(!Reset)
        begin
            $display("Las salidas son : C1 = %b, C2 = %b, C3 = %b",C1,C2,C3);
            vectornum = vectornum + 1;
                if(vectornum == 28)
                    $finish;
        end
endmodule



