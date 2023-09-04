// X_* are control inputs.
// Y_* are control output.
// S_* are internal states, exposed for inspection.

module Bakery(
	input logic clk, en,
	
	input logic X_water, X_drain,
	
	input logic  X_flour, X_salt,
	output logic Y_flour, Y_salt,
	output logic Y_flour_remain, Y_salt_remain,
	
	input logic X_mixer, X_cover, X_pressurize,
	
	input logic X_dispenser, X_pan_conveyor,
	
	output logic Y_water_base, Y_water_middle, Y_water_top,
	output logic Y_pan, Y_pan_full,
	
	output logic [15:0] S_water,
	output logic [15:0] S_pressure,
	output logic [15:0] S_cover,
	output logic S_cover_closed, S_cover_leaky, S_cover_opened,
	
	output logic [3:0] S_mixed_flour,
	output logic [3:0] S_mixed_salt,
	
	output logic [15:0] S_pan_weight,
	output logic [3:0] S_pans,
	output logic [6:0] S_conveyor
);
	
	// Cover state interpretations and logic
	logic S_cover_fully_opened;
	Cover(.*);
	
	// Pressure interpretations and logic
	logic S_pressure_low, S_pressure_medium, S_pressure_high;
	Pressure(.*);
	
	// Water level and sensors
	logic S_water_base, dirty_water_base;
	Water(.Y_water_base(S_water_base), .*);
	assign Y_water_base = S_water_base || dirty_water_base;
	
	// Flour and salt feeder logic
	logic feed_flour, feed_salt;
	Feeder#(20,25,100)(clk, en, X_flour, Y_flour, Y_flour_remain, feed_flour);
	Feeder#(15,10,100)(clk, en, X_salt,  Y_salt,  Y_salt_remain,  feed_salt );
	
	// Clean logic
	logic [3:0] ds; // dirty state
	// 0 = empty, clean 
	// 1 = solid ingredients
	// 2 = unmixed ingredients
	// 3 = mixed pasta
	// 4 = empty, dirty
	// 5 = water, pre-wash
	// 6 = water, washed
	assign dirty_water_base = dirty_water_base && ds || ds > 1;
	
	// Mixture
	logic S_mixer_delayed;
	logic [3:0] S_mixer_ctr;

	always_ff @(posedge clk) if (en)
	begin
		// mixer delay logic
		S_mixer_ctr     <= X_mixer * (S_mixer_ctr + 1);
		S_mixer_delayed <= X_mixer * (&S_mixer_ctr || S_mixer_delayed);
	
		// State sequence
		ds <= (feed_flour || feed_salt) ? 1 : // ingredients at any time wil make the tank dirty
			ds == 1 && S_water            ? 2 :
			ds == 2 && S_mixer_delayed    ? 3 :
			ds == 3 && !S_water           ? 4 : 
			ds == 4 && Y_water_middle     ? 5 :
			ds == 5 && S_mixer_delayed    ? 6 :
			ds == 6 && !S_water           ? 0 : 
			ds;
	
		// Recipe logic
		S_mixed_flour <= |ds * S_mixed_flour + (S_cover_fully_opened && feed_flour && S_mixed_flour != 15);
		S_mixed_salt  <= |ds * S_mixed_salt  + (S_cover_fully_opened && feed_salt  && S_mixed_salt  != 15);
	end
	
	// banking pans and conveyor
	BakingPan(.*);	
endmodule
