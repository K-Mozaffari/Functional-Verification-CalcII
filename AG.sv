


package AG;
import PK::*;


 class Agent;
  Transaction_Tx pkt[1:4],scb_pkt[1:4][$];
  mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4];
  bit [31:0] s2drv_pkt[1:4]='{default:0};
  bit [31:0] r2agt_pkt[1:4]='{default:0};
 
  extern function new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4]);
  extern task run ;
  extern task wrap_up;

 endclass:Agent

///--------------------------------------------------------------------------------
  function Agent::new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4]);
	this.mbx_gen2agt=mbx_gen2agt;
	this.mbx_agt2drv=mbx_agt2drv;
  endfunction
//---------------------------------------------------------------------------------
task Agent::run ;
  $display ("\t\t\t\t Agent is run \n");
  foreach (pkt[i]) begin 
	do begin 
 		pkt[i]=new;
		mbx_gen2agt[i].get(pkt[i]);// receiving packts from generator block
		r2agt_pkt[i]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[i],i);
		pkt[i].print(1);
		mbx_agt2drv[i].put(pkt[i]);// put packet on mail box of driver
		s2drv_pkt[i]++;
		if (pkt[i].cmd!=0)scb_pkt[i].push_back(pkt[i]);// put packets on scoreboard array
  	end while (mbx_gen2agt[i].num!=0);
	pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");
  end 
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


