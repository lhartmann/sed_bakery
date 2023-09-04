module Water(
	input logic clk, en,
	
	input logic X_water, X_drain, X_dispenser, S_pressure_high,
	
	output logic Y_water_base, Y_water_middle, Y_water_top,
	output logic [15:0] S_water
);
	// Water Level sensors
	assign Y_water_base   = S_water >  1000;
	assign Y_water_middle = S_water > 20000;
	assign Y_water_top    = S_water > 50000;
	
	// Water Level Logic
	logic [15:0] S_water_next;
	add_sub_sat(S_water_next, S_water,
		1500 * (X_water && !S_pressure_high),
		1500 * (X_drain || X_dispenser && S_pressure_high)
	);
	always_ff @(posedge clk) 
		if (en)
			S_water = S_water_next;

endmodule
