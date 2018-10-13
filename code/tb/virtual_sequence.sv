class virtual_sequence extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(virtual_sequence)

write_sequencer wr_sqr;
read_sequencer rd_sqr[];
virtual_sequencer v_sqr;
case_1 cs; 
case_2 cs1,cs2,cs3;
env_config e_cfg;

extern function new (string name="virtual_sequence");
extern task body(); 

endclass	

	function virtual_sequence::new(string name="virtual_sequence");
		super.new(name);
	endfunction

	task virtual_sequence::body();
		if(!$cast(v_sqr,m_sequencer))
			`uvm_error("get_full_name()","casting failed");
		wr_sqr=v_sqr.wr_sqr;
		
		if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",e_cfg))
			`uvm_error("virtual_sequence","cannot get env_config");
		rd_sqr=new[e_cfg.no_of_DUTS];
		
		foreach(rd_sqr[i])
		begin
			rd_sqr[i]=v_sqr.rd_sqr[i];
		end
	endtask


class virtual_case_1 extends virtual_sequence;

`uvm_object_utils(virtual_case_1)

extern function new(string name="virtual_case_1");
extern task body();

endclass

	function virtual_case_1::new(string name="virtual_case_1");
		super.new(name);
	endfunction

	task virtual_case_1::body();
		super.body();
		cs=case_1::type_id::create("cs");
		cs1=case_2::type_id::create("cs1");
		cs2=case_2::type_id::create("cs2");
		cs3=case_2::type_id::create("cs3");

		fork
			cs.start(wr_sqr);
			
			fork
				cs1.start(rd_sqr[0]);
				cs2.start(rd_sqr[1]);
				cs3.start(rd_sqr[2]);	
			join_any


		join
	
	endtask
