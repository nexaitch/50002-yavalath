//so far, we need
//ST LD AND SHL BEQ ADD + maybe C variants of SHL AND ADD

//can 4 bits instruction 3 bits ra 3 bits rb 6 bits c?

//i think the following 4 lines are not needed in modern C but for some reason i can't compile without those

#define GRID_SIZE 7

typedef short int16_t;
typedef short bool;
#define true 1
#define false 0

#if GRID_SIZE == 9

int16_t valid_squares[9] =
  {0b000011111,
   0b000111111,
   0b001111111,
   0b011111111,
   0b111111111,
   0b111111110,
   0b111111100,
   0b111111000,
   0b111110000};

#elif GRID_SIZE == 7

int16_t valid_squares[7] =
  {0b0001111,
   0b0011111,
   0b0111111,
   0b1111111,
   0b1111110,
   0b1111100,
   0b1111000
  };

#else

#error grid size not supported

#endif

int16_t player_0[GRID_SIZE], player_1[GRID_SIZE];
int16_t working[GRID_SIZE];

void reset(){
  int i = 0;
  while(i<GRID_SIZE){
    player_0[i]=0;
    player_1[i]=0;
    ++i;
  }
}

// probably want to inline this
int16_t is_in(int16_t row, int16_t col, int16_t* board){
  if(board[row] & 1<<col)
    return true;
  return false;
}

// returns 0 if square is invalid, else returns a non-zero number (not guaranteed to be 1)
int16_t is_valid(int16_t row, int16_t col){
  if(!row)
    return false;
  if(!col)
    return false;
  if(row==GRID_SIZE) // !(row-GRID_SIZE)
    return false;
  if(col==GRID_SIZE)
    return false;
  return is_in(row, col, valid_squares);
}

bool try_insert(int16_t row, int16_t col, int16_t* board){
  if(is_valid(row, col)){
    if(is_in(row, col, player_0)) return false;
    if(is_in(row, col, player_1)) return false;
    board[row] += 1<<col;
    return true;
  }
  return false;
}

// can and should probably inline this
void col2(int16_t* board){
  // precompute 2-in-a-row for each column
  int i = 0;
  while(i<GRID_SIZE-1){
    working[i] = board[i] & board[i+1];
    ++i;
  }
}

//in reality we'll probably only need to call col2 once

bool has_col_3_in_a_row(int16_t* board){
  int i = 0;
  col2(board);
  while (i<GRID_SIZE-2){
    if(working[i] & working[i+1]) return true;
    ++i;
  }
  return false;
}

bool has_col_4_in_a_row(int16_t* board){
  int i = 0;
  col2(board);
  while (i<GRID_SIZE-3){
    if(working[i] & working[i+2]) return true;
    ++i;
  }
  return false;
}

void row2(int16_t* board){
  //again, we can avoid SHLC by having 1 as a constant in memory
  int i = 0;
  while(i<GRID_SIZE){
    working[i] = board[i] & board[i]<<1;
    ++i;
  }
}

bool has_row_3_in_a_row(int16_t* board){
  int i = 0;
  row2(board);
  while(i<GRID_SIZE){
    if(working[i] & (working[i] << 1)) return true;
    ++i;
  }
  return false;
}

bool has_row_4_in_a_row(int16_t* board){
  int i = 0;
  row2(board);
  while(i<GRID_SIZE){
    if(working[i] & (working[i] << 2)) return true;
    ++i;
  }
  return false;
}

void diag2(int16_t* board){
  int i = 0;
  while(i<GRID_SIZE-1){
    working[i] = board[i+1] & board[i]<<1;
    ++i;
  }
}

bool has_diag_3_in_a_row(int16_t* board){
  int i = 0;
  diag2(board);
  while(i<GRID_SIZE-2){
    if(working[i+1] & (working[i] << 1)) return true;
    ++i;
  }
  return false;
}

bool has_diag_4_in_a_row(int16_t* board){
  int i = 0;
  diag2(board);
  while(i<GRID_SIZE-3){
    if(working[i+2] & (working[i] << 2)) return true;
    ++i;
  }
  return false;
}

/* from here on everything is for testing purposes only */
#include <stdio.h>

char get(int16_t row, int16_t col){
  if (is_in(row, col, player_0))
    return 'O';
  if (is_in(row, col, player_1))
    return 'X';
  if (!is_valid(row,col))
    return ' ';
  return '.';
}

void pretty_print(){

  printf("    %c %c %c %c %c\n", get(0,0), get(0,1), get(0,2), get(0,3), get(0,4));
  printf("   %c %c %c %c %c %c\n", get(1,0), get(1,1), get(1,2), get(1,3), get(1,4), get(1,5));
  printf("  %c %c %c %c %c %c %c\n", get(2,0), get(2,1), get(2,2), get(2,3), get(2,4), get(2,5), get(2,6));
  printf(" %c %c %c %c %c %c %c %c\n", get(3,0), get(3,1), get(3,2), get(3,3), get(3,4), get(3,5), get(3,6), get(3,7));
  printf("%c %c %c %c %c %c %c %c %c\n", get(4,0), get(4,1), get(4,2), get(4,3), get(4,4), get(4,5), get(4,6), get(4,7), get(4,8));
  printf(" %c %c %c %c %c %c %c %c\n", get(5,1), get(5,2), get(5,3), get(5,4), get(5,5), get(5,6), get(5,7), get(5,8));
  printf("  %c %c %c %c %c %c %c\n", get(6,2), get(6,3), get(6,4), get(6,5), get(6,6), get(6,7), get(6,8));
  printf("   %c %c %c %c %c %c\n", get(7,3), get(7,4), get(7,5), get(7,6), get(7,7), get(7,8));
  printf("    %c %c %c %c %c\n", get(8,4), get(8,5), get(8,6), get(8,7), get(8,8));
}

int main(int argc, char** argv){
  int player = 0;
  int16_t* board;
  int16_t row, col;
  bool valid;
  reset();
  pretty_print();
  while (1){
    valid = false;
    board = player_0;
    if(player) board = player_1;
    while(!valid){
      printf("Player %d enter move (row col): ", player);
      scanf("%hd %hd", &row, &col);
      valid = try_insert(row, col, board);
    }
    pretty_print();
    if (has_row_4_in_a_row(board)){
      printf("row 4, wins\n");
      return 0;
    }
    if (has_col_4_in_a_row(board)){
      printf("col 4, wins\n");
      return 0;
    }
    if (has_diag_4_in_a_row(board)){
      printf("diag 4, wins\n");
      return 0;
    }
    if (has_row_3_in_a_row(board)){
      printf("row 3, loses\n");
      return 0;
    }
    if (has_col_3_in_a_row(board)){
      printf("col 3, loses\n");
      return 0;
    }
    if (has_diag_3_in_a_row(board)){
      printf("diag 3, loses\n");
      return 0;
    }
    player = !player;
  }
}
