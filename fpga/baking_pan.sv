module BakingPan(
	input logic clk, en,

	input logic X_dispenser, X_pan_conveyor,
	output logic Y_pan, Y_pan_full,
	
	input logic S_pressure_high,
	input logic [15:0] S_water,
	
	output logic [15:0] S_pan_weight,
	output logic [3:0] S_pans,
	output logic [6:0] S_conveyor
);
	logic conveyor_step, pan_step;
	Every#( 3)(clk, en, conveyor_step);
	Every#(10)(clk, en, pan_step);
	
	// Pseudo random generator
	logic [15:0] prbs;
	initial prbs = 16'h1235;
	always_ff @(posedge clk) if(en)
		prbs = (prbs >> 1) ^ (16'hA001 * prbs[0]);
	
	// Randomize pans on conveyor
	always_ff @(posedge clk) if(pan_step && X_pan_conveyor)
		S_pans = (S_pans << 1) | (!S_pans[0] && !prbs[1:0]); // And add more pans 25% of the time.
	
	// Animate conveyor
	always_ff @(posedge clk) if(conveyor_step && X_pan_conveyor)
		S_conveyor = (S_conveyor << 1) | !S_conveyor[1:0]; // 1/3 lights up
	
	// Sensors:
	assign Y_pan = S_pans[3];
	assign Y_pan_full = S_pan_weight >= 8192;
	
	// Pressure Logic
	logic [15:0] S_pan_weight_next;
	add_sub_sat(S_pan_weight_next, S_pan_weight,
		1500 * (X_dispenser && S_pressure_high && S_water),
		0
	);
	always_ff @(posedge clk) 
		if (en)
			S_pan_weight = !Y_pan ? 0 : S_pan_weight_next;

endmodule
