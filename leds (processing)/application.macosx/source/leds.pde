//square, elipse, line, outlines

int[][] leds;
//for storing drawing in code
PrintWriter file;
//for saving file
BufferedReader reader;
//for reading file

/*
Green - 25, 125, 25
Pink - 255, 0, 200
Purple - 155, 0, 255
Orange = 255, 155, 0
Gray - 127, 127, 127
Light Blue - 0, 125, 255
Turquiose - 64, 224, 204
light green - 144, 255, 144
Brown - 100, 64, 19
*/


void setup() {
  leds = new int[32][32];
  size(800, 700);
  noStroke();
  fill(0);
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      leds[a][b] = 0;
    }
  }
}

//used to keep track of where to draw circles for drawing
float x;
float y;

//used to keep track of when starting position to know where to draw shapes
float hasPressed = 0;
float saveX;
float saveY;
float triangleVertex = 0;
float triVertexX1;
float triVertexY1;
float triVertexX2;
float triVertexY2;
float triVertexX3;
float triVertexY3;

int xShape;
int yShape;

//mode used to store color
int mode = 1;

//mode used to store what shape is being drawn (0 being no shape chosen, 1 for square, 2 for triange, 3 for circle, 4 for line)
int shapeMode = 0;

//mode used to save color but to know where to draw currently chosen highlight
int xMode = 1;
int yMode = 2;

