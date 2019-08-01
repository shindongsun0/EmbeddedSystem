//***************************************************
//Surf Behavioral Model by Donsun Sin 
//***************************************************
`timescale 1 ns/1 ns
`define A_WIDTH 17
`define D_WIDTH 16
`define COL 320
`define ROW 240
`define DetMSize 75516
`define XA_WIDTH 4
`define XD_WIDTH 32
`define YA_WIDTH 4
`define YD_WIDTH 32
`define XYA_WIDTH 5
`define XYD_WIDTH 32	

module CalcDeterminant(Go, I_Addr, I_Data, X_Addr, X_Data, Y_Addr, Y_Data, XY_Addr, XY_Data,
			D_Addr, I_RW, I_En, O_RW, O_En, Done, Surf_Out, Clk, Rst);
	input Go;
	input [(`D_WIDTH - 1) : 0] I_Data;
	output reg [(`A_WIDTH - 1) : 0] I_Addr, D_Addr;
	output reg I_RW, I_En, O_RW, O_En, Done;
	output reg [(`D_WIDTH-1) : 0] Surf_Out;
	input Clk, Rst;
	output reg [(`XA_WIDTH - 1) : 0] X_Addr, Y_Addr;
	output reg [(`XYA_WIDTH - 1) : 0] XY_Addr;
	input signed [(`XYD_WIDTH - 1) : 0] X_Data, Y_Data, XY_Data;
	

	reg [5:0] State;                                                                 
	//reg [(`D_WIDTH - 1) : 0] sum;
	integer I, J, K;
	integer dx;
	integer dy;
	integer dxy;

	parameter S0 = 6'b000_000, S1 = 6'b000_001,
	 	  S1b = 6'b000_010, S2 = 6'b000_011,
		  S3a = 6'b000_100, S3 = 6'b000_101,
		  S4a = 6'b000_110, S4 = 6'b000_111,
		  S5a = 6'b001_000, S5 = 6'b001_001,
		  S6a = 6'b001_010, S6 = 6'b001_011,
		  S7a = 6'b001_100, S7 = 6'b001_101,
		  S8a = 6'b001_110, S8 = 6'b001_111,
		  S9a = 6'b010_000, S9 = 6'b010_001,
		  S10a = 6'b010_010, S10 = 6'b010_011,
		  S11a = 6'b010_100, S11 = 6'b010_101,
		  S12a = 6'b010_110, S12 = 6'b010_111,
		  S13a = 6'b011_000, S13 = 6'b011_001,
		  S14a = 6'b011_010, S14 = 6'b011_011,
		  S15a = 6'b011_100, S15 = 6'b011_101,
		  S16a = 6'b011_110, S16 = 6'b011_111,
		  S17a = 6'b100_000, S17 = 6'b100_001, 
		  S18a = 6'b100_010, S18 = 6'b100_011, 
		  S19a = 6'b100_100, S19 = 6'b100_101, 
		  S20a = 6'b100_110, S20 = 6'b100_111,
		  S21a = 6'b101_000, S21 = 6'b101_001,
		  S22a = 6'b101_010, S22 = 6'b101_011,
		  S23a = 6'b101_100, S23 = 6'b101_101,
		  S24a = 6'b101_110, S24 = 6'b101_111,
		  S25a = 6'b110_000, S25 = 6'b110_001;

	integer size = 9;
	integer endi;
	integer endj;
	integer margin;
	integer layerStep = `COL;
	
	always @(posedge Clk) begin
		endi <= 1 + (`ROW - size);
		endj <= 1 + (`COL - size);
		margin <= size / 2;
		if (Rst == 1) begin
			I_Addr <= {`A_WIDTH{1'b0}};
			D_Addr <= {`A_WIDTH{1'b0}};
			X_Addr <= {`XA_WIDTH{1'b0}};
			Y_Addr <= {`YA_WIDTH{1'b0}};
			XY_Addr <= {`XYA_WIDTH{1'b0}};
			I_RW <= 1'b0; O_RW <= 1'b0;
			I_En <= 1'b0; O_En <= 1'b0;
			Done <= 1'b0;
			State <= S0;
			dx <= 0; dy <= 0; dxy <= 0;
			Surf_Out <= 16'b0;
			I <= 0; J <= 0; K <= 0;
		end
		else begin
			I_Addr <= {`A_WIDTH{1'b0}};
			D_Addr <= {`A_WIDTH{1'b0}};
			X_Addr <= {`XA_WIDTH{1'b0}};
			Y_Addr <= {`YA_WIDTH{1'b0}};
			XY_Addr <= {`XYA_WIDTH{1'b0}};
			I_RW <= 1'b0; O_RW <= 1'b0;
			I_En <= 1'b0; O_En <= 1'b1;
			Done <= 1'b0;
			Surf_Out <= 16'b0;
			
			case (State)
				S0: begin
					if (Go == 1'b1)begin
						State <= S1;
						I <= 0;
					end
					else
						State <= S0;
				end
				S1: begin
					J <= 0;
					State <= S1b;
				end
				S1b: begin
					K <= 0;
					dx <= 0; dy <= 0; dxy <= 0;
					State <= S2;
				end
				S2: begin
					if(K < 15) begin
						State <= S3a;
						X_Addr <= K;
						I_RW <= 1'b0;
						I_En <= 1'b1;
					end
					else begin
						XY_Addr <= K;
						I_RW <= 1'b0;
						I_En <= 1'b1;
						State <= S19a;
					end
				end
				S3a: begin
					State <= S3;
				end
				S3: begin
					I_Addr <= I * (`COL + 1) + J + X_Data; // I<= ADDRESS+ X[K]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					X_Addr <= K+3;
					State <= S4a;
				end
				S4a: begin
					State <= S4;
				end
				S4: begin
					//$display("%4x",dx);
					dx = dx + I_Data; //I_X[K]
					I_Addr <= I * (`COL + 1) + J + X_Data;  // I <= ADDRESS + X[K+3]
					X_Addr <= K + 1;
					I_RW <= 1'b0;
					I_En <= 1'b1;
					State <= S5a;
				end
				S5a: begin
					State <= S5;
				end
				S5: begin
					dx = dx + I_Data; // I_X[K+3]
					I_Addr <= I * (`COL + 1) + J + X_Data; // I <= ADDRESS + X[K+1]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					X_Addr <= K+2;
					State <= S6a;
				end
				S6a: begin
					State <= S6;
				end
				S6:begin
					dx = dx - I_Data; //I_X[K+1]
					I_Addr <= I * (`COL + 1) + J + X_Data; //I <= ADDRESS + X[K+2]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					X_Addr <= K+4;
					State <= S7a;
				end
				S7a:begin
					State <= S7;
				end
				S7: begin
					dx = dx - I_Data; // I_X[K+2]
					I_RW <= 1'b0; 
					I_En <= 1'b1;
					X_Addr <= K+4; //again
					Y_Addr <= K; 
					State <= S8a;
				end
				S8a: begin
					State <= S8;
				end
				S8: begin
					dx = dx * X_Data; // DX = DX * dx[k+4]
					I_Addr <= I * (`COL + 1) + J + Y_Data;
					I_RW <= 1'b0;
					I_En <= 1'b1;
					Y_Addr <= K+3;
					State <= S9a;
				end
				S9a: begin
					State <= S9;
				end
				S9: begin
					dy = dy + I_Data; //dy[k] 
					I_Addr <= I * (`COL + 1) + J + Y_Data; //DY[K+3]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					Y_Addr <= K+1;
					State <= S10a;
				end
				S10a: begin
					State <= S10;
				end
				S10: begin
					dy = dy + I_Data; // dy[k+3]
					I_Addr <= I * (`COL + 1) + J + Y_Data; //DY[K+1]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					Y_Addr <= K + 2;
					State <= S11a;
				end
				S11a: begin
					State <= S11;
				end
				S11: begin
					dy = dy - I_Data; // dy[k+1]
					I_Addr <= I * (`COL + 1) + J + Y_Data; //DY[K+2]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					Y_Addr <= K + 4;
					State <= S12a;
				end
				S12a: begin
					State <= S12;
				end
				S12: begin
					dy = dy - I_Data; // dy[k+2]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					Y_Addr <= K + 4; //again
					XY_Addr <= K;
					State <= S13a;
				end
				S13a: begin
					State <= S13;
				end	
				S13: begin
					dy = dy * Y_Data; // dy[k+4]
					I_Addr <= I * (`COL + 1) + J + XY_Data;  //DXY[K]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 3;
					State <= S14a;
				end
				S14a:
					State <= S14;
				S14: begin
					dxy = dxy + I_Data; //dxy[k]
					I_Addr <= I * (`COL + 1) + J + XY_Data;  //DXY[K+3]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 1;
					State <= S15a;
				end
				S15a:
					State <= S15;
				S15: begin
					dxy = dxy + I_Data; //dxy[k+3]
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+1]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 2;
					State <= S16a;
				end
				S16a:
					State <= S16;
				S16: begin
					dxy = dxy - I_Data; // dxy[k+1]
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+2]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 4;
					State <= S17a;
				end
				S17a: 
					State <= S17;	
				S17: begin
					dxy = dxy - I_Data; //dxy[k+2]
					XY_Addr <= K + 4;
					//I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+4]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					State <= S18a;
				end
				S18a:
					State <= S18;
				S18: begin
					dxy = dxy * XY_Data; //dxy[k+4]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					K <= K + 5;
					State <= S2;
				end
				S19a: begin
					State <= S19;
				end
				S19: begin
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 3;
					State <= S20a;
				end
				S20a: 
					State <= S20;
				S20: begin	
					dxy = dxy + I_Data; //dxy[k]
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+3]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 1;
					State <= S21a;
				end
				S21a: begin
					State <= S21;
				end
				S21: begin
					dxy = dxy + I_Data; //dxy[k + 3]
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+1]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 2;
					State <= S22a;
				end
				S22a: begin
					State <= S22;
				end
				S22: begin
					dxy = dxy - I_Data; //dxy[k + 1]
					I_Addr <= I * (`COL + 1) + J + XY_Data; //DXY[K+2]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 4;
					State <= S23a;
				end
				S23a: 
					State <= S23;
				S23: begin
					dxy = (dxy - I_Data); //dxy[k + 2] -> DXY[K+4]
					I_RW <= 1'b0;
					I_En <= 1'b1;
					XY_Addr <= K + 4;
					State <= S24a;
				end
				S24a: begin
					State <= S24;
				end
				S24: begin
					dxy = dxy * XY_Data;
					/*if(($signed(dx) * $signed(dy) - ($signed(dxy)* $signed(dxy)>> 1))< 0)
						Surf_Out <= signed dx * signed dy - (signed dxy* signed dxy >> 1) -1;
					else
						Surf_Out <= signed dx * signed dy - (signed dxy* signed dxy >> 1);*/
					State <= S25a;
				end
				S25a: begin
					Surf_Out <= dx * dy - ((dxy* dxy)/16'h0002);
					/*$display("dx: %x, dy: %x, dxy: %x", dx, dy, dxy); 	
					$display("%x - %x(%x) = %x", dx*dy, dxy*dxy,  (dxy*dxy /16'h0002), dx*dy - dxy*dxy/16'h0002);
					$display("surf_out: %x", dx*dy - (dxy*dxy/16'h0002)); 
					$display("surf_out2: %x", dx*dy - (dxy*dxy)); */
					D_Addr <= ((I + margin) * layerStep + margin + J);
					O_RW <= 1'b1;
					O_En <= 1'b1;
					
					J <= J + 1;
					if(J < endj) begin
						State <= S1b;
					end
					else
						State <= S25;	
				end
				S25: begin
					I <= I + 1;
					if(I < endi)
						State <= S1;
					else begin
						Done <= 1'b1;
						State <= S0;
					end
				end
				default: 
					State <= S0;
			endcase
		end
	end
endmodule

 