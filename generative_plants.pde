void setup() {
  size(2000, 2000);
  //noLoop(); //uncomment to only product one output
  frameRate(1);
  background(255);
}

void draw() {
  background(255);
  Generator g = new Generator(1000, 1800);
}



class Generator {
  float x;
  float y;
  boolean flowers;
  boolean leaves;
  boolean tree;
  boolean stems;
  boolean stemsList;
  public Generator(float x, float y) {
    // /*
    decideAttributes();
     int maxStems = int(abs((6+5*randomGaussian())));
     int maxBranches = int(abs((25+15*randomGaussian())));
     if (stems==true) {
       color green = getGreen();
       ArrayList<Stem> stemsList = new ArrayList();
       for (int i=0; i<maxStems; i++) {
         Stem s = new Stem(x+30*randomGaussian(),y,abs(500+500*randomGaussian()),20+10*randomGaussian());
         stemsList.add(s);
         s.drawStem(getGreen(green));
       }
       if (leaves==true) {
         leavesOnStems(stemsList);
       }
       if (flowers==true) {
         flowersOnStems(stemsList);
       }
     }
     
     else {
     ArrayList<Branch> branches = buildTree(x,y,height,width,maxBranches);
     color c = getBrown();
     color cf = getMutedColor();
     float size = random(3,10);
     int numPetals = int(random(3,8));
     branches.get(0).drawTrunk(c);
     for (int i=1; i<branches.size(); i++) {
       Branch b = branches.get(i);
       b.drawBranch(pushColor(c));
       if (leaves==true && b.next == null) {
         leavesOnBranch(b,b.len/10);
       }
       if (flowers==true && b.next==null) {
         flowersOnBranch(b, b.len,cf,size,numPetals);
       }
     }
     }
     // */
  }

