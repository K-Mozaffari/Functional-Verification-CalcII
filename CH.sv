package CH;
import PK::*;
class Checker;
  logic [3:0] cmd;
  logic[31:0]  data_error[1:4]='{default:0},response_error[1:4]='{default:0},fault_tag[1:4]='{default:0} ;
  bit [2:0] no_port;
  bit [31:0] no_r_pkt[1:4];

  mailbox #(Transaction_Rx) mbx_mon2chk[1:4];

  Transaction_Rx receive_pkt[1:4];
  Transaction_Tx expect_pkt[1:4];

  extern function void check(int no_port,Transaction_Tx e,Transaction_Rx r);
  extern function new(mailbox #(Transaction_Rx) mbx_mon2chk[1:4]);
  extern task  get_packet(int no_port,ref Transaction_Tx scb[$] );
  extern task run( Transaction_Tx scb_pkt[1:4][$]);
  extern task wrap_up;

endclass:Checker
//-------------------
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
//----
 function Checker::new(mailbox #(Transaction_Rx) mbx_mon2chk[1:4]);
	this.mbx_mon2chk=mbx_mon2chk;
	endfunction

task  Checker::  get_packet(int no_port,ref Transaction_Tx scb[$] );
      		no_r_pkt[no_port]++;
	   	expect_pkt[no_port]=new;
	   	receive_pkt[no_port]=new;
		expect_pkt[no_port]=scb.pop_front;
		mbx_mon2chk[no_port].get(receive_pkt[no_port]);
		check(no_port,expect_pkt[no_port],receive_pkt[no_port]);
endtask:Checker::get_packet

  task Checker::run( Transaction_Tx scb_pkt[1:4][$]);
    $display("%0t \t\t\t Checker is run\n",$time);
    for (int j=1;j<5;j++) begin 
	int k=j;
	fork
	   while (scb_pkt[k].size!=0) get_packet(k,scb_pkt[k]);
	join_none
	#(7000000ns) disable fork;
    end
    $display("\t\t\t Checker is finish\n");
  endtask:Checker::run 

 task  Checker::wrap_up;
$display("\t\t\t Checker Wrap_Up\n");
  foreach (data_error[i]) begin 
	$display("\t Checker::Port[%0d]\t%0d Mismatch Response Out ",i,response_error[i]);
	$display("\t Checker::Port[%0d]\t%0d Mismatch Tag Out ",i,fault_tag[i]);
	$display("\t Checker::Port[%0d]\t%0d Mismatch Data_out",i,data_error[i]);
  end 

  foreach (receive_pkt[i]) begin 
 	receive_pkt[i]=null;
	expect_pkt[i]=null;
  end 
//Error_pkt_in=null;
//Error_pkt_out=null;

 endtask: Checker::wrap_up
endpackage
