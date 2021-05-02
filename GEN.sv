package GEN;
import PK::*;
class Generator;
//*****************
	bit[31:0] seed[1:4];

	Transaction_Tx blueprint[1:4];
	mailbox #(Transaction_Tx) mbx_gen2agt[1:4];
 bit [31:0] crt_pkt[1:4];// the number of pckets on each port 
 extern function new(mailbox #(Transaction_Tx ) mbx_gen2agt[1:4]);
 extern function void build;
 extern task run(bit [31:0] no_pkt);
 extern task wrap_up;
endclass:Generator

//****************************************************************************/

 function Generator::new(mailbox #(Transaction_Tx) mbx_gen2agt[1:4]);
 	this.mbx_gen2agt=mbx_gen2agt;
  endfunction


function void Generator::build; //
bit [31:0] temp_global;
bit [31:0]  temp_seed;
	temp_global=$urandom(global_seed);
	foreach (seed[i]) seed[i]=$urandom_range(1000,0);
	foreach (blueprint[i]) temp_seed=$urandom(seed[i]);
	foreach (blueprint[i]) begin blueprint[i]=new;
end
endfunction:Generator::build

 task Generator::run(bit [31:0] no_pkt);
 
    Transaction_Tx pkt[1:4];
    fork
	begin 
		repeat (no_pkt) begin
				if (!(blueprint[1].randomize())) begin 
					$display("%s:%0d: Randomization failed \"%s\"", `__FILE__, `__LINE__, `"blueprint[1].randomize()`"); 
					$finish;
				end
				pkt[1]=blueprint[1].copy;
				mbx_gen2agt[1].put(pkt[1]);
				crt_pkt[1]++;
				$display (" Generator:\t\t\t %0dth packet is put on Mailbox[%0d]\n",crt_pkt[1],1);
				blueprint[1].print(1);
		end
	end 
	begin 
		repeat (no_pkt) begin
				if (!(blueprint[2].randomize())) begin 
					$display("%s:%0d: Randomization failed \"%s\"", `__FILE__, `__LINE__, `"blueprint[2].randomize()`"); 
					$finish;
				end
				pkt[2]=blueprint[2].copy;
				mbx_gen2agt[2].put(pkt[2]);
				crt_pkt[2]++;
				$display (" Generator:\t\t\t %0dth packet is put on Mailbox[%0d]\n",crt_pkt[2],2);
				blueprint[2].print(1);
		end
	end 
	begin 
		repeat (no_pkt) begin
				if (!(blueprint[3].randomize())) begin 
					$display("%s:%0d: Randomization failed \"%s\"", `__FILE__, `__LINE__, `"blueprint[3].randomize()`"); 
					$finish;
				end
				pkt[3]=blueprint[3].copy;
				mbx_gen2agt[3].put(pkt[3]);
				crt_pkt[3]++;
				$display (" Generator:\t\t\t %0dth packet is put on Mailbox[%0d]\n",crt_pkt[3],3);
				blueprint[3].print(3);
		end
	end 
	begin 
		repeat (no_pkt) begin
				if (!(blueprint[4].randomize())) begin 
					$display("%s:%0d: Randomization failed \"%s\"", `__FILE__, `__LINE__, `"blueprint[4].randomize()`"); 
					$finish;
				end
				pkt[4]=blueprint[4].copy;
				mbx_gen2agt[4].put(pkt[4]);
				crt_pkt[4]++;
				$display (" Generator:\t\t\t %0dth packet is put on Mailbox[%0d]\n",crt_pkt[4],4);
				blueprint[4].print(4);
		end
	end
    join
endtask:Generator::run

 task Generator::wrap_up;
	$display("\t\t\tGenereator Wrap_Up\n");
	$display( "t\tGenereator SEED Report\n");
	$display ("\nGlobal seed=%0d,\t seed_port[1]=%0d,\t seed_port[2]=%0d,\t seed_port[3]=%0d,\t seed_port[4]=%0d\n",global_seed,seed[1],seed[2],seed[3],seed[4]);
	$display("********************************************************************************************************************************");
    foreach (crt_pkt[i]) begin 
	$display("\t Generator:: Port[%0d]=%0d packets are produced ",i,crt_pkt[i]);
	crt_pkt[i]=0;
    end 
    foreach (mbx_gen2agt[i]) begin 
	if (mbx_gen2agt[i].num!=0) begin 
	$display("\t\t\t\t\t\t Fail ");
	$display("\t Generator:: Port [%0d] %0d packets is not send to MailBox ",mbx_gen2agt[i].num,i);
	 end else 
	$display("\t Generator::Port[%0d] Successful  ",i);
    end
	
  foreach (blueprint[i]) begin  blueprint[i]=null;end
    $display("---------------------------------------------------------------------\n");
 endtask:Generator::wrap_up
 

endpackage
