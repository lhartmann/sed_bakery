module Pressure(
	input logic clk, en,
	
	input logic X_pressurize, S_cover_leaky, S_cover_closed, S_cover_opened,
	
	output logic [15:0] S_pressure,
	output logic S_pressure_low, S_pressure_medium, S_pressure_high
);

	assign S_pressure_high   = S_pressure[15:14] == 3;
	assign S_pressure_medium = S_pressure[15:14] == 2;
	assign S_pressure_low    = S_pressure[15:14] <= 1;
	// Pressure Logic
	logic [15:0] S_pressure_next;
	add_sub_sat(S_pressure_next, S_pressure,
		2517 * ( X_pressurize && (S_cover_leaky && S_pressure_low || S_cover_closed)),
		2523 * (!X_pressurize || S_cover_leaky && S_pressure_high)
	);
	always_ff @(posedge clk) 
		if (en)
			S_pressure = S_cover_opened ? 0 : S_pressure_next;

endmodule
