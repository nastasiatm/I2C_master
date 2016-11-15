`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:04:23 11/15/2016 
// Design Name: 
// Module Name:    I2C_master 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module I2C_master(
	 input wire in_sw,
    input wire clk,
    inout wire sda,
    output wire slc
    );
	
	localparam IDLE = 0;
	localparam START = 1;
	localparam STOP = 2;
	localparam ADDR_DEV_W = 3;
	localparam WACK_ADDR_DEV_W = 4;
	localparam ADDR_REG = 5;
	localparam RESTART = 6;
	localparam ADDR_DEV_R = 7;
	localparam WACK_ADDR_DEV_R = 8;
	localparam READ_ID = 9;
	localparam READ_TEMP_VAL = 10;
	localparam NACK = 11;
	
	localparam ADDR_DEV					= 8'b01001011;
	localparam ADDR_ID_REG 				= 8'b00001011;
	localparam ADDR_TEMP_VALUE_REG 	= 8'b00000000;

	reg store[15:0];
	reg counter[3:0];
	reg state[3:0] = IDLE;
	reg sw[0];
	reg flag[0];
	
	always@(posedge clk) begin
		case(state)
			IDLE: begin
				sw <= in_sw;
				scl <= 1;
				sda <= 1;
				state <= START;
			end
			START: 	begin
				counter <= 7;
				store <= ADDR_DEV;
				state <= ADDR_DEV_W;
			end
			ADDR_DEV_W:	begin
				if (counter != 0) begin
					sda <= store[counter - 1];
					counter <= counter - 1;
				end else begin
					sda <= 0;
					state <= WACK_ADDR_DEV_W;
				end
			end
			WACK_ADDR_DEV_W:		begin
				if (sda == 0) begin
					state <= ADDR_REG;
					counter <= 7;
					if (sw == 0)
						store <= ADDR_ID_REG;
					else
						store <= ADDR_TEMP_VAL_REG;
				end else
					state <= START;
			end
			ADDR_REG:	begin
				sda <= store[counter];
				if (counter == 0)
					state <= WACK_ADDR_REG;
				else
					counter <= counter - 1;
			end
			WACK_ADDR_REG:		begin
				if (sda == 0) begin
					state <= RESTART;
				end else
					state <= START;
			end
			RESTART:		begin
				counter <= 7;
				state <= ADDR_DEV_R;
			end
			ADDR_DEV_R:	begin
			end
			WACK_ADDR_DEV_R:		begin
			end
			READ_ID:	begin
			end
			READ_TEMP_VAL:	begin
			end
			NACK:	begin
			end
			STOP: 	begin
			end
		endcase
	end
	
endmodule
