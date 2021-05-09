
package SC;
import PK::*;
  class Scoreboard;

	Transaction_Tx r_pkt[1:4];
	Transaction_Tx e_pkt[1:4];
	mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4];
		bit[31:0]	s2drv_pkt[4];
	
	extern function new(mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4]);
	extern function void gen_expected_result( Transaction_Tx s);
	extern task  exp_trans(bit[2:0] no_port,bit [31:0] no_pkt);
	extern task run(bit [31:0] no_pkt);
	extern task wrap_up;

  endclass:Scoreboard
//==================================================================
 function Scoreboard::new(mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4]);
this.mbx_agt2scb=mbx_agt2scb;
this.mbx_scb2chk=mbx_scb2chk;

endfunction 


task Scoreboard::exp_trans(bit[2:0] no_port,bit [31:0] no_pkt);
		repeat (no_pkt) begin 
			r_pkt[no_port]=new;
			mbx_agt2scb[no_port].get(r_pkt[no_port]);// receiving packts from generator block
			gen_expected_result(r_pkt[no_port]);
			e_pkt[no_port]=r_pkt[no_port].copy;
			mbx_scb2chk[no_port].put(e_pkt[no_port]);// put packet on mail box of driver
			s2drv_pkt[no_port]++;
		end ;
		
endtask:Scoreboard::exp_trans


task Scoreboard:: run(bit [31:0] no_pkt);
 
 
    $display ("\t\t\t\t Scoreboard is run\n");
	fork 
		exp_trans(1,no_pkt);
		exp_trans(2,no_pkt);
		exp_trans(3,no_pkt);
		exp_trans(4,no_pkt);
	join
	$display ("\t\t\t\t Scoreboard finish");
	$display("---------------------------------------------------------------------\n");
endtask:Scoreboard:: run


 task  Scoreboard::wrap_up;
	$display("\t\t\t\tScoreboard Wrap_Up\n");
 	foreach (mbx_scb2chk[i])    $display("\t Scoreboard::Port[%0d] %0d packets are remaied in Scoreboard mailbox ",i,mbx_scb2chk[i].num());

	$display("---------------------------------------------------------------------\n");
 endtask: Scoreboard::wrap_up

function void Scoreboard::gen_expected_result( Transaction_Tx s);

	  s.tag_out=s.req_tag_in;
          case(s.cmd)
           4'b0001 :
              begin
                
                if (longint '(s.op1 +s. op2)>32'hffffffff) begin 
               		s.resp_out = 2'b10;
			s.data_out=s.op1 +s. op2;
	       end
               else begin 
             	        s.resp_out = 2'b01;
	 		s.data_out=s.op1 +s. op2;
		end
	   end
          4'b0010 :
              begin
                if(s.op1 <s.op2)begin 
               		 s.resp_out=2'b10;
			 s.data_out=(s.op1 - s.op2);
		end
                else begin 
               		 s.resp_out=2'b01;
			 s.data_out=(s.op1 - s.op2);
			end
              end
	    4'b0101:  begin 	s.resp_out = 2'b01; 
				s.data_out=(s.op1 << s.op2[31:27]); end
            4'b0110: begin  	s.resp_out =2'b01;
				s.data_out=(s.op1 >> s.op2[31:27]);end
	
            4'b0000: begin 	s.resp_out = 2'b00;
				s.data_out=32'b0;  
		end
            default: begin 	s.resp_out = 2'b10;
				s.data_out=32'b0; 
		end
     endcase
  endfunction:Scoreboard::gen_expected_result

endpackage