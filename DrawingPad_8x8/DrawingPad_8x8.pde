// Need G4P library for GUI
import java.lang.*;
import g4p_controls.*;
import javax.swing.*;
import processing.serial.*;

Serial port;
 
int r =0, g =0, b =0, COM_PORT_NUM = 1;    // RGB and serial port vars
PImage img;
String filePath;

boolean flag = boolean(1);            // flag = 0 if COMPORT set in GUI
int gridScale;                        // 80 for 8x8, 10 for 64x64
int rowsOfModules;
int colsOfModules;
int[] boards;
int[][] moduleSpace;
int BORDER = 5;
int x, y, prev_x, prev_y;

public void setup(){
  // Set up the GUI - needs to be >640x640
  size(1000, 1000, JAVA2D);
  background(230);          // grey
  fill(0,0,0);              // fill for sketch area
  rect(BORDER-1, BORDER-1, 990, 740);
  createGUI();
  customGUI();
  
  setBoards();
  setWorkspace();
  constructModuleSpace();
  setImage();
  verifySetup();

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


public void fileSelected(File selection){
  if (selection == null) {
    filePath = "-1";
    println("Window was closed or the user hit cancel.");
  }else {
    filePath = selection.getAbsolutePath();
    println("User selected " + selection.getAbsolutePath());
  }
}

public void setBoards(){
  String op = JOptionPane.showInputDialog(frame, "Please input the number of boards in your workspace", "");
  int check = 0;
  int numberOfBoards = 0;
  while (check != 1) {
    try {
      numberOfBoards = Integer.parseInt(op);
      boards = new int[numberOfBoards];
      check = 1;
    }
    catch (NumberFormatException e) {
      println("Invalid number of boards, please choose an integer value greater than 0.");
    }
  }
  for (int i = 0; i < boards.length; i++) {
    check = 0;
    while (check != 1){
      op = JOptionPane.showInputDialog(frame, "For board " + i + ", please input the maximum current supplied to its modules in mA.", "");
      try { 
        boards[i] = Integer.parseInt(op);
        check = 1;
        if (boards[i] < 500) {
          println("Minimum current is 500 mA (current supplied by USB 2.0)");
          check = 0;
        }
      }
      catch (NumberFormatException e) {
        println("Invalid current value supplied.");
      }
    }
  }
}

public void setWorkspace(){
  rowsOfModules = boards.length*4;
  int check = 0;
  while (check != 1) {
    String op = JOptionPane.showInputDialog(frame, "Please input the cols of modules in your workspace", "");
    try{
      colsOfModules = Integer.parseInt(op);
      check = 1;
    }
    catch (NumberFormatException e){
      println("Invalid format used. Please use an integer greater than 0.");
    }
  }
}

public void setImage() {
  selectInput("Select an image, or press cancel : ", "fileSelected");
  while (filePath == null) {println("...");}
  if (!filePath.equals("-1")) {
    img = loadImage(filePath);
    if (img != null) {
      println("Image loaded");
    }
    else {
      println("Image not loaded");
    }
  }  
}

public void constructModuleSpace(){
  moduleSpace = new int[rowsOfModules][colsOfModules];
  for (int i = 0; i < rowsOfModules; i++) {
    for (int j = 0; j < colsOfModules; j++) {
      int check = 0;
      while (check != 1)
      {
        String op = JOptionPane.showInputDialog(frame, "Using 0 (no) or 1 (yes), is a module present at index: [" + i + "," + j + "]", "");
        try {
          moduleSpace[i][j] = Integer.parseInt(op);
        }
        catch (NumberFormatException e) {
          println("Invalid entry, please use 0 (no) or 1 (yes) for module presence at index: [" + i + "," + j + "]");
          moduleSpace[i][j] = -1;    
        }
        if (moduleSpace[i][j] != 0 && moduleSpace[i][j] != 1) {
          println("Invalid entry, please use 0 (no) or 1 (yes) for module presence at index: [" + i + "," + j + "]");
        }
        else {
          check = 1;
        }
      }
    }
  }
  int pixelsAvailable = 0;
  for (int i = 0; i < rowsOfModules; i++) {
    for (int j = 0; j < colsOfModules; j++) {
    pixelsAvailable = pixelsAvailable + moduleSpace[i][j]*64;
    }
  }
  gridScale = (int)(990/(sqrt(pixelsAvailable)));
}

public void verifySetup(){
  println("Checking electrical requirements...");
  int[] boardCheck = electricalRequirements();
  int check = 0;
  int imageCheck = 0;
  for (int i = 0; i < boardCheck.length; i++) { 
    if (boardCheck[i] > 0) {
       println("Electrical requirements of board " + i + " exceed max (max current - 60 mA)");
       check = -1;
    }
    else {
      println("Board " + i + " OK.");
    }
  }
  if (check != -1) {
    println("Electrical requirements OK");
  }
  else {
    println("Electrical requirements failed! Check power supplies to boards for given setup.");
  }
  if (img != null) {
    println("Checking image requirements");
    imageCheck = imageRequirements();
    if (imageCheck != -1) {
      println("Image requirements OK");
    }
    else {
      println("Image requirements failed!");
    }
  }
  else { imageCheck = 1; }
  if (check != 1 || imageCheck != 1) {
    println("Desired setup did not pass requirements, please revisit build");
  }
  else {
    println("All clear!");
  }
}

private int[] electricalRequirements(){
  int maxCurrentPerLED = 60;
  int[] maxCurrentDraw = new int[boards.length];
  int[] badBoards = new int[boards.length];
  for (int k = 0; k < boards.length; k++) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < colsOfModules; j++) {
        maxCurrentDraw[k] = maxCurrentDraw[k] + moduleSpace[i][j]*maxCurrentPerLED;
      }
    }
    if (maxCurrentDraw[k] >= boards[k]-60) {
      badBoards[k] = 1;
    }
    else{
      badBoards[k] = 0;
    }
  }
  return badBoards;
}

private int imageRequirements(){
  int pixelsAvailable = 0;
  for (int i = 0; i < rowsOfModules; i++) {
    for (int j = 0; j < colsOfModules; j++) {
    pixelsAvailable = pixelsAvailable + moduleSpace[i][j]*64;
    }
  }
  if (img.width > (int)sqrt(pixelsAvailable) || img.height > (int)sqrt(pixelsAvailable)){
       println("Image exceeds pixel dimensions of workspace!");
       String op = JOptionPane.showInputDialog(frame, "Resize image? (yes or no/cancel)", "");
       op = op.toLowerCase();
       if (op.equals("yes")) {
         img.resize((int)sqrt(pixelsAvailable), (int)sqrt(pixelsAvailable));
       }
       else {
         return -1;
       }
    }
  return 1;
}
