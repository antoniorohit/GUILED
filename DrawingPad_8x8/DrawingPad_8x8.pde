// Need G4P library for GUI
import g4p_controls.*;

import processing.serial.*;
Serial port;
 
int r =0, g =0, b =0, COM_PORT_NUM = 1;    // RGB and serial port vars
boolean flag = boolean(1);            // flag = 0 if COMPORT set in GUI
int gridScale = 40;                  // 80 for 8x8, 10 for 64x64
int BORDER = 5;
int x, y, prev_x, prev_y;

public void setup(){
  // Set up the GUI - needs to be >640x640
  size(650, 710, JAVA2D);
  background(230);          // grey
  fill(0,0,0);              // fill for sketch area
  rect(BORDER-1, BORDER-1, 640, 640);
  createGUI();
  customGUI();

  println("Available serial ports:");  
  println(Serial.list());
  // note that the serial port is set using the GUI
//  port = new Serial(this, Serial.list()[3], 115200); 
//  flag = false;
}

public void draw(){
  // left click draws a pixel. Recall that flag == true if COMPORT is set
   if(mousePressed && (flag == false) && (mouseButton == LEFT))
   { 
      if((mouseX <= 643) && (mouseX >= BORDER) && (mouseY <= 643) && (mouseY >= BORDER)) 
      {
        fill(r, g, b);
        stroke(0,0,0);  //black
        // draw the pixel
        rect(mouseX-(mouseX-(BORDER-1))%gridScale, mouseY-(mouseY-(BORDER-1))%gridScale, gridScale,gridScale);
        x = int((mouseX-(BORDER-1))/gridScale);
        y = int((mouseY-(BORDER-1))/gridScale);
        if(x!= prev_x || y!= prev_y){
          port.write(254);                                     // start byte
          port.write(x);   // X
          port.write(y);    // Y
          port.write(int(r*128/255));                                // R byte (6-bit)
          port.write(int(g*128/255));                                // G byte  (6-bit)
          port.write(int(b*128/255));                                // B byte  (6-bit)
          port.write(255);                                           // end byte    
          println(x, y, int(r*128/255), int(g*128/255), int(b*128/255));
          port.write(254);                                     // start byte
          port.write(254);                                     // start byte
          port.write(255);                                           // end byte    

        }
        prev_x = x;
        prev_y = y;
      }
   }
   // right click clears a pixel. Recall that flag == true if COMPORT is set
   if(mousePressed && (flag == false) && (mouseButton == RIGHT)){
      if((mouseX <= 643) && (mouseX >= BORDER) && (mouseY <= 643) && (mouseY >= BORDER)) 
      {
        fill(0, 0, 0);
        stroke(0,0,0);  //black
        rect(mouseX-(mouseX-(BORDER-1))%gridScale, mouseY-(mouseY-(BORDER-1))%gridScale, gridScale,gridScale);
        x = int((mouseX-(BORDER-1))/gridScale);
        y = int((mouseY-(BORDER-1))/gridScale);
        if(x!= prev_x || y!= prev_y){
          port.write(254);                                     // start byte
          port.write(x);   // X
          port.write(y);    // Y
          port.write(0);                                // R byte (6-bit)
          port.write(0);                                // G byte  (6-bit)
          port.write(0);                                // B byte  (6-bit)
          port.write(255);                                     // end byte        
        }
        prev_x = x;
        prev_y = y;
      }
   
    if(port.available()!=0){
      println(port.read());
    }
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
