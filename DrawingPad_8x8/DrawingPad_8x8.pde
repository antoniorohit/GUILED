// Need G4P library for GUI
import g4p_controls.*;

import processing.serial.*;
Serial port;
 
int r =0, g =0, b =0, COM_PORT_NUM = 0;    // RGB and serial port vars
boolean flag = boolean(1);            // flag = 0 if COMPORT set in GUI
int gridScale = 80;                  // 80 for 8x8, 10 for 64x64
int BORDER = 5;


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
//  port = new Serial(this, Serial.list()[3], 9600); 
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
         port.write(254);                                     // start byte
        // Packet type
        port.write(int((mouseX-(BORDER-1))/gridScale));   // X
        port.write(int((mouseY-(BORDER-1))/gridScale));    // Y
         port.write(r*250/255);                                // R byte (6-bit)
         port.write(g*250/255);                                // G byte  (6-bit)
         port.write(b*250/255);                                // B byte  (6-bit)
         port.write(255);                                     // end byte         
     port.write(254);
     port.write(254);
     port.write(255);
      }
   }
   // right click clears a pixel. Recall that flag == true if COMPORT is set
   if(mousePressed && (flag == false) && (mouseButton == RIGHT)){
      if((mouseX <= 643) && (mouseX >= BORDER) && (mouseY <= 643) && (mouseY >= BORDER)) 
      {
        fill(0, 0, 0);
        stroke(0,0,0);  //black
        rect(mouseX-(mouseX-(BORDER-1))%gridScale, mouseY-(mouseY-(BORDER-1))%gridScale, gridScale,gridScale);
       port.write(254);                                     // start byte
        port.write(int((mouseX-(BORDER-1))/gridScale));                // X location
        port.write(int((mouseY-(BORDER-1))/gridScale));                // Y location
      // black (RGB = {0,0,0})
      port.write(0);                              
      port.write(0);
      port.write(0);
      port.write(255);                                               // end byte

     port.write(254);
     port.write(254);
     port.write(255);

      }
   }
   

}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
