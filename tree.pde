

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
  
  public void drawTrunk(float width) {
    
    strokeWeight(12);
    fill(200,200,200);
    float weight = this.getWeight();
    float tx1 = x1-width/2;
    float tx2 = x1+width/2;
    float tx3 = x2-weight/2;
    float tx4 = x2+weight/2;
    /*
        curveVertex(tx3,y2);
    //curveVertex(tx3,y2-len);
    //curveVertex(tx4,y2-len);
    curveVertex(tx4,y2);
    curveVertex(tx2,y1);
    //curveVertex(tx2+len, y1+len);
    //curveVertex(tx1-len,y1+len);
    curveVertex(tx1,y1);
    curveVertex(tx3,y2);
    */

  /*
    noFill();
    
    stroke(255,0,0);
    for (int i=0; i<width/weight; i++) {
      stroke(255/i+1,0,0);
      float move = i*weight;
      line(tx3,y2, tx4,y2);
      curve(tx4,y2+len, tx4,y2,tx2,y1, tx2+len,y1+len);
      line(tx2,y1, tx1,y1);
      curve(tx1-len, y1+len, tx1,y1, tx3,y2, tx3, y2+len);
    }
    */
    
    
  }


  public String toString() {
    return "(" + round(x1) +"," + round(y1) + ") to (" + round(x2) + "," + round(y2) + "), len: " + round(len) +", theta: "+round(theta*180/PI);
  }
}
