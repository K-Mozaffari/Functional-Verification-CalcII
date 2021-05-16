

program automatic test16(calc2_bus.TB bus);
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
	bit [3:0] 	old_cmd;
	bit [31:0]  old_op2=32'h8000000;
	bit [7:0] w_add=0,w_sub=0,w_shl=0,w_shr=0,w_invalid=0,w_nop=0;
	constraint cmd_dist {cmd dist {4'b0000:=w_nop, 4'b0001:=w_add,4'b0010:=w_sub,4'b0101:=w_shl,4'b0110:=w_shr,[3:4]:/w_invalid,[7:15]:/w_invalid};}
	constraint c_tag {req_tag_in inside {[1:3]};}
	
	constraint c_bb_shift {(old_cmd==5)->(cmd==6);(old_cmd==6)->(cmd==5);op2==old_op2;}
	
	function void  post_randomize;
		old_cmd=cmd;
		old_op2=op2+32'h8000000;
	 endfunction
endclass

 Environment env;
 my_trans newblueprint[1:4];


  initial begin 
  $display("###################### TEST CASE 16 ######################");
	 reset;

	 env=new(bus );
	 env.cfg.min_cfg=1 ;
	 env.cfg.max_cfg=50 ;
	 env.gen_cfg;
	 env.build;
//---------------------------------------------------------------------------------
  begin 
  
 
 	foreach (newblueprint[i]) newblueprint[i] =  new;

 	foreach (newblueprint[i])
		begin
			newblueprint[i].w_shl=50;
			newblueprint[i].w_shr=50;
			 
		end;
	foreach (newblueprint[i]) env.gen.blueprint[i]=newblueprint[i];

  end 
  //--------------------------------------------------------------------------------- 
  env.buffer_size=4;
    env.run;
    env.wrap_up;
 end
endprogram

