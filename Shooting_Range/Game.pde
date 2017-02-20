//count which target we are on

//check what type that number is

//if type 0 - enemy (shoot immediately)
//   type 1 - civilian don't shoot
//   type 2 - hostage (wait for green bar)

//after 3 seconds change to next target

//when tcount==targets change to next mode
//fcount ticks per frame

int shot=0;
int fcount=0;
int tcount=0;
boolean wait=false;
int wcount=-1;
int wcount2=-1;

void game(){
  if (!started){
    if (fcount < 5){ background(back); }
    else {
      target(targets[tcount],true);
      if (targets[tcount]==2){ wait=true; }
      started=true;
    }
  } else {
    if (shot==1){ shoot(targets[tcount]); }
    if (wait){ waiting(); }
  }
  
  fcount++;
  if (fcount==205){
    fcount=0;
    tcount++;
    shot=0;
    started=false;
    wait=false;
    wcount=-1;
  }
  if (tcount==tnum){
    change(4);
  }
}

void target(int type, boolean ba){
  if (ba){ background(back); }
  color temp;
  if (type!=1){ temp=c[0]; }
  else { temp=c[1]; }
  fill(temp);
  //body
  rectMode(CORNERS);
  rect(170, 210, 310, 510, 10);
  quad(185, 210, 295, 210, 270, 195, 210, 195);
  fill(back);
  ellipse(240, 190, 56, 35);
  
  fill(temp);
  //arms
  rect(110, 215, 160, 520, 20, 6, 12, 12);
  rect(370, 215, 320, 520, 6, 20, 12, 12);
  
  //head
  rectMode(CENTER);
  ellipse(240, 115, 80, 80);
  ellipse(240, 155, 80, 80);
  rect(240, 135, 80, 40);
  
  if (type==2){
    pushMatrix();
    translate(105,30);
    target(1,false);
    popMatrix();
  }
}

void shoot(int type){
  fill(0);
  switch(type){
    case 0:
      //println("Bang!");
      ellipse(240+(int)random(-fcount*2,fcount*2), 200+(int)random(-100,200),5,5);
      rating[tcount]=fcount-5;
      break;
    case 1:
      //println("Damn!");
      ellipse(240+(int)random(-70,70),200+(int)random(-100,200),5,5);
      rating[tcount]=-10;
      break;
    case 2:
      if (wcount==0){
        //println("Good");
        ellipse(240+random(-40,40), 135+random(-40,40), 5,5);
        rating[tcount]=fcount-wcount2-5;
      } else {
        //println("Wait, dammit!");
        ellipse(350+random(-50,50), 180+random(-80,150), 5,5);
        rating[tcount]=-10;
      }
  }
  shot++;
}

void waiting(){
  if (wcount==-1){
    rectMode(CORNERS);
    wcount=(int)random(5,100);
    wcount2=wcount;
  } else {
    wcount--;
  }
  if (wcount==0){
    wait=false;
    fill(c[2]);
    rect(0,0,480,40);
  }
}

void reset(){
  shot=fcount=tcount=0;
  wait=false;
  wcount=wcount2=-1;
  for (int i=0; i<30; i++){
    targets[i]=-1;
    rating[i]=-1;
  }
  score=0;
  correct=0;
}
