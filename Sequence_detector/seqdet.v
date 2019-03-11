`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kishankumar R. Patel
// Email ID: kishankumarpatel.ec@gmail.com
// Create Date:    14:47:17 08/17/2018 
// Design Name: Generalized sequence detector of 8 bits
// Module Name:    seqdet
// Target Devices: 
// Tool versions: 
// Description: In this digital system 8 parallel inputs are making sequence if and only if reset is 1, 
//              then based on this sequence next state and ouput will be determined. 
//
//////////////////////////////////////////////////////////////////////////////////
module seqdet(

//***************************INPUT PORTS*************************************************************************************************
				input in_bit,					//1-bit input 
				input clk,				//clock frequency of FPGA board
				input reset,
				input [7:0] seq_in,
//***************************************************************************************************************************************

				
//***************************OUTPUT PORTS************************************************************************************************				
				output reg out);			//output of FSM
//***************************************************************************************************************************************
				

	reg [31:0] count;			//count clock pulses of main clock clk for frequency divider to gain new clock
	reg [3:0] i;				//variable for counting first 8 inputs
	reg [7:0] seq;				// 8 bit sequence user can change this by keep reset 1 at runtime and change the sequence
	reg new_clk;				//new clock for discretize user input in_bit 
	reg [3:0] p_state;		//present state of the FSM
	reg [3:0] n_state;		//next state of the FSM
							
	
	initial begin
		out=0;
		count = 0;
		seq=8'd0;
		new_clk=0;
		i=0;
		p_state=0;
		n_state=0;
	end

//***********function for assigning net type inputs to regs**********
	function [7:0] assign_seq;
		input [7:0] s_in;
		reg [3:0] j;
		begin
		for(j=0;j<8;j=j+1)
			assign_seq[j]= s_in[j] ? 1:0;		
		end	
	endfunction
//*******************************************************************


//***********************FREQUENCY DIVIDER*************************** 
	always @(posedge clk) begin				
		count= count+1;					//count clock cycles of on-board clock clk
		if(count==32'd5) begin	//when count clock cycles are passed	
			new_clk=~new_clk;				//1 new_clk clock pulse completes and alters its logic
			count=0;							//in order to count next clock cycles of on-board clock clk 
		end
	end
//*******************************************************************

	always @(posedge new_clk) begin
		p_state=n_state;
		
		if(reset==1) begin
			i=0;
			out=0;
			p_state=0;
			n_state=0;
			seq=assign_seq(seq_in);
		end	
		
			
		else begin  		// detector	
			case(p_state)
			
			//******detection for 0th bit of sequence****************************************************************************
				4'd0: begin
					out=0;
					
					//***********if desired bit comes then move to the next state*******************************
					
					if(seq[0]==in_bit)
						n_state=1;       //1
					
					//*******if undesired bit comes then move to the one state among previous states************
					
					else 
						n_state=0;
				end
			//*******************************************************************************************************************
				
			//******detection for 1st bit of sequence**************************************************************************** 	
				4'd1: begin
					out=0;
					
					//************if desired bit comes then move to the next state*******************************
					
					if(seq[1]==in_bit)
						n_state=4'd2;       
						
					//**********if undesired bit comes then move to the one state among previous states**********	
						
					else if (seq[0]==in_bit)    // if we have 
						n_state=1;
					else
						n_state=0;
				end
			//********************************************************************************************************************
			
			
			
			//******detection for 2nd bit of sequence*****************************************************************************
				4'd2: begin
					out=0;
					//*************if desired bit comes then move to the next states*****************************
					
					if(in_bit==seq[2])
						n_state=4'd3;
					
					//********if undesired bit comes then move to the one state among previous states************
					
					else if(in_bit==(seq[1]) && (seq[0]==seq[1])) 
						n_state=4'd2;
					else if(in_bit==seq[0])
						n_state=1;
					else
						n_state=0;
				end
			//********************************************************************************************************************
			
			
			
			
			//******detection for 3rd bit of sequence*****************************************************************************
				4'd3: begin
					out=0;
					//**************if desired bit comes then move to the next state*****************************
					if(in_bit==seq[3])
						n_state=4'd4;

					//******if undesired bit comes then move to the one state among previous states**************
					else if((in_bit==seq[2]) && (seq[1:0]==seq[2:1]))
						n_state=4'd3;
					else if((in_bit==seq[1]) && (seq[0]==seq[2]))
						n_state=4'd2;
					else if(in_bit==seq[0])
						n_state=1;
					else
						n_state=0;
				end
			//*********************************************************************************************************************
			
			
			
			
			//******detection for 4th bit of sequence******************************************************************************
				4'd4: begin
					out=0;
					//*********** if desired bit comes then move to the next state*******************************
					if(in_bit==seq[4])
						n_state=4'd5;		
						
					//**********if undesired bit comes then move to the one state among previous states**********
					else if((in_bit==seq[3]) && (seq[2:0]==seq[3:1])) 
						n_state=4'd4;
					else if((in_bit==seq[2]) && (seq[1:0]==seq[3:2]))
						n_state=4'd3;
					else if((in_bit==seq[1]) && (seq[0]==seq[3]))
						n_state=4'd2;
					else if(in_bit==seq[0])
						n_state=1;
					else
						n_state=0;
				end
			//*********************************************************************************************************************


			
			
			//******detection for 5th bit of sequence******************************************************************************

				4'd5: begin
					out=0;	

					//******************if undesired bit comes then move to the next state**************************

					if(in_bit==seq[5])
						n_state=4'd6;
						
					//**********if undesired bit comes then move to the one state among previous states**********	
					else if((in_bit==seq[4]) && ((seq[3:0])==(seq[4:1])))
						n_state=4'd5;
					else if((in_bit==seq[3]) && (seq[2:0]==seq[4:2]))
						n_state=4'd4;
					else if((in_bit==seq[2]) && (seq[1:0]==seq[4:3]))
						n_state=4'd3;
					else if((in_bit==seq[1]) && (seq[0]==seq[4]))
						n_state=4'd2;
					else if(in_bit==seq[0])
						n_state=1;
					else
						n_state=0;
				end
			//*********************************************************************************************************************
			
			
			
			
			
			//******detection for 6th bit of sequence******************************************************************************		
				4'd6: begin
					out=0;
					
					//*********** if desired bit comes then move to the next state*******************************
					
					if(in_bit==seq[6])
						n_state=4'd7;
					
					//**********if undesired bit comes then move to the one state among previous states**********
							
					else if((in_bit==seq[5]) && (seq[4:0]==seq[5:1])) 
						n_state=4'd6;
					else if((in_bit==seq[4]) && (seq[3:0]==seq[5:2]))
						n_state=4'd5;
					else if((in_bit==seq[3]) && (seq[2:0]==seq[5:3]))
						n_state=4'd4;
					else if((in_bit==seq[2]) && (seq[1:0]==seq[5:4]))
						n_state=4'd3;
					else if((in_bit==seq[1]) && (seq[0]==seq[5]))
						n_state=4'd2;
					else if(in_bit==seq[0])
						n_state=1;
					else
						n_state=0;
				end
			
			//*********************************************************************************************************************
			
			
			
			
			
			//******detection for 7th bit of sequence******************************************************************************

				4'd7: begin

					//*********** if desired bit comes then move to the next state*******************************	
				
					if((in_bit==seq[7]) && (in_bit==seq[6]) && (seq[5:0]==seq[6:1])) begin 
						n_state=4'd7;
						out=1; end
					if((in_bit==seq[7]) && (in_bit==seq[5]) && (seq[4:0]==seq[6:2])) begin
						n_state=4'd6;
						out=1; end
					else if((in_bit==seq[7]) && (in_bit==seq[4]) && (seq[3:0]==seq[6:3])) begin
						n_state=4'd5;
						out=1; end
					else if((in_bit==seq[7]) && (in_bit==seq[3]) && (seq[2:0]==seq[6:4])) begin
						n_state=4'd4;
						out=1; end
					else if((in_bit==seq[7]) && (in_bit==seq[2]) && (seq[1:0]==seq[6:5])) begin
						n_state=4'd3;
						out=1; end
					else if((in_bit==seq[7]) && (in_bit==seq[1]) && (seq[0]==seq[6])) begin
						n_state=4'd2;
						out=1; end
					else if((in_bit==seq[7]) && (in_bit==seq[0])) begin
						n_state=4'd1;
						out=1; end
					else if(in_bit==seq[7]) begin
						n_state=4'd0;
						out=1; end


					//**********if undesired bit comes then move to the one state among previous states**********		
					
					else if((in_bit==seq[6]) && (seq[5:0]^seq[6:1])) begin
						n_state=4'd7;
						out=0; end
					else if((in_bit==seq[5]) && (seq[4:0]^seq[6:2])) begin
						n_state=4'd6;
						out=0; end
					else if((in_bit==seq[4]) && (seq[3:0]^seq[6:3])) begin
						n_state=4'd5;
						out=0; end
					else if((in_bit==seq[3]) && (seq[2:0]^seq[6:4])) begin
						n_state=4'd4;
						out=0; end
					else if((in_bit==seq[2]) && (seq[1:0]^seq[6:5])) begin
						n_state=4'd3;
						out=0; end
					else if((in_bit==seq[1]) && (seq[0]^seq[6])) begin
						n_state=4'd2;
						out=0; end
					else if(in_bit==seq[0]) begin
						n_state=1;
						out=0; end
					else begin
						n_state=0;
						out=0; end
				end
				
			//*********************************************************************************************************************

			endcase
			
		end
	end
endmodule
