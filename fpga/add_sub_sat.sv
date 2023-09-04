module add_sub_sat #(
	parameter N = 16
) (
	output logic [N-1:0] Y,
	input logic [N-1:0] X,
	input logic [N-1:0] ADD,
	input logic [N-1:0] SUB
);
	logic [N:0] TMP;
	
	assign TMP = X + ADD - SUB;
	
	assign Y = !TMP[N] ? TMP : ADD > SUB ? {N{1'b1}} : 0;
endmodule
