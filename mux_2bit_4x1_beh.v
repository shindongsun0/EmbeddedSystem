`timescale 1 ns/1 ns

module Mux_4x1_2bit_beh(A1_s, A0_s, B1_s, B0_s, C1_s, C0_s, D1_s, D0_s, S1_s, S0_s, Out1_bs, Out0_bs);
	
	input A1_s, A0_s, B1_s, B0_s, C1_s, C0_s, D1_s, D0_s;
	input S1_s, S0_s;
	output Out1_bs, Out0_bs;
	reg Out1_bs, Out0_bs;
	
	always @(A1_s, A0_s, B1_s, B0_s, C1_s, C0_s, D1_s, D0_s, S1_s, S0_s)
	begin
		if (S1_s == 0 && S0_s == 0)
		begin
			Out1_bs <= A1_s;
			Out0_bs <= A0_s;
		end
		else if (S1_s == 0 && S0_s == 1)
		begin
			Out1_bs <= B1_s;
			Out0_bs <= B0_s;
		end
		else if (S1_s == 1 && S0_s == 0)
		begin
			Out1_bs <= C1_s;
			Out0_bs <= C0_s;
		end
		else 
		begin
			Out1_bs <= D1_s;
			Out0_bs <= D0_s;
		end
	end
endmodule
