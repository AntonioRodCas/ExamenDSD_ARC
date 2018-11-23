module ExamenDSD
#(
	parameter WORD_LENGTH = 8
)

(
	// Input Ports
	input clk,
	input reset,
	input start,
	input [WORD_LENGTH-1:0] x_input,
	
	output  error,
	output [WORD_LENGTH-1:0] y_output

);

//---------------Internal signals-----------------------
wire [1:0] Constant_control;
wire [1:0] M_S_I1_control;
wire [1:0] M_S_I0_control;


wire [WORD_LENGTH-1:0] M_S_I0_MUX_I0;
wire [WORD_LENGTH-1:0] M_S_Input_0;
wire [WORD_LENGTH-1:0] M_S_Input_1;

wire [WORD_LENGTH-1:0] Mul_Sum_Out;

wire [WORD_LENGTH-1:0] Accum0;
wire [WORD_LENGTH-1:0] Accum1;

wire MS_control;

wire Acc0_en;
wire Acc1_en;

wire OR_en;
//-----------------------Instances-----------------------------------
Mux4to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Constant_MUX			            	//Constant_MUX
(
	.Selector(Constant_control),
	.MUX_Data0(8'b00000100),
	.MUX_Data1(8'b00000101),
	.MUX_Data2(8'b00000011),
	.MUX_Data3(8'b00000000),
	
	.MUX_Output(M_S_I0_MUX_I0)

);


Mux4to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
M_S_I0_MUX			            	//Mul_Sum_input0_MUX
(
	.Selector(M_S_I0_control),
	.MUX_Data0(M_S_I0_MUX_I0),
	.MUX_Data1(x_input),
	.MUX_Data2(Accum0),
	.MUX_Data3(8'b00000000),
	
	.MUX_Output(M_S_Input_0)

);

Mux4to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
M_S_I1_MUX				            	//Mul_Sum_input1_MUX
(
	.Selector(M_S_I1_control),
	.MUX_Data0(x_input),
	.MUX_Data1(Accum0),
	.MUX_Data2(Accum1),
	.MUX_Data3(8'b00000000),
	
	.MUX_Output(M_S_Input_1)

);

Mul_Sum
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Mul_Sum_Instance				            	//Mul_Sum_instance
(
	.MS_control(MS_control),
	.input_0(M_S_Input_0),
	.input_1(M_S_Input_1),
	
	.Mul_Sum_Out(Mul_Sum_Out)

);

//----------------------Accummulators and Output Register--------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Accum0_ints				            	//Accumulator 0
(
	.clk(clk),
	.reset(reset),
	.enable(Acc0_en),
	.Data_Input(Mul_Sum_Out),
	
	.Data_Output(Accum0)

);

Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Accum1_ints				            	//Accumulator 1
(
	.clk(clk),
	.reset(reset),
	.enable(Acc1_en),
	.Data_Input(Mul_Sum_Out),
	
	.Data_Output(Accum1)

);


Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Output_Reg				            	//Output Register
(
	.clk(clk),
	.reset(reset),
	.enable(OR_en),
	.Data_Input(Accum0),
	
	.Data_Output(y_output)

);

//-------------------Control FSM------------------------
FSM_control
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Control_FSM_inst			            	//Control FSM Instance
(
	.clk(clk),
	.reset(reset),
	.start(start),
	
	.error(error),
	.Constant_control(Constant_control),
	.M_S_I1_control(M_S_I1_control),
	.M_S_I0_control(M_S_I0_control),
	.MS_control(MS_control),
	.Acc0_en(Acc0_en),
	.Acc1_en(Acc1_en),
	.OR_en(OR_en)

);




endmodule