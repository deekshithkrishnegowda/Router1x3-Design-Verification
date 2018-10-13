class write_driver extends uvm_driver #(write_xtns);

`uvm_component_utils(write_driver)

virtual router_if.WDR_MP vif;
write_config w_cfg;

	extern function new(string name="write_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase); 
	extern function void connect_phase(uvm_phase phase);
	extern task drive_item(write_xtns wr_xtns);
	extern task run_phase(uvm_phase phase);


endclass

	function write_driver::new(string name="write_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void write_driver :: build_phase(uvm_phase phase);
		super.build_phase(phase);
                if(!uvm_config_db #(write_config)::get(this,"","write_config",w_cfg))
		`uvm_error("write_driver","not able to get interface");
	
		$display("\n \n %m w_cfg:%p \n \n",w_cfg);

	endfunction

	function void write_driver:: connect_phase(uvm_phase phase);
		vif=w_cfg.vif;
	endfunction


	task write_driver:: drive_item(write_xtns wr_xtns);
	begin	
			wait(~vif.wdr_cb.busy)
				@(vif.wdr_cb);
				vif.wdr_cb.pkt_valid<=1'b1;
				vif.wdr_cb.data_in<=wr_xtns.header;
				//wr_xtns.payload=new[wr_xtns.header[7:2]];
				@(vif.wdr_cb);
			
			//	wait(~vif.wdr_cb.busy)
			
					
			for(int i=0;i<wr_xtns.header[7:2];i++)	
			begin
				wait(~vif.wdr_cb.busy)
				@(vif.wdr_cb);
				
				vif.wdr_cb.data_in<= wr_xtns.payload[i];
				vif.wdr_cb.pkt_valid<=1'b1;
			end	

				wait(~vif.wdr_cb.busy)
				@(vif.wdr_cb);
				vif.wdr_cb.data_in<=wr_xtns.parity;
				vif.wdr_cb.pkt_valid<=1'b0;
	end
	endtask
		 	

	task write_driver::run_phase(uvm_phase phase );
	vif.wdr_cb.reset<=1'b1;
	forever
		begin
		seq_item_port.get_next_item(req);
   		     		
		drive_item(req);
		$display("*****************this is write driver*************");	
		req.print();
	   

		seq_item_port.item_done();
		end
	endtask
