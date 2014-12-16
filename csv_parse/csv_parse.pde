// The following short CSV file called "mammals.csv" is parsed 
// in the code below. It must be in the project's "data" folder.
//
import java.util.*;

int HEIGHT = 8;
int WIDTH = 8;

Table table;
PImage img = createImage(HEIGHT, WIDTH, RGB);

void setup() {
  int timestamp, state, oneStartTime = 0, zeroStartTime=0, numLEDs = 0;
  int count = 0;
  float highTime = 1.25, lowTime = 1.25;
  float dutyCycle;
  int[] dutyCycleBuff = {0, 0, 0, 0, 0, 0, 0 , 0};
  int i = 0;
  int r = 0, g = 0, b = 0;
  int prev_state = 0;
  int rowIndex = 0;
  img.loadPixels();

  table = loadTable("test5.csv", "header");

  int maxRows = table.getRowCount();

  while(true){
  for(int index = 0; index < 8; index ++){
  for (TableRow row : table.rows()) {
    rowIndex++;
    timestamp = row.getInt("timestamp (abs)");
    state = row.getInt("Channel-"+index);
    
    if(state == 0){
      if(state != prev_state){
        zeroStartTime = timestamp;
        highTime = timestamp - oneStartTime;
        dutyCycle = highTime/2.5;//(highTime + lowTime);          // 2.5 cycles = 1.25uS
//        println(highTime + lowTime, dutyCycle);
        if(dutyCycle > .4){
          dutyCycleBuff[i] = 1;
        }
      }
      prev_state = state;
    }
    else{
      if(state != prev_state){
        count++;
        i++;
        if(count == 8){
          g = dutyCycleBuff[7]*128 + dutyCycleBuff[6]*64 + dutyCycleBuff[5]*32 + dutyCycleBuff[4]*16 + dutyCycleBuff[3]*8 + dutyCycleBuff[2]*4 + dutyCycleBuff[1]*2 + dutyCycleBuff[0]*1;
          Arrays.fill(dutyCycleBuff, 0);
          i = 0;
        }
        else if(count == 16){
          r = dutyCycleBuff[7]*128 + dutyCycleBuff[6]*64 + dutyCycleBuff[5]*32 + dutyCycleBuff[4]*16 + dutyCycleBuff[3]*8 + dutyCycleBuff[2]*4 + dutyCycleBuff[1]*2 + dutyCycleBuff[0]*1;
          Arrays.fill(dutyCycleBuff, 0);
          i = 0;
        }
        else if(count == 24){
          b = dutyCycleBuff[7]*128 + dutyCycleBuff[6]*64 + dutyCycleBuff[5]*32 + dutyCycleBuff[4]*16 + dutyCycleBuff[3]*8 + dutyCycleBuff[2]*4 + dutyCycleBuff[1]*2 + dutyCycleBuff[0]*1;
          Arrays.fill(dutyCycleBuff, 0);
          i = 0;
          count = 0;
          img.pixels[index*8+numLEDs%8] = color(r, g, b); 
          numLEDs++;
          if(numLEDs%8 == 0){
            println(index);
            break;
          }
          if(numLEDs > 64){
          
          }
        }
        oneStartTime = timestamp;
        lowTime = timestamp - zeroStartTime;

        if(oneStartTime - zeroStartTime > 30){
          println("Reset");
          count = 0;
          i = 0;
        }
      }
      prev_state = state;
    }
  }
  }
  img.updatePixels();
  image(img, 0, 0, 100 ,100);
  println("NumLEDs RGB Obtained: ", numLEDs);
}

}

// Sketch prints:
// 3 total rows in table
// Goat (Capra hircus) has an ID of 0
// Leopard (Panthera pardus) has an ID of 1
// Zebra (Equus zebra) has an ID of 2
