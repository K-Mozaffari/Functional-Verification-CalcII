
package SC;
import PK::*;
  class Scoreboard;

	Transaction_Tx r_pkt[1:4];
	Transaction_Tx e_pkt[1:4];
	mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4];
		bit[31:0]	s2drv_pkt[4];
	
	extern function new(mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4]);
	extern function void gen_expected_result( Transaction_Tx s);
	extern task run();
	//extern task wrap_up;

  endclass:Scoreboard
//==================================================================
 function Scoreboard::new(mailbox #(Transaction_Tx) mbx_agt2scb[1:4],mbx_scb2chk[1:4]);
this.mbx_agt2scb=mbx_agt2scb;
this.mbx_scb2chk=mbx_scb2chk;

endfunction 
task Scoreboard:: run();
 
 
    $display ("\t\t\t\t Scoreboard is run\n");
fork 
  
	begin
		forever begin 
			r_pkt[1]=new;
			mbx_agt2scb[1].get(r_pkt[1]);// receiving packts from generator block
			gen_expected_result(r_pkt[1]);
			e_pkt[1]=r_pkt[1].copy;
			mbx_scb2chk[1].put(e_pkt[1]);// put packet on mail box of driver
			s2drv_pkt[1]++;
		end;
	 end;
	 
	begin
		forever begin 
			r_pkt[2]=new;
			mbx_agt2scb[2].get(r_pkt[2]);// receiving packts from generator block
			gen_expected_result(r_pkt[2]);
			e_pkt[2]=r_pkt[2].copy;
			mbx_scb2chk[2].put(e_pkt[2]);// put packet on mail box of driver
			s2drv_pkt[2]++;
		end;
	 end;
	begin
		forever begin 
			r_pkt[3]=new;
			mbx_agt2scb[3].get(r_pkt[3]);// receiving packts from generator block
			gen_expected_result(r_pkt[3]);
			e_pkt[3]=r_pkt[3].copy;
			mbx_scb2chk[3].put(e_pkt[3]);// put packet on mail box of driver
			s2drv_pkt[3]++;
		end;
	 end;
	begin
		forever begin 
			r_pkt[4]=new;
			mbx_agt2scb[4].get(r_pkt[4]);// receiving packts from generator block
			gen_expected_result(r_pkt[4]);
			e_pkt[4]=r_pkt[4].copy;
			mbx_scb2chk[4].put(e_pkt[4]);// put packet on mail box of driver
			s2drv_pkt[4]++;
		end;
	 end;

  join
  

       $display ("\t\t\t\t Scoreboard finish");
$display("---------------------------------------------------------------------\n");
  endtask:Scoreboard:: run


 /*task  Scoreboard::wrap_up;
	$display("\t\t\t\tScoreboard Wrap_Up\n");
 	foreach (size[i])    $display("\t Scoreboard::Port[%0d] %0d packets were in Scoreboard ",i,size[i]);
	foreach (scb_pkt[i]) $display("\t Scoreboard::Port[%0d] %0d packets are  in Scoreboard ",i,scb_pkt[i].size);
	$display("---------------------------------------------------------------------\n");
 endtask: Scoreboard::wrap_up
*/
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