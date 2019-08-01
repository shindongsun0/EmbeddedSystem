`timescale 1 ns/1 ns

module Mux_4x1_1bit_gate(I3, I2, I1, I0, S1, S0, D);

	input I3, I2, I1, I0;
	input S1, S0;
	output D;
	
	wire N1, N2, N3, N4, N5, N6;

	not Inv_0(N1, S0);
	not Inv_1(N2, S1);
	and And_1(N3, I0, S0, S1);
	and And_2(N4, I1, N1, S1);
	and And_3(N5, I2, S0, N2);
	and And_4(N6, I3, N1, N2);
	or Or_1(D, N3, N4, N5, N6);

endmodule
