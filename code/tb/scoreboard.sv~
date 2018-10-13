class scoreboard extends uvm_scoreboard;

uvm_tlm_analysis_fifo #(read_xtns) fifo_rd[];
uvm_tlm_analysis_fifo #(write_xtns) fifo_wr;

`uvm_component_utils(scoreboard)

write_xtns wr_data;
read_xtns rd_data;
env_config m_tb_cfg;


extern function new(string name="scoreboard", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task check_data(write_xtns wr,read_xtns rd);

endclass

function scoreboard::new(string name,uvm_component parent);
super.new(name,parent);
endfunction

function void scoreboard::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(env_config)::get(this,"","env_config",m_tb_cfg))
`uvm_fatal("CONFIG","cannot get config file")

fifo_wr=new("fifo_wr",this);
fifo_rd=new[m_tb_cfg.no_of_DUTS];

foreach(fifo_rd[i])
fifo_rd[i]=new($sformatf("fifo_rd[%0d]",i),this);
endfunction

task scoreboard::run_phase(uvm_phase phase);
fork
forever
begin
fifo_wr.get(wr_data);
end
fork
			forever
			begin
			fifo_rd[0].get(rd_data);
			check_data(wr_data,rd_data);
			end

			forever
			begin
			fifo_rd[1].get(rd_data);
			check_data(wr_data,rd_data);
			end

			forever
			begin
			fifo_rd[2].get(rd_data);
			check_data(wr_data,rd_data);
			end


join_any
join
endtask

task scoreboard::check_data(write_xtns wr, read_xtns rd);
$display("------------SCOREBOARD--------------------");
	if(wr.header==rd.header)
		$display("header match %b",wr.header);
	else
	$display("header didnt match");

for(int i=0;i<wr.header[7:2];i++)
begin
	if(wr.payload[i]==rd.payload[i])
	$display("payload match %0d",i);
end

if(wr.parity==rd.parity)
$display("parity match");
else
$display("parity did not match");


endtask




 
