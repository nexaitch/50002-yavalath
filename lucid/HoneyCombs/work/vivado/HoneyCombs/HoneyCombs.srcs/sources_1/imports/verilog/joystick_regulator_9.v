/*
   This file was generated automatically by Alchitry Labs version 1.2.1.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module joystick_regulator_9 (
    input [3:0] in,
    input [15:0] input_read,
    input clk,
    output reg write_en,
    output reg [15:0] out
  );
  
  
  
  wire [4-1:0] M_regulator_map_inp;
  wire [1-1:0] M_regulator_input_write_enable;
  wire [16-1:0] M_regulator_input_write_data;
  reg [4-1:0] M_regulator_inp;
  reg [16-1:0] M_regulator_map_out;
  reg [16-1:0] M_regulator_input_read;
  input_regulator_19 regulator (
    .clk(clk),
    .inp(M_regulator_inp),
    .map_out(M_regulator_map_out),
    .input_read(M_regulator_input_read),
    .map_inp(M_regulator_map_inp),
    .input_write_enable(M_regulator_input_write_enable),
    .input_write_data(M_regulator_input_write_data)
  );
  
  wire [16-1:0] M_mapper_map_out;
  reg [4-1:0] M_mapper_map_in;
  joystick_mapper_20 mapper (
    .map_in(M_mapper_map_in),
    .map_out(M_mapper_map_out)
  );
  
  always @* begin
    M_regulator_inp = in;
    M_mapper_map_in = M_regulator_map_inp;
    M_regulator_map_out = M_mapper_map_out;
    M_regulator_input_read = input_read;
    write_en = M_regulator_input_write_enable;
    out = M_regulator_input_write_data;
  end
endmodule