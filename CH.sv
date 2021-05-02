package CH;
import PK::*;
class Checker;
  logic [3:0] cmd;
  logic[31:0]  data_error[1:4]='{default:0},response_error[1:4]='{default:0},fault_tag[1:4]='{default:0} ;
  bit [2:0] no_port;
  bit [31:0] no_r_pkt[1:4];
  mailbox #(Transaction_Tx)  mbx_scb2chk[1:4];
  mailbox #(Transaction_Rx) mbx_mon2chk[1:4] ;
 
  Transaction_Rx r_mon[1:4] ;
  Transaction_Tx r_scb[1:4];
 
  extern function new(mailbox #(Transaction_Rx) mbx_mon2chk[1:4],mailbox #(Transaction_Tx)  mbx_scb2chk[1:4]);
  extern task  get_packet(int no_port );
  extern function void check(int no_port,Transaction_Tx e,Transaction_Rx r);
  extern task run(bit [31:0] no_pkt);
  extern task wrap_up;

endclass:Checker
//-------------------

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function Checker::new(mailbox #(Transaction_Rx) mbx_mon2chk[1:4],mailbox #(Transaction_Tx)  mbx_scb2chk[1:4] );
	this.mbx_mon2chk=mbx_mon2chk;
	this.mbx_scb2chk=mbx_scb2chk;
endfunction
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
task  Checker::  get_packet(int no_port);
  		no_r_pkt[no_port]++;
	   	r_scb[no_port]=new;
	   	r_mon[no_port]=new;
		mbx_scb2chk[no_port].get(r_scb[no_port]);
		mbx_mon2chk[no_port].get(r_mon[no_port]);
		check(no_port,r_scb[no_port],r_mon[no_port]);
endtask:Checker::get_packet
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function void Checker::check(int no_port,Transaction_Tx  e,Transaction_Rx  r);
$display("%0t\t\t\t Check: Port[%0d], %0dth packet\n",$time,no_port,no_r_pkt[no_port]);
if (e.tag_out!=r.tag_out&&e.data_out!=r.data_out&&e.resp_out!=r.resp_out) begin 
$display("\t\t\t Port[%0d] %0dth packet Failed\n",no_port,no_r_pkt[no_port]);
e.print(1);

	if (e.resp_out!=r.resp_out) begin 
		response_error[no_port]++;
		
		$display("\t Checher:: Port[%0d]:%0dth packet Reponse out is %0b, But it should be %0b",no_port,no_r_pkt[no_port],r.resp_out,e.resp_out);
		
	end
 	if (e.tag_out!=r.tag_out) begin 
		fault_tag[no_port]++;
		
		$display("\t Checher:: Port[%0d]:%0dth packet tag_out is %0b,But it should be %0b",no_port,no_r_pkt[no_port],r.tag_out,e.tag_out);
	
	end
	if (e.resp_out!=2'b10) begin 
		if (e.data_out!=r.data_out) begin 
			data_error[no_port]++;
			$display("\t Checher:: Port[%0d]:%0dth packet data_out is %0h, But it should be %0h",no_port,no_r_pkt[no_port],r.data_out,e.data_out);
		end 
	end
	         
end else  	$display("\t\t\tPort[%0d], %0dth packet SUCCESS\n",no_port,no_r_pkt[no_port]);
		$display("\n------------------------------------------------------------------------------\n");

endfunction:Checker::check
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  task Checker::run(bit [31:0] no_pkt);
    $display("%0t \t\t\t Checker is run\n",$time);
  
	fork
	
	 
	while (no_pkt!=no_r_pkt[1]) get_packet(1)   ;
	while (no_pkt!=no_r_pkt[2]) get_packet(2) ;
	while (no_pkt!=no_r_pkt[3]) get_packet(3) ;
	while (no_pkt!=no_r_pkt[4]) get_packet(4);
	join
	
     
    $display("\t\t\t Checker is finish\n");
	$finish;
  endtask:Checker::run 
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 task  Checker::wrap_up;
$display("\t\t\t Checker Wrap_Up\n");
  foreach (data_error[i]) begin 
	$display("\t Checker::Port[%0d]\t%0d Mismatch Response Out ",i,response_error[i]);
	$display("\t Checker::Port[%0d]\t%0d Mismatch Tag Out ",i,fault_tag[i]);
	$display("\t Checker::Port[%0d]\t%0d Mismatch Data_out",i,data_error[i]);
  end 


//Error_pkt_in=null;
//Error_pkt_out=null;

 endtask: Checker::wrap_up
 
 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endpackage
