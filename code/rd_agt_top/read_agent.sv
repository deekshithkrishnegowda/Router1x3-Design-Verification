class read_agent extends uvm_agent;

`uvm_component_utils(read_agent)

read_config r_cfg;

read_driver drv;
read_monitor rmon;
read_sequencer rseq;

extern function new(string name="read_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

	function read_agent::new(string name="read_agent",uvm_component parent);
	 	super.new(name,parent);
	endfunction

	function void read_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
			if(!uvm_config_db #(read_config)::get(this,"","read_config",r_cfg))
			`uvm_error("read_agent","unable to get read config");
			
			rmon=read_monitor::type_id::create("rmon",this);
		//	r_cfg=read_config::type_id::create("r_cfg");
            
		if(r_cfg.is_active==UVM_ACTIVE)
		begin	
			drv=read_driver::type_id::create("drv",this);
			rseq=read_sequencer::type_id::create("rseq",this);
		end
	endfunction

	function void read_agent::connect_phase(uvm_phase phase);
		if(r_cfg.is_active==UVM_ACTIVE)
		drv.seq_item_port.connect(rseq.seq_item_export);
	endfunction
		



