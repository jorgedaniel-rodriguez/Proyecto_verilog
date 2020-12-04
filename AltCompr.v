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
    a	:	if(PB)	ProxEstado = b;
                else ProxEstado = a;

    b   :   if(PA)   ProxEstado = c;
                else if(PMB) ProxEstado = g;
                        else ProxEstado = b;
    c   :   if(PB)   ProxEstado  = d;
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