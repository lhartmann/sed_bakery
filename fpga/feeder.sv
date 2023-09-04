module Feeder
#(
	parameter period = 65536,
	parameter portions = 10,
	parameter refill = 100
)(
	input logic clk, en,
	input logic x,
	
	output logic revolution, remain, feed
);

	logic [$clog2(period  )-1 : 0] ctr;
	logic [$clog2(portions)-1 : 0] N_remain;
	logic [$clog2(refill  )-1 : 0] ref_delay;
	
	// Model the sensor on the feeding wheel
	assign revolution = ctr < period/2;
	
	// Model the  feeding wheel
	assign remain = |N_remain;
	
	// Models the portion drop
	assign feed = ctr == period*3/4 && N_remain && en;
	
	always_ff @(posedge clk) if (en)
	begin
		// Model the spinning feeder wheel
		ctr <= !x ? ctr-feed : !ctr ? period-1 : ctr-1;
		
		// Model remaining portions on the feeder
		N_remain <= !ref_delay ? portions : N_remain-feed;
		
		// Models refill delay (external user intervention)
		ref_delay <= N_remain ? refill-1 : ref_delay ? ref_delay-1 : 0;
	end

endmodule
