/**  
DDF 2021
Exports PDF, press R to export . Exports rects and circles that can be used to make a necklace
does an FFT analsis of a sound clip and average to 32 buckets
based on example by Damien Di Fede. 
 */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;

import processing.pdf.*;
boolean record = false;


void setup()
{
  size(1200, 800, P3D);  
  minim = new Minim(this);

  jingle = minim.loadFile("jingle.mp3", 2048);
  // loop the file
  jingle.loop();
  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
  // and a sample rate that is the same as jingle's
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  // use 128 averages.
  // the maximum number of averages we could ask for is half the spectrum size. 
  fft.linAverages(32);
  noFill();  // we only want the outline.
}

void draw()
{
  background(255);

  if (record == true) {
    beginRecord(PDF, "output.pdf");  // Start recording to the file
  }


  stroke(0);
  // perform a forward FFT on the samples in jingle's mix buffer
  // note that if jingle were a MONO file, this would be the same as using jingle.left or jingle.right
  fft.forward(jingle.mix);
  int w = int(fft.specSize()/32);
  int currentX= 100, currentY = 300;

  for (int i = 0; i < fft.avgSize(); i++)
  {
    // draw a rectangle for each average, multiply the value by 10 so we can see it better
    rect(i*w+50, 100-fft.getAvg(i)*5, w-2, fft.getAvg(i)*10);
    currentX+= fft.getAvg(i)*40+ 10;

    ellipse(currentX, currentY, fft.getAvg(i)*20, fft.getAvg(i)*20);
    if (currentX> width-100) {
      currentX= 100;
      currentY+= 300;
    }
  }


  if (record == true) {
    endRecord();
    record = false; // Stop recording to the file
    println("recorded PDF");
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}

void stop()
{
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();

  super.stop();
}