void draw() {
  background(100);
  ellipseMode(CORNER);
  x = 35;
  if(hasPressed == 1 && shapeMode != 2) {
    //if drawer is chosing where to draw rectange, show where orginally clicked
    fill(150);
    ellipse(saveX - 2, saveY - 2, 14, 14);
  } 
  if(triangleVertex > 0 && shapeMode == 2) {
    fill(150);
    if(triangleVertex == 1) {
      ellipse(((triVertexX1 * 20) + 35) - 2, ((triVertexY1 * 20) + 35) - 2, 14, 14);
    } else if(triangleVertex > 1) {
      ellipse(((triVertexX1 * 20) + 35) - 2, ((triVertexY1 * 20) + 35) - 2, 14, 14);
      ellipse(((triVertexX2 * 20) + 35) - 2, ((triVertexY2 * 20) + 35) - 2, 14, 14);
    }
  }
  //uses for nested for loops to draw circles, variables x and y start at 35 (coords), then add 20 each time to draw next rectange
  //at that location
  for(int i = 0; i < 32; i = i + 1) {
    y = 35;
    for(int j = 0; j < 32; j = j + 1) {
      if(mouseX > (x - 2) && mouseX < (x + 12) && mouseY > (y - 2) && mouseY < (y + 12)) {
        if(shapeMode == 1) {
          fill(200);
          if(hasPressed == 0 && mousePressed == true) {
            //saves where clicked and changes variable if in rectange mode.
            saveX = centerize(mouseX);
            saveY = centerize(mouseY);
            hasPressed = 1;
          }
        } else if(shapeMode == 4) {
          fill(200);
          if(hasPressed == 0 && mousePressed == true) {
            saveX = centerize(mouseX);
            saveY = centerize(mouseY);
            hasPressed = 1;
          }
        } else if(shapeMode == 2) {
          fill(200);
          if(mousePressed == true && mouseButton == LEFT && hasPressed == 0) {
            hasPressed = 1;
            if(triangleVertex == 0) {
              triangleVertex = 1;
              triVertexX1 = ((centerize(mouseX) - 35) / 20);
              triVertexY1 = ((centerize(mouseY) - 35) / 20);
            } else if(triangleVertex == 1) {
              triangleVertex = 2;
              triVertexX2 = ((centerize(mouseX) - 35) / 20);
              triVertexY2 = ((centerize(mouseY) - 35) / 20);
            } else if(triangleVertex == 2) {
              triangleVertex = 0;
              triVertexX3 = ((centerize(mouseX) - 35) / 20);
              triVertexY3 = ((centerize(mouseY) - 35) / 20);
              drawLine(triVertexX1, triVertexY1, triVertexX2, triVertexY2);
              drawLine(triVertexX2, triVertexY2, triVertexX3, triVertexY3);
              drawLine(triVertexX3, triVertexY3, triVertexX1, triVertexY1);
            }
            println(triangleVertex);
          }
        } else { 
          //if not in rectange mode, changes that circle in array to the color choosen
          fill(150);
          if(mousePressed == true) {
            if(mouseButton == LEFT) {
              leds[(int)i][(int)j] = mode;
            }
          }
        }
        //draws the highlighted circle
        ellipse(x - 2, y - 2, 14, 14);
      }    
      //uses array to choose the color to set to
      switch(leds[(int)i][(int)j]) {
        case 0:
          fill(0);
          break;
        case 1:
          fill(255);
          break;
        case 2:
          fill(0, 0, 255);
          break;
        case 3:
          fill(0, 255, 0);
          break;
        case 4:
          fill(255, 0, 0);
          break;
        case 5:
          fill(255, 255, 0);
          break;
        case 6:
          fill(0, 255, 255);
          break;
      }
      //draws circle
      ellipse(x, y, 10, 10);  
      y = y + 20;
    }
    x = x + 20;
  }
  
  //color buttons
  fill(255, 0, 0);
  rect(695, 35, 40, 40);
  fill(0, 255, 0);
  rect(735, 35, 40, 40);
  fill(0, 0, 255);
  rect(695, 75, 40, 40);
  fill(255, 255, 0);
  rect(735, 75, 40, 40);
  fill(0, 255, 255);
  rect(695, 115, 40, 40);
  fill(255);
  rect(735, 115, 40, 40);
  fill(0);
  rect(695, 155, 80, 40);
  
  //fill button
  fill(255);
  rect(695, 315, 80, 40);
  textSize(20);
  fill(0);
  text("Fill", 722, 342);
  
  //load and save buttons
  fill(255);
  rect(695, 395, 80, 80);
  textSize(20);
  fill(0);
  text("Load", 715, 422);
  text("Save", 715, 461);
  
  //rectange button
  fill(255);
  rect(695, 235, 80, 80);
  fill(0);
  rect(705, 245, 20, 20);
  
  //circle button
  fill(0);
  ellipse(745, 245, 20, 20);
  
  //triangle button
  fill(0);
  triangle(715, 285, 705, 305, 725, 305);
  
  //line button
  stroke(0);
  line(745, 285, 765, 305);
  noStroke();
  
  if(shapeMode > 0) {
    if(shapeMode == 1) {
      xShape = 0;
      yShape = 0;
    } else if(shapeMode == 2) {
      xShape = 0;
      yShape = 1;
    } else if(shapeMode == 3) {
      xShape = 1;
      yShape = 0;
    } else {
      xShape = 1;
      yShape = 1;
    }
    
    fill(0, 0, 0, 75);
    rect(695 + (xShape * 40), 235 + (yShape * 40), 40, 5);
    rect(695 + (xShape * 40), 270 + (yShape * 40), 40, 5);
    rect(695 + (xShape * 40), 240 + (yShape * 40), 5, 30);
    rect(730 + (xShape * 40), 240 + (yShape * 40), 5, 30);
  }
  
  //highlights the buttons that mouse is over
  if(mouseX >= 695 && mouseY >= 35) {
      float squareX = ((mouseX - 695) - ((mouseX - 695) % 40)) / 40;
      float squareY = ((mouseY - 35) - ((mouseY - 35) % 40)) / 40;
      if(squareY == 3 || squareY == 7 || squareY == 9 || squareY == 10) {
        squareX = 0;
        if(squareY == 3) {
          fill(255, 255, 255, 50);
        } else {
          fill(0, 0, 0, 50);
        }
        rect(695 + (squareX * 40), 35 + (squareY * 40), 80, 5);
        rect(695 + (squareX * 40), 70 + (squareY * 40), 80, 5);
        rect(695 + (squareX * 40), 40 + (squareY * 40), 5, 30);
        rect(730 + ((squareX + 1) * 40), 40 + (squareY * 40), 5, 30);
      } else {
        fill(0, 0, 0, 50);
      }
      //the "or" here is to include the shapes as well so I don't have to repeat code
      if(squareX < 2 && squareY < 3 || squareX < 2 && squareY < 7 && squareY > 4) {
        rect(695 + (squareX * 40), 35 + (squareY * 40), 40, 5);
        rect(695 + (squareX * 40), 70 + (squareY * 40), 40, 5);
        rect(695 + (squareX * 40), 40 + (squareY * 40), 5, 30);
        rect(730 + (squareX * 40), 40 + (squareY * 40), 5, 30);
      }
  }
  
  //different shape and highlight color for black
  fill(0, 0, 0, 100);
  
  if(yMode < 3) {
    rect(695 + (xMode * 40), 35 + (yMode * 40), 40, 5);
    rect(695 + (xMode * 40), 70 + (yMode * 40), 40, 5);
    rect(695 + (xMode * 40), 40 + (yMode * 40), 5, 30);
    rect(730 + (xMode * 40), 40 + (yMode * 40), 5, 30);
  } else {
    fill(255, 255, 255, 150);
    rect(695 + (xMode * 40), 35 + (yMode * 40), 80, 5);
    rect(695 + (xMode * 40), 70 + (yMode * 40), 80, 5);
    rect(695 + (xMode * 40), 40 + (yMode * 40), 5, 30);
    rect(730 + ((xMode + 1) * 40), 40 + (yMode * 40), 5, 30);
  }
}

