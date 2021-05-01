
package SC;
import PK::*;
  class Scoreboard;

	Transaction_Tx scb_pkt[1:4][$] ;

	logic[31:0]size[1:4];		
	extern function void gen_expected_result( Transaction_Tx s);
	extern task run(ref  Transaction_Tx scb_pkt[1:4][$]);
	extern task wrap_up;

  endclass:Scoreboard
//==================================================================

task Scoreboard:: run(ref Transaction_Tx scb_pkt[1:4][$] );
    this.scb_pkt=scb_pkt;
    foreach (scb_pkt[i]) size[i]=scb_pkt[i].size;
    $display ("\t\t\t\t Scoreboard is run\n");
    foreach (scb_pkt[i,j]) begin 
		gen_expected_result(scb_pkt[i][j]);
		$display("Scoreboard\t\t\t %0dth packet port[%0d]",j+1,i);		
		scb_pkt[i][j].print(1);
		$display("\t Expected result");
		scb_pkt[i][j].print(0);
	end 

       $display ("\t\t\t\t Scoreboard finish");
$display("---------------------------------------------------------------------\n");
  endtask:Scoreboard:: run


 task  Scoreboard::wrap_up;
	$display("\t\t\t\tScoreboard Wrap_Up\n");
 	foreach (size[i])    $display("\t Scoreboard::Port[%0d] %0d packets were in Scoreboard ",i,size[i]);
	foreach (scb_pkt[i]) $display("\t Scoreboard::Port[%0d] %0d packets are  in Scoreboard ",i,scb_pkt[i].size);
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