`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env m_env;

  //COLOCAR LAS FASES Y EL CONSTRUCTOR A UTILIZAR

extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass:top_test

//CREAR LAS CLASES

function top_test::new(string name, uvm_component parent);
super.new(name, parent);
endfunction:new

function void top_test::build_phase(uvm_phase phase);
//EN ESTA PARTE DE INSTANCIA EL ENVIRONMENT CON EL TOP, DE ACUERDO A LA JERARQUIA
m_env= top_env::type_id::create("m_env",this);
endfunction: build_phase

function void top_test::end_of_elaboration_phase(uvm_phase phase);
//SE COLOCAN DOS COMANDOS POR DEFAULT PARA QUE IMPRIMA LA JERARQUIA
uvm_root::get().print_topology();
uvm_factory::get().print();
endfunction: end_of_elaboration_phase

task top_test::run_phase(uvm_phase phase);
//PARA INICIARLIZAR EL RUN, SE COLOCAN OTROS DOS COMANDO POR DEFAULT
phase.raise_objection(this);
`uvm_info(get_name(),"Running test ....", UVM_MEDIUM);
`uvm_info(get_name(),"Bienvenido Luis Namigtle....", UVM_MEDIUM);

phase.drop_objection(this);

endtask: run_phase


`endif // top_test
