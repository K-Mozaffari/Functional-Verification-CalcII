package PK;
bit [31:0] global_seed=300;//$urandom_range(1000,0);

class Transaction_Tx;
	randc bit   [1:0 ] req_tag_in;
	rand  bit   [3:0 ] cmd;
	rand  bit [31:0] op1;
	rand  bit [31:0] op2;
	bit  [1:0] tag_out;
	bit  [1:0] resp_out;
	bit  [31:0]data_out;
	rand bit delay_on;
	bit [3:0] old_cmd;
	
	bit  [31:0]sum ;
	bit dif;
	//-------------------------------------------------------------
	bit [31:0] min_op1=1,max_op1=32'hfffffffe;
	bit [31:0] min_op2=1,max_op2=32'hfffffffe;
	bit [7:0] w_add=0,w_sub=0,w_shl=0,w_shr=0,w_invalid=0,w_nop=0;
	bit [7:0] w_delay_insert=30;
	//add=4'b0001,sub=4'b0010,shl=4'b0101,shr=4'b0110

 	constraint cmd_dist {cmd dist {4'b0000:=w_nop, 4'b0001:=w_add,4'b0010:=w_sub,4'b0101:=w_shl,4'b0110:=w_shr,[3:4]:/w_invalid,[7:15]:/w_invalid};}


	constraint c_op1 {op1 inside {[min_op1:max_op1]};}
	constraint c_op2 {op2 inside {[min_op2:max_op2]};}
	constraint c_tag {req_tag_in inside {[1:3]};}
	constraint c_delay {delay_on dist {1:=w_delay_insert,0:=100-w_delay_insert};}
	//--------------------------------------------------------------------------------------------
	
	
	constraint c_nou_flow {op1+op2<32'hFFFFFFFF;op1-op2>0;}
	constraint c_ou_flow {((cmd==4'b0001)->(op1+op2==sum));( (cmd==4'b0010&&dif==0)->(op1<op2));(cmd==4'b0010&&dif==1)->(op2-op1==1);}
	constraint c_eq_op {op1==op2;}
//---------------------------------------------------------------------------------------------------------17

constraint c_bb_ouflow {(old_cmd==1)->(cmd==2);(old_cmd==2)->(cmd==1);}
	//------------------------------------------------------------------------------------------------------------18
	bit [31:0] old_op2=32'h8000000;

	constraint c_bb_shift {(old_cmd==5)->(cmd==6);(old_cmd==6)->(cmd==5);op2==old_op2;}
	//-------------------------------------------------------------------------------------------------------------19

	constraint c_pipeline {(old_cmd==1)->(cmd==5);(old_cmd==2)->(cmd==6);  (old_cmd==5)-> (cmd==2); (old_cmd==6)->(cmd==1);}
	
	
	
	extern function void print(bit I_O);
	

	function Transaction_Tx copy;
		copy=new;
		copy.req_tag_in=req_tag_in;
		copy.cmd=cmd;
		copy.op1=op1;
		copy.op2=op2;
		copy.tag_out=tag_out;
		copy.resp_out=resp_out;
		copy.data_out=data_out;
		copy.delay_on=delay_on;
		
	endfunction
	
	extern function void post_randomize;
endclass:Transaction_Tx

class Transaction_Rx;
	bit [1:0] tag_out;
	bit [1:0] resp_out;
	bit [31:0]data_out;
	extern function void print ;
endclass:Transaction_Rx
 

  function void Transaction_Tx::print (bit I_O) ;
		if (I_O) $display("\t %0t :Operand_1 = %0h,\tOpernad_2=%0h,\t Command= %0d,\t tag=%0b\n ",$time,op1,op2,cmd,req_tag_in,);
		if (I_O==0)$display("\t %0t: tag_out= %0h,\t resp_out=%0h,\t data_out=%0h\n",$time,tag_out,resp_out,data_out);
  endfunction:Transaction_Tx::print 
  
  function void Transaction_Tx::post_randomize;
  old_cmd=cmd;
  old_op2=op2+32'h8000000;
  endfunction
 
 
  function void Transaction_Rx::print ;
	$display("tag_out= %0h,resp_out=%0h,data_out=%0h",tag_out,resp_out,data_out);
  endfunction:Transaction_Rx::print 





endpackage





