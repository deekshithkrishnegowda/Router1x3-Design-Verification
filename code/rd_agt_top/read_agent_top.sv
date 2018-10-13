class read_agent_top extends uvm_env;

`uvm_component_utils(read_agent_top)

read_agent ragt[];

read_config r_cfg;
env_config e_cfg;

extern function new(string name="read_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

	function read_agent_top::new(string name="read_agent_top",uvm_component parent );
		super.new(name,parent);
	endfunction

	function void read_agent_top::build_phase(uvm_phase phase);
	super.build_phase( phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("rd_top","cannot get env_config")
	
			$display("\n %m \n %p \n",e_cfg);

		ragt=new[e_cfg.no_of_DUTS];
	foreach(ragt[i])
	begin
	ragt[i]=read_agent::type_id::create($sformatf("ragt[%0d]",i),this);
	end
	endfunction

	task read_agent_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask	
