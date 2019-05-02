// $Id: $
// File name:   tb_n_bitmultiplier.sv
// Created:     11/2/2017
// Author:      Karim Itani
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench.
// 
module tb_n_bitmultiplier
();
	// Define local parameters used by the test bench
	localparam NUM_INPUT_BITS			= 8;
	localparam NUM_OUTPUT_BITS		= 2*NUM_INPUT_BITS;
	localparam MAX_OUTPUT_BIT			= NUM_OUTPUT_BITS - 1;
	localparam NUM_TEST_BITS 			= NUM_INPUT_BITS * 2;
	localparam MAX_TEST_BIT				= NUM_TEST_BITS - 1;
	localparam NUM_TEST_CASES 		= 2 ** NUM_TEST_BITS;
	localparam MAX_TEST_VALUE 		= NUM_TEST_CASES - 1;
	localparam TEST_DELAY					= 10;
	
	// Declare Design Under Test (DUT) portmap signals
	wire	[(NUM_INPUT_BITS-1):0] tb_a;
	wire	[(NUM_INPUT_BITS-1):0] tb_b;
	wire	[MAX_OUTPUT_BIT:0] tb_product;
	
	// Declare test bench signals
	integer tb_test_case;
	reg [MAX_TEST_BIT:0] tb_test_inputs;
	reg [MAX_OUTPUT_BIT:0] tb_expected_outputs;
	reg [2*MAX_OUTPUT_BIT:0] tb_ext_expected_outputs;
	reg [2*(NUM_INPUT_BITS)-1:0] tb_ext_a;
	reg [2*(NUM_INPUT_BITS)-1:0] tb_ext_b;
	
	// DUT port map
	n_bitmultiplier #(NUM_INPUT_BITS) DUT(.a(tb_a), .b(tb_b), .product(tb_product));
	
	// Connect individual test input bits to a vector for easier testing
	assign tb_a					= tb_test_inputs[(NUM_INPUT_BITS-1):0];
	assign tb_b					= tb_test_inputs[MAX_TEST_BIT:NUM_INPUT_BITS];
	
	// Test bench process
	initial
	begin
		// Initialize test inputs for DUT
		tb_test_inputs = 0;
		
		// Interative Exhaustive Testing Loop
		for(tb_test_case = 0; tb_test_case < NUM_TEST_CASES; tb_test_case = tb_test_case + 1)
		begin
			// Send test input to the design
			tb_test_inputs = tb_test_case[MAX_TEST_BIT:0];
			
			// Wait for a bit to allow this process to catch up with assign statements triggered
			// by test input assignment above
			#1;
			
			// Calculate the expected outputs
			tb_ext_a = (tb_a[NUM_INPUT_BITS-1]) ? {{NUM_INPUT_BITS{1'b1}}, tb_a} : {{NUM_INPUT_BITS{1'b0}}, tb_a};
			tb_ext_b = (tb_b[NUM_INPUT_BITS-1]) ? {{NUM_INPUT_BITS{1'b1}}, tb_b} : {{NUM_INPUT_BITS{1'b0}}, tb_b};
			tb_ext_expected_outputs = tb_ext_a * tb_ext_b;
			tb_expected_outputs = tb_ext_expected_outputs[MAX_OUTPUT_BIT:0];
			
			// Wait for DUT to process the inputs
			#(TEST_DELAY - 1);
			
			// Check the DUT's Sum output value
			if(tb_expected_outputs == tb_product)
			begin
				$info("Correct Product value for test case %d!", tb_test_case);
			end
			else
			begin
				$error("Incorrect Product value for test case %d!", tb_test_case);
				$error("Expected: %d, Actual: %d", tb_expected_outputs, tb_product);
			end
		end
	end
	
	// Wrap-up process
	final
	begin
		if(NUM_TEST_CASES != tb_test_case)
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