  public void leavesOnStems(ArrayList<Stem> stemsList) {
    int numLeaves = howManyLeaves(); //how many leaves per branch side
    float len = 200 + 40*randomGaussian();
    float scale = 200 + 40*randomGaussian();
    for (int i=0; i<stemsList.size(); i++) {
      leavesOnStem(stemsList.get(i), numLeaves, len, scale);
    }
  }
  public void leavesOnStem(Stem s, int numLeaves, float len, float scale) {
    //xxx test this tomorrow
    //
    len = abs(len + s.h/10*randomGaussian());
    scale = abs(scale + s.h/10*randomGaussian());
    if (numLeaves==1) {
      Leaf l = new Leaf(s.x2, s.y2, s.h*0.3, s.theta, s.c);
      l.drawLeaf();
    } else {
      float empty = 0.3;
      float d = (s.h*(1-empty))/numLeaves;
      float t = empty;
      float tplus = (1-t)/numLeaves;

      float n1x = curvePoint(s.c1x, s.x1, s.x2, s.c2x, t);
      float n1y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t);
      float n2x = curvePoint(s.c1x, s.x1+s.w, s.x2+0.01*s.w, s.c2x, t);
      float n2y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t);
      float alpha = radians(15 + abs(15*randomGaussian()));
      for (int i=0; i< numLeaves; i++) {
        float theta = getTheta(s, t);
        if (theta>PI) {
          theta=PI-theta;
        }
        Leaf l = new Leaf(n1x, n1y, len, scale, theta+alpha, pushColor(s.c, 15));
        Leaf l2 = new Leaf(n2x, n2y, len, scale, theta-alpha, pushColor(s.c, 15));
        l.drawLeaf();
        l2.drawLeaf();
        t = t+tplus;

        n1x = curvePoint(s.c1x, s.x1, s.x2, s.c2x, t);
        n1y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t);
        n2x = curvePoint(s.c1x, s.x1+s.w, s.x2+0.01*s.w, s.c2x, t);
        n2y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t);
      }
      oneLeaf(s, len, scale);
    }
  }
  public void oneLeaf(Stem s) {
    Leaf l = new Leaf(s.x2, s.y2, s.h*0.3, s.theta, s.c);
    l.drawLeaf();
  }
  public void oneLeaf(Stem s, float len, float scale) {
    Leaf l = new Leaf(s.x2, s.y2, len, scale, s.theta, s.c);
    l.drawLeaf();
  }
  
  public void flowersOnStems(ArrayList<Stem> stems) {
    int numPetals = abs(5+int(3*randomGaussian()));
    float size = abs(20+10*randomGaussian());
    color c = getMutedColor();
    if (int(random(0,2)) > 0) {
      float thisSize = abs(size + 5*randomGaussian());
      for (int i=0; i<stems.size(); i++) {
        if (random(10)>1) { //about 80% of stems have flowers
          Stem s = stems.get(i);
          Flower f = new Flower(s.x2,s.y2,thisSize,numPetals);
          f.setColor(pushColor(c),pushColor(c,20));
          f.drawGradient();
        }
      }
    } else {
      for (int i=0; i<stems.size(); i++) {
        
        if (random(10)>1) {
          Stem s = stems.get(i);
          for (int j=0; j<(3+2*randomGaussian());j++) {
            float x = s.x2 + size/2*randomGaussian();
            float y = s.y2 + size/2*randomGaussian();
            Flower f = new Flower(x,y,size+2*randomGaussian(),numPetals);
            f.setColor(pushColor(c,10),pushColor(c,25));
            f.drawGradient();
          }
        }
      }
    }
  }

  public float getTheta(Stem s, float t) {
    //returns the slope (theta) at a given interval t on a stem object
    float n1x = curvePoint(s.c1x, s.x1, s.x2, s.c2x, t-0.005);
    float n1y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t-0.005);
    float n2x = curvePoint(s.c1x, s.x1, s.x2, s.c2x, t+0.005);
    float n2y = curvePoint(s.c1y, s.y1, s.y2, s.c2y, t+0.005);
    float theta = atan((n1y-n2y)/(n1x-n2x));
    if (s.curve <1) {
      theta = PI-theta;
    }
    return abs(theta);
  }
  public void leavesOnBranch(Branch b, float density) {
    float empty = 0.5;
    float x = b.x1 + b.len*empty*cos(b.theta);
    float y = b.y1 - b.len*empty*sin(b.theta);
    float d = b.len*(1-empty);
    float cx = x + 0.5*b.len*(1-empty)*cos(b.theta);
    float cy = y - 0.5*b.len*(1-empty)*sin(b.theta);

    for (int i=0; i<density; i++) {
      float theta = random(2*PI);
      float r = d/3*abs(randomGaussian());
      float lx = cx + r*cos(theta);
      float ly = cy + r*sin(theta);
      Leaf l = new Leaf(lx,ly, 50,50,random(PI),getGreen());
      l.drawLeaf();
    }
  }
  
  public void flowersOnBranch(Branch b, float density, color c, float size,  int numPetals) {
    float empty = 0.5;
    float x = b.x1 + b.len*empty*cos(b.theta);
    float y = b.y1 - b.len*empty*sin(b.theta);
    float d = b.len*(1-empty);
    float cx = x + 0.5*b.len*(1-empty)*cos(b.theta);
    float cy = y - 0.5*b.len*(1-empty)*sin(b.theta);

    for (int i=0; i<density; i++) {
      float theta = random(2*PI);
      float r = d/2*abs(randomGaussian());
      float lx = cx + r*cos(theta);
      float ly = cy + r*sin(theta);
      Flower f = new Flower(lx,ly,size+2*randomGaussian(),numPetals);
      f.setColor(pushColor(c,10),pushColor(c,25));
      f.drawGradient();
    }
  }
  
  public void drawUpperLeaves(Leaf template, float ux1, float uy1, float ux2, float uy2, float btheta, float alpha) { 
    Leaf l = new Leaf(ux1, uy1, template.len, template.scale,-PI/2+btheta+alpha, template.c);
    Leaf l2 = new Leaf(ux2, uy2, template.len, template.scale,PI/2+btheta-alpha, template.c);
    l.drawLeaf();
    l2.drawLeaf();
  }
  public int howManyLeaves() {
    if (int(random(0, 2)) < 0) {
      return 1;
    }
    return 10+int(10*randomGaussian());
  }

  private void decideAttributes() {
    stems = false;
    tree = false;
    flowers = false;
    leaves = false;

    if (int(random(0, 2)) > 0) { //xxx
      stems=true;
    } else {
      tree=true;
    }
    if (int(random(1, 2)) > 0) {
      flowers=true;
    }
    if (int(random(0, 2)) > 0) { //xxx
      leaves=true;
    }
  }

  //COLOR METHODS
  public color pushColor(color c) {
    return pushColor(c, 7);
  }

  public color pushColor(color c, float d) {
    float r = red(c)+d*randomGaussian();
    float g = green(c)+d*randomGaussian();
    float b = blue(c)+d*randomGaussian();
    return color(r, g, b);
  }
  public color getGreen() {
    float r = 50 + 50*randomGaussian();
    float g = random(79, 190);
    float b = random(0, 150);
    return getGreen(color(r, g, b));
  }
  public color getGreen(color avg) {
    float r = red(avg) + 8*randomGaussian();
    float g = green(avg) + 8*randomGaussian();
    float b = blue(avg) + 8*randomGaussian();
    return color(r, g, b);
  }
  public color getMutedColor() {
    return color(random(20, 200), random(20, 200), random(20, 200));
  }
  public color getBrown() {
    float r = random(20,255);
    float g = abs(r-random(50));
    float b = random(10,g);
    return color(r,g,b);
  }
}//END OF GENERATOR CLASS




