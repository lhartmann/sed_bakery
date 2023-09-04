module top_level(
	inout logic AUD_ADCDAT,
	inout logic AUD_ADCLRCK,
	inout logic AUD_BCLK,
	inout logic AUD_DACDAT,
	inout logic AUD_DACLRCK,
	inout logic AUD_XCK,
	input logic CLOCK_27,
	input logic CLOCK_50,
	output logic [11:0] DRAM_ADDR,
	inout logic DRAM_BA_0,
	inout logic DRAM_BA_1,
	inout logic DRAM_CAS_N,
	inout logic DRAM_CKE,
	inout logic DRAM_CLK,
	inout logic DRAM_CS_N,
	inout logic [15:0] DRAM_DQ,
	inout logic DRAM_LDQM,
	inout logic DRAM_RAS_N,
	inout logic DRAM_UDQM,
	inout logic DRAM_WE_N,
	inout logic ENET_CLK,
	inout logic ENET_CMD,
	inout logic ENET_CS_N,
	inout logic [15:0] ENET_DATA,
	inout logic ENET_INT,
	inout logic ENET_RD_N,
	inout logic ENET_RST_N,
	inout logic ENET_WR_N,
	input logic EXT_CLOCK,
	inout logic [21:0] FL_ADDR,
	inout logic FL_CE_N,
	inout logic [7:0] FL_DQ,
	inout logic FL_OE_N,
	inout logic FL_RST_N,
	inout logic FL_WE_N,
	inout logic [35:0] GPIO_0,
	inout logic [35:0] GPIO_1,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5,
	output logic [6:0] HEX6,
	output logic [6:0] HEX7,
	inout logic I2C_SCLK,
	inout logic I2C_SDAT,
	input logic IRDA_RXD,
	output logic IRDA_TXD,
	input logic [3:0] KEY,
	inout logic LCD_BLON,
	inout logic [7:0] LCD_DATA,
	inout logic LCD_EN,
	inout logic LCD_ON,
	inout logic LCD_RS,
	inout logic LCD_RW,
	output logic [8:0] LEDG,
	output logic [17:0] LEDR,
	inout logic [1:0] OTG_ADDR,
	inout logic OTG_CS_N,
	inout logic OTG_DACK0_N,
	inout logic OTG_DACK1_N,
	inout logic [15:0] OTG_DATA,
	inout logic OTG_DREQ0,
	inout logic OTG_DREQ1,
	inout logic OTG_FSPEED,
	inout logic OTG_INT0,
	inout logic OTG_INT1,
	inout logic OTG_LSPEED,
	inout logic OTG_RD_N,
	inout logic OTG_RST_N,
	inout logic OTG_WR_N,
	inout logic PS2_CLK,
	inout logic PS2_DAT,
	inout logic SD_CLK,
	inout logic SD_CMD,
	inout logic SD_DAT,
	inout logic SD_DAT3,
	output logic [17:0] SRAM_ADDR,
	inout logic SRAM_CE_N,
	inout logic [15:0] SRAM_DQ,
	inout logic SRAM_LB_N,
	inout logic SRAM_OE_N,
	inout logic SRAM_UB_N,
	inout logic SRAM_WE_N,
	input logic [17:0] SW,
	inout logic TCK,
	inout logic TCS,
	inout logic [7:0] TD_DATA,
	inout logic TD_HS,
	inout logic TDI,
	inout logic TDO,
	inout logic TD_RESET,
	inout logic TD_VS,
	inout logic UART_RXD,
	output logic UART_TXD,
	output logic [9:0] VGA_B,
	output logic VGA_BLANK,
	output logic VGA_CLK,
	output logic [9:0] VGA_G,
	output logic VGA_HS,
	output logic [9:0] VGA_R,
	output logic VGA_SYNC,
	output logic VGA_VS
);

	// OpenPLC pin mapping
	// Inputs to OpenPLC/Raspberry Pi, outputs here.
	logic [7:0] IX0;
	assign GPIO_1[27] = IX0[0];
	assign GPIO_1[26] = IX0[1];
	assign GPIO_1[24] = IX0[2];
	assign GPIO_1[22] = IX0[3];
	assign GPIO_1[20] = IX0[4];
	assign GPIO_1[18] = IX0[5];
	assign GPIO_1[16] = IX0[6];
	assign GPIO_1[14] = IX0[7];
	
	logic [5:0] IX1;
	assign GPIO_1[12] = IX1[0];
	assign GPIO_1[ 8] = IX1[1];
	assign GPIO_1[ 6] = IX1[2];
	assign GPIO_1[ 4] = IX1[3];
	assign GPIO_1[ 2] = IX1[4];
	assign GPIO_1[ 0] = IX1[5];
	
	//Outputs from OpenPLC/Raspberry Pi, inputs here.
	logic [7:0] QX0;
	assign QX0[0] = GPIO_1[25];
	assign QX0[1] = GPIO_1[23];
	assign QX0[2] = GPIO_1[19];
	assign QX0[3] = GPIO_1[17];
	assign QX0[4] = GPIO_1[15];
	assign QX0[5] = GPIO_1[13];
	assign QX0[6] = GPIO_1[11];
	assign QX0[7] = GPIO_1[ 7];
	
	logic [2:0] QX1;
	assign QX1[0] = GPIO_1[ 5];
	assign QX1[1] = GPIO_1[ 3];
	assign QX1[2] = GPIO_1[ 1];
	
	// Analog PWM OpenPLC output, input here.
	logic QW0;
	assign QW0 = GPIO_1[21];
	
	// Rate limiters
	logic r1, r2, r10, r1k;
	Every#(50000)(CLOCK_50, 1,   r1k);
	Every#(  100)(CLOCK_50, r1k, r10);
	Every#(    5)(CLOCK_50, r10, r2 );
	Every#(    2)(CLOCK_50, r2,  r1 );
	
	// Togglers
	logic t1, t2, t10, t1k;
	always_ff @(posedge CLOCK_50) t1k ^= r1k;
	always_ff @(posedge CLOCK_50) t10 ^= r10;
	always_ff @(posedge CLOCK_50) t2  ^= r2;
	always_ff @(posedge CLOCK_50) t1  ^= r1;
	
	// Stimuli generators, for testing
	logic [15:0] stim;
	always_ff @(posedge CLOCK_50) 
		stim = stim == 600 ? 0 : stim + r10;
	
	// Internal signals and states
	logic X_water, X_mixer, X_drain, X_dispenser, X_pan_conveyor;
	logic X_cover, X_pressurize;
	logic X_flour, X_salt, Y_flour, Y_salt, Y_salt_remain, Y_flour_remain;
	logic Y_water_base, Y_water_middle, Y_water_top;
	logic S_cover_leaky, S_cover_closed, S_cover_opened;
	logic S_pressure_low, S_pressure_medium, S_pressure_high;
	logic [15:0] S_water;
	logic [15:0] S_cover;
	logic [15:0] S_pressure;

	logic Y_pan, Y_pan_full;
	logic [15:0] S_pan_weight;
	logic [3:0] S_pans;
	logic [6:0] S_conveyor;
	
	logic [3:0] S_mixed_flour;
	logic [3:0] S_mixed_salt;

	// Tests
	//`include "test_board.svi"
	// `include "test_mapping.svi"
	//`include "test_add_sub_sat.svi"
	//`include "test_water.svi"
	//`include "test_cover.svi"
	//`include "test_pressure.svi"
	//`include "test_feeder.svi"
	//`include "test_baking_pan.svi"
	
	// Test-input assignment: SW[0] enables manual mode.
	assign X_water        = SW[0] ? SW[17]  : QX0[0];
	assign X_drain        = SW[0] ? SW[16]  : QX0[1];
	assign X_cover        = SW[0] ? SW[15]  : QX0[2];
	assign X_pressurize   = SW[0] ? SW[14]  : QX0[3];
	assign X_mixer        = SW[0] ? SW[13]  : QX0[4];
	assign X_flour        = SW[0] ? !KEY[3] : QX1[2];
	assign X_salt         = SW[0] ? !KEY[2] : QX0[6];
	assign X_pan_conveyor = SW[0] ? !KEY[1] : QX1[1];
	assign X_dispenser    = SW[0] ? !KEY[0] : QX1[0];
	
	assign IX0[0] = Y_water_base;
	assign IX0[1] = Y_water_middle;
	assign IX0[2] = Y_water_top;
	assign IX0[3] = Y_flour;
	assign IX0[4] = Y_flour_remain;
	assign IX0[5] = Y_salt;
	assign IX1[2] = Y_salt_remain;
	assign IX1[1] = Y_pan;
	assign IX1[0] = Y_pan_full;
	
	assign LEDG[7] = X_salt;	
	assign LEDG[6] = Y_salt;
	assign LEDG[5] = Y_salt_remain;
	assign LEDG[4] = X_flour;
	assign LEDG[3] = Y_flour;
	assign LEDG[2] = Y_flour_remain;
	
	Bakery(.clk(CLOCK_50), .en(r10), .*);
	
	// Tank sensors vizulization
	assign HEX7 = ~( 7'b0001000 * Y_water_base
	               | 7'b0010100 * Y_water_middle
	               | 7'b1000000 * Y_water_top
	               | 7'b0000001 * S_cover_leaky
	               | 7'b0100011 * S_cover_closed
	               );
	               
	// Blender under the tank
	assign LEDR[17:16] = X_mixer << t10;
	
	// Tank pressure indicator
	d7s(1, S_pressure[15:12], HEX6);

	// Flour portions counter
	d7s(1, S_mixed_flour, HEX5);
	
	// Salt portions counter
	d7s(1, S_mixed_salt, HEX4);
	
	// Pans on the conveyor
	assign HEX3 = ~( 7'b0011100 * S_pans[3] 
	               | 7'b1000000 * Y_pan_full
	               | 7'b1000001 * (S_pan_weight >= 16384) // Spill
	               ); 
	assign HEX2 = ~(S_pans[2] ? 7'b0011100 : 0);
	assign HEX1 = ~(S_pans[1] ? 7'b0011100 : 0);
	assign HEX0 = ~(S_pans[0] ? 7'b0011100 : 0);
	
	// Roling conveyor
	assign LEDR[11:5] = S_conveyor;
endmodule
