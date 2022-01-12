module timer(clk_1,state,rst,time_shi,time_ge);//倒计时器
input clk_1,rst;
input [1:0] state;
output reg [3:0] time_shi,time_ge;

always@(posedge clk_1 or posedge rst)
begin
	if(rst)                              //复位，重新从40s开始倒计时
	begin
		time_shi<=4'b0100;
		time_ge<=4'b0000;
	end
	else if(state==2'b00)                //初始状态，时间保持40
	begin
		time_shi<=4'b0100;
		time_ge<=4'b0000;
	end
	else if(state==2'b01)					 //开始倒计时
	begin
		if(time_ge==0&&time_shi!=0)
		begin
			time_ge<=4'b1001;
			time_shi<=time_shi-1;
		end
		else if(time_ge==0&&time_shi==0)  //时间到，数字保持00不变
		begin
			time_ge<=time_ge;
			time_shi<=time_shi;
		end
		else time_ge<=time_ge-1;
	end
	else begin				//游戏成功、失败状态，倒计时保持当前数字不变
		time_ge<=time_ge;
		time_shi<=time_shi;
	end
end

endmodule
