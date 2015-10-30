
// GOD CONSTANTS
int CELL_SIZE = 10;
int WINDOW_SIZE_X = 800;
int WINDOW_SIZE_Y = 600;
int CELLS_NUM_X = WINDOW_SIZE_X / CELL_SIZE;
int CELLS_NUM_Y = WINDOW_SIZE_Y / CELL_SIZE;

boolean play = false;

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
  frameRate(15);
  background(255);
  
  drawCells();
  
  drawBrush();
  
  /*fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text("whadup", 0, 0);*/
  
  //_drawNeighbourCounts();
  
  // CONWAY'S GAME OF LIFE
  if (play) {
    solveGrid();
    //cellsGrid = nextCellsGrid; // switch the grid to the new iteration - NOT ACTUALLY HAHA
    //copyArray(nextCellsGrid, cellsGrid, CELLS_NUM_X, CELLS_NUM_Y);
    for (int j = 0; j < CELLS_NUM_Y; j++) {
      for (int i = 0; i < CELLS_NUM_X; i++) {
        cellsGrid[i][j].status = nextCellsGrid[i][j].status;
      }
    }
  }
  
}

void _drawNeighbourCounts() { // debug method
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      int liveNeighs = calculateLiveNeighbours(i, j);
      fill(255);
      textAlign(LEFT, TOP);
      textSize(8);
      text(liveNeighs, i * CELL_SIZE, j * CELL_SIZE);
    }
  }
}


void mouseDragged() {
  
  if (key == 'd' || key == 'D') {
    eraseWithBrush();
  } else {
    paintWithBrush();
  }
}

void mousePressed() {
  if (key == 'd' || key == 'D') {
    eraseWithBrush();
  } else {
    paintWithBrush();
  }
}

void keyPressed() {
  if (key == 'p' || key == 'P') { // Play
    play = true;
  } else if (key == 's' || key == 'S') { // Stop
    play = false;
  } else if (key == 'c' || key == 'C') { // Clear
    play = false; // maybe not needed
    clearGrid();
  }
}

void copyArray(Cell[][] arr1, Cell[][] arr2, int sizeX, int sizeY) {
  for (int j = 0; j < sizeY; j++) {
    for (int i = 0; i < sizeX; i++) {
      arr2[i][j] = arr1[i][j];
    }
  }
}

void drawBrush() {
  //fill(255);
  stroke(255);
  fill(255, 0);
  ellipse(mouseX, mouseY, 100, 100);
}

void paintWithBrush() {
  int i = (int)mouseX / CELL_SIZE;
  int j = (int)mouseY / CELL_SIZE;
  println("mouseX / CELL_SIZE = " + mouseX + " / " + CELL_SIZE + " = " + i);
  cellsGrid[i][j].status = true;
}

void eraseWithBrush() {
  int i = (int)mouseX / CELL_SIZE;
  int j = (int)mouseY / CELL_SIZE;
  println("mouseX / CELL_SIZE = " + mouseX + " / " + CELL_SIZE + " = " + i);
  cellsGrid[i][j].status = false;
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
      cellsGrid[i][j] = new Cell(i, j, false );
    }
  }
}

void clearGrid() {
  for (int j = 0; j < CELLS_NUM_Y; j++) {
    for (int i = 0; i < CELLS_NUM_X; i++) {
      cellsGrid[i][j].status = false;
    }
  }
}

void createCellsRandom() {
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

void drawGrid() { // not used anymore
  
  stroke(200);
  for (int i = 0; i <= width; i += CELL_SIZE) {
    line(i, 0, i, height);
  }
  
  for (int j = 0; j < height; j += CELL_SIZE) {
      line(0, j, width, j);
  }
  stroke(0);
}