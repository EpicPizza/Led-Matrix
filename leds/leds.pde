import java.util.*;

//square, elipse, line, outlines

char[][] leds;

//for undo and redo
char[][][] ledsLast;
char[][][] ledsNext;

//for storing drawing in code
PrintWriter file;
//for saving file
BufferedReader reader;
//for reading file
colors Colors;

int red;
int blue;
int green;
int fillMode = 1;
int alertMode = 0;

HashMap<colors, Character> map;

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

void resetUndoAndRedo() {
  for(int i = 0; i < 40; i++) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsLast[i][a][b] = '0';
        ledsNext[i][a][b] = '0';
      }
    }
  } 
}

void setup() {
  leds = new char[32][32];
  ledsLast = new char[40][32][32];
  ledsNext = new char[40][32][32];
  size(880, 700);
  noStroke();
  fill(0);
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      leds[a][b] = 'g';
    }
  }
  
  resetUndoAndRedo();
  
  Colors = new colors(255, 255, 255);
  Colors.addColor(255, 0, 0);
  Colors.addColor(0, 255, 0);
  Colors.addColor(0, 0, 255);
  Colors.addColor(0, 255, 255);
  Colors.addColor(255, 255, 0);
  Colors.addColor(0, 0, 0);
  Colors.addColor(25, 125, 25);
  Colors.addColor(255, 0, 200);
  Colors.addColor(155, 0, 255);
  Colors.addColor(127, 127, 127);
  Colors.addColor(255, 155, 0);
  Colors.addColor(0, 125, 255);
  Colors.addColor(64, 224, 204);
  Colors.addColor(144, 255, 144);
  Colors.addColor(100, 64, 19);
  
  map = Colors.getCharMap();
  
  /*for(colors c: map.keySet()) {
    println(map.get(c) + ", " + c); 
  }*/
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
char mode = 'a';

//mode used to store what shape is being drawn (0 being no shape chosen, 1 for square, 2 for triange, 3 for circle, 4 for line)
int shapeMode = 0;

//mode used to save color but to know where to draw currently chosen highlight
int xMode = 1;
int yMode = 2;

