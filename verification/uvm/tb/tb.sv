module tb();

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import top_test_pkg::*;

localparam CLK_PERIOD =10ns ;
logic clk_i=0;
always #(CLK_PERIOD /2) clk_i= ~clk_i;

logic reset_i=1;
initial begin
    repeat(2) @(posedge clk_i)
    reset_i =1 ;
    @(posedge clk_i)
    reset_i=0;
    
end
//INSTANCIAR LA INTERFAZ
spi_uvc_if spi_if(clk_i, rst_i);


spi_ip dut(
     .clk_i(spi_if.clk_i),  //Reloj de entrada
     .reset_i(spi_if.reset_i),  // reset Asincrono
     .din_i(spi_if.din_i),  //Datos de Entrada 8 bits
     .dvsr_i(spi_if.dvsr_i),  //Determinara el ciclo de sclk_o. 
     .start_i(spi_if.start_i),  //bandera de iniciar
     .cpol_i(spi_if.cpol_i),  //Polaridad del reloj
     .cpha_i(spi_if.cpha_i),  //Fase del reloj. (Cphol y Cpha me definen el modo de slck)
     .dout_o(spi_if.dout_o),  //
     .spi_done_tick_o(spi_if.spi_done_tick_o),  //Bandera de fin
     .ready_o(spi_if.ready_o),  //Bandera Para transmitir
     .sclk_o(spi_if.sclk_o),  //Reloj para la transmision de datos
     .miso_i(spi_if.miso_i),  //
     .mosi_o(spi_if.mosi_o)  //Salida de datos.


);


 initial begin
    $timeformat(-9, 0, " ns", 10);
    //uvm_config_db#(virtual spi_uvc_if)::set(null, "uvm_test_top.m_env.m_spi_agent", "vif", spi_vif);
    run_test();
  end

endmodule:tb 