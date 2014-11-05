#include "mbed.h"
DigitalOut myled(LED1);
char x, y;
Serial pc(USBTX, USBRX); // tx, rx
SPI mySPI(D11, D12, D13);
struct color_s{
  uint8_t r;
  uint8_t g;
  uint8_t b;

};
typedef struct color_s color_t;
color_t matrix[64][64];// array to hold all pixel values

int main() {
  uint8_t read_data;
  myled = 0;
  pc.baud(115200);
  mySPI.frequency(20000000);
  mySPI.format(8, 0);

    
  for(int i=0; i<64; i++){
    for(int j=0; j< 64; j++){
      matrix[i][j].r = (i*4)%254;
      matrix[i][j].g = (j*4)%254;
      matrix[i][j].b = (2*(i+j))%254;
    }
  }


  while(1) {
    //read_data = mySPI.write(0);
    for(int i=0; i<64; i++){
      for(int j=0; j< 64; j++){
	while(pc.getc() != 'G');
        pc.putc(i);
	pc.putc(j);
	pc.putc(matrix[i][j].r);
	pc.putc(matrix[i][j].g);
	pc.putc(matrix[i][j].b);
	pc.putc(char(255));
	myled = !myled.read();
	wait(0.1);
      }
    }

  }
}
