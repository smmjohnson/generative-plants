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
