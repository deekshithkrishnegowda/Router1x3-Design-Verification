class write_agent_top extends uvm_env;

`uvm_component_utils(write_agent_top)

write_agent wagt;

extern function new(string name="write_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

	function write_agent_top::new(string name="write_agent_top",uvm_component parent );
		super.new(name,parent);
	endfunction

	function void write_agent_top::build_phase(uvm_phase phase);
		wagt=write_agent::type_id::create("wagt",this);
	endfunction

	task write_agent_top::run_phase(uvm_phase phase);
	//	uvm_top.print_topology;
	endtask	
