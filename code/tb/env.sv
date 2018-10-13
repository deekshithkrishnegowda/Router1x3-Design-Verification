class env extends uvm_env;

`uvm_component_utils(env)

write_agent_top wr_top;
read_agent_top rd_top;
virtual_sequencer v_sqr;

env_config e_cfg;
read_config r_cfg[];
read_sequencer rd_sqr[];
scoreboard sb;

extern function new(string name="env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function  void connect_phase(uvm_phase phase);

endclass

 	function env::new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void env::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
		`uvm_error("env","unable to get env_config");

	if(e_cfg.has_write_agent_top)
		begin
		uvm_config_db #(write_config)::set(this,"wr_top.wagt*","write_config",e_cfg.w_cfg);
		wr_top=write_agent_top::type_id::create("wr_top",this);
		end
	
	if(e_cfg.has_read_agent_top)
		begin
			rd_top=read_agent_top::type_id::create("rd_top",this);

			r_cfg=new[e_cfg.no_of_DUTS];
			foreach(r_cfg[i])
				begin	
				uvm_config_db #(read_config)::set(this,$sformatf("rd_top.ragt[%0d]*",i),"read_config",e_cfg.r_cfg[i]);
				end
		end
	
	if(e_cfg.has_virtual_sequencer)
		begin
			v_sqr=virtual_sequencer::type_id::create("v_sqr",this);
		end
	
	sb=scoreboard::type_id::create("scoreboard",this);
	
	endfunction

	function void env::connect_phase(uvm_phase phase);
		v_sqr.wr_sqr=wr_top.wagt.wseq;
		rd_sqr=new[e_cfg.no_of_DUTS];
	
	foreach(rd_sqr[i])
		begin
		v_sqr.rd_sqr[i]=rd_top.ragt[i].rseq;
		end
	
	wr_top.wagt.wmon.monitor_port.connect(sb.fifo_wr.analysis_export);
	foreach(r_cfg[i])
	rd_top.ragt[i].rmon.monitor_port.connect(sb.fifo_rd[i].analysis_export);

	endfunction
