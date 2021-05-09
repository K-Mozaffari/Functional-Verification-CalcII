


package AG;
import PK::*;


 class Agent;
  Transaction_Tx pkt[1:4],scb_pkt[1:4][$];
  mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4];
  bit [31:0] s2drv_pkt[1:4]='{default:0};
  bit [31:0] r2agt_pkt[1:4]='{default:0};
 
  extern function new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4]);
  extern task trnsfer2scb_drv(bit[2:0] no_port,bit [31:0] no_pkt);
  extern task run(bit [31:0] no_pkt) ;
  extern task wrap_up;

 endclass:Agent

///--------------------------------------------------------------------------------
  function Agent::new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4]);
	this.mbx_gen2agt=mbx_gen2agt;
	this.mbx_agt2drv=mbx_agt2drv;
	this.mbx_agt2scb=mbx_agt2scb;
  endfunction
//---------------------------------------------------------------------------------
task Agent::trnsfer2scb_drv(bit[2:0] no_port,bit [31:0] no_pkt);

	repeat (no_pkt) begin 
 		pkt[no_port]=new;
		mbx_gen2agt[no_port].get(pkt[no_port]);// receiving packts from generator block
		r2agt_pkt[no_port]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[no_port],no_port);
		pkt[no_port].print(no_port);
		mbx_agt2drv[no_port].put(pkt[no_port]);// put packet on mail box of driver
		s2drv_pkt[no_port]++;
		if (pkt[no_port].cmd!=0) mbx_agt2scb[no_port].put(pkt[no_port]);// put packets on scoreboard mailbox
	end;
	//pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");

endtask:Agent::trnsfer2scb_drv


task Agent::run(bit [31:0] no_pkt) ;
  $display ("\t\t\t\t Agent is run \n");
    
  fork 
  trnsfer2scb_drv(1,no_pkt);
  trnsfer2scb_drv(2,no_pkt);
  trnsfer2scb_drv(3,no_pkt);
  trnsfer2scb_drv(4,no_pkt);

  join 
  $display("\t\t\t\t Agent Finish\n");
endtask:Agent::run 



 task Agent::wrap_up;
$display("\t\t\t Agent Wrap_Up\n");
   foreach (r2agt_pkt[i]) $display("\t Agent:: %0d packets are received from Generator Port[%0d] ",r2agt_pkt[i],i);
   foreach (s2drv_pkt[i]) $display("\t Agent:: %0d packets are sent to Driver Port[%0d]",s2drv_pkt[i],i);
   foreach (r2agt_pkt[i]) begin  
	if (r2agt_pkt[i]!=s2drv_pkt[i]) 
	$display (" \t Agent ::Port[%0d] %0d packets are not send to Driver",i,r2agt_pkt[i]-s2drv_pkt[i]);
	else $display("\t  Agent Port[%0d]  Successful  ",i);
	for  (int i=1; i<5;i++) begin pkt[i]=null;end
   end
 endtask:Agent::wrap_up

endpackage


