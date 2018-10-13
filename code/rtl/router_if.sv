interface router_if(input bit clock);

bit [7:0] data_in;
bit [7:0] data_out;
bit error,busy;
bit vld_out;
bit read_enb;
bit reset;
bit pkt_valid;
 

	clocking wdr_cb @(posedge clock);
	default input #1 output #1;
		input busy;
		input error;
		output data_in;
		output reset;
		output pkt_valid;
	endclocking

	
	
	clocking wmon_cb @(posedge clock);
	default input #1 output #1;
		input busy;
		input error;
		input data_in;
		input reset;
		input pkt_valid;
	endclocking


	
	clocking rdr_cb @(posedge clock);
	default input #1 output #1;
		input vld_out;
		output read_enb;
	endclocking

	
	clocking rmon_cb @(posedge clock);
	default input #1 output #1;
		input read_enb;
		input data_out;
	endclocking

modport WDR_MP(clocking wdr_cb);
modport WMON_MP(clocking wmon_cb);
modport RDR_MP(clocking rdr_cb);
modport RMON_MP(clocking rmon_cb);

endinterface	
