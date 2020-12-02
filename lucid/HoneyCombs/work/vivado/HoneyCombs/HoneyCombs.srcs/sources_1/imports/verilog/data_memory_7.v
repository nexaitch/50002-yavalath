// Based on Alchitry's 2-port RAM. Read/write tested
// Modified to:
// - Include input-specific addresses (0,29) with input write/read interface

module data_memory_7 #(
    parameter SIZE = 16,                // Size of entry at each address
    parameter DEPTH = 64,                // Number of entries/address
    parameter JOYSTICK_ADDR = 0,        // Joystick input address
    parameter BUTTON_ADDR = 29,          // Button read address
    parameter PLAYER0_START = 1,        // Player 1 lowest read address
    parameter PLAYER1_START = 10,        // Player 2 lowest read address
    parameter SELECTED_START = 19,      // Selected lowest read address
    parameter TURN_ADDR = 28            // Turn read address
  )(
    input clk,                        // clock
  
    // regular write interface
    input [$clog2(DEPTH)-1:0] waddr,   // write address (of size log(DEPTH))
    input [SIZE-1:0] write_data,       // write data (of size SIZE)
    input write_en,                    // write enable (1 = write)
    
    // regular read interface
    input [$clog2(DEPTH)-1:0] raddr,   // read address (of size log(DEPTH))
    output [SIZE-1:0] read_data,    // read data (of size SIZE)
    
    // joystick input write interface
    input [SIZE-1:0] input0_write_data,
    input input0_write_en,
    
    // button input write interface
    input [SIZE-1:0] input1_write_data,
    input input1_write_en,
    
    // input read interface
    output [SIZE-1:0] input0_read_data,
    output [SIZE-1:0] input1_read_data,
    
    // player1 read interface
    output [(9*SIZE)-1:0] player0_read,
    
    // player2 read interface
    output [(9*SIZE)-1:0] player1_read,
    
    // selected read interface
    output [(9*SIZE)-1:0] selection_read,
    
    // turn read interface
    output [0:0] turn_read
    
    // debug read interface
    //output [SIZE-1:0] debug_read0,
    //output [SIZE-1:0] debug_read1,
    //output [SIZE-1:0] debug_read2,
    //output [SIZE-1:0] debug_read3
    
  );
  
  reg [SIZE-1:0] mem [DEPTH-1:0];      // memory array to store values
  
  // write clock domain
  always @(posedge clk) begin
    
    // Perform regular write (highest precedence)
    if (write_en) 
      mem[waddr] <= write_data;
      
    // Perform joystick input write only if joystick write is enabled and regular write isn't writing to joystick address
    if (input0_write_en && (!(write_en && (waddr==JOYSTICK_ADDR)))) 
      mem[JOYSTICK_ADDR] <= input0_write_data;
      
    // Perform button input write only if button write is enabled and regular write isn't writing to button address
    if (input1_write_en && (!(write_en && (waddr==BUTTON_ADDR)))) 
      mem[BUTTON_ADDR] <= input1_write_data;
      
  end
  
  assign read_data = mem[raddr];       // read memory directly from memory array (I suppose a mux is implemented in background)
  assign input0_read_data = mem[JOYSTICK_ADDR];     // read joystick input directly from memory array
  assign input1_read_data = mem[BUTTON_ADDR];      // read button input directly from memory array
  
  assign player0_read[(9*SIZE)-1:0] = {mem[PLAYER0_START+8],mem[PLAYER0_START+7],mem[PLAYER0_START+6],mem[PLAYER0_START+5],mem[PLAYER0_START+4],
                                        mem[PLAYER0_START+3],mem[PLAYER0_START+2],mem[PLAYER0_START+1],mem[PLAYER0_START]}; // Assign player 0 occupancy grid
  assign player1_read[(9*SIZE)-1:0] = {mem[PLAYER1_START+8],mem[PLAYER1_START+7],mem[PLAYER1_START+6],mem[PLAYER1_START+5],mem[PLAYER1_START+4],
                                        mem[PLAYER1_START+3],mem[PLAYER1_START+2],mem[PLAYER1_START+1],mem[PLAYER1_START]}; // Assign player 1 occupancy grid
  assign selection_read[(9*SIZE)-1:0] = {mem[SELECTED_START+8],mem[SELECTED_START+7],mem[SELECTED_START+6],mem[SELECTED_START+5],mem[SELECTED_START+4],
                                        mem[SELECTED_START+3],mem[SELECTED_START+2],mem[SELECTED_START+1],mem[SELECTED_START]}; // Assign selected grid
  assign turn_read = mem[TURN_ADDR][0]; // Assign turn read
  //assign debug_read0 = mem[22];
  //assign debug_read1 = mem[23];
  //assign debug_read2 = mem[24];
  //assign debug_read3 = mem[25];
  
  
endmodule