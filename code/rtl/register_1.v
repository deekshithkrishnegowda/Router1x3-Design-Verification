module register_1(input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
		input [7:0]data_in,output reg err,parity_done,low_packet_valid,output reg [7:0]dout);
	
	reg [7:0]int_header;
	reg[7:0] int_parity;
	reg[7:0] packet_parity;
	reg[7:0] fifo_full_state;

always@(posedge clock)				// parity done logic
begin
	if(~resetn)
		parity_done<=0;
	else if(detect_add)
		parity_done<=0;
	else 
	begin
		if(~pkt_valid && ld_state && ~fifo_full)
			parity_done<=1;
		else if(parity_done && laf_state && low_packet_valid)
			parity_done<=1;
else 
parity_done<=0;
	end
end

always@(posedge clock) 				// low packet valid logic, this indicates the availbility of the packet				
begin						//goes high as soon as the pkt valid goes low
	if(~resetn)
		low_packet_valid<=0;
	else if(rst_int_reg)
		low_packet_valid<=0;
	else 
	begin
		if(~pkt_valid&&ld_state)
			low_packet_valid<=1;
		else
			low_packet_valid<=0;
	end
end

always@(posedge clock) 				// internal header logic
begin
	if(~resetn)
		int_header<=0;
	else
	begin
		if(detect_add && pkt_valid && data_in!=2'd3)
			int_header<=data_in;
		else
			int_header<=0;
	end
end

always@(posedge clock)				// dout logic
begin
	if(~resetn)
		dout<=0;
	else
	begin
		if(lfd_state)
			dout<=int_header;
		else if(ld_state && ~fifo_full)
			dout<=data_in;
		else if(ld_state && fifo_full)
			fifo_full_state<=data_in;
		else if(laf_state)
			dout<=fifo_full_state;
	end
end

always@(posedge clock)				// internal parity loading
	begin
	if(~resetn)
		int_parity<=0;
	else
	begin
		if(lfd_state && ~full_state && pkt_valid)
			int_parity<=int_parity^int_header;
		else if(ld_state && ~full_state && pkt_valid)
			int_parity<=int_parity ^ data_in;
		else if(detect_add)
			int_parity<=0;
	end
end

always@(posedge clock) 				// error detection by parity
	begin
	if(~resetn)
		err<=0;
	else if(parity_done)
	begin
		if(int_parity==packet_parity)
			err<=0;
		else
			err<=1;
	end
end

always@(posedge clock)
begin
	if(ld_state && ~pkt_valid)
		packet_parity<=data_in;
	/*else 
		packet_parity<=0;*/
end
endmodule

