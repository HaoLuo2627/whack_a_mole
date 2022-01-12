module getrandom(clk,rst,ran1,ran2);//生成随机数，clk接0.5Hz

	parameter MIN=2,MAX=5;           //随机数范围MIN~MAX

input clk,rst;
output [2:0] ran1,ran2;
wire ran_tmp0,ran_tmp1,ran_tmp2,ran_tmp3,ran_tmp4,ran_tmp5;
wire w,z;
wire y;

//移位寄存器组成的M序列发生器生成随机数
D_ff FF0(clk,rst,y,ran_tmp0);
D_ff FF1(clk,rst,ran_tmp0,ran_tmp1);
D_ff FF2(clk,rst,ran_tmp1,ran_tmp2);
D_ff FF3(clk,rst,ran_tmp2,ran_tmp3);
D_ff FF4(clk,rst,ran_tmp3,ran_tmp4);
D_ff FF5(clk,rst,ran_tmp4,ran_tmp5);
nor nr1(z,ran_tmp0,ran_tmp1,ran_tmp2,ran_tmp3,ran_tmp4,ran_tmp5);
xor xr1(w,ran_tmp0,ran_tmp5);
xor xr2(y,w,z);

assign ran1=2+{ran_tmp4,ran_tmp3}%(MAX-MIN+1);     //生成随机数的范围2~5
assign ran2=2+{ran_tmp1,ran_tmp0}%(MAX-MIN+1);

endmodule

module D_ff(clk,clr,D,Q);//D触发器
input clk,D,clr;         //D输入，clr复位
output reg Q;

always @(posedge clk)	//主模块下降沿触发，在有效边沿到来前提供稳定随机数
begin
	if(clr) Q<=1'b0;
	else Q<=D;
end

endmodule
