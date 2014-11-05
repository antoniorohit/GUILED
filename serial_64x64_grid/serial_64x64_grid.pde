// This sketch produces a 64x64 canvas of squares which are drawable.
// It is meant to be one of the input methods for an RGB LED Matrix Display

int PACKET_SIZE = 7;
int BUFFER_SIZE = 64*64;

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
byte[][] buff; 
byte[] temp_buff;
int num_bytes;

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
  temp_buff = new byte[PACKET_SIZE+10];
  buff = new byte[BUFFER_SIZE][PACKET_SIZE];
  frameRate(11);
  size(640,640);
  
  // Start the serial comm on port [3] - KL25Z shows up here
  String portName = Serial.list()[3];
  print(Serial.list());
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  
  // Initialize columns and rows based on the canvas just drawn
  cols = width/videoScale;
  rows = height/videoScale;
  ClearScreen();            // call the 2 for loops defined above
  stroke(0,0,0);  //black
}

void draw() {    // Runs forever (like a while(1)
  myPort.write("GG");
  while(myPort.available() > 0 && val < 4095){
    myPort.write("GG");
    // Protocol is packets of: XYRGB<255> 
    myPort.readBytesUntil((255), buff[val++]);
  }

  while(val > 0) {
    fill(buff[val][2], buff[val][3], buff[val][4]);
    // fill in the corresponding rectangle
    rect(buff[val][0]*videoScale,buff[val][1]*videoScale, videoScale,videoScale);
    val--;  
  }
 if(mousePressed && (mouseButton == RIGHT)){
     ClearScreen();
   }
    
}

