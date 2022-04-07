#include <Adafruit_GFX.h>
#include <RGBmatrixPanel.h>
#include <Fonts/Picopixel.h>;
#include <SPI.h>
#include <SD.h>

#define CLK 11
#define OE  9
#define LAT 10
#define A   A0
#define B   A1 
#define C   A2
#define D   A3

#ifdef __arm__
// should use uinstd.h to define sbrk but Due causes a conflict
extern "C" char* sbrk(int incr);
#else  // __ARM__
extern char *__brkval;
#endif  // __arm__

int freeMemory() {
  char top;
#ifdef __arm__
  return &top - reinterpret_cast<char*>(sbrk(0));
#elif defined(CORE_TEENSY) || (ARDUINO > 103 && ARDUINO != 151)
  return &top - __brkval;
#else  // __arm__
  return __brkval ? &top - __brkval : &top - __malloc_heap_start;
#endif  // __arm__
}

const int PROGMEM rightPin = A5;
const int PROGMEM clickPin = A6;
const int PROGMEM leftPin = A7;

String buffer = "";

RGBmatrixPanel matrix(A, B, C, D, CLK, LAT, OE, true);

#define clear()          fillScreen(0)
#define show()           swapBuffers(true)

File root;

int counter = 0;
String inputString = "";
bool stringComplete = false;

File imageFile;
char leds[32][32];
const char alertImage[32][32] = {"gggggggggggggggggggggggggggggggg", "gggggggggggggggggggggggggggggggg", "gggggggggggggggggggggggggggggggg", "ggggggggggbbbbbbbbbbbbgggggggggg", "gggggggggbbbbbbbbbbbbbbggggggggg", "ggggggggbbbbbbbbbbbbbbbbgggggggg", "gggggggbbbbbbbbbbbbbbbbbbggggggg", "ggggggbbbbbbbbbbbbbbbbbbbbgggggg", "gggggbbbbbbbbbbbbbbbbbbbbbbggggg", "ggggbbbbbbbbbbbbbbbbbbbbbbbbgggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "gggbbaaaaaaaaaaaaaabbbaaaabbbggg", "gggbbaaaaaaaaaaaaaabbaaaaaabbggg", "gggbbaaaaaaaaaaaaaabbaaaaaabbggg", "gggbbaaaaaaaaaaaaaabbaaaaaabbggg", "gggbbaaaaaaaaaaaaaabbaaaaaabbggg", "gggbbaaaaaaaaaaaaaabbbaaaabbbggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "gggbbbbbbbbbbbbbbbbbbbbbbbbbbggg", "ggggbbbbbbbbbbbbbbbbbbbbbbbbgggg", "gggggbbbbbbbbbbbbbbbbbbbbbbggggg", "ggggggbbbbbbbbbbbbbbbbbbbbgggggg", "gggggggbbbbbbbbbbbbbbbbbbggggggg", "ggggggggbbbbbbbbbbbbbbbbgggggggg", "gggggggggbbbbbbbbbbbbbbggggggggg", "ggggggggggbbbbbbbbbbbbgggggggggg", "gggggggggggggggggggggggggggggggg", "gggggggggggggggggggggggggggggggg", "gggggggggggggggggggggggggggggggg"};
//char charCounter = 0;

String files[28];
int fileNumber = 0;

void setup() {
  matrix.begin();
  Serial.begin(9600);
  inputString.reserve(200);

  pinMode(rightPin, INPUT_PULLUP);
  pinMode(clickPin, INPUT_PULLUP);
  pinMode(leftPin, INPUT_PULLUP);

  Serial.println("Starting SD card.");

  if(!SD.begin(37)) {
    Serial.println("Couldn't start SD card.");
    matrix.setCursor(2, 9);
    alert("Couldn't find SD    card.", true);
  }
  Serial.println("SD card started."); 

  matrix.setCursor(2, 9);
  alert("Looking   for files.", false);
  root = SD.open("/");

  printDirectory(root, 0);

  reload(true);
}

int encoderVal = 1;
int image;
int lastImage = 0;
int imageState = 0;
int showImage = 0;
int lastEncoderVal;
int clickState = 0;

String imageName;

void(* resetFunc) (void) = 0;

void loop() {
  int rightState = digitalRead(rightPin);
  int clickState = digitalRead(clickPin);
  int leftState = digitalRead(leftPin);

  if(stringComplete) {
    Serial.println(inputString);
    if(inputString == "a") {
      leftState = 0;
    } else if(inputString == "w") {
      clickState = 0;
    } else if(inputString == "d") {
      rightState = 0;
    }
    inputString = "";
    stringComplete = false;
  }
  
  if(clickState == 0) {
    if(imageState == 0) {
      matrix.clear();
      showImage = 0;
      imageState = 1;
      while(digitalRead(clickPin) == 0);
    } else {
      matrix.clear();
      imageState = 0;
      while(digitalRead(clickPin) == 0);
      reload(false);
    }
  }

  if(imageState == 1 && rightState == 0) {
    matrix.clear();
    imageState = 0;
    while(digitalRead(rightPin) == 0);
    reload(false);
  }

  if(imageState == 1 && leftState == 0) {
    matrix.clear();
    imageState = 0;
    while(digitalRead(leftPin) == 0);
    reload(false);
  }
  
  if(imageState == 0) {
    if(rightState == 0) {
      encoderVal = encoderVal + 1;
      while(digitalRead(rightPin) == 0);
      if(encoderVal > 28) {
        encoderVal = 1;
      }
    } 
    if(leftState == 0) {
      encoderVal = encoderVal - 1;
      while(digitalRead(leftPin) == 0);
      if(encoderVal < 1) {
        encoderVal = 28;
      }
    }

    if(lastEncoderVal != encoderVal) {
      matrix.drawLine(1, 28, 30, 28, matrix.Color888(0, 0, 0));
      matrix.drawLine(1, 30, 30, 30, matrix.Color888(0, 0, 0));
      matrix.drawRect(encoderVal, 28, 3, 3, matrix.Color888(255, 255, 255));
  
    
      image = map(encoderVal, 1, 29, 0, fileNumber);
      
      lastEncoderVal = encoderVal;

      matrix.show();
    }
  
    if(lastImage != image) {
      reload(true);
      lastImage = image;
      lastEncoderVal = encoderVal - 1;
    }
    showImage = 0;
  } else if(imageState == 1) {
    if(showImage == 0) {
      for(int x = 0; x < 32; x++) {
        for(int y = 0; y < 32; y++) {
          drawLed(x, y, leds[x][y]);
        }
      }
      matrix.show();
    }
    showImage = 1;
  }
  
}

int red;
int green;
int blue;

void reload(bool fileNeeded) {
  if(fileNeeded == true) { //dont't read file unless it is needed
    readFile();
    Serial.println("reading");
    Serial.println(freeMemory());
  }
 
  matrix.clear();
  
  matrix.drawLine(1, 29, 30, 29, matrix.Color888(255, 255, 255));
  matrix.drawRect(encoderVal, 28, 3, 3, matrix.Color888(255, 255, 255));
  
  for(int x = 0; x < 8; x++) {
    for(int y = 0; y < 8; y++) {
      drawLed(x + 1, y + 1, leds[x * 4][y * 4]);
    }
  }

  matrix.setCursor(1, 15);
  matrix.setFont(&Picopixel);
  matrix.setTextColor(matrix.Color888(255, 255, 255));
  
  matrix.print(imageName);

  matrix.show();
}

void drawLed(int x, int y, char a) {
  if(a == 'a') {
    matrix.drawPixel(x, y, matrix.Color888(255, 255, 255, true));
  } else if(a == 'b') {
    matrix.drawPixel(x, y, matrix.Color888(255, 0, 0, true));
  } else if(a == 'c') {
    matrix.drawPixel(x, y, matrix.Color888(0, 255, 0, true));
  } else if(a == 'd') {
    matrix.drawPixel(x, y, matrix.Color888(0, 0, 255, true));
  } else if(a == 'e') {
    matrix.drawPixel(x, y, matrix.Color888(0, 255, 255, true));
  } else if(a == 'f') { 
    matrix.drawPixel(x, y, matrix.Color888(255, 255, 0, true));
  } else if(a == 'g') {
    matrix.drawPixel(x, y, matrix.Color888(0, 0, 0, true));
  } else if(a == 'h') {
    matrix.drawPixel(x, y, matrix.Color888(25, 125, 25, true));
  } else if(a == 'i') {
    matrix.drawPixel(x, y, matrix.Color888(255, 0, 200, true));
  } else if(a == 'j') {
    matrix.drawPixel(x, y, matrix.Color888(155, 0, 255, true));
  } else if(a == 'k') {
    matrix.drawPixel(x, y, matrix.Color888(127, 127, 127, true));
  } else if(a == 'l') {
    matrix.drawPixel(x, y, matrix.Color888(255, 155, 0, true));
  } else if(a == 'm') {
    matrix.drawPixel(x, y, matrix.Color888(0, 125, 255, true));
  } else if(a == 'n') {
    matrix.drawPixel(x, y, matrix.Color888(64, 224, 204, true));
  } else if(a == 'o') {
    matrix.drawPixel(x, y, matrix.Color888(144, 255, 144, true));
  } else if(a == 'p') {
    matrix.drawPixel(x, y, matrix.Color888(102, 75, 0, true));
  }
}

void readFile() {

  imageFile = SD.open(files[image]);

  for(int p = 0; p < 11; p++) {
    imageFile.read();
  }

  counter = 0;

  while(imageFile.available()) {
    leds[(counter - (counter % 32)) / 32][counter % 32] = imageFile.read();
    counter++;
    if(counter == 1024) {
      break;
    }
  }

  counter = 0;

  imageName = files[image];

  if(imageName != imageFile.name()) {
    //reload sd card

    alert("SD CARD ERROR.", true);
  } else {
    imageName.remove(imageName.length() - 4, 4);
  }

  //imageName = "";
  //for(int h = 0; h < (fileName.length() - 4); h++) {
  //  imageName += fileName.charAt(h);
  //}

  //imageName.toLowerCase();

  //fileName = "";
}

void printDirectory(File dir, int numTabs) {
  fileNumber = 0;
  while (true) {

    File entry =  dir.openNextFile();
    if (! entry) {
      // no more files
      break;
    }
    if (!entry.isDirectory() && checkFile(entry)) {
      // files have sizes, directories do not
      Serial.print(entry.name());
      Serial.print("\t\t");
      Serial.println(entry.size(), DEC);
      fileNumber++;
      Serial.println(fileNumber);
    }
    entry.close();
  }
}

String start;

bool checkFile(File file) {
  start = "";
  
  if (file) {
    while (file.available() && start.length() < 11) {
      start += (char) file.read();
    }
    while (file.available()) {
      int c = file.read();
      if(c <= 112 && c >= 97 || c == 10 || c == 32) {
        //continue
      } else {
        return false;
      }
    }
  }

  String fileName = file.name();

  if(start == "***image***" && file.size() == 1036 && fileName.endsWith(".TXT")) {
    files[fileNumber] = fileName;

    if(fileNumber == 28) {
      matrix.setCursor(2, 15);
      alert("too many files", true);
    }
    
    return true;
  } else {
    return false;
  }
}

void alert(String message, bool freeze) {
  matrix.clear();
  
  for(int x = 0; x < 8; x++) {
    for(int y = 0; y < 8; y++) {
      drawLed(x + 1, y + 1, (char)alertImage[x * 4][y * 4]);
    }
  }

  matrix.setFont(&Picopixel);
  matrix.setTextColor(matrix.Color888(255, 255, 255));
  
  matrix.print(message);

  matrix.show();

  if(freeze == 1) {
    while(true){}
    /*matrix.setCursor(2, 15);
    alert("Reloading... ", 0); //temparoryyyyyy fixxxx
    delay(2000);
    Serial.println("resetting");
    resetFunc();*/
  } 
}

void serialEvent() {
  while(Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;

    if(inChar == '\n') {
      stringComplete = true;
    }
  }
  stringComplete = true;
}
