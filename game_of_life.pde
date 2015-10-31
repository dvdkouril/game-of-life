import java.util.Calendar;

// GOD CONSTANTS
int CELL_SIZE = 10;
/*int WINDOW_SIZE_X = 800;
int WINDOW_SIZE_Y = 600;*/
int WINDOW_SIZE_X = 1440;
int WINDOW_SIZE_Y = 900;
int CELLS_NUM_X = WINDOW_SIZE_X / CELL_SIZE;
int CELLS_NUM_Y = WINDOW_SIZE_Y / CELL_SIZE;

int currentPatternBrush = 0;

boolean isInGame = false;
boolean play = false;
boolean hideBrush = false;
boolean fadeOutEffect = false;
//boolean onePointBrush = true;
long framecount = 0;

Cell[][] cellsGrid;
Cell[][] nextCellsGrid;

void setup() {
  
  fullScreen();
  //size(800, 600);
  background(0);
  
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

void drawGameOfLife() {
  drawCells();
  
  if (!hideBrush) {
    drawBrushPattern(patterns[currentPatternBrush]);
  }
  
  //_drawNeighbourCounts();
  
  // CONWAY'S GAME OF LIFE
  if (play /*&& (framecount % 5 == 0)*/) {
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

void drawWelcomeScreen() {
  background(0);
  fill(255);
  textAlign(CENTER, TOP);
  
  textSize(50);
  text("\"Brush of Life\"", width/2, height/2 - 80);
  
  textSize(18);
  text("David Kouřil (dvdkouril.com)", width/2, height/2);
  
  textSize(20);
  text("press [space] to start", width/2, height - 100);
}

void draw() {
  //frameRate(15);
  framecount++;
  
  if (isInGame) { // play the game
    drawGameOfLife();
  } else { // show welcome screen
    drawWelcomeScreen();
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

/* I think that the cool effect with dragging point brush is because this function is evaluated independently 
   from draw() function */
void mouseDragged() {
  
  if (mouseButton == LEFT) {
    paintArray(patterns[currentPatternBrush]);
  } else if (mouseButton == RIGHT) {
    eraseWithBrush();
  }
  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    paintArray(patterns[currentPatternBrush]);
  } else if (mouseButton == RIGHT) {
    eraseWithBrush();
  }
  println("sup.");
}
void keyReleased() {
  if (key == 's' || key == 'S') saveFrame("dvdisawesome" + timestamp() + "_##.png");
}

void keyPressed() {
  if (key == 'p' || key == 'P') { // Play/pause
    play = !play;
  } else if (key == 'c' || key == 'C') { // Clear
    //play = false; // maybe not needed
    clearGrid();
  } else if (keyCode == DOWN) { // put down the pattern (for putting just one pattern on exact position)
    paintArray(patterns[currentPatternBrush]);
  } else if (key == ' ') {
    isInGame = true;
  } else if (key == ESC) {
    if (isInGame) { // if we are not on welcome screen, we do not want to quit
      key = 0;
    }
    isInGame = false;
    clearGrid();
  } else if (key == '1') {
    currentPatternBrush = 0;
  } else if (key == '2') {
    //paintArray(pulsar);
    currentPatternBrush = 1;
  } else if (key == '3') {
    currentPatternBrush = 2;
  } else if (key == '4') {
    currentPatternBrush = 3;
  } else if (key == '5') {
    currentPatternBrush = 4;
  } else if (key == '0') {
    hideBrush = !hideBrush;
  } else if (key == 'q') {
    fadeOutEffect = !fadeOutEffect;
  }
  
}

void paintArray(int [][] pattern) {
  int patSizeX = pattern[0].length;
  int patSizeY = pattern.length;
  
  for (int j = 0; j < patSizeY; j++) {
    for (int i = 0; i < patSizeX; i++) {
      boolean patPosStatus = pattern[j][i] == 1 ? true : false;
      int xOffset = (int)mouseX / CELL_SIZE;
      int yOffset = (int)mouseY / CELL_SIZE;
      
      if ( (i + xOffset >= CELLS_NUM_X) || (j + yOffset >= CELLS_NUM_Y) ) continue;
      
      cellsGrid[i + xOffset][j + yOffset].status = patPosStatus;
    }
  }
}

void drawBrush() {
   // old code - just a circle
  stroke(255);
  fill(255, 0);
  ellipse(mouseX, mouseY, 100, 100);
}

void drawOnePointBrush() {
  fill(125, 125);
  rect(mouseX, mouseY, CELL_SIZE, CELL_SIZE);
}

void drawBrushPattern(int[][] pattern) {
  int patSizeX = pattern[0].length;
  int patSizeY = pattern.length;
  
  for (int j = 0; j < patSizeY; j++) {
    for (int i = 0; i < patSizeX; i++) {
      //boolean patPosStatus = pattern[i][j] == 1 ? true : false;
      boolean patPosStatus = pattern[j][i] == 1 ? true : false;
      if (!patPosStatus) continue;
      
      int x = mouseX + i * CELL_SIZE;
      int y = mouseY + j * CELL_SIZE;
      int w = CELL_SIZE;
      int h = CELL_SIZE;
      fill(125, 125);
      rect(x, y, w, h);
    
    }
  }
}

void paintWithBrush() {
  int i = (int)mouseX / CELL_SIZE;
  int j = (int)mouseY / CELL_SIZE;
  if (i < 0 || j < 0) return;
  if (i >= CELLS_NUM_X || j >= CELLS_NUM_Y) return;
  
  //println("mouseX / CELL_SIZE = " + mouseX + " / " + CELL_SIZE + " = " + i);
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

int[][][] patterns = {
  // point ... yes, lol
{
{1}
},
  // pulsar
{
{0,0,1,1,1,0,0,0,1,1,1,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,0,0,0,1,0,1,0,0,0,0,1}, 
{1,0,0,0,0,1,0,1,0,0,0,0,1},
{1,0,0,0,0,1,0,1,0,0,0,0,1},
{0,0,1,1,1,0,0,0,1,1,1,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,1,1,1,0,0,0,1,1,1,0,0},
{1,0,0,0,0,1,0,1,0,0,0,0,1},
{1,0,0,0,0,1,0,1,0,0,0,0,1},
{1,0,0,0,0,1,0,1,0,0,0,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,1,1,1,0,0,0,1,1,1,0,0}
},
  // lightweight spaceship
{ 
{0,1,0,0,1},
{1,0,0,0,0},
{1,0,0,0,1}, 
{1,1,1,1,0}
},
  // r-pentomino
{ 
{0,1,1},
{1,1,0},
{0,1,0}
},
  // infinite growth
{ 
{1,1,1,0,1},
{1,0,0,0,0},
{0,0,0,1,1},
{0,1,1,0,1},
{1,0,1,0,1}
}
};

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}