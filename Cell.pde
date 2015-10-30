class Cell {
  int xIndex;  // x coordinate in the grid
  int yIndex; // y coordinate in the grid
  boolean status; // true = alive; false = ded
  
  Cell(int x, int y, boolean s) {
    this.status = s;
    this.xIndex = x;
    this.yIndex = y;
  }

  Cell(int x, int y) {
    this(x, y, false);
  }

  Cell() {
    this(0, 0, false); // fuck Processing
  }
  
  void drawCell() {
    //noStroke();
    int x = this.xIndex * CELL_SIZE;
    int y = this.yIndex * CELL_SIZE;
    int cellWidth = CELL_SIZE;
    int cellHeight = CELL_SIZE;
    
    /* // no fade out
    int col = this.status ? 255 : 0;
    fill(col);*/
    
    // fade out
    if (this.status) fill(255); else fill(0, 50);
    
    rect(x, y, cellWidth, cellHeight);
    stroke(0);
  }
  
  void setStatus(boolean s) {
    this.status = s;
  }
  
  void setAlive() { // not actually usefull
    this.status = true;
  }
  
  void setDead() { // not actually useful
    this.status = false;
  }
  
  boolean getStatus() {
    return status;
  }
}