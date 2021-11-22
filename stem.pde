

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
  
  
  
}
