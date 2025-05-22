`ifndef SPI_UVC_MONITOR_SV
`define SPI_UVC_MONITOR_SV

class spi_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(spi_uvc_monitor)
  uvm_analysis_port #(spi_uvc_sequence_item) analysis_port;


virtual spi_uvc_if                         vif;
  spi_uvc_config                             m_config;
  spi_uvc_sequence_item                      m_trans;

  //CREAR UNAS VARIABLES AUXILIAIRES
  byte data_miso;
  byte data_mosi;
  
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();


endclass:spi_uvc_monitor

function spi_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void spi_uvc_monitor::build_phase(uvm_phase phase);
  if (!uvm_config_db#(virtual spi_uvc_if)::get(get_parent(), "", "vif", vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve spi_uvc_if from config db")
  end

  if (!uvm_config_db#(spi_uvc_config)::get(get_parent(), "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve spi_uvc_config from config db")
  end

  analysis_port = new("analysis_port", this);
endfunction : build_phase


task spi_uvc_monitor::run_phase(uvm_phase phase);
  m_trans = spi_uvc_sequence_item::type_id::create("m_trans");
  do_mon();
endtask : run_phase

task spi_uvc_monitor::do_mon();
  forever begin

  

      for(int i=7; i>=0; i--) begin
           wait (vif.sclk_o != 1);
     @(vif.cb_mon iff (vif.sclk_o == 1));
        data_mosi[i]= vif.mosi_o;
        data_miso[i]= vif.miso_i;
      end

      m_trans.m_data_miso= data_miso;
      m_trans.m_data_mosi= data_mosi;

    // Wait for the end of the transaction
    wait (vif.spi_done_tick_o != 1);
    @(vif.cb_mon iff (vif.spi_done_tick_o == 1));
    
    `uvm_info(get_type_name(), {"\n ------ MONITOR (GPIO UVC) ------ ", m_trans.convert2string()}, UVM_DEBUG)
    analysis_port.write(m_trans);
  end
endtask : do_mon

`endif // SPI_UVC_MONITOR_SV
