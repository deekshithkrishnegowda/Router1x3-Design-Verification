class base_sequence extends uvm_sequence #(write_xtns);

`uvm_object_utils(base_sequence)

extern function new(string name="base_sequence");

endclass

	function base_sequence ::new(string name="base_sequence");
		super.new(name);
	endfunction






class case_1 extends base_sequence;

`uvm_object_utils(case_1)

extern function new(string name="case_1");
extern task body();

endclass

	function case_1::new(string name="case_1");
		super.new(name);
	endfunction

	task case_1::body();
	begin
		req=write_xtns::type_id::create("req");
		start_item(req);
		assert(req.randomize()with {payload.size==6'd10;});
		$display("****************this is wr_sequence********");
		req.print;
		finish_item(req);
	end
	endtask

