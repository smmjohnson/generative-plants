public int radius(float scale) {
  //returns a normally distributed radius scaled by scale
  int radius = abs(int(scale + scale*randomGaussian()));
  return(radius);
}

public ArrayList<ArrayList<Float>> getCoords(int numPetals, float r, float x, float y, float theta){ 
  /*x,y are coordinates of focus of circle
  returns an ArrayList of size numPetals which are coordinates of points on circle of radius r

  theta is the degree (0 to 360) to which the coordinates are rotated clockwise
  */
  float radians = 6.28;
  theta = radians * theta/360;
  ArrayList<ArrayList<Float>> coords = new ArrayList();
  for (int i=0; i<numPetals; i++) {
    ArrayList<Float> xy = new ArrayList();
    float cx = x + r*cos(i*(radians/numPetals) + theta);
    float cy = y + r*sin(i*(radians/numPetals)+ theta);
    xy.add(cx);
    xy.add(cy);
    coords.add(xy);
  }
  return(coords);
}
//
//


class Flower {
  float x;
  float y;
  float theta;
  int numPetals;
  float s;
  color out; //color on outside of petals
  color in; // color on inside of petals
  ArrayList<ArrayList<Float>> coords;
  
  public Flower(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.s = s;
    this.numPetals = numPetals();
    this.theta = radians(random(180));
    this.out = color(random(255),random(255),random(255));
    this.in = color(random(255),random(255),random(255));
    getCoords();
  }
  
  public Flower(float x, float y, float s, int numPetals) {
    this(x,y,s);
    this.numPetals = numPetals;
    getCoords();
  }
  
  public Flower(float x, float y, float s, int numPetals, float theta) {
    this(x,y,s,numPetals);
    this.theta = radians(theta);
    getCoords();
  }
  
  public void setColor(color out) {
    setColor(out,out);
  }
  
  public void setColor(color out, color in) {
    this.out = out;
    this.in = in;
  }
  
  public int numPetals() {
    int numPetals = abs(int(7*randomGaussian()));
    if (numPetals < 3) {
      return numPetals();
    }
    return(numPetals);
}
  
   public ArrayList<ArrayList<Float>> getCoords() {
     return getCoords(numPetals, s, x, y, theta);
   }
  
  public ArrayList<ArrayList<Float>> getCoords(int numPetals, float r, float x, float y, float theta){ 
    /*x,y are coordinates of focus of circle
    returns an ArrayList of size numPetals which are coordinates of points on circle of radius r
    x = cx + r * cos(a)
    y = cy + r * sin(a)
    theta is the degree (0 to 360) to which the coordinates are rotated clockwise
    */
    float radians = 6.28;
    theta = radians * theta/360;
    ArrayList<ArrayList<Float>> coords = new ArrayList();
    for (int i=0; i<numPetals; i++) {
      ArrayList<Float> xy = new ArrayList();
      float cx = x + r*cos(i*(radians/numPetals) + theta);
      float cy = y + r*sin(i*(radians/numPetals)+ theta);
      xy.add(cx);
      xy.add(cy);
      coords.add(xy);
    }
    return(coords);
}

  void drawFlower() {
    drawFlower(x,y,numPetals, s, theta, out, in);
    }
    
    void drawFlower(float x, float y, int numPetals, float s, float theta, color out, color in) {
    noStroke();
    int r = int(s);
    ArrayList<ArrayList<Float>> coordsBig = getCoords(numPetals, r+s, x, y, theta);
    for (int i=0; i<numPetals; i++){
      ArrayList<Float> bxy1 = coordsBig.get(i);
      ArrayList<Float> bxy2 = coordsBig.get(0);
      if (i==numPetals-1){
          bxy2 = coordsBig.get(0);} else {
          bxy2 = coordsBig.get(i+1);
        }
      float bx1 = bxy1.get(0);
      float by1 = bxy1.get(1);
      float bx2 = bxy2.get(0);
      float by2 = bxy2.get(1);
      
      //begin petal
      beginShape();
      vertex(x,y);
      bezierVertex(bx1,by1,bx2,by2,x,y);
      endShape();
    }

  }
  
  public void drawGradient() {
    drawGradient(x,y,numPetals,s,theta,out,in);
  }
  
  
  public void drawGradient(float x, float y, int numPetals, float s, float theta, color out, color in) {
    noStroke();
    float inc = 0.05;
    for (int i=0; i<50; i++) {
      fill(lerpColor(out,in, i*inc));
      drawFlower(x,y,numPetals,s-(i*s/50),theta, out, in);
    }
  }
  
  void drawCenter(color c) {
    drawFlower(x,y,numPetals, s/10, theta, c,c);
  }
  
  
}
