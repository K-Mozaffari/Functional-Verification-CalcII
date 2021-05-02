package GEN;
import PK::*;
class Generator;
//*****************
	bit[31:0] seed[1:4];

	Transaction_Tx blueprint[1:4];
	Transaction_Tx pkt[1:4];
	mailbox #(Transaction_Tx) mbx_gen2agt[1:4];
 bit [31:0] crt_pkt[1:4];// the number of pckets on each port 
 extern function new(mailbox #(Transaction_Tx ) mbx_gen2agt[1:4]);
 extern function void build;
 extern task gen_trans(bit [2:0] no_port,bit [31:0] no_pkt);
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


	task Generator:: gen_trans(bit [2:0] no_port,bit [31:0] no_pkt );
	
	 
		repeat (no_pkt) begin
				if (!(blueprint[no_port].randomize())) begin 
					$display("%s:%0d: Randomization failed \"%s\"", `__FILE__, `__LINE__, `"blueprint[no_port].randomize()`"); 
					$finish;
				end
				pkt[no_port]=blueprint[no_port].copy;
				mbx_gen2agt[no_port].put(pkt[no_port]);
				crt_pkt[no_port]++;
				$display (" Generator:\t\t\t %0dth packet is put on Mailbox[%0d]\n",crt_pkt[no_port],no_port);
				blueprint[no_port].print(1);
		end
	endtask:Generator::gen_trans 
	
 task Generator::run(bit [31:0] no_pkt);
 
    
    fork
	 
		gen_trans(1, no_pkt );
		gen_trans(2, no_pkt );
		gen_trans(3, no_pkt );
		gen_trans(4, no_pkt );		

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
