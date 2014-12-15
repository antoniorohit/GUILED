#include "mbed.h"
#include "WS2811.h"

#define X_MAX	64
#define Y_MAX	64

// per LED: 3 * 20 mA = 60mA max
// 60 LEDs: 60 * 60mA = 3600 mA max
// 120 LEDs: 7200 mA max
unsigned const nLEDs = MAX_LEDS_PER_STRIP;			// 64

// Pins *NUMBERS* for PORTC (convenient for KL25Z freedom board)
unsigned const DATA_OUT_PIN1 = 7; 
unsigned const DATA_OUT_PIN2 = 0; 
unsigned const DATA_OUT_PIN3 = 3; 
unsigned const DATA_OUT_PIN4 = 4; 
unsigned const DATA_OUT_PIN5 = 5; 
unsigned const DATA_OUT_PIN6 = 6; 
unsigned const DATA_OUT_PIN7 = 10; 

// Next 8 pin *NUMBERS* - these are randomly spaced across the board
unsigned const DATA_OUT_PIN8 = 11; 
unsigned const DATA_OUT_PIN9 = 1;
unsigned const DATA_OUT_PIN10 = 2;
unsigned const DATA_OUT_PIN11 = 8;
unsigned const DATA_OUT_PIN12 = 9;
unsigned const DATA_OUT_PIN13 = 12;
unsigned const DATA_OUT_PIN14 = 13;
unsigned const DATA_OUT_PIN15 = 16;
unsigned const DATA_OUT_PIN16 = 17;


Serial pc(USBTX, USBRX);					//  D1 (PTA2) and D0 (PTA1) on KL25Z

static void clearStrip(WS2811 &strip)
{
    unsigned nLEDs = strip.numPixels();
    for (unsigned i = 0; i < nLEDs; i++) {
        strip.setPixelColor(i, 0, 0, 0);
    }
    strip.show();
}

int main(void)
{
	pc.baud(115200);							// 11520 Bytes/s -> ~0.3s for 32x32 RGB pixels
    WS2811 *lightStrip;
    // Initialize an 8-strip matrix
    WS2811 lightStrip1(nLEDs, DATA_OUT_PIN1);
    WS2811 lightStrip2(nLEDs, DATA_OUT_PIN2);
    WS2811 lightStrip3(nLEDs, DATA_OUT_PIN3);
    WS2811 lightStrip4(nLEDs, DATA_OUT_PIN4);    
    WS2811 lightStrip5(nLEDs, DATA_OUT_PIN5);
    WS2811 lightStrip6(nLEDs, DATA_OUT_PIN6);
    WS2811 lightStrip7(nLEDs, DATA_OUT_PIN7);
    WS2811 lightStrip8(nLEDs, DATA_OUT_PIN8);
    
    WS2811 lightStrip9(nLEDs, DATA_OUT_PIN9);
    WS2811 lightStrip10(nLEDs, DATA_OUT_PIN10);
    WS2811 lightStrip11(nLEDs, DATA_OUT_PIN11);
    WS2811 lightStrip12(nLEDs, DATA_OUT_PIN12);
    WS2811 lightStrip13(nLEDs, DATA_OUT_PIN13);
    WS2811 lightStrip14(nLEDs, DATA_OUT_PIN14);
    WS2811 lightStrip15(nLEDs, DATA_OUT_PIN15);
    WS2811 lightStrip16(nLEDs, DATA_OUT_PIN16);

    lightStrip1.begin();
    lightStrip2.begin();
    lightStrip3.begin();
    lightStrip4.begin();
    lightStrip5.begin();
    lightStrip6.begin();
    lightStrip7.begin();
    lightStrip8.begin();

//    lightStrip9.begin();
//    lightStrip10.begin();
//    lightStrip11.begin();
//    lightStrip12.begin();
//    lightStrip13.begin();
//    lightStrip14.begin();
//    lightStrip15.begin();
//    lightStrip16.begin();

    uint8_t q = 0;								// index variable
    uint8_t char_buff[10];							// UART buffer
    uint8_t curr_char = 0;							// current byte read from UART
    
    for (;;) {
        /* I have defined a custom UART packet protocol
         * A general packet may look like: 
         * char_buff[0]		start byte: 	254
         * char_buff[1]     x-coordinate [0, 63]
         * char_buff[2]     y-coordinate [0, 63]
         * char_buff[3]     R (6-bit)	 [0, 63]
         * char_buff[4]     G (6-bit)	 [0, 63]
         * char_buff[5]     B (6-bit)	 [0, 63]
         * char_buff[6]     Delimiter: 		255
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
        
        if((char_buff[6] == 255) && (q > 5)){
            switch(char_buff[2]%Y_MAX){
            case 0:
                lightStrip = &lightStrip1;
                break;
            case 1:
                lightStrip = &lightStrip2;
                break;
            case 2:
                lightStrip = &lightStrip3;
                break;
            case 3:
                lightStrip = &lightStrip4;
                break;
            case 4:
                lightStrip = &lightStrip5;
                break;
            case 5:
                lightStrip = &lightStrip6;
                break;
            case 6:
                lightStrip = &lightStrip7;
                break;
            case 7:
                lightStrip = &lightStrip8;
                break;        
//            case 8:
//                lightStrip = &lightStrip9;
//                break;
//            case 9:
//                lightStrip = &lightStrip10;
//                break;
//            case 10:
//                lightStrip = &lightStrip11;
//                break;
//            case 11:
//                lightStrip = &lightStrip12;
//                break;
//            case 12:
//                lightStrip = &lightStrip13;
//                break;
//            case 13:
//                lightStrip = &lightStrip14;
//                break;
//            case 14:
//                lightStrip = &lightStrip15;
//                break;
//            case 15:
//                lightStrip = &lightStrip16;
//                break;
            default:
                lightStrip = &lightStrip1;
                q = 0;
                break;   
            }
            // 								{PIXEL_POS (X), 		R, 				G, 				B}
            (*lightStrip).setPixelColor(char_buff[1]%X_MAX, (char_buff[3]), (char_buff[4]), (char_buff[5]));
            
            (*lightStrip).show();
            pc.putc((char_buff[3]));
            WS2811::startDMA();
        }
        else{
        	if(q == 2){
				clearStrip(lightStrip1);
				clearStrip(lightStrip2);
				clearStrip(lightStrip3);
				clearStrip(lightStrip4);
				clearStrip(lightStrip5);
				clearStrip(lightStrip6);
				clearStrip(lightStrip7);
				clearStrip(lightStrip8);
//				clearStrip(lightStrip9);
//				clearStrip(lightStrip10);
//				clearStrip(lightStrip11);
//				clearStrip(lightStrip12);
//				clearStrip(lightStrip13);
//				clearStrip(lightStrip14);
//				clearStrip(lightStrip15);
//				clearStrip(lightStrip16);
		        WS2811::startDMA();

        	}
        }
        q = 0;
        curr_char = 0;

    }
}

