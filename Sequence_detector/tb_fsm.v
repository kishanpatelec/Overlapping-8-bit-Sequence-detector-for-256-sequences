`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Author: Kishankumar R. Patel
// Email ID: kishankumarpatel.ec@gmail.com
// Create Date:   18:43:21 08/17/2018
// Design Name:   seqdet
// Module Name:   tb_fsm
// Project Name:  FSM_of_sequence
// Target Device:  
// Description: Test the 8 bit general sequence detector using any 256 sequences and inputs.
//
// Verilog Test Fixture created by ISE for module: seqdet
//
// Dependencies: seqdet.v
// 
////////////////////////////////////////////////////////////////////////////////

module tb_fsm;

	// Inputs
	reg in_bit;
	reg clk;
	reg reset;
	reg [7:0] seq_in;
	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	seqdet uut (
					.in_bit(in_bit), 
					.clk(clk),
					.reset(reset),	 
					.seq_in(seq_in), 
					.out(out));




	initial begin
		// Initialize Inputs
		reset=1;
		in_bit = 0;
		clk = 0;
		seq_in=8'b01001101;
		// Wait 200 ns for global reset to finish
		#201
		reset=0;	// also detects last +ve edge thus taken 201ns



		// Add stimulus here
		
  		#17 in_bit=1;//also sense the input on +ve edge 
		#20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=1;
		#20 in_bit=0;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;
		
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;
      #20 in_bit=1;
		#20 in_bit=1;
      #20 in_bit=0;     
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=1;

		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=0;
      #20 in_bit=1;
		#20 in_bit=0;     //1
      #20 in_bit=1;
		#20 in_bit=1;
      #20 in_bit=0;     
		#20 in_bit=0;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;
      #20 in_bit=1;
      #20 in_bit=1;
		#20 in_bit=0;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;		//1

      #20 in_bit=1;
		#20 in_bit=1;
		#20 reset=1;
		
		seq_in=8'b01010010;
      #20 in_bit=0;
		#18 in_bit=0;
		#1 reset=0;
		
      #21 in_bit=1;
		#20 in_bit=0;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=1;
		#20 in_bit=0;
		
		
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;
      #20 in_bit=1;
		#20 in_bit=1;
      #20 in_bit=0;     
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=0;

		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=0;
      #20 in_bit=1;
		#20 in_bit=0;
      #20 in_bit=1;
		#20 in_bit=0;	     //1
      #20 in_bit=0;     
		#20 in_bit=1;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;			//1
      #20 in_bit=1;
      #20 in_bit=1;
		#20 in_bit=0;
      #20 in_bit=0;
		#20 in_bit=1;
      #20 in_bit=0;		


	end
	
	always begin 
	#1 clk=~clk;
	end
      
endmodule

