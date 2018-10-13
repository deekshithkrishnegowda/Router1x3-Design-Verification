class write_sequencer extends uvm_sequencer #(write_xtns);

`uvm_component_utils(write_sequencer)

extern function new(string name="write_sequencer",uvm_component parent);

endclass

function write_sequencer::new(string name ="write_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction 
