class read_xtns extends uvm_sequence_item;

`uvm_object_utils(read_xtns)

bit [7:0] header;
bit [7:0]payload[];
bit [7:0] parity;
rand bit read_enb;
bit vld_out;

rand int delay;

constraint valid {delay inside {[0:29]};} 

/*bit payload_size=header[7:2];
bit address=header[1:0];

constraint VALID{header[1:0]!=2'b11; header[7:2]!=6'd0;}*/

extern function new (string name="read_xtns");
//extern function void do_copy (uvm_object rhs);
//extern function bit do_compare (uvm_object rhs,uvm_comparer comparer);
extern function void do_print (uvm_printer printer);
//extern function void post_randomize();
endclass







	function read_xtns::new(string name="read_xtns");
		super.new(name);
	endfunction

	
/*	function void read_xtns::do_copy(uvm_object rhs);
		read_xtns rhs_;
 	
		if(!$cast(rhs,rhs_))
			begin
			`uvm_warning("read_xtns","$cast failed");
			end
	
		super.do_copy(rhs);
		 header=rhs_.header;
		 payload=rhs_.payload;
		 parity=rhs_.parity;
	endfunction

	function bit read_xtns::do_compare(uvm_object rhs,uvm_comparer comparer);
				read_xtns rhs_;
 	
		if(!$cast(rhs,rhs_))
			begin
			`uvm_warning("read_xtns","read_xtns:$cast failed");
			return 0;
			end

	
		return do_compare(rhs,comparer) &&
		 header==rhs_.header &&
		 payload==rhs_.payload &&
		 parity==rhs_.parity;
	endfunction*/

        function void read_xtns::do_print(uvm_printer printer);

		super.do_print(printer);
		printer.print_field("read_enb",read_enb,1,UVM_DEC);
		printer.print_field("delay",delay,32,UVM_DEC);
		printer.print_field("header",header,8,UVM_DEC);
//		payload=new[header[7:2]];
		foreach(payload[i])
		begin
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
		end
		printer.print_field("parity",this.parity,8,UVM_DEC);

		//printer.print_field("parity",parity,8,UVM_DEC);
	endfunction


/*	function void read_xtns::post_randomize();
		super.post_randomize;
		parity=header^payload;
	endfunction*/
