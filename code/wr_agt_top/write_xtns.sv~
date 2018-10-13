class write_xtns extends uvm_sequence_item;

`uvm_object_utils(write_xtns)

rand bit [7:0] header;
rand bit [7:0] payload[];   //dyanamic array
bit [7:0] parity;
bit error,busy;
bit reset;
bit pkt_valid;

bit address=header[1:0];

constraint VALID{header[1:0]!=2'b11; header[7:2]!=6'd0;}
constraint VALID1{payload.size==header[7:2];}
//constraint PL{foreach(payload[i]){payload[i]!=0;}}
//constraint payload_tag {payload inside{[0:100]};}

extern function new (string name="write_xtns");
extern function void do_copy (uvm_object rhs);
extern function bit do_compare (uvm_object rhs,uvm_comparer comparer);
extern function void do_print (uvm_printer printer);
extern function void post_randomize ();
endclass







	function write_xtns::new(string name="write_xtns");
		super.new(name);
	endfunction

	
	function void write_xtns::do_copy(uvm_object rhs);
		write_xtns rhs_;
 	
		if(!$cast(rhs,rhs_))
			begin
			`uvm_warning("write_xtns","write_xtns:$cast failed");
			end
	
		super.do_copy(rhs);
		 header=rhs_.header;
		 payload=rhs_.payload;
		 parity=rhs_.parity;
		 /*payload.size=rhs_.payload.size;
		 address=rhs_.address;*/
	endfunction

	function bit write_xtns::do_compare(uvm_object rhs,uvm_comparer comparer);
				write_xtns rhs_;
 	
		if(!$cast(rhs,rhs_))
			begin
			`uvm_warning("write_xtns","write_xtns:$cast failed");
			return 0;
			end

	
		return do_compare(rhs,comparer) &&
		 header==rhs_.header &&
		 payload==rhs_.payload &&
		 parity==rhs_.parity;
	endfunction

        function void write_xtns::do_print(uvm_printer printer);

		super.do_print(printer);
		printer.print_field("header",header,8,UVM_DEC);
//		payload=new[header[7:2]];
		foreach(payload[i])
		begin
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
		end
		printer.print_field("parity",this.parity,8,UVM_DEC);
		printer.print_field("reset",this.reset,1,UVM_DEC);
		printer.print_field("pkt_valid",this.pkt_valid,1,UVM_DEC);

	endfunction

	function void write_xtns::post_randomize();
		
			//	payload=new[header[7:2]];
				parity=header;
			foreach(payload[i])
				begin
				parity=parity^payload[i];
	
				end
	endfunction
