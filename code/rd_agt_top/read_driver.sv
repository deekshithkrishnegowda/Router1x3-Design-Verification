class read_driver extends uvm_driver #(read_xtns);

`uvm_component_utils(read_driver)

virtual router_if.RDR_MP vif;

read_config r_cfg;

	extern function new(string name="read_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase); 
	extern function void connect_phase(uvm_phase phase);
	extern task data_item(read_xtns rd_xtns);
	extern task run_phase(uvm_phase phase);


endclass

	function read_driver::new(string name="read_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void read_driver :: build_phase(uvm_phase phase);
		super.build_phase(phase);
                if(!uvm_config_db #(read_config)::get(this,"","read_config",r_cfg))
		`uvm_fatal("read_driver","not able to get interface");

		//$display("\n \n %m r_cfg:%p \n \n",r_cfg);
			endfunction

	function void read_driver:: connect_phase(uvm_phase phase);
		vif=r_cfg.vif;
	endfunction

	task read_driver::data_item(read_xtns rd_xtns);
		wait(vif.rdr_cb.vld_out) //&& (rd_xtns.delay<=5'd29))	
		
		@(vif.rdr_cb);
		vif.rdr_cb.read_enb<=rd_xtns.read_enb;
		@(vif.rdr_cb);
		
		if(vif.rdr_cb.vld_out==0)
		begin
		rd_xtns.read_enb=1'b0;
		@(vif.rdr_cb);

		vif.rdr_cb.read_enb<=rd_xtns.read_enb;
		end
	endtask

	task read_driver::run_phase(uvm_phase phase);
		seq_item_port.get_next_item(req);
		//$display("*************entering driver ruphase***************");
		data_item(req);
			seq_item_port.item_done();

	endtask
	

		 	
	
