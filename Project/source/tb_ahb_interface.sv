// $Id: $
// File name:   tb_ahb_interface.sv
// Created:     12/11/2017
// Author:      Karim Itani
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for AHB Interface Block.
module tb_ahb_interface();

	// Define local constants
	localparam CHECK_DELAY	= 1ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_HCLK;
	reg tb_HRESETn;
	reg tb_HSEL;
	reg tb_HREADY;
	reg [31:0] tb_HADDR;
	reg [1:0] tb_HTRANS;
	reg tb_HWRITE;
	reg [2:0] tb_HSIZE;
	reg [67:0] tb_HWDATA;
	reg tb_HREADYOUT;
	reg [67:0] tb_HRDATA;
	reg tb_output_enable;
	reg [3:0] tb_output_pixel;
	reg [3:0][3:0][3:0] tb_pixels;
	reg tb_load_enable;
	reg [3:0] tb_brightness_value;

	
	// Declare Test Bench Variables
	integer test_num = 0;
	integer error_count = 0;
	reg expected_HREADYOUT;
	reg [3:0] [3:0] [3:0] expected_pixels;
	reg expected_load_enable;
	reg [3:0] expected_brightness_value;
	reg [67:0] expected_HRDATA;
	integer i;
	integer j;										// Loop variable for misc. for loops
	
	
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_HRESETn = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_HCLK);
		@(posedge tb_HCLK);
		
		// Release the reset
		@(negedge tb_HCLK);
		tb_HRESETn = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_HCLK);
	end
	endtask
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_HCLK = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_HCLK = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	// DUT portmap
	ahb_interface INT(
									.HCLK(tb_HCLK),
									.HRESETn(tb_HRESETn),
									.HSEL(tb_HSEL),
									.HADDR(tb_HADDR),
									.HTRANS(tb_HTRANS),
									.HWRITE(tb_HWRITE),
									.HSIZE(tb_HSIZE),
									.HWDATA(tb_HWDATA),
									.HREADY(tb_HREADY),
									.HREADYOUT(tb_HREADYOUT),
									.HRDATA(tb_HRDATA),
									.output_enable(tb_output_enable),
									.pixel(tb_output_pixel),
									.pixels(tb_pixels),
									.load_enable(tb_load_enable),
									.brightness_value(tb_brightness_value)
								);
		

	task check_outputs;
	begin
		#CHECK_DELAY
		if(tb_HWRITE) 
		begin
			if(expected_HREADYOUT == tb_HREADYOUT)
			begin
				$display("Test Case %d: Correct HREADYOUT of: %d", test_num, tb_HREADYOUT);
			end	
			else
			begin	
				$error("Test Case %d: Incorrect HREADYOUT of: %d Expected HREADYOUT of: %d", test_num, tb_HREADYOUT, expected_HREADYOUT);
				error_count = error_count + 1;
			end
	
			if(expected_pixels == tb_pixels)
			begin
				$display("Test Case %d: Correct pixels.", test_num);
			end
			else
			begin
				$error("Test Case %d: Incorrect pixels.", test_num);
				error_count = error_count + 1;
			end
	
			if(expected_load_enable == tb_load_enable)
			begin
				$display("Test Case %d: Correct load enable of: %d", test_num, tb_load_enable);
			end
			else
			begin
				$error("Test Case %d: Incorrect load_enable of: %d Expected load_enable of: %d", test_num, tb_load_enable, expected_load_enable);
				error_count = error_count + 1;
			end
	
			if(expected_brightness_value == tb_brightness_value)
			begin
				$display("Test Case %d: Correct brightness value of: %d", test_num, tb_brightness_value);
			end
			else
			begin
				$error("Test Case %d: Incorrect brightness value of: %d Expected brightness value of: %d", test_num, tb_brightness_value, expected_brightness_value);
				error_count = error_count + 1;
			end
		end
		else
		begin
			if(expected_HREADYOUT == tb_HREADYOUT)
			begin
				$display("Test Case %d: Correct HREADYOUT of: %d", test_num, tb_HREADYOUT);
			end	
			else
			begin	
				$error("Test Case %d: Incorrect HREADYOUT of: %d Expected HREADYOUT of: %d", test_num, tb_HREADYOUT, expected_HREADYOUT);
				error_count = error_count + 1;
			end
			if(expected_HRDATA == tb_HRDATA)	
			begin
				$display("Test Case %d: Correct HRDATA.", test_num);
			end
			else
			begin
				$error("Test Case %d: Incorrect HRDATA.", test_num);
				error_count = error_count + 1;
			end
		end
	end
	endtask	

	// Test bench process
	initial
	begin
		// Initial values
		tb_HRESETn = 1'b1;
		tb_HSEL = 1'b1;
		tb_HREADY = 1'b0;
		tb_HADDR = 32'd0;
		tb_HTRANS = 2'b10;
		tb_HWRITE = 1'b1;
		tb_HSIZE = 2'b00;
		tb_HWDATA = 68'd0;
		tb_output_enable = 1'b0;
		tb_output_pixel = 4'b0000;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the AHB Interface Block
		$display("Test Case 1: Output after reset");
		test_num = test_num + 1;
		reset_dut;
		expected_HREADYOUT = 1'b0;
		expected_pixels = 'b0;
		expected_load_enable = 1'b0;
		expected_brightness_value = 4'b0010;
		expected_HRDATA = 68'd0;
		check_outputs;

		// Test Case 2: Write event to the AHB Block
		$display("Test Case 2: Write Event");
		test_num = test_num + 1;
		reset_dut;
		tb_HWRITE = 1'b1;
		tb_HWDATA = 68'b00001111000011110000111100001111000011110000111100001111000011110110;
		tb_HREADY = 1'b1;
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		expected_HREADYOUT = 1'b1;
		expected_pixels[0][0] = 4'b0000;
		expected_pixels[0][1] = 4'b1111;
		expected_pixels[0][2] = 4'b0000;
		expected_pixels[0][3] = 4'b1111;
		expected_pixels[1][0] = 4'b0000;
		expected_pixels[1][1] = 4'b1111;
		expected_pixels[1][2] = 4'b0000;
		expected_pixels[1][3] = 4'b1111;
		expected_pixels[2][0] = 4'b0000;
		expected_pixels[2][1] = 4'b1111;
		expected_pixels[2][2] = 4'b0000;
		expected_pixels[2][3] = 4'b1111;
		expected_pixels[3][0] = 4'b0000;
		expected_pixels[3][1] = 4'b1111;
		expected_pixels[3][2] = 4'b0000;
		expected_pixels[3][3] = 4'b1111;
		expected_load_enable = 1'b1;
		expected_brightness_value = 4'b0110;
		check_outputs;

		// Test Case 3: Read with low output enable
		$display("Test Case 3: Read Event with Low Output Enable");
		test_num = test_num + 1;
		tb_HWRITE = 1'b0;
		reset_dut;
		tb_output_enable = 1'b0;
		tb_HREADY = 1'b1;
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		expected_load_enable = 1'b0;
		expected_HREADYOUT = 1'b0;
		expected_HRDATA = 'b0;
		check_outputs;

		// Test Case 4: Read with high output enable
		$display("Test Case 3: Read Event with High Output Enable");
		test_num = test_num + 1;
		tb_HREADY = 1'b0;
		reset_dut;
		tb_HWRITE = 1'b0;
		tb_output_enable = 1'b1;
		tb_output_pixel = 4'b0111;
		tb_HREADY = 1'b1;
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		expected_load_enable = 1'b0;
		expected_HREADYOUT = 1'b1;
		expected_HRDATA = {64'd0, 4'b0111};
		check_outputs;
	end
endmodule