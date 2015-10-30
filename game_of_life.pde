
// GOD CONSTANTS
int CELL_SIZE = 10;
int WINDOW_SIZE_X = 800;
int WINDOW_SIZE_Y = 600;
int CELLS_NUM_X = WINDOW_SIZE_X / CELL_SIZE;
int CELLS_NUM_Y = WINDOW_SIZE_Y / CELL_SIZE;

Cell[][] cellsGrid;
Cell[][] nextCellsGrid;

void setup() {
  size(800, 600);
  
  // current iteration of grid
  cellsGrid = new Cell[CELLS_NUM_X][CELLS_NUM_Y];
  createCells();
  // next iteration of grid
  nextCellsGrid = new Cell[CELLS_NUM_X][CELLS_NUM_Y];
  // TODO: make it better
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      nextCellsGrid[i][j] = new Cell(i, j, false);
    }
  }
}

void draw() {
  background(255);
  
  //drawGrid();
  drawCells();
  solveGrid();
  
  cellsGrid = nextCellsGrid; // switch the grid to the new iteration
  
}

void solveGrid() {
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      int liveNeighs = calculateLiveNeighbours(i, j);
      boolean currentStatus = cellsGrid[i][j].status;
      boolean newStatus = solveCell(currentStatus, liveNeighs);
      nextCellsGrid[i][j].status = newStatus;
    }
  }
}

int calculateLiveNeighbours(int i, int j) {
  
  int num = 0;
  for (int l = j - 1; l <= j + 1; l++) {
    for (int k = i - 1; k <= i + 1; k++) {
      if (k == i && l == j) continue; // skip the current cell
      
      if (k < 0 || l < 0) continue; // boundary condition
      if (k >= CELLS_NUM_X || l >= CELLS_NUM_Y) continue; // boundary condition
      
      if (cellsGrid[k][l].status) {
        num += 1;
      }
    }
  }
  
  return num;
}

boolean solveCell(boolean currentStatus, int liveNeighboursNum) {
  if (currentStatus) { // cell is alive
    if (liveNeighboursNum < 2) return false; // under-population... dies
    if (liveNeighboursNum > 3) return false; // over-population... dies
    return true; // 2 or 3 live neighbours...lives
  } else { // cell is dead
    if (liveNeighboursNum == 3) return true; // reproduction...alive
    return false; // ...stays dead
  }
}

void createCells() {
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      //cellsGrid[i][j] = new Cell(i, j, false);
      cellsGrid[i][j] = new Cell(i, j, ((int)random(2)) == 1 );
    }
  }
}

void drawCells() {
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      cellsGrid[i][j].drawCell();
    }
  }
}

void drawGrid() {
  
  stroke(200);
  for (int i = 0; i <= width; i += CELL_SIZE) {
    line(i, 0, i, height);
  }
  
  for (int j = 0; j < height; j += CELL_SIZE) {
      line(0, j, width, j);
  }
  stroke(0);
}