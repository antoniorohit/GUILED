#include "mbed.h"
#include "WS2811.h"

#define X_MAX   64
#define Y_MAX   64

#define nRows 8 //The number of rows in a basic block
#define nCols 8 // The number of columns in a basic block

// per LED: 3 * 20 mA = 60mA max
// 60 LEDs: 60 * 60mA = 3600 mA max
// 120 LEDs: 7200 mA max
unsigned const nLEDs = MAX_LEDS_PER_STRIP;          // 64

unsigned const horizontal_blocks = 2; //The number of basic blocks connected horizontally
unsigned const vertical_blocks = 4; //The number of basic blocks connected vertically

//Each mask corresponds to the nth significant bit in a binary word
uint8_t mask_1 = 1;
uint8_t mask_2 = 2;
uint8_t mask_3 = 4;
uint8_t mask_4 = 8;
uint8_t mask_5 = 16;
uint8_t mask_6 = 32;

// Pins *NUMBERS* for PORTC (convenient for KL25Z freedom board)

unsigned const DATA_OUT_PIN1 = 7; // DATA OUT for the highest vertical block
unsigned const DATA_OUT_PIN2 = 0;// The lower the PIN number, the higher it is IRL
unsigned const DATA_OUT_PIN3 = 3;
unsigned const DATA_OUT_PIN4 = 4;

// Address Pin locations (There is some issue with the pins where only these specific pins can be used for addressing.)
DigitalOut ADDRESS_PIN_3(D2); // AKA PTD4
DigitalOut ADDRESS_PIN_2(D3); // AKA PTA12
DigitalOut ADDRESS_PIN_1(D5); // AKA PTA5



Serial pc(USBTX, USBRX);                    //  D1 (PTA2) and D0 (PTA1) on KL25Z

static void clearStrip(WS2811 &strip)
{
    unsigned nLEDs = strip.numPixels();
    for (unsigned i = 0; i < nLEDs; i++) {
        strip.setPixelColor(i, 0, 0, 0);
    }
    strip.show();
}

static void illuminateStrip(WS2811 &strip, uint8_t led_matrix[])
{
    unsigned nLEDs = strip.numPixels();
     for (unsigned i = 0; i < nLEDs; i++) {
        strip.setPixelColor(i, led_matrix[3*i], led_matrix[(3*i)+1], led_matrix[(3*i)+2]);
    }
    strip.show();
}



int main(void)
{
    pc.baud(115200);                            // 11520 Bytes/s -> ~0.3s for 32x32 RGB pixels
    
 
    // Initialize one LED Strip, run from one pin. This is a placeholder for the entire block.

    WS2811 lightStrip1(nLEDs,DATA_OUT_PIN1); //Highest Vertical Block (1.0)
    WS2811 lightStrip2(nLEDs,DATA_OUT_PIN2);
    WS2811 lightStrip3(nLEDs,DATA_OUT_PIN3); 
    WS2811 lightStrip4(nLEDs,DATA_OUT_PIN4); // Lowest Vertical Block   (4.0)
    
    
    /*  -------------------------------------
        |               |                   |
        |   BLOCK       |   BLOCK           |
        |   1.0         |   1.1             |
        |               |                   |
        |_______________|___________________|
        |               |                   |
        |               |                   |
        |   BLOCK       |   BLOCK           |
        |   2.0         |   2.1             |
        |               |                   |
        ----------------|--------------------
            */
    
    lightStrip1.begin();
    lightStrip2.begin();
    lightStrip3.begin();
    lightStrip4.begin();
    
    uint8_t q = 0;                              // index variable
    uint8_t char_buff[10];                          // UART buffer
    uint8_t curr_char = 0;                          // current byte read from UART
   
  
    uint8_t led_matrix[nRows*vertical_blocks][3*nCols*horizontal_blocks] = {0};           // Define a matrix to store RGB info about each LED in the array
    
    uint8_t ledmatrix_row1[3*nCols*horizontal_blocks] = {0};        // Temporary variables to take in each row in an array for input to a function
    uint8_t ledmatrix_row2[3*nCols*horizontal_blocks] = {0};		// Each array represents a separate data pin. All data pins are driven simultaeneously	
    uint8_t ledmatrix_row3[3*nCols*horizontal_blocks] = {0};		// to keep the matrix correct.
    uint8_t ledmatrix_row4[3*nCols*horizontal_blocks] = {0};
    
  
    
    for (;;) {
        
        /* I have defined a custom UART packet protocol
         * A general packet may look like: 
         * char_buff[0]     start byte:     254
         * char_buff[1]     x-coordinate [0, 63]
         * char_buff[2]     y-coordinate [0, 63]
         * char_buff[3]     R (6-bit)    [0, 63]
         * char_buff[4]     G (6-bit)    [0, 63]
         * char_buff[5]     B (6-bit)    [0, 63]
         * char_buff[6]     Delimiter:      255
         */
        while(curr_char != 255 && q < 7)
        {
            /* If there is UART traffic */
            if(pc.readable())
            {
                curr_char = uint8_t(pc.getc());
                char_buff[q] = curr_char;
                q++;
            }
        }
        
        
         
        //Store the RGB values at the correct place in the array
        led_matrix[char_buff[2]][3*(char_buff[1]%X_MAX)]   = char_buff[3];
        led_matrix[char_buff[2]][3*(char_buff[1]%X_MAX)+1] = char_buff[4];
        led_matrix[char_buff[2]][3*(char_buff[1]%X_MAX)+2] = char_buff[5]; 
   
   
   ////////////////////////// Writing the colours to the LED's //////////////////////////////////////
   
        
        unsigned vert_pos = char_buff[2]%Y_MAX; // The absolute vertical position in the structure
        
        unsigned row_pos = char_buff[2] % 8 ; // The relative position of the strip being actuated
        
        if((char_buff[0] == 254) && (q >= 5)){
            
            
                ADDRESS_PIN_1 =  mask_1 & vert_pos; //Change the value on each address pin
                ADDRESS_PIN_2 =  mask_2 & vert_pos;
                ADDRESS_PIN_3 =  mask_3 & vert_pos;
             
               
      
                
                    for (int col = 0; col < 3*nCols*horizontal_blocks; col++){
                    // This is the data to be sent out on each data pin
                            ledmatrix_row1[col] = led_matrix[row_pos] [col];
                            if (vertical_blocks > 1) {
                            	ledmatrix_row2[col] = led_matrix[row_pos+nRows] [col];}	
                            if (vertical_blocks > 2) {
                            	ledmatrix_row3[col] = led_matrix[row_pos+2*nRows] [col];}
                            if (vertical_blocks > 3) {
                            	ledmatrix_row4[col] = led_matrix[row_pos+3*nRows] [col];}
                         }
                         
               
               //		Send the data out into the real world...
                        illuminateStrip(lightStrip1, ledmatrix_row1);
                        
                        if (vertical_blocks > 1) {
                       		illuminateStrip(lightStrip2, ledmatrix_row2);}
                        if (vertical_blocks > 2) {
                        	illuminateStrip(lightStrip3, ledmatrix_row3);}
                        if (vertical_blocks > 3) {
                        	illuminateStrip(lightStrip4, ledmatrix_row4);}
   
           
                
            pc.putc(48+(char_buff[1]));
            
        }
        else{   
                
                // Clear function. Still a little tempermental.
                  for (int col = 0; col < 3*nCols*horizontal_blocks; col++){
                    for (int row = 0; row < nRows*vertical_blocks; row ++) {
                      
                       led_matrix[row][col] = 0; //Set the entire matrix to zero
                        } 
                    }
                    
                    for (int j = 0; j <nRows; j ++) {
                    	
                    	 ADDRESS_PIN_1 =  mask_1 & j; 
                		 ADDRESS_PIN_2 =  mask_2 & j;
                		 ADDRESS_PIN_3 =  mask_3 & j;
            	
            			clearStrip(lightStrip1);
                		clearStrip(lightStrip2);
                		clearStrip(lightStrip3);
                		clearStrip(lightStrip4);
                		}                  
        }
        q = 0;
        curr_char = 0;
        WS2811::startDMA();

    }
}
