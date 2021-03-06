class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

`uvm_component_utils(virtual_sequencer)

write_sequencer wr_sqr;
read_sequencer rd_sqr[];

env_config e_cfg;

extern function new(string name="virtual_sequencer",uvm_component parent); 
extern function void build_phase(uvm_phase phase);

endclass

	function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction 

	function void virtual_sequencer::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
		`uvm_fatal("virtual_sequencer","cannot get env_config");
		rd_sqr=new[e_cfg.no_of_DUTS];
	endfunction
	
