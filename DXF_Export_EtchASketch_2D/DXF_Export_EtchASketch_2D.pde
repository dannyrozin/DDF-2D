/*
DDF 2023
use the arrow keys to sketch, then press R to record a DXF of the result.
*/

import processing.dxf.*;
boolean record = false;
int move=0, lastMove=0,currentX= 500, currentY=300, lastX=500,lastY=300;
float theta; 
int Xs[] = new int[1];
int Ys[] = new int[1];

void setup() {
  size(1000, 600,P3D);  // DXF Export seems to like P3D
  Xs[0]=currentX;
  Ys[0]=currentY;
}

void draw() {
  background(255);  
  stroke(0);
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }
  
  if (lastMove != move) {    // we changed direction
    Xs= append(Xs,lastX);
    Ys= append(Ys,lastY);
  }

  lastX=currentX;
  lastY=currentY;
  
  for (int i= 0;i<Xs.length-1;i++) {  // draw all the lines we have in our arrays
    line(Xs[i],Ys[i],Xs[i+1],Ys[i+1]);
  }

  line(Xs[Xs.length-1],Ys[Xs.length-1],currentX,currentY); // draw the last line that is not in the array yet
  lastMove = move;


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
  if (keyCode ==UP) { 
    move = 0;
    currentY--;
  }

  if (keyCode ==RIGHT) { 
    move = 1;
    currentX++;
  }
  if (keyCode ==DOWN) { 
    move = 2;
    currentY++;
  }

  if (keyCode ==LEFT) { 
    move = 3;
    currentX--;
  }
}
