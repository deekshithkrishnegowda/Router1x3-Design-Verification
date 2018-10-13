class read_monitor extends uvm_monitor;

`uvm_component_utils(read_monitor)

virtual router_if.RMON_MP vif; 

read_config r_cfg;
read_xtns rd_xtns;
uvm_analysis_port #(read_xtns) monitor_port;

extern function new(string name="read_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task collect_data();
extern task run_phase(uvm_phase phase);
endclass 


	function read_monitor::new(string name="read_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void read_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(read_config)::get(this,"","read_config",r_cfg))
			`uvm_error("read_monitor","can't get read_config");
		monitor_port=new("monitor_port",this);
	endfunction
	
	function void read_monitor::connect_phase(uvm_phase phase);
		vif=r_cfg.vif;
	endfunction

	task read_monitor::collect_data();
	
		wait(vif.rmon_cb.read_enb)
		@(vif.rmon_cb);
		rd_xtns.header=vif.rmon_cb.data_out;
		
			@(vif.rmon_cb);
		rd_xtns.payload=new[rd_xtns.header[7:2]];
		for(int i=0;i<rd_xtns.header[7:2];i++)
		begin
		wait(vif.rmon_cb.read_enb)
			@(vif.rmon_cb);
			rd_xtns.payload[i]=vif.rmon_cb.data_out;
		end
		
		wait(vif.rmon_cb.read_enb)
		@(vif.rmon_cb);
		rd_xtns.parity=vif.rmon_cb.data_out;
		monitor_port.write(rd_xtns);
$display("**************this is read_monitor******************");
rd_xtns.print();

	endtask

	task read_monitor::run_phase(uvm_phase phase);
	rd_xtns=read_xtns::type_id::create("rd_xtns",this);
	
	forever
	collect_data();
	
		
			endtask
	
