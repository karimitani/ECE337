// $Id: $
// File name:   matrixgenerator.sv
// Created:     12/4/2017
// Author:      Karim Itani
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: generate matrix
module matrixgenerator
(
	input wire [3:0] bscalar,
	output reg [4:0] outx [0:2][0:2],
	output reg [4:0] outy [0:2][0:2]
);

	//reg brightscalar = {0,bscalar};
	reg [4:0] pixelx [0:2][0:2] = {{{5'b00001},{5'b00000},{5'b11111}},{{5'b00010},{5'b00000},{5'b11110}},{{5'b00001},{5'b00000},{5'b11111}}};
	reg [4:0] pixely [0:2][0:2] = {{{5'b00001},{5'b00010},{5'b00001}},{{5'b00000},{5'b00000},{5'b00000}},{{5'b11111},{5'b11110},{5'b11111}}};
	//integer i;
	//integer j;

	//always_comb
	//begin
	integer i ;
	integer j ;
		
		
	always_comb
	begin
		for (j = 0; j <= 2; j = j +1)
		begin
			
			if(pixelx[1][j][4] == 1'b0)
			begin	
				outx[1][j][3:0] = (pixelx[1][j][3:0]) *bscalar;
			end
			else begin
				outx[1][j][3:0] = (~pixelx[1][j][3:0] + 'b1) *bscalar;
			end
			outx[1][j][4] = pixelx[1][j][4];
			
		end
		
		outx[0][0:2] = pixelx[0][0:2];
		outx[2][0:2] = pixelx[2][0:2];
		
		// j = 2;
		for (i = 0; i <= 2; i = i +1)
		begin
			//j =2;
			if(pixely[i][1][4] == 1'b0)
			begin	
				outy[i][1][3:0] = pixely[i][1][3:0] * bscalar;
			end
			else begin
				outy[i][1][3:0] = (~pixely[i][1][3:0] + 'b1) * bscalar;
			end
			outy[i][1][4] = pixely[i][1][4];
			
		end
		outy[0][0] = pixely[0][0];
		outy[0][2] = pixely[0][2];
		outy[1][0] = pixely[1][0];
		outy[1][2] = pixely[1][2];
		outy[2][0] = pixely[2][0];
		outy[2][2] = pixely[2][2];
	end
endmodule
