module top;


parameter Test_Case =6;//Please enter the numbet of test case 


bit clk=1'b0;
always #50ns clk=~clk;


calc2_bus 	bus(.c_clk(clk));


generate 
if (Test_Case==1 ) test1		tb1(bus);
if (Test_Case==2 ) test2		tb1(bus);
if (Test_Case==3 ) test3		tb1(bus);
if (Test_Case==4 ) test4		tb1(bus);
if (Test_Case==5 ) test5		tb1(bus);
if (Test_Case==6 ) test6		tb1(bus);
if (Test_Case==7 ) test7		tb1(bus);
if (Test_Case==8 ) test8		tb1(bus);
if (Test_Case==9 ) test9		tb1(bus);
if (Test_Case==10) test10		tb1(bus);
if (Test_Case==11) test11		tb1(bus);
if (Test_Case==12) test12		tb1(bus);
if (Test_Case==13) test13		tb1(bus);
if (Test_Case==14) test14		tb1(bus);
if (Test_Case==15) test15		tb1(bus);
if (Test_Case==16) test16		tb1(bus);
if (Test_Case==17) test17		tb1(bus);
if (Test_Case==18) test18		tb1(bus);
endgenerate



calc2_top  d(
.out_data1(bus.data_out[1]),
.out_data2(bus. data_out[2]), 
.out_data3(bus. data_out[3]), 
.out_data4(bus. data_out[4]), 
.out_resp1(bus.resp_out[1]), 
.out_resp2(bus.resp_out[2]), 
.out_resp3(bus.resp_out[3]), 
.out_resp4(bus.resp_out[4]), 
.out_tag1(bus.tag_out[1]), 
.out_tag2(bus.tag_out[2]), 
.out_tag3(bus.tag_out[3]),
.out_tag4(bus.tag_out[4]), 
.scan_out(  ), 
.a_clk(), 
.b_clk( ), 
.c_clk(bus.c_clk ), 
.req1_cmd_in(bus.req_cmd_in[1]),
.req1_data_in(bus.req_data_in[1]),
.req1_tag_in(bus.req_tag_in[1]),
.req2_cmd_in(bus.req_cmd_in[2]),
.req2_data_in(bus.req_data_in[2]),
.req2_tag_in(bus.req_tag_in[2]),
.req3_cmd_in(bus.req_cmd_in[3]),
.req3_data_in(bus.req_data_in[3]),
.req3_tag_in(bus.req_tag_in[3]),
.req4_cmd_in(bus.req_cmd_in[4]),
.req4_data_in(bus.req_data_in[4]),
.req4_tag_in(bus.req_tag_in[4]),
 .reset(bus.reset),
.scan_in( ));

endmodule




