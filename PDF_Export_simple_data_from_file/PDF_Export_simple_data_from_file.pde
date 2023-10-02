/*  DDF 2023
 get data from a CSV file and use it to draw something and export as PDF */

import processing.pdf.*;

int[] data;

void setup() {
  size(400, 100);
  String[] stringFromdata = loadStrings("data.txt");                             // load our file into a string array
  data= int(split (stringFromdata[0], ','));                                      // our string arry only has one item because the file had one line                                                                                  // split the String to items using ',' as deliminato                                                                                 
                                                                                  // cast the strings into an int array data[]
  beginRecord(PDF, "output.pdf");                                                  // Start recording to the file

  for (int i = 0; i<data.length; i++) {
    ellipse(i*50, 50, data[i], data[i]);                                            // draw circles based on the numbers in the file
  }
  endRecord();
} 
void draw() {
}