void draw() {
  background(100);
  ellipseMode(CORNER);
  Colors.displayColors();
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
      if(alertMode == 0) {
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
          } else if(shapeMode == 3) {
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
                save();
                triangleVertex = 0;
                triVertexX3 = ((centerize(mouseX) - 35) / 20);
                triVertexY3 = ((centerize(mouseY) - 35) / 20);
                if(fillMode == 0) {
                  drawLine((int)triVertexX1, (int)triVertexY1, (int)triVertexX2, (int)triVertexY2);
                  drawLine((int)triVertexX2, (int)triVertexY2, (int)triVertexX3, (int)triVertexY3);
                  drawLine((int)triVertexX3, (int)triVertexY3, (int)triVertexX1, (int)triVertexY1);
                } else {
                  drawLine((int)triVertexX1, (int)triVertexY1, (int)triVertexX2, (int)triVertexY2);
                  drawLine((int)triVertexX2, (int)triVertexY2, (int)triVertexX3, (int)triVertexY3);
                  drawLine((int)triVertexX3, (int)triVertexY3, (int)triVertexX1, (int)triVertexY1);
                  drawFilledTriangle((int)triVertexX1, (int)triVertexY1, (int)triVertexX2, (int)triVertexY2, (int)triVertexX3, (int)triVertexY3);
                }
              }
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
      }
      //uses array to choose the color to set to
      switch(leds[(int)i][(int)j]) {
        case 'a':
          fill(255);
          break;
        case 'b':
          fill(255, 0, 0);
          break;
        case 'c':
          fill(0, 255, 0);
          break;
        case 'd':
          fill(0, 0, 255);
          break;
        case 'e':
          fill(0, 255, 255);
          break;
        case 'f':
          fill(255, 255, 0);
          break;
        case 'g':
          fill(0, 0, 0);
          break;
        case 'h':
          fill(25, 125, 25);
          break;
        case 'i':
          fill(255, 0, 200);
          break;
        case 'j':
          fill(155, 0, 255);
          break;
        case 'k':
          fill(127, 127, 127);
          break;
        case 'l':
          fill(255, 155, 0);
          break;
        case 'm':
          fill(0, 125, 255);
          break;
        case 'n':
          fill(64, 224, 204);
          break;
        case 'o':
          fill(144, 255, 144);
          break;
        case 'p':
          fill(100, 64, 19);
          break;
      }
      //draws circle
      ellipse(x, y, 10, 10);  
      y = y + 20;
    }
    x = x + 20;
  }
  
  //color buttons
  /*fill(255, 0, 0);
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
  rect(695, 155, 80, 40);*/
  
  //fill button
  fill(255);
  rect(775, 235, 80, 80);
  textSize(20);
  fill(0);
  text("Fill", 802, 262);
  
  //775
  //275
  fill(0);
  
  noFill();
  stroke(0);
  strokeWeight(2);
  rect(785, 285, 20, 20);
  fill(150);
  rect(825, 285, 20, 20);
  noStroke();
    
  //load and save buttons
  fill(255);
  rect(695, 315, 160, 80);
  rect(695, 435, 160, 40);
  textSize(20);
  fill(0);
  text("Load", 715, 462);
  text("Save", 795, 462);
  
  //move up, down, right, left, buttons
  stroke(0);
  strokeWeight(2);
  noFill();
  rect(705, 325, 20, 20);
  line(715, 330, 715, 340);
  triangle(715, 330, 712, 333, 718, 333);
  rect(745, 325, 20, 20);
  line(755, 330, 755, 340);
  triangle(755, 340, 752, 337, 758, 337);
  rect(785, 325, 20, 20);
  line(790, 335, 800, 335);
  triangle(790, 335, 793, 338, 793, 332);
  rect(825, 325, 20, 20);
  line(830, 335, 840, 335);
  triangle(840, 335, 837, 338, 837, 332);
  
  noStroke();
  
  //695, 315
  
  //undo and redo buttons
  fill(255);
  stroke(0);
  noFill();
  strokeWeight(4);
  ellipseMode(CENTER);
  arc(735, 388, 32, 32, -HALF_PI-QUARTER_PI, -QUARTER_PI);
  arc(815, 388, 32, 32, -HALF_PI-QUARTER_PI, -QUARTER_PI);
  fill(0);
  triangle(722, 376, 723, 372.5, 726, 377.5);
  triangle(828, 376, 827, 372.5, 823, 377.5);
  noStroke();
  ellipseMode(CORNER); //for everywhere else in the code
  //695 355
  
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
  
  //Highlights current color---------------------------------------
  int modeNumber = mode - 97;
  
  int modeX = round(modeNumber / 4);
  int modeY = modeNumber % 4;
  
  if(mode != 'd' && mode != 'g') {
    fill(0, 0, 0, 75);
  } else {
    fill(255, 255, 255, 200);
  }
  
  rect((modeX * 40) + 695, (modeY * 40) + 35, 5, 40);
  rect((modeX * 40) + 695 + 35, (modeY * 40) + 35, 5, 40);
  rect((modeX * 40) + 695 + 5, (modeY * 40) + 35, 30, 5);
  rect((modeX * 40) + 695 + 5, (modeY * 40) + 35 + 35, 30, 5);
  //---------------------------------------------------------------
  
  if(alertMode == 0) {
    //highlights color over
    if(mouseX >= 695 && mouseX <= 855 && mouseY >= 35 && mouseY <= 195) {
        ArrayList<Integer> coords = Colors.coordColor(mouseX, mouseY);
        if(coords == null) {
          //nothing
        } else {
          char b = Colors.whatColor(mouseX, mouseY);
          if(b == 'g' || b == 'd') {
            fill(255, 255, 255, 200);
          } else {
            fill(0, 0, 0, 75);
          }
          rect(coords.get(0), coords.get(1), 5, 40);
          rect(coords.get(0) + 35, coords.get(1), 5, 40);
          rect(coords.get(0) + 5, coords.get(1), 30, 5);
          rect(coords.get(0) + 5, coords.get(1) + 35, 30, 5);
        }
    }
    
    //highlights the buttons that mouse is over
    if(mouseX >= 695 && mouseY >= 235) {
        float squareX = ((mouseX - 695) - ((mouseX - 695) % 40)) / 40;
        float squareY = ((mouseY - 35) - ((mouseY - 35) % 40)) / 40;
        if(squareY == 5 && (squareX == 3 || squareX == 2) || (squareY == 8 || squareY == 10) && squareX < 4) {
          if(squareX == 1) {
            squareX = 0;
          } else if(squareX == 3) {
            squareX = 2;
          }
          fill(0, 0, 0, 50);
          rect(695 + (squareX * 40), 35 + (squareY * 40), 80, 5);
          rect(695 + (squareX * 40), 70 + (squareY * 40), 80, 5);
          rect(695 + (squareX * 40), 40 + (squareY * 40), 5, 30);
          rect(730 + ((squareX + 1) * 40), 40 + (squareY * 40), 5, 30);
        } else {
          fill(0, 0, 0, 50);
        }
        
        if(squareX < 2 && squareY < 7 && squareY > 4 || squareX > 1 && squareX < 4 && squareY > 5 && squareY < 7 || squareY == 7 && squareX < 4) {
          rect(695 + (squareX * 40), 35 + (squareY * 40), 40, 5);
          rect(695 + (squareX * 40), 70 + (squareY * 40), 40, 5);
          rect(695 + (squareX * 40), 40 + (squareY * 40), 5, 30);
          rect(730 + (squareX * 40), 40 + (squareY * 40), 5, 30);
        }
    }
  }
  
  fill(0, 0, 0, 75);
  if(fillMode == 1) {
    rect(695 + (3 * 40), 35 + (6 * 40), 40, 5);
    rect(695 + (3 * 40), 70 + (6 * 40), 40, 5);
    rect(695 + (3 * 40), 40 + (6 * 40), 5, 30);
    rect(730 + (3 * 40), 40 + (6 * 40), 5, 30);
  } else {
    rect(695 + (2 * 40), 35 + (6 * 40), 40, 5);
    rect(695 + (2 * 40), 70 + (6 * 40), 40, 5);
    rect(695 + (2 * 40), 40 + (6 * 40), 5, 30);
    rect(730 + (2 * 40), 40 + (6 * 40), 5, 30);
  }
  
  if(alertMode == 1) {
    fill(0, 0, 0, 100);
    rect(0, 0, 880, 700);
  }
}

