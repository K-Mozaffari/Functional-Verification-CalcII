
package DV;
import PK::*;

class Driver;
  event done[1:4];
 
  time delay;
  bit [31:0]temp[1:4];
  bit [3:0] buffer_size;
  virtual calc2_bus.TB bus;
  mailbox #(Transaction_Tx ) mbx_agt2drv[1:4];
  Transaction_Tx  pkt[1:4];
  bit [31:0] no_delay[1:4];
  bit [31:0] drv2duv_pkt[1:4]='{default:0};//number of packets send to DUV 
  extern function new ( mailbox #(Transaction_Tx) mbx_agt2drv[1:4],input virtual calc2_bus.TB bus,event done[1:4]);
  extern task transmit(input bit [2:0] no_port,Transaction_Tx p, input  virtual calc2_bus.TB b);
  extern task insert_delay(bit on,bit[2:0] port);
  extern task reset(bit r,input  virtual calc2_bus.TB bo);
  extern task run(bit [3:0] buffer_size=4) ;
  extern task wrap_up;
endclass:Driver

//========================================================
  function Driver::new ( mailbox #(Transaction_Tx ) mbx_agt2drv[1:4],input virtual calc2_bus.TB bus,event done[1:4]);
	this.mbx_agt2drv=mbx_agt2drv;
	this.bus =bus;
this.done=done;
  endfunction 


  task Driver::transmit(input bit [2:0] no_port, Transaction_Tx p, input  virtual calc2_bus.TB b);
    
 	insert_delay(p.delay_on,no_port);
	@(posedge b.cb);
		drv2duv_pkt[no_port]++;
		$display("\n   %0t Driver-port[%0d] ::%0dth packet is sent to DUV",$time,no_port,drv2duv_pkt[no_port]);
		p.print(1);
		b.cb.req_cmd_in[no_port]<=p.cmd;
		b.cb.req_tag_in[no_port]<=p.req_tag_in;
		b.cb.req_data_in[no_port]<=p.op1;
	@(negedge b.cb);
		b.cb.req_data_in[no_port]<=p.op2;
		b.cb.req_tag_in[no_port]<=2'b0;
		b.cb.req_cmd_in[no_port]<=2'b0;
  endtask:Driver::transmit
  
  task Driver::run (bit [3:0] buffer_size=4);
  this.buffer_size=buffer_size;
	$display("%0t:\t\t\t Driver is run\t,Buffer Size=%0d\ns",$time,buffer_size);
foreach (mbx_agt2drv[j]) begin 
int i=j;
	fork 
	  	while(mbx_agt2drv[i].num!=0) begin  


			if (temp[i]==buffer_size) begin
				$display("\t %0t:Driver:: Buffer port[%0d]=Full",$time,i);
						wait (done[i].triggered() );
						$display("\t %0t:Driver:: Buffer port[%0d]=Free",$time,i);
					
			 end
			
			if (temp[i]>buffer_size ) begin
			 $display("\t %0t:Driver:: Buffer port[%0d]=Full",$time,i);
			 wait (done[i].triggered() ); 
			 $display("\t %0t:Driver:: Buffer port[%0d]=Free",$time,i);
			end
			
			mbx_agt2drv[i].get(pkt[i]);
			transmit(i,pkt[i],bus);
			temp[i]=drv2duv_pkt[i];
		end
		$display("%0t \t\t\t Driver %0d is finish",$time,i);
	join_any
end
	$display ("%0t\t\t\t Driver finish",$time);
endtask


 task  Driver::wrap_up;
$display("\t\t\t Driver Wrap_Up \n");
foreach (drv2duv_pkt[i]) begin 
	$display("\tDriver :: %0d packets are sent to DUV on port[%0d] ",drv2duv_pkt[i],i);
	$display("\tDriver :: %0d delay are sent to DUV on port[%0d] ",no_delay[i],i);
	end
   foreach (pkt[i]) pkt[i]=null;
 endtask: Driver::wrap_up

 task Driver::	insert_delay(bit on,bit[2:0] port);
 
 if (on) begin 
	delay=$urandom_range(1000,0);
	 # delay;
	 $display ("******%0d ns delay is inserted on port[%0d]",delay,port);
	 no_delay[port]++;
	end
endtask:Driver::insert_delay


task Driver::reset(bit r,input  virtual calc2_bus.TB bo);

		if (r)$display("\n   %0t Driver Calc2 is reseting",$time);
		bo.reset=r;
		for(int i=1; i<5;i++) begin 
		bo.cb.req_cmd_in[i]<=4'b0000;
		bo.cb.req_tag_in[i]<=2'b00;
		bo.cb.req_data_in[i]<=32'h0;
		end
		#300ns;
		bo.reset=1'b0;
endtask:Driver::reset

endpackage:DV
