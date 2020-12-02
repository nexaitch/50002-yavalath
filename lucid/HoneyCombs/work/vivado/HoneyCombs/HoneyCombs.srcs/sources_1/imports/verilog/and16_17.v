/*
   This file was generated automatically by Alchitry Labs version 1.2.1.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module and16_17 (
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] bool
  );
  
  
  
  wire [(5'h10+0)-1:0] M_bool_mux_out;
  reg [(5'h10+0)-1:0] M_bool_mux_s0;
  reg [(5'h10+0)-1:0] M_bool_mux_s1;
  
  genvar GEN_bool_mux0;
  generate
  for (GEN_bool_mux0=0;GEN_bool_mux0<5'h10;GEN_bool_mux0=GEN_bool_mux0+1) begin: bool_mux_gen_0
    mux4_18 bool_mux (
      .inp0(1'h0),
      .inp1(1'h0),
      .inp2(1'h0),
      .inp3(1'h1),
      .s0(M_bool_mux_s0[GEN_bool_mux0*(1)+(1)-1-:(1)]),
      .s1(M_bool_mux_s1[GEN_bool_mux0*(1)+(1)-1-:(1)]),
      .out(M_bool_mux_out[GEN_bool_mux0*(1)+(1)-1-:(1)])
    );
  end
  endgenerate
  
  always @* begin
    M_bool_mux_s0 = a;
    M_bool_mux_s1 = b;
    bool = M_bool_mux_out;
  end
endmodule
