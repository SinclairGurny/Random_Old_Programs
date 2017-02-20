int score=0;
int correct=0;

void score(){
  if (!started){
    background(back);
    fill(0);
    started=true;
    for (int i=0; i<tcount; i++){
      score+=comp(targets[i],rating[i]);
    }
    text("Rating:",70,100);
    text(correct,295,150);
    text("/",320,150);
    text(tcount,345,150);
    
    text("Score:",70,200);
    text(score,300,250);
    
    fill(255,215,0);
    if (score > (tcount*40)-300){ star(100, 350, 20, 10, 5); }
    if (score > (tcount*40)-250){ star(169, 350, 20, 10, 5); }
    if (score > (tcount*40)-200){ star(238, 350, 20, 10, 5); }
    if (score > (tcount*40)-100){ star(307, 350, 20, 10, 5); }
    if (score > (tcount*40)){ star(376, 350, 20, 10, 5); }
  }
}

int comp(int t, int r){
  switch(t){
    case 0:
      if (r>0) { correct++; return 60-r; }
      else { return 0; }
    case 1:
      if (r==-1) { correct++; return 45; }
      else { return 0; } 
    case 2:
      if (r>0) { correct++; return 60-r; }
      else { return 0; }
    default:
      return 0;
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
