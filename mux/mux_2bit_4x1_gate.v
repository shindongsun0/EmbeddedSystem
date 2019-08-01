`timescale 1 ns/1 ns

module Mux_4x1_2bit_gate (A1_s, A0_s, B1_s, B0_s, C1_s, C0_s, 
	                           D1_s, D0_s, S1_s, S0_s, Out1_gs, Out0_gs);

	input A1_s, A0_s;
	input B1_s, B0_s;
	input C1_s, C0_s;
	input D1_s, D0_s;
	input S1_s, S0_s;
	output Out1_gs, Out0_gs;
	
	Mux_4x1_1bit_gate Mux_4x1_1bit_gate_1 (A1_s, B1_s, C1_s, D1_s, S1_s, S0_s, Out1_gs);
	Mux_4x1_1bit_gate Mux_4x1_1bit_gate_0 (A0_s, B0_s, C0_s, D0_s, S1_s, S0_s, Out0_gs);
	
endmodule