public float gaussianLength(float length, float scale) {
  return randomGaussian()*scale+ + length;
}

public int chooseNode(Branch branch) { //takes a Branch and returns a randomly selected int 0-2 corresponding with an empty node
  //0=mida,1=midb,2=next
  //println(branch, branch.mida,branch.midb, branch.next);
  ArrayList<Integer> empties = new ArrayList();
  if (branch.mida == null) {
    empties.add(0);
  }
  if (branch.midb == null) {
    empties.add(1);
  }
  if (branch.next == null) {
    empties.add(2);
  }
  return empties.get(int(random(empties.size()-1)));
}
public boolean isFull(Branch branch) {
  if (branch.mida != null & branch.midb != null & branch.next != null) {
    return true;
  }
  return false;
}

public ArrayList<Branch> buildTree(float x1, float y1, float maxHeight, float maxWidth, float density) {
  ArrayList<Branch> branches = new ArrayList<Branch>(); //list of Branch objects in tree
  ArrayList<Branch> nodes = new ArrayList<Branch>();
  Branch b = new Branch(x1, y1, 700);
  if (b.x2 < maxWidth || b.x2 > 0 || b.y2 < maxHeight) {
    branches.add(b);
    nodes.add(b);
  }
  for (int i = 0; i<density; i++) { //while number of branches is less than density
    int idx = int(random(nodes.size()-1));
    Branch addBranch = nodes.get(idx);
    int nodeNum = chooseNode(addBranch);
    float len = random(addBranch.len*0.4, addBranch.len*0.9); //randomize length of new branch between 20-80% of stemming branch's length
    float from = random(addBranch.len*0.3, addBranch.len*0.8);
    if (nodeNum == 0) {
      addBranch.addMida(from, len, random(180));
      branches.add(addBranch.mida);
      nodes.add(addBranch.mida);
    }
    if (nodeNum == 1) {
      addBranch.addMidb(from, len, random(180));
      branches.add(addBranch.midb);
      nodes.add(addBranch.midb);
    }
    if (nodeNum == 2) {
      addBranch.addNext(addBranch.len*0.75, random(180));
      branches.add(addBranch.next);
      nodes.add(addBranch.next);
    }
    if (isFull(addBranch)) {
      nodes.remove(idx);
    }
  }
  return branches;
}

public class Branch {

  /*
  Branch class holds data for each branch of a tree.
   Attributes:
   x1,y1: coordinates for lower end of branch
   x2,y2: coordinates for highter end of branch, equivalent to lower coordinates of next branch if it exists
   len: length of branch
   theta: angle of branch 0-180, 0 is right-facing
   next: next Branch in Tree
   mid: Branch in middle of this Branch
   prev: Branch connecting to base of this Branch
   
   minimum parameters are x,y and len which creates a vertical branch with no connecting branches
   Constructors:
   x,y,len
   x,y,len,theta
   x,y,len,prev
   x,y,len,prev,next
   
   **mid Branches must be set using addMid()=
   **xxx: add width component??
   */

  float x1, y1, x2, y2, len, theta;
  int level;
  Branch next;
  Branch mida;
  Branch midb;
  Branch prev;

  public Branch(float x, float y, float len) {
    x1 = x;
    y1 = y;
    this.len = len;
    theta = radians(90); //defaults to vertical orientation
    next = null;
    mida = null;
    midb =null;
    prev = null;
    setLast(); //set x2,y2
    if (this.prev == null) {
      level = 0;
    } else {
      level = this.prev.level + 1;
    }
  }
  public Branch(float x, float y, float len, float theta) {
    this(x, y, len);
    this.theta = radians(theta);
    mida=null;
    midb=null;
    setLast();
  }
  public Branch(float x, float y, float len, Branch prev) {
    this(x, y, len);
    this.prev = prev;
  }

