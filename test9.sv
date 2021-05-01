

program automatic test9(calc2_bus.TB bus);
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
  $display("###################### TEST CASE 9 ######################");
reset;
	 env=new(bus );
	 env.cfg.min_cfg=1 ;
	 env.cfg.max_cfg=20 ;
	  env.gen_cfg;
	 env.build;
//---------------------------------------------------------------------------------
  begin 
    env.gen.build;
//Test refrence number 10
    for (int i=1;i<5;i++) begin 
        	env.gen.blueprint[i].constraint_mode(0);
        	env.gen.blueprint[i].cmd_dist.constraint_mode(1);
        	env.gen.blueprint[i].req_tag_in.rand_mode(0);
        	env.gen.blueprint[i].req_tag_in=1;
        	env.gen.blueprint[i].c_delay.constraint_mode(1);
        	
		
		env.gen.blueprint[i].w_invalid=100;
		env.gen.blueprint[i].w_delay_insert=0;

					
		
	end



  end 
  env.buffer_size=1;
   env.run;
//--------------------------------------------------------------------------------- 
     env.wrap_up;
 end
endprogram

