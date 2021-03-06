// $Id: $
// File name:   tb_matrixgenerator.sv
// Created:     12/4/2017
// Author:      Karim Itani
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: tbmatrix
`timescale 1ns / 100ps
module tb_matrixgenerator();

	// Define local parameters used by the test bench
	localparam NUM_INPUT_BITS			= 4;
	localparam NUM_OUTPUT_BITS		= 2*NUM_INPUT_BITS;
	localparam MAX_OUTPUT_BIT			= NUM_OUTPUT_BITS - 1;
	localparam NUM_TEST_BITS 			= NUM_INPUT_BITS * 2;
	localparam MAX_TEST_BIT				= NUM_TEST_BITS - 1;
	localparam NUM_TEST_CASES 		= 2 ** NUM_TEST_BITS;
	localparam MAX_TEST_VALUE 		= NUM_TEST_CASES - 1;
	localparam TEST_DELAY					= 1ns;
	
	// Declare Design Under Test (DUT) portmap signals
	wire	[3:0] bscalar;
	wire	[2:0][2:0][4:0] x;
	wire	[2:0][2:0][4:0] y;
	// Declare test bench signals
	integer tb_test_case = 1;
	byte tb_initial;
	wire [3:0] tb_test_inputs;
	wire [4:0] expected_pos;
	wire [4:0] expected_neg;
	
	assign tb_test_inputs = tb_test_case[3:0];
	assign bscalar = tb_test_inputs;
	assign expected_pos = {1'b0, bscalar};
	assign expected_neg = (~{1'b0, bscalar}) + 1'b1;
	// DUT port map
	matrixgenerator DUT(.bscalar(bscalar), .outx(x), .outy(y));
	
	initial
		begin
			// Interative Exhaustive Testing Loop
			for(tb_test_case = 1; tb_test_case < 8; tb_test_case = tb_test_case + 1)
			begin
				// Wait for a bit to allow this process to catch up with assign statements triggered
				// by test input assignment above
				#1;
				
				// Calculate the expected outputs
				
				// Wait for DUT to process the inputs
				#(TEST_DELAY);
				
				// Check the DUT's Sum output value
				if(x[1][0] == expected_pos && x[1][2] == expected_neg)
				begin
					$info("Correct Product value for xtest case %d!", tb_test_case);
				end
				else
				begin
					$error("Incorrect Product value for test case %d!", tb_test_case);
					$error("Expected: %d, Actual: %d", expected_pos, x[1][0]);
					$error("Expected: %d, Actual: %d", expected_neg, x[1][2]);
				end

				if(y[0][1] == expected_pos && y[2][1] ==expected_neg)
				begin
					$info("Correct Product value for ytest case %d!", tb_test_case);
				end
				else
				begin
					$error("Incorrect Product value for ytest case %d!", tb_test_case);
					$error("Expected: %d, Actual: %d", expected_pos, y[0][1]);
					$error("Expected: %d, Actual: %d", expected_neg, y[2][1]);
				end
			end
		end
	final
	
	begin
		if(tb_test_case != 16)
		begin
			// Didn't run the test bench through all test cases
			$display("This test bench was not run long enough to execute all test cases. Please run this test bench for at least a total of %d ns", (NUM_TEST_CASES * TEST_DELAY));
		end
		else
		begin
			// Test bench was run to completion
			$display("This test bench has run to completion");
		end
	end
endmodule
