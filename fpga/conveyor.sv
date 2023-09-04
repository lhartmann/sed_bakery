module Conveyor
#(
	parameter len = 3
)(
	input logic clk,
	input  logic en,
	output [len-1:0] y
);
	// Conveyor
	always_ff @(posedge clk)
		if (en)
			y <= y << 1 | !y[1:0];
endmodule
