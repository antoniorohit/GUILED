// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-6: Drawing a grid of squares

// Size of each cell in the grid, ratio of window size to video size
// 80 * 8 = 640
// 60 * 8 = 320
int videoScale = 20;
// Number of columns and rows in our system
int cols, rows;
  

void ClearScreen() 
{
    // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {
      
      // Scaling up to draw a rectangle at (x,y)
      int x = i*videoScale;
      int y = j*videoScale;
      fill(100);
      stroke(0);
      // For every column and row, a rectangle is drawn at an (x,y) location scaled and sized by videoScale.
      rect(x,y,videoScale,videoScale); 
    }
  }
  return;
}
  
  
void setup() {
  size(640,640);
  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;
      // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {
      
      // Scaling up to draw a rectangle at (x,y)
      int x = i*videoScale;
      int y = j*videoScale;
      fill(100);
      stroke(0);
      // For every column and row, a rectangle is drawn at an (x,y) location scaled and sized by videoScale.
      rect(x,y,videoScale,videoScale); 
    }
  }
}

void draw() {

   if(mousePressed && (mouseButton == LEFT))
   { 
     if((mouseX <= 640) && (mouseY <= 640)) 
      {
        fill(mouseX,mouseY,random(1,255));
        stroke(0,0,0);
        rect(mouseX-(mouseX%20), mouseY-mouseY%20, videoScale,videoScale);
      }
   }
      if(mousePressed && (mouseButton == RIGHT)){
       ClearScreen();
     }
    
}


