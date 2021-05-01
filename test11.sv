

program automatic test11(calc2_bus.TB bus);
import ENV::*;
import CFG::*;
  Environment env;
task reset;
bus.reset=1'b1;
#300ns;
bus.reset=1'b0;
#2000ns;
endtask:reset

  initial begin 
  $display("###################### TEST CASE 11 ######################");
reset;
	 env=new(bus );
	 env.cfg.min_cfg=100 ;
	 env.cfg.max_cfg=1000 ;
	  env.gen_cfg;
	 env.build;
//---------------------------------------------------------------------------------
  begin 
    env.gen.build;
//Test refrence number 13
    for (int i=1;i<5;i++) begin 
        	env.gen.blueprint[i].constraint_mode(0);
        	env.gen.blueprint[i].cmd_dist.constraint_mode(1);
        	env.gen.blueprint[i].c_tag.constraint_mode(1);
        	env.gen.blueprint[i].c_delay.constraint_mode(1);
        	

 
		env.gen.blueprint[i].w_invalid=0;
		env.gen.blueprint[i].w_add=25;
		env.gen.blueprint[i].w_sub=25;
		env.gen.blueprint[i].w_shr=25;
		env.gen.blueprint[i].w_shl=25;
		env.gen.blueprint[i].w_delay_insert=0;
	
					
		
	end



  end 
  env.buffer_size=4;
   env.run;
//--------------------------------------------------------------------------------- 
     env.wrap_up;
 end
endprogram

