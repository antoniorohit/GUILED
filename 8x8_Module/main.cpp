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
unsigned const DATA_OUT_PIN8 = 11;

Serial pc(USBTX, USBRX);					//  D1 (PTA2) and D0 (PTA1) on KL25Z

static void clearStrip(WS2811 &strip)
{
    unsigned nLEDs = strip.numPixels();
    for (unsigned i = 0; i < nLEDs; i++) {
        strip.setPixelColor(i, 0, 0, 0);
    }
    strip.show();
}

static void showSolidColor(WS2811 &strip, uint8_t r, uint8_t g, uint8_t b)
{
    unsigned nLEDs = strip.numPixels();
    for (unsigned i = 0; i < nLEDs; i++) {
        strip.setPixelColor(i, r, g, b);
    }
    strip.show();
}

int main(void)
{
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
    
    lightStrip1.begin();
    lightStrip2.begin();
    lightStrip3.begin();
    lightStrip4.begin();
    lightStrip5.begin();
    lightStrip6.begin();
    lightStrip7.begin();
    lightStrip8.begin();

    uint8_t q = 0, r, g, b = 0;								// index variable
    
    for (;;) {

    	q++;
            switch(q%8){
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
            default:
                lightStrip = &lightStrip1;
                q = 0;
                break;   
            }
            // 								{PIXEL_POS (X), 		R, 				G, 				B}
//            (*lightStrip).setPixelColor(char_buff[1]%X_MAX, (char_buff[3]), (char_buff[4]), (char_buff[5]));
    		showSolidColor( (*lightStrip), q/5,q/2,q/3);

            (*lightStrip).show();
            WS2811::startDMA();
    		wait(0.01);

        }

}
