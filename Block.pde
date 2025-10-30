class Block {
  int x;
  int y;
  int thisRow;
  int thisCol;
  
  boolean visitedByMaze = false;
  boolean visitedBySolver = false;
  Block parent = null;
  boolean[] walls = {true, true, true, true};
  ArrayList<Block> neighbours = new ArrayList<>();
  
  Block(int row, int col) {
    x = row * size;
    y = col * size;
    thisRow = row;
    thisCol = col;
  }
  
  void show() {
    stroke(0);
    if (walls[0]) line(x, y, x + size, y);
    if (walls[1]) line(x + size, y, x + size, y + size);
    if (walls[2]) line(x + size, y + size, x, y + size);
    if (walls[3]) line(x, y + size, x, y);
    
    if (visitedByMaze) {
      noStroke();
      fill(255, 50, 255, 95);
      rect(x, y, size, size);
      stroke(0);
    }
    
    // Show BFS exploration in blue
    if (visitedBySolver && !isSolved) {
      noStroke();
      fill(100, 150, 255, 150); // Light blue
      rect(x, y, size, size);
      stroke(0);
    }
  }
  
  void addNeighbours() {
    if (thisRow > 0) {
      neighbours.add(blocks[thisRow - 1][thisCol]);
    }
    if (thisCol < cols - 1) {
      neighbours.add(blocks[thisRow][thisCol + 1]);
    }
    if (thisRow < rows - 1) {
      neighbours.add(blocks[thisRow + 1][thisCol]);
    }
    if (thisCol > 0) {
      neighbours.add(blocks[thisRow][thisCol - 1]);
    }
  }
  
  boolean hasUnvisitedNeighbours() {
    for (Block neighbour : neighbours) {
      if (!neighbour.visitedByMaze) {
        return true;
      }
    }
    return false;
  }
  
  Block pickRandomNeighbour() {
    ArrayList<Block> unvisited = new ArrayList<>();
    for (Block neighbour : neighbours) {
      if (!neighbour.visitedByMaze) {
        unvisited.add(neighbour);
      }
    }
    if (unvisited.size() == 0) return null;
    Block next = unvisited.get(floor(random(0, unvisited.size())));
    next.visitedByMaze = true;
    return next;
  }
}