//just a string to use to store array for saving file
String output = "";

void mousePressed() {
  if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 395 && mouseY <= 435) {
    //button for choosing a file to load
    selectInput("Select a file to load...", "fileLoading");
  } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 435 && mouseY <= 475) {
    //button for choosing a file to save
    //before it asks which file, it stores array in the string output.
    output = "";
    for(int j = 0; j < 32; j = j + 1) {
      for(int k = 0; k < 32; k = k + 1) {
        if(leds[j][k] == 255) {
          output = output + "1"; 
        } else {
          output = output + (int) leds[j][k];
        }
      }
    }
    println(output);
    selectOutput("Select a file to save...", "fileSelected");
  } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 315 && mouseY <= 355) {
    //button for filling the entire screen to one color
    for(int o = 0; o < 32; o = o + 1) {
      for(int p = 0; p < 32; p = p + 1) {
        leds[o][p] = mode;
      }
    }
  } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 35 && mouseY <= 195) {
    //if within these certain coordinates, then it is choosing a color.
    //decides what color is being choosen, then sets it to that color
    
    //math to decide what coord of color is being chosen
    /*    0      1 (x)
        0 red    green
        
        1 blue   yellow
        
        2 cyan   white
        
        3 black  black
        (y)              (for reference)*/
     
    float squareX = ((mouseX - 695) - ((mouseX - 695) % 40)) / 40;
    float squareY = ((mouseY - 35) - ((mouseY - 35) % 40)) / 40;
    
    
    //sets the color to mode variables
    if(squareX == 0 && squareY == 0) {
      println("red"); 
      mode = 4;
      xMode = 0;
      yMode = 0;
    } else if(squareX == 1 && squareY == 0) {
      println("green");
      mode = 3;
      xMode = 1;
      yMode = 0;
    } else if(squareX == 0 && squareY == 1) {
      println("blue");
      mode = 2;
      xMode = 0;
      yMode = 1;
    } else if(squareX == 1 && squareY == 1) {
      println("yellow");
      mode = 5;
      xMode = 1;
      yMode = 1;
    } else if(squareX == 0 && squareY == 2) {
      println("aqua");
      mode = 6;
      xMode = 0;
      yMode = 2;
    } else if(squareX == 1 && squareY == 2) {
      println("white");
      mode = 1;
      xMode = 1;
      yMode = 2;
    } else {
      println("black");
      mode = 0;
      xMode = 0;
      yMode = 3;
    }
  } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 235 && mouseY <= 315) {
    
    float shapeX = ((mouseX - 695) - ((mouseX - 695) % 40)) / 40;
    float shapeY = ((mouseY - 235) - ((mouseY - 235) % 40)) / 40;
    
    if(shapeX == 0 && shapeY == 0) {
      if(shapeMode == 1) {
        shapeMode = 0;
      } else {
        shapeMode = 1;
      }
      println("square");
    } else if(shapeX == 0 && shapeY == 1) {
      if(shapeMode == 2) {
        shapeMode = 0;
      } else {
        shapeMode = 2;
      }
      println("triange");
    } else if(shapeX == 1 && shapeY == 0) {
      if(shapeMode == 3) {
        shapeMode = 0;
      } else {
        shapeMode = 3;
        triangleVertex = 0;
      }
      println("circle");
    } else {
      if(shapeMode == 4) {
        shapeMode = 0;
      } else {
        shapeMode = 4;
      }
      println("line");
    }
    hasPressed = 0;
    println(shapeMode);
  }
}