  public Branch addMid(float from, float len, float theta) {
    // from parameter indicates how far from the base of this Branch the mid Branch will be
    //does not error check to make sure from parameter is not greater then length of current branch
    float x = this.x1 + from*cos(this.theta); //calculate x1 and y1 for new mid Branch
    float y = this.y1 - from*sin(this.theta);
    Branch b = new Branch(x, y, len, theta);
    b.level = this.level+1;
    b.prev = this;
    return b;
  }

  public void addMida(float from, float len, float theta) {
    this.mida = addMid(from, len, theta);
  }

  public void addMidb(float from, float len, float theta) {
    this.midb = addMid(from, len, theta);
  }

  public void addNext(float len, float theta) {
    Branch b = new Branch(x2, y2, len, theta);

    b.level = level+1;
    this.next = b;
  }

  public void setLast() {
    //sets x2 and y2 based off of x1,y1, len, and theta.
    if (this.next == null ) {
      x2 = x1 + len * cos(theta);
      y2 = y1 - len * sin(theta);
    } else {
      x2 = next.x1;
      y2 = next.y1;
    }
  }
  
  private float getWeight() {
    return (6+15/(level+1));
  }

  public void drawBranch(color c) {
    float weight = this.getWeight();
    strokeWeight(weight);
    stroke(c);
    //strokeCap(SQUARE);
    
    if (next == null) {
      float midx = x1 + (0.7*len*cos(theta));
      float midy = y1 - (0.7*len*sin(theta));
      line(x1, y1, midx,midy);
      drawTaper(midx,midy,weight, c);
    } else {
      line(x1,y1,x2,y2);
    }
  }

  private void drawTaper(float midx, float midy, float weight, color c) {
    strokeWeight(0);
    fill(c);
    float tx1 = midx + weight/2*cos(theta-radians(90));
    float ty1 = midy - weight/2*sin(theta-radians(90));
    float tx2 = midx + weight/2*cos(theta+radians(90)); //+
    float ty2 = midy - weight/2*sin(theta+radians(90));//-
    triangle(tx1,ty1,tx2,ty2,x2,y2);
  }
  
  public void drawTrunk(color c) {
    fill(c);
    strokeWeight(0);
    float w = getWeight();
    float c1x = x1-0.25*len;
    float c1y = y1+len/2;
    float c2x = x2;//-0.5*w;
    float c2y = y2-len;
    float c3x = x1+0.25*len;
    float c3y = y1+len/2;
    float c4x = x2;//+0.5*w;
    float c4y = y2-len;
    beginShape();
    vertex(x1+2*w,y1);
    vertex(x1-2*w,y1);
    curveVertex(c1x,c1y);
    curveVertex(x1-w*2,y1);
    curveVertex(x2-0.5*w,y2);
    curveVertex(c2x,c2y);
    vertex(x2-0.5*w,y2);
    vertex(x2+0.5*w,y2);
    curveVertex(c4x,c4y);
    curveVertex(x2+0.5*w,y2);
    curveVertex(x1+2*w,y1);
    curveVertex(c3x,c3y);
    endShape();
  }

  public String toString() {
    return "(" + round(x1) +"," + round(y1) + ") to (" + round(x2) + "," + round(y2) + "), len: " + round(len) +", theta: "+round(theta*180/PI);
  }
}//END OF BRANCH CLASS



class Stem {
  int curve; //curve left = -1, curve right = 1;
  float h;
  float w;
  float x1;
  float y1;
  float x2;
  float y2;
  float c1x;
  float c1y;
  float c2x;
  float c2y;
  float theta;
  color c;

  
  public Stem (float x, float y, float h, float w) {
    this.curve = int(random(0,2));
    if (curve == 0) {
      this.curve = -1;
    }
    this.h = h;
    this.w = w;
    this.x1 = x;
    this.y1 = y;
    this.x2 = x1  + curve * random(400);
    this.y2 = y-h;
    
    float curveFactor = curve * 0.5*width*abs(randomGaussian()); //randomize some degree of curve
    
    this.c1x = x1 + curve*5*w + curveFactor;
    this.c1y = y1 + 5*w;
    this.c2x = x2 + curve*5*w + curveFactor;
    this.c2y = y2 - 5*w;
    setTheta();
  }
  
