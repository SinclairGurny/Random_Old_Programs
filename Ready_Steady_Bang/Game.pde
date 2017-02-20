void play(byte d){
  start2=true;
  diff=d;
  mode=2;
}

void playing(){
  background(255);
  //ready,steady,bang
  if (!start) {
    textFont(mmf);
    start=!start;
    fc=0;
    bang=(int)random(360)+60;
    bangE=enemy(diff);
    rc=0;
  } else {
    if (fc >= 0) {
      if (fc <= 30) {
        fill(0);
        text("Ready.",240,348);
      } else {
        fill(0);
        text("Steady.",240,348);
      }
    }
    if (bang>0){
      bang--;
    } else {
      noStroke();
      fill(255,0,0);
      ellipse(240,338,110,110);
      fill(255);
      text("BANG!",240,348);
      rc++;
    }
    if (fc==59){fc=-1;}else if(fc>=0){fc++;}
  }
}

void reset(){
  start=false;
  start2=true;
  mode=2;
}

void restart(){
  reset();
  ldcount=loses=wins=round=0;
  for (int i=0; i<10; i++){
    times[i]=-1;
  }
}

void quit(){
  restart();
  mode=1;
}

int enemy(int d){
  switch(d){
    case 1:
      return (int)random(19,24);
    case 2:
      return (int)random(15,19);
    case 3:
      return (int)random(12,15);
     default:
       return -1;
  }
}
