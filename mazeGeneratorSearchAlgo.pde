import java.util.*;

//global variables
int cols;
int rows;
int size = 20;
Block[][] blocks;
Block currentMazeBlock;
Stack<Block> stack = new Stack<>();
boolean isFinished = false;
boolean isSolving = false;
boolean isSolved = false;
ArrayList<Block> solutionPath = new ArrayList<>();

// BFS animation variables
Queue<Block> bfsQueue = new LinkedList<>();
Block currentSolverBlock = null;

void setup() {
  size(200, 200);
  rows = height / size;
  cols = width / size;
  blocks = new Block[rows][cols];
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j] = new Block(i, j);
    }
  }
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].addNeighbours();
    }
  }
 
  currentMazeBlock = blocks[0][0];
  currentMazeBlock.visitedByMaze = true;
  
  frameRate(25);
}

void draw() {
  background(0, 255, 255);
  
  // Draw all blocks
  strokeWeight(1);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].show();
    }
  }
  
  if (!isFinished) {
    // Maze generation
    fill(193, 50, 193);
    rect(currentMazeBlock.x, currentMazeBlock.y, size, size);
    
    if (currentMazeBlock.hasUnvisitedNeighbours()) {
      Block nextCurrent = currentMazeBlock.pickRandomNeighbour();
      stack.add(currentMazeBlock); 
      removeWalls(currentMazeBlock, nextCurrent);
      currentMazeBlock = nextCurrent;
    } else if (stack.size() > 0) {
      Block nextCurrent = stack.get(stack.size() - 1);
      stack.remove(nextCurrent);
      currentMazeBlock = nextCurrent;
    } else {
      println("Maze Done! Starting BFS Solver...");
      isFinished = true;
      startBFSSolver();
    }
  } else if (isSolving) {
    // Animate BFS solving
    solveMazeBFSStep();
    
    // Highlight current block being explored
    if (currentSolverBlock != null) {
      fill(255, 255, 0); // Yellow for current
      rect(currentSolverBlock.x, currentSolverBlock.y, size, size);
    }
  } else if (isSolved) {
    // Draw the solution path as a line
    drawSolutionPath();
  }
}

void startBFSSolver() {
  Block start = blocks[0][0];
  start.visitedBySolver = true;
  bfsQueue.add(start);
  isSolving = true;
}

void solveMazeBFSStep() {
  if (bfsQueue.isEmpty()) {
    println("No path found!");
    isSolving = false;
    return;
  }
  
  Block current = bfsQueue.remove();
  currentSolverBlock = current;
  Block end = blocks[rows - 1][cols - 1];
  
  // Found the end!
  if (current == end) {
    println("Path found!");
    reconstructPath(end);
    isSolving = false;
    isSolved = true;
    return;
  }
  
  // Check all neighbors
  for (Block neighbor : current.neighbours) {
    if (!neighbor.visitedBySolver && canMove(current, neighbor)) {
      neighbor.visitedBySolver = true;
      neighbor.parent = current;
      bfsQueue.add(neighbor);
    }
  }
}

boolean canMove(Block current, Block neighbor) {
  // Check if there's a wall between current and neighbor
  int rowDiff = neighbor.thisRow - current.thisRow;
  int colDiff = neighbor.thisCol - current.thisCol;
  
  // Neighbor is below
  if (rowDiff == 1) {
    return !current.walls[1];
  }
  // Neighbor is above
  if (rowDiff == -1) {
    return !current.walls[3];
  }
  // Neighbor is to the right
  if (colDiff == 1) {
    return !current.walls[2];
  }
  // Neighbor is to the left
  if (colDiff == -1) {
    return !current.walls[0];
  }
  
  return false;
}

void reconstructPath(Block end) {
  Block current = end;
  while (current != null) {
    solutionPath.add(0, current);
    current = current.parent;
  }
  println("Path length: " + solutionPath.size());
}

void drawSolutionPath() {
  // Draw solution as a thick line through centers of blocks
  stroke(255, 0, 0); // Green line
  strokeWeight(4);
  noFill();
  
  beginShape();
  for (Block b : solutionPath) {
    vertex(b.x + size/2, b.y + size/2);
  }
  endShape();
  
  // Draw start and end markers
  fill(0, 255, 0);
  noStroke();
  ellipse(blocks[0][0].x + size/2, blocks[0][0].y + size/2, 10, 10);
  fill(255, 0, 0);
  ellipse(blocks[rows-1][cols-1].x + size/2, blocks[rows-1][cols-1].y + size/2, 10, 10);
}

void removeWalls(Block current, Block next) {
  int xDistance = current.thisRow - next.thisRow;
  int yDistance = current.thisCol - next.thisCol;
  
  if (xDistance == -1) {
    current.walls[1] = false;
    next.walls[3] = false;
  } else if (xDistance == 1) {
    current.walls[3] = false;
    next.walls[1] = false;
  }
  
  if (yDistance == -1) {
    current.walls[2] = false;
    next.walls[0] = false;
  } else if (yDistance == 1) {
    current.walls[0] = false;
    next.walls[2] = false;
  }
}
