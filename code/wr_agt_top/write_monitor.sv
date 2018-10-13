class write_monitor extends uvm_monitor;

`uvm_component_utils(write_monitor)

virtual router_if.WMON_MP vif; 

write_config w_cfg;
write_xtns wr_xtns;

uvm_analysis_port #(write_xtns) monitor_port;


extern function new(string name="write_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);	
extern task collect_data();
extern task run_phase(uvm_phase phase);

endclass 


	function write_monitor::new(string name="write_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void write_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(write_config)::get(this,"","write_config",w_cfg))
			`uvm_error("write_monitor","can't get write_config");
		monitor_port=new("monitor_port",this);
	endfunction
	
	function void write_monitor::connect_phase(uvm_phase phase);
		vif=w_cfg.vif;
	endfunction

	task write_monitor::collect_data();

			wait((~vif.wmon_cb.busy)&&vif.wmon_cb.pkt_valid)
		//	@(vif.wmon_cb);
		//	@(vif.wmon_cb);
			
			wr_xtns.header=vif.wmon_cb.data_in;
		//		$display("***********HEADER**********this is write monitor********************");
		//		wr_xtns.print;


			wr_xtns.payload=new[wr_xtns.header[7:2]];
			@(vif.wmon_cb);
	
			for(int i=0;i<wr_xtns.header[7:2];i++)	
	
			begin
				wait((~vif.wmon_cb.busy)&&(vif.wmon_cb.pkt_valid))
				@(vif.wmon_cb);
				wr_xtns.payload[i]=vif.wmon_cb.data_in;
			

			end

			wait((~vif.wmon_cb.busy)&&(~vif.wmon_cb.pkt_valid))
			@(vif.wmon_cb);
			wr_xtns.parity=vif.wmon_cb.data_in;
			$display("*********************this is write monitor********************");
		wr_xtns.print;
		monitor_port.write(wr_xtns);

					
	endtask

	task write_monitor::run_phase(uvm_phase phase);
	 	wr_xtns=write_xtns::type_id::create("wr_xtns",this);
		forever
		collect_data();
		$display("*********************this is write monitor********************");
		wr_xtns.print;



	endtask	
