//global variables
int cols;
int rows;
int size = 40;
Block[][] blocks;
 

void setup(){
  size(480, 480);
  rows = height / size;
  cols = width / size;
 
   for(int i = 0; i < rows; i++){
     for(int j = 0; j < cols; j++){
     blocks[i][j] = new Block(i , j);
   }
   }
}

void draw(){
  for(int i = 0; i < rows; i++){
     for(int j = 0; j < cols; j++){
     blocks[i][j].show();
   }
   }
}
