/* DDF 2023
 finds contours in a picture according to brightness and exports as PDF
 requires the OPENCV for Processing library installed
 move mouse to change the threshold
 click mouse to save contour as PDF
 press as many times as you want, you get a numbered PDF */
 
import gab.opencv.*;                      
import processing.pdf.*;
PImage src;
OpenCV opencv;
int count = 0;
ArrayList<Contour> contours;

void setup() {
  size(1200, 700);
}

void draw() {
  background (255);
  noFill();  
  if (mousePressed) {                                         // click mouse to start recording PDF
    beginRecord(PDF, "countour"+count++ +".pdf"); 
    noFill();                                                 // we want the PDF with outlines but no fill otherwise we will have double lines in VW or AI
  }
  src = loadImage("test.jpg");                                
  opencv = new OpenCV(this, src);
  opencv.gray();                                               // turn our pic to grayscale
  opencv.blur(5);                                              // blur it to smooth the details
  opencv.threshold(mouseX);                                     // turn to b&w in a threshold of the mouseX                        
 // image(opencv.getOutput(), 0, 0); 
  contours = opencv.findContours();                             // tell opencv to find the contours and return as an array list

  for (Contour thisContour : contours) {                         // visit all elements of the array list "contour" naming each one as "thisContour"
    thisContour.draw();
  }
  endRecord();                                                 // end ther PDF recording, you can call it even if you are not currently recording and it doesnt care
}
