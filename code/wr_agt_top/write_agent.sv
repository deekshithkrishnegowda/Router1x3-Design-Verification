class write_agent extends uvm_agent;

`uvm_component_utils(write_agent)

write_config w_cfg;

write_driver drv;
write_monitor wmon;
write_sequencer wseq;

extern function new(string name="write_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

	function write_agent::new(string name="write_agent",uvm_component parent);
	 	super.new(name,parent);
	endfunction

	function void write_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
			if(!uvm_config_db #(write_config)::get(this,"","write_config",w_cfg))
			`uvm_error("write_agent","unable to get write config");
			
			wmon=write_monitor::type_id::create("wmon",this);
			w_cfg=write_config::type_id::create("w_cfg");

		if(w_cfg.is_active==UVM_ACTIVE)
		begin	
			drv=write_driver::type_id::create("drv",this);
			wseq=write_sequencer::type_id::create("wseq",this);
		end
	endfunction

	function void write_agent::connect_phase(uvm_phase phase);
		if(w_cfg.is_active==UVM_ACTIVE)
		drv.seq_item_port.connect(wseq.seq_item_export);
	endfunction
		



