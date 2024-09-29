/**  
DDF 2024
Exports PDF, press R to export . Exports rects and circles that can be used to make a necklace
does an FFT analsis of a sound clip and average to 32 buckets
 */
/**
 * This sketch shows how to use the FFT class to analyze a stream
 * of sound. Change the number of bands to get more spectral bands
 * (at the expense of more coarse-grained time resolution of the spectrum).
 */

import processing.sound.*;
import processing.pdf.*;

// Declare the sound source and FFT analyzer variables
SoundFile sample;
FFT fft;
boolean record = false;

// Define how many FFT bands to use (this needs to be a power of two)
int bands = 128;

// Define a smoothing factor which determines how much the spectrums of consecutive
// points in time should be combined to create a smoother visualisation of the spectrum.
// A smoothing factor of 1.0 means no smoothing (only the data from the newest analysis
// is rendered), decrease the factor down towards 0.0 to have the visualisation update
// more slowly, which is easier on the eye.
float smoothingFactor = 0.2;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];

// Variables for drawing the spectrum:
// Declare a scaling factor for adjusting the height of the rectangles
int scale = 5;
// Declare a drawing variable for calculating the width of the
float barWidth;

public void setup() {
  size(1640, 360);
  background(255);

  // Calculate the width of the rects depending on how many bands we have
  barWidth = width/float(bands);

  // Load and play a soundfile and loop it.
  sample = new SoundFile(this, "jingle.mp3");
  sample.loop();

  // Create the FFT analyzer and connect the playing soundfile to it.
  fft = new FFT(this, bands);
  fft.input(sample);
}

public void draw() {
  int currentX= 50;
  // Set background color, noStroke and fill color
  background(255);
  noFill();


  if (record == true) {
    beginRecord(PDF, "output.pdf");  // Start recording to the file
  }

  // Perform the analysis
  fft.analyze();

  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    currentX+=sum[i]*height*scale/2+10;
    circle(currentX, height/2, sum[i]*height*scale);
     circle(currentX, height/2, 3);
    currentX+=sum[i]*height*scale/2+10;
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
