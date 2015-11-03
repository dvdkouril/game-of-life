class Cell {
  int xIndex;  // x coordinate in the grid
  int yIndex; // y coordinate in the grid
  boolean status; // true = alive; false = ded
  float hue;
  
  Cell(int x, int y, boolean s) {
    this.status = s;
    this.xIndex = x;
    this.yIndex = y;
    hue = 0;
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
    
    if (this.status) {
      if (cellColorMode) {
        colorMode(HSB);
        fill(hue, 255, 255);
        colorMode(RGB);
      } else {
        fill(255);
      }
    } else {
      if (fadeOutEffect) {
        fill(0, 50); // fade out
      } else {
        fill(0);     // no fadeout
      }
    }
    
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