package ENV;
import PK::*;
import GEN::*;
import AG::*;
import DV::*;
import SC::*;
import MO::*;
import CH::*;
import CFG::*;
  class Environment;
	Generator	gen;
	Agent		agt;
	Driver		drv;
	Scoreboard	scb;
	Monitor		mon;
	Checker		chk;
	Config		cfg;
	bit [3:0]buffer_size=4;
	event done [1:4];
	virtual calc2_bus.TB bus;
	mailbox #(Transaction_Tx) mbx_gen2agt[1:4];
	mailbox #(Transaction_Tx) mbx_agt2drv[1:4];
	mailbox #(Transaction_Tx) mbx_agt2scb[1:4];
	mailbox #(Transaction_Tx) mbx_scb2chk[1:4];
	mailbox #(Transaction_Rx) mbx_mon2chk[1:4];
	


	extern function new(input virtual calc2_bus.TB bus); 
	extern function void gen_cfg();
 	extern function void build();
 	extern task run(); 
	extern task wrap_up();// Clean up after the stimulus and report the results
  endclass:Environment
  
 function Environment::new(input virtual calc2_bus.TB bus);
	this.bus=bus;
	cfg=new;
 endfunction 

 function void Environment::gen_cfg();
	assert(cfg.randomize());
 endfunction:Environment::gen_cfg

 function void Environment::build();
	for (int i=1;i<=4;i++)  mbx_gen2agt[i]=new(buffer_size);
	for (int i=1;i<=4;i++)  mbx_agt2drv[i]=new(buffer_size);
	for (int i=1;i<=4;i++) 	mbx_agt2scb[i]=new(buffer_size);
	for (int i=1;i<=4;i++) 	mbx_scb2chk[i]=new(buffer_size);
	for (int i=1;i<=4;i++) 	mbx_mon2chk[i]=new(buffer_size);
	
	

 	gen=new(mbx_gen2agt);
 	gen.build;
  	agt=new(mbx_gen2agt,mbx_agt2drv,mbx_agt2scb);
  	scb=new(mbx_agt2scb,mbx_scb2chk);
  	drv=new(mbx_agt2drv,bus,done);
 	mon=new(bus,mbx_mon2chk,done);
	chk=new(mbx_mon2chk,mbx_scb2chk);
 endfunction:Environment::build

 task Environment::run();
   
	fork 
	  gen.run(cfg.run_for_n_trans);
$display ("The number of packets=%0d",cfg.run_for_n_trans);
	  agt.run(cfg.run_for_n_trans);
	  scb.run(cfg.run_for_n_trans);
	  drv.run(buffer_size);
	  $display ("Buffer Size=%0d",buffer_size);
	  mon.run(cfg.run_for_n_trans);
	  chk.run(cfg.run_for_n_trans); 
	join  
	 
 endtask:Environment::run

 task Environment::wrap_up();
	fork 
	  gen.wrap_up();
	  agt.wrap_up();
	  scb.wrap_up();
	  drv.wrap_up();
	  mon.wrap_up();
	  
	  chk.wrap_up(); 

	join
	$finish;
 endtask:Environment::wrap_up



endpackage:ENV


