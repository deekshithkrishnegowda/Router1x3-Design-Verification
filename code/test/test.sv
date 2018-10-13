class test extends uvm_test;

`uvm_component_utils(test)

env env_handle;
env_config e_cfg;
write_config w_cfg;
read_config r_cfg[];
int no_of_DUTS=3;
virtual_case_1 v_sq;

extern function new(string name="test",uvm_component parent);
extern  function void  build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

	function test::new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
	
	e_cfg=env_config::type_id::create("e_cfg");
	
	e_cfg.no_of_DUTS=no_of_DUTS;
        e_cfg.r_cfg=new[no_of_DUTS];
	w_cfg=write_config::type_id::create("w_cfg");
	r_cfg=new[no_of_DUTS];
	
	foreach(r_cfg[i])
		begin
			r_cfg[i]=read_config::type_id::create($sformatf("r_cfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),r_cfg[i].vif))
			`uvm_fatal("test","unable to get read ram_if")

	//$display("LINE-39: \n \n %m r_cfg[%0d]=%p",i,r_cfg[i]);
			e_cfg.r_cfg[i]=r_cfg[i];
//$display("LINE-41: \n \n %m %p \n \n",e_cfg);

		end

	if(!uvm_config_db #(virtual router_if)::get(this,"","vif",w_cfg.vif))
		`uvm_fatal("test","unable to get write ram_if")
	
		e_cfg.w_cfg=w_cfg;
//		$display("LINE-49:\n \n %m %p \n \n",e_cfg);

		uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
		env_handle=env::type_id::create("env_handle",this);
	endfunction

	task test::run_phase(uvm_phase phase);
		v_sq=virtual_case_1::type_id::create("v_sq");
		phase.raise_objection(this);
		v_sq.start(env_handle.v_sqr);
		#200;
		phase.drop_objection(this);
	endtask
