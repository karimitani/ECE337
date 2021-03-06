// $Id: $
// File name:   bit_select.sv
// Created:     11/30/2017
// Author:      Karim Itani
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Bit Select FSM for X and Y Convolution Blocks

module x_bit_select
(
	input wire clk,
	input wire n_rst,
	input wire calc_enable,
	input wire [2:0][2:0][3:0] pixels,
	input wire [2:0][2:0][4:0] filter,
	output reg [4:0] a,
	output reg [4:0] b,
	output reg calc_done
);
	typedef enum bit [3:0] {IDLE, Gx1, Gx2, Gx3, Gx4, Gx5, Gx6, DONE1, DONE2} stateType;
	stateType state;
	stateType nxt_state;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			state <= IDLE;
		end
		else
		begin
			state <= nxt_state;
		end
	end

	always_comb
	begin
		nxt_state = state;
		
		if(state == IDLE)
		begin
			if(calc_enable == 1'b1)
			begin
				nxt_state = Gx1;
			end
		end
		else if (state == Gx1)
		begin
			nxt_state = Gx2;
		end
		else if (state == Gx2)
		begin
			nxt_state = Gx3;
		end
		else if (state == Gx3)
		begin
			nxt_state = Gx4;
		end
		else if (state == Gx4)
		begin
			nxt_state = Gx5;
		end
		else if (state == Gx5)
		begin
			nxt_state = Gx6;
		end
		else if (state == Gx6)
		begin
			nxt_state = DONE1;
		end
		else if (state == DONE1)
		begin
			nxt_state = DONE2;
		end
		else if (state == DONE2)
		begin
			nxt_state = IDLE;
		end
	end

	always_comb
	begin
		a = 4'b000;
		b = 4'b000;
		calc_done = 1'b0;

		if(state == Gx1)
		begin
			a = filter[0][2];
			b = {1'b0, pixels[0][0]};
		end
		else if(state == Gx2)
		begin
			a = filter[1][2];
			b = {1'b0, pixels[0][1]};
		end
		else if(state == Gx3)
		begin
			a = filter[2][2];
			b = {1'b0, pixels[0][2]};
		end
		else if(state == Gx4)
		begin
			a = filter[0][0];
			b = {1'b0, pixels[2][0]};
		end
		else if(state == Gx5)
		begin
			a = filter[1][0];
			b = {1'b0, pixels[2][1]};
		end
		else if(state == Gx6)
		begin
			a = filter[2][0];
			b = {1'b0, pixels[2][2]};
		end
		else if(state == DONE2)
		begin
			calc_done = 1'b1;
		end
	end

endmodule;