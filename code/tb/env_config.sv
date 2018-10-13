class env_config extends uvm_object;

`uvm_object_utils(env_config)

bit has_functional_coverage=0;

bit has_write_agent_top=1;

bit has_read_agent_top=1;

bit has_virtual_sequencer=1;

write_config w_cfg;
read_config r_cfg[];

int no_of_DUTS=3;

extern function new(string name="env_config");

endclass

 	function env_config::new(string name="env_config");
		super.new(name);
	//	r_cfg=new[no_of_DUTS];
	endfunction	
