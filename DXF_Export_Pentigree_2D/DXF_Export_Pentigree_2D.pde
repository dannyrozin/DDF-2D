/** 
 DDF 2021
 Let the sketch evolve till you're happy with it. Then press R to export DXF
 Pentigree L-System 
 by Geraldine Sarmiento (NYU ITP). 
 This code was based on Patrick Dwyer's L-System class. 
 */
import processing.dxf.*;
boolean record = false;

PentigreeLSystem ps;

void setup() {
  size(640, 360, P2D);                             // DXF export only works in P2D and P3D
  smooth();
  ps = new PentigreeLSystem();
  ps.simulate(3);
}

void draw() {
  background(0);
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }
  ps.render();

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
