class read_base_sequence extends uvm_sequence #(read_xtns);

`uvm_object_utils(read_base_sequence)

extern function new(string name="read_base_sequence");

endclass

	function read_base_sequence ::new(string name="read_base_sequence");
		super.new(name);
	endfunction






class case_2 extends read_base_sequence;

`uvm_object_utils(case_2)

extern function new(string name="case_2");
extern task body();

endclass

	function case_2::new(string name="case_2");
		super.new(name);
	endfunction

	task case_2::body();
	begin
		req=read_xtns::type_id::create("req");
		start_item(req);
		assert(req.randomize()with {read_enb==1'd1;});
		$display("****************this is rd_sequence******************");
		req.print;
		
		finish_item(req);
		
	end
	endtask