void fileSelected(File selection) {
  //creates the file, prints in file the drawing, flushes and closes.
  file = createWriter(selection);
  file.println(output);
  file.flush();
  file.close();
}

int ledCounter = 0;
String image;
char[] imageArray;

void fileLoading(File selection) {
  //creates a new array
  imageArray = new char[1024];
  //opens file
  BufferedReader reader = createReader(selection);
  //reads file
  try {
    image = reader.readLine();
  } catch(IOException e) {
    e.printStackTrace();
  }
  //once read, puts into array the code uses
  if(image != null) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        int c = image.charAt(ledCounter) - 48;
        println(c);
        leds[a][b] = c;
        ledCounter++;
      }
    }
    
    ledCounter = 0;
  }
}

//setting up variables for "for" loop in drawing line
int lineLength;
float lineHeight;
float dotX;
float dotY;
float lineX1 ;
float lineY1;
float lineX2;
float lineY2;

void mouseReleased() {
  //this is used when shapes are being draw and when mouse is released to draw shape.
  if(mouseX > 35 && mouseX < 710 && mouseY > 35 && mouseY < 710 && hasPressed == 1) {
    switch(shapeMode) {
      case 1:
        drawSquare((int)saveX, (int)saveY, centerize(mouseX), centerize(mouseY));
      case 4:
        hasPressed = 0;
        
        //these get coordinates of the endpoints of the line
        float x1 = ((saveX - 35) / 20);
        float y1 = ((saveY - 35) / 20);
        float x2 = ((centerize(mouseX) - 35) / 20);
        float y2 = ((centerize(mouseY) - 35) / 20);
        drawLine((int)x1, (int)y1, (int)x2, (int)y2);        
        break;
      case 0:
        hasPressed = 0;
        break;
    }
  } else {
    hasPressed = 0;
  }
  hasPressed = 0;
}

/*centerize aligns where the mouse clicked to the corner of the circle, 
so the code doesn't draw a misaligned circle when drawer chooses a circle to draw.*/
int centerize(int input) {
  int saved = input;
  input = input - 35;
  input = (saved - (input % 10));
  if((input / 10) % 2 == 0) {
    if(((saved - 5) % 10) > 5) {
        input = input + 10;
    } else if(((saved - 5) % 10) < 5) {
        input = input - 10;
    }
  }
  return input;
}

