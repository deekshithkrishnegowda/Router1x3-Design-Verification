module fsm_1(input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
	   soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,input[1:0]data_in, 
	   output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

parameter decode_address=8'b00000001,
	load_first_data=8'b00000010,
	load_data=8'b00000100,
	wait_till_empty=8'b00001000,
	fifo_full_state=8'b00010000,
	load_after_full=8'b00100000,
	load_parity=8'b01000000,
	check_parity_error=8'b10000000;
reg[7:0]ps,ns;
reg[1:0] temp;

always@(posedge clock)
begin
if(~resetn)
temp<=0;
else
begin
if(detect_add)
temp<=data_in;
end
end

   always@(posedge clock) //present state logic
	begin
	if(~resetn)
		ps<=decode_address;
	else if((soft_reset_0&&temp==2'd0)|(soft_reset_1&&temp==2'd1)|(soft_reset_2&&temp==2'd2))
	ps<=decode_address;
	else
	ps<=ns;
end

always@(*) //next state logic
begin
if(soft_reset_0|soft_reset_1|soft_reset_2) ns<=decode_address;
else
	case(ps)	
	decode_address:/*ns<=decode_address;*/          //
	begin
		ns<=decode_address;
	if((pkt_valid&&(data_in==2'b00)&&fifo_empty_0)|(pkt_valid&&(data_in==2'b01)&&fifo_empty_1)|(pkt_valid&&(data_in==2'b10)&&fifo_empty_2))
		ns<=load_first_data;
	if(((pkt_valid)&&(data_in==2'b00)&&(~fifo_empty_0))|((pkt_valid)&&(data_in==2'b01)&&(~fifo_empty_1))|((pkt_valid)&&(data_in==2'b10)&&(~fifo_empty_2)))
		ns<=wait_till_empty;
	end

	load_first_data:ns<=load_data;              //

	load_data:/*ns<=load_data;*/		    //
	begin
		ns<=load_data;
	if(fifo_full==1) ns<=fifo_full_state;
	else if(pkt_valid==0) ns<=load_parity;
	end

	wait_till_empty:		            //
	begin
		ns<=wait_till_empty;
	if((~fifo_empty_0)|(~fifo_empty_1)|(~fifo_empty_2)) ns<=wait_till_empty;
	if((fifo_empty_0&&temp==2'd0)|(fifo_empty_1&&temp==2'd1)|(fifo_empty_2&&temp==2'd2)) ns<=load_first_data;
        end

	load_parity: ns<=check_parity_error;        //

	fifo_full_state:if(fifo_full) ns<=fifo_full_state; //
	else ns<=load_after_full;

	load_after_full:
	begin
		ns<=load_after_full;
	if(parity_done==0&&low_packet_valid==0) ns<=load_data;
	if(parity_done) ns<=decode_address;
	end
	
	check_parity_error:
		if(fifo_full) ns<=fifo_full_state;
		else ns<=decode_address;
	default:ns<=decode_address;
endcase
end

assign write_enb_reg=(((ps==load_data)|(ps==load_parity)|(ps==load_after_full))&&((ps!=fifo_full_state)&&(ps!=wait_till_empty)))? 1'b1:1'b0; /*assign write_enb_reg=((ps==fifo_full_state)|(ps==wait_till_empty))?1'b0:1'b1;*/



assign detect_add=(ps==decode_address)? 1'b1:1'b0; 
assign lfd_state=(ps==load_first_data)? 1'b1:1'b0;
assign busy=((ps==load_first_data)|(ps==fifo_full_state)|(ps==load_after_full)|(ps==wait_till_empty)|(ps==check_parity_error)|(ps==load_parity)) ? 1'b1:1'b0;
assign ld_state=(ps==load_data)? 1'b1:1'b0; /*assign busy=(ps==load_data)? 1'b0:1'b1;*/
assign full_state=(ps==fifo_full_state)? 1'b1:1'b0;
assign laf_state=(ps==load_after_full)? 1'b1:1'b0;
assign rst_int_reg=(ps==check_parity_error)? 1'b1:1'b0;

endmodule

