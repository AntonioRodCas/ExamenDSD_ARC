module Mul_Sum
#(
	parameter WORD_LENGTH = 8
)

(
	// Input Ports
	input MS_control,
	input [WORD_LENGTH-1:0] input_0,
	input [WORD_LENGTH-1:0] input_1,
	
	output reg [WORD_LENGTH-1:0] Mul_Sum_Out

);


always@(input_0, input_1, MS_control) begin
	if(MS_control==0)
		Mul_Sum_Out = input_0 * input_1;
	else
		Mul_Sum_Out = input_0 + input_1;

end


endmodule