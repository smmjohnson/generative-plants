

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
     for (int i=0; i<branches.size(); i++) {
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
