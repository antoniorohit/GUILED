// This sketch produces a 64x64 canvas of squares which are drawable.
// It is meant to be one of the input methods for an RGB LED Matrix Display

// Serial library to talk to KL25z
import processing.serial.*;
Serial myPort;

// Size of each cell in the grid, ratio of window size to video size
// 10 * 64 = 640
// 10 * 64 = 640
int videoScale = 10;
// Number of columns and rows in our system
int cols, rows;
int j = 0;
int val;
byte buff[] = {0, 0, 0, 0, 0, 0, 0};

// Helper function: sets the grid back to near-black
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
  
  // Start the serial comm on port [3] - KL25Z shows up here
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  
  // Initialize columns and rows based on the canvas just drawn
  cols = width/videoScale;
  rows = height/videoScale;
  ClearScreen();            // call the 2 for loops defined above
}

void draw() {    // Runs forever (like a while(1)
   if(myPort.available() > 0) {
     // Protocol is packets of: 'S'XYRGB'R' 
     val = myPort.readBytesUntil('R', buff);
      
      // Prints for DEBUG
//      print(char(buff[0]));       // -----> 'S'
//      print(',', int(buff[1]));   // -----> X coordinate
//      print(',', int(buff[2]));   // -----> Y coordinate
//      print(',', int(buff[3]));   // -----> R value
//      print(',', int(buff[4]));   // -----> G value
//      print(',', int(buff[5]));   // -----> B value
//      print(',', char(buff[6]));  // -----> 'R'
//      print('|');
      
      fill(buff[3], buff[4], char(buff[5]));
      stroke(0,0,0);  //black
      // fill in the corresponding rectangle
      rect(buff[1]*videoScale,buff[2]*videoScale, videoScale,videoScale);

   }
   else if(mousePressed && (mouseButton == RIGHT)){
       ClearScreen();
     }
    
}

