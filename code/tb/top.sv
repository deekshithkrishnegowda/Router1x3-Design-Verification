module top;
    import router_test_pkg::*;
	import uvm_pkg::*;

	bit clock;  
	always 
	#10 clock=!clock;     

  router_if in0(clock);
  router_if in1(clock);
  router_if in2(clock);
  router_if in3(clock);
   
router DUT(.clock(clock),.data_in(in0.data_in),.err(in0.error),.busy(in0.busy),
	   .pkt_valid(in0.pkt_valid),.vld_out_0(in1.vld_out),.vld_out_1(in2.vld_out),.vld_out_2(in3.vld_out),
	   .data_out_0(in1.data_out),.data_out_1(in2.data_out),.data_out_2(in3.data_out),.resetn(in0.reset),
	   .read_enb_0(in1.read_enb),.read_enb_1(in2.read_enb),.read_enb_2(in3.read_enb));



       	initial begin
   uvm_config_db #(virtual router_if)::set(null,"*","vif",in0); //write_agent 
   uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in1); //read_agent_1
   uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in2); //read_agent_2
   uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in3); //read_agent_3
	
		
	run_test();
     end
 

   
endmodule


  

