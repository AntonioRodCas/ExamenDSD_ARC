 /*********************************************************
 * Description:
 * This module is test bench file for testing the UART module
 *
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    25/10/18
 *
 **********************************************************/ 
 
 
 
module ExamenDSD_TB;

parameter WORD_LENGTH = 8;


reg clk_tb = 0;
reg reset_tb;
reg start_tb = 0;
reg [WORD_LENGTH-1:0] x_input_tb;



wire [WORD_LENGTH-1:0] y_output_tb;
wire error_tb;


ExamenDSD
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Examen_ints
(
	.clk(clk_tb),
	.reset(reset_tb),
	.start(start_tb),
	.x_input(x_input_tb),
	
	.error(error_tb),
	.y_output(y_output_tb)

);

/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
   #0 reset_tb = 0;
   #5 reset_tb = 1;
end

/*********************************************************/
initial begin // start 
	#0 reset_tb = 0;
   #10 start_tb = 1;
end


/*********************************************************/
initial begin // Transmit
	#0 x_input_tb = 0;
	#5 x_input_tb = 0;
end



endmodule