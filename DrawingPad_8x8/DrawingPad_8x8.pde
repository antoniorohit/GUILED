// Need G4P library
import g4p_controls.*;
 import processing.serial.*;
 Serial port;
 
int r =0, g =0, b =0, COM_PORT_NUM;
boolean flag = boolean(1);
int videoScale = 80;
int BORDER = 5;


public void setup(){
  size(650, 710, JAVA2D);
  background(230);
  fill(0,0,0);
  rect(BORDER-1, BORDER-1, 640, 640);
  createGUI();
  customGUI();

 println("Available serial ports:");
 println(Serial.list());
  
// port = new Serial(this, Serial.list()[3], 9600); 
  
}

public void draw(){
 if(mousePressed && flag == false && (mouseButton == LEFT))
   { 
      if((mouseX <= 643) && (mouseX >= BORDER) && (mouseY <= 643) && (mouseY >= BORDER)) 
      {
        fill(r, g, b);
        stroke(0,0,0);  //black
        rect(mouseX-(mouseX-(BORDER-1))%videoScale, mouseY-(mouseY-(BORDER-1))%videoScale, videoScale,videoScale);
        port.write(255);
        port.write(int((mouseX-(BORDER-1))/videoScale));
        port.write(int((mouseY-(BORDER-1))/videoScale));

      }
     port.write(r*31/255);
     port.write(g*31/255);
     port.write(b*31/255);
     port.write(254);

   }
   if(mousePressed && flag == false && (mouseButton == RIGHT)){
      if((mouseX <= 643) && (mouseX >= BORDER) && (mouseY <= 643) && (mouseY >= BORDER)) 
      {
        fill(0, 0, 0);
        stroke(0,0,0);  //black
        rect(mouseX-(mouseX-(BORDER-1))%videoScale, mouseY-(mouseY-(BORDER-1))%videoScale, videoScale,videoScale);
        port.write(255);
        port.write(int((mouseX-(BORDER-1))/videoScale));
        port.write(int((mouseY-(BORDER-1))/videoScale));

      }
     port.write(0);
     port.write(0);
     port.write(0);
     port.write(254);     
   }

}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
