/*DDF 2023
 click the mouse to select a color to track, when you are ready , press R to export DXF
 */

import processing.video.*;
import processing.pdf.*;

boolean record = false;
float targetR=255, targetG=255, targetB=255;
Capture video;
int closestX, closestY;
int snakeLength =100;
float snakeX[] =new float[snakeLength];     // array of items of type float hold the X positions
float snakeY[] =new float[snakeLength];  

void setup() {
  size(640, 480); 
  String[] cameras = Capture.list();
  video= new Capture(this, width, height, cameras[0]);                     // new OSX requires that you specify the camera
  fill(targetR, targetG, targetB); 
  strokeWeight(5);
  smooth();
  video.start();
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height);                                                     // Draw the  video onto the screen
    closestX = 0;                                                                           // X-coordinate of the closest video pixel
    closestY = 0;                                                                           // Y-coordinate of the closest video pixel
    video.loadPixels();
    int index = 0;
    int countTheGoods=0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {                                                                              // Get the color stored in the pixel
        color pixelValue = video.pixels[index];
        float distance = dist( targetR, targetG, targetB, red(pixelValue), green(pixelValue), blue(pixelValue));
        // If that value is close enough to what we're looking for, then add the X and Y to the average                                                                                                        // brightness of that pixel, as well as its (x,y) location
        if (distance < 20) {
          closestY += y;
          closestX += x;
          countTheGoods++;
        }
        index++;
      }
    }

    if (countTheGoods>0) {
      closestX/=countTheGoods;                     // divide by the number of good pixels we found to get an average X, and Y
      closestY/=countTheGoods;
    }
    if (mousePressed ==true) {                                             // click mouse to select a new target color
      color pixelValue = video.pixels[mouseX+mouseY*width];   
      targetR=red(pixelValue);
      targetG =green(pixelValue);
      targetB=blue(pixelValue) ;
      fill(targetR, targetG, targetB);
    }

    // Draw a  circle at the closest pixel
    ellipse(closestX, closestY, 20, 20);
  }

  if (closestX >0 && closestY>0) {                           // we don't want to record the times whe we did not find any good pixels
    advanceSnake();
  }
  drawSnake();
}

void advanceSnake() {                                           
  for (int i= 0; i<snakeLength-1; i++) {                       // repeat with the first 49 items of the arrays:                
    snakeX[i]=  snakeX[i+1];                                   // take the value of the next item on X
    snakeY[i]=  snakeY[i+1];                                  //  take the value of the next item on Y
  }
  snakeX[snakeLength-1]= closestX;                                        // the last item, number 49, gets the mouseX and Y values
  snakeY[snakeLength-1]= closestY;
}

void drawSnake() {
  if (record == true) {
    beginRecord(PDF, "output.pdf");  // Start recording to the file
  }
  for (int i= 0; i<snakeLength-1; i++) {                                   // repeat with all 50 items in our array:
    // ellipse( snakeX[i], snakeY[i],20,20);                    // draw a circle
    line(snakeX[i], snakeY[i], snakeX[i+1], snakeY[i+1]);
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
