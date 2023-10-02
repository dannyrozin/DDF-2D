/*
DDF 2023
 pose to the camera and press R to export DXF
 */

import processing.dxf.*;
import processing.video.*;


int cellSize = 18;                                                      // Size of each cell in the grid



Capture video;                                                            // Variable for capture device
boolean record = false;

void setup() {
  size(640, 480, P3D);                                                   // DXF likes P3D
  String[] cameras = Capture.list();
  video= new Capture(this, width, height, cameras[0]);                     // new OSX requires that you specify the camera
  video.start();
  image(video,1,1);
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    background(255);
    fill(0);
    if (record == true) {
      beginRaw(DXF, "output.dxf");                                            // Start recording to the file
      noFill();                                                                 // we only want the outline
    }
    for (int x = 0; x < width; x+= cellSize) {                                // loop through pixels jumping "cellSize" on x and y
      for (int y = 0; y < height; y+=cellSize) { 
        color c= video.get(x, y );                                             // get pixel color for each x, y
        float CircleSize= map(brightness(c), 0, 255, cellSize-1, 0);           // get the brightness and then map to 0 - cellSize
        ellipse(x + cellSize/2, y + cellSize/2, CircleSize, CircleSize);       // draw a circle with size porportional to brightness
      }
    }

    if (record == true) {                                                      // wer're done drawing, and we are curently recording
      endRaw();                                                                // stop the recording to DXF
      println("recorded DXF");
      record = false;                                                           // We only want to record once So we set "record" to false
    }
  }
}
void keyPressed() {
  if (key == 'R' || key == 'r') {                                              // Press R to save the file
    record = true;
  }
}
