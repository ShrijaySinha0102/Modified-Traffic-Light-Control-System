`include "timer5s.v"
`include "timer10s.v"

module traffic_light(state,q1,q2,clk,rst,x,y);
  
  input clk,rst,x,y;
  reg rst1,rst2;
  output [3:0]q1;
  output [2:0]q2;
  output reg [1:0]state;
  reg h;
  
  //x- E-W red hai s0->s2
  //y- S-N red hai s2->s0
  parameter s0=2'b00; //for S-N green and E-W red
  parameter s1=2'b01; //for E-W yellow
  parameter s2=2'b10; //for S-N red and E-W green
  parameter s3=2'b11; //for S-N yellow
  
  timer10s m0(q1,clk,rst1);
  timer5s m1(q2,clk,rst2);
  
  always@(*)
  begin
    if(q1==4'b0000)
      h=1;
    else if(q2==3'b000)
      h=0;
  end
    
    always@(posedge clk or posedge rst)
    begin
      if(rst==1)
        begin
          state=s0;
          rst1=1;
          #1 rst1=0;
          rst2=1;
          h=0;
        end
      else
        case(state)
          s0:if(h==1 && x==0 && y==0)
            begin
              state=s1;
              rst1=1;
              rst2=0;
            end
              else if(x==1)
                begin
                  state=s2;
                  rst1=0;
                  rst2=1;
                end
              else if(y==1)
                begin
                  state=s0;
                  rst1=0;
                  rst2=1;
                end
          s1:if(h==0)
            begin
              state=s2;
              rst1=0;
              rst2=1;
            end
          s2:if(h==1 && x==0 && y==0)
            begin
              state=s3;
              rst1=1;
              rst2=0;
            end
              else if(y==1)
                begin
                  state=s0;
                  rst1=0;
                  rst2=1;
                end
                else if(x==1)
                begin
                  state=s2;
                  rst1=0;
                  rst2=1;
                end
          s3:if(h==0)
            begin
              state=s0;
              rst1=0;
              rst2=1;
            end
        endcase
    end
  
endmodule

module tb_traffic_light();
  
  reg clk,rst,x,y;
  wire [3:0]q1;
  wire [2:0]q2;
  wire [1:0]state;
  
  traffic_light mm0(state,q1,q2,clk,rst,x,y);
  
  always
  begin
    #10 clk=~clk;
  end
  
  initial
  begin
    clk=0;rst=0;x=0;y=0;
    #10 rst=1;
    #10 rst=0;
    #10 x=0;y=0;
    #100;
    #20 x=1;y=0;
    #100;
    #10 x=0;y=0;
    #1000;
    #20 x=1;y=0;
    #200;
    #20 x=0;y=1;
    #200;
    #10 x=0;y=0;
    #1000;
    $stop;
  end
  
endmodule



