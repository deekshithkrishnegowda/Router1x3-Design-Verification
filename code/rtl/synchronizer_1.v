module synchronizer_1 (input clock,resetn,detect_add,write_enb_reg, 
                     input[1:0]data_in,
                     input full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2,
                     output  reg[2:0] write_enb,
                     output reg vld_out_0,soft_reset_0, vld_out_1,soft_reset_1, vld_out_2,soft_reset_2, 
                     output reg fifo_full);
reg [1:0]temp;
integer count0,count1,count2;

always@(posedge clock)  //1.packet address detection
begin
	if(~resetn)
		temp<=2'b11;
	else if(detect_add)
		temp<=data_in;
	
end

always@(posedge clock) //2.soft reset generation
begin
	if(~resetn) // COUNTER1 LOGIC
	begin
		soft_reset_0<=0;count0<=5'd0;
	end
	else if(vld_out_0)
	begin 
        	if(read_enb_0)
		soft_reset_0<=0;
	        else	
		count0<=count0+1'b1;
	        if(count0>=5'd29)
		soft_reset_0<=1;
	end
	
	if(~resetn) //COUNTER2 LOGIC
	begin
		soft_reset_1<=0;count1<=5'd0;
	end
	else if(vld_out_1)
	begin 
        	if(read_enb_1)
		soft_reset_1<=0;
	        else	
		count1<=count1+1'b1;
	        if(count1>=5'd29)
		soft_reset_1<=1;
	end
	
	if(~resetn) //COUNTER3 LOGIC
	begin
		soft_reset_2<=0;count2<=5'd0;
	end
	else if(vld_out_2)
	begin 
        	if(read_enb_2)
		soft_reset_2<=0;
	        else	
		count2<=count2+1'b1;
	        if(count2>=5'd29)
		soft_reset_2<=1;
	end



end

always@(*) //3.write_enb generation
begin
 	 if(write_enb_reg)
	case(temp)
		2'b00:write_enb=3'b001;
		2'b01:write_enb=3'b010;
		2'b10:write_enb=3'b100;
		default:write_enb=3'bxxx;
	endcase
	else
	write_enb=3'bxxx;
end

always@(*) //4.validout generation
begin
	if(~empty_0)
		vld_out_0=1'b1;
	else 
		vld_out_0=1'b0;

	if(~empty_1)
		vld_out_1=1'b1;
	else
		vld_out_1=1'b0;


        if(~empty_2)
		vld_out_2=1'b1;
	else
		vld_out_2=1'b0;
end

always@(*) //5.fifo full generation
begin
		case(temp)
			2'b00:fifo_full=full_0;
			2'b01:fifo_full=full_1;
			2'b10:fifo_full=full_2;
			default:fifo_full=0;
		endcase
end
endmodule



