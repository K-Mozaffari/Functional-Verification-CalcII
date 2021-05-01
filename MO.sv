package MO;
import PK::*;
class Monitor;

	virtual calc2_bus.TB bus;
	mailbox #(Transaction_Rx) mbx_mon2chk[1:4];
	bit ee[1:4]='{default:0};
	event done[1:4];
	Transaction_Rx real_pkt[1:4];
	bit [31:0] no_r_pkt[1:4];
	bit [31:0] no_pkt;
	bit [31:0] Error_sig_tag[1:4];
	bit [31:0] Error_sig_data[1:4];
	bit [31:0] Error_sig_resp[1:4];
	bit [31:0] Error_pkt[1:4];
	bit [31:0] Success_pkt[1:4];
	bit [31:0] Error_pkt_N_resp_out[1:4];
	bit [31:0] Error_pkt_N_tag_out[1:4];
	bit [31:0] Error_pkt_N_data_out[1:4];
	bit S_pkt[1:4];
	bit E_pkt[1:4];
	bit er,et,ed;
	bit [31:0] Error_Resp_out[1:4];
	bit [31:0] Error_Tag_out[1:4];   
	bit [31:0] Error_Data_out[1:4];  
	extern function new(input virtual calc2_bus.TB bus,mailbox #(Transaction_Rx) mbx_mon2chk[1:4],event done[1:4]);
	extern task event_p(bit [2:0] no_port,input virtual calc2_bus.TB bus);
	
	extern task run(bit [31:0] no_pkt);
	 extern task wrap_up;
endclass:Monitor
//=============================================
 function Monitor::new(input virtual calc2_bus.TB bus,mailbox #(Transaction_Rx) mbx_mon2chk[1:4],event done[1:4]);
		this.bus=bus;
		this.mbx_mon2chk=mbx_mon2chk;
		this.done=done;
	endfunction 


 task Monitor::run(bit[31:0] no_pkt);
		$display("\t\t\t %0t:Monitor is started \n",$time );
 for (int i=1;i<5;i++)		begin 
 int j=i;
	fork 
	  event_p(j, bus);
	join_none
end

endtask:Monitor::run	


task Monitor::event_p(bit [2:0] no_port,input virtual calc2_bus.TB bus);
	//fork
		while(1) begin 
			@(bus.cb.resp_out[no_port] or bus.cb.tag_out[no_port] or bus.cb.data_out[no_port]  );
//---------------------------
			if (S_pkt[no_port]==0||E_pkt[no_port]==0) begin //1
			  if (bus.cb.resp_out[no_port]==0 &&bus.cb.tag_out[no_port]!=0&&bus.cb.data_out[no_port]==0) begin //1-1
				$display("\t ** %0t:Monitor::Port[%0d] There is tag signal between two packets",$time,no_port);
				Error_sig_tag[no_port]++;
			  end//1-1
			  if (bus.cb.resp_out[no_port]==0 &&bus.cb.tag_out[no_port]==0&&bus.cb.data_out[no_port]!=0) begin //1-2
				
				$display("\t ** %0t:Monitor::Port[%0d] There is data signal between two packets",$time,no_port);
			  	Error_sig_data[no_port]++;
			  end//1-2
			  if (bus.cb.resp_out[no_port]!=0 &&bus.cb.tag_out[no_port]==0&&bus.cb.data_out[no_port]==0) begin //1-3
				
				$display("\t ** %0t:Monitor::Port[%0d] There is rep signal between two packets",$time,no_port);
			  	Error_sig_resp[no_port]++;
			  end//1-3
			end//1
//-----------------------------------	 
 		if (S_pkt[no_port]) begin //2
			if (bus.cb.resp_out[no_port]!=0&&bus.cb.tag_out[no_port]!=0&&bus.cb.data_out[no_port]!=0)  begin//2-4
					  Error_pkt[no_port]++;
						 $display("\t %0t:Monitor::%0dth packet Port[%0d]  is received with error\n ",$time,no_r_pkt[no_port],no_port); 
					if (bus.cb.resp_out[no_port]!=0) begin //2-4-1
						$display("\t %0t:Monitor::Error:%0dth packet on Port[%0d]:resp_out is not became low",$time,no_r_pkt[no_port],no_port);
						Error_pkt_N_resp_out[no_port]++;
					end//2-4-1
			    		if (bus.cb.tag_out[no_port]!=0)  begin //2-4-2
						$display("\t %0t:Monitor::Error:%0dth packet on Port[%0d]:tag_out is not became low",$time,no_r_pkt[no_port],no_port);
						Error_pkt_N_tag_out[no_port]++;
					end//2-4-2
			   		if ( bus.cb.data_out[no_port]!=0) begin//2-4-3
						$display("\t %0t:Monitor::Error:%0dth packet on Port[%0d]:data_out is not became low",$time,no_r_pkt[no_port],no_port);
						Error_pkt_N_data_out[no_port]++;
					end//2-4-3
			end//2-4

			if (bus.cb.resp_out[no_port]==0||bus.cb.tag_out[no_port]==0||bus.cb.data_out[no_port]==0) begin 
					Success_pkt[no_port]++;
					$display("\t %0t:Monitor::%0dth packet Port[%0d]  is received successfuly\n ",$time,no_r_pkt[no_port],no_port); 
			end 
			S_pkt[no_port]=0;
		end
//////////////////////////////////////
		if (E_pkt[no_port]) begin
			Error_pkt[no_port]++;
 			$display("\t %0t:Monitor::%0dth packet Port[%0d]  is received with error\n ",$time,no_r_pkt[no_port],no_port);
			if (er)$display("\t %0t:Monitor::%0dth packet on Port[%0d] Resp_out is not received",$time,no_r_pkt[no_port],no_port);
			if (et)$display("\t %0t:Monitor::%0dth packet on Port[%0d] Tag_out is not received",$time,no_r_pkt[no_port],no_port);
			if (ed)$display("\t %0t:Monitor::%0dth packet on Port[%0d] Data_out is not received",$time,no_r_pkt[no_port],no_port);
			er=0;
			et=0;
			ed=0;
			E_pkt[no_port]=0;
		end

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		 
			if(  (bus.cb.resp_out[no_port]!=0) && (bus.cb.tag_out[no_port]!=0)) begin 
		 	  real_pkt[no_port]=new;
 			  real_pkt[no_port].resp_out= bus.cb.resp_out[no_port];
			  real_pkt[no_port].tag_out=bus.cb.tag_out[no_port];
			  real_pkt [no_port].data_out= bus.cb.data_out[no_port];
			  mbx_mon2chk[no_port].put(real_pkt[no_port]);
			  no_r_pkt[no_port]++;
			  S_pkt[no_port]=1;
			  ->done[no_port];
			end  else 
			begin 
			if ((((bus.cb.resp_out[no_port]!=0)&&(bus.cb.tag_out[no_port]==0))&&(bus.cb.data_out[no_port]!=0))||((bus.cb.resp_out[no_port]==0)&&(bus.cb.tag_out[no_port]!=0)&&(bus.cb.data_out[no_port]!=0))) begin 
	  		
			  real_pkt[no_port ]=new;
 			  real_pkt[no_port ].resp_out= bus.cb.resp_out[no_port];
			  real_pkt[no_port ].tag_out=bus.cb.tag_out[no_port];
			  real_pkt [no_port ].data_out= bus.cb.data_out[no_port];
			  mbx_mon2chk[no_port ].put(real_pkt[no_port ]);
			  no_r_pkt[no_port]++;
			 
 		  	  if (bus.cb.resp_out[no_port]==0)begin  Error_Resp_out[no_port]++; er=1;end
			  if (bus.cb.tag_out[no_port]==0) begin  Error_Tag_out[no_port]++;  et=1;end
			  if (bus.cb.data_out[no_port]==0)begin  Error_Data_out[no_port]++; ed=1;end
			  E_pkt[no_port]=1;
			  ->done[no_port];
			end 
			end 
			
	
end
	//join_none
endtask:Monitor::event_p

task Monitor::wrap_up;
$display("%0t \t\t\t Monitor Wrap_Up\n",$time);
	for(int i=1;i<5;i++) begin 
	  $display ("\t\t Port[%0d]\n",i);
		$display ("\t Monitor::Port[%0d]\t%0d packets are received",i,no_r_pkt[i]);
		$display ("\t Monitor::Port[%0d]\t%0d packets are received successfuly",i,Success_pkt[i]);
		$display ("\t Monitor::Port[%0d]\t%0d packets are received with error\n",i,Error_pkt[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Resp_out(Pose Edge)",i,Error_Resp_out[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Tag_out(Pose Edge)",i,Error_Tag_out[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Data_out(Pose Edge)",i,Error_Data_out[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Response_out(Neg Edge)",i,Error_pkt_N_resp_out[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Tag_out(Neg Edge)",i,Error_pkt_N_tag_out[i]);
		$display ("\t        Monitor::Port[%0d]\t%0d packets are received with Error_Data_out(Neg Edge)\n",i,Error_pkt_N_data_out[i]);
		$display ("\t Monitor::Port[%0d] There is %0d  resp signal between two received packets",i,Error_sig_resp[i]);
		$display ("\t Monitor::Port[%0d] There is %0d  tag signal between two received packets",i,Error_sig_tag[i]);
		$display ("\t Monitor::Port[%0d] There is %0d  data signal between two received packets\n",i,Error_sig_data[i]);
	end 
foreach (real_pkt[i]) real_pkt[i]=null;

endtask:Monitor::wrap_up  
endpackage
