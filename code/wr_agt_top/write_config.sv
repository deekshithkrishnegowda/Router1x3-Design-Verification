class write_config extends uvm_object;

`uvm_object_utils(write_config)

virtual router_if vif;

uvm_active_passive_enum is_active=UVM_ACTIVE;

extern function new (string name="write_config"); 
endclass

	function write_config::new(string name="write_config");
		super.new(name);
	endfunction



