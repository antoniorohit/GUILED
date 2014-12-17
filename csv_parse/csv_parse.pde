// The following short CSV file called "mammals.csv" is parsed 
// in the code below. It must be in the project's "data" folder.
//
import java.util.*;

int HEIGHT = 8;
int WIDTH = 8;

Table table;
PImage img = createImage(HEIGHT, WIDTH, RGB);

void setup() {
  float timestamp, oneStartTime = 0, zeroStartTime=0;
  int state,numLEDs = 0; 
  int count = 0;
  float highTime = 0.00, lowTime = 0.00;
  float dutyCycle;
  int[] dutyCycleBuff = {0, 0, 0, 0, 0, 0, 0 , 0};
  int i = 0;
  int r = 0, g = 0, b = 0;
  int prev_state = 0;
  int rowIndex = 0;
  img.loadPixels();
  float oldTimeStamp = 0;
  
  table = loadTable("tess2.csv", "header");

  int maxRows = table.getRowCount();
  
  // Go through every channel (8 strips)
  for(int index = 7; index >= 0; index--){
      rowIndex = 0;
      prev_state = -1;            // set prev state to be neither of 0 or 1
      highTime = lowTime = oneStartTime = zeroStartTime = numLEDs = 0;
      oldTimeStamp = 0;
      println("Index: ", index);
      // Go through every row in the table
      for (TableRow row : table.rows()) {
      rowIndex++;
      timestamp = row.getFloat("Time[s]");                                    // absolute time in seconds
      state = Integer.parseInt(row.getString(" Channel "+index).trim());      // state of the channel (high or low)
      
//      print("TS: ", timestamp, "S: ", state);
      
        if(state == 0){                                            // LOW
          if(state != prev_state){                                 // PREV STATE WAS HIGH or -1
            zeroStartTime = timestamp;                                  
            if(oneStartTime != 0){                                 // oneStartTime was previously assigned
              highTime += (zeroStartTime - oneStartTime);
            }
  //         println("HT: ", highTime*1000000);
          prev_state = state;
        }
      }
      else{                                    // state == HIGH
        if(state != prev_state){               // prev_state was LOW or -1
          oneStartTime = timestamp;
          if(zeroStartTime != 0){                // zeroStartTime was previously assigned
            lowTime += (oneStartTime - zeroStartTime);
          }
//          println("LT: ", lowTime*1000000); 
           prev_state = state;
            // lots of 0s means a reset
            if(lowTime > 30*0.001*0.001){
              println("Reset");
              count = 0;
              i = 0;
           }
          }
      }
      
      // If the sum of high and low times exceeds 1 period, then we probably have a bit!
      if((highTime + lowTime) > 1.1*0.001*0.001){// || (timestamp - oldTimeStamp > 1.25*.001*.001)){ //us
          oldTimeStamp = timestamp;
          if(lowTime + highTime > 0){
            // DC = high/total time
            dutyCycle = highTime/(0.001*0.001*1.25);//(highTime + lowTime);          // 2.5 cycles = 1.25uS
            if(dutyCycle > .5){                      // WS2811 protocol with a little margin
              dutyCycleBuff[i] = 1;                  // DC buff is a 8 variable buffer to recreate the RGB bytes
            }
            count++;
            i++;
            
//            println("DutyCycle: ", dutyCycle, "TT: ", (highTime+lowTime)*1000000);
            
            // restart counting high and low times
            highTime = lowTime = 0;
          
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
            img.pixels[(7-index)*8+numLEDs%8] = color(2*r, 2*g, 2*b); 
            numLEDs++;
            
            if(numLEDs%8 == 0){
              println("Index:", index, "Row:", rowIndex);
              break;
            }

          }
        }
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0, 100 ,100);
  println("NumLEDs RGB Obtained: ", numLEDs);
}


