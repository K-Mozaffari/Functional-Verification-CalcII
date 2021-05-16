

program automatic test7(calc2_bus.TB bus);
import ENV::*;
import CFG::*;
import PK::*; 
task reset;
bus.reset=1'b1;
#300ns;
bus.reset=1'b0;
#2000ns;
endtask:reset


 class my_trans extends Transaction_Tx;

	
	constraint c_op1 {op1 inside {[1:32'hfffffffe]};}
 	constraint c_tag {req_tag_in inside {[1:3]};}
 

endclass

 Environment env;
 my_trans newblueprint[1:4];


  initial begin 
  $display("###################### TEST CASE 7 ######################");
	 reset;

	 env=new(bus );
	 env.cfg.min_cfg=1 ;
	 env.cfg.max_cfg=50 ;
	 env.gen_cfg;
	 env.build;
//---------------------------------------------------------------------------------
  begin 
  
 
 	foreach (newblueprint[i]) newblueprint[i] =  new;
	foreach (newblueprint[i]) begin 
		newblueprint[i].op2.rand_mode(0) ;
		newblueprint[i].cmd.rand_mode(0) ;
		newblueprint[i].delay_on.rand_mode(0);
		newblueprint[i].delay_on=0;
	 
	end;
	
	 newblueprint[1].op2=0;
	 newblueprint[1].cmd=4'b0101;//shift left
	 
	 newblueprint[2].op2=0;
	 newblueprint[2].cmd=4'b0110;//shift right
	 
	 newblueprint[3].op2=32'hFFFFFFFF;
	 newblueprint[3].cmd=4'b0101;//shift right
	 
	 newblueprint[4].op2=32'hFFFFFFFF;
	 newblueprint[4].cmd=4'b0110;//shift right

	foreach (newblueprint[i]) env.gen.blueprint[i]=newblueprint[i];

  end 
  //--------------------------------------------------------------------------------- 
    env.run;
    env.wrap_up;
 end

endprogram

