
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
  
}
