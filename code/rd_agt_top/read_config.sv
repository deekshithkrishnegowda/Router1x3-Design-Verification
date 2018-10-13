class read_config extends uvm_object;

`uvm_object_utils(read_config)

virtual router_if vif;
int no_of_DUTS=3;

uvm_active_passive_enum is_active=UVM_ACTIVE;

extern function new (string name="read_config"); 
endclass

	function read_config::new(string name="read_config");
		super.new(name);
	endfunction



