/*
   This file was generated automatically by Alchitry Labs version 1.2.1.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

/*
   Parameters:
     GRID_SIZE = 9
     SPEED = 10
     BLINK_SPEED = 27
*/
module input_printer_11 (
    input clk,
    input [143:0] player0_occupancy,
    input [143:0] player1_occupancy,
    input [143:0] selection_occupancy,
    output reg [8:0] row,
    output reg [8:0] column0,
    output reg [8:0] column1
  );
  
  localparam GRID_SIZE = 4'h9;
  localparam SPEED = 4'ha;
  localparam BLINK_SPEED = 5'h1b;
  
  
  wire [1-1:0] M_slowclock_value;
  counter_23 slowclock (
    .rst(1'h0),
    .clk(clk),
    .value(M_slowclock_value)
  );
  
  wire [1-1:0] M_blink_slowclock_value;
  counter_24 blink_slowclock (
    .rst(1'h0),
    .clk(clk),
    .value(M_blink_slowclock_value)
  );
  
  reg [3:0] M_row_iterator_d, M_row_iterator_q = 1'h0;
  
  wire [(3'h4+0)-1:0] M_row_iterator_change_out;
  reg [(3'h4+0)-1:0] M_row_iterator_change_inp0;
  reg [(3'h4+0)-1:0] M_row_iterator_change_inp1;
  reg [(3'h4+0)-1:0] M_row_iterator_change_s0;
  
  genvar GEN_row_iterator_change0;
  generate
  for (GEN_row_iterator_change0=0;GEN_row_iterator_change0<3'h4;GEN_row_iterator_change0=GEN_row_iterator_change0+1) begin: row_iterator_change_gen_0
    mux2_12 row_iterator_change (
      .inp0(M_row_iterator_change_inp0[GEN_row_iterator_change0*(1)+(1)-1-:(1)]),
      .inp1(M_row_iterator_change_inp1[GEN_row_iterator_change0*(1)+(1)-1-:(1)]),
      .s0(M_row_iterator_change_s0[GEN_row_iterator_change0*(1)+(1)-1-:(1)]),
      .out(M_row_iterator_change_out[GEN_row_iterator_change0*(1)+(1)-1-:(1)])
    );
  end
  endgenerate
  
  wire [16-1:0] M_player0_occupancy_select_out;
  grid_selector_25 player0_occupancy_select (
    .select(M_row_iterator_q),
    .grid(player0_occupancy),
    .out(M_player0_occupancy_select_out)
  );
  
  wire [16-1:0] M_player1_occupancy_select_out;
  grid_selector_25 player1_occupancy_select (
    .select(M_row_iterator_q),
    .grid(player1_occupancy),
    .out(M_player1_occupancy_select_out)
  );
  
  wire [16-1:0] M_selection_occupancy_select_out;
  grid_selector_25 selection_occupancy_select (
    .select(M_row_iterator_q),
    .grid(selection_occupancy),
    .out(M_selection_occupancy_select_out)
  );
  
  always @* begin
    M_row_iterator_d = M_row_iterator_q;
    
    M_row_iterator_change_s0 = {3'h4{(~|(M_row_iterator_q ^ 5'h08))}};
    M_row_iterator_change_inp0 = M_row_iterator_q + 1'h1;
    M_row_iterator_change_inp1 = 4'h0;
    M_row_iterator_d = M_row_iterator_change_out;
    row = ~(1'h1 << M_row_iterator_q);
    column0 = M_player0_occupancy_select_out[0+8-:9] | (M_selection_occupancy_select_out[0+8-:9] & ({4'h9{M_blink_slowclock_value}}));
    column1 = M_player1_occupancy_select_out[0+8-:9] | (M_selection_occupancy_select_out[0+8-:9] & ({4'h9{M_blink_slowclock_value}}));
  end
  
  always @(posedge M_slowclock_value) begin
    M_row_iterator_q <= M_row_iterator_d;
  end
  
endmodule
