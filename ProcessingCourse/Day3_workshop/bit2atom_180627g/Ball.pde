class Ball {
  //Global variables 
  PVector loc;
  PVector speed = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector gravity = new PVector(0, 0.01);
  PVector mouseAttraction = new PVector(0, 0);
  float r =25;
  int colorBall;

  //class Constructor
  Ball(PVector loc_, float _r, int _colorBall) {
    loc = loc_;
    r = _r;
    colorBall = _colorBall;
  }

  //Functions
  void run() {
    move();
    pong();
    mouseAttraction();
    display();
    collision();
  }

  void move() {
    acc.add(gravity);
    acc.add(mouseAttraction);
    speed.add(acc);
    //speed.mult(0.995);
    speed.limit(5);
    loc.add(speed);
    acc = new PVector(0, 0);
  }

  void mouseAttraction() {
    if (mousePressed && (mouseButton == RIGHT)) {
      PVector mouseLoc = new PVector(mouseX, mouseY);
      PVector mouseDist = PVector.sub(mouseLoc, loc);
      mouseDist.normalize();
      mouseDist.mult(20/r);
      mouseAttraction.add(mouseDist);
    }
    else{
      mouseAttraction = new PVector(0, 0);
    }
  }

  void pong() {
    for (int i = 0; i < myBall.size(); i ++) {
      Ball other = (Ball)myBall.get(i);
      PVector diff = PVector.sub(loc, other.loc);
      float distance = diff.mag();

      if (distance > 0 && distance < r + other.r) {
        diff.normalize();
        diff.mult(20/r);
        acc.add(diff);
      }
    }
  }

  void collision() {
    if (loc.x > width-r) {
      speed.x = speed.x * -1;
      loc.x = width-r;
    }
    if (loc.x < r) {
      speed.x = speed.x * -1;
      loc.x = r;
    }
    if (loc.y > height-r) {
      speed.y = speed.y * -1;
      loc.y = height-r;
    }
    if (loc.y < r) {
      speed.y = speed.y * -1;
      loc.y = r;
    }
  }

  void display() {
    fill(colorBall);
    ellipse(loc.x, loc.y, r*2, r*2);
    float ang = speed.heading();
    float arrowLength = 10*speed.mag(); //30;
    float arrowWing = 5;
    stroke(255);
    line(loc.x, loc.y, loc.x + arrowLength*cos(ang), loc.y + arrowLength*sin(ang));
    line(loc.x + arrowLength*cos(ang), loc.y + arrowLength*sin(ang), 
      loc.x + arrowLength*cos(ang) + arrowWing*cos(ang+PI/2+PI/4), 
      loc.y + arrowLength*sin(ang)+ arrowWing*sin(ang+PI/2+PI/4));
    line(loc.x + arrowLength*cos(ang), loc.y + arrowLength*sin(ang), 
      loc.x + arrowLength*cos(ang) + arrowWing*cos(ang-PI/2-PI/4), 
      loc.y + arrowLength*sin(ang) + arrowWing*sin(ang-PI/2-PI/4));
  }
}
