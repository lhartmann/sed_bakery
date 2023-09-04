module Cover(
	input logic clk, en,
	
	input logic X_cover,
	input logic S_pressure_high,
	input logic S_pressure_medium,
	
	output logic [15:0] S_cover,
	output logic S_cover_closed,
	output logic S_cover_leaky,
	output logic S_cover_opened,
	output logic S_cover_fully_opened
);
	
	assign S_cover_closed       = S_cover[15:14] == 3;
	assign S_cover_leaky        = S_cover[15:14] == 2;
	assign S_cover_opened       = S_cover[15:14] <= 1;
	assign S_cover_fully_opened = S_cover[15:14] == 0;
	
	// Cover logic
	logic Xe_cover; // Effective action
	assign Xe_cover = S_pressure_high || S_cover_closed && S_pressure_medium ? 1 : X_cover;
	logic [15:0] S_cover_next;
	add_sub_sat(S_cover_next, S_cover,
		 Xe_cover * 2517,
		!Xe_cover * 2523
	);
	always_ff @(posedge clk) 
		if (en)
			S_cover = S_cover_next;
endmodule