//just a string to use to store array for saving file
String output = "";

void save() {
  for(int i = 39; i > 0; i--) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsLast[i][a][b] = ledsLast[i - 1][a][b];
      }
    }
  }
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      ledsLast[0][a][b] = leds[a][b];
    }
  }
  for(int i = 39; i > -1; i--) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsNext[i][a][b] = '0';
      }
    }
  }
}

void undo() {
    for(int i = 39; i > 0; i--) {
      for(int a = 0; a < 32; a = a + 1) {
        for(int b = 0; b < 32; b = b + 1) {
          ledsNext[i][a][b] = ledsNext[i - 1][a][b];
        }
      }
    }
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsNext[0][a][b] = leds[a][b];
      }
    }
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        leds[a][b] = ledsLast[0][a][b];
      }
    }
    for(int i = 0; i < 39; i++) {
      for(int a = 0; a < 32; a = a + 1) {
        for(int b = 0; b < 32; b = b + 1) {
          ledsLast[i][a][b] = ledsLast[i + 1][a][b];
        }
      }
    }
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsLast[39][a][b] = '0';
      }
    }  
}

void redo() {
  for(int i = 39; i > 0; i--) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsLast[i][a][b] = ledsLast[i - 1][a][b];
      }
    }
  }
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      ledsLast[0][a][b] = leds[a][b];
    }
  }
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      leds[a][b] = ledsNext[0][a][b];
    }
  }
  for(int i = 0; i < 39; i++) {
    for(int a = 0; a < 32; a = a + 1) {
      for(int b = 0; b < 32; b = b + 1) {
        ledsNext[i][a][b] = ledsNext[i + 1][a][b];
      }
    }
  }
  for(int a = 0; a < 32; a = a + 1) {
    for(int b = 0; b < 32; b = b + 1) {
      ledsNext[39][a][b] = '0';
    }
  }
}

void mousePressed() {
  if(alertMode == 0) {
    if(mouseX >= 35 && mouseY >= 35 && mouseX <= 665 && mouseY <= 665 && shapeMode != 2) {  
      save();
    }
    
    if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 435 && mouseY <= 475) {
      //button for choosing a file to load
      selectInput("Select a file to load...", "fileLoading");
    } else if(mouseButton == LEFT && mouseX >= 775 && mouseX <= 855 && mouseY >= 435 && mouseY <= 475) {
      //button for choosing a file to save.
      //before it asks which file, it stores array in the string output.
      output = "";
      for(int j = 0; j < 32; j = j + 1) {
        for(int k = 0; k < 32; k = k + 1) {
          if(leds[j][k] == 255) {
            output = output + "1"; 
          } else {
            output = output + (char) leds[j][k];
          }
        }
      }
      println(output);
      selectOutput("Select a file to save...", "fileSelected");
    } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 355 && mouseY <= 395) {
      if(ledsLast[0][0][0] == '0') {
        println("cannot undo");
      } else {
        undo();
      }
    } else if(mouseButton == LEFT && mouseX >= 775 && mouseX <= 855 && mouseY >= 355 && mouseY <= 395) {
      if(ledsNext[0][0][0] == '0') {
        println("cannot redo");
      } else {
        redo();
      }
    } else if(mouseButton == LEFT && mouseX >= 775 && mouseX <= 855 && mouseY >= 235 && mouseY <= 275) {
      save();
      //button for filling the entire screen to one color
      for(int o = 0; o < 32; o = o + 1) {
        for(int p = 0; p < 32; p = p + 1) {
          leds[o][p] = mode;
        }
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
      } else if(shapeX == 0 && shapeY == 1) {
        if(shapeMode == 2) {
          shapeMode = 0;
        } else {
          shapeMode = 2;
        }
      } else if(shapeX == 1 && shapeY == 0) {
        if(shapeMode == 3) {
          shapeMode = 0;
        } else {
          shapeMode = 3;
          triangleVertex = 0;
        }
      } else {
        if(shapeMode == 4) {
          shapeMode = 0;
        } else {
          shapeMode = 4;
        }
      }
      triangleVertex = 0;
      hasPressed = 0;
    } else if(mouseButton == LEFT && mouseX >= 775 && mouseX <= 815 && mouseY >= 275 && mouseY <= 315) {
      fillMode = 0;
    } else if(mouseButton == LEFT && mouseX >= 815 && mouseX <= 855 && mouseY >= 275 && mouseY <= 315) {
      fillMode = 1;
    } else if(mouseButton == LEFT && mouseX >= 775 && mouseX <= 815 && mouseY >= 315 && mouseY <= 355) {
      //left
      save();
      for(int i = 0; i <= 30; i++) {
        for(int b = 0; b <= 31; b++) {
          leds[i][b] = ledsLast[0][i + 1][b];
        }
      }
      for(int b = 0; b <= 31; b++) {
        leds[31][b] = 'g';
      }
    } else if(mouseButton == LEFT && mouseX >= 815 && mouseX <= 855 && mouseY >= 315 && mouseY <= 355) {
      //right
      save();
      for(int i = 0; i <= 30; i++) {
        for(int b = 0; b <= 31; b++) {
          leds[i + 1][b] = ledsLast[0][i][b];
        }
      }
      for(int b = 0; b <= 31; b++) {
        leds[0][b] = 'g';
      }
    } else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 735 && mouseY >= 315 && mouseY <= 355) {
      //up
      save();
      for(int i = 0; i <= 30; i++) {
        for(int b = 0; b <= 31; b++) {
          leds[b][i] = ledsLast[0][b][i + 1];
        }
      }
      for(int b = 0; b <= 31; b++) {
        leds[b][31] = 'g';
      }
    } else if(mouseButton == LEFT && mouseX >= 735 && mouseX <= 775 && mouseY >= 315 && mouseY <= 355) {
      //down
      save();
      for(int i = 0; i <= 30; i++) {
        for(int b = 0; b <= 31; b++) {
          leds[b][i + 1] = ledsLast[0][b][i];
        }
      }
      for(int b = 0; b <= 31; b++) {
        leds[b][0] = 'g';
      }
    } 
    
    if(Colors.pressedColor(mouseX, mouseY) != null) {
      colors colorChosen = Colors.pressedColor(mouseX, mouseY);
      red = colorChosen.getRed();
      green = colorChosen.getGreen();
      blue = colorChosen.getBlue();
      for(colors c: map.keySet()) {
        //println(c + " " + map.get(c)); 
        if(c.getRed() == red && c.getGreen() == green && c.getBlue() == blue) {
          mode = map.get(c);  
        }
      }
    }
  }
  
  //Old color choser:
  /*else if(mouseButton == LEFT && mouseX >= 695 && mouseX <= 775 && mouseY >= 35 && mouseY <= 195) {
    //if within these certain coordinates, then it is choosing a color.
    //decides what color is being choosen, then sets it to that color
    
    //math to decide what coord of color is being chosen
    /*    0      1 (x)
        0 red    green
        
        1 blue   yellow
        
        2 cyan   white
        
        3 black  black
        (y)              (for reference)
     
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
  }  */
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
        char c = image.charAt(ledCounter);
        println(c);
        leds[a][b] = (char)c;
        ledCounter++;
      }
    }
    
    ledCounter = 0;
  }
  
  resetUndoAndRedo();
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
  int x1 = (int)((saveX - 35) / 20);
  int y1 = (int)((saveY - 35) / 20);
  int x2 = (int)((centerize(mouseX) - 35) / 20);
  int y2 = (int)((centerize(mouseY) - 35) / 20);
  //this is used when shapes are being draw and when mouse is released to draw shape.
  if(mouseX > 30 && mouseX < 670 && mouseY > 30 && mouseY < 670 && hasPressed == 1) {
    switch(shapeMode) {
      case 1:
        if(fillMode == 1) {
          drawSquare((int)saveX, (int)saveY, centerize(mouseX), centerize(mouseY));
        } else {
          drawLine(x1, y1, x2, y1);
          drawLine(x2, y1, x2, y2);
          drawLine(x2, y2, x1, y2);
          drawLine(x1, y2, x1, y1);
        }
        break;
      case 3:
        if(fillMode == 1) {
          drawFilledCircle((int)saveX, (int)saveY, centerize(mouseX), centerize(mouseY));
        } else { 
          drawCircle((int)saveX, (int)saveY, centerize(mouseX), centerize(mouseY));
        }
        break;
      case 4:
        hasPressed = 0;
        drawLine(x1, y1, x2, y2);        
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

int a;
int b;

int[][] line01;
int[][] line12;
int[][] line02;
int[][] line012;

void drawFilledTriangle(int x0, int y0, int x1, int y1, int x2, int y2) {
  //https://gabrielgambetta.com/computer-graphics-from-scratch/07-filled-triangles.html
  if(y1 < y0) {
    int a = x0;
    int b = y0;
    x0 = x1;
    y0 = y1;
    x1 = a;
    y1 = b;
  } 
  if(y2 < y0) {
    int a = x0;
    int b = y0;
    x0 = x2;
    y0 = y2;
    x2 = a;
    y2 = b;
  }
  if(y2 < y1) {
    int a = x1;
    int b = y1;
    x1 = x2;
    y1 = y2;
    x2 = a;
    y2 = b;
  }
  
  line12 = lineForTriangle(x1, y1, x2, y2);
  line02 = lineForTriangle(x0, y0, x2, y2);
  line01 = lineForTriangle(x0, y0, x1, y1);
  
  combine(line01, line12, abs(y2 - y0) + 1, (y1 - y0), (y2 - y1) + 1);
  
  for(int i = 0; i < (y2 - y0) + 1; i++) {
    drawLine(line02[i][0], line02[i][1], line012[i][0], line012[i][1]);
  }
}

int o;

void combine(int[][] line01, int[][] line12, int size, int y1, int y2) {
  o = 0;
  line012 = new int[size][2];
  
  for(int i = 0; i < y1; i++) {
    line012[o] = line01[i];
    o++;
  }
  for(int i = 0; i < y2; i++) {
    line012[o] = line12[i];
    o++;
  }
}

void drawCircle(float x1, float y1, float x2, float y2) {
  //https://www.cs.helsinki.fi/group/goa/mallinnus/ympyrat/ymp1.html
  int cx = ((int)x1 - 35) / 20;
  int cy = ((int)y1 - 35) / 20;
  int ex = ((int)x2 - 35) / 20;
  int ey = ((int)y2 - 35) / 20;
  double r = sqrt(sq(cx - ex) + sq(cy - ey));
  
  double x = r;
  double y = 0;
  double d = 1 - r;
  
  do {
    circlePoints(x, y, cx, cy);
    y++;
    if(d < 0) {
      d = d + 2*y + 1;
    } else {
      x--;
      d = d + 2*(y - x) + 1;
    }
  } while(x >= y);
}

void drawFilledCircle(float x1, float y1, float x2, float y2) {
  int cx = ((int)x1 - 35) / 20;
  int cy = ((int)y1 - 35) / 20;
  int ex = ((int)x2 - 35) / 20;
  int ey = ((int)y2 - 35) / 20;
  double r = sqrt(sq(cx - ex) + sq(cy - ey));
  
  double x = r;
  double y = 0;
  double d = 1 - r;
  
  do {
    filledCirclePoints(x, y, cx, cy);
    y++;
    if(d < 0) {
      d = d + 2*y + 1;
    } else {
      x--;
      d = d + 2*(y - x) + 1;
    }
  } while(x >= y);
}

void setPoint(double dx, double dy) { 
  int x = round((float) dx);
  int y = round((float) dy);
  if(x < 0 || x > 31 || y < 0 || y > 31) {
    return;
  }
  leds[x][y] = mode;
}
  
void circlePoints(double x, double y, double cx, double cy) {
  setPoint(cx + x, cy + y);
  setPoint(cx + y, cy + x);
  setPoint(cx + y, cy - x);
  setPoint(cx + x, cy - y);
  setPoint(cx - x, cy - y);
  setPoint(cx - y, cy - x);
  setPoint(cx - y, cy + x);
  setPoint(cx - x, cy + y);
}

void filledCirclePoints(double x, double y, double cx, double cy) {
  drawSquare(((cx + x) * 20) + 35, ((cy + y) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx + y) * 20) + 35, ((cy + x) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx + y) * 20) + 35, ((cy - x) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx + x) * 20) + 35, ((cy - y) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx - x) * 20) + 35, ((cy - y) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx - y) * 20) + 35, ((cy - x) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx - y) * 20) + 35, ((cy + x) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
  drawSquare(((cx - x) * 20) + 35, ((cy + y) * 20) + 35, (cx * 20) + 35, (cy * 20) + 35);
}

int flipped;

void drawLine(int x1, int y1, int x2, int y2) {
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
      //leds[(int)dotX][(int)dotY - 1] = mode;
    } else { 
      dotY = lineY1 - 1;
      //leds[(int)dotX][(int)dotY + 1] = mode;
      
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
  
  //leds[(int)lineX2][(int)lineY2] = mode;
  
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

int lastY = -1;
int m = 0;
int[][] line;

int[][] lineForTriangle(int x1, int y1, int x2, int y2) {
  flipped = 0;
  line = new int[abs(y2 - y1) + 1][2];
  lastY = -1;
  m = 0;
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
     flipped = 1;
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
      //leds[(int)dotX][(int)dotY - 1] = mode;
    } else { 
      dotY = lineY1 - 1;
      //leds[(int)dotX][(int)dotY + 1] = mode;
      
    }
    lineLength = (int)lineHeight; 
  } else if(lineWidth == lineHeight) {
    dotX = lineX1;
    dotY = lineY1;
    lastY = (int)dotY;
    line[m][0] = (int)dotX;
    line[m][1] = (int)dotY;
    m++;
    lineLength = (int)lineHeight - 1;
  } else {
    dotY = lineY1;
    dotX = lineX1 - 1;
    //leds[(int)dotX + 1][(int)dotY] = mode;
    lineLength = (int)lineWidth;
  }  
  
  //leds[(int)lineX2][(int)lineY2] = mode;
  
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
    if(lastY == -1 || lastY != dotY) {
        lastY = (int)dotY;
        line[m][0] = (int)dotX;
        line[m][1] = (int)dotY;
        m++;
    }
  }
  if(flipped == 0) {
    return line;
  } else {
    int[][] line2 = new int[abs(y2 - y1) + 1][2];
    j = 0;
    for(int i = abs(y2 - y1); i > -1; i--) {
      line2[j][0] = line[i][0];
      line2[j][1] = line[i][1];
      j++;
    }
    return line2;
  } 
}

int j;

void drawSquare(double x1, double y1, double x2, double y2) {
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
