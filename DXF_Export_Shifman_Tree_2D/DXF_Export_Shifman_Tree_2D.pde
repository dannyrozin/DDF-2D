/*
DDF 2024
Here I mutilated Dan's code to make  "fruit" in the end of the branches , 
just because for laser cutting and such, circles would be more usefull than lines...
When you're happy , press R to export DXF


 * Recursive Tree
 * by Daniel Shiffman.  
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 */


import processing.dxf.*;
boolean record = false;

float theta;   

void setup() {
  size(1280, 720, P3D);
  smooth();
  noFill();
}

void draw() {
  background(0);
  frameRate(30);
  stroke(255);
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  line(0,0,0,-120*2);
  // Move to the end of that line
  translate(0,-120*2);
  // Start the recursive branching!
  branch(120*2);
  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
    println("recorded DXF");
  }
}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 5) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    //line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
   // line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
  else {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    ellipse(0, 0,10,10);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
  }
}
void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}
