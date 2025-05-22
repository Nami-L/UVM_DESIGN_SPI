module tb();

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import top_test_pkg::*;

localparam time CLK_PERIOD =10ns ;
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
spi_uvc_if spi_vif(clk_i, reset_i);


spi_ip dut(
     .clk_i(spi_vif.clk_i),  //Reloj de entrada
     .reset_i(spi_vif.reset_i),  // reset Asincrono
     .din_i(spi_vif.din_i),  //Datos de Entrada 8 bits
     .dvsr_i('d50),  //Determinara el ciclo de sclk_o. 
     .start_i(spi_vif.start_i),  //bandera de iniciar
     .cpol_i(1'b0),  //Polaridad del reloj
     .cpha_i(1'b0),  //Fase del reloj. (Cphol y Cpha me definen el modo de slck)
     .dout_o(spi_vif.dout_o),  //
     .spi_done_tick_o(spi_vif.spi_done_tick_o),  //Bandera de fing
     .ready_o(spi_vif.ready_o),  //Bandera Para transmitir
     .sclk_o(spi_vif.sclk_o),  //Reloj para la transmision de datos
     .miso_i(spi_vif.miso_i),  //
     .mosi_o(spi_vif.mosi_o)  //Salida de datos.


);


 initial begin
    $timeformat(-9, 0, " ns", 10);
    //Está estableciendo (o insertando) una interfaz virtual (spi_vif) de tipo virtual spi_uvc_if en la base de datos de configuración 
    //(uvm_config_db) para que esté disponible en el componente ubicado en uvm_test_top.m_env.m_spi_agent, donde se buscará bajo el nombre vif."
    uvm_config_db#(virtual spi_uvc_if)::set(null, "uvm_test_top.m_env.m_spi_agent", "vif", spi_vif);
    run_test();
  end

endmodule:tb 