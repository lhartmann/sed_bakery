module Every 
#(parameter period)
(input clk, input en, output y);
	logic [$clog2(period)-1:0] ctr;
	
	always_comb y = !ctr && en;
	
	always_ff @(posedge clk)
		if (en)
			ctr = !ctr ? period-1 : ctr-1;
	
endmodule
