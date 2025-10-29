class Block{
  //general
 int x;
 int y;
 int thisRow;
 int thisCol;

 Block(int row, int col){
   x = row * size;
   y = col * size;
   thisRow = row;
   thisCol = col;
 }
 
 void show(){
   line(x       ,  y       ,  x + size,  y);
   line(x + size,  y       ,  x + size,  y + size);
   line(x + size,  y + size,  x       ,  y + size);
   line(x       ,  y + size,  x       ,  y);
 }
}
