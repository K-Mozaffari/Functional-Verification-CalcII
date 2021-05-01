
interface calc2_bus (input bit a_clk,b_clk,c_clk);

logic[1:4] [1:0]	resp_out;
logic [1:0]	tag_out[1:4];
logic [31:0]	data_out[1:4];
bit 	 	reset;
logic 		scan_in;
logic		scan_out;
bit[3:0] 	req_cmd_in[1:4];
bit [1:0] 	req_tag_in[1:4];
bit [31:0]	req_data_in[1:4];


modport DUV(output	
			resp_out,
			tag_out,
			data_out,
			scan_out,
	    input
			a_clk,
			b_clk,
			c_clk, 
			reset, 
			scan_in,
			
			req_cmd_in,
			req_tag_in,
			req_data_in);

clocking cb@(posedge c_clk);
output 
	reset, 
	scan_in,
	req_cmd_in,
	req_tag_in,
	req_data_in;
input 	resp_out,
			tag_out,
			data_out,
			scan_out;

endclocking 


modport TB(clocking cb, output reset);


  			
endinterface 


