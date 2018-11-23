module FSM_control
#(
	parameter WORD_LENGTH = 8
)

(
	// Input Ports
	input clk,
	input reset,
	input start,
	
	output  error,
	output reg [1:0] Constant_control,
	output reg [1:0] M_S_I1_control,
	output reg [1:0] M_S_I0_control,
	output reg MS_control,
	output reg Acc0_en,
	output reg Acc1_en,
	output reg OR_en

);

//State machine states   ############FSM########
localparam IDLE = 0;
localparam XX = 1;
localparam A_XX = 2;
localparam A_X = 3;
localparam XX_SUM_X = 4;
localparam A0_SUM = 5;
localparam Output = 6;


reg [4:0]State ;


always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IDLE;
	else 
		case(State)
			IDLE:
				if(start)
					State <= XX;
				else
					State <= IDLE;
				
			XX:
				State <= A_XX;
			
			A_XX:
				State <= A_X;
	
			A_X:
				State <= XX_SUM_X;
				
			XX_SUM_X:
				State <= A0_SUM;
			
			A0_SUM:
				State <= Output;
				
			Output:
				State <= IDLE;
				
			default:
				State <= IDLE;
	endcase
end

always@(State) begin
	Constant_control = 2'b00;
	M_S_I1_control = 2'b00;
	M_S_I0_control = 2'b00;
	MS_control = 0;
	Acc0_en = 0;
	Acc1_en = 0;
	OR_en = 0;
		case(State)
			
			XX:
				begin
					M_S_I0_control = 2'b01;
					M_S_I1_control = 2'b00;
					MS_control = 0;
					Acc0_en = 1;
				end
			
			A_XX:
				begin
					Constant_control = 2'b10;
					M_S_I0_control = 2'b00;
					M_S_I1_control = 2'b01;
					MS_control = 0;
					Acc0_en = 1;
				end
			
			A_X:
				begin
					Constant_control = 2'b01;
					M_S_I0_control = 2'b00;
					M_S_I1_control = 2'b00;
					MS_control = 0;
					Acc1_en = 1;
				end
			
			XX_SUM_X:
				begin
					M_S_I0_control = 2'b10;
					M_S_I1_control = 2'b10;
					MS_control = 1;
					Acc0_en = 1;
				end
			
			A0_SUM:
				begin
					Constant_control = 2'b00;
					M_S_I0_control = 2'b00;
					M_S_I1_control = 2'b01;
					MS_control = 1;
					Acc0_en = 1;
				end
			
			Output:
				begin 
					OR_en = 1;
				end
			
			
			
			default:
				begin
					Constant_control = 2'b00;
					M_S_I1_control = 2'b00;
					M_S_I0_control = 2'b00;
					MS_control = 0;
					Acc0_en = 0;
					Acc1_en = 0;
					OR_en = 0;
				end
		endcase
end







endmodule