/* Draw 16x16 image on the RGB Panel */
 
 import processing.serial.*;
 Serial port;
 
  int r = 0, g = 0, b = 0;
  PImage img1, img2, img3, img4;

 void setup() {

  size(100, 100);
  
  println("Available serial ports:");
  println(Serial.list());
 
  img2 = loadImage("logo.gif");
  img4 = loadImage("hearts.jpg");
  img3 = loadImage("google.jpg");
  img1 = loadImage("4.jpg");

  img1.resize(8, 8);
  img2.resize(16, 16);
  img3.resize(16, 16);
  img4.resize(16, 16);

  image(img1, 0, 0, 100, 100);
  
 
  img1.loadPixels();
  img2.loadPixels();
  img3.loadPixels();
  img4.loadPixels();

  // Uses the second port in this list (number 1).  Change this to
  // select the port corresponding to your Pioneer board.  The last
  // parameter (e.g. 115200) is the speed of the communication.  It
  // has to correspond to the value in the UART Component 
  port = new Serial(this, Serial.list()[3], 9600);  
 
  // If you know the name of the port used by the Pioneer board, you
  // can specify it directly like this.
  // port = new Serial(this, "COM1", 115200);
 }
 
 void draw() {
  r = 0; g = 0; b = 0;
  int i = 0, j = 0;    

  if(mousePressed)
  {
       for(int dim = 0; dim < img1.height*img1.width; dim++)
       {
         i = (int)dim%8;
         j = (int)dim/8;
         port.write(254);       
         port.write(i);
         port.write(j);
       
         port.write((int)((128*red(img1.pixels[dim]))/255));
         port.write((int)((128*green(img1.pixels[dim]))/255));
         port.write((int)((128*blue(img1.pixels[dim]))/255));
         port.write(255);
          
        }
       
       // Display Image Packet
       port.write(254);       
       port.write(254);       
       port.write(255);
 }
}
 
