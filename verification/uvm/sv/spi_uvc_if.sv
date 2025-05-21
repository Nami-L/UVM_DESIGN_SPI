
interface spi_uvc_if(
    input logic clk_i,
    input logic reset_i
);


    logic [7:0] din_i;  //Datos de Entrada 8 bits
    logic [15:0] dvsr_i;  //Determinara el ciclo de sclk_o. 
    logic start_i;  //bandera de iniciar
    logic cpol_i;  //Polaridad del reloj
    logic cpha_i;  //Fase del reloj. (Cphol y Cpha me definen el modo de slck)
    logic [7:0] dout_o;  //
    logic spi_done_tick_o;  //Bandera de fin
    logic ready_o;  //Bandera Para transmitir
    logic sclk_o;  //Reloj para la transmision de datos
    logic miso_i;  //
    logic mosi_o; //Salida de datos.

clocking cb_drv @(posedge clk_i);
default output #5ns;
    output din_i;  //Datos de Entrada 8 bits
    output dvsr_i;  //Determinara el ciclo de sclk_o. 
    output start_i;  //bandera de iniciar
    output cpol_i;  //Polaridad del reloj
    output cpha_i;  //Fase del reloj. (Cphol y Cpha me definen el modo de slck)
endclocking: cb_drv

clocking cb_mon @(posedge clk_i);
default output #1ns;
    input dout_o;  //
    input spi_done_tick_o;  //Bandera de fin
    input ready_o;  //Bandera Para transmitir
    input sclk_o;  //Reloj para la transmision de datos
    input miso_i;  //
    input mosi_o; //Salida de datos.


endclocking: cb_mon

endinterface: spi_uvc_if