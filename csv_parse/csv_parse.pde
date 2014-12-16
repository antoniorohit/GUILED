// The following short CSV file called "mammals.csv" is parsed 
// in the code below. It must be in the project's "data" folder.
//
// id,species,name
// 0,Capra hircus,Goat
// 1,Panthera pardus,Leopard
// 2,Equus zebra,Zebra

Table table;

void setup() {
  int timestamp, state, oneStartTime = 0, highTime, zeroStartTime=0;
  int count;
  float dutyCycle;
  table = loadTable("test1.csv", "header");

//  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    timestamp = row.getInt("timestamp (abs)");
    state = row.getInt("Channel-0");
    
//    println("Timestamp: ", timestamp, " :", state);
    if(state == 0){
      zeroStartTime = timestamp;
      highTime = timestamp - oneStartTime;
      dutyCycle = highTime/5.0;
      if(dutyCycle > 0.5){
        println("###############################");
      }
//      println("DutyCycle: ", (dutyCycle));
    }
    else{
      oneStartTime = timestamp;
      if(oneStartTime - zeroStartTime > 100){
        println("Reset");
        println(count);
        count = 0;
      }
    }
  }
  
}

// Sketch prints:
// 3 total rows in table
// Goat (Capra hircus) has an ID of 0
// Leopard (Panthera pardus) has an ID of 1
// Zebra (Equus zebra) has an ID of 2
