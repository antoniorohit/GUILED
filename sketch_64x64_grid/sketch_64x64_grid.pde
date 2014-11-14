// This sketch produces a 64x64 canvas of squares which are drawable.
// It is meant to be one of the input methods for an RGB LED Matrix Display
import processing.serial.*;
Serial myPort;
// Size of each cell in the grid, ratio of window size to video size
// 10 * 64 = 640
// 10 * 64 = 640
int videoScale = 80;
// Number of columns and rows in our system
int cols, rows;
int x, y;

// Sets the grid back to near-black
void ClearScreen() 
{
  // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {  
      int x = i*videoScale;        // Scaling up to draw a rectangle at (x,y)
      int y = j*videoScale;
      fill(30);                    // near black fill (arbitrary)
      stroke(0);                    // black border
      // For every column and row, draw rectangle at (x,y)
      // scaled and sized by videoscale
      rect(x,y,videoScale,videoScale); 
    }
  }
  return;
}
  
  
void setup() {    // Runs once in the beginning of the execution
  size(640,640);
  String portName = Serial.list()[3];
  print(Serial.list());
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  // Initialize columns and rows based on the canvas just drawn
  cols = width/videoScale;
  rows = height/videoScale;
  ClearScreen();            // call the 2 for loops defined above
}

void draw() {    // Runs forever (like a while(1)
   if(mousePressed && (mouseButton == LEFT))
   { 
     // different behaviors for LEFT and RIGHT click
     if((mouseX <= 640) && (mouseY <= 640)) // within canvas
      {
        x = int((mouseX-1)/videoScale);
        y = int((mouseY-1)/videoScale);
        fill(mouseX*253/width,mouseY*253/height,0);
        stroke(0,0,0);  //black
        // fill in the corresponding rectangle
        rect(mouseX-(mouseX%videoScale), mouseY-mouseY%videoScale, videoScale,videoScale);
        myPort.write(255);        
        myPort.write(x);
        myPort.write(y);
        myPort.write(mouseX*253/width);
        myPort.write(mouseY*253/height);
        myPort.write(0);
        myPort.write(254);
      }
   }
      if(mousePressed && (mouseButton == RIGHT)){
         ClearScreen();
         myPort.write(255);        
         myPort.write(254);          
         myPort.write(254);          

     }
    
}

