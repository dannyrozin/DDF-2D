
/*
DDF 2024
Make sure the audio input is set to the internal mic then sing into it to get nice waves
and press R to record DXF
/**
 * This sketch shows how to use the Waveform class to analyze a stream
 * of sound. Change the number of samples to extract and draw a longer/shorter
 * part of the waveform.
 */
import processing.dxf.*;
import processing.sound.*;

// Declare the sound source and Waveform analyzer variables
AudioIn input;
Waveform waveform;
boolean record = false;



// Define how many samples of the Waveform you want to be able to read at once
int samples = 300;

public void setup() {
  size(640, 360,P3D);
  background(255);

input = new AudioIn(this, 0);
input.start();

  // Create the Waveform analyzer and connect the playing soundfile to it.
  waveform = new Waveform(this, samples);
  waveform.input(input);
}

public void draw() {
  // Set background color, noFill and stroke style
  background(0);
  stroke(255);
  strokeWeight(2);
  noFill();
 
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }
 
  // Perform the analysis
  waveform.analyze();

  beginShape();
  for (int i = 0; i < samples; i++) {
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1
    vertex(
      map(i, 0, samples, 0, width),
      map(waveform.data[i], -1, 1, 0, height)
      );
  }
  endShape();
  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
    println("recorded DXF");
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}
