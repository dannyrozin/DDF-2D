/*  DDF 2023
 Creates a gradient made of random shapes
 Press R to Export PDF  */

import processing.pdf.*;
boolean record = false;

void setup() {
  size(1000, 700);   
  fill(0);
  frameRate(2);
}

void draw() {
  background(255);
  if (record == true) {
    beginRecord(PDF, "output.pdf");  // Start recording to the file
  }

  stroke(0);
  for (int x=0; x<width; x+=50) {
    for (int y=0; y<height; y+=50) {
      int shapeSize = x/25;
      if  ( random(2) < 1) {
        ellipse(x, y, shapeSize, shapeSize);
      } else {
        rect(x-shapeSize/2, y-shapeSize/2, shapeSize, shapeSize);
      }
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
