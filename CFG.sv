package CFG;
  class Config;
// Unsigned integer indicating the # of transactions to generate
	rand bit [31:0] run_for_n_trans;
	bit [31:0] min_cfg=1000;
	bit [31:0] max_cfg=1000;
// Constrain the # of transactions from 1 to 1000
	constraint reasonable {run_for_n_trans inside {[min_cfg:max_cfg]};}
	function void post_randomize;
	$display ("CONFIG::\t\tThe number of transactions=%0d",run_for_n_trans);
	endfunction
  endclass:Config
endpackage
