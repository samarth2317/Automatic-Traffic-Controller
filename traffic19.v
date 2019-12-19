`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:54 04/18/2019 
// Design Name: 
// Module Name:    traffic1 
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
module traffic19(clk, p_e1, p_e2, p_e3, p_e4, A, B, C, D, P1, P2, P3, P4);
input clk, p_e1, p_e2, p_e3, p_e4;
output reg [2:0] A, B, C, D;
output reg P1 = 1'b0, P2 = 1'b0, P3 = 1'b0, P4 = 1'b0;
reg [2:0] current_state = 000;
reg clk_1HZ = 0;			
reg flag1 = 1'b0, flag2 = 1'b0, flag3 = 1'b0, flag4 = 1'b0;
integer r;
integer counter_10msec;

always @(posedge clk) 						// Generating internal clock
begin
	if(counter_10msec == 500000) 
	begin
		clk_1HZ = ~ clk_1HZ;
		counter_10msec<=0;
	end
	else
	counter_10msec <= counter_10msec+1;
end

always @(posedge clk_1HZ) begin			// Using internal clock for FSM
case (current_state) 

3'b000 : 	begin	
					if (r == 250)	// machine will start after 5 sec and 111 will be for 3 sec
					begin
						r = 0;
						A = 3'b100; B = 3'b001; C = 3'b100; D = 3'b100; // A = R, B = G, C = R, D = R
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						
						if(flag2 == 1)
						begin
							P2 = 1'b1;
							flag2 = 1'b0;
						end
						else
							P2 = 1'b0;
						current_state <= 001;
					end
					else
					begin
						r = r + 1;
						if (p_e2 == 1)
							flag2 = 1'b1;
					end
				end

3'b001 : 	begin	
				if (r == 250)  // 000 will run for 5 seconds
				begin
					r = 0;
					A = 3'b001; B = 3'b001; C = 3'b100; D = 3'b100;	// A = G, B = G, C = R, D = R
					P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
					if(flag1 == 1 || flag2 == 1)
						begin
							P1 = 1'b1;
							P2 = 1'b1;
							flag1 = 1'b0;
							flag2 = 1'b0;
						end
						else
							P1 = 1'b0;
					current_state <= 010;
				end
				else
					begin
						r = r + 1;
						if (p_e1 == 1 || p_e2 == 1)
						begin
							P2 = 1'b1;
							flag1 = 1'b1; 
							flag2 = 1'b1;
						end
					end
				end

3'b010 : 	begin
					if (r == 350)	// 001 will be for 7 sec
					begin
						r = 0;
						A = 3'b001; B = 3'b010; C = 3'b100; D = 3'b100;	// A = G, B = Y, C = R, D = R
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
			
						if (flag1 == 1)
						begin
							P1 = 1'b1;
							flag1 = 1'b0;
						end
						else
							P1 = 1'b0;
						current_state <= 011;
					end
					else
					begin
						r = r + 1;
						if (p_e1 == 1 || p_e2 == 1)
						begin
							P1 = 1'b1; 
							flag1 = 1'b1;
							P2 = 1'b1;
						end
					end
				end

3'b011 : 	begin	
					if (r == 250)	// 010 will be for 5 sec
					begin
						r = 0;
						A = 3'b010; B = 3'b100; C = 3'b100; D = 3'b100;	// A = Y, B = R, C = R, D = R
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						current_state <= 100;
					end
					else 
					begin
						r = r + 1;
						if (p_e1 == 1)
							P1 = 1'b1;
					end
				end

3'b100 : 	begin	
					if ( r == 250)	// 011 will be for 5 sec
					begin
						r = 0;
						A = 3'b100; B = 3'b100; C = 3'b100; D = 3'b001;	// A = R, B = R, C = R, D = G
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						if (flag4 == 1)
						begin
							P4 = 1'b1;
							flag4 = 0;
						end
						current_state <= 101;
					end
					else 
					begin
						r = r + 1;
						if (p_e4 == 1)
							flag4 = 1'b1;
					end
				end

3'b101 : 	begin	
					if (r == 250)	// 100 will be for 5 sec
					begin
						r = 0;
						A = 3'b100; B = 3'b100; C = 3'b001; D = 3'b001;	// A = R, B = R, C = G, D = G
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						if (flag3 == 1 || flag4 == 1)
						begin
							P3 = 1'b1;
							P4 = 1'b1;
							flag3 = 0;
							flag4 = 0;
						end
						current_state <= 110;
					end
					else 
					begin	r = r + 1;
							if (p_e3 == 1 || p_e4 == 1)
							begin
								flag3 = 1'b1;
								P4 = 1'b1;
								flag4 = 1'b1;
							end
								
					end
				end

3'b110 : 	begin	
					if (r == 350)	// 101 will be for 7 sec
					begin
						r = 0;
						A = 3'b100; B = 3'b100; C = 3'b001; D = 3'b010;	// A = R, B = R, C = G, D = Y
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						if (flag3 == 1)
						begin
							P3 = 1'b1;
							flag3 = 0;
						end
						current_state <= 111;
					end
					else 
					begin
						r = r + 1;
						if (p_e3 == 1)
						begin
							P3 = 1'b1;
							flag3 = 1'b1;
						end
						else if (p_e4 == 1)
							P4 = 1'b1;
					end
				end

3'b111 : 	begin	
					if ( r == 250)	// 110 will be for 5 sec
					begin
						r = 0;
						A = 3'b100; B = 3'b100; C = 3'b010; D = 3'b100;	// A = R, B = R, C = Y, D = R
						P1 = 1'b0; P2 = 1'b0; P3 = 1'b0; P4 = 1'b0;
						current_state <= 000;
					end
					else 
					begin
						r = r + 1;
						if (p_e3 == 1)
							P3 = 1'b1;
					end
				end
				
endcase
end

endmodule 