

program automatic test8(calc2_bus.TB bus);
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

	bit [7:0] w_add=0,w_sub=0,w_shl=0,w_shr=0,w_invalid=0,w_nop=0;
	constraint cmd_dist {cmd dist {4'b0000:=w_nop, 4'b0001:=w_add,4'b0010:=w_sub,4'b0101:=w_shl,4'b0110:=w_shr,[3:4]:/w_invalid,[7:15]:/w_invalid};}
 	constraint c_tag {req_tag_in inside {[1:3]};}
 

endclass
 Environment env;
 my_trans newblueprint[1:4];


  initial begin 
  $display("###################### TEST CASE 8 ######################");
	 reset;

	 env=new(bus );
	 env.cfg.min_cfg=20 ;
	 env.cfg.max_cfg=50 ;
	 env.gen_cfg;
	 env.build;
//---------------------------------------------------------------------------------
  begin 
  
 
 	foreach (newblueprint[i]) newblueprint[i] =  new;
	
	foreach(newblueprint[i]) begin 
	newblueprint[i].delay_on.rand_mode(0);
	newblueprint[i].delay_on=0;
	end;
		newblueprint[1].op1.rand_mode(0) ;
		newblueprint[1].op2.rand_mode(0) ;
		newblueprint[1].op1=0 ;
		newblueprint[1].op2=0 ;
		newblueprint[1].w_add=25;
		newblueprint[1].w_sub=25;
		newblueprint[1].w_shl=25;
		newblueprint[1].w_shr=25;
		
		newblueprint[2].op1.rand_mode(0) ;
		newblueprint[2].op2.rand_mode(0) ;
		newblueprint[2].op1=0 ;
		newblueprint[2].op2=0 ;
		
		newblueprint[2].w_add=25;
		newblueprint[2].w_sub=25;
		newblueprint[2].w_shl=25;
		newblueprint[2].w_shr=25;
		
		newblueprint[3].w_nop=100;
		
		newblueprint[4].w_nop=100;

	foreach (newblueprint[i]) env.gen.blueprint[i]=newblueprint[i];

  end 
  //--------------------------------------------------------------------------------- 
  env.buffer_size=1;
    env.run;
    env.wrap_up;
 end


endprogram

