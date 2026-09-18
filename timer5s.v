`include "D_ff.v"
`include "D1_ff.v"

module timer5s(q,clk,rst);
  
  input clk,rst;
  output [2:0]q;
  
  assign w1=((~q[2])&~(q[1])&(~q[0]))|(q[2]&q[0]);
  assign w2=(q[2]&(~q[0]))|(q[1]&q[0]);
  assign w3=~q[0];
  
  D1_ff m0(clk,rst,w1,q[2]);
  D_ff m1(clk,rst,w2,q[1]);
  D1_ff m2(clk,rst,w3,q[0]);
  
endmodule

module tb_timer5s();
  
  reg clk,rst;
  wire [2:0]q;
  
  timer5s mm0(q,clk,rst);
  
  always
  begin
    #10 clk=~clk;
  end
  
  initial
  begin
    clk=0;rst=0;
    #10 rst=1;
    #10 rst=0;
    #400;
    $stop;
  end
  
endmodule