void drawLine(float x1, float y1, float x2, float y2) {
  lineX1 = x1;
  lineY1 = y1;
  lineX2 = x2;
  lineY2 = y2;
  //just flips the coordinates if line is being drawn backwards
  if(lineX1 > lineX2) {
     int tempx1 = (int)lineX1;
     int tempy1 = (int)lineY1;
     lineX1 = lineX2;
     lineY1 = lineY2;
     lineX2 = tempx1;
     lineY2 = tempy1;
  }
  
  //get width and height
  float lineWidth = lineX2 - lineX1 + 1;
  
  if(lineY1 > lineY2) {
    lineHeight = abs(lineY2 - lineY1) + 1;
  } else {
    lineHeight = lineY2 - lineY1 + 1;
  }
  
  //setting up variables for "for" loop
  
  //how the line is drawn can change base on slope if it is less or greater than -1.
  if(lineWidth < lineHeight) {
    dotX = lineX1;
    dotY = lineY1 - 1;
    if(lineY1 > lineY2) {
      dotY = lineY1 + 1;
      leds[(int)dotX][(int)dotY - 1] = mode;
    } else { 
      dotY = lineY1 - 1;
      leds[(int)dotX][(int)dotY + 1] = mode;
      
    }
    lineLength = (int)lineHeight; 
  } else if(lineWidth == lineHeight) {
    dotX = lineX1;
    dotY = lineY1;
    leds[(int)dotX][(int)dotY] = mode;
    lineLength = (int)lineHeight - 1;
  } else {
    dotY = lineY1;
    dotX = lineX1 - 1;
    //leds[(int)dotX + 1][(int)dotY] = mode;
    lineLength = (int)lineWidth;
  }  
  
  leds[(int)lineX2][(int)lineY2] = mode;
  
  for(int i = 0; i < lineLength; i++) {
    if(lineY1 > lineY2) {
      if(lineWidth >= lineHeight) {
         int a = (int)((lineHeight / lineWidth) * (i - 1));
         int b = (int)((lineHeight / lineWidth) * i);
         if(b > a) {
           dotX++;
           dotY--;
         } else {
           dotX++;
         }
      } else {
        int c = (int)((lineWidth / lineHeight) * (i - 1));
        int d = (int)((lineWidth / lineHeight) * i);
        if(d > c) {
          dotX++;
          dotY--;
        } else {
          dotY--;
        }
      }
    } else {
      if(lineWidth >= lineHeight) {
         int a = (int)((lineHeight / lineWidth) * (i - 1));
         int b = (int)((lineHeight / lineWidth) * i);
         if(b > a) {
           dotX++;
           dotY++;
         } else {
           dotX++;
         }
      } else {
        int c = (int)((lineWidth / lineHeight) * (i - 1));
        int d = (int)((lineWidth / lineHeight) * i);
        if(d > c) {
          dotX++;
          dotY++;
        } else {
          dotY++;
        }
      }
    }
    leds[(int)dotX][(int)dotY] = mode;
  }
}

void drawSquare(int x1, int y1, int x2, int y2) {
  //basically this code decides which cirlces to draw in between the pressed and released coords.
  //it just gets more complicated because rectangles can be drawn in four different directions.
  hasPressed = 0;
  x = 35;
  for(int j = 0; j < 32; j++) {
    y = 35;
    for(int i = 0; i < 32; i++) {
      if(x1 > x2 && y1 > y2) {
        if(x < (x1 + 12) && x > (x2 - 2) && y < (y1 + 12) && y > (y2 - 2)) {
          leds[(int)j][(int)i] = mode;
        }
      } else if(x1 > x2 && y1 < y2) {
        if(x < (x1 + 12) && x > (x2 - 2) && y < (y2 + 12) && y > (y1 - 2)) {
          leds[(int)j][(int)i] = mode;
        }
      } else if(x1 < x2 && y1 > y2) {
        if(x < (x2 + 12) && x > (x1 - 2) && y < (y1 + 12) && y > (y2 - 2)) {
          leds[(int)j][(int)i] = mode;
        }
      } else if(x1 < x2 && y1 < y2) {
        if(x < (x2 + 12) && x > (x1 - 2) && y < (y2 + 12) && y > (y1 - 2)) {
          leds[(int)j][(int)i] = mode;
        }
      }
      y += 20;
    }
    x += 20;
  }
}
