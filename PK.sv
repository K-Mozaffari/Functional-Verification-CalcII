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
  

 
 
  function void Transaction_Rx::print ;
	$display("tag_out= %0h,resp_out=%0h,data_out=%0h",tag_out,resp_out,data_out);
  endfunction:Transaction_Rx::print 





endpackage





