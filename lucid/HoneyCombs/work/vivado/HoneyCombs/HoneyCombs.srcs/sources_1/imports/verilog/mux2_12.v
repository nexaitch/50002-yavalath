/*
   This file was generated automatically by Alchitry Labs version 1.2.1.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module mux2_12 (
    input inp0,
    input inp1,
    input s0,
    output reg out
  );
  
  
  
  always @* begin
    out = (inp0 & (~s0)) | (inp1 & s0);
  end
endmodule