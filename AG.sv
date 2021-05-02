


package AG;
import PK::*;


 class Agent;
  Transaction_Tx pkt[1:4],scb_pkt[1:4][$];
  mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4];
  bit [31:0] s2drv_pkt[1:4]='{default:0};
  bit [31:0] r2agt_pkt[1:4]='{default:0};
 
  extern function new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4]);
  extern task run ;
  extern task wrap_up;

 endclass:Agent

///--------------------------------------------------------------------------------
  function Agent::new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4],mbx_agt2drv[1:4],mbx_agt2scb[1:4]);
	this.mbx_gen2agt=mbx_gen2agt;
	this.mbx_agt2drv=mbx_agt2drv;
	this.mbx_agt2scb=mbx_agt2scb;
  endfunction
//---------------------------------------------------------------------------------
task Agent::run ;
  $display ("\t\t\t\t Agent is run \n");
    
  fork 
  
  begin 
	forever begin 
 		pkt[1]=new;
		mbx_gen2agt[1].get(pkt[1]);// receiving packts from generator block
		r2agt_pkt[1]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[1],1);
		pkt[1].print(1);
		mbx_agt2drv[1].put(pkt[1]);// put packet on mail box of driver
		s2drv_pkt[1]++;
		if (pkt[1].cmd!=0) mbx_agt2scb[1].put(pkt[1]);// put packets on scoreboard mailbox
	end;
	//pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");
  end 
  
begin 
	forever begin 
 		pkt[2]=new;
		mbx_gen2agt[2].get(pkt[2]);// receiving packts from generator block
		r2agt_pkt[2]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[2],2);
		pkt[2].print(1);
		mbx_agt2drv[2].put(pkt[2]);// put packet on mail box of driver
		s2drv_pkt[2]++;
		if (pkt[2].cmd!=0) mbx_agt2scb[2].put(pkt[2]);// put packets on scoreboard mailbox
	end;
	//pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");
  end 
begin 
	forever begin 
 		pkt[3]=new;
		mbx_gen2agt[3].get(pkt[3]);// receiving packts from generator block
		r2agt_pkt[3]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[3],3);
		pkt[3].print(1);
		mbx_agt2drv[3].put(pkt[3]);// put packet on mail box of driver
		s2drv_pkt[3]++;
		if (pkt[3].cmd!=0) mbx_agt2scb[3].put(pkt[3]);// put packets on scoreboard mailbox
	end;
	//pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");
  end 
begin 
	forever begin 
 		pkt[4]=new;
		mbx_gen2agt[4].get(pkt[4]);// receiving packts from generator block
		r2agt_pkt[4]++;//the number of packts received from agent bock
		$display ("Agent: \t\t \t %0dth packet\t Port[%0d]\n ",r2agt_pkt[4],4);
		pkt[4].print(1);
		mbx_agt2drv[4].put(pkt[4]);// put packet on mail box of driver
		s2drv_pkt[4]++;
		if (pkt[4].cmd!=0) mbx_agt2scb[4].put(pkt[4]);// put packets on scoreboard mailbox
	end;
	//pkt[i]=null;
	 $display("-------------------------------------------------------------------------------------------------\n");
  end
  
  
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


