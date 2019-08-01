module Code_Detector(Start, Red, Green, Blue, Clk, Rst, U);
	input Start, Red, Green, Blue;
	output reg U;
	input Clk, Rst;
	
	parameter S_Wait = 3'b000, S_Start = 3'b001, S_Red1 = 3'b010, S_Blue = 3'b011, S_Green = 3'b100, S_Red2 = 3'b101;

	reg [2:0] State, StateNext;

// StateReg
	always @ (posedge Clk) begin
		if (Rst == 1)
			State <= S_Wait;
		else
			State <= StateNext;
	end

//ComLogic
	always @ (State, Start, Red, Green, Blue) begin
		case(State)
			//Wait_State
			S_Wait: begin
				U <= 0;
				//$display("Enter wait");
				if (Start == 1)
					StateNext <= S_Start;
					
				else 
					StateNext <= S_Wait;
			end
			//Start_State
			S_Start: begin
				//$display("Enter start");
				U <= 0;
				if(Red == 1 && Blue == 0 && Green == 0)
					StateNext <= S_Red1;
				else if (Blue == 1 || Green == 1)
					StateNext <= S_Wait;
			end
			//Red1_State
			S_Red1: begin
				U <= 0;
				//$display("Enter red1");
				if (Red == 0 && Blue == 1 && Green == 0)
					StateNext <= S_Blue;
				else if (Red == 1 || Green == 1)
					StateNext <= S_Wait;
			end
			//Blue_State
			S_Blue: begin
				//$display("Enter blue");
				U <= 0;
				if (Red == 0 && Blue == 0 && Green == 1)
					StateNext <= S_Green;
				else if (Red == 1 || Blue == 1)
					StateNext <= S_Wait;
			end
			//Green_State
			S_Green: begin
				//$display("Enter green");
				U <= 0;
				if (Red == 1 && Blue == 0 && Green == 0) 
					StateNext <= S_Red2;
					

				else if (Blue == 1 || Green == 1)
					StateNext <= S_Wait;
					
			end
			//Red2_State
			S_Red2: begin
				//$display("Enter red2");
				U <= 1;
				StateNext <= S_Wait;
			end
			//Default
			default: begin
				U <= 0;
				StateNext <= S_Wait;
			end
		endcase
	end
endmodule

			