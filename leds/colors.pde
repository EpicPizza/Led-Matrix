import java.util.*;

public class colors {
  private int red;
  private int green;
  private int blue;
  private int x1 = 695;
  private int y1 = 75;
  private int x2 = 735;
  private int y2 = 115;
  private ArrayList<colors> list;
  private HashMap<colors,ArrayList<Integer>> map;
  private HashMap<colors,Character> charMap;
  char a = 'a';
  
  public colors(int red, int green, int blue) {
    colors defaultColor = new colors();
    if(red > 255 || red < 0) {
      this.red = 255; 
    } else {
      this.red = red;
    }
    if(green > 255 || green < 0) {
      this.green = 255; 
    } else {
      this.green = green;
    }
    if(blue > 255 || blue < 0) {
      this.blue = 255; 
    } else {
      this.blue = blue;
    }
    list = new ArrayList();
    map = new HashMap();
    charMap = new HashMap();
    if(list.size() == 0) {
      ArrayList<Integer> coords = new ArrayList<Integer>();
      coords.add(695);
      coords.add(35);
      coords.add(735);
      coords.add(75);
      map.put(defaultColor, coords);
      charMap.put(defaultColor, a);
      a++;
      //list.add(defaultColor);
    }
  }
  
  private colors() {
    red = 255;
    green = 255;
    blue = 255;
  }
  
  public void addColor(int red, int green, int blue) {
    //list.add(new colors(red, green, blue));
    ArrayList<Integer> coords = new ArrayList();
    coords.add(this.x1);
    coords.add(this.y1);
    coords.add(this.x2);
    coords.add(this.y2);
    map.put(new colors(red, green, blue), coords);
    charMap.put(new colors(red, green, blue), a);
    a++;
    
    if(map.size() % 4 == 0) {
      this.x1 += 40;
      this.x2 += 40;
      this.y1 -= 120;
      this.y2 -= 120;
    } else {
      this.y1 += 40;
      this.y2 += 40;
    }
  }
  
  public void addColor(colors newColor) {
    ArrayList<Integer> coords = new ArrayList();
    coords.add(x1);
    coords.add(y1);
    coords.add(x2);
    coords.add(y2);
    map.put(newColor, coords);  
    charMap.put(newColor, a);
    a++;
    
    if(map.size() % 4 == 0) {
      x1 += 40;
      x2 += 40;
      y1 = 35;
      y2 = 75;
    } else {
      y1 += 40;
      y2 += 40;
    }
  }
  
  public void replaceColor(int red1, int green1, int blue1, int red2, int green2, int blue2) {
    for(colors c: map.keySet()) {
      if(c.red == red1 && c.green == green1 && c.blue == blue1) {
        ArrayList<Integer> coords = map.get(c);
        char b = charMap.get(c);
        map.remove(c);
        charMap.remove(c);
        map.put(new colors(red2, green2, blue2), coords);
        charMap.put(new colors(red2, green2, blue2), b);
      }
    }
  }
  
  public HashMap<colors, Character> getCharMap() {
    return charMap;
  }
  
  public void replaceColor(colors c1, colors c2) {
    for(colors c: map.keySet()) {
      if(c.equals(c1)) {
        ArrayList<Integer> coords = map.get(c);
        char b = charMap.get(c);
        map.remove(c);
        charMap.remove(c);
        map.put(c2, coords);
        charMap.put(c2, b);
      }
    }
  }
  
  public boolean equals(colors c) {
    return c.red == red && c.green == green && c.blue == blue;
  }
  
  public boolean equals(int red, int green, int blue) {
    return this.red == red && this.green == green && this.blue == blue; 
  }
  
  public int getRed() {
    return this.red;
  }
  
  public int getGreen() {
    return this.green;  
  }
  
  public int getBlue() {
    return this.blue;  
  }
  
  public void setRed(int red) {
    if(red > 255 || red < 0) {
      this.red = 255; 
    } else {
      this.red = red;
    }
  }
  
  public void setGreen(int green) {
    if(green > 255 || green < 0) {
      this.green = 255; 
    } else {
      this.green = green;
    }
  }
  
  public void setBlue(int blue) {
    if(blue > 255 || blue < 0) {
      this.blue = 255; 
    } else {
      this.blue = blue;
    }  
  }
  
  public HashMap<colors, ArrayList<Integer>> getMap() {
    return map;  
  }
  
  public String toString() {
    return "red: " + red + ", green: " + green + ", blue: " + blue;  
  }
  
  //695 35
  public void displayColors() {
     if(numColors() < 15) {
       println("not enough colors");
     } else {
       for(colors c: map.keySet()) {
         fill(c.red, c.green, c.blue);
         rect(map.get(c).get(0), map.get(c).get(1), map.get(c).get(2) - map.get(c).get(0), map.get(c).get(3) - map.get(c).get(1));
       }
     }
  }
  
  public int numColors() {
    return map.size();  
  }
  
  public colors pressedColor(int x, int y) {
    for(colors c: map.keySet()) {
       ArrayList<Integer> coords = map.get(c);
       if(x > coords.get(0) && x < coords.get(2) && y > coords.get(1) && y < coords.get(3)) {
         return c;  
       }
    }
    return null;
  }
  
  public ArrayList<Integer> coordColor(int x, int y) {
    for(colors c: map.keySet()) {
       ArrayList<Integer> coords = map.get(c);
       if(x > coords.get(0) && x < coords.get(2) && y > coords.get(1) && y < coords.get(3)) {
         return coords;  
       }
    }
    return null;
  }
  
  public char whatColor(int x, int y) {
    for(colors c: map.keySet()) {
       ArrayList<Integer> coords = map.get(c);
       if(x > coords.get(0) && x < coords.get(2) && y > coords.get(1) && y < coords.get(3)) {
          for(colors d: charMap.keySet()) {
            //println(c + " " + map.get(c)); 
            if(d.getRed() == c.getRed() && d.getGreen() == c.getGreen() && d.getBlue() == c.getBlue()) {
              char b = charMap.get(d);  
              return b;
            } 
          }
          return 0;
       }
    }
    return 0;
  }
}