  public void drawStem(color c) {
    this.c = c;
    
    strokeWeight(0);
    fill(c);
    beginShape();
    
    vertex(x1 + w, y1);
    vertex(x1,y1);
    curveVertex(c1x,c1y);
    curveVertex(x1,y1);
    curveVertex(x2,y2);
    curveVertex(c2x,c2y);
    float second = x2 + 0.1*w;
    
    vertex(x2,y2);
    vertex(second,y2);
    
    curveVertex(c2x,c2y);
    curveVertex(second, y2);
    curveVertex(x1+w,y1);
    curveVertex(c1x,c1y);
    
    endShape();

  }
  
  public void setTheta() {
    //Sets the theta value of the end of the plant based on the slope of the top 5% of the stem.
    float pt1x = curvePoint(c1x,x1,x2,c2x,0.95);
    float pt1y = curvePoint(c1y,y1,y2,c2y,0.95);
    float pt2x = curvePoint(c1x,x1,x2,c2x,1);
    float pt2y = curvePoint(c1y,y1,y2,c2y,1);
    float theta = atan((pt1y-pt2y)/(pt1x-pt2x));
    if (curve <1) {
      theta = PI-theta;
    }
    this.theta=abs(theta);
  }
}//END OF STEM CLASS

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
  
  
}//END OF FLOWER CLASS


class Leaf {
  float x1;
  float y1;
  float x2;
  float y2;
  float len;
  float scale;
  float theta;
  color c;
  String type;
  
  public Leaf(float x, float y, float len, float theta) {
    x1 = x;
    y1 = y;
    this.len = len;
    this.theta = theta;
    this.scale = 500;
    setEnds();
    c = color(0,255,0);
    type = "ovate"; //other types: deltoid (monstera)
  }
  
  public Leaf(float x, float y, float len, float theta, color c) {
    this(x,y,len,theta);
    this.c = c;
  }
  
  public Leaf(float x, float y, float len, float scale, float theta, color c) {
    this(x,y,len,theta,c);
    this.scale = scale;
  }
  
  private void setEnds() {
    this.x2 = x1+len*cos(theta);
    this.y2 = y1-len*sin(theta);
  }
  
  
  
  public void drawLeaf() {
    
    float c1x = x1 - (sqrt(2) * scale * sin(radians(135)-theta));
    float c1y = y1 + (sqrt(2) * scale * cos(radians(135)-theta));
    float c2x = x2 - (sqrt(2) * scale * cos(radians(135)-theta));
    float c2y = y2 - (sqrt(2) * scale * sin(radians(135)-theta));
  
    float c3x = x1 + (sqrt(2) * scale * cos(radians(135)-theta));
    float c3y = y1 + (sqrt(2) * scale * sin(radians(135)-theta));
    float c4x = x2 + (sqrt(2) * scale * sin(radians(135)-theta));
    float c4y = y2 - (sqrt(2) * scale * cos(radians(135)-theta));
  
    strokeWeight(0);
    stroke(c);
    fill(c);
    beginShape();
    vertex(x1,y1);
    curve(c1x,c1y,x1,y1,x2,y2,c2x,c2y);
    curve(c3x,c3y,x1,y1,x2,y2,c4x,c4y);
    endShape();

  }
  public void drawTwoTone(color c1, color c2) {
  
    float c1x = x1 - (sqrt(2) * scale * sin(radians(135)-theta));
    float c1y = y1 + (sqrt(2) * scale * cos(radians(135)-theta));
    float c2x = x2 - (sqrt(2) * scale * cos(radians(135)-theta));
    float c2y = y2 - (sqrt(2) * scale * sin(radians(135)-theta));
    float c3x = x1 + (sqrt(2) * scale * cos(radians(135)-theta));
    float c3y = y1 + (sqrt(2) * scale * sin(radians(135)-theta));
    float c4x = x2 + (sqrt(2) * scale * sin(radians(135)-theta));
    float c4y = y2 - (sqrt(2) * scale * cos(radians(135)-theta));
  
    strokeWeight(0);
    stroke(c1);
    fill(c1);
    beginShape();
    vertex(x1,y1);
    curve(c1x,c1y,x1,y1,x2,y2,c2x,c2y);
    endShape();
    
    stroke(c2);
    fill(c2);
    beginShape();
    curve(c3x,c3y,x1,y1,x2,y2,c4x,c4y);
    endShape();      
  }
  
}//END OF LEAF CLASS
