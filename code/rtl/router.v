module router(input [7:0]data_in,input pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2, output [7:0]data_out_0,data_out_1,data_out_2,
 	      output vld_out_0,vld_out_1,vld_out_2,err,busy);
wire [2:0]write_enb;
wire[7:0]dout;
fifo_1 FIFO1(clock ,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd_state,dout,data_out_0,full_0,fifo_empty_0);
fifo_1 FIFO2(clock ,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd_state,dout,data_out_1,full_1,fifo_empty_1);
fifo_1 FIFO3(clock ,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd_state,dout,data_out_2,full_2,fifo_empty_2);

synchronizer_1 SYNCHRONISER(clock,resetn,detect_add,write_enb_reg,data_in[1:0],full_0,full_1,full_2,fifo_empty_0,fifo_empty_1,fifo_empty_2,read_enb_0,read_enb_1,read_enb_2,write_enb,vld_out_0,soft_reset_0, vld_out_1,soft_reset_1, vld_out_2,soft_reset_2,fifo_full);

fsm_1 FSM(clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
	   soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,data_in[1:0], 
	   write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

register_1 REGISTER(clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
		data_in,err,parity_done,low_pkt_valid,dout);
endmodule


