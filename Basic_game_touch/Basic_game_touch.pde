int x=0;
int y=0;
int mousePx=0;
int mousePy=0;
int mouseRx=0;
int mouseRy=0;
int count=0;
int gravCount=0;
int jumpCount=0;
Boolean doneJump=true;
Boolean doneGrav=true;
Boolean canJump=true;
int XYspeed;
int Jspeed;
int Gspeed;
int direc=0;
Platform p1=new Platform();
Platform p2=new Platform();
Platform p3=new Platform();
Platform obs1=new Platform();
Platform obs2=new Platform();
Platform obs3=new Platform();
Platform base=new Platform();

PFont font;
PFont font2;
long timer;
int temp=0;

int state=0;
void setup(){
  size(480,320);
  orientation(LANDSCAPE);
  frameRate(60);
  rectMode(CORNERS);
  smooth();
  fill(color(0,50,255));
  noStroke();
  font=createFont("Arial",20);
  font2=createFont("Arial",60);
  timer=3600;
  x=5;
  y=200;
  base.place(0,300,480,320);
  obs1.place(350,60,360,260);
  obs2.place(230,0,240,210);
  obs3.place(110,40,120,320);
  XYspeed=2;
  Jspeed=2;
  Gspeed=2;
}
void draw(){
  background(color(119,184,240));
  if(frameCount%120==0){
    obs3.Sy+=-3;
    obs2.Ey+=6;
    obs1.Sy+=-2;
    obs1.Ey+=2;
  }
  if(keyPressed){
    if(keyCode==37 || key==111){
      direc=1;
    }
    else if(keyCode==39 || key==112){
      direc=2;
    }
  }else{direc=0;}
  
  if(doneJump){gravity();}
  else{jump();}
  
  rectMode(CORNERS);
  fill(255);
  rect(440,0,480,40);
  fill(color(37,124,26));
  if(mousePressed){
    rect(mousePx,mousePy,mouseX,mouseY);
  }
  rect(base.Sx,base.Sy,base.Ex,base.Ey);
  
  if(p1.time==0){
    p1.place(0,0,0,0);
  }if(p2.time==0){
    p2.place(0,0,0,0);
  }if(p3.time==0){
    p3.place(0,0,0,0);
  }
  
  rect(p1.Sx,p1.Sy,p1.Ex,p1.Ey);
  rect(p2.Sx,p2.Sy,p2.Ex,p2.Ey);
  rect(p3.Sx,p3.Sy,p3.Ex,p3.Ey);
  
  rect(obs1.Sx,obs1.Sy,obs1.Ex,obs1.Ey);
  rect(obs2.Sx,obs2.Sy,obs2.Ex,obs2.Ey);
  rect(obs3.Sx,obs3.Sy,obs3.Ex,obs3.Ey);
  
  p1.time--;
  p2.time--;
  p3.time--;
  
  rectMode(CENTER);
  fill(color(0,0,255));
  rect(x,y,10,10);
  if(x>440 && y<40){
    rect(100,100,100,100);
    state=1;
  }
  if((x-5)<0){x=5;}
  if(x+5>480){x=475;}
  if(y-5<0){y=5;}
  if(y+5>300){y=295;}
  
  temp=(int)timer/60;
  if(timer<=0){
    fill(0);
    rect(0,0,1000,1000);
    textFont(font2);
    fill(color(255,0,0));
    text("You Lose",130,140);
  }else if(state==0){
    fill(0);
    text(str(temp),400,312);
    timer--;
  }else if(state==1){
    fill(0);
    rect(0,0,1000,1000);
    textFont(font2);
    fill(color(255,0,0));
    text("You Win",130,100);
    text(str(200-temp),200,220);
  }
}

