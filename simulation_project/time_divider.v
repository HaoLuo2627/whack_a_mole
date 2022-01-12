module time_divider #(		//分频器
parameter N=2,
	WIDTH=8)
(
	input clk,
	input rst,
	output reg clk_out);		//N是分频比，WIDTH计数器位宽
reg [WIDTH-1:0] cnt;
always @(posedge clk or posedge rst)
begin
	if(rst) begin
		cnt<=0;
		clk_out<=0;
	end
	else if(cnt==(N>>1)-1)	    //偶分频，计数器计到N/2-1取反
	begin
		clk_out<=~clk_out;
		cnt<=0;
	end
	else cnt<=cnt+1;
end
endmodule
