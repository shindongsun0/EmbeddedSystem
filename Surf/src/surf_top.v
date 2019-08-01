`timescale 1 ns/1 ns
`define A_WIDTH 17
`define D_WIDTH 16

module SURF_Top(Go_t, Done_t, Surf_Out_t, Rst_Core, MA_di_B, MB_di_B,
	       MA_di_A, MB_di_A, MA_do_B, MB_do_B, MA_Addr_A, MB_Addr_A,
	       MA_enb, MB_enb, MA_web, MB_web, Rst_M, Clk);
   
   //SAD_Core Interface 
   input Go_t;
   output Done_t;
   output [15:0] Surf_Out_t;
   input Rst_Core;
   
   //Dual-port SRAM Interface 
   input [63:0] MA_di_A, MB_di_B;
   input [15:0] MA_di_A, MB_di_B;  //dummy port, not used!
   output [63:0] MA_do_A, MB_do_B; //dummy port, not used!
   input [14:0] MA_Addr_A, MB_Addr_B;
   input MA_enb, MB_enb, MA_web, MB_web;
   input Rst_M;
   
   //Interface between SAD_Core and Dual_port SRAM
   wire [(`D_WIDTH-1):0] MA_do_A, MB_do_B;
   wire [(`A_WIDTH-1):0] MA_Addr_A, MB_Addr_B;
   wire M_ena, M_wea;
   
   //Common Interface 
   input Clk;
   
  
  /*Go, I_Addr, I_Data, X_Addr, X_Data, Y_Addr, Y_Data, XY_Addr, XY_Data,
			D_Addr, I_RW, I_En, O_RW, O_En, Done, Surf_Out, Clk, Rst*/
  CalcDeterminant CalcDeterminant_Core(Go_t, MA_Addr_A, MA_do,
               MB_Addr_B, MB_do_B, M_wea, M_ena, 
               Done_t, Surf_Out_t, Clk, Rst_Core);
   
   dp_sram_coregen SADMemA(
	MA_Addr_A, //MA_Addr8 == addra,
	MA_Addr_B,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MA_di_A,//MA_di8 == dina,
	MA_di_B, //MA_di31 == dinb,
	MA_do_A,//8douta,
	MA_do_B,//31doutb,
	M_ena,//ena,
	MA_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MA_web);//web);
   
   dp_sram_coregen SADMemB(
	MB_Addr_B,//addra,
	MB_Addr_B,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MB_di_A,//dina,
	MB_di_B,//dinb,
	MB_do_A,//douta,
	MB_do_B,//doutb,
	M_ena,//ena,
	MB_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MB_web);//web);

endmodule